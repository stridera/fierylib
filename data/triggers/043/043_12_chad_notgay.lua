-- Trigger: chad_notgay
-- Zone: 43, ID: 12
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #4312

-- Converted from DG Script #4312: chad_notgay
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: Oh don't worry I can make it worth your time.
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "oh") or string.find(string.lower(speech), "don't") or string.find(string.lower(speech), "worry") or string.find(string.lower(speech), "i") or string.find(string.lower(speech), "can") or string.find(string.lower(speech), "make") or string.find(string.lower(speech), "it") or string.find(string.lower(speech), "worth") or string.find(string.lower(speech), "your") or string.find(string.lower(speech), "time.")) then
    return true  -- No matching keywords
end
if actor.id == 4302 then
    wait(5)
    self:emote("scoots away from his fellow player.")
    wait(3)
    self:say("I just don't know...  I mean, I COULD be...")
    wait(5)
    self:emote("is so confused by it all!")
end