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

from mud.mudfile import MudFiles, MudData
from mud.types.player import Player
from mud.types.object import Object
from mud.types.pet import Pet
from mud.types import CurrentMax, Money
from mud.flags import SPELLS, PLAYER_SKILLS, BARDIC_SONGS, MONK_CHANTS
from fierylib.converters import normalize_flags, normalize_skill_name, EntityResolver, convert_legacy_colors


class PlayerImporter:
    """Imports player/character data to PostgreSQL using Prisma"""

    def __init__(self, prisma_client):
        """
        Initialize player importer

        Args:
            prisma_client: Prisma client instance
        """
        self.prisma = prisma_client
        self.resolver = EntityResolver(prisma_client)
        self._class_cache: dict[str, int] = {}  # plain_name -> class_id
        self._class_abilities_cache: dict[int, set[int]] = {}  # class_id -> set of ability_ids

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

    async def _get_class_id(self, class_name: str) -> int | None:
        """
        Look up class_id from Class table using plain_name

        Args:
            class_name: Class name from legacy file (e.g., "SORCERER", "Sorcerer")

        Returns:
            class_id if found, None otherwise
        """
        # Normalize class name for lookup (title case, handle variations)
        normalized = class_name.replace('_', '-').title()

        # Check cache first
        if normalized in self._class_cache:
            return self._class_cache[normalized]

        # Query database - CharacterClass model maps to "Class" table
        class_record = await self.prisma.characterclass.find_first(
            where={"plainName": normalized}
        )

        if class_record:
            self._class_cache[normalized] = class_record.id
            return class_record.id

        # Try exact match without normalization
        class_record = await self.prisma.characterclass.find_first(
            where={"plainName": class_name}
        )

        if class_record:
            self._class_cache[class_name] = class_record.id
            return class_record.id

        return None

    async def _get_class_spells(self, class_id: int) -> set[int]:
        """
        Get set of spell ability IDs valid for a class (from ClassAbilities only).

        Note: We only validate SPELLS, not physical skills, because:
        1. ClassAbilities contains complete spell data (extracted from spell_assign calls)
        2. ClassSkills is incomplete - it's missing loop-assigned skills from C++ init_class_skills()
           (e.g., MOUNT, RIDING, MEDITATE, KNOW_SPELL, etc. that are assigned to ALL classes)
        3. For legacy player imports, we want to preserve all skills the character had

        Args:
            class_id: The class ID to look up

        Returns:
            Set of spell ability IDs valid for this class
        """
        if class_id in self._class_abilities_cache:
            return self._class_abilities_cache[class_id]

        ability_ids: set[int] = set()

        # Get spells from ClassAbilities only
        # Note: ClassSkills is incomplete (missing loop-assigned skills), so we don't validate skills
        class_abilities = await self.prisma.classabilities.find_many(
            where={"classId": class_id}
        )
        for ca in class_abilities:
            ability_ids.add(ca.abilityId)

        self._class_abilities_cache[class_id] = ability_ids
        return ability_ids

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

        # Parse stamina (format: CurrentMax, "current/max", or int) - REQUIRED
        # Note: legacy field is called "move" but modern system uses "stamina"
        if not player_data.move:
            raise ValueError(f"Character '{player_data.name}' missing required stamina data")

        if isinstance(player_data.move, CurrentMax):
            stamina = player_data.move.current
            stamina_max = player_data.move.max
        elif isinstance(player_data.move, str) and "/" in player_data.move:
            current, max_mv = player_data.move.split("/")
            stamina = int(current)
            stamina_max = int(max_mv)
        elif isinstance(player_data.move, int):
            stamina = stamina_max = player_data.move
        else:
            raise ValueError(f"Character '{player_data.name}' has invalid stamina format: {player_data.move}")

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

        # Look up class_id from Class table (CRITICAL for ability circle lookup)
        class_id = await self._get_class_id(player_class)
        if class_id is None:
            print(f"  ⚠️  Warning: Class '{player_class}' not found in database for {player_data.name}")

        # Get valid SPELLS for this class (for spell validation during ability import)
        # Note: We only validate spells, not physical skills, because ClassSkills data is incomplete
        # (missing loop-assigned skills like MOUNT, MEDITATE, etc.)
        valid_spell_ids: set[int] = set()
        if class_id is not None:
            valid_spell_ids = await self._get_class_spells(class_id)

        # Prepare currency (convert to copper-equivalent wealth)
        # Exchange rates: 1 platinum = 1000 copper, 1 gold = 100 copper, 1 silver = 10 copper
        PLATINUM_SCALE = 1000
        GOLD_SCALE = 100
        SILVER_SCALE = 10

        wealth = 0
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
            wealth = copper + silver * SILVER_SCALE + gold * GOLD_SCALE + platinum * PLATINUM_SCALE

        bank_wealth = 0
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
            bank_wealth = bank_copper + bank_silver * SILVER_SCALE + bank_gold * GOLD_SCALE + bank_platinum * PLATINUM_SCALE

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

        # Normalize flags (skip legacy runtime flags that don't apply to modern system)
        legacy_runtime_flags = {"AUTOSAVE", "REMOVING", "SAVING"}
        player_flags = []
        if player_data.player_flags:
            player_flags = [f for f in normalize_flags(player_data.player_flags)
                           if f not in legacy_runtime_flags]

        # Parse room numbers and convert VNUMs to composite keys using EntityResolver
        # Resolver validates rooms exist in database before returning composite IDs
        async def resolve_room_vnum(vnum_raw) -> tuple[int | None, int | None]:
            """Resolve a room VNUM to (zone_id, local_id) tuple using EntityResolver"""
            if vnum_raw is None:
                return None, None
            vnum = int(vnum_raw) if isinstance(vnum_raw, str) else vnum_raw
            if vnum <= 0:
                return None, None
            context_zone = vnum // 100 if vnum >= 100 else 0
            result = await self.resolver.resolve_room(vnum, context_zone=context_zone)
            if result:
                return result.zone_id, result.id
            return None, None

        current_room_zone_id, current_room_id = await resolve_room_vnum(player_data.load_room)
        # Map save_room to recallRoom (schema no longer has separate save/home rooms)
        recall_room_zone_id, recall_room_id = await resolve_room_vnum(player_data.save_room)

        # Skip level 0 players (incomplete/new characters that never finished creation)
        if not player_data.level or player_data.level < 1:
            return {"skipped": True, "reason": "level_0"}

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
            "stamina": stamina,
            "staminaMax": stamina_max,
            "wealth": wealth,
            "bankWealth": bank_wealth,
            "passwordHash": password_hash,
            "race": race_enum,
            "raceType": race_type,
            "gender": gender_str,
            "playerClass": player_class,
            "classId": class_id,
            "height": player_data.height,
            "weight": player_data.weight,
            "baseHeight": player_data.base_height,
            "baseWeight": player_data.base_weight,
            "baseSize": player_data.base_size or 0,
            "currentSize": player_data.natural_size or 0,
            "hitRoll": player_data.hit_roll or 0,
            "damageRoll": player_data.damage_roll or 0,
            "currentRoomZoneId": current_room_zone_id,
            "currentRoomId": current_room_id,
            "recallRoomZoneId": recall_room_zone_id,
            "recallRoomId": recall_room_id,
            "lastLogin": player_data.last_login_time if player_data.last_login_time else datetime.now(),
            "timePlayed": player_data.time_played or 0,
            "isOnline": False,
            "hunger": player_data.hunger or 0,
            "thirst": player_data.thirst or 0,
            "description": convert_legacy_colors(player_data.description) if player_data.description else None,
            "title": player_data.title,
            "prompt": convert_legacy_colors(player_data.prompt) if player_data.prompt else "<%h/%Hhp %v/%Vmv>",
            "playerFlags": player_flags,
            "invisLevel": player_data.invis_level or 0,
            "wimpyThreshold": player_data.wimpy or 0,
            "freezeLevel": player_data.freeze_level,
            "autoInvisLevel": player_data.auto_invis or 0,
            "birthTime": player_data.birth_time if player_data.birth_time else datetime.now(),
            "userId": None,  # No user - character exists standalone until claimed
            "experience": player_data.experience if player_data.experience is not None else 0,
        }

        if not dry_run:
            # Try to find existing character by name
            existing = await self.prisma.characters.find_first(
                where={"name": player_data.name}
            )

            if existing:
                # Update existing character and use its ID for equipment
                character_id = existing.id
                # Remove 'id' from update data (can't update primary key)
                update_data = {k: v for k, v in character_data.items() if k != "id"}
                await self.prisma.characters.update(
                    where={"id": character_id},
                    data=update_data
                )

                # Delete existing skills/spells/aliases/items to avoid duplicates
                await self.prisma.characterabilities.delete_many(where={"characterId": character_id})
                await self.prisma.characteraliases.delete_many(where={"characterId": character_id})
                await self.prisma.characteritems.delete_many(where={"characterId": character_id})
            else:
                # Create new character
                await self.prisma.characters.create(data=character_data)
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
                # Skip invalid/placeholder skills
                if skill_name in ['NONE', 'UNUSED', ''] or not skill_name:
                    continue

                # Remove redundant prefixes
                normalized_name = skill_name
                for prefix in ['SKILL_', 'SONG_', 'CHANT_', 'SPELL_']:
                    if skill_name.startswith(prefix):
                        normalized_name = skill_name[len(prefix):]
                        break

                # Skip if normalized name is invalid
                if normalized_name in ['NONE', 'UNUSED', ''] or not normalized_name:
                    continue

                # Determine if this is a spell or skill based on the flags lists
                check_spell = self.is_spell(skill_name)

                # Look up ability in unified Ability table by plainName (CODE_STYLE format)
                # Apply normalization to convert C++ name to database name
                db_ability_name = normalize_skill_name(normalized_name)
                ability = await self.prisma.ability.find_first(
                    where={"plainName": db_ability_name}
                )

                if ability and not dry_run:
                    # Validate SPELLS are available for this class
                    # Note: We only validate spells, not physical skills, because ClassSkills
                    # data is incomplete (missing loop-assigned skills from C++ init_class_skills)
                    if check_spell and valid_spell_ids and ability.id not in valid_spell_ids:
                        # Only warn if they had significant proficiency
                        if proficiency > 0:
                            print(f"  ⚠️  Spell '{normalized_name}' not available for {player_class} ({player_data.name}) - proficiency: {proficiency}")
                        if "skipped" not in stats:
                            stats["skipped"] = 0
                        stats["skipped"] += 1
                        continue

                    try:
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
                    except Exception as e:
                        # Skip abilities that fail to import (e.g., FK constraints)
                        pass
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

                # Query from Ability table by plainName (CODE_STYLE format)
                # Apply normalization to convert C++ name to database name
                db_spell_name = normalize_skill_name(normalized_name)
                ability = await self.prisma.ability.find_first(
                    where={"plainName": db_spell_name}
                )

                if ability:
                    # Validate spell is available for this class
                    if valid_spell_ids and ability.id not in valid_spell_ids:
                        # Only warn about meaningful circles
                        circle_val = int(circle) if isinstance(circle, str) else circle
                        if circle_val > 0:
                            print(f"  ⚠️  Spell '{normalized_name}' not available for {player_class} ({player_data.name}) - circle: {circle_val}")
                        if "skipped" not in stats:
                            stats["skipped"] = 0
                        stats["skipped"] += 1
                        continue

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
                    try:
                        await self.prisma.characteraliases.create(
                            data={
                                "characterId": character_id,
                                "alias": alias,
                                "command": command,
                            }
                        )
                        stats["aliases"] += 1
                    except Exception as e:
                        # Skip aliases that fail to import (e.g., FK constraints)
                        pass
                else:
                    stats["aliases"] += 1

        # Add character_id to stats for equipment/pet import
        stats["character_id"] = character_id
        return stats

    async def _import_equipment(self, character_id: str, objs_file_path: str) -> int:
        """
        Import character equipment and inventory items from .objs file

        Args:
            character_id: Character UUID
            objs_file_path: Path to .objs file

        Returns:
            Number of items imported
        """
        item_count = 0

        try:
            with open(objs_file_path, 'r') as f:
                content = f.read()

            # Skip version line
            lines = content.split('\n')
            if not lines or lines[0].strip() != '1':
                print(f"  ⚠️  Unsupported .objs version: {lines[0] if lines else 'empty'}")
                return 0

            # Parse each object block (separated by ~~)
            blocks = content.split('~~\n')

            for block in blocks[1:]:  # Skip first block (before first ~~)
                if not block.strip():
                    continue

                # Extract vnum and location
                vnum = None
                location = None

                for line in block.split('\n'):
                    line = line.strip()
                    if line.startswith('vnum:'):
                        vnum = int(line.split(':')[1].strip())
                    elif line.startswith('location:'):
                        location = int(line.split(':')[1].strip())

                    # Stop once we have both
                    if vnum is not None and location is not None:
                        break

                # Import if valid vnum (not custom item)
                if vnum is not None and vnum != -1 and location is not None:
                    # Resolve object vnum to composite key using EntityResolver
                    context_zone = vnum // 100 if vnum >= 100 else 0
                    obj_result = await self.resolver.resolve_object(vnum, context_zone=context_zone)

                    if obj_result:
                        zone_id = obj_result.zone_id
                        object_id = obj_result.id
                        # Convert location number to equipped location name
                        equipped_location = self._location_to_slot(location)

                        # Create CharacterItem
                        try:
                            await self.prisma.characteritems.create(
                                data={
                                    "characterId": character_id,
                                    "objectZoneId": zone_id,
                                    "objectId": object_id,
                                    "equippedLocation": equipped_location,
                                    "condition": 100,
                                    "charges": -1,  # Default: unlimited/not applicable
                                    "updatedAt": datetime.utcnow(),
                                }
                            )
                            item_count += 1
                        except Exception as e:
                            # Skip items that fail to import (e.g., FK constraints)
                            pass
                    # else: Skip items with missing prototypes (silently)
                elif vnum == -1:
                    # Skip custom items for now
                    pass

        except Exception as e:
            print(f"  ⚠️  Error parsing .objs file: {e}")
            import traceback
            traceback.print_exc()

        return item_count

    def _location_to_slot(self, location: int) -> str | None:
        """
        Convert CircleMUD wear location number to slot name

        Args:
            location: Wear location number from .objs file

        Returns:
            Slot name or None for inventory
        """
        # CircleMUD wear locations
        # See: https://github.com/tbamud/tbamud/blob/master/src/constants.c
        location_map = {
            0: "LIGHT",          # Light source
            1: "FINGER_RIGHT",   # Right finger
            2: "FINGER_LEFT",    # Left finger
            3: "NECK_1",         # Around neck 1
            4: "NECK_2",         # Around neck 2
            5: "BODY",           # On body
            6: "HEAD",           # On head
            7: "LEGS",           # On legs
            8: "FEET",           # On feet
            9: "HANDS",          # On hands
            10: "ARMS",          # On arms
            11: "SHIELD",        # As shield
            12: "ABOUT",         # About body (cloak)
            13: "WAIST",         # Around waist
            14: "WRIST_RIGHT",   # Right wrist
            15: "WRIST_LEFT",    # Left wrist
            16: "WIELD",         # Wielded weapon
            17: "HOLD",          # Held item
            18: "EARS",          # Ears
            19: "BADGE",         # Badge
            20: "FACE",          # Face
            127: None,           # Inventory (not equipped)
        }

        return location_map.get(location)

    async def _import_pet(self, character_id: str, pet_data: Pet) -> bool:
        """
        Import character pet

        Args:
            character_id: Character UUID
            pet_data: Parsed Pet object

        Returns:
            True if pet was successfully imported, False otherwise
        """
        # Resolve mob vnum to composite key using EntityResolver
        context_zone = pet_data.id // 100 if pet_data.id >= 100 else 0
        mob_result = await self.resolver.resolve_mob(pet_data.id, context_zone=context_zone)

        if mob_result:
            zone_id = mob_result.zone_id
            vnum = mob_result.id
            try:
                # Create pet in CharacterPets table
                await self.prisma.characterpets.create(
                    data={
                        "id": str(uuid.uuid4()),
                        "characterId": character_id,
                        "mobPrototypeZoneId": zone_id,
                        "mobPrototypeVnum": vnum,
                        "name": pet_data.name,
                        "customDescription": pet_data.desc if pet_data.desc else None,
                    }
                )
                return True
            except Exception as e:
                # Log the error for debugging
                print(f"  ⚠️  Failed to import pet (zone_id={zone_id}, vnum={vnum}): {e}")
                return False
        # else: Skip pets with missing mob prototypes
        print(f"  ⚠️  Pet mob prototype not found (legacy vnum={pet_data.id})")
        return False

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
            "equipment": 0,
            "pets": 0,
            "skipped": 0,
            "errors": 0,
        }

        # Use MudFiles to get player files
        player_files = MudFiles.player_files(str(players_dir), player_name)

        for player_file_group in player_files:
            player_data = None
            character_id = None

            try:
                # First pass: Process .plr file to create character
                for file in player_file_group:
                    if file.filename.endswith(".plr"):
                        player_data = file.parse_player()

                        if player_data:
                            stats = await self.import_player(player_data, dry_run=dry_run)

                            # Skip level 0 players (incomplete characters)
                            if stats.get("skipped"):
                                print(f"⏭ Skipped player: {player_data.name} (level 0)")
                                total_stats["skipped"] += 1
                                continue

                            character_id = stats.get("character_id")

                            total_stats["characters"] += stats.get("character", 0)
                            total_stats["skills"] += stats.get("skills", 0)
                            total_stats["spells"] += stats.get("spells", 0)
                            total_stats["aliases"] += stats.get("aliases", 0)

                            print(f"✓ Imported player: {player_data.name}")

                # Second pass: Process equipment, pets, quests (requires character_id)
                if character_id and not dry_run:
                    for file in player_file_group:
                        if file.filename.endswith(".objs"):
                            # Import equipment using simplified vnum-only parser
                            item_count = await self._import_equipment(character_id, file.filename)
                            total_stats["equipment"] += item_count
                            if item_count > 0:
                                print(f"  ✓ Imported {item_count} items for {player_data.name}")

                        elif file.filename.endswith(".pet"):
                            # Parse and import pets
                            pet_data = file.parse_player()
                            if pet_data:
                                success = await self._import_pet(character_id, pet_data)
                                if success:
                                    total_stats["pets"] += 1
                                    print(f"  ✓ Imported pet for {player_data.name}")

                        # TODO: .quest files - need to understand format first

            except Exception as e:
                print(f"✗ Error importing player from {player_file_group.id}: {e}")
                import traceback
                traceback.print_exc()
                total_stats["errors"] += 1

        return total_stats
