-- Trigger: blur_vulcera_death
-- Zone: 18, ID: 36
-- Type: MOB, Flags: DEATH
-- Status: CLEAN
--
-- Original DG Script: #1836

-- Converted from DG Script #1836: blur_vulcera_death
-- Original: MOB trigger, flags: DEATH, probability: 100%
-- TODO(parity): legacy room vnum 12597 was the East Wind's lair (volcano caldera).
-- Translate to composite (zone_id, local_id) once verified; current best guess (125, 97).
-- TODO(parity): legacy iterated actor.group_member[]/next_in_room. Rewritten to
-- iterate the death room's actors (covers solo + grouped East-wind quest holders).
local east_wind_name = mobiles.template(18, 21).name
local lair = get_room(125, 97)
local lair_name = lair and lair.name or "the East Wind's lair"
if world.count_mobiles(18, 21) <= 0 then
    return true
end
for _, person in ipairs(self.room.actors) do
    if person.is_player and (person:get_quest_stage("blur") == 4) and (not person:get_quest_var("blur:east")) then
        person:send(tostring(east_wind_name) .. " thanks you heartily!")
        self.room:send_except(person, tostring(east_wind_name) .. " thanks " .. tostring(person.name) .. " heartily!")
        person:send(tostring(east_wind_name) .. " tells you, 'See if you can get to<b:yellow> " .. tostring(lair_name) .. " </>first!'")
        person:send("'I already started the clock...'")
        self.room:send(tostring(east_wind_name) .. " takes off like a rocket and vanishes!")
        person:set_quest_var("blur", "east", 1)
    end
end