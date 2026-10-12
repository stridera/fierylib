-- Per-sphere display colours (data-over-code).
--
-- fierymud-rs kept the sphere -> colour palette in two hard-coded copies (the spells/skills
-- listings and the `<fire>`-style tag aliases). The colour now lives in "SphereStyle"
-- (sphere -> XML-Lite tag body, e.g. 'red', 'b:cyan'); the game falls back to the same built-in
-- palette when a row or its colour is missing, so behaviour is identical either way.
--
-- This patch:
--   * creates "SphereStyle" if missing (DDL matches what Prisma's `db push` creates);
--   * seeds the current palette, filling only NULL colours (a colour edited in Muditor wins);
--   * adds the GENERIC row with no colour (listings render it dim).
--
-- Idempotent: rerunning changes nothing.

BEGIN;

CREATE TABLE IF NOT EXISTS "SphereStyle" (
    "sphere" "SpellSphere" NOT NULL,
    "color" TEXT,

    CONSTRAINT "SphereStyle_pkey" PRIMARY KEY ("sphere")
);

INSERT INTO "SphereStyle" ("sphere", "color")
VALUES
    ('FIRE', 'red'),
    ('WATER', 'cyan'),
    ('AIR', 'b:cyan'),
    ('EARTH', 'yellow'),
    ('HEALING', 'green'),
    ('DEATH', 'b:black'),
    ('PROTECTION', 'b:white'),
    ('ENCHANTMENT', 'magenta'),
    ('SUMMONING', 'b:magenta'),
    ('DIVINATION', 'b:yellow')
ON CONFLICT ("sphere") DO UPDATE
SET "color" = EXCLUDED."color"
WHERE "SphereStyle"."color" IS NULL;

INSERT INTO "SphereStyle" ("sphere", "color")
VALUES ('GENERIC', NULL)
ON CONFLICT ("sphere") DO NOTHING;

COMMIT;
