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
    if actor.level >= 50 and (string.find(actor.class, "priest") or string.find(actor.class, "cleric") or string.find(actor.class, "diabolist")) then
        _return_value = true
        actor:send("Please specify:")
        actor:send("Group Heal")
        if string.find(actor.class, "priest") or (actor.level >= 65 and string.find(actor.class, "cleric")) then
            actor:send("Group Armor")
        end
        if actor.level >= 65 and string.find(actor.class, "cleric") then
            actor:send("Group Recall")
        end
    end
end
return _return_value