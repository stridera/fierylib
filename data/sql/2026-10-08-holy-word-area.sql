-- Issue stridera/fierymud-rs#81: Holy Word must be an area spell. Legacy skills.cpp:
-- spello(SPELL_HOLY_WORD, ..., TAR_IGNORE, MAG_AREA, ...) and magic.cpp mag_areas() sweep the room
-- hitting every evil creature (non-evil are skipped silently), exactly like Unholy Word (is_area =
-- true, target_scope = ROOM_ENEMIES). Source of truth: data/abilities.json (isArea).
--
-- Idempotent: only touches the row while it is still single-target, so a second run updates 0 rows
-- and later builder edits survive.
UPDATE "Ability"
SET is_area = true,
    target_scope = 'ROOM_ENEMIES'
WHERE plain_name = 'HOLY_WORD'
  AND (is_area = false OR target_scope = 'SINGLE');
