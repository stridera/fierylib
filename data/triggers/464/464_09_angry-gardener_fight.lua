-- Trigger: angry-gardener_fight
-- Zone: 464, ID: 9
-- Type: MOB, Flags: FIGHT
-- Status: CLEAN
--
-- Original DG Script: #46409

-- Converted from DG Script #46409: angry-gardener_fight
-- Original: MOB trigger, flags: FIGHT, probability: 20%

-- 20% chance to trigger
if not percent_chance(20) then
    return true
end
self:command("snarl " .. tostring(actor.name))
actor.name:send(self.name .. " tells you, '" .. "I will kill you." .. "'")