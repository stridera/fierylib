-- Trigger: Gem Exchange sell blocker
-- Zone: 62, ID: 98
-- Type: MOB, Flags: COMMAND
--
-- "sell" is not a valid action in the gem exchange. Explain instead of
-- silently failing.
--
-- Original DG Script: #6298

if cmd ~= "sell" then
    return true
end
actor:send(tostring(self.name) .. " says, 'The Soltan Gem Exchange is not a traditional shop.  We do not buy, sell, list, or value goods.'")
return true