"""Tests for the CreationRecipe data, SQL patch and seeder (no DB)."""

import json
import re
from pathlib import Path

import pytest
from fierylib.seeders.creation_recipe_seeder import (
    CreationRecipeSeeder,
    build_sql,
    load_recipes,
)

ROOT = Path(__file__).resolve().parents[1]
SQL_PATH = ROOT / "data" / "sql" / "2026-10-09-creation-recipes.sql"
_LEGACY_SRC = Path("fierymud_legacy") / "src" / "constants.cpp"
# The legacy checkout is a sibling of the fierylib checkout (or of .worktrees/).
LEGACY_CONSTANTS = next(
    (p / _LEGACY_SRC for p in ROOT.parents[:2] if (p / _LEGACY_SRC).exists()),
    ROOT / _LEGACY_SRC,
)


def test_minor_creation_matches_the_legacy_item_list():
    rows = [r for r in load_recipes() if r["ability"] == "MINOR_CREATION"]
    assert len(rows) == 40
    # Legacy: item i is object 1000 + i, i.e. zone 10 id i; word order is the
    # abbreviation match order.
    for i, r in enumerate(rows):
        assert r["object"] == {"zone": 10, "id": i}
        assert r["class"] is None
    words = [r["keyword"] for r in rows]
    assert words[:3] == ["backpack", "sack", "robe"]
    assert words[12] == "dagger" and words[-1] == "bracer"
    assert len(set(words)) == 40


@pytest.mark.skipif(not LEGACY_CONSTANTS.exists(), reason="legacy checkout not present")
def test_minor_creation_words_match_legacy_constants_cpp():
    src = LEGACY_CONSTANTS.read_text(encoding="utf-8", errors="replace")
    block = re.search(r"minor_creation_items\[\] = \{(.*?)\};", src, re.S).group(1)
    legacy = [w for w in re.findall(r'"([^"\\]+)"', block)]
    ours = [r["keyword"] for r in load_recipes() if r["ability"] == "MINOR_CREATION"]
    assert legacy == ours


def test_create_food_zone_by_class_matches_legacy_spell_creations():
    rows = [r for r in load_recipes() if r["ability"] == "CREATE_FOOD"]
    by_class = {r["class"]: r["object"] for r in rows}
    # magic.cpp spell_creations: Priest 100, Paladin 110, default (Cleric) 120,
    # Anti-Paladin 130, Druid 140. id null = any FOOD object in the zone.
    assert by_class == {
        "Priest": {"zone": 100, "id": None},
        "Paladin": {"zone": 110, "id": None},
        "Anti-Paladin": {"zone": 130, "id": None},
        "Druid": {"zone": 140, "id": None},
        None: {"zone": 120, "id": None},
    }
    assert all(r["keyword"] is None for r in rows)


def test_recipe_keys_are_unique():
    keys = [(r["ability"], r.get("keyword"), r.get("class")) for r in load_recipes()]
    assert len(keys) == len(set(keys))


def test_sql_patch_is_in_sync_with_the_data_file():
    assert SQL_PATH.read_text(encoding="utf-8") == build_sql()


def test_sql_patch_is_idempotent_in_shape():
    sql = SQL_PATH.read_text(encoding="utf-8")
    assert 'CREATE TABLE IF NOT EXISTS "CreationRecipe"' in sql
    assert "CREATE UNIQUE INDEX IF NOT EXISTS" in sql
    assert "NOT EXISTS" in sql and "IS NOT DISTINCT FROM" in sql
    assert "DELETE FROM" not in sql and "TRUNCATE" not in sql and "DROP" not in sql


def test_create_food_fallback_is_pinned_in_abilities_json():
    abilities = json.loads((ROOT / "data" / "abilities.json").read_text(encoding="utf-8"))
    food = next(a for a in abilities if a["plainName"] == "CREATE_FOOD")
    params = food["effects"][0]["params"]
    assert (params["objectZoneId"], params["objectId"]) == (185, 8)
    assert '"objectZoneId": 185, "objectId": 8' in SQL_PATH.read_text(encoding="utf-8")


class _FakePrisma:
    """Counts rows like Postgres would: a (ability, keyword, class) seen before inserts 0."""

    def __init__(self, existing=()):
        self.seen = set(existing)
        self.calls = []

    async def execute_raw(self, sql, ability, keyword, cls, zone, obj):
        self.calls.append((ability, keyword, cls, zone, obj))
        key = (ability, keyword, cls)
        if key in self.seen:
            return 0
        self.seen.add(key)
        return 1


@pytest.mark.asyncio
async def test_seed_inserts_every_row_once_and_is_a_no_op_on_rerun():
    prisma = _FakePrisma()
    stats = await CreationRecipeSeeder(prisma).seed_creation_recipes()
    assert stats == {"inserted": 45, "existing": 0, "total": 45}
    assert prisma.calls[12] == ("MINOR_CREATION", "dagger", None, 10, 12)
    assert ("CREATE_FOOD", None, "Priest", 100, None) in prisma.calls
    again = await CreationRecipeSeeder(prisma).seed_creation_recipes()
    assert again == {"inserted": 0, "existing": 45, "total": 45}
