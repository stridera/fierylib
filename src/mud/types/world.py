from dataclasses import dataclass

from mud.bitflags import BitFlags
from mud.flags import ROOM_FLAGS, SECTORS
from mud.mudfile import MudData
from mud.types import Direction, Extras


@dataclass
class World:
    """Construct an World"""

    id: int
    name: str
    description: str
    sector: str
    flags: list[str]
    exits: dict[str, dict[str, str]] | None = None
    extras: list[Extras] | None = None

    @classmethod
    def parse(cls, world_file: MudData):
        rooms = []
        for room_data in world_file.split_by_delimiter():
            room = {}
            room["id"] = room_data.get_next_line().lstrip("#")
            room["name"] = room_data.read_string()
            room["description"] = room_data.read_string()
            (_zone, flags, sector) = room_data.get_next_line().split()
            room["flags"] = BitFlags.read_flags(flags, ROOM_FLAGS)
            room["sector"] = BitFlags.get_flag(int(sector), SECTORS)
            while line := room_data.get_next_line():
                if line == "S" or line.startswith("$"):
                    break
                elif line.startswith("D"):
                    if "exits" not in room:
                        room["exits"] = {}
                    exit = {}
                    direction = Direction(int(line[1:])).name
                    exit["description"] = room_data.read_string()
                    exit["keyword"] = room_data.read_string()
                    exit_type, key, destination = room_data.get_next_line().split()
                    if exit_type == "1":
                        exit["type"] = "Door"
                    elif exit_type == "2":
                        exit["type"] = "Pick-proof Door"
                    elif exit_type == "3":
                        exit["type"] = "Description only"
                    exit["key"] = key
                    exit["destination"] = destination
                    if direction in room["exits"]:
                        print(f"Duplicate exit for direction {direction} in room {room_data.id}")
                    room["exits"][direction] = exit
                elif line.startswith("E"):
                    if "extras" not in room:
                        room["extras"] = []
                    keyword = room_data.read_string().split(" ")
                    description = room_data.read_string()
                    room["extras"].append(Extras(keywords=keyword, text=description))
                else:
                    print(f"Unknown line: {line}")

            rooms.append(room)

        return rooms

    def to_json(self):
        from dataclasses import asdict

        return asdict(self)
