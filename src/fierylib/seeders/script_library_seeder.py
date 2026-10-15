"""Importable Lua libraries (ScriptLibrary table), loaded from ``data/script_libraries/*.lua``.

Libraries are what fierymud-rs scripts load with ``require("name")``. They live in git like the
trigger scripts and the file is the source of truth: every run upserts each file by name, so an
edit made to the same library in Muditor is replaced by the file on the next seed. (Libraries
that exist only in the database are never touched or deleted.)

File format::

    -- Library: wand-quest          (required; lowercase letters, digits, _ - . /, max 64)
    -- Zone: 30                     (optional owning zone; omit for a global library)
    -- Description: One line text   (optional)

    <lua code>

The header is the leading run of ``--`` comment lines; everything after it is the library body.
Comment lines inside the body (including the usage notes that follow the header) stay part of the
code. Mirrored DDL: ``data/sql/2026-10-14-script-library.sql``.
"""

import re
from dataclasses import dataclass
from pathlib import Path
from typing import Optional

NAME_RE = re.compile(r"^[a-z0-9_\-./]{1,64}$")


@dataclass
class ParsedLibrary:
    name: str
    zone_id: Optional[int]
    description: Optional[str]
    code: str
    file_path: Path


def parse_library_file(path: Path) -> ParsedLibrary:
    """Parse one library file; raises ValueError on a missing or invalid header."""
    text = path.read_text(encoding="utf-8")
    lines = text.split("\n")

    name: Optional[str] = None
    zone_id: Optional[int] = None
    description: Optional[str] = None
    body_start = 0
    for i, line in enumerate(lines):
        if not line.startswith("--"):
            body_start = i
            break
        body_start = i + 1
        if m := re.match(r"^-- Library:\s*(.+?)\s*$", line):
            name = m.group(1)
        elif m := re.match(r"^-- Zone:\s*(\d+)\s*$", line):
            zone_id = int(m.group(1))
        elif m := re.match(r"^-- Description:\s*(.*?)\s*$", line):
            description = m.group(1) or None

    if name is None:
        raise ValueError(f"Missing '-- Library: <name>' header in {path}")
    if not NAME_RE.match(name):
        raise ValueError(
            f"Invalid library name {name!r} in {path} "
            "(1-64 chars of lowercase letters, digits, '_', '-', '.', '/')"
        )

    # Keep the header's trailing comment block (usage notes) as part of the code: only the three
    # metadata lines are stripped.
    body_lines = [
        ln
        for ln in lines[:body_start]
        if not re.match(r"^-- (Library|Zone|Description):", ln)
    ] + lines[body_start:]
    code = "\n".join(body_lines).strip("\n") + "\n"
    return ParsedLibrary(name, zone_id, description, code, path)


class ScriptLibrarySeeder:
    def __init__(self, prisma):
        self.prisma = prisma

    async def seed_script_libraries(self, directory: Path, verbose: bool = False) -> dict:
        """Upsert every ``*.lua`` library under ``directory``.

        Returns ``{"imported": new rows, "updated": rows whose content changed, "skipped": errors}``.
        Raw SQL so it works with a Python Prisma client generated before the model existed.
        A library whose ``-- Zone:`` is not imported is skipped with a warning.
        """
        stats = {"imported": 0, "updated": 0, "skipped": 0}
        seen: dict[str, Path] = {}
        for path in sorted(directory.glob("*.lua")):
            try:
                lib = parse_library_file(path)
            except ValueError as err:
                print(f"  ⚠️  {err}")
                stats["skipped"] += 1
                continue
            if lib.name in seen:
                print(f"  ⚠️  duplicate library {lib.name!r}: {path.name} (already in {seen[lib.name].name})")
                stats["skipped"] += 1
                continue
            seen[lib.name] = path

            if lib.zone_id is not None:
                rows = await self.prisma.query_raw(
                    'SELECT 1 AS ok FROM "Zones" WHERE "id" = $1::int', lib.zone_id
                )
                if not rows:
                    print(f"  ⚠️  {path.name}: zone {lib.zone_id} does not exist, skipped")
                    stats["skipped"] += 1
                    continue

            existing = await self.prisma.query_raw(
                'SELECT 1 AS ok FROM "ScriptLibrary" WHERE "name" = $1', lib.name
            )
            changed = await self.prisma.execute_raw(
                'INSERT INTO "ScriptLibrary" ("name", "zone_id", "description", "code", "updated_at") '
                "VALUES ($1, $2::int, $3, $4, now()) "
                'ON CONFLICT ("name") DO UPDATE SET "zone_id" = EXCLUDED."zone_id", '
                '"description" = EXCLUDED."description", "code" = EXCLUDED."code", '
                '"updated_at" = now() '
                'WHERE ("ScriptLibrary"."zone_id", "ScriptLibrary"."description", "ScriptLibrary"."code") '
                'IS DISTINCT FROM (EXCLUDED."zone_id", EXCLUDED."description", EXCLUDED."code")',
                lib.name,
                lib.zone_id,
                lib.description,
                lib.code,
            )
            if not existing:
                stats["imported"] += 1
            elif changed:
                stats["updated"] += 1
            if verbose:
                print(f"  {lib.name} <- {path.name}")
        return stats
