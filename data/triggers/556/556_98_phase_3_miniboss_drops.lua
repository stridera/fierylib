-- Trigger: Phase 3 Miniboss Drops
-- Zone: 556, ID: 98
-- Type: MOB, Flags: DEATH
-- Status: CLEAN
--
-- Original DG Script: #55698

-- Converted from DG Script #55698: Phase 3 Miniboss Drops
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
-- 28 pieces of armor in phase_3
local what_armor_drop = random(1, 28)
-- 77 gems in phase_3
local what_gem_drop = random(1, 28)
-- 
if will_drop <= 30 then
    -- 30% to drop nothing
elseif will_drop <= 70 then
    -- 40% to drop a gem
    local gem_vnum = what_gem_drop + 55670
elseif will_drop >= 71 and will_drop <= 90 then
    -- 20% to drop armor
    local armor_vnum = what_armor_drop + 55355
    self.room:spawn_object(vnum_to_zone(armor_vnum), vnum_to_local(armor_vnum))
else
    -- 10% chance to drop armor and gem
    local gem_vnum = what_gem_drop + 55670
    local armor_vnum = what_armor_drop + 55355
    self.room:spawn_object(vnum_to_zone(gem_vnum), vnum_to_local(gem_vnum))
    self.room:spawn_object(vnum_to_zone(armor_vnum), vnum_to_local(armor_vnum))
end