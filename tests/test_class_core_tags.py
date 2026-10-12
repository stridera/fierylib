"""Class.tags (core:<role>) must survive a reimport (classes.json -> importer; no DB)."""

import asyncio
import json
import re
from pathlib import Path

from fierylib.importers.class_importer_v2 import ClassImporterV2

ROOT = Path(__file__).resolve().parents[1]
CLASSES_JSON = ROOT / "data" / "classes.json"
SQL_PATH = ROOT / "data" / "sql" / "2026-10-12-core-class-tags.sql"


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


def _json_tags() -> dict[str, list[str]]:
    data = json.loads(CLASSES_JSON.read_text(encoding="utf-8"))
    return {
        c["plainName"].lower(): c["tags"]
        for c in data["classes"]
        if c.get("plainName") and c.get("tags")
    }


def test_classes_json_tags_monk_and_thief_only():
    assert _json_tags() == {"monk": ["core:monk"], "thief": ["core:thief"]}


def test_classes_json_in_sync_with_sql_patch():
    sql = SQL_PATH.read_text(encoding="utf-8")
    sql_tags = {
        name: [tag]
        for name, tag in re.findall(
            r"lower\(c\.plain_name\) = '([^']+)'\s+AND NOT \('([^']+)'", sql
        )
    }
    assert sql_tags == _json_tags()


def test_importer_writes_tags():
    prisma = _FakePrisma()
    data = json.loads(CLASSES_JSON.read_text(encoding="utf-8"))["classes"]
    asyncio.run(ClassImporterV2(prisma).import_classes(data))
    created = {d["plainName"].lower(): d for d in prisma.characterclass.created}
    assert created["monk"]["tags"] == ["core:monk"]
    assert created["thief"]["tags"] == ["core:thief"]
    # Untagged classes omit the key so the DB default ([]) applies.
    assert "tags" not in created["warrior"]
