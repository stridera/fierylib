-- Knockdown: give the durations an explicit unit (combat rounds, 4 s each).
--
-- The Bash, Buck and Trip Up knockdown rows carried {"duration": 1} with no durationUnit, and the
-- knockdown Effect default was {"duration": 2}. The engine reads a unit-less duration as MUD hours
-- (75 s each), so the knockdown showed in `effects`, GMCP and saved effects for 75 s / 150 s.
-- Legacy knockdowns were WAIT_STATE(vict, PULSE_VIOLENCE * rounds) (act.offensive.cpp
-- perform_knockdown/do_tripup), so pin them to rounds with the legacy counts:
--   Bash     2 rounds (legacy rounds = 2)
--   Trip Up  3 rounds (legacy WAIT_STATE(vict, PULSE_VIOLENCE * 3))
--   Buck     1 round  (legacy bucks give the rider no lag; the posture drop is the effect)
--   default  2 rounds (the old value, now in the unit it always meant)
--
-- Idempotent and guarded on the exact current values: a builder's edit in Muditor is never
-- overwritten and a second run changes 0 rows.
-- Keep in sync with data/abilities.json (Bash, Buck, Trip Up) and data/effects.json (knockdown).

BEGIN;

UPDATE "Effect"
SET default_params = '{"duration": 2, "durationUnit": "rounds"}'::jsonb
WHERE name = 'knockdown'
  AND default_params = '{"duration": 2}'::jsonb;

UPDATE "AbilityEffect" ae
SET override_params = v.new_params
FROM (VALUES
    ('Bash',    '{"power": "skill", "duration": 1}'::jsonb, '{"power": "skill", "duration": 2, "durationUnit": "rounds"}'::jsonb),
    ('Trip Up', '{"power": "skill", "duration": 1}'::jsonb, '{"power": "skill", "duration": 3, "durationUnit": "rounds"}'::jsonb),
    ('Buck',    '{"duration": 1}'::jsonb,                   '{"duration": 1, "durationUnit": "rounds"}'::jsonb)
) AS v(ability_name, old_params, new_params),
"Ability" a,
"Effect" e
WHERE a.name = v.ability_name
  AND e.name = 'knockdown'
  AND ae.ability_id = a.id
  AND ae.effect_id = e.id
  AND ae.override_params = v.old_params;

COMMIT;
