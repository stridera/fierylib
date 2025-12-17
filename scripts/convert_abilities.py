#!/usr/bin/env python3
"""Convert abilities.json from old effect types to new consolidated format."""

import json
from pathlib import Path

def convert_effect(effect_data: dict) -> dict:
    """Convert a single effect from old format to new format."""
    effect_type = effect_data.get("effect")
    params = effect_data.get("params", {})
    new_params = params.copy()
    new_effect = effect_type

    # stat_mod -> modify (change stat to target)
    if effect_type == "stat_mod":
        new_effect = "modify"
        if "stat" in new_params:
            stat = new_params.pop("stat")
            # Normalize stat names
            stat_map = {
                "WARD": "ward",
                "STR": "str",
                "DEX": "dex",
                "CON": "con",
                "INT": "int",
                "WIS": "wis",
                "CHA": "cha",
                "HITROLL": "hitroll",
                "DAMROLL": "damroll",
                "AC": "ac",
            }
            new_params["target"] = stat_map.get(stat.upper(), stat.lower())

    # resource_mod -> modify (change resource to target)
    elif effect_type == "resource_mod":
        new_effect = "modify"
        if "resource" in new_params:
            resource = new_params.pop("resource")
            resource_map = {
                "hp": "max_hp",
                "mana": "max_mana",
                "move": "max_move",
            }
            new_params["target"] = resource_map.get(resource.lower(), f"max_{resource.lower()}")

    # saving_mod -> modify (change type to target)
    elif effect_type == "saving_mod":
        new_effect = "modify"
        if "type" in new_params:
            save_type = new_params.pop("type")
            save_map = {
                "spell": "save_spell",
                "para": "save_para",
                "rod": "save_rod",
                "petri": "save_petri",
                "breath": "save_breath",
                "all": "save_all",
            }
            new_params["target"] = save_map.get(save_type.lower(), f"save_{save_type.lower()}")

    # size_mod -> modify (change to target: size)
    elif effect_type == "size_mod":
        new_effect = "modify"
        new_params["target"] = "size"

    # create_object -> create
    elif effect_type == "create_object":
        new_effect = "create"
        # Rename type to objectType if present
        if "type" in new_params and "objectType" not in new_params:
            new_params["objectType"] = new_params.pop("type")

    # cure -> cleanse
    elif effect_type == "cure":
        new_effect = "cleanse"

    # crowd_control -> status (change type to flag)
    elif effect_type == "crowd_control":
        new_effect = "status"
        if "type" in new_params:
            cc_type = new_params.pop("type")
            cc_map = {
                "paralyze": "paralyzed",
                "sleep": "sleeping",
                "charm": "charmed",
                "fear": "feared",
                "confuse": "confused",
                "silence": "silenced",
                "slow": "slowed",
                "web": "webbed",
                "mesmerize": "mesmerized",
                "blind": "blinded",
            }
            new_params["flag"] = cc_map.get(cc_type.lower(), cc_type.lower())

    # detection -> status (change type to flag)
    elif effect_type == "detection":
        new_effect = "status"
        if "type" in new_params:
            det_type = new_params.pop("type")
            det_map = {
                "invisible": "detect_invisible",
                "magic": "detect_magic",
                "align": "detect_align",
                "poison": "detect_poison",
                "life": "detect_life",
                "hidden": "detect_hidden",
            }
            new_params["flag"] = det_map.get(det_type.lower(), f"detect_{det_type.lower()}")

    # stealth -> status (change type to flag)
    elif effect_type == "stealth":
        new_effect = "status"
        if "type" in new_params:
            stealth_type = new_params.pop("type")
            stealth_map = {
                "invisible": "invisible",
                "camouflage": "camouflaged",
                "hide": "hidden",
            }
            new_params["flag"] = stealth_map.get(stealth_type.lower(), stealth_type.lower())
        # Rename level to contestedBy if it's perception-related
        if "level" in new_params:
            # Keep level as-is for now, it's the stealth power
            pass

    # protection -> status with resistance flag
    elif effect_type == "protection":
        new_effect = "status"
        new_params["flag"] = "resistance"
        # type and amount stay the same

    # vulnerability -> status with vulnerability flag
    elif effect_type == "vulnerability":
        new_effect = "status"
        new_params["flag"] = "vulnerability"
        # type and amount stay the same

    # reflect -> status with reflect flag
    elif effect_type == "reflect":
        new_effect = "status"
        new_params["flag"] = "reflect"
        # type and amount stay the same

    # lifesteal -> status with lifesteal flag
    elif effect_type == "lifesteal":
        new_effect = "status"
        new_params["flag"] = "lifesteal"
        # Rename percent to amount if present
        if "percent" in new_params:
            new_params["amount"] = new_params.pop("percent")

    # dot -> damage (keep type/amount, ensure interval/duration are present)
    elif effect_type == "dot":
        new_effect = "damage"
        # Ensure interval is present (default to 1 if not)
        if "interval" not in new_params:
            new_params["interval"] = 1

    # chain_damage -> damage (keep maxJumps, attenuation)
    elif effect_type == "chain_damage":
        new_effect = "damage"
        # maxJumps and attenuation stay the same

    # room_effect -> room with subtype: effect
    elif effect_type == "room_effect":
        new_effect = "room"
        new_params["subtype"] = "effect"

    # room_barrier -> room with subtype: barrier
    elif effect_type == "room_barrier":
        new_effect = "room"
        new_params["subtype"] = "barrier"

    # banish -> extract
    elif effect_type == "banish":
        new_effect = "extract"
        # Remove the old banish-specific params
        new_params = {"target": "mob"}
        if effect_data.get("params", {}).get("destroyEquipment"):
            new_params["destroyEquipment"] = True

    # Build new effect data
    new_effect_data = {
        "effect": new_effect,
        "order": effect_data.get("order", 0),
        "params": new_params,
        "trigger": effect_data.get("trigger", "on_cast"),
    }

    # Preserve optional fields
    if "notes" in effect_data:
        new_effect_data["notes"] = effect_data["notes"]
    if "chance" in effect_data:
        new_effect_data["chance"] = effect_data["chance"]

    return new_effect_data


def convert_abilities(input_path: Path, output_path: Path):
    """Convert all abilities from old format to new format."""
    with open(input_path, 'r') as f:
        abilities = json.load(f)

    converted_count = 0
    effect_types_converted = set()

    for ability in abilities:
        if "effects" in ability:
            new_effects = []
            for effect in ability["effects"]:
                old_type = effect.get("effect")
                new_effect = convert_effect(effect)
                new_effects.append(new_effect)

                if new_effect["effect"] != old_type:
                    converted_count += 1
                    effect_types_converted.add(f"{old_type} -> {new_effect['effect']}")

            ability["effects"] = new_effects

    with open(output_path, 'w') as f:
        json.dump(abilities, f, indent=2)

    print(f"Converted {converted_count} effects")
    print("Conversions made:")
    for conv in sorted(effect_types_converted):
        print(f"  {conv}")


if __name__ == "__main__":
    base_path = Path("/home/strider/Code/mud/fierylib/data")
    input_file = base_path / "abilities.json"
    output_file = base_path / "abilities.json"  # Overwrite in place

    convert_abilities(input_file, output_file)
    print(f"\nUpdated {output_file}")
