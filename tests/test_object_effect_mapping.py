"""fierymud-rs #151: legacy object EFF_* words are 32 bits wide (eff3 << 64 | eff2 << 32 | eff1)."""

import importlib.util
from pathlib import Path

from mud.mudfile import MudData
from mud.types.object import Object

from fierylib.converters.flag_normalizer import object_weapon_damage_type, process_object_flags

ROOT = Path(__file__).resolve().parent.parent
SQL = ROOT / "data" / "sql" / "2026-10-13-object-effect-mapping.sql"

# Legacy #1047 "a dagger of ice" (lib/world/obj/10.obj): eff3 = 2097152 = word 2 bit 21 = EFF_ICE_WEAPON (85).
ICE_DAGGER = (
    "#1047\ndagger dagger-ice~\na dagger of ice~\nA dagger of jagged ice lies here, melting...~\n~\n"
    "5 822009928 8193 1\n0 2 4 11 0 0 0\n1.80 0 0 0 0 0 0 2097152\n$\n"
)


def _parse(block: str):
    return Object.parse(MudData(block.split("\n")))[0]


def _load_generator():
    spec = importlib.util.spec_from_file_location("gen_oem", ROOT / "scripts" / "gen_object_effect_mapping_sql.py")
    mod = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(mod)
    return mod


def test_ice_dagger_is_an_ice_weapon_not_a_major_globe():
    obj = _parse(ICE_DAGGER)
    assert obj.effects == ["ICE_WEAPON"]
    r = process_object_flags([], obj.effects)
    assert r.globe_circle == 0 and r.status_flags == []


def test_second_word_bits_land_on_32_plus():
    # eff2 = 1 << 15 is flag 47 (MAJOR_GLOBE); the old << 13 shift put it on flag 28.
    block = "#701\nring~\na ring~\nA ring.~\n~\n9 0 1 10\n0 0 0 0 0 0 0\n0.50 10 0 0 0 0 32768 0\n$\n"
    assert _parse(block).effects == ["MAJOR_GLOBE"]
    # eff1 bits are untouched: bit 20 = FLY.
    block = block.replace("0.50 10 0 0 0 0 32768 0", "0.50 10 0 1048576 0 0 0 0")
    assert _parse(block).effects == ["FLY"]


def test_weapon_bit_picks_the_element_in_legacy_order():
    assert object_weapon_damage_type([]) is None
    assert object_weapon_damage_type(["ICE_WEAPON"]) == "COLD"
    assert object_weapon_damage_type(["ACID_WEAPON", "SHOCK_WEAPON"]) == "SHOCK"
    assert object_weapon_damage_type(["FIRE_WEAPON", "RADIANT_WEAPON"]) == "ALIGN"
    assert object_weapon_damage_type(["MAJOR_GLOBE"]) is None


def test_generator_derives_old_and_new_state(tmp_path):
    gen = _load_generator()
    # The buggy parser read the dagger's bit 85 as bit 47 (MAJOR_GLOBE).
    assert gen.buggy_effect_names(["ICE_WEAPON"]) == ["MAJOR_GLOBE"]
    assert gen.buggy_effect_names(["FLY"]) == ["FLY"]
    obj_dir = tmp_path / "world" / "obj"
    obj_dir.mkdir(parents=True)
    (obj_dir / "10.obj").write_text(ICE_DAGGER)
    effect_rows, dmg_rows, failed = gen.collect(tmp_path)
    assert not failed
    assert effect_rows == [(10, 1047 - 1000, ([], 6, {}), ([], 0, {}))]
    assert dmg_rows == [(10, 47, "PIERCE", "COLD")]


def test_committed_patch_is_guarded_and_idempotent():
    sql = SQL.read_text()
    assert "CREATE TEMP TABLE _oem_hit" in sql and "= m.old_status" in sql and "= m.old_res" in sql
    assert "AND o.weapon_damage_type = v.legacy" in sql
    assert "ON CONFLICT" not in sql
    for ddl in ("ALTER TABLE", "DROP TABLE", "TRUNCATE"):
        assert ddl not in sql
    # the dagger: old = major globe (6), new = nothing; it is cold-typed after the patch
    assert "(10, 47, ARRAY[]::text[], 6, '{}'::jsonb, ARRAY[]::text[], 0, '{}'::jsonb)" in sql
    assert "(10, 47, 'PIERCE', 'COLD')" in sql
