-- Trigger: Phase 1 Miniboss Drops
-- Zone: 556, ID: 94
-- Type: MOB, Flags: DEATH
-- Status: CLEAN
--
-- Original DG Script: #55694

-- Converted from DG Script #55694: Phase 1 Miniboss Drops
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
if will_drop <= 30 then
    -- 30% to drop nothing
elseif will_drop <= 70 then
    -- 40% to drop a gem
    local gem_vnum = what_gem_drop + 55565
elseif will_drop >= 71 and will_drop <= 90 then
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
    -- armor_vnum values are 553xx => zone = armor_vnum // 100, local_id = armor_vnum % 100
    self.room:spawn_object(armor_vnum // 100, armor_vnum % 100)
else
    -- 10% chance to drop armor and gem
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
    elseif armor_vnum == 55327 then
    end
    -- gem_vnum values are 555xx => zone = gem_vnum // 100, local_id = gem_vnum % 100
    self.room:spawn_object(gem_vnum // 100, gem_vnum % 100)
    self.room:spawn_object(553, 24)
end