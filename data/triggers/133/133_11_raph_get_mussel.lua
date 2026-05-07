-- Trigger: raph_get_mussel
-- Zone: 133, ID: 11
-- Type: OBJECT, Flags: GET
-- Status: CLEAN
--
-- Original DG Script: #13311
--
-- Fires when the player picks up the mussel. If the actor is on stage 7 of
-- the get_raph_food quest ("fetch mussel"), advance them to stage 8.
--
-- TODO(parity): see 133_08 — same dead-code pattern in the converter for
-- the "mussel slips from fingers" anti-dupe branch. Intent unverifiable.
if actor.is_player then
    if actor:get_quest_stage("get_raph_food") == 7 then
        actor:advance_quest("get_raph_food")
    end
end
return true
