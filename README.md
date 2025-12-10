# FieryLib - One-Time Legacy Data Import Tool

Python tool to import legacy CircleMUD text files into PostgreSQL **once**. After initial import, this tool becomes obsolete.

## ⚠️ Important: One-Time Use

**FieryLib is a one-time import tool.** After you've seeded your database:
- ✅ Use **Muditor** for all ongoing world editing
- ✅ Muditor is the source of truth for the database schema
- ✅ FieryLib can be archived/ignored after initial setup

## Quick Start (One Time Only)

```bash
# Setup
cp .env.example .env
poetry install

# Initialize database schema and generate Python client
# (Schema is symlinked from Muditor - no syncing needed)
poetry run prisma db push
poetry run prisma generate

# Import everything (world data + test users)
poetry run fierylib import-legacy --with-users

# Generate layout coordinates (optional)
poetry run fierylib layout generate

# ✅ Done! Now use Muditor for all future work
```

## What It Does

1. **Imports Legacy World Files**
   - Zones (`.zon`), Rooms (`.wld`), Mobs (`.mob`), Objects (`.obj`), Shops (`.shp`)
   - Converts legacy IDs to composite keys: `3045` → `(zoneId: 30, vnum: 45)`
   - Normalizes flags: `NORENT` → `NO_RENT`

2. **Imports Legacy Characters (`.plr` files)**
   - Preserves original Unix crypt() password hashes
   - Authentication system validates both bcrypt and legacy crypt formats
   - Passwords migrated to bcrypt on first successful login
   - Preserves stats, skills, spells, inventory, and aliases

3. **Seeds Test Users**
   - Admin (`admin@muditor.dev` / `admin123`) - GOD level
   - Builder (`builder@muditor.dev` / `builder123`) - BUILDER level
   - Player (`player@muditor.dev` / `player123`) - PLAYER level

4. **Generates Layout Coordinates**
   - Auto-generates `(x, y, z)` for visual editor
   - Breadth-first traversal from starting room
   - Handles vertical connections (UP/DOWN)

## Commands

### Import Data

```bash
# Import all zones + seed users (recommended)
poetry run fierylib import-legacy --with-users

# Import all zones only
poetry run fierylib import-legacy

# Import specific zone
poetry run fierylib import-legacy --zone 30

# Dry run (validate without importing)
poetry run fierylib import-legacy --dry-run --verbose
```

### Seed Users

```bash
# Create test users
poetry run fierylib seed users

# Reset user passwords
poetry run fierylib seed users --reset
```

### Reset Database (drop and recreate)

```bash
# Drop all tables, re-apply schema, and run generators inside Poetry env
poetry run prisma migrate reset --force

# If you prefer no generation during reset (rarely needed here):
poetry run prisma migrate reset --force --skip-generate
poetry run prisma db push
poetry run prisma generate
```

### Generate Layout

```bash
# Generate coordinates for all rooms
poetry run fierylib layout generate

# Start from specific room
poetry run fierylib layout generate --start-zone 30 --start-vnum 1
```

## After Import

Once you've successfully imported your data:

1. **Verify Import**
   ```bash
   cd ../muditor
   pnpm db:studio    # Check data looks good
   ```

2. **Use Muditor for All Future Work**
   ```bash
   cd ../muditor
   pnpm dev          # Start editor
   # Navigate to http://localhost:3002
   ```

3. **Archive FieryLib** (optional)
   - FieryLib is no longer needed
   - Keep it around for reference or future re-imports
   - All ongoing editing happens in Muditor

## Schema Note

**Important**: Muditor's schema is the source of truth, not FieryLib's.

FieryLib's Prisma schema is a **symlink** to Muditor's schema:

```bash
# The schema automatically stays in sync via symlink
fierylib/prisma/schema.prisma -> ../../muditor/packages/db/prisma/schema.prisma
```

No manual syncing needed - changes to Muditor's schema are immediately reflected in FieryLib.

### Enum Generation

Prisma enums are auto-generated from Python source code (`src/mud/types/` and `src/mud/flags.py`):

```bash
# Regenerate enums from Python source of truth
poetry run python scripts/generate_prisma_enums.py

# This creates/updates prisma/enums.prisma
# Copy enum definitions to prisma/schema.prisma manually, then:
poetry run prisma generate
```

**Note**: The enum generation script writes to `prisma/enums.prisma`. You must manually update `prisma/schema.prisma` with the new enum definitions.

You rarely need to do this - FieryLib is used once and then forgotten.

### Prisma usage in this repo (Poetry-only)

- Always run Prisma via Poetry so the Python generator is available.
- Examples:
   - `poetry run prisma generate`
   - `poetry run prisma db push`
   - `poetry run prisma migrate reset --force`
- Avoid `npx prisma` in this repo; use it from Muditor only.

### Python keyword gotcha (already handled)

We renamed the Prisma model `Class` → `GameClass` and relation fields `class` → `gameClass` to avoid Python keyword conflicts in the Prisma Python client. The underlying table remains `classes` via `@@map("classes")`. If you reference this in Muditor or elsewhere, use `gameClass` in code.

## Architecture

```
        One-Time Setup                    Ongoing Use

Legacy lib/ files                    Developer
       ↓                                   ↓
  [FieryLib]                         [Muditor] ← Source of Truth
       ↓                                   ↓
   PostgreSQL ←───────────────────────────┘
       ↓
  [FieryMUD] ← Game Server
       ↓
    Players
```

## Features

### Composite Primary Keys
- Legacy: `3045` (single integer)
- Modern: `(zoneId: 30, vnum: 45)` (composite)
- Benefits: 2-3x faster lookups, natural zone grouping

### ID Conversion
- Zone 0 → Zone 1000 (special case)
- Zone 30 rooms (3000-3099) → `(zoneId: 30, vnum: 0-99)`
- Zone 45 mobs (4500-4599) → `(zoneId: 45, vnum: 0-99)`

### Flag Normalization
- `NORENT`, `!RENT`, `NO-RENT` → `NO_RENT` (consistent enum)

## Dependencies

- **prisma** (0.11+) - Python Prisma client
- **click** (8.1+) - CLI framework
- **psycopg2-binary** (2.9+) - PostgreSQL adapter
- **bcrypt** (4.1+) - Password hashing
- **python-dotenv** (1.0+) - Environment variables

## Environment Variables

```env
DATABASE_URL="postgresql://muditor:password@localhost:5432/fierydev"
LEGACY_LIB_PATH="../lib"
LOG_LEVEL="INFO"
```

## Troubleshooting

### Connection Refused

Ensure PostgreSQL is running (from parent directory):
```bash
cd ..  # Navigate to parent directory containing docker-compose.yml
docker compose up -d
docker compose ps
```

### Schema Mismatch

Since the schema is symlinked to Muditor, just regenerate the Prisma client:
```bash
# From the fierylib directory
poetry run prisma generate
```

If you need to update the schema itself, edit it in Muditor:
```bash
# Edit schema in Muditor's packages/db/prisma/schema.prisma
# Changes are automatically reflected in FieryLib via symlink
cd ../muditor
pnpm db:generate
```

### Import Errors

Check legacy files exist:
```bash
ls -la ../lib/world/wld/
ls -la ../lib/world/mob/
```

## See Also

- [Muditor README](https://github.com/stridera/muditor) - Main Muditor documentation and setup guide
- [Schema Management](https://github.com/stridera/muditor/blob/main/packages/db/SCHEMA_NOTE.md) - Database schema management details
- [Database Package](https://github.com/stridera/muditor/blob/main/packages/db/README.md) - Prisma client and database utilities

## Summary

**FieryLib is a one-time import tool.** Use it to seed your database, then:
- ✅ Use Muditor for ongoing editing
- ✅ Muditor manages the database schema
- ✅ FieryLib can be archived after import

**You're done with FieryLib once the database is seeded!** 🎉
