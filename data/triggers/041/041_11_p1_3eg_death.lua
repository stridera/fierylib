-- Trigger: p1_3eg_death
-- Zone: 41, ID: 11
-- Type: MOB, Flags: DEATH
-- Status: CLEAN
--
-- p1 (tier 1) Eldorian Guard mob death drop. Has a 90% chance to drop one
-- of the four 3eg-side trophies (zone 55, ids 4/6/8/10) into the room for
-- Black Legion players to turn in via 041_03.
-- Original DG had a `mjunk all.eldoria-reward` pass intended to destroy any
-- equipped gem-rewards; that has not been ported.
--
-- Original DG Script: #4111

local id_trophy1 = 4
local id_trophy2 = 6
local id_trophy3 = 8
local id_trophy4 = 10
-- Roll for whether a trophy drops at all, then which tier it is.
local will_drop = random(1, 100)
if will_drop <= 10 then
    -- 10% chance: drop nothing and bail.
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