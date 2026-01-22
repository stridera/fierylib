-- Trigger: Group Recall progress journal
-- Zone: 4, ID: 98
-- Type: OBJECT, Flags: LOOK
-- Status: CLEAN
--
-- Original DG Script: #498

-- Converted from DG Script #498: Group Recall progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if string.find(arg, "group_recall") then
    if actor.level >= 65 and string.find(actor.class, "Cleric") then
        _return_value = false
        actor:send("This quest is not yet available in game.")
        actor:send("Petition the gods for a quest.")
    end
end
return _return_value