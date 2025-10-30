# FieryLib Scripts

Helper scripts for database management and data import.

## Quick Start

### Full Reset and Import

The easiest way to reset everything and import all legacy data:

```bash
bash scripts/full_reset_and_import.sh --with-users
```

This will:
1. Generate Prisma enums from Python flags (if schema changed)
2. Reset and regenerate the database
3. Import all legacy CircleMUD data
4. Seed test users

### Test with a Single Zone

To quickly test the import process with one zone:

```bash
bash scripts/full_reset_and_import.sh --zone 100 --with-users
```

### Validate Without Importing

To check if your data would import correctly without changing the database:

```bash
bash scripts/full_reset_and_import.sh --dry-run --verbose
```

## Available Scripts

### `full_reset_and_import.sh`

**The main script** - performs a complete reset and import cycle.

```bash
bash scripts/full_reset_and_import.sh [options]
```

**Options:**
- `--skip-enum-generation` - Skip regenerating Prisma enums from Python (faster if schema unchanged)
- `--skip-import` - Only reset database, don't import data
- `--with-users` - Seed test users after import
- `--zone <number>` - Import only a specific zone (useful for testing)
- `--dry-run` - Parse and validate without importing to database
- `--verbose` - Show more detailed output during import
- `--debug` - Show full error messages for all failures

**Examples:**

```bash
# Full reset with all data and test users
bash scripts/full_reset_and_import.sh --with-users

# Quick test with zone 100
bash scripts/full_reset_and_import.sh --zone 100 --debug

# Reset database only (no import)
bash scripts/full_reset_and_import.sh --skip-import

# Skip enum generation if you know schema hasn't changed
bash scripts/full_reset_and_import.sh --skip-enum-generation
```

### `reset_db.sh`

Simpler script that only resets the database without importing data.

```bash
bash scripts/reset_db.sh [--skip-generate] [--seed]
```

**Options:**
- `--skip-generate` - Skip generating Prisma clients
- `--seed` - Seed test users after reset

### `generate_prisma_enums.py`

Python script that generates Prisma enum definitions from Python flag arrays.

```bash
poetry run python scripts/generate_prisma_enums.py
```

This reads flag definitions from `src/mud/flags.py` and updates the Prisma schema enums.
Run this whenever you modify flag definitions in Python.

## Workflow

### When You Update Flag Definitions

1. Edit `src/mud/flags.py` to add/modify flags
2. Run enum generator:
   ```bash
   poetry run python scripts/generate_prisma_enums.py
   ```
3. Reset and test:
   ```bash
   bash scripts/full_reset_and_import.sh --zone 100
   ```

### Daily Development

```bash
# Reset database and import everything
bash scripts/full_reset_and_import.sh --with-users
```

### Debugging Import Issues

```bash
# Test specific zone with full error output
bash scripts/full_reset_and_import.sh --zone 85 --debug --with-users
```

## Import Statistics

After a full import, you should see approximately:

- **Zones**: 133
- **Rooms**: 10,295
- **Mobs**: ~2,050+
- **Objects**: ~3,490
- **Shops**: (not yet implemented)

## Troubleshooting

### "Prisma migrate reset failed"

The script automatically falls back to `--skip-generate` mode. This is normal if custom generators are configured.

### Import failures

Use `--debug` to see full error messages:

```bash
bash scripts/full_reset_and_import.sh --zone 100 --debug
```

### Missing test users

Make sure to use `--with-users` flag:

```bash
bash scripts/full_reset_and_import.sh --with-users
```

Default test users:
- **Admin**: admin@muditor.dev / admin123 (GOD level)
- **Builder**: builder@muditor.dev / builder123 (BUILDER level)
- **Player**: player@muditor.dev / player123 (PLAYER level)
