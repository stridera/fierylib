-- Trigger: sexton_greet
-- Zone: 185, ID: 26
-- Type: MOB, Flags: GREET
--
-- Sexton greets a player who is on the current "macestep" stage of the
-- phase_mace upgrade quest, prompting them to talk about upgrades.
--
-- TODO(parity): the legacy `macestep` stage name and the global of the
-- same name are part of the phase_mace progression system used across
-- multiple zones. Need a runtime mechanism for "current step" before
-- this trigger can fire correctly.
wait(2)
if actor:get_quest_stage("phase_mace") == "macestep" then
    local minlevel = (macestep or 0) * 10
    if actor.level >= minlevel then
        if actor:get_quest_var("phase_mace:greet") == 0 then
            actor:send(tostring(self.name) .. " says, 'I sense a ghostly presence about your weapons.  If you want my help, we can talk about <b:cyan>[upgrades]</>.'")
        else
            actor:send(tostring(self.name) .. " says, 'Do you have what I need?'")
        end
    end
end