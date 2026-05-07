-- Trigger: flood_lady_speech2
-- Zone: 390, ID: 3
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #39003
--
-- The Lady deflects questions about what was stolen from her. Rude.

local speech_lower = string.lower(speech)
if not (string.find(speech_lower, "what")
        or string.find(speech_lower, "stolen")
        or string.find(speech_lower, "take")) then
    return true
end

self.room:send(self.name .. " says, 'What they took matters not!  They have stolen from")
self.room:send("</>the sea and must either return what they stole or be destroyed.'")