-- Trigger: academy_revel_greet
-- Zone: 519, ID: 58
-- Type: MOB, Flags: GREET_ALL
-- Status: CLEAN
--
-- Original DG Script: #51958

-- Converted from DG Script #51958: academy_revel_greet
-- Original: MOB trigger, flags: GREET_ALL, probability: 100%
wait(2)
if actor:get_quest_stage("school") == 5 then
    actor:send(tostring(self.name) .. " tells you, 'Congratulations on completing your combat training!")
    actor:send("I'm the last instructor in the Academy.")
    actor:send("I'm here to help you get down and party!'")
    self:command("dance")
    wait(2)
    actor:send(tostring(self.name) .. " tells you, 'After combat you'll probably have some downtime.")
    actor:send("It's a good time for <b:yellow>RESTING</> to recover health and dealing with <b:yellow>MONEY</>.'")
    wait(2)
    actor:send(tostring(self.name) .. " tells you, 'It looks like you still need to complete lessons on:")
    if actor:get_quest_var("school:rest") ~= "complete" then
        actor:send("<b:yellow>RESTING</>")
    end
    if actor:get_quest_var("school:money") ~= "complete" then
        actor:send("<b:yellow>MONEY</>")
    end
    actor:send("</>")
    actor:send("<b:green>Say</> one of these to start or resume your lesson where you left off.")
    actor:send("</>")
    actor:send("Or you can say <magenta>SKIP</> to skip to the end of the Academy.'")
elseif actor:get_quest_stage("school") == 6 then
    actor:send(tostring(self.name) .. " tells you, 'You're ready to graduate from Ethilien Academy!")
    actor:send("<b:green>Say finish</> to end the school.'")
end