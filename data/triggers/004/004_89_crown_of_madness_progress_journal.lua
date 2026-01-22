-- Trigger: Crown of Madness progress journal
-- Zone: 4, ID: 89
-- Type: OBJECT, Flags: LOOK
-- Status: CLEAN
--
-- Original DG Script: #489

-- Converted from DG Script #489: Crown of Madness progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if string.find(arg, "crown") or string.find(arg, "madness") or string.find(arg, "crown") of madness then
    _return_value = false
    actor:send("This quest is not yet available in game.")
    actor:send("Petition the gods for a quest.")
end
return _return_value