-- Trigger: Eye peck
-- Zone: 0, ID: 16
-- Type: MOB, Flags: FIGHT
-- Status: CLEAN
--
-- Original DG Script: #16

-- Converted from DG Script #16: Eye peck
-- Original: MOB trigger, flags: FIGHT, probability: 10%

-- 10% chance to trigger
if not percent_chance(10) then
    return true
end
actor:send(self.name .. " pecks out your eyes!")
self.room:send_except(actor, self.name .. " pecks out " .. actor.name .. "'s eyes!")