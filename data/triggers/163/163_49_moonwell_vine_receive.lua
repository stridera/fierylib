-- Trigger: Moonwell Vine Receive
-- Zone: 163, ID: 49
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #16349

-- Converted from DG Script #16349: Moonwell Vine Receive
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
if actor:get_quest_stage("moonwell_spell_quest") == 1 then
    wait(2)
    self:destroy_item("vine")
    actor:send(tostring(self.name) .. " tells you, 'How did you get this?  No, go get it yourself.'")
elseif actor:get_quest_stage("moonwell_spell_quest") == 2 then
    wait(2)
    self:destroy_item("vine")
    actor.name:advance_quest("moonwell_spell_quest")
    actor:send(tostring(self.name) .. " tells you, 'Very good.  I can now lay out the well's boundaries.'")
    wait(10)
    self.room:send(tostring(self.name) .. " places the vine in a small circle on the ground.")
    self:command("smile " .. tostring(actor.name))
    wait(10)
    actor:send(tostring(self.name) .. " tells you, 'Excellent.  Now we must have stone.  Of course there is")
    actor:send("</>plenty of stone here, but we need to have a stone with significant energy to")
    actor:send("</>act as a magical anchor point.'")
    wait(15)
    actor:send(tostring(self.name) .. " tells you, 'Far to the north there is an ancient burial site.  Within")
    actor:send("</>its catacombs lays a stone of great power, shaped like a heart.  Obtain this")
    actor:send("</>stone and it will surely increase our well's power.'")
    wait(5)
    actor:send(tostring(self.name) .. " tells you, 'Go now while I continue construction of our well.'")
    wait(20)
    self.room:send(tostring(self.name) .. " begins to collect some rocks and place them around the vine circle.")
end