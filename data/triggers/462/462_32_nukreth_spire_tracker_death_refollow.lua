-- Trigger: Nukreth Spire tracker death refollow
-- Zone: 462, ID: 32
-- Type: MOB, Flags: DEATH
-- Status: CLEAN
--
-- Original DG Script: #46232

-- Converted from DG Script #46232: Nukreth Spire tracker death refollow
-- Original: MOB trigger, flags: DEATH, probability: 100%
if world.count_mobiles("46201") == 1 then
    run_room_trigger(46233)
end