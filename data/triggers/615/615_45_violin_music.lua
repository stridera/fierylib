-- Trigger: Violin music
-- Zone: 615, ID: 45
-- Type: OBJECT, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #61545

-- Converted from DG Script #61545: Violin music
-- Original: OBJECT trigger, flags: COMMAND, probability: 3%

-- Command location mask 3: legacy OCMD_EQUIP=1 (worn), OCMD_INVEN=2 (carried), OCMD_ROOM=4 (floor)
if not (location == "equip" or location == "inventory") then
    return true  -- Not in a location this trigger watches
end

-- Command filter: throw
if not (cmd == "throw") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
-- switch on cmd
if cmd == "t" or cmd == "th" or cmd == "thr" or cmd == "thro" then
    _return_value = true
    return _return_value
end
self.room:send("I'm throwing!")
return _return_value