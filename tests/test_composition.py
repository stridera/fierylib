"""Creature composition: legacy `Composition:` value -> Prisma enum, race defaults, SQL backfill."""

import importlib.util
import json
from pathlib import Path

import pytest
from fierylib.parsers.cpp_race_parser import CppRaceParser
from mud.mudfile import MudData
from mud.types import Composition
from mud.types.mob import Mob

ROOT = Path(__file__).resolve().parent.parent

# Legacy composition.hpp COMP_FLESH..COMP_PLANT, in order.
LEGACY_ORDER = [
    "FLESH", "EARTH", "AIR", "FIRE", "WATER", "ICE", "MIST",
    "ETHER", "METAL", "STONE", "BONE", "LAVA", "PLANT",
]  # fmt: skip


def _load_gen_script():
    spec = importlib.util.spec_from_file_location("gen_composition_sql", ROOT / "scripts" / "gen_composition_sql.py")
    mod = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(mod)
    return mod


def test_legacy_value_maps_to_enum_name():
    assert [Composition(i).name for i in range(13)] == LEGACY_ORDER


def test_prisma_enum_matches_legacy_set_and_order():
    prisma_enums = pytest.importorskip("prisma.enums")
    if not hasattr(prisma_enums, "Composition"):
        pytest.skip("python prisma client not regenerated")
    assert [m.name for m in prisma_enums.Composition] == LEGACY_ORDER


def test_sql_script_enum_matches_legacy_order():
    assert _load_gen_script().COMPOSITIONS == LEGACY_ORDER


def test_race_parser_maps_every_comp_constant():
    for i, name in enumerate(LEGACY_ORDER):
        assert CppRaceParser.COMPOSITION_MAP[f"COMP_{name}"] == name


def test_races_json_defaults():
    races = json.loads((ROOT / "data" / "races.json").read_text())["races"]
    non_flesh = {r["plainName"]: r["defaultComposition"] for r in races if r["defaultComposition"] != "FLESH"}
    assert non_flesh == {"Plant": "PLANT", "Arborean": "PLANT"}


def test_mob_composition_is_parsed():
    src = next((ROOT.parent / "lib" / "world" / "mob").glob("30.mob"), None)
    if src is None:
        pytest.skip("legacy lib not present")
    text = src.read_text()
    mobs = Mob.parse(MudData(text.split("\n")))
    assert mobs
    assert all(isinstance(m.composition, Composition) for m in mobs)


def test_collect_mobs_only_returns_non_flesh():
    lib = ROOT.parent / "lib"
    if not (lib / "world" / "mob").is_dir():
        pytest.skip("legacy lib not present")
    gen = _load_gen_script()
    rows, _ = gen.collect_mobs(lib)
    assert rows
    assert all(comp != "FLESH" and comp in LEGACY_ORDER for _, _, comp in rows)


def test_generated_sql_is_idempotent_by_construction():
    sql = (ROOT / "data" / "sql" / "2026-10-07-composition.sql").read_text()
    assert "EXCEPTION WHEN duplicate_object THEN NULL" in sql
    assert sql.count("ADD COLUMN IF NOT EXISTS") == 2
    # Both backfills only touch rows still at the FLESH default.
    assert sql.count("= 'FLESH';") >= 2
