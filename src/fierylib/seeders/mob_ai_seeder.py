"""Mob spellcasting / skill AI rule seeder (WP-B of ops/plans/mob-ai.md).

Fills ``ClassAiRules`` from ``data/mob_ai_seed.json``, a hand port of the legacy
hard-coded mob AI lists (``cleric.cpp``, ``sorcerer.cpp``/``.hpp``, ``rogue.cpp``/``.hpp``,
``warrior.cpp``, ``mobact.cpp``). The seed is organised in *families* (cleric, sorcerer,
bard, rogue, warrior) plus a ``classes`` map from ``Class.plain_name`` to the families it
runs, so the hybrid Ranger / Paladin / Anti-Paladin run the cleric rules and then the
warrior rules, as legacy ``mob_attack`` did.

A rule is created only when the class really has the ability: in ``ClassAbilities``
(spells, songs, chants) or in ``ClassSkills`` (skills; the skill's ``min_level`` becomes
``ClassAiRules.min_level``). Everything is keyed by ``Class.plain_name`` and
``Ability.plain_name``, never by numeric id. The seed owns the rows it defines: a re-seed updates
a row whose chance / cooldown / conditions / target / min_level differ from the seed (and changes
nothing when they match); ``enabled`` is never touched.

Ownership. Every seed rule has a stable key (:func:`rule_key`: the rule's ``key`` or
``<family>:<ABILITY>``; race rules ``<RACE>:<ABILITY>``) stored in ``seed_key`` (class rows:
``<Class.plain_name>/<key>``) together with ``seed_hash``, a hash of the values the seeder last
wrote. A re-seed (1) claims existing un-keyed rows that still match the seed, (2) upserts on
``seed_key``, updating only a row whose stored hash equals the hash of its current values, so a row
a builder edited since the last seed (Muditor clears ``seed_hash``; a direct SQL edit makes the
hashes differ) is left alone, and (3) disables seed-owned rows whose key left the seed. Renumbering
a priority therefore updates the row instead of leaving a duplicate.

The same SQL is written to ``data/sql/2026-10-10-mob-ai-seed.sql`` by
:func:`build_sql` (``python -m fierylib.seeders.mob_ai_seeder --write-sql``) for databases
that are patched instead of reseeded.

Race rules (dragon / demon breath, sweep, roar: legacy ``dragonlike_attack``) live in the
seed's ``race_rules`` and fill ``RaceAiRules``; ``race_abilities`` lists the ``RaceAbilities``
rows the races need so the rules can fire (legacy ``races.cpp`` ``assign_race_skills``). Both go
into ``data/sql/2026-10-10-mob-ai-race.sql``, which also creates the table.

Known conditions (``crates/mud-world/src/mob_ai_rules.rs``) are validated here so a typo
in the seed fails the unit tests instead of silently dropping the rule at server boot.
"""

import json
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[3]
SEED_JSON = ROOT / "data" / "mob_ai_seed.json"
SQL_PATH = ROOT / "data" / "sql" / "2026-10-10-mob-ai-seed.sql"
RACE_SQL_PATH = ROOT / "data" / "sql" / "2026-10-10-mob-ai-race.sql"

#: ``conditions`` keys the Rust loader understands, with the value kinds it accepts.
CONDITION_KEYS: dict[str, str] = {
    "in_combat": "bool",
    "out_of_combat": "bool",
    "self_hp_below": "percent",
    "target_hp_below": "percent",
    "ally_hp_below": "percent",
    "grouped_targets": "count_or_true",
    "target_casting": "bool",
    "target_has_buff": "bool",
    "target_hp_above": "percent",
    "self_has_debuff": "debuff",
    "target_lifeforce": "lifeforce",
    "not_lifeforce": "lifeforce_list",
    "align": "align",
    "not_align": "align",
    "self_align": "align_list",
    "target_level_max": "int",
    "level_scaled_chance": "factor",
    "level_roll": "level_roll",
    "composition": "composition_list",
    "not_composition": "composition_list",
    "requires_shield": "bool",
    "requires_weapon_type": "weapon_type",
    "outdoors": "bool",
    "telegraph": "bool",
}
LIFEFORCES = {"LIFE", "UNDEAD", "MAGIC", "CELESTIAL", "DEMONIC", "ELEMENTAL"}
COMPOSITIONS = {
    "FLESH", "EARTH", "AIR", "FIRE", "WATER", "ICE", "MIST", "ETHER", "METAL", "STONE", "BONE", "LAVA", "PLANT",
}
ALIGNS = {"good", "neutral", "evil"}
TARGETS = {"auto", "self", "tank", "weakest_attacker", "caster", "most_buffed", "lowest_ally", "room"}


def load_seed() -> dict:
    """The parsed ``data/mob_ai_seed.json``."""
    with open(SEED_JSON, encoding="utf-8") as f:
        return json.load(f)


def _names(value) -> list | None:
    """A string or a non-empty list of strings as a list; ``None`` if it is neither."""
    if isinstance(value, str):
        return [value]
    if isinstance(value, list) and value and all(isinstance(v, str) for v in value):
        return value
    return None


def validate_rule(rule: dict) -> list[str]:
    """Problems with one seed rule (empty when it is usable)."""
    problems = []
    for key, value in (rule.get("conditions") or {}).items():
        kind = CONDITION_KEYS.get(key)
        if kind is None:
            problems.append(f"unknown condition {key!r}")
        elif kind == "bool" and not isinstance(value, bool):
            problems.append(f"{key}: expected a bool")
        elif kind == "percent" and not (isinstance(value, int) and 0 <= value <= 100):
            problems.append(f"{key}: expected 0..100")
        elif kind == "count_or_true" and not (value is True or (isinstance(value, int) and value >= 1)):
            problems.append(f"{key}: expected true or a count >= 1")
        elif kind == "lifeforce" and value not in LIFEFORCES:
            problems.append(f"{key}: unknown life force {value!r}")
        elif kind == "lifeforce_list" and not ((names := _names(value)) and set(names) <= LIFEFORCES):
            problems.append(f"{key}: expected life force name(s)")
        elif kind == "align" and value not in ALIGNS:
            problems.append(f"{key}: expected good / neutral / evil")
        elif kind == "align_list" and not ((names := _names(value)) and set(names) <= ALIGNS):
            problems.append(f"{key}: expected band name(s) from good / neutral / evil")
        elif kind == "int" and not (isinstance(value, int) and not isinstance(value, bool)):
            problems.append(f"{key}: expected an integer")
        elif kind == "debuff" and not (value is True or _names(value)):
            problems.append(f"{key}: expected true, a debuff name, or a list of names")
        elif kind == "factor" and not (
            value is True or (isinstance(value, (int, float)) and not isinstance(value, bool) and 0 < value <= 100)
        ):
            problems.append(f"{key}: expected true or a positive factor")
        elif kind == "level_roll" and not (
            isinstance(value, dict)
            and isinstance(value.get("min"), int)
            and isinstance(value.get("max"), int)
            and 0 <= value["min"] <= value["max"] <= 1000
        ):
            problems.append(f"{key}: expected {{min, max}} with 0 <= min <= max")
        elif kind == "composition_list" and not ((names := _names(value)) and set(names) <= COMPOSITIONS):
            problems.append(f"{key}: expected Composition name(s)")
        elif kind == "weapon_type" and not (isinstance(value, str) and value.strip()):
            problems.append(f"{key}: expected a weapon damage type")
    if rule.get("target") not in TARGETS:
        problems.append(f"unknown target {rule.get('target')!r}")
    if not (isinstance(rule.get("chance_pct"), int) and 0 <= rule["chance_pct"] <= 100):
        problems.append("chance_pct must be 0..100")
    if not isinstance(rule.get("priority"), int):
        problems.append("priority must be an int")
    return problems


def rule_key(scope: str, rule: dict) -> str:
    """The stable key of a seed rule: its ``key``, else ``<scope>:<ABILITY>``.

    ``scope`` is the family for class rules and the race for race rules. A family that repeats an
    ability must give every repeat after the first an explicit ``key`` (the tests enforce it).
    """
    return rule.get("key") or f"{scope}:{rule['ability']}"


def expand(seed: dict | None = None) -> list[dict]:
    """Every (class, rule) pair the seed describes, before the ability join."""
    seed = load_seed() if seed is None else seed
    rows = []
    for class_name, families in seed["classes"].items():
        for family in families:
            for rule in seed["families"][family]:
                rows.append({"class": class_name, "family": family, **rule, "key": rule_key(family, rule)})
    return rows


def expand_race_rules(seed: dict | None = None) -> list[dict]:
    """Every race rule the seed describes, before the ability join."""
    seed = load_seed() if seed is None else seed
    return [{**r, "key": rule_key(r["race"], r)} for r in seed.get("race_rules", [])]


def _lit(text: str) -> str:
    return "'" + text.replace("'", "''") + "'"


def _hash_expr(ref: str) -> str:
    """SQL hash of the seed-owned values of a rule row (or seed CTE row) named ``ref``.

    The same expression hashes the seed's values and a row's current values, so "has the row been
    edited since the seed wrote it" is a plain comparison done by the database (jsonb renders
    canonically, so the Python side never has to reproduce it).
    """
    return (
        f"md5(concat_ws('|', {ref}.ability_id, {ref}.priority, {ref}.chance_pct, {ref}.cooldown_s, "
        f"coalesce({ref}.conditions::text, ''), {ref}.target, coalesce({ref}.min_level::text, '')))"
    )


def _cond_sql(rule: dict) -> str:
    cond = json.dumps(rule.get("conditions") or {}, sort_keys=True)
    return "NULL" if cond == "{}" else _lit(cond)


CLASS_SCHEMA_SQL = """\
ALTER TABLE "ClassAiRules"
    ADD COLUMN IF NOT EXISTS "seed_key" TEXT,
    ADD COLUMN IF NOT EXISTS "seed_hash" TEXT;

CREATE UNIQUE INDEX IF NOT EXISTS "ClassAiRules_seed_key_key" ON "ClassAiRules"("seed_key")"""


def _class_seed_cte(seed: dict, retired: bool = False) -> str:
    """``WITH ... seed AS (...)``: every rule the seed describes, resolved to ids, with its hash.

    ``retired`` adds the seed's ``retired_families`` rules (only the claim step wants them).
    """
    class_rows = [
        f"({_lit(cls)}, {_lit(fam)})" for cls, fams in seed["classes"].items() for fam in fams
    ]
    rule_rows = []
    groups = list(seed["families"].items())
    if retired:
        groups += list(seed.get("retired_families", {}).items())
    for family, rules in groups:
        for r in rules:
            rule_rows.append(
                f"({_lit(family)}, {_lit(rule_key(family, r))}, {_lit(r['ability'])}, {r['priority']}, "
                f"{r['chance_pct']}, {r.get('cooldown_s', 0)}, {_cond_sql(r)}, {_lit(r['target'])})"
            )
    return (
        "WITH class_family(class_name, family) AS (VALUES\n    "
        + ",\n    ".join(class_rows)
        + "\n), family_rule(family, rule_key, ability_name, priority, chance_pct, cooldown_s, conditions, target)"
        " AS (VALUES\n    "
        + ",\n    ".join(rule_rows)
        + "\n), raw AS (\n"
        "    SELECT cf.class_name || '/' || fr.rule_key AS seed_key, c.id AS class_id, a.id AS ability_id,\n"
        "           fr.priority::int AS priority, fr.chance_pct::int AS chance_pct, fr.cooldown_s::int AS cooldown_s,\n"
        "           fr.conditions::jsonb AS conditions, fr.target AS target, cs.min_level AS min_level\n"
        "    FROM class_family cf\n"
        "    JOIN family_rule fr ON fr.family = cf.family\n"
        '    JOIN "Class" c ON c.plain_name = cf.class_name\n'
        '    JOIN "Ability" a ON a.plain_name = fr.ability_name\n'
        '    LEFT JOIN "ClassSkills" cs ON cs.class_id = c.id AND cs.ability_id = a.id\n'
        '    LEFT JOIN "ClassAbilities" ca ON ca.class_id = c.id AND ca.ability_id = a.id\n'
        "    WHERE cs.id IS NOT NULL OR ca.id IS NOT NULL\n"
        "), seed AS (\n"
        f"    SELECT raw.*, {_hash_expr('raw')} AS seed_hash FROM raw\n"
        ")\n"
    )


def build_statements(seed: dict | None = None) -> list[str]:
    """The three idempotent ``ClassAiRules`` statements, in order (no trailing semicolons).

    1. claim: an existing un-keyed row that still matches the seed (a row written before the
       seed had keys; a cooldown of 0 counts as matching, it was the value before cooldowns were
       seeded) gets its ``seed_key`` and the hash of its current values, so it is seed-owned;
    2. upsert on ``seed_key``: new rules are inserted; an existing one is updated only while its
       stored hash equals the hash of its current values (NULL hash = builder-owned) and differs
       from the seed's. A seed slot (class, ability, priority) held by a different row is skipped;
    3. disable seed-owned, unedited rows whose key is no longer in the seed (the claim also takes
       the seed's ``retired_families`` rules, so a rule dropped from the seed is claimed, then
       disabled, in a database seeded before it was dropped).
    """
    seed = load_seed() if seed is None else seed
    cte = _class_seed_cte(seed)
    t = '"ClassAiRules"'
    claim = (
        _class_seed_cte(seed, retired=True) + f"UPDATE {t} r SET seed_key = s.seed_key, seed_hash = {_hash_expr('r')}\n"
        "FROM seed s\n"
        "WHERE r.seed_key IS NULL AND r.class_id = s.class_id AND r.ability_id = s.ability_id\n"
        "  AND r.priority = s.priority AND r.chance_pct = s.chance_pct\n"
        "  AND r.conditions IS NOT DISTINCT FROM s.conditions AND r.target = s.target\n"
        "  AND r.min_level IS NOT DISTINCT FROM s.min_level\n"
        "  AND (r.cooldown_s = s.cooldown_s OR r.cooldown_s = 0)\n"
        f"  AND NOT EXISTS (SELECT 1 FROM {t} k WHERE k.seed_key = s.seed_key)"
    )
    upsert = (
        cte + f"INSERT INTO {t} (class_id, ability_id, priority, chance_pct, cooldown_s, conditions,\n"
        "    target, min_level, enabled, seed_key, seed_hash)\n"
        "SELECT s.class_id, s.ability_id, s.priority, s.chance_pct, s.cooldown_s, s.conditions,\n"
        "       s.target, s.min_level, true, s.seed_key, s.seed_hash\n"
        "FROM seed s\n"
        f"WHERE NOT EXISTS (SELECT 1 FROM {t} x WHERE x.class_id = s.class_id AND x.ability_id = s.ability_id\n"
        "                  AND x.priority = s.priority AND x.seed_key IS DISTINCT FROM s.seed_key)\n"
        "ON CONFLICT (seed_key) DO UPDATE SET\n"
        "    ability_id = EXCLUDED.ability_id, priority = EXCLUDED.priority, chance_pct = EXCLUDED.chance_pct,\n"
        "    cooldown_s = EXCLUDED.cooldown_s, conditions = EXCLUDED.conditions, target = EXCLUDED.target,\n"
        "    min_level = EXCLUDED.min_level, seed_hash = EXCLUDED.seed_hash\n"
        f"WHERE {t}.seed_hash IS NOT DISTINCT FROM {_hash_expr(t)}\n"
        f"  AND {t}.seed_hash IS DISTINCT FROM EXCLUDED.seed_hash"
    )
    disable = (
        cte + f"UPDATE {t} r SET enabled = false\n"
        f"WHERE r.seed_key IS NOT NULL AND r.enabled AND r.seed_hash IS NOT DISTINCT FROM {_hash_expr('r')}\n"
        "  AND NOT EXISTS (SELECT 1 FROM seed s WHERE s.seed_key = r.seed_key)"
    )
    return [claim, upsert, disable]


RACE_SCHEMA_SQL = """\
CREATE TABLE IF NOT EXISTS "RaceAiRules" (
    "id" SERIAL NOT NULL,
    "race" "Race" NOT NULL,
    "ability_id" INTEGER NOT NULL,
    "priority" INTEGER NOT NULL,
    "chance_pct" INTEGER NOT NULL DEFAULT 100,
    "cooldown_s" INTEGER NOT NULL DEFAULT 0,
    "conditions" JSONB,
    "target" TEXT NOT NULL,
    "min_level" INTEGER,
    "enabled" BOOLEAN NOT NULL DEFAULT true,
    "seed_key" TEXT,
    "seed_hash" TEXT,

    CONSTRAINT "RaceAiRules_pkey" PRIMARY KEY ("id")
);

-- A table created by an earlier version of this patch lacks the newer columns.
ALTER TABLE "RaceAiRules"
    ADD COLUMN IF NOT EXISTS "min_level" INTEGER,
    ADD COLUMN IF NOT EXISTS "seed_key" TEXT,
    ADD COLUMN IF NOT EXISTS "seed_hash" TEXT;

CREATE INDEX IF NOT EXISTS "RaceAiRules_race_idx" ON "RaceAiRules"("race");

CREATE UNIQUE INDEX IF NOT EXISTS "RaceAiRules_race_ability_id_priority_key"
    ON "RaceAiRules"("race", "ability_id", "priority");

CREATE UNIQUE INDEX IF NOT EXISTS "RaceAiRules_seed_key_key" ON "RaceAiRules"("seed_key");

DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'RaceAiRules_race_fkey') THEN
        ALTER TABLE "RaceAiRules" ADD CONSTRAINT "RaceAiRules_race_fkey"
            FOREIGN KEY ("race") REFERENCES "Races"("race") ON DELETE CASCADE ON UPDATE CASCADE;
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'RaceAiRules_ability_id_fkey') THEN
        ALTER TABLE "RaceAiRules" ADD CONSTRAINT "RaceAiRules_ability_id_fkey"
            FOREIGN KEY ("ability_id") REFERENCES "Ability"("id") ON DELETE CASCADE ON UPDATE CASCADE;
    END IF;
END
$$"""


def build_race_ability_statement(seed: dict | None = None) -> str:
    """Idempotent INSERT of the ``RaceAbilities`` rows the race rules need (no trailing semicolon)."""
    seed = load_seed() if seed is None else seed
    rows = [
        f"({_lit(race)}, {_lit(ability)})"
        for race, abilities in seed.get("race_abilities", {}).items()
        for ability in abilities
    ]
    return (
        'INSERT INTO "RaceAbilities" (race, ability_id, category, bonus, proficiency_cap)\n'
        "SELECT v.race::\"Race\", a.id, 'PRIMARY', 0, 100\n"
        "FROM (VALUES\n    " + ",\n    ".join(rows) + "\n) AS v(race, ability_name)\n"
        'JOIN "Ability" a ON a.plain_name = v.ability_name\n'
        "ON CONFLICT (race, ability_id) DO NOTHING"
    )


def _race_seed_cte(seed: dict) -> str:
    rows = [
        f"({_lit(r['race'])}, {_lit(r['key'])}, {_lit(r['ability'])}, {r['priority']}, {r['chance_pct']}, "
        f"{r.get('cooldown_s', 0)}, {_cond_sql(r)}, {_lit(r['target'])}, {r.get('min_level', 'NULL')})"
        for r in expand_race_rules(seed)
    ]
    return (
        "WITH race_rule(race, rule_key, ability_name, priority, chance_pct, cooldown_s, conditions, target, min_level)"
        " AS (VALUES\n    "
        + ",\n    ".join(rows)
        + "\n), raw AS (\n"
        '    SELECT rr.race::"Race" AS race, rr.rule_key AS seed_key, a.id AS ability_id, rr.priority::int AS priority,\n'
        "           rr.chance_pct::int AS chance_pct, rr.cooldown_s::int AS cooldown_s,\n"
        "           rr.conditions::jsonb AS conditions, rr.target AS target, rr.min_level::int AS min_level\n"
        "    FROM race_rule rr\n"
        '    JOIN "Ability" a ON a.plain_name = rr.ability_name\n'
        '    JOIN "RaceAbilities" ra ON ra.race = rr.race::"Race" AND ra.ability_id = a.id\n'
        "), seed AS (\n"
        f"    SELECT raw.*, {_hash_expr('raw')} AS seed_hash FROM raw\n"
        ")\n"
    )


def build_race_rule_statements(seed: dict | None = None) -> list[str]:
    """The three idempotent ``RaceAiRules`` statements (claim, upsert, disable; see
    :func:`build_statements`). A rule is created only for a race that has the ability in
    ``RaceAbilities`` (so the sweep and roar rules of a DRAGONBORN, which has neither, are dropped).
    """
    seed = load_seed() if seed is None else seed
    cte = _race_seed_cte(seed)
    t = '"RaceAiRules"'
    claim = (
        cte + f"UPDATE {t} r SET seed_key = s.seed_key, seed_hash = {_hash_expr('r')}\n"
        "FROM seed s\n"
        "WHERE r.seed_key IS NULL AND r.race = s.race AND r.ability_id = s.ability_id\n"
        "  AND r.priority = s.priority AND r.chance_pct = s.chance_pct\n"
        "  AND r.conditions IS NOT DISTINCT FROM s.conditions AND r.target = s.target\n"
        "  AND (r.cooldown_s = s.cooldown_s OR r.cooldown_s = 0)\n"
        "  AND (r.min_level IS NOT DISTINCT FROM s.min_level OR r.min_level IS NULL)\n"
        f"  AND NOT EXISTS (SELECT 1 FROM {t} k WHERE k.seed_key = s.seed_key)"
    )
    upsert = (
        cte + f"INSERT INTO {t} (race, ability_id, priority, chance_pct, cooldown_s, conditions,\n"
        "    target, min_level, enabled, seed_key, seed_hash)\n"
        "SELECT s.race, s.ability_id, s.priority, s.chance_pct, s.cooldown_s, s.conditions,\n"
        "       s.target, s.min_level, true, s.seed_key, s.seed_hash\n"
        "FROM seed s\n"
        f"WHERE NOT EXISTS (SELECT 1 FROM {t} x WHERE x.race = s.race AND x.ability_id = s.ability_id\n"
        "                  AND x.priority = s.priority AND x.seed_key IS DISTINCT FROM s.seed_key)\n"
        "ON CONFLICT (seed_key) DO UPDATE SET\n"
        "    race = EXCLUDED.race, ability_id = EXCLUDED.ability_id, priority = EXCLUDED.priority,\n"
        "    chance_pct = EXCLUDED.chance_pct, cooldown_s = EXCLUDED.cooldown_s, conditions = EXCLUDED.conditions,\n"
        "    target = EXCLUDED.target, min_level = EXCLUDED.min_level, seed_hash = EXCLUDED.seed_hash\n"
        f"WHERE {t}.seed_hash IS NOT DISTINCT FROM {_hash_expr(t)}\n"
        f"  AND {t}.seed_hash IS DISTINCT FROM EXCLUDED.seed_hash"
    )
    disable = (
        cte + f"UPDATE {t} r SET enabled = false\n"
        f"WHERE r.seed_key IS NOT NULL AND r.enabled AND r.seed_hash IS NOT DISTINCT FROM {_hash_expr('r')}\n"
        "  AND NOT EXISTS (SELECT 1 FROM seed s WHERE s.seed_key = r.seed_key)"
    )
    return [claim, upsert, disable]


def build_race_sql(seed: dict | None = None) -> str:
    """The full idempotent SQL patch for ``data/sql/2026-10-10-mob-ai-race.sql``."""
    seed = load_seed() if seed is None else seed
    header = (
        "-- Mob AI: race rules (dragon / demon breath, sweep, roar), WP-D of ops/plans/mob-ai.md.\n"
        "--\n"
        "-- Legacy dragonlike_attack (mobact.cpp): roll = rand(0, 150 - level); breath if roll < 5, sweep if\n"
        "-- roll < 10, roar if roll < 15, for the DRAGON_* / DRAGONBORN_* races and DEMON. The element comes\n"
        "-- from the body composition (earth/stone acid, air/ether lightning, fire/lava fire, water/ice/mist\n"
        "-- frost, metal/bone/plant gas), any other composition rolls it. The rules express the bands with the\n"
        "-- level_roll condition (one shared roll per mob per round) and the element with composition /\n"
        "-- not_composition. min_level keeps a low-level demon from breathing, sweeping or roaring.\n"
        "--\n"
        "--   1. creates \"RaceAiRules\" or adds its min_level / seed_key / seed_hash columns (matches muditor\n"
        "--      packages/db/prisma/schema.prisma, db push compatible),\n"
        "--   2. adds the RaceAbilities rows the races lack (legacy races.cpp assign_race_skills): the DRAGON_*\n"
        "--      races and DEMON had no BREATHE_* / SWEEP / ROAR row; DRAGONBORN_* already have their breath,\n"
        "--   3. seeds the rules.\n"
        "-- Generated by `python -m fierylib.seeders.mob_ai_seeder --write-sql` from data/mob_ai_seed.json; a\n"
        "-- unit test keeps the two in sync. Standalone (own table); the server loads it at every boot but uses\n"
        "-- it only with mob_ai.enabled on. Keyed by Races.race (enum) and Ability.plain_name, never numeric ids.\n"
        "--\n"
        "-- Ownership: each rule has a stable seed_key and a seed_hash of the values it last wrote. Step 3\n"
        "-- (a) claims existing un-keyed rows that still match the seed, (b) upserts on seed_key, updating a\n"
        "-- row only while its stored hash equals the hash of its current values, so a builder-edited row\n"
        "-- (hash cleared or stale) is left alone, and (c) disables seed-owned rows whose key left the seed.\n"
        "-- A second run changes 0 rows.\n\n"
        "BEGIN;\n\n"
    )
    stmts = build_race_rule_statements(seed)
    return (
        header
        + RACE_SCHEMA_SQL
        + ";\n\n"
        + build_race_ability_statement(seed)
        + ";\n\n"
        + ";\n\n".join(stmts)
        + ";\n\nCOMMIT;\n"
    )


def build_sql(seed: dict | None = None) -> str:
    """The full idempotent SQL patch for ``data/sql/2026-10-10-mob-ai-seed.sql``."""
    seed = load_seed() if seed is None else seed
    header = (
        "-- Mob AI: ClassAiRules seed (WP-B of ops/plans/mob-ai.md).\n"
        "--\n"
        "-- Hand-ported from the legacy hard-coded mob AI lists (cleric.cpp, sorcerer.cpp, rogue.cpp,\n"
        "-- warrior.cpp, mobact.cpp) into per-class rule lists. Generated by\n"
        "-- `python -m fierylib.seeders.mob_ai_seeder --write-sql` from data/mob_ai_seed.json; a unit\n"
        "-- test keeps the two in sync. Requires 2026-10-10-mob-ai-schema.sql.\n"
        "--\n"
        "-- A rule is created only for a class that really has the ability (ClassAbilities for spells,\n"
        "-- songs and chants, ClassSkills for skills; the skill's min_level becomes min_level). Keyed by\n"
        "-- Class.plain_name / Ability.plain_name, never numeric ids.\n"
        "--\n"
        "-- Ownership: every seed rule has a stable seed_key (<Class>/<family>:<ABILITY>) and a seed_hash of\n"
        "-- the values it last wrote (chance, cooldown, conditions, target, min_level, priority, ability;\n"
        "-- `enabled` is not part of it). The three statements (a) claim existing un-keyed rows that still\n"
        "-- match the seed, (b) upsert on seed_key, updating a row only while its stored hash equals the\n"
        "-- hash of its current values, so a row a builder edited (Muditor clears seed_hash) is left alone and\n"
        "-- renumbering a priority updates the row instead of duplicating it, and (c) disable seed-owned\n"
        "-- rows whose key left the seed. Builder-created rows have no seed_key. A second run changes 0 rows.\n"
        "-- Race rules (dragon breath, sweep, roar) are in 2026-10-10-mob-ai-race.sql.\n\n"
        "BEGIN;\n\n"
    )
    return header + CLASS_SCHEMA_SQL + ";\n\n" + ";\n\n".join(build_statements(seed)) + ";\n\nCOMMIT;\n"


class MobAiSeeder:
    """Writes ``ClassAiRules`` from ``data/mob_ai_seed.json``."""

    def __init__(self, prisma):
        self.prisma = prisma

    async def seed_mob_ai(self, verbose: bool = False) -> dict:
        """Claim, upsert and retire the seed rules (see the module docstring)."""
        seed = load_seed()
        bad = [(r["class"], r["ability"], p) for r in expand(seed) for p in validate_rule(r)]
        bad += [(r["race"], r["ability"], p) for r in expand_race_rules(seed) for p in validate_rule(r)]
        if bad:
            raise ValueError(f"invalid mob AI seed rules: {bad[:5]}")
        # Counts are rows touched by claim + upsert + disable (a re-seed of an unchanged seed is 0).
        inserted = sum([await self.prisma.execute_raw(q) for q in build_statements(seed)])
        race_abilities = await self.prisma.execute_raw(build_race_ability_statement(seed))
        race_rules = sum([await self.prisma.execute_raw(q) for q in build_race_rule_statements(seed)])
        rows = await self.prisma.query_raw(
            'SELECT c.plain_name AS class_name, count(*)::int AS n FROM "ClassAiRules" r '
            'JOIN "Class" c ON c.id = r.class_id GROUP BY 1 ORDER BY 1'
        )
        per_class = {r["class_name"]: r["n"] for r in rows}
        if verbose:
            for name, n in per_class.items():
                print(f"  {name}: {n} rules")
        return {
            "inserted": inserted,
            "per_class": per_class,
            "race_abilities_inserted": race_abilities,
            "race_rules_inserted": race_rules,
        }


def main(argv: list[str]) -> int:
    if "--write-sql" in argv:
        SQL_PATH.write_text(build_sql(), encoding="utf-8")
        RACE_SQL_PATH.write_text(build_race_sql(), encoding="utf-8")
        print(f"wrote {SQL_PATH}\nwrote {RACE_SQL_PATH}")
        return 0
    print("usage: python -m fierylib.seeders.mob_ai_seeder --write-sql", file=sys.stderr)
    return 2


if __name__ == "__main__":
    raise SystemExit(main(sys.argv[1:]))
