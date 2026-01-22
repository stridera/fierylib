-- Trigger: Death_reload
-- Zone: 83, ID: 3
-- Type: MOB, Flags: DEATH
-- Status: CLEAN
--
-- Original DG Script: #8303

-- Converted from DG Script #8303: Death_reload
-- Original: MOB trigger, flags: DEATH, probability: 100%
get_room(84, 23):at(function()
    self.room:spawn_mobile(83, 9)
end)