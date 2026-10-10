"""Mob AI class-rule seed (WP-B): data/mob_ai_seed.json, the seeder and the SQL patch.

Offline tests check the seed file and the generated SQL. The last two tests query the
dev database (skipped when it is unreachable or the AI schema is not applied) to prove the
seeded ClassAiRules never reference an ability the class lacks.
"""

import json
import re
from collections import Counter
from pathlib import Path

import pytest

from fierylib.seeders.mob_ai_seeder import (
    CONDITION_KEYS,
    SQL_PATH,
    build_sql,
    expand,
    load_seed,
    validate_rule,
)

ROOT = Path(__file__).resolve().parents[1]
SEED = load_seed()
ROWS = expand(SEED)

MAGE_CLASSES = ["Sorcerer", "Pyromancer", "Cryomancer", "Necromancer", "Illusionist", "Conjurer"]
CLERIC_CLASSES = ["Cleric", "Druid", "Diabolist", "Priest", "Shaman"]
HYBRIDS = ["Ranger", "Paladin", "Anti-Paladin"]
HINDRANCES = {"BLINDNESS", "POISON", "DISEASE", "CURSE", "INSANITY", "SILENCE", "ENTANGLE", "WEB", "RAY_OF_ENFEEB"}
HEALS = {"FULL_HEAL", "HEAL", "CURE_CRITIC", "CURE_SERIOUS", "CURE_LIGHT"}


def _class_rules(name: str) -> list[dict]:
    return sorted((r for r in ROWS if r["class"] == name), key=lambda r: r["priority"])


def test_every_rule_is_valid():
    problems = [(r["class"], r["ability"], p) for r in ROWS for p in validate_rule(r)]
    assert problems == []


def test_only_rust_condition_keys_are_used():
    used = {k for r in ROWS for k in r["conditions"]}
    assert used <= set(CONDITION_KEYS)


def test_every_family_class_and_ability_exists():
    classes = json.loads((ROOT / "data" / "classes.json").read_text(encoding="utf-8"))["classes"]
    known = {c["plainName"] for c in classes}
    assert set(SEED["classes"]) <= known
    assert all(f in SEED["families"] for fs in SEED["classes"].values() for f in fs)
    abilities = {a["plainName"] for a in json.loads((ROOT / "data" / "abilities.json").read_text(encoding="utf-8"))}
    abilities.add("HIT_ALL")  # the DB name of legacy SKILL_HITALL
    missing = sorted({r["ability"] for r in ROWS} - abilities)
    assert missing == []


def test_priorities_are_unique_per_class_and_ability():
    keys = Counter((r["class"], r["ability"], r["priority"]) for r in ROWS)
    assert [k for k, n in keys.items() if n > 1] == []


@pytest.mark.parametrize("cls", MAGE_CLASSES)
def test_mage_offensive_spell_above_hindrances(cls):
    rules = _class_rules(cls)
    hindrance = [r["priority"] for r in rules if r["ability"] in HINDRANCES]
    offensive = [
        r["priority"]
        for r in rules
        if r["family"] == "sorcerer" and "in_combat" in r["conditions"] and r["ability"] not in HINDRANCES
        and r["ability"] != "HARNESS" and r["ability"] != "TELEPORT"
    ]
    assert hindrance and offensive
    assert min(offensive) < min(hindrance)


@pytest.mark.parametrize("cls", CLERIC_CLASSES + HYBRIDS)
def test_cleric_types_heal_themselves_under_sixty_percent(cls):
    heals = [r for r in _class_rules(cls) if r["ability"] in HEALS and r["priority"] < 20]
    assert heals, "no heal rules"
    for r in heals:
        assert r["conditions"]["self_hp_below"] == 60
        assert r["target"] == "self"
    # Heals come before the offensive spells, as in legacy cleric_ai_action.
    assert max(r["priority"] for r in heals) < min(
        r["priority"] for r in _class_rules(cls) if r["ability"] == "HARM"
    )


def test_warrior_has_bash_and_rogue_has_backstab():
    assert "BASH" in {r["ability"] for r in _class_rules("Warrior")}
    assert "BACKSTAB" in {r["ability"] for r in _class_rules("Rogue")}


def test_hybrids_run_cleric_rules_before_warrior_rules():
    for cls in HYBRIDS:
        fams = [r["family"] for r in _class_rules(cls)]
        assert fams == sorted(fams, key={"cleric": 0, "warrior": 1}.get)
        assert {"cleric", "warrior"} <= set(fams)


def test_cleric_offensive_filters_are_carried_over():
    rules = {r["ability"]: r["conditions"] for r in _class_rules("Cleric") if r["priority"] >= 50}
    assert rules["DESTROY_UNDEAD"]["target_lifeforce"] == "UNDEAD"
    assert rules["DISPEL_EVIL"]["align"] == "evil"
    assert rules["DISPEL_GOOD"]["align"] == "good"
    area = {r["ability"]: r["conditions"] for r in _class_rules("Cleric") if 20 <= r["priority"] < 30}
    assert all(c["grouped_targets"] is True for c in area.values())


def test_sql_patch_matches_generator_and_is_name_keyed_and_idempotent():
    sql = SQL_PATH.read_text(encoding="utf-8")
    assert sql == build_sql(SEED)
    assert "ON CONFLICT (class_id, ability_id, priority) DO NOTHING" in sql
    assert 'JOIN "Class" c ON c.plain_name = cf.class_name' in sql
    assert 'JOIN "Ability" a ON a.plain_name = fr.ability_name' in sql
    assert "WHERE cs.id IS NOT NULL OR ca.id IS NOT NULL" in sql
    assert not re.search(r"(class_id|ability_id)\s*=\s*\d", sql)


# ---- database-backed checks -------------------------------------------------------------


@pytest.fixture(scope="module")
def db():
    psycopg2 = pytest.importorskip("psycopg2")
    try:
        conn = psycopg2.connect(dbname="fierydev", user="strider", connect_timeout=3)
    except Exception as exc:  # noqa: BLE001
        pytest.skip(f"database unavailable: {exc}")
    cur = conn.cursor()
    cur.execute("SELECT to_regclass('\"ClassAiRules\"')")
    if cur.fetchone()[0] is None:
        pytest.skip("ClassAiRules not applied")
    yield cur
    conn.close()


def test_db_no_rule_references_an_ability_its_class_lacks(db):
    db.execute(
        'SELECT c.plain_name, a.plain_name FROM "ClassAiRules" r '
        'JOIN "Class" c ON c.id = r.class_id JOIN "Ability" a ON a.id = r.ability_id '
        'WHERE NOT EXISTS (SELECT 1 FROM "ClassAbilities" x WHERE x.class_id = r.class_id AND x.ability_id = r.ability_id) '
        'AND NOT EXISTS (SELECT 1 FROM "ClassSkills" x WHERE x.class_id = r.class_id AND x.ability_id = r.ability_id)'
    )
    assert db.fetchall() == []


def test_db_skill_rules_carry_the_class_skill_min_level(db):
    db.execute(
        'SELECT c.plain_name, a.plain_name, r.min_level, cs.min_level FROM "ClassAiRules" r '
        'JOIN "Class" c ON c.id = r.class_id JOIN "Ability" a ON a.id = r.ability_id '
        'JOIN "ClassSkills" cs ON cs.class_id = r.class_id AND cs.ability_id = r.ability_id '
        "WHERE r.min_level IS DISTINCT FROM cs.min_level"
    )
    assert db.fetchall() == []
