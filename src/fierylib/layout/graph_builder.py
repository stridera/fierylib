"""
Graph Builder - Loads rooms and exits from database into graph structure
"""

from typing import Dict, List, Set, Tuple, Optional
from collections import defaultdict


class RoomNode:
    """Represents a room in the graph"""

    def __init__(self, zone_id: int, room_id: int, name: str, sector: str):
        self.zone_id = zone_id
        self.room_id = room_id
        self.name = name
        self.sector = sector
        self.exits: Dict[str, Tuple[int, int]] = {}  # direction -> (dest_zone, dest_id)
        self.position: Optional[Tuple[int, int, int]] = None
        self.is_placed = False

    @property
    def room_key(self) -> Tuple[int, int]:
        """Return the composite key for this room"""
        return (self.zone_id, self.room_id)

    def __repr__(self):
        return f"Room({self.zone_id}, {self.room_id}, '{self.name}')"


class RoomGraph:
    """Graph structure for all rooms and their connections"""

    def __init__(self):
        self.rooms: Dict[Tuple[int, int], RoomNode] = {}
        self.isolated_rooms: Set[Tuple[int, int]] = set()
        self.zones: Set[int] = set()

    def add_room(self, zone_id: int, room_id: int, name: str, sector: str) -> RoomNode:
        """Add a room to the graph"""
        room_key = (zone_id, room_id)
        if room_key not in self.rooms:
            node = RoomNode(zone_id, room_id, name, sector)
            self.rooms[room_key] = node
            self.zones.add(zone_id)
        return self.rooms[room_key]

    def add_exit(
        self,
        from_zone: int,
        from_id: int,
        direction: str,
        to_zone: int,
        to_id: int,
    ):
        """Add an exit connection between two rooms"""
        from_key = (from_zone, from_id)
        to_key = (to_zone, to_id)

        if from_key in self.rooms:
            self.rooms[from_key].exits[direction] = to_key

    def get_room(self, zone_id: int, room_id: int) -> Optional[RoomNode]:
        """Get a room by its composite key"""
        return self.rooms.get((zone_id, room_id))

    def find_isolated_rooms(self):
        """Identify rooms with no connections in or out"""
        connected = set()

        # Find all rooms that have exits or are destinations
        for room_key, room in self.rooms.items():
            if room.exits:
                connected.add(room_key)
                for dest in room.exits.values():
                    connected.add(dest)

        # Isolated rooms are those not in the connected set
        self.isolated_rooms = set(self.rooms.keys()) - connected

    def get_rooms_by_zone(self, zone_id: int) -> List[RoomNode]:
        """Get all rooms belonging to a specific zone"""
        return [room for room in self.rooms.values() if room.zone_id == zone_id]

    def get_connected_component(
        self, start_key: Tuple[int, int]
    ) -> Set[Tuple[int, int]]:
        """
        Get all rooms reachable from the start room (BFS)
        Returns set of room keys
        """
        if start_key not in self.rooms:
            return set()

        from collections import deque

        visited = set()
        queue = deque([start_key])

        while queue:
            current_key = queue.popleft()  # O(1) instead of O(n)
            if current_key in visited:
                continue

            visited.add(current_key)
            current_room = self.rooms.get(current_key)

            if current_room:
                # Add all destinations from this room
                for dest_key in current_room.exits.values():
                    if dest_key not in visited and dest_key in self.rooms:
                        queue.append(dest_key)

        return visited

    def __len__(self):
        return len(self.rooms)


async def load_room_graph(prisma_client) -> RoomGraph:
    """
    Load all rooms and exits from the database into a graph structure
    Uses batching to avoid PostgreSQL stack depth errors

    Args:
        prisma_client: Connected Prisma client

    Returns:
        RoomGraph with all rooms and connections
    """
    graph = RoomGraph()

    BATCH_SIZE = 500

    # First, get total count of rooms
    total_rooms = await prisma_client.rooms.count(
        where={"deletedAt": None}
    )

    print(f"Loading {total_rooms} rooms from database in batches of {BATCH_SIZE}...")

    # Load rooms in batches
    loaded = 0
    skip = 0

    while skip < total_rooms:
        # Load batch of rooms with their exits
        rooms = await prisma_client.rooms.find_many(
            skip=skip,
            take=BATCH_SIZE,
            include={"exits": True},
            where={"deletedAt": None},
        )

        # Build graph for this batch
        for room in rooms:
            # Add room node (using composite key: zoneId, id)
            graph.add_room(
                zone_id=room.zoneId,
                room_id=room.id,
                name=room.name,
                sector=room.sector,
            )

            # Add exits using stored zone and room IDs
            if room.exits:
                for exit_data in room.exits:
                    if exit_data.toZoneId is not None and exit_data.toRoomId is not None:
                        graph.add_exit(
                            from_zone=room.zoneId,
                            from_id=room.id,
                            direction=exit_data.direction,
                            to_zone=exit_data.toZoneId,
                            to_id=exit_data.toRoomId,
                        )

        loaded += len(rooms)
        skip += BATCH_SIZE
        print(f"  Loaded {loaded}/{total_rooms} rooms ({(loaded/total_rooms)*100:.1f}%)")

    print(f"✅ Loaded {len(graph.rooms)} rooms total")

    # Identify isolated rooms
    graph.find_isolated_rooms()
    print(f"Found {len(graph.isolated_rooms)} isolated rooms")
    print(f"Found {len(graph.zones)} zones")

    return graph
