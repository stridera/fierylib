"""CommandSeeder must not seed rows for names that are only aliases in the game registry."""

from fierylib.seeders.command_help import load_rows
from fierylib.seeders.command_seeder import COMMANDS


def test_seeder_has_no_alias_only_rows_and_keeps_wizinvis_permission():
    registry = {r["name"] for r in load_rows()}
    aliases = {a for r in load_rows() for a in r["aliases"]} - registry
    seeded = {c["name"] for c in COMMANDS}
    assert not (seeded & aliases), sorted(seeded & aliases)
    wizinvis = next(c for c in COMMANDS if c["name"] == "wizinvis")
    assert "INVISIBLE" in wizinvis["permissions"]
