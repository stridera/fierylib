"""Text-fix patches: socials not_found is one message, typos are gone from the sources."""

from pathlib import Path

from fierylib.parsers.socials_parser import STANDARD_NOT_FOUND, normalize_not_found, parse_socials_file

ROOT = Path(__file__).resolve().parents[1]


def _parse(tmp_path, nf_nod, nf_ack="Nobody."):
    f = tmp_path / "socials"
    f.write_text(
        "nod 0 0\nYou nod.\n$n nods.\nYou nod at $M.\n$n nods at $N.\n$n nods at you.\n"
        f"{nf_nod}\nYou nod to yourself.\n$n nods to $mself.\n\n"
        "ack 0 0\nACK!\n$n acks.\n#\n\n$\n",
        encoding="utf-8",
    )
    return parse_socials_file(f)


def test_legacy_not_found_wording_is_kept_but_defects_fixed(tmp_path):
    nod, ack = _parse(tmp_path, "You agree.  They're not here.  ")
    assert nod.not_found == "You agree. They're not here."
    assert ack.not_found is None


def test_not_found_capital_and_end_punctuation():
    assert normalize_not_found("who's that") == "Who's that."
    assert normalize_not_found("Slap away...") == "Slap away..."
    assert normalize_not_found("Eh?  Who?") == "Eh? Who?"
    assert normalize_not_found("   ") is None


def test_missing_not_found_on_targeted_social_gets_the_generic_line(tmp_path):
    nod, _ = _parse(tmp_path, "")
    assert nod.not_found == STANDARD_NOT_FOUND


def test_help_source_says_several_seconds():
    text = (ROOT / "data" / "help" / "magic.md").read_text(encoding="utf-8")
    assert "about 3s" not in text
    assert "several seconds, depending on the spell" in text


def test_patch_files_exist_and_are_guarded():
    sql = (ROOT / "data" / "sql" / "2026-10-11-text-fixes.sql").read_text(encoding="utf-8")
    assert "fiercely" in sql and "possessions" in sql
    assert STANDARD_NOT_FOUND in sql
    dedupe = (ROOT / "data" / "sql" / "2026-10-11-dedupe-zone-reimport.sql").read_text(encoding="utf-8")
    assert dedupe.count("DELETE FROM") == 4
