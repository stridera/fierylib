-- Trigger: Julks greet
-- Zone: 31, ID: 62
-- Type: MOB, Flags: GREET
-- Status: CLEAN
--
-- Original DG Script: #3162

-- Converted from DG Script #3162: Julks greet
-- Original: MOB trigger, flags: GREET, probability: 100%
wait(1)
if actor:get_quest_stage("trainer_3160") == 1 then
    if actor:get_quest_var("trainer_3160:actor_level") == actor.level then
        actor:send(tostring(self.name) .. " says, 'Have you returned to be trained in " .. tostring(actor:get_quest_var("trainer_3160:skill_name")) .. "?'")
        return _return_value
    else
        actor:send(tostring(self.name) .. " says, 'You've been out adventuring, have you?  Perhaps you could use some training?'")
    end
else
    actor.name:send(self.name .. " tells you, '" .. "Greetings adventurer.  Improving your skills taking too long?  I can help you for a fee." .. "'")
end