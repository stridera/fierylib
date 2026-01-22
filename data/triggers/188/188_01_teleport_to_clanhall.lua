-- Trigger: Teleport_to_clanhall
-- Zone: 188, ID: 1
-- Type: OBJECT, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #18801

-- Converted from DG Script #18801: Teleport_to_clanhall
-- Original: OBJECT trigger, flags: COMMAND, probability: 1%

-- 1% chance to trigger
if not percent_chance(1) then
    return true
end

-- Command filter: sneak
if not (cmd == "sneak") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
if arg == "out" then
    if actor.room ~= 18800 then
        _return_value = true
        self.room:send_except(actor, tostring(actor.name) .. " ducks quietly out of the room.")
        actor:send("Glancing around, you duck quietly out of the room.")
        actor:teleport(get_room(188, 0))
        self.room:send_except(actor, tostring(actor.name) .. " suddenly fades into existance, walking in from the east.")
        actor:command("look")
    else
        _return_value = false
    end
else
    _return_value = false
end
return _return_value