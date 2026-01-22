-- Trigger: Give_pork
-- Zone: 83, ID: 2
-- Type: MOB, Flags: GREET_ALL
-- Status: CLEAN
--
-- Original DG Script: #8302

-- Converted from DG Script #8302: Give_pork
-- Original: MOB trigger, flags: GREET_ALL, probability: 100%
if actor.id == -1 then
    if actor.alignment > 349 then
        self.room:spawn_object(83, 50)
        self:say("Eat up while it's still hot.")
        wait(1)
        self:command("give pork " .. tostring(actor.name))
        actor.name:command("eat pork")
    end
end