-- Trigger: berserker_command_dig
-- Zone: 364, ID: 7
-- Type: WORLD, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #36407

-- Converted from DG Script #36407: berserker_command_dig
-- Original: WORLD trigger, flags: COMMAND, probability: 100%

-- Command filter: dig
if not (cmd == "dig") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
-- switch on cmd
if cmd == "d" or cmd == "di" then
    _return_value = false
    return _return_value
end
if actor.id == -1 then
    actor:send("You dig out a path through the snow.")
    self.room:send_except(actor, tostring(actor.name) .. " digs out a path through the snow.")
    get_room(364, 29):at(function()
        self.room:send("The way south has been cleared.")
    end)
    get_room(364, 31):at(function()
        self.room:send("The way north has been cleared.")
    end)
    doors.set_state(get_room(364, 29), "south", {action = "room"})
    doors.set_state(get_room(364, 31), "north", {action = "room"})
    wait(15)
    get_room(364, 29):at(function()
        self.room:send("The snow begins to drift back in...")
    end)
    get_room(364, 31):at(function()
        self.room:send("The snow begins to drift back in...")
    end)
    wait(10)
    get_room(364, 29):at(function()
        self.room:send("The snow has completely covered the path south.")
    end)
    get_room(364, 31):at(function()
        self.room:send("The snow has completely covered the path north.")
    end)
    doors.set_state(get_room(364, 29), "south", {action = "purge"})
    doors.set_state(get_room(364, 31), "north", {action = "purge"})
end
return _return_value