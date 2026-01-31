-- Trigger: p2_3eg_death_p2_55574_boss_18
-- Zone: 185, ID: 52
-- Type: MOB, Flags: GREET
-- Status: NEEDS_REVIEW
--   Complex nesting: 9 if statements
--
-- Original DG Script: #18552

-- Converted from DG Script #18552: p2_3eg_death_p2_55574_boss_18
-- Original: MOB trigger, flags: GREET, probability: 100%
-- Adapted from Eldorian quest.  There is no gear to destroy in this rendition.
-- mecho %self.name%'s gear is destroyed in the battle!
-- mjunk all.eldoria-reward
local trophy1_zone, trophy1_local = 55, 8
local trophy2_zone, trophy2_local = 55, 10
local trophy3_zone, trophy3_local = 55, 12
local trophy4_zone, trophy4_local = 55, 14
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
    self.room:spawn_object(trophy1_zone, trophy1_local)
elseif will_drop >= 51 and will_drop <= 70 then
    self.room:spawn_object(trophy2_zone, trophy2_local)
elseif will_drop >= 71 and will_drop <= 90 then
    self.room:spawn_object(trophy3_zone, trophy3_local)
else
    self.room:spawn_object(trophy4_zone, trophy4_local)
end
-- 
-- Death trigger for random gem and armor drops
-- 
-- set a random number to determine if a drop will
-- happen.
-- 
-- boss setup - 55574 boss
-- 
local bonus = random(1, 100)
local will_drop = random(1, 100)
-- 3 pieces of armor per sub_phase in phase_1
local what_armor_drop = random(1, 3)
-- 4 classes questing in phase_1
local what_gem_drop = random(1, 4)
-- 
if will_drop <= 20 then
    -- drop nothing and bail
    return _return_value
end
if will_drop <= 60 then
    -- Normal non-bonus drops
    if bonus <= 50 then
        -- drop a gem from the previous wear pos set
        self.room:spawn_object(555, what_gem_drop + 85)
    elseif bonus >= 51 and bonus <= 90 then
        -- We're in the Normal drops from current wear pos set
        -- drop a gem from the current wear pos set
        self.room:spawn_object(555, what_gem_drop + 89)
    else
        -- We're in the BONUS ROUND!!
        -- drop a gem from the next wear pos set
        self.room:spawn_object(555, what_gem_drop + 93)
    end
elseif will_drop >= 61 and will_drop <= 80 then
    -- Normal non-bonus drops
    if bonus <= 50 then
        -- drop destroyed armor 55299 is the vnum before the
        -- first piece of armor.
        self.room:spawn_object(553, what_armor_drop + 19)
    elseif bonus >= 51 and bonus <= 90 then
        -- We're in the Normal drops from current wear pos set
        -- drop armor from the current wear pos set
        self.room:spawn_object(553, what_armor_drop + 23)
    else
        -- We're in the BONUS ROUND!!
        -- drop a piece of armor from next wear pos
        self.room:spawn_object(553, what_armor_drop + 27)
    end
else
    -- Normal non-bonus drops
    if bonus <= 50 then
        -- drop armor and gem from previous wear pos
        self.room:spawn_object(555, what_gem_drop + 85)
        self.room:spawn_object(553, what_armor_drop + 19)
    elseif bonus >= 51 and bonus <= 90 then
        -- We're in the Normal drops from current wear pos set
        -- drop a gem and armor from the current wear pos set
        self.room:spawn_object(553, what_armor_drop + 23)
        self.room:spawn_object(555, what_gem_drop + 89)
    else
        -- We're in the BONUS ROUND!!
        -- drop armor and gem from next wear pos
        self.room:spawn_object(555, what_gem_drop + 93)
        self.room:spawn_object(553, what_armor_drop + 27)
    end
end