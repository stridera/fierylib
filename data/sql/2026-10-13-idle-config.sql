-- Idle-timeout config (fierymud-rs commit 7adfb1a).
--
-- fierymud-rs no longer reads GameConfig server.connection_timeout_seconds. Idle handling now
-- follows legacy (600s -> void, 900s -> auto-rent) with optional overrides:
--   server.idle_void_seconds   (default 600)
--   server.idle_rent_seconds   (default 900)
--
-- This patch deletes the stale row and inserts the two new keys only if absent (an existing
-- value, e.g. one edited in Muditor, is never overwritten).
--
-- Idempotent: a second run changes 0 rows.
BEGIN;

DELETE FROM "GameConfig"
 WHERE category = 'server' AND key = 'connection_timeout_seconds';

INSERT INTO "GameConfig" (category, key, value, value_type, description, min_value, max_value, is_secret, restart_req, updated_at)
SELECT v.category, v.key, v.value, 'INT'::"ConfigValueType", v.description, '60', '86400', false, false, now()
  FROM (VALUES
    ('server', 'idle_void_seconds', '600', 'Seconds idle before a player is pulled into the void'),
    ('server', 'idle_rent_seconds', '900', 'Seconds idle before a player is auto-rented out')
  ) AS v(category, key, value, description)
 WHERE NOT EXISTS (
    SELECT 1 FROM "GameConfig" g WHERE g.category = v.category AND g.key = v.key
 );

COMMIT;
