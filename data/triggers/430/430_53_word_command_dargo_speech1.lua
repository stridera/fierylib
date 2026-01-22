-- Trigger: word_command_dargo_speech1
-- Zone: 430, ID: 53
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #43053

-- Converted from DG Script #43053: word_command_dargo_speech1
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: yes yes? sure okay yeah
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "yes") or string.find(string.lower(speech), "yes?") or string.find(string.lower(speech), "sure") or string.find(string.lower(speech), "okay") or string.find(string.lower(speech), "yeah")) then
    return true  -- No matching keywords
end
wait(2)
if questor == actor.name then
    self:say("Lead on!")
elseif actor:get_has_completed("word_command") then
    self:emote("stars in wide-eyed terror.")
    wait(2)
    self:say("Don't I know you already?!  Cyprianum is tormenting me again!!")
    wait(1)
    self.room:send(tostring(self.name) .. " screams, 'NOOOOOOOO!!!!!' as he runs wildly into the shadows!")
    world.destroy(self)
elseif (string.find(actor.class, "Priest") or string.find(actor.class, "Diabolist")) and actor.level > 72 then
    self:say("Thank you!")
    if not actor:get_quest_stage("word_command") then
        actor.name:start_quest("word_command")
    end
    local questor = actor.name
    globals.questor = globals.questor or true
    self:follow(actor)
else
    self.room:send(tostring(self.name) .. " says, 'I don't know if you can protect me from the demonic forces")
    self.room:send("</>here...  You'll need in-depth knowledge of demons to get us out of")
    self.room:send("</>here alive!'")
end