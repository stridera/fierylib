-- Trigger: hell_gate_armor_p2_doppelganger_55585
-- Zone: 564, ID: 10
-- Type: MOB, Flags: DEATH
-- Status: CLEAN
--
-- Original DG Script: #56410
--
-- Death trigger on the phase-2 doppelganger miniboss (55585). Two
-- effects:
--   1. (Hell Gate parity) If the killer is wearing the ritual dagger
--      (564, 7) and is on stage 3, ~35% chance to drop blood vial
--      (564, 4) — but only once per quest. Uses the same
--      `blood<N>` key family as 564_05.
--   2. Random gem and/or armor drops biased by two d100 rolls. The
--      `bonus` axis chooses which sub-phase wear set the drop comes
--      from (previous, current, or "bonus round" = next). The
--      `will_drop` axis chooses what kind of drop (nothing, gem only,
--      armor only, or both).

-- Hell Gate side-effect.
if actor:get_quest_stage("hell_gate") == 3 and actor:has_equipped(564, 7) then
    if random(1, 100) > 65 then
        if not actor:get_quest_var("hell_gate:blood4") then
            actor:set_quest_var("hell_gate", "blood4", 1)
            self.room:spawn_object(564, 4)
        end
    end
end

-- Miniboss random-loot table.
local bonus = random(1, 100)
local will_drop = random(1, 100)
-- 4 pieces of armor per sub-phase in phase 2.
local what_armor_drop = random(1, 4)
-- 11 classes questing in phase 2.
local what_gem_drop = random(1, 11)

if will_drop <= 30 then
    -- Drop nothing and bail.
    return true
end

if will_drop <= 70 then
    -- Gem-only drop, with sub-phase wear set chosen by `bonus`.
    if bonus <= 50 then
        -- Previous wear-pos set.
        self.room:spawn_object(556, 37 + what_gem_drop)
    elseif bonus <= 90 then
        -- Current wear-pos set.
        self.room:spawn_object(556, 48 + what_gem_drop)
    else
        -- Bonus round: next wear-pos set.
        self.room:spawn_object(556, 59 + what_gem_drop)
    end
elseif will_drop <= 90 then
    -- Armor-only drop.
    if bonus <= 50 then
        -- Previous wear-pos set armor (553, 44..47).
        self.room:spawn_object(553, 43 + what_armor_drop)
    elseif bonus <= 90 then
        -- Current wear-pos set armor (553, 48..51).
        self.room:spawn_object(553, 47 + what_armor_drop)
    else
        -- Bonus round: next wear-pos set armor (553, 52..55).
        self.room:spawn_object(553, 51 + what_armor_drop)
    end
else
    -- Combined gem + armor drop.
    if bonus <= 50 then
        self.room:spawn_object(556, 37 + what_gem_drop)
        self.room:spawn_object(553, 43 + what_armor_drop)
    elseif bonus <= 90 then
        self.room:spawn_object(553, 47 + what_armor_drop)
        self.room:spawn_object(556, 48 + what_gem_drop)
    else
        self.room:spawn_object(556, 59 + what_gem_drop)
        self.room:spawn_object(553, 51 + what_armor_drop)
    end
end
