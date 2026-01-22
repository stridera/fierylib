-- Trigger: no practice
-- Zone: 31, ID: 59
-- Type: MOB, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #3159

-- Converted from DG Script #3159: no practice
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: practice
if not (cmd == "practice") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
-- switch on cmd
if cmd == "p" or cmd == "pr" or cmd == "pra" then
    _return_value = false
    return _return_value
end
actor:send(tostring(self.name) .. " says, 'You don't need to use a \"training\" or \"practice\" command.  Skills increase gradually as you use them.  The words don't change often, but your skills are getting better!'")
return _return_value