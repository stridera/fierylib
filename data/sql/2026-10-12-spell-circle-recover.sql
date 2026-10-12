-- Spell-slot recovery time per circle (data-over-code).
--
-- fierymud-rs kept CIRCLE_RECOVER_TIME (legacy spell_mem.cpp circle_recover_time[]) as a
-- hard-coded array. The base seconds a spent slot takes to recover now live in
-- "SpellCircle" (circle -> recover_secs); the game falls back to the same built-in value when a
-- row or its time is missing, so behaviour is identical either way. Circle 14 is extrapolated
-- (the legacy table stops at 12 entries).
--
-- This patch:
--   * creates "SpellCircle" if missing (DDL matches what Prisma's `db push` creates);
--   * seeds circles 1-14, filling only missing rows and NULL times (a time edited in Muditor
--     wins).
--
-- Idempotent: rerunning changes nothing.

BEGIN;

CREATE TABLE IF NOT EXISTS "SpellCircle" (
    "circle" INTEGER NOT NULL,
    "recover_secs" INTEGER,

    CONSTRAINT "SpellCircle_pkey" PRIMARY KEY ("circle")
);

INSERT INTO "SpellCircle" ("circle", "recover_secs")
VALUES
    (1, 30),
    (2, 35),
    (3, 50),
    (4, 65),
    (5, 80),
    (6, 95),
    (7, 130),
    (8, 145),
    (9, 165),
    (10, 210),
    (11, 250),
    (12, 290),
    (13, 310),
    (14, 330)
ON CONFLICT ("circle") DO UPDATE
SET "recover_secs" = EXCLUDED."recover_secs"
WHERE "SpellCircle"."recover_secs" IS NULL;

COMMIT;
