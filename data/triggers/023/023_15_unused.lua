-- Trigger: **UNUSED**
-- Zone: 23, ID: 15
-- Type: MOB, Flags: DEATH
-- Status: REVIEWED (bitwise & -> and; group iter normalized; orphan return fixed)
--
-- Original DG Script: #2315
-- Marked UNUSED in the legacy world. Combines two unrelated drop tables:
-- a "Creeping Doom" gem drop, and a tiered gem/armor drop for boss_27
-- (#55580). Preserved verbatim semantics; no live trigger references it.
--
-- TODO(parity): Legacy id ranges (person.id >= 1000 .. 1038) and (.zone, .id)
-- references for spawn_object use legacy 5-digit decoding (e.g. 55580 ->
-- (553, 80) wear-pos sets). If this is ever re-activated, audit the spawn
-- (zone, id) tuples against the current world data.
--
-- for Creeping Doom
--
local function maybe_drop_doom(person)
    if person.room ~= self.room then return end
    if person:get_quest_stage("creeping_doom") == 2
       or (person.level > 80 and person.id >= 1000 and person.id <= 1038) then
        if random(1, 50) <= self.level then
            self.room:spawn_object(615, 17)
        end
    end
end
if actor.group then
    for _, member in ipairs(actor.group) do
        maybe_drop_doom(member)
    end
else
    maybe_drop_doom(actor)
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
    return true
end
if will_drop <= 60 then
    -- Normal non-bonus drops
    if bonus <= 50 then
        -- drop a gem from the previous wear pos set
        self.room:spawn_object(556, 4 + what_gem_drop)
    elseif bonus >= 51 and bonus <= 90 then
        -- We're in the Normal drops from current wear pos set
        -- drop a gem from the current wear pos set
        self.room:spawn_object(556, 15 + what_gem_drop)
    else
        -- We're in the BONUS ROUND!!
        -- drop a gem from the next wear pos set
        self.room:spawn_object(556, 26 + what_gem_drop)
    end
elseif will_drop >= 61 and will_drop <= 80 then
    -- Normal non-bonus drops
    if bonus <= 50 then
        -- drop destroyed armor 55299 is the ID before the
        -- first piece of armor.
        self.room:spawn_object(553, 31 + what_armor_drop)
    elseif bonus >= 51 and bonus <= 90 then
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
    elseif bonus >= 51 and bonus <= 90 then
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