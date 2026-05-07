-- Trigger: raph_get_donuts
-- Zone: 133, ID: 9
-- Type: OBJECT, Flags: GET
-- Status: CLEAN
--
-- Original DG Script: #13309
--
-- Fires when the player picks up the donuts. If the actor is on stage 3 of
-- the get_raph_food quest ("fetch donuts"), advance them to stage 4.
--
-- TODO(parity): see 133_08 — same dead-code pattern in the converter for
-- the "donuts crumble to dust" anti-dupe branch. Intent unverifiable.
if actor.is_player then
    if actor:get_quest_stage("get_raph_food") == 3 then
        actor:advance_quest("get_raph_food")
    end
end
return true
