-- Trigger: fv_Aeron_greet
-- Zone: 534, ID: 8
-- Type: MOB, Flags: GREET
-- Status: CLEAN
--
-- Original DG Script: #53408

-- Converted from DG Script #53408: fv_Aeron_greet
-- Original: MOB trigger, flags: GREET, probability: 20%

-- 20% chance to trigger
if not percent_chance(20) then
    return true
end
actor:send(tostring(self.name) .. " tells you, 'Hello Traveler, my name is Aeron.'")
self:emote("turns a page in his book.")