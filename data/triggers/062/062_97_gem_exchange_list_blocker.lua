-- Trigger: Gem Exchange list blocker
-- Zone: 62, ID: 97
-- Type: MOB, Flags: COMMAND
--
-- "list" is not a valid action in the gem exchange. Explain instead of
-- silently failing.
--
-- Original DG Script: #6297

if cmd ~= "list" then
    return true
end
actor:send(tostring(self.name) .. " says, 'The Soltan Gem Exchange is not a traditional shop.  We do not buy, sell, list, or value goods.'")
return true