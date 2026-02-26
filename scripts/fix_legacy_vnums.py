#!/usr/bin/env python3
"""
Convert legacy flat vnums in Lua trigger files to composite (zone, id) format.

Handles three patterns:
  - world.count_mobiles("VNUM") → world.count_mobiles(zone, id)
  - world.count_objects("VNUM") → world.count_objects(zone, id)
  - run_room_trigger(VNUM)      → run_room_trigger(zone, id)

Uses data/vnum_map.json for correct zone resolution, with .zon file ranges as fallback.
"""

import json
import re
import sys
from pathlib import Path


def load_vnum_map() -> dict[int, int]:
    """Load zone_id -> max_id mapping from vnum_map.json."""
    map_path = Path(__file__).parent.parent / "data" / "vnum_map.json"
    if not map_path.exists():
        print(f"ERROR: {map_path} not found.")
        sys.exit(1)
    with open(map_path) as f:
        data = json.load(f)
    return {int(k): v for k, v in data["zone_max_ids"].items()}


def load_zon_ranges() -> dict[int, int]:
    """Load zone_id -> max_id from .zon files (uses top_vnum field)."""
    zon_dir = Path(__file__).parent.parent.parent / "lib" / "world" / "zon"
    ranges = {}
    for zon_file in zon_dir.glob("*.zon"):
        try:
            lines = zon_file.read_text(encoding="latin-1").splitlines()
            if len(lines) < 3:
                continue
            zone_line = lines[0].strip()
            if not zone_line.startswith("#"):
                continue
            zone_id = int(zone_line[1:])
            parts = lines[2].strip().split()
            if not parts:
                continue
            top = int(parts[0])
            max_id = top - zone_id * 100
            ranges[zone_id] = max_id
        except (ValueError, IndexError):
            continue
    return ranges


ZONE_MAP: dict[int, int] = {}
SORTED_ZONES: list[tuple[int, int]] = []


def init_zone_map():
    global ZONE_MAP, SORTED_ZONES
    # Start with .zon file ranges, then overlay DB-derived map
    # This ensures triggers referencing vnums within .zon range but not in DB still resolve
    ZONE_MAP = load_zon_ranges()
    db_map = load_vnum_map()
    for zone_id, max_id in db_map.items():
        # Use whichever gives a larger range
        ZONE_MAP[zone_id] = max(ZONE_MAP.get(zone_id, 0), max_id)
    SORTED_ZONES = sorted(ZONE_MAP.items())


def vnum_to_parts(vnum: int) -> tuple[int, int] | None:
    """Convert legacy vnum to (zone_id, local_id). Returns None if unmapped."""
    for zone_id, max_id in reversed(SORTED_ZONES):
        zone_start = zone_id * 100
        if zone_start <= vnum <= zone_start + max_id:
            return zone_id, vnum - zone_start
    return None


def convert_file(filepath: Path, dry_run: bool = True) -> tuple[int, list[str], list[str]]:
    """Convert a single Lua file. Returns (changes, log_lines, warnings)."""
    content = filepath.read_text()
    lines = content.split("\n")
    changes = 0
    log_lines = []
    warnings = []

    for i, line in enumerate(lines):
        original = line

        # Pattern 1: world.count_mobiles("VNUM")
        def replace_count_mobiles(m):
            vnum = int(m.group(1))
            parts = vnum_to_parts(vnum)
            if parts is None:
                warnings.append(f"  L{i+1}: unmapped vnum {vnum} in count_mobiles")
                return m.group(0)
            zone, local = parts
            return f"world.count_mobiles({zone}, {local})"

        line = re.sub(r'world\.count_mobiles\("(\d+)"\)', replace_count_mobiles, line)

        # Pattern 2: world.count_objects("VNUM")
        def replace_count_objects(m):
            vnum = int(m.group(1))
            parts = vnum_to_parts(vnum)
            if parts is None:
                warnings.append(f"  L{i+1}: unmapped vnum {vnum} in count_objects")
                return m.group(0)
            zone, local = parts
            return f"world.count_objects({zone}, {local})"

        line = re.sub(r'world\.count_objects\("(\d+)"\)', replace_count_objects, line)

        # Pattern 3: run_room_trigger(VNUM) - integer arg, not string
        def replace_run_room_trigger(m):
            vnum = int(m.group(1))
            parts = vnum_to_parts(vnum)
            if parts is None:
                warnings.append(f"  L{i+1}: unmapped vnum {vnum} in run_room_trigger")
                return m.group(0)
            zone, local = parts
            return f"run_room_trigger({zone}, {local})"

        line = re.sub(r"run_room_trigger\((\d+)\)", replace_run_room_trigger, line)

        if line != original:
            lines[i] = line
            changes += 1
            log_lines.append(f"  L{i+1}: {original.strip()}")
            log_lines.append(f"      → {line.strip()}")

    new_content = "\n".join(lines)

    if not dry_run and changes > 0:
        filepath.write_text(new_content)

    return changes, log_lines, warnings


def main():
    import argparse

    parser = argparse.ArgumentParser(
        description="Convert legacy flat vnums to composite (zone, id) in Lua triggers"
    )
    parser.add_argument(
        "--apply", action="store_true", help="Apply changes (default: dry-run)"
    )
    parser.add_argument("--file", type=str, help="Process a single file")
    parser.add_argument(
        "--verbose", "-v", action="store_true", help="Show all changes"
    )
    args = parser.parse_args()

    init_zone_map()
    print(f"Loaded {len(ZONE_MAP)} zones from vnum_map.json")

    triggers_dir = Path(__file__).parent.parent / "data" / "triggers"

    if args.file:
        files = [Path(args.file)]
    else:
        files = list(triggers_dir.rglob("*.lua"))

    total_changes = 0
    files_changed = 0
    all_warnings = []
    pattern_counts = {"count_mobiles": 0, "count_objects": 0, "run_room_trigger": 0}

    for filepath in sorted(files):
        content = filepath.read_text()
        has_patterns = (
            'world.count_mobiles("' in content
            or 'world.count_objects("' in content
            or "run_room_trigger(" in content
        )
        if not has_patterns:
            continue

        file_changes, file_log, file_warnings = convert_file(
            filepath, dry_run=not args.apply
        )

        if file_changes > 0 or file_warnings:
            try:
                rel_path = filepath.relative_to(triggers_dir)
            except ValueError:
                rel_path = filepath

            # Count by pattern
            for log_line in file_log:
                if "count_mobiles" in log_line and log_line.startswith("  L"):
                    pattern_counts["count_mobiles"] += 1
                elif "count_objects" in log_line and log_line.startswith("  L"):
                    pattern_counts["count_objects"] += 1
                elif "run_room_trigger" in log_line and log_line.startswith("  L"):
                    pattern_counts["run_room_trigger"] += 1

            if args.verbose or file_warnings:
                print(f"\n{rel_path}: {file_changes} changes")
                for line in file_log:
                    print(line)
                for w in file_warnings:
                    print(f"  WARNING: {w}")

            all_warnings.extend([(filepath, w) for w in file_warnings])
            if file_changes > 0:
                files_changed += 1
                total_changes += file_changes

    print(f"\n{'=' * 60}")
    print(f"Total: {total_changes} line changes in {files_changed} files")
    print(f"  count_mobiles: {pattern_counts['count_mobiles']}")
    print(f"  count_objects: {pattern_counts['count_objects']}")
    print(f"  run_room_trigger: {pattern_counts['run_room_trigger']}")

    if all_warnings:
        print(f"\nWarnings ({len(all_warnings)} unmapped vnums):")
        for filepath, w in all_warnings:
            print(f"  {filepath.relative_to(triggers_dir)}: {w}")

    if not args.apply:
        print("\nDry run. Use --apply to write changes.")


if __name__ == "__main__":
    main()
