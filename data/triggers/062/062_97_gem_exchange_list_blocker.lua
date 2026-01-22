-- Trigger: Gem Exchange list blocker
-- Zone: 62, ID: 97
-- Type: MOB, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #6297

-- Converted from DG Script #6297: Gem Exchange list blocker
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: list
if not (cmd == "list") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
-- switch on cmd
if cmd == "l" or cmd == "li" then
    _return_value = false
    return _return_value
end
actor:send(tostring(self.name) .. " says, 'The Soltan Gem Exchange is not a traditional shop.  We do not buy, sell, list, or value goods.'")
return _return_value