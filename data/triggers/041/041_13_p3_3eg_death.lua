-- Trigger: p3_3eg_death
-- Zone: 41, ID: 13
-- Type: MOB, Flags: DEATH
-- Status: CLEAN
--
-- Original DG Script: #4113

-- Converted from DG Script #4113: p3_3eg_death
-- Original: MOB trigger, flags: DEATH, probability: 100%
-- Adapted from Eldorian quest.  There is no gear to destroy in this rendition.
-- mecho %self.name%'s gear is destroyed in the battle!
-- mjunk all.eldoria-reward
local vnum_trophy1 = 5510
local vnum_trophy2 = 5512
local vnum_trophy3 = 5514
local vnum_trophy4 = 5516
-- 
-- Death trigger for random trophy drops
-- 
-- set a random number to determine if a drop will
-- happen.
-- 
local will_drop = random(1, 100)
-- 
if will_drop <= 10 then
    -- drop nothing and bail
    return _return_value
end
if will_drop <= 50 then
    self.room:spawn_object(vnum_to_zone(vnum_trophy1), vnum_to_local(vnum_trophy1))
elseif will_drop >= 51 and will_drop <= 70 then
    self.room:spawn_object(vnum_to_zone(vnum_trophy2), vnum_to_local(vnum_trophy2))
elseif will_drop >= 71 and will_drop <= 90 then
    self.room:spawn_object(vnum_to_zone(vnum_trophy3), vnum_to_local(vnum_trophy3))
else
    self.room:spawn_object(vnum_to_zone(vnum_trophy4), vnum_to_local(vnum_trophy4))
end