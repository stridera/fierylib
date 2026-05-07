-- Trigger: fly_away
-- Zone: 80, ID: 35
-- Type: MOB, Flags: FIGHT
-- Status: CLEAN
--
-- Original DG Script: #8035
-- During combat: if attacker is over level 30 and not on the
-- dragon_slayer quest at stage 3, the drakling flies off to a random
-- room in zone 80 (range 50..175) to escape high-level players.

if actor.level > 30 and actor:get_quest_stage("dragon_slayer") ~= 3 then
    local rnd_room = random(1, 126) + 49
    self.room:send(tostring(self.name) .. " flies off because you seem to be a bit too powerful.")
    self.room:send("(Let the newbies < 30 do this)")
    self.room:find_actor("drakling"):teleport(get_room(80, rnd_room))
end