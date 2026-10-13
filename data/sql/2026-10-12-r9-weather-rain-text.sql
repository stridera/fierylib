-- Playtest r9 #19: the rain weather-change line carried a non-ASCII em dash that the telnet
-- output drops, leaving "The rain picks up  a steady downpour." (double space, missing word).
-- Only the untouched seed text is replaced; a line edited in Muditor is left alone. Idempotent.

BEGIN;

UPDATE "SystemMessage"
SET messages = ARRAY['The <cyan>rain</> picks up into a steady <cyan>downpour</>.']::text[]
WHERE key = 'weather_change_rain'
  AND messages = ARRAY['The <cyan>rain</> picks up — a steady <cyan>downpour</>.']::text[];

COMMIT;
