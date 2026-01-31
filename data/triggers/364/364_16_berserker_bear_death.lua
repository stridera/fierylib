-- Trigger: berserker_bear_death
-- Zone: 364, ID: 16
-- Type: MOB, Flags: DEATH
-- Status: CLEAN (reviewed 2026-01-22)
--   Complex nesting: 7 if statements
--
-- Original DG Script: #36416

-- Converted from DG Script #36416: berserker_bear_death
-- Original: MOB trigger, flags: DEATH, probability: 100%
if actor:get_quest_stage("berserker_subclass") == 4 and actor:get_quest_var("berserker_subclass:target") == self.id then
    actor:send("<b:cyan>Congratulations, you have succeeded in your Wild Hunt!</>")
    actor:send("<b:cyan>You have earned the right to become a &9<blue>Ber<red>ser&9ker<b:cyan>!</>")
    actor:send("Type '<b:yellow>subclass</>' to proceed.")
    actor:complete_quest("berserker_subclass")
end
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
    if bonus <= 50 then
        -- drop a gem from the previous wear pos set
        self.room:spawn_object(555, what_gem_drop + 73)
    elseif bonus >= 51 and bonus <= 90 then
        -- We're in the Normal drops from current wear pos set
        -- drop a gem from the current wear pos set
        self.room:spawn_object(555, what_gem_drop + 77)
    else
        -- We're in the BONUS ROUND!!
        -- drop a gem from the next wear pos set
        self.room:spawn_object(555, what_gem_drop + 81)
    end
elseif will_drop >= 71 and will_drop <= 90 then
    -- Normal non-bonus drops
    if bonus <= 50 then
        -- drop destroyed armor 55299 is the vnum before the
        -- first piece of armor.
        self.room:spawn_object(553, what_armor_drop + 7)
    elseif bonus >= 51 and bonus <= 90 then
        -- We're in the Normal drops from current wear pos set
        -- drop armor from the current wear pos set
        self.room:spawn_object(553, what_armor_drop + 11)
    else
        -- We're in the BONUS ROUND!!
        -- drop a piece of armor from next wear pos
        self.room:spawn_object(553, what_armor_drop + 15)
    end
else
    -- Normal non-bonus drops
    if bonus <= 50 then
        -- drop armor and gem from previous wear pos
        self.room:spawn_object(555, what_gem_drop + 73)
        self.room:spawn_object(553, what_armor_drop + 7)
    elseif bonus >= 51 and bonus <= 90 then
        -- We're in the Normal drops from current wear pos set
        -- drop a gem and armor from the current wear pos set
        self.room:spawn_object(553, what_armor_drop + 11)
        self.room:spawn_object(555, what_gem_drop + 77)
    else
        -- We're in the BONUS ROUND!!
        -- drop armor and gem from next wear pos
        self.room:spawn_object(555, what_gem_drop + 81)
        self.room:spawn_object(553, what_armor_drop + 15)
    end
end