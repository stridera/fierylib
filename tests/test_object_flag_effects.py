import importlib.util
import json
from pathlib import Path
from types import SimpleNamespace as NS

import pytest

from fierylib.converters.flag_normalizer import (
    MOB_EFFECT_FLAG_TO_STATUS_FLAG,
    process_object_flags,
)
from fierylib.importers.object_importer import ObjectImporter

ROOT = Path(__file__).resolve().parent.parent


def _load_generator():
    spec = importlib.util.spec_from_file_location("gen_object_flag_effects_sql", ROOT / "scripts" / "gen_object_flag_effects_sql.py")
    mod = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(mod)
    return mod


def test_object_effect_bits_map_through_shared_mob_table():
    result = process_object_flags(["MAGIC"], ["FLY", "DETECT_INVIS", "SANCTUARY", "INFRAVISION", "PROTECT_FIRE"])
    assert result.status_flags == ["detect_invisible", "fly", "infravision", "sanctuary"]
    assert result.skipped_effect_flags == ["PROTECT_FIRE"]
    for flag in result.status_flags:
        assert flag in MOB_EFFECT_FLAG_TO_STATUS_FLAG.values()


def test_object_without_mappable_bits_has_no_status_flags():
    result = process_object_flags([], ["CHARM", "UNUSED"])
    assert result.status_flags == []


class _Effect:
    async def find_first(self, where):
        assert where == {"name": "status"}
        return NS(id=4)


class _ObjectEffects:
    def __init__(self):
        self.created = []

    async def create(self, data):
        self.created.append(data)


@pytest.mark.asyncio
async def test_add_status_effect_writes_single_row():
    prisma = NS(effect=_Effect(), objecteffects=_ObjectEffects())
    imp = ObjectImporter(prisma)
    assert await imp.add_status_effect(30, 78, ["fly", "haste", "fly"]) is True
    [row] = prisma.objecteffects.created
    assert (row["objectZoneId"], row["objectId"], row["effectId"]) == (30, 78, 4)
    assert json.loads(row["modifierData"]) == {"flags": ["fly", "haste"]}


@pytest.mark.asyncio
async def test_add_status_effect_noop_without_flags():
    prisma = NS(effect=_Effect(), objecteffects=_ObjectEffects())
    assert await ObjectImporter(prisma).add_status_effect(30, 78, []) is False
    assert prisma.objecteffects.created == []


def test_generator_collects_and_renders_guarded_idempotent_sql(tmp_path):
    gen = _load_generator()
    obj_dir = tmp_path / "world" / "obj"
    obj_dir.mkdir(parents=True)
    # zone 7: #701 carries DETECT_INVIS (eff word 1 bit 3) + FLY (word 2 bit 7); #702 has none.
    (obj_dir / "7.obj").write_text(
        "#701\nring~\na ring~\nA ring.~\n~\n9 0 1 10\n0 0 0 0 0 0 0\n0.50 10 0 8 0 0 128 0\n"
        "#702\nrock~\na rock~\nA rock.~\n~\n9 0 1 10\n0 0 0 0 0 0 0\n0.50 10 0 0 0 0 0 0\n$\n"
    )
    rows, usage, skipped, failed = gen.collect(tmp_path)
    assert not failed
    assert rows == [(7, 1, ["detect_invisible", "fly"])]
    sql = gen.render(rows, usage)
    assert """(7, 1, '{"flags": ["detect_invisible", "fly"]}')""" in sql
    assert "WHERE NOT EXISTS" in sql and "e.name = 'status'" in sql
    assert "ON CONFLICT" not in sql  # ObjectEffects has no unique key; guard is NOT EXISTS


def test_committed_sql_patch_is_guarded():
    sql = (ROOT / "data" / "sql" / "2026-10-08-object-flag-effects.sql").read_text()
    assert "WHERE NOT EXISTS" in sql
    assert """'{"flags": ["detect_invisible"]}'""" in sql
