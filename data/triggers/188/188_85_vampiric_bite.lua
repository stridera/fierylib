-- Trigger: vampiric_bite
-- Zone: 188, ID: 85
-- Type: OBJECT, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #18885

-- Converted from DG Script #18885: vampiric_bite
-- Original: OBJECT trigger, flags: COMMAND, probability: 1%

-- 1% chance to trigger
if not percent_chance(1) then
    return true
end

-- Command filter: bite
if not (cmd == "bite") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
-- switch on cmd
if cmd == "b" then
    _return_value = false
    return _return_value
end
if arg == "self" or arg.name == actor.name then
    _return_value = false
elseif arg and arg.room == actor.room then
    actor:send("You bite " .. tostring(arg.name) .. " on the neck!")
    actor:teleport(get_room(11, 0))
    self.room:send_except(arg, tostring(actor.name) .. " bites " .. tostring(arg.name) .. " on the neck!")
    actor:teleport(get_room(arg.room.zone_id, arg.room.local_id))
    arg:send(tostring(actor.name) .. " bites you on the neck!")
    _return_value = true
else
    _return_value = false
end
return _return_value