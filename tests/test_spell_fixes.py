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
