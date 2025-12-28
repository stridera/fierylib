"""
Trigger Importer - Imports converted Lua triggers to PostgreSQL

Handles:
- DG Script parsing from legacy .trg files
- Conversion to Lua via dg_to_lua converter
- Lua syntax validation before import
- Upsert to PostgreSQL Triggers table
- Zone 0 → Zone 1000 conversion
"""

import os
import subprocess
import tempfile
from pathlib import Path
from typing import Optional
from prisma import Prisma, Json

from fierylib.parsers.trigger_parser import parse_trigger_file, parse_all_triggers, DGTrigger
from fierylib.converters.dg_to_lua import convert_trigger, LuaTrigger
from fierylib.converters import convert_zone_id


def validate_lua_syntax(code: str, name: str) -> tuple[bool, str]:
    """
    Validate Lua syntax by attempting to compile the code.

    Args:
        code: Lua source code to validate
        name: Name for error messages

    Returns:
        (success, error_message) tuple
    """
    with tempfile.NamedTemporaryFile(mode='w', suffix='.lua', delete=False) as f:
        f.write(code)
        temp_path = f.name

    try:
        # Use luac (Lua compiler) to check syntax without executing
        result = subprocess.run(
            ['luac', '-p', temp_path],
            capture_output=True,
            text=True
        )

        if result.returncode != 0:
            error = result.stderr.strip()
            # Clean up the temp file path from error message
            error = error.replace(temp_path, f'<{name}>')
            return False, error

        return True, ""
    except FileNotFoundError:
        # luac not installed - skip validation with warning
        return True, ""
    finally:
        os.unlink(temp_path)


class TriggerImporter:
    """Imports DG Script triggers to PostgreSQL as Lua scripts"""

    def __init__(self, prisma_client: "Prisma"):
        """
        Initialize trigger importer.

        Args:
            prisma_client: Prisma client instance
        """
        self.prisma = prisma_client

    async def import_trigger(
        self,
        trigger: LuaTrigger,
        dry_run: bool = False,
        syntax_error: Optional[str] = None
    ) -> dict:
        """
        Import a single Lua trigger to the database.

        Args:
            trigger: Converted LuaTrigger object
            dry_run: If True, validate but don't write to database
            syntax_error: If set, the Lua syntax error message

        Returns:
            Dict with import results
        """
        # Handle zone 0 → 1000 conversion
        zone_id = convert_zone_id(trigger.zone_id)

        # Build trigger data - only include optional relations if they apply
        trigger_data = {
            "name": trigger.name,
            "attachType": trigger.attach_type,
            "flags": trigger.flags,
            "commands": trigger.commands,
            "numArgs": len(trigger.arg_list),
            "argList": trigger.arg_list,
            "variables": Json({}),
            # DG Scripts trigger vnum for mob/object linking
            "vnum": trigger.vnum,
            # Validation tracking
            "needsReview": syntax_error is not None,
            "syntaxError": syntax_error,
        }

        # Set attachment references based on type
        # Check if referenced entities exist before setting FKs
        if trigger.attach_type == "MOB":
            # Check if mob exists
            mob_exists = await self.prisma.mobs.find_unique(
                where={"zoneId_id": {"zoneId": zone_id, "id": trigger.local_id}}
            )
            if mob_exists:
                trigger_data["mobZoneId"] = zone_id
                trigger_data["mobId"] = trigger.local_id
            # If mob doesn't exist, we still store the trigger but without the FK
        elif trigger.attach_type == "OBJECT":
            # Check if object exists
            obj_exists = await self.prisma.objects.find_unique(
                where={"zoneId_id": {"zoneId": zone_id, "id": trigger.local_id}}
            )
            if obj_exists:
                trigger_data["objectZoneId"] = zone_id
                trigger_data["objectId"] = trigger.local_id
            # If object doesn't exist, we still store the trigger but without the FK
        elif trigger.attach_type == "WORLD":
            # World triggers are linked to a zone via zoneId
            zone_exists = await self.prisma.zones.find_unique(where={"id": zone_id})
            if zone_exists:
                trigger_data["zoneId"] = zone_id

        if dry_run:
            return {
                "success": True,
                "vnum": trigger.vnum,
                "name": trigger.name,
                "action": "validated",
                "type": trigger.attach_type,
                "flags": trigger.flags,
            }

        try:
            # Create trigger (use create since we don't have a unique constraint on vnum)
            # Check if trigger already exists by name and zone
            existing = await self.prisma.triggers.find_first(
                where={
                    "name": trigger.name,
                    "zoneId": zone_id,
                }
            )

            if existing:
                # Update existing trigger
                await self.prisma.triggers.update(
                    where={"id": existing.id},
                    data=trigger_data
                )
                action = "updated"
            else:
                # Create new trigger
                await self.prisma.triggers.create(data=trigger_data)
                action = "created"

            return {
                "success": True,
                "vnum": trigger.vnum,
                "name": trigger.name,
                "action": action,
                "type": trigger.attach_type,
                "flags": trigger.flags,
            }

        except Exception as e:
            return {
                "success": False,
                "vnum": trigger.vnum,
                "name": trigger.name,
                "action": "failed",
                "error": str(e),
            }

    async def import_from_dg_trigger(
        self,
        dg_trigger: DGTrigger,
        dry_run: bool = False,
        validate_syntax: bool = True,
        import_with_errors: bool = True
    ) -> dict:
        """
        Convert and import a DG Script trigger.

        Args:
            dg_trigger: Parsed DGTrigger object
            dry_run: If True, validate but don't write to database
            validate_syntax: If True, validate Lua syntax before import
            import_with_errors: If True, import even if syntax validation fails

        Returns:
            Dict with import results
        """
        try:
            lua_trigger = convert_trigger(dg_trigger)
            syntax_error = None

            # Validate Lua syntax
            if validate_syntax:
                valid, error = validate_lua_syntax(lua_trigger.commands, lua_trigger.name)
                if not valid:
                    syntax_error = error
                    if not import_with_errors:
                        return {
                            "success": False,
                            "vnum": dg_trigger.vnum,
                            "name": dg_trigger.name,
                            "action": "failed",
                            "error": f"Lua syntax error: {error}",
                            "converted": True,
                            "syntax_valid": False,
                        }

            # Import the trigger (with or without syntax error)
            result = await self.import_trigger(
                lua_trigger,
                dry_run=dry_run,
                syntax_error=syntax_error
            )
            result["converted"] = True
            result["syntax_valid"] = syntax_error is None
            if syntax_error:
                result["needs_review"] = True
                result["syntax_error"] = syntax_error
            return result
        except Exception as e:
            return {
                "success": False,
                "vnum": dg_trigger.vnum,
                "name": dg_trigger.name,
                "action": "failed",
                "error": f"Conversion error: {str(e)}",
                "converted": False,
            }

    async def import_from_file(
        self,
        trg_file: Path,
        dry_run: bool = False,
        validate_syntax: bool = True,
        import_with_errors: bool = True
    ) -> dict:
        """
        Import all triggers from a .trg file.

        Args:
            trg_file: Path to .trg file
            dry_run: If True, validate but don't write to database
            validate_syntax: If True, validate Lua syntax before import
            import_with_errors: If True, import even if syntax validation fails

        Returns:
            Dict with import summary
        """
        try:
            dg_triggers = parse_trigger_file(trg_file)
        except Exception as e:
            return {
                "success": False,
                "file": str(trg_file),
                "error": f"Parse error: {str(e)}",
                "total": 0,
                "imported": 0,
                "failed": 0,
                "needs_review": 0,
            }

        results = {
            "success": True,
            "file": str(trg_file),
            "total": len(dg_triggers),
            "imported": 0,
            "failed": 0,
            "needs_review": 0,
            "triggers": [],
        }

        for dg_trigger in dg_triggers:
            result = await self.import_from_dg_trigger(
                dg_trigger,
                dry_run=dry_run,
                validate_syntax=validate_syntax,
                import_with_errors=import_with_errors
            )
            results["triggers"].append(result)

            if result["success"]:
                results["imported"] += 1
                if result.get("needs_review"):
                    results["needs_review"] += 1
            else:
                results["failed"] += 1
                results["success"] = False

        return results

    async def import_all_triggers(
        self,
        trg_dir: Path,
        dry_run: bool = False,
        verbose: bool = False,
        validate_syntax: bool = True,
        import_with_errors: bool = True
    ) -> dict:
        """
        Import all triggers from a directory of .trg files.

        Args:
            trg_dir: Path to directory containing .trg files
            dry_run: If True, validate but don't write to database
            verbose: If True, print progress
            validate_syntax: If True, validate Lua syntax before import
            import_with_errors: If True, import even if syntax validation fails

        Returns:
            Dict with import summary
        """
        trg_files = sorted(trg_dir.glob("*.trg"))

        results = {
            "success": True,
            "total_files": len(trg_files),
            "total_triggers": 0,
            "imported": 0,
            "failed": 0,
            "needs_review": 0,
            "files": [],
        }

        for trg_file in trg_files:
            if verbose:
                print(f"Processing: {trg_file.name}")

            file_result = await self.import_from_file(
                trg_file,
                dry_run=dry_run,
                validate_syntax=validate_syntax,
                import_with_errors=import_with_errors
            )
            results["files"].append(file_result)

            results["total_triggers"] += file_result.get("total", 0)
            results["imported"] += file_result.get("imported", 0)
            results["failed"] += file_result.get("failed", 0)
            results["needs_review"] += file_result.get("needs_review", 0)

            if not file_result["success"]:
                results["success"] = False

        return results

    async def get_trigger_stats(self) -> dict:
        """
        Get statistics about triggers in the database.

        Returns:
            Dict with trigger statistics
        """
        total = await self.prisma.triggers.count()

        # Count by type
        mob_count = await self.prisma.triggers.count(
            where={"attachType": "MOB"}
        )
        obj_count = await self.prisma.triggers.count(
            where={"attachType": "OBJECT"}
        )
        world_count = await self.prisma.triggers.count(
            where={"attachType": "WORLD"}
        )

        return {
            "total": total,
            "by_type": {
                "MOB": mob_count,
                "OBJECT": obj_count,
                "WORLD": world_count,
            }
        }

    async def clear_all_triggers(self) -> int:
        """
        Delete all triggers from the database.

        Returns:
            Number of triggers deleted
        """
        result = await self.prisma.triggers.delete_many()
        return result
