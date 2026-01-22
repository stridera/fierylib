-- Trigger: charm_person_hinazuru_pay
-- Zone: 580, ID: 4
-- Type: MOB, Flags: BRIBE
-- Status: CLEAN
--
-- Original DG Script: #58004

-- Converted from DG Script #58004: charm_person_hinazuru_pay
-- Original: MOB trigger, flags: BRIBE, probability: 100000%
if (string.find(actor.class, "Sorcerer") or string.find(actor.class, "Illusionist") or string.find(actor.class, "Bard")) and actor.level > 88 and actor:get_quest_stage("charm_person") == 0 then
    actor.name:start_quest("charm_person")
    self:command("bow " .. tostring(actor.name))
    self:say("I give humble thanks for your payment.")
    wait(2)
    self:say("The first thing you will need is an implement which casts the spell you seek to learn so you may experiment with it.")
    wait(2)
    self:say("Only one such item exists in the world: a simple black metal rod buried in an extensive crypt in the Iron Hills.")
    wait(2)
    self:say("Please retrieve it and bring it back to me.")
    self:command("bow " .. tostring(actor.name))
    wait(1)
    self.room:send(tostring(self.name) .. " says, 'During this training, if you need to check your <b:white>[spell progress]</>, you may ask at any time.'")
    self:command("bow " .. tostring(actor.name))
else
    self:say("I am deeply honored by your gratuity.")
    self:command("bow " .. tostring(actor.name))
end