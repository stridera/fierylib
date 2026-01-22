-- Trigger: can_go_to_adramalech
-- Zone: 490, ID: 24
-- Type: WORLD, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #49024

-- Converted from DG Script #49024: can_go_to_adramalech
-- Original: WORLD trigger, flags: COMMAND, probability: 100%

-- Command filter: enter
if not (cmd == "enter") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
-- switch on cmd
if cmd == "e" then
    _return_value = false
    return _return_value
end
if actor:get_quest_stage("griffin_quest") > 7 then
    _return_value = false
else
    _return_value = true
    self.room:send_except(actor, tostring(actor.name) .. " hops into the pool, but gets " .. tostring(actor.possessive) .. " feet wet.")
    actor:send("You hop into the pool, but only get your feet wet.")
end
return _return_value