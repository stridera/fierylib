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
            doors.set_flags(get_room(519, 1), "east", "abe")
            doors.set_state(get_room(519, 1), "east", {action = "room"})
            doors.set_name(get_room(519, 1), "east", "curtain")
            doors.set_description(get_room(519, 1), "east", "The curtain conceals a hidden door to the east!")
        end
    end
end