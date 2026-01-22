-- Trigger: Armor Exchange value blocker
-- Zone: 30, ID: 57
-- Type: MOB, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #3057

-- Converted from DG Script #3057: Armor Exchange value blocker
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: value
if not (cmd == "value") then
    return true  -- Not our command
end
actor:send(tostring(self.name) .. " says, 'Betsy Boo's Treasure Palace is not a SHOP.  I don't buy, sell, list, or value goods.'")
wait(1)
actor:send(tostring(self.name) .. " says indignantly, 'This is not JUNK!'")