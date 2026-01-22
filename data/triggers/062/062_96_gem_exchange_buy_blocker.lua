-- Trigger: Gem Exchange buy blocker
-- Zone: 62, ID: 96
-- Type: MOB, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #6296

-- Converted from DG Script #6296: Gem Exchange buy blocker
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: buy
if not (cmd == "buy") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
-- switch on cmd
if cmd == "b" or cmd == "bu" then
    _return_value = false
    return _return_value
end
actor:send(tostring(self.name) .. " says, 'The Soltan Gem Exchange is not a traditional shop.  We do not buy, sell, list, or value goods.'")
return _return_value