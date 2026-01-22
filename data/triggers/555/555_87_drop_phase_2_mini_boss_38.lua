-- Trigger: drop_phase_2_mini_boss_38
-- Zone: 555, ID: 87
-- Type: MOB, Flags: DEATH
-- Status: NEEDS_REVIEW
--   Complex nesting: 6 if statements
--
-- Original DG Script: #55587

-- Converted from DG Script #55587: drop_phase_2_mini_boss_38
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
-- 4 pieces of armor per sub_phase in phase_2
local what_armor_drop = random(1, 4)
-- 11 classes questing in phase_2
local what_gem_drop = random(1, 11)
-- 
if will_drop <= 30 then
    -- drop nothing and bail
    return _return_value
end
if will_drop <= 70 then
    -- Normal non-bonus drops
    if bonus <= 50 then
        -- drop a gem from the previous wear pos set
        local gem_vnum = what_gem_drop + 55648
        self.room:spawn_object(vnum_to_zone(gem_vnum), vnum_to_local(gem_vnum))
    elseif bonus >= 51 and bonus <= 90 then
        -- We're in the Normal drops from current wear pos set
        -- drop a gem from the current wear pos set
        local gem_vnum = what_gem_drop + 55659
        self.room:spawn_object(vnum_to_zone(gem_vnum), vnum_to_local(gem_vnum))
    else
        -- We're in the BONUS ROUND!!
        -- drop a gem from the next wear pos set
        local gem_vnum = what_gem_drop + 55670
        self.room:spawn_object(vnum_to_zone(gem_vnum), vnum_to_local(gem_vnum))
    end
elseif will_drop >= 71 and will_drop <= 90 then
    -- Normal non-bonus drops
    if bonus <= 50 then
        -- drop destroyed armor 55299 is the vnum before the
        -- first piece of armor.
        local armor_vnum = what_armor_drop + 55347
        self.room:spawn_object(vnum_to_zone(armor_vnum), vnum_to_local(armor_vnum))
    elseif bonus >= 51 and bonus <= 90 then
        -- We're in the Normal drops from current wear pos set
        -- drop armor from the current wear pos set
        local armor_vnum = what_armor_drop + 55351
        self.room:spawn_object(vnum_to_zone(armor_vnum), vnum_to_local(armor_vnum))
    else
        -- We're in the BONUS ROUND!!
        -- drop a piece of armor from next wear pos
        local armor_vnum = what_armor_drop + 55355
        self.room:spawn_object(vnum_to_zone(armor_vnum), vnum_to_local(armor_vnum))
    end
else
    -- Normal non-bonus drops
    if bonus <= 50 then
        -- drop armor and gem from previous wear pos
        local gem_vnum = what_gem_drop + 55648
        local armor_vnum = what_armor_drop + 55347
        self.room:spawn_object(vnum_to_zone(gem_vnum), vnum_to_local(gem_vnum))
        self.room:spawn_object(vnum_to_zone(armor_vnum), vnum_to_local(armor_vnum))
    elseif bonus >= 51 and bonus <= 90 then
        -- We're in the Normal drops from current wear pos set
        -- drop a gem and armor from the current wear pos set
        local armor_vnum = what_armor_drop + 55351
        self.room:spawn_object(vnum_to_zone(armor_vnum), vnum_to_local(armor_vnum))
        local gem_vnum = what_gem_drop + 55659
        self.room:spawn_object(vnum_to_zone(gem_vnum), vnum_to_local(gem_vnum))
    else
        -- We're in the BONUS ROUND!!
        -- drop armor and gem from next wear pos
        local gem_vnum = what_gem_drop + 55670
        self.room:spawn_object(vnum_to_zone(gem_vnum), vnum_to_local(gem_vnum))
        local armor_vnum = what_armor_drop + 55355
        self.room:spawn_object(vnum_to_zone(armor_vnum), vnum_to_local(armor_vnum))
    end
end