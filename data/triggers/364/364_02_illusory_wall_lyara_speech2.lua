-- Trigger: illusory_wall_lyara_speech2
-- Zone: 364, ID: 2
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Lyara offers tutelage to an eligible Illusionist/Bard who mentions teach
-- / teacher / student, then asks if they are willing to learn.
--
-- Original DG Script: #36402

local speech_lower = string.lower(speech)
if not (string.find(speech_lower, "teach") or string.find(speech_lower, "student")) then
    return true
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