import json
from pathlib import Path
from types import SimpleNamespace as NS
from typing import Any, Dict, List

import pytest

from fierylib.converters.flag_normalizer import (
    MOB_EFFECT_FLAG_TO_STATUS_FLAG,
    mob_default_status_flags,
    process_mob_flags,
)
from fierylib.importers.mob_importer import MobImporter

DATA = Path(__file__).resolve().parent.parent / "data"


def _catalog_status_flags() -> set:
    abilities = json.loads((DATA / "abilities.json").read_text())
    effects = json.loads((DATA / "effects.json").read_text())
    status = next(e for e in effects if e["name"] == "status")
    declared = set(status["paramSchema"]["properties"]["flag"]["enum"])
    return declared | {
        e["params"]["flag"]
        for a in abilities
        for e in a.get("effects", [])
        if e.get("effect") == "status" and e.get("params", {}).get("flag")
    }


def test_detect_invis_maps_to_detect_invisible():
    flags, skipped = mob_default_status_flags(["DETECT_INVIS"])
    assert flags == ["detect_invisible"]
    assert skipped == []


def test_every_target_flag_exists_in_ability_catalog():
    catalog = _catalog_status_flags()
    missing = {v for v in MOB_EFFECT_FLAG_TO_STATUS_FLAG.values() if v not in catalog}
    assert not missing


def test_mapping_dedupes_sorts_and_reports_skipped():
    flags, skipped = mob_default_status_flags(
        ["MINOR_PARALYSIS", "MAJOR_PARALYSIS", "HASTE", "NO_TRACK", "PROTECT_EVIL", "UNUSED", "NO_TRACK"]
    )
    assert flags == ["haste", "paralyzed"]
    assert skipped == ["NO_TRACK", "PROTECT_EVIL"]


def test_charm_and_tamed_are_not_mapped():
    flags, skipped = mob_default_status_flags(["CHARM", "TAMED"])
    assert flags == []
    assert set(skipped) == {"CHARM", "TAMED"}


def test_process_mob_flags_exposes_status_flags():
    result = process_mob_flags(["SENTINEL"], ["DETECT_INVIS", "INFRAVISION", "NO_TRACK"])
    assert result.default_status_flags == ["detect_invisible", "infravision"]
    assert result.skipped_effect_flags == ["NO_TRACK"]


def test_generated_sql_patch_is_idempotent_by_construction():
    sql = (DATA / "sql" / "2026-10-07-mob-default-effects.sql").read_text()
    assert 'ON CONFLICT (mob_zone_id, mob_id, effect_id) DO NOTHING' in sql
    assert '\'{"flags": ["detect_invisible"]}\'' in sql


class MockEffect:
    def __init__(self, rows):
        self.rows = rows

    async def find_first(self, where: Dict[str, Any]):
        for name, id_ in self.rows.items():
            if name == where["name"]:
                return NS(id=id_)
        return None


class MockMobDefaultEffects:
    def __init__(self):
        self.table: Dict[tuple, Any] = {}
        self.deletes: List[Dict[str, Any]] = []

    async def upsert(self, where: Dict[str, Any], data: Dict[str, Any]):
        key = where["mobZoneId_mobId_effectId"]
        k = (key["mobZoneId"], key["mobId"], key["effectId"])
        if k in self.table:
            self.table[k] = data["update"]["modifierData"]
        else:
            self.table[k] = data["create"]["modifierData"]

    async def delete_many(self, where: Dict[str, Any]):
        self.deletes.append(where)
        self.table.pop((where["mobZoneId"], where["mobId"], where["effectId"]), None)


class MockPrisma:
    def __init__(self, effects):
        self.effect = MockEffect(effects)
        self.mobdefaulteffects = MockMobDefaultEffects()


@pytest.mark.asyncio
async def test_sync_default_effects_upserts_single_status_row_idempotently():
    prisma = MockPrisma({"status": 4})
    imp = MobImporter(prisma)
    assert await imp.sync_default_effects(30, 11, ["sneak", "haste", "haste"]) is True
    assert await imp.sync_default_effects(30, 11, ["haste", "sneak"]) is True
    assert list(prisma.mobdefaulteffects.table) == [(30, 11, 4)]
    assert prisma.mobdefaulteffects.table[(30, 11, 4)].data == {"flags": ["haste", "sneak"]}


@pytest.mark.asyncio
async def test_sync_default_effects_removes_row_when_no_flags():
    prisma = MockPrisma({"status": 4})
    imp = MobImporter(prisma)
    await imp.sync_default_effects(30, 11, ["haste"])
    assert await imp.sync_default_effects(30, 11, []) is False
    assert prisma.mobdefaulteffects.table == {}
    assert prisma.mobdefaulteffects.deletes == [{"mobZoneId": 30, "mobId": 11, "effectId": 4}]


@pytest.mark.asyncio
async def test_sync_default_effects_noop_without_status_effect():
    prisma = MockPrisma({})
    imp = MobImporter(prisma)
    assert await imp.sync_default_effects(30, 11, ["haste"]) is False
    assert prisma.mobdefaulteffects.table == {}
