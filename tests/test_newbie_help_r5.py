"""Playtest round 5 (N8, N12, N14, N15): help articles and login text patches (no DB)."""

import re
from pathlib import Path

import pytest

from fierylib.seeders.help_seeder import load_help_dir, render_sql

ROOT = Path(__file__).resolve().parents[1]
SQL_DIR = ROOT / "data" / "sql"
HELP_SQL = SQL_DIR / "2026-10-12-newbie-help-r5.sql"
FILES = (
    "academy",
    "newbie",
    "touchstone",
    "death",
    "study",
    "wimpy",
    "where",
    "rest",
    "food",
    "torch",
)
REGENERATE = (
    "regenerate with: fierylib seed help "
    + " ".join(f"--only {f}" for f in FILES)
    + " --emit-sql data/sql/2026-10-12-newbie-help-r5.sql"
)


def _articles():
    wanted = {f"data/help/{f}.md" for f in FILES}
    return [a for a in load_help_dir(ROOT / "data" / "help") if a.source_file in wanted]


def test_every_article_loads_and_is_player_visible():
    arts = _articles()
    assert sorted(a.primary for a in arts) == sorted(
        {"academy", "newbie", "touchstone", "death", "study", "wimpy", "where", "rest", "food", "torch"}
    )
    assert all(a.min_level == 0 for a in arts)


def test_sql_patch_matches_markdown():
    assert HELP_SQL.read_text(encoding="utf-8") == render_sql(_articles()), REGENERATE


def test_help_update_is_skipped_when_the_row_already_matches():
    sql = HELP_SQL.read_text(encoding="utf-8")
    # One guarded UPDATE per article: a second run changes 0 rows.
    assert sql.count("IS DISTINCT FROM") == len(FILES)
    assert sql.count("UPDATE \"HelpEntry\"") == len(FILES)


def test_articles_fit_an_80_column_terminal():
    for art in _articles():
        for line in art.content.splitlines():
            assert len(line) <= 78, f"{art.primary}: {line!r}"


def test_keywords_do_not_collide_across_the_new_articles():
    seen = {}
    for art in load_help_dir(ROOT / "data" / "help"):
        for kw in art.keywords:
            other = seen.setdefault(kw.lower(), art.primary)
            assert other == art.primary, f"{kw!r} is claimed by {other} and {art.primary}"


def test_academy_help_says_how_to_reach_the_academy():
    academy = next(a for a in _articles() if a.primary == "academy")
    assert "down" in academy.content and "Forest Temple of Mielikki" in academy.content


def test_touchstone_no_longer_claims_every_newbie_starts_bound_to_the_temple():
    touchstone = next(a for a in _articles() if a.primary == "touchstone")
    assert "Mielikki temple bound by default" not in touchstone.content
    assert "room your race starts in" in touchstone.content


def test_newbie_help_covers_exits_light_and_study():
    newbie = next(a for a in _articles() if a.primary == "newbie")
    for needle in ('"exits"', "autoexit", "torch", "study", "no coin"):
        assert needle in newbie.content, needle


@pytest.mark.parametrize(
    "name",
    ["2026-10-12-login-text-r5.sql", "2026-10-12-object-articles-r5.sql"],
)
def test_data_patches_are_guarded_and_never_delete(name):
    sql = (SQL_DIR / name).read_text(encoding="utf-8")
    assert "DELETE" not in sql.upper().replace("-- ", "")
    for stmt in re.findall(r"UPDATE\b.*?;", sql, flags=re.S):
        assert "WHERE" in stmt, stmt
    # Every statement keys on the old text, so a re-run matches nothing.
    if "login-text" in name:
        assert sql.count("position(") == 2
    else:
        assert sql.count("AND name = ") == 5


def test_login_patch_points_new_players_at_the_in_game_creation_prompt():
    sql = (SQL_DIR / "2026-10-12-login-text-r5.sql").read_text(encoding="utf-8")
    assert "type a new character name to start one here" in sql
    assert "at least 6 characters" in sql


def test_text_seeder_matches_the_login_patch():
    seeder = (ROOT / "src" / "fierylib" / "seeders" / "text_seeder.py").read_text(encoding="utf-8")
    assert "New players: type a new character name to start one here." in seeder
    assert "(at least 6 characters)" in seeder
    assert "(6-20 characters)" not in seeder
    assert "visit https://fierymud.org to register" not in seeder
