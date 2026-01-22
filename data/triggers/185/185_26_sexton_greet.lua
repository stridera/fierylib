-- Trigger: Sexton greet
-- Zone: 185, ID: 26
-- Type: MOB, Flags: GREET
-- Status: CLEAN
--
-- Original DG Script: #18526

-- Converted from DG Script #18526: Sexton greet
-- Original: MOB trigger, flags: GREET, probability: 100%
wait(2)
if actor:get_quest_stage("phase_mace") == "macestep" then
    local minlevel = macestep * 10
    if actor.level >= minlevel then
        if actor:get_quest_var("phase_mace:greet") == 0 then
            actor:send(tostring(self.name) .. " says, 'I sense a ghostly presence about your weapons.  If you want my help, we can talk about <b:cyan>[upgrades]</>.'")
        else
            actor:send(tostring(self.name) .. " says, 'Do you have what I need?'")
        end
    end
end