-- Trigger: tight fitting armor
-- Zone: 625, ID: 70
-- Type: OBJECT, Flags: WEAR
-- Status: CLEAN
--
-- Original DG Script: #62570

-- Converted from DG Script #62570: tight fitting armor
-- Original: OBJECT trigger, flags: WEAR, probability: 100%
local _return_value = true  -- Default: allow action
if actor.size == "tiny" or actor.size == "small" or actor.size == "medium" then
    _return_value = true
else
    _return_value = false
    actor:send("It's too small for you!")
    self.room:send_except(actor, tostring(actor.name) .. " struggles and fails to squeeze into " .. tostring(self.shortdesc) .. ".")
end
return _return_value