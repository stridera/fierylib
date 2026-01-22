-- Trigger: Major Paralysis progress journal
-- Zone: 4, ID: 84
-- Type: OBJECT, Flags: LOOK
-- Status: CLEAN
--
-- Original DG Script: #484

-- Converted from DG Script #484: Major Paralysis progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if string.find(arg, "major_paralysis") or string.find(arg, "paralysis") then
    _return_value = false
    actor:send("This quest is not yet available in game.")
    actor:send("Petition the gods for a quest.")
end
return _return_value