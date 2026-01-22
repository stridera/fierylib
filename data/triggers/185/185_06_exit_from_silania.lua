-- Trigger: exit_from_silania
-- Zone: 185, ID: 6
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #18506

-- Converted from DG Script #18506: exit_from_silania
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: exit exit?
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "exit") or string.find(string.lower(speech), "exit?")) then
    return true  -- No matching keywords
end
self:say("Ooops, how embarassing, I forgot about the door!")
run_room_trigger(18507)