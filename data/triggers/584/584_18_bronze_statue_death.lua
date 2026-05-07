-- Trigger: Bronze_statue_death
-- Zone: 584, ID: 18
-- Type: MOB, Flags: DEATH
-- Status: NEEDS_REVIEW
--
-- Original DG Script: #58418
--
-- TODO: the original DG script body for this DEATH trigger had no logic in
-- the converted output (only an empty `if` branch). It almost certainly was
-- meant to advance major_spell_quest from stage 5 to the next stage and/or
-- spawn the prize the bronze statue is guarding (the prize the Gypsy Prince
-- asks for in trigger 16). Re-check the original DG source for #58418
-- before declaring this clean — the quest cannot complete as-is.
if actor:get_quest_stage("major_spell_quest") == 5 then
    -- Intentionally empty until the original DG body is recovered.
end
return true