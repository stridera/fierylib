-- Trigger: **UNUSED**
-- Zone: 410, ID: 6
-- Type: MOB, Flags: DEATH
-- Status: NEEDS_REVIEW
--   Original DG had complex nesting; converted but not attached to any mob.
--
-- Original DG Script: #41006
-- Death drop trigger for a Phase 1 miniboss (slightly earlier wear-pos
-- progression than 41005). Two responsibilities:
--   1. Creeping Doom quest (615:17) drop, per eligible group member.
--   2. Random gem (555:*) and armor (553:*) drops, indexed lower than 41005.
--
-- TODO(parity): the `person.id >= 1000 and person.id <= 1038` branch is a
-- legacy DG check for an old player vnum range. Confirm the equivalent in
-- the new account model before re-enabling this trigger.

-- 1. Creeping Doom relic drop, per eligible group member.
local function try_creeping_doom_drop(person)
    if person == nil or person.room ~= self.room then
        return
    end
    local stage_ok = person:get_quest_stage("creeping_doom") == 2
    local test_ok = person.level > 80 and (person.id >= 1000 and person.id <= 1038)
    if stage_ok or test_ok then
        if random(1, 50) <= self.level then
            self.room:spawn_object(615, 17)
        end
    end
end

local size = actor.group_size
if size and size > 0 then
    local i = size
    while i > 0 do
        try_creeping_doom_drop(actor.group_member[i])
        i = i - 1
    end
else
    try_creeping_doom_drop(actor)
end

-- 2. Phase 1 miniboss drop table.
local will_drop = random(1, 100)
if will_drop <= 30 then
    -- 30% no drop.
    return
end

local bonus = random(1, 100)
local what_armor_drop = random(1, 3) -- 3 pieces of armor per sub_phase
local what_gem_drop = random(1, 4)   -- 4 classes questing in phase_1

if will_drop <= 70 then
    -- Gem-only tier.
    if bonus <= 50 then
        -- Previous wear-position gem set.
        self.room:spawn_object(555, 69 + what_gem_drop)
    elseif bonus <= 90 then
        -- Current wear-position gem set.
        self.room:spawn_object(555, 73 + what_gem_drop)
    else
        -- Bonus: next wear-position gem set.
        self.room:spawn_object(555, 77 + what_gem_drop)
    end
elseif will_drop <= 90 then
    -- Armor-only tier.
    if bonus <= 50 then
        -- Previous wear-position armor set.
        self.room:spawn_object(553, 3 + what_armor_drop)
    elseif bonus <= 90 then
        -- Current wear-position armor set.
        self.room:spawn_object(553, 7 + what_armor_drop)
    else
        -- Bonus: next wear-position armor set.
        self.room:spawn_object(553, 11 + what_armor_drop)
    end
else
    -- Gem + armor tier (10%).
    if bonus <= 50 then
        self.room:spawn_object(555, 69 + what_gem_drop)
        self.room:spawn_object(553, 3 + what_armor_drop)
    elseif bonus <= 90 then
        self.room:spawn_object(553, 7 + what_armor_drop)
        self.room:spawn_object(555, 73 + what_gem_drop)
    else
        self.room:spawn_object(555, 77 + what_gem_drop)
        self.room:spawn_object(553, 11 + what_armor_drop)
    end
end
