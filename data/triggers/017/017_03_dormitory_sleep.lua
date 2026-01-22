-- Trigger: dormitory_sleep
-- Zone: 17, ID: 3
-- Type: WORLD, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #1703

-- Converted from DG Script #1703: dormitory_sleep
-- Original: WORLD trigger, flags: COMMAND, probability: 100%

-- Command filter: sleep
if not (cmd == "sleep") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
if not actor then
    _return_value = false
elseif actor.id >= 0 then
    _return_value = false
elseif s == "cmd" then
    _return_value = false
elseif actor.stance ~= "resting" and actor.stance ~= "alert" then
    _return_value = false
else
    actor:send("You retreat into your cubicle, lay down your belongings, and rest.")
    self.room:send_except(actor, tostring(actor.name) .. " enters " .. tostring(actor.possessive) .. " cubicle and tunes out the world.")
    actor:rent()
end
return _return_value