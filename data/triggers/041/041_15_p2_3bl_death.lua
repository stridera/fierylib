-- Trigger: p2_3bl_death
-- Zone: 41, ID: 15
-- Type: MOB, Flags: DEATH
-- Status: CLEAN
--
-- Original DG Script: #4115

-- Converted from DG Script #4115: p2_3bl_death
-- Original: MOB trigger, flags: DEATH, probability: 100%
-- Adapted from Eldorian quest.  There is no gear to destroy in this rendition.
-- mecho %self.name%'s gear is destroyed in the battle!
-- mjunk all.eldoria-reward
-- Trophy vnums are all in zone 55
local trophy1_zone, trophy1_local = 55, 7
local trophy2_zone, trophy2_local = 55, 9
local trophy3_zone, trophy3_local = 55, 11
local trophy4_zone, trophy4_local = 55, 13
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
    self.room:spawn_object(trophy1_zone, trophy1_local)
elseif will_drop >= 51 and will_drop <= 70 then
    self.room:spawn_object(trophy2_zone, trophy2_local)
elseif will_drop >= 71 and will_drop <= 90 then
    self.room:spawn_object(trophy3_zone, trophy3_local)
else
    self.room:spawn_object(trophy4_zone, trophy4_local)
end