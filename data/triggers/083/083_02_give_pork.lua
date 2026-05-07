-- Trigger: Give_pork
-- Zone: 83, ID: 2
-- Type: MOB, Flags: GREET_ALL
-- Status: CLEAN
--
-- Greet a sufficiently good-aligned player by spawning a piece of pork
-- (object 83/50), giving it to them, and forcing them to eat it.
--
-- Original DG Script: #8302
if actor.is_player then
    if actor.alignment > 349 then
        self.room:spawn_object(83, 50)
        self:say("Eat up while it's still hot.")
        wait(1)
        self:command("give pork " .. tostring(actor.name))
        actor:command("eat pork")
    end
end