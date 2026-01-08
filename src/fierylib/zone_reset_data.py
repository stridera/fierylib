"""
Zone Reset Data - In-memory storage for parsed zone reset commands

Stores reset commands from .zon files for efficient single-parse import.
All resets use legacy vnums for validation and debugging.
"""

from dataclasses import dataclass, field
from typing import Dict, List
from mud.types.zone import Zone


@dataclass
class ZoneResetData:
    """Stores parsed reset commands from a zone file"""

    zone_id: int
    door_resets: Dict[int, Dict[str, dict]] = field(default_factory=dict)  # {room_vnum: {direction: {flags, defaultState}}}
    mob_resets: List[dict] = field(default_factory=list)
    object_resets: List[dict] = field(default_factory=list)


def extract_door_resets(zone: Zone) -> Dict[int, Dict[str, dict]]:
    """
    Extract door reset commands from parsed zone

    Args:
        zone: Parsed Zone object with reset commands

    Returns:
        Dict mapping room_vnum -> {direction -> {'flags': [...], 'defaultState': 'OPEN'|'CLOSED'|'LOCKED'}}
        Example: {3045: {'NORTH': {'flags': ['IS_DOOR', 'HIDDEN'], 'defaultState': 'LOCKED'}}}
    """
    door_resets = {}

    resets = getattr(zone, "resets", None)
    if not resets:
        return door_resets

    # Get door reset list from resets dict
    door_list = resets.get("door", []) if isinstance(resets, dict) else []

    for door in door_list:
        room_vnum = int(door.get("room"))
        direction = str(door.get("direction"))
        state = door.get("state", [])

        # Flatten state list (may be nested from continued D commands)
        flattened_state = []
        if isinstance(state, list):
            for s in state:
                if isinstance(s, list):
                    flattened_state.extend(s)
                else:
                    flattened_state.append(s)

        # Build flags: IS_DOOR always, plus HIDDEN if present
        # CLOSED/LOCKED are now stored in defaultState, not flags
        flags = ["IS_DOOR"]
        flat_upper = {str(x).upper() for x in flattened_state}

        if "HIDDEN" in flat_upper:
            flags.append("HIDDEN")

        # Determine defaultState (LOCKED > CLOSED > OPEN)
        if "LOCKED" in flat_upper:
            default_state = "LOCKED"
        elif "CLOSED" in flat_upper:
            default_state = "CLOSED"
        else:
            default_state = "OPEN"

        # Store in nested dict structure
        if room_vnum not in door_resets:
            door_resets[room_vnum] = {}
        door_resets[room_vnum][direction] = {
            "flags": flags,
            "defaultState": default_state,
        }

    return door_resets


def extract_mob_resets(zone: Zone) -> List[dict]:
    """
    Extract mob reset commands from parsed zone

    Args:
        zone: Parsed Zone object with reset commands

    Returns:
        List of mob reset dicts in original format expected by import_mob_reset()
        Example: [
            {
                'id': 3001,
                'max': 1,
                'room': 3045,
                'equipped': [{'id': 3050, 'max': 1, 'position': 'WIELD'}],
                'carrying': [{'id': 3051, 'max': 1, 'contains': [...]}]
            }
        ]
    """
    mob_resets = []

    resets = getattr(zone, "resets", None)
    if not resets:
        return mob_resets

    # Get mob reset list from resets dict - already in correct format!
    mob_list = resets.get("mob", []) if isinstance(resets, dict) else []

    # Return as-is since the parser already provides the correct format
    return mob_list if mob_list else []


def extract_object_resets(zone: Zone) -> List[dict]:
    """
    Extract object reset commands from parsed zone

    Args:
        zone: Parsed Zone object with reset commands

    Returns:
        List of object reset dicts in original format expected by import_object_reset()
        Example: [
            {
                'id': 3099,
                'max': 1,
                'room': 3045,
                'contains': [{'id': 3100, 'max': 1, ...}]
            }
        ]
    """
    object_resets = []

    resets = getattr(zone, "resets", None)
    if not resets:
        return object_resets

    # Get object reset list from resets dict - already in correct format!
    obj_list = resets.get("object", []) if isinstance(resets, dict) else []

    # Return as-is since the parser already provides the correct format
    return obj_list if obj_list else []
