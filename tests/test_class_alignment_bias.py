"""Class.alignmentBias must survive a reimport (classes.json -> importer; no DB)."""

import asyncio
import json
import re
from pathlib import Path

from fierylib.importers.class_importer_v2 import ClassImporterV2

ROOT = Path(__file__).resolve().parents[1]
CLASSES_JSON = ROOT / "data" / "classes.json"
SQL_PATH = ROOT / "data" / "sql" / "2026-10-08-class-alignment-bias.sql"


class _FakeClassTable:
    def __init__(self):
        self.created = []

    async def find_first(self, where):
        return None

    async def create(self, data):
        self.created.append(data)


class _FakePrisma:
    def __init__(self):
        self.characterclass = _FakeClassTable()


def _json_biases() -> dict[str, int]:
    data = json.loads(CLASSES_JSON.read_text(encoding="utf-8"))
    return {
        c["plainName"].lower(): c["alignmentBias"]
        for c in data["classes"]
        if c.get("plainName") and "alignmentBias" in c
    }


def test_classes_json_has_legacy_biases_for_nine_classes():
    assert _json_biases() == {
        "paladin": 100,
        "priest": 100,
        "ranger": 50,
        "druid": 50,
        "anti-paladin": -100,
        "diabolist": -100,
        "necromancer": -100,
        "thief": -50,
        "assassin": -50,
    }


def test_classes_json_in_sync_with_sql_patch():
    sql = SQL_PATH.read_text(encoding="utf-8")
    sql_biases = {n: int(b) for n, b in re.findall(r"^\s+\('([^']+)', (-?\d+)\)[,]?$", sql, re.M)}
    assert sql_biases == _json_biases()


def test_importer_writes_alignment_bias():
    prisma = _FakePrisma()
    data = json.loads(CLASSES_JSON.read_text(encoding="utf-8"))["classes"]
    asyncio.run(ClassImporterV2(prisma).import_classes(data))
    created = {d["plainName"].lower(): d for d in prisma.characterclass.created}
    assert created["paladin"]["alignmentBias"] == 100
    assert created["anti-paladin"]["alignmentBias"] == -100
    assert created["thief"]["alignmentBias"] == -50
    # Classes without a bias are omitted so the DB default (0) applies.
    assert "alignmentBias" not in created["warrior"]
