-- Trigger: Hearthsong progress journal
-- Zone: 4, ID: 88
-- Type: OBJECT, Flags: LOOK
-- Status: CLEAN
--
-- Original DG Script: #488

-- Converted from DG Script #488: Hearthsong progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if string.find(arg, "Hearthsong") or string.find(arg, "hearth") then
    _return_value = false
    actor:send("This quest is not yet available in game.")
    actor:send("Petition the gods for a quest.")
end
return _return_value