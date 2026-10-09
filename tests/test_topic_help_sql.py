"""The topic help SQL patch is generated from data/help/*.md; keep them in sync (no DB)."""

from pathlib import Path

from fierylib.seeders.help_seeder import load_help_dir, render_sql

ROOT = Path(__file__).resolve().parents[1]
SQL_PATH = ROOT / "data" / "sql" / "2026-10-09-topic-help.sql"
TOPICS = ("combat", "death", "stealth", "tank", "touchstone")
REGENERATE = (
    "regenerate with: fierylib seed help "
    + " ".join(f"--only {t}" for t in TOPICS)
    + " --insert-only --emit-sql data/sql/2026-10-09-topic-help.sql"
)


def _topic_articles():
    wanted = {f"data/help/{t}.md" for t in TOPICS}
    return [a for a in load_help_dir(ROOT / "data" / "help") if a.source_file in wanted]


def test_all_topic_files_exist_with_player_visible_guides():
    arts = _topic_articles()
    assert [a.primary for a in arts] == list(TOPICS)
    assert all(a.min_level == 0 and a.category == "guide" for a in arts)


def test_sql_patch_matches_markdown():
    expected = render_sql(_topic_articles(), insert_only=True)
    assert SQL_PATH.read_text(encoding="utf-8") == expected, REGENERATE


def test_sql_patch_is_insert_only():
    sql = SQL_PATH.read_text(encoding="utf-8")
    assert "UPDATE" not in sql and "DELETE" not in sql
    assert sql.count("WHERE NOT EXISTS") == len(TOPICS)
