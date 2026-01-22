-- Trigger: mheal
-- Zone: 488, ID: 11
-- Type: OBJECT, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #48811

-- Converted from DG Script #48811: mheal
-- Original: OBJECT trigger, flags: COMMAND, probability: 3%

-- 3% chance to trigger
if not percent_chance(3) then
    return true
end

-- Command filter: mheal
if not (cmd == "mheal") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
if (actor.id > 0) and not (actor:has_effect(Effect.Charm)) then
    actor:heal(arg)
else
    _return_value = false
end
return _return_value