import asyncio
import importlib.util
import json
from pathlib import Path
from types import SimpleNamespace as NS

from fierylib.importers.race_importer import RaceImporter

ROOT = Path(__file__).resolve().parent.parent
DATA = ROOT / "data"
LEGACY_RACES_CPP = ROOT.parent / "fierymud_legacy" / "src" / "races.cpp"


def _gen():
    spec = importlib.util.spec_from_file_location("gen_race_effects_sql", ROOT / "scripts" / "gen_race_effects_sql.py")
    mod = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(mod)
    return mod


def _rows():
    return dict(_gen().collect(DATA / "races.json"))


def test_elf_gets_infravision_not_bless():
    rows = _rows()
    assert rows["ELF"] == ["infravision"]
    assert all("bless" not in flags for flags in rows.values())


def test_legacy_perm_eff_table_mapped():
    rows = _rows()
    assert rows["DROW"] == ["infravision", "ultravision"]
    assert rows["DWARF"] == ["detect_poison", "infravision", "ultravision"]
    assert rows["HALFLING"] == ["detect_life", "infravision"]
    assert rows["DRAGON_FIRE"] == ["fly"]
    assert rows["HALF_ELF"] == ["infravision"]
    assert "HUMAN" not in rows


def test_checked_in_sql_matches_generator(tmp_path):
    gen = _gen()
    out = tmp_path / "race-effects.sql"
    rows = gen.collect(DATA / "races.json")
    values = ",\n".join(f"    ('{r}', '{json.dumps({'flags': fl})}')" for r, fl in rows)
    out.write_text(gen.HEADER.format(n_rows=len(rows)) + values + "\n" + gen.FOOTER)
    assert out.read_text() == (DATA / "sql" / "2026-10-08-race-effects.sql").read_text()


def test_races_json_has_half_elf_permanent_effects():
    races = {r["name"]: r for r in json.loads((DATA / "races.json").read_text())["races"]}
    assert races["halfelf"]["permanentEffects"] == ["INFRAVISION"]


def test_parser_attaches_half_elf_effects():
    import pytest

    if not LEGACY_RACES_CPP.exists():
        pytest.skip("legacy races.cpp not present")
    from fierylib.parsers.cpp_race_parser import parse_races_cpp

    parsed = {r["name"]: r for r in parse_races_cpp(LEGACY_RACES_CPP)["races"]}
    assert parsed["halfelf"]["permanentEffects"] == ["INFRAVISION"]


class _FakeTable:
    def __init__(self):
        self.rows = []

    async def delete_many(self, where):
        self.rows = [r for r in self.rows if r["race"] != where["race"]]

    async def create(self, data):
        self.rows.append(data)


class _FakeEffects:
    async def find_first(self, where):
        return NS(id=4)


def _importer():
    imp = RaceImporter.__new__(RaceImporter)
    imp.db = NS(raceeffects=_FakeTable(), effect=_FakeEffects())
    return imp


def test_sync_race_effects_writes_status_flags_and_is_idempotent():
    imp = _importer()
    for _ in range(2):
        assert asyncio.run(imp.sync_race_effects("DROW", ["INFRAVISION", "ULTRAVISION"]))
    rows = imp.db.raceeffects.rows
    assert len(rows) == 1
    assert rows[0]["effectId"] == 4
    assert rows[0]["modifierData"].data == {"flags": ["infravision", "ultravision"]}


def test_sync_race_effects_no_mappable_flags_leaves_no_row():
    imp = _importer()
    assert not asyncio.run(imp.sync_race_effects("HUMAN", []))
    assert not asyncio.run(imp.sync_race_effects("HUMAN", ["NO_TRACK"]))
    assert imp.db.raceeffects.rows == []
