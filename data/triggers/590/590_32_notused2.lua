-- Trigger: notused2
-- Zone: 590, ID: 32
-- Type: MOB, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #59032

-- Converted from DG Script #59032: notused2
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: fle
if not (cmd == "fle") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
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
return _return_value