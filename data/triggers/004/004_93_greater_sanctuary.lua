-- Trigger: Greater Sanctuary
-- Zone: 4, ID: 93
-- Type: OBJECT, Flags: LOOK
-- Status: CLEAN
--
-- Original DG Script: #493

-- Converted from DG Script #493: Greater Sanctuary
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if string.find(arg, "greater_sanctuary") or string.find(arg, "greater_sanc") then
    _return_value = false
    actor:send("This quest is not yet available in game.")
    actor:send("Petition the gods for a quest.")
end
return _return_value