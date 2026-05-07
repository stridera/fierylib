-- Trigger: Eleweiss refuse
-- Zone: 163, ID: 10
-- Type: MOB, Flags: RECEIVE
--
-- Original DG Script: #16310
-- Probability: 0% (disabled in source data; data-layer probability gate handles activation)
--
-- Catch-all RECEIVE handler for Eleweiss: if the offered object isn't one of
-- the wand-quest items, refuse it.

-- TODO(parity): the original gated on `object.id == %wandgem% || %wand_id%`
-- where wandgem and wand_id were DG globals naming the in-progress wand parts.
-- The Lua runtime doesn't yet expose those identifiers, so the gate is a stub
-- that always falls through to the refusal path. Wire the wand quest schema
-- through before re-enabling.

wait(2)
actor:send(tostring(self.name) .. " says, 'What is this?'")
wait(3)
actor:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
wait(2)
actor:send(tostring(self.name) .. " says, 'I have no need of " .. tostring(object.shortdesc) .. ".'")
return true
