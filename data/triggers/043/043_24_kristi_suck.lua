-- Trigger: kristi_suck
-- Zone: 43, ID: 24
-- Type: MOB, Flags: RANDOM
-- Status: CLEAN
--
-- Original DG Script: #4324

-- Converted from DG Script #4324: kristi_suck
-- Original: MOB trigger, flags: RANDOM, probability: 10%

-- 10% chance to trigger
if not percent_chance(10) then
    return true
end
self:command("sigh")
wait(3)
self.room:send(tostring(self.name) .. " says, 'Sometimes the world just sucks you know?  No matter what you")
self.room:send("</>do, it's just a terrible place to be.'")
wait(4)
self:command("sigh")
wait(3)
self:say("If only everyone would stop being oh so cruel to me!")