-- Trigger: Phase 3 Boss Drops
-- Zone: 556, ID: 99
-- Type: MOB, Flags: DEATH
-- Status: CLEAN
--
-- Original DG Script: #55699

-- Converted from DG Script #55699: Phase 3 Boss Drops
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
-- 28 pieces of armor in phase_1
local what_armor_drop = random(1, 28)
-- 28 gems in phase_1
local what_gem_drop = random(1, 28)
-- 
if will_drop <= 20 then
    -- 20% to drop nothing
elseif will_drop <= 60 then
    -- 40% to drop a gem
    local gem_vnum = what_gem_drop + 55670
elseif will_drop >= 61 and will_drop <= 80 then
    -- 20% to drop armor
    local armor_vnum = what_armor_drop + 55355
    self.room:spawn_object(vnum_to_zone(armor_vnum), vnum_to_local(armor_vnum))
else
    -- 20% chance to drop armor and gem
    local gem_vnum = what_gem_drop + 55670
    local armor_vnum = what_armor_drop + 55355
    self.room:spawn_object(vnum_to_zone(gem_vnum), vnum_to_local(gem_vnum))
    self.room:spawn_object(vnum_to_zone(armor_vnum), vnum_to_local(armor_vnum))
end