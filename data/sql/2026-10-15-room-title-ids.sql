-- Playtest r12 F14: zone 80 room titles carried the legacy builder's room number
-- ("Carrot Top Heaven (27)"). Strip a trailing " (<id>)" when <id> is the room's
-- own local id. Rows edited since (name no longer ends that way) are untouched.
-- Other zones have no such titles; "Storeroom (W)" style suffixes are not matched.
BEGIN;
UPDATE "Room"
SET name = left(name, length(name) - length(' (' || id::text || ')')),
    updated_at = now()
WHERE zone_id = 80
  AND right(name, length(' (' || id::text || ')')) = ' (' || id::text || ')';
COMMIT;
