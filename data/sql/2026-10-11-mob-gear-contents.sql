-- Mob gear contents: items nested inside a container a mob carries or wears
-- (legacy `G`/`E` followed by `P`). The import used to drop these 25 rows, so e.g. the little bronze key
-- (23/2) that sits inside the large white cocoon (23/3) carried by the canopy spider (23/8) never existed
-- and LOCKED door 23/107 down could not be opened.
--
-- Needs the table from muditor deploy/prod/sql/080-mob-reset-equipment-contents.sql (`prisma db push` does
-- the same on dev); this patch creates it too if it is missing, with the same DDL.
--
-- Keyed by natural keys only, since ids differ between dev and prod: the mob reset is identified by
-- (mob zone/id, room zone/id) and the carried/worn item by its object (zone/id); the nested item is an
-- object (zone/id) with its legacy `P` max (<=0 = unlimited = 999, as the importer stores it). Every
-- value is the (zone_id, id) pair resolved from the legacy vnum through the zone ranges in lib/world/zon/*.zon.
-- All 25 are one level deep (item directly inside the carried/worn container).
-- Idempotent: a row is only inserted when that equipment row has no content row for the object yet.
-- Generated from lib/world/zon/*.zon.

BEGIN;

CREATE TABLE IF NOT EXISTS "MobResetEquipmentContents" (
    "id" SERIAL NOT NULL,
    "equipment_id" INTEGER NOT NULL,
    "parent_content_id" INTEGER,
    "object_zone_id" INTEGER NOT NULL,
    "object_id" INTEGER NOT NULL,
    "quantity" INTEGER NOT NULL DEFAULT 1,
    "max_instances" INTEGER NOT NULL DEFAULT 1,
    "comment" TEXT,

    CONSTRAINT "MobResetEquipmentContents_pkey" PRIMARY KEY ("id")
);

DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'MobResetEquipmentContents_equipment_id_fkey') THEN
        ALTER TABLE "MobResetEquipmentContents" ADD CONSTRAINT "MobResetEquipmentContents_equipment_id_fkey"
            FOREIGN KEY ("equipment_id") REFERENCES "MobResetEquipment"("id") ON DELETE CASCADE ON UPDATE CASCADE;
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'MobResetEquipmentContents_parent_content_id_fkey') THEN
        ALTER TABLE "MobResetEquipmentContents" ADD CONSTRAINT "MobResetEquipmentContents_parent_content_id_fkey"
            FOREIGN KEY ("parent_content_id") REFERENCES "MobResetEquipmentContents"("id") ON DELETE CASCADE ON UPDATE CASCADE;
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'MobResetEquipmentContents_object_zone_id_object_id_fkey') THEN
        ALTER TABLE "MobResetEquipmentContents" ADD CONSTRAINT "MobResetEquipmentContents_object_zone_id_object_id_fkey"
            FOREIGN KEY ("object_zone_id", "object_id") REFERENCES "Objects"("zone_id", "id") ON DELETE CASCADE ON UPDATE CASCADE;
    END IF;
END $$;

INSERT INTO "MobResetEquipmentContents" (equipment_id, object_zone_id, object_id, quantity, max_instances, comment)
SELECT e.id, v.content_zone, v.content_id, 1, v.max_instances, o.name
FROM (VALUES
    -- (mob zone, mob id, room zone, room id, gear zone, gear id, content zone, content id, P max)
    (23, 8, 23, 459, 23, 3, 23, 2, 3),
    (360, 1, 360, 8, 360, 10, 30, 10, 200),
    (360, 2, 360, 8, 360, 10, 30, 10, 200),
    (360, 1, 360, 1, 360, 10, 30, 10, 200),
    (360, 2, 360, 1, 360, 10, 30, 10, 200),
    (360, 1, 360, 6, 360, 10, 30, 10, 200),
    (360, 1, 360, 4, 360, 10, 30, 10, 200),
    (360, 1, 360, 12, 360, 10, 30, 10, 200),
    (360, 2, 360, 12, 360, 10, 30, 10, 200),
    (360, 1, 360, 11, 360, 10, 30, 10, 200),
    (360, 1, 360, 10, 360, 10, 30, 10, 200),
    (360, 2, 360, 10, 360, 10, 30, 10, 200),
    (360, 2, 360, 3, 360, 10, 30, 10, 200),
    (360, 2, 360, 5, 360, 10, 30, 10, 200),
    (360, 2, 360, 7, 360, 10, 30, 10, 200),
    (464, 0, 464, 47, 464, 6, 464, 12, 1),
    (489, 20, 489, 44, 489, 24, 489, 25, 5),
    (489, 20, 489, 38, 489, 24, 489, 25, 5),
    (489, 20, 489, 35, 489, 24, 489, 25, 5),
    (489, 20, 489, 33, 489, 24, 489, 25, 5),
    (489, 20, 489, 29, 489, 24, 489, 25, 5),
    (550, 2, 551, 14, 550, 29, 550, 4, 1),
    (584, 20, 584, 117, 584, 24, 584, 17, 1),
    (584, 2, 584, 109, 584, 8, 584, 9, 1),
    (584, 11, 584, 91, 584, 2, 584, 22, 1)
) AS v(mob_zone, mob_id, room_zone, room_id, gear_zone, gear_id, content_zone, content_id, max_instances)
JOIN "MobResets" r
  ON r.mob_zone_id = v.mob_zone AND r.mob_id = v.mob_id
 AND r.room_zone_id = v.room_zone AND r.room_id = v.room_id
JOIN "MobResetEquipment" e
  ON e.reset_id = r.id AND e.object_zone_id = v.gear_zone AND e.object_id = v.gear_id
JOIN "Objects" o
  ON o.zone_id = v.content_zone AND o.id = v.content_id
WHERE NOT EXISTS (
    SELECT 1 FROM "MobResetEquipmentContents" c
    WHERE c.equipment_id = e.id AND c.parent_content_id IS NULL
      AND c.object_zone_id = v.content_zone AND c.object_id = v.content_id
);

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
    FOREACH t IN ARRAY ARRAY['MobResetEquipmentContents'] LOOP
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
