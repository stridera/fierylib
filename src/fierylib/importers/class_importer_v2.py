"""
Class Importer V2 - Imports class data with proper circle handling

Imports:
- Class definitions (CharacterClass table)
- Physical skill assignments (ClassSkills table)
- Spell assignments (SpellClassCircles table)
- Class circle access levels (ClassCircles table)
"""

import json
import click
from pathlib import Path
from typing import Dict, List
from prisma import Prisma
from fierylib.converters import normalize_skill_name


class ClassImporterV2:
    """Imports class and skill assignment data with circle support"""

    def __init__(self, prisma_client):
        self.prisma = prisma_client

    async def import_classes(self, classes_data: List[Dict], skip_existing: bool = True) -> Dict:
        """Import class definitions to CharacterClass table"""
        stats = {"classes_created": 0, "classes_skipped": 0, "errors": 0}

        click.echo("  Importing class definitions...")

        for class_data in classes_data:
            try:
                # Skip classes with None name (e.g., layman placeholder)
                if class_data.get("name") is None or class_data.get("plainName") is None:
                    stats["classes_skipped"] += 1
                    continue

                # Check if class already exists (by plainName since that's unique)
                if skip_existing:
                    existing = await self.prisma.characterclass.find_first(
                        where={"plainName": class_data["plainName"]}
                    )
                    if existing:
                        stats["classes_skipped"] += 1
                        continue

                # Create class with all combat-related fields
                create_data = {
                    "name": class_data["name"],  # With XML-Lite colors
                    "plainName": class_data["plainName"],  # Plain text (Python doesn't have middleware)
                }

                # Add optional combat modifier fields if present
                if "description" in class_data:
                    create_data["description"] = class_data["description"]
                if "hitDice" in class_data:
                    create_data["hitDice"] = class_data["hitDice"]
                if "primaryStat" in class_data:
                    create_data["primaryStat"] = class_data["primaryStat"]
                if "bonusHitroll" in class_data:
                    create_data["bonusHitroll"] = class_data["bonusHitroll"]
                if "bonusDamroll" in class_data:
                    create_data["bonusDamroll"] = class_data["bonusDamroll"]
                if "baseAc" in class_data:
                    create_data["baseAc"] = class_data["baseAc"]
                if "hpPerLevel" in class_data:
                    create_data["hpPerLevel"] = class_data["hpPerLevel"]
                if "thac0Base" in class_data:
                    create_data["thac0Base"] = class_data["thac0Base"]
                if "thac0PerLevel" in class_data:
                    create_data["thac0PerLevel"] = class_data["thac0PerLevel"]
                if "resistances" in class_data:
                    create_data["resistances"] = class_data["resistances"]

                await self.prisma.characterclass.create(data=create_data)

                stats["classes_created"] += 1
                click.echo(f"    ✓ Imported class: {class_data['plainName']}")

            except Exception as e:
                click.echo(f"    ✗ Error importing class {class_data.get('plainName', 'unknown')}: {e}")
                stats["errors"] += 1

        click.echo(f"  ✅ Classes imported: {stats['classes_created']}, skipped: {stats['classes_skipped']}")
        return stats

    async def import_class_skills(
        self,
        class_skills_data: List[Dict],
        skip_existing: bool = True,
        dry_run: bool = False
    ) -> Dict:
        """
        Import PHYSICAL skill assignments (not spells) to ClassSkills table
        """
        stats = {
            "assignments_created": 0,
            "assignments_skipped": 0,
            "skill_not_found": 0,
            "class_not_found": 0,
            "errors": 0,
        }

        click.echo("  Importing physical skill assignments (SKILL, SONG, CHANT)...")

        # Filter to only non-spell assignments
        skills_only = [s for s in class_skills_data if s.get('abilityType') != 'SPELL']

        # Group by class
        by_class: Dict[str, List[Dict]] = {}
        for assignment in skills_only:
            class_name_with_prefix = assignment["className"]
            class_name = class_name_with_prefix.replace("CLASS_", "").replace("_", "-").lower()

            if class_name not in by_class:
                by_class[class_name] = []
            by_class[class_name].append(assignment)

        for class_name, assignments in sorted(by_class.items()):
            # Look up by plainName (title-cased, e.g., "sorcerer" -> "Sorcerer", "anti-paladin" -> "Anti-Paladin")
            character_class = await self.prisma.characterclass.find_first(
                where={"plainName": class_name.title()}
            )

            if not character_class:
                click.echo(f"    ⚠️  Class '{class_name}' not found, skipping {len(assignments)} assignments")
                stats["class_not_found"] += len(assignments)
                continue

            click.echo(f"    Processing {character_class.plainName}: {len(assignments)} skills")

            for assignment in assignments:
                try:
                    # Normalize C++ name to database plainName (e.g., 2H_BLUDGEONING → TWO_HAND_BLUDGEONING)
                    normalized_skill_name = normalize_skill_name(assignment["skillName"])
                    ability = await self.prisma.ability.find_first(
                        where={"plainName": normalized_skill_name}
                    )

                    if not ability:
                        stats["skill_not_found"] += 1
                        if assignment["minLevel"] > 1:
                            click.echo(f"      ⚠️  Skill '{assignment['skillName']}' not found (level {assignment['minLevel']})")
                        continue

                    if skip_existing:
                        existing = await self.prisma.classskills.find_first(
                            where={
                                "classId": character_class.id,
                                "abilityId": ability.id,
                            }
                        )
                        if existing:
                            stats["assignments_skipped"] += 1
                            continue

                    if not dry_run:
                        await self.prisma.classskills.create(
                            data={
                                "classId": character_class.id,
                                "abilityId": ability.id,
                                "minLevel": assignment["minLevel"],
                            }
                        )

                    stats["assignments_created"] += 1

                except Exception as e:
                    click.echo(f"      ✗ Error: {e}")
                    stats["errors"] += 1

        click.echo(f"  ✅ Physical skills: {stats['assignments_created']}, skipped: {stats['assignments_skipped']}")
        if stats["skill_not_found"] > 0:
            click.echo(f"  ⚠️  Skills not found: {stats['skill_not_found']}")

        return stats

    async def import_spell_circles(
        self,
        class_skills_data: List[Dict],
        skip_existing: bool = True,
        dry_run: bool = False
    ) -> Dict:
        """
        Import SPELL assignments to SpellClassCircles table with circle info
        """
        stats = {
            "assignments_created": 0,
            "assignments_skipped": 0,
            "spell_not_found": 0,
            "class_not_found": 0,
            "errors": 0,
        }

        click.echo("  Importing spell circle assignments...")

        # Filter to only spell assignments (those with circles)
        spells_only = [s for s in class_skills_data if 'circle' in s]

        # Group by class
        by_class: Dict[str, List[Dict]] = {}
        for assignment in spells_only:
            class_name_with_prefix = assignment["className"]
            class_name = class_name_with_prefix.replace("CLASS_", "").replace("_", "-").lower()

            if class_name not in by_class:
                by_class[class_name] = []
            by_class[class_name].append(assignment)

        for class_name, assignments in sorted(by_class.items()):
            # Look up by plainName (title-cased, e.g., "sorcerer" -> "Sorcerer", "anti-paladin" -> "Anti-Paladin")
            character_class = await self.prisma.characterclass.find_first(
                where={"plainName": class_name.title()}
            )

            if not character_class:
                click.echo(f"    ⚠️  Class '{class_name}' not found, skipping {len(assignments)} spells")
                stats["class_not_found"] += len(assignments)
                continue

            click.echo(f"    Processing {character_class.plainName}: {len(assignments)} spells")

            for assignment in assignments:
                try:
                    # Look up spell in Ability table by plainName
                    # Note: Spells don't currently need normalization, but we apply it for consistency
                    normalized_spell_name = normalize_skill_name(assignment["skillName"])
                    ability = await self.prisma.ability.find_first(
                        where={"plainName": normalized_spell_name}
                    )

                    if not ability:
                        stats["spell_not_found"] += 1
                        click.echo(f"      ⚠️  Spell '{assignment['skillName']}' not found (circle {assignment['circle']})")
                        continue

                    if skip_existing:
                        existing = await self.prisma.classabilities.find_first(
                            where={
                                "classId": character_class.id,
                                "abilityId": ability.id,
                            }
                        )
                        if existing:
                            stats["assignments_skipped"] += 1
                            continue

                    if not dry_run:
                        await self.prisma.classabilities.create(
                            data={
                                "classId": character_class.id,
                                "abilityId": ability.id,
                                "circle": assignment["circle"],
                            }
                        )

                    stats["assignments_created"] += 1

                except Exception as e:
                    click.echo(f"      ✗ Error: {e}")
                    stats["errors"] += 1

        click.echo(f"  ✅ Spell circles: {stats['assignments_created']}, skipped: {stats['assignments_skipped']}")
        if stats["spell_not_found"] > 0:
            click.echo(f"  ⚠️  Spells not found: {stats['spell_not_found']}")

        return stats

    async def import_class_circles(
        self,
        class_skills_data: List[Dict],
        skip_existing: bool = True,
        dry_run: bool = False
    ) -> Dict:
        """
        Import class circle access levels to ClassCircles table
        Extracts when each class gains access to each spell circle
        """
        stats = {
            "circles_created": 0,
            "circles_skipped": 0,
            "errors": 0,
        }

        click.echo("  Importing class circle access levels...")

        # Extract unique (class, circle, minLevel) combinations from spell assignments
        circle_access = {}
        for assignment in class_skills_data:
            if assignment.get('abilityType') != 'SPELL' or 'circle' not in assignment:
                continue

            class_name_with_prefix = assignment["className"]
            class_name = class_name_with_prefix.replace("CLASS_", "").replace("_", "-").lower()
            circle = assignment["circle"]
            min_level = assignment["minLevel"]

            key = (class_name, circle)
            if key not in circle_access:
                circle_access[key] = min_level
            else:
                # Use the minimum level for this circle
                circle_access[key] = min(circle_access[key], min_level)

        click.echo(f"    Found {len(circle_access)} class-circle combinations")

        for (class_name, circle), min_level in sorted(circle_access.items()):
            try:
                # Look up by plainName (title-cased, e.g., "sorcerer" -> "Sorcerer", "anti-paladin" -> "Anti-Paladin")
                character_class = await self.prisma.characterclass.find_first(
                    where={"plainName": class_name.title()}
                )

                if not character_class:
                    continue

                if skip_existing:
                    existing = await self.prisma.classabilitycircles.find_first(
                        where={
                            "classId": character_class.id,
                            "circle": circle,
                        }
                    )
                    if existing:
                        stats["circles_skipped"] += 1
                        continue

                if not dry_run:
                    await self.prisma.classabilitycircles.create(
                        data={
                            "classId": character_class.id,
                            "circle": circle,
                            "minLevel": min_level,
                        }
                    )

                stats["circles_created"] += 1

            except Exception as e:
                click.echo(f"      ✗ Error: {e}")
                stats["errors"] += 1

        click.echo(f"  ✅ Circle access: {stats['circles_created']}, skipped: {stats['circles_skipped']}")
        return stats

    async def import_from_json(
        self,
        json_path: Path,
        skip_existing: bool = True,
        dry_run: bool = False
    ) -> Dict:
        """Import classes, skills, spells, and circle access from JSON"""
        click.echo(f"  Loading class data from {json_path}...")

        with open(json_path, 'r') as f:
            data = json.load(f)

        classes = data.get("classes", [])
        class_skills = data.get("classSkills", [])

        click.echo(f"    Found {len(classes)} classes and {len(class_skills)} assignments")

        # Separate spells from skills for statistics
        spells = [s for s in class_skills if s.get('abilityType') == 'SPELL']
        skills = [s for s in class_skills if s.get('abilityType') != 'SPELL']
        click.echo(f"    → {len(spells)} spells, {len(skills)} physical skills")

        # Import in order
        class_stats = await self.import_classes(classes, skip_existing=skip_existing)
        skill_stats = await self.import_class_skills(class_skills, skip_existing=skip_existing, dry_run=dry_run)
        spell_stats = await self.import_spell_circles(class_skills, skip_existing=skip_existing, dry_run=dry_run)
        circle_stats = await self.import_class_circles(class_skills, skip_existing=skip_existing, dry_run=dry_run)

        return {
            **class_stats,
            "skills_created": skill_stats["assignments_created"],
            "skills_skipped": skill_stats["assignments_skipped"],
            "spells_created": spell_stats["assignments_created"],
            "spells_skipped": spell_stats["assignments_skipped"],
            **circle_stats,
            "skill_not_found": skill_stats["skill_not_found"] + spell_stats["spell_not_found"],
            "class_not_found": skill_stats["class_not_found"] + spell_stats["class_not_found"],
            "errors": class_stats["errors"] + skill_stats["errors"] + spell_stats["errors"] + circle_stats["errors"],
        }
