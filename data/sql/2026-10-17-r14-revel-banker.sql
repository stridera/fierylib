-- Playtest r14 B2: the Master of the Revel (519:8) tells students "I myself happen to be a
-- certified banker!" and the money lesson makes them deposit with him, but he was imported
-- without the BANKER profession (legacy made his ROOM, 51907, the bank: ASSIGNROOM(51907, bank)),
-- so `deposit` answered "You need a banker here to handle that."
--
-- Guarded and idempotent: only adds BANKER to that one mob while it is missing.
-- The server loads mob prototypes at boot, so the profession takes effect after a restart.

BEGIN;

UPDATE "Mobs"
SET professions = array_append(professions, 'BANKER'::"MobProfession"),
    updated_at = now()
WHERE zone_id = 519 AND id = 8
  AND name = 'the Master of the Revel'
  AND NOT ('BANKER'::"MobProfession" = ANY (COALESCE(professions, ARRAY[]::"MobProfession"[])));

COMMIT;
