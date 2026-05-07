-- Trigger: sagece_dragons_health_death
-- Zone: 586, ID: 7
-- Type: MOB, Flags: DEATH
-- Status: CLEAN
--
-- Original DG Script: #58607
-- Attached to Sagece of Raymif. When she dies during dragons_health stage 4,
-- mark the kill on the player's quest so the receive trigger will accept her
-- skin / shield / decoy items.
--
-- TODO: legacy script credited every group member in the room; the Lua actor
-- API does not yet expose group iteration, so only the killer is credited
-- here. Restore group crediting when bindings exist.

if actor and actor:get_quest_stage("dragons_health") == 4 then
    actor:set_quest_var("dragons_health", "sagece", 1)
end
