-- Trigger: Witch_rand1
-- Zone: 105, ID: 1
-- Type: MOB, Flags: RANDOM
-- Status: CLEAN
--
-- Original DG Script: #10501

-- Converted from DG Script #10501: Witch_rand1
-- Original: MOB trigger, flags: RANDOM, probability: 17%

-- 17% chance to trigger
if not percent_chance(17) then
    return true
end
self.room:send("</>The <green>witchwoman</> looks at you then turns away with a look of disappointment.</>")
self:command("sigh")