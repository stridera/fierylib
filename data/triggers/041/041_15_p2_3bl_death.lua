-- Trigger: p2_3bl_death
-- Zone: 41, ID: 15
-- Type: MOB, Flags: DEATH
-- Status: CLEAN
--
-- p2 (tier 2) Black Legion mob death drop. Has a 90% chance to drop one
-- of the four 3bl-side trophies (zone 55, ids 7/9/11/13) into the room for
-- Eldorian Guard players to turn in via 041_07.
-- Original DG had a `mjunk all.eldoria-reward` pass intended to destroy any
-- equipped gem-rewards; that has not been ported.
--
-- Original DG Script: #4115

local id_trophy1 = 7
local id_trophy2 = 9
local id_trophy3 = 11
local id_trophy4 = 13
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