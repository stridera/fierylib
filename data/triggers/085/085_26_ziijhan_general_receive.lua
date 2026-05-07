-- Trigger: Ziijhan general receive
-- Zone: 85, ID: 26
-- Type: MOB, Flags: RECEIVE
--
-- Default RECEIVE handler for Ziijhan: rejects any item that isn't part of
-- the phase mace upgrade chain.
--
-- Original DG Script: #8526

-- Converted from DG Script #8526: Ziijhan general receive
-- Original: MOB trigger, flags: RECEIVE, probability: 100%

-- TODO(parity): the legacy DG matched object.id against the globals
-- %maceitem2% .. %maceitem5% and %mace_id% (set somewhere in the
-- phase_mace quest chain). Until those globals are migrated to the new
-- quest var system, we always reject — restore the early-allow branch
-- when the mace item ids are pinned down.
actor:send(self.name .. " scoffs at " .. tostring(object.shortdesc) .. ".")
wait(2)
actor:send(tostring(self.name) .. " says, 'What is this garbage?'")
return true