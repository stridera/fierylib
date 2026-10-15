-- Trigger: Armor Exchange buy blocker
-- Zone: 30, ID: 54
-- Type: MOB, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #3054

-- Converted from DG Script #3054: Armor Exchange buy blocker
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: buy
if not (cmd == "buy") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
-- switch on cmd
do
    local _sw1 = string.lower(tostring(cmd or ""))
    if _sw1 == "b" or _sw1 == "bu" then
        _return_value = true
        return _return_value
    end
end
actor:send(tostring(self.name) .. " says, 'Betsy Boo's Treasure Palace is not a SHOP.  I don't buy, sell, list, or value goods.'")
wait(1)
actor:send(tostring(self.name) .. " says indignantly, 'This is not JUNK!'")
return _return_value