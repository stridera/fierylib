-- Trigger: Major Sanctuary progress journal
-- Zone: 4, ID: 92
-- Type: OBJECT, Flags: LOOK
-- Status: CLEAN
--
-- Original DG Script: #492

-- Converted from DG Script #492: Major Sanctuary progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if string.find(arg, "major_sanctuary") or string.find(arg, "major_sanc") then
    _return_value = false
    actor:send("This quest is not yet available in game.")
    actor:send("Petition the gods for a quest.")
end
return _return_value