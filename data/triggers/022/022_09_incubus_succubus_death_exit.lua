-- Trigger: Incubus_Succubus_Death_Exit
-- Zone: 22, ID: 9
-- Type: MOB, Flags: DEATH
-- Status: CLEAN
--
-- Original DG Script: #2209

-- Converted from DG Script #2209: Incubus_Succubus_Death_Exit
-- Original: MOB trigger, flags: DEATH, probability: 100%
if world.count_mobiles("2210") + world.count_mobiles("2211") == 1 then
    run_room_trigger(2218)
end