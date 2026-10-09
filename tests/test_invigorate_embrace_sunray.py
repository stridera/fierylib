"""Invigorate, Nature's Embrace and Sunray match legacy (magic.cpp:4612, 4616; spell_dams SPELL_SUNRAY)."""

import json
import re
from pathlib import Path

DATA = Path(__file__).resolve().parents[1] / "data"
SQL = (DATA / "sql" / "2026-10-08-invigorate-embrace-sunray.sql").read_text(encoding="utf-8")
ABILITIES = json.loads((DATA / "abilities.json").read_text(encoding="utf-8"))
BY_NAME = {a["plainName"]: a for a in ABILITIES}

SUNRAY_AMOUNT = (
    "roll_dice(20 + 10 * actor_is_player * target_is_player, 10) + (pow(skill, 2) * 7) / 400"
)


# 2026-10-09-group-targeting.sql reworded these sentences once group targeting and the outdoors
# restriction were modelled; undo that to compare with the text this patch wrote.
_LATER_REWORDING = [
    (
        "MAG_GROUP (mag_group, magic.cpp:3451) is targetScope ROOM_ALLIES: the cast fills the "
        "caster plus every grouped player in the room, caster last.",
        "MAG_GROUP (caster plus grouped allies in the room) is not modelled: single target.",
    ),
    ("Outdoors only.", "Outdoors only (not enforced yet)."),
    (
        "is the \"outdoors\" restriction rule: the cast is refused with that line while the "
        "caster's room is indoors (IndoorRoom flag, underdark or underwater sector).",
        "has no restriction type in the runtime yet, so it is not enforced.",
    ),
]


def _as_of_this_patch(text):
    for later, earlier in _LATER_REWORDING:
        text = text.replace(later, earlier)
    return text


def _effects(name, kind):
    return [e for e in BY_NAME[name]["effects"] if e["effect"] == kind]


def test_invigorate_heals_the_targets_full_stamina():
    (row,) = BY_NAME["INVIGORATE"]["effects"]
    assert row["effect"] == "heal"
    assert row["params"] == {"resource": "move", "amount": "target_max_stamina"}


def test_natures_embrace_raises_hiddenness_and_does_not_heal():
    ability = BY_NAME["NATURES_EMBRACE"]
    assert _effects("NATURES_EMBRACE", "heal") == []
    (row,) = ability["effects"]
    assert row["effect"] == "modify"
    assert row["params"] == {
        "target": "hiddenness",
        "amount": "skill * 5",
        "duration": "skill / 3 + 1",
        "durationUnit": "hours",
    }
    assert ability["messages"]["successToSelf"] == "You phase into the landscape."
    assert ability["messages"]["successSelfRoom"] == "{actor.name} phases into the landscape."
    assert "heal" not in ability["description"].lower()


def test_sunray_rolls_30d10_between_players_and_20d10_otherwise():
    (damage,) = _effects("SUNRAY", "damage")
    assert damage["params"]["amount"] == SUNRAY_AMOUNT
    assert damage["params"]["type"] == "fire"
    # The rest of Sunray (blind, accuracy -4, evasion -40) is untouched.
    assert [e["effect"] for e in BY_NAME["SUNRAY"]["effects"]] == [
        "damage",
        "status",
        "modify",
        "modify",
    ]


def test_only_known_formula_symbols_are_used():
    known = {
        "skill",
        "target_max_stamina",
        "actor_is_player",
        "target_is_player",
        "roll_dice",
        "pow",
    }
    for text in ("target_max_stamina", "skill * 5", "skill / 3 + 1", SUNRAY_AMOUNT):
        assert set(re.findall(r"[a-z_]+", text)) <= known, text


def test_sql_literals_match_json():
    assert "jsonb_build_object('resource', 'move', 'amount', 'target_max_stamina')" in SQL
    assert "'amount', 'skill * 5'" in SQL
    assert "'duration', 'skill / 3 + 1'" in SQL
    assert f"'{SUNRAY_AMOUNT}'" in SQL
    for name in ("INVIGORATE", "NATURES_EMBRACE", "SUNRAY"):
        notes = _as_of_this_patch(BY_NAME[name]["notes"]).replace("'", "''")
        assert notes in SQL, name
        if name == "SUNRAY":  # description unchanged, only the dice and notes move
            continue
        description = _as_of_this_patch(BY_NAME[name]["description"]).replace("'", "''")
        assert description in SQL, name


def test_sql_is_keyed_by_names_only_and_idempotent():
    for name in ("'INVIGORATE'", "'NATURES_EMBRACE'", "'SUNRAY'", "'heal'", "'modify'", "'damage'"):
        assert name in SQL
    # Ability ids differ between dev and prod: nothing may hard-code one.
    assert not re.search(r"ability_id\s*=\s*\d", SQL)
    assert not re.search(r"\ba\.id\s*=\s*\d", SQL)
    # Each statement only rewrites rows still in the old shape.
    assert "ae.override_params->>'amount' = 'skill / 2'" in SQL
    assert "ae.override_params->>'amount' = '20d10 + (pow(skill, 2) * 7) / 400'" in SQL
    assert "AND e.name = 'heal'" in SQL
    assert SQL.count("UPDATE ") == 7
    assert "INSERT" not in SQL and "DELETE" not in SQL
