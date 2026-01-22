-- Trigger: sagece-dead
-- Zone: 520, ID: 52
-- Type: MOB, Flags: DEATH
-- Status: CLEAN
--
-- Original DG Script: #52052

-- Converted from DG Script #52052: sagece-dead
-- Original: MOB trigger, flags: DEATH, probability: 100%
get_room(520, 93):at(function()
    run_room_trigger(52054)
end)