-- Issue stridera/fierymud-rs#92: waist and belt are separate slots. Slot::Belt (legacy
-- WEAR_OBELT) is saved as equipped_location 'BELT'. The player importer used to collapse
-- OBELT into 'WAIST', so every item that hangs from a belt was stored as worn at the waist.
--
-- 1. A worn-at-WAIST item whose prototype can only hang from a belt (BELT wear flag, no WAIST
--    wear flag) is really a belt item: move it to 'BELT'.
-- 2. Legacy rule (may_wear_eq / do_remove): a belt item needs a worn waist item. Where the
--    character has none, the item goes back to the pack (equipped_location cleared).
--
-- Run after 2026-10-09-obelt-wear-slot.sql (it asserts the WAIST/BELT wear flags this reads).
-- Corpse rows are left alone. Idempotent: step 1 only matches 'WAIST', step 2 only 'BELT'
-- rows with no waist item, and a second run finds neither.
-- Restart fierymud-rs after applying (sqlx prepared-statement cache).

UPDATE "CharacterItems" ci
SET equipped_location = 'BELT'
FROM "Objects" o
WHERE o.zone_id = ci.object_zone_id
  AND o.id = ci.object_id
  AND ci.corpse_id IS NULL
  AND ci.equipped_location = 'WAIST'
  AND 'BELT' = ANY (o."wearFlags"::text[])
  AND NOT ('WAIST' = ANY (o."wearFlags"::text[]));

UPDATE "CharacterItems" ci
SET equipped_location = NULL
WHERE ci.corpse_id IS NULL
  AND ci.equipped_location = 'BELT'
  AND NOT EXISTS (
    SELECT 1
    FROM "CharacterItems" w
    WHERE w.character_id = ci.character_id
      AND w.corpse_id IS NULL
      AND w.equipped_location = 'WAIST'
  );
