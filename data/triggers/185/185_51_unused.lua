-- Trigger: **UNUSED** (legacy: phase_2 boss death drops)
-- Zone: 185, ID: 51
-- Type: MOB, Flags: DEATH
--
-- Adapted from the Eldorian quest. Random trophy / armor / gem drops
-- for a phase_2 boss kill. Currently unused in this zone; retained as
-- reference until the phase_2 reward system is reimplemented.
--
-- TODO(parity): this whole script is a stub; the legacy DG used `&` as
-- AND (not valid Lua) and several `_return_value` orphans. Reproduced
-- here with `and` for parse correctness, but the trigger still has no
-- attachment in the imported world. Wire it up or delete once the
-- phase_2 reward design is finalized.

local id_trophy1 = 8
local id_trophy2 = 10
local id_trophy3 = 12
local id_trophy4 = 14

-- Trophy roll
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

-- Random gem and armor drops (phase_2 boss).
-- 4 pieces of armor per sub_phase; 11 classes questing in phase_2.
local bonus = random(1, 100)
local will_drop2 = random(1, 100)
local what_armor_drop = random(1, 4)
local what_gem_drop = random(1, 11)

if will_drop2 <= 20 then
    return
end

if will_drop2 <= 60 then
    -- gem only
    if bonus <= 50 then
        self.room:spawn_object(555, 89 + what_gem_drop)
    elseif bonus >= 51 and bonus <= 90 then
        self.room:spawn_object(555, 93 + what_gem_drop)
    else
        self.room:spawn_object(556, 4 + what_gem_drop)
    end
elseif will_drop2 >= 61 and will_drop2 <= 80 then
    -- armor only
    if bonus <= 50 then
        self.room:spawn_object(553, 23 + what_armor_drop)
    elseif bonus >= 51 and bonus <= 90 then
        self.room:spawn_object(553, 27 + what_armor_drop)
    else
        self.room:spawn_object(553, 31 + what_armor_drop)
    end
else
    -- both
    if bonus <= 50 then
        self.room:spawn_object(555, 89 + what_gem_drop)
        self.room:spawn_object(553, 23 + what_armor_drop)
    elseif bonus >= 51 and bonus <= 90 then
        self.room:spawn_object(553, 27 + what_armor_drop)
        self.room:spawn_object(555, 93 + what_gem_drop)
    else
        self.room:spawn_object(556, 4 + what_gem_drop)
        self.room:spawn_object(553, 31 + what_armor_drop)
    end
end
