-- Trigger: sexton_refuse
-- Zone: 185, ID: 29
-- Type: MOB, Flags: RECEIVE
--
-- Sexton refuses any object that is not part of the phase_mace upgrade.
--
-- TODO(parity): the accepted-object list is gated on globals
-- (maceitem2/3/4/5/6, mace_id) from the phase_mace system that is not
-- yet wired up in the rs runtime. As-is, the comparison `object.id ==
-- "%maceitem2%"` is a string compare that will never match, so every
-- object is refused. Once the phase_mace globals are real, replace the
-- literal-string list with proper id checks.

local accepted_ids = {
    "%maceitem2%", "%maceitem3%", "%maceitem4%", "%maceitem5%",
    "%mace_id%", "%maceitem6%",
}

for _, id in ipairs(accepted_ids) do
    if object.id == id then
        return true
    end
end

actor:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
wait(2)
actor:send(tostring(self.name) .. " says, 'I'm sorry, what is this for?'")
return true
