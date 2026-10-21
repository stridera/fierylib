-- fierymud-rs #175 / #176: kick and bash never missed and had no wait between uses.
--
-- Both rows carry the data the engine already reads:
--   * `"attackRoll": true` on the damage row makes the skill roll to hit with the melee accuracy/evasion contest
--     (skill adds skill / 2 accuracy), then the target's dodge/parry, before any effect lands. A miss uses the
--     ability's fail_to_* messages (already seeded) and still counts as a use.
--   * `Ability.cooldown_ms` is the per-skill lag. The combat round is 4 s; legacy WAIT_STATE was 1.5 rounds for kick
--     and 2 rounds for bash (and bash set CD_BASH for 2 rounds): kick 6000 ms, bash 8000 ms. Same style as BACKSTAB
--     (6000) and TRIP_UP (8000).
--
-- Idempotent and guarded on the current values, so a builder's edit in Muditor is never overwritten and a second
-- run changes 0 rows. Keep in sync with data/abilities.json (KICK, BASH).

BEGIN;

UPDATE "Ability" SET cooldown_ms = 6000 WHERE plain_name = 'KICK' AND cooldown_ms = 0;
UPDATE "Ability" SET cooldown_ms = 8000 WHERE plain_name = 'BASH' AND cooldown_ms = 0;

UPDATE "AbilityEffect" ae
SET override_params = COALESCE(ae.override_params, '{}'::jsonb) || '{"attackRoll": true}'::jsonb
FROM "Ability" a, "Effect" e
WHERE a.id = ae.ability_id
  AND e.id = ae.effect_id
  AND a.plain_name IN ('KICK', 'BASH')
  AND e.name = 'damage'
  AND ae."order" = 0
  AND NOT COALESCE(ae.override_params ? 'attackRoll', false);

COMMIT;
