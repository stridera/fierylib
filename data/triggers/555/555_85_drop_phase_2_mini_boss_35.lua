-- Trigger: drop_phase_2_mini_boss_35
-- Zone: 555, ID: 85
-- Type: MOB, Flags: DEATH
-- Status: NEEDS_REVIEW
--   Complex nesting: 6 if statements
--
-- Original DG Script: #55585

-- Converted from DG Script #55585: drop_phase_2_mini_boss_35
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
        self.room:spawn_object(556, what_gem_drop + 37)
    elseif bonus >= 51 and bonus <= 90 then
        -- We're in the Normal drops from current wear pos set
        -- drop a gem from the current wear pos set
        self.room:spawn_object(556, what_gem_drop + 48)
    else
        -- We're in the BONUS ROUND!!
        -- drop a gem from the next wear pos set
        self.room:spawn_object(556, what_gem_drop + 59)
    end
elseif will_drop >= 71 and will_drop <= 90 then
    -- Normal non-bonus drops
    if bonus <= 50 then
        self:say("normal < 90")
        -- drop destroyed armor 55299 is the vnum before the
        -- first piece of armor.
        self.room:spawn_object(553, what_armor_drop + 43)
    elseif bonus >= 51 and bonus <= 90 then
        -- We're in the Normal drops from current wear pos set
        -- drop armor from the current wear pos set
        self:say("normal 50 to 90")
        self.room:spawn_object(553, what_armor_drop + 47)
    else
        -- We're in the BONUS ROUND!!
        -- drop a piece of armor from next wear pos
        self:say("normal > 90")
        self.room:spawn_object(553, what_armor_drop + 51)
    end
else
    -- Normal non-bonus drops
    if bonus <= 50 then
        self:say("bonus < 50")
        -- drop armor and gem from previous wear pos
        self.room:spawn_object(556, what_gem_drop + 37)
        self.room:spawn_object(553, what_armor_drop + 43)
    elseif bonus >= 51 and bonus <= 90 then
        -- We're in the Normal drops from current wear pos set
        -- drop a gem and armor from the current wear pos set
        self:say("bonus 50 to 90")
        self.room:spawn_object(553, what_armor_drop + 47)
        self.room:spawn_object(556, what_gem_drop + 48)
    else
        -- We're in the BONUS ROUND!!
        -- drop armor and gem from next wear pos
        self:say("bonus > 90")
        self.room:spawn_object(556, what_gem_drop + 59)
        self.room:spawn_object(553, what_armor_drop + 51)
    end
end