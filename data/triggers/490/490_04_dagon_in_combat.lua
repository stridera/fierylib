-- Trigger: dagon_in_combat
-- Zone: 490, ID: 4
-- Type: MOB, Flags: FIGHT
-- Status: CLEAN
--
-- Original DG Script: #49004

-- Converted from DG Script #49004: dagon_in_combat
-- Original: MOB trigger, flags: FIGHT, probability: 100%
if dagonisweak ~= 1 then
    run_room_trigger(49005)
end