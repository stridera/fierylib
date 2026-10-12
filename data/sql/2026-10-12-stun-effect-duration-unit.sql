-- Effect "stun": give the default duration an explicit unit.
--
-- The stun Effect default was {"duration": 2} with no durationUnit. The engine reads a
-- unit-less duration as MUD hours (75 s each), so a "2 round" stun would have lasted 150 s.
-- data/effects.json documents the value as combat rounds (4 s each), the unit legacy stuns
-- used (WAIT_STATE in PULSE_VIOLENCE multiples), so pin it to "rounds" (2 rounds = 8 s).
--
-- Idempotent and guarded on the current value: only the untouched default is rewritten, so a
-- builder's edit in Muditor is never overwritten and a second run changes 0 rows.
-- Keep in sync with data/effects.json (stun.defaultParams).

BEGIN;

UPDATE "Effect"
SET default_params = '{"duration": 2, "durationUnit": "rounds"}'::jsonb
WHERE name = 'stun'
  AND default_params = '{"duration": 2}'::jsonb;

COMMIT;
