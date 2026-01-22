-- Trigger: Enrapture progress journal
-- Zone: 4, ID: 90
-- Type: OBJECT, Flags: LOOK
-- Status: CLEAN
--
-- Original DG Script: #490

-- Converted from DG Script #490: Enrapture progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if string.find(arg, "entrapture") then
    _return_value = false
    actor:send("This quest is not yet available in game.")
    actor:send("Petition the gods for a quest.")
end
return _return_value