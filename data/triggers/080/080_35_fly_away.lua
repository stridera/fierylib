-- Trigger: fly_away
-- Zone: 80, ID: 35
-- Type: MOB, Flags: FIGHT
-- Status: CLEAN
--
-- Original DG Script: #8035

-- Converted from DG Script #8035: fly_away
-- Original: MOB trigger, flags: FIGHT, probability: 100%
-- 
-- this is intended to make the creature fly off
-- to a random room to avoid high levels killing
-- it..
-- 
-- Exception written in to allow players on the
-- dragon hunt to kill them.
-- 
-- Generate random room number to spawn drakes in.
-- Thanks to the evil Pergus for inspiring me to be
-- more evil.
if actor.level > 30 and actor:get_quest_stage("dragon_slayer") ~= 3 then
    local rnd_range = random(1, 126)
    local rnd_room = rnd_range + 8049
    self.room:send(tostring(self.name) .. " flies off because you seem to be a bit to powerful.")
    self.room:send("(Let the newbies < 30 do this)")
    self.room:find_actor("drakling"):teleport(find_room_by_name("%rnd_room%"))
end