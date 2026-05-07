-- Trigger: p2_3eg_death
-- Zone: 41, ID: 12
-- Type: MOB, Flags: DEATH
-- Status: CLEAN
--
-- p2 (tier 2) Eldorian Guard mob death drop. Has a 90% chance to drop one
-- of the four 3eg-side trophies (zone 55, ids 8/10/12/14) into the room for
-- Black Legion players to turn in via 041_03.
-- Original DG had a `mjunk all.eldoria-reward` pass intended to destroy any
-- equipped gem-rewards; that has not been ported.
--
-- Original DG Script: #4112

local id_trophy1 = 8
local id_trophy2 = 10
local id_trophy3 = 12
local id_trophy4 = 14
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