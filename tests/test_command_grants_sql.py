"""The command-grants SQL patch seeds an empty mortal allowlist, and the seeder agrees."""

import re
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
SQL = (ROOT / "data" / "sql" / "2026-10-09-command-grants.sql").read_text(encoding="utf-8")
SEEDER = (ROOT / "src" / "fierylib" / "seeders" / "config_seeder.py").read_text(encoding="utf-8")


def test_patch_seeds_an_empty_allowlist_without_overwriting():
    assert "ADD COLUMN IF NOT EXISTS command_grants JSONB" in SQL
    assert "'grants', 'mortal_allowlist', '[]', 'JSON'" in SQL
    assert 'ON CONFLICT ("category", "key") DO NOTHING' in SQL


def test_seeder_matches_the_patch():
    assert '("grants", "mortal_allowlist", "[]", ConfigValueType.JSON' in SEEDER


def test_allowlist_requires_a_restart_and_the_patch_fixes_existing_rows():
    assert "\"restart_req\", \"updated_at\")" in SQL
    assert 'SET "restart_req" = true' in SQL
    assert 'AND "restart_req" = false' in SQL
    assert re.search(r'\("grants", "mortal_allowlist", .*ConfigValueType\.JSON.*None, None, False, True\)', SEEDER)
