-- Trigger: Anduin_pasture_cow_moo
-- Zone: 69, ID: 1
-- Type: MOB, Flags: RANDOM
-- Status: CLEAN
--
-- Original DG Script: #6901

-- Converted from DG Script #6901: Anduin_pasture_cow_moo
-- Original: MOB trigger, flags: RANDOM, probability: 25%

-- 25% chance to trigger
if not percent_chance(25) then
    return true
end
-- moo
self.room:send(tostring(self.name) .. " moos.")
self.room:send_to_adjacent("You hear loud moo'ing nearby.")