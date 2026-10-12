"""Command help text seed (data/command_help.json -> Command.help_summary/help_text; no DB)."""

import asyncio
import re
from pathlib import Path

from fierylib.seeders.command_help import (
    CATEGORY,
    COLUMN_DDL,
    DATA_PATH,
    TAG,
    insert_sql,
    load_rows,
    patch_sql,
)
from fierylib.seeders.command_seeder import CommandSeeder

ROOT = Path(__file__).resolve().parents[1]
SQL_PATH = ROOT / "data" / "sql" / "2026-10-12-command-help-text.sql"
CATEGORY_ENUM = {
    "MOVEMENT", "COMBAT", "COMMUNICATION", "OBJECT", "INFORMATION", "SOCIAL",
    "ADMIN", "BUILDING", "SYSTEM", "CLAN", "MAGIC", "SKILLS",
}  # fmt: skip


def test_rows_are_complete_and_unique():
    rows = load_rows()
    names = [r["name"] for r in rows]
    assert len(rows) >= 400
    assert len(names) == len(set(names))
    for r in rows:
        assert r["summary"], r["name"]
        assert r["category"] in CATEGORY, r["name"]
        assert TAG not in r["summary"] + r["long"] + r["usage"], r["name"]


def test_category_map_targets_real_enum_values():
    assert set(CATEGORY.values()) <= CATEGORY_ENUM


def test_sql_patch_is_in_sync_with_json():
    # Regenerate with `poetry run python scripts/gen_command_help_sql.py`.
    assert SQL_PATH.read_bytes().decode("utf-8") == patch_sql(load_rows(DATA_PATH))


def test_sql_patch_is_transactional_idempotent_and_builder_safe():
    sql = SQL_PATH.read_text(encoding="utf-8")
    assert sql.count("BEGIN;") == 1 and sql.rstrip().endswith("COMMIT;")
    assert all(ddl in sql for ddl in COLUMN_DDL)
    assert 'ON CONFLICT ("name") DO UPDATE' in sql
    # Only fills NULL/empty help columns; description/usage of existing rows are untouched.
    assert sql.count('COALESCE("Command"."help_') == 2
    update = sql.split("DO UPDATE SET")[1]
    assert not re.search(r'"(description|usage|category|aliases)"\s*=', update)


def test_dollar_quoting_preserves_text_exactly():
    rows = [
        {
            "name": "x", "aliases": ["y"], "category": "Info", "min_role": "Player",
            "usage": "x", "summary": "It's a \\ test", "long": "line1\nline2 'q' \"d\"",
        }
    ]  # fmt: skip
    rows[0]["category"] = "Information"
    sql = insert_sql(rows)
    assert f"{TAG}It's a \\ test{TAG}" in sql
    assert f"{TAG}line1\nline2 'q' \"d\"{TAG}" in sql


def test_seeder_runs_ddl_then_one_insert():
    calls = []

    class FakePrisma:
        async def execute_raw(self, sql):
            calls.append(sql)

    n = asyncio.run(CommandSeeder(FakePrisma()).seed_help_text())
    assert n == len(load_rows())
    assert calls[:2] == COLUMN_DDL
    assert len(calls) == 3 and calls[2].startswith('INSERT INTO "Command"')
