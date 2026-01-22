-- Trigger: Greater Displacement progress journal
-- Zone: 4, ID: 91
-- Type: OBJECT, Flags: LOOK
-- Status: CLEAN
--
-- Original DG Script: #491

-- Converted from DG Script #491: Greater Displacement progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if string.find(arg, "greater") displacement or string.find(arg, "displacement") then
    _return_value = false
    actor:send("This quest is not yet available in game.")
    actor:send("Petition the gods for a quest.")
end
return _return_value