-- Trigger: high-druid-blessings
-- Zone: 23, ID: 6
-- Type: MOB, Flags: SPEECH_TO
-- Status: CLEAN
--
-- Original DG Script: #2306

-- Converted from DG Script #2306: high-druid-blessings
-- Original: MOB trigger, flags: SPEECH_TO, probability: 100%
if actor.id == -1 then
    if string.find(actor.class, "Druid") then
        wait(1)
        self:command("nod")
        wait(1)
        self:say("Long ago, the founders of the Vale left gret stone monoliths in each of the four power points of nature.")
        self:say("There was one in each direction, and they were used to commune with the powers of nature.")
        wait(2)
        self:say("But the blessings of nature were lost, and we were forced to abandon the stones in order to protect our order.")
        wait(2)
        self:say("If you could prove yourself by bringing me the blessing of the south, perhaps you could be sent after the others as well.")
        self:command("bow " .. tostring(actor.name))
    else
        self.room:send(tostring(self.name) .. " smiles sadly at " .. tostring(actor.name) .. ".")
        self:say("I am afraid you cannot help me, my child.")
        self:say("This is a concern for the druids.")
    end
end