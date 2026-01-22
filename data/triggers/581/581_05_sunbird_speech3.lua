-- Trigger: Sunbird_speech3
-- Zone: 581, ID: 5
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #58105

-- Converted from DG Script #58105: Sunbird_speech3
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: yes
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "yes")) then
    return true  -- No matching keywords
end
wait(1)
self:emote("beams with joy.")
wait(5)
self:say("The tea master recently left this here")
self:say("after offering prayers to Kannon for forgiveness.")
self:say("He muttered something about a ceremony with Yajiro.")
wait(3)
self.room:spawn_object(581, 9)
self:command("give key " .. tostring(actor))
self:say("Perhaps he holds some kind of key to the conspiracy.")