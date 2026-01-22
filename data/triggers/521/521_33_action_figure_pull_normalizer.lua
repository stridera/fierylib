-- Trigger: action_figure_pull_normalizer
-- Zone: 521, ID: 33
-- Type: OBJECT, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #52133

-- Converted from DG Script #52133: action_figure_pull_normalizer
-- Original: OBJECT trigger, flags: COMMAND, probability: 1%

-- 1% chance to trigger
if not percent_chance(1) then
    return true
end

-- Command filter: pu
if not (cmd == "pu") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
_return_value = false
-- This trigger is required to make the command "pu" return to its default
-- behavior, rather than setting off the pull trigger.
return _return_value