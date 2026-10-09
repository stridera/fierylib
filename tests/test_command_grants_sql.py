"""The command-grants SQL patch seeds an empty mortal allowlist, and the seeder agrees."""

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
