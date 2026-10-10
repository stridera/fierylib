-- Trigger: action_figure_pull_normalizer
-- Zone: 521, ID: 33
-- Type: OBJECT, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #52133

-- Converted from DG Script #52133: action_figure_pull_normalizer
-- Original: OBJECT trigger, flags: COMMAND, probability: 1%

-- Command location mask 1: legacy OCMD_EQUIP=1 (worn), OCMD_INVEN=2 (carried), OCMD_ROOM=4 (floor)
if not (location == "equip") then
    return true  -- Not in a location this trigger watches
end

-- Command filter: pu
if not (cmd == "pu") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
_return_value = true
-- This trigger is required to make the command "pu" return to its default
-- behavior, rather than setting off the pull trigger.
return _return_value