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

        print("Finding connected components...")

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

        # Find all connected components
        unplaced_rooms = set(graph.rooms.keys())
        components = []
        component_num = 0

        while unplaced_rooms:
            # Pick any unplaced room as starting point
            start_key = next(iter(unplaced_rooms))
            start_room = self.graph.get_room(*start_key)

            if not start_room:
                unplaced_rooms.remove(start_key)
                continue

            # Find all rooms reachable from this start room
            connected = self._find_connected_rooms(start_room)
            unplaced_rooms -= connected

            components.append({
                'start_key': start_key,
                'size': len(connected),
                'rooms': connected
            })
            component_num += 1

            if component_num <= 5 or len(connected) > 100:
                print(f"  Component {component_num}: {len(connected)} rooms (Zone {start_key[0]}, ID {start_key[1]})")

        # Sort components by size (largest first)
        components.sort(key=lambda x: x['size'], reverse=True)

        print(f"Found {len(components)} connected components")
        print(f"Largest component: {components[0]['size']} rooms")

        # Place main component first at origin
        main_comp = components[0]
        start_room = self.graph.get_room(*main_comp['start_key'])
        position = self.config.start_position
        print(f"Placing main component ({main_comp['size']} rooms) at position {position}")
        
        # Place starting room
        self._place_room(start_room, position)
        
        # Place all rooms in main component using BFS
        self._bfs_placement_bidirectional(start_room)
        
        # For smaller components, treat them like isolated room clusters
        # Group them by zone and place near zone centers intelligently
        if len(components) > 1:
            print(f"\nPlacing {len(components) - 1} smaller disconnected components...")
            
            # Group smaller components by zone
            components_by_zone: Dict[int, List[Dict]] = defaultdict(list)
            for comp in components[1:]:
                zone_id = comp['start_key'][0]
                components_by_zone[zone_id].append(comp)
            
            # Calculate zone centers from placed rooms
            zone_centers = self._calculate_zone_centers()
            
            # Place each zone's disconnected components
            for zone_id, zone_comps in components_by_zone.items():
                center = zone_centers.get(zone_id, (0, 0, 0))
                print(f"  Zone {zone_id}: {len(zone_comps)} disconnected components, center at {center}")
                
                # Collect all rooms from these components
                comp_rooms = []
                for comp in zone_comps:
                    for room_key in comp['rooms']:
                        room = self.graph.get_room(*room_key)
                        if room and not room.is_placed:
                            comp_rooms.append(room)
                
                # Place using smart clustering (tries to match by name)
                if comp_rooms:
                    self._place_disconnected_components(comp_rooms, center, zone_id)

        # Handle truly isolated rooms (no connections at all)
        self._place_isolated_rooms()

        # Identify conflicts
        self._identify_conflicts()

        return {
            "success": True,
            "total_rooms": len(self.graph),
            "placed": self.placed_count,
            "skipped": self.skipped_count,
            "isolated": len(self.graph.isolated_rooms),
            "conflicts": len(self.conflicts),
            "zones": len(self.graph.zones),
            "components": len(components),
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

        while queue:
            current_room = queue.popleft()

            if not current_room.position:
                continue

            # Process exits FROM current room
            for direction, dest_key in current_room.exits.items():
                dest_room = self.graph.get_room(*dest_key)
                if not dest_room or dest_room.is_placed:
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
            # Skip cross-zone reverse exits to prioritize same-zone placement
            if current_room.room_key in self.reverse_exits:
                for source_key in self.reverse_exits[current_room.room_key]:
                    source_room = self.graph.get_room(*source_key)
                    if not source_room or source_room.is_placed:
                        continue

                    # Skip cross-zone reverse placements to prioritize natural same-zone flow
                    if source_room.zone_id != current_room.zone_id:
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
        Place disconnected component rooms intelligently - either near related rooms
        or grouped compactly above zone center
        
        Args:
            rooms: List of rooms from disconnected components
            center: Zone center position (fallback)
            zone_id: Zone ID for these rooms
        """
        # Try to place each room near a related room first
        unplaced = []
        
        for room in rooms:
            related_pos = self._find_related_room(room, zone_id)
            if related_pos:
                # Found a related room, place nearby
                if self.config.verbose:
                    print(f"    Placing '{room.name}' near related room at {related_pos}")
                self._place_room(room, related_pos)
            else:
                # No match found, will place in cluster
                unplaced.append(room)
        
        # Place remaining unplaced rooms in a compact cluster directly above zone center
        if unplaced:
            # Place directly above center (z+1) to keep map compact
            offset_x = center[0]
            offset_y = center[1]
            offset_z = center[2] + 1
            
            if self.config.verbose:
                print(f"    Placing {len(unplaced)} unmatched rooms at ({offset_x}, {offset_y}, {offset_z}) [+1 Z from center]")
            
            # Simple grid placement - compact and directly above
            grid_size = int(len(unplaced) ** 0.5) + 1
            for i, room in enumerate(unplaced):
                row = i // grid_size
                col = i % grid_size
                position = (offset_x + col, offset_y + row, offset_z)
                self._place_room(room, position)

    def _place_room_cluster_smart(
        self, rooms: List[RoomNode], center: Tuple[int, int, int], zone_id: int
    ):
        """
        Intelligently place a cluster of rooms, attempting to place them near related rooms
        
        Args:
            rooms: List of rooms to place
            center: Center position to cluster around (fallback)
            zone_id: Zone ID for these rooms
        """
        # Try to place each room near a related room first
        unplaced = []
        
        for room in rooms:
            related_pos = self._find_related_room(room, zone_id)
            if related_pos:
                # Found a related room, place nearby
                if self.config.verbose:
                    print(f"    Placing '{room.name}' near related room at {related_pos}")
                self._place_room(room, related_pos)
            else:
                # No match found, will place in cluster
                unplaced.append(room)
        
        # Place remaining unplaced rooms in a compact cluster directly above zone center
        if unplaced:
            # Place directly above center (z+1) to keep map compact
            offset_x = center[0]
            offset_y = center[1]
            offset_z = center[2] + 1
            
            if self.config.verbose:
                print(f"    Placing {len(unplaced)} unmatched rooms at ({offset_x}, {offset_y}, {offset_z}) [+1 Z from center]")
            
            # Simple grid placement - compact and directly above
            grid_size = int(len(unplaced) ** 0.5) + 1
            for i, room in enumerate(unplaced):
                row = i // grid_size
                col = i % grid_size
                position = (offset_x + col, offset_y + row, offset_z)
                self._place_room(room, position)

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
