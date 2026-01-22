-- Trigger: Armor Exchange sell blocker
-- Zone: 30, ID: 56
-- Type: MOB, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #3056

-- Converted from DG Script #3056: Armor Exchange sell blocker
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
actor:send(tostring(self.name) .. " says, 'Betsy Boo's Treasure Palace is not a SHOP.  I don't buy, sell, list, or value goods.'")
wait(1)
actor:send(tostring(self.name) .. " says indignantly, 'This is not JUNK!'")
return _return_value