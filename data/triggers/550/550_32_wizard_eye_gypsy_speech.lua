-- Trigger: wizard_eye_gypsy_speech
-- Zone: 550, ID: 32
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #55032

-- Converted from DG Script #55032: wizard_eye_gypsy_speech
-- Original: MOB trigger, flags: SPEECH, probability: 1%

-- 1% chance to trigger
if not percent_chance(1) then
    return true
end

-- Speech keywords: wizard eye wizard? eye?
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "wizard") or string.find(string.lower(speech), "eye") or string.find(string.lower(speech), "wizard?") or string.find(string.lower(speech), "eye?")) then
    return true  -- No matching keywords
end
wait(2)
if actor:get_quest_stage("wizard_eye") == 1 then
    actor:send(tostring(self.name) .. " says, 'Why yes, I can help with that!  So you want your own crystal ball, ya say?'")
    wait(2)
    actor:send(tostring(self.name) .. " says, '<b:cyan>Show</> me your <b:cyan>palm</>.'")
end