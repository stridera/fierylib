-- Trigger: **UNUSED**
-- Zone: 410, ID: 7
-- Type: MOB, Flags: GREET
-- Status: CLEAN
--
-- Original DG Script: #41007

-- Converted from DG Script #41007: **UNUSED**
-- Original: MOB trigger, flags: GREET, probability: 100%
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
        local i = i - 1
    end
elseif person:get_quest_stage("creeping_doom") == 2 or (person.level > 80 and (person.id >= 1000 and person.id <= 1038)) then
    local rnd = random(1, 50)
    if rnd <= self.level then
        self.room:spawn_object(615, 17)
    end
end
-- 
-- Death trigger for random gem and armor drops - 55570
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
        self.room:spawn_object(555, what_gem_drop + 77)
    elseif bonus >= 51 and bonus <= 90 then
        -- We're in the Normal drops from current wear pos set
        -- drop a gem from the current wear pos set
        self.room:spawn_object(555, what_gem_drop + 81)
    else
        -- We're in the BONUS ROUND!!
        -- drop a gem from the next wear pos set
        self.room:spawn_object(555, what_gem_drop + 85)
    end
elseif will_drop >=61 and will_drop <= 80 then
    -- Normal non-bonus drops
    if bonus <= 50 then
        -- drop destroyed armor 55299 is the vnum before the
        -- first piece of armor.
        self.room:spawn_object(553, what_armor_drop + 11)
    elseif bonus >= 51 and bonus <= 90 then
        -- We're in the Normal drops from current wear pos set
        -- drop armor from the current wear pos set
        self.room:spawn_object(553, what_armor_drop + 15)
    else
        -- We're in the BONUS ROUND!!
        -- drop a piece of armor from next wear pos
        self.room:spawn_object(553, what_armor_drop + 19)
    end
else
    -- Normal non-bonus drops
    if bonus <= 50 then
        -- drop armor and gem from previous wear pos
        self.room:spawn_object(555, what_gem_drop + 77)
        self.room:spawn_object(553, what_armor_drop + 11)
    elseif bonus >= 51 and bonus <= 90 then
        -- We're in the Normal drops from current wear pos set
        -- drop a gem and armor from the current wear pos set
        self.room:spawn_object(553, what_armor_drop + 15)
        self.room:spawn_object(555, what_gem_drop + 81)
    else
        -- We're in the BONUS ROUND!!
        -- drop armor and gem from next wear pos
        self.room:spawn_object(555, what_gem_drop + 85)
        self.room:spawn_object(553, what_armor_drop + 19)
    end
end