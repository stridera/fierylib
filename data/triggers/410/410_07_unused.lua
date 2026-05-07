-- Trigger: **UNUSED**
-- Zone: 410, ID: 7
-- Type: MOB, Flags: GREET
-- Status: NEEDS_REVIEW
--   Original DG had complex nesting; converted but not attached to any mob.
--   Unusual: this is the boss tier yet flagged GREET, not DEATH; the body
--   reads as a death drop. Confirm intended trigger flag before enabling.
--
-- Original DG Script: #41007
-- Boss-tier drop logic (higher gem/armor indices than 41005/41006). Two
-- responsibilities:
--   1. Creeping Doom quest (615:17) drop, per eligible group member.
--   2. Random gem (555:*) and armor (553:*) drops; gem range 77-89,
--      armor range 11-22.
--
-- TODO(parity): the `person.id >= 1000 and person.id <= 1038` branch is a
-- legacy DG check for an old player vnum range. Confirm the equivalent in
-- the new account model before re-enabling this trigger.
-- TODO(parity): trigger is flagged GREET but body is a death drop table.

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

-- 2. Boss drop table.
local will_drop = random(1, 100)
if will_drop <= 20 then
    -- 20% no drop (boss has higher drop rate than minibosses).
    return
end

local bonus = random(1, 100)
local what_armor_drop = random(1, 3) -- 3 pieces of armor per sub_phase
local what_gem_drop = random(1, 4)   -- 4 classes questing in phase_1

if will_drop <= 60 then
    -- Gem-only tier.
    if bonus <= 50 then
        -- Previous wear-position gem set.
        self.room:spawn_object(555, 77 + what_gem_drop)
    elseif bonus <= 90 then
        -- Current wear-position gem set.
        self.room:spawn_object(555, 81 + what_gem_drop)
    else
        -- Bonus: next wear-position gem set.
        self.room:spawn_object(555, 85 + what_gem_drop)
    end
elseif will_drop <= 80 then
    -- Armor-only tier.
    if bonus <= 50 then
        -- Previous wear-position armor set.
        self.room:spawn_object(553, 11 + what_armor_drop)
    elseif bonus <= 90 then
        -- Current wear-position armor set.
        self.room:spawn_object(553, 15 + what_armor_drop)
    else
        -- Bonus: next wear-position armor set.
        self.room:spawn_object(553, 19 + what_armor_drop)
    end
else
    -- Gem + armor tier (20%).
    if bonus <= 50 then
        self.room:spawn_object(555, 77 + what_gem_drop)
        self.room:spawn_object(553, 11 + what_armor_drop)
    elseif bonus <= 90 then
        self.room:spawn_object(553, 15 + what_armor_drop)
        self.room:spawn_object(555, 81 + what_gem_drop)
    else
        self.room:spawn_object(555, 85 + what_gem_drop)
        self.room:spawn_object(553, 19 + what_armor_drop)
    end
end
