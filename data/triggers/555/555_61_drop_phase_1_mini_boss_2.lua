-- Trigger: drop_phase_1_mini_boss_2
-- Zone: 555, ID: 61
-- Type: MOB, Flags: DEATH
-- Status: NEEDS_REVIEW
--   Complex nesting: 6 if statements
--
-- Original DG Script: #55561

-- Converted from DG Script #55561: drop_phase_1_mini_boss_2
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
-- 3 pieces of armor per sub_phase in phase_1
local what_armor_drop = random(1, 3)
-- 4 classes questing in phase_1
local what_gem_drop = random(1, 4)
-- 
if will_drop <= 30 then
    -- drop nothing and bail
    return _return_value
end
if will_drop <= 70 then
    -- Normal non-bonus drops
    if bonus <= 90 then
        -- drop a gem 55565 is the vnum before very first gem
        local gem_vnum = what_gem_drop + 55565
        self.room:spawn_object(vnum_to_zone(gem_vnum), vnum_to_local(gem_vnum))
    else
        -- We're in the BONUS ROUND!!
        -- drop a gem from the next wear pos set
        local gem_vnum = what_gem_drop + 55569
        self.room:spawn_object(vnum_to_zone(gem_vnum), vnum_to_local(gem_vnum))
    end
elseif will_drop >= 71 and will_drop <= 90 then
    -- Normal non-bonus drops
    if bonus <= 90 then
        -- drop destroyed armor 55299 is the vnum before the
        -- first piece of armor.
        local armor_vnum = what_armor_drop + 55299
        self.room:spawn_object(vnum_to_zone(armor_vnum), vnum_to_local(armor_vnum))
    else
        -- We're in the BONUS ROUND!!
        -- drop a piece of armor from next wear pos
        local armor_vnum = what_armor_drop + 55303
        self.room:spawn_object(vnum_to_zone(armor_vnum), vnum_to_local(armor_vnum))
    end
else
    -- Normal non-bonus drops
    if bonus <= 90 then
        -- drop armor and gem
        local gem_vnum = what_gem_drop + 55565
        local armor_vnum = what_armor_drop + 55299
        self.room:spawn_object(vnum_to_zone(armor_vnum), vnum_to_local(armor_vnum))
        self.room:spawn_object(vnum_to_zone(gem_vnum), vnum_to_local(gem_vnum))
    else
        -- We're in the BONUS ROUND!!
        -- drop armor and gem from next wear pos
        local gem_vnum = what_gem_drop + 55569
        self.room:spawn_object(vnum_to_zone(gem_vnum), vnum_to_local(gem_vnum))
        local armor_vnum = what_armor_drop + 55303
        self.room:spawn_object(vnum_to_zone(armor_vnum), vnum_to_local(armor_vnum))
    end
end