#!/usr/bin/env python3
"""
Convert old doors.* API calls to new room:exit(dir):set_state() API.

Conversions:
- doors.set_state(room, dir, {action = "room"}) -> room:exit(dir):set_state({hidden = false})
- doors.set_state(room, dir, {action = "purge"}) -> room:exit(dir):set_state({hidden = true})
- doors.set_flags(room, dir, "flags") -> room:exit(dir):set_state({has_door = ..., closed = ..., locked = ..., pickproof = ...})
- doors.set_name(room, dir, name) -> room:exit(dir):set_state({name = name})
- doors.set_description(room, dir, desc) -> room:exit(dir):set_state({description = desc})
- doors.set_key(room, dir, key) -> removed (not supported)
"""

import re
import os
from pathlib import Path


def parse_flags(flag_string: str) -> dict:
    """Convert flag string like 'abcd' to properties dict."""
    result = {}
    if 'a' in flag_string:
        result['has_door'] = 'true'
    if 'b' in flag_string:
        result['closed'] = 'true'
    if 'c' in flag_string:
        result['locked'] = 'true'
    if 'd' in flag_string:
        result['pickproof'] = 'true'
    if 'e' in flag_string:
        result['hidden'] = 'true'
    if 'f' in flag_string:
        # 'f' was a custom flag in DG scripts, treat as hidden for now
        result['hidden'] = 'true'
    return result


def convert_script(commands: str) -> str:
    """Convert all doors.* calls in a script to new API."""

    # Pattern for room expressions - handles get_room(x, y) with nested parens and variables
    room_pattern = r'(?:get_room\([^)]+\)|self\.room|room)'
    # Also handle get_room with variable expressions like get_room(self.zone_id, self.id)
    room_pattern_extended = r'(?:get_room\([^)]+\)|self\.room|room)'

    # Pattern for doors.set_state with action
    pattern_set_state = rf'doors\.set_state\(({room_pattern}),\s*("[^"]+"),\s*(\{{[^}}]+\}})\)'

    def replace_set_state(m):
        room_expr = m.group(1).strip()
        direction = m.group(2)
        action_table = m.group(3)
        new_expr = f"{room_expr}:exit({direction})"
        if 'action = "room"' in action_table or "action = 'room'" in action_table:
            return f"{new_expr}:set_state({{hidden = false}})"
        elif 'action = "purge"' in action_table or "action = 'purge'" in action_table:
            return f"{new_expr}:set_state({{hidden = true}})"
        else:
            return f"{new_expr}:set_state({action_table})"

    commands = re.sub(pattern_set_state, replace_set_state, commands)

    # Pattern for doors.set_flags - handles flags a-f
    pattern_set_flags = rf'doors\.set_flags\(({room_pattern}),\s*("[^"]+"),\s*"([a-f]+)"\)'

    def replace_set_flags(m):
        room_expr = m.group(1).strip()
        direction = m.group(2)
        flag_str = m.group(3)
        new_expr = f"{room_expr}:exit({direction})"
        flags = parse_flags(flag_str)
        if flags:
            props = ", ".join(f"{k} = {v}" for k, v in flags.items())
            return f"{new_expr}:set_state({{{props}}})"
        return f"-- FIXME: empty flags in doors.set_flags"

    commands = re.sub(pattern_set_flags, replace_set_flags, commands)

    # Pattern for doors.set_name - captures the name which may contain commas in strings
    pattern_set_name = rf'doors\.set_name\(({room_pattern}),\s*("[^"]+"),\s*("[^"]*")\)'

    def replace_set_name(m):
        room_expr = m.group(1).strip()
        direction = m.group(2)
        name = m.group(3)
        new_expr = f"{room_expr}:exit({direction})"
        return f"{new_expr}:set_state({{name = {name}}})"

    commands = re.sub(pattern_set_name, replace_set_name, commands)

    # Pattern for doors.set_description - handles escaped quotes in description
    pattern_set_desc = rf'doors\.set_description\(({room_pattern}),\s*("[^"]+"),\s*("(?:[^"\\]|\\.)*")\)'

    def replace_set_desc(m):
        room_expr = m.group(1).strip()
        direction = m.group(2)
        desc = m.group(3)
        new_expr = f"{room_expr}:exit({direction})"
        return f"{new_expr}:set_state({{description = {desc}}})"

    commands = re.sub(pattern_set_desc, replace_set_desc, commands)

    # Pattern for doors.set_exit - creates/modifies exit to destination room
    pattern_set_exit = rf'doors\.set_exit\(({room_pattern_extended}),\s*("[^"]+"),\s*({room_pattern_extended})\)'

    def replace_set_exit(m):
        room_expr = m.group(1).strip()
        direction = m.group(2)
        dest_room = m.group(3)
        # set_exit creates/links an exit to a destination room
        return f"{room_expr}:exit({direction}):set_destination({dest_room})"

    commands = re.sub(pattern_set_exit, replace_set_exit, commands)

    # Pattern for doors.set_key
    pattern_set_key = rf'doors\.set_key\(({room_pattern}),\s*("[^"]+"),\s*([^)]+)\)'

    def replace_set_key(m):
        # set_key is not implemented in the new API - just remove
        return f"-- REMOVED: doors.set_key (not supported): {m.group(0)}"

    commands = re.sub(pattern_set_key, replace_set_key, commands)

    return commands


def main():
    triggers_dir = Path("/home/strider/Code/mud/fierylib/data/triggers")

    # Find all .lua files with doors.* calls
    lua_files = list(triggers_dir.rglob("*.lua"))

    updated = 0
    files_with_remaining = []

    for lua_file in lua_files:
        content = lua_file.read_text()

        if "doors." not in content:
            continue

        new_content = convert_script(content)

        if new_content != content:
            # Check if conversion was successful (no remaining doors. calls)
            remaining = len(re.findall(r'doors\.', new_content))
            if remaining > 0:
                files_with_remaining.append((lua_file, remaining))

            lua_file.write_text(new_content)
            updated += 1
            print(f"Updated: {lua_file.relative_to(triggers_dir)}")

    print(f"\nUpdated {updated} files")

    if files_with_remaining:
        print(f"\nWARNING: {len(files_with_remaining)} files still have doors.* calls:")
        for f, count in files_with_remaining:
            print(f"  - {f.relative_to(triggers_dir)} ({count} remaining)")
    else:
        print("\nAll doors.* calls have been converted!")


if __name__ == "__main__":
    main()
