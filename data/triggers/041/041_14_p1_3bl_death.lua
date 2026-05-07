-- Trigger: p1_3bl_death
-- Zone: 41, ID: 14
-- Type: MOB, Flags: DEATH
-- Status: CLEAN
--
-- p1 (tier 1) Black Legion mob death drop. Has a 90% chance to drop one
-- of the four 3bl-side trophies (zone 55, ids 3/5/7/9) into the room for
-- Eldorian Guard players to turn in via 041_07.
-- Original DG had a `mjunk all.eldoria-reward` pass intended to destroy any
-- equipped gem-rewards; that has not been ported.
--
-- Original DG Script: #4114

local id_trophy1 = 3
local id_trophy2 = 5
local id_trophy3 = 7
local id_trophy4 = 9
local will_drop = random(1, 100)
if will_drop <= 10 then
    return true
end
if will_drop <= 50 then
    self.room:spawn_object(55, id_trophy1)
elseif will_drop <= 70 then
    self.room:spawn_object(55, id_trophy2)
elseif will_drop <= 90 then
    self.room:spawn_object(55, id_trophy3)
else
    self.room:spawn_object(55, id_trophy4)
end