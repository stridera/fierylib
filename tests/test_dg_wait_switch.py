"""DG wait units and switch/case translation in converters/dg_to_lua.py.

Legacy `process_wait` (dg_scripts.cpp): a bare number is PULSES (10 per second, so
`wait 2` is 0.2s), `N s` is seconds, `N t` is game hours (75s). `find_case` picks the first
`case` whose value `==` the switch value (numbers numerically, otherwise case-insensitive
strings, or `default`); execution then falls through every following label until `break`.
"""

import shutil
import subprocess
import textwrap

import pytest

from fierylib.converters.dg_to_lua import convert_command, convert_script_body

LUA = shutil.which("lua5.4") or shutil.which("lua")
needs_lua = pytest.mark.skipif(LUA is None, reason="lua not installed")


# ---- wait ---------------------------------------------------------------------------------------


@pytest.mark.parametrize(
    "dg, lua",
    [
        # bare number: pulses, tenths of a second
        ("wait 1", "wait(0.1)"),
        ("wait 2", "wait(0.2)"),
        ("wait 5", "wait(0.5)"),
        ("wait 10", "wait(1)"),
        ("wait 15", "wait(1.5)"),
        ("wait 20", "wait(2)"),
        ("wait 0", "wait(0)"),
        # seconds
        ("wait 1s", "wait(1)"),
        ("wait 3 s", "wait(3)"),
        ("wait 12s", "wait(12)"),
        ("wait 2 seconds", "wait(2)"),
        ("wait 5ss", "wait(5)"),
        ("WAIT 4S", "wait(4)"),
        # game hours
        ("wait 1 t", "wait_ticks(1)"),
        ("wait 2t", "wait_ticks(2)"),
        # until
        ("wait until 14:30", "wait_until(14, 30)"),
    ],
)
def test_wait_units(dg, lua):
    assert convert_command(dg, 0, set()).strip() == lua


def test_wait_variable_units():
    assert convert_command("wait %delay%s", 0, set()).strip() == "wait(delay)"
    assert convert_command("wait %delay% s", 0, set()).strip() == "wait(delay)"
    assert convert_command("wait %pulses%", 0, set()).strip() == "wait((pulses) / 10)"


def test_wait_keeps_indent_in_a_body():
    lua = convert_script_body("if %x% == 1\n  wait 2\n  wait 1 s\nendif")
    assert "    wait(0.2)" in lua and "    wait(1)" in lua


# ---- switch -------------------------------------------------------------------------------------


def run_body(dg: str, env: str = "", body_kwargs=None) -> list[str]:
    """Convert the DG body and run it; returns the say / wait / echo log in order."""
    assert LUA, "lua not installed"
    lua = convert_script_body(textwrap.dedent(dg).strip("\n"), **(body_kwargs or {}))
    chunk = (
        "local log = {}\n"
        "self = {name = 'mob', class = 'sorcerer', say = function(_, m) log[#log+1] = m end,\n"
        "        command = function(_, m) log[#log+1] = 'cmd:' .. m end,\n"
        "        room = {send = function(_, m) log[#log+1] = m end}}\n"
        "function wait(n) log[#log+1] = 'wait:' .. tostring(n) end\n"
        "function random() return 1 end\n"
        f"{env}\n"
        f"local function body()\n{lua}\nend\n"
        "body()\n"
        "print(table.concat(log, '|'))\n"
    )
    r = subprocess.run([LUA, "-"], input=chunk, capture_output=True, text=True)
    assert r.returncode == 0, f"{r.stderr}\n--- lua ---\n{lua}"
    out = r.stdout.strip()
    return out.split("|") if out else []


def lua_of(dg: str) -> str:
    return convert_script_body(textwrap.dedent(dg).strip("\n"))


@needs_lua
def test_grouped_labels_share_one_body():
    dg = """
        switch %speech%
          case major
          case major?
          case globe
            say hint one
            break
          case relocate
            say hint two
            break
        done
    """
    for word in ("major", "major?", "globe"):
        assert run_body(dg, f"speech = '{word}'") == ["hint one"]
    assert run_body(dg, "speech = 'relocate'") == ["hint two"]
    assert run_body(dg, "speech = 'nothing'") == []


@needs_lua
def test_issue_165_if_inside_a_case_stays_inside_it():
    dg = """
        switch %speech%
          case major
          case major?
            if %self.class% /= sorcerer
              say sorcerer major
            else
              say other major
            endif
            break
          case relocate
          case relocate?
            if %self.class% /= sorcerer
              say sorcerer relocate
            else
              say other relocate
            endif
            break
          default
            return 0
        done
    """
    assert run_body(dg, "speech = 'major?'") == ["sorcerer major"]
    assert run_body(dg, "speech = 'relocate'") == ["sorcerer relocate"]
    assert run_body(dg, "speech = 'major'", None) == ["sorcerer major"]
    # a non-sorcerer takes the else of the matched case only
    assert run_body(dg, "speech = 'relocate?'; self.class = 'cleric'") == ["other relocate"]
    assert run_body(dg, "speech = 'zzz'") == []
    lua = lua_of(dg)
    # one if / elseif chain over the labels, with the class test nested in each branch
    assert lua.count("elseif") == 1 and "else\n        _return_value = true" in lua


@needs_lua
def test_default_runs_only_when_no_case_matches():
    dg = """
        switch %speech%
          case a
            say A
            break
          case b
            say B
            break
          default
            say other
        done
        say after
    """
    assert run_body(dg, "speech = 'a'") == ["A", "after"]
    assert run_body(dg, "speech = 'b'") == ["B", "after"]
    assert run_body(dg, "speech = 'c'") == ["other", "after"]


@needs_lua
def test_default_only_switch_runs_unconditionally():
    dg = """
        switch %speech%
          default
            say always
        done
    """
    assert run_body(dg, "speech = 'x'") == ["always"]


@needs_lua
def test_fallthrough_without_break_runs_the_following_bodies():
    dg = """
        switch %rooms%
          case 3
            say three
          case 2
            say two
          case 1
            say one
            break
          case 0
            say zero
        done
    """
    assert run_body(dg, "rooms = 3") == ["three", "two", "one"]
    assert run_body(dg, "rooms = 2") == ["two", "one"]
    assert run_body(dg, "rooms = 1") == ["one"]
    assert run_body(dg, "rooms = 0") == ["zero"]
    assert run_body(dg, "rooms = 9") == []


@needs_lua
def test_fallthrough_into_default():
    # DG runs `default` after a break-less last case: it is just another label.
    dg = """
        switch %speech%
          case a
            say A
            break
          case b
            say B
          default
            say D
        done
    """
    assert run_body(dg, "speech = 'a'") == ["A"]
    assert run_body(dg, "speech = 'b'") == ["B", "D"]
    assert run_body(dg, "speech = 'q'") == ["D"]


@needs_lua
def test_case_values_compare_case_insensitively_and_numbers_numerically():
    dg = """
        switch %arg%
          case North
            say n
            break
          case 7
            say seven
            break
        done
    """
    assert run_body(dg, "arg = 'NORTH'") == ["n"]
    assert run_body(dg, "arg = 'north'") == ["n"]
    assert run_body(dg, "arg = '007'") == ["seven"]
    assert run_body(dg, "arg = 7") == ["seven"]
    assert run_body(dg, "arg = 'x'") == []
    assert run_body(dg, "arg = nil") == []


@needs_lua
def test_switch_value_is_evaluated_once():
    dg = """
        switch %random.3%
          case 1
            say one
            break
          case 2
            say two
            break
        done
    """
    # random() counts up (1, 2, 3, ...): re-evaluating it per label would skip "one"
    env = "local n = 0; function random() n = n + 1; return n end"
    assert run_body(dg, env) == ["one"]
    code = [l for l in lua_of(dg).splitlines() if not l.lstrip().startswith("--")]
    assert sum(l.count("random(") for l in code) == 1


@needs_lua
def test_nested_switches():
    dg = """
        switch %speech%
          case a
            switch %arg%
              case x
                say ax
                break
              case y
                say ay
                break
              default
                say a?
            done
            break
          case b
            say b
            break
        done
        say end
    """
    assert run_body(dg, "speech = 'a'; arg = 'x'") == ["ax", "end"]
    assert run_body(dg, "speech = 'a'; arg = 'y'") == ["ay", "end"]
    assert run_body(dg, "speech = 'a'; arg = 'z'") == ["a?", "end"]
    assert run_body(dg, "speech = 'b'; arg = 'x'") == ["b", "end"]
    assert run_body(dg, "speech = 'c'; arg = 'x'") == ["end"]


@needs_lua
def test_break_inside_an_if_leaves_the_switch():
    dg = """
        switch %speech%
          case a
            if %arg% == 1
              say early
              break
            endif
            say late
            break
          case b
            say B
        done
        say end
    """
    assert run_body(dg, "speech = 'a'; arg = 1") == ["early", "end"]
    assert run_body(dg, "speech = 'a'; arg = 2") == ["late", "end"]
    assert run_body(dg, "speech = 'b'; arg = 1") == ["B", "end"]


@needs_lua
def test_switch_inside_while_and_if():
    dg = """
        if %speech% == go
          switch %arg%
            case 1
              say one
              break
            case 2
              say two
              break
          done
        else
          say no
        endif
    """
    assert run_body(dg, "speech = 'go'; arg = 2") == ["two"]
    assert run_body(dg, "speech = 'stop'; arg = 2") == ["no"]


@needs_lua
def test_waits_inside_cases_use_the_new_units():
    dg = """
        switch %speech%
          case a
            wait 3
            say A
            wait 2 s
            break
        done
    """
    assert run_body(dg, "speech = 'a'") == ["wait:0.3", "A", "wait:2"]


def test_vnum_switch_labels_become_zone_and_id_tests():
    lua = lua_of(
        """
        switch %object.vnum%
          case 3001
          case 3002
            say hit
            break
        done
        """
    )
    assert "object.zone_id == 30 and object.id == 1" in lua
    assert "object.zone_id == 30 and object.id == 2" in lua
    assert "object.id == 3001" not in lua


def test_empty_and_label_only_switches_do_not_break_syntax():
    for dg in ("switch %x%\ndone", "switch %x%\n  case 1\ndone", "switch %x%\n  case 1\n  break\ndone"):
        lua = lua_of(dg)
        assert lua.count("do\n") + lua.count("do ") >= 1
        if LUA:
            r = subprocess.run([LUA, "-"], input=f"x = 1\n{lua}", capture_output=True, text=True)
            assert r.returncode == 0, (dg, r.stderr, lua)


def test_unclosed_switch_is_closed():
    lua = lua_of("switch %x%\n  case 1\n    say one\n")
    if LUA:
        r = subprocess.run([LUA, "-"], input=f"x = 1; self = {{say = function() end}}\n{lua}", capture_output=True, text=True)
        assert r.returncode == 0, (r.stderr, lua)
