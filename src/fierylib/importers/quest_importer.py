"""
Quest Importer - Creates quest definitions and imports player quest progress

Handles:
- Creating stub Zone entries for zones that have quest data but weren't imported
- Creating Quest definitions from legacy quest data
- Importing CharacterQuests entries from .quest files
- Mapping subclass quests (zone IDs >= 32768) to a dedicated zone
"""

import glob
import json
import os
from datetime import datetime
from typing import Optional

from prisma import Prisma

from mud.mudfile import MudData, MudFiles
from mud.types.quests import Quests as LegacyQuest

# Subclass quests use legacy zone IDs >= 32768 (0x8000)
SUBCLASS_QUEST_THRESHOLD = 32768
# Zone ID to house subclass/class quest definitions
SUBCLASS_QUEST_ZONE_ID = 900
SUBCLASS_QUEST_ZONE_NAME = "Class Quests"


class QuestImporter:
    """Imports quest definitions and player quest progress to PostgreSQL"""

    def __init__(self, prisma_client: Prisma):
        self.prisma = prisma_client
        # Map from legacy quest zone_id to (db_zone_id, quest_id)
        self._quest_map: dict[int, tuple[int, int]] = {}

    async def analyze_quest_files(self, players_dir: str) -> dict:
        """Scan all .quest files and return analysis of unique quests.

        Returns dict with:
            zone_quests: {legacy_zone_id: {stages, variables, player_count}}
            total_entries: int
            total_players: int
        """
        quest_files = glob.glob(os.path.join(players_dir, "*", "*.quest"))

        zone_quests: dict[int, dict] = {}
        total_entries = 0
        total_players = 0

        for qf in quest_files:
            with open(qf) as f:
                content = f.read().strip()
            if not content:
                continue
            total_players += 1

            lines = content.split("\n")
            i = 0
            while i < len(lines):
                line = lines[i].strip()
                if not line:
                    i += 1
                    continue
                parts = line.split()
                if len(parts) != 3:
                    i += 1
                    continue

                zone_id, stage, num_vars = int(parts[0]), int(parts[1]), int(parts[2])
                for _ in range(num_vars):
                    i += 1
                total_entries += 1

                if zone_id not in zone_quests:
                    zone_quests[zone_id] = {
                        "stages": set(),
                        "variables": set(),
                        "player_count": 0,
                        "max_stage": 0,
                    }
                zone_quests[zone_id]["stages"].add(stage)
                zone_quests[zone_id]["player_count"] += 1
                zone_quests[zone_id]["max_stage"] = max(
                    zone_quests[zone_id]["max_stage"], stage
                )
                i += 1

        return {
            "zone_quests": zone_quests,
            "total_entries": total_entries,
            "total_players": total_players,
        }

    async def create_quest_definitions(self, players_dir: str) -> int:
        """Create stub zones and quest definitions from legacy quest data.

        Returns the number of quest definitions created.
        """
        analysis = await self.analyze_quest_files(players_dir)
        zone_quests = analysis["zone_quests"]

        if not zone_quests:
            print("  No quest data found in player files")
            return 0

        # Get existing zone IDs
        existing_zones = await self.prisma.zones.find_many()
        existing_zone_ids = {z.id for z in existing_zones}

        # Separate normal vs subclass quests
        normal_quest_zones = {
            zid: data
            for zid, data in zone_quests.items()
            if zid < SUBCLASS_QUEST_THRESHOLD
        }
        subclass_quest_zones = {
            zid: data
            for zid, data in zone_quests.items()
            if zid >= SUBCLASS_QUEST_THRESHOLD
        }

        # Create stub zones for missing normal quest zones
        missing_zone_ids = [
            zid for zid in normal_quest_zones if zid not in existing_zone_ids
        ]
        if missing_zone_ids:
            print(
                f"  Creating {len(missing_zone_ids)} stub zones for quest-only zones..."
            )
            for zid in sorted(missing_zone_ids):
                player_count = normal_quest_zones[zid]["player_count"]
                await self.prisma.zones.create(
                    data={
                        "id": zid,
                        "name": f"Legacy Zone {zid} (Quest Only)",
                    }
                )
                print(
                    f"    Created stub zone {zid} ({player_count} players have quest data)"
                )

        # Create subclass quest zone if needed
        if subclass_quest_zones:
            if SUBCLASS_QUEST_ZONE_ID not in existing_zone_ids:
                await self.prisma.zones.create(
                    data={
                        "id": SUBCLASS_QUEST_ZONE_ID,
                        "name": SUBCLASS_QUEST_ZONE_NAME,
                    }
                )
                print(
                    f"  Created zone {SUBCLASS_QUEST_ZONE_ID} ({SUBCLASS_QUEST_ZONE_NAME}) for {len(subclass_quest_zones)} subclass quests"
                )

        # Create quest definitions
        quest_count = 0

        # Normal quests: one per zone, id=0
        for zid in sorted(normal_quest_zones.keys()):
            data = normal_quest_zones[zid]
            max_stage = data["max_stage"]
            await self.prisma.quests.create(
                data={
                    "zoneId": zid,
                    "id": 0,
                    "name": f"Zone {zid} Quest",
                    "plainName": f"Zone {zid} Quest",
                    "description": f"Legacy quest from zone {zid}. Max stage: {max_stage}. {data['player_count']} players had progress.",
                    "hidden": True,
                }
            )
            self._quest_map[zid] = (zid, 0)
            quest_count += 1

        # Subclass quests: all in the subclass zone, sequential IDs
        for idx, zid in enumerate(sorted(subclass_quest_zones.keys())):
            data = subclass_quest_zones[zid]
            quest_id = idx  # 0, 1, 2, ...
            await self.prisma.quests.create(
                data={
                    "zoneId": SUBCLASS_QUEST_ZONE_ID,
                    "id": quest_id,
                    "name": f"Subclass Quest (legacy {zid})",
                    "plainName": f"Subclass Quest (legacy {zid})",
                    "description": f"Legacy subclass quest (original ID {zid}). Max stage: {data['max_stage']}. {data['player_count']} players had progress.",
                    "hidden": True,
                }
            )
            self._quest_map[zid] = (SUBCLASS_QUEST_ZONE_ID, quest_id)
            quest_count += 1

        print(
            f"  Created {quest_count} quest definitions ({len(normal_quest_zones)} zone quests, {len(subclass_quest_zones)} subclass quests)"
        )
        return quest_count

    async def import_player_quests(
        self, character_id: str, quest_file_path: str
    ) -> int:
        """Import quest progress for a single character from their .quest file.

        Returns the number of quest entries imported.
        """
        with open(quest_file_path) as f:
            content = f.read().strip()
        if not content:
            return 0

        lines = content.split("\n")
        imported = 0
        i = 0

        while i < len(lines):
            line = lines[i].strip()
            if not line:
                i += 1
                continue
            parts = line.split()
            if len(parts) != 3:
                i += 1
                continue

            legacy_zone_id, stage, num_vars = (
                int(parts[0]),
                int(parts[1]),
                int(parts[2]),
            )
            variables: dict[str, str] = {}
            for _ in range(num_vars):
                i += 1
                if i < len(lines):
                    var_parts = lines[i].strip().split(None, 1)
                    if len(var_parts) == 2:
                        variables[var_parts[0]] = var_parts[1]

            # Look up the quest definition
            quest_key = self._quest_map.get(legacy_zone_id)
            if quest_key is None:
                i += 1
                continue

            db_zone_id, quest_id = quest_key

            # Stage 255 = completed in legacy system
            status = "COMPLETED" if stage == 255 else "IN_PROGRESS"

            try:
                await self.prisma.characterquests.create(
                    data={
                        "characterId": character_id,
                        "questZoneId": db_zone_id,
                        "questId": quest_id,
                        "status": status,
                        "completionCount": 1 if status == "COMPLETED" else 0,
                        "variables": json.dumps(
                            {"stage": stage, "vars": variables}
                        ),
                    }
                )
                imported += 1
            except Exception:
                # Likely duplicate (same character + quest combo) — skip
                pass

            i += 1

        return imported

    async def import_all(self, players_dir: str) -> dict:
        """Full quest import: create definitions then import all player quest progress.

        Returns stats dict.
        """
        stats = {
            "quest_definitions": 0,
            "stub_zones": 0,
            "player_quests": 0,
            "players_with_quests": 0,
            "errors": 0,
        }

        # Step 1: Create quest definitions
        print("Creating quest definitions from legacy data...")
        stats["quest_definitions"] = await self.create_quest_definitions(players_dir)

        # Step 2: Import player quest progress
        print("Importing player quest progress...")

        # We need character IDs. Look up all characters in DB and match by name.
        characters = await self.prisma.characters.find_many(
            where={"deletedAt": None}
        )
        char_map = {c.name.lower(): c.id for c in characters}
        print(f"  Found {len(char_map)} characters in database")

        quest_files = glob.glob(os.path.join(players_dir, "*", "*.quest"))
        for qf in quest_files:
            player_name = os.path.basename(qf).replace(".quest", "")
            character_id = char_map.get(player_name.lower())
            if not character_id:
                continue

            try:
                count = await self.import_player_quests(character_id, qf)
                if count > 0:
                    stats["player_quests"] += count
                    stats["players_with_quests"] += 1
            except Exception as e:
                print(f"  Error importing quests for {player_name}: {e}")
                stats["errors"] += 1

        print(
            f"  Imported {stats['player_quests']} quest entries for {stats['players_with_quests']} players"
        )
        return stats
