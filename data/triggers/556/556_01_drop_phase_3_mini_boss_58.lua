-- Trigger: drop_phase_3_mini_boss_58
-- Zone: 556, ID: 1
-- Type: MOB, Flags: DEATH
-- Status: NEEDS_REVIEW
--   Complex nesting: 6 if statements
--
-- Original DG Script: #55601

-- Converted from DG Script #55601: drop_phase_3_mini_boss_58
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
-- 4 pieces of armor per sub_phase in phase_3
local what_armor_drop = random(1, 4)
-- 11 classes questing in phase_3
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
        local gem_vnum = what_gem_drop + 55725
        self.room:spawn_object(vnum_to_zone(gem_vnum), vnum_to_local(gem_vnum))
    elseif bonus >= 51 and bonus <= 90 then
        -- We're in the Normal drops from current wear pos set
        -- drop a gem from the current wear pos set
        local gem_vnum = what_gem_drop + 55736
        self.room:spawn_object(vnum_to_zone(gem_vnum), vnum_to_local(gem_vnum))
    else
        -- We're in the BONUS ROUND!!
        -- drop a gem from the next wear pos set
        local gem_vnum = what_gem_drop + 55736
        self.room:spawn_object(vnum_to_zone(gem_vnum), vnum_to_local(gem_vnum))
    end
elseif will_drop >= 71 and will_drop <= 90 then
    -- Normal non-bonus drops
    if bonus <= 50 then
        -- drop destroyed armor 55299 is the vnum before the
        -- first piece of armor.
        local armor_vnum = what_armor_drop + 55375
        self.room:spawn_object(vnum_to_zone(armor_vnum), vnum_to_local(armor_vnum))
    elseif bonus >= 51 and bonus <= 90 then
        -- We're in the Normal drops from current wear pos set
        -- drop armor from the current wear pos set
        local armor_vnum = what_armor_drop + 55379
        self.room:spawn_object(vnum_to_zone(armor_vnum), vnum_to_local(armor_vnum))
    else
        -- We're in the BONUS ROUND!!
        -- drop a piece of armor from next wear pos
        local armor_vnum = what_armor_drop + 55379
        self.room:spawn_object(vnum_to_zone(armor_vnum), vnum_to_local(armor_vnum))
    end
else
    -- Normal non-bonus drops
    if bonus <= 50 then
        -- drop armor and gem from previous wear pos
        local gem_vnum = what_gem_drop + 55725
        local armor_vnum = what_armor_drop + 55375
        self.room:spawn_object(vnum_to_zone(gem_vnum), vnum_to_local(gem_vnum))
        self.room:spawn_object(vnum_to_zone(armor_vnum), vnum_to_local(armor_vnum))
    elseif bonus >= 51 and bonus <= 90 then
        -- We're in the Normal drops from current wear pos set
        -- drop a gem and armor from the current wear pos set
        local gem_vnum = what_gem_drop + 55736
        local armor_vnum = what_armor_drop + 55379
        self.room:spawn_object(vnum_to_zone(armor_vnum), vnum_to_local(armor_vnum))
        self.room:spawn_object(vnum_to_zone(gem_vnum), vnum_to_local(gem_vnum))
    else
        -- We're in the BONUS ROUND!!
        -- drop armor and gem from next wear pos
        local gem_vnum = what_gem_drop + 55736
        local armor_vnum = what_armor_drop + 55379
        self.room:spawn_object(vnum_to_zone(gem_vnum), vnum_to_local(gem_vnum))
        self.room:spawn_object(vnum_to_zone(armor_vnum), vnum_to_local(armor_vnum))
    end
end