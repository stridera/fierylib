-- Trigger: temptest-eq-drop
-- Zone: 238, ID: 21
-- Type: MOB, Flags: DEATH
-- Status: CLEAN
--
-- Original DG Script: #23821

-- Converted from DG Script #23821: temptest-eq-drop
-- Original: MOB trigger, flags: DEATH, probability: 100%
local _return_value = true  -- Default: allow action
_return_value = false
self.room:spawn_object(238, 25)
self:command("drop pants")
return _return_value