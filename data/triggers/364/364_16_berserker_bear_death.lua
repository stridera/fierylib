-- Trigger: berserker_bear_death
-- Zone: 364, ID: 16
-- Type: MOB, Flags: DEATH
-- Status: CLEAN
--
-- Death trigger for the berserker miniboss bear:
--   1. If the killer is on stage 4 of berserker_subclass and this mob is
--      their assigned target, complete the quest.
--   2. Roll a loot drop on the carcass:
--        - 30% nothing
--        - 40% gem only
--        - 20% armor only
--        - 10% gem + armor
--      Each loot category has three sub-tiers (previous / current / next
--      wear position set) chosen by a separate `bonus` roll.
--
-- Original DG Script: #36416

if actor:get_quest_stage("berserker_subclass") == 4
    and actor:get_quest_var("berserker_subclass:target") == self.id
then
    actor:send("<b:cyan>Congratulations, you have succeeded in your Wild Hunt!</>")
    actor:send("<b:cyan>You have earned the right to become a &9<blue>Ber<red>ser&9ker<b:cyan>!</>")
    actor:send("Type '<b:yellow>subclass</>' to proceed.")
    actor:complete_quest("berserker_subclass")
end

-- Loot rolls. Roll each driver exactly once.
local will_drop = random(1, 100)
if will_drop <= 30 then
    return true
end
local bonus = random(1, 100)
local what_armor_drop = random(1, 3)
local what_gem_drop = random(1, 4)

-- Pick which gem/armor sub-tier this `bonus` roll falls into.
-- 1..50 = previous wear pos set, 51..90 = current, 91..100 = next.
local function gem_id()
    if bonus <= 50 then
        return 73 + what_gem_drop  -- previous tier
    elseif bonus <= 90 then
        return 77 + what_gem_drop  -- current tier
    else
        return 81 + what_gem_drop  -- bonus next-tier
    end
end
local function armor_id()
    if bonus <= 50 then
        return 7 + what_armor_drop
    elseif bonus <= 90 then
        return 11 + what_armor_drop
    else
        return 15 + what_armor_drop
    end
end

if will_drop <= 70 then
    -- gem only (zone 555)
    self.room:spawn_object(555, gem_id())
elseif will_drop <= 90 then
    -- armor only (zone 553)
    self.room:spawn_object(553, armor_id())
else
    -- gem + armor (bonus round)
    self.room:spawn_object(555, gem_id())
    self.room:spawn_object(553, armor_id())
end
return true
