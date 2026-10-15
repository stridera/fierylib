-- Trigger: stop_flee3
-- Zone: 590, ID: 33
-- Type: MOB, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #59033

-- Converted from DG Script #59033: stop_flee3
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: flee
if not (cmd == "flee") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
if actor.class == "paladin" then
    _return_value = true
else
    _return_value = false
    local rnd = random(1, 10)
    -- switch on rnd
    do
        local _sw1 = string.lower(tostring(rnd or ""))
        if tonumber(_sw1) == 1 or tonumber(_sw1) == 2 or tonumber(_sw1) == 3 or tonumber(_sw1) == 4 or tonumber(_sw1) == 5 then
            self.room:send_except(actor, tostring(actor.name) .. " panics, and attempts to flee!")
            self.room:send_except(actor, tostring(actor.name) .. " leaves north.")
            actor:teleport(get_room(590, 35))
            self.room:send_except(actor, tostring(actor.name) .. " enters from the south.")
            -- actor looks around
            actor:send("You panic and flee north!")
        elseif tonumber(_sw1) == 6 or tonumber(_sw1) == 7 or tonumber(_sw1) == 8 or tonumber(_sw1) == 9 or tonumber(_sw1) == 10 then
            actor:send("PANIC!  You couldn't escape!")
        end
    end
end
return _return_value