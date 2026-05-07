-- Trigger: supernova clue 1
-- Zone: 62, ID: 8
-- Type: OBJECT, Flags: LOOK
--
-- The first supernova clue scroll. Only readable by an actor who is on the
-- quest at stage 4+ AND carrying or wearing one of Phayla's lamps (489, 17);
-- otherwise the writing is gibberish. The actual clue text depends on the
-- random step4 chosen at quest stage 2.
--
-- Original DG Script: #6208

local stage = actor:get_quest_stage("supernova")
local readable = stage > 0 and stage >= 4 and (actor:has_item(489, 17) or actor:has_equipped(489, 17))

if readable then
    local step4 = actor:get_quest_var("supernova:step4")
    local clue2
    if step4 == 18577 then
        -- The Abbey, the rising sun room
        clue2 = "I continue my journey where the sun rises amidst a sea of swirling worlds."
    elseif step4 == 17277 then
        -- Citadel of Testing
        clue2 = "Atop a tower I visit a master who waits to give his final examination."
    elseif step4 == 8561 then
        -- Cathedral of Betrayal near Norisent
        clue2 = "I study in a secret place above a hall of misery beyond a gallery of horrors."
    end
    actor:send("Learning is a life-long process.")
    if clue2 then
        actor:send(clue2)
    end
else
    actor:send("The writings are just a bunch of indecipherable squiggles and lines.")
end
return true