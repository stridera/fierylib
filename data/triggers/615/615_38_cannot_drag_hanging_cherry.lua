-- Trigger: Cannot drag hanging cherry
-- Zone: 615, ID: 38
-- Type: OBJECT, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #61538

-- Converted from DG Script #61538: Cannot drag hanging cherry
-- Original: OBJECT trigger, flags: COMMAND, probability: 100%

-- Command location mask 100: legacy OCMD_EQUIP=1 (worn), OCMD_INVEN=2 (carried), OCMD_ROOM=4 (floor)
if not (location == "room") then
    return true  -- Not in a location this trigger watches
end

-- Command filter: drag
if not (cmd == "drag") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
-- switch on cmd
if cmd == "d" then
    _return_value = true
    return _return_value
end
if string.find(arg, "purple") or string.find(arg, "cherry") then
    _return_value = false
    actor:send("You can't reach that high!")
else
    _return_value = true
end
return _return_value