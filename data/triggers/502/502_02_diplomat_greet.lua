-- Trigger: Diplomat greet
-- Zone: 502, ID: 2
-- Type: MOB, Flags: GREET
-- Status: CLEAN
--
-- Original DG Script: #50202

-- Converted from DG Script #50202: Diplomat greet
-- Original: MOB trigger, flags: GREET, probability: 100%
if actor.id == -1 and actor.level < 100 then
    wait(2)
    actor:send("The ghost of a diplomat stares at you for a moment.")
    self.room:send_except(actor, "The ghost of a diplomat stares at " .. tostring(actor.name) .. ".")
    wait(4)
    self.room:send(tostring(self.name) .. " says, 'Please forgive my rudeness.  It has been some")
    self.room:send("</>time since I was in the company of the living.'")
    self:command("sigh")
    wait(3)
    self:say("Since the accident...")
end