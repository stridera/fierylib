"""Every patch that creates a table also hands it to the "Characters" owner.

Run by a superuser (postgres on prod) a patch otherwise leaves the table owned by postgres and
Prisma / the game get "permission denied" (ScriptLibrary, fierymud-rs week of 2026-10-14).
"""

import re
from pathlib import Path

from fierylib.seeders.sql_owner import owner_fixup_sql

SQL_DIR = Path(__file__).resolve().parents[1] / "data" / "sql"
FIRST_PATCH = "2026-10-08"  # EffectAura onwards; older patches predate the rule


def _patches():
    for p in sorted(SQL_DIR.glob("*.sql")):
        if p.name >= FIRST_PATCH:
            yield p, p.read_text(encoding="utf-8")


def test_every_table_creating_patch_fixes_ownership():
    checked = 0
    for path, sql in _patches():
        tables = re.findall(r'CREATE TABLE IF NOT EXISTS "([A-Za-z_]+)"', sql)
        if not tables:
            continue
        checked += 1
        own = sql.split("-- Environment-neutral ownership", 1)
        assert len(own) == 2, f"{path.name}: no ownership block"
        block = own[1]
        for table in tables:
            assert f"'{table}'" in block or f'"{table}" OWNER TO' in block, (path.name, table)
    assert checked >= 13


def test_helper_names_every_table_and_checks_the_characters_owner():
    sql = owner_fixup_sql(("A", "B"))
    assert "ARRAY['A', 'B']" in sql
    assert "tablename = 'Characters'" in sql
    assert sql.endswith("END $$;\n")
