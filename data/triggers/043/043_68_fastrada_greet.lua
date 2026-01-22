-- Trigger: fastrada_greet
-- Zone: 43, ID: 68
-- Type: MOB, Flags: GREET
-- Status: CLEAN
--
-- Original DG Script: #4368

-- Converted from DG Script #4368: fastrada_greet
-- Original: MOB trigger, flags: GREET, probability: 100%
if self.room == 4353 and actor:get_quest_stage("theatre") == 3 then
    wait(2)
    actor:send("Fastrada tosses a sultry smile your way.")
    self.room:send_except(actor, "Fastrada puts on a sultry smile.")
    wait(3)
    self.room:send(tostring(self.name) .. " says, 'Thank you for letting me out of here.  Please, allow me to")
    self.room:send("</>to repay you in the future.'")
    self:command("wink " .. tostring(actor.name))
    wait(1)
    self.room:send(tostring(self.name) .. " says, 'But first things first - may I have my dressing room key back")
    self.room:send("</>please?'")
end