-- Trigger: sacrifice_trigger
-- Zone: 18, ID: 22
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #1822

-- Converted from DG Script #1822: sacrifice_trigger
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: sacrifice Sacrifice
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "sacrifice") or string.find(string.lower(speech), "sacrifice")) then
    return true  -- No matching keywords
end
actor.name:send("The void guardians says to you, \"Give me something valuable, and I might set you free.\"")