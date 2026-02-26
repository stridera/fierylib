-- Trigger: **UNUSED**
-- Zone: 185, ID: 51
-- Type: MOB, Flags: DEATH
-- Status: NEEDS_REVIEW
--   Complex nesting: 9 if statements
--
-- Original DG Script: #18551

-- Converted from DG Script #18551: **UNUSED**
-- Original: MOB trigger, flags: DEATH, probability: 100%
-- Adapted from Eldorian quest.  There is no gear to destroy in this rendition.
-- mecho %self.name%'s gear is destroyed in the battle!
-- mjunk all.eldoria-reward
local vnum_trophy1 = 8
local vnum_trophy2 = 10
local vnum_trophy3 = 12
local vnum_trophy4 = 14
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
end
if will_drop <= 50 then
    self.room:spawn_object(55, vnum_trophy1)
elseif will_drop >= 51 &will_drop <= 70 then
    self.room:spawn_object(55, vnum_trophy2)
elseif will_drop >= 71 &will_drop <= 90 then
    self.room:spawn_object(55, vnum_trophy3)
else
    self.room:spawn_object(55, vnum_trophy4)
end
-- 
-- Death trigger for random gem and armor drops
-- 
-- set a random number to determine if a drop will
-- happen.
-- 
-- boss setup
-- 
local bonus = random(1, 100)
local will_drop = random(1, 100)
-- 4 pieces of armor per sub_phase in phase_2
local what_armor_drop = random(1, 4)
-- 11 classes questing in phase_2
local what_gem_drop = random(1, 11)
-- 
if will_drop <= 20 then
    -- drop nothing and bail
    return _return_value
end
if will_drop <= 60 then
    -- Normal non-bonus drops
    if bonus <= 50 then
        -- drop a gem from the previous wear pos set
        self.room:spawn_object(555, 89 + what_gem_drop)
    elseif bonus >= 51 &bonus <= 90 then
        -- We're in the Normal drops from current wear pos set
        -- drop a gem from the current wear pos set
        self.room:spawn_object(555, 93 + what_gem_drop)
    else
        -- We're in the BONUS ROUND!!
        -- drop a gem from the next wear pos set
        self.room:spawn_object(556, 4 + what_gem_drop)
    end
elseif will_drop >=61 &will_drop <= 80 then
    -- Normal non-bonus drops
    if bonus <= 50 then
        -- drop destroyed armor 55299 is the vnum before the
        -- first piece of armor.
        self.room:spawn_object(553, 23 + what_armor_drop)
    elseif bonus >= 51 &bonus <= 90 then
        -- We're in the Normal drops from current wear pos set
        -- drop armor from the current wear pos set
        self.room:spawn_object(553, 27 + what_armor_drop)
    else
        -- We're in the BONUS ROUND!!
        -- drop a piece of armor from next wear pos
        self.room:spawn_object(553, 31 + what_armor_drop)
    end
else
    -- Normal non-bonus drops
    if bonus <= 50 then
        -- drop armor and gem from previous wear pos
        self.room:spawn_object(555, 89 + what_gem_drop)
        self.room:spawn_object(553, 23 + what_armor_drop)
    elseif bonus >= 51 &bonus <= 90 then
        -- We're in the Normal drops from current wear pos set
        -- drop a gem and armor from the current wear pos set
        self.room:spawn_object(553, 27 + what_armor_drop)
        self.room:spawn_object(555, 93 + what_gem_drop)
    else
        -- We're in the BONUS ROUND!!
        -- drop armor and gem from next wear pos
        self.room:spawn_object(556, 4 + what_gem_drop)
        self.room:spawn_object(553, 31 + what_armor_drop)
    end
end