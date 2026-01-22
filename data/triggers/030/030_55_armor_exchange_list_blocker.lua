-- Trigger: Armor Exchange list blocker
-- Zone: 30, ID: 55
-- Type: MOB, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #3055

-- Converted from DG Script #3055: Armor Exchange list blocker
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
actor:send(tostring(self.name) .. " says, 'Betsy Boo's Treasure Palace is not a SHOP.  I don't buy, sell, list, or value goods.'")
wait(1)
actor:send(tostring(self.name) .. " says indignantly, 'This is not JUNK!'")
return _return_value