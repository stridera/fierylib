-- Trigger: lantern shows the path
-- Zone: 51, ID: 19
-- Type: WORLD, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #5119

-- Converted from DG Script #5119: lantern shows the path
-- Original: WORLD trigger, flags: COMMAND, probability: 0%

-- 0% chance to trigger
if not percent_chance(0) then
    return true
end

-- Command filter: look
if not (cmd == "look") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
-- switch on arg
if arg == "l" or arg == "la" or arg == "lan" or arg == "lant" or arg == "lante" or arg == "lanter" or arg == "lantern" then
    actor:command("look lantern")
    self.room:send_except(actor, tostring(actor.name) .. " looks at the stone lantern.")
    wait(2)
    self.room:send("An eerie <b:yellow>glow</> begins emitting from the lantern...")
    wait(5)
    get_room(580, 1):exit("west"):set_state({hidden = false})
    self.room:send("The light reveals a well-concealed break in the rocky hills to the west!")
    wait(20)
    self.room:send("The light begins to flicker and fade...")
    wait(5)
    get_room(580, 1):exit("west"):set_state({hidden = true})
    self.room:send("The passage west is obscured again as the glow of the lantern fades.")
end
_return_value = false
return _return_value