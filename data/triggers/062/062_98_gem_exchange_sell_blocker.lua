-- Trigger: Gem Exchange sell blocker
-- Zone: 62, ID: 98
-- Type: MOB, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #6298

-- Converted from DG Script #6298: Gem Exchange sell blocker
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: sell
if not (cmd == "sell") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
-- switch on cmd
if cmd == "s" then
    _return_value = false
    return _return_value
end
actor:send(tostring(self.name) .. " says, 'The Soltan Gem Exchange is not a traditional shop.  We do not buy, sell, list, or value goods.'")
return _return_value