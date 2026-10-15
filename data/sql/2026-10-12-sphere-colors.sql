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

-- Environment-neutral ownership: tables created by a superuser (postgres on prod)
-- must belong to the same role as the existing tables, or Prisma gets
-- "permission denied". Dev owner is strider, prod is fierynext.
DO $$
DECLARE
  tbl_owner text;
  t text;
  seq text;
BEGIN
  SELECT tableowner INTO tbl_owner FROM pg_tables WHERE tablename = 'Characters' LIMIT 1;
  IF tbl_owner IS NOT NULL THEN
    FOREACH t IN ARRAY ARRAY['SphereStyle'] LOOP
      EXECUTE format('ALTER TABLE %I OWNER TO %I', t, tbl_owner);
      FOR seq IN
        SELECT sq.relname
        FROM pg_class sq
        JOIN pg_depend d ON d.objid = sq.oid AND d.deptype = 'a'
        JOIN pg_class tb ON tb.oid = d.refobjid
        WHERE sq.relkind = 'S' AND tb.relname = t AND tb.relnamespace = 'public'::regnamespace
      LOOP
        EXECUTE format('ALTER SEQUENCE %I OWNER TO %I', seq, tbl_owner);
      END LOOP;
    END LOOP;
  END IF;
END $$;

COMMIT;
