-- Trigger: Gem Exchange value blocker
-- Zone: 62, ID: 99
-- Type: MOB, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #6299

-- Converted from DG Script #6299: Gem Exchange value blocker
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: value
if not (cmd == "value") then
    return true  -- Not our command
end
actor:send(tostring(self.name) .. " says, 'The Soltan Gem Exchange is not a traditional shop.  We do not buy, sell, list, or value goods.'")