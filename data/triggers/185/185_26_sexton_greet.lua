-- Trigger: sexton_greet
-- Zone: 185, ID: 26
-- Type: MOB, Flags: GREET
--
-- Sexton greets a player who is on the current "macestep" stage of the
-- phase_mace upgrade quest, prompting them to talk about upgrades.
--
-- `macestep` is a DG global set on this mob by its LOAD trigger (002_118); it is read from the
-- mob's `globals` table.
wait(2)
if actor:get_quest_stage("phase_mace") == globals.macestep then
    local minlevel = (globals.macestep or 0) * 10
    if actor.level >= minlevel then
        if (actor:get_quest_var("phase_mace:greet") or 0) == 0 then
            actor:send(tostring(self.name) .. " says, 'I sense a ghostly presence about your weapons.  If you want my help, we can talk about <b:cyan>[upgrades]</>.'")
        else
            actor:send(tostring(self.name) .. " says, 'Do you have what I need?'")
        end
    end
end