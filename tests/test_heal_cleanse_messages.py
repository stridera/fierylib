"""Group Heal heals like Heal; cleanse rows carry the legacy per-condition messages."""

import json
import re
from pathlib import Path

DATA = Path(__file__).resolve().parents[1] / "data"
SQL = (DATA / "sql" / "2026-10-08-heal-cleanse-messages.sql").read_text(encoding="utf-8")
ABILITIES = json.loads((DATA / "abilities.json").read_text(encoding="utf-8"))

BLIND = ("Your vision returns!", "There's a momentary gleam in {target.name}'s eyes.")
POISON = ("The poison in your system has been cleansed.", None)
DISEASE = ("Your disease has been cured.", None)
EXPECTED = {
    ("CURE_BLIND", "blind"): BLIND,
    ("HEAL", "blind"): BLIND,
    ("FULL_HEAL", "blind"): BLIND,
    ("GROUP_HEAL", "blind"): BLIND,
    ("HEAL", "poison"): POISON,
    ("FULL_HEAL", "poison"): POISON,
    ("GROUP_HEAL", "poison"): POISON,
    ("HEAL", "disease"): DISEASE,
    ("FULL_HEAL", "disease"): DISEASE,
    ("GROUP_HEAL", "disease"): DISEASE,
    ("REMOVE_POISON", "poison"): (
        "A warm feeling runs through your body!",
        "{target.name} looks better.",
    ),
    ("REMOVE_CURSE", "curse"): ("You don't feel so unlucky.", None),
    ("REMOVE_PARALYSIS", "paralysis"): (
        "<b:yellow>Your body begins to move again.</>",
        "<b:yellow>{target.name} begins to move again.</>",
    ),
}


def _ability(plain_name):
    (ability,) = [a for a in ABILITIES if a["plainName"] == plain_name]
    return ability


def _heal_amount(plain_name):
    (heal,) = [e for e in _ability(plain_name)["effects"] if e["effect"] == "heal"]
    return heal["params"]["amount"]


def test_group_heal_uses_heals_formula_not_the_1d8_placeholder():
    # magic.cpp:3414 perform_mag_group: mag_point(SPELL_HEAL) on every member.
    assert _heal_amount("GROUP_HEAL") == _heal_amount("HEAL") == "100 + roll_dice(2, 9) + skill / 5"
    (heal,) = [e for e in _ability("GROUP_HEAL")["effects"] if e["effect"] == "heal"]
    assert heal["params"]["area"] is True


def test_no_heal_row_keeps_the_placeholder_amount():
    for ability in ABILITIES:
        for effect in ability.get("effects", []):
            if effect["effect"] == "heal":
                amount = effect["params"].get("amount")
                assert amount and amount != "1d8", ability["plainName"]


def test_cleanse_rows_carry_the_legacy_messages():
    found = {}
    for ability in ABILITIES:
        for effect in ability.get("effects", []):
            if effect["effect"] == "cleanse":
                params = effect["params"]
                key = (ability["plainName"], params.get("condition"))
                if "message" in params or "roomMessage" in params:
                    found[key] = (params.get("message"), params.get("roomMessage"))
    assert found == EXPECTED


def test_cure_blind_catalog_no_longer_duplicates_the_cleanse_lines():
    messages = _ability("CURE_BLIND")["messages"]
    assert messages == {"successToCaster": "You cure {target.name}'s blindness."}


def test_sql_literals_match_json():
    for (plain_name, condition), (message, room) in EXPECTED.items():
        sql_message = message.replace("'", "''")
        assert f"'{plain_name}', '{condition}', '{sql_message}'" in SQL, (plain_name, condition)
        if room:
            assert room.replace("'", "''") in SQL, room
    assert "100 + roll_dice(2, 9) + skill / 5" in SQL


def test_sql_is_keyed_by_names_only_and_idempotent():
    for name in ("'GROUP_HEAL'", "'cleanse'", "'heal'", "'CURE_BLIND'"):
        assert name in SQL
    # Ability ids differ between dev and prod: nothing may hard-code one.
    assert not re.search(r"ability_id\s*=\s*\d", SQL)
    assert not re.search(r"\ba\.id\s*=\s*\d", SQL)
    # Each statement only rewrites rows still in the old shape.
    assert "ae.override_params->>'amount' = '1d8'" in SQL
    assert "NOT (ae.override_params ? 'message')" in SQL
    assert SQL.count("UPDATE ") == 3
    assert "INSERT" not in SQL and "DELETE" not in SQL
