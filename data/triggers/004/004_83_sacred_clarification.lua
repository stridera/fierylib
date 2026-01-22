-- Trigger: Sacred clarification
-- Zone: 4, ID: 83
-- Type: OBJECT, Flags: LOOK
-- Status: CLEAN
--
-- Original DG Script: #483

-- Converted from DG Script #483: Sacred clarification
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if arg == "sacred" then
    if actor.level >= 25 then
        _return_value = false
        actor:send("Please specify:")
        actor:send("Infiltrate the Sacred Haven")
        if actor.level >= 50 then
            actor:send("The Great Rite")
        end
    end
end
return _return_value