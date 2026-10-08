import importlib.util
from pathlib import Path

from types import SimpleNamespace as NS

import pytest

from fierylib.converters.flag_normalizer import (
    MOB_EFFECT_FLAG_TO_STATUS_FLAG,
    OBJECT_EFFECT_FLAG_TO_STATUS_FLAG,
    mob_default_status_flags,
    object_globe_circle,
    process_object_flags,
)
from fierylib.importers.object_importer import EFFECT_TO_RESISTANCE, ObjectImporter

ROOT = Path(__file__).resolve().parent.parent
SQL = ROOT / "data" / "sql" / "2026-10-08-object-flag-effects-2.sql"


def _load_generator():
    spec = importlib.util.spec_from_file_location(
        "gen_object_flag_effects2_sql", ROOT / "scripts" / "gen_object_flag_effects2_sql.py"
    )
    mod = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(mod)
    return mod


def test_object_only_status_mappings():
    assert OBJECT_EFFECT_FLAG_TO_STATUS_FLAG == {
        "PROTECT_EVIL": "protect_evil",
        "PROTECT_GOOD": "protect_good",
        "TONGUES": "language_fluency",
        "FAMILIARITY": "familiarity",
    }
    # the shared mob / race table is untouched
    assert not set(OBJECT_EFFECT_FLAG_TO_STATUS_FLAG) & set(MOB_EFFECT_FLAG_TO_STATUS_FLAG)
    flags, skipped = mob_default_status_flags(["PROTECT_EVIL", "TONGUES"])
    assert flags == [] and skipped == ["PROTECT_EVIL", "TONGUES"]


def test_process_object_flags_maps_new_bits_and_skips_nonsense():
    r = process_object_flags(
        [], ["PROTECT_EVIL", "PROTECT_GOOD", "TONGUES", "FAMILIARITY", "FLY",
             "CHARM", "TAMED", "ON_FIRE", "HURT_THROAT", "VITALITY", "GLORY", "NO_TRACK"]
    )
    assert r.status_flags == ["familiarity", "fly", "language_fluency", "protect_evil", "protect_good"]
    assert r.skipped_effect_flags == ["CHARM", "TAMED", "ON_FIRE", "HURT_THROAT", "VITALITY", "GLORY", "NO_TRACK"]


@pytest.mark.parametrize(
    "flags,circle",
    [([], 0), (["MINOR_GLOBE"], 3), (["MAJOR_GLOBE"], 6), (["MINOR_GLOBE", "MAJOR_GLOBE"], 6)],
)
def test_globe_circle(flags, circle):
    assert object_globe_circle(flags) == circle
    assert process_object_flags([], flags).globe_circle == circle


def test_stone_skin_is_physical_resistance_not_status_flag():
    assert EFFECT_TO_RESISTANCE["STONE_SKIN"] == ("PHYSICAL", 25)
    r = process_object_flags([], ["STONE_SKIN", "PROTECT_FIRE"])
    assert "STONE_SKIN" in r.effect_names and "PROTECT_FIRE" in r.effect_names
    assert r.status_flags == []


def test_generator_collects_all_three_row_kinds(tmp_path):
    gen = _load_generator()
    obj_dir = tmp_path / "world" / "obj"
    obj_dir.mkdir(parents=True)
    from mud.mudfile import MudData
    from mud.types.object import Object

    text = (
        "#701\nring~\na ring~\nA ring.~\n~\n9 0 1 10\n0 0 0 0 0 0 0\n0.50 10 0 8 0 0 128 0\n$\n"
    )
    (obj_dir / "7.obj").write_text(text)
    # Drive collect() with named effect flags by stubbing the parser output.
    objs = Object.parse(MudData(text.split("\n")))
    objs[0].effects = ["PROTECT_EVIL", "MINOR_GLOBE", "MAJOR_GLOBE", "STONE_SKIN", "PROTECT_FIRE", "FIRESHIELD", "CHARM"]
    gen.Object = type("O", (), {"parse": staticmethod(lambda _m: objs)})
    status, globe, res, usage, failed = gen.collect(tmp_path)
    assert not failed
    assert status == [(7, 1, ["protect_evil"])]
    assert globe == [(7, 1, 6)]
    assert res == [(7, 1, "COLD", 25), (7, 1, "FIRE", 25), (7, 1, "PHYSICAL", 25)]
    sql = gen.render(status, globe, res, usage)
    assert """(7, 1, '{"flags": ["protect_evil"]}')""" in sql
    assert "(7, 1, 6)" in sql and "(7, 1, 'PHYSICAL', 25)" in sql


def test_committed_patch_is_idempotent_and_data_only():
    sql = SQL.read_text()
    assert sql.count("WHERE NOT EXISTS") >= 3
    assert "ON CONFLICT" not in sql
    for ddl in ("CREATE TABLE", "ALTER TABLE", "DROP ", "TRUNCATE", "DELETE FROM"):
        assert ddl not in sql
    assert """'{"flags": ["protect_evil"]}'""" in sql or """"protect_evil\"""" in sql
    assert "e.name = 'globe'" in sql and 'INSERT INTO "ObjectResistance"' in sql
    assert "todo.add_flags <> '[]'::jsonb" in sql  # merge is a no-op once flags are present


class _Effect:
    async def find_first(self, where):
        assert where == {"name": "globe"}
        return NS(id=17)


class _ObjectEffects:
    def __init__(self):
        self.created = []

    async def create(self, data):
        self.created.append(data)


@pytest.mark.asyncio
async def test_add_globe_effect_strength_is_max_circle():
    prisma = NS(effect=_Effect(), objecteffects=_ObjectEffects())
    imp = ObjectImporter(prisma)
    assert await imp.add_globe_effect(23, 34, 0) is False
    assert await imp.add_globe_effect(23, 34, 6) is True
    [row] = prisma.objecteffects.created
    assert (row["objectZoneId"], row["objectId"], row["effectId"], row["strength"]) == (23, 34, 17, 6)
