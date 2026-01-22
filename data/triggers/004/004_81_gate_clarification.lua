-- Trigger: Gate clarification
-- Zone: 4, ID: 81
-- Type: OBJECT, Flags: LOOK
-- Status: CLEAN
--
-- Original DG Script: #481

-- Converted from DG Script #481: Gate clarification
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if arg == "gate" then
    if actor.level >= 75 and (string.find(actor.class, "Priest") or string.find(actor.class, "Diabolist")) then
        _return_value = false
        actor:send("Please specify:")
        if string.find(actor.class, "Priest") then
            actor:send("Heavens Gate")
        end
        if string.find(actor.class, "Diabolist") then
            actor:send("Hell Gate")
        end
    end
end
return _return_value