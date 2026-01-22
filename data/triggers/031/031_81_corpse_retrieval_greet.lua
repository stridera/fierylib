-- Trigger: corpse retrieval greet
-- Zone: 31, ID: 81
-- Type: MOB, Flags: GREET
-- Status: CLEAN
--
-- Original DG Script: #3181

-- Converted from DG Script #3181: corpse retrieval greet
-- Original: MOB trigger, flags: GREET, probability: 100%
if actor.id == -1 then
    wait(4)
    self.room:send(tostring(self.name) .. " says, 'Welcome to the headquarters of the Bloody Red Cross.  We provide")
    self.room:send("</>corpse retrieval services for unlucky adventurers.'")
    wait(1)
    self:say("Are you in need of a corpse retrieval?")
end