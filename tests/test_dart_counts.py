"""Dart spells fire a skill-gated random bolt count; Remove Paralysis says "already move just fine".

Legacy spells.cpp spell_magic_missile / spell_fire_darts / spell_ice_darts / spell_spirit_arrows:
1 bolt, plus one per tier whose skill gate is met and whose random_number(1, 100) beats its
threshold. spell_remove_paralysis (spells.cpp:1878) tells the caster when the target had nothing
to lift.
"""

import json
import re
from pathlib import Path

DATA = Path(__file__).resolve().parents[1] / "data"
SQL = (DATA / "sql" / "2026-10-09-dart-counts.sql").read_text(encoding="utf-8")
ABILITIES = json.loads((DATA / "abilities.json").read_text(encoding="utf-8"))
BY_NAME = {a["plainName"]: a for a in ABILITIES}

# (skill gate, roll must exceed) per tier, from the legacy source.
TIERS = [(5, 80), (14, 75), (24, 60), (34, 55), (44, 50), (74, 25)]
FIRE_TIERS = [(5, 80), (12, 75), (24, 60), (34, 55), (44, 50), (74, 25)]
EXPECTED_TIERS = {
    "MAGIC_MISSILE": TIERS,
    "ICE_DARTS": TIERS,
    "SPIRIT_ARROWS": TIERS,
    "FIRE_DARTS": FIRE_TIERS,
}


def _damage_row(name):
    (row,) = (e for e in BY_NAME[name]["effects"] if e["effect"] == "damage")
    return row


def _clamp(v, lo, hi):
    return max(lo, min(hi, v))


def _bolts(formula, skill, roll):
    """Evaluate the formula the way the runtime does, with every random(1, 100) pinned to `roll`."""
    expr = re.sub(r"random\(1, 100\)", str(roll), formula).replace("skill", str(skill))
    return eval(expr, {"clamp": _clamp})  # noqa: S307 - our own data file


def _legacy(tiers, skill, roll):
    return 1 + sum(1 for gate, over in tiers if skill >= gate and roll > over)


def test_every_multihit_spell_has_a_bolt_count_formula():
    multihit = {
        n for n, a in BY_NAME.items() for e in a.get("effects", []) if e["params"].get("multihit")
    }
    assert multihit == set(EXPECTED_TIERS)
    for name in multihit:
        assert isinstance(_damage_row(name)["params"]["boltCount"], str), name


def test_formula_matches_legacy_for_every_skill_and_roll():
    for name, tiers in EXPECTED_TIERS.items():
        formula = _damage_row(name)["params"]["boltCount"]
        for skill in range(0, 101):
            for roll in range(1, 101):
                assert _bolts(formula, skill, roll) == _legacy(tiers, skill, roll), (
                    name,
                    skill,
                    roll,
                )


def test_remove_paralysis_tells_the_caster_when_nothing_was_lifted():
    (row,) = (e for e in BY_NAME["REMOVE_PARALYSIS"]["effects"] if e["effect"] == "cleanse")
    assert row["params"]["noopMessage"] == "{target.name} can already move just fine."
    assert row["params"]["noopMessageSelf"] == "You can already move just fine."


def test_sql_literals_match_json():
    for name in EXPECTED_TIERS:
        assert f"('{name}', '{_damage_row(name)['params']['boltCount']}')" in SQL
    for key in ("noopMessage", "noopMessageSelf"):
        (row,) = (e for e in BY_NAME["REMOVE_PARALYSIS"]["effects"] if e["effect"] == "cleanse")
        assert f"'{key}', '{row['params'][key]}'" in SQL


def test_sql_is_keyed_by_names_only_and_idempotent():
    for token in (
        "a.plain_name = v.plain_name",
        "a.plain_name = 'REMOVE_PARALYSIS'",
        "e.name = 'damage'",
        "e.name = 'cleanse'",
    ):
        assert token in SQL
    assert not re.search(r"ability_id\s*=\s*\d", SQL)
    assert not re.search(r"\ba\.id\s*=\s*\d", SQL)
    assert "ae.override_params->'boltCount' IS NULL" in SQL
    assert "ae.override_params->'noopMessage' IS NULL" in SQL
    assert SQL.count("UPDATE ") == 2
    assert "INSERT" not in SQL and "DELETE" not in SQL
