-- Trigger: quest_eleweiss_opening
-- Zone: 163, ID: 0
-- Type: WORLD, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #16300

-- Converted from DG Script #16300: quest_eleweiss_opening
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
if string.find(arg, "scrape") or string.find(arg, "mark") or string.find(arg, "branch") then
    actor:send("A sudden gust of air catches hold of you, swirling around and moving you!")
    self.room:send_except(actor, tostring(actor.name) .. " is swallowed by swirling air and disappears.")
    doors.set_state(get_room(163, 74), "up", {action = "room"})
    self.room:send("The wind whips around and around.")
    get_room(163, 75):at(function()
        self.room:send("There is a sudden gust of wind.")
    end)
    get_room(163, 75):at(function()
        self.room:send(tostring(actor.name) .. " is pushed in by the gust of wind which ceases promptly afterwards.")
    end)
    actor:move("up")
    doors.set_state(get_room(163, 74), "up", {action = "purge"})
else
    _return_value = false
end
return _return_value