-- Trigger: gnome_king_random
-- Zone: 43, ID: 5
-- Type: MOB, Flags: RANDOM
-- Status: CLEAN
--
-- Original DG Script: #4305

-- Converted from DG Script #4305: gnome_king_random
-- Original: MOB trigger, flags: RANDOM, probability: 15%

-- 15% chance to trigger
if not percent_chance(15) then
    return true
end
self:command("grumble")
wait(1)
self:say("I sure hope we rounded up the last of those stupid monkeys...")