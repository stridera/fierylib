#!/usr/bin/env python3
"""
Fix math.floor(x / 100), x % 100 fallback patterns left by convert_vnums.py.

Traces variables back to their literal definitions (including aliases) and
resolves using vnum_map.json for correct extended zone handling.
"""

import json
import re
from pathlib import Path


def load_vnum_map() -> dict[int, int]:
    map_path = Path(__file__).parent.parent / "data" / "vnum_map.json"
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
    for zone_id, max_id in reversed(SORTED_ZONES):
        zone_start = zone_id * 100
        if zone_start <= vnum <= zone_start + max_id:
            return zone_id, vnum - zone_start
    zone_id = vnum // 100
    if zone_id == 0:
        zone_id = 1000
    return zone_id, vnum % 100


def find_var_definitions(lines: list[str], var_name: str) -> list[tuple[int, str]]:
    """Find all `local VAR = EXPR` definitions of a variable in the file."""
    defs = []
    pat = re.compile(rf"^\s*local\s+{re.escape(var_name)}\s*=\s*(.+?)\s*$")
    for i, line in enumerate(lines):
        stripped = line.strip()
        if stripped.startswith("--"):
            continue
        m = pat.match(stripped)
        if m:
            defs.append((i, m.group(1)))
    return defs


def resolve_var_to_constants(
    lines: list[str], var_name: str, depth: int = 0
) -> list[tuple[int, int, str]] | None:
    """Resolve a variable to its constant values, following aliases.

    Returns list of (line_idx, constant_value, offset_expr) or None if unresolvable.
    Skips non-vnum definitions (like random(1,15) or small ints).
    """
    if depth > 3:
        return None

    defs = find_var_definitions(lines, var_name)
    if not defs:
        return None

    results = []
    has_unresolvable = False

    for def_idx, def_expr in defs:
        expr = def_expr.strip()

        # Pure constant (3+ digits = likely vnum)
        if expr.isdigit() and len(expr) >= 3:
            results.append((def_idx, int(expr), ""))
            continue

        # CONST + EXPR (e.g., 3139 + random(1, 7))
        m = re.match(r"^(\d{3,6})\s*\+\s*(.+)$", expr)
        if m:
            results.append((def_idx, int(m.group(1)), m.group(2).strip()))
            continue

        # EXPR + CONST
        m = re.match(r"^(.+?)\s*\+\s*(\d{3,6})$", expr)
        if m and not m.group(1).strip().isdigit():
            results.append((def_idx, int(m.group(2)), m.group(1).strip()))
            continue

        # Variable alias (e.g., vnum_reward = vnum_reward_helm)
        if re.match(r"^\w+$", expr) and not expr.isdigit():
            alias_results = resolve_var_to_constants(lines, expr, depth + 1)
            if alias_results is not None:
                for _, const_val, offset_expr in alias_results:
                    results.append((def_idx, const_val, offset_expr))
                continue

        # ALIAS + CONST (e.g., macestep + 339)
        m = re.match(r"^(\w+)\s*\+\s*(\d{3,6})$", expr)
        if m and not m.group(1).isdigit():
            alias_results = resolve_var_to_constants(lines, m.group(1), depth + 1)
            if alias_results is not None and all(o == "" for _, _, o in alias_results):
                const_add = int(m.group(2))
                for _, base_val, _ in alias_results:
                    results.append((def_idx, base_val + const_add, ""))
                continue

        # Non-vnum definition (small number, random(), etc.) — skip it
        has_unresolvable = True

    # If we found at least some vnum-like definitions, use them
    # (handles cases like p = random(1,15) + p = 3139 + random(1,7))
    return results if results else None


def convert_file(filepath: Path, dry_run: bool = True) -> tuple[int, list[str]]:
    content = filepath.read_text()
    if "math.floor(" not in content:
        return 0, []

    lines = content.split("\n")
    original_lines = list(lines)  # Keep originals for resolution
    warnings = []

    # Collect all pending edits: {line_idx: new_line_content}
    edits: dict[int, str] = {}

    math_pat = re.compile(
        r"math\.floor\((\w+)\s*/\s*100\)\s*,\s*\1\s*%\s*100"
    )

    # Group math.floor usages by variable name
    var_usages: dict[str, list[int]] = {}
    for i, line in enumerate(lines):
        if "math.floor(" not in line:
            continue
        m = math_pat.search(line)
        if m:
            var_name = m.group(1)
            var_usages.setdefault(var_name, []).append(i)

    for var_name, usage_lines in var_usages.items():
        # Resolve using original (unmodified) lines
        resolved = resolve_var_to_constants(original_lines, var_name)
        if resolved is None:
            for i in usage_lines:
                warnings.append(f"  L{i+1}: can't resolve '{var_name}'")
            continue

        # Resolve all constants to zones
        zone_set = set()
        for def_idx, const_val, offset_expr in resolved:
            zone, local_id = vnum_to_parts(const_val)
            zone_set.add(zone)

        if len(zone_set) != 1:
            for i in usage_lines:
                warnings.append(
                    f"  L{i+1}: '{var_name}' maps to multiple zones: {sorted(zone_set)}"
                )
            continue

        zone = zone_set.pop()

        # Update usage lines: math.floor(var/100), var%100 → zone, var
        for i in usage_lines:
            m = math_pat.search(lines[i])
            if m:
                replacement = f"{zone}, {var_name}"
                edits[i] = lines[i][:m.start()] + replacement + lines[i][m.end():]

        # Update variable definitions to use local IDs
        direct_defs = find_var_definitions(original_lines, var_name)
        seen_alias_defs: set[int] = set()

        for def_idx, def_expr in direct_defs:
            expr = def_expr.strip()

            # Pure constant
            if expr.isdigit() and len(expr) >= 3:
                const_val = int(expr)
                _, local_id = vnum_to_parts(const_val)
                old_def = original_lines[def_idx]
                new_def = re.sub(
                    rf"(local\s+{re.escape(var_name)}\s*=\s*){re.escape(str(const_val))}\b",
                    rf"\g<1>{local_id}",
                    old_def,
                )
                if new_def != old_def:
                    edits[def_idx] = new_def

            # Variable alias — also fix the source variable
            elif re.match(r"^\w+$", expr) and not expr.isdigit():
                alias_name = expr
                alias_defs = find_var_definitions(original_lines, alias_name)
                for adef_idx, adef_expr in alias_defs:
                    if adef_idx in seen_alias_defs:
                        continue
                    seen_alias_defs.add(adef_idx)
                    aexpr = adef_expr.strip()
                    a_old = original_lines[adef_idx]
                    a_new = a_old
                    if aexpr.isdigit() and len(aexpr) >= 3:
                        const_val = int(aexpr)
                        _, local_id = vnum_to_parts(const_val)
                        a_new = re.sub(
                            rf"(local\s+{re.escape(alias_name)}\s*=\s*){re.escape(str(const_val))}\b",
                            rf"\g<1>{local_id}",
                            a_old,
                        )
                    elif re.match(r"^(\d{3,6})\s*\+\s*(.+)$", aexpr):
                        am = re.match(r"^(\d{3,6})\s*\+\s*(.+)$", aexpr)
                        const_val = int(am.group(1))
                        _, base_local = vnum_to_parts(const_val)
                        a_new = a_old.replace(str(const_val), str(base_local), 1)
                    elif re.match(r"^(.+?)\s*\+\s*(\d{3,6})$", aexpr):
                        am = re.match(r"^(.+?)\s*\+\s*(\d{3,6})$", aexpr)
                        if am and not am.group(1).strip().isdigit():
                            const_val = int(am.group(2))
                            _, base_local = vnum_to_parts(const_val)
                            # Replace from right side
                            idx = a_old.rfind(str(const_val))
                            if idx >= 0:
                                a_new = a_old[:idx] + str(base_local) + a_old[idx + len(str(const_val)):]
                    if a_new != a_old:
                        edits[adef_idx] = a_new

            # CONST + EXPR
            else:
                cm = re.match(r"^(\d{3,6})\s*\+\s*(.+)$", expr)
                if cm:
                    const_val = int(cm.group(1))
                    _, base_local = vnum_to_parts(const_val)
                    old_def = original_lines[def_idx]
                    new_def = old_def.replace(str(const_val), str(base_local), 1)
                    if new_def != old_def:
                        edits[def_idx] = new_def
                else:
                    cm = re.match(r"^(.+?)\s*\+\s*(\d{3,6})$", expr)
                    if cm and not cm.group(1).strip().isdigit():
                        const_val = int(cm.group(2))
                        _, base_local = vnum_to_parts(const_val)
                        old_def = original_lines[def_idx]
                        idx = old_def.rfind(str(const_val))
                        if idx >= 0:
                            new_def = old_def[:idx] + str(base_local) + old_def[idx + len(str(const_val)):]
                            if new_def != old_def:
                                edits[def_idx] = new_def

    # Also fix comparisons for resolved variables (e.g., p == 3182 → p == 182)
    # Build a set of (var_name, zone) for resolved variables
    resolved_vars: dict[str, int] = {}
    for var_name, usage_lines in var_usages.items():
        resolved = resolve_var_to_constants(original_lines, var_name)
        if resolved is None:
            continue
        zones = set()
        for _, const_val, _ in resolved:
            z, _ = vnum_to_parts(const_val)
            zones.add(z)
        if len(zones) == 1:
            resolved_vars[var_name] = zones.pop()

    for var_name, zone in resolved_vars.items():
        zone_base = zone * 100
        # Find VAR == CONST or VAR ~= CONST patterns with vnum-like constants
        comp_pat = re.compile(
            rf"\b{re.escape(var_name)}\s*(==|~=|>=|<=|>|<)\s*(\d{{3,6}})\b"
        )
        for i, line in enumerate(original_lines):
            if i in edits:
                # Check the edited version instead
                check_line = edits[i]
            else:
                check_line = line

            for m in comp_pat.finditer(check_line):
                const_val = int(m.group(2))
                resolved_zone, local_id = vnum_to_parts(const_val)
                if resolved_zone == zone and const_val != local_id:
                    # Replace the constant with its local ID
                    if i in edits:
                        edits[i] = edits[i].replace(str(const_val), str(local_id))
                    else:
                        edits[i] = check_line.replace(str(const_val), str(local_id))

    # Apply all edits
    changes = len(edits)
    if changes > 0:
        for line_idx, new_line in edits.items():
            lines[line_idx] = new_line
        new_content = "\n".join(lines)
        if not dry_run:
            filepath.write_text(new_content)

    return changes, warnings


def main():
    import argparse

    parser = argparse.ArgumentParser(
        description="Fix math.floor fallback patterns from vnum conversion"
    )
    parser.add_argument("--apply", action="store_true", help="Apply changes (default: dry-run)")
    parser.add_argument("--file", type=str, help="Process a single file")
    parser.add_argument("--verbose", "-v", action="store_true", help="Show all changes")
    args = parser.parse_args()

    init_zone_map()

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
        if "math.floor(" not in content:
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
        if "math.floor(" in lua_file.read_text():
            remaining += 1

    print(f"Files still containing math.floor: {remaining}")
    if not args.apply:
        print("\nDry run. Use --apply to write changes.")


if __name__ == "__main__":
    main()
