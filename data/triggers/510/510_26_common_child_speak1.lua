-- Trigger: common_child_speak1
-- Zone: 510, ID: 26
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #51026

-- Converted from DG Script #51026: common_child_speak1
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: kafit?
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "kafit?")) then
    return true  -- No matching keywords
end
self.room:send("Both the child's heads focus their attention on you.")
self.room:send("One head says, 'That is the key to decoding Luchiaans' spells.'")
self.room:send("The other head says, 'Avenge us, adventurer!'")
self:command("beg " .. tostring(actor.name))