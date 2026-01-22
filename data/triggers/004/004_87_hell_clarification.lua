-- Trigger: Hell clarification
-- Zone: 4, ID: 87
-- Type: OBJECT, Flags: LOOK
-- Status: CLEAN
--
-- Original DG Script: #487

-- Converted from DG Script #487: Hell clarification
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if arg == "hell" then
    if string.find(actor.class, "Diabolist") then
        _return_value = false
        actor:send("Please specify:")
        actor:send("Hellfire and Brimstone")
        actor:send("Infernal Weaponry")
        actor:send("Hell Gate")
    end
end
return _return_value