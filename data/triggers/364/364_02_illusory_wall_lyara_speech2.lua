-- Trigger: illusory_wall_lyara_speech2
-- Zone: 364, ID: 2
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #36402

-- Converted from DG Script #36402: illusory_wall_lyara_speech2
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: teach teacher student teach? teacher? student?
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "teach") or string.find(string.lower(speech), "teacher") or string.find(string.lower(speech), "student") or string.find(string.lower(speech), "teach?") or string.find(string.lower(speech), "teacher?") or string.find(string.lower(speech), "student?")) then
    return true  -- No matching keywords
end
if (string.find(actor.class, "illusionist") or string.find(actor.class, "bard")) and actor.level > 56 then
    wait(2)
    self.room:send(tostring(self.name) .. " says, 'I don't get many students these days.  They just")
    self.room:send("</>don't have enough patience...'")
    wait(4)
    self:command("grumble")
    wait(3)
    self.room:send(tostring(self.name) .. " says, 'But if you're willing to take the time to study, I")
    self.room:send("</>can take you on as my pupil for a bit.'")
    wait(4)
    self:say("Are you willing?")
end