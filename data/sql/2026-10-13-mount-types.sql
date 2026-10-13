-- Summon-mount tiers (data-over-code).
--
-- fierymud-rs kept the legacy `mount_types` table (act.other.cpp) hard-coded in the summonmount
-- command: four tiers per alignment side (Paladin = good, Anti-Paladin = evil), each with a level
-- and alignment gate, a mount mob prototype (zone 0 ids 45-52) and HP / movement bonuses. It now
-- lives in "MountType"; the game falls back to the same built-in table when the table or its rows
-- are missing, so behaviour is identical either way.
--
-- This patch:
--   * creates "MountType" if missing (DDL matches what Prisma's `db push` creates);
--   * seeds the current tiers, never overwriting a row that already exists for a (tier, side)
--     (edits made in Muditor win) and skipping a tier whose mount mob is not imported (the FK
--     would reject it; the game then uses its built-in table).
--
-- tier 1 is each side's base mount (always applies); min_alignment is a magnitude (an evil
-- summoner needs alignment <= -min_alignment).
--
-- Idempotent: rerunning changes nothing.

BEGIN;

CREATE TABLE IF NOT EXISTS "MountType" (
    "id" SERIAL NOT NULL,
    "tier" INTEGER NOT NULL,
    "alignment_side" TEXT NOT NULL,
    "min_level" INTEGER NOT NULL DEFAULT 0,
    "min_alignment" INTEGER NOT NULL DEFAULT 0,
    "mob_zone_id" INTEGER NOT NULL,
    "mob_id" INTEGER NOT NULL,
    "hp_bonus" INTEGER NOT NULL DEFAULT 0,
    "mv_bonus" INTEGER NOT NULL DEFAULT 0,

    CONSTRAINT "MountType_pkey" PRIMARY KEY ("id")
);

CREATE UNIQUE INDEX IF NOT EXISTS "MountType_tier_alignment_side_key" ON "MountType"("tier", "alignment_side");

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_constraint WHERE conname = 'MountType_mob_zone_id_mob_id_fkey'
    ) THEN
        ALTER TABLE "MountType"
            ADD CONSTRAINT "MountType_mob_zone_id_mob_id_fkey"
            FOREIGN KEY ("mob_zone_id", "mob_id") REFERENCES "Mobs"("zone_id", "id")
            ON DELETE RESTRICT ON UPDATE CASCADE;
    END IF;
END
$$;

INSERT INTO "MountType"
    ("tier", "alignment_side", "min_level", "min_alignment", "mob_zone_id", "mob_id", "hp_bonus", "mv_bonus")
SELECT v."tier", v."alignment_side", v."min_level", v."min_alignment", v."mob_zone_id", v."mob_id",
       v."hp_bonus", v."mv_bonus"
FROM (VALUES
    (1, 'good', 0, 0, 0, 48, 0, 0),
    (1, 'evil', 0, 0, 0, 47, 0, 0),
    (2, 'good', 30, 700, 0, 49, 0, 0),
    (2, 'evil', 30, 700, 0, 50, 0, 0),
    (3, 'good', 60, 900, 0, 45, 50, 50),
    (3, 'evil', 60, 900, 0, 46, 50, 50),
    (4, 'good', 90, 1000, 0, 51, 100, 100),
    (4, 'evil', 90, 1000, 0, 52, 100, 100)
) AS v("tier", "alignment_side", "min_level", "min_alignment", "mob_zone_id", "mob_id", "hp_bonus", "mv_bonus")
WHERE EXISTS (
    SELECT 1 FROM "Mobs" m WHERE m."zone_id" = v."mob_zone_id" AND m."id" = v."mob_id"
)
ON CONFLICT ("tier", "alignment_side") DO NOTHING;

COMMIT;
