-- Trigger: academy_instructor_hello_class
-- Zone: 519, ID: 2
-- Type: MOB, Flags: SPEECH_TO
-- Status: CLEAN
--
-- Original DG Script: #51902

-- Converted from DG Script #51902: academy_instructor_hello_class
-- Original: MOB trigger, flags: SPEECH_TO, probability: 0%

-- 0% chance to trigger
if not percent_chance(0) then
    return true
end
if actor:get_quest_var("school:speech") == 1 then
    actor:set_quest_var("school", "speech", 2)
    wait(2)
    actor:send(tostring(self.name) .. " tells you, 'Exactly!'")
    wait(1)
    actor:send(tostring(self.name) .. " tells you, 'You can talk to one person at a time by using the <b:cyan>(T)ELL</> command.")
    actor:send("Only the person you TELL to will hear what you say.")
    actor:send("You can talk to anyone, anywhere in the world.")
    actor:send("You do it by typing <b:cyan>tell [person] [message]</>'")
    wait(3)
    actor:send(tostring(self.name) .. " tells you, 'Try typing <b:green>tell instructor hello teacher</>.'")
end