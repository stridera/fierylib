-- 520:2 burning branch destroys itself (world.destroy) wherever it is
--
-- Idempotent: a row already holding the new body is left alone, so rerunning
-- updates nothing. Keyed by the composite primary key (zone_id, id).
-- Guarded: a row is only touched while it still holds the previous committed
-- body (md5), so rows edited in Muditor since then are left alone.

BEGIN;

UPDATE "Triggers" AS t
SET commands = v.commands,
    updated_at = now()
FROM (VALUES
  -- data/triggers/520/520_02_break_burning_branch.lua
  (520, 2, $trig$-- Converted from DG Script #52002: break_burning_branch
-- Original: OBJECT trigger, flags: DROP, probability: 100%
wait(1)
self.room:send("The branch cracks and breaks into 3 pieces!")
self.room:spawn_object(520, 35)
self.room:spawn_object(520, 35)
self.room:spawn_object(520, 35)
-- Legacy `opurge burning-branch` matches the script's own object by keyword wherever it is
-- (floor, bag, hand); find_object only sees the room floor, so a branch put in a bag survived
-- and the embers duplicated on every put/get.
world.destroy(self)$trig$, '2780f426597cbbf1a6b4030e2fde8350')
) AS v(zone_id, id, commands, old_md5)
WHERE t.zone_id = v.zone_id
  AND t.id = v.id
  AND md5(t.commands) = v.old_md5
  AND t.commands IS DISTINCT FROM v.commands;

COMMIT;
