"""Misdirection and Ventriloquate (fierymud-rs): abilities.json and
data/sql/2026-10-12-misdirection-ventriloquate.sql stay in sync, and the SQL is guarded
and idempotent."""

import json
import re
from pathlib import Path

from fierylib.seeders.ability_effects_linker import EFF_FLAG_MAPPINGS

DATA = Path(__file__).resolve().parents[1] / "data"
SQL = (DATA / "sql" / "2026-10-12-misdirection-ventriloquate.sql").read_text(encoding="utf-8")
BY_NAME = {
    a["plainName"]: a for a in json.loads((DATA / "abilities.json").read_text(encoding="utf-8"))
}
OLD_ROW = '{"flag": "hidden", "amount": 20, "duration": "skill", "durationUnit": "hours"}'


def test_misdirection_applies_the_misdirection_flag_for_two_plus_skill_over_four_hours():
    (row,) = BY_NAME["MISDIRECTION"]["effects"]
    assert row["effect"] == "status" and row["trigger"] == "on_cast" and row["order"] == 0
    assert row["params"] == {
        "flag": "misdirection",
        "duration": "2 + (skill / 4)",
        "durationUnit": "hours",
    }
    new = json.dumps(row["params"])
    assert f"SET override_params = '{new}'::jsonb" in SQL


def test_ventriloquate_is_a_manual_speak_as_spell_that_applies_nothing_else():
    (row,) = BY_NAME["VENTRILOQUATE"]["effects"]
    assert row["effect"] == "alter_object" and row["trigger"] == "on_cast" and row["order"] == 0
    assert row["params"] == {"mode": "speak_as"}
    assert "'{\"mode\": \"speak_as\"}'::jsonb, 0, 'on_cast'" in SQL


def test_no_ability_keeps_the_stealth_stand_in_for_these_two():
    for name in ("MISDIRECTION", "VENTRILOQUATE"):
        assert all(e["params"].get("flag") != "hidden" for e in BY_NAME[name]["effects"]), name


def test_sql_is_transactional_keyed_by_plain_name_and_guarded_on_the_old_row():
    assert SQL.count("BEGIN;") == 1 and SQL.rstrip().endswith("COMMIT;")
    assert "plain_name = 'MISDIRECTION'" in SQL and "plain_name = 'VENTRILOQUATE'" in SQL
    assert SQL.count(OLD_ROW) == 2  # one guard per ability
    assert 'ON CONFLICT (ability_id, effect_id, "order") DO NOTHING' in SQL
    # Every statement that changes help or the effect description is guarded against a rerun.
    assert "NOT LIKE '%speak_as%'" in SQL
    assert "NOT LIKE '%does not work while riding%'" in SQL
    assert "NOT LIKE '%Everyone else in the room hears%'" in SQL
    assert 'UPDATE "Command"' in SQL and "keeps_hidden = true" in SQL  # `stay` keeps hiders hidden
    # Ids differ between dev and prod: nothing is addressed by a number.
    assert not re.search(r"ability_id\s*=\s*\d+|\bid\s*=\s*\d+", SQL)


def test_alter_object_documents_the_speak_as_mode():
    effects = json.loads((DATA / "effects.json").read_text(encoding="utf-8"))
    (effect,) = (e for e in effects if e["name"] == "alter_object")
    assert "speak_as" in effect["paramSchema"]["properties"]["mode"]["enum"]
    assert "speak_as" in effect["description"]


def test_a_legacy_reimport_maps_misdirection_to_its_own_flag():
    assert EFF_FLAG_MAPPINGS["EFF_MISDIRECTION"] == ("status", {"flag": "misdirection"})
