-- Trigger: death_of_dagon
-- Zone: 490, ID: 6
-- Type: MOB, Flags: DEATH
-- Status: CLEAN
--
-- Original DG Script: #49006

-- Converted from DG Script #49006: death_of_dagon
-- Original: MOB trigger, flags: DEATH, probability: 100%
local _return_value = true  -- Default: allow action
_return_value = false
self.room:send("Dagon utters a blood curdling scream as his demonic spirit returns to its realm.")
run_room_trigger(49007)
if not (world.count_mobiles("49010")) then
    get_room(491, 90):at(function()
        self.room:spawn_mobile(490, 10)
    end)
    get_room(491, 90):at(function()
        self.room:find_actor("adramalech"):spawn_object(490, 34)
    end)
end
return _return_value