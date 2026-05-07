-- Trigger: quest_ranger_druid_subclass_heart_limiter
-- Zone: 163, ID: 7
-- Type: OBJECT, Flags: GET
--
-- Original DG Script: #16307
--
-- Pickup hook for the jewel of the heart: only advances stage 3 -> 4.
-- Stage 3 is the "go fetch the jewel" stage, so picking it up at any
-- other stage does nothing (gear-only loot).

if actor:get_quest_stage("ran_dru_subclass") == 3 then
    actor:advance_quest("ran_dru_subclass")
end
