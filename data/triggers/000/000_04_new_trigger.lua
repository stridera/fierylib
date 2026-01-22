-- Trigger: new trigger
-- Zone: 0, ID: 4
-- Type: MOB, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #4

-- Converted from DG Script #4: new trigger
-- Original: MOB trigger, flags: COMMAND, probability: 0%

-- 0% chance to trigger
if not percent_chance(0) then
    return true
end

-- Command filter: kneel
if not (cmd == "kneel") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
_return_value = false
self.room:send("Command trigger (cackle) running")
return _return_value