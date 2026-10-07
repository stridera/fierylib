-- PlayerFlag EXPAND_MOBS / EXPAND_OBJS (Refs #51): legacy PRF_EXPAND_MOBS /
-- PRF_EXPAND_OBJS. When set, identical mobs / objects in room, inventory and
-- container listings are shown one per line instead of stacked "(x3)".
-- Legacy default is OFF (stacking on), so no backfill is needed.
--
-- ALTER TYPE ... ADD VALUE cannot run inside a transaction block, so there is
-- no BEGIN/COMMIT here. IF NOT EXISTS makes it idempotent.
-- Apply: psql -v ON_ERROR_STOP=1 -U strider -d fierydev -f 2026-10-07-expand-flags.sql

ALTER TYPE "PlayerFlag" ADD VALUE IF NOT EXISTS 'EXPAND_MOBS';
ALTER TYPE "PlayerFlag" ADD VALUE IF NOT EXISTS 'EXPAND_OBJS';
