-- Trigger: Ring_Bell
-- Zone: 125, ID: 1
-- Type: WORLD, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #12501

-- Converted from DG Script #12501: Ring_Bell
-- Original: WORLD trigger, flags: COMMAND, probability: 100%

-- Command filter: pull
if not (cmd == "pull") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
if string.find(arg, "rope") then
    actor:send("As you pull the rope, you think you hear the faint ringing of a bell.")
    self.room:send_except(actor, "As " .. tostring(actor.name) .. " pulls the rope, you seem to hear a bell ringing.")
    if world.count_objects("12521") or world.count_objects("12522") then
        get_room(126, 2):at(function()
            world.destroy(self.room:find_actor("field"))
        end)
    end
    if world.count_objects("12521") or world.count_objects("12522") then
        get_room(126, 2):at(function()
            world.destroy(self.room:find_actor("field"))
        end)
    end
    get_room(126, 2):at(function()
        self.room:spawn_object(125, 21)
    end)
    get_room(126, 2):at(function()
        self.room:spawn_object(125, 22)
    end)
    get_room(126, 2):at(function()
        self.room:send("The echo of a bell ringing echoes through the cavern.")
    end)
    get_room(126, 2):at(function()
        self.room:send("In response, glowing fields envelope the tunnel entrances to the west and east.")
    end)
else
    _return_value = false
end
return _return_value