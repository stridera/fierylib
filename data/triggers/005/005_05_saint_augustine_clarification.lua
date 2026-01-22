-- Trigger: Saint Augustine clarification
-- Zone: 5, ID: 5
-- Type: OBJECT, Flags: LOOK
-- Status: NEEDS_REVIEW
--   Complex nesting: 6 if statements
--
-- Original DG Script: #505

-- Converted from DG Script #505: Saint Augustine clarification
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if arg == "saint" or arg == "augustine" or arg == "saint augustine" then
    if actor.level >= 30 and string.find(actor.class, "Monk") then
        _return_value = false
        actor:send("Please specify:")
        if actor.level >= 30 then
            actor:send("Tremors of Saint Augustine")
        end
        if actor.level >= 40 then
            actor:send("Tempest of Saint Augustine")
        end
        if actor.level >= 50 then
            actor:send("Blizzards of Saint Augustine")
        end
        if actor.level >= 80 then
            actor:send("Fires of Saint Augustine")
        end
    end
end
return _return_value