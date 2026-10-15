-- Trigger: academy_instructor_speech_say_tell_gossip
-- Zone: 519, ID: 5
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #51905

-- Converted from DG Script #51905: academy_instructor_speech_say_tell_gossip
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
local speech_word = nil  -- the first listed word found; branch on this, not on the raw speech
for _, w in ipairs({"say", "tell", "gossip"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        speech_word = w
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
wait(0.2)
if (actor:get_quest_var("school:speech") or 0) == 3 then
    if speech_word == "say" then
        actor:send(tostring(self.name) .. " tells you, 'The most basic command is <b:cyan>(SA)Y</>.")
        actor:send("It sends your message to everything in the room, even NPCs and monsters.'")
    elseif speech_word == "tell" or speech_word == "whisper" then
        actor:send(tostring(self.name) .. " tells you, 'You can talk to one person by using <b:cyan>(T)ELL</>.")
        actor:send("Only the person you talk to will hear what you say, just like how I'm talking to you right now.")
        actor:send("You use it by typing <b:cyan>TELL [person] [message]</>.'")
    elseif speech_word == "gossip" then
        actor:send(tostring(self.name) .. " tells you, '<b:cyan>(GOS)SIP</> talks to everyone in the game.")
        actor:send("It's definitely the most popular communication channel.")
        actor:send("It's a great way to ask questions or get help.'")
    end
    actor:send("</>")
    actor:send(tostring(self.name) .. " tells you, 'Do you have any other questions about communication?")
    actor:send(tostring(self.name) .. " tells you, 'You can <b:green>say yes</> or <b:green>say no</>.'")
end