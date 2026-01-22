-- Trigger: mage_speak1
-- Zone: 238, ID: 11
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #23811

-- Converted from DG Script #23811: mage_speak1
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: riddle quest hi hello
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "riddle") or string.find(string.lower(speech), "quest") or string.find(string.lower(speech), "hi") or string.find(string.lower(speech), "hello")) then
    return true  -- No matching keywords
end
wait(1)
self:command("frown")
wait(2)
self:emote("gestures at the symbols on the walls.")
self:say("There is a riddle here, yes.  It is...somewhat complicated.")
self:emote("takes a deep breath and begins to translate some runes.")
wait(3)
self:say("\"Five friends from five towns liked five colors and stood in a line.  Each was a different race and class, and each fought a different enemy.  In my keep you will find all the information you need to solve the question I ask.\"")
wait(3)
self:command("frown")
wait(1)
self:emote("gestures at the wall, looking frustrated.")
self:say("But the question referred to is obscured by ice.")