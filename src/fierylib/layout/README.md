# Layout Tool

Auto-generates 3D coordinates (x, y, z) for MUD rooms based on their directional connections.

## Features

- **BFS-based placement**: Places rooms starting from a configurable starting room
- **Direction mapping**: N/S/E/W/U/D → coordinate changes
- **Conflict detection**: Identifies overlapping room positions
- **Isolated room handling**: Groups unconnected rooms by zone and sector
- **Database integration**: Updates `layoutX`, `layoutY`, `layoutZ` fields

## Usage

### Command Line

Generate layout for all rooms:
```bash
fierylib layout generate
```

Options:
- `--start-zone INT`: Starting zone ID (default: 30)
- `--start-vnum INT`: Starting room vnum (default: 1)
- `--dry-run`: Calculate without updating database
- `--show-conflicts`: Display detailed conflict report
- `--group-by-sector/--no-group-by-sector`: Group isolated rooms by sector type

Examples:
```bash
# Dry run to see results without updating
fierylib layout generate --dry-run --show-conflicts

# Generate layout starting from zone 31, room 3101
fierylib layout generate --start-zone 31 --start-vnum 1

# Generate and update database
fierylib layout generate
```

### Python API

```python
from prisma import Prisma
from fierylib.layout import LayoutConfig, LayoutEngine
from fierylib.layout.graph_builder import load_room_graph

async def generate_layout():
    prisma = Prisma()
    await prisma.connect()
    
    # Load rooms
    graph = await load_room_graph(prisma)
    
    # Configure
    config = LayoutConfig(
        start_room_zone=30,
        start_room_vnum=1,
        group_by_sector=True,
    )
    
    # Generate
    engine = LayoutEngine(config)
    result = engine.generate_layout(graph)
    
    # Update database
    await engine.update_database(prisma)
    
    await prisma.disconnect()
```

## Algorithm

1. **Graph Building**: Load all rooms and exits from database
2. **BFS Placement**: Starting from the specified room, traverse the graph using Breadth-First Search
3. **Position Calculation**: Apply direction vectors:
   - NORTH: (0, +1, 0)
   - SOUTH: (0, -1, 0)
   - EAST: (+1, 0, 0)
   - WEST: (-1, 0, 0)
   - UP: (0, 0, +1)
   - DOWN: (0, 0, -1)
4. **Conflict Detection**: Mark positions where multiple rooms overlap
5. **Isolated Rooms**: Place unconnected rooms in clusters by zone and sector
6. **Database Update**: Write layoutX/Y/Z coordinates back to database

## Handling Conflicts

Conflicts occur when multiple rooms want the same position. This happens due to:
- **Loops**: Rooms that circle back (e.g., A→B→C→A)
- **Inconsistent exits**: Room A says "north to B", but B doesn't say "south to A"
- **Zone boundaries**: Different layout expectations across zones

The tool marks but allows conflicts. View them with `--show-conflicts`, then manually adjust in your editor (muditor).

## Configuration

Edit `src/fierylib/layout/config.py` to change:
- Starting position coordinates
- Direction vector mappings
- Zone spacing
- Grouping behavior

## Future Enhancements

Potential improvements:
- Force-directed layout for conflict resolution
- Manual room pinning
- Zone-level layout strategies
- Export to various visualization formats
- Pathfinding-based inter-zone connections
