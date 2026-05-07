-- Trigger: quest_eleweiss_opening
-- Zone: 163, ID: 0
-- Type: WORLD, Flags: COMMAND
--
-- Original DG Script: #16300
-- Probability: 0% (disabled in source data; data-layer probability gate handles activation)
--
-- Look at the marked branch in the entry chamber: the wind catches the actor
-- and lifts them up to room 163/74.

if cmd ~= "look" then
    return true  -- Not our command
end

if string.find(arg, "scrape") or string.find(arg, "mark") or string.find(arg, "branch") then
    actor:send("A sudden gust of air catches hold of you, swirling around and moving you!")
    self.room:send_except(actor, tostring(actor.name) .. " is swallowed by swirling air and disappears.")
    get_room(163, 74):exit("up"):set_state({hidden = false})
    self.room:send("The wind whips around and around.")
    get_room(163, 75):at(function()
        self.room:send("There is a sudden gust of wind.")
    end)
    get_room(163, 75):at(function()
        self.room:send(tostring(actor.name) .. " is pushed in by the gust of wind which ceases promptly afterwards.")
    end)
    actor:move("up")
    get_room(163, 74):exit("up"):set_state({hidden = true})
end

return true
