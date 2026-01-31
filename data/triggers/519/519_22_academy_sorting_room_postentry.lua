-- Trigger: academy_sorting_room_postentry
-- Zone: 519, ID: 22
-- Type: WORLD, Flags: POSTENTRY
-- Status: CLEAN
--
-- Original DG Script: #51922

-- Converted from DG Script #51922: academy_sorting_room_postentry
-- Original: WORLD trigger, flags: POSTENTRY, probability: 100%
if actor.id == -1 then
    if actor:get_quest_stage("school") == 2 then
        if not actor:get_quest_var("school:prep") then
            actor:set_quest_var("school", "prep", 1)
            get_room(519, 1):exit("east"):set_state({has_door = true, closed = true, hidden = true})
            get_room(519, 1):exit("east"):set_state({hidden = false})
            get_room(519, 1):exit("east"):set_state({name = "curtain"})
            get_room(519, 1):exit("east"):set_state({description = "The curtain conceals a hidden door to the east!"})
        end
    end
end