-- Race start rooms that stranded new characters (Refs fierymud-rs #156).
--
-- A new character spawns in, and `recall` (before a touchstone is bound) and respawn
-- return to, "Races"."start_room_*". Seven playable races pointed at rooms that are not
-- fit to start in:
--   DRAGONBORN_LIGHTNING  (488, 60)  AIR sector in Doom: the Plane of the Air; the character
--                                    fell on login and again on every recall.
--   DROW (237, 22), DUERGAR (133, 1), SVERFNEBLIN (54, 2), DRAGONBORN_FIRE (52, 72),
--   DRAGONBORN_FROST (533, 88), DRAGONBORN_GAS (54, 72)
--                                    CAVE / UNDERDARK rooms that are dark around the clock, so
--                                    a first-time player sees nothing without a torch.
-- They move to the legacy default start (3001 = zone 30 id 1, the Forest Temple of Mielikki).
-- This is not a decision about where everyone starts: races whose room is fine are untouched,
-- and Muditor can give any race another lit, ground-level room later. The server also refuses
-- an unusable start room at runtime (falls back to 30/1), and a live-DB test checks every race.
--
-- Guarded and idempotent: a race is only changed while it still holds the bad room listed
-- above (a builder's later edit wins), and only if room 30/1 exists. Mirrors data/races.json.

BEGIN;

UPDATE "Races" r
SET start_room_zone_id = 30, start_room_id = 1, updated_at = now()
FROM (VALUES
    ('DRAGONBORN_LIGHTNING', 488, 60),
    ('DRAGONBORN_FIRE', 52, 72),
    ('DRAGONBORN_FROST', 533, 88),
    ('DRAGONBORN_GAS', 54, 72),
    ('SVERFNEBLIN', 54, 2),
    ('DUERGAR', 133, 1),
    ('DROW', 237, 22)
) AS v(race, zone_id, room_id)
WHERE r.race::text = v.race
  AND r.start_room_zone_id = v.zone_id
  AND r.start_room_id = v.room_id
  AND EXISTS (SELECT 1 FROM "Room" ro WHERE ro.zone_id = 30 AND ro.id = 1);

COMMIT;
