"""
Quest Seeder - Import legacy CircleMUD quest definitions to PostgreSQL
"""

import re
from dataclasses import dataclass
from pathlib import Path
from prisma import Prisma
import click


@dataclass
class LegacyQuest:
    """Parsed legacy quest definition"""
    name: str
    id: int
    max_stages: int


def parse_legacy_quests(quests_file: Path) -> list[LegacyQuest]:
    """Parse legacy lib/misc/quests file

    Format: quest_name quest_id max_stages
    Example: troll_quest 1 3
    """
    quests = []

    with open(quests_file, 'r') as f:
        for line in f:
            line = line.strip()
            if not line or line.startswith('#'):
                continue

            parts = line.split()
            if len(parts) != 3:
                continue

            try:
                name = parts[0]
                quest_id = int(parts[1])
                max_stages = int(parts[2])
                quests.append(LegacyQuest(name=name, id=quest_id, max_stages=max_stages))
            except ValueError:
                continue

    return quests


def format_quest_name(name: str) -> str:
    """Convert quest_name_format to Title Case Display Name"""
    # Replace underscores with spaces and title case
    display = name.replace('_', ' ').title()
    # Fix common abbreviations
    display = display.replace(' Quest', ' Quest')
    return display


async def seed_legacy_quests(
    prisma: Prisma,
    quests_file: Path,
    zone_id: int = 0,
    dry_run: bool = False,
    verbose: bool = False
) -> int:
    """Seed legacy quests into the database

    Args:
        prisma: Prisma client
        quests_file: Path to legacy lib/misc/quests file
        zone_id: Zone ID for all imported quests (default: 0 for global)
        dry_run: If True, don't actually write to database
        verbose: Print verbose output

    Returns:
        Number of quests imported
    """
    if not quests_file.exists():
        click.echo(f"Warning: Quest file not found: {quests_file}")
        return 0

    quests = parse_legacy_quests(quests_file)

    if verbose:
        click.echo(f"Parsed {len(quests)} legacy quests")

    if dry_run:
        for q in quests:
            click.echo(f"  Would import: {q.name} (ID: {q.id}, stages: {q.max_stages})")
        return len(quests)

    # Check if zone exists
    zone = await prisma.zones.find_unique(where={"id": zone_id})
    if not zone:
        # Create a global zone for quests if it doesn't exist
        if zone_id == 0:
            click.echo(f"Creating global quest zone (ID: 0)...")
            await prisma.zones.create(
                data={
                    "id": 0,
                    "name": "&WGlobal Quests&0",
                    "plainName": "Global Quests",
                    "lifespan": 30,
                    "resetMode": "RESET_ALWAYS",
                    "builders": "God",
                    "lowRoom": 0,
                    "highRoom": 0,
                }
            )
        else:
            click.echo(f"Error: Zone {zone_id} does not exist")
            return 0

    imported = 0
    for q in quests:
        display_name = format_quest_name(q.name)

        try:
            # Check if quest already exists
            existing = await prisma.quests.find_unique(
                where={"zoneId_id": {"zoneId": zone_id, "id": q.id}}
            )

            if existing:
                if verbose:
                    click.echo(f"  Skipping existing: {q.name} (ID: {q.id})")
                continue

            # Create quest
            await prisma.quests.create(
                data={
                    "zoneId": zone_id,
                    "id": q.id,
                    "name": f"&W{display_name}&0",
                    "plainName": display_name,
                    "description": f"Legacy quest: {q.name}",
                    "shortDescription": f"Complete the {display_name}",
                    "minLevel": 1,
                    "maxLevel": 100,
                    "repeatable": False,
                    "shareable": True,
                    "autoAccept": False,
                    "hidden": False,
                    "triggerType": "MANUAL",  # Legacy quests are typically manual
                }
            )

            # Create phases for each stage
            for stage in range(1, q.max_stages + 1):
                await prisma.questphases.create(
                    data={
                        "questZoneId": zone_id,
                        "questId": q.id,
                        "id": stage,
                        "name": f"Stage {stage}",
                        "description": f"Stage {stage} of {display_name}",
                        "order": stage,
                    }
                )

            imported += 1
            if verbose:
                click.echo(f"  Imported: {q.name} -> {display_name} (ID: {q.id}, {q.max_stages} stages)")

        except Exception as e:
            click.echo(f"  Error importing {q.name}: {e}")

    click.echo(f"Imported {imported} quests")
    return imported


async def clear_legacy_quests(prisma: Prisma, zone_id: int = 0) -> int:
    """Clear legacy quests from database

    Args:
        prisma: Prisma client
        zone_id: Zone ID to clear quests from

    Returns:
        Number of quests deleted
    """
    result = await prisma.quests.delete_many(
        where={"zoneId": zone_id}
    )
    return result
