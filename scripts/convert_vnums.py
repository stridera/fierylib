#!/usr/bin/env python3
"""
Convert legacy vnum_to_zone/vnum_to_local patterns to modern zone/id format.

Uses data/vnum_map.json for correct zone resolution (handles extended zones
where max_id > 99, e.g., zone 30 has IDs 0-499).
"""

import json
import re
import sys
from pathlib import Path


def load_vnum_map() -> dict[int, int]:
    """Load zone_id -> max_id mapping from vnum_map.json."""
    map_path = Path(__file__).parent.parent / "data" / "vnum_map.json"
    if not map_path.exists():
        print(f"ERROR: {map_path} not found. Generate it from the database first.")
        sys.exit(1)
    with open(map_path) as f:
        data = json.load(f)
    return {int(k): v for k, v in data["zone_max_ids"].items()}


ZONE_MAP: dict[int, int] = {}
SORTED_ZONES: list[tuple[int, int]] = []


def init_zone_map():
    global ZONE_MAP, SORTED_ZONES
    ZONE_MAP = load_vnum_map()
    SORTED_ZONES = sorted(ZONE_MAP.items())


def vnum_to_parts(vnum: int) -> tuple[int, int]:
    """Convert legacy vnum to (zone_id, local_id) using the zone map."""
    for zone_id, max_id in reversed(SORTED_ZONES):
        zone_start = zone_id * 100
        if zone_start <= vnum <= zone_start + max_id:
            return zone_id, vnum - zone_start
    zone_id = vnum // 100
    return zone_id, vnum % 100


def convert_file(filepath: Path, dry_run: bool = True) -> tuple[int, list[str]]:
    """Convert a single Lua trigger file. Returns (changes_made, warnings)."""
    content = filepath.read_text()
    if "vnum_to_zone" not in content and "vnum_to_local" not in content:
        return 0, []

    lines = content.split("\n")
    changes = 0
    warnings = []
    lines_to_remove: set[int] = set()

    # Multi-pass approach: keep converting until no more changes
    max_passes = 5
    for pass_num in range(max_passes):
        pass_changes = 0

        for i in range(len(lines)):
            line = lines[i]
            if "vnum_to_zone" not in line and "vnum_to_local" not in line:
                continue

            original = line

            # --- Rule 1: Room/object refs that are already objects ---
            for obj_ref in ["self.room", "actor.room", "arg.room"]:
                pat = (
                    rf"get_room\(vnum_to_zone\({re.escape(obj_ref)}\),\s*"
                    rf"vnum_to_local\({re.escape(obj_ref)}\)\)"
                )
                line = re.sub(pat, obj_ref, line)

            # 'room' local variable (saved from self.room)
            room_pat = r"get_room\(vnum_to_zone\(room\),\s*vnum_to_local\(room\)\)"
            line = re.sub(room_pat, "room", line)

            # --- Rule 2: self.id ---
            line = re.sub(
                r"vnum_to_zone\(self\.id\),\s*vnum_to_local\(self\.id\)",
                "self.zone_id, self.id",
                line,
            )

            # --- Rule 3: Inline literal pairs ---
            def replace_literal_pair(m):
                vnum = int(m.group(1))
                zone, local = vnum_to_parts(vnum)
                return f"{zone}, {local}"

            line = re.sub(
                r"vnum_to_zone\((\d{3,6})\),\s*vnum_to_local\(\1\)",
                replace_literal_pair,
                line,
            )

            # --- Rule 4: Variable pairs - look back for adjacent definition ---
            m_var = re.search(
                r"vnum_to_zone\((\w+)\),\s*vnum_to_local\(\1\)", line
            )
            if m_var:
                var_name = m_var.group(1)
                # Look backwards (up to 5 lines) for the definition
                found_def = False
                for back in range(1, min(6, i + 1)):
                    def_line = lines[i - back].strip()
                    if def_line.startswith("--"):
                        continue

                    # local VAR = CONST
                    m_def = re.match(
                        rf"local\s+{re.escape(var_name)}\s*=\s*(\d{{3,6}})\s*$",
                        def_line,
                    )
                    if m_def:
                        base = int(m_def.group(1))
                        zone, local_id = vnum_to_parts(base)
                        line = re.sub(
                            rf"vnum_to_zone\({re.escape(var_name)}\),\s*vnum_to_local\({re.escape(var_name)}\)",
                            f"{zone}, {local_id}",
                            line,
                        )
                        # Check if var is used elsewhere
                        var_used = False
                        for j, l in enumerate(lines):
                            if j == i - back or j == i:
                                continue
                            if j in lines_to_remove:
                                continue
                            if re.search(rf"\b{re.escape(var_name)}\b", l):
                                var_used = True
                                break
                        if not var_used:
                            lines_to_remove.add(i - back)
                        found_def = True
                        break

                    # local VAR = CONST + expr  OR  local VAR = expr + CONST
                    m_def2 = re.match(
                        rf"local\s+{re.escape(var_name)}\s*=\s*(\d{{3,6}})\s*\+\s*(.+?)\s*$",
                        def_line,
                    )
                    if not m_def2:
                        m_def2 = re.match(
                            rf"local\s+{re.escape(var_name)}\s*=\s*(.+?)\s*\+\s*(\d{{3,6}})\s*$",
                            def_line,
                        )
                        if m_def2 and m_def2.group(1).strip().isdigit():
                            m_def2 = None  # Two constants, handled differently
                        if m_def2:
                            # Swap groups so const is first
                            g1 = m_def2.group(2)
                            g2 = m_def2.group(1)
                            class FakeMatch:
                                def __init__(self, a, b):
                                    self._g1 = a
                                    self._g2 = b
                                def group(self, n):
                                    return self._g1 if n == 1 else self._g2
                            m_def2 = FakeMatch(g1, g2)

                    if m_def2:
                        base = int(m_def2.group(1))
                        offset_expr = m_def2.group(2).strip()
                        zone, base_local = vnum_to_parts(base)
                        if base_local == 0:
                            replacement = f"{zone}, {offset_expr}"
                        else:
                            replacement = f"{zone}, {base_local} + {offset_expr}"
                        line = re.sub(
                            rf"vnum_to_zone\({re.escape(var_name)}\),\s*vnum_to_local\({re.escape(var_name)}\)",
                            replacement,
                            line,
                        )
                        var_used = False
                        for j, l in enumerate(lines):
                            if j == i - back or j == i:
                                continue
                            if j in lines_to_remove:
                                continue
                            if re.search(rf"\b{re.escape(var_name)}\b", l):
                                var_used = True
                                break
                        if not var_used:
                            lines_to_remove.add(i - back)
                        found_def = True
                        break

                    # Don't look past control flow or unrelated code
                    if def_line and not def_line.startswith("local ") and not def_line.startswith("self.") and not def_line.startswith("actor") and not def_line.startswith("get_room") and not def_line.startswith("world."):
                        break

                if not found_def and m_var:
                    # Math fallback
                    line = re.sub(
                        rf"vnum_to_zone\({re.escape(var_name)}\),\s*vnum_to_local\({re.escape(var_name)}\)",
                        f"math.floor({var_name} / 100), {var_name} % 100",
                        line,
                    )
                    if pass_num == 0:  # Only warn once
                        warnings.append(
                            f"  L{i+1}: math fallback for '{var_name}'"
                        )

            # --- Rule 5: Remaining standalone calls ---
            def replace_single_zone(m):
                arg = m.group(1).strip()
                if arg.isdigit():
                    zone, _ = vnum_to_parts(int(arg))
                    return str(zone)
                return f"math.floor({arg} / 100)"

            def replace_single_local(m):
                arg = m.group(1).strip()
                if arg.isdigit():
                    _, local = vnum_to_parts(int(arg))
                    return str(local)
                return f"({arg} % 100)"

            line = re.sub(r"vnum_to_zone\(([^)]+)\)", replace_single_zone, line)
            line = re.sub(r"vnum_to_local\(([^)]+)\)", replace_single_local, line)

            if line != original:
                lines[i] = line
                pass_changes += 1

        changes += pass_changes
        if pass_changes == 0:
            break

    # Remove unused definition lines
    new_lines = [l for i, l in enumerate(lines) if i not in lines_to_remove]
    changes += len(lines_to_remove)
    new_content = "\n".join(new_lines)

    if not dry_run and changes > 0:
        filepath.write_text(new_content)

    return changes, warnings


def main():
    import argparse

    parser = argparse.ArgumentParser(
        description="Convert vnum patterns to modern zone/id format"
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

    for filepath in sorted(files):
        content = filepath.read_text()
        if "vnum_to_zone" not in content and "vnum_to_local" not in content:
            continue

        file_changes, file_warnings = convert_file(filepath, dry_run=not args.apply)

        if file_changes > 0 or file_warnings:
            try:
                rel_path = filepath.relative_to(triggers_dir)
            except ValueError:
                rel_path = filepath

            if args.verbose or file_warnings:
                print(f"\n{rel_path}: {file_changes} changes")
                for w in file_warnings:
                    print(w)
            all_warnings.extend([(filepath, w) for w in file_warnings])
            if file_changes > 0:
                files_changed += 1
                total_changes += file_changes

    print(f"\n{'=' * 60}")
    print(f"Total: {total_changes} changes in {files_changed} files")
    if all_warnings:
        print(f"Warnings: {len(all_warnings)} items needing manual review")

    remaining = 0
    for lua_file in triggers_dir.rglob("*.lua"):
        content = lua_file.read_text()
        if "vnum_to_zone" in content or "vnum_to_local" in content:
            remaining += 1
            if args.verbose:
                print(f"  REMAINING: {lua_file.relative_to(triggers_dir)}")

    print(f"Files still containing vnum_to_zone/vnum_to_local: {remaining}")

    if not args.apply:
        print("\nDry run. Use --apply to write changes.")


if __name__ == "__main__":
    main()
