-- ReservedNames: words refused as character names (staff/system voices and generic mob
-- words), moved out of the game server's source (data over code). Builders edit the table in
-- Muditor; the game loads it at boot and logs an ERROR and falls back to an empty list when
-- the table is missing, so applying this by hand after the deploy is safe.
--
-- The command-grammar words (all/self/me/everyone/someone/something/here) are not rows: they
-- stay in the game's code. Names are stored lowercase; the game compares case-insensitively.
--
-- Idempotent and builder-safe: the table is created IF NOT EXISTS and rows are inserted only
-- when missing (ON CONFLICT DO NOTHING). Keep in sync with model ReservedNames in
-- muditor/packages/db/prisma/schema.prisma (and muditor/deploy/prod/sql/070-reserved-names.sql).
-- Generated from data/reserved_names.json; a unit test keeps the two in sync.

BEGIN;

CREATE TABLE IF NOT EXISTS "ReservedNames" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "reason" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "ReservedNames_pkey" PRIMARY KEY ("id")
);

CREATE UNIQUE INDEX IF NOT EXISTS "ReservedNames_name_key" ON "ReservedNames"("name");

INSERT INTO "ReservedNames" ("name", "reason") VALUES
  ('admin', 'Staff or system voice'),
  ('administrator', 'Staff or system voice'),
  ('builder', 'Staff or system voice'),
  ('god', 'Staff or system voice'),
  ('gods', 'Staff or system voice'),
  ('immortal', 'Staff or system voice'),
  ('implementor', 'Staff or system voice'),
  ('moderator', 'Staff or system voice'),
  ('server', 'Staff or system voice'),
  ('staff', 'Staff or system voice'),
  ('system', 'Staff or system voice'),
  ('beggar', 'Generic mob word'),
  ('citizen', 'Generic mob word'),
  ('cityguard', 'Generic mob word'),
  ('corpse', 'Generic mob word'),
  ('guard', 'Generic mob word'),
  ('guardian', 'Generic mob word'),
  ('guardsman', 'Generic mob word'),
  ('merchant', 'Generic mob word'),
  ('mob', 'Generic mob word'),
  ('npc', 'Generic mob word'),
  ('shopkeeper', 'Generic mob word')
ON CONFLICT ("name") DO NOTHING;

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
    FOREACH t IN ARRAY ARRAY['ReservedNames'] LOOP
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
