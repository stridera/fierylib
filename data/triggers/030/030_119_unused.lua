-- Trigger: **UNUSED**
-- Zone: 30, ID: 119
-- Type: OBJECT, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #3119

-- Converted from DG Script #3119: **UNUSED**
-- Original: OBJECT trigger, flags: COMMAND, probability: 1%

-- Command location mask 1: legacy OCMD_EQUIP=1 (worn), OCMD_INVEN=2 (carried), OCMD_ROOM=4 (floor)
if not (location == "equip") then
    return true  -- Not in a location this trigger watches
end

-- Command filter: pr
if not (cmd == "pr") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
-- This trigger makes sure the command "pr" does its normal function,
-- instead of triggering the press trigger.
_return_value = true
return _return_value