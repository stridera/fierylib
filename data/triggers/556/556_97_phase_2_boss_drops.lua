-- Trigger: Phase 2 Boss Drops
-- Zone: 556, ID: 97
-- Type: MOB, Flags: DEATH
-- Status: CLEAN
--
-- Original DG Script: #55697

-- Converted from DG Script #55697: Phase 2 Boss Drops
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
local what_gem_drop = random(1, 28)
-- 
if will_drop <= 20 then
    -- 20% to drop nothing
elseif will_drop <= 60 then
    -- 40% to drop a gem
    local gem_vnum = what_gem_drop + 55593
elseif will_drop >= 61 and will_drop <= 80 then
    -- 20% to drop armor
    self.room:spawn_object(553, what_armor_drop + 27)
else
    -- 20% chance to drop armor and gem
    self.room:spawn_object(555, what_gem_drop + 93)
    self.room:spawn_object(553, what_armor_drop + 27)
end