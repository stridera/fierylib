-- Trigger: Phase 2 Miniboss Drops
-- Zone: 556, ID: 96
-- Type: MOB, Flags: DEATH
-- Status: CLEAN
--
-- Original DG Script: #55696

-- Converted from DG Script #55696: Phase 2 Miniboss Drops
-- Original: MOB trigger, flags: DEATH, probability: 100%
-- 
-- Death trigger for random gem and armor drops
-- 
-- set a random number to determine if a drop will
-- happen.
-- 
-- Miniboss setup
-- 
local bonus = random(1, 100)
local will_drop = random(1, 100)
-- 28 pieces of armor in phase_2
local what_armor_drop = random(1, 28)
-- 77 gems in phase_2
local what_gem_drop = random(1, 77)
-- 
if will_drop <= 30 then
    -- 30% to drop nothing
elseif will_drop <= 70 then
    -- 40% to drop a gem
    local gem_vnum = what_gem_drop + 55593
elseif will_drop >= 71 and will_drop <= 90 then
    -- 20% to drop armor
    local armor_vnum = what_armor_drop + 55327
    self.room:spawn_object(vnum_to_zone(armor_vnum), vnum_to_local(armor_vnum))
else
    -- 10% chance to drop armor and gem
    local gem_vnum = what_gem_drop + 55593
    local armor_vnum = what_armor_drop + 55327
    self.room:spawn_object(vnum_to_zone(gem_vnum), vnum_to_local(gem_vnum))
    self.room:spawn_object(vnum_to_zone(armor_vnum), vnum_to_local(armor_vnum))
end