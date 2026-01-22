-- Trigger: overseer-receive
-- Zone: 133, ID: 24
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #13324

-- Converted from DG Script #13324: overseer-receive
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
if object.id == 13304 then
    wait(1)
    self:command("blink")
    self:say("This is mine.  It was stolen.")
    wait(1)
    self.room:send(tostring(self.name) .. " inspects the pickaxe carefully.")
    self:command("frown")
    self:say("It smells like lizard, so you couldn't have stolen it.")
    wait(2)
    self:command("shrug")
    self:say("I am in your debt for returning it.")
    self.room:spawn_object(133, 5)
    self:command("bow " .. tostring(actor.name))
    wait(1)
    self:say("Please accept these as a token of my gratitude.")
    self:command("give goggles " .. tostring(actor.name))
    wait(1)
    self:command("wield overseer-pickaxe")
    self.room:send(tostring(self.name) .. " gets back to work.")
else
    self:command("frown")
    self:say("No, that's not what's gone missing.")
    self:say("Youngsters these days all have rocks for brains.")
end