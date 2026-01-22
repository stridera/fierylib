"""
Trigger Importer - Imports Lua triggers to PostgreSQL

Primary import method: import_from_lua_directory()
  - Reads curated Lua files from lib/triggers/
  - Parses header comments for metadata
  - Imports to database

Legacy methods (for reference, not used in normal import):
  - import_from_dg_trigger() - converts DG scripts on the fly
  - import_all_triggers() - imports from .trg files
"""

import os
import re
import subprocess
import tempfile
from dataclasses import dataclass
from pathlib import Path
from typing import Optional
from prisma import Prisma, Json

# Legacy imports - only used by convert-legacy command
from fierylib.parsers.trigger_parser import parse_trigger_file, parse_all_triggers, DGTrigger
from fierylib.converters.dg_to_lua import convert_trigger, LuaTrigger


@dataclass
class ParsedLuaTrigger:
    """Trigger data parsed from a Lua file."""
    zone_id: int
    local_id: int
    name: str
    attach_type: str
    flags: list[str]
    commands: str
    needs_review: bool
    file_path: Path


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


def parse_lua_trigger_file(file_path: Path) -> ParsedLuaTrigger:
    """
    Parse a Lua trigger file and extract metadata from header comments.

    Expected format:
        -- Trigger: trigger name
        -- Zone: 489, ID: 2
        -- Type: MOB, Flags: LOAD, FIGHT
        -- Status: CLEAN|NEEDS_REVIEW
        --
        -- Original DG Script: #48902

        <lua code>

    Args:
        file_path: Path to the .lua trigger file

    Returns:
        ParsedLuaTrigger with extracted metadata and code

    Raises:
        ValueError: If file format is invalid
    """
    content = file_path.read_text(encoding="utf-8")
    lines = content.split("\n")

    # Parse header
    name = None
    zone_id = None
    local_id = None
    attach_type = None
    flags = []
    needs_review = False
    header_end = 0

    for i, line in enumerate(lines):
        if not line.startswith("--"):
            # First non-comment line marks end of header
            header_end = i
            break

        # Parse trigger name
        if match := re.match(r"^-- Trigger:\s*(.+)$", line):
            name = match.group(1).strip()

        # Parse zone and ID
        elif match := re.match(r"^-- Zone:\s*(\d+),\s*ID:\s*(\d+)$", line):
            zone_id = int(match.group(1))
            local_id = int(match.group(2))

        # Parse type and flags
        elif match := re.match(r"^-- Type:\s*(\w+)(?:,\s*Flags:\s*(.*))?$", line):
            attach_type = match.group(1).strip()
            if match.group(2):
                flags_str = match.group(2).strip()
                if flags_str:
                    flags = [f.strip() for f in flags_str.split(",") if f.strip()]

        # Parse status
        elif "Status: NEEDS_REVIEW" in line:
            needs_review = True

        header_end = i + 1

    # Validate required fields
    if name is None:
        raise ValueError(f"Missing 'Trigger:' header in {file_path}")
    if zone_id is None or local_id is None:
        raise ValueError(f"Missing 'Zone: X, ID: Y' header in {file_path}")
    if attach_type is None:
        raise ValueError(f"Missing 'Type:' header in {file_path}")

    # Extract commands (everything after the header)
    # Skip empty lines after header
    while header_end < len(lines) and not lines[header_end].strip():
        header_end += 1

    commands = "\n".join(lines[header_end:]).strip()

    return ParsedLuaTrigger(
        zone_id=zone_id,
        local_id=local_id,
        name=name,
        attach_type=attach_type,
        flags=flags,
        commands=commands,
        needs_review=needs_review,
        file_path=file_path,
    )


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
        # Decompose vnum into composite key (zoneId, id)
        # e.g., 3045 -> zoneId=30, id=45
        trigger_zone_id = trigger.vnum // 100
        trigger_local_id = trigger.vnum % 100
        # Handle zone 0 → 1000 conversion
        if trigger_zone_id == 0:
            trigger_zone_id = 1000

        # Verify the zone exists before importing
        zone_exists = await self.prisma.zones.find_unique(where={"id": trigger_zone_id})
        if not zone_exists:
            return {
                "success": False,
                "zoneId": trigger_zone_id,
                "id": trigger_local_id,
                "name": trigger.name,
                "action": "failed",
                "error": f"Zone {trigger_zone_id} not found",
            }

        trigger_data = {
            "zoneId": trigger_zone_id,
            "id": trigger_local_id,
            "name": trigger.name,
            "attachType": trigger.attach_type,
            "flags": trigger.flags,
            "commands": trigger.commands,
            "numArgs": len(trigger.arg_list),
            "argList": trigger.arg_list,
            "variables": Json({}),
            # Validation tracking
            "needsReview": syntax_error is not None,
            "syntaxError": syntax_error,
        }

        if dry_run:
            return {
                "success": True,
                "zoneId": trigger_zone_id,
                "id": trigger_local_id,
                "name": trigger.name,
                "action": "validated",
                "type": trigger.attach_type,
                "flags": trigger.flags,
            }

        try:
            # Check if trigger already exists
            existing = await self.prisma.triggers.find_unique(
                where={
                    "zoneId_id": {
                        "zoneId": trigger_zone_id,
                        "id": trigger_local_id,
                    }
                }
            )

            if existing:
                # Update existing trigger
                update_data = {k: v for k, v in trigger_data.items() if k not in ("zoneId", "id")}
                await self.prisma.triggers.update(
                    where={
                        "zoneId_id": {
                            "zoneId": trigger_zone_id,
                            "id": trigger_local_id,
                        }
                    },
                    data=update_data
                )
                action = "updated"
            else:
                # Create new trigger
                await self.prisma.triggers.create(data=trigger_data)
                action = "created"

            return {
                "success": True,
                "zoneId": trigger_zone_id,
                "id": trigger_local_id,
                "name": trigger.name,
                "action": action,
                "type": trigger.attach_type,
                "flags": trigger.flags,
            }

        except Exception as e:
            return {
                "success": False,
                "zoneId": trigger_zone_id,
                "id": trigger_local_id,
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

    # =========================================================================
    # File-based import methods (primary import path)
    # =========================================================================

    async def import_from_lua_file(
        self,
        lua_file: Path,
        dry_run: bool = False,
        validate_syntax: bool = True,
    ) -> dict:
        """
        Import a single Lua trigger file to the database.

        Args:
            lua_file: Path to .lua trigger file
            dry_run: If True, validate but don't write to database
            validate_syntax: If True, validate Lua syntax before import

        Returns:
            Dict with import results
        """
        try:
            trigger = parse_lua_trigger_file(lua_file)
        except Exception as e:
            return {
                "success": False,
                "file": str(lua_file),
                "action": "failed",
                "error": f"Parse error: {str(e)}",
            }

        # Validate syntax if requested
        syntax_error = None
        if validate_syntax and trigger.commands:
            valid, error = validate_lua_syntax(trigger.commands, trigger.name)
            if not valid:
                syntax_error = error

        # Verify the zone exists
        zone_exists = await self.prisma.zones.find_unique(where={"id": trigger.zone_id})
        if not zone_exists:
            return {
                "success": False,
                "zoneId": trigger.zone_id,
                "id": trigger.local_id,
                "name": trigger.name,
                "file": str(lua_file),
                "action": "failed",
                "error": f"Zone {trigger.zone_id} not found",
            }

        trigger_data = {
            "zoneId": trigger.zone_id,
            "id": trigger.local_id,
            "name": trigger.name,
            "attachType": trigger.attach_type,
            "flags": trigger.flags,
            "commands": trigger.commands,
            "numArgs": 0,  # Args not tracked in file format
            "argList": [],
            "variables": Json({}),
            "needsReview": trigger.needs_review or syntax_error is not None,
            "syntaxError": syntax_error,
        }

        if dry_run:
            return {
                "success": True,
                "zoneId": trigger.zone_id,
                "id": trigger.local_id,
                "name": trigger.name,
                "file": str(lua_file),
                "action": "validated",
                "type": trigger.attach_type,
                "flags": trigger.flags,
            }

        try:
            # Check if trigger already exists
            existing = await self.prisma.triggers.find_unique(
                where={
                    "zoneId_id": {
                        "zoneId": trigger.zone_id,
                        "id": trigger.local_id,
                    }
                }
            )

            if existing:
                # Update existing trigger
                update_data = {k: v for k, v in trigger_data.items() if k not in ("zoneId", "id")}
                await self.prisma.triggers.update(
                    where={
                        "zoneId_id": {
                            "zoneId": trigger.zone_id,
                            "id": trigger.local_id,
                        }
                    },
                    data=update_data
                )
                action = "updated"
            else:
                # Create new trigger
                await self.prisma.triggers.create(data=trigger_data)
                action = "created"

            return {
                "success": True,
                "zoneId": trigger.zone_id,
                "id": trigger.local_id,
                "name": trigger.name,
                "file": str(lua_file),
                "action": action,
                "type": trigger.attach_type,
                "flags": trigger.flags,
            }

        except Exception as e:
            return {
                "success": False,
                "zoneId": trigger.zone_id,
                "id": trigger.local_id,
                "name": trigger.name,
                "file": str(lua_file),
                "action": "failed",
                "error": str(e),
            }

    async def import_from_lua_directory(
        self,
        triggers_dir: Path,
        dry_run: bool = False,
        verbose: bool = False,
        validate_syntax: bool = True,
        zone: Optional[int] = None,
    ) -> dict:
        """
        Import all Lua trigger files from a directory.

        Expected structure:
            triggers_dir/
            ├── 001/
            │   ├── 001_00_trigger.lua
            │   └── 001_01_another.lua
            ├── 489/
            │   ├── 489_02_lokari_init.lua
            │   └── ...
            └── REVIEW_STATUS.md

        Args:
            triggers_dir: Path to triggers directory (e.g., lib/triggers/)
            dry_run: If True, validate but don't write to database
            verbose: If True, print progress for each file
            validate_syntax: If True, validate Lua syntax before import
            zone: If set, only import triggers from this zone

        Returns:
            Dict with import summary
        """
        if not triggers_dir.exists():
            return {
                "success": False,
                "error": f"Triggers directory not found: {triggers_dir}",
                "total": 0,
                "imported": 0,
                "failed": 0,
            }

        # Find all zone directories
        if zone is not None:
            zone_dirs = [triggers_dir / f"{zone:03d}"]
            if not zone_dirs[0].exists():
                return {
                    "success": False,
                    "error": f"Zone directory not found: {zone_dirs[0]}",
                    "total": 0,
                    "imported": 0,
                    "failed": 0,
                }
        else:
            zone_dirs = sorted([d for d in triggers_dir.iterdir() if d.is_dir()])

        results = {
            "success": True,
            "total_zones": len(zone_dirs),
            "total": 0,
            "imported": 0,
            "updated": 0,
            "failed": 0,
            "needs_review": 0,
            "errors": [],
        }

        for zone_dir in zone_dirs:
            lua_files = sorted(zone_dir.glob("*.lua"))

            for lua_file in lua_files:
                result = await self.import_from_lua_file(
                    lua_file,
                    dry_run=dry_run,
                    validate_syntax=validate_syntax,
                )

                results["total"] += 1

                if result["success"]:
                    if result["action"] == "created":
                        results["imported"] += 1
                    elif result["action"] == "updated":
                        results["updated"] += 1
                    elif result["action"] == "validated":
                        results["imported"] += 1  # Count validated as imported for dry run
                else:
                    results["failed"] += 1
                    results["success"] = False
                    results["errors"].append({
                        "file": str(lua_file),
                        "error": result.get("error", "Unknown error"),
                    })

                if verbose:
                    status = result["action"].upper() if result["success"] else "FAILED"
                    print(f"  [{status}] {lua_file.relative_to(triggers_dir)}")

            if not verbose and lua_files:
                zone_num = zone_dir.name
                print(f"  Zone {zone_num}: {len(lua_files)} triggers")

        return results
