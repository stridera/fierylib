-- Trigger: Rhode's Pool of Blood
-- Zone: 30, ID: 91
-- Type: OBJECT, Flags: WEAR
-- Status: CLEAN
--
-- Original DG Script: #3091

-- Converted from DG Script #3091: Rhode's Pool of Blood
-- Original: OBJECT trigger, flags: WEAR, probability: 100%
local _return_value = true  -- Default: allow action
wait(15)
self.room:send(tostring(self.shortdesc) .. "  creates a small pool of blood on the ground.")
if actor.id == -1 then
    self.room:spawn_object(1000, 34)
end
wait(2)
_return_value = false
return _return_value