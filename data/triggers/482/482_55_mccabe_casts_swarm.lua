-- Trigger: Mccabe casts swarm
-- Zone: 482, ID: 55
-- Type: MOB, Flags: RANDOM
-- Status: CLEAN
--
-- Original DG Script: #48255

-- Converted from DG Script #48255: Mccabe casts swarm
-- Original: MOB trigger, flags: RANDOM, probability: 30%

-- 30% chance to trigger
if not percent_chance(30) then
    return true
end
run_room_trigger(48257)
wait(10)