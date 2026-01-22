-- Trigger: belial_quest_start
-- Zone: 22, ID: 40
-- Type: MOB, Flags: GREET_ALL
-- Status: CLEAN
--
-- Original DG Script: #2240

-- Converted from DG Script #2240: belial_quest_start
-- Original: MOB trigger, flags: GREET_ALL, probability: 100%
-- Set the quest in motion, prevent retriggering stages
-- until completion or reboot/crash/etc.
if belial_queue then
    run_room_trigger(2242)
else
    local belial_queue = 1
    globals.belial_queue = globals.belial_queue or true
    run_room_trigger(2241)
end