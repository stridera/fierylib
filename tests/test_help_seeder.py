"""Tests for the authored help seeder (parsing and SQL emission; no DB)."""

import pytest

from fierylib.seeders.help_seeder import (
    DEFAULT_HELP_DIR,
    HelpFileError,
    load_help_dir,
    parse_help_text,
    render_sql,
)

SAMPLE = """---
keywords: [Quest, quests, "two words"]
title: "Quests: a guide"
category: guide
min_level: 0
usage: "quests | qaccept {zone} {id}"
---
Body line one.

Body line two with 'quotes'.
"""


def test_parse_front_matter_and_body():
    art = parse_help_text(SAMPLE, "sample.md")
    assert art.keywords == ["quest", "quests", "two words"]
    assert art.primary == "quest"
    assert art.title == "Quests: a guide"
    assert art.category == "guide"
    assert art.min_level == 0
    assert art.usage == "quests | qaccept {zone} {id}"
    assert art.content == "Body line one.\n\nBody line two with 'quotes'."


def test_block_list_keywords():
    art = parse_help_text("---\nkeywords:\n  - a\n  - b\ntitle: T\n---\nx\n", "s.md")
    assert art.keywords == ["a", "b"]


@pytest.mark.parametrize(
    "text",
    [
        "no front matter",
        "---\ntitle: T\n---\nbody\n",  # no keywords
        "---\nkeywords: [a]\n---\nbody\n",  # no title
        "---\nkeywords: [a]\ntitle: T\n---\n\n",  # empty body
        "---\nkeywords: [a]\ntitle: T\nbogus: 1\n---\nbody\n",
    ],
)
def test_malformed_files_rejected(text):
    with pytest.raises(HelpFileError):
        parse_help_text(text, "bad.md")


def test_sql_is_idempotent_shape_and_escapes():
    art = parse_help_text(SAMPLE.replace("Quests: a guide", "Bob's guide"), "sample.md")
    sql = render_sql([art])
    assert "BEGIN;" not in sql and "COMMIT;" not in sql  # caller owns the transaction
    assert "keywords[1] = 'quest'" in sql
    assert "'Bob''s guide'" in sql
    assert "ARRAY['quest', 'quests', 'two words']::text[]" in sql
    assert "ON CONFLICT" not in sql  # no unique key on HelpEntry


def test_dollar_quote_tag_avoids_collision():
    art = parse_help_text("---\nkeywords: [a]\ntitle: T\n---\nprice $help$ here\n", "s.md")
    assert "$help1$price $help$ here$help1$" in render_sql([art])


def test_shipped_guides_are_valid():
    articles = load_help_dir(DEFAULT_HELP_DIR, ["guide"])
    assert len(articles) >= 15
    primaries = {a.primary for a in articles}
    assert {"quest", "boards", "inn", "shops", "bank", "mail", "clans", "group",
            "consent", "magic", "skill", "communication", "prompt", "website",
            "newbie"} <= primaries
    for art in articles:
        assert art.min_level == 0
        assert "<" not in art.content and "&" not in art.content  # markup-safe
