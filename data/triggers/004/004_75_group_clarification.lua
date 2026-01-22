-- Trigger: Group clarification
-- Zone: 4, ID: 75
-- Type: OBJECT, Flags: LOOK
-- Status: CLEAN
--
-- Original DG Script: #475

-- Converted from DG Script #475: Group clarification
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if arg == "group" then
    if actor.level >= 50 and (string.find(actor.class, "Priest") or string.find(actor.class, "Cleric") or string.find(actor.class, "Diabolist")) then
        _return_value = false
        actor:send("Please specify:")
        actor:send("Group Heal")
        if string.find(actor.class, "Priest") or (actor.level >= 65 and string.find(actor.class, "Cleric")) then
            actor:send("Group Armor")
        end
        if actor.level >= 65 and string.find(actor.class, "Cleric") then
            actor:send("Group Recall")
        end
    end
end
return _return_value