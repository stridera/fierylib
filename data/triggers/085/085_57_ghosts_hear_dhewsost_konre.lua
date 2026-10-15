-- Trigger: ghosts hear Dhewsost Konre
-- Zone: 85, ID: 57
-- Type: MOB, Flags: SPEECH
--
-- When a quester utters the words of power "Dhewsost Konre" near a ghost,
-- mark the ghost as shaken and remember the quester as the killer-of-record
-- so 085_58 can credit them on the ghost's death.
--
-- Original DG Script: #8557

-- Converted from DG Script #8557: ghosts hear Dhewsost Konre
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech phrase: dhewsost konre (DG num_arg 0 = the speech contains the whole phrase, on word boundaries)
local speech_padded = " " .. string.lower(speech) .. " "
if not string.find(speech_padded, "[%s%p]dhewsost konre[%s%p]") then
    return true  -- Not the phrase
end
if actor:get_quest_stage("resurrection_quest") > 0 then
    self.room:send_except(actor, "<b:cyan>" .. tostring(self.name) .. " is shaken by " .. tostring(actor.name) .. "'s powerful utterance!</>")
    actor:send("<b:cyan>" .. tostring(self.name) .. " is shaken by your powerful utterance!</>")
    globals.quester = actor
end