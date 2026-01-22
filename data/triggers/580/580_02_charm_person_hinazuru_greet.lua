-- Trigger: charm_person_hinazuru_greet
-- Zone: 580, ID: 2
-- Type: MOB, Flags: GREET
-- Status: CLEAN
--
-- Original DG Script: #58002

-- Converted from DG Script #58002: charm_person_hinazuru_greet
-- Original: MOB trigger, flags: GREET, probability: 100%
local stage = actor:get_quest_stage("charm_person")
wait(2)
-- switch on stage
if stage == 1 then
    self:say("I see you have returned.")
    self:command("bow " .. tostring(actor.name))
    wait(1)
    self:say("Have you found " .. tostring(objects.template(480, 8).name) .. "?")
elseif stage == 2 then
    self:say("Welcome back.")
    self:command("bow " .. tostring(actor.name))
    wait(1)
    self:say("I hope you have been able to observe the methods of the troupe and return with a trophy.")
elseif stage == 3 then
    self:say("I am delighted to see you again.")
    self:command("bow " .. tostring(actor.name))
    wait(1)
    self:say("How is your search for the instruments coming along?  I truly look forward to hearing your tales.")
elseif stage == 4 then
    self.room:send(tostring(self.name) .. " says, 'Welcome back, I was not expecting to see you again so soon.  Are you having trouble locating your conversation partners?  I can update you on your <b:white>[spell progress]</> if you are.'")
else
    self:say("Welcome honored guest.")
    self:command("bow")
    wait(1)
    self:say("I am delighted to host you.")
    if (string.find(actor.class, "Sorcerer") or string.find(actor.class, "Illusionist") or string.find(actor.class, "Bard")) and actor.level > 88 and stage == 0 then
        wait(1)
        self:say("You seem like you might be interested in some of my specialty services.")
    end
end