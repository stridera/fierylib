-- Trigger: anti_thief_obj_trigger
-- Zone: 87, ID: 50
-- Type: OBJECT, Flags: WEAR
-- Status: CLEAN
--
-- Original DG Script: #8750

-- Converted from DG Script #8750: anti_thief_obj_trigger
-- Original: OBJECT trigger, flags: WEAR, probability: 100%
local _return_value = true  -- Default: allow action
if string.find(actor.class, "thief") then
    _return_value = false
    actor:send("You cannot use " .. tostring(self.shortdesc) .. ".")
else
    _return_value = true
end
return _return_value