-- DB-backed player corpses (fierymud-rs; replaces state/corpses.json).
--
-- A dead player's gear and coins now live in the database: a PlayerCorpses
-- row (room, copper coins, decay deadline) plus the dead player's
-- CharacterItems rows tagged with corpse_id (character_id stays the owner,
-- container_id nesting is preserved). Looting clears corpse_id as the item
-- moves into the looter's inventory; decay deletes the PlayerCorpses row,
-- which cascades to its items.
--
-- Matches the Prisma schema (muditor packages/db/prisma/schema.prisma) and the
-- constraint / index names Prisma generates. Idempotent: safe to run twice.
-- After applying, restart fieryNT (sqlx prepared-statement cache).

BEGIN;

CREATE TABLE IF NOT EXISTS "PlayerCorpses" (
    "id" SERIAL NOT NULL,
    "owner_id" TEXT NOT NULL,
    "room_zone_id" INTEGER NOT NULL,
    "room_id" INTEGER NOT NULL,
    "coins" BIGINT NOT NULL DEFAULT 0,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "decay_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "PlayerCorpses_pkey" PRIMARY KEY ("id")
);

ALTER TABLE "CharacterItems" ADD COLUMN IF NOT EXISTS "corpse_id" INTEGER;

CREATE INDEX IF NOT EXISTS "PlayerCorpses_owner_id_idx" ON "PlayerCorpses"("owner_id");
CREATE INDEX IF NOT EXISTS "PlayerCorpses_decay_at_idx" ON "PlayerCorpses"("decay_at");
CREATE INDEX IF NOT EXISTS "CharacterItems_corpse_id_idx" ON "CharacterItems"("corpse_id");

DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'PlayerCorpses_owner_id_fkey') THEN
    ALTER TABLE "PlayerCorpses"
      ADD CONSTRAINT "PlayerCorpses_owner_id_fkey"
      FOREIGN KEY ("owner_id") REFERENCES "Characters"("id") ON DELETE CASCADE ON UPDATE CASCADE;
  END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'CharacterItems_corpse_id_fkey') THEN
    ALTER TABLE "CharacterItems"
      ADD CONSTRAINT "CharacterItems_corpse_id_fkey"
      FOREIGN KEY ("corpse_id") REFERENCES "PlayerCorpses"("id") ON DELETE CASCADE ON UPDATE CASCADE;
  END IF;
END $$;

-- Environment-neutral ownership: objects created by a superuser (e.g. postgres on
-- prod) must belong to the same role as the existing tables, or Prisma gets
-- "permission denied". Dev owner is strider, prod is fierynext.
DO $$
DECLARE
  tbl_owner text;
BEGIN
  SELECT tableowner INTO tbl_owner FROM pg_tables WHERE tablename = 'Characters' LIMIT 1;
  IF tbl_owner IS NOT NULL THEN
    EXECUTE format('ALTER TABLE "PlayerCorpses" OWNER TO %I', tbl_owner);
    EXECUTE format('ALTER SEQUENCE "PlayerCorpses_id_seq" OWNER TO %I', tbl_owner);
  END IF;
END $$;

COMMIT;

-- Report: expect 0 corpses right after applying.
SELECT count(*) AS player_corpses FROM "PlayerCorpses";
