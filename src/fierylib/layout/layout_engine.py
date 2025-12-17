"""
Layout Engine - Core algorithm for placing rooms in 3D space
"""

from typing import Dict, List, Set, Tuple, Optional
from collections import deque, defaultdict

from .config import LayoutConfig
from .graph_builder import RoomGraph, RoomNode


class ConflictInfo:
    """Information about a position conflict"""

    def __init__(self, position: Tuple[int, int, int]):
        self.position = position
        self.rooms: List[Tuple[int, int]] = []  # List of (zone_id, room_id) at this position

    def add_room(self, zone_id: int, room_id: int):
        self.rooms.append((zone_id, room_id))

    @property
    def has_conflict(self) -> bool:
        return len(self.rooms) > 1

    def __repr__(self):
        return f"Conflict at {self.position}: {len(self.rooms)} rooms"


class LayoutEngine:
    """Main engine for auto-laying out rooms"""

    def __init__(self, config: LayoutConfig):
        self.config = config
        self.graph: Optional[RoomGraph] = None
        self.position_map: Dict[Tuple[int, int, int], ConflictInfo] = {}
        self.conflicts: List[ConflictInfo] = []
        self.placed_count = 0
        self.skipped_count = 0

    def generate_layout(self, graph: RoomGraph) -> Dict:
        """
        Generate layout for all rooms in the graph
        Handles multiple disconnected components automatically

        Args:
            graph: RoomGraph with all rooms and exits

        Returns:
            Dict with statistics about the layout generation
        """
        self.graph = graph
        self.position_map = {}
        self.conflicts = []
        self.placed_count = 0
        self.skipped_count = 0

        # Build reverse index for bidirectional traversal
        # Maps room_key -> set of rooms that have exits TO this room
        print("Building reverse exit index...")
        self.reverse_exits = {}
        for room_key, room in graph.rooms.items():
            for dest_key in room.exits.values():
                if dest_key in graph.rooms:
                    if dest_key not in self.reverse_exits:
                        self.reverse_exits[dest_key] = set()
                    self.reverse_exits[dest_key].add(room_key)

        # STEP 1: Start from configured starting room (Zone 30, ID 1)
        configured_start_key = (self.config.start_room_zone, self.config.start_room_id)
        start_room = self.graph.get_room(*configured_start_key)

        if not start_room:
            print(f"❌ ERROR: Configured start room (Zone {configured_start_key[0]}, ID {configured_start_key[1]}) not found!")
            print(f"Please check that this room exists in the database.")
            return {
                "success": False,
                "error": f"Start room {configured_start_key} not found",
                "total_rooms": len(self.graph),
                "placed": 0,
                "skipped": 0,
                "isolated": 0,
                "conflicts": 0,
                "zones": len(self.graph.zones),
                "components": 0,
            }

        # Place starting room at origin
        position = self.config.start_position
        print(f"Starting from configured room: Zone {configured_start_key[0]}, ID {configured_start_key[1]}")
        print(f"  '{start_room.name}'")
        print(f"Placing at origin {position}")

        self._place_room(start_room, position)

        # STEP 2: Place all rooms connected to starting room using BFS
        print(f"Placing all rooms connected to starting room...")
        self._bfs_placement_bidirectional(start_room)

        main_component_size = self.placed_count
        print(f"✅ Placed {main_component_size} rooms connected to starting room")

        # STEP 3: Find remaining unplaced rooms (disconnected from main component)
        unplaced_rooms = [
            room for room in self.graph.rooms.values()
            if not room.is_placed
        ]

        if unplaced_rooms:
            print(f"\n{len(unplaced_rooms)} rooms are disconnected from Zone {configured_start_key[0]}, ID {configured_start_key[1]}")
            print(f"Placing disconnected rooms by zone...")

            # Calculate zone centers from placed rooms
            zone_centers = self._calculate_zone_centers()

            # Group disconnected rooms by zone
            disconnected_by_zone: Dict[int, List[RoomNode]] = defaultdict(list)
            for room in unplaced_rooms:
                disconnected_by_zone[room.zone_id].append(room)

            # Place each zone's disconnected rooms
            for zone_id, rooms in disconnected_by_zone.items():
                center = zone_centers.get(zone_id, (0, 0, 0))
                print(f"  Zone {zone_id}: {len(rooms)} disconnected rooms")

                # Place using smart clustering (tries to match by name, otherwise grid)
                self._place_disconnected_components(rooms, center, zone_id)

        # Handle truly isolated rooms (no connections at all)
        self._place_isolated_rooms()

        # Identify conflicts
        self._identify_conflicts()

        disconnected_count = len(unplaced_rooms) if unplaced_rooms else 0

        return {
            "success": True,
            "total_rooms": len(self.graph),
            "placed": self.placed_count,
            "main_component": main_component_size,
            "disconnected": disconnected_count,
            "isolated": len(self.graph.isolated_rooms),
            "conflicts": len(self.conflicts),
            "zones": len(self.graph.zones),
        }

    def _find_connected_rooms(self, start_room: RoomNode) -> Set[Tuple[int, int]]:
        """
        Find all rooms reachable from the start room using BFS
        Treats the graph as UNDIRECTED (if A→B or B→A, they're connected)

        Args:
            start_room: Starting room

        Returns:
            Set of (zone_id, room_id) tuples for all connected rooms
        """
        visited = set()
        queue = deque([start_room.room_key])

        while queue:
            current_key = queue.popleft()

            if current_key in visited:
                continue

            visited.add(current_key)
            current_room = self.graph.get_room(*current_key)

            if current_room:
                # Add all destinations FROM this room
                for dest_key in current_room.exits.values():
                    if dest_key not in visited and dest_key in self.graph.rooms:
                        queue.append(dest_key)

                # Also add all rooms that have exits TO this room (bidirectional)
                if current_key in self.reverse_exits:
                    for source_key in self.reverse_exits[current_key]:
                        if source_key not in visited:
                            queue.append(source_key)

        return visited

    def _place_room(self, room: RoomNode, position: Tuple[int, int, int]) -> bool:
        """
        Place a room at the given position

        Args:
            room: Room to place
            position: (x, y, z) coordinates

        Returns:
            True if placed successfully, False if already placed
        """
        if room.is_placed:
            return False

        room.position = position
        room.is_placed = True
        self.placed_count += 1

        # Verbose logging
        if self.config.verbose:
            print(f"  Placed Zone {room.zone_id:3d} ID {room.room_id:4d} at ({position[0]:5d}, {position[1]:5d}, {position[2]:3d}) - {room.name[:50]}")

        # Track position for conflict detection
        if position not in self.position_map:
            self.position_map[position] = ConflictInfo(position)
        self.position_map[position].add_room(room.zone_id, room.room_id)

        return True

    def _bfs_placement(self, start_room: RoomNode):
        """
        Use Breadth-First Search to place rooms starting from start_room

        Args:
            start_room: Starting room (already placed)
        """
        queue = deque([start_room])
        visited = {start_room.room_key}

        while queue:
            current_room = queue.popleft()

            if not current_room.position:
                continue

            # Process each exit
            for direction, dest_key in current_room.exits.items():
                # Check if destination exists
                dest_room = self.graph.get_room(*dest_key)
                if not dest_room:
                    continue

                # Skip if already placed
                if dest_room.is_placed:
                    continue

                # Calculate new position based on direction
                new_position = self._calculate_position(
                    current_room.position, direction
                )

                # Place the room (even if it conflicts)
                self._place_room(dest_room, new_position)

                # Add to queue if not visited
                if dest_key not in visited:
                    visited.add(dest_key)
                    queue.append(dest_room)

    def _bfs_placement_bidirectional(self, start_room: RoomNode):
        """
        Use Breadth-First Search with bidirectional traversal to place all rooms in a component

        Args:
            start_room: Starting room (already placed)
        """
        queue = deque([start_room])
        visited = {start_room.room_key}

        # Special zones that should be excluded from main map placement
        # These are non-player zones that should be kept separate from the main world map
        excluded_zones = {
            0,   # System/void rooms
            1,   # System rooms
            2,   # System rooms
            4,   # System rooms
            9,   # System rooms
            12,  # God zone
        }

        while queue:
            current_room = queue.popleft()

            if not current_room.position:
                continue

            # Process exits FROM current room
            for direction, dest_key in current_room.exits.items():
                dest_room = self.graph.get_room(*dest_key)
                if not dest_room:
                    continue

                # Skip excluded zones - they'll be placed separately
                if dest_room.zone_id in excluded_zones:
                    continue

                # Skip if already placed
                if dest_room.is_placed:
                    continue

                # Calculate new position based on direction
                new_position = self._calculate_position(
                    current_room.position, direction
                )

                # Place the room
                self._place_room(dest_room, new_position)

                if dest_key not in visited:
                    visited.add(dest_key)
                    queue.append(dest_room)

            # Process rooms that have exits TO current room (reverse direction)
            # This handles one-way connections, including cross-zone connections
            if current_room.room_key in self.reverse_exits:
                for source_key in self.reverse_exits[current_room.room_key]:
                    source_room = self.graph.get_room(*source_key)
                    if not source_room:
                        continue

                    # Skip excluded zones - they'll be placed separately
                    if source_room.zone_id in excluded_zones:
                        continue

                    # Skip if already placed
                    if source_room.is_placed:
                        continue

                    # Find which direction the source room used to get here
                    source_direction = None
                    for dir, dest in source_room.exits.items():
                        if dest == current_room.room_key:
                            source_direction = dir
                            break

                    if source_direction:
                        # Calculate reverse position
                        reverse_vector = self._reverse_direction_vector(source_direction)
                        new_position = (
                            current_room.position[0] + reverse_vector[0],
                            current_room.position[1] + reverse_vector[1],
                            current_room.position[2] + reverse_vector[2],
                        )

                        # Place the room
                        self._place_room(source_room, new_position)

                        if source_key not in visited:
                            visited.add(source_key)
                            queue.append(source_room)

    def _reverse_direction_vector(self, direction: str) -> Tuple[int, int, int]:
        """
        Get the reverse of a direction vector

        Args:
            direction: Direction string (NORTH, SOUTH, etc.)

        Returns:
            Reverse vector (opposite direction)
        """
        vector = self.config.direction_vectors.get(direction, (0, 0, 0))
        return (-vector[0], -vector[1], -vector[2])

    def _calculate_position(
        self, current_pos: Tuple[int, int, int], direction: str
    ) -> Tuple[int, int, int]:
        """
        Calculate new position based on current position and direction

        Args:
            current_pos: Current (x, y, z) position
            direction: Direction string (NORTH, SOUTH, etc.)

        Returns:
            New (x, y, z) position
        """
        vector = self.config.direction_vectors.get(direction, (0, 0, 0))
        return (
            current_pos[0] + vector[0],
            current_pos[1] + vector[1],
            current_pos[2] + vector[2],
        )

    def _place_isolated_rooms(self):
        """
        Place rooms that have no connections
        Group them by zone and place near the zone's center of mass
        """
        if not self.graph.isolated_rooms:
            return

        if self.config.verbose:
            print(f"\nPlacing {len(self.graph.isolated_rooms)} isolated rooms (no exits)...")

        # Calculate zone centers based on placed rooms
        zone_centers = self._calculate_zone_centers()

        # Group isolated rooms by zone
        isolated_by_zone: Dict[int, List[RoomNode]] = defaultdict(list)
        for room_key in self.graph.isolated_rooms:
            room = self.graph.get_room(*room_key)
            if room and not room.is_placed:
                isolated_by_zone[room.zone_id].append(room)

        # Place isolated rooms in a grid near their zone center
        for zone_id, rooms in isolated_by_zone.items():
            center = zone_centers.get(zone_id, (0, 0, 0))
            if self.config.verbose:
                print(f"  Zone {zone_id}: {len(rooms)} isolated rooms, center at {center}")
            self._place_room_cluster_smart(rooms, center, zone_id)

    def _calculate_zone_centers(self) -> Dict[int, Tuple[int, int, int]]:
        """
        Calculate the center of mass for each zone based on placed rooms

        Returns:
            Dict mapping zone_id to (x, y, z) center position
        """
        zone_positions: Dict[int, List[Tuple[int, int, int]]] = defaultdict(list)

        # Collect all positions per zone
        for room in self.graph.rooms.values():
            if room.is_placed and room.position:
                zone_positions[room.zone_id].append(room.position)

        # Calculate centers
        centers = {}
        for zone_id, positions in zone_positions.items():
            if positions:
                avg_x = sum(p[0] for p in positions) // len(positions)
                avg_y = sum(p[1] for p in positions) // len(positions)
                avg_z = sum(p[2] for p in positions) // len(positions)
                centers[zone_id] = (avg_x, avg_y, avg_z)

        return centers

    def _find_related_room(self, room: RoomNode, zone_id: int) -> Optional[Tuple[int, int, int]]:
        """
        Try to find a related room by name matching to intelligently place unconnected rooms
        
        Args:
            room: Room to find related room for
            zone_id: Zone to search in
            
        Returns:
            Position near related room, or None if no match found
        """
        # Extract base name (remove things like "Back Room", "Storage", etc.)
        room_name_lower = room.name.lower()
        
        # Look for rooms with similar names in the same zone
        best_match = None
        best_score = 0
        
        for other_room in self.graph.rooms.values():
            if other_room.zone_id != zone_id or not other_room.is_placed:
                continue
            if other_room.room_key == room.room_key:
                continue
                
            other_name_lower = other_room.name.lower()
            
            # Check for common words between names
            room_words = set(room_name_lower.split())
            other_words = set(other_name_lower.split())
            
            # Remove common filler words
            filler_words = {'the', 'a', 'an', 'of', 'in', 'at', 'to', 'back', 'front', 'room', 'area'}
            room_words -= filler_words
            other_words -= filler_words
            
            if not room_words or not other_words:
                continue
            
            # Calculate similarity score
            common_words = room_words & other_words
            if common_words:
                # Score based on number of common words and length
                score = len(common_words) * 10
                # Bonus if one name contains the other
                if any(word in other_name_lower for word in room_words if len(word) > 3):
                    score += 5
                    
                if score > best_score:
                    best_score = score
                    best_match = other_room
        
        if best_match and best_score >= 10:
            # Place near the matched room, offset by z+1 to avoid collision
            return (best_match.position[0], best_match.position[1], best_match.position[2] + 1)
        
        return None

    def _place_disconnected_components(
        self, rooms: List[RoomNode], center: Tuple[int, int, int], zone_id: int
    ):
        """
        Place disconnected component rooms by grouping into connected components
        and placing each component using BFS to respect directional exits

        Args:
            rooms: List of rooms from disconnected components
            center: Zone center position (fallback for cluster positioning)
            zone_id: Zone ID for these rooms
        """
        if not rooms:
            return

        # Group rooms into connected components
        components = self._find_components(rooms)

        if self.config.verbose:
            print(f"    Found {len(components)} disconnected component(s) in zone {zone_id}")

        # Check if this zone has many small/isolated components (like god zones)
        # If so, use compact grid placement instead of wide ring distribution
        total_components = len(components)
        avg_component_size = len(rooms) / total_components if total_components > 0 else 0

        # Zones with many small components (avg size < 3) should use compact placement
        use_compact_placement = (total_components > 10 and avg_component_size < 3)

        if use_compact_placement:
            # Compact grid placement for zones with many isolated rooms
            if self.config.verbose:
                print(f"      Using compact placement for {total_components} small components")

            # Calculate grid dimensions
            import math
            grid_cols = int(math.sqrt(total_components * 1.5))  # Slightly wider than square
            grid_spacing = 2  # Rooms are spaced 2 units apart (tight clustering)

            # Start position offset from zone center
            start_x = center[0] + 500
            start_y = center[1]
            start_z = center[2] + 1

            for idx, component_rooms in enumerate(components):
                row = idx // grid_cols
                col = idx % grid_cols

                offset_x = start_x + (col * grid_spacing)
                offset_y = start_y + (row * grid_spacing)
                offset_z = start_z

                component_start_position = (offset_x, offset_y, offset_z)

                # Place component
                start_room = component_rooms[0]
                self._place_room(start_room, component_start_position)
                self._bfs_placement_component(start_room, set(r.room_key for r in component_rooms))
        else:
            # Ring placement for zones with fewer, larger components
            # Calculate offset distance - smaller for zones with more components
            base_distance = 500 + (zone_id * 10)
            # Reduce distance if there are many components to avoid huge spread
            component_offset_distance = base_distance // max(1, total_components // 5)

            for idx, component_rooms in enumerate(components):
                if self.config.verbose:
                    print(f"      Component {idx + 1}: {len(component_rooms)} rooms")

                # Calculate position for this component cluster
                # Position in a ring around the center
                import math
                angle = (2 * 3.14159 * idx) / len(components)
                offset_x = center[0] + int(component_offset_distance * math.cos(angle))
                offset_y = center[1] + int(component_offset_distance * math.sin(angle))
                offset_z = center[2] + 1  # One layer above to avoid conflicts

                component_start_position = (offset_x, offset_y, offset_z)

                # Pick the first room as starting point for this component
                start_room = component_rooms[0]

                # Place the starting room
                self._place_room(start_room, component_start_position)

                # Use BFS to place all connected rooms in this component
                # respecting their directional exits
                self._bfs_placement_component(start_room, set(r.room_key for r in component_rooms))

    def _find_components(self, rooms: List[RoomNode]) -> List[List[RoomNode]]:
        """
        Group rooms into connected components (undirected graph traversal)

        Args:
            rooms: List of unplaced rooms

        Returns:
            List of components, where each component is a list of connected rooms
        """
        unvisited = {room.room_key: room for room in rooms}
        components = []

        while unvisited:
            # Start a new component from an arbitrary unvisited room
            start_key, start_room = next(iter(unvisited.items()))
            component_keys = self.graph.get_connected_component(start_key)

            # Filter to only include rooms in our unvisited set
            component_rooms = []
            for key in component_keys:
                if key in unvisited:
                    component_rooms.append(unvisited[key])
                    del unvisited[key]

            if component_rooms:
                components.append(component_rooms)

        return components

    def _bfs_placement_component(self, start_room: RoomNode, component_keys: Set[Tuple[int, int]]):
        """
        Use BFS to place all rooms in a component, respecting directional exits
        Only places rooms that are part of the specified component

        Args:
            start_room: Starting room (already placed)
            component_keys: Set of (zone_id, room_id) tuples that are part of this component
        """
        queue = deque([start_room])
        visited = {start_room.room_key}

        while queue:
            current_room = queue.popleft()

            if not current_room.position:
                continue

            # Process exits FROM current room
            for direction, dest_key in current_room.exits.items():
                # Only process rooms in this component
                if dest_key not in component_keys:
                    continue

                dest_room = self.graph.get_room(*dest_key)
                if not dest_room:
                    continue

                # Skip if already placed
                if dest_room.is_placed:
                    continue

                # Calculate new position based on direction
                new_position = self._calculate_position(
                    current_room.position, direction
                )

                # Place the room
                self._place_room(dest_room, new_position)

                if dest_key not in visited:
                    visited.add(dest_key)
                    queue.append(dest_room)

            # Also process reverse exits (rooms that exit TO current room)
            if current_room.room_key in self.reverse_exits:
                for source_key in self.reverse_exits[current_room.room_key]:
                    # Only process rooms in this component
                    if source_key not in component_keys:
                        continue

                    source_room = self.graph.get_room(*source_key)
                    if not source_room:
                        continue

                    # Skip if already placed
                    if source_room.is_placed:
                        continue

                    # Find which direction the source room used to get here
                    source_direction = None
                    for dir, dest in source_room.exits.items():
                        if dest == current_room.room_key:
                            source_direction = dir
                            break

                    if source_direction:
                        # Calculate reverse position
                        reverse_vector = self._reverse_direction_vector(source_direction)
                        new_position = (
                            current_room.position[0] + reverse_vector[0],
                            current_room.position[1] + reverse_vector[1],
                            current_room.position[2] + reverse_vector[2],
                        )

                        # Place the room
                        self._place_room(source_room, new_position)

                        if source_key not in visited:
                            visited.add(source_key)
                            queue.append(source_room)

    def _place_room_cluster_smart(
        self, rooms: List[RoomNode], center: Tuple[int, int, int], zone_id: int
    ):
        """
        Intelligently place a cluster of isolated rooms (no connections)
        Uses component-based placement for consistency

        Args:
            rooms: List of rooms to place
            center: Center position to cluster around
            zone_id: Zone ID for these rooms
        """
        # For isolated rooms with no connections, just use the component placement logic
        # but with a simpler offset calculation
        self._place_disconnected_components(rooms, center, zone_id)

    def _place_room_cluster(
        self, rooms: List[RoomNode], center: Tuple[int, int, int]
    ):
        """
        Place a cluster of rooms in a grid pattern near the center

        Args:
            rooms: List of rooms to place
            center: Center position to cluster around
        """
        # Offset from center to avoid conflicts with connected rooms
        # Place isolated rooms on a higher Z-layer (z+1) to separate from main map
        offset_x = center[0]
        offset_y = center[1]
        offset_z = center[2] + 1  # One layer above the zone's main level

        if self.config.verbose:
            print(f"    Placing cluster at offset ({offset_x}, {offset_y}, {offset_z}) [+1 Z from center to avoid conflicts]")

        # Group by sector if configured
        if self.config.group_by_sector:
            by_sector: Dict[str, List[RoomNode]] = defaultdict(list)
            for room in rooms:
                by_sector[room.sector].append(room)

            # Place each sector group in a line
            current_x = offset_x
            for sector, sector_rooms in by_sector.items():
                for i, room in enumerate(sector_rooms):
                    position = (current_x + i, offset_y, offset_z)
                    self._place_room(room, position)
                current_x += len(sector_rooms) + 5  # Space between sectors
        else:
            # Simple grid placement
            grid_size = int(len(rooms) ** 0.5) + 1
            for i, room in enumerate(rooms):
                row = i // grid_size
                col = i % grid_size
                position = (offset_x + col, offset_y + row, offset_z)
                self._place_room(room, position)

    def _identify_conflicts(self):
        """Identify all positions with multiple rooms"""
        self.conflicts = [
            conflict
            for conflict in self.position_map.values()
            if conflict.has_conflict
        ]

    def get_conflict_report(self) -> List[Dict]:
        """
        Generate a detailed conflict report

        Returns:
            List of conflict details
        """
        report = []
        for conflict in self.conflicts:
            conflict_data = {
                "position": conflict.position,
                "room_count": len(conflict.rooms),
                "rooms": [],
            }

            for zone_id, room_id in conflict.rooms:
                room = self.graph.get_room(zone_id, room_id)
                if room:
                    conflict_data["rooms"].append(
                        {
                            "zone_id": zone_id,
                            "room_id": room_id,
                            "name": room.name,
                            "sector": room.sector,
                        }
                    )

            report.append(conflict_data)

        return report

    async def update_database(self, prisma_client) -> Dict:
        """
        Update the database with calculated layout positions
        Uses batching to avoid PostgreSQL stack depth errors

        Args:
            prisma_client: Connected Prisma client

        Returns:
            Dict with update statistics
        """
        if self.config.dry_run:
            return {
                "success": True,
                "dry_run": True,
                "would_update": self.placed_count,
            }

        # Collect all rooms to update
        rooms_to_update = [
            room for room in self.graph.rooms.values()
            if room.is_placed and room.position
        ]

        total_rooms = len(rooms_to_update)
        updated = 0
        errors = []

        # Process in batches of 100 to avoid stack depth issues
        BATCH_SIZE = 100

        print(f"Updating {total_rooms} rooms in batches of {BATCH_SIZE}...")

        for batch_start in range(0, total_rooms, BATCH_SIZE):
            batch_end = min(batch_start + BATCH_SIZE, total_rooms)
            batch = rooms_to_update[batch_start:batch_end]

            # Update this batch
            for room in batch:
                try:
                    await prisma_client.room.update(
                        where={
                            "zoneId_id": {
                                "zoneId": room.zone_id,
                                "id": room.room_id,
                            }
                        },
                        data={
                            "layoutX": room.position[0],
                            "layoutY": room.position[1],
                            "layoutZ": room.position[2],
                        },
                    )
                    updated += 1
                except Exception as e:
                    errors.append(
                        {
                            "room": (room.zone_id, room.room_id),
                            "error": str(e),
                        }
                    )

            # Progress reporting
            print(f"  Updated {batch_end}/{total_rooms} rooms ({(batch_end/total_rooms)*100:.1f}%)")

        print(f"✅ Finished: {updated} rooms updated, {len(errors)} errors")

        return {
            "success": True,
            "updated": updated,
            "errors": len(errors),
            "error_details": errors if errors else None,
        }
