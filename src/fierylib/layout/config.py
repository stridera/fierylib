"""
Layout Configuration
"""

from dataclasses import dataclass, field
from typing import Tuple, Dict, Optional


@dataclass
class LayoutConfig:
    """Configuration for the auto-layout algorithm"""

    # Starting point
    start_room_zone: int = 30  # Zone 30
    start_room_id: int = 1  # Room ID 1
    start_position: Tuple[int, int, int] = (0, 0, 0)

    # Direction mappings to coordinate changes
    # Using standard cardinal directions: North is +Y, East is +X
    direction_vectors: Optional[Dict[str, Tuple[int, int, int]]] = None

    # Conflict handling
    allow_overlaps: bool = True  # Mark overlaps but don't prevent them
    track_conflicts: bool = True  # Keep list of conflicting positions

    # Zone management
    zone_spacing: int = 50  # Minimum spacing between zones (for future use)
    group_by_sector: bool = True  # Group rooms by sector when possible

    # Algorithm options
    placement_order: str = "bfs"  # "bfs" or "dfs"

    # Database
    update_database: bool = True  # Actually write layoutX/Y/Z to DB
    dry_run: bool = False  # If True, don't update database

    # Logging
    verbose: bool = False  # Show detailed placement information

    def __post_init__(self):
        """Set default direction vectors if not provided"""
        if self.direction_vectors is None:
            self.direction_vectors = {
                "NORTH": (0, 1, 0),
                "SOUTH": (0, -1, 0),
                "EAST": (1, 0, 0),
                "WEST": (-1, 0, 0),
                "UP": (0, 0, 1),
                "DOWN": (0, 0, -1),
            }
