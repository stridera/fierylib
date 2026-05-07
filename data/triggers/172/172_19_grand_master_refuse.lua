-- Trigger: Grand Master refuse
-- Zone: 172, ID: 19
-- Type: MOB, Flags: RECEIVE
-- Status: DISABLED
--
-- Disabled in legacy DG (probability: 0%) - the Grand Master would refuse
-- arbitrary gifts and emote about it, but the original author left it
-- gated to 0% so the receive-handler in 172_05 (return-the-choker) is the
-- only one that actually runs. Kept here as documentation; the early
-- return makes it a no-op.
--
-- Original DG Script: #17219

return true

-- luacheck: push ignore
-- Reference body, not executed:
--   wait(1)
--   actor:send(self.name .. " says, 'Eh?  Err... no thank you.'")
--   wait(2)
--   actor:send(self.name .. " returns your gift.")
--   self.room:send_except(actor, self.name .. " refuses to accept " .. actor.name .. "'s gift.")
-- luacheck: pop