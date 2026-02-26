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
local vnum_trophy1 = 5508
local vnum_trophy2 = 5510
local vnum_trophy3 = 5512
local vnum_trophy4 = 5514
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
    self.room:spawn_object(vnum_to_zone(vnum_trophy1), vnum_to_local(vnum_trophy1))
elseif will_drop >= 51 &will_drop <= 70 then
    self.room:spawn_object(vnum_to_zone(vnum_trophy2), vnum_to_local(vnum_trophy2))
elseif will_drop >= 71 &will_drop <= 90 then
    self.room:spawn_object(vnum_to_zone(vnum_trophy3), vnum_to_local(vnum_trophy3))
else
    self.room:spawn_object(vnum_to_zone(vnum_trophy4), vnum_to_local(vnum_trophy4))
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
        local gem_vnum = what_gem_drop + 55589
        self.room:spawn_object(vnum_to_zone(gem_vnum), vnum_to_local(gem_vnum))
    elseif bonus >= 51 &bonus <= 90 then
        -- We're in the Normal drops from current wear pos set
        -- drop a gem from the current wear pos set
        local gem_vnum = what_gem_drop + 55593
        self.room:spawn_object(vnum_to_zone(gem_vnum), vnum_to_local(gem_vnum))
    else
        -- We're in the BONUS ROUND!!
        -- drop a gem from the next wear pos set
        local gem_vnum = what_gem_drop + 55604
        self.room:spawn_object(vnum_to_zone(gem_vnum), vnum_to_local(gem_vnum))
    end
elseif will_drop >=61 &will_drop <= 80 then
    -- Normal non-bonus drops
    if bonus <= 50 then
        -- drop destroyed armor 55299 is the vnum before the
        -- first piece of armor.
        local armor_vnum = what_armor_drop + 55323
        self.room:spawn_object(vnum_to_zone(armor_vnum), vnum_to_local(armor_vnum))
    elseif bonus >= 51 &bonus <= 90 then
        -- We're in the Normal drops from current wear pos set
        -- drop armor from the current wear pos set
        local armor_vnum = what_armor_drop + 55327
        self.room:spawn_object(vnum_to_zone(armor_vnum), vnum_to_local(armor_vnum))
    else
        -- We're in the BONUS ROUND!!
        -- drop a piece of armor from next wear pos
        local armor_vnum = what_armor_drop + 55331
        self.room:spawn_object(vnum_to_zone(armor_vnum), vnum_to_local(armor_vnum))
    end
else
    -- Normal non-bonus drops
    if bonus <= 50 then
        -- drop armor and gem from previous wear pos
        local gem_vnum = what_gem_drop + 55589
        local armor_vnum = what_armor_drop + 55323
        self.room:spawn_object(vnum_to_zone(gem_vnum), vnum_to_local(gem_vnum))
        self.room:spawn_object(vnum_to_zone(armor_vnum), vnum_to_local(armor_vnum))
    elseif bonus >= 51 &bonus <= 90 then
        -- We're in the Normal drops from current wear pos set
        -- drop a gem and armor from the current wear pos set
        local armor_vnum = what_armor_drop + 55327
        self.room:spawn_object(vnum_to_zone(armor_vnum), vnum_to_local(armor_vnum))
        local gem_vnum = what_gem_drop + 55593
        self.room:spawn_object(vnum_to_zone(gem_vnum), vnum_to_local(gem_vnum))
    else
        -- We're in the BONUS ROUND!!
        -- drop armor and gem from next wear pos
        local gem_vnum = what_gem_drop + 55604
        self.room:spawn_object(vnum_to_zone(gem_vnum), vnum_to_local(gem_vnum))
        local armor_vnum = what_armor_drop + 55331
        self.room:spawn_object(vnum_to_zone(armor_vnum), vnum_to_local(armor_vnum))
    end
end