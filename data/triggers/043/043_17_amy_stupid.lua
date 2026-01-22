-- Trigger: amy_stupid
-- Zone: 43, ID: 17
-- Type: MOB, Flags: RANDOM
-- Status: CLEAN
--
-- Original DG Script: #4317

-- Converted from DG Script #4317: amy_stupid
-- Original: MOB trigger, flags: RANDOM, probability: 10%

-- 10% chance to trigger
if not percent_chance(10) then
    return true
end
self:emote("scoffs.")
wait(3)
self.room:send(tostring(self.name) .. " says, 'My sister is so freaking stupid.  She has no idea what's going")
self.room:send("</>on.  Why can't she be a better person, like me?'")
wait(4)
self:emote("mumbles something about being from the deep end of the gene pool.")