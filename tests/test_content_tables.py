"""Tests for the content tables data, SQL patch and seeder (no DB)."""

import asyncio
import json
import re
from pathlib import Path

from fierylib.seeders.content_tables_seeder import (
    ContentTablesSeeder,
    build_sql,
    build_statements,
    config_value_text,
    load_content,
)

ROOT = Path(__file__).resolve().parents[1]
SQL_PATH = ROOT / "data" / "sql" / "2026-10-09-content-tables.sql"
ABILITIES = json.loads((ROOT / "data" / "abilities.json").read_text(encoding="utf-8"))
PLAIN_NAMES = {a["plainName"] for a in ABILITIES}

PRECIP_KINDS = ["clear", "cloudy", "drizzle", "rain", "storm", "snow", "blizzard"]


def _messages(key):
    (row,) = (m for m in load_content()["system_messages"] if m["key"] == key)
    return row["messages"]


def test_sql_patch_matches_the_json():
    assert SQL_PATH.read_text(encoding="utf-8") == build_sql()


def test_status_flag_values_match_the_old_match_arms():
    values = dict(load_content()["status_flag_values"])
    assert len(values) == 75
    assert values["major_paralysis"] == -50
    assert values["blind"] == -40 and values["blindness"] == -40
    assert values["curse"] == 3
    assert values["detect_invis"] == 40
    assert values["haste"] == 60
    assert values["greater_displacement"] == 70
    assert values["sanctuary"] == 90
    assert values["stone_skin"] == 100 and values["stoneskin"] == 100
    flags = [f for f, _ in load_content()["status_flag_values"]]
    assert len(flags) == len(set(flags)), "flag is the primary key"


def test_spell_syllables_keep_legacy_match_order():
    pairs = load_content()["spell_syllables"]
    assert len(pairs) == 54
    syllables = [s for s, _ in pairs]
    assert len(set(syllables)) == len(syllables), "syllable is unique"
    assert pairs[0] == [" ", " "]
    # Whole-syllable rewrites come before the single-letter cipher.
    first_letter = next(i for i, s in enumerate(syllables) if len(s) == 1 and s != " ")
    assert all(len(s) > 1 for s in syllables[1:first_letter] if s != " ")
    assert syllables.index("word of") < first_letter
    assert syllables[first_letter:] == [chr(c) for c in range(ord("a"), ord("z") + 1)]
    assert dict(pairs)["ar"] == "abra"


def test_system_messages():
    assert len(_messages("exp_progress")) == 11
    assert _messages("exp_progress")[0].startswith("<blue>You still have a very long way")
    assert len(_messages("insult_lines")) == 8
    months = _messages("month_names")
    assert len(months) == 16
    assert months[0] == "the Month of Deepwinter" and months[15] == "the Month of the Long Night"
    for kind in PRECIP_KINDS:
        assert len(_messages(f"weather_change_{kind}")) == 1
    keys = [m["key"] for m in load_content()["system_messages"]]
    assert len(keys) == len(set(keys))


def test_prompt_templates_are_json_name_template_pairs():
    (row,) = load_content()["game_config"]
    assert (row["category"], row["key"], row["valueType"]) == ("display", "prompt_templates", "JSON")
    pairs = json.loads(config_value_text(row))
    assert [n for n, _ in pairs] == [
        "classic", "compact", "bars", "vitals", "verbose",
        "location", "worldclock", "combat", "minimal",
    ]  # fmt: skip
    assert dict(pairs)["classic"] == "<%h/%H hp %v/%V mv> "


def test_prompt_letters_name_real_abilities():
    letters = load_content()["prompt_letters"]
    assert len(letters) == 17
    assert all(len(letter) == 1 for letter, _ in letters)
    assert len({letter for letter, _ in letters}) == len(letters)
    # Legacy cooldown_selectors accepts a-y; every letter we drive is one of them.
    assert all("a" <= letter <= "y" for letter, _ in letters)
    for letter, names in letters:
        missing = [n for n in names if n not in PLAIN_NAMES]
        assert not missing, f"%d{letter}: no such ability {missing}"
    assert dict(letters)["b"] == [
        "BREATHE_ACID", "BREATHE_FIRE", "BREATHE_FROST", "BREATHE_GAS", "BREATHE_LIGHTNING",
    ]  # fmt: skip


def test_every_statement_is_idempotent():
    for stmt in build_statements():
        if stmt.startswith("INSERT"):
            assert "ON CONFLICT" in stmt and "DO NOTHING" in stmt, stmt[:60]
        elif stmt.startswith("UPDATE"):
            assert '"prompt_letter" IS NULL' in stmt
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
    stats = asyncio.run(ContentTablesSeeder(fake).seed_content_tables())
    assert [c[0] for c in fake.calls] == build_statements()
    assert stats == {"statements": len(fake.calls), "rows": len(fake.calls)}
