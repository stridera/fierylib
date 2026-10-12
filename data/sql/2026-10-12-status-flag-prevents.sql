-- StatusFlagValue prevents_*: which actions an effect carrying a status flag blocks (data over code).
--
-- fierymud-rs used to hard-code this as `flag_prevents` in commands.rs (webbed, held, silence,
-- asleep, ... -> movement / casting / speaking). The game now reads the three columns, so apply
-- this BEFORE deploying that game build (order: muditor `prisma db push`, this SQL, game).
--
-- The columns are created IF NOT EXISTS (`prisma db push` normally adds them first). Flags with
-- no row yet are inserted with ai_value 0, which scores the same as having no row. An existing
-- row is only filled in while all three columns are still false, so builder edits in Muditor
-- are never overwritten and a second run changes 0 rows. Keep in sync with the Prisma model
-- StatusFlagValue in muditor/packages/db/prisma/schema.prisma. Generated from
-- data/content_tables.json (status_flag_prevents); a unit test keeps the two in sync.

BEGIN;

ALTER TABLE "StatusFlagValue" ADD COLUMN IF NOT EXISTS "prevents_movement" BOOLEAN NOT NULL DEFAULT false;

ALTER TABLE "StatusFlagValue" ADD COLUMN IF NOT EXISTS "prevents_casting" BOOLEAN NOT NULL DEFAULT false;

ALTER TABLE "StatusFlagValue" ADD COLUMN IF NOT EXISTS "prevents_speaking" BOOLEAN NOT NULL DEFAULT false;

INSERT INTO "StatusFlagValue" ("flag", "prevents_movement", "prevents_casting", "prevents_speaking") VALUES
  ('webbed', TRUE, FALSE, FALSE),
  ('held', TRUE, TRUE, FALSE),
  ('hold_person', TRUE, TRUE, FALSE),
  ('paralyzed', TRUE, TRUE, FALSE),
  ('mesmerized', TRUE, TRUE, FALSE),
  ('asleep', TRUE, TRUE, TRUE),
  ('sleeping', TRUE, TRUE, TRUE),
  ('rooted', TRUE, FALSE, FALSE),
  ('entangled', TRUE, FALSE, FALSE),
  ('stunned', TRUE, TRUE, TRUE),
  ('stun', TRUE, TRUE, TRUE),
  ('silenced', FALSE, TRUE, TRUE),
  ('silence', FALSE, TRUE, TRUE)
ON CONFLICT ("flag") DO UPDATE SET
  "prevents_movement" = EXCLUDED."prevents_movement",
  "prevents_casting" = EXCLUDED."prevents_casting",
  "prevents_speaking" = EXCLUDED."prevents_speaking"
WHERE NOT ("StatusFlagValue"."prevents_movement"
        OR "StatusFlagValue"."prevents_casting"
        OR "StatusFlagValue"."prevents_speaking");

COMMIT;
