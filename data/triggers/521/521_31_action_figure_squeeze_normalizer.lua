-- Trigger: action_figure_squeeze_normalizer
-- Zone: 521, ID: 31
-- Type: OBJECT, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #52131

-- Converted from DG Script #52131: action_figure_squeeze_normalizer
-- Original: OBJECT trigger, flags: COMMAND, probability: 1%

-- Command location mask 1: legacy OCMD_EQUIP=1 (worn), OCMD_INVEN=2 (carried), OCMD_ROOM=4 (floor)
if not (location == "equip") then
    return true  -- Not in a location this trigger watches
end

-- Command filter: s
if not (cmd == "s") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
-- This trigger is needed on the action figure to return the command "s"
-- back to its default function, rather than triggering the squeeze trigger.
_return_value = true
return _return_value