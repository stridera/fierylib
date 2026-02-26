-- Trigger: **UNUSED**
-- Zone: 23, ID: 15
-- Type: MOB, Flags: DEATH
-- Status: NEEDS_REVIEW
--   Complex nesting: 11 if statements
--
-- Original DG Script: #2315

-- Converted from DG Script #2315: **UNUSED**
-- Original: MOB trigger, flags: DEATH, probability: 100%
-- 
-- for Creeping Doom
-- 
local person = actor
local i = actor.group_size
if i then
    person = nil
    while i > 0 do
        local person = actor.group_member[i]
        if person.room == self.room then
            if person:get_quest_stage("creeping_doom") == 2 or (person.level > 80 and (person.id >= 1000 and person.id <= 1038)) then
                local rnd = random(1, 50)
                if rnd <= self.level then
                    self.room:spawn_object(615, 17)
                end
            end
        end
        i = i - 1
    end
elseif person:get_quest_stage("creeping_doom") == 2 or (person.level > 80 and (person.id >= 1000 and person.id <= 1038)) then
    local rnd = random(1, 50)
    if rnd <= self.level then
        self.room:spawn_object(615, 17)
    end
end
-- 
-- Death trigger for random gem and armor drops
-- 
-- set a random number to determine if a drop will
-- happen.
-- 
-- boss setup - 55580 boss_27
-- 
local bonus = random(1, 100)
local will_drop = random(1, 100)
-- 4 pieces of armor per sub_phase in phase_2
local what_armor_drop = random(1, 4)
-- 11 classes questing in phase_2
local what_gem_drop = random(1, 11)
-- 
if will_drop <= 20 then
    -- drop nothing and bail
    return _return_value
end
if will_drop <= 60 then
    -- Normal non-bonus drops
    if bonus <= 50 then
        -- drop a gem from the previous wear pos set
        self.room:spawn_object(556, 4 + what_gem_drop)
    elseif bonus >= 51 &bonus <= 90 then
        -- We're in the Normal drops from current wear pos set
        -- drop a gem from the current wear pos set
        self.room:spawn_object(556, 15 + what_gem_drop)
    else
        -- We're in the BONUS ROUND!!
        -- drop a gem from the next wear pos set
        self.room:spawn_object(556, 26 + what_gem_drop)
    end
elseif will_drop >=61 &will_drop <= 80 then
    -- Normal non-bonus drops
    if bonus <= 50 then
        -- drop destroyed armor 55299 is the vnum before the
        -- first piece of armor.
        self.room:spawn_object(553, 31 + what_armor_drop)
    elseif bonus >= 51 &bonus <= 90 then
        -- We're in the Normal drops from current wear pos set
        -- drop armor from the current wear pos set
        self.room:spawn_object(553, 35 + what_armor_drop)
    else
        -- We're in the BONUS ROUND!!
        -- drop a piece of armor from next wear pos
        self.room:spawn_object(553, 39 + what_armor_drop)
    end
else
    -- Normal non-bonus drops
    if bonus <= 50 then
        -- drop armor and gem from previous wear pos
        self.room:spawn_object(556, 4 + what_gem_drop)
        self.room:spawn_object(553, 31 + what_armor_drop)
    elseif bonus >= 51 &bonus <= 90 then
        -- We're in the Normal drops from current wear pos set
        -- drop a gem and armor from the current wear pos set
        self.room:spawn_object(553, 35 + what_armor_drop)
        self.room:spawn_object(556, 15 + what_gem_drop)
    else
        -- We're in the BONUS ROUND!!
        -- drop armor and gem from next wear pos
        self.room:spawn_object(556, 26 + what_gem_drop)
        self.room:spawn_object(556, 39 + what_armor_drop)
    end
end