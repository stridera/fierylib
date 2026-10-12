-- Internal zones (data-over-code).
--
-- fierymud-rs kept INTERNAL_ZONE_IDS = [0, 1, 2] as a hard-coded list: zone 0 is the Void (the
-- fallback room), zone 1 is "Reserved - create food items" and zone 2 is "non-loading items
-- zone". They carry no explorable content, so they grant no exploration credit and stay out of
-- the zone listings. The flag now lives in "Zones".is_internal (Muditor zone editor, HEAD_BUILDER+);
-- the game falls back to the same three ids when the column is missing.
--
-- This patch:
--   * adds "Zones".is_internal (additive; DDL matches Prisma's `isInternal Boolean
--     @default(false) @map("is_internal")`, so `prisma db push` is then a no-op);
--   * flags the zones with id 0, 1 and 2 (Zones.id is the legacy zone number unchanged; zone 0
--     is not remapped, and the dev database has Zones rows 0, 1 and 2 under those ids).
--
-- Idempotent and one-way: only rows still false are touched, so a rerun changes 0 rows. The
-- NOTICE line reports the rows flagged (0 on a rerun). Mirrored by ZoneImporter.mark_internal_zones
-- (a unit test keeps the two in sync).

BEGIN;

ALTER TABLE "Zones" ADD COLUMN IF NOT EXISTS is_internal BOOLEAN NOT NULL DEFAULT false;

DO $$
DECLARE
  n_flagged integer;
BEGIN
  UPDATE "Zones"
  SET is_internal = true, updated_at = now()
  WHERE id IN (0, 1, 2) AND is_internal = false;
  GET DIAGNOSTICS n_flagged = ROW_COUNT;
  RAISE NOTICE 'zone-internal-flag patch: Zones rows flagged is_internal: %', n_flagged;
END $$;

COMMIT;
