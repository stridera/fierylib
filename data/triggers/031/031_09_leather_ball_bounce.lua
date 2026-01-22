-- Trigger: leather_ball_bounce
-- Zone: 31, ID: 9
-- Type: OBJECT, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #3109

-- Converted from DG Script #3109: leather_ball_bounce
-- Original: OBJECT trigger, flags: COMMAND, probability: 1%

-- 1% chance to trigger
if not percent_chance(1) then
    return true
end

-- Command filter: bounce
if not (cmd == "bounce") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
_return_value = true
if arg then
    if actor.room ~= arg.room then
        actor:send("Bounce the ball on who?  They don't seem to be here!")
    else
        arg:teleport(get_room(11, 0))
        self.room:send_except(actor, tostring(actor.name) .. " throws " .. tostring(self.shortdesc) .. " at " .. tostring(arg.name) .. ", bouncing it off " .. tostring(arg.possessive) .. " forehead!")
        arg:teleport(get_room(vnum_to_zone(actor.room), vnum_to_local(actor.room)))
        arg:send(tostring(actor.name) .. " throws " .. tostring(self.shortdesc) .. " at you, bouncing it off your forehead!")
        actor:send("You launch " .. tostring(self.shortdesc) .. " at " .. tostring(arg.name) .. ", bouncing it off " .. tostring(arg.possessive) .. " forehead!")
    end
else
    self.room:send_except(actor, tostring(actor.name) .. " bounces " .. tostring(self.shortdesc) .. " on the ground a few times.")
    actor:send("You dribble " .. tostring(self.shortdesc) .. " around yourself a little bit.")
end
return _return_value