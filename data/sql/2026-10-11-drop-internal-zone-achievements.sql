-- Internal zones 0 (Void), 1 and 2 are engine scaffolding, not explorable
-- content. The game skips them (mud_world::INTERNAL_ZONE_IDS) and the
-- achievement seeder no longer generates their zone-clear achievements
-- (INTERNAL_ZONE_IDS in achievement_seeder.py). Remove existing rows.
--
-- Only character_achievement references achievement (ON DELETE CASCADE), but
-- dependents are deleted explicitly first so the intent is visible.
-- Idempotent: a re-run deletes 0 rows.

BEGIN;

DELETE FROM character_achievement ca
USING achievement a
WHERE ca.achievement_id = a.id
  AND a.code IN ('zone_0_cleared', 'zone_1_cleared', 'zone_2_cleared');

DELETE FROM achievement
WHERE code IN ('zone_0_cleared', 'zone_1_cleared', 'zone_2_cleared');

COMMIT;
