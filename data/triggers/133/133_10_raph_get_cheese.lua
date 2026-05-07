-- Trigger: raph_get_cheese
-- Zone: 133, ID: 10
-- Type: OBJECT, Flags: GET
-- Status: CLEAN
--
-- Original DG Script: #13310
--
-- Fires when the player picks up the cheese. If the actor is on stage 5 of
-- the get_raph_food quest ("fetch cheese"), advance them to stage 6.
--
-- TODO(parity): see 133_08 — same dead-code pattern in the converter for
-- the "cheese turns to mushy goo" anti-dupe branch. Intent unverifiable.
if actor.is_player then
    if actor:get_quest_stage("get_raph_food") == 5 then
        actor:advance_quest("get_raph_food")
    end
end
return true
