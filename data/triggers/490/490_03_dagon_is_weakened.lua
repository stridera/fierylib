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
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
if actor.id == self.id then
    globals.dagonisweak = true
end
return _return_value