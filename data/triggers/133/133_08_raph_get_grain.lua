-- Trigger: raph_get_grain
-- Zone: 133, ID: 8
-- Type: OBJECT, Flags: GET
-- Status: CLEAN
--
-- Original DG Script: #13308
--
-- Fires when the player picks up the grain. If the actor is currently on
-- stage 1 of the get_raph_food quest ("fetch grain"), advance them to stage 2.
-- Picking up the grain off-quest produces no quest progress.
--
-- TODO(parity): the legacy converter emitted a never-set `already_retrieved_grain`
-- local plus a `globals.already_retrieved_grain or true` write. Both halves of the
-- pattern were dead code (the local read fired before the local declaration; the
-- global was never queried), so the anti-cheat / anti-dupe branch ("grain pass
-- between fingers, scratching") is unreachable. Original intent unclear without
-- the DG source for #13308 — likely a single-pickup gate per actor, but cannot
-- be confirmed. Leaving the success path only.
if actor.is_player then
    if actor:get_quest_stage("get_raph_food") == 1 then
        actor:advance_quest("get_raph_food")
    end
end
return true
