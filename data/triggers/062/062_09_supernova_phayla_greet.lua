-- Trigger: supernova_phayla_greet
-- Zone: 62, ID: 9
-- Type: MOB, Flags: GREET
-- Status: CLEAN
--
-- Original DG Script: #6209

-- Converted from DG Script #6209: supernova_phayla_greet
-- Original: MOB trigger, flags: GREET, probability: 100%
wait(1)
if actor:get_quest_stage("supernova") == 7 then
    self.room:send(tostring(self.name) .. " says, 'Ah, so you found me " .. tostring(actor.name) .. ".  I was wondering if you would")
    self.room:send("</>make it.'")
    wait(2)
    self:emote("settles back in a chair.")
    wait(1)
    self.room:send(tostring(self.name) .. " says, 'So, why are you here?  Normal people don't just barge into")
    self.room:send("</>someone's home without good reason.  Come on, out with it!'")
else
    self:command("eye " .. tostring(actor.name))
    wait(2)
    self:command("blink")
    wait(1)
    self:say("And who might you be?  You're not at all who I was expecting...")
end