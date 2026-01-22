-- Trigger: quest_eleweiss_ranger_druid_subclass_speak3
-- Zone: 163, ID: 4
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #16304

-- Converted from DG Script #16304: quest_eleweiss_ranger_druid_subclass_speak3
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: quest quest?
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "quest") or string.find(string.lower(speech), "quest?")) then
    return true  -- No matching keywords
end
wait(2)
if actor:get_quest_stage("ran_dru_subclass") == 1 then
    actor.name:advance_quest("ran_dru_subclass")
    actor:send(tostring(self.name) .. " says, 'Yes, quest.  I do suppose it would help if I told you about it.'")
    self:emote("rubs his chin thoughtfully.")
    wait(1)
    actor:send(tostring(self.name) .. " says, 'Long ago I <b:cyan>lost something</>.  It is a shame, but it has never been recovered.'")
    self:command("sigh")
    actor:send(tostring(self.name) .. " says, 'If you were to help me with that, then we could arrange something.'")
    self:emote("looks hopeful.")
end