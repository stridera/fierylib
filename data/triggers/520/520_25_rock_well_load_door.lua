-- Trigger: rock_well_load_door
-- Zone: 520, ID: 25
-- Type: WORLD, Flags: GLOBAL
-- Status: CLEAN
--
-- Original DG Script: #52025

-- Converted from DG Script #52025: rock_well_load_door
-- Original: WORLD trigger, flags: GLOBAL, probability: 100%
get_room(22, 1):exit("up"):set_state({hidden = false})
get_room(22, 1):exit("up"):set_state({description = "A ruin mansion lies just above.  If only it was reachable."})
get_room(22, 1):exit("up"):set_state({name = "Basement Ceiling"})
local person = self.people
while person do
    if person:get_quest_stage("meteorswarm") == 2 or person:get_quest_var("meteorswarm:new") ~= "yes" then
        if person:get_quest_stage("meteorswarm") == 2 then
            person.name:advance_quest("meteorswarm")
        elseif person:get_quest_var("meteorswarm:new") ~= "yes" then
            person.name:set_quest_var("meteorswarm", "new", "no")
        end
        self.room:spawn_object(482, 52)
        self.room:send("A flaming meteor shoots off the towering rock demon, soars through the sky, and begins to fall toward the ground!")
    end
    local person = person.next_in_room
end