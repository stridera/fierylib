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
``Ability.plain_name``, never by numeric id, and existing rows are never touched
(``ON CONFLICT DO NOTHING``), so builder edits survive a re-seed.

The same SQL is written to ``data/sql/2026-10-10-mob-ai-seed.sql`` by
:func:`build_sql` (``python -m fierylib.seeders.mob_ai_seeder --write-sql``) for databases
that are patched instead of reseeded.

Known conditions (``crates/mud-world/src/mob_ai_rules.rs``) are validated here so a typo
in the seed fails the unit tests instead of silently dropping the rule at server boot.
"""

import json
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[3]
SEED_JSON = ROOT / "data" / "mob_ai_seed.json"
SQL_PATH = ROOT / "data" / "sql" / "2026-10-10-mob-ai-seed.sql"

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
    "self_has_debuff": "bool",
    "target_lifeforce": "lifeforce",
    "align": "align",
}
LIFEFORCES = {"LIFE", "UNDEAD", "MAGIC", "CELESTIAL", "DEMONIC", "ELEMENTAL"}
ALIGNS = {"good", "neutral", "evil"}
TARGETS = {"auto", "self", "tank", "weakest_attacker", "caster", "most_buffed", "lowest_ally", "room"}


def load_seed() -> dict:
    """The parsed ``data/mob_ai_seed.json``."""
    with open(SEED_JSON, encoding="utf-8") as f:
        return json.load(f)


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
        elif kind == "align" and value not in ALIGNS:
            problems.append(f"{key}: expected good / neutral / evil")
    if rule.get("target") not in TARGETS:
        problems.append(f"unknown target {rule.get('target')!r}")
    if not (isinstance(rule.get("chance_pct"), int) and 0 <= rule["chance_pct"] <= 100):
        problems.append("chance_pct must be 0..100")
    if not isinstance(rule.get("priority"), int):
        problems.append("priority must be an int")
    return problems


def expand(seed: dict | None = None) -> list[dict]:
    """Every (class, rule) pair the seed describes, before the ability join."""
    seed = load_seed() if seed is None else seed
    rows = []
    for class_name, families in seed["classes"].items():
        for family in families:
            for rule in seed["families"][family]:
                rows.append({"class": class_name, "family": family, **rule})
    return rows


def _lit(text: str) -> str:
    return "'" + text.replace("'", "''") + "'"


def _insert_statement(seed: dict) -> str:
    class_rows = [
        f"({_lit(cls)}, {_lit(fam)})" for cls, fams in seed["classes"].items() for fam in fams
    ]
    rule_rows = []
    for family, rules in seed["families"].items():
        for r in rules:
            cond = json.dumps(r.get("conditions") or {}, sort_keys=True)
            cond_sql = "NULL" if cond == "{}" else _lit(cond)
            rule_rows.append(
                f"({_lit(family)}, {_lit(r['ability'])}, {r['priority']}, {r['chance_pct']}, "
                f"{r.get('cooldown_s', 0)}, {cond_sql}, {_lit(r['target'])})"
            )
    return (
        "WITH class_family(class_name, family) AS (VALUES\n    "
        + ",\n    ".join(class_rows)
        + "\n), family_rule(family, ability_name, priority, chance_pct, cooldown_s, conditions, target) AS (VALUES\n    "
        + ",\n    ".join(rule_rows)
        + "\n)\n"
        'INSERT INTO "ClassAiRules" (class_id, ability_id, priority, chance_pct, cooldown_s, conditions, '
        "target, min_level, enabled)\n"
        "SELECT c.id, a.id, fr.priority::int, fr.chance_pct::int, fr.cooldown_s::int, fr.conditions::jsonb,\n"
        "       fr.target, cs.min_level, true\n"
        "FROM class_family cf\n"
        "JOIN family_rule fr ON fr.family = cf.family\n"
        'JOIN "Class" c ON c.plain_name = cf.class_name\n'
        'JOIN "Ability" a ON a.plain_name = fr.ability_name\n'
        'LEFT JOIN "ClassSkills" cs ON cs.class_id = c.id AND cs.ability_id = a.id\n'
        'LEFT JOIN "ClassAbilities" ca ON ca.class_id = c.id AND ca.ability_id = a.id\n'
        "WHERE cs.id IS NOT NULL OR ca.id IS NOT NULL\n"
        "ON CONFLICT (class_id, ability_id, priority) DO NOTHING"
    )


def build_statement(seed: dict | None = None) -> str:
    """The single idempotent INSERT ... SELECT statement (no trailing semicolon)."""
    return _insert_statement(load_seed() if seed is None else seed)


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
        "-- Class.plain_name / Ability.plain_name, never numeric ids. Insert only if missing: existing\n"
        "-- rows, including builder edits, are never touched, so a second run changes 0 rows.\n"
        "-- Race rules (dragon breath, sweep, roar) are NOT covered: ClassAiRules is keyed by class.\n\n"
        "BEGIN;\n\n"
    )
    return header + build_statement(seed) + ";\n\nCOMMIT;\n"


class MobAiSeeder:
    """Writes ``ClassAiRules`` from ``data/mob_ai_seed.json``."""

    def __init__(self, prisma):
        self.prisma = prisma

    async def seed_mob_ai(self, verbose: bool = False) -> dict:
        """Insert every missing rule. Returns ``{"inserted": n, "per_class": {...}}``."""
        seed = load_seed()
        bad = [(r["class"], r["ability"], p) for r in expand(seed) for p in validate_rule(r)]
        if bad:
            raise ValueError(f"invalid mob AI seed rules: {bad[:5]}")
        inserted = await self.prisma.execute_raw(build_statement(seed))
        rows = await self.prisma.query_raw(
            'SELECT c.plain_name AS class_name, count(*)::int AS n FROM "ClassAiRules" r '
            'JOIN "Class" c ON c.id = r.class_id GROUP BY 1 ORDER BY 1'
        )
        per_class = {r["class_name"]: r["n"] for r in rows}
        if verbose:
            for name, n in per_class.items():
                print(f"  {name}: {n} rules")
        return {"inserted": inserted, "per_class": per_class}


def main(argv: list[str]) -> int:
    if "--write-sql" in argv:
        SQL_PATH.write_text(build_sql(), encoding="utf-8")
        print(f"wrote {SQL_PATH}")
        return 0
    print("usage: python -m fierylib.seeders.mob_ai_seeder --write-sql", file=sys.stderr)
    return 2


if __name__ == "__main__":
    raise SystemExit(main(sys.argv[1:]))
