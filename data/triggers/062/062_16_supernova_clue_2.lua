-- Trigger: supernova clue 2
-- Zone: 62, ID: 16
-- Type: OBJECT, Flags: LOOK
--
-- Second supernova clue scroll. Readable only by a stage 5+ supernova questor
-- who is carrying/wearing Phayla's lamp (489, 17); points to the next quest
-- destination based on the random step5 selected earlier.
--
-- Original DG Script: #6216

local stage = actor:get_quest_stage("supernova")
local readable = stage > 0 and stage >= 5 and (actor:has_item(489, 17) or actor:has_equipped(489, 17))

if readable then
    local step5 = actor:get_quest_var("supernova:step5")
    local clue3
    if step5 == 53219 then
        -- Lizard King's throne room, Sunken
        clue3 = "Where DID the lizard men get that throne from?  I'll see if I can find out."
    elseif step5 == 47343 then
        -- Kryzanthor, Graveyard
        clue3 = "They often wonder what would happen if bones could talk.  I'll ask one who can make that happen!"
    elseif step5 == 16278 then
        -- Imanhotep, Pyramid
        clue3 = "Waves of sand hold the remains of a child of the Sun God.  Supposedly.  I'll have to see for myself."
    end
    actor:send("History is so fascinating!")
    if clue3 then
        actor:send(clue3)
    end
else
    actor:send("The writings are just a bunch of indecipherable squiggles and lines.")
end
return true