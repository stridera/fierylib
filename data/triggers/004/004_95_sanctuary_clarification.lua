-- Trigger: sanctuary clarification
-- Zone: 4, ID: 95
-- Type: OBJECT, Flags: LOOK
-- Status: CLEAN
--
-- Original DG Script: #495

-- Converted from DG Script #495: sanctuary clarification
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if arg == "sanctuary" or arg == "sanc" then
    local majorsancclasses = "Cleric Priest Diabolist Paladin Anti-Paladin"
    local greatersancclasses = "Cleric Priest Diabolist"
    if string.find(majorsancclasses, "actor.class") then
        _return_value = false
        actor:send("Please specify:")
        if actor.level >= 75 then
            actor:send("Major Sanctuary")
        end
        if actor.level >= 85 and string.find(greatersancclasses, "actor.class") then
            actor:send("Greater Sanctuary")
        end
    end
end
return _return_value