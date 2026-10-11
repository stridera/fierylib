"""Tests for the reserved names data, SQL patch and seeder (no DB)."""

import asyncio
import re
from pathlib import Path

from fierylib.seeders.reserved_names_seeder import (
    ReservedNamesSeeder,
    build_sql,
    build_statements,
    load_reserved_names,
)

ROOT = Path(__file__).resolve().parents[1]
SQL_PATH = ROOT / "data" / "sql" / "2026-10-10-reserved-names.sql"
# Fixed in the game's code (command parser); must never be rows.
TARGET_WORDS = {"all", "self", "me", "everyone", "someone", "something", "here"}


def test_sql_patch_matches_the_json():
    assert SQL_PATH.read_text(encoding="utf-8") == build_sql()


def test_rows_are_the_curated_list():
    rows = load_reserved_names()
    names = [n for n, _ in rows]
    assert len(rows) == 22
    assert len(set(names)) == len(names), "name is unique"
    assert all(n == n.lower() and n.strip() == n and n for n in names)
    assert all(reason for _, reason in rows)
    assert {"beggar", "citizen", "guard", "merchant", "admin", "system"} <= set(names)


def test_target_words_stay_in_code():
    assert not TARGET_WORDS & {n for n, _ in load_reserved_names()}


def test_every_statement_is_idempotent():
    for stmt in build_statements():
        if stmt.startswith("INSERT"):
            assert 'ON CONFLICT ("name") DO NOTHING' in stmt
        else:
            assert "IF NOT EXISTS" in stmt, stmt[:60]


def test_sql_is_one_transaction_of_semicolon_terminated_statements():
    sql = SQL_PATH.read_text(encoding="utf-8")
    body = re.sub(r"^--.*$", "", sql, flags=re.M).strip()
    assert body.startswith("BEGIN;") and body.endswith("COMMIT;")


class _FakePrisma:
    def __init__(self):
        self.calls = []

    async def execute_raw(self, stmt, *args):
        self.calls.append((stmt, args))
        return 1


def test_seeder_runs_every_statement():
    fake = _FakePrisma()
    stats = asyncio.run(ReservedNamesSeeder(fake).seed_reserved_names())
    assert [c[0] for c in fake.calls] == build_statements()
    assert stats == {"statements": len(fake.calls), "rows": len(fake.calls)}
