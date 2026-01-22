-- Trigger: no training
-- Zone: 31, ID: 55
-- Type: MOB, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #3155

-- Converted from DG Script #3155: no training
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: train
if not (cmd == "train") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
-- switch on cmd
if cmd == "t" or cmd == "tr" or cmd == "tra" then
    _return_value = false
    return _return_value
end
actor:send(tostring(self.name) .. " says, 'You don't need to use a \"training\" or \"practice\" command.  Skills increase gradually as you use them.  The words don't change often, but your skills are getting better!'")
return _return_value