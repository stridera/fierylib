-- Trigger: bird_whistle
-- Zone: 30, ID: 112
-- Type: OBJECT, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #3112

-- Converted from DG Script #3112: bird_whistle
-- Original: OBJECT trigger, flags: COMMAND, probability: 1%

-- Command location mask 1: legacy OCMD_EQUIP=1 (worn), OCMD_INVEN=2 (carried), OCMD_ROOM=4 (floor)
if not (location == "equip") then
    return true  -- Not in a location this trigger watches
end

-- Command filter: whistle
if not (cmd == "whistle") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
-- switch on cmd
if cmd == "w" or cmd == "wh" or cmd == "whi" or cmd == "whis" then
    _return_value = true
    return _return_value
end
self.room:send_except(actor, tostring(actor.name) .. " places a bird whistle to " .. tostring(actor.possessive) .. " lips and lets out a twitter.")
actor:send("You blow on a bird whistle, making a twittering noise.")
return _return_value