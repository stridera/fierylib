-- Trigger: mdamage
-- Zone: 488, ID: 10
-- Type: OBJECT, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #48810

-- Converted from DG Script #48810: mdamage
-- Original: OBJECT trigger, flags: COMMAND, probability: 3%

-- 3% chance to trigger
if not percent_chance(3) then
    return true
end

-- Command filter: mdamage
if not (cmd == "mdamage") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
if (actor.id > 0) and not (actor:has_effect(Effect.Charm)) then
    actor:damage(arg)
else
    _return_value = false
end
return _return_value