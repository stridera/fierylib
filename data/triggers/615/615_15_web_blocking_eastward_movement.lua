-- Trigger: Web blocking eastward movement
-- Zone: 615, ID: 15
-- Type: WORLD, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #61515

-- Converted from DG Script #61515: Web blocking eastward movement
-- Original: WORLD trigger, flags: COMMAND, probability: 100%

-- Command filter: east
if not (cmd == "east") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
if web_present == 1 then
    _return_value = true
    self.room:send_except(actor, tostring(actor.name) .. " tries to walk through a glistening web, and nearly cuts " .. tostring(actor.object) .. "self!")
    actor:send("You find the delicate-looking web completely impassable.")
else
    _return_value = false
end
return _return_value