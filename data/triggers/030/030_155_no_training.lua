-- Trigger: no training
-- Zone: 30, ID: 155
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
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
-- switch on cmd
do
    local _sw1 = string.lower(tostring(cmd or ""))
    if _sw1 == "t" or _sw1 == "tr" or _sw1 == "tra" then
        _return_value = true
        return _return_value
    end
end
actor:send(tostring(self.name) .. " says, 'You don't need to use a \"training\" or \"practice\" command.  Skills increase gradually as you use them.  The words don't change often, but your skills are getting better!'")
return _return_value