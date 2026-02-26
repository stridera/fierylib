-- Trigger: academy_instructor_command_give
-- Zone: 519, ID: 14
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #51914

-- Converted from DG Script #51914: academy_instructor_command_give
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
if actor:get_quest_var("school:gear") == 12 then
    actor:set_quest_var("school", "gear", 13)
    wait(2)
    world.destroy(object)
    actor:send(tostring(self.name) .. " tells you, 'Why thank you, what a lovely gift.'")
    self:command("grin")
    wait(2)
    actor:send(tostring(self.name) .. " tells you, 'Lastly, you can <b:cyan>(P)UT</> objects in containers.")
    actor:send("The command is <b:cyan>PUT [object] [container]</>.'")
    wait(2)
    actor:send(tostring(self.name) .. " tells you, 'You started with a bag, but just in case here's another.'")
    self.room:spawn_object(0, 18)
    self:command("give bag " .. tostring(actor))
    wait(3)
    actor:send(tostring(self.name) .. " tells you, 'Put a stick in it by typing <b:green>put stick bag</>.'")
end