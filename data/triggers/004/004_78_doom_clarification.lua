-- Trigger: Doom clarification
-- Zone: 4, ID: 78
-- Type: OBJECT, Flags: LOOK
-- Status: CLEAN
--
-- Original DG Script: #478

-- Converted from DG Script #478: Doom clarification
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if arg == "doom" then
    if (actor.level >= 75 and string.find(actor.class, "Druid")) or actor.level >= 85 then
        _return_value = false
        actor:send("Please Specify:")
        if actor.level >= 75 and string.find(actor.class, "Druid") then
            actor:send("Creeping Doom")
        end
        if actor.level >= 85 then
            actor:send("The Planes of Doom")
        end
    end
end
return _return_value