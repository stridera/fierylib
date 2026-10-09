"""Socials with a digit in the legacy name (hi5) import; the SQL patch matches the parser."""

from pathlib import Path

from fierylib.parsers.socials_parser import parse_socials_file

SQL_PATH = Path(__file__).resolve().parents[1] / "data" / "sql" / "2026-10-09-missing-socials.sql"


def _write(tmp_path, body: str) -> Path:
    p = tmp_path / "socials"
    p.write_text(body, encoding="utf-8")
    return p


def test_digit_in_name_is_parsed(tmp_path):
    body = (
        "hi5 0 0\nHi-Five WHO?\n#\nYou high five $M.\n$n high fives $N.\n"
        "$n hi-fives you!\nNobody.\nYou slap your hands.\n$n hi-five's $mself.\n\n$\n"
    )
    f = _write(tmp_path, body)
    [s] = parse_socials_file(f)
    assert s.name == "hi5"
    assert s.char_no_arg == "Hi-Five WHO?"
    assert s.others_no_arg is None
    assert s.char_found == "You high five {target.pronoun.objective}."


def test_garbage_names_are_still_skipped(tmp_path):
    body = "z001#@# 0 0\nx\ny\nz\n\nsmile 0 0\nYou smile.\n$n smiles.\n#\n\n$\n"
    f = _write(tmp_path, body)
    assert [s.name for s in parse_socials_file(f)] == ["smile"]


def test_sql_patch_text_matches_the_legacy_entry():
    sql = SQL_PATH.read_text(encoding="utf-8")
    assert "ON CONFLICT (name) DO NOTHING" in sql
    candidates = [d / "lib" / "misc" / "socials" for d in Path(__file__).resolve().parents]
    legacy = next((c for c in candidates if c.exists()), None)
    if legacy is None:  # no legacy lib checkout above this tree
        return
    hi5 = next(s for s in parse_socials_file(legacy) if s.name == "hi5")
    for field in (
        hi5.char_no_arg,
        hi5.char_found,
        hi5.others_found,
        hi5.vict_found,
        hi5.not_found,
        hi5.char_auto,
        hi5.others_auto,
    ):
        assert field.replace("'", "''") in sql
