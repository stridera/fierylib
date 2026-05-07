-- Trigger: wug_drake_death
-- Zone: 80, ID: 34
-- Type: MOB, Flags: DEATH
-- Status: CLEAN
--
-- Original DG Script: #8034
-- On death: drops cycle marker (80/34) and rolls for gem/armor loot.
-- TODO: Verify object ids (zone 553/555) — original DG vnums (e.g. 55299)
-- did not map cleanly to the (zone, id) split used here.

self:say("You have vanquished me for now but I will return!")
self.room:spawn_object(80, 34)

-- Random gem/armor drop logic (from boss setup)
local bonus = random(1, 100)
local will_drop = random(1, 100)
-- 3 pieces of armor per sub_phase in phase_1
local what_armor_drop = random(1, 3)
-- 4 classes questing in phase_1
local what_gem_drop = random(1, 4)

if will_drop <= 20 then
    -- drop nothing and bail
    return
end
if will_drop <= 60 then
    -- Gem drop tier
    if bonus <= 50 then
        -- drop a gem from the previous wear pos set
        self.room:spawn_object(555, 85 + what_gem_drop)
    elseif bonus >= 51 and bonus <= 90 then
        -- drop a gem from the current wear pos set
        self.room:spawn_object(555, 89 + what_gem_drop)
    else
        -- BONUS ROUND: drop a gem from the next wear pos set
        self.room:spawn_object(555, 93 + what_gem_drop)
    end
elseif will_drop >= 61 and will_drop <= 80 then
    -- Armor drop tier
    if bonus <= 50 then
        -- drop destroyed armor (legacy id 55299 was the slot before the
        -- first piece of armor).
        self.room:spawn_object(553, 19 + what_armor_drop)
    elseif bonus >= 51 and bonus <= 90 then
        -- drop armor from the current wear pos set
        self.room:spawn_object(553, 23 + what_armor_drop)
    else
        -- BONUS ROUND: drop a piece of armor from next wear pos
        self.room:spawn_object(553, 27 + what_armor_drop)
    end
else
    -- Combined gem + armor drop tier
    if bonus <= 50 then
        -- drop armor and gem from previous wear pos
        self.room:spawn_object(555, 85 + what_gem_drop)
        self.room:spawn_object(553, 19 + what_armor_drop)
    elseif bonus >= 51 and bonus <= 90 then
        -- drop a gem and armor from the current wear pos set
        self.room:spawn_object(553, 23 + what_armor_drop)
        self.room:spawn_object(555, 89 + what_gem_drop)
    else
        -- BONUS ROUND: drop armor and gem from next wear pos
        self.room:spawn_object(555, 93 + what_gem_drop)
        self.room:spawn_object(553, 27 + what_armor_drop)
    end
end