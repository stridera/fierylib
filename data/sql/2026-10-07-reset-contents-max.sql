-- ObjectResetContents.max_instances: legacy `P` world cap (Refs fierymud-rs review).
--
-- Adds the column (default 1) and backfills it from the legacy zone files' `P`
-- commands (`P <if> <obj> <max> <container>`), keyed by (content object,
-- container object). One cap per pair; legacy has no pair with two different
-- maxes. Rows with no matching legacy P keep the default of 1. A max of 0 or
-- less (legacy "unlimited") is stored as 999, matching the importer.
-- Idempotent: ADD COLUMN IF NOT EXISTS, and the UPDATE is a pure assignment.
-- Generated from lib/world/zon/*.zon (vnum = zone_id*100 + id, resolved against "Objects").

BEGIN;

ALTER TABLE "ObjectResetContents"
    ADD COLUMN IF NOT EXISTS max_instances integer NOT NULL DEFAULT 1;

UPDATE "ObjectResetContents" c
SET max_instances = v.max
FROM (VALUES
    (0, 38, 16, 11, 50),
    (16, 15, 16, 11, 10),
    (18, 7, 18, 97, 1),
    (23, 0, 23, 1, 1),
    (23, 2, 23, 3, 3),
    (30, 10, 360, 10, 200),
    (30, 298, 30, 297, 20),
    (43, 57, 136, 60, 1),
    (80, 8, 80, 7, 4),
    (83, 27, 83, 26, 1),
    (83, 41, 83, 44, 4),
    (83, 42, 83, 44, 3),
    (83, 48, 83, 26, 1),
    (85, 1, 85, 2, 5),
    (120, 158, 120, 17, 5),
    (125, 8, 125, 7, 1),
    (125, 9, 125, 7, 1),
    (125, 26, 125, 25, 1),
    (125, 30, 125, 29, 1),
    (125, 32, 125, 28, 1),
    (125, 33, 125, 28, 1),
    (125, 42, 125, 40, 3),
    (133, 14, 133, 2, 10),
    (136, 1, 136, 60, 10),
    (136, 62, 136, 60, 50),
    (160, 11, 160, 10, 1),
    (160, 13, 160, 12, 1),
    (160, 15, 160, 14, 2),
    (160, 17, 160, 16, 3),
    (162, 4, 162, 10, 2),
    (162, 8, 162, 7, 1),
    (162, 11, 162, 6, 2),
    (162, 12, 162, 7, 2),
    (162, 13, 162, 10, 2),
    (162, 16, 162, 6, 1),
    (185, 12, 85, 21, 50),
    (185, 28, 185, 27, 50),
    (185, 50, 185, 54, 3),
    (185, 56, 185, 55, 1),
    (302, 2, 302, 1, 1),
    (360, 11, 360, 2, 10),
    (360, 12, 360, 1, 10),
    (363, 3, 363, 0, 99),
    (410, 5, 410, 13, 3),
    (410, 14, 410, 12, 10),
    (430, 25, 430, 24, 12),
    (464, 12, 464, 6, 1),
    (480, 4, 480, 27, 1),
    (480, 22, 480, 21, 1),
    (480, 24, 480, 32, 1),
    (480, 35, 480, 21, 1),
    (481, 14, 481, 15, 1),
    (481, 17, 481, 19, 50),
    (481, 22, 481, 19, 5),
    (484, 3, 484, 0, 1),
    (484, 100, 484, 103, 1),
    (484, 101, 484, 103, 1),
    (484, 102, 484, 103, 1),
    (489, 2, 489, 20, 99),
    (489, 23, 489, 15, 1),
    (489, 25, 489, 24, 5),
    (489, 94, 489, 15, 1),
    (490, 42, 490, 54, 6),
    (490, 65, 490, 64, 50),
    (510, 71, 510, 70, 1),
    (510, 73, 510, 72, 1),
    (510, 74, 510, 72, 1),
    (520, 2, 520, 36, 1),
    (520, 6, 520, 32, 1),
    (520, 7, 520, 32, 1),
    (520, 18, 520, 5, 1),
    (520, 19, 520, 5, 1),
    (520, 20, 520, 5, 1),
    (520, 21, 520, 5, 1),
    (520, 22, 520, 5, 1),
    (520, 23, 520, 5, 1),
    (520, 24, 520, 5, 1),
    (520, 25, 520, 5, 1),
    (520, 26, 520, 5, 1),
    (520, 27, 520, 5, 1),
    (520, 28, 520, 5, 1),
    (520, 29, 520, 5, 1),
    (520, 30, 520, 5, 1),
    (520, 52, 520, 5, 1),
    (530, 4, 530, 11, 99),
    (530, 28, 530, 11, 2),
    (533, 15, 533, 24, 1),
    (533, 24, 533, 22, 1),
    (534, 5, 534, 4, 10),
    (534, 6, 534, 4, 10),
    (534, 11, 534, 4, 8),
    (534, 21, 534, 4, 20),
    (550, 4, 550, 29, 1),
    (550, 23, 489, 15, 99),
    (584, 9, 584, 8, 1),
    (584, 12, 584, 11, 1),
    (584, 17, 584, 24, 1),
    (584, 22, 584, 2, 1),
    (584, 23, 584, 27, 3),
    (590, 17, 590, 34, 50),
    (590, 18, 590, 19, 1),
    (590, 23, 590, 33, 20),
    (590, 30, 590, 32, 30)
) AS v(oz, oid, cz, cid, max)
WHERE c.object_zone_id = v.oz
  AND c.object_id = v.oid
  AND (
    -- direct child of the reset's container object
    (c.parent_content_id IS NULL AND EXISTS (
        SELECT 1 FROM "ObjectResets" r
        WHERE r.id = c.reset_id AND r.object_zone_id = v.cz AND r.object_id = v.cid))
    OR
    -- nested inside another content row
    EXISTS (
        SELECT 1 FROM "ObjectResetContents" p
        WHERE p.id = c.parent_content_id AND p.object_zone_id = v.cz AND p.object_id = v.cid)
  );

COMMIT;
