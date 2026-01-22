-- Trigger: academy_recruiter_greet
-- Zone: 519, ID: 67
-- Type: MOB, Flags: GREET_ALL
-- Status: CLEAN
--
-- Original DG Script: #51967

-- Converted from DG Script #51967: academy_recruiter_greet
-- Original: MOB trigger, flags: GREET_ALL, probability: 100%
if actor.id == -1 then
    wait(3)
    if actor:get_quest_stage("school") == 0 then
        actor:send(tostring(self.name) .. " tells you, 'Hello there!  What kind of training are you here for?")
        actor:send("Type <b:green>say basic</> if you're brand new to MUDding.")
        actor:send("Type <b:green>say combat</> if you want to skip straight to FieryMUD's combat and spellcasting system.")
        actor:send("Type <b:green>say none</> to leave.'")
    elseif not actor:get_has_completed("school") then
        actor:send(tostring(self.name) .. " tells you, 'I see you had already started your lessons.")
        actor:send("<b:green>Say resume</> to continue where you left off.'")
    else
        actor:send(tostring(self.name) .. " tells you, 'I see you already finished your lessons.  Would you like to do them again?")
        actor:send("<b:green>Say basic</> to restart them.'")
    end
end