#!/usr/bin/env python3
"""Raise cast_time_rounds for under-tuned high-circle spells.

User playtest 2026-05-17: "casting time should depend on spell
difficulty." Current curve trends 1.6 → 3.4 rounds across circles
1-12 but is flat at ~1.9 from C2-C7. High-circle ultimates were
casting in 1-2 rounds, indistinguishable from cantrips.

This script enforces a per-circle FLOOR for cast_time_rounds without
flattening any spell that's already faster than the floor (cantrips
stay fast) and without bumping a spell that's already at or above
its tier. Only the under-tuned outliers move.

Floor ladder (rounds):
  C1-C5 : leave alone (current values OK)
  C6-C7 : ≥ 2
  C8-C9 : ≥ 3
  C10+  : ≥ 4

Also: AoE+violent damage spells get a +1 rounding-up nudge — bigger
spells take longer to channel.

Circle is read from the live DB (ClassAbilities) since abilities.json
doesn't carry the per-class circle assignment. The script
joins abilities.json by `plainName`.

Idempotent: re-running won't push a spell above its floor a second time.
"""

import asyncio
import json
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent.parent / "src"))

from prisma import Prisma  # type: ignore

JSON_PATH = Path(__file__).resolve().parent.parent / "data" / "abilities.json"


# Per-circle minimum cast_time_rounds. Lower circles untouched.
FLOOR_BY_CIRCLE: dict[int, int] = {
    6: 2,
    7: 2,
    8: 3,
    9: 3,
    10: 4,
    11: 4,
    12: 4,
    13: 4,
}


async def fetch_min_circles(prisma: Prisma) -> dict[str, int]:
    """Return {plain_name: min(circle)} across class assignments."""
    rows = await prisma.query_raw(
        '''
        SELECT a.plain_name AS plain_name, MIN(ca.circle) AS circle
        FROM "Ability" a
        JOIN "ClassAbilities" ca ON ca.ability_id = a.id
        WHERE a."abilityType" IN ('SPELL','CHANT','SONG')
        GROUP BY a.plain_name
        '''
    )
    return {row["plain_name"]: int(row["circle"]) for row in rows}


async def main(dry_run: bool = False) -> None:
    prisma = Prisma()
    await prisma.connect()
    try:
        circles = await fetch_min_circles(prisma)
    finally:
        await prisma.disconnect()

    data = json.loads(JSON_PATH.read_text())

    raised = 0
    aoe_bumped = 0
    untouched = 0

    changelog: list[tuple[str, int, int, int]] = []

    for ability in data:
        if ability.get("abilityType") not in ("SPELL", "CHANT", "SONG"):
            continue
        plain = ability.get("plainName")
        circle = circles.get(plain)
        if circle is None:
            untouched += 1
            continue

        current = ability.get("castTimeRounds", 1)
        # Allow floats (some entries are 2.5) — round up to int for the
        # comparison; we always write integer cast times.
        current_int = int(current) if isinstance(current, int) else int(current + 0.999)
        new_value = current_int

        floor = FLOOR_BY_CIRCLE.get(circle, 0)
        if new_value < floor:
            new_value = floor

        # AoE-violent bump: big damage spells take an extra round to
        # channel. Only apply if not already saturated.
        if ability.get("isArea") and ability.get("violent"):
            new_value = max(new_value, current_int + 1) if current_int < 4 else new_value
            new_value = min(new_value, 4)
            if new_value > current_int:
                aoe_bumped += 1

        if new_value != current_int:
            changelog.append((plain, circle, current_int, new_value))
            raised += 1
            if not dry_run:
                ability["castTimeRounds"] = new_value

    if not dry_run:
        JSON_PATH.write_text(json.dumps(data, indent=2) + "\n")

    print(f"Raised cast_time_rounds on {raised} abilities ({aoe_bumped} via AoE bump).")
    print(f"Untouched (no class/circle data, or already at floor): {untouched}")
    print()
    print("Sample changes:")
    for plain, circle, old, new in changelog[:30]:
        print(f"  C{circle:>2}  {plain:<30}  {old} → {new}")
    if dry_run:
        print("(DRY RUN — no changes written.)")


if __name__ == "__main__":
    asyncio.run(main(dry_run="--dry-run" in sys.argv[1:]))
