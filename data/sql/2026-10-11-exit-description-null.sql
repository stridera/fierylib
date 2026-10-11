-- RoomExit.description: '' -> NULL. The importer now stores NULL for an exit with no description
-- (playtest 2026-10-11 round 2 #69: `look <dir>` through a closed door printed blank lines).
-- Idempotent: only rows still holding '' are touched; a second run changes 0 rows.
UPDATE "RoomExit" SET description = NULL WHERE description = '';
