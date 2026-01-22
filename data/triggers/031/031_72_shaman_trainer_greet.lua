-- Trigger: shaman trainer greet
-- Zone: 31, ID: 72
-- Type: MOB, Flags: GREET
-- Status: CLEAN
--
-- Original DG Script: #3172

-- Converted from DG Script #3172: shaman trainer greet
-- Original: MOB trigger, flags: GREET, probability: 100%
wait(1)
if actor:get_quest_stage("trainer_3170") == 1 then
    if actor:get_quest_var("trainer_3170:lvl") then
        if actor:get_quest_var("trainer_3170:lvl") == actor.level then
            actor:send(tostring(self.name) .. " says, 'Have you returned to be trained in " .. tostring(actor:get_quest_var("trainer_3170:skill_name")) .. "?")
            return _return_value
        end
    end
    actor:send(tostring(self.name) .. " says, 'You've been gaining power, have you?  Perhaps you could use some training?'")
else
    actor.name:send(self.name .. " tells you, '" .. "Greetings adventurer.  Improving your skills taking too long?  I can help you for a fee." .. "'")
end