-- Trigger: silania_refuse
-- Zone: 185, ID: 31
-- Type: MOB, Flags: RECEIVE
--
-- Silania refuses any object not tied to the wand/mace upgrade quests.
--
-- TODO(parity): same issue as 185_29 — the accepted ids are DG globals
-- (maceitem2..5, wandgem, wand_id, mace_id) that are not converted.
-- Until phase_mace/type_wand globals are exposed in the rs runtime,
-- the literal-string compares can never match and Silania will refuse
-- every gift. Legacy probability was 0% (manual fire); confirm that
-- this should run as a normal RECEIVE trigger.

local accepted_ids = {
    "%maceitem2%", "%maceitem3%", "%maceitem4%", "%maceitem5%",
    "%wandgem%",   "%wand_id%",   "%mace_id%",
}

for _, id in ipairs(accepted_ids) do
    if object.id == id then
        return true
    end
end

actor:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
wait(2)
actor:send(tostring(self.name) .. " says, 'What is this for?'")
return true
