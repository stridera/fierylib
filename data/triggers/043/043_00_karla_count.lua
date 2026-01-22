-- Trigger: karla_count
-- Zone: 43, ID: 0
-- Type: MOB, Flags: RANDOM
-- Status: CLEAN
--
-- Original DG Script: #4300

-- Converted from DG Script #4300: karla_count
-- Original: MOB trigger, flags: RANDOM, probability: 15%

-- 15% chance to trigger
if not percent_chance(15) then
    return true
end
self:emote("takes a deep breath")
wait(3)
self:say("Here we go!  5, 6, 7, 8!")
wait(2)
self:emote("executes a flawless combination of steps.")
wait(1)
self:command("nod")
self:say("Okay, I think I got it.")