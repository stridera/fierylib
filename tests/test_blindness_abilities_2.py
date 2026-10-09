"""Sunray, the heal family's blindness cure and Blinding Beauty's area targeting match legacy."""

import json
import re
from pathlib import Path

DATA = Path(__file__).resolve().parents[1] / "data"
SQL = (DATA / "sql" / "2026-10-08-blindness-abilities-2.sql").read_text(encoding="utf-8")
ABILITIES = json.loads((DATA / "abilities.json").read_text(encoding="utf-8"))


def _ability(plain_name):
    (ability,) = [a for a in ABILITIES if a["plainName"] == plain_name]
    return ability


def _effects(plain_name, kind):
    return [e for e in _ability(plain_name)["effects"] if e["effect"] == kind]


def test_sunray_damages_then_blinds_for_two_ticks_with_legacy_penalties():
    sunray = _ability("SUNRAY")
    ordered = sorted(sunray["effects"], key=lambda e: e["order"])
    assert [e["effect"] for e in ordered] == ["damage", "status", "modify", "modify"]
    assert [e["order"] for e in ordered] == [0, 1, 2, 3]

    (damage,) = _effects("SUNRAY", "damage")
    # lib.default/misc/spell_dams 155: 20d10, 30d10 between players (see
    # test_invigorate_embrace_sunray.py); magic.cpp:961 adds skill^2 * 7 / 400.
    assert damage["params"] == {
        "type": "fire",
        "amount": "roll_dice(20 + 10 * actor_is_player * target_is_player, 10) + (pow(skill, 2) * 7) / 400",
    }
    assert sunray["damageType"] == "FIRE"
    assert sunray["isArea"] is False

    (status,) = _effects("SUNRAY", "status")
    assert status["params"] == {"flag": "blind", "duration": 2, "durationUnit": "hours"}
    # magic.cpp:2876-2884: -4 hitroll and -40 AC ride on the same affect.
    modifiers = {e["params"]["target"]: e["params"]["amount"] for e in _effects("SUNRAY", "modify")}
    assert modifiers == {"accuracy": "-4", "evasion": "-40"}


def test_sunray_save_only_turns_away_the_blinding():
    (save,) = _ability("SUNRAY")["savingThrows"]
    # Legacy saves only inside mag_affect; the mag_damage half is never saved against.
    assert save["onSaveAction"] == "NEGATE_STATUS"


def test_heal_family_cures_blind_poison_and_disease():
    for name in ("HEAL", "FULL_HEAL", "GROUP_HEAL"):
        ability = _ability(name)
        assert [e["effect"] for e in ability["effects"]][0] == "heal", name
        cleanses = sorted(_effects(name, "cleanse"), key=lambda e: e["order"])
        assert [e["params"]["condition"] for e in cleanses] == ["blind", "poison", "disease"], name
        assert all(e["params"]["scope"] == "all" for e in cleanses), name
        orders = [e["order"] for e in ability["effects"]]
        assert len(orders) == len(set(orders)), name


def test_blinding_beauty_is_a_violent_area_spell_still_blinding():
    ability = _ability("BLINDING_BEAUTY")
    assert ability["isArea"] is True
    assert ability["violent"] is True
    # Holy Word shows the importer derives ROOM_ENEMIES from isArea + violent.
    assert "targetScope" not in ability
    (status,) = _effects("BLINDING_BEAUTY", "status")
    assert status["params"]["flag"] == "blind"


def test_sql_literals_match_json():
    literals = [json.loads(m) for m in re.findall(r"'(\{\"[^']*\})'::jsonb", SQL)]
    # This patch seeded the 20d10 damage row; 2026-10-08-invigorate-embrace-sunray.sql moves it to the
    # player-aware dice, so only the unchanged status row is compared to the JSON.
    assert _effects("SUNRAY", "status")[0]["params"] in literals
    assert {"type": "fire", "amount": "20d10 + (pow(skill, 2) * 7) / 400"} in literals
    assert "'\"NEGATE_STATUS\"'" in SQL
    for condition in ("'blind', 1", "'poison', 2", "'disease', 3"):
        assert condition in SQL


def test_sql_is_keyed_by_names_only_and_idempotent():
    for name in ("'SUNRAY'", "'BLINDING_BEAUTY'", "'HEAL', 'FULL_HEAL', 'GROUP_HEAL'"):
        assert name in SQL
    # Ability ids differ between dev and prod: nothing may hard-code one.
    assert not re.search(r"ability_id\s*=\s*\d", SQL)
    assert not re.search(r"\ba\.id\s*=\s*\d", SQL)
    assert SQL.count("NOT EXISTS") >= 5
    assert SQL.count("ON CONFLICT DO NOTHING") == 3
    # The Sunray save and the area flag only change rows that are still in the old shape.
    assert "s.on_save_action = '\"NEGATE\"'" in SQL
    assert "is_area = false OR target_scope = 'SINGLE'" in SQL
