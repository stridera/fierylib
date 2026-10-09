"""Class.campcraftBonus must survive a reimport (classes.json -> importer; no DB)."""

import asyncio
import json
import re
from pathlib import Path

from fierylib.importers.class_importer_v2 import ClassImporterV2

ROOT = Path(__file__).resolve().parents[1]
CLASSES_JSON = ROOT / "data" / "classes.json"
SQL_PATH = ROOT / "data" / "sql" / "2026-10-09-campcraft.sql"


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


def _json_campers() -> set[str]:
    data = json.loads(CLASSES_JSON.read_text(encoding="utf-8"))
    return {
        c["plainName"].lower()
        for c in data["classes"]
        if c.get("plainName") and c.get("campcraftBonus")
    }


def test_classes_json_marks_ranger_and_druid_only():
    assert _json_campers() == {"ranger", "druid"}


def test_classes_json_in_sync_with_sql_patch():
    sql = SQL_PATH.read_text(encoding="utf-8")
    match = re.search(r"IN \(([^)]*)\)", sql)
    assert match
    sql_campers = set(re.findall(r"'([^']+)'", match.group(1)))
    assert sql_campers == _json_campers()


def test_importer_writes_campcraft_bonus():
    prisma = _FakePrisma()
    data = json.loads(CLASSES_JSON.read_text(encoding="utf-8"))["classes"]
    asyncio.run(ClassImporterV2(prisma).import_classes(data))
    created = {d["plainName"].lower(): d for d in prisma.characterclass.created}
    assert created["druid"]["campcraftBonus"] is True
    assert created["ranger"]["campcraftBonus"] is True
    # Classes without the bonus are omitted so the DB default (false) applies.
    assert "campcraftBonus" not in created["shaman"]
