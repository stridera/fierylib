"""Round-3 polish data: the `help circle` fragment and the stamina prompt wording."""

import json
from pathlib import Path

from fierylib.parsers.help_parser import HelpFileParser

ROOT = Path(__file__).resolve().parents[1]
SQL_DIR = ROOT / "data" / "sql"

FRAGMENT = (
    "&4&bCircle 1&0                        &4&bCircle 6&0\n"
    "barkskin                        darkness\n"
    "create food                     greater endurance\n"
)


def _parse(text, tmp_path):
    path = tmp_path / "help.hlp"
    path.write_text(text, encoding="utf-8")
    return HelpFileParser().parse_file(path)


def test_parser_skips_a_table_fragment_with_colour_codes_as_keywords(tmp_path):
    entries = _parse(FRAGMENT + "#0\nKICK\nKicks things.\n#0\n", tmp_path)
    assert "circle" not in entries
    assert "kick" in entries


def test_parser_still_reads_ordinary_entries(tmp_path):
    entries = _parse('"CIRCLE OF FIRE" CIRCLE_FIRE\nA ring of fire.\n#0\n', tmp_path)
    assert "circle of fire" in entries and "circle fire" in entries


def test_help_circle_patch_is_guarded_and_idempotent_in_shape():
    sql = (SQL_DIR / "2026-10-11-help-circle.sql").read_text(encoding="utf-8")
    assert "keywords = ARRAY['circle', '1', 'circle', '6']::text[]" in sql
    assert "category = 'race'" in sql
    assert "WHERE keywords = ARRAY['circle_skill']::text[]" in sql
    assert "TRUNCATE" not in sql


def test_prompt_patch_changes_only_the_old_default_and_templates():
    sql = (SQL_DIR / "2026-10-11-prompt-stamina.sql").read_text(encoding="utf-8")
    assert "WHERE prompt = '<%h/%Hhp %v/%Vmv>'" in sql
    assert "SET DEFAULT '<%h/%Hhp %v/%Vst>'" in sql
    assert "key = 'prompt_templates'" in sql
    assert "DELETE" not in sql and "TRUNCATE" not in sql


def test_content_tables_prompt_presets_say_st_not_mv():
    data = json.loads((ROOT / "data" / "content_tables.json").read_text(encoding="utf-8"))
    templates = next(
        row["value"]
        for row in data["game_config"]
        if row["category"] == "display" and row["key"] == "prompt_templates"
    )
    flat = " ".join(t for _, t in templates)
    assert " mv" not in flat
    assert "%V st" in flat


def test_prompt_help_article_documents_st():
    text = (ROOT / "data" / "help" / "prompt.md").read_text(encoding="utf-8")
    assert "%v/%V st" in text and "mv]" not in text
    assert "current and maximum stamina" in text


def test_player_importer_default_prompt_says_st():
    text = (ROOT / "src" / "fierylib" / "importers" / "player_importer.py").read_text(encoding="utf-8")
    assert '"<%h/%Hhp %v/%Vst>"' in text and "Vmv" not in text
