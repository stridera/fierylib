"""Converter output for the quest-variable / nested-variable cases, the unbound-API
checker, and the trigger API-fix SQL patch."""

import importlib.util
import re
from pathlib import Path

from fierylib.converters.dg_to_lua import convert_text_with_vars

ROOT = Path(__file__).resolve().parent.parent


def _load_script(name: str):
    spec = importlib.util.spec_from_file_location(name, ROOT / "scripts" / f"{name}.py")
    mod = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(mod)
    return mod


checker = _load_script("check_trigger_api")


# --- converter -------------------------------------------------------------


def test_quest_variable_with_nested_key_uses_get_quest_var():
    out = convert_text_with_vars("%actor.quest_variable[black_legion:%id_trophy1%_trophies]%")
    assert out == (
        'tostring(actor:get_quest_var("black_legion:" .. tostring(id_trophy1) .. "_trophies"))'
    )


def test_quest_variable_closing_percent_after_literal_text():
    out = convert_text_with_vars(
        "- times claimed: (%actor.quest_variable[black_legion:%id_food%_reward]%)_"
    )
    assert out == (
        '"- times claimed: (" .. '
        'tostring(actor:get_quest_var("black_legion:" .. tostring(id_food) .. "_reward")) .. ")_"'
    )
    assert "%" not in out


def test_plain_quest_variable_is_unchanged():
    assert convert_text_with_vars("%actor.quest_variable[sacred_haven:given_earring]%") == (
        'tostring(actor:get_quest_var("sacred_haven:given_earring"))'
    )


def test_obj_noadesc_takes_a_composite_id():
    assert convert_text_with_vars("%get.obj_noadesc[2339]%") == "get_obj_noadesc(23, 39)"


def test_room_and_world_lookups_take_a_composite_id():
    assert convert_text_with_vars("%self.people[3010]%") == "tostring(self:get_people(30, 10))"
    assert convert_text_with_vars("%self.mexists[3055]%") == "tostring(self:get_mexists(30, 55))"


# --- checker ---------------------------------------------------------------


def test_strip_lua_blanks_comments_and_strings():
    src = 'local a = "fake_call(1)" -- also_fake(2)\n--[[ block_fake(3) ]]\nreal_call(4)\n'
    code = checker.strip_lua(src)
    assert "fake_call" not in code and "block_fake" not in code
    assert "real_call(4)" in code
    assert code.count("\n") == src.count("\n")


def test_checker_reports_only_unbound_calls(tmp_path):
    rust = tmp_path / "rust"
    rust.mkdir()
    (rust / "lib.rs").write_text(
        'globals.set("timestamp", f)?;\n'
        'world_tbl.set("destroy", f)?;\n'
        'methods.add_method("say", f);\n'
    )
    trig = tmp_path / "triggers"
    trig.mkdir()
    (trig / "a.lua").write_text(
        "local function mine() end\n"
        "mine()\n"
        "timestamp()\n"
        "missing_fn(1)\n"
        "world.destroy(self)\n"
        "world.nope(self)\n"
        "zone.echo(1, 'x')\n"
        "self:say('hi')\n"
        "self:shout('hi')\n"
        "string.format('%d', 1)\n"
        "-- commented_out(1)\n"
    )
    missing = checker.check(trig, rust)
    assert dict(missing["global"]) == {"missing_fn": 1}
    assert dict(missing["namespace"]) == {"world.nope": 1, "zone.echo": 1}
    assert dict(missing["method"]) == {"shout": 1}


# --- SQL patch -------------------------------------------------------------

PATCH = (ROOT / "data" / "sql" / "2026-10-10-trigger-api-fixes.sql").read_text(encoding="utf-8")


def test_patch_updates_by_composite_key_and_is_idempotent():
    assert 'UPDATE "Triggers" AS t' in PATCH
    assert "t.zone_id = v.zone_id" in PATCH and "t.id = v.id" in PATCH
    # A row already holding the new body is skipped, so a rerun changes nothing.
    assert "t.commands IS DISTINCT FROM v.commands" in PATCH
    assert PATCH.count("BEGIN;") == 1 and PATCH.count("COMMIT;") == 1


def test_patch_carries_the_group_heal_fix():
    assert re.search(r"\(185, 23, \$trig\$", PATCH)
    body = PATCH.split("(185, 23, $trig$", 1)[1].split("$trig$", 1)[0]
    assert 'actor:set_skill("group heal", 100)' in body
    assert "mskillset" not in body


def test_group_heal_script_no_longer_runs_the_staff_command():
    script = (ROOT / "data" / "triggers" / "185" / "185_23_group_heal_injured_give.lua").read_text()
    assert "mskillset" not in script.split("\n\n", 1)[1]
    assert 'actor:set_skill("group heal", 1000)' in script


def test_no_trigger_reads_legacy_vnum_fields():
    offenders = [
        str(p.relative_to(ROOT))
        for p in (ROOT / "data" / "triggers").rglob("*.lua")
        if re.search(r"\.vnum\b", p.read_text(encoding="utf-8"))
    ]
    assert offenders == []
