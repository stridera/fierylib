-- Trigger: Island, Isle clarification
-- Zone: 4, ID: 82
-- Type: OBJECT, Flags: LOOK
-- Status: CLEAN
--
-- Original DG Script: #482

-- Converted from DG Script #482: Island, Isle clarification
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if arg == "island" or arg == "isle" then
    if actor.level >= 35 then
        _return_value = false
        actor:send("Please specify:")
        if actor.level >= 35 then
            actor:send("Liberate Fiery Island")
        end
        if actor.level >= 45 then
            actor:send("Destroy the Cult of the Griffin")
        end
    end
end
return _return_value