-- Trigger: Random_Wind_Damage
-- Zone: 521, ID: 12
-- Type: WORLD, Flags: RANDOM
-- Status: NEEDS_REVIEW
--
-- Original DG Script: #52112
-- TODO: Original DG branched on a `damage_dealt` variable populated by the
-- damage command (e.g. zero when resisted). Lua actor:damage() returns
-- nothing, so the resist branch ("seems to soothe") is no longer reachable.
-- A future runtime addition that returns dealt damage would let us restore
-- the soothe/chill split. For now we always emit the chill message.

-- 25% chance to trigger
if not percent_chance(25) then
    return true
end
-- WORLD/RANDOM triggers fire without an `actor` — pick a random occupant.
if not room or not room.actors or #room.actors == 0 then
    return true
end
wait(1)
local rndm = room.actors[random(1, #room.actors)]
if not rndm then
    return true
end
local dmg = 65
rndm:damage(dmg)  -- type: cold
rndm:send("A strong gust blows in from the north, giving you an awful chill. (<red>" .. tostring(dmg) .. "</>)")
self.room:send_except(rndm, "A strong gust blows in from the north, which seems to chill " .. rndm.name .. ". (<blue>" .. tostring(dmg) .. "</>)")