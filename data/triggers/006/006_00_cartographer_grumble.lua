-- Trigger: Cartographer grumble
-- Zone: 6, ID: 0
-- Type: MOB, Flags: RANDOM
-- Status: CLEAN
--
-- Original DG Script: #600

-- Converted from DG Script #600: Cartographer grumble
-- Original: MOB trigger, flags: RANDOM, probability: 5%

-- 5% chance to trigger
if not percent_chance(5) then
    return true
end
if self.id == 600 then
    self.room:send(tostring(self.name) .. " mutters something about his memory fading...")
elseif self.id == 603 then
    self:say("What do you want?  I don't have all day.")
end