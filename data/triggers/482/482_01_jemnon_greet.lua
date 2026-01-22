-- Trigger: jemnon_greet
-- Zone: 482, ID: 1
-- Type: MOB, Flags: GREET
-- Status: CLEAN
--
-- Original DG Script: #48201

-- Converted from DG Script #48201: jemnon_greet
-- Original: MOB trigger, flags: GREET, probability: 100%
if actor.id == -1 then
    wait(2)
    actor:send(tostring(self.name) .. " says, 'Aaaaaaaaand who - '")
    wait(4)
    self:emote("hiccups.")
    wait(4)
    actor:send(tostring(self.name) .. " says, '- are you?'")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'You 'ere to 'ear the tales o' Jemnon the Lionhearted?!'")
    wait(1)
    actor:send(tostring(self.name) .. " says, 'Yeah?'")
    wait(1)
    actor:send(tostring(self.name) .. " says, 'Yeah??'")
    self:command("nudge " .. tostring(actor))
end