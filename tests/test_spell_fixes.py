"""Spell fixes from player reports (fierymud-rs #111, #106, #109); see data/sql/2026-10-10-spell-fixes.sql."""

import json
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
DATA = ROOT / "data"
SQL = (DATA / "sql" / "2026-10-10-spell-fixes.sql").read_text(encoding="utf-8")
ABILITIES = json.loads((DATA / "abilities.json").read_text(encoding="utf-8"))
BY_NAME = {a["plainName"]: a for a in ABILITIES}
IMPORTER = (ROOT / "src" / "fierylib" / "importers" / "magic_system_importer.py").read_text(encoding="utf-8")


def _statements(table):
    return [s for s in SQL.split(";") if f'UPDATE "{table}"' in s]


# --- #111: Major Globe is an out-of-combat spell ---------------------------------------------------------------


def test_globes_are_not_castable_in_combat():
    for name in ("MAJOR_GLOBE", "MINOR_GLOBE"):
        assert BY_NAME[name]["combatOk"] is False, name


def test_importer_writes_combat_ok_from_the_json():
    assert 'ability.get("combatOk", True)' in IMPORTER


def test_sql_flips_combat_ok_for_the_globes_by_plain_name_only():
    (stmt,) = [s for s in _statements("Ability") if "combat_ok = false" in s]
    assert "plain_name IN ('MAJOR_GLOBE', 'MINOR_GLOBE')" in stmt
    assert "AND combat_ok" in stmt  # idempotent: only rows still in the old shape
    assert not re.search(r"\bid\s*=", stmt)


# --- #106: hostile non-damaging spells start combat ------------------------------------------------------------


def test_dispel_magic_and_ray_of_enfeeblement_are_violent():
    for name in ("DISPEL_MAGIC", "RAY_OF_ENFEEB"):
        assert BY_NAME[name]["violent"] is True, name


def test_sql_makes_dispel_magic_violent_by_plain_name_only():
    (stmt,) = [s for s in _statements("Ability") if "violent = true" in s]
    assert "plain_name = 'DISPEL_MAGIC'" in stmt
    assert "AND NOT violent" in stmt
    assert not re.search(r"\bid\s*=", stmt)


# --- #109: Fly cast on another names the target -----------------------------------------------------------------

FLY_OTHER = "{target.name} rises into the air and begins to fly."
FLY_FIRST_PERSON = "You rise into the air and begin to fly."


def test_fly_on_another_names_the_target_to_caster_and_room():
    m = BY_NAME["FLY"]["messages"]
    assert m["successToCaster"] == FLY_OTHER
    assert m["successToRoom"] == FLY_OTHER
    assert m["successToVictim"] == FLY_FIRST_PERSON


def test_fly_self_cast_lines_stay_first_person():
    m = BY_NAME["FLY"]["messages"]
    assert m["successToSelf"] == FLY_FIRST_PERSON
    assert m["successSelfRoom"] == "{actor.name} rises into the air and begins to fly."


def test_no_other_spell_shares_one_line_between_caster_and_victim():
    for name, ability in BY_NAME.items():
        m = ability.get("messages") or {}
        if m.get("successToCaster") and m.get("successToCaster") == m.get("successToVictim"):
            raise AssertionError(f"{name}: caster and victim read the same line")


def test_sql_rewrites_only_the_old_fly_lines_by_plain_name():
    (stmt,) = _statements("AbilityMessages")
    assert "a.plain_name = 'FLY'" in stmt
    assert FLY_OTHER in stmt
    assert f"am.success_to_caster = '{FLY_FIRST_PERSON}'" in stmt
    assert "am.success_to_room = '{actor.name} rises into the air and begins to fly.'" in stmt
    assert not re.search(r"\bid\s*=", stmt.replace("am.ability_id = a.id", ""))
