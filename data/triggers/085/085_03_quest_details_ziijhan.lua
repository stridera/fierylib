-- Trigger: quest_details_ziijhan
-- Zone: 85, ID: 3
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #8503

-- Converted from DG Script #8503: quest_details_ziijhan
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: quest
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "quest")) then
    return true  -- No matching keywords
end
if actor.id == -1 then
    if actor:get_quest_stage("nec_dia_ant_subclass") == 1 then
        actor.name:advance_quest("nec_dia_ant_subclass")
    end
    wait(2)
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