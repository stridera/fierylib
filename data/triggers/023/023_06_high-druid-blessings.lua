-- Trigger: high-druid-blessings
-- Zone: 23, ID: 6
-- Type: MOB, Flags: SPEECH_TO
-- Status: CLEAN
--
-- Original DG Script: #2306

-- Converted from DG Script #2306: high-druid-blessings
-- Original: MOB trigger, flags: SPEECH_TO, probability: 100%
-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"blessing", "blessings", "blessing?", "blessings?"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end

if actor.is_player then
    if string.find(actor.class, "druid") then
        wait(0.1)
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