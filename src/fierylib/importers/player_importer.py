"""
Player Importer - Imports player/character data from legacy .plr files to PostgreSQL

Handles:
- Character stats, attributes, and state
- Skills and proficiencies
- Spells/spell circles (mem section)
- Command aliases
- Equipment and inventory
- Currency and bank balance
- Password preservation (legacy Unix crypt format)
"""

import uuid
from typing import Optional, cast, Any
from pathlib import Path
from datetime import datetime

from mud.mudfile import MudFiles
from mud.types.player import Player
from mud.types import CurrentMax, Money
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
        # Stats collection for return; allow mixed value types (counts + optional data)
        stats: dict[str, Any] = {
            "character": 0,
            "skills": 0,
            "spells": 0,
            "aliases": 0,
        }

        # Prepare character data
        character_id = str(uuid.uuid4())

        # Parse hitpoints (format: CurrentMax, "current/max", or int) - REQUIRED
        if not player_data.hit_points:
            raise ValueError(f"Character '{player_data.name}' missing required hit_points data")

        if isinstance(player_data.hit_points, CurrentMax):
            hit_points = player_data.hit_points.current
            hit_points_max = player_data.hit_points.max
        elif isinstance(player_data.hit_points, str) and "/" in player_data.hit_points:
            current, max_hp = player_data.hit_points.split("/")
            hit_points = int(current)
            hit_points_max = int(max_hp)
        elif isinstance(player_data.hit_points, int):
            hit_points = hit_points_max = player_data.hit_points
        else:
            raise ValueError(f"Character '{player_data.name}' has invalid hit_points format: {player_data.hit_points}")

        # Parse movement (format: CurrentMax, "current/max", or int) - REQUIRED
        if not player_data.move:
            raise ValueError(f"Character '{player_data.name}' missing required movement data")

        if isinstance(player_data.move, CurrentMax):
            movement = player_data.move.current
            movement_max = player_data.move.max
        elif isinstance(player_data.move, str) and "/" in player_data.move:
            current, max_mv = player_data.move.split("/")
            movement = int(current)
            movement_max = int(max_mv)
        elif isinstance(player_data.move, int):
            movement = movement_max = player_data.move
        else:
            raise ValueError(f"Character '{player_data.name}' has invalid movement format: {player_data.move}")

        # Map gender
        gender_str = "neutral"
        if hasattr(player_data, 'gender') and player_data.gender:
            gender_str = player_data.gender.name.lower() if hasattr(player_data.gender, 'name') else str(player_data.gender).lower()

        # Map race - REQUIRED (all characters must have a race)
        if not hasattr(player_data, 'race') or not player_data.race:
            raise ValueError(f"Character '{player_data.name}' missing required race data")
        race_enum = player_data.race.name if hasattr(player_data.race, 'name') else str(player_data.race)

        # Derive raceType (string version used by frontend/game rules) - REQUIRED
        # The Prisma schema has a default of "human" which was masking missing/incorrect mappings.
        # We now always populate it explicitly to avoid silent fallbacks.
        # Mapping rule: lowercase enum name with underscores removed (e.g. HALF_ELF -> halfelf)
        race_type = race_enum.replace('_', '').lower()

        # Map class - REQUIRED (all characters must have a class)
        if not hasattr(player_data, 'player_class') or not player_data.player_class:
            raise ValueError(f"Character '{player_data.name}' missing required class data")
        player_class = player_data.player_class.name if hasattr(player_data.player_class, 'name') else str(player_data.player_class)

        # Prepare currency
        copper = silver = gold = platinum = 0
        if player_data.money:
            raw_money = player_data.money
            if isinstance(raw_money, dict):  # parser form
                money_dict = cast(dict[str, Any], raw_money)
                copper = int(money_dict.get("copper", 0) or 0)
                silver = int(money_dict.get("silver", 0) or 0)
                gold = int(money_dict.get("gold", 0) or 0)
                platinum = int(money_dict.get("plat", money_dict.get("platinum", 0)) or 0)
            else:  # Money dataclass
                copper = getattr(raw_money, "copper", 0)
                silver = getattr(raw_money, "silver", 0)
                gold = getattr(raw_money, "gold", 0)
                platinum = getattr(raw_money, "platinum", 0)

        bank_copper = bank_silver = bank_gold = bank_platinum = 0
        if player_data.bank:
            raw_bank = player_data.bank
            if isinstance(raw_bank, dict):
                bank_dict = cast(dict[str, Any], raw_bank)
                bank_copper = int(bank_dict.get("copper", 0) or 0)
                bank_silver = int(bank_dict.get("silver", 0) or 0)
                bank_gold = int(bank_dict.get("gold", 0) or 0)
                bank_platinum = int(bank_dict.get("plat", bank_dict.get("platinum", 0)) or 0)
            else:
                bank_copper = getattr(raw_bank, "copper", 0)
                bank_silver = getattr(raw_bank, "silver", 0)
                bank_gold = getattr(raw_bank, "gold", 0)
                bank_platinum = getattr(raw_bank, "platinum", 0)

        # Prepare stats (parser usually produces a dict; dataclass Stats also supported) - REQUIRED
        if not player_data.stats:
            raise ValueError(f"Character '{player_data.name}' missing required stats data")

        required_stats = ["strength", "intelligence", "wisdom", "dexterity", "constitution", "charisma"]
        if isinstance(player_data.stats, dict):
            stats_dict = cast(dict[str, Any], player_data.stats)
            for stat in required_stats:
                if stat not in stats_dict:
                    raise ValueError(f"Character '{player_data.name}' missing required stat: {stat}")
            strength = int(stats_dict["strength"])  # type: ignore[arg-type]
            intelligence = int(stats_dict["intelligence"])  # type: ignore[arg-type]
            wisdom = int(stats_dict["wisdom"])  # type: ignore[arg-type]
            dexterity = int(stats_dict["dexterity"])  # type: ignore[arg-type]
            constitution = int(stats_dict["constitution"])  # type: ignore[arg-type]
            charisma = int(stats_dict["charisma"])  # type: ignore[arg-type]
            # Luck is optional in legacy files, default to average if missing
            luck = int(stats_dict.get("luck", 13) or 13)  # type: ignore[arg-type]
        else:  # Stats dataclass
            strength = int(getattr(player_data.stats, "strength"))
            intelligence = int(getattr(player_data.stats, "intelligence"))
            wisdom = int(getattr(player_data.stats, "wisdom"))
            dexterity = int(getattr(player_data.stats, "dexterity"))
            constitution = int(getattr(player_data.stats, "constitution"))
            charisma = int(getattr(player_data.stats, "charisma"))
            luck = 13  # No luck attribute present in dataclass

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

        # Validate level - REQUIRED
        if not player_data.level or player_data.level < 1:
            raise ValueError(f"Character '{player_data.name}' has invalid level: {player_data.level}")

        # Preserve legacy password hash (Unix crypt format)
        # Authentication system must handle both bcrypt and legacy crypt formats
        # Store as-is for now; Muditor will validate on login and migrate to bcrypt
        password_hash = player_data.password

        # Create character
        character_data: dict[str, Any] = {
            "id": character_id,
            "name": player_data.name,
            "level": player_data.level,
            "alignment": player_data.alignment if player_data.alignment is not None else 0,
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
            "passwordHash": password_hash,
            "race": race_enum,
            "raceType": race_type,
            "gender": gender_str,
            "playerClass": player_class,
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
            "experience": player_data.experience if player_data.experience is not None else 0,
        }

        if not dry_run:
            await self.prisma.characters.create(data=character_data)  # type: ignore[attr-defined]
        stats["character"] = 1

        # If dry_run, include the prepared character data for test/introspection purposes
        if dry_run:
            stats["character_data"] = character_data

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

                # Look up ability in unified Ability table
                # Apply normalization to convert C++ name to database name
                db_ability_name = normalize_skill_name(normalized_name)
                ability = await self.prisma.ability.find_first(
                    where={"name": db_ability_name}
                )

                if ability and not dry_run:
                    await self.prisma.characterabilities.create(
                        data={
                            "characterId": character_id,
                            "abilityId": ability.id,
                            "known": True,
                            "proficiency": proficiency,
                        }
                    )
                    if check_spell:
                        stats["spells"] += 1
                    else:
                        stats["skills"] += 1
                elif not ability:
                    # Ability not found in database - skip it
                    if proficiency > 0:  # Only log if they actually had proficiency
                        ability_type = "Spell" if check_spell else "Skill"
                        print(f"  ⚠️  {ability_type} '{normalized_name}' (from {skill_name}) not found in database (proficiency: {proficiency})")

        # Import spell memorization (spell circles)
        # The "mem" section in .plr files contains spell circle data
        # Spells are now in unified Ability table
        if hasattr(player_data, 'spell_casts') and player_data.spell_casts:
            for spell_name, circle in player_data.spell_casts.items():
                # Remove SPELL_ prefix if present to match database
                normalized_name = spell_name
                if spell_name.startswith('SPELL_'):
                    normalized_name = spell_name[len('SPELL_'):]

                # Query from Ability table
                # Apply normalization to convert C++ name to database name
                db_spell_name = normalize_skill_name(normalized_name)
                ability = await self.prisma.ability.find_first(
                    where={"name": db_spell_name}
                )

                if ability:
                    # Create CharacterAbilities entry if not already exists
                    if not dry_run:
                        existing = await self.prisma.characterabilities.find_first(
                            where={
                                "characterId": character_id,
                                "abilityId": ability.id,
                            }
                        )
                        if not existing:
                            await self.prisma.characterabilities.create(
                                data={
                                    "characterId": character_id,
                                    "abilityId": ability.id,
                                    "known": True,
                                    "proficiency": 0,  # Will be set from skills data if available
                                }
                            )
                    stats["spells"] += 1
                elif not ability:
                    # Spell doesn't exist in database - skip it
                    if isinstance(circle, (int, str)) and (int(circle) if isinstance(circle, str) else circle) > 0:
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
