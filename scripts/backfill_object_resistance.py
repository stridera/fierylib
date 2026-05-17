#!/usr/bin/env python3
"""One-off backfill for ObjectResistance from legacy object JSON.

The full object importer (`object_importer.py`) now emits ObjectResistance
rows during `import-legacy`, but the live fierydev DB was last imported
before that change. This script reads `lib/world/obj/*.json` directly and
populates ObjectResistance using the same `EFFECT_TO_RESISTANCE` mapping
so we don't have to re-run the entire world import.

After this script, future `import-legacy` runs round-trip the same rows
via the importer — this is a one-shot bridge.

Usage:
    poetry run python scripts/backfill_object_resistance.py [--dry-run]
"""

import asyncio
import json
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent.parent / "src"))

from prisma import Prisma  # type: ignore

from fierylib.converters import legacy_id_to_composite
from fierylib.converters.flag_normalizer import normalize_flag
from fierylib.importers.object_importer import EFFECT_TO_RESISTANCE


LEGACY_OBJ_DIR = Path("/home/strider/Code/mud/lib/world/obj")


def parse_effect_tokens(raw: object) -> list[str]:
    """Pull effect tokens from the legacy object's 'effects' field.

    Legacy JSON stores effects as either a comma-separated string or a list.
    Tokens look like 'EFF_PROT_FIRE' or 'PROT_FIRE'; normalize the EFF_
    prefix away and run through the flag normalizer so we get the canonical
    name ('PROTECT_FIRE' etc.).
    """
    if not raw:
        return []
    if isinstance(raw, str):
        parts = [p.strip() for p in raw.split(",") if p.strip()]
    elif isinstance(raw, list):
        parts = [str(p).strip() for p in raw if p]
    else:
        return []

    cleaned: list[str] = []
    for token in parts:
        # Strip the legacy EFF_ prefix if present so flag_normalizer sees
        # the same shape the .obj parser hands to the live importer.
        if token.startswith("EFF_"):
            token = token[4:]
        normalized = normalize_flag(token)
        if normalized:
            cleaned.append(normalized)
    return cleaned


async def main(dry_run: bool = False) -> None:
    prisma = Prisma()
    await prisma.connect()
    try:
        per_object_rows: list[tuple[int, int, str, int]] = []
        scanned = 0

        for obj_file in sorted(LEGACY_OBJ_DIR.glob("*.json")):
            data = json.loads(obj_file.read_text())
            if not isinstance(data, list):
                continue
            legacy_zone = int(obj_file.stem)
            for obj in data:
                scanned += 1
                stats = obj.get("stats") or {}
                tokens = parse_effect_tokens(stats.get("effects"))
                if not tokens:
                    continue

                best_per_element: dict[str, int] = {}
                for tok in tokens:
                    mapping = EFFECT_TO_RESISTANCE.get(tok)
                    if mapping is None:
                        continue
                    element, value = mapping
                    if value > best_per_element.get(element, 0):
                        best_per_element[element] = value
                if not best_per_element:
                    continue

                # legacy vnum → composite (zoneId, id)
                legacy_vnum = int(obj["vnum"])
                obj_zone_id, obj_id = legacy_id_to_composite(legacy_vnum)
                for element, value in best_per_element.items():
                    per_object_rows.append((obj_zone_id, obj_id, element, value))

        print(f"Scanned {scanned} legacy objects, {len(per_object_rows)} resistance rows derived.")
        if dry_run:
            # Show element-count breakdown
            from collections import Counter
            element_counts = Counter(r[2] for r in per_object_rows)
            print("By element:", dict(element_counts.most_common()))
            return

        # Wipe and reinsert; ObjectResistance has a unique key on
        # (object_zone_id, object_id, element) so dedup is automatic.
        # Use the FK-safe pathway: only delete rows we're about to refill.
        affected_objects = {(z, i) for z, i, *_ in per_object_rows}
        deleted = 0
        for zone_id, obj_id in affected_objects:
            count = await prisma.objectresistance.delete_many(
                where={"objectZoneId": zone_id, "objectId": obj_id}
            )
            deleted += count
        print(f"Cleared {deleted} existing rows on {len(affected_objects)} objects.")

        created = 0
        skipped_missing_object = 0
        for zone_id, obj_id, element, value in per_object_rows:
            obj_row = await prisma.objects.find_unique(
                where={"zoneId_id": {"zoneId": zone_id, "id": obj_id}}
            )
            if obj_row is None:
                skipped_missing_object += 1
                continue
            await prisma.objectresistance.create(
                data={
                    "objectZoneId": zone_id,
                    "objectId": obj_id,
                    "element": element,
                    "value": value,
                    "allowAbsorption": False,
                }
            )
            created += 1
        print(f"Created {created} ObjectResistance rows.")
        if skipped_missing_object:
            print(f"Skipped {skipped_missing_object} (object not in DB — likely unimported zone).")

    finally:
        await prisma.disconnect()


if __name__ == "__main__":
    dry = "--dry-run" in sys.argv[1:]
    asyncio.run(main(dry_run=dry))
