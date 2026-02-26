-- Trigger: ice elemental lord - fight
-- Zone: 484, ID: 230
-- Type: MOB, Flags: FIGHT
-- Status: CLEAN
--
-- Original DG Script: #48630

-- Converted from DG Script #48630: ice elemental lord - fight
-- Original: MOB trigger, flags: FIGHT, probability: 100%
local chance = random(1, 10)
if chance > 5 then
    wait(2)
    run_room_trigger(484, 231)
end