import re
from pathlib import Path

SQL = Path(__file__).resolve().parent.parent / "data" / "sql" / "2026-10-08-effect-auras.sql"


def _text():
    return SQL.read_text()


def test_idempotent_shape():
    sql = _text()
    assert 'CREATE TABLE IF NOT EXISTS "EffectAura"' in sql
    assert "ON CONFLICT (slug) DO NOTHING" in sql
    assert "DELETE" not in sql and "TRUNCATE" not in sql


def test_rows_have_unique_slugs_and_ordering():
    rows = re.findall(r"^    \('([^']+)', ARRAY\[", _text(), re.M)
    assert len(rows) == 32
    assert len(set(rows)) == len(rows)


def test_sanctuary_alignment_bands_cover_all_alignments():
    sql = _text()
    assert "'sanctuary_evil'" in sql and ", NULL, NULL, -350," in sql
    assert ", NULL, -349, 349," in sql
    assert ", NULL, 350, NULL," in sql


def test_dragon_health_supersedes_endurance():
    sql = _text()
    groups = re.findall(r"'health_boost'", sql)
    assert len(groups) == 2
