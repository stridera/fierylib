-- Summon mob table, moved out of the hard-coded match in fierymud-rs
-- commands.rs (data over code). The `summon` effect now names the mob it spawns
-- in its params:
--   mobZone / mobId   the Mobs prototype (zone_id, id) spawned as the caster's
--                     follower. `mobType` stays as a label for builders.
-- A summon effect without both keys is skipped at cast time with a warning
-- naming the ability (a builder-facing log line), so every summon spell needs
-- them.
--
--   ANIMATE_DEAD          54:20   the Large Skeleton
--   CLONE                 163:8   the Knight Errant (renamed to the caster at cast)
--   MOUNT, SUMMON_MOUNT   324:21  a well trained horse
--   SIMULACRUM            163:8   the Knight Errant (renamed to the target)
--   SPHERE_SUMMON,
--   SUMMON_ELEMENTAL      52:12   the flame elemental
--   SUMMON_DEMON          510:24  an Astral Demon
--   SUMMON_GREATER_DEMON  160:11  the Demon Lord
--   SUMMON_DRACOLICH      533:11  a dragon cult guardian
--
-- Keyed by Ability.plain_name. Idempotent and builder-safe: the keys are merged
-- under whatever the params already hold, and rows that already carry both are
-- not touched, so a second run changes nothing.

BEGIN;

UPDATE "AbilityEffect" ae
SET override_params =
      jsonb_build_object('mobZone', v.mob_zone, 'mobId', v.mob_id)
      || COALESCE(ae.override_params, '{}'::jsonb)
FROM (VALUES
    ('ANIMATE_DEAD', 54, 20),
    ('CLONE', 163, 8),
    ('MOUNT', 324, 21),
    ('SIMULACRUM', 163, 8),
    ('SPHERE_SUMMON', 52, 12),
    ('SUMMON_DEMON', 510, 24),
    ('SUMMON_DRACOLICH', 533, 11),
    ('SUMMON_ELEMENTAL', 52, 12),
    ('SUMMON_GREATER_DEMON', 160, 11),
    ('SUMMON_MOUNT', 324, 21)
) AS v(plain_name, mob_zone, mob_id),
"Ability" a, "Effect" e
WHERE ae.ability_id = a.id
  AND ae.effect_id = e.id
  AND a.plain_name = v.plain_name
  AND e."effectType" = 'summon'
  AND NOT (COALESCE(ae.override_params, '{}'::jsonb) ?& ARRAY['mobZone', 'mobId']);

COMMIT;
