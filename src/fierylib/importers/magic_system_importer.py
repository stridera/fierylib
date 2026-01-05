"""Import effects and abilities from JSON files into the database."""

import json
import click
import asyncio
from pathlib import Path
from typing import Dict, List, Any, Optional
from prisma import Prisma

from ..parsers.help_parser import HelpFileParser, parse_all_help_files


class MagicSystemImporter:
    """Import effects and abilities from JSON files."""

    def __init__(self, prisma: Prisma, data_dir: Path):
        self.prisma = prisma
        self.data_dir = data_dir
        self.effect_id_cache: Dict[str, int] = {}  # name -> id
        self.school_id_cache: Dict[str, int] = {}  # name -> id
        self.stats = {
            "effects_created": 0,
            "effects_updated": 0,
            "abilities_created": 0,
            "abilities_updated": 0,
            "effect_links_created": 0,
            "errors": 0,
        }
        self.warnings: List[str] = []  # Track warnings for summary

    async def load_effect_cache(self):
        """Load existing effects into cache."""
        effects = await self.prisma.effect.find_many()
        for e in effects:
            self.effect_id_cache[e.name] = e.id

    async def load_school_cache(self):
        """Load existing schools into cache."""
        schools = await self.prisma.abilityschool.find_many()
        for s in schools:
            self.school_id_cache[s.name] = s.id

    async def import_effects(self, verbose: bool = False) -> int:
        """Import effects from effects.json."""
        effects_path = self.data_dir / "effects.json"
        if not effects_path.exists():
            click.echo(f"  Warning: {effects_path} not found, skipping effects")
            return 0

        with open(effects_path) as f:
            effects_data = json.load(f)

        click.echo(f"  Importing {len(effects_data)} effects...")

        for effect in effects_data:
            try:
                name = effect["name"]
                data = {
                    "name": name,
                    "effectType": effect["effectType"],
                    "description": effect.get("description"),
                    "tags": effect.get("tags", []),
                    "defaultParams": json.dumps(effect.get("defaultParams", {})),
                    "paramSchema": json.dumps(effect.get("paramSchema")) if effect.get("paramSchema") else None,
                }

                existing = await self.prisma.effect.find_unique(where={"name": name})
                if existing:
                    await self.prisma.effect.update(where={"name": name}, data=data)
                    self.effect_id_cache[name] = existing.id
                    self.stats["effects_updated"] += 1
                    if verbose:
                        click.echo(f"    Updated: {name}")
                else:
                    created = await self.prisma.effect.create(data=data)
                    self.effect_id_cache[name] = created.id
                    self.stats["effects_created"] += 1
                    if verbose:
                        click.echo(f"    Created: {name}")

            except Exception as e:
                click.echo(f"    Error importing effect {effect.get('name', '?')}: {e}")
                self.stats["errors"] += 1

        return len(effects_data)

    async def import_abilities(self, verbose: bool = False) -> int:
        """Import abilities from abilities.json."""
        abilities_path = self.data_dir / "abilities.json"
        if not abilities_path.exists():
            click.echo(f"  Warning: {abilities_path} not found, skipping abilities")
            return 0

        with open(abilities_path) as f:
            abilities_data = json.load(f)

        click.echo(f"  Importing {len(abilities_data)} abilities...")

        for ability in abilities_data:
            try:
                await self._import_ability(ability, verbose)
            except Exception as e:
                click.echo(f"    Error importing ability {ability.get('name', '?')}: {e}")
                self.stats["errors"] += 1

        return len(abilities_data)

    async def _import_ability(self, ability: Dict[str, Any], verbose: bool):
        """Import a single ability with its related data."""
        name = ability["name"]
        plain_name = ability["plainName"]

        # Build ability data
        data = {
            "name": name,
            "plainName": plain_name,
            "abilityType": ability["abilityType"],
            "description": ability.get("description"),
            "minPosition": ability.get("minPosition", "STANDING"),
            "violent": ability.get("violent", False),
            "castTimeRounds": ability.get("castTimeRounds", 1),
            "cooldownMs": ability.get("cooldownMs", 0),
            "inCombatOnly": ability.get("inCombatOnly", False),
            "combatOk": ability.get("combatOk", True),
            "isArea": ability.get("isArea", False),
            "memorizationTime": ability.get("memorizationTime", 0),
            "questOnly": ability.get("questOnly", False),
            "humanoidOnly": ability.get("humanoidOnly", False),
        }

        # Optional fields
        if ability.get("notes"):
            data["notes"] = ability["notes"]
        if ability.get("tags"):
            data["tags"] = ability["tags"]
        if ability.get("luaScript"):
            data["luaScript"] = ability["luaScript"]
        if ability.get("sphere"):
            data["sphere"] = ability["sphere"]
        if ability.get("damageType"):
            data["damageType"] = ability["damageType"]
        if ability.get("pages"):
            data["pages"] = ability["pages"]
        if ability.get("isToggle") is not None:
            data["isToggle"] = ability["isToggle"]

        # Stealth & Visibility fields
        if ability.get("contestedVisibility") is not None:
            data["contestedVisibility"] = ability["contestedVisibility"]
        if ability.get("visibilityCheck"):
            data["visibilityCheck"] = ability["visibilityCheck"]

        # School lookup
        if ability.get("school"):
            school_id = self.school_id_cache.get(ability["school"])
            if school_id:
                data["schoolId"] = school_id

        # Check if ability exists
        existing = await self.prisma.ability.find_first(where={"plainName": plain_name})

        if existing:
            ability_id = existing.id
            await self.prisma.ability.update(where={"id": ability_id}, data=data)
            self.stats["abilities_updated"] += 1
            if verbose:
                click.echo(f"    Updated: {name}")
        else:
            created = await self.prisma.ability.create(data=data)
            ability_id = created.id
            self.stats["abilities_created"] += 1
            if verbose:
                click.echo(f"    Created: {name}")

        # Import related data
        await self._import_ability_effects(ability_id, ability.get("effects", []), verbose)
        await self._import_ability_targeting(ability_id, ability.get("targeting"), verbose)
        await self._import_ability_saving_throws(ability_id, ability.get("savingThrows", []), verbose)
        await self._import_ability_messages(ability_id, ability.get("messages"), verbose)

        # Build restrictions from targetRestrictions and casterRestrictions
        restrictions = self._build_restrictions(ability)
        await self._import_ability_restrictions(ability_id, restrictions, verbose)

    def _build_restrictions(self, ability: Dict[str, Any]) -> Optional[Dict]:
        """Build restrictions dict from targetRestrictions and casterRestrictions."""
        target_restrictions = ability.get("targetRestrictions", [])
        caster_restrictions = ability.get("casterRestrictions", [])
        legacy_restrictions = ability.get("restrictions", {})
        messages = ability.get("messages", {})

        # Start with legacy restrictions if present
        requirements = list(legacy_restrictions.get("requirements", []))

        # Add target restrictions
        for r in target_restrictions:
            req = {
                "type": r.get("type"),
                "value": r.get("value"),
                "target": "victim",
            }
            if r.get("required"):
                req["required"] = True
            if r.get("prohibited"):
                req["prohibited"] = True
            # Add fail message if available
            if messages.get("failToCaster"):
                req["message"] = messages["failToCaster"]
            requirements.append(req)

        # Add caster restrictions
        for r in caster_restrictions:
            req = {
                "type": r.get("type"),
                "value": r.get("value"),
                "target": "caster",
            }
            if r.get("required"):
                req["required"] = True
            if r.get("prohibited"):
                req["prohibited"] = True
            if messages.get("failToCaster"):
                req["message"] = messages["failToCaster"]
            requirements.append(req)

        if not requirements:
            return None

        return {
            "requirements": requirements,
            "customRequirementLua": legacy_restrictions.get("customRequirementLua"),
        }

    async def _import_ability_effects(self, ability_id: int, effects: List[Dict], verbose: bool):
        """Import ability effect links."""
        if not effects:
            return

        # Delete existing links
        await self.prisma.abilityeffect.delete_many(where={"abilityId": ability_id})

        for effect_data in effects:
            effect_name = effect_data["effect"]
            effect_id = self.effect_id_cache.get(effect_name)

            if not effect_id:
                warning = f"Effect '{effect_name}' not found (referenced by ability {ability_id})"
                self.warnings.append(warning)
                if verbose:
                    click.echo(f"      Warning: {warning}")
                continue

            await self.prisma.abilityeffect.create(
                data={
                    "abilityId": ability_id,
                    "effectId": effect_id,
                    "order": effect_data.get("order", 0),
                    "overrideParams": json.dumps(effect_data.get("params", {})),
                    "trigger": effect_data.get("trigger"),
                    "chancePct": effect_data.get("chancePct", 100),
                    "condition": effect_data.get("condition"),
                }
            )
            self.stats["effect_links_created"] += 1

    async def _import_ability_targeting(self, ability_id: int, targeting: Optional[Dict], verbose: bool):
        """Import ability targeting."""
        if not targeting:
            return

        # Delete existing
        try:
            await self.prisma.abilitytargeting.delete(where={"abilityId": ability_id})
        except:
            pass

        await self.prisma.abilitytargeting.create(
            data={
                "abilityId": ability_id,
                "validTargets": targeting.get("validTargets", ["SELF"]),
                "scope": targeting.get("scope", "SINGLE"),
                "scopePattern": targeting.get("scopePattern"),
                "maxTargets": targeting.get("maxTargets", 1),
                "range": targeting.get("range", 0),
                "requireLos": targeting.get("requireLos", False),
            }
        )

    async def _import_ability_saving_throws(self, ability_id: int, saving_throws: List[Dict], verbose: bool):
        """Import ability saving throws."""
        if not saving_throws:
            return

        # Delete existing
        await self.prisma.abilitysavingthrow.delete_many(where={"abilityId": ability_id})

        for st in saving_throws:
            await self.prisma.abilitysavingthrow.create(
                data={
                    "abilityId": ability_id,
                    "saveType": st.get("saveType", "SPELL"),
                    "dcFormula": st.get("dcFormula", "10 + level/2"),
                    "onSaveAction": json.dumps(st.get("onSaveAction", "NEGATE")),
                }
            )

    async def _import_ability_messages(self, ability_id: int, messages: Optional[Dict], verbose: bool):
        """Import ability messages."""
        if not messages:
            return

        # Delete existing
        try:
            await self.prisma.abilitymessages.delete(where={"abilityId": ability_id})
        except:
            pass

        await self.prisma.abilitymessages.create(
            data={
                "abilityId": ability_id,
                "startToCaster": messages.get("startToCaster"),
                "startToVictim": messages.get("startToVictim"),
                "startToRoom": messages.get("startToRoom"),
                "successToCaster": messages.get("successToCaster"),
                "successToVictim": messages.get("successToVictim"),
                "successToRoom": messages.get("successToRoom"),
                "successToSelf": messages.get("successToSelf"),
                "successSelfRoom": messages.get("successSelfRoom"),
                "failToCaster": messages.get("failToCaster"),
                "failToVictim": messages.get("failToVictim"),
                "failToRoom": messages.get("failToRoom"),
                "wearoffToTarget": messages.get("wearoffToTarget"),
                "wearoffToRoom": messages.get("wearoffToRoom"),
                "lookMessage": messages.get("lookMessage"),
            }
        )

    async def _import_ability_restrictions(self, ability_id: int, restrictions: Optional[Dict], verbose: bool):
        """Import ability restrictions."""
        if not restrictions:
            return

        # Delete existing
        try:
            await self.prisma.abilityrestrictions.delete(where={"abilityId": ability_id})
        except:
            pass

        await self.prisma.abilityrestrictions.create(
            data={
                "abilityId": ability_id,
                "requirements": [json.dumps(r) for r in restrictions.get("requirements", [])],
                "customRequirementLua": restrictions.get("customRequirementLua"),
            }
        )

    async def run(self, verbose: bool = False) -> Dict[str, Any]:
        """Run the full import.

        Returns:
            Dictionary containing 'stats' and 'warnings' keys.
        """
        click.echo("\nLoading caches...")
        await self.load_effect_cache()
        await self.load_school_cache()

        click.echo("\nImporting effects...")
        await self.import_effects(verbose)

        click.echo("\nImporting abilities...")
        await self.import_abilities(verbose)

        return {
            "stats": self.stats,
            "warnings": self.warnings,
        }

    async def update_descriptions_from_help(
        self,
        help_dir: Path,
        verbose: bool = False,
        dry_run: bool = False,
    ) -> Dict[str, int]:
        """Update ability descriptions from help files.

        Args:
            help_dir: Directory containing .hlp files
            verbose: Show detailed output
            dry_run: Don't actually update, just show what would change

        Returns:
            Dictionary with update statistics
        """
        stats = {
            "matched": 0,
            "updated": 0,
            "skipped_no_match": 0,
            "skipped_same": 0,
            "errors": 0,
        }

        click.echo(f"\nParsing help files from {help_dir}...")
        parser = parse_all_help_files(help_dir)
        click.echo(f"  Found {len(parser.entries)} help entries")

        # Get all abilities
        click.echo("\nFetching abilities from database...")
        abilities = await self.prisma.ability.find_many()
        click.echo(f"  Found {len(abilities)} abilities")

        click.echo("\nMatching and updating descriptions...")

        for ability in abilities:
            try:
                # Try to find matching help entry by name
                # Normalize ability name for lookup
                lookup_name = ability.name.lower().replace('_', ' ')

                entry = parser.get_entry(lookup_name)

                if not entry:
                    # Try alternative lookups
                    # Remove "spell " or "skill " prefix if present
                    alt_name = lookup_name.replace('spell ', '').replace('skill ', '')
                    entry = parser.get_entry(alt_name)

                if not entry:
                    stats["skipped_no_match"] += 1
                    if verbose:
                        click.echo(f"  No match: {ability.name}")
                    continue

                stats["matched"] += 1

                # Check if description is different
                new_desc = entry.description.strip()
                if not new_desc:
                    stats["skipped_same"] += 1
                    continue

                # Check if current description is a placeholder
                current_desc = ability.description or ""
                is_placeholder = (
                    current_desc.startswith("Spell: ")
                    or current_desc.startswith("Player skill: ")
                    or current_desc.startswith("Monk chant: ")
                    or current_desc.startswith("Bardic song: ")
                    or not current_desc
                )

                if not is_placeholder and current_desc == new_desc:
                    stats["skipped_same"] += 1
                    if verbose:
                        click.echo(f"  Same: {ability.name}")
                    continue

                if dry_run:
                    click.echo(f"  Would update: {ability.name}")
                    if verbose:
                        click.echo(f"    Old: {current_desc[:80]}...")
                        click.echo(f"    New: {new_desc[:80]}...")
                    stats["updated"] += 1
                else:
                    # Update in database
                    update_data: Dict[str, Any] = {"description": new_desc}

                    # Also update sphere if available and not set
                    if entry.sphere and not ability.sphere:
                        sphere_map = {
                            "generic": "GENERIC",
                            "death": "DEATH",
                            "fire": "FIRE",
                            "water": "WATER",
                            "air": "AIR",
                            "earth": "EARTH",
                            "healing": "HEALING",
                            "protection": "PROTECTION",
                            "divination": "DIVINATION",
                            "enchantment": "ENCHANTMENT",
                            "summoning": "SUMMONING",
                        }
                        mapped_sphere = sphere_map.get(entry.sphere.lower())
                        if mapped_sphere:
                            update_data["sphere"] = mapped_sphere

                    await self.prisma.ability.update(
                        where={"id": ability.id},
                        data=update_data,
                    )
                    stats["updated"] += 1
                    if verbose:
                        click.echo(f"  Updated: {ability.name}")

            except Exception as e:
                stats["errors"] += 1
                click.echo(f"  Error updating {ability.name}: {e}")

        return stats


async def import_magic_system(
    data_dir: Optional[Path] = None,
    verbose: bool = False,
) -> Dict[str, Any]:
    """Main entry point for importing the magic system.

    Returns:
        Dictionary containing:
        - stats: Dict with creation/update counts and errors
        - warnings: List of warning messages (e.g., missing effects)
    """
    if data_dir is None:
        data_dir = Path(__file__).parent.parent.parent.parent / "data"

    if not data_dir.exists():
        raise FileNotFoundError(f"Data directory not found: {data_dir}")

    prisma = Prisma()
    await prisma.connect()

    try:
        importer = MagicSystemImporter(prisma, data_dir)
        return await importer.run(verbose)
    finally:
        await prisma.disconnect()


@click.command(name="magic-system")
@click.option("--verbose", "-v", is_flag=True, help="Show detailed output")
@click.option("--data-dir", type=click.Path(exists=True), help="Path to data directory")
def import_magic_system_cli(verbose: bool, data_dir: Optional[str]):
    """Import effects and abilities from JSON files."""

    async def run():
        click.echo("=" * 60)
        click.echo("Importing Magic System from JSON")
        click.echo("=" * 60)

        path = Path(data_dir) if data_dir else None
        result = await import_magic_system(data_dir=path, verbose=verbose)
        stats = result['stats']
        warnings = result['warnings']

        click.echo("\n" + "=" * 60)
        click.echo("Import Summary")
        click.echo("=" * 60)
        click.echo(f"  Effects created:     {stats['effects_created']}")
        click.echo(f"  Effects updated:     {stats['effects_updated']}")
        click.echo(f"  Abilities created:   {stats['abilities_created']}")
        click.echo(f"  Abilities updated:   {stats['abilities_updated']}")
        click.echo(f"  Effect links:        {stats['effect_links_created']}")
        if stats['errors'] > 0:
            click.echo(f"  Errors:              {stats['errors']}")

        if warnings:
            click.echo(f"\n  Warnings:            {len(warnings)}")
            for warning in warnings:
                click.echo(f"    - {warning}")

        click.echo("\nImport complete!")

    asyncio.run(run())


async def update_descriptions_from_help_files(
    help_dir: Path,
    verbose: bool = False,
    dry_run: bool = False,
) -> Dict[str, int]:
    """Update ability descriptions from help files."""
    prisma = Prisma()
    await prisma.connect()

    try:
        # We need a data_dir for the importer, use default
        data_dir = Path(__file__).parent.parent.parent.parent / "data"
        importer = MagicSystemImporter(prisma, data_dir)
        return await importer.update_descriptions_from_help(help_dir, verbose, dry_run)
    finally:
        await prisma.disconnect()


@click.command(name="update-descriptions")
@click.option("--verbose", "-v", is_flag=True, help="Show detailed output")
@click.option("--dry-run", is_flag=True, help="Show what would change without updating")
@click.argument("help_dir", type=click.Path(exists=True))
def update_descriptions_cli(verbose: bool, dry_run: bool, help_dir: str):
    """Update ability descriptions from help files.

    HELP_DIR: Path to directory containing .hlp help files
    (e.g., fierymud/legacy/lib/text/help/)
    """

    async def run():
        click.echo("=" * 60)
        click.echo("Updating Ability Descriptions from Help Files")
        click.echo("=" * 60)

        if dry_run:
            click.echo("\n*** DRY RUN - No changes will be made ***\n")

        stats = await update_descriptions_from_help_files(
            Path(help_dir), verbose, dry_run
        )

        click.echo("\n" + "=" * 60)
        click.echo("Update Summary")
        click.echo("=" * 60)
        click.echo(f"  Matched:         {stats['matched']}")
        click.echo(f"  Updated:         {stats['updated']}")
        click.echo(f"  No match found:  {stats['skipped_no_match']}")
        click.echo(f"  Same/no change:  {stats['skipped_same']}")
        if stats['errors'] > 0:
            click.echo(f"  Errors:          {stats['errors']}")
        click.echo("\nUpdate complete!")

    asyncio.run(run())


if __name__ == "__main__":
    import_magic_system_cli()
