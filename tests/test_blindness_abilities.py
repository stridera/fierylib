"""Blindness, Blinding Beauty, Cure Blind and Eye Gouge are wired to the runtime's blind status."""

import json
import re
from pathlib import Path

from fierylib.seeders.ability_effects_linker import EFF_FLAG_MAPPINGS

ROOT = Path(__file__).resolve().parents[1]
DATA = ROOT / "data"
SQL = (DATA / "sql" / "2026-10-08-blindness-abilities.sql").read_text(encoding="utf-8")


def _ability(plain_name):
    abilities = json.loads((DATA / "abilities.json").read_text(encoding="utf-8"))
    (ability,) = [a for a in abilities if a["plainName"] == plain_name]
    return ability


def _effects(plain_name, kind):
    return [e for e in _ability(plain_name)["effects"] if e["effect"] == kind]


def test_blindness_spells_apply_the_blind_status_for_two_ticks():
    for name in ("BLINDNESS", "BLINDING_BEAUTY"):
        (status,) = _effects(name, "status")
        assert status["params"] == {"flag": "blind", "duration": 2, "durationUnit": "hours"}
        assert status["order"] == 0
        # Legacy magic.cpp:1273-1283 keeps -4 hitroll / -40 AC on the same affect.
        targets = {e["params"]["target"]: e["params"]["amount"] for e in _effects(name, "modify")}
        assert targets == {"accuracy": "-4", "evasion": "-40"}
        (save,) = _ability(name)["savingThrows"]
        assert save["onSaveAction"] == "NEGATE"


def test_cure_blind_cleanses_instead_of_healing():
    ability = _ability("CURE_BLIND")
    (effect,) = ability["effects"]
    assert effect["effect"] == "cleanse"
    assert effect["params"]["condition"] == "blind"
    assert not _effects("CURE_BLIND", "heal")
    # The victim / room lines live on the cleanse row (tests/test_heal_cleanse_messages.py), so
    # they only print when sight actually returns.
    assert effect["params"]["message"] == "Your vision returns!"


def test_eye_gouge_blinds_for_one_tick_before_it_damages():
    ability = _ability("EYE_GOUGE")
    kinds = [e["effect"] for e in sorted(ability["effects"], key=lambda e: e["order"])]
    assert kinds == ["status", "modify", "damage"]
    (status,) = _effects("EYE_GOUGE", "status")
    assert status["params"] == {"flag": "blind", "duration": 1, "durationUnit": "hours"}
    (modify,) = _effects("EYE_GOUGE", "modify")
    assert modify["params"]["target"] == "accuracy"
    assert modify["params"]["amount"] == "-2 - skill / 10"
    assert ability["messages"]["wearoffToTarget"] == "Your vision returns."


def test_every_effect_row_has_a_unique_order_per_ability():
    for name in ("BLINDNESS", "BLINDING_BEAUTY", "CURE_BLIND", "EYE_GOUGE"):
        orders = [e["order"] for e in _ability(name)["effects"]]
        assert len(orders) == len(set(orders)), name


def test_sql_literals_match_json():
    literals = [json.loads(m) for m in re.findall(r"'(\{\"[^']*\})'::jsonb", SQL)]
    wanted = [
        _effects("BLINDNESS", "status")[0]["params"],
        # The cleanse messages arrive later, in 2026-10-08-heal-cleanse-messages.sql.
        {"condition": "blind", "scope": "all"},
        _effects("EYE_GOUGE", "status")[0]["params"],
        _effects("EYE_GOUGE", "modify")[0]["params"],
    ]
    for params in wanted:
        assert params in literals, params


def test_sql_is_keyed_by_names_only_and_guarded():
    for name in ("'BLINDNESS'", "'BLINDING_BEAUTY'", "'CURE_BLIND'", "'EYE_GOUGE'"):
        assert name in SQL
    assert "e.name = 'status'" in SQL and "e.name = 'cleanse'" in SQL
    # Ability ids differ between dev and prod: nothing may hard-code one.
    assert not re.search(r"ability_id\s*=\s*\d", SQL)
    assert not re.search(r"\ba\.id\s*=\s*\d", SQL)
    assert SQL.count("NOT EXISTS") >= 5
    assert SQL.count("ON CONFLICT DO NOTHING") == 4
    assert "ae.override_params->>'amount' = '1d8'" in SQL


def test_linker_names_the_blind_status_the_runtime_cleanse_matches():
    assert EFF_FLAG_MAPPINGS["EFF_BLIND"] == ("status", {"flag": "blind"})
