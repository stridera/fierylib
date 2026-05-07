-- Trigger: mheal
-- Zone: 488, ID: 11
-- Type: OBJECT, Flags: COMMAND
-- Status: REVIEWED
--
-- Original DG Script: #48811
--
-- Behavior: Builder/admin scaffolding. Intercepts the `mheal <amount>`
-- command on whoever wears/holds this object and heals the actor by that
-- amount. Charmed actors are skipped.
-- TODO: confirm runtime API — `arg` arrives as the raw command argument
-- string; `actor:heal` may need an integer (`tonumber(arg)`). Leave as-is if
-- the binding already coerces.

-- Command filter: mheal
if not (cmd == "mheal") then
    return true  -- Not our command
end
if (actor.id > 0) and not actor:has_effect(Effect.Charm) then
    actor:heal(tonumber(arg) or 0)
end
return true