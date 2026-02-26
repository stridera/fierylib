-- Trigger: drop_phase_1_boss_12
-- Zone: 555, ID: 70
-- Type: MOB, Flags: DEATH
-- Status: NEEDS_REVIEW
--   Complex nesting: 6 if statements
--
-- Original DG Script: #55570

-- Converted from DG Script #55570: drop_phase_1_boss_12
-- Original: MOB trigger, flags: DEATH, probability: 100%
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
        self.room:spawn_object(555, 77 + what_gem_drop)
    elseif bonus >= 51 and bonus <= 90 then
        -- We're in the Normal drops from current wear pos set
        -- drop a gem from the current wear pos set
        self.room:spawn_object(555, 81 + what_gem_drop)
    else
        -- We're in the BONUS ROUND!!
        -- drop a gem from the next wear pos set
        self.room:spawn_object(555, 85 + what_gem_drop)
    end
elseif will_drop >=61 and will_drop <= 80 then
    -- Normal non-bonus drops
    if bonus <= 50 then
        -- drop destroyed armor 55299 is the vnum before the
        -- first piece of armor.
        self.room:spawn_object(553, 11 + what_armor_drop)
    elseif bonus >= 51 and bonus <= 90 then
        -- We're in the Normal drops from current wear pos set
        -- drop armor from the current wear pos set
        self.room:spawn_object(553, 15 + what_armor_drop)
    else
        -- We're in the BONUS ROUND!!
        -- drop a piece of armor from next wear pos
        self.room:spawn_object(553, 19 + what_armor_drop)
    end
else
    -- Normal non-bonus drops
    if bonus <= 50 then
        -- drop armor and gem from previous wear pos
        self.room:spawn_object(555, 77 + what_gem_drop)
        self.room:spawn_object(553, 11 + what_armor_drop)
    elseif bonus >= 51 and bonus <= 90 then
        -- We're in the Normal drops from current wear pos set
        -- drop a gem and armor from the current wear pos set
        self.room:spawn_object(553, 15 + what_armor_drop)
        self.room:spawn_object(555, 81 + what_gem_drop)
    else
        -- We're in the BONUS ROUND!!
        -- drop armor and gem from next wear pos
        self.room:spawn_object(555, 85 + what_gem_drop)
        self.room:spawn_object(553, 19 + what_armor_drop)
    end
end