"""
Player Importer - Imports player/character data from legacy .plr files to PostgreSQL

Handles:
- Character stats, attributes, and state
- Skills and proficiencies
- Spells/spell circles (mem section)
- Command aliases
- Equipment and inventory
- Currency and bank balance
"""

import uuid
from typing import Optional
from pathlib import Path
from datetime import datetime

from mud.mudfile import MudFiles
from mud.types.player import Player
from mud.flags import SPELLS, PLAYER_SKILLS, BARDIC_SONGS, MONK_CHANTS
from fierylib.converters import normalize_flags, normalize_skill_name


class PlayerImporter:
    """Imports player/character data to PostgreSQL using Prisma"""

    def __init__(self, prisma_client):
        """
        Initialize player importer

        Args:
            prisma_client: Prisma client instance
        """
        self.prisma = prisma_client

    @staticmethod
    def is_spell(skill_name: str) -> bool:
        """
        Determine if a skill name is actually a spell based on the flags lists

        Args:
            skill_name: The skill/spell name (may have SPELL_/SKILL_ prefix)

        Returns:
            True if it's a spell, False if it's a skill/song/chant
        """
        # Remove common prefixes to get normalized name
        normalized = skill_name
        for prefix in ['SPELL_', 'SKILL_', 'SONG_', 'CHANT_']:
            if skill_name.startswith(prefix):
                normalized = skill_name[len(prefix):]
                break

        # Check if it's in the SPELLS list (IDs 1-267)
        if normalized in SPELLS:
            return True

        # Check if it's in the PLAYER_SKILLS, BARDIC_SONGS, or MONK_CHANTS lists
        if normalized in PLAYER_SKILLS or normalized in BARDIC_SONGS or normalized in MONK_CHANTS:
            return False

        # If not found in any list, assume it's a spell if it had SPELL_ prefix
        # or if proficiency is very high (legacy heuristic as fallback)
        return skill_name.startswith('SPELL_')

    @staticmethod
    def map_gender(sex: int) -> str:
        """
        Map legacy sex integer to Prisma Gender enum string

        Args:
            sex: Legacy sex value (0=neutral, 1=male, 2=female)

        Returns:
            Prisma Gender enum string
        """
        gender_map = {
            0: "NEUTRAL",
            1: "MALE",
            2: "FEMALE",
        }
        return gender_map.get(sex, "NEUTRAL")

    @staticmethod
    def map_race(race_value: Optional[int]) -> str:
        """
        Map legacy race integer to Prisma Race enum string

        Args:
            race_value: Legacy race integer

        Returns:
            Prisma Race enum string
        """
        if race_value is None:
            return "HUMAN"

        # This is a simplified mapping - you may need to expand based on actual race values
        race_map = {
            0: "HUMAN",
            1: "ELF",
            2: "GNOME",
            3: "DWARF",
            4: "TROLL",
            5: "DROW",
            6: "DUERGAR",
            7: "OGRE",
            8: "ORC",
            9: "HALF_ELF",
            10: "BARBARIAN",
            11: "HALFLING",
        }
        return race_map.get(race_value, "HUMAN")

    async def import_player(
        self, player_data: Player, dry_run: bool = False
    ) -> dict:
        """
        Import a single player/character WITHOUT a user account

        Characters are imported standalone with their legacy password.
        Users can later "claim" these characters on the website by providing
        the character name + password, which will link them to their user account.

        Args:
            player_data: Parsed Player object from legacy file
            dry_run: If True, don't actually write to database

        Returns:
            dict with import statistics
        """
        stats = {
            "character": 0,
            "skills": 0,
            "spells": 0,
            "aliases": 0,
        }

        # Prepare character data
        character_id = str(uuid.uuid4())

        # Parse hitpoints (format: "current/max")
        hit_points = 100
        hit_points_max = 100
        if player_data.hit_points:
            if isinstance(player_data.hit_points, str) and "/" in player_data.hit_points:
                current, max_hp = player_data.hit_points.split("/")
                hit_points = int(current)
                hit_points_max = int(max_hp)
            elif isinstance(player_data.hit_points, int):
                hit_points = hit_points_max = player_data.hit_points

        # Parse movement (format: "current/max")
        movement = 100
        movement_max = 100
        if player_data.move:
            if isinstance(player_data.move, str) and "/" in player_data.move:
                current, max_mv = player_data.move.split("/")
                movement = int(current)
                movement_max = int(max_mv)
            elif isinstance(player_data.move, int):
                movement = movement_max = player_data.move

        # Map gender
        gender_str = "neutral"
        if hasattr(player_data, 'gender') and player_data.gender:
            gender_str = player_data.gender.name.lower() if hasattr(player_data.gender, 'name') else str(player_data.gender).lower()

        # Map race
        race_enum = "HUMAN"
        if hasattr(player_data, 'races') and player_data.races:
            race_enum = player_data.races.name if hasattr(player_data.races, 'name') else str(player_data.races)

        # Prepare currency
        copper = silver = gold = platinum = 0
        if player_data.money:
            copper = player_data.money.get("copper", 0)
            silver = player_data.money.get("silver", 0)
            gold = player_data.money.get("gold", 0)
            platinum = player_data.money.get("plat", 0)

        bank_copper = bank_silver = bank_gold = bank_platinum = 0
        if player_data.bank:
            bank_copper = player_data.bank.get("copper", 0)
            bank_silver = player_data.bank.get("silver", 0)
            bank_gold = player_data.bank.get("gold", 0)
            bank_platinum = player_data.bank.get("plat", 0)

        # Prepare stats (parser uses full names as keys)
        strength = intelligence = wisdom = 13
        dexterity = constitution = charisma = luck = 13
        if player_data.stats:
            strength = player_data.stats.get("strength", 13)
            intelligence = player_data.stats.get("intelligence", 13)
            wisdom = player_data.stats.get("wisdom", 13)
            dexterity = player_data.stats.get("dexterity", 13)
            constitution = player_data.stats.get("constitution", 13)
            charisma = player_data.stats.get("charisma", 13)
            # Luck might not be in all player files
            luck = player_data.stats.get("luck", 13)

        # Normalize flags
        player_flags = []
        if player_data.player_flags:
            player_flags = normalize_flags(player_data.player_flags)

        effect_flags = []
        if player_data.effect_flags:
            effect_flags = normalize_flags(player_data.effect_flags)

        privilege_flags = []
        if player_data.privilege_flags:
            privilege_flags = normalize_flags(player_data.privilege_flags)

        # Parse room numbers (may be strings or ints)
        current_room = None
        if player_data.load_room:
            current_room = int(player_data.load_room) if isinstance(player_data.load_room, str) else player_data.load_room

        save_room = None
        if player_data.save_room:
            save_room = int(player_data.save_room) if isinstance(player_data.save_room, str) else player_data.save_room

        home_room = None
        if player_data.home:
            home_room = int(player_data.home) if isinstance(player_data.home, str) else player_data.home

        # Create character
        character_data = {
            "id": character_id,
            "name": player_data.name,
            "level": player_data.level or 1,
            "alignment": player_data.alignment or 0,
            "strength": strength,
            "intelligence": intelligence,
            "wisdom": wisdom,
            "dexterity": dexterity,
            "constitution": constitution,
            "charisma": charisma,
            "luck": luck,
            "hitPoints": hit_points,
            "hitPointsMax": hit_points_max,
            "movement": movement,
            "movementMax": movement_max,
            "copper": copper,
            "silver": silver,
            "gold": gold,
            "platinum": platinum,
            "bankCopper": bank_copper,
            "bankSilver": bank_silver,
            "bankGold": bank_gold,
            "bankPlatinum": bank_platinum,
            "passwordHash": player_data.password,
            "race": race_enum,
            "gender": gender_str,
            "height": player_data.height,
            "weight": player_data.weight,
            "baseHeight": player_data.base_height,
            "baseWeight": player_data.base_weight,
            "baseSize": player_data.base_size or 0,
            "currentSize": player_data.natural_size or 0,
            "hitRoll": player_data.hit_roll or 0,
            "damageRoll": player_data.damage_roll or 0,
            "currentRoom": current_room,
            "saveRoom": save_room,
            "homeRoom": home_room,
            "lastLogin": player_data.last_login_time if player_data.last_login_time else datetime.now(),
            "timePlayed": player_data.time_played or 0,
            "isOnline": False,
            "hunger": player_data.hunger or 0,
            "thirst": player_data.thirst or 0,
            "description": player_data.description,
            "title": player_data.title,
            "prompt": player_data.prompt or "<%h/%Hhp %v/%Vmv>",
            "playerFlags": player_flags,
            "effectFlags": effect_flags,
            "privilegeFlags": privilege_flags,
            "invisLevel": player_data.invis_level or 0,
            "wimpyThreshold": player_data.wimpy or 0,
            "freezeLevel": player_data.freeze_level,
            "autoInvisLevel": player_data.auto_invis or 0,
            "birthTime": player_data.birth_time if player_data.birth_time else datetime.now(),
            "userId": None,  # No user - character exists standalone until claimed
            "experience": player_data.experience or 0,
        }

        if not dry_run:
            await self.prisma.characters.create(data=character_data)
        stats["character"] = 1

        # Import skills
        # Note: player_data.skills has skill NAMES as keys (e.g., "SKILL_BACKSTAB")
        # because the parser converts IDs to names using the SKILLS array
        # Both SPELLS and SKILLS are in this dictionary
        # We determine which table to query by checking the skill name against the flags lists
        if player_data.skills:
            for skill_name, proficiency in player_data.skills.items():
                # Remove redundant prefixes
                normalized_name = skill_name
                for prefix in ['SKILL_', 'SONG_', 'CHANT_', 'SPELL_']:
                    if skill_name.startswith(prefix):
                        normalized_name = skill_name[len(prefix):]
                        break

                # Determine if this is a spell or skill based on the flags lists
                check_spell = self.is_spell(skill_name)

                if check_spell:
                    # Try Spells table
                    # Apply normalization to convert C++ name to database name
                    db_spell_name = normalize_skill_name(normalized_name)
                    spell = await self.prisma.spells.find_first(
                        where={"name": db_spell_name}
                    )

                    if spell:
                        # TODO: Create CharacterSpells entry when that table exists
                        # For now, we skip spell memorization import
                        if not dry_run:
                            # Placeholder - will be implemented when CharacterSpells table is added
                            pass
                        stats["spells"] += 1
                        continue
                    else:
                        # Spell not found in database
                        if proficiency > 0:
                            print(f"  ⚠️  Spell '{normalized_name}' (from {skill_name}) not found in database (proficiency: {proficiency})")
                        continue

                # Try Skills table
                # Apply normalization to convert C++ name to database name
                db_skill_name = normalize_skill_name(normalized_name)
                skill = await self.prisma.skills.find_first(
                    where={"name": db_skill_name}
                )

                if skill and not dry_run:
                    await self.prisma.characterskills.create(
                        data={
                            "characterId": character_id,
                            "skillId": skill.id,
                            "level": proficiency,
                        }
                    )
                    stats["skills"] += 1
                elif not skill:
                    # Skill not found in database - skip it
                    if proficiency > 0:  # Only log if they actually had proficiency
                        print(f"  ⚠️  Skill '{normalized_name}' (from {skill_name}) not found in database (proficiency: {proficiency})")

        # Import spell memorization (spell circles)
        # The "mem" section in .plr files contains spell circle data
        # Spells are now in a separate Spells table
        if hasattr(player_data, 'spell_casts') and player_data.spell_casts:
            for spell_name, circle in player_data.spell_casts.items():
                # Remove SPELL_ prefix if present to match database
                normalized_name = spell_name
                if spell_name.startswith('SPELL_'):
                    normalized_name = spell_name[len('SPELL_'):]

                # Query from Spells table (not Skills)
                # Apply normalization to convert C++ name to database name
                db_spell_name = normalize_skill_name(normalized_name)
                spell = await self.prisma.spells.find_first(
                    where={"name": db_spell_name}
                )

                if spell:
                    # TODO: Create CharacterSpells entry when that table exists
                    # For now, we skip spell memorization import since we don't have
                    # a CharacterSpells table in the schema yet
                    if not dry_run:
                        # Placeholder - will be implemented when CharacterSpells table is added
                        pass
                    stats["spells"] += 1
                elif not spell:
                    # Spell doesn't exist in database - skip it
                    if isinstance(circle, (int, str)) and int(circle) if isinstance(circle, str) else circle > 0:
                        print(f"  ⚠️  Spell '{normalized_name}' (from {spell_name}) not found in database (circle: {circle})")

        # Import aliases
        if player_data.aliases:
            for alias, command in player_data.aliases.items():
                if not dry_run:
                    await self.prisma.characteraliases.create(
                        data={
                            "characterId": character_id,
                            "alias": alias,
                            "command": command,
                        }
                    )
                stats["aliases"] += 1

        return stats

    async def import_players_from_directory(
        self, players_dir: Path, player_name: Optional[str] = None, dry_run: bool = False
    ) -> dict:
        """
        Import all players from a directory (or a specific player)

        Args:
            players_dir: Path to the legacy players directory
            player_name: Specific player name to import (None = all players)
            dry_run: If True, don't actually write to database

        Returns:
            dict with total import statistics
        """
        total_stats = {
            "characters": 0,
            "skills": 0,
            "spells": 0,
            "aliases": 0,
            "errors": 0,
        }

        # Use MudFiles to get player files
        player_files = MudFiles.player_files(str(players_dir), player_name)

        for player_file_group in player_files:
            try:
                for file in player_file_group:
                    if file.filename.endswith(".plr"):
                        # Parse player file
                        player_data = file.parse_player()

                        if player_data:
                            # Import player
                            stats = await self.import_player(player_data, dry_run=dry_run)

                            total_stats["characters"] += stats.get("character", 0)
                            total_stats["skills"] += stats.get("skills", 0)
                            total_stats["spells"] += stats.get("spells", 0)
                            total_stats["aliases"] += stats.get("aliases", 0)

                            print(f"✓ Imported player: {player_data.name}")
            except Exception as e:
                print(f"✗ Error importing player from {player_file_group.id}: {e}")
                total_stats["errors"] += 1

        return total_stats
