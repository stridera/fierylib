-- Trigger: dagon_is_weakened
-- Zone: 490, ID: 3
-- Type: MOB, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #49003

-- Converted from DG Script #49003: dagon_is_weakened
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: dagonisweaknow
if not (cmd == "dagonisweaknow") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
if actor.id == self.id then
    local dagonisweak = 1
    globals.dagonisweak = globals.dagonisweak or true
else
    _return_value = false
end
return _return_value