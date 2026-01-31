#!/usr/bin/env python3
"""
Convert legacy vnum_to_zone/vnum_to_local patterns to modern zone/local ID format.

Patterns handled:
1. Inline variable patterns:
   `local x = 55604` followed by `spawn_object(vnum_to_zone(x), vnum_to_local(x))`
   → `spawn_object(556, 4)` (removes the local declaration)
2. Computed patterns:
   `local x = expr + 55604` followed by usage
   → `spawn_object(556, expr + 4)`
3. Inline literals: `vnum_to_zone(12345)` → `123`
4. Object properties: `vnum_to_zone(self.room)` → flagged for manual review
"""

import re
import sys
from pathlib import Path
from dataclasses import dataclass
from typing import Optional


def vnum_to_parts(vnum: int) -> tuple[int, int]:
    """Convert legacy vnum to (zone_id, local_id)."""
    zone_id = vnum // 100
    if zone_id == 0:
        zone_id = 1000
    local_id = vnum % 100
    return zone_id, local_id


def parse_vnum_definition(line: str) -> Optional[tuple[str, int, Optional[str]]]:
    """
    Parse a line that defines a vnum variable.
    Returns (var_name, base_vnum, dynamic_expr) or None.
    """
    # Pattern: local varname = number (static)
    static_match = re.match(r'^\s*local\s+(\w+)\s*=\s*(\d{3,5})\s*$', line)
    if static_match:
        return (static_match.group(1), int(static_match.group(2)), None)

    # Pattern: local varname = number + expression (base on left)
    dynamic_match_left = re.match(r'^\s*local\s+(\w+)\s*=\s*(\d{3,5})\s*\+\s*(.+)$', line)
    if dynamic_match_left:
        return (dynamic_match_left.group(1), int(dynamic_match_left.group(2)), dynamic_match_left.group(3).strip())

    # Pattern: local varname = expression + number (base on right)
    dynamic_match_right = re.match(r'^\s*local\s+(\w+)\s*=\s*(.+?)\s*\+\s*(\d{3,5})\s*$', line)
    if dynamic_match_right:
        expr = dynamic_match_right.group(2).strip()
        # Make sure it's not just a number (would be static)
        if not expr.isdigit():
            return (dynamic_match_right.group(1), int(dynamic_match_right.group(3)), expr)

    return None


def convert_file(filepath: Path, dry_run: bool = True) -> tuple[int, list[str]]:
    """
    Convert a single file using a multi-pass approach.
    Returns (changes_made, warnings).
    """
    content = filepath.read_text()
    lines = content.split('\n')
    changes = 0
    warnings = []

    # Track which definition lines to remove and which usage lines to modify
    # Key: line number of definition to remove
    # Value: (usage_line_number, new_usage_line_content)
    removals_and_updates: dict[int, tuple[int, str]] = {}

    # First pass: find definition+usage pairs and plan conversions
    for i, line in enumerate(lines):
        parsed = parse_vnum_definition(line)
        if not parsed:
            continue

        var_name, base_vnum, dynamic_expr = parsed
        zone_id, local_id = vnum_to_parts(base_vnum)

        # Look ahead for usage of this variable
        look_ahead_limit = 5
        for j in range(i + 1, min(i + 1 + look_ahead_limit, len(lines))):
            next_line = lines[j]
            zone_pattern = rf'vnum_to_zone\(\s*{re.escape(var_name)}\s*\)'
            local_pattern = rf'vnum_to_local\(\s*{re.escape(var_name)}\s*\)'

            if re.search(zone_pattern, next_line) or re.search(local_pattern, next_line):
                # Found usage - plan the inline conversion
                new_next_line = next_line
                new_next_line = re.sub(zone_pattern, str(zone_id), new_next_line)
                if dynamic_expr:
                    new_next_line = re.sub(local_pattern, f'{dynamic_expr} + {local_id}', new_next_line)
                else:
                    new_next_line = re.sub(local_pattern, str(local_id), new_next_line)

                # Check if variable is ONLY used for vnum conversion
                remaining_content = '\n'.join(lines[j+1:])
                cleaned = re.sub(rf'local\s+{re.escape(var_name)}\s*=', '', remaining_content)
                cleaned = re.sub(rf'vnum_to_zone\(\s*{re.escape(var_name)}\s*\)', '', cleaned)
                cleaned = re.sub(rf'vnum_to_local\(\s*{re.escape(var_name)}\s*\)', '', cleaned)
                var_still_used = re.search(rf'\b{re.escape(var_name)}\b', cleaned)

                if not var_still_used:
                    # Can remove definition and inline usage
                    removals_and_updates[i] = (j, new_next_line)
                    changes += 1
                break

    # Second pass: apply changes
    new_lines = []
    updated_lines = {j: new_content for i, (j, new_content) in removals_and_updates.items()}
    removed_lines = set(removals_and_updates.keys())

    for i, line in enumerate(lines):
        if i in removed_lines:
            continue  # Skip removed definition lines

        if i in updated_lines:
            new_lines.append(updated_lines[i])
        else:
            new_line = line

            # Convert inline literal vnums: vnum_to_zone(12345) → 123
            def replace_inline_zone(m):
                vnum = int(m.group(1))
                zone_id, _ = vnum_to_parts(vnum)
                return str(zone_id)

            def replace_inline_local(m):
                vnum = int(m.group(1))
                _, local_id = vnum_to_parts(vnum)
                return str(local_id)

            old_line = new_line
            new_line = re.sub(r'vnum_to_zone\(\s*(\d{3,5})\s*\)', replace_inline_zone, new_line)
            new_line = re.sub(r'vnum_to_local\(\s*(\d{3,5})\s*\)', replace_inline_local, new_line)
            if new_line != old_line:
                changes += 1

            # Flag problematic patterns for manual review
            if 'vnum_to_zone(self.room)' in new_line or 'vnum_to_local(self.room)' in new_line:
                warnings.append(f"  Line {i+1}: self.room is a Room object, not a vnum - needs manual fix")
            if 'vnum_to_zone(actor.room)' in new_line or 'vnum_to_local(actor.room)' in new_line:
                warnings.append(f"  Line {i+1}: actor.room is a Room object, not a vnum - needs manual fix")

            # Check for remaining vnum_to_* calls that weren't converted
            remaining = re.findall(r'vnum_to_(zone|local)\(([^)]+)\)', new_line)
            for func, arg in remaining:
                arg = arg.strip()
                if not arg.isdigit():
                    warnings.append(f"  Line {i+1}: Unconverted vnum_to_{func}({arg}) - needs manual review")

            new_lines.append(new_line)

    new_content = '\n'.join(new_lines)

    if not dry_run and changes > 0:
        filepath.write_text(new_content)

    return changes, warnings


def main():
    import argparse
    parser = argparse.ArgumentParser(description='Convert vnum patterns to modern zone/local format')
    parser.add_argument('--apply', action='store_true', help='Actually apply changes (default is dry-run)')
    parser.add_argument('--file', type=str, help='Process a single file')
    parser.add_argument('--verbose', '-v', action='store_true', help='Show all changes')
    args = parser.parse_args()

    triggers_dir = Path(__file__).parent.parent / 'data' / 'triggers'

    if args.file:
        files = [Path(args.file)]
    else:
        files = list(triggers_dir.rglob('*.lua'))

    total_changes = 0
    files_changed = 0
    all_warnings = []

    for filepath in sorted(files):
        # Skip files without vnum functions
        content = filepath.read_text()
        if 'vnum_to_zone' not in content and 'vnum_to_local' not in content:
            continue

        changes, warnings = convert_file(filepath, dry_run=not args.apply)

        if changes > 0 or warnings:
            try:
                rel_path = filepath.relative_to(triggers_dir)
            except ValueError:
                rel_path = filepath
            print(f"\n{rel_path}: {changes} changes")
            if warnings:
                for w in warnings:
                    print(w)
                all_warnings.extend([(filepath, w) for w in warnings])
            files_changed += 1
            total_changes += changes

    print(f"\n{'=' * 60}")
    print(f"Total: {total_changes} changes in {files_changed} files")
    if all_warnings:
        print(f"Warnings: {len(all_warnings)} items need manual review")

    if not args.apply:
        print("\nThis was a dry run. Use --apply to make changes.")


if __name__ == '__main__':
    main()
