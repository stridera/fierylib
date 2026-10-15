"""scripts/fix_quest_var_nil_compare.py: nil-safe comparisons on get_quest_var (unset var = nil)."""

import importlib.util
import shutil
import subprocess
import sys
import textwrap
from pathlib import Path

import pytest

ROOT = Path(__file__).resolve().parents[1]
_spec = importlib.util.spec_from_file_location("fix_quest_var_nil_compare", ROOT / "scripts" / "fix_quest_var_nil_compare.py")
Q = importlib.util.module_from_spec(_spec)
sys.modules["fix_quest_var_nil_compare"] = Q
_spec.loader.exec_module(Q)

LUA = shutil.which("lua5.4") or shutil.which("lua")


def fix(src):
    return Q.fix_source(textwrap.dedent(src).strip("\n"))


def test_direct_numeric_comparisons_get_a_zero_default():
    out, counts = fix(
        """
        if actor:get_quest_var("q:v") == 0 then a() end
        if actor:get_quest_var("q:v") ~= 0 then b() end
        if actor:get_quest_var("q:v") < 3 then c() end
        if actor:get_quest_var("q:v") > 2 then d() end
        if actor:get_quest_var("q:v") <= -1 then e() end
        if actor:get_quest_var("q:v") >= 2.5 then f() end
        """
    )
    assert 'if (actor:get_quest_var("q:v") or 0) == 0 then' in out
    assert 'if (actor:get_quest_var("q:v") or 0) ~= 0 then' in out
    assert 'if (actor:get_quest_var("q:v") or 0) < 3 then' in out
    assert 'if (actor:get_quest_var("q:v") or 0) > 2 then' in out
    assert 'if (actor:get_quest_var("q:v") or 0) <= -1 then' in out
    assert 'if (actor:get_quest_var("q:v") or 0) >= 2.5 then' in out
    assert counts["call-num"] == 6


def test_other_receivers_and_chains():
    out, _ = fix('if person:get_quest_var("q:v") == 0 and self.room:get_quest_var("q:w") == 1 then end')
    assert '(person:get_quest_var("q:v") or 0) == 0' in out
    assert '(self.room:get_quest_var("q:w") or 0) == 1' in out


def test_empty_string_comparisons_treat_nil_as_empty():
    out, counts = fix(
        """
        if actor:get_quest_var("q:s") == "" then a() end
        if actor:get_quest_var("q:s") ~= '' then b() end
        """
    )
    assert 'if (actor:get_quest_var("q:s") or "") == "" then' in out
    assert "if (actor:get_quest_var(\"q:s\") or \"\") ~= '' then" in out
    assert counts["call-empty"] == 2


def test_other_string_comparisons_are_left_alone():
    src = """
        if actor:get_quest_var("q:s") == "done" then a() end
        if actor:get_quest_var("q:s") ~= "running" then b() end
        if actor:get_quest_var("q:s") < "m" then d() end
        if actor:get_quest_var("q:s") == "1.5" then c() end
    """
    out, counts = fix(src)
    assert out == textwrap.dedent(src).strip("\n")


def test_equality_against_non_literal_is_left_alone_and_counted():
    src = 'if actor:get_quest_var("q:v") == actor.level and actor:get_quest_var("q:w") ~= other then end'
    out, counts = fix(src)
    assert out == src
    assert counts["skipped:call:non-literal rhs"] == 2


def test_relational_against_non_literal_gets_a_zero_default():
    out, counts = fix(
        """
        if value >= actor:get_quest_var("q:price") then a() end
        if actor:get_quest_var("q:v") >= need then b() end
        """
    )
    assert 'if value >= (actor:get_quest_var("q:price") or 0) then' in out
    assert 'if (actor:get_quest_var("q:v") or 0) >= need then' in out
    assert counts["call-rel"] == 2


def test_arithmetic_on_the_getter_gets_a_zero_default():
    out, counts = fix(
        """
        local a = actor:get_quest_var("q:v") + 1
        local b = 6 - actor:get_quest_var("q:v")
        local c = ((attack) - actor:get_quest_var("q:v"))
        local d = actor:get_quest_var("q:v") * 2 - x:get_quest_var("q:w") / 3 % 4
        local e = math.floor(person:get_quest_var("q:v") / 100)
        """
    )
    assert 'local a = (actor:get_quest_var("q:v") or 0) + 1' in out
    assert 'local b = 6 - (actor:get_quest_var("q:v") or 0)' in out
    assert 'local c = ((attack) - (actor:get_quest_var("q:v") or 0))' in out
    assert 'local d = (actor:get_quest_var("q:v") or 0) * 2 - (x:get_quest_var("q:w") or 0) / 3 % 4' in out
    assert 'math.floor((person:get_quest_var("q:v") or 0) / 100)' in out
    assert counts["call-arith"] == 6


def test_locals_from_a_getter_used_in_arithmetic():
    out, counts = fix(
        """
        local boots = actor:get_quest_var("q:boots")
        local cloak = actor:get_quest_var("q:cloak")
        local total = boots + cloak
        local left = 5 - boots
        if total >= need then a() end
        if boots and boots + 1 > 2 then b() end
        """
    )
    assert "local total = (boots or 0) + (cloak or 0)" in out
    assert "local left = 5 - (boots or 0)" in out
    # `total` was not assigned from a getter, so it is left alone; `boots and ...` is guarded.
    assert "if total >= need then" in out
    assert "if boots and boots + 1 > 2 then" in out
    assert counts["local-arith"] == 3


def test_reassigned_or_defaulted_locals_and_concat_are_left_alone():
    src = textwrap.dedent(
        """
        local n = actor:get_quest_var("q:v")
        n = n or 0
        local m = n + 1
        local k = actor:get_quest_var("q:v") or 0
        local j = k + 1
        local s = "got " .. actor:get_quest_var("q:v") .. " of 6"
        local t = tostring(actor:get_quest_var("q:v")) .. "x"
        local u = tonumber(actor:get_quest_var("q:v")) or 0
        local w = actor:get_quest_var("q:v").field
        """
    ).strip("\n")
    out, _ = Q.fix_source(src)
    assert out == src


def test_numeric_string_comparison_becomes_numeric():
    out, counts = fix(
        """
        if actor:get_quest_var("q:s") == "1" then a() end
        if actor:get_quest_var("q:s") ~= '0' then b() end
        local v = actor:get_quest_var("q:s")
        if v == "12" then c() end
        """
    )
    assert 'if (actor:get_quest_var("q:s") or 0) == 1 then' in out
    assert "if (actor:get_quest_var(\"q:s\") or 0) ~= 0 then" in out
    assert "if (v or 0) == 12 then" in out
    assert counts["call-numstr"] == 2 and counts["local-numstr"] == 1


def test_arithmetic_pass_is_idempotent():
    src = textwrap.dedent(
        """
        local a = actor:get_quest_var("q:v") + 1
        local b = 6 - actor:get_quest_var("q:v")
        if value >= actor:get_quest_var("q:price") then end
        local v = actor:get_quest_var("q:s")
        if v == "1" then end
        local w = v + 1
        """
    ).strip("\n")
    once, _ = Q.fix_source(src)
    twice, counts = Q.fix_source(once)
    assert once != src and twice == once
    assert not [k for k in counts if not k.startswith("skipped:")]


def test_idempotent_and_already_guarded_forms_untouched():
    src = textwrap.dedent(
        """
        if (actor:get_quest_var("q:v") or 0) == 0 then a() end
        if actor:get_quest_var("q:v") or 0 then b() end
        if actor:get_quest_var("q:v") then c() end
        local n = actor:get_quest_var("q:v") or 0
        if n == 0 then d() end
        """
    ).strip("\n")
    assert fix(src)[0] == src
    first, _ = fix('if actor:get_quest_var("q:v") == 0 then end')
    assert Q.fix_source(first)[0] == first


def test_nested_calls_and_arguments_with_parentheses():
    out, counts = fix(
        """
        if foo(actor:get_quest_var("q:v") == 0, bar(1)) then end
        if actor:get_quest_var(string.format("%s:x", name)) > 1 then end
        if actor:get_quest_var("q:" .. tostring(i)) == 0 then end
        """
    )
    assert 'foo((actor:get_quest_var("q:v") or 0) == 0, bar(1))' in out
    assert '(actor:get_quest_var(string.format("%s:x", name)) or 0) > 1' in out
    assert '(actor:get_quest_var("q:" .. tostring(i)) or 0) == 0' in out
    assert counts["call-num"] == 3


def test_operand_inside_larger_expression_is_not_the_left_side():
    src = textwrap.dedent(
        """
        if not actor:get_quest_var("q:v") == 0 then end
        if x .. actor:get_quest_var("q:v") == "a0" then end
        if actor:get_quest_var("q:v") == 0 .. "x" then end
        """
    ).strip("\n")
    assert fix(src)[0] == src


def test_strings_and_comments_are_never_touched():
    src = textwrap.dedent(
        '''
        -- if actor:get_quest_var("q:v") == 0 then
        --[[ actor:get_quest_var("q:v") == 0 ]]
        local s = 'actor:get_quest_var("q:v") == 0'
        local t = [[ actor:get_quest_var("q:v") == 0 ]]
        '''
    ).strip("\n")
    assert fix(src)[0] == src


def test_local_assigned_from_getter():
    out, counts = fix(
        """
        local job1 = actor:get_quest_var("p:job1")
        local job2 = actor:get_quest_var("p:job2")
        if job1 == 0 and job2 >= 2 then a() end
        if job1 then b() end
        local name = actor:get_quest_var("p:name")
        if name == "" then c() end
        if name == "bob" then d() end
        """
    )
    assert "if (job1 or 0) == 0 and (job2 or 0) >= 2 then" in out
    assert "if job1 then b() end" in out
    assert 'if (name or "") == "" then' in out
    assert 'if name == "bob" then' in out
    assert counts["local-num"] == 2 and counts["local-empty"] == 1


def test_local_in_function_scope_and_shadowing():
    src = """
        local function f(actor)
            local v = actor:get_quest_var("q:v")
            return v == 1
        end
        local v = 5
        if v == 1 then g() end
    """
    out, _ = fix(src)
    assert "return (v or 0) == 1" in out
    assert "if v == 1 then g() end" in out  # a different local named v


def test_block_scoped_locals_are_resolved_per_block():
    out, _ = fix(
        """
        if a then
            local x = actor:get_quest_var("q:x")
            if x == 0 then p() end
        else
            local x = 7
            if x == 0 then q() end
        end
        """
    )
    assert "if (x or 0) == 0 then p() end" in out
    assert "if x == 0 then q() end" in out


def test_reassigned_local_is_left_alone():
    src = """
        local v = actor:get_quest_var("q:v")
        if cond then v = 3 end
        if v == 0 then a() end
    """
    assert fix(src)[0] == textwrap.dedent(src).strip("\n")


def test_local_not_assigned_directly_from_the_getter_is_left_alone():
    src = """
        local a = actor:get_quest_var("q:v") or 5
        local b = tonumber(actor:get_quest_var("q:v"))
        local c = actor:get_quest_var("q:v") .. "x"
        local d, e = actor:get_quest_var("q:v")
        if a == 0 or b == 0 or c == 0 or d == 0 then x() end
    """
    assert fix(src)[0] == textwrap.dedent(src).strip("\n")


def test_loop_variable_and_parameter_shadow_the_local():
    src = """
        local v = actor:get_quest_var("q:v")
        for v = 1, 3 do
            if v == 2 then a() end
        end
        local function f(v) return v == 0 end
    """
    out, _ = fix(src)
    assert "if v == 2 then a() end" in out
    assert "return v == 0 end" in out


def test_local_already_truthiness_guarded_is_not_rewritten():
    src = """
        local v = actor:get_quest_var("q:v")
        return v and v ~= 0 and v ~= ""
    """
    assert fix(src)[0] == textwrap.dedent(src).strip("\n")


@pytest.mark.skipif(LUA is None, reason="no lua interpreter")
def test_fixed_conditions_behave_with_nil_in_lua():
    src, _ = fix(
        """
        local job = actor:get_quest_var("q:job")
        r = {}
        r[1] = actor:get_quest_var("q:v") == 0
        r[2] = actor:get_quest_var("q:v") ~= 0
        r[3] = actor:get_quest_var("q:v") < 3
        r[4] = actor:get_quest_var("q:s") == ""
        r[5] = job == 0
        r[6] = job >= 1
        r[7] = 6 - actor:get_quest_var("q:v")
        r[8] = actor:get_quest_var("q:v") + 1
        r[9] = 3 >= actor:get_quest_var("q:v")
        r[10] = job + 2
        """
    )
    prog = 'local actor = {get_quest_var = function() return nil end}\n' + src + (
        '\nprint(table.concat({tostring(r[1]), tostring(r[2]), tostring(r[3]), tostring(r[4]),'
        ' tostring(r[5]), tostring(r[6]), tostring(r[7]), tostring(r[8]), tostring(r[9]),'
        ' tostring(r[10])}, " "))'
    )
    out = subprocess.run([LUA, "-e", prog], capture_output=True, text=True)
    assert out.returncode == 0, out.stderr
    assert out.stdout.strip() == "true false true true true false 6 1 true 2"


def test_file_runner_check_and_write(tmp_path):
    f = tmp_path / "t.lua"
    f.write_text('if actor:get_quest_var("q:v") == 0 then end\n', encoding="utf-8")
    assert Q.process([tmp_path], write=False).files_changed == 1
    assert "or 0" not in f.read_text(encoding="utf-8")
    rep = Q.process([tmp_path], write=True)
    assert rep.files_changed == 1 and rep.rewrites["call-num"] == 1
    assert f.read_text(encoding="utf-8") == 'if (actor:get_quest_var("q:v") or 0) == 0 then end\n'
    assert Q.process([tmp_path], write=True).files_changed == 0


def test_corpus_is_already_fixed():
    rep = Q.process([ROOT / "data" / "triggers"], write=False)
    assert rep.files_changed == 0, rep.changed_paths[:5]


def test_arithmetic_inside_a_comparison_is_fixed_on_the_operand():
    out, _ = fix('if 1 + actor:get_quest_var("q:v") == 3 then end')
    assert out == 'if 1 + (actor:get_quest_var("q:v") or 0) == 3 then end'
