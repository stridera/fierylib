from dataclasses import dataclass
from typing import Self

from mud.bitflags import BitFlags
from mud.flags import AFFECTS, EFFECTS, OBJECT_FLAGS, OBJECT_TYPES, WEAR_FLAGS
from mud.mudfile import MudData
from mud.parser import Parser
from mud.types import MudTypes, WearLocation, obj_val, Extras


@dataclass
class Object:
    id: int
    type: str | None = None
    keywords: list[str] | None = None
    short: str | None = None
    ground: str | None = None
    action_description: str | None = None
    extras: list[Extras] | None = None
    values: dict | None = None  # Stats that change for each object type
    flags: list[str] | None = None  # ItemFlags
    weight: float | None = None
    cost: int | None = None
    timer: int | None = None
    decompose_timer: int | None = None
    level: int | None = None
    effect_flags: list[str] | None = None  # flags.py EFFECTS
    wear_flags: list[str] | None = None
    concealment: int | None = None
    affects: list[dict[str, int]] | None = None  # Affects
    applies: dict[str, int] | None = None  # ObjApplies (location (str/dex/etc), modifier)
    spells: list[str] | None = None  # Spell books Only
    triggers: list[str] | None = None  # Scripts
    script_variables: dict[str, str] | None = None  # Script Variables
    contains: list[Self] | None = None  # Containers Only
    effects: list[str] | None = None  # Object Effects

    @classmethod
    def parse(cls, data: MudData):
        objects = []
        for object_data in data.split_by_delimiter():
            obj = {}
            obj["id"] = int(object_data.get_next_line().lstrip("#"))

            obj["keywords"] = object_data.read_string().split(" ")
            obj["short"] = object_data.read_string()
            obj["ground"] = object_data.read_string()
            obj["action_description"] = object_data.read_string()

            type_flag, extra_flags, wear_flags, level = object_data.get_next_line().split()
            f1, f2, f3, f4, f5, f6, f7 = object_data.get_next_line().split()
            weight, cost, timer, eff1, _, _, eff2, eff3 = object_data.get_next_line().split()
            item_types_str = BitFlags.get_flag(int(type_flag), OBJECT_TYPES)
            extra_flags = BitFlags.build_flags(int(extra_flags), OBJECT_FLAGS)
            wear_flags_text = BitFlags.build_flags(int(wear_flags), WEAR_FLAGS)
            extra_stats = obj_val(item_types_str, f1, f2, f3, f4, f5, f6, f7)
            effects = (int(eff3) << 26) | (int(eff2) << int(13)) | int(eff1)
            obj_effects = BitFlags.build_flags(effects, EFFECTS)

            # Store the type as a string from OBJECT_TYPES list
            obj["type"] = item_types_str
            obj["wear_flags"] = wear_flags_text
            obj["flags"] = extra_flags
            obj["level"] = int(level)
            obj["weight"] = float(weight)
            obj["cost"] = int(cost)
            obj["timer"] = int(timer)
            obj["effects"] = obj_effects
            obj["values"] = extra_stats

            while line := object_data.get_next_line():
                if line.startswith("E"):
                    if "extras" not in obj:
                        obj["extras"] = []
                    keyword = object_data.read_string().split(" ")
                    extra_desc = object_data.read_string()
                    obj["extras"].append(Extras(keywords=keyword, text=extra_desc))
                elif line.startswith("A"):
                    if "affects" not in obj:
                        obj["affects"] = []
                    location, modifier = object_data.get_next_line().strip().split(" ")
                    obj["affects"].append(
                        {
                            "location": BitFlags.get_flag(location, AFFECTS),
                            "modifier": int(modifier),
                        }
                    )
                elif line.startswith("H"):
                    obj["concealment"] = int(object_data.get_next_line().strip())
                elif line.startswith("T"):
                    if "triggers" not in obj:
                        obj["triggers"] = []
                    obj["triggers"].append(int(line[2:]))
                elif line.startswith("X"):
                    if "flags" not in obj:
                        obj["flags"] = []
                    obj["flags"] += BitFlags.build_flags(object_data.get_next_line().strip(), OBJECT_FLAGS, 32)
                elif line.startswith(("#", "$")):
                    break
                else:
                    raise Exception(f"Unknown Extra Flags: {line}")

            objects.append(cls(**obj))
        return objects

    @classmethod
    def parse_player(cls, player_file: MudData):
        objects = {"inventory": [], "equipment": {}}
        parser = Parser(MudTypes.OBJECT)
        if player_file.get_next_line() != "1":
            print(f"Error! Unsupported version: {player_file.data[0]}.  Skipping.")

        last_root = None
        for object_data in player_file.split_by_delimiter("~~"):
            parsed_data = parser.parse(object_data)
            location = parsed_data.pop("location")
            obj = Object(**parsed_data)

            if location < 0:  # Item inside container.
                depth = -location
                if not last_root:
                    raise Exception("Error!  No last root.", obj.id)
                parent = last_root
                for _ in range(1, depth):
                    parent = parent.contains[-1]
                if not parent.contains:
                    parent.contains = []
                parent.contains.append(obj)
            elif location == 127:  # Item in inventory.
                objects["inventory"].append(obj)
                last_root = obj
            else:
                location_name = WearLocation(location).name
                objects["equipment"][location_name] = obj
                last_root = obj

        return objects
