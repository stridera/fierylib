"""WeatherText lines and SpellCircle recovery times: seeder constants, SQL patches and the
seeder logic stay in sync (no DB)."""

import asyncio
import re
from pathlib import Path

from fierylib.seeders.spell_circle_seeder import SPELL_CIRCLES, SpellCircleSeeder
from fierylib.seeders.weather_text_seeder import WEATHER_TEXTS, WeatherTextSeeder

ROOT = Path(__file__).resolve().parents[1]
SQL_DIR = ROOT / "data" / "sql"
WEATHER_SQL = (SQL_DIR / "2026-10-12-weather-text.sql").read_text(encoding="utf-8")
CIRCLE_SQL = (SQL_DIR / "2026-10-12-spell-circle-recover.sql").read_text(encoding="utf-8")
SCHEMA = (ROOT.parent / "muditor/packages/db/prisma/schema.prisma").read_text(encoding="utf-8")

DAYPARTS = {"dawn", "day", "midday", "evening", "night", "any"}


def test_weather_sql_matches_seeder():
    rows = re.findall(r"\('([A-Z]+)', '([a-z]+)', '((?:[^']|'')*)'\)", WEATHER_SQL)
    rows = [(c, d, t.replace("''", "'")) for c, d, t in rows]
    assert rows == WEATHER_TEXTS


def test_weather_keys_unique_and_valid():
    keys = [(c, d) for c, d, _ in WEATHER_TEXTS]
    assert len(keys) == len(set(keys)) == 20
    schema_climates = set(
        w for w in re.search(r"enum Climate \{(.*?)\}", SCHEMA, re.S).group(1).split() if w.isupper()
    )
    assert {c for c, _ in keys} == schema_climates  # every climate has a line
    assert {d for _, d in keys} <= DAYPARTS
    assert all(text.strip() for _, _, text in WEATHER_TEXTS)
    # Every climate except NONE has a day and a night line; NONE is a single "any" line.
    for climate in schema_climates - {"NONE"}:
        assert (climate, "day") in keys and (climate, "night") in keys
    assert ("NONE", "any") in keys


def test_weather_ddl_matches_prisma_model():
    assert re.search(r"model WeatherText \{\s*climate Climate\s*daypart String\s*text\s+String\?", SCHEMA)
    assert 'PRIMARY KEY ("climate","daypart")' in WEATHER_SQL
    assert '"text" TEXT,' in WEATHER_SQL


def test_spell_circle_sql_matches_seeder():
    rows = [(int(a), int(b)) for a, b in re.findall(r"\((\d+), (\d+)\)", CIRCLE_SQL)]
    assert rows == SPELL_CIRCLES
    assert [c for c, _ in SPELL_CIRCLES] == list(range(1, 15))
    secs = [s for _, s in SPELL_CIRCLES]
    assert secs == sorted(secs) and len(set(secs)) == 14


def test_spell_circle_ddl_matches_prisma_model():
    assert re.search(r"model SpellCircle \{\s*circle\s+Int\s+@id\s*recoverSecs Int\?\s+@map\(\"recover_secs\"\)", SCHEMA)
    assert '"recover_secs" INTEGER,' in CIRCLE_SQL
    assert 'CONSTRAINT "SpellCircle_pkey" PRIMARY KEY ("circle")' in CIRCLE_SQL


class _FakeDb:
    """Emulates the WeatherText / SpellCircle upserts the seeders issue via execute_raw."""

    def __init__(self, weather=None, circles=None):
        self.weather = dict(weather or {})
        self.circles = dict(circles or {})

    @staticmethod
    def _upsert(store, key, value):
        if key not in store or (store[key] is None and value is not None):
            store[key] = value
            return 1
        return 0

    async def execute_raw(self, sql, *args):
        if 'INTO "WeatherText"' in sql:
            climate, daypart, text = args
            return self._upsert(self.weather, (climate, daypart), text)
        if 'INTO "SpellCircle"' in sql:
            circle, secs = args
            return self._upsert(self.circles, circle, secs)
        raise AssertionError(sql)


def test_weather_seeder_creates_fills_and_keeps_builder_edits():
    db = _FakeDb({("ARID", "day"): "Custom heat.", ("ARID", "night"): None})
    stats = asyncio.run(WeatherTextSeeder(db).seed_weather_text())
    assert db.weather[("ARID", "day")] == "Custom heat."  # builder edit survives
    assert db.weather[("ARID", "night")].startswith("The desert chill")  # NULL filled
    assert len(db.weather) == len(WEATHER_TEXTS)
    assert stats == {"changed": len(WEATHER_TEXTS) - 1}
    assert asyncio.run(WeatherTextSeeder(db).seed_weather_text()) == {"changed": 0}


def test_spell_circle_seeder_creates_fills_and_keeps_builder_edits():
    db = _FakeDb(circles={1: 99, 2: None})
    stats = asyncio.run(SpellCircleSeeder(db).seed_spell_circles())
    assert db.circles[1] == 99  # builder edit survives
    assert db.circles[2] == 35  # NULL filled
    assert len(db.circles) == 14
    assert stats == {"changed": 13}
    assert asyncio.run(SpellCircleSeeder(db).seed_spell_circles()) == {"changed": 0}
