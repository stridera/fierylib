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
local _return_value = true  -- Default: allow action
_return_value = true
local rnd = random(1, 10)
-- switch on rnd
if rnd == 1 or rnd == 2 or rnd == 3 or rnd == 4 or rnd == 5 then
    self.room:send_except(actor, tostring(actor.name) .. " panics, and attempts to flee!")
    self.room:send_except(actor, tostring(actor.name) .. " leaves north.")
    actor:teleport(get_room(590, 35))
    self.room:send_except(actor, tostring(actor.name) .. " enters from the south.")
    -- actor looks around
    actor:send("You panic and flee north!")
elseif rnd == 6 or rnd == 7 or rnd == 8 or rnd == 9 or rnd == 10 then
    actor:send("PANIC!  You couldn't escape!")
end
return _return_value