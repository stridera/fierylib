"""scripts/gen_text_underline_sql.py: legacy `&8` (underline) repair patch for imported text."""

import importlib.util
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
_spec = importlib.util.spec_from_file_location("gen_text_underline_sql", ROOT / "scripts" / "gen_text_underline_sql.py")
G = importlib.util.module_from_spec(_spec)
sys.modules["gen_text_underline_sql"] = G
_spec.loader.exec_module(G)

SQL = (ROOT / "data" / "sql" / "2026-10-15-text-underline-bg.sql").read_text(encoding="utf-8")


def test_old_converter_dropped_eight_new_one_underlines():
    assert G.old_convert("A &8&bGreen&0 Moss") == "A <b>Green</> Moss"
    assert G.new_convert("A &8&bGreen&0 Moss") == "A <b:u>Green</> Moss"
    assert G.changed("no codes here") is None
    assert G.changed("&1red&0 and &Rbg&0") is None  # background codes already worked
    assert G.changed("escaped &&8 literal") is None


def test_old_converter_patch_leaves_the_converter_fixed_afterwards():
    G.old_convert("&8x&0")
    assert G.new_convert("&8x&0") == "<u>x</>"


def test_patch_is_guarded_transactional_and_covers_known_rows():
    assert SQL.count("BEGIN;") == 1 and SQL.rstrip().endswith("COMMIT;")
    # every UPDATE only touches a field that still holds the old converted text
    assert SQL.count("UPDATE ") == SQL.count("= v.old_txt;")
    assert 'UPDATE "Room"' in SQL and "(69, 68," in SQL  # A Glade of <b>Green</> Moss
    assert "(22, 1," in SQL  # Varin
    assert "<b:u>Green</> Moss" in SQL
