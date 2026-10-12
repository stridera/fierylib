"""Command policy flags seed (src/fierylib/seeders/command_policy.py; no DB)."""

import asyncio
from pathlib import Path

from fierylib.seeders import command_policy as cp
from fierylib.seeders.command_seeder import CommandSeeder

ROOT = Path(__file__).resolve().parents[1]
SQL_PATH = ROOT / "data" / "sql" / "2026-10-12-command-policy-flags.sql"


def test_columns_and_list_sizes_match_the_rust_lists():
    assert list(cp.FLAGS) == [
        "allowed_while_casting",
        "allowed_while_paralyzed",
        "keeps_hidden",
        "held_by_cast_lag",
    ]
    assert [len(v) for v in cp.FLAGS.values()] == [55, 56, 108, 9]
    for col, names in cp.FLAGS.items():
        assert len(names) == len(set(names)), col


def test_sql_patch_is_in_sync_with_the_lists():
    # Regenerate with `poetry run python scripts/gen_command_policy_sql.py`.
    assert SQL_PATH.read_bytes().decode("utf-8") == cp.patch_sql()


def test_sql_patch_is_transactional_and_idempotent():
    sql = SQL_PATH.read_text(encoding="utf-8")
    assert sql.count("BEGIN;") == 1 and sql.rstrip().endswith("COMMIT;")
    assert all(ddl in sql for ddl in cp.COLUMN_DDL)
    # Each UPDATE is guarded so a rerun (or a Muditor edit of the column) changes 0 rows.
    assert sql.count("AND NOT EXISTS (SELECT 1 FROM") == 4
    assert "= false" not in sql.split("BEGIN;")[1].replace("DEFAULT false", "")


def test_quotes_in_names_are_escaped():
    assert "''''" in cp.flag_sql("allowed_while_paralyzed", ["'"])


def test_seeder_runs_ddl_then_one_update_per_column():
    calls = []

    class FakePrisma:
        async def execute_raw(self, sql):
            calls.append(sql)

    n = asyncio.run(CommandSeeder(FakePrisma()).seed_policy_flags())
    assert n == 55 + 56 + 108 + 9
    assert calls[:4] == cp.COLUMN_DDL
    assert len(calls) == 8
    assert all(c.startswith('UPDATE "Command" SET') for c in calls[4:])
