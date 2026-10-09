-- Waist and belt are different wear positions (issue #92). Legacy has ITEM_WEAR_WAIST (bit 11,
-- WEAR_WAIST: a belt, sash or girdle) and ITEM_WEAR_OBELT (bit 20, WEAR_OBELT: something attached to a
-- worn belt), and the importer maps them to the WearFlag values WAIST and BELT. The runtime used to fold
-- both into one waist slot; it now has a separate belt slot (Slot::Belt), so the two flags have to be
-- right on every object. This patch re-asserts them from the legacy lib/world/obj/*.obj files
-- (38 objects with WAIST, 68 with BELT, none with both).
--
-- Keyed ONLY by (zone_id, id): the legacy vnum minus 100 x the zone file number, zone files keep their
-- number (zone 0 stays 0). Rows absent from this database are skipped. Idempotent: an object is touched only
-- while its WAIST or BELT membership differs from legacy, every other flag is left alone, and the order of
-- the remaining flags is kept, so a second run changes 0 rows and builder edits to other flags survive.
-- The equipped_location text on CharacterItems / MobResetEquipment needs no change: the runtime reads
-- OBELT and BELT as the belt slot and WAIST as the waist slot.

WITH legacy(zone_id, id, has_waist, has_belt) AS (
  VALUES
    (0, 18, false, true),
    (2, 15, true, false),
    (2, 20, false, true),
    (2, 34, true, false),
    (4, 8, false, true),
    (4, 42, false, true),
    (4, 53, false, true),
    (4, 78, false, true),
    (4, 79, false, true),
    (4, 80, false, true),
    (4, 92, false, true),
    (4, 101, false, true),
    (4, 121, false, true),
    (4, 140, false, true),
    (4, 167, false, true),
    (4, 172, false, true),
    (4, 196, false, true),
    (10, 1, false, true),
    (10, 31, true, false),
    (11, 27, true, false),
    (12, 5, true, false),
    (12, 7, false, true),
    (23, 12, false, true),
    (28, 3, true, false),
    (30, 237, true, false),
    (40, 10, false, true),
    (43, 5, true, false),
    (43, 16, true, false),
    (43, 20, true, false),
    (55, 29, true, false),
    (55, 30, true, false),
    (63, 80, false, true),
    (64, 11, true, false),
    (64, 12, false, true),
    (86, 4, true, false),
    (87, 1, false, true),
    (100, 34, true, false),
    (120, 8, true, false),
    (123, 1, false, true),
    (123, 11, false, true),
    (123, 13, false, true),
    (123, 16, false, true),
    (123, 19, false, true),
    (123, 31, true, false),
    (123, 42, false, true),
    (123, 98, true, false),
    (123, 99, false, true),
    (123, 101, false, true),
    (123, 111, false, true),
    (123, 113, false, true),
    (123, 116, false, true),
    (123, 119, false, true),
    (123, 131, true, false),
    (123, 142, false, true),
    (123, 198, true, false),
    (160, 31, true, false),
    (161, 7, false, true),
    (161, 10, true, false),
    (172, 4, true, false),
    (172, 5, true, false),
    (173, 9, false, true),
    (185, 56, true, false),
    (203, 0, false, true),
    (237, 69, false, true),
    (237, 92, true, false),
    (238, 18, false, true),
    (238, 90, true, false),
    (238, 92, false, true),
    (238, 93, false, true),
    (324, 12, false, true),
    (350, 5, false, true),
    (360, 10, true, false),
    (470, 15, true, false),
    (481, 1, false, true),
    (481, 4, false, true),
    (481, 28, false, true),
    (481, 63, false, true),
    (484, 16, false, true),
    (484, 20, false, true),
    (484, 22, false, true),
    (484, 23, true, false),
    (489, 4, true, false),
    (490, 25, false, true),
    (490, 33, false, true),
    (502, 19, false, true),
    (502, 20, false, true),
    (510, 12, false, true),
    (521, 17, true, false),
    (534, 20, false, true),
    (550, 13, true, false),
    (558, 3, false, true),
    (580, 7, true, false),
    (580, 294, true, false),
    (584, 31, true, false),
    (584, 32, true, false),
    (587, 5, false, true),
    (587, 7, false, true),
    (588, 20, false, true),
    (590, 4, false, true),
    (590, 5, false, true),
    (590, 8, false, true),
    (590, 40, false, true),
    (615, 13, false, true),
    (615, 19, false, true),
    (625, 1, true, false),
    (625, 8, false, true)
)
UPDATE "Objects" o
SET "wearFlags" =
      COALESCE(
        (SELECT array_agg(t.f ORDER BY t.ord)
           FROM unnest(o."wearFlags") WITH ORDINALITY AS t(f, ord)
          WHERE t.f NOT IN ('WAIST', 'BELT')
             OR (t.f = 'WAIST' AND l.has_waist)
             OR (t.f = 'BELT' AND l.has_belt)),
        ARRAY[]::"WearFlag"[])
      || CASE WHEN l.has_waist AND NOT ('WAIST' = ANY(o."wearFlags"))
              THEN ARRAY['WAIST']::"WearFlag"[] ELSE ARRAY[]::"WearFlag"[] END
      || CASE WHEN l.has_belt AND NOT ('BELT' = ANY(o."wearFlags"))
              THEN ARRAY['BELT']::"WearFlag"[] ELSE ARRAY[]::"WearFlag"[] END
FROM legacy l
WHERE o.zone_id = l.zone_id
  AND o.id = l.id
  AND (('WAIST' = ANY(o."wearFlags")) <> l.has_waist OR ('BELT' = ANY(o."wearFlags")) <> l.has_belt);
