-- Trigger: rock_well_load_door
-- Zone: 520, ID: 25
-- Type: WORLD, Flags: GLOBAL
-- Status: CLEAN
--
-- Original DG Script: #52025
-- Sub-routine for the rock-well death: re-seals the basement-ceiling exit
-- in the connected ruin (zone 22, room 1) and hands every actor still in
-- the room the meteorswarm-quest meteorite focus (object 481:152), the
-- same as rock_demon_call_rock (520:0).
-- TODO(parity): get_room(22, 1) - confirm the cross-zone reference is
-- correct (legacy vnum 22 mapped to (zone=22, id=1)). Original DG used
-- room 2201; if the import re-keyed the ruin zone this needs updating.

local upexit = get_room(22, 1):exit("up")
upexit:set_state({
    hidden = false,
    description = "A ruin mansion lies just above.  If only it was reachable.",
    name = "Basement Ceiling",
})

local person = self.people
while person do
    if person:get_quest_stage("meteorswarm") == 2 or person:get_quest_var("meteorswarm:new") ~= "yes" then
        if person:get_quest_stage("meteorswarm") == 2 then
            person:advance_quest("meteorswarm")
        elseif person:get_quest_var("meteorswarm:new") ~= "yes" then
            person:set_quest_var("meteorswarm", "new", "no")
        end
        self.room:spawn_object(481, 152)
        self.room:send("A flaming meteor shoots off the towering rock demon, soars through the sky, and begins to fall toward the ground!")
    end
    person = person.next_in_room
end