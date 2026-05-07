-- Trigger: Eye peck
-- Zone: 0, ID: 16
-- Type: MOB, Flags: FIGHT
-- Status: CLEAN
--
-- Original DG Script: #16
-- 10% chance per fight tick to peck the opponent's eyes out.

-- 10% chance to trigger
if not percent_chance(10) then
    return true
end

actor:send(tostring(self.name) .. " pecks out your eyes!")
self.room:send_except(actor, tostring(self.name) .. " pecks out " .. tostring(actor.name) .. "'s eyes!")
