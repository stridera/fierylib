-- Importable Lua libraries ("ScriptLibrary"): the table behind `require("name")` in fierymud-rs.
--
-- Libraries are separate from "Triggers" so they cannot be attached to a mob/object/room, and are
-- looked up by unique name. `zone_id` is optional organisation/permission scope: a library with a
-- zone is editable by builders holding a WRITE grant on it; a library without one by HEAD_BUILDER+.
-- The game loads the table at boot and on /api/admin/triggers/reload; a missing table just means
-- "no libraries" (one ERROR in the log), so applying this patch is safe at any time.
--
-- This patch only creates the table (DDL matches what Prisma's `db push` creates for the
-- `ScriptLibrary` model in muditor/packages/db/prisma/schema.prisma). The library bodies live in
-- git (fierylib/data/script_libraries/*.lua) and are loaded with `fierylib seed script-libraries`.
--
-- Idempotent: rerunning changes nothing.

BEGIN;

CREATE TABLE IF NOT EXISTS "ScriptLibrary" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "zone_id" INTEGER,
    "description" TEXT,
    "code" TEXT NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "created_by" TEXT,
    "updated_by" TEXT,

    CONSTRAINT "ScriptLibrary_pkey" PRIMARY KEY ("id")
);

CREATE UNIQUE INDEX IF NOT EXISTS "ScriptLibrary_name_key" ON "ScriptLibrary"("name");

CREATE INDEX IF NOT EXISTS "ScriptLibrary_zone_id_idx" ON "ScriptLibrary"("zone_id");

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_constraint WHERE conname = 'ScriptLibrary_zone_id_fkey'
    ) THEN
        ALTER TABLE "ScriptLibrary"
            ADD CONSTRAINT "ScriptLibrary_zone_id_fkey"
            FOREIGN KEY ("zone_id") REFERENCES "Zones"("id")
            ON DELETE SET NULL ON UPDATE CASCADE;
    END IF;
END
$$;

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
    FOREACH t IN ARRAY ARRAY['ScriptLibrary'] LOOP
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
