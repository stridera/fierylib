-- Trigger: p2_3eg_death_p2_55574_boss_18
-- Zone: 185, ID: 52
-- Type: MOB, Flags: GREET
--
-- Adapted from the Eldorian quest, phase_1 (3-class subset, boss 555,74).
-- Random trophy / armor / gem drops on encounter.
--
-- TODO(parity): the trigger is flagged GREET in the import but the
-- legacy intent is clearly a DEATH/kill-loot mechanic. The flag and
-- the attachment may both need correcting in the imported world.
-- The legacy DG used `&` as AND (not Lua) and had several orphan
-- `_return_value` references; both fixed below for parse correctness.

local id_trophy1 = 8
local id_trophy2 = 10
local id_trophy3 = 12
local id_trophy4 = 14

local will_drop = random(1, 100)
if will_drop <= 10 then
    -- drop nothing
elseif will_drop <= 50 then
    self.room:spawn_object(55, id_trophy1)
elseif will_drop >= 51 and will_drop <= 70 then
    self.room:spawn_object(55, id_trophy2)
elseif will_drop >= 71 and will_drop <= 90 then
    self.room:spawn_object(55, id_trophy3)
else
    self.room:spawn_object(55, id_trophy4)
end

-- 3 pieces of armor per sub_phase in phase_1; 4 classes questing.
local bonus = random(1, 100)
local will_drop2 = random(1, 100)
local what_armor_drop = random(1, 3)
local what_gem_drop = random(1, 4)

if will_drop2 <= 20 then
    return
end

if will_drop2 <= 60 then
    if bonus <= 50 then
        self.room:spawn_object(555, 85 + what_gem_drop)
    elseif bonus >= 51 and bonus <= 90 then
        self.room:spawn_object(555, 89 + what_gem_drop)
    else
        self.room:spawn_object(555, 93 + what_gem_drop)
    end
elseif will_drop2 >= 61 and will_drop2 <= 80 then
    if bonus <= 50 then
        self.room:spawn_object(553, 19 + what_armor_drop)
    elseif bonus >= 51 and bonus <= 90 then
        self.room:spawn_object(553, 23 + what_armor_drop)
    else
        self.room:spawn_object(553, 27 + what_armor_drop)
    end
else
    if bonus <= 50 then
        self.room:spawn_object(555, 85 + what_gem_drop)
        self.room:spawn_object(553, 19 + what_armor_drop)
    elseif bonus >= 51 and bonus <= 90 then
        self.room:spawn_object(553, 23 + what_armor_drop)
        self.room:spawn_object(555, 89 + what_gem_drop)
    else
        self.room:spawn_object(555, 93 + what_gem_drop)
        self.room:spawn_object(553, 27 + what_armor_drop)
    end
end
