-- Trigger fixes: Lua wait_ticks(n) is renamed wait_hours(n) (fierymud-rs #163); a MUD hour is 75 s and not a MUD tick, so the old name was mislabeled.
--
-- ORDER: apply AFTER 2026-10-15-wait-switch-fixes.sql (and, on prod, 2026-10-15-wait-switch-drift.sql):
-- the md5 guards below are the post-2d49615 bodies, so on a database that has not had
-- those patches the guard matches nothing and no row is touched.
-- DEPLOY COUPLING: ship together with the fierymud-rs engine rename (wait_ticks -> wait_hours,
-- no alias). Old engine + this patch: wait_hours is undefined; new engine without this
-- patch: wait_ticks is undefined. Either way the script errors, so deploy both together.
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
  -- data/triggers/117/117_00_11765_to_11766_south_exit.lua
  (117, 0, $trig$-- Converted from DG Script #11700: 11765_to_11766_south_exit
-- Original: WORLD trigger, flags: COMMAND, probability: 100%

-- Command filter: wave fog
if not (cmd == "wave" or cmd == "fog") then
    return true  -- Not our command
end
get_room(117, 65):exit("south"):set_state({hidden = false})
get_room(117, 65):exit("south"):set_state({description = "A wall of fog is parted to the south, allowing passage."})
get_room(117, 65):exit("south"):set_state({name = "mistwall mistdoor"})
self.room:send_except(actor, tostring(actor.name) .. " waves " .. tostring(actor.possessive) .. " hands around causing the fog south to dissipate allowing passage.")
actor:send("By moving your hands you clear a passage through the fog to the south.")
get_room(117, 66):at(function()
    self.room:send("The fog to the north clears a little.")
end)
-- Legacy `wait 1 tick`: one game hour (75s).
wait_hours(1)
self.room:send("The fog slowly closes back around the exit to the south.")
get_room(117, 65):exit("south"):set_state({hidden = true})$trig$, 'ac6d9081f844a3cfcb7eafeadb586a0e'),
  -- data/triggers/533/533_06_frost_valley_entrance.lua
  (533, 6, $trig$-- Command filter: push
if cmd ~= "push" then
    return true  -- Not our command
end
get_room(533, 2):exit("west"):set_state({hidden = false})
get_room(533, 2):exit("west"):set_state({description = "The piles of ice slips allowing passage."})
get_room(533, 2):exit("west"):set_state({name = "ice"})
self.room:send_except(actor, tostring(actor.name) .. " pushes some ice out of the way, opening a passage down the western tunnel.")
actor:send("It took some effort, but the wall of ice has been moved from the west, allowing passage.")
get_room(534, 1):at(function()
    self.room:send("The ice falls from the east allowing passage.")
end)
wait_hours(1)
self.room:send("The ice seems to magically reform blocking the western passage.")
get_room(533, 2):exit("west"):set_state({hidden = true})$trig$, '676ab51a6a356b8cb84d1ca550f50346')
) AS v(zone_id, id, commands, old_md5)
WHERE t.zone_id = v.zone_id
  AND t.id = v.id
  AND md5(t.commands) = v.old_md5
  AND t.commands IS DISTINCT FROM v.commands;

COMMIT;
