-- Trigger: Torturer_death_resurrect_quest
-- Zone: 85, ID: 52
-- Type: MOB, Flags: GREET
-- Status: CLEAN
--
-- Original DG Script: #8552

-- Converted from DG Script #8552: Torturer_death_resurrect_quest
-- Original: MOB trigger, flags: GREET, probability: 100%
if actor.id == -1 then
    if actor.class == "cleric" or actor.class == "priest" or actor.class == "diabolist" then
        if actor:get_quest_stage("resurrection_quest") == 2 then
            self.room:spawn_object(85, 4)
        end
    end
end