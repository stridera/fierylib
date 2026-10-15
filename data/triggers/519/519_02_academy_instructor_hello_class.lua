-- Trigger: academy_instructor_hello_class
-- Zone: 519, ID: 2
-- Type: MOB, Flags: SPEECH_TO
-- Status: CLEAN
--
-- Original DG Script: #51902

-- Converted from DG Script #51902: academy_instructor_hello_class
-- Original: MOB trigger, flags: SPEECH_TO, probability: 0%

-- Speech phrase: hello class (DG num_arg 0 = the speech contains the whole phrase, on word boundaries)
local speech_padded = " " .. string.lower(speech) .. " "
if not string.find(speech_padded, "[%s%p]hello class[%s%p]") then
    return true  -- Not the phrase
end
if (actor:get_quest_var("school:speech") or 0) == 1 then
    actor:set_quest_var("school", "speech", 2)
    wait(0.2)
    actor:send(tostring(self.name) .. " tells you, 'Exactly!'")
    wait(1)
    actor:send(tostring(self.name) .. " tells you, 'You can talk to one person at a time by using the <b:cyan>(T)ELL</> command.")
    actor:send("Only the person you TELL to will hear what you say.")
    actor:send("You can talk to anyone, anywhere in the world.")
    actor:send("You do it by typing <b:cyan>tell [person] [message]</>'")
    wait(3)
    actor:send(tostring(self.name) .. " tells you, 'Try typing <b:green>tell instructor hello teacher</>.'")
end