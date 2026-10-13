"""scripts/fix_quest_stage_truthiness.py: DG-style truthiness tests on quest getters that return 0."""

import importlib.util
import shutil
import subprocess
import sys
import textwrap
from pathlib import Path

import pytest

ROOT = Path(__file__).resolve().parents[1]
_spec = importlib.util.spec_from_file_location("fix_quest_stage_truthiness", ROOT / "scripts" / "fix_quest_stage_truthiness.py")
Q = importlib.util.module_from_spec(_spec)
sys.modules["fix_quest_stage_truthiness"] = Q
_spec.loader.exec_module(Q)

LUA = shutil.which("lua5.4") or shutil.which("lua")

ZERO = {("megalith_quest", "item1"), ("theatre", "sash")}


def fix(src, zero=ZERO):
    rep = Q.Report()
    return Q.fix_text(textwrap.dedent(src).strip("\n"), zero, rep), rep


def test_not_getter_becomes_equals_zero():
    out, rep = fix('if not actor:get_quest_stage("q") then\n  x()\nend')
    assert out.startswith('if actor:get_quest_stage("q") == 0 then')
    assert rep.rewrites["direct get_quest_stage neg"] == 1


def test_bare_getter_becomes_greater_than_zero():
    out, _ = fix('if actor:get_quest_stage("q") then\nelseif person:get_quest_stage("r") and not actor:get_has_completed("r") then\nend')
    assert 'if actor:get_quest_stage("q") > 0 then' in out
    assert 'elseif person:get_quest_stage("r") > 0 and not actor:get_has_completed("r") then' in out


def test_mixed_condition_keeps_comparisons():
    src = 'elseif (not actor:get_quest_stage("q") and actor.level >= 5) or (actor:get_quest_stage("q") == 1 and not actor:get_quest_var("q:hunt")) then'
    out, _ = fix(src)
    assert out == (
        'elseif (actor:get_quest_stage("q") == 0 and actor.level >= 5) '
        'or (actor:get_quest_stage("q") == 1 and not actor:get_quest_var("q:hunt")) then'
    )


@pytest.mark.parametrize(
    "line",
    [
        'if actor:get_quest_stage("q") == 1 then',
        'if actor:get_quest_stage("q") >= 2 then',
        'if actor:get_quest_stage("q") < 1 then',
        'if (actor:get_quest_stage("q") or 0) > 0 then',
        'if actor.level >= (actor:get_quest_stage("q") - 1) * 10 then',
        'if visionstage > actor:get_quest_stage("q") then',
        'if tostring(actor:get_quest_stage("q")) then',
        'local stage = actor:get_quest_stage("q")',
        '-- if not actor:get_quest_stage("q") then',
        'x = ok and actor:get_quest_stage("q")',
    ],
)
def test_numeric_uses_and_non_conditions_are_left_alone(line):
    out, rep = fix(line)
    assert out == line
    assert not rep.rewrites


def test_local_holding_the_stage_is_fixed_null_safe():
    out, rep = fix(
        """
        local stage = actor:get_quest_stage("q")
        if not stage then
            a()
        elseif stage then
            b()
        elseif stage == 2 or stage >= 3 then
            c()
        end
        """
    )
    assert "if (stage or 0) == 0 then" in out
    assert "elseif (stage or 0) > 0 then" in out
    assert "elseif stage == 2 or stage >= 3 then" in out
    assert rep.rewrites["local stage neg"] == 1 and rep.rewrites["local stage pos"] == 1


def test_stage_one_or_not_stage_covers_not_started():
    out, _ = fix('local stage = actor:get_quest_stage("q")\nif stage == 1 or not stage then')
    assert out.endswith("if stage == 1 or (stage or 0) == 0 then")


def test_quest_var_only_when_the_var_is_stored_as_zero():
    out, rep = fix(
        """
        if not actor:get_quest_var("theatre:sash") then
        elseif actor:get_quest_var("theatre:other") then
        end
        if actor:get_quest_var("theatre:sash") then
        end
        """
    )
    assert 'if (actor:get_quest_var("theatre:sash") or 0) == 0 then' in out
    assert 'elseif actor:get_quest_var("theatre:other") then' in out
    assert 'if (actor:get_quest_var("theatre:sash") or 0) ~= 0 then' in out
    assert rep.rewrites["direct get_quest_var neg"] == 1


def test_zero_vars_are_collected_from_both_set_quest_var_shapes(tmp_path):
    f = tmp_path / "a.lua"
    f.write_text('actor:set_quest_var("q", "v", 0)\nactor:set_quest_var("w:x", "0")\nactor:set_quest_var("q", "keep", 1)\n')
    assert Q.collect_zero_vars([f]) == {("q", "v"), ("w", "x")}


def test_rewrite_is_idempotent():
    once, _ = fix('local s = actor:get_quest_stage("q")\nif not s or s then\nif not actor:get_quest_stage("q") then\nend\nend')
    twice, rep = fix(once)
    assert twice == once and not rep.rewrites


def test_run_writes_files_and_check_does_not(tmp_path):
    f = tmp_path / "t.lua"
    f.write_text('if not actor:get_quest_stage("q") then\nend\n')
    Q.run([tmp_path], check=True, zero_from=[tmp_path])
    assert "not actor" in f.read_text()
    rep = Q.run([tmp_path], check=False, zero_from=[tmp_path])
    assert rep.files_changed == 1 and f.read_text().startswith('if actor:get_quest_stage("q") == 0')


@pytest.mark.skipif(LUA is None, reason="no lua interpreter")
def test_fixed_conditions_behave_like_dg_in_lua():
    src, _ = fix(
        """
        local stage = actor:get_quest_stage("q")
        if not actor:get_quest_stage("q") then
            r = "fresh"
        elseif actor:get_quest_stage("q") then
            r = "started"
        end
        if not stage then s = "fresh" elseif stage then s = "started" end
        if not actor:get_quest_var("theatre:sash") then v = "unset" else v = "set" end
        """
    )
    for stage, sash, expect in [(0, 0, "fresh unset"), (2, 1, "started set"), (0, "x", "fresh set")]:
        prog = (
            f"local actor = {{get_quest_stage = function() return {stage} end,"
            f" get_quest_var = function() return {sash!r} end}}\n".replace("'", '"')
            + src
            + '\nprint(r .. " " .. v)\n'
            + 'assert(r == s)\n'
        )
        out = subprocess.run([LUA, "-e", prog], capture_output=True, text=True)
        assert out.returncode == 0, out.stderr
        assert out.stdout.strip() == expect
