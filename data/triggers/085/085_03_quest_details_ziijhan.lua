-- Trigger: quest_details_ziijhan
-- Zone: 85, ID: 3
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #8503

-- Converted from DG Script #8503: quest_details_ziijhan
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"quest"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
if actor.is_player then
    if actor:get_quest_stage("nec_dia_ant_subclass") == 1 then
        actor:advance_quest("nec_dia_ant_subclass")
    end
    wait(0.2)
    actor:send(tostring(self.name) .. " says, 'Many years ago, my pact with the demon realm allowed me to be master of this domain.  All were subjugated, man, woman, and beast.'")
    self:command("smirk")
    wait(1)
    actor:send(tostring(self.name) .. " says, 'One man would not bow though!'")
    self:emote("growls with an anger and fury with which many have never seen and lived!")
    wait(1)
    actor:send(tostring(self.name) .. " says, 'My pitiful waste of a <magenta>brother</> escaped my minions.'")
    self:command("smi " .. tostring(actor.name))
    wait(1)
    actor:send(tostring(self.name) .. " says, 'Perhaps you will remedy that.'")
end