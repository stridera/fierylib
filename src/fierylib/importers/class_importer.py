"""
Class Importer - Imports class data from extracted JSON to PostgreSQL

Imports:
- Class definitions (CharacterClass table)
- Class skill assignments (ClassSkills table)
"""

import json
import click
from pathlib import Path
from typing import Dict, List
from prisma import Prisma


class ClassImporter:
    """Imports class and skill assignment data to PostgreSQL"""

    def __init__(self, prisma_client):
        """
        Initialize class importer

        Args:
            prisma_client: Prisma client instance
        """
        self.prisma = prisma_client

    async def import_classes(self, classes_data: List[Dict], skip_existing: bool = True) -> Dict:
        """
        Import class definitions to CharacterClass table

        Args:
            classes_data: List of class definition dictionaries
            skip_existing: If True, skip classes that already exist

        Returns:
            Dictionary with import statistics
        """
        stats = {
            "classes_created": 0,
            "classes_skipped": 0,
            "errors": 0,
        }

        click.echo("  Importing class definitions...")

        for class_data in classes_data:
            try:
                # Check if class already exists
                if skip_existing:
                    existing = await self.prisma.characterclass.find_first(
                        where={"name": class_data["name"]}
                    )
                    if existing:
                        stats["classes_skipped"] += 1
                        continue

                # Create class
                await self.prisma.characterclass.create(
                    data={
                        "name": class_data["name"],
                        "description": f"Class: {class_data['displayName'] or class_data['name']}",
                        # Add other fields as needed based on schema
                    }
                )

                stats["classes_created"] += 1
                click.echo(f"    ✓ Imported class: {class_data['name']}")

            except Exception as e:
                click.echo(f"    ✗ Error importing class {class_data.get('name', 'unknown')}: {e}")
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
        Import class skill assignments to ClassSkills table

        Args:
            class_skills_data: List of class skill assignment dictionaries
            skip_existing: If True, skip assignments that already exist
            dry_run: If True, don't actually write to database

        Returns:
            Dictionary with import statistics
        """
        stats = {
            "assignments_created": 0,
            "assignments_skipped": 0,
            "skill_not_found": 0,
            "class_not_found": 0,
            "errors": 0,
        }

        click.echo("  Importing class skill assignments...")

        # Group by class for better output
        by_class: Dict[int, List[Dict]] = {}
        for assignment in class_skills_data:
            class_id = assignment["classId"]
            if class_id not in by_class:
                by_class[class_id] = []
            by_class[class_id].append(assignment)

        for class_id, assignments in sorted(by_class.items()):
            # Get class name from first assignment (strip CLASS_ prefix)
            class_name_with_prefix = assignments[0]["className"]
            class_name = class_name_with_prefix.replace("CLASS_", "").replace("_", "-").lower()

            # Get class from database by name
            character_class = await self.prisma.characterclass.find_first(
                where={"name": class_name}
            )

            if not character_class:
                click.echo(f"    ⚠️  Class '{class_name}' (ID {class_id}) not found in database, skipping {len(assignments)} assignments")
                stats["class_not_found"] += len(assignments)
                continue

            click.echo(f"    Processing {character_class.name}: {len(assignments)} assignments")

            for assignment in assignments:
                try:
                    # Look up skill by name (without prefix)
                    skill = await self.prisma.skills.find_first(
                        where={"name": assignment["skillName"]}
                    )

                    if not skill:
                        # Try with original name as fallback
                        skill = await self.prisma.skills.find_first(
                            where={"name": assignment["originalName"]}
                        )

                    if not skill:
                        stats["skill_not_found"] += 1
                        if assignment["minLevel"] > 1:  # Only warn if it's actually assigned
                            click.echo(f"      ⚠️  Skill '{assignment['skillName']}' not found (level {assignment['minLevel']})")
                        continue

                    # Check if assignment already exists
                    if skip_existing:
                        existing = await self.prisma.classskills.find_first(
                            where={
                                "classId": character_class.id,
                                "skillId": skill.id,
                            }
                        )
                        if existing:
                            stats["assignments_skipped"] += 1
                            continue

                    if not dry_run:
                        # Create class skill assignment
                        await self.prisma.classskills.create(
                            data={
                                "classId": character_class.id,
                                "skillId": skill.id,
                                "minLevel": assignment["minLevel"],
                                "maxLevel": 100,  # Default max level
                                "category": "PRIMARY" if assignment["abilityType"] in ["SPELL", "SONG", "CHANT"] else "SECONDARY",
                            }
                        )

                    stats["assignments_created"] += 1

                except Exception as e:
                    click.echo(f"      ✗ Error importing assignment for {assignment.get('skillName', 'unknown')}: {e}")
                    stats["errors"] += 1

            click.echo(f"      ✓ {stats['assignments_created']} assignments for {character_class.name}")

        click.echo(f"  ✅ Total assignments: {stats['assignments_created']}, skipped: {stats['assignments_skipped']}")
        if stats["skill_not_found"] > 0:
            click.echo(f"  ⚠️  Skills not found: {stats['skill_not_found']}")
        if stats["class_not_found"] > 0:
            click.echo(f"  ⚠️  Classes not found: {stats['class_not_found']}")

        return stats

    async def import_from_json(
        self,
        json_path: Path,
        skip_existing: bool = True,
        dry_run: bool = False
    ) -> Dict:
        """
        Import classes and skill assignments from JSON file

        Args:
            json_path: Path to classes.json file
            skip_existing: If True, skip existing records
            dry_run: If True, don't actually write to database

        Returns:
            Dictionary with combined import statistics
        """
        click.echo(f"  Loading class data from {json_path}...")

        with open(json_path, 'r') as f:
            data = json.load(f)

        classes = data.get("classes", [])
        class_skills = data.get("classSkills", [])

        click.echo(f"    Found {len(classes)} classes and {len(class_skills)} skill assignments")

        # Import classes first
        class_stats = await self.import_classes(classes, skip_existing=skip_existing)

        # Then import skill assignments
        skill_stats = await self.import_class_skills(
            class_skills,
            skip_existing=skip_existing,
            dry_run=dry_run
        )

        # Combine stats
        return {
            **class_stats,
            **skill_stats,
        }
