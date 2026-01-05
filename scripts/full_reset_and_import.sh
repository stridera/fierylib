#!/usr/bin/env bash
set -euo pipefail

# Full Reset and Import Script for FieryLib
#
# This script performs a complete reset and import cycle:
# 1. Reset and regenerate the database
# 2. Seed skills, spells, classes, races, and abilities
# 3. Seed parameterized effects (damage, heal, stat_mod, etc.)
# 4. Link abilities to their effects (AbilityEffect records)
# 5. Import all legacy CircleMUD world data
# 6. Generate room layout coordinates
# 7. Import legacy player/character files
# 8. Optionally seed test users
#
# Usage:
#   bash scripts/full_reset_and_import.sh [options]
#
# Options:
#   --skip-enum-generation    Skip regenerating Prisma enums from Python (DEPRECATED)
#   --skip-import             Skip the data import step
#   --skip-layout             Skip the layout generation step
#   --skip-players            Skip the player import step
#   --with-players            Import legacy player/character files
#   --with-users              Seed test users after import
#   --zone <number>           Import only a specific zone (for testing)
#   --dry-run                 Parse and validate without importing
#   --verbose                 Enable verbose output during import
#   --debug                   Enable debug output (shows all errors)
#
# Examples:
#   # Full reset and import everything (world + layout + players + users)
#   bash scripts/full_reset_and_import.sh --with-players --with-users
#
#   # Reset and test import for zone 100
#   bash scripts/full_reset_and_import.sh --zone 100 --with-users
#
#   # Dry run to validate without changing database
#   bash scripts/full_reset_and_import.sh --dry-run --verbose
#
#   # Import world data only (no layout, no players)
#   bash scripts/full_reset_and_import.sh --skip-layout --skip-players

# Parse arguments
SKIP_ENUM_GEN=0
SKIP_IMPORT=0
SKIP_LAYOUT=0
SKIP_PLAYERS=0
WITH_PLAYERS=""
WITH_USERS=""
ZONE_ARG=""
DRY_RUN=""
VERBOSE=""
DEBUG=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --help|-h)
      echo "Usage: bash scripts/full_reset_and_import.sh [options]"
      echo ""
      echo "Options:"
      echo "  --skip-enum-generation    Skip regenerating Prisma enums from Python (DEPRECATED)"
      echo "  --skip-import             Skip the data import step"
      echo "  --skip-layout             Skip the layout generation step"
      echo "  --skip-players            Skip the player import step"
      echo "  --with-players            Import legacy player/character files"
      echo "  --with-users              Seed test users after import"
      echo "  --zone <number>           Import only a specific zone (for testing)"
      echo "  --dry-run                 Parse and validate without importing"
      echo "  --verbose                 Enable verbose output during import"
      echo "  --debug                   Enable debug output (shows all errors)"
      echo "  --help, -h                Show this help message"
      echo ""
      echo "Examples:"
      echo "  bash scripts/full_reset_and_import.sh --with-players --with-users"
      echo "  bash scripts/full_reset_and_import.sh --zone 100 --debug"
      exit 0
      ;;
    --skip-enum-generation)
      SKIP_ENUM_GEN=1
      shift
      ;;
    --skip-import)
      SKIP_IMPORT=1
      shift
      ;;
    --skip-layout)
      SKIP_LAYOUT=1
      shift
      ;;
    --skip-players)
      SKIP_PLAYERS=1
      shift
      ;;
    --with-players)
      WITH_PLAYERS="--with-players"
      shift
      ;;
    --with-users)
      WITH_USERS="--with-users"
      shift
      ;;
    --zone)
      ZONE_ARG="--zone $2"
      shift 2
      ;;
    --dry-run)
      DRY_RUN="--dry-run"
      shift
      ;;
    --verbose)
      VERBOSE="--verbose"
      shift
      ;;
    --debug)
      DEBUG="--debug"
      shift
      ;;
    *)
      echo "Unknown option: $1"
      echo "Use --help to see available options"
      exit 1
      ;;
  esac
done

echo "╔════════════════════════════════════════════════════════════════╗"
echo "║    FieryLib Full Reset and Import                             ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""

# Step 1: Generate Prisma enums from Python flags
# LEGACY: Enums are now maintained directly in schema.prisma
# if [[ "$SKIP_ENUM_GEN" -eq 0 ]]; then
#   echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
#   echo "Step 1: Generating Prisma enums from Python flags"
#   echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
#   echo ""
#   
#   poetry run python scripts/generate_prisma_enums.py
#   
#   echo ""
#   echo "✅ Prisma enums generated"
#   echo ""
# else
#   echo "⏭️  Skipping enum generation"
#   echo ""
# fi

# Step 2: Reset database
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Step 2: Resetting database"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

echo "[2.1] Resetting database..."
if ! poetry run prisma migrate reset --force; then
  echo "⚠️  Migrate reset failed, falling back to skip-generate mode..."
  poetry run prisma migrate reset --force --skip-generate || true
fi

echo ""
echo "[2.2] Ensuring schema is applied..."
poetry run prisma db push

echo ""
echo "[2.3] Generating Prisma clients (Python + JS)..."
poetry run prisma generate

echo ""
echo "✅ Database reset complete"
echo ""

# Step 3: Seed skills, spells, classes, races, and abilities
if [[ "$SKIP_IMPORT" -eq 0 ]] && [[ -z "$DRY_RUN" ]]; then
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "Step 3: Seeding skills, spells, classes, races, and abilities"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo ""

  echo "[3.1] Seeding spells and skills..."
  poetry run python -c "
import asyncio
from prisma import Prisma
from fierylib.seeders.skill_seeder import SkillSeeder

async def seed():
    prisma = Prisma()
    await prisma.connect()
    seeder = SkillSeeder(prisma)
    await seeder.seed_spells()
    await seeder.seed_skills()
    await prisma.disconnect()

asyncio.run(seed())
"

  echo ""
  echo "[3.2] Importing class data..."
  poetry run python -c "
import asyncio
from pathlib import Path
from prisma import Prisma
from fierylib.importers.class_importer_v2 import ClassImporterV2

async def import_classes():
    prisma = Prisma()
    await prisma.connect()
    importer = ClassImporterV2(prisma)
    await importer.import_from_json(Path('data/classes.json'))
    await prisma.disconnect()

asyncio.run(import_classes())
"

  echo ""
  echo "[3.3] Importing race data..."
  poetry run fierylib seed races

  echo ""
  echo "[3.3.5] Seeding liquid types..."
  poetry run fierylib seed liquids

  echo ""
  echo "[3.4] Seeding parameterized effects..."
  EFFECTS_CMD="poetry run fierylib seed effects"

  if [[ -n "$VERBOSE" ]]; then
    EFFECTS_CMD="$EFFECTS_CMD --verbose"
  fi

  eval $EFFECTS_CMD

  echo ""
  echo "[3.5] Importing abilities with full metadata (sphere, damageType, etc.)..."
  MAGIC_CMD="poetry run fierylib seed magic-system"

  if [[ -n "$VERBOSE" ]]; then
    MAGIC_CMD="$MAGIC_CMD --verbose"
  fi

  eval $MAGIC_CMD

  echo ""
  echo "[3.6] Linking abilities to effects..."
  LINK_CMD="poetry run fierylib seed ability-effects"

  if [[ -n "$VERBOSE" ]]; then
    LINK_CMD="$LINK_CMD --verbose"
  fi

  eval $LINK_CMD

  echo ""
  echo "[3.7] Importing social commands..."
  SOCIALS_CMD="poetry run fierylib seed socials --clear"

  if [[ -n "$VERBOSE" ]]; then
    SOCIALS_CMD="$SOCIALS_CMD --verbose"
  fi

  eval $SOCIALS_CMD

  echo ""
  echo "✅ Skills, spells, classes, races, effects, ability links, ability metadata, and socials seeded"
  echo ""
else
  if [[ -n "$DRY_RUN" ]]; then
    echo "⏭️  Skipping skills/spells/classes/races/effects seeding (dry-run mode)"
  else
    echo "⏭️  Skipping skills/spells/classes/races/effects seeding (world import skipped)"
  fi
  echo ""
fi

# Step 4: Import legacy world data
if [[ "$SKIP_IMPORT" -eq 0 ]]; then
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "Step 4: Importing legacy CircleMUD world data"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo ""

  # Build the command with optional arguments
  IMPORT_CMD="poetry run fierylib import-legacy"

  if [[ -n "$ZONE_ARG" ]]; then
    IMPORT_CMD="$IMPORT_CMD $ZONE_ARG"
  fi

  if [[ -n "$DRY_RUN" ]]; then
    IMPORT_CMD="$IMPORT_CMD $DRY_RUN"
  fi

  if [[ -n "$VERBOSE" ]]; then
    IMPORT_CMD="$IMPORT_CMD $VERBOSE"
  fi

  if [[ -n "$DEBUG" ]]; then
    IMPORT_CMD="$IMPORT_CMD $DEBUG"
  fi

  echo "Running: $IMPORT_CMD"
  echo ""

  eval $IMPORT_CMD

  echo ""
  echo "✅ World data import complete"
  echo ""
else
  echo "⏭️  Skipping world import"
  echo ""
fi

# Step 5: Generate room layout
if [[ "$SKIP_LAYOUT" -eq 0 ]] && [[ "$SKIP_IMPORT" -eq 0 ]] && [[ -z "$DRY_RUN" ]]; then
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "Step 5: Generating room layout coordinates"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo ""

  LAYOUT_CMD="poetry run fierylib layout generate"

  if [[ -n "$VERBOSE" ]]; then
    LAYOUT_CMD="$LAYOUT_CMD --verbose"
  fi

  echo "Running: $LAYOUT_CMD"
  echo ""

  eval $LAYOUT_CMD

  echo ""
  echo "✅ Layout generation complete"
  echo ""
else
  if [[ "$SKIP_LAYOUT" -eq 1 ]]; then
    echo "⏭️  Skipping layout generation (--skip-layout)"
  elif [[ -n "$DRY_RUN" ]]; then
    echo "⏭️  Skipping layout generation (dry-run mode)"
  else
    echo "⏭️  Skipping layout generation (world import was skipped)"
  fi
  echo ""
fi

# Step 6: Import legacy players/characters
if [[ "$SKIP_PLAYERS" -eq 0 ]] && [[ -n "$WITH_PLAYERS" ]] && [[ -z "$DRY_RUN" ]]; then
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "Step 6: Importing legacy player/character files"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo ""

  PLAYER_CMD="poetry run fierylib import-players"

  if [[ -n "$VERBOSE" ]]; then
    PLAYER_CMD="$PLAYER_CMD --verbose"
  fi

  echo "Running: $PLAYER_CMD"
  echo ""

  eval $PLAYER_CMD

  echo ""
  echo "✅ Player import complete"
  echo ""
else
  if [[ "$SKIP_PLAYERS" -eq 1 ]]; then
    echo "⏭️  Skipping player import (--skip-players)"
  elif [[ -z "$WITH_PLAYERS" ]]; then
    echo "⏭️  Skipping player import (use --with-players to enable)"
  elif [[ -n "$DRY_RUN" ]]; then
    echo "⏭️  Skipping player import (dry-run mode)"
  fi
  echo ""
fi

# Step 7: Seed test users
if [[ -n "$WITH_USERS" ]] && [[ -z "$DRY_RUN" ]]; then
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "Step 7: Seeding test users"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo ""

  poetry run fierylib seed users

  echo ""
  echo "✅ Test users seeded"
  echo ""
else
  if [[ -z "$WITH_USERS" ]]; then
    echo "⏭️  Skipping test user seeding (use --with-users to enable)"
  elif [[ -n "$DRY_RUN" ]]; then
    echo "⏭️  Skipping test user seeding (dry-run mode)"
  fi
  echo ""
fi

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ All steps complete!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
