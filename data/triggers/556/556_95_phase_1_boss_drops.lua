-- Trigger: Phase 1 Boss Drops
-- Zone: 556, ID: 95
-- Type: MOB, Flags: DEATH
-- Status: CLEAN
--
-- Original DG Script: #55695

-- Converted from DG Script #55695: Phase 1 Boss Drops
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
-- 28 pieces of armor in phase_1
local what_armor_drop = random(1, 28)
-- 28 gems in phase_1
local what_gem_drop = random(1, 28)
-- 
if will_drop <= 20 then
    -- 20% to drop nothing
elseif will_drop <= 60 then
    -- 40% to drop a gem
    local gem_id = what_gem_drop + 65
    self.room:spawn_object(555, gem_id)
elseif will_drop >= 61 and will_drop <= 80 then
    -- 20% to drop armor
    -- drop destroyed armor 55299 is the ID before the
    -- first piece of armor.
    local armor_id = what_armor_drop + 55299
    -- do this because decayed medium armor isn't used, replace with warrior/cleric
    if armor_id == 55303 then
        armor_id = 55300
    elseif armor_id == 55307 then
        armor_id = 55304
    elseif armor_id == 55311 then
        armor_id = 55308
    elseif armor_id == 55315 then
        armor_id = 55312
    elseif armor_id == 55319 then
        armor_id = 55316
    elseif armor_id == 55323 then
        armor_id = 55320
    elseif armor_id == 55327 then
        armor_id = 55324
    end
    self.room:spawn_object(math.floor(armor_id / 100), armor_id % 100)
else
    -- 20% chance to drop armor and gem
    local gem_id = what_gem_drop + 65
    local armor_id = what_armor_drop + 55299
    -- do this because decayed medium armor isn't used, replace with warrior/cleric
    if armor_id == 55303 then
        armor_id = 55300
    elseif armor_id == 55307 then
        armor_id = 55304
    elseif armor_id == 55311 then
        armor_id = 55308
    elseif armor_id == 55315 then
        armor_id = 55312
    elseif armor_id == 55319 then
        armor_id = 55316
    elseif armor_id == 55323 then
        armor_id = 55320
    elseif armor_id == 55327 then
        armor_id = 55324
    end
    self.room:spawn_object(555, gem_id)
    self.room:spawn_object(math.floor(armor_id / 100), armor_id % 100)
end