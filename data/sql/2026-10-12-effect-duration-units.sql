-- Effect defaults with a "duration" but no "durationUnit" (the fierymud-rs loader logs a WARN
-- at boot listing them; the engine reads a unit-less duration as MUD hours, 75 s each).
--
-- Eleven of the twelve are spell/skill-style durations that legacy expresses in MUD hours and
-- that were already being read as hours, so they are pinned to "hours" with the SAME value
-- (no behaviour change, just explicit). Most referencing abilities override duration+unit
-- anyway (modify/status/room/summon: nearly all carry "durationUnit":"hours"); drag, intercept,
-- redirect, conceal_item and portal have no duration in legacy (portals use object decay) so
-- their defaults are effectively unused. "Refreshed" is the exception: its 1800 is the 30-minute
-- window (REFRESHED_DURATION_SECS in fierymud-rs rest.rs), so its unit is "seconds"; read as
-- hours it would be 26 real hours. No VALUE changes.
--
-- Idempotent: each UPDATE is guarded on the exact untouched default, so builder edits in Muditor
-- are never overwritten and a second run changes 0 rows.
-- Keep in sync with data/effects.json (defaultParams of each effect named below).

BEGIN;

UPDATE "Effect"
SET default_params = '{"target": "str", "amount": 4, "duration": "level", "durationUnit": "hours"}'::jsonb
WHERE name = 'modify'
  AND default_params = '{"target": "str", "amount": 4, "duration": "level"}'::jsonb;

UPDATE "Effect"
SET default_params = '{"flag": "bless", "duration": "level * 2", "durationUnit": "hours"}'::jsonb
WHERE name = 'status'
  AND default_params = '{"flag": "bless", "duration": "level * 2"}'::jsonb;

UPDATE "Effect"
SET default_params = '{"form": "wolf", "duration": "level * 2", "durationUnit": "hours"}'::jsonb
WHERE name = 'transform'
  AND default_params = '{"form": "wolf", "duration": "level * 2"}'::jsonb;

UPDATE "Effect"
SET default_params = '{"mobType": "elemental", "duration": 100, "maxCount": 1, "durationUnit": "hours"}'::jsonb
WHERE name = 'summon'
  AND default_params = '{"mobType": "elemental", "duration": 100, "maxCount": 1}'::jsonb;

UPDATE "Effect"
SET default_params = '{"maxCircle": 3, "duration": "level", "durationUnit": "hours"}'::jsonb
WHERE name = 'globe'
  AND default_params = '{"maxCircle": 3, "duration": "level"}'::jsonb;

UPDATE "Effect"
SET default_params = '{"subtype": "effect", "type": "darkness", "duration": 10, "durationUnit": "hours"}'::jsonb
WHERE name = 'room'
  AND default_params = '{"subtype": "effect", "type": "darkness", "duration": 10}'::jsonb;

UPDATE "Effect"
SET default_params = '{"duration": 1, "durationUnit": "hours"}'::jsonb
WHERE name = 'drag'
  AND default_params = '{"duration": 1}'::jsonb;

UPDATE "Effect"
SET default_params = '{"duration": "level", "chance": 100, "durationUnit": "hours"}'::jsonb
WHERE name = 'intercept'
  AND default_params = '{"duration": "level", "chance": 100}'::jsonb;

UPDATE "Effect"
SET default_params = '{"type": "two-way", "duration": 10, "durationUnit": "hours"}'::jsonb
WHERE name = 'portal'
  AND default_params = '{"type": "two-way", "duration": 10}'::jsonb;

UPDATE "Effect"
SET default_params = '{"duration": "level * 10", "durationUnit": "hours"}'::jsonb
WHERE name = 'conceal_item'
  AND default_params = '{"duration": "level * 10"}'::jsonb;

UPDATE "Effect"
SET default_params = '{"percent": 50, "duration": "level", "durationUnit": "hours"}'::jsonb
WHERE name = 'redirect'
  AND default_params = '{"percent": 50, "duration": "level"}'::jsonb;

UPDATE "Effect"
SET default_params = '{"duration": 1800, "durationUnit": "seconds"}'::jsonb
WHERE name = 'Refreshed'
  AND default_params = '{"duration": 1800}'::jsonb;

COMMIT;
