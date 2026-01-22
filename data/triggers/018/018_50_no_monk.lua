-- Trigger: no_monk
-- Zone: 18, ID: 50
-- Type: OBJECT, Flags: WEAR
-- Status: CLEAN
--
-- Original DG Script: #1850

-- Converted from DG Script #1850: no_monk
-- Original: OBJECT trigger, flags: WEAR, probability: 100%
local _return_value = true  -- Default: allow action
if string.find(actor.class, "Monk") then
    actor:send("You cannot use  " .. tostring(self.shortdesc) .. ".")
    _return_value = false
end
return _return_value