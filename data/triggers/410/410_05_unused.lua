-- Trigger: **UNUSED**
-- Zone: 410, ID: 5
-- Type: MOB, Flags: DEATH
-- Status: NEEDS_REVIEW
--   Complex nesting: 11 if statements
--
-- Original DG Script: #41005

-- Converted from DG Script #41005: **UNUSED**
-- Original: MOB trigger, flags: DEATH, probability: 100%
-- 
-- Trigger 61554 for Creeping Doom
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
-- Death trigger for random gem and armor drops - 55567
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
        self.room:spawn_object(555, 73 + what_gem_drop)
    elseif bonus >= 51 &bonus <= 90 then
        -- We're in the Normal drops from current wear pos set
        -- drop a gem from the current wear pos set
        self.room:spawn_object(555, 77 + what_gem_drop)
    else
        -- We're in the BONUS ROUND!!
        -- drop a gem from the next wear pos set
        self.room:spawn_object(555, 81 + what_gem_drop)
    end
elseif will_drop >= 71 &will_drop <= 90 then
    -- Normal non-bonus drops
    if bonus <= 50 then
        -- drop destroyed armor 55299 is the vnum before the
        -- first piece of armor.
        self.room:spawn_object(553, 7 + what_armor_drop)
    elseif bonus >= 51 &bonus <= 90 then
        -- We're in the Normal drops from current wear pos set
        -- drop armor from the current wear pos set
        self.room:spawn_object(553, 11 + what_armor_drop)
    else
        -- We're in the BONUS ROUND!!
        -- drop a piece of armor from next wear pos
        self.room:spawn_object(553, 15 + what_armor_drop)
    end
else
    -- Normal non-bonus drops
    if bonus <= 50 then
        -- drop armor and gem from previous wear pos
        self.room:spawn_object(555, 73 + what_gem_drop)
        self.room:spawn_object(553, 7 + what_armor_drop)
    elseif bonus >= 51 &bonus <= 90 then
        -- We're in the Normal drops from current wear pos set
        -- drop a gem and armor from the current wear pos set
        self.room:spawn_object(553, 11 + what_armor_drop)
        self.room:spawn_object(555, 77 + what_gem_drop)
    else
        -- We're in the BONUS ROUND!!
        -- drop armor and gem from next wear pos
        self.room:spawn_object(555, 81 + what_gem_drop)
        self.room:spawn_object(553, 15 + what_armor_drop)
    end
end