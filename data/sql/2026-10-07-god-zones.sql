-- God zones (Refs backlog item 2).
--
-- Brings an already-seeded database in line with `fierylib import-legacy`
-- (which now marks god zones itself) without a reimport:
--   * adds "Zones".is_god_zone (additive; `prisma db push` is then a no-op),
--   * marks the legacy staff-only zones,
--   * retires the "Walked: <zone>" exploration achievements of those zones.
--
-- Rule (mirrors ZoneImporter.GOD_ZONE_* in the importer): legacy has no zone
-- flag for this, so a zone is a god zone when at least half of its rooms carry
-- a GODROOM entry restriction (legacy GODROOM -> `return actor:is_god()`), plus
-- the legacy immortal-only item/holding zones listed explicitly below.
-- On the dev dump this marks zones 4, 9, 10, 11, 12.
--
-- Idempotent and one-way: it only ever sets the flag to true, so a builder who
-- later clears a zone in the Muditor editor is not overridden by a re-run
-- unless the zone still matches the rule; rerunning is otherwise a no-op.

BEGIN;

ALTER TABLE "Zones" ADD COLUMN IF NOT EXISTS is_god_zone BOOLEAN NOT NULL DEFAULT false;

UPDATE "Zones" z
SET is_god_zone = true, updated_at = now()
WHERE z.is_god_zone = false
  AND (
    z.id IN (4, 11)  -- "imm quest items zone", "The Repository (II)"
    OR (
      SELECT count(*) FROM "Room" r
      WHERE r.zone_id = z.id AND r.deleted_at IS NULL
        AND r.entry_restriction IS NOT NULL
    ) * 2 >= (
      SELECT GREATEST(count(*), 1) FROM "Room" r
      WHERE r.zone_id = z.id AND r.deleted_at IS NULL
    )
    AND EXISTS (
      SELECT 1 FROM "Room" r
      WHERE r.zone_id = z.id AND r.deleted_at IS NULL
        AND r.entry_restriction IS NOT NULL
    )
  );

-- Exploration achievements for god zones: drop the ones nobody earned, hide
-- the ones somebody did (so earned history is kept).
DELETE FROM achievement a
USING "Zones" z
WHERE z.is_god_zone
  AND a.code = 'zone_' || z.id || '_cleared'
  AND NOT EXISTS (
    SELECT 1 FROM character_achievement c WHERE c.achievement_id = a.id
  );

UPDATE achievement a
SET hidden = true, updated_at = now()
FROM "Zones" z
WHERE z.is_god_zone
  AND a.code = 'zone_' || z.id || '_cleared'
  AND a.hidden = false;

-- Random teleport tuning, read by the game from the teleport effect params
-- (data over code): "Teleport" stays inside the caster's zone, "World
-- Teleport" ranges over the whole world; both keep the legacy success roll
-- (random(1,100) <= 10 + skill*2, spells.cpp perform_teleport_spell). Merges
-- keys into the params; rerunning is a no-op.
UPDATE "AbilityEffect" ae
SET override_params = COALESCE(ae.override_params, '{}'::jsonb)
  || '{"range": "zone", "success_base_pct": 10, "success_per_skill_pct": 2}'::jsonb
FROM "Ability" a
WHERE ae.ability_id = a.id AND a.plain_name = 'TELEPORT'
  AND ae.override_params ->> 'destination' = 'random';

UPDATE "AbilityEffect" ae
SET override_params = COALESCE(ae.override_params, '{}'::jsonb)
  || '{"range": "world", "success_base_pct": 10, "success_per_skill_pct": 2}'::jsonb
FROM "Ability" a
WHERE ae.ability_id = a.id AND a.plain_name = 'WORLD_TELEPORT'
  AND ae.override_params ->> 'destination' = 'random';

COMMIT;
