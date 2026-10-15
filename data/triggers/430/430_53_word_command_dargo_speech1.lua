-- Trigger: word_command_dargo_speech1
-- Zone: 430, ID: 53
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #43053

-- Converted from DG Script #43053: word_command_dargo_speech1
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"yes", "yes?", "sure", "okay", "yeah"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
wait(0.2)
if globals.questor == actor.name then
    self:say("Lead on!")
elseif actor:get_has_completed("word_command") then
    self:emote("stars in wide-eyed terror.")
    wait(2)
    self:say("Don't I know you already?!  Cyprianum is tormenting me again!!")
    wait(1)
    self.room:send(tostring(self.name) .. " screams, 'NOOOOOOOO!!!!!' as he runs wildly into the shadows!")
    world.destroy(self)
elseif (string.find(actor.class, "priest") or string.find(actor.class, "diabolist")) and actor.level > 72 then
    self:say("Thank you!")
    if actor:get_quest_stage("word_command") == 0 then
        actor:start_quest("word_command")
    end
    globals.questor = actor.name
    self:follow(actor)
else
    self.room:send(tostring(self.name) .. " says, 'I don't know if you can protect me from the demonic forces")
    self.room:send("</>here...  You'll need in-depth knowledge of demons to get us out of")
    self.room:send("</>here alive!'")
end