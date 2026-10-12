"""scripts/fix_trigger_patterns.py: branch-scoped locals (P1) and legacy vnum comparisons (P2)."""

import importlib.util
import shutil
import subprocess
import sys
import textwrap
from pathlib import Path

import pytest

ROOT = Path(__file__).resolve().parents[1]
_spec = importlib.util.spec_from_file_location("fix_trigger_patterns", ROOT / "scripts" / "fix_trigger_patterns.py")
F = importlib.util.module_from_spec(_spec)
sys.modules["fix_trigger_patterns"] = F
_spec.loader.exec_module(F)

# (base, top, zone), as build_zone_ranges returns them: zone 30 spans 3000-3499.
RANGES = [(55500, 55599, 555), (3000, 3499, 30), (1000, 1099, 10), (0, 99, 0)]
LUA = shutil.which("lua5.4") or shutil.which("lua")


def fix(src: str, **kw):
    return F.process(textwrap.dedent(src).lstrip("\n"), RANGES, "t.lua", **kw)


def run_lua(src: str) -> str:
    out = subprocess.run([LUA, "-"], input=src, capture_output=True, text=True, timeout=20)
    assert out.returncode == 0, out.stderr
    return out.stdout


needs_lua = pytest.mark.skipif(LUA is None, reason="no lua interpreter")


# ---- tokenizer / parser -------------------------------------------------------------------------


def test_tokenizer_skips_comments_and_long_strings():
    src = '--[==[ x.id == 3045 ]==]\nlocal s = [[ y.id == 3045 ]] -- z.id == 3045\nlocal t = "a.id == 3045"\n'
    r = fix(src)
    assert r.src == src and r.p2 == 0


def test_parser_handles_the_corpus_syntax():
    src = """
    local function f(a, ...) return a end
    local t = { x = 1, [2] = 3, f(1), function() return 1 end }
    for i, v in ipairs(t) do if v then break end end
    repeat local q = 1 until q
    obj:method "str"
    obj.field = { a = 1 }
    goto done
    ::done::
    """
    F.parse(textwrap.dedent(src))


# ---- P2 -----------------------------------------------------------------------------------------


def test_p2_equality_uses_the_zone_ranges():
    r = fix("if object.id == 3123 then x() end\n")
    # zone 30 spans 3000-3499: 3123 is 30:123, not 31:23
    assert r.src == "if (object.zone_id == 30 and object.id == 123) then x() end\n"
    assert r.p2 == 1


def test_p2_not_equal_and_reversed_operands():
    r = fix("if self.id ~= 3045 and 55577 == victim.id then x() end\n")
    assert r.src == (
        "if (self.zone_id ~= 30 or self.id ~= 45) and (victim.zone_id == 555 and victim.id == 77) then x() end\n"
    )


def test_p2_no_double_parentheses_and_nested_receivers():
    r = fix("if (actor.room.id == 1005) then x() end\n")
    assert r.src == "if (actor.room.zone_id == 10 and actor.room.id == 5) then x() end\n"


def test_p2_vnum_property_is_the_same_as_id():
    r = fix("if obj.vnum == 3045 then x() end\nlocal k = obj.vnum\n")
    assert "obj.zone_id == 30 and obj.id == 45" in r.src
    assert "local k = obj.id" in r.src and r.p2_vnum_reads == 1


def test_p2_value_variable_comparisons():
    r = fix(
        """
        local me = self.id
        if me == 3012 then a() elseif 3013 ~= me then b() end
        """
    )
    assert "(self.zone_id == 30 and me == 12)" in r.src
    assert "(self.zone_id ~= 30 or me ~= 13)" in r.src


def test_p2_value_variable_reassigned_is_left_alone():
    src = "local me = self.id\nme = 5\nif me == 3012 then a() end\n"
    assert fix(src).src == src


def test_p2_leaves_ranges_arithmetic_and_small_ids_and_lists_them():
    src = textwrap.dedent(
        """
        if object.id > 3000 then a() end
        if self.id == 45 then b() end
        local n = object.id - 3000
        """
    )
    r = F.process(src, RANGES, "t.lua")
    assert r.src == src
    kinds = {m.kind for m in r.manual}
    assert "range" in kinds


def test_p2_vnum_without_zone_range_is_manual():
    src = "if self.id == 99999 then a() end\n"
    r = fix(src)
    assert r.src == src
    assert [m.kind for m in r.manual] == ["no-zone-range"]


def test_p2_calls_in_the_receiver_and_operator_precedence_are_not_touched():
    for src in (
        "if f(x).id == 3045 then a() end\n",
        "if 1 + object.id == 3045 then a() end\n",
        "if object.id == 3045 + 1 then a() end\n",
    ):
        assert fix(src).src == src


def test_p2_listing_of_vnum_tables_and_variable_comparisons():
    r = fix(
        """
        local T = { { id = 16105, place = "x" } }
        local want = 3045
        if object.id == want then a() end
        """
    )
    kinds = sorted(m.kind for m in r.manual)
    assert kinds == ["var-compare", "vnum-table"]


@needs_lua
def test_p2_rewritten_condition_matches_the_right_entity():
    cond = fix("return (object.id == 3123)\n").src
    prog = f"""
    local function check(object) {cond.replace('return', 'return', 1)} end
    print(check({{zone_id = 30, id = 123}}), check({{zone_id = 31, id = 23}}), check({{zone_id = 30, id = 3123}}))
    """
    assert run_lua(prog).split() == ["true", "false", "false"]


# ---- P2 ranges ----------------------------------------------------------------------------------


def test_range_covering_a_whole_zone_is_a_zone_check():
    r = fix("if (x.id >= 55500) and (x.id <= 55599) then a() end\n")
    assert r.src == "if (x.zone_id == 555) then a() end\n"
    assert r.p2_ranges == 1


def test_range_inside_a_zone_adds_local_id_bounds():
    assert fix("if x.id >= 55510 and x.id <=55580 then a() end\n").src == (
        "if (x.zone_id == 555 and x.id >= 10 and x.id <= 80) then a() end\n"
    )
    # only the side that trims the zone gets a bound; zone 10 starts at 1000
    assert fix("if x.id >= 1000 and x.id <= 1038 then a() end\n").src == (
        "if (x.zone_id == 10 and x.id <= 38) then a() end\n"
    )


def test_range_exclusive_bounds_are_adjusted():
    assert fix("if x.id > 55500 and x.id < 55599 then a() end\n").src == (
        "if (x.zone_id == 555 and x.id >= 1 and x.id <= 98) then a() end\n"
    )


def test_outside_form_negates_the_zone_check():
    assert fix("if candidate and ((candidate.id < 55500) or (candidate.id > 55599)) and ok then a() end\n").src == (
        "if candidate and (candidate.zone_id ~= 555) and ok then a() end\n"
    )
    assert fix("if (p.id < 55510) or (p.id > 55580) then a() end\n").src == (
        "if (p.zone_id ~= 555 or p.id < 10 or p.id > 80) then a() end\n"
    )


def test_range_spanning_zones_is_an_or_of_zone_clauses():
    # 1050-3100 takes the tail of zone 10 and the head of zone 30 (nothing between them exists)
    assert fix("if x.id >= 1050 and x.id <= 3100 then a() end\n").src == (
        "if ((x.zone_id == 10 and x.id >= 50) or (x.zone_id == 30 and x.id <= 100)) then a() end\n"
    )


def test_range_on_an_id_variable_and_a_nested_receiver():
    r = fix("local zone = room.id\nif a == 1 or zone >= 55510 and zone <= 55580 then b() end\n")
    assert "or (room.zone_id == 555 and zone >= 10 and zone <= 80) then" in r.src
    assert fix("if actor.room.id >= 55500 and actor.room.id <= 55599 then a() end\n").src == (
        "if (actor.room.zone_id == 555) then a() end\n"
    )


def test_open_ended_and_unbound_ranges_are_left_and_listed():
    src = "if object.id > 1100 then a() end\nif x.id >= 55500 and y.id <= 55599 then b() end\n"
    r = fix(src)
    assert r.src == src and r.p2_ranges == 0
    assert sorted(m.line for m in r.manual if m.kind == "range") == [1, 2]


def test_range_not_a_unit_is_left_alone():
    # `not` or an `and` neighbour changes what the pair means
    for src in (
        "if ok and x.id < 55500 or x.id > 55599 then a() end\n",
        "if x.id < 55500 or x.id > 55599 and ok then a() end\n",
        "if not x.id >= 55500 and x.id <= 55599 then a() end\n",
    ):
        assert fix(src).p2_ranges == 0, src


def test_range_with_no_zone_is_manual():
    r = fix("if x.id >= 99000 and x.id <= 99100 then a() end\n")
    assert r.p2_ranges == 0 and "no-zone-range" in {m.kind for m in r.manual}


@needs_lua
def test_range_rewrite_gives_the_same_answer_as_the_vnum_comparison():
    exprs = [
        "x.id >= 55510 and x.id <= 55580",
        "(x.id < 55510) or (x.id > 55580)",
        "x.id > 1000 and x.id < 1099",
        "x.id >= 1050 and x.id <= 3100",
        "x.id < 1050 or x.id >= 3100",
    ]
    for e in exprs:
        new = fix(f"return {e}\n").src
        assert "zone_id" in new, e
        prog = f"""
        local ranges = {{ {{55500, 55599, 555}}, {{3000, 3499, 30}}, {{1000, 1099, 10}}, {{0, 99, 0}} }}
        local bad = 0
        for vnum = 0, 56000 do
          local zone, id
          for _, r in ipairs(ranges) do
            if vnum >= r[1] and vnum <= r[2] then zone, id = r[3], vnum - r[1] break end
          end
          if zone then
            local function old(x) return {e} end
            local function new(x) return {new.replace('return ', '', 1)} end
            if old({{id = vnum}}) ~= new({{zone_id = zone, id = id}}) then bad = bad + 1 end
          end
        end
        print(bad)
        """
        assert run_lua(prog).split() == ["0"], e


# ---- P1 -----------------------------------------------------------------------------------------


def test_p1_hoists_declaration_before_the_chain():
    r = fix(
        """
        if a == 1 then
            local x = "one"
        elseif a == 2 then
            local x = "two"
        end
        print(x)
        """
    )
    assert r.src == textwrap.dedent(
        """
        local x
        if a == 1 then
            x = "one"
        elseif a == 2 then
            x = "two"
        end
        print(x)
        """
    ).lstrip("\n")
    assert r.p1.statements == 2 and r.p1.hoisted_names == 1


def test_p1_nested_chains_hoist_to_the_outermost_one_the_use_follows():
    r = fix(
        """
        if a then
            if b then
                local found = 1
            end
        end
        if found == 1 then ok() end
        """
    )
    lines = r.src.splitlines()
    assert lines[0] == "local found"
    assert "found = 1" in r.src and "local found = 1" not in r.src


def test_p1_use_only_inside_the_branch_is_left_alone():
    src = "if a then\n    local x = 1\n    print(x)\nend\n"
    assert fix(src).src == src


def test_p1_use_before_the_chain_or_in_a_loop_scope_is_left_alone():
    src = "print(x)\nfor i = 1, 2 do\n    local x = i\nend\n"
    assert fix(src).src == src


def test_p1_bare_declaration_is_dropped_and_names_are_grouped():
    r = fix(
        """
        if a then
            local task
            local item = 1
            task = "x"
        end
        print(task, item)
        """
    )
    assert r.src.splitlines()[0] == "local task, item"
    assert "local task\n" not in r.src.split("\n", 1)[1]


def test_p1_shadowed_outer_local_becomes_an_assignment():
    r = fix(
        """
        local gems = 0
        if a then
            local gems = 5
        end
        print(gems)
        """
    )
    assert "    gems = 5" in r.src and r.src.count("local gems") == 1
    assert r.p1.shadow_assigns == 1 and r.p1.hoisted_names == 0


def test_p1_two_sibling_chains_get_their_own_declaration():
    r = fix(
        """
        if a then local x = 1 end
        print(x)
        if b then local x = 2 end
        print(x)
        """
    )
    assert r.src.count("local x") == 2
    assert r.p1.hoisted_names == 2


def test_p1_is_idempotent():
    src = "if a then local x = 1 else local x = 2 end\nprint(x)\n"
    once = fix(src).src
    assert fix(once).src == once


@needs_lua
def test_p1_behaviour_before_and_after():
    body = """
    local out = {}
    local function pick(a)
        if a == 1 then
            local x = "one"
        elseif a == 2 then
            local x = "two"
        end
        return x
    end
    print(pick(1), pick(2), pick(3))
    """
    before = run_lua(textwrap.dedent(body)).split()
    assert before == ["nil", "nil", "nil"]
    after = run_lua(fix(body).src).split()
    assert after == ["one", "two", "nil"]


def test_local_id_rewrite_is_opt_in():
    src = "if object.local_id == 5 and self.room.local_id == 6 then a() end\n"
    assert fix(src).src == src
    assert fix(src, local_id_to_id=True).src == "if object.id == 5 and self.room.id == 6 then a() end\n"
    keyed = "local t = { local_id = 5 }\nprint(t.local_id)\n"
    assert fix(keyed, local_id_to_id=True).src == keyed


# ---- the corpus ---------------------------------------------------------------------------------


def _zon_dir():
    return next((p / "lib" / "world" / "zon" for p in ROOT.parents if (p / "lib" / "world" / "zon").is_dir()), None)


def test_corpus_is_fully_rewritten_and_every_script_parses():
    zon = _zon_dir()
    if zon is None:
        pytest.skip("lib/world/zon not found")
    from fierylib.converters.dg_to_lua import build_zone_ranges

    ranges = build_zone_ranges(zon)
    dirty = []
    for f in sorted((ROOT / "data" / "triggers").rglob("*.lua")):
        src = f.read_text(encoding="utf-8")
        r = F.process(src, ranges, str(f))
        assert not [m for m in r.manual if m.kind == "parse-error"], f
        if r.src != src:
            dirty.append(f.name)
    assert not dirty, f"rerun scripts/fix_trigger_patterns.py: {dirty[:5]}"
