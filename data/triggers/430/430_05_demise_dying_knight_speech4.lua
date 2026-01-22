-- Trigger: Demise_dying_knight_speech4
-- Zone: 430, ID: 5
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #43005

-- Converted from DG Script #43005: Demise_dying_knight_speech4
-- Original: MOB trigger, flags: SPEECH, probability: 1%

-- 1% chance to trigger
if not percent_chance(1) then
    return true
end

-- Speech keywords: help
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "help")) then
    return true  -- No matching keywords
end
self:command("wince")
self.room:send(tostring(self.name) .. " says, 'kill me, don't let them get me!'")
self:command("beg " .. tostring(actor.name))