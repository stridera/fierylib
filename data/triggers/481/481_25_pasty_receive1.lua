-- Trigger: pasty_receive1
-- Zone: 481, ID: 25
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #48125

-- Converted from DG Script #48125: pasty_receive1
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
if object.id == 48101 then
    self:emote("examines the shell.")
    wait(2)
    self:command("cry")
    self.room:send(tostring(self.name) .. " says, 'This is a wonderful gift from my father, he forgives me for my cowardice.'")
    self:command("hol shell")
    wait(2)
    self:command("thanks " .. tostring(actor.name))
    self.room:send(tostring(self.name) .. " says, 'You have brought me hope in this dark place, so I will help you.'")
    wait(1)
    self:command("think")
    self.room:send(tostring(self.name) .. " says, 'There is a pit near here which is very deep, but it has a side tunnel partway down.'")
    wait(1)
    self:command("smile")
    self:say("I hope you find this information useful.")
end