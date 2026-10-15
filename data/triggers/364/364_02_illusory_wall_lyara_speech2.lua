-- Trigger: illusory_wall_lyara_speech2
-- Zone: 364, ID: 2
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Lyara offers tutelage to an eligible Illusionist/Bard who mentions teach
-- / teacher / student, then asks if they are willing to learn.
--
-- Original DG Script: #36402

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"teach", "teacher", "student", "teach?", "teacher?", "student?"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
if (string.find(actor.class, "illusionist") or string.find(actor.class, "bard")) and actor.level > 56 then
    wait(0.2)
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