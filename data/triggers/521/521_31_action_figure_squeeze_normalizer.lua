-- Trigger: action_figure_squeeze_normalizer
-- Zone: 521, ID: 31
-- Type: OBJECT, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #52131

-- Converted from DG Script #52131: action_figure_squeeze_normalizer
-- Original: OBJECT trigger, flags: COMMAND, probability: 1%

-- 1% chance to trigger
if not percent_chance(1) then
    return true
end

-- Command filter: s
if not (cmd == "s") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
-- This trigger is needed on the action figure to return the command "s"
-- back to its default function, rather than triggering the squeeze trigger.
_return_value = false
return _return_value