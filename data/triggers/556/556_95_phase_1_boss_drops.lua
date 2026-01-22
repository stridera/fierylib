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
    local gem_vnum = what_gem_drop + 55565
elseif will_drop >= 61 and will_drop <= 80 then
    -- 20% to drop armor
    -- drop destroyed armor 55299 is the vnum before the
    -- first piece of armor.
    local armor_vnum = what_armor_drop + 55299
    -- do this because decayed medium armor isn't used, replace with warrior/cleric
    if armor_vnum == 55303 then
        local armor_vnum = 55300
    elseif armor_vnum == 55307 then
        local armor_vnum = 55304
    elseif armor_vnum == 55311 then
        local armor_vnum = 55308
    elseif armor_vnum == 55315 then
        local armor_vnum = 55312
    elseif armor_vnum == 55319 then
        local armor_vnum = 55316
    elseif armor_vnum == 55323 then
        local armor_vnum = 55320
    elseif armor_vnum == 55327 then
        local armor_vnum = 55324
    end
    self.room:spawn_object(vnum_to_zone(armor_vnum), vnum_to_local(armor_vnum))
else
    -- 20% chance to drop armor and gem
    local gem_vnum = what_gem_drop + 55565
    local armor_vnum = what_armor_drop + 55299
    -- do this because decayed medium armor isn't used, replace with warrior/cleric
    if armor_vnum == 55303 then
        local armor_vnum = 55300
    elseif armor_vnum == 55307 then
        local armor_vnum = 55304
    elseif armor_vnum == 55311 then
        local armor_vnum = 55308
    elseif armor_vnum == 55315 then
        local armor_vnum = 55312
    elseif armor_vnum == 55319 then
        local armor_vnum = 55316
    elseif armor_vnum == 55323 then
        local armor_vnum = 55320
    elseif armor_vnum == 55327 then
        local armor_vnum = 55324
    end
    self.room:spawn_object(vnum_to_zone(gem_vnum), vnum_to_local(gem_vnum))
    self.room:spawn_object(vnum_to_zone(armor_vnum), vnum_to_local(armor_vnum))
end