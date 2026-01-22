-- Trigger: lena_place
-- Zone: 43, ID: 18
-- Type: MOB, Flags: RANDOM
-- Status: CLEAN
--
-- Original DG Script: #4318

-- Converted from DG Script #4318: lena_place
-- Original: MOB trigger, flags: RANDOM, probability: 10%

-- 10% chance to trigger
if not percent_chance(10) then
    return true
end
self:emote("screams, 'No, that's NOT where you're supposed to be!'")
wait(5)
self:emote("points vehemently to a spot on the floor.")
wait(3)
self:say("THIS is where you're supposed to be!")
wait(5)
self:command("scream")
wait(4)
self.room:send(tostring(self.name) .. " says, 'God!  Why does no one know what they're supposed to be doing")
self.room:send("</>but me?!'")