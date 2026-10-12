"""Disguise (fierymud-rs #143): Familiarity that ends when the bearer enters combat.

abilities.json / classes.json / effects.json and data/sql/2026-10-12-disguise-spell.sql stay
in sync; Statue and Hearthsong place the same breakOnCombat disguise.
"""

import json
import re
from pathlib import Path

DATA = Path(__file__).resolve().parents[1] / "data"
SQL = (DATA / "sql" / "2026-10-12-disguise-spell.sql").read_text(encoding="utf-8")
ABILITIES = json.loads((DATA / "abilities.json").read_text(encoding="utf-8"))
BY_NAME = {a["plainName"]: a for a in ABILITIES}
CLASSES = json.loads((DATA / "classes.json").read_text(encoding="utf-8"))
EFFECTS = json.loads((DATA / "effects.json").read_text(encoding="utf-8"))
DISGUISE = BY_NAME["DISGUISE"]


def sql_literal(value):
    return "'" + value.replace("'", "''") + "'"


def familiarity_rows(name):
    return [e for e in BY_NAME[name]["effects"] if e["params"].get("flag") == "familiarity"]


def test_disguise_is_familiarity_that_breaks_on_combat():
    assert DISGUISE["abilityType"] == "SPELL"
    assert DISGUISE["violent"] is False
    assert DISGUISE["combatOk"] is False  # cannot be cast mid-fight
    (row,) = DISGUISE["effects"]
    assert row["effect"] == "status" and row["trigger"] == "on_cast"
    assert row["params"]["flag"] == "familiarity"
    assert row["params"]["breakOnCombat"] is True
    assert row["params"]["duration"] == "5 + (skill / 10)"
    assert row["params"]["durationUnit"] == "hours"


def test_disguise_is_an_illusionist_circle_4_spell_and_nobody_elses():
    rows = [s for s in CLASSES["classSkills"] if s["skillName"] == "DISGUISE"]
    assert [(s["className"], s["circle"], s["minLevel"], s["abilityType"]) for s in rows] == [
        ("CLASS_ILLUSIONIST", 4, 25, "SPELL")
    ]
    # Circle 4 starts at level 25 for the Illusionist (Misdirection sits on the same circle).
    (misdirection,) = (
        s
        for s in CLASSES["classSkills"]
        if s["skillName"] == "MISDIRECTION" and s["className"] == "CLASS_ILLUSIONIST"
    )
    assert misdirection["circle"] == 4 and misdirection["minLevel"] == 25
    # Familiarity is circle 9, so one circle above it would have been wrong: 4 is the choice.
    (familiarity,) = (
        s
        for s in CLASSES["classSkills"]
        if s["skillName"] == "FAMILIARITY" and s["className"] == "CLASS_ILLUSIONIST"
    )
    assert familiarity["circle"] == 9


def test_statue_and_hearthsong_place_the_disguise():
    # Statue: both rows (statue, familiarity) end when combat starts.
    assert {e["params"]["flag"] for e in BY_NAME["STATUE"]["effects"]} == {"statue", "familiarity"}
    assert all(e["params"]["breakOnCombat"] is True for e in BY_NAME["STATUE"]["effects"])
    # Hearthsong keeps its focus buff and adds the disguise as a second status row.
    effects = BY_NAME["HEARTHSONG"]["effects"]
    assert [e["effect"] for e in effects] == ["modify", "status"]
    (row,) = familiarity_rows("HEARTHSONG")
    assert row["order"] == 1 and row["trigger"] == "on_cast"
    assert row["params"]["breakOnCombat"] is True
    assert "fighting begins" in row["params"]["breakMessage"]
    assert "{actor.name}" in row["params"]["breakRoomMessage"]
    # The real Familiarity spell does not break on combat.
    assert all("breakOnCombat" not in e["params"] for e in BY_NAME["FAMILIARITY"]["effects"])


def test_status_effect_documents_the_break_params():
    (status,) = (e for e in EFFECTS if e["name"] == "status")
    props = status["paramSchema"]["properties"]
    assert props["breakOnCombat"]["type"] == "boolean"
    assert (
        props["breakMessage"]["type"] == "string" and props["breakRoomMessage"]["type"] == "string"
    )


def test_sql_matches_the_json():
    assert sql_literal(DISGUISE["description"]) in SQL
    assert sql_literal(DISGUISE["notes"]) in SQL
    for key in (
        "successToCaster",
        "successToVictim",
        "successToRoom",
        "successToSelf",
        "successSelfRoom",
    ):
        assert sql_literal(DISGUISE["messages"][key]) in SQL, key
    assert sql_literal(DISGUISE["messages"]["wearoffToTarget"]) in SQL
    assert sql_literal(DISGUISE["messages"]["wearoffToRoom"]) in SQL
    (row,) = DISGUISE["effects"]
    assert sql_literal(json.dumps(row["params"])) + "::jsonb" in SQL
    (hs,) = familiarity_rows("HEARTHSONG")
    assert sql_literal(json.dumps(hs["params"])) + "::jsonb" in SQL
    assert f"{DISGUISE['pages']}, 0, CURRENT_TIMESTAMP" in SQL
    assert "'ENCHANTMENT'::\"SpellSphere\"" in SQL and DISGUISE["sphere"] == "ENCHANTMENT"
    # Statue and Hearthsong description / notes sentences.
    assert "The disguise ends if the caster enters combat." in BY_NAME["STATUE"]["description"]
    assert "The disguise ends if the caster enters combat." in SQL
    assert "also takes on a familiar disguise" in BY_NAME["HEARTHSONG"]["description"]
    assert "also takes on a familiar disguise" in SQL


def test_sql_is_keyed_by_name_and_idempotent():
    assert not re.search(r"\b(ability_id|class_id|a\.id|c\.id)\s*=\s*\d", SQL)
    assert SQL.count("BEGIN;") == 1 and SQL.rstrip().endswith("COMMIT;")
    assert "WHERE NOT EXISTS (SELECT 1 FROM \"Ability\" WHERE plain_name = 'DISGUISE')" in SQL
    assert (
        "c.plain_name = 'Illusionist'" in SQL
        and "ON CONFLICT (class_id, ability_id) DO NOTHING" in SQL
    )
    assert "COALESCE(ae.override_params->>'breakOnCombat', '') <> 'true'" in SQL
    assert "NOT LIKE '%The disguise ends if the caster enters combat.%'" in SQL
    assert "NOT LIKE '%also takes on a familiar disguise%'" in SQL
    assert "x.override_params->>'flag' = 'familiarity'" in SQL
    assert "'disguise' = ANY(keywords)" in SQL
