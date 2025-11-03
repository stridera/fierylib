"""
Race Importer for FieryMUD

Imports race data from data/races.json into PostgreSQL database:
- Full race base data to Races table (physical stats, combat modifiers, permanent effects)
- Race skill/spell assignments to RaceSkills table
"""

import json
from pathlib import Path
from typing import Dict, List, Optional
from prisma import Prisma
from prisma.enums import Race, SkillCategory, RaceAlign, Size, LifeForce, Composition, EffectFlag


# Map skill/spell names to skill IDs (must match database Skills table)
SKILL_NAME_TO_ID = {
    # Weapon skills
    'SKILL_SLASHING': None,  # Will be resolved from database
    'SKILL_PIERCING': None,
    'SKILL_BLUDGEONING': None,
    'SKILL_BREATHE_FIRE': None,
    'SKILL_BREATHE_FROST': None,
    'SKILL_BREATHE_ACID': None,
    'SKILL_BREATHE_GAS': None,
    'SKILL_BREATHE_LIGHTNING': None,

    # Spells
    'SPELL_MAGIC_MISSILE': None,
}

# Map race names to Race enum values
RACE_NAME_TO_ENUM = {
    'human': Race.HUMAN,
    'elf': Race.ELF,
    'gnome': Race.GNOME,
    'dwarf': Race.DWARF,
    'troll': Race.TROLL,
    'drow': Race.DROW,
    'duergar': Race.DUERGAR,
    'ogre': Race.OGRE,
    'orc': Race.ORC,
    'half_elf': Race.HALF_ELF,
    'halfelf': Race.HALF_ELF,  # Alternative spelling
    'barbarian': Race.BARBARIAN,
    'halfling': Race.HALFLING,
    'plant': Race.PLANT,
    'humanoid': Race.HUMANOID,
    'animal': Race.ANIMAL,
    'dragon_general': Race.DRAGON_GENERAL,
    'giant': Race.GIANT,
    'other': Race.OTHER,
    'goblin': Race.GOBLIN,
    'demon': Race.DEMON,
    'brownie': Race.BROWNIE,
    'dragon_fire': Race.DRAGON_FIRE,
    'dragon_frost': Race.DRAGON_FROST,
    'dragon_acid': Race.DRAGON_ACID,
    'dragon_lightning': Race.DRAGON_LIGHTNING,
    'dragon_gas': Race.DRAGON_GAS,
    'dragonborn_fire': Race.DRAGONBORN_FIRE,
    'dragonborn_frost': Race.DRAGONBORN_FROST,
    'dragonborn_acid': Race.DRAGONBORN_ACID,
    'dragonborn_lightning': Race.DRAGONBORN_LIGHTNING,
    'dragonborn_gas': Race.DRAGONBORN_GAS,
    'sverfneblin': Race.SVERFNEBLIN,
    'faerie_seelie': Race.FAERIE_SEELIE,
    'faerie_unseelie': Race.FAERIE_UNSEELIE,
    'nymph': Race.NYMPH,
    'arborean': Race.ARBOREAN,
}


class RaceImporter:
    """Importer for race data into PostgreSQL."""

    def __init__(self, db: Prisma):
        """Initialize importer with database connection."""
        self.db = db
        self.skill_name_cache: Dict[str, int] = {}

    async def load_skill_mappings(self):
        """Load skill name to ID mappings from database."""
        print("Loading skill mappings from database...")

        skills = await self.db.skills.find_many()

        for skill in skills:
            # Try to match skill names
            skill_upper = skill.name.upper().replace(' ', '_').replace('-', '_')

            # Create mapping variations
            self.skill_name_cache[f'SKILL_{skill_upper}'] = skill.id
            self.skill_name_cache[f'SPELL_{skill_upper}'] = skill.id
            self.skill_name_cache[skill.name.upper()] = skill.id

        print(f"✓ Loaded {len(self.skill_name_cache)} skill mappings")

    def resolve_skill_id(self, skill_name: str) -> Optional[int]:
        """Resolve skill name to database ID."""
        # Try exact match first
        if skill_name in self.skill_name_cache:
            return self.skill_name_cache[skill_name]

        # Try variations
        variations = [
            skill_name,
            skill_name.replace('SKILL_', '').replace('SPELL_', ''),
            skill_name.replace('_', ' ').title(),
        ]

        for variation in variations:
            if variation in self.skill_name_cache:
                return self.skill_name_cache[variation]

        return None

    def normalize_race_name(self, race_name: str) -> str:
        """Normalize race name to match RACE_NAME_TO_ENUM keys."""
        # Convert to lowercase and replace spaces/hyphens with underscores
        normalized = race_name.lower().replace(' ', '_').replace('-', '_')
        return normalized

    async def import_races(self, races_json_path: Path, dry_run: bool = False) -> Dict[str, int]:
        """
        Import races from JSON file.

        Args:
            races_json_path: Path to races.json file
            dry_run: If True, validate but don't commit to database

        Returns:
            Dictionary with import statistics
        """
        print(f"{'[DRY RUN] ' if dry_run else ''}Importing races from {races_json_path}")

        # Load race data
        with races_json_path.open() as f:
            data = json.load(f)

        races = data.get('races', [])
        print(f"Found {len(races)} races in source file")

        # Load skill mappings
        await self.load_skill_mappings()

        stats = {
            'races_created': 0,
            'races_updated': 0,
            'race_skills_created': 0,
            'race_skills_updated': 0,
            'race_skills_skipped': 0,
            'errors': []
        }

        for race_data in races:
            race_name = race_data['name']
            normalized_name = self.normalize_race_name(race_name)

            # Get Race enum value
            race_enum = RACE_NAME_TO_ENUM.get(normalized_name)
            if not race_enum:
                print(f"⚠ Warning: Unknown race '{race_name}' (normalized: '{normalized_name}')")
                stats['errors'].append(f"Unknown race: {race_name}")
                continue

            # Import base race data to Races table
            try:
                if not dry_run:
                    # Parse permanent effects
                    permanent_effects = []
                    for effect_str in race_data.get('permanentEffects', []):
                        try:
                            permanent_effects.append(EffectFlag[effect_str])
                        except KeyError:
                            print(f"  ⚠ Unknown effect flag: {effect_str}")

                    # Check if race already exists
                    existing_race = await self.db.races.find_unique(
                        where={'race': race_enum}
                    )

                    race_db_data = {
                        'name': race_data['name'],
                        'keywords': race_data['keywords'],
                        'displayName': race_data['displayName'],
                        'fullName': race_data['fullName'],
                        'plainName': race_data['plainName'],
                        'playable': race_data['playable'],
                        'humanoid': race_data['humanoid'],
                        'magical': race_data['magical'],
                        'raceAlign': RaceAlign[race_data['raceAlign']],
                        'defaultSize': Size[race_data['defaultSize']],
                        'defaultAlignment': race_data['defaultAlignment'],
                        'bonusDamroll': race_data['bonusDamroll'],
                        'bonusHitroll': race_data['bonusHitroll'],
                        'focusBonus': race_data['focusBonus'],
                        'defaultLifeforce': LifeForce[race_data['defaultLifeforce']],
                        'defaultComposition': Composition[race_data['defaultComposition']],
                        'maleWeightLow': race_data['maleWeightLow'],
                        'maleWeightHigh': race_data['maleWeightHigh'],
                        'maleHeightLow': race_data['maleHeightLow'],
                        'maleHeightHigh': race_data['maleHeightHigh'],
                        'femaleWeightLow': race_data['femaleWeightLow'],
                        'femaleWeightHigh': race_data['femaleWeightHigh'],
                        'femaleHeightLow': race_data['femaleHeightLow'],
                        'femaleHeightHigh': race_data['femaleHeightHigh'],
                        'maxStrength': race_data['maxStats']['str'],
                        'maxDexterity': race_data['maxStats']['dex'],
                        'maxIntelligence': race_data['maxStats']['int'],
                        'maxWisdom': race_data['maxStats']['wis'],
                        'maxConstitution': race_data['maxStats']['con'],
                        'maxCharisma': race_data['maxStats']['cha'],
                        'expFactor': race_data['expFactor'],
                        'hpFactor': race_data['hpFactor'],
                        'hitDamageFactor': race_data['hitDamageFactor'],
                        'damageDiceFactor': race_data['damageDiceFactor'],
                        'copperFactor': race_data['copperFactor'],
                        'acFactor': race_data['acFactor'],
                        'enterVerb': race_data.get('enterVerb'),
                        'leaveVerb': race_data.get('leaveVerb'),
                        'permanentEffects': permanent_effects,
                    }

                    if existing_race:
                        # Update existing race
                        await self.db.races.update(
                            where={'race': race_enum},
                            data=race_db_data
                        )
                        stats['races_updated'] += 1
                        print(f"✓ Updated: {race_data['displayName']}")
                    else:
                        # Create new race
                        await self.db.races.create(
                            data={
                                'race': race_enum,
                                **race_db_data
                            }
                        )
                        stats['races_created'] += 1
                        print(f"✓ Created: {race_data['displayName']}")
                else:
                    print(f"[DRY RUN] Would create/update race: {race_data['displayName']}")
                    stats['races_created'] += 1

            except Exception as e:
                error_msg = f"Failed to import race {race_name}: {e}"
                print(f"✗ {error_msg}")
                stats['errors'].append(error_msg)
                continue

            # Import race skills
            skills = race_data.get('skills', [])
            if skills and not dry_run:
                print(f"  Processing {len(skills)} skills...")

                for skill_data in skills:
                    skill_name = skill_data['skillName']
                    min_level = skill_data['minLevel']
                    category = skill_data.get('category', 'PRIMARY')

                    # Resolve skill ID
                    skill_id = self.resolve_skill_id(skill_name)
                    if not skill_id:
                        print(f"    ⚠ Skill not found: {skill_name}")
                        stats['race_skills_skipped'] += 1
                        continue

                    # Create or update RaceSkills entry
                    try:
                        existing = await self.db.raceskills.find_unique(
                            where={
                                'race_skillId': {
                                    'race': race_enum,
                                    'skillId': skill_id
                                }
                            }
                        )

                        if existing:
                            # Update existing
                            await self.db.raceskills.update(
                                where={
                                    'race_skillId': {
                                        'race': race_enum,
                                        'skillId': skill_id
                                    }
                                },
                                data={
                                    'category': SkillCategory[category],
                                    'bonus': 0,  # Default bonus for racial skills
                                }
                            )
                            stats['race_skills_updated'] += 1
                            print(f"    ✓ Updated skill: {skill_name}")
                        else:
                            # Create new
                            await self.db.raceskills.create(
                                data={
                                    'race': race_enum,
                                    'skillId': skill_id,
                                    'category': SkillCategory[category],
                                    'bonus': 0,  # Default bonus
                                }
                            )
                            stats['race_skills_created'] += 1
                            print(f"    ✓ Created skill: {skill_name}")

                    except Exception as e:
                        error_msg = f"Failed to import skill {skill_name} for race {race_enum.value}: {e}"
                        print(f"    ✗ {error_msg}")
                        stats['errors'].append(error_msg)

        # Print summary
        print("\n" + "=" * 60)
        print("IMPORT SUMMARY")
        print("=" * 60)
        print(f"Races created: {stats['races_created']}")
        print(f"Races updated: {stats['races_updated']}")
        print(f"Race skills created: {stats['race_skills_created']}")
        print(f"Race skills updated: {stats['race_skills_updated']}")
        print(f"Race skills skipped: {stats['race_skills_skipped']}")
        if stats['errors']:
            print(f"\nErrors ({len(stats['errors'])}):")
            for error in stats['errors'][:10]:  # Show first 10 errors
                print(f"  - {error}")

        return stats


async def import_races_from_json(races_json_path: Path, dry_run: bool = False) -> Dict[str, int]:
    """
    Import races from JSON file into database.

    Args:
        races_json_path: Path to races.json file
        dry_run: If True, validate but don't commit changes

    Returns:
        Dictionary with import statistics
    """
    db = Prisma()
    await db.connect()

    try:
        importer = RaceImporter(db)
        stats = await importer.import_races(races_json_path, dry_run=dry_run)
        return stats
    finally:
        await db.disconnect()
