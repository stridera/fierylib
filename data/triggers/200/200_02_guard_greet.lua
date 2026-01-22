-- Trigger: guard greet
-- Zone: 200, ID: 2
-- Type: MOB, Flags: GREET
-- Status: CLEAN
--
-- Original DG Script: #20002

-- Converted from DG Script #20002: guard greet
-- Original: MOB trigger, flags: GREET, probability: 100%
if actor.id == -1 then
    if direction == "west" then
        if actor.alignment > -350 then
            actor:send(tostring(self.name) .. " says to you, 'I cannot allow you to pass this point.'")
            actor:send(tostring(self.name) .. " stands in your way.")
        else
            actor:send(tostring(self.name) .. " nods at you.")
            actor:send(tostring(self.name) .. " says to you, 'Welcome to the Blackthorn Abbey.'")
        end
    end
end