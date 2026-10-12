-- fierymud-rs #137 follow-up: Ice Armor conjures armor around the body rather than transforming it,
-- so it is allowed on fluid (Waterform/Vaporform) characters. Drop the requires_rigid tag from it only.
-- Idempotent: a row without the tag is left alone.
BEGIN;
UPDATE "Ability" SET tags = array_remove(tags, 'requires_rigid')
WHERE name = 'Ice Armor' AND 'requires_rigid' = ANY(tags);
COMMIT;
