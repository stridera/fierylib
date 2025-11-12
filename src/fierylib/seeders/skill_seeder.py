"""Skill and Spell seeding functionality for initial database setup"""

import click
import re
from pathlib import Path
from typing import Dict
from prisma import Prisma
from mud.flags import SPELLS, PLAYER_SKILLS, BARDIC_SONGS, MONK_CHANTS
from fierylib.converters import normalize_skill_name


class SkillSeeder:
    """Seeds skills and spells into the Skills and Spells tables"""

    def __init__(self, prisma: Prisma):
        self.prisma = prisma
        self.spell_descriptions: Dict[str, str] = {}

    def parse_spell_help_file(self, help_file_path: Path) -> Dict[str, str]:
        """
        Parse the spells.hlp file to extract spell descriptions

        Format:
        SPELL_NAME or "MULTI WORD SPELL"

        Usage       : ...
        Level       : ...

        Description paragraph(s)
        #

        Args:
            help_file_path: Path to spells.hlp file

        Returns:
            Dictionary mapping spell names to descriptions
        """
        descriptions = {}

        if not help_file_path.exists():
            click.echo(f"    ⚠️  Spell help file not found: {help_file_path}")
            return descriptions

        try:
            with open(help_file_path, 'r', encoding='utf-8', errors='ignore') as f:
                content = f.read()

            # Split by # delimiter
            entries = content.split('#')

            for entry in entries:
                entry = entry.strip()
                if not entry:
                    continue

                lines = entry.split('\n')
                if not lines:
                    continue

                # First line is the spell name
                spell_name = lines[0].strip().strip('"').upper()

                # Find where the description starts (after the metadata)
                desc_start = 0
                for i, line in enumerate(lines):
                    if line.strip() and not any(keyword in line for keyword in
                        ['Usage', 'Accumulative', 'Duration', 'Level', 'Save', 'Circle']):
                        desc_start = i
                        break

                # Extract description (skip metadata lines)
                description_lines = []
                for i, line in enumerate(lines[1:], 1):
                    stripped = line.strip()
                    # Skip metadata lines
                    if any(keyword in line for keyword in ['Usage', 'Accumulative', 'Duration', 'Level', 'Save', 'Circle']):
                        continue
                    # Skip "See also" lines
                    if stripped.startswith('See also:'):
                        break
                    # Skip empty lines at start
                    if not stripped and not description_lines:
                        continue
                    # Add non-empty lines
                    if stripped:
                        description_lines.append(stripped)

                # Join description
                if description_lines:
                    # Take first 2-3 sentences for a concise description
                    desc = ' '.join(description_lines[:3])
                    # Normalize spell name (remove underscores for matching)
                    normalized_name = spell_name.replace(' ', '_').replace('-', '_')
                    descriptions[normalized_name] = desc[:500]  # Limit to 500 chars

            click.echo(f"    ✅ Parsed {len(descriptions)} spell descriptions from help file")

        except Exception as e:
            click.echo(f"    ⚠️  Error parsing spell help file: {e}")

        return descriptions

    async def seed_spells(self, skip_existing: bool = True, help_file_path: Path = None) -> dict:
        """
        Create all spells from legacy SPELLS definitions into Ability table

        Args:
            skip_existing: If True, skip spells that already exist (default)
            help_file_path: Optional path to spells.hlp file

        Returns:
            Dictionary with created spell counts
        """
        click.echo("  Seeding spells to Ability table...")

        # Parse spell descriptions if help file provided
        if help_file_path and help_file_path.exists():
            self.spell_descriptions = self.parse_spell_help_file(help_file_path)
        elif not help_file_path:
            # Try default path
            default_help_path = Path(__file__).parents[4] / "fierymud" / "legacy" / "lib" / "text" / "help" / "spells.hlp"
            if default_help_path.exists():
                self.spell_descriptions = self.parse_spell_help_file(default_help_path)

        spells_created = 0

        # ========================================
        # SPELLS (IDs 1-267) - Ability table
        # ========================================
        for i, spell_name in enumerate(SPELLS):
            if not spell_name or spell_name == "NONE":
                continue

            spell_id = i + 1  # Spell IDs start at 1
            name = spell_name  # No prefix for spells

            # Check if spell already exists
            if skip_existing:
                existing = await self.prisma.ability.find_first(where={"name": name})
                if existing:
                    continue

            # Get description from help file or use default
            normalized_name = name.replace(' ', '_').replace('-', '_')
            description = self.spell_descriptions.get(normalized_name, f"Spell: {name}")

            await self.prisma.ability.create(
                data={
                    "name": name,
                    "description": description,
                    "abilityType": "SPELL",
                    "notes": description,
                }
            )
            spells_created += 1

        click.echo(f"    ✅ Created {spells_created} spells")

        return {
            "spells": spells_created,
        }

    async def seed_skills(self, skip_existing: bool = True) -> dict:
        """
        Create all physical skills, songs, and chants from legacy definitions

        The legacy SKILLS dictionary maps:
        - IDs 401-495: PLAYER_SKILLS → Ability table (type: SKILL)
        - IDs 551-560: BARDIC_SONGS → Ability table (type: SONG)
        - IDs 601-618: MONK_CHANTS → Ability table (type: CHANT)

        Args:
            skip_existing: If True, skip skills that already exist (default)

        Returns:
            Dictionary with created skill counts
        """
        click.echo("  Seeding physical skills, songs, and chants to Ability table...")

        skills_created = 0
        songs_created = 0
        chants_created = 0

        # ========================================
        # PLAYER_SKILLS (IDs 401-495) - Ability table (type: SKILL)
        # ID ranges: 463-469 weapons, 452-462 sphere/magic, 401-451 & 471-495 combat/utility
        # ========================================
        for i, skill_base_name in enumerate(PLAYER_SKILLS):
            if not skill_base_name:
                continue

            skill_id = i + 401  # Player skills start at 401
            name = normalize_skill_name(skill_base_name)  # Apply normalization (e.g., 2H_ → TWO_HAND_)

            # Check if skill already exists
            if skip_existing:
                existing = await self.prisma.ability.find_first(where={"name": name})
                if existing:
                    continue

            # Build description
            description = f"Player skill: {skill_base_name.replace('_', ' ').title()}"

            # Add tags based on skill type
            tags = []
            if 463 <= skill_id <= 469:
                tags.append("weapon")
            elif 452 <= skill_id <= 462:
                tags.append("magic")
            elif any(keyword in skill_base_name.upper() for keyword in ['BACKSTAB', 'HIDE', 'SNEAK', 'STEAL', 'PICK_LOCK', 'POISON']):
                tags.append("stealth")
            elif any(keyword in skill_base_name.upper() for keyword in ['BASH', 'KICK', 'PARRY', 'DODGE', 'DUAL_WIELD', 'DISARM', 'RESCUE', 'TRACK']):
                tags.append("combat")
            elif any(keyword in skill_base_name.upper() for keyword in ['MOUNT', 'RIDING', 'BANDAGE', 'FIRST_AID', 'FORAGE', 'SWIM']):
                tags.append("survival")

            await self.prisma.ability.create(
                data={
                    "name": name,
                    "description": description,
                    "abilityType": "SKILL",
                    "tags": tags,
                }
            )
            skills_created += 1

        click.echo(f"    ✅ Created {skills_created} player skills")

        # ========================================
        # BARDIC_SONGS (IDs 551-560) - Ability table (type: SONG)
        # Bardic songs are performance-based skills for bards
        # ========================================
        for i, song_base_name in enumerate(BARDIC_SONGS):
            if not song_base_name:
                continue

            skill_id = i + 551  # Bardic songs start at 551
            name = normalize_skill_name(song_base_name)  # Apply normalization

            # Check if skill already exists
            if skip_existing:
                existing = await self.prisma.ability.find_first(where={"name": name})
                if existing:
                    continue

            await self.prisma.ability.create(
                data={
                    "name": name,
                    "description": f"Bardic song: {song_base_name.replace('_', ' ').title()}",
                    "abilityType": "SONG",
                    "tags": ["bardic", "performance"],
                }
            )
            songs_created += 1

        click.echo(f"    ✅ Created {songs_created} bardic songs")

        # ========================================
        # MONK_CHANTS (IDs 601-618) - Ability table (type: CHANT)
        # Monk chants are spiritual/ki-based abilities
        # ========================================
        for i, chant_base_name in enumerate(MONK_CHANTS):
            if not chant_base_name:
                continue

            skill_id = i + 601  # Monk chants start at 601
            name = normalize_skill_name(chant_base_name)  # Apply normalization

            # Check if skill already exists
            if skip_existing:
                existing = await self.prisma.ability.find_first(where={"name": name})
                if existing:
                    continue

            await self.prisma.ability.create(
                data={
                    "name": name,
                    "description": f"Monk chant: {chant_base_name.replace('_', ' ').title()}",
                    "abilityType": "CHANT",
                    "tags": ["monk", "ki"],
                }
            )
            chants_created += 1

        click.echo(f"    ✅ Created {chants_created} monk chants")

        total_created = skills_created + songs_created + chants_created
        click.echo(f"  ✅ Total skills/songs/chants created: {total_created}")

        return {
            "skills": skills_created,
            "songs": songs_created,
            "chants": chants_created,
            "total": total_created,
        }
