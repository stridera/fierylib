"""Mob AI rule seed (WP-B, WP-D): data/mob_ai_seed.json, the seeder and the SQL patches.

Offline tests check the seed file and the generated SQL (class rules, race rules and the
RaceAbilities rows the race rules need). The database tests query the dev database (skipped when
it is unreachable or the AI schema is not applied) to prove the seeded rules never reference an
ability the class / race lacks.
"""

import json
import re
from collections import Counter
from pathlib import Path

import pytest

from fierylib.seeders.mob_ai_seeder import (
    CONDITION_KEYS,
    RACE_SQL_PATH,
    SQL_PATH,
    build_race_rule_statements,
    build_race_sql,
    build_sql,
    build_statements,
    expand,
    expand_race_rules,
    load_seed,
    rule_key,
    validate_rule,
)

ROOT = Path(__file__).resolve().parents[1]
SEED = load_seed()
ROWS = expand(SEED)
RACE_ROWS = expand_race_rules(SEED)

MAGE_CLASSES = ["Sorcerer", "Pyromancer", "Cryomancer", "Necromancer", "Illusionist", "Conjurer"]
CLERIC_CLASSES = ["Cleric", "Druid", "Diabolist", "Priest", "Shaman"]
HYBRIDS = ["Ranger", "Paladin", "Anti-Paladin"]
HINDRANCES = {"BLINDNESS", "POISON", "DISEASE", "CURSE", "INSANITY", "SILENCE", "ENTANGLE", "WEB", "RAY_OF_ENFEEB"}
HEALS = {"FULL_HEAL", "HEAL", "CURE_CRITIC", "CURE_SERIOUS", "CURE_LIGHT"}


def _class_rules(name: str) -> list[dict]:
    return sorted((r for r in ROWS if r["class"] == name), key=lambda r: r["priority"])


def test_every_rule_is_valid():
    problems = [(r["class"], r["ability"], p) for r in ROWS for p in validate_rule(r)]
    problems += [(r["race"], r["ability"], p) for r in RACE_ROWS for p in validate_rule(r)]
    assert problems == []


def test_only_rust_condition_keys_are_used():
    used = {k for r in ROWS + RACE_ROWS for k in r["conditions"]}
    assert used <= set(CONDITION_KEYS)


def test_the_validator_rejects_bad_new_conditions():
    base = {"target": "self", "chance_pct": 100, "priority": 1}
    for bad in [
        {"target_hp_above": 150},
        {"self_align": []},
        {"self_align": ["lawful"]},
        {"not_align": "chaotic"},
        {"not_lifeforce": ["GHOST"]},
        {"target_level_max": "high"},
        {"self_has_debuff": 3},
        {"level_scaled_chance": 0},
        {"level_roll": {"min": 9, "max": 2}},
        {"composition": ["JELLY"]},
        {"requires_weapon_type": ""},
        {"outdoors": "yes"},
    ]:
        assert validate_rule({**base, "conditions": bad}), bad
    for good in [
        {"target_hp_above": 15, "self_align": ["good", "neutral"], "not_align": "evil"},
        {"not_lifeforce": ["UNDEAD", "MAGIC"], "target_level_max": 19, "level_scaled_chance": True},
        {"self_has_debuff": ["web", "entangle"], "requires_shield": True, "outdoors": True},
        {"level_roll": {"min": 0, "max": 5}, "composition": ["FIRE", "LAVA"], "requires_weapon_type": "piercing"},
    ]:
        assert validate_rule({**base, "conditions": good}) == [], good


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


def _rule(cls, ability, priority=None):
    hits = [r for r in _class_rules(cls) if r["ability"] == ability and priority in (None, r["priority"])]
    assert len(hits) == 1, (cls, ability, priority, hits)
    return hits[0]


def test_dropped_legacy_filters_are_restored():
    # self alignment
    assert _rule("Cleric", "FLAMESTRIKE")["conditions"]["self_align"] == ["good"]
    assert _rule("Cleric", "STYGIAN_ERUPTION")["conditions"]["self_align"] == ["evil"]
    assert _rule("Cleric", "HOLY_WORD")["conditions"]["self_align"] == ["good", "neutral"]
    assert _rule("Cleric", "SOULSHIELD")["conditions"]["self_align"] == ["good", "evil"]
    assert _rule("Cleric", "DISPEL_EVIL")["conditions"]["self_align"] == ["good"]
    # negated target alignment
    assert _rule("Cleric", "HELL_BOLT")["conditions"]["not_align"] == "evil"
    assert _rule("Cleric", "DIVINE_BOLT")["conditions"]["not_align"] == "good"
    # negated life force
    for ab in ("DEGENERATION", "SOUL_TAP", "ENERGY_DRAIN"):
        assert _rule("Sorcerer", ab)["conditions"]["not_lifeforce"] == ["UNDEAD", "MAGIC"]
    # victim HP above
    assert _rule("Sorcerer", "STONE_SKIN")["conditions"]["target_hp_above"] == 15
    assert _rule("Sorcerer", "HARNESS")["conditions"]["target_hp_above"] == 75
    assert _rule("Sorcerer", "RAY_OF_ENFEEB", 52)["conditions"]["target_hp_above"] == 80
    assert _rule("Sorcerer", "RAY_OF_ENFEEB", 53)["conditions"]["target_hp_below"] == 81
    # victim level < mob level + 20
    for ab in ("BLINDNESS", "POISON", "WEB"):
        assert _rule("Cleric", ab, next(r["priority"] for r in _class_rules("Cleric") if r["ability"] == ab))[
            "conditions"
        ]["target_level_max"] == 19
    # equipment and room
    assert _rule("Warrior", "BASH", 500)["conditions"]["requires_shield"] is True
    assert _rule("Warrior", "BASH", 540)["conditions"]["requires_shield"] is True
    assert _rule("Rogue", "BACKSTAB")["conditions"]["requires_weapon_type"] == "piercing"
    assert _rule("Cleric", "EARTHQUAKE")["conditions"]["outdoors"] is True
    assert _rule("Cleric", "GAIAS_CLOAK")["conditions"]["outdoors"] is True


def test_cures_name_the_debuff_they_answer_to():
    names = {
        r["ability"]: r["conditions"]["self_has_debuff"]
        for r in _class_rules("Cleric")
        if 100 <= r["priority"] < 110 and r["ability"] != "HEAL"
    }
    assert names == {
        "CURE_BLIND": "blind",
        "REMOVE_POISON": "poison",
        "REMOVE_CURSE": "curse",
        "SANE_MIND": "insanity",
        "REMOVE_PARALYSIS": ["web", "entangle"],
    }
    assert all(r["conditions"]["self_has_debuff"] is not True for r in _class_rules("Bard") if 100 <= r["priority"] < 110)


def test_level_percent_classes_use_level_scaled_chance():
    for cls in ("Rogue", "Warrior", "Bard"):
        gated = [r for r in _class_rules(cls) if r["conditions"].get("level_scaled_chance")]
        assert gated, cls
    # Bard cures and buffs are not behind the level gate (legacy check_bard_status).
    assert not any(
        r["conditions"].get("level_scaled_chance") for r in _class_rules("Bard") if r["priority"] >= 100
    )
    # The old static level-50 approximation is gone: bard rules are 100% behind the gate.
    assert {r["chance_pct"] for r in _class_rules("Bard") if r["priority"] < 100} == {4, 100}


def test_sql_patch_matches_generator_and_is_name_keyed_and_idempotent():
    sql = SQL_PATH.read_text(encoding="utf-8")
    assert sql == build_sql(SEED)
    assert "ON CONFLICT (seed_key) DO UPDATE SET" in sql
    assert "IS NOT DISTINCT FROM" in sql and "IS DISTINCT FROM EXCLUDED.seed_hash" in sql, "a second run must change 0 rows"
    assert 'ADD COLUMN IF NOT EXISTS "seed_key" TEXT' in sql and 'ADD COLUMN IF NOT EXISTS "seed_hash" TEXT' in sql
    assert 'JOIN "Class" c ON c.plain_name = cf.class_name' in sql
    assert 'JOIN "Ability" a ON a.plain_name = fr.ability_name' in sql
    assert "WHERE cs.id IS NOT NULL OR ca.id IS NOT NULL" in sql
    assert not re.search(r"(class_id|ability_id)\s*=\s*\d", sql)


# ---- race rules ------------------------------------------------------------------------

DRAGONS = ["DRAGON_GENERAL", "DRAGON_FIRE", "DRAGON_FROST", "DRAGON_ACID", "DRAGON_GAS", "DRAGON_LIGHTNING"]
DRAGONBORN = ["DRAGONBORN_FIRE", "DRAGONBORN_FROST", "DRAGONBORN_ACID", "DRAGONBORN_LIGHTNING", "DRAGONBORN_GAS"]
ELEMENT_OF = {
    "BREATHE_FIRE": {"FIRE", "LAVA"},
    "BREATHE_GAS": {"METAL", "BONE", "PLANT"},
    "BREATHE_FROST": {"WATER", "ICE", "MIST"},
    "BREATHE_ACID": {"EARTH", "STONE"},
    "BREATHE_LIGHTNING": {"AIR", "ETHER"},
}


def _race_rules(race: str) -> list[dict]:
    return sorted((r for r in RACE_ROWS if r["race"] == race), key=lambda r: r["priority"])


def test_race_rules_cover_every_legacy_dragonlike_race():
    legacy = set(SEED["race_rules_legacy"]["races"])
    assert {r["race"] for r in RACE_ROWS} == legacy
    assert set(SEED["race_abilities"]) == {"DEMON", *DRAGONS}, "dragonborn already own their breath"


def test_race_rules_keys_are_unique():
    keys = Counter((r["race"], r["ability"], r["priority"]) for r in RACE_ROWS)
    assert [k for k, n in keys.items() if n > 1] == []


def test_legacy_roll_bands_breath_sweep_roar():
    for race in DRAGONS + DRAGONBORN + ["DEMON"]:
        bands = {}
        for r in _race_rules(race):
            b = r["conditions"]["level_roll"]
            kind = "breath" if r["ability"].startswith("BREATHE_") else r["ability"].lower()
            bands.setdefault(kind, []).append((b["min"], b["max"]))
        # breath roll < 5, sweep 5..10, roar 10..15; the demon has no sweep
        assert max(hi for _, hi in bands["breath"]) == 5, race
        assert bands.get("sweep", [(5, 10)]) == [(5, 10)], race
        assert bands["roar"] == [(10, 15)], race
        assert ("sweep" in bands) == (race != "DEMON"), race


def test_composition_picks_the_element_for_multi_breath_races():
    for race in ("DRAGON_GENERAL", "DEMON"):
        comp = {
            r["ability"]: set(r["conditions"]["composition"])
            for r in _race_rules(race)
            if "composition" in r["conditions"]
        }
        assert comp == ELEMENT_OF
        mapped = set().union(*ELEMENT_OF.values())
        fallback = [r for r in _race_rules(race) if "not_composition" in r["conditions"]]
        assert len(fallback) == 5
        assert all(set(r["conditions"]["not_composition"]) == mapped for r in fallback)
        # the "other" bodies roll the element: 0 fire, 1 gas, 2 frost, 3 acid, 4 lightning
        order = [r["ability"] for r in sorted(fallback, key=lambda r: r["conditions"]["level_roll"]["min"])]
        assert order == ["BREATHE_FIRE", "BREATHE_GAS", "BREATHE_FROST", "BREATHE_ACID", "BREATHE_LIGHTNING"]
        assert [r["conditions"]["level_roll"]["max"] - r["conditions"]["level_roll"]["min"] for r in fallback] == [1] * 5


def test_single_element_races_breathe_their_own_element():
    own = {"DRAGON_FIRE": "FIRE", "DRAGON_FROST": "FROST", "DRAGON_ACID": "ACID", "DRAGON_GAS": "GAS",
           "DRAGON_LIGHTNING": "LIGHTNING"}
    for race, element in own.items():
        breaths = [r["ability"] for r in _race_rules(race) if r["ability"].startswith("BREATHE_")]
        assert breaths == [f"BREATHE_{element}"]
        assert SEED["race_abilities"][race] == [f"BREATHE_{element}", "SWEEP", "ROAR"]
    for race in DRAGONBORN:
        assert len([r for r in _race_rules(race) if r["ability"].startswith("BREATHE_")]) == 1


def test_races_json_grants_the_same_abilities_for_reimports():
    races = json.loads((ROOT / "data" / "races.json").read_text(encoding="utf-8"))["races"]
    got = {
        r["name"].upper(): [s["skillName"].removeprefix("SKILL_") for s in r.get("skills", [])]
        for r in races
        if r["name"].upper() in SEED["race_abilities"]
    }
    assert got == SEED["race_abilities"]


def test_race_sql_patch_matches_generator_and_is_name_keyed_and_idempotent():
    sql = RACE_SQL_PATH.read_text(encoding="utf-8")
    assert sql == build_race_sql(SEED)
    assert 'CREATE TABLE IF NOT EXISTS "RaceAiRules"' in sql
    assert "ON CONFLICT (race, ability_id) DO NOTHING" in sql
    assert "ON CONFLICT (seed_key) DO UPDATE SET" in sql and "IS DISTINCT FROM EXCLUDED.seed_hash" in sql
    assert 'ADD COLUMN IF NOT EXISTS "min_level" INTEGER' in sql and "SET enabled = false" in sql
    header = "\n".join(line for line in sql.splitlines() if line.startswith("--")).lower()
    assert "insert only if missing" not in header and "reads it only with" not in header
    assert 'JOIN "Ability" a ON a.plain_name = rr.ability_name' in sql
    assert 'JOIN "RaceAbilities" ra ON ra.race = rr.race::"Race" AND ra.ability_id = a.id' in sql
    assert not re.search(r"ability_id\s*=\s*\d", sql)
    # The patch grants the missing breath / sweep / roar rows.
    assert "('DEMON', 'BREATHE_FIRE')" in sql and "('DRAGON_GENERAL', 'SWEEP')" in sql


def test_new_table_matches_the_prisma_model():
    schema = (ROOT.parent / "muditor" / "packages" / "db" / "prisma" / "schema.prisma")
    if not schema.exists():
        pytest.skip("muditor checkout not found")
    text = schema.read_text(encoding="utf-8")
    if "model RaceAiRules" not in text:
        pytest.skip("muditor schema not updated in this checkout")
    block = text[text.index("model RaceAiRules"):]
    block = block[: block.index("\n}\n")]
    for column in ("race", "ability_id", "priority", "chance_pct", "cooldown_s", "conditions", "target", "min_level", "enabled", "seed_key", "seed_hash"):
        assert f'"{column}"' in RACE_SQL_PATH.read_text(encoding="utf-8")
        camel = {"ability_id": "abilityId", "chance_pct": "chancePct", "cooldown_s": "cooldownS", "min_level": "minLevel",
                 "seed_key": "seedKey", "seed_hash": "seedHash"}
        assert column in block or camel.get(column, column) in block


# ---- the review fixes: cooldowns, race min_level, dead rules, ownership keys ------------------


def test_self_heals_have_a_cooldown_so_they_cannot_loop():
    for family in ("cleric", "bard"):
        heals = [
            r for r in SEED["families"][family]
            if r["ability"] in HEALS and r["target"] == "self" and "in_combat" in r.get("conditions", {})
        ]
        assert heals and all(r.get("cooldown_s", 0) >= 10 for r in heals), family


def test_self_heals_share_one_cooldown_group():
    for family in ("cleric", "bard"):
        heals = [
            r for r in SEED["families"][family]
            if r["ability"] in HEALS and r["target"] == "self" and "in_combat" in r.get("conditions", {})
        ]
        assert {r["conditions"].get("cooldown_group") for r in heals} == {"self_heal"}, family
    for bad in ("", "  ", 3, None):
        rule = {"target": "self", "chance_pct": 100, "priority": 1, "conditions": {"cooldown_group": bad}}
        assert any("cooldown_group" in p for p in validate_rule(rule)), bad


def test_both_claim_steps_skip_keys_already_taken():
    guard = "NOT EXISTS (SELECT 1 FROM \"{t}\" k WHERE k.seed_key = s.seed_key)"
    assert guard.format(t="ClassAiRules") in build_statements(SEED)[0]
    assert guard.format(t="RaceAiRules") in build_race_rule_statements(SEED)[0]


def test_race_rules_are_level_gated():
    floor = {"BREATHE": 15, "SWEEP": 15, "ROAR": 15}
    for r in RACE_ROWS:
        need = floor[r["ability"].split("_")[0]]
        assert r.get("min_level", 0) >= need, (r["race"], r["ability"], r.get("min_level"))
    assert {r["min_level"] for r in RACE_ROWS if r["ability"].startswith("BREATHE")} == {15}


def test_dead_rules_are_dropped_and_retired():
    live = {(f, r["ability"]) for f, rs in SEED["families"].items() for r in rs}
    assert ("warrior", "BODYSLAM") not in live and ("sorcerer", "ANIMATE_DEAD") not in live
    retired = {(f, r["ability"]) for f, rs in SEED["retired_families"].items() for r in rs}
    assert retired == {("warrior", "BODYSLAM"), ("sorcerer", "ANIMATE_DEAD"), ("rogue", "HIDE")}
    assert not retired & live
    # No room-targeted rule asks for a peaceful cast: with no opponent there is nothing to resolve.
    for f, rs in SEED["families"].items():
        for r in rs:
            assert not (r["target"] == "room" and r.get("conditions", {}).get("out_of_combat")), (f, r["ability"])


def test_rule_keys_are_unique_and_stable_per_scope():
    for family, rules in SEED["families"].items():
        keys = [rule_key(family, r) for r in rules]
        assert len(keys) == len(set(keys)), (family, [k for k, n in Counter(keys).items() if n > 1])
    race_keys = [r["key"] for r in RACE_ROWS]
    assert len(race_keys) == len(set(race_keys))
    # A key never encodes the priority, so renumbering updates a row instead of duplicating it.
    assert all(not re.search(r":\d+$", k) for k in race_keys)
    assert rule_key("cleric", {"ability": "HARM"}) == "cleric:HARM"


def test_the_three_statements_claim_upsert_and_retire():
    claim, upsert, disable = build_statements(SEED)
    assert 'UPDATE "ClassAiRules" r SET seed_key = s.seed_key' in claim and "r.seed_key IS NULL" in claim
    assert "'warrior', 'warrior:BODYSLAM'" in claim and "BODYSLAM" not in upsert and "BODYSLAM" not in disable
    assert "WHERE \"ClassAiRules\".seed_hash IS NOT DISTINCT FROM md5(" in upsert
    assert "SET enabled = false" in disable and "NOT EXISTS (SELECT 1 FROM seed s WHERE s.seed_key = r.seed_key)" in disable
    race_claim, race_upsert, race_disable = build_race_rule_statements(SEED)
    assert "r.min_level IS NULL" in race_claim and "min_level = EXCLUDED.min_level" in race_upsert
    assert "'DEMON:BREATHE_FIRE:other'" in race_upsert and "SET enabled = false" in race_disable


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


@pytest.fixture(scope="module")
def race_db(db):
    db.execute("SELECT to_regclass('\"RaceAiRules\"')")
    if db.fetchone()[0] is None:
        pytest.skip("RaceAiRules not applied")
    return db


def test_db_race_rules_only_reference_abilities_the_race_grants(race_db):
    race_db.execute(
        'SELECT r.race::text, a.plain_name FROM "RaceAiRules" r JOIN "Ability" a ON a.id = r.ability_id '
        'WHERE NOT EXISTS (SELECT 1 FROM "RaceAbilities" x WHERE x.race = r.race AND x.ability_id = r.ability_id)'
    )
    assert race_db.fetchall() == []


def test_db_every_dragonlike_race_can_breathe(race_db):
    race_db.execute(
        'SELECT r.race::text, count(*) FROM "RaceAiRules" r JOIN "Ability" a ON a.id = r.ability_id '
        "WHERE a.plain_name LIKE 'BREATHE_%' GROUP BY 1"
    )
    got = {race: n for race, n in race_db.fetchall()}
    assert set(got) == set(SEED["race_rules_legacy"]["races"])
    assert got["DRAGON_GENERAL"] == got["DEMON"] == 10


# ---- ownership semantics against the dev database (every change is rolled back) ---------------


@pytest.fixture()
def owned(db):
    """The cursor in a transaction that is always rolled back."""
    db.execute('SELECT 1 FROM information_schema.columns WHERE table_name = \'ClassAiRules\' AND column_name = \'seed_key\'')
    if db.fetchone() is None:
        pytest.skip("seed_key columns not applied")
    db.execute('SELECT count(*) FROM "ClassAiRules"')
    if db.fetchone()[0] == 0:
        pytest.skip("ClassAiRules is empty")
    db.connection.rollback()
    yield db
    db.connection.rollback()


def _run_class_seed(cur):
    for stmt in build_statements(SEED):
        cur.execute(stmt)


def test_db_reseed_is_a_no_op_and_spares_builder_edits(owned):
    _run_class_seed(owned)  # settle: claim anything un-keyed
    owned.execute(
        'SELECT id FROM "ClassAiRules" WHERE seed_key LIKE %s AND seed_hash IS NOT NULL ORDER BY id LIMIT 2',
        ("Cleric/cleric:%",),
    )
    edited, cleared = (row[0] for row in owned.fetchall())
    owned.execute('UPDATE "ClassAiRules" SET chance_pct = 7 WHERE id = %s', (edited,))  # raw SQL edit
    owned.execute('UPDATE "ClassAiRules" SET cooldown_s = 99, seed_hash = NULL WHERE id = %s', (cleared,))  # Muditor edit
    owned.execute("SAVEPOINT s")
    _run_class_seed(owned)
    owned.execute('SELECT id, chance_pct, cooldown_s FROM "ClassAiRules" WHERE id IN (%s, %s)', (edited, cleared))
    got = {i: (c, cd) for i, c, cd in owned.fetchall()}
    assert got[edited][0] == 7 and got[cleared][1] == 99, "builder edits were reverted"
    owned.execute('SELECT count(*) FROM "ClassAiRules" WHERE enabled IS NOT TRUE AND seed_key LIKE %s', ("Cleric/cleric:%",))
    assert owned.fetchone()[0] == 0


def test_db_a_changed_seed_updates_unedited_rows_and_a_renumber_does_not_duplicate(owned):
    _run_class_seed(owned)
    owned.execute('SELECT count(*) FROM "ClassAiRules"')
    before = owned.fetchone()[0]
    owned.execute('SELECT id FROM "ClassAiRules" WHERE seed_key = %s', ("Cleric/cleric:HARM",))
    row = owned.fetchone()
    if row is None:
        pytest.skip("no Cleric HARM rule in this database")
    # Pretend the previous seed had HARM at another priority and a different chance.
    owned.execute(
        'UPDATE "ClassAiRules" SET priority = 9054, chance_pct = 50, '
        "seed_hash = md5(concat_ws('|', ability_id, 9054, 50, cooldown_s, coalesce(conditions::text, ''), target, "
        "coalesce(min_level::text, ''))) WHERE id = %s",
        row,
    )
    _run_class_seed(owned)
    owned.execute('SELECT priority, chance_pct FROM "ClassAiRules" WHERE id = %s', row)
    assert owned.fetchone() == (54, 100)
    owned.execute('SELECT count(*) FROM "ClassAiRules"')
    assert owned.fetchone()[0] == before, "renumbering left a duplicate row"


def test_db_rows_that_left_the_seed_are_disabled_unless_edited(owned):
    _run_class_seed(owned)
    owned.execute('SELECT id FROM "ClassAiRules" WHERE seed_key LIKE %s ORDER BY id LIMIT 2', ("Cleric/cleric:%",))
    gone, kept = (r[0] for r in owned.fetchall())
    owned.execute('UPDATE "ClassAiRules" SET seed_key = %s WHERE id = %s', ("Cleric/cleric:RETIRED", gone))
    owned.execute('UPDATE "ClassAiRules" SET seed_key = %s, seed_hash = NULL WHERE id = %s', ("Cleric/cleric:RETIRED2", kept))
    _run_class_seed(owned)
    owned.execute('SELECT id, enabled FROM "ClassAiRules" WHERE id IN (%s, %s)', (gone, kept))
    assert dict(owned.fetchall()) == {gone: False, kept: True}


# ---- prod reproduction: rows left by the 0917bb0 seed (no keys, no cooldown group) ---------------


def _sql_body(sql: str) -> str:
    return sql.replace("\nBEGIN;\n", "\n").replace("\nCOMMIT;\n", "\n")


def _old_seed_sql() -> str:
    import subprocess

    try:
        out = subprocess.run(
            ["git", "show", "0917bb0:data/sql/2026-10-10-mob-ai-seed.sql"],
            cwd=ROOT, capture_output=True, text=True, check=True,
        ).stdout
    except (subprocess.CalledProcessError, FileNotFoundError):
        pytest.skip("commit 0917bb0 not available")
    return _sql_body(out)


def _group_rows(cur):
    cur.execute(
        'SELECT count(*), count(*) FILTER (WHERE cooldown_s = 12) FROM "ClassAiRules" '
        "WHERE conditions->>'cooldown_group' = 'self_heal'"
    )
    return cur.fetchone()


def test_db_claim_takes_rows_from_the_first_seed_that_lack_the_cooldown_group(owned):
    owned.execute('DELETE FROM "ClassAiRules"')
    owned.execute(_old_seed_sql())
    owned.execute('SELECT count(*) FROM "ClassAiRules"')
    assert owned.fetchone()[0] > 0
    owned.execute('SELECT count(*) FROM "ClassAiRules" WHERE seed_key IS NOT NULL')
    assert owned.fetchone()[0] == 0
    assert _group_rows(owned)[0] == 0
    # A builder edit (a different chance) and a taken key are never claimed.
    owned.execute(
        'UPDATE "ClassAiRules" SET chance_pct = 7 WHERE id = '
        "(SELECT r.id FROM \"ClassAiRules\" r JOIN \"Ability\" a ON a.id = r.ability_id "
        "WHERE a.plain_name = 'CURE_LIGHT' ORDER BY r.id LIMIT 1)"
    )
    owned.execute("SELECT id FROM \"ClassAiRules\" WHERE chance_pct = 7")
    edited = owned.fetchone()[0]

    owned.execute(_sql_body(build_sql(SEED)))
    owned.execute('SELECT count(*) FROM "ClassAiRules" WHERE seed_key IS NULL')
    unkeyed = owned.fetchone()[0]
    owned.execute(
        'SELECT r.id, c.plain_name, a.plain_name FROM "ClassAiRules" r JOIN "Class" c ON c.id = r.class_id '
        'JOIN "Ability" a ON a.id = r.ability_id WHERE r.seed_key IS NULL'
    )
    left = owned.fetchall()
    assert [row[0] for row in left] == [edited], left  # only the builder-edited row stays unkeyed
    assert unkeyed == 1
    total, at_12 = _group_rows(owned)
    assert total > 0 and total == at_12, (total, at_12)
    print(f"self_heal rows with cooldown 12 after the claim: {total}")

    # Every statement of a second run changes nothing.
    for stmt in build_statements(SEED):
        owned.execute(stmt)
        assert owned.rowcount == 0, stmt[-120:]
    assert _group_rows(owned) == (total, at_12)


def test_db_claim_never_takes_a_row_whose_key_is_already_in_use(owned):
    owned.execute('DELETE FROM "ClassAiRules"')
    owned.execute(_old_seed_sql())
    owned.execute(
        'SELECT r.id, c.plain_name FROM "ClassAiRules" r JOIN "Class" c ON c.id = r.class_id '
        'JOIN "Ability" a ON a.id = r.ability_id WHERE a.plain_name = \'HEAL\' AND c.plain_name = \'Cleric\''
    )
    row = owned.fetchone()
    if row is None:
        pytest.skip("no Cleric HEAL rule")
    # The key is already held by another row: the claim must leave the old row alone.
    owned.execute('UPDATE "ClassAiRules" SET seed_key = %s WHERE id = (SELECT id FROM "ClassAiRules" WHERE id <> %s LIMIT 1)',
                  ("Cleric/cleric:HEAL", row[0]))
    claim = build_statements(SEED)[0]
    owned.execute(claim)
    owned.execute('SELECT seed_key FROM "ClassAiRules" WHERE id = %s', (row[0],))
    assert owned.fetchone()[0] is None


# ---- parked rules (enabled=false): rogue THROATCUT / STEAL ----------------------------------------


def test_rogue_opener_skills_are_parked_and_hide_is_retired():
    rogue = {r["ability"]: r for r in SEED["families"]["rogue"]}
    assert "HIDE" not in rogue and "HIDE" in {r["ability"] for r in SEED["retired_families"]["rogue"]}
    parked = {a for a, r in rogue.items() if r.get("enabled") is False}
    assert parked == {"THROATCUT", "STEAL"}
    # Every parked rule is explained in gaps.parked; everything else is live and can fire in a fight.
    assert all(any(g.startswith(a) for g in SEED["gaps"]["parked"]) for a in parked)
    for a, r in rogue.items():
        if a not in parked:
            assert r["conditions"].get("in_combat") is True, a


def test_db_parked_rules_turn_prod_rows_off_once_and_a_builder_can_re_enable(owned):
    owned.execute('DELETE FROM "ClassAiRules"')
    owned.execute(_old_seed_sql())  # a9a5027's behaviour needs keys; start from the first seed and claim
    owned.execute(_sql_body(build_sql(SEED)))
    owned.execute(
        'SELECT r.id, r.enabled, a.plain_name FROM "ClassAiRules" r JOIN "Ability" a ON a.id = r.ability_id '
        "WHERE r.seed_key LIKE '%/rogue:%' AND a.plain_name IN ('THROATCUT', 'STEAL', 'HIDE', 'KICK')"
    )
    got = {name: (i, en) for i, en, name in owned.fetchall()}
    if not {"KICK", "THROATCUT", "STEAL"} <= set(got):
        pytest.skip("no rogue-family class with those skills in this database")
    assert got["KICK"][1] is True
    assert got["THROATCUT"][1] is False and got["STEAL"][1] is False
    assert "HIDE" not in got or got["HIDE"][1] is False  # retired rows are switched off
    # A builder re-enabling a parked rule keeps it on across re-seeds.
    owned.execute('UPDATE "ClassAiRules" SET enabled = true WHERE id = %s', (got["THROATCUT"][0],))
    _run_class_seed(owned)
    owned.execute('SELECT enabled FROM "ClassAiRules" WHERE id = %s', (got["THROATCUT"][0],))
    assert owned.fetchone()[0] is True
    # A second run of a clean seed changes nothing.
    owned.execute('UPDATE "ClassAiRules" SET enabled = false WHERE id = %s', (got["THROATCUT"][0],))
    for stmt in build_statements(SEED):
        owned.execute(stmt)
        assert owned.rowcount == 0, stmt[-120:]
