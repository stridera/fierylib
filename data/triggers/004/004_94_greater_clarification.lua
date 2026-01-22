-- Trigger: greater clarification
-- Zone: 4, ID: 94
-- Type: OBJECT, Flags: LOOK
-- Status: CLEAN
--
-- Original DG Script: #494

-- Converted from DG Script #494: greater clarification
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if arg == "greater" then
    _return_value = false
    actor:send("Please specify:")
    if string.find(actor.class, "ranger") then
        actor:send("Greater Displacement")
    end
    if string.find(actor.class, "cleric") or string.find(actor.class, "priest") or string.find(actor.class, "diabolist") then
        actor:send("Greater Sanctuary")
    end
end
return _return_value