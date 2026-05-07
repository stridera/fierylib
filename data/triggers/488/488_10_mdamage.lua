-- Trigger: mdamage
-- Zone: 488, ID: 10
-- Type: OBJECT, Flags: COMMAND
-- Status: REVIEWED
--
-- Original DG Script: #48810
--
-- Behavior: Builder/admin scaffolding. Intercepts the `mdamage <amount>`
-- command on whoever wears/holds this object and applies that amount of damage
-- to the actor. Charmed actors are skipped to avoid pets self-killing.
-- TODO: confirm runtime API — `arg` arrives as the raw command argument
-- string; `actor:damage` may need an integer (`tonumber(arg)`). Leave as-is
-- if the binding already coerces.

-- Command filter: mdamage
if not (cmd == "mdamage") then
    return true  -- Not our command
end
if (actor.id > 0) and not actor:has_effect(Effect.Charm) then
    actor:damage(tonumber(arg) or 0)
end
return true