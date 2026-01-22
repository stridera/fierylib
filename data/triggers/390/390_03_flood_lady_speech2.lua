-- Trigger: flood_lady_speech2
-- Zone: 390, ID: 3
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #39003

-- Converted from DG Script #39003: flood_lady_speech2
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: what stolen? Take?
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "what") or string.find(string.lower(speech), "stolen?") or string.find(string.lower(speech), "take?")) then
    return true  -- No matching keywords
end
if speech == "what did they take?" or speech == "stolen?" or speech == "what was stolen?" or speech == "stolen" then
    self.room:send(tostring(self.name) .. " says, 'What they took matters not!  They have stolen from")
    self.room:send("</>the sea and must either return what they stole or be destroyed.'")
end