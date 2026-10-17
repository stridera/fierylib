"""Keywords are for matching, not display: legacy '&' colour codes must not reach the DB.

Playtest r14 polish: Fountain 12:72 had keywords {&0&4a,Small,Fountain&0} and the Belt of GODLYNESS 12:5
had &1NEVER_LET_A_MORTAL_KEEP&0.
"""

import re
from pathlib import Path
from types import SimpleNamespace as NS
from unittest.mock import AsyncMock, MagicMock

import pytest

from fierylib.converters import strip_keyword_codes
from fierylib.importers.object_importer import ObjectImporter
from mud.types import Extras
from mud.types.object import Object

ROOT = Path(__file__).resolve().parent.parent


def test_strip_keyword_codes():
    assert strip_keyword_codes(["&0&4a", "Small", "Fountain&0"]) == ["a", "Small", "Fountain"]
    assert strip_keyword_codes(["belt", "&1NEVER_LET_A_MORTAL_KEEP&0"]) == ["belt", "NEVER_LET_A_MORTAL_KEEP"]
    assert strip_keyword_codes(["&0", "sword"]) == ["sword"]
    assert strip_keyword_codes(["rock&&roll"]) == ["rock&roll"]


@pytest.mark.asyncio
async def test_object_importer_writes_keywords_without_codes():
    prisma = MagicMock()
    upsert = AsyncMock()
    prisma.objects.upsert = upsert
    obj = Object(
        id=1272,
        type="FOUNTAIN",
        keywords=["&0&4a", "Small", "Fountain&0"],
        short="&0&4a Small Fountain&0",
        ground="A fountain.",
        extras=[Extras(keywords=["&1fountain&0"], text="Water.")],
        values={},
        flags=[],
        weight=1,
        cost=0,
    )
    await ObjectImporter(prisma).import_object(obj, 12)
    assert upsert.await_count >= 1
    data = upsert.await_args.kwargs["data"]
    assert data["create"]["keywords"] == ["Small", "Fountain"]
    assert data["update"]["keywords"] == ["Small", "Fountain"]
    created = [c.kwargs["data"] for c in prisma.objectextradescriptions.create.await_args_list]
    assert all("&" not in k for d in created for k in d["keywords"])


def test_keyword_patch_sql_is_guarded_and_code_free():
    sql = (ROOT / "data" / "sql" / "2026-10-17-keyword-codes.sql").read_text(encoding="utf-8")
    assert "UPDATE \"Objects\"" in sql
    # Every UPDATE is guarded on the current (dirty) keywords.
    assert sql.count("AND keywords = ") == sql.count("UPDATE ")
    new_values = re.findall(r"SET keywords = (ARRAY\[[^\]]*\])", sql)
    assert new_values and all("&" not in v for v in new_values)
