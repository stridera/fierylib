-- Trigger: paralysis_prevent_order
-- Zone: 485, ID: 34
-- Type: MOB, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #48534

-- Converted from DG Script #48534: paralysis_prevent_order
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: order
if not (cmd == "order") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
if paralysis_victim_1 and (paralysis_victim_1.name == actor.name) then
    local block = 1
elseif paralysis_victim_2 and (paralysis_victim_2.name == actor.name) then
    local block = 1
elseif paralysis_victim_3 and (paralysis_victim_3.name == actor.name) then
    local block = 1
elseif paralysis_victim_4 and (paralysis_victim_4.name == actor.name) then
    local block = 1
elseif paralysis_victim_5 and (paralysis_victim_5.name == actor.name) then
    local block = 1
end
if block then
    _return_value = true
    if message then
        actor:send(tostring(message))
    else
        actor:send("You are trapped, and unable to move!")
    end
else
    _return_value = false
end
return _return_value