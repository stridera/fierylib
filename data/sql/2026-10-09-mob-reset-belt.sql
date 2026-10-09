-- Mob reset equipment: belt-only items were reset at the waist.
-- Waist (legacy WEAR_WAIST) and belt (WEAR_OBELT) are separate slots, and a belt item needs a worn waist item.
-- A zone-file E line can name either position for an object that only fits the other, so some resets put a
-- belt-only object (BELT wear flag, no WAIST) in the WAIST slot: the mob then wears the pouch where the belt
-- should be, and the pouch the belt would carry has nothing to hang from. On dev that is 6 rows (five
-- belt pouches in zone 588 and a severed head in zone 481); the 30 OBELT rows with a BELT-flagged object were
-- already right.
--
-- The slot follows the object's actual wear flags:
--   BELT without WAIST -> OBELT        WAIST without BELT -> WAIST
-- Both flags, neither flag (OBELT rows on objects with no wear flags at all), every other slot, and rows with
-- no slot (G commands, carried) are left alone. A reimport gets the same answer from
-- fierylib/importers/reset_importer.py belt_slot_for.
--
-- Keyed ONLY by the object's natural key (Objects.zone_id, Objects.id) joined from the reset row, never by a
-- serial id (ids differ between dev and prod). Idempotent: a row is touched only while its slot disagrees with
-- the object's flags, so a second run changes 0 rows. The runtime reads OBELT and BELT as the belt slot.
-- Restart fierymud-rs after applying (sqlx prepared-statement cache).

UPDATE "MobResetEquipment" e
SET wear_location = 'OBELT'
FROM "Objects" o
WHERE o.zone_id = e.object_zone_id
  AND o.id = e.object_id
  AND e.wear_location = 'WAIST'
  AND 'BELT' = ANY (o."wearFlags"::text[])
  AND NOT ('WAIST' = ANY (o."wearFlags"::text[]));

UPDATE "MobResetEquipment" e
SET wear_location = 'WAIST'
FROM "Objects" o
WHERE o.zone_id = e.object_zone_id
  AND o.id = e.object_id
  AND e.wear_location IN ('OBELT', 'BELT')
  AND 'WAIST' = ANY (o."wearFlags"::text[])
  AND NOT ('BELT' = ANY (o."wearFlags"::text[]));
