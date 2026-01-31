-- Trigger: hell_gate_armor_p2_doppelganger_55585
-- Zone: 564, ID: 10
-- Type: MOB, Flags: DEATH
-- Status: NEEDS_REVIEW
--   Complex nesting: 9 if statements
--
-- Original DG Script: #56410

-- Converted from DG Script #56410: hell_gate_armor_p2_doppelganger_55585
-- Original: MOB trigger, flags: DEATH, probability: 100%
-- 
-- For Hell Gate
-- 
if actor:get_quest_stage("hell_gate") == 3 and actor:has_equipped("56407") then
    local blood = random(1, 100)
    if blood > 65 then
        if actor:get_quest_var("hell_gate:blood56404") == 0 then
            actor:set_quest_var("hell_gate", "blood56404", 1)
            self.room:spawn_object(564, 4)
        end
    end
end
-- 
-- Death trigger for random gem and armor drops - 55585
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
    elseif bonus >= 51 &bonus <= 90 then
        -- We're in the Normal drops from current wear pos set
        -- drop a gem from the current wear pos set
        self.room:spawn_object(556, what_gem_drop + 48)
    else
        -- We're in the BONUS ROUND!!
        -- drop a gem from the next wear pos set
        self.room:spawn_object(556, what_gem_drop + 59)
    end
elseif will_drop >= 71 &will_drop <= 90 then
    -- Normal non-bonus drops
    if bonus <= 50 then
        -- drop destroyed armor 55299 is the vnum before the
        -- first piece of armor.
        self.room:spawn_object(553, what_armor_drop + 43)
    elseif bonus >= 51 &bonus <= 90 then
        -- We're in the Normal drops from current wear pos set
        -- drop armor from the current wear pos set
        self.room:spawn_object(553, what_armor_drop + 47)
    else
        -- We're in the BONUS ROUND!!
        -- drop a piece of armor from next wear pos
        self.room:spawn_object(553, what_armor_drop + 51)
    end
else
    -- Normal non-bonus drops
    if bonus <= 50 then
        -- drop armor and gem from previous wear pos
        self.room:spawn_object(556, what_gem_drop + 37)
        self.room:spawn_object(553, what_armor_drop + 43)
    elseif bonus >= 51 &bonus <= 90 then
        -- We're in the Normal drops from current wear pos set
        -- drop a gem and armor from the current wear pos set
        self.room:spawn_object(553, what_armor_drop + 47)
        self.room:spawn_object(556, what_gem_drop + 48)
    else
        -- We're in the BONUS ROUND!!
        -- drop armor and gem from next wear pos
        self.room:spawn_object(556, what_gem_drop + 59)
        self.room:spawn_object(553, what_armor_drop + 51)
    end
end