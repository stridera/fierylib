-- Trigger: fv_Aeron_entry
-- Zone: 534, ID: 9
-- Type: MOB, Flags: ENTRY
-- Status: CLEAN
--
-- Original DG Script: #53409

-- Converted from DG Script #53409: fv_Aeron_entry
-- Original: MOB trigger, flags: ENTRY, probability: 10%

-- 10% chance to trigger
if not percent_chance(10) then
    return true
end
local rnd = room.actors[random(1, #room.actors)]
if rnd.id == -1 then
    self.room:send_except(rnd, tostring(self.name) .. " glances up at " .. tostring(rnd.name) .. " then goes back to reading.")
    rnd:send(tostring(self.name) .. " glances up at you then goes back to reading.")
else
end