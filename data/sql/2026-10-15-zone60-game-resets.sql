-- Playtest r13 F3: the ConnectFour board (60:60) and the Hearts table (60:75) are in no zone's
-- reset list, so the games never appeared in the world. Legacy zon/60.zon has no O command for
-- them either (the importer dropped nothing); they were never placed. Put the board in The Ole
-- Witch Tavern (60:37) and the table in the Casino in the Red Feathered Nest (60:55): different
-- rooms, so each room has one game.
--
-- Idempotent: a row is only added while the object has no reset at all in zone 60 (a builder
-- who has already placed it, or removed and re-added it, is left alone), and only when both
-- the object and the room exist. Takes effect at the next server restart (the reset catalog is
-- read at boot; there is no reload for it).

BEGIN;

INSERT INTO "ObjectResets" ("max_instances", "comment", "object_zone_id", "object_id",
                            "room_zone_id", "room_id", "zone_id", "probability", "reset_behavior")
SELECT 1, v.comment, 60, v.obj, 60, v.room, 60, 1.0, 'PERSISTENT'
FROM (VALUES
  (60, 37, '(a ConnectFour board)'),
  (75, 55, '(a Hearts table)')
) AS v(obj, room, comment)
WHERE EXISTS (SELECT 1 FROM "Objects" o WHERE o."zone_id" = 60 AND o."id" = v.obj)
  AND EXISTS (SELECT 1 FROM "Room" r WHERE r."zone_id" = 60 AND r."id" = v.room)
  AND NOT EXISTS (SELECT 1 FROM "ObjectResets" x
                  WHERE x."object_zone_id" = 60 AND x."object_id" = v.obj);

COMMIT;
