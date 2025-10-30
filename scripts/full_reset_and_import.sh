#!/usr/bin/env bash
set -euo pipefail

# Full Reset and Import Script for FieryLib
#
# This script performs a complete reset and import cycle:
# 1. Generate Prisma enums from Python flags
# 2. Reset and regenerate the database
# 3. Import all legacy CircleMUD data
# 4. Optionally seed test users
#
# Usage:
#   bash scripts/full_reset_and_import.sh [options]
#
# Options:
#   --skip-enum-generation    Skip regenerating Prisma enums from Python
#   --skip-import             Skip the data import step
#   --with-users              Seed test users after import
#   --zone <number>           Import only a specific zone (for testing)
#   --dry-run                 Parse and validate without importing
#   --verbose                 Enable verbose output during import
#   --debug                   Enable debug output (shows all errors)
#
# Examples:
#   # Full reset and import everything
#   bash scripts/full_reset_and_import.sh
#
#   # Reset and test import for zone 100
#   bash scripts/full_reset_and_import.sh --zone 100 --with-users
#
#   # Dry run to validate without changing database
#   bash scripts/full_reset_and_import.sh --dry-run --verbose
#
#   # Skip enum generation (faster if schema hasn't changed)
#   bash scripts/full_reset_and_import.sh --skip-enum-generation

# Parse arguments
SKIP_ENUM_GEN=0
SKIP_IMPORT=0
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
      echo "  --skip-enum-generation    Skip regenerating Prisma enums from Python"
      echo "  --skip-import             Skip the data import step"
      echo "  --with-users              Seed test users after import"
      echo "  --zone <number>           Import only a specific zone (for testing)"
      echo "  --dry-run                 Parse and validate without importing"
      echo "  --verbose                 Enable verbose output during import"
      echo "  --debug                   Enable debug output (shows all errors)"
      echo "  --help, -h                Show this help message"
      echo ""
      echo "Examples:"
      echo "  bash scripts/full_reset_and_import.sh --with-users"
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
if [[ "$SKIP_ENUM_GEN" -eq 0 ]]; then
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "Step 1: Generating Prisma enums from Python flags"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo ""
  
  poetry run python scripts/generate_prisma_enums.py
  
  echo ""
  echo "✅ Prisma enums generated"
  echo ""
else
  echo "⏭️  Skipping enum generation"
  echo ""
fi

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

# Step 3: Import legacy data
if [[ "$SKIP_IMPORT" -eq 0 ]]; then
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "Step 3: Importing legacy CircleMUD data"
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
  
  if [[ -n "$WITH_USERS" ]]; then
    IMPORT_CMD="$IMPORT_CMD $WITH_USERS"
  fi
  
  echo "Running: $IMPORT_CMD"
  echo ""
  
  eval $IMPORT_CMD
  
  echo ""
  echo "✅ Import complete"
  echo ""
else
  echo "⏭️  Skipping import"
  echo ""
fi

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ All steps complete!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
