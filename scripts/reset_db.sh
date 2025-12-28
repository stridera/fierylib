#!/usr/bin/env bash
set -euo pipefail

# Simple DB reset helper for FieryLib (Poetry environment)
# Usage:
#   bash scripts/reset_db.sh [--skip-generate] [--seed] [--import]
#
# Options:
#   --skip-generate  Skip Prisma client generation during reset
#   --seed           Create test users after reset
#   --import         Import all legacy data (zones, rooms, mobs, objects, triggers, mail, boards)
#
# Notes:
# - Runs Prisma via Poetry environment so Python generator is available
# - Falls back automatically if generators fail during reset
# - Use --import for a complete fresh database with all legacy data

SKIP_GEN=0
SEED=0
IMPORT=0

for arg in "$@"; do
  case "$arg" in
    --skip-generate)
      SKIP_GEN=1
      shift
      ;;
    --seed)
      SEED=1
      shift
      ;;
    --import)
      IMPORT=1
      shift
      ;;
  esac
done

echo "[1/3] Resetting database..."
if [[ "$SKIP_GEN" -eq 1 ]]; then
  poetry run prisma migrate reset --force --skip-generate || true
else
  if ! poetry run prisma migrate reset --force; then
    echo "Falling back to --skip-generate + db push + generate..."
    poetry run prisma migrate reset --force --skip-generate || true
  fi
fi

echo "[2/3] Ensuring schema is applied..."
poetry run prisma db push

echo "[3/3] Generating Prisma clients (Python + JS)..."
poetry run prisma generate

echo "✅ Database reset complete."

if [[ "$IMPORT" -eq 1 ]]; then
  echo ""
  echo "[4/4] Importing legacy data..."
  if [[ "$SEED" -eq 1 ]]; then
    poetry run fierylib import-legacy --clear --with-users
  else
    poetry run fierylib import-legacy --clear
  fi
  echo "✅ Legacy data import complete."
elif [[ "$SEED" -eq 1 ]]; then
  echo "Seeding users..."
  poetry run fierylib seed users --reset
fi
