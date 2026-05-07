-- Trigger: Gem Exchange buy blocker
-- Zone: 62, ID: 96
-- Type: MOB, Flags: COMMAND
--
-- The exchange is not a normal shop, so explicitly tell players that "buy"
-- is unsupported here. (Original script also had branches for "b"/"bu" abbreviations
-- but those are unreachable behind the cmd == "buy" filter.)
--
-- Original DG Script: #6296

if cmd ~= "buy" then
    return true
end
actor:send(tostring(self.name) .. " says, 'The Soltan Gem Exchange is not a traditional shop.  We do not buy, sell, list, or value goods.'")
return true