-- Trigger: finger_trap_remove
-- Zone: 31, ID: 14
-- Type: OBJECT, Flags: REMOVE
-- Status: CLEAN
--
-- Original DG Script: #3114

-- Converted from DG Script #3114: finger_trap_remove
-- Original: OBJECT trigger, flags: REMOVE, probability: 100%
local _return_value = true  -- Default: allow action
if actor.level < 100 then
    if random(1, 200) > actor.real_int then
        _return_value = false
        self.room:send_except(actor, tostring(actor.name) .. " struggles, trying to remove a finger trap!")
        actor:send("You struggle, but can't seem to remove the finger trap!")
    end
end
return _return_value