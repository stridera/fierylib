-- Trigger: black_glow
-- Zone: 200, ID: 1
-- Type: OBJECT, Flags: WEAR
-- Status: CLEAN
--
-- Original DG Script: #20001

-- Converted from DG Script #20001: black_glow
-- Original: OBJECT trigger, flags: WEAR, probability: 100%
local _return_value = true  -- Default: allow action
self.room:send(tostring(self.shortdesc) .. " emitts a dark glow through out the room.")
wait(2)
_return_value = false
return _return_value