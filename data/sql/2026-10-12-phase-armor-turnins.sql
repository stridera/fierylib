-- Phase armor turn-ins (553-555 RECEIVE scripts): quest vars keyed by object vnum as DG did, for the 556 status readers; 556:12 sorcerer phase 2 bracer vnum
--
-- Idempotent: a row already holding the new body is left alone, so rerunning
-- updates nothing. Keyed by the composite primary key (zone_id, id).
-- Guarded: a row is only touched while it still holds the previous committed
-- body (md5), so rows edited in Muditor since then are left alone.

BEGIN;

UPDATE "Triggers" AS t
SET commands = v.commands,
    updated_at = now()
FROM (VALUES
  -- data/triggers/553/553_01_cleric_phase_1.lua
  (553, 1, $trig$-- Converted from DG Script #55301: cleric_phase_1
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
--
-- Phase armor turn-in (class and phase specific). Quest vars are keyed by the legacy object
-- vnum, as DG did: phase_armor:<armor vnum>_armor_acquired (1 piece) and
-- phase_armor:<gem vnum>_gems_acquired (3 gems). The zone 556 status scripts read these keys.
-- The runtime fires RECEIVE after the item is already in the mob's hands, so a refusal hands
-- it back with a give command (DG's `return 0`).

local class_ok = false
for _, c in ipairs({"cleric", "priest", "diabolist", "druid"}) do
    if string.lower(actor.class or "") == c then
        class_ok = true
        break
    end
end

local function obj_name(vnum)
    return objects.template(math.floor(vnum / 100), vnum % 100).name
end

-- Item names carry a leading article ("a rusted helm"); give matches on the bare words.
local function bare_name(name)
    return (string.gsub(string.gsub(name, "^%s*[Tt]he%s+", ""), "^%s*[Aa]n?%s+", ""))
end

local function give_back()
    self:command("give " .. bare_name(object.name) .. " to " .. actor.name)
    actor:send(tostring(self.name) .. " returns your item to you.")
end

if not (class_ok and actor:get_quest_stage("phase_armor") >= 1) then
    -- not the right class / phase for this questmaster
    wait(1)
    self:command("eye " .. tostring(actor.name))
    actor:send(tostring(self.name) .. " tells you, 'I am not interested in this from you.'")
    give_back()
    return true
end

-- Slots for this class: destroyed armor, gem, reward (legacy 5-digit vnums) and exp multiplier.
local slots = {
    {slot = "helm", armor = 55312, gem = 55578, reward = 55391, mult = 10},
    {slot = "arm", armor = 55316, gem = 55582, reward = 55392, mult = 17},
    {slot = "chest", armor = 55324, gem = 55590, reward = 55393, mult = 29},
    {slot = "legs", armor = 55320, gem = 55586, reward = 55394, mult = 24},
    {slot = "boots", armor = 55304, gem = 55570, reward = 55395, mult = 4},
    {slot = "bracer", armor = 55308, gem = 55574, reward = 55396, mult = 7},
    {slot = "gloves", armor = 55300, gem = 55566, reward = 55397, mult = 2},
}

-- DG switch: an armor case falls through into its gem case, so both vnums map to the same slot.
local object_vnum = object.zone_id * 100 + object.id
local entry, is_armor
for _, s in ipairs(slots) do
    if object_vnum == s.armor then
        entry = s
        is_armor = true
        break
    elseif object_vnum == s.gem then
        entry = s
        is_armor = false
        break
    end
end
if not entry then
    wait(1)
    self:command("eye " .. tostring(actor.name))
    actor:send(tostring(self.name) .. " tells you, 'I am not interested in this from you.'")
    give_back()
    return true
end

local armor_key = tostring(entry.armor) .. "_armor_acquired"
local gem_key = tostring(entry.gem) .. "_gems_acquired"
local armor = tonumber(actor:get_quest_var("phase_armor:" .. armor_key)) or 0
local gems = tonumber(actor:get_quest_var("phase_armor:" .. gem_key)) or 0

if is_armor then
    if armor < 1 then
        armor = armor + 1
        actor:set_quest_var("phase_armor", armor_key, armor)
        wait(2)
        actor:send(tostring(self.name) .. " tells you, \"Hey now. what have we here?!  I've been looking for some of this\"")
        actor:send(tostring(self.name) .. " tells you, \"for quite some time.  You have now given me " .. obj_name(entry.armor) .. ".\"")
        world.destroy(object)
        actor:save()
    else
        wait(2)
        self:command("eye " .. tostring(actor.name))
        wait(1)
        actor:send(tostring(self.name) .. " tells you, \"Hey now, you have given me " .. obj_name(entry.armor) .. " already!\"")
        give_back()
        -- Halt here so the reward can't be given twice.
        return true
    end
else
    if gems < 3 then
        gems = gems + 1
        actor:set_quest_var("phase_armor", gem_key, gems)
        wait(2)
        actor:send(tostring(self.name) .. " tells you, \"Hey, very nice. It is good to see adventurers out conquering the\"")
        actor:send(tostring(self.name) .. " tells you, \"realm.  You have now given me " .. tostring(gems) .. " " .. obj_name(entry.gem) .. ".\"")
        world.destroy(object)
        actor:save()
    else
        wait(2)
        self:command("eye " .. tostring(actor.name))
        wait(1)
        actor:send(tostring(self.name) .. " tells you, \"Hey now, you have given me 3 already!\"")
        give_back()
        -- Halt here so the reward can't be given twice.
        return true
    end
end

-- Quest complete for this slot: armor piece plus all 3 gems.
if armor == 1 and gems == 3 then
    wait(2)
    actor:send(tostring(self.name) .. " tells you, \"Excellent intrepid adventurer, you have provided me with all\"")
    actor:send(tostring(self.name) .. " tells you, \"I need in order to reward you with " .. obj_name(entry.reward) .. "!\"")
    wait(1)
    local reward = self:spawn_object(math.floor(entry.reward / 100), entry.reward % 100)
    wait(1)
    actor:send("<b:yellow>You gain experience!</>")
    for _ = 1, entry.mult do
        actor:award_exp(2640)
    end
    if reward then
        self:command("give " .. bare_name(reward.name) .. " to " .. actor.name)
    end
end
return true$trig$, '4d1610459d6921818cf964cc23f060c8'),
  -- data/triggers/553/553_20_warrior_phase_1.lua
  (553, 20, $trig$-- Converted from DG Script #55320: warrior_phase_1
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
--
-- Phase armor turn-in (class and phase specific). Quest vars are keyed by the legacy object
-- vnum, as DG did: phase_armor:<armor vnum>_armor_acquired (1 piece) and
-- phase_armor:<gem vnum>_gems_acquired (3 gems). The zone 556 status scripts read these keys.
-- The runtime fires RECEIVE after the item is already in the mob's hands, so a refusal hands
-- it back with a give command (DG's `return 0`).

local class_ok = false
for _, c in ipairs({"warrior", "paladin", "anti-paladin", "ranger", "monk"}) do
    if string.lower(actor.class or "") == c then
        class_ok = true
        break
    end
end

local function obj_name(vnum)
    return objects.template(math.floor(vnum / 100), vnum % 100).name
end

-- Item names carry a leading article ("a rusted helm"); give matches on the bare words.
local function bare_name(name)
    return (string.gsub(string.gsub(name, "^%s*[Tt]he%s+", ""), "^%s*[Aa]n?%s+", ""))
end

local function give_back()
    self:command("give " .. bare_name(object.name) .. " to " .. actor.name)
    actor:send(tostring(self.name) .. " returns your item to you.")
end

if not (class_ok and actor.level >= 1 and actor:get_quest_stage("phase_armor") >= 1) then
    -- not the right class / phase for this questmaster
    wait(1)
    self:command("eye " .. tostring(actor.name))
    actor:send(tostring(self.name) .. " tells you, 'I am not interested in this from you.'")
    give_back()
    return true
end

-- Slots for this class: destroyed armor, gem, reward (legacy 5-digit vnums) and exp multiplier.
local slots = {
    {slot = "helm", armor = 55312, gem = 55581, reward = 55384, mult = 10},
    {slot = "arm", armor = 55316, gem = 55585, reward = 55385, mult = 17},
    {slot = "chest", armor = 55324, gem = 55593, reward = 55386, mult = 29},
    {slot = "legs", armor = 55320, gem = 55589, reward = 55387, mult = 24},
    {slot = "boots", armor = 55304, gem = 55573, reward = 55388, mult = 4},
    {slot = "bracer", armor = 55308, gem = 55577, reward = 55389, mult = 7},
    {slot = "gloves", armor = 55300, gem = 55569, reward = 55390, mult = 2},
}

-- DG switch: an armor case falls through into its gem case, so both vnums map to the same slot.
local object_vnum = object.zone_id * 100 + object.id
local entry, is_armor
for _, s in ipairs(slots) do
    if object_vnum == s.armor then
        entry = s
        is_armor = true
        break
    elseif object_vnum == s.gem then
        entry = s
        is_armor = false
        break
    end
end
if not entry then
    wait(1)
    self:command("eye " .. tostring(actor.name))
    actor:send(tostring(self.name) .. " tells you, 'I am not interested in this from you.'")
    give_back()
    return true
end

local armor_key = tostring(entry.armor) .. "_armor_acquired"
local gem_key = tostring(entry.gem) .. "_gems_acquired"
local armor = tonumber(actor:get_quest_var("phase_armor:" .. armor_key)) or 0
local gems = tonumber(actor:get_quest_var("phase_armor:" .. gem_key)) or 0

if is_armor then
    if armor < 1 then
        armor = armor + 1
        actor:set_quest_var("phase_armor", armor_key, armor)
        wait(2)
        actor:send(tostring(self.name) .. " tells you, \"Hey now. what have we here?!  I've been looking for some of this\"")
        actor:send(tostring(self.name) .. " tells you, \"for quite some time.  You have now given me " .. obj_name(entry.armor) .. ".\"")
        world.destroy(object)
        actor:save()
    else
        wait(2)
        self:command("eye " .. tostring(actor.name))
        wait(1)
        actor:send(tostring(self.name) .. " tells you, \"Hey now, you have given me " .. obj_name(entry.armor) .. " already!\"")
        give_back()
        -- Halt here so the reward can't be given twice.
        return true
    end
else
    if gems < 3 then
        gems = gems + 1
        actor:set_quest_var("phase_armor", gem_key, gems)
        wait(2)
        actor:send(tostring(self.name) .. " tells you, \"Hey, very nice. It is good to see adventurers out conquering the\"")
        actor:send(tostring(self.name) .. " tells you, \"realm.  You have now given me " .. tostring(gems) .. " " .. obj_name(entry.gem) .. ".\"")
        world.destroy(object)
        actor:save()
    else
        wait(2)
        self:command("eye " .. tostring(actor.name))
        wait(1)
        actor:send(tostring(self.name) .. " tells you, \"Hey now, you have given me 3 already!\"")
        give_back()
        -- Halt here so the reward can't be given twice.
        return true
    end
end

-- Quest complete for this slot: armor piece plus all 3 gems.
if armor == 1 and gems == 3 then
    wait(2)
    actor:send(tostring(self.name) .. " tells you, \"Excellent intrepid adventurer, you have provided me with all\"")
    actor:send(tostring(self.name) .. " tells you, \"I need in order to reward you with " .. obj_name(entry.reward) .. "!\"")
    wait(1)
    local reward = self:spawn_object(math.floor(entry.reward / 100), entry.reward % 100)
    wait(1)
    actor:send("<b:yellow>You gain experience!</>")
    for _ = 1, entry.mult do
        actor:award_exp(2640)
    end
    if reward then
        self:command("give " .. bare_name(reward.name) .. " to " .. actor.name)
    end
end
return true$trig$, '1af2c7ed9515584945a799e936471352'),
  -- data/triggers/553/553_30_sorcerer_phase_1.lua
  (553, 30, $trig$-- Converted from DG Script #55330: sorcerer_phase_1
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
--
-- Phase armor turn-in (class and phase specific). Quest vars are keyed by the legacy object
-- vnum, as DG did: phase_armor:<armor vnum>_armor_acquired (1 piece) and
-- phase_armor:<gem vnum>_gems_acquired (3 gems). The zone 556 status scripts read these keys.
-- The runtime fires RECEIVE after the item is already in the mob's hands, so a refusal hands
-- it back with a give command (DG's `return 0`).

local class_ok = false
for _, c in ipairs({"sorcerer", "necromancer", "conjurer", "cryomancer", "pyromancer"}) do
    if string.lower(actor.class or "") == c then
        class_ok = true
        break
    end
end

local function obj_name(vnum)
    return objects.template(math.floor(vnum / 100), vnum % 100).name
end

-- Item names carry a leading article ("a rusted helm"); give matches on the bare words.
local function bare_name(name)
    return (string.gsub(string.gsub(name, "^%s*[Tt]he%s+", ""), "^%s*[Aa]n?%s+", ""))
end

local function give_back()
    self:command("give " .. bare_name(object.name) .. " to " .. actor.name)
    actor:send(tostring(self.name) .. " returns your item to you.")
end

if not (class_ok and actor.level >= 1 and actor:get_quest_stage("phase_armor") >= 1) then
    -- not the right class / phase for this questmaster
    wait(1)
    self:command("eye " .. tostring(actor.name))
    actor:send(tostring(self.name) .. " tells you, 'I am not interested in this from you.'")
    give_back()
    return true
end

-- Slots for this class: destroyed armor, gem, reward (legacy 5-digit vnums) and exp multiplier.
local slots = {
    {slot = "helm", armor = 55314, gem = 55579, reward = 55398, mult = 10},
    {slot = "arm", armor = 55318, gem = 55583, reward = 55399, mult = 17},
    {slot = "chest", armor = 55326, gem = 55591, reward = 55400, mult = 29},
    {slot = "legs", armor = 55322, gem = 55587, reward = 55401, mult = 24},
    {slot = "boots", armor = 55306, gem = 55571, reward = 55402, mult = 4},
    {slot = "bracer", armor = 55310, gem = 55575, reward = 55403, mult = 7},
    {slot = "gloves", armor = 55302, gem = 55567, reward = 55404, mult = 2},
}

-- DG switch: an armor case falls through into its gem case, so both vnums map to the same slot.
local object_vnum = object.zone_id * 100 + object.id
local entry, is_armor
for _, s in ipairs(slots) do
    if object_vnum == s.armor then
        entry = s
        is_armor = true
        break
    elseif object_vnum == s.gem then
        entry = s
        is_armor = false
        break
    end
end
if not entry then
    wait(1)
    self:command("eye " .. tostring(actor.name))
    actor:send(tostring(self.name) .. " tells you, 'I am not interested in this from you.'")
    give_back()
    return true
end

local armor_key = tostring(entry.armor) .. "_armor_acquired"
local gem_key = tostring(entry.gem) .. "_gems_acquired"
local armor = tonumber(actor:get_quest_var("phase_armor:" .. armor_key)) or 0
local gems = tonumber(actor:get_quest_var("phase_armor:" .. gem_key)) or 0

if is_armor then
    if armor < 1 then
        armor = armor + 1
        actor:set_quest_var("phase_armor", armor_key, armor)
        wait(2)
        actor:send(tostring(self.name) .. " tells you, \"Hey now. what have we here?!  I've been looking for some of this\"")
        actor:send(tostring(self.name) .. " tells you, \"for quite some time.  You have now given me " .. obj_name(entry.armor) .. ".\"")
        world.destroy(object)
        actor:save()
    else
        wait(2)
        self:command("eye " .. tostring(actor.name))
        wait(1)
        actor:send(tostring(self.name) .. " tells you, \"Hey now, you have given me " .. obj_name(entry.armor) .. " already!\"")
        give_back()
        -- Halt here so the reward can't be given twice.
        return true
    end
else
    if gems < 3 then
        gems = gems + 1
        actor:set_quest_var("phase_armor", gem_key, gems)
        wait(2)
        actor:send(tostring(self.name) .. " tells you, \"Hey, very nice. It is good to see adventurers out conquering the\"")
        actor:send(tostring(self.name) .. " tells you, \"realm.  You have now given me " .. tostring(gems) .. " " .. obj_name(entry.gem) .. ".\"")
        world.destroy(object)
        actor:save()
    else
        wait(2)
        self:command("eye " .. tostring(actor.name))
        wait(1)
        actor:send(tostring(self.name) .. " tells you, \"Hey now, you have given me 3 already!\"")
        give_back()
        -- Halt here so the reward can't be given twice.
        return true
    end
end

-- Quest complete for this slot: armor piece plus all 3 gems.
if armor == 1 and gems == 3 then
    wait(2)
    actor:send(tostring(self.name) .. " tells you, \"Excellent intrepid adventurer, you have provided me with all\"")
    actor:send(tostring(self.name) .. " tells you, \"I need in order to reward you with " .. obj_name(entry.reward) .. "!\"")
    wait(1)
    local reward = self:spawn_object(math.floor(entry.reward / 100), entry.reward % 100)
    wait(1)
    actor:send("<b:yellow>You gain experience!</>")
    for _ = 1, entry.mult do
        actor:award_exp(2640)
    end
    if reward then
        self:command("give " .. bare_name(reward.name) .. " to " .. actor.name)
    end
end
return true$trig$, '51c37ca1ac3c9474523eca48f6bac9d4'),
  -- data/triggers/553/553_40_rogue_phase_1.lua
  (553, 40, $trig$-- Converted from DG Script #55340: rogue_phase_1
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
--
-- Phase armor turn-in (class and phase specific). Quest vars are keyed by the legacy object
-- vnum, as DG did: phase_armor:<armor vnum>_armor_acquired (1 piece) and
-- phase_armor:<gem vnum>_gems_acquired (3 gems). The zone 556 status scripts read these keys.
-- The runtime fires RECEIVE after the item is already in the mob's hands, so a refusal hands
-- it back with a give command (DG's `return 0`).

local class_ok = false
for _, c in ipairs({"rogue", "assassin", "thief", "mercenary"}) do
    if string.lower(actor.class or "") == c then
        class_ok = true
        break
    end
end

local function obj_name(vnum)
    return objects.template(math.floor(vnum / 100), vnum % 100).name
end

-- Item names carry a leading article ("a rusted helm"); give matches on the bare words.
local function bare_name(name)
    return (string.gsub(string.gsub(name, "^%s*[Tt]he%s+", ""), "^%s*[Aa]n?%s+", ""))
end

local function give_back()
    self:command("give " .. bare_name(object.name) .. " to " .. actor.name)
    actor:send(tostring(self.name) .. " returns your item to you.")
end

if not (class_ok and actor.level >= 1 and actor:get_quest_stage("phase_armor") >= 1) then
    -- not the right class / phase for this questmaster
    wait(1)
    self:command("eye " .. tostring(actor.name))
    actor:send(tostring(self.name) .. " tells you, 'I am not interested in this from you.'")
    give_back()
    return true
end

-- Slots for this class: destroyed armor, gem, reward (legacy 5-digit vnums) and exp multiplier.
local slots = {
    {slot = "helm", armor = 55313, gem = 55580, reward = 55405, mult = 10},
    {slot = "arm", armor = 55317, gem = 55584, reward = 55406, mult = 17},
    {slot = "chest", armor = 55325, gem = 55592, reward = 55407, mult = 29},
    {slot = "legs", armor = 55321, gem = 55588, reward = 55408, mult = 24},
    {slot = "boots", armor = 55305, gem = 55572, reward = 55409, mult = 4},
    {slot = "bracer", armor = 55309, gem = 55576, reward = 55410, mult = 7},
    {slot = "gloves", armor = 55301, gem = 55568, reward = 55411, mult = 2},
}

-- DG switch: an armor case falls through into its gem case, so both vnums map to the same slot.
local object_vnum = object.zone_id * 100 + object.id
local entry, is_armor
for _, s in ipairs(slots) do
    if object_vnum == s.armor then
        entry = s
        is_armor = true
        break
    elseif object_vnum == s.gem then
        entry = s
        is_armor = false
        break
    end
end
if not entry then
    wait(1)
    self:command("eye " .. tostring(actor.name))
    actor:send(tostring(self.name) .. " tells you, 'I am not interested in this from you.'")
    give_back()
    return true
end

local armor_key = tostring(entry.armor) .. "_armor_acquired"
local gem_key = tostring(entry.gem) .. "_gems_acquired"
local armor = tonumber(actor:get_quest_var("phase_armor:" .. armor_key)) or 0
local gems = tonumber(actor:get_quest_var("phase_armor:" .. gem_key)) or 0

if is_armor then
    if armor < 1 then
        armor = armor + 1
        actor:set_quest_var("phase_armor", armor_key, armor)
        wait(2)
        actor:send(tostring(self.name) .. " tells you, \"Hey now. what have we here?!  I've been looking for some of this\"")
        actor:send(tostring(self.name) .. " tells you, \"for quite some time.  You have now given me " .. obj_name(entry.armor) .. ".\"")
        world.destroy(object)
        actor:save()
    else
        wait(2)
        self:command("eye " .. tostring(actor.name))
        wait(1)
        actor:send(tostring(self.name) .. " tells you, \"Hey now, you have given me " .. obj_name(entry.armor) .. " already!\"")
        give_back()
        -- Halt here so the reward can't be given twice.
        return true
    end
else
    if gems < 3 then
        gems = gems + 1
        actor:set_quest_var("phase_armor", gem_key, gems)
        wait(2)
        actor:send(tostring(self.name) .. " tells you, \"Hey, very nice. It is good to see adventurers out conquering the\"")
        actor:send(tostring(self.name) .. " tells you, \"realm.  You have now given me " .. tostring(gems) .. " " .. obj_name(entry.gem) .. ".\"")
        world.destroy(object)
        actor:save()
    else
        wait(2)
        self:command("eye " .. tostring(actor.name))
        wait(1)
        actor:send(tostring(self.name) .. " tells you, \"Hey now, you have given me 3 already!\"")
        give_back()
        -- Halt here so the reward can't be given twice.
        return true
    end
end

-- Quest complete for this slot: armor piece plus all 3 gems.
if armor == 1 and gems == 3 then
    wait(2)
    actor:send(tostring(self.name) .. " tells you, \"Excellent intrepid adventurer, you have provided me with all\"")
    actor:send(tostring(self.name) .. " tells you, \"I need in order to reward you with " .. obj_name(entry.reward) .. "!\"")
    wait(1)
    local reward = self:spawn_object(math.floor(entry.reward / 100), entry.reward % 100)
    wait(1)
    actor:send("<b:yellow>You gain experience!</>")
    for _ = 1, entry.mult do
        actor:award_exp(2640)
    end
    if reward then
        self:command("give " .. bare_name(reward.name) .. " to " .. actor.name)
    end
end
return true$trig$, 'a969a1122d4925c2d9c1179e181bdf28'),
  -- data/triggers/553/553_50_anti-paladin_phase_2.lua
  (553, 50, $trig$-- Converted from DG Script #55350: anti-paladin_phase_2
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
--
-- Phase armor turn-in (class and phase specific). Quest vars are keyed by the legacy object
-- vnum, as DG did: phase_armor:<armor vnum>_armor_acquired (1 piece) and
-- phase_armor:<gem vnum>_gems_acquired (3 gems). The zone 556 status scripts read these keys.
-- The runtime fires RECEIVE after the item is already in the mob's hands, so a refusal hands
-- it back with a give command (DG's `return 0`).

local class_ok = false
for _, c in ipairs({"anti-paladin"}) do
    if string.lower(actor.class or "") == c then
        class_ok = true
        break
    end
end

local function obj_name(vnum)
    return objects.template(math.floor(vnum / 100), vnum % 100).name
end

-- Item names carry a leading article ("a rusted helm"); give matches on the bare words.
local function bare_name(name)
    return (string.gsub(string.gsub(name, "^%s*[Tt]he%s+", ""), "^%s*[Aa]n?%s+", ""))
end

local function give_back()
    self:command("give " .. bare_name(object.name) .. " to " .. actor.name)
    actor:send(tostring(self.name) .. " returns your item to you.")
end

if not (class_ok and actor.level >= 21 and actor:get_quest_stage("phase_armor") >= 2) then
    -- not the right class / phase for this questmaster
    wait(1)
    self:command("eye " .. tostring(actor.name))
    actor:send(tostring(self.name) .. " tells you, 'I am not interested in this from you.'")
    give_back()
    return true
end

-- Slots for this class: destroyed armor, gem, reward (legacy 5-digit vnums) and exp multiplier.
local slots = {
    {slot = "helm", armor = 55340, gem = 55627, reward = 55426, mult = 7},
    {slot = "arm", armor = 55344, gem = 55638, reward = 55427, mult = 8},
    {slot = "chest", armor = 55352, gem = 55660, reward = 55428, mult = 10},
    {slot = "legs", armor = 55348, gem = 55649, reward = 55429, mult = 9},
    {slot = "boots", armor = 55332, gem = 55605, reward = 55430, mult = 5},
    {slot = "bracer", armor = 55336, gem = 55616, reward = 55431, mult = 6},
    {slot = "gloves", armor = 55328, gem = 55594, reward = 55432, mult = 4},
}

-- DG switch: an armor case falls through into its gem case, so both vnums map to the same slot.
local object_vnum = object.zone_id * 100 + object.id
local entry, is_armor
for _, s in ipairs(slots) do
    if object_vnum == s.armor then
        entry = s
        is_armor = true
        break
    elseif object_vnum == s.gem then
        entry = s
        is_armor = false
        break
    end
end
if not entry then
    wait(1)
    self:command("eye " .. tostring(actor.name))
    actor:send(tostring(self.name) .. " tells you, 'I am not interested in this from you.'")
    give_back()
    return true
end

local armor_key = tostring(entry.armor) .. "_armor_acquired"
local gem_key = tostring(entry.gem) .. "_gems_acquired"
local armor = tonumber(actor:get_quest_var("phase_armor:" .. armor_key)) or 0
local gems = tonumber(actor:get_quest_var("phase_armor:" .. gem_key)) or 0

if is_armor then
    if armor < 1 then
        armor = armor + 1
        actor:set_quest_var("phase_armor", armor_key, armor)
        wait(2)
        actor:send(tostring(self.name) .. " tells you, \"Hey now. what have we here?!  I've been looking for some of this\"")
        actor:send(tostring(self.name) .. " tells you, \"for quite some time.  You have now given me " .. obj_name(entry.armor) .. ".\"")
        world.destroy(object)
        actor:save()
    else
        wait(2)
        self:command("eye " .. tostring(actor.name))
        wait(1)
        actor:send(tostring(self.name) .. " tells you, \"Hey now, you have given me " .. obj_name(entry.armor) .. " already!\"")
        give_back()
        -- Halt here so the reward can't be given twice.
        return true
    end
else
    if gems < 3 then
        gems = gems + 1
        actor:set_quest_var("phase_armor", gem_key, gems)
        wait(2)
        actor:send(tostring(self.name) .. " tells you, \"Hey, very nice. It is good to see adventurers out conquering the\"")
        actor:send(tostring(self.name) .. " tells you, \"realm.  You have now given me " .. tostring(gems) .. " " .. obj_name(entry.gem) .. ".\"")
        world.destroy(object)
        actor:save()
    else
        wait(2)
        self:command("eye " .. tostring(actor.name))
        wait(1)
        actor:send(tostring(self.name) .. " tells you, \"Hey now, you have given me 3 already!\"")
        give_back()
        -- Halt here so the reward can't be given twice.
        return true
    end
end

-- Quest complete for this slot: armor piece plus all 3 gems.
if armor == 1 and gems == 3 then
    wait(2)
    actor:send(tostring(self.name) .. " tells you, \"Excellent intrepid adventurer, you have provided me with all\"")
    actor:send(tostring(self.name) .. " tells you, \"I need in order to reward you with " .. obj_name(entry.reward) .. "!\"")
    wait(1)
    local reward = self:spawn_object(math.floor(entry.reward / 100), entry.reward % 100)
    wait(1)
    actor:send("<b:yellow>You gain experience!</>")
    for _ = 1, entry.mult do
        actor:award_exp(29880)
    end
    if reward then
        self:command("give " .. bare_name(reward.name) .. " to " .. actor.name)
    end
end
return true$trig$, '260cebf027a3128451886a70c22f9a7b'),
  -- data/triggers/553/553_60_cleric_phase_2.lua
  (553, 60, $trig$-- Converted from DG Script #55360: cleric_phase_2
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
--
-- Phase armor turn-in (class and phase specific). Quest vars are keyed by the legacy object
-- vnum, as DG did: phase_armor:<armor vnum>_armor_acquired (1 piece) and
-- phase_armor:<gem vnum>_gems_acquired (3 gems). The zone 556 status scripts read these keys.
-- The runtime fires RECEIVE after the item is already in the mob's hands, so a refusal hands
-- it back with a give command (DG's `return 0`).

local class_ok = false
for _, c in ipairs({"cleric", "priest"}) do
    if string.lower(actor.class or "") == c then
        class_ok = true
        break
    end
end

local function obj_name(vnum)
    return objects.template(math.floor(vnum / 100), vnum % 100).name
end

-- Item names carry a leading article ("a rusted helm"); give matches on the bare words.
local function bare_name(name)
    return (string.gsub(string.gsub(name, "^%s*[Tt]he%s+", ""), "^%s*[Aa]n?%s+", ""))
end

local function give_back()
    self:command("give " .. bare_name(object.name) .. " to " .. actor.name)
    actor:send(tostring(self.name) .. " returns your item to you.")
end

if not (class_ok and actor.level >= 21 and actor:get_quest_stage("phase_armor") >= 2) then
    -- not the right class / phase for this questmaster
    wait(1)
    self:command("eye " .. tostring(actor.name))
    actor:send(tostring(self.name) .. " tells you, 'I am not interested in this from you.'")
    give_back()
    return true
end

-- Slots for this class: destroyed armor, gem, reward (legacy 5-digit vnums) and exp multiplier.
local slots = {
    {slot = "helm", armor = 55340, gem = 55634, reward = 55433, mult = 7},
    {slot = "arm", armor = 55344, gem = 55645, reward = 55434, mult = 8},
    {slot = "chest", armor = 55352, gem = 55667, reward = 55435, mult = 10},
    {slot = "legs", armor = 55348, gem = 55656, reward = 55436, mult = 9},
    {slot = "boots", armor = 55332, gem = 55612, reward = 55437, mult = 5},
    {slot = "bracer", armor = 55336, gem = 55623, reward = 55438, mult = 6},
    {slot = "gloves", armor = 55328, gem = 55601, reward = 55439, mult = 4},
}

-- DG switch: an armor case falls through into its gem case, so both vnums map to the same slot.
local object_vnum = object.zone_id * 100 + object.id
local entry, is_armor
for _, s in ipairs(slots) do
    if object_vnum == s.armor then
        entry = s
        is_armor = true
        break
    elseif object_vnum == s.gem then
        entry = s
        is_armor = false
        break
    end
end
if not entry then
    wait(1)
    self:command("eye " .. tostring(actor.name))
    actor:send(tostring(self.name) .. " tells you, 'I am not interested in this from you.'")
    give_back()
    return true
end

local armor_key = tostring(entry.armor) .. "_armor_acquired"
local gem_key = tostring(entry.gem) .. "_gems_acquired"
local armor = tonumber(actor:get_quest_var("phase_armor:" .. armor_key)) or 0
local gems = tonumber(actor:get_quest_var("phase_armor:" .. gem_key)) or 0

if is_armor then
    if armor < 1 then
        armor = armor + 1
        actor:set_quest_var("phase_armor", armor_key, armor)
        wait(2)
        actor:send(tostring(self.name) .. " tells you, \"Hey now. what have we here?!  I've been looking for some of this\"")
        actor:send(tostring(self.name) .. " tells you, \"for quite some time.  You have now given me " .. obj_name(entry.armor) .. ".\"")
        world.destroy(object)
        actor:save()
    else
        wait(2)
        self:command("eye " .. tostring(actor.name))
        wait(1)
        actor:send(tostring(self.name) .. " tells you, \"Hey now, you have given me " .. obj_name(entry.armor) .. " already!\"")
        give_back()
        -- Halt here so the reward can't be given twice.
        return true
    end
else
    if gems < 3 then
        gems = gems + 1
        actor:set_quest_var("phase_armor", gem_key, gems)
        wait(2)
        actor:send(tostring(self.name) .. " tells you, \"Hey, very nice. It is good to see adventurers out conquering the\"")
        actor:send(tostring(self.name) .. " tells you, \"realm.  You have now given me " .. tostring(gems) .. " " .. obj_name(entry.gem) .. ".\"")
        world.destroy(object)
        actor:save()
    else
        wait(2)
        self:command("eye " .. tostring(actor.name))
        wait(1)
        actor:send(tostring(self.name) .. " tells you, \"Hey now, you have given me 3 already!\"")
        give_back()
        -- Halt here so the reward can't be given twice.
        return true
    end
end

-- Quest complete for this slot: armor piece plus all 3 gems.
if armor == 1 and gems == 3 then
    wait(2)
    actor:send(tostring(self.name) .. " tells you, \"Excellent intrepid adventurer, you have provided me with all\"")
    actor:send(tostring(self.name) .. " tells you, \"I need in order to reward you with " .. obj_name(entry.reward) .. "!\"")
    wait(1)
    local reward = self:spawn_object(math.floor(entry.reward / 100), entry.reward % 100)
    wait(1)
    actor:send("<b:yellow>You gain experience!</>")
    for _ = 1, entry.mult do
        actor:award_exp(29880)
    end
    if reward then
        self:command("give " .. bare_name(reward.name) .. " to " .. actor.name)
    end
end
return true$trig$, '219eff67aa64e80a84d1a416a7af0f6a'),
  -- data/triggers/553/553_70_diabolist_phase_2.lua
  (553, 70, $trig$-- Converted from DG Script #55370: diabolist_phase_2
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
--
-- Phase armor turn-in (class and phase specific). Quest vars are keyed by the legacy object
-- vnum, as DG did: phase_armor:<armor vnum>_armor_acquired (1 piece) and
-- phase_armor:<gem vnum>_gems_acquired (3 gems). The zone 556 status scripts read these keys.
-- The runtime fires RECEIVE after the item is already in the mob's hands, so a refusal hands
-- it back with a give command (DG's `return 0`).

local class_ok = false
for _, c in ipairs({"diabolist"}) do
    if string.lower(actor.class or "") == c then
        class_ok = true
        break
    end
end

local function obj_name(vnum)
    return objects.template(math.floor(vnum / 100), vnum % 100).name
end

-- Item names carry a leading article ("a rusted helm"); give matches on the bare words.
local function bare_name(name)
    return (string.gsub(string.gsub(name, "^%s*[Tt]he%s+", ""), "^%s*[Aa]n?%s+", ""))
end

local function give_back()
    self:command("give " .. bare_name(object.name) .. " to " .. actor.name)
    actor:send(tostring(self.name) .. " returns your item to you.")
end

if not (class_ok and actor.level >= 21 and actor:get_quest_stage("phase_armor") >= 2) then
    -- not the right class / phase for this questmaster
    wait(1)
    self:command("eye " .. tostring(actor.name))
    actor:send(tostring(self.name) .. " tells you, 'I am not interested in this from you.'")
    give_back()
    return true
end

-- Slots for this class: destroyed armor, gem, reward (legacy 5-digit vnums) and exp multiplier.
local slots = {
    {slot = "helm", armor = 55340, gem = 55628, reward = 55468, mult = 7},
    {slot = "arm", armor = 55344, gem = 55639, reward = 55469, mult = 8},
    {slot = "chest", armor = 55352, gem = 55661, reward = 55470, mult = 10},
    {slot = "legs", armor = 55348, gem = 55650, reward = 55471, mult = 9},
    {slot = "boots", armor = 55332, gem = 55606, reward = 55472, mult = 5},
    {slot = "bracer", armor = 55336, gem = 55617, reward = 55473, mult = 6},
    {slot = "gloves", armor = 55328, gem = 55595, reward = 55474, mult = 4},
}

-- DG switch: an armor case falls through into its gem case, so both vnums map to the same slot.
local object_vnum = object.zone_id * 100 + object.id
local entry, is_armor
for _, s in ipairs(slots) do
    if object_vnum == s.armor then
        entry = s
        is_armor = true
        break
    elseif object_vnum == s.gem then
        entry = s
        is_armor = false
        break
    end
end
if not entry then
    wait(1)
    self:command("eye " .. tostring(actor.name))
    actor:send(tostring(self.name) .. " tells you, 'I am not interested in this from you.'")
    give_back()
    return true
end

local armor_key = tostring(entry.armor) .. "_armor_acquired"
local gem_key = tostring(entry.gem) .. "_gems_acquired"
local armor = tonumber(actor:get_quest_var("phase_armor:" .. armor_key)) or 0
local gems = tonumber(actor:get_quest_var("phase_armor:" .. gem_key)) or 0

if is_armor then
    if armor < 1 then
        armor = armor + 1
        actor:set_quest_var("phase_armor", armor_key, armor)
        wait(2)
        actor:send(tostring(self.name) .. " tells you, \"Hey now. what have we here?!  I've been looking for some of this\"")
        actor:send(tostring(self.name) .. " tells you, \"for quite some time.  You have now given me " .. obj_name(entry.armor) .. ".\"")
        world.destroy(object)
        actor:save()
    else
        wait(2)
        self:command("eye " .. tostring(actor.name))
        wait(1)
        actor:send(tostring(self.name) .. " tells you, \"Hey now, you have given me " .. obj_name(entry.armor) .. " already!\"")
        give_back()
        -- Halt here so the reward can't be given twice.
        return true
    end
else
    if gems < 3 then
        gems = gems + 1
        actor:set_quest_var("phase_armor", gem_key, gems)
        wait(2)
        actor:send(tostring(self.name) .. " tells you, \"Hey, very nice. It is good to see adventurers out conquering the\"")
        actor:send(tostring(self.name) .. " tells you, \"realm.  You have now given me " .. tostring(gems) .. " " .. obj_name(entry.gem) .. ".\"")
        world.destroy(object)
        actor:save()
    else
        wait(2)
        self:command("eye " .. tostring(actor.name))
        wait(1)
        actor:send(tostring(self.name) .. " tells you, \"Hey now, you have given me 3 already!\"")
        give_back()
        -- Halt here so the reward can't be given twice.
        return true
    end
end

-- Quest complete for this slot: armor piece plus all 3 gems.
if armor == 1 and gems == 3 then
    wait(2)
    actor:send(tostring(self.name) .. " tells you, \"Excellent intrepid adventurer, you have provided me with all\"")
    actor:send(tostring(self.name) .. " tells you, \"I need in order to reward you with " .. obj_name(entry.reward) .. "!\"")
    wait(1)
    local reward = self:spawn_object(math.floor(entry.reward / 100), entry.reward % 100)
    wait(1)
    actor:send("<b:yellow>You gain experience!</>")
    for _ = 1, entry.mult do
        actor:award_exp(29880)
    end
    if reward then
        self:command("give " .. bare_name(reward.name) .. " to " .. actor.name)
    end
end
return true$trig$, '336f6aa028c785bff52ec6f7a1ff4fe5'),
  -- data/triggers/553/553_80_druid_phase_2.lua
  (553, 80, $trig$-- Converted from DG Script #55380: druid_phase_2
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
--
-- Phase armor turn-in (class and phase specific). Quest vars are keyed by the legacy object
-- vnum, as DG did: phase_armor:<armor vnum>_armor_acquired (1 piece) and
-- phase_armor:<gem vnum>_gems_acquired (3 gems). The zone 556 status scripts read these keys.
-- The runtime fires RECEIVE after the item is already in the mob's hands, so a refusal hands
-- it back with a give command (DG's `return 0`).

local class_ok = false
for _, c in ipairs({"druid"}) do
    if string.lower(actor.class or "") == c then
        class_ok = true
        break
    end
end

local function obj_name(vnum)
    return objects.template(math.floor(vnum / 100), vnum % 100).name
end

-- Item names carry a leading article ("a rusted helm"); give matches on the bare words.
local function bare_name(name)
    return (string.gsub(string.gsub(name, "^%s*[Tt]he%s+", ""), "^%s*[Aa]n?%s+", ""))
end

local function give_back()
    self:command("give " .. bare_name(object.name) .. " to " .. actor.name)
    actor:send(tostring(self.name) .. " returns your item to you.")
end

if not (class_ok and actor.level >= 21 and actor:get_quest_stage("phase_armor") >= 2) then
    -- not the right class / phase for this questmaster
    wait(1)
    self:command("eye " .. tostring(actor.name))
    actor:send(tostring(self.name) .. " tells you, 'I am not interested in this from you.'")
    give_back()
    return true
end

-- Slots for this class: destroyed armor, gem, reward (legacy 5-digit vnums) and exp multiplier.
local slots = {
    {slot = "helm", armor = 55342, gem = 55629, reward = 55447, mult = 7},
    {slot = "arm", armor = 55346, gem = 55640, reward = 55448, mult = 8},
    {slot = "chest", armor = 55354, gem = 55662, reward = 55449, mult = 10},
    {slot = "legs", armor = 55350, gem = 55651, reward = 55450, mult = 9},
    {slot = "boots", armor = 55334, gem = 55607, reward = 55451, mult = 5},
    {slot = "bracer", armor = 55338, gem = 55618, reward = 55452, mult = 6},
    {slot = "gloves", armor = 55330, gem = 55596, reward = 55453, mult = 4},
}

-- DG switch: an armor case falls through into its gem case, so both vnums map to the same slot.
local object_vnum = object.zone_id * 100 + object.id
local entry, is_armor
for _, s in ipairs(slots) do
    if object_vnum == s.armor then
        entry = s
        is_armor = true
        break
    elseif object_vnum == s.gem then
        entry = s
        is_armor = false
        break
    end
end
if not entry then
    wait(1)
    self:command("eye " .. tostring(actor.name))
    actor:send(tostring(self.name) .. " tells you, 'I am not interested in this from you.'")
    give_back()
    return true
end

local armor_key = tostring(entry.armor) .. "_armor_acquired"
local gem_key = tostring(entry.gem) .. "_gems_acquired"
local armor = tonumber(actor:get_quest_var("phase_armor:" .. armor_key)) or 0
local gems = tonumber(actor:get_quest_var("phase_armor:" .. gem_key)) or 0

if is_armor then
    if armor < 1 then
        armor = armor + 1
        actor:set_quest_var("phase_armor", armor_key, armor)
        wait(2)
        actor:send(tostring(self.name) .. " tells you, \"Hey now. what have we here?!  I've been looking for some of this\"")
        actor:send(tostring(self.name) .. " tells you, \"for quite some time.  You have now given me " .. obj_name(entry.armor) .. ".\"")
        world.destroy(object)
        actor:save()
    else
        wait(2)
        self:command("eye " .. tostring(actor.name))
        wait(1)
        actor:send(tostring(self.name) .. " tells you, \"Hey now, you have given me " .. obj_name(entry.armor) .. " already!\"")
        give_back()
        -- Halt here so the reward can't be given twice.
        return true
    end
else
    if gems < 3 then
        gems = gems + 1
        actor:set_quest_var("phase_armor", gem_key, gems)
        wait(2)
        actor:send(tostring(self.name) .. " tells you, \"Hey, very nice. It is good to see adventurers out conquering the\"")
        actor:send(tostring(self.name) .. " tells you, \"realm.  You have now given me " .. tostring(gems) .. " " .. obj_name(entry.gem) .. ".\"")
        world.destroy(object)
        actor:save()
    else
        wait(2)
        self:command("eye " .. tostring(actor.name))
        wait(1)
        actor:send(tostring(self.name) .. " tells you, \"Hey now, you have given me 3 already!\"")
        give_back()
        -- Halt here so the reward can't be given twice.
        return true
    end
end

-- Quest complete for this slot: armor piece plus all 3 gems.
if armor == 1 and gems == 3 then
    wait(2)
    actor:send(tostring(self.name) .. " tells you, \"Excellent intrepid adventurer, you have provided me with all\"")
    actor:send(tostring(self.name) .. " tells you, \"I need in order to reward you with " .. obj_name(entry.reward) .. "!\"")
    wait(1)
    local reward = self:spawn_object(math.floor(entry.reward / 100), entry.reward % 100)
    wait(1)
    actor:send("<b:yellow>You gain experience!</>")
    for _ = 1, entry.mult do
        actor:award_exp(29880)
    end
    if reward then
        self:command("give " .. bare_name(reward.name) .. " to " .. actor.name)
    end
end
return true$trig$, '29c787f572663eaf474f7a3163f3c808'),
  -- data/triggers/553/553_90_monk_phase_2.lua
  (553, 90, $trig$-- Converted from DG Script #55390: monk_phase_2
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
--
-- Phase armor turn-in (class and phase specific). Quest vars are keyed by the legacy object
-- vnum, as DG did: phase_armor:<armor vnum>_armor_acquired (1 piece) and
-- phase_armor:<gem vnum>_gems_acquired (3 gems). The zone 556 status scripts read these keys.
-- The runtime fires RECEIVE after the item is already in the mob's hands, so a refusal hands
-- it back with a give command (DG's `return 0`).

local class_ok = false
for _, c in ipairs({"monk"}) do
    if string.lower(actor.class or "") == c then
        class_ok = true
        break
    end
end

local function obj_name(vnum)
    return objects.template(math.floor(vnum / 100), vnum % 100).name
end

-- Item names carry a leading article ("a rusted helm"); give matches on the bare words.
local function bare_name(name)
    return (string.gsub(string.gsub(name, "^%s*[Tt]he%s+", ""), "^%s*[Aa]n?%s+", ""))
end

local function give_back()
    self:command("give " .. bare_name(object.name) .. " to " .. actor.name)
    actor:send(tostring(self.name) .. " returns your item to you.")
end

if not (class_ok and actor.level >= 21 and actor:get_quest_stage("phase_armor") >= 2) then
    -- not the right class / phase for this questmaster
    wait(1)
    self:command("eye " .. tostring(actor.name))
    actor:send(tostring(self.name) .. " tells you, 'I am not interested in this from you.'")
    give_back()
    return true
end

-- Slots for this class: destroyed armor, gem, reward (legacy 5-digit vnums) and exp multiplier.
local slots = {
    {slot = "helm", armor = 55342, gem = 55630, reward = 55461, mult = 7},
    {slot = "arm", armor = 55346, gem = 55641, reward = 55462, mult = 8},
    {slot = "chest", armor = 55354, gem = 55663, reward = 55463, mult = 10},
    {slot = "legs", armor = 55350, gem = 55652, reward = 55464, mult = 9},
    {slot = "boots", armor = 55334, gem = 55608, reward = 55465, mult = 5},
    {slot = "bracer", armor = 55338, gem = 55619, reward = 55466, mult = 6},
    {slot = "gloves", armor = 55330, gem = 55597, reward = 55467, mult = 4},
}

-- DG switch: an armor case falls through into its gem case, so both vnums map to the same slot.
local object_vnum = object.zone_id * 100 + object.id
local entry, is_armor
for _, s in ipairs(slots) do
    if object_vnum == s.armor then
        entry = s
        is_armor = true
        break
    elseif object_vnum == s.gem then
        entry = s
        is_armor = false
        break
    end
end
if not entry then
    wait(1)
    self:command("eye " .. tostring(actor.name))
    actor:send(tostring(self.name) .. " tells you, 'I am not interested in this from you.'")
    give_back()
    return true
end

local armor_key = tostring(entry.armor) .. "_armor_acquired"
local gem_key = tostring(entry.gem) .. "_gems_acquired"
local armor = tonumber(actor:get_quest_var("phase_armor:" .. armor_key)) or 0
local gems = tonumber(actor:get_quest_var("phase_armor:" .. gem_key)) or 0

if is_armor then
    if armor < 1 then
        armor = armor + 1
        actor:set_quest_var("phase_armor", armor_key, armor)
        wait(2)
        actor:send(tostring(self.name) .. " tells you, \"Hey now. what have we here?!  I've been looking for some of this\"")
        actor:send(tostring(self.name) .. " tells you, \"for quite some time.  You have now given me " .. obj_name(entry.armor) .. ".\"")
        world.destroy(object)
        actor:save()
    else
        wait(2)
        self:command("eye " .. tostring(actor.name))
        wait(1)
        actor:send(tostring(self.name) .. " tells you, \"Hey now, you have given me " .. obj_name(entry.armor) .. " already!\"")
        give_back()
        -- Halt here so the reward can't be given twice.
        return true
    end
else
    if gems < 3 then
        gems = gems + 1
        actor:set_quest_var("phase_armor", gem_key, gems)
        wait(2)
        actor:send(tostring(self.name) .. " tells you, \"Hey, very nice. It is good to see adventurers out conquering the\"")
        actor:send(tostring(self.name) .. " tells you, \"realm.  You have now given me " .. tostring(gems) .. " " .. obj_name(entry.gem) .. ".\"")
        world.destroy(object)
        actor:save()
    else
        wait(2)
        self:command("eye " .. tostring(actor.name))
        wait(1)
        actor:send(tostring(self.name) .. " tells you, \"Hey now, you have given me 3 already!\"")
        give_back()
        -- Halt here so the reward can't be given twice.
        return true
    end
end

-- Quest complete for this slot: armor piece plus all 3 gems.
if armor == 1 and gems == 3 then
    wait(2)
    actor:send(tostring(self.name) .. " tells you, \"Excellent intrepid adventurer, you have provided me with all\"")
    actor:send(tostring(self.name) .. " tells you, \"I need in order to reward you with " .. obj_name(entry.reward) .. "!\"")
    wait(1)
    local reward = self:spawn_object(math.floor(entry.reward / 100), entry.reward % 100)
    wait(1)
    actor:send("<b:yellow>You gain experience!</>")
    for _ = 1, entry.mult do
        actor:award_exp(29880)
    end
    if reward then
        self:command("give " .. bare_name(reward.name) .. " to " .. actor.name)
    end
end
return true$trig$, 'b219de9a3e2add90114712cc46e77911'),
  -- data/triggers/554/554_00_necromancer_phase_2.lua
  (554, 0, $trig$-- Converted from DG Script #55400: necromancer_phase_2
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
--
-- Phase armor turn-in (class and phase specific). Quest vars are keyed by the legacy object
-- vnum, as DG did: phase_armor:<armor vnum>_armor_acquired (1 piece) and
-- phase_armor:<gem vnum>_gems_acquired (3 gems). The zone 556 status scripts read these keys.
-- The runtime fires RECEIVE after the item is already in the mob's hands, so a refusal hands
-- it back with a give command (DG's `return 0`).

local class_ok = false
for _, c in ipairs({"necromancer"}) do
    if string.lower(actor.class or "") == c then
        class_ok = true
        break
    end
end

local function obj_name(vnum)
    return objects.template(math.floor(vnum / 100), vnum % 100).name
end

-- Item names carry a leading article ("a rusted helm"); give matches on the bare words.
local function bare_name(name)
    return (string.gsub(string.gsub(name, "^%s*[Tt]he%s+", ""), "^%s*[Aa]n?%s+", ""))
end

local function give_back()
    self:command("give " .. bare_name(object.name) .. " to " .. actor.name)
    actor:send(tostring(self.name) .. " returns your item to you.")
end

if not (class_ok and actor.level >= 21 and actor:get_quest_stage("phase_armor") >= 2) then
    -- not the right class / phase for this questmaster
    wait(1)
    self:command("eye " .. tostring(actor.name))
    actor:send(tostring(self.name) .. " tells you, 'I am not interested in this from you.'")
    give_back()
    return true
end

-- Slots for this class: destroyed armor, gem, reward (legacy 5-digit vnums) and exp multiplier.
local slots = {
    {slot = "helm", armor = 55343, gem = 55631, reward = 55454, mult = 7},
    {slot = "arm", armor = 55347, gem = 55642, reward = 55455, mult = 8},
    {slot = "chest", armor = 55355, gem = 55664, reward = 55456, mult = 10},
    {slot = "legs", armor = 55351, gem = 55653, reward = 55457, mult = 9},
    {slot = "boots", armor = 55335, gem = 55609, reward = 55458, mult = 5},
    {slot = "bracer", armor = 55339, gem = 55620, reward = 55459, mult = 6},
    {slot = "gloves", armor = 55331, gem = 55598, reward = 55460, mult = 4},
}

-- DG switch: an armor case falls through into its gem case, so both vnums map to the same slot.
local object_vnum = object.zone_id * 100 + object.id
local entry, is_armor
for _, s in ipairs(slots) do
    if object_vnum == s.armor then
        entry = s
        is_armor = true
        break
    elseif object_vnum == s.gem then
        entry = s
        is_armor = false
        break
    end
end
if not entry then
    wait(1)
    self:command("eye " .. tostring(actor.name))
    actor:send(tostring(self.name) .. " tells you, 'I am not interested in this from you.'")
    give_back()
    return true
end

local armor_key = tostring(entry.armor) .. "_armor_acquired"
local gem_key = tostring(entry.gem) .. "_gems_acquired"
local armor = tonumber(actor:get_quest_var("phase_armor:" .. armor_key)) or 0
local gems = tonumber(actor:get_quest_var("phase_armor:" .. gem_key)) or 0

if is_armor then
    if armor < 1 then
        armor = armor + 1
        actor:set_quest_var("phase_armor", armor_key, armor)
        wait(2)
        actor:send(tostring(self.name) .. " tells you, \"Hey now. what have we here?!  I've been looking for some of this\"")
        actor:send(tostring(self.name) .. " tells you, \"for quite some time.  You have now given me " .. obj_name(entry.armor) .. ".\"")
        world.destroy(object)
        actor:save()
    else
        wait(2)
        self:command("eye " .. tostring(actor.name))
        wait(1)
        actor:send(tostring(self.name) .. " tells you, \"Hey now, you have given me " .. obj_name(entry.armor) .. " already!\"")
        give_back()
        -- Halt here so the reward can't be given twice.
        return true
    end
else
    if gems < 3 then
        gems = gems + 1
        actor:set_quest_var("phase_armor", gem_key, gems)
        wait(2)
        actor:send(tostring(self.name) .. " tells you, \"Hey, very nice. It is good to see adventurers out conquering the\"")
        actor:send(tostring(self.name) .. " tells you, \"realm.  You have now given me " .. tostring(gems) .. " " .. obj_name(entry.gem) .. ".\"")
        world.destroy(object)
        actor:save()
    else
        wait(2)
        self:command("eye " .. tostring(actor.name))
        wait(1)
        actor:send(tostring(self.name) .. " tells you, \"Hey now, you have given me 3 already!\"")
        give_back()
        -- Halt here so the reward can't be given twice.
        return true
    end
end

-- Quest complete for this slot: armor piece plus all 3 gems.
if armor == 1 and gems == 3 then
    wait(2)
    actor:send(tostring(self.name) .. " tells you, \"Excellent intrepid adventurer, you have provided me with all\"")
    actor:send(tostring(self.name) .. " tells you, \"I need in order to reward you with " .. obj_name(entry.reward) .. "!\"")
    wait(1)
    local reward = self:spawn_object(math.floor(entry.reward / 100), entry.reward % 100)
    wait(1)
    actor:send("<b:yellow>You gain experience!</>")
    for _ = 1, entry.mult do
        actor:award_exp(29880)
    end
    if reward then
        self:command("give " .. bare_name(reward.name) .. " to " .. actor.name)
    end
end
return true$trig$, '016a8622ab47c9f6d28f7d25990b88f8'),
  -- data/triggers/554/554_10_paladin_phase_2.lua
  (554, 10, $trig$-- Converted from DG Script #55410: paladin_phase_2
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
--
-- Phase armor turn-in (class and phase specific). Quest vars are keyed by the legacy object
-- vnum, as DG did: phase_armor:<armor vnum>_armor_acquired (1 piece) and
-- phase_armor:<gem vnum>_gems_acquired (3 gems). The zone 556 status scripts read these keys.
-- The runtime fires RECEIVE after the item is already in the mob's hands, so a refusal hands
-- it back with a give command (DG's `return 0`).

local class_ok = false
for _, c in ipairs({"paladin"}) do
    if string.lower(actor.class or "") == c then
        class_ok = true
        break
    end
end

local function obj_name(vnum)
    return objects.template(math.floor(vnum / 100), vnum % 100).name
end

-- Item names carry a leading article ("a rusted helm"); give matches on the bare words.
local function bare_name(name)
    return (string.gsub(string.gsub(name, "^%s*[Tt]he%s+", ""), "^%s*[Aa]n?%s+", ""))
end

local function give_back()
    self:command("give " .. bare_name(object.name) .. " to " .. actor.name)
    actor:send(tostring(self.name) .. " returns your item to you.")
end

if not (class_ok and actor.level >= 21 and actor:get_quest_stage("phase_armor") >= 2) then
    -- not the right class / phase for this questmaster
    wait(1)
    self:command("eye " .. tostring(actor.name))
    actor:send(tostring(self.name) .. " tells you, 'I am not interested in this from you.'")
    give_back()
    return true
end

-- Slots for this class: destroyed armor, gem, reward (legacy 5-digit vnums) and exp multiplier.
local slots = {
    {slot = "helm", armor = 55340, gem = 55632, reward = 55419, mult = 7},
    {slot = "arm", armor = 55344, gem = 55643, reward = 55420, mult = 8},
    {slot = "chest", armor = 55352, gem = 55665, reward = 55421, mult = 10},
    {slot = "legs", armor = 55348, gem = 55654, reward = 55422, mult = 9},
    {slot = "boots", armor = 55332, gem = 55610, reward = 55423, mult = 5},
    {slot = "bracer", armor = 55336, gem = 55621, reward = 55424, mult = 6},
    {slot = "gloves", armor = 55328, gem = 55599, reward = 55425, mult = 4},
}

-- DG switch: an armor case falls through into its gem case, so both vnums map to the same slot.
local object_vnum = object.zone_id * 100 + object.id
local entry, is_armor
for _, s in ipairs(slots) do
    if object_vnum == s.armor then
        entry = s
        is_armor = true
        break
    elseif object_vnum == s.gem then
        entry = s
        is_armor = false
        break
    end
end
if not entry then
    wait(1)
    self:command("eye " .. tostring(actor.name))
    actor:send(tostring(self.name) .. " tells you, 'I am not interested in this from you.'")
    give_back()
    return true
end

local armor_key = tostring(entry.armor) .. "_armor_acquired"
local gem_key = tostring(entry.gem) .. "_gems_acquired"
local armor = tonumber(actor:get_quest_var("phase_armor:" .. armor_key)) or 0
local gems = tonumber(actor:get_quest_var("phase_armor:" .. gem_key)) or 0

if is_armor then
    if armor < 1 then
        armor = armor + 1
        actor:set_quest_var("phase_armor", armor_key, armor)
        wait(2)
        actor:send(tostring(self.name) .. " tells you, \"Hey now. what have we here?!  I've been looking for some of this\"")
        actor:send(tostring(self.name) .. " tells you, \"for quite some time.  You have now given me " .. obj_name(entry.armor) .. ".\"")
        world.destroy(object)
        actor:save()
    else
        wait(2)
        self:command("eye " .. tostring(actor.name))
        wait(1)
        actor:send(tostring(self.name) .. " tells you, \"Hey now, you have given me " .. obj_name(entry.armor) .. " already!\"")
        give_back()
        -- Halt here so the reward can't be given twice.
        return true
    end
else
    if gems < 3 then
        gems = gems + 1
        actor:set_quest_var("phase_armor", gem_key, gems)
        wait(2)
        actor:send(tostring(self.name) .. " tells you, \"Hey, very nice. It is good to see adventurers out conquering the\"")
        actor:send(tostring(self.name) .. " tells you, \"realm.  You have now given me " .. tostring(gems) .. " " .. obj_name(entry.gem) .. ".\"")
        world.destroy(object)
        actor:save()
    else
        wait(2)
        self:command("eye " .. tostring(actor.name))
        wait(1)
        actor:send(tostring(self.name) .. " tells you, \"Hey now, you have given me 3 already!\"")
        give_back()
        -- Halt here so the reward can't be given twice.
        return true
    end
end

-- Quest complete for this slot: armor piece plus all 3 gems.
if armor == 1 and gems == 3 then
    wait(2)
    actor:send(tostring(self.name) .. " tells you, \"Excellent intrepid adventurer, you have provided me with all\"")
    actor:send(tostring(self.name) .. " tells you, \"I need in order to reward you with " .. obj_name(entry.reward) .. "!\"")
    wait(1)
    local reward = self:spawn_object(math.floor(entry.reward / 100), entry.reward % 100)
    wait(1)
    actor:send("<b:yellow>You gain experience!</>")
    for _ = 1, entry.mult do
        actor:award_exp(29880)
    end
    if reward then
        self:command("give " .. bare_name(reward.name) .. " to " .. actor.name)
    end
end
return true$trig$, '57342457a7e5dbccaa88b7b70e58e501'),
  -- data/triggers/554/554_20_ranger_phase_2.lua
  (554, 20, $trig$-- Converted from DG Script #55420: ranger_phase_2
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
--
-- Phase armor turn-in (class and phase specific). Quest vars are keyed by the legacy object
-- vnum, as DG did: phase_armor:<armor vnum>_armor_acquired (1 piece) and
-- phase_armor:<gem vnum>_gems_acquired (3 gems). The zone 556 status scripts read these keys.
-- The runtime fires RECEIVE after the item is already in the mob's hands, so a refusal hands
-- it back with a give command (DG's `return 0`).

local class_ok = false
for _, c in ipairs({"ranger"}) do
    if string.lower(actor.class or "") == c then
        class_ok = true
        break
    end
end

local function obj_name(vnum)
    return objects.template(math.floor(vnum / 100), vnum % 100).name
end

-- Item names carry a leading article ("a rusted helm"); give matches on the bare words.
local function bare_name(name)
    return (string.gsub(string.gsub(name, "^%s*[Tt]he%s+", ""), "^%s*[Aa]n?%s+", ""))
end

local function give_back()
    self:command("give " .. bare_name(object.name) .. " to " .. actor.name)
    actor:send(tostring(self.name) .. " returns your item to you.")
end

if not (class_ok and actor.level >= 21 and actor:get_quest_stage("phase_armor") >= 2) then
    -- not the right class / phase for this questmaster
    wait(1)
    self:command("eye " .. tostring(actor.name))
    actor:send(tostring(self.name) .. " tells you, 'I am not interested in this from you.'")
    give_back()
    return true
end

-- Slots for this class: destroyed armor, gem, reward (legacy 5-digit vnums) and exp multiplier.
local slots = {
    {slot = "helm", armor = 55341, gem = 55633, reward = 55440, mult = 7},
    {slot = "arm", armor = 55345, gem = 55644, reward = 55441, mult = 8},
    {slot = "chest", armor = 55353, gem = 55666, reward = 55442, mult = 10},
    {slot = "legs", armor = 55349, gem = 55655, reward = 55443, mult = 9},
    {slot = "boots", armor = 55333, gem = 55611, reward = 55444, mult = 5},
    {slot = "bracer", armor = 55337, gem = 55622, reward = 55445, mult = 6},
    {slot = "gloves", armor = 55329, gem = 55600, reward = 55446, mult = 4},
}

-- DG switch: an armor case falls through into its gem case, so both vnums map to the same slot.
local object_vnum = object.zone_id * 100 + object.id
local entry, is_armor
for _, s in ipairs(slots) do
    if object_vnum == s.armor then
        entry = s
        is_armor = true
        break
    elseif object_vnum == s.gem then
        entry = s
        is_armor = false
        break
    end
end
if not entry then
    wait(1)
    self:command("eye " .. tostring(actor.name))
    actor:send(tostring(self.name) .. " tells you, 'I am not interested in this from you.'")
    give_back()
    return true
end

local armor_key = tostring(entry.armor) .. "_armor_acquired"
local gem_key = tostring(entry.gem) .. "_gems_acquired"
local armor = tonumber(actor:get_quest_var("phase_armor:" .. armor_key)) or 0
local gems = tonumber(actor:get_quest_var("phase_armor:" .. gem_key)) or 0

if is_armor then
    if armor < 1 then
        armor = armor + 1
        actor:set_quest_var("phase_armor", armor_key, armor)
        wait(2)
        actor:send(tostring(self.name) .. " tells you, \"Hey now. what have we here?!  I've been looking for some of this\"")
        actor:send(tostring(self.name) .. " tells you, \"for quite some time.  You have now given me " .. obj_name(entry.armor) .. ".\"")
        world.destroy(object)
        actor:save()
    else
        wait(2)
        self:command("eye " .. tostring(actor.name))
        wait(1)
        actor:send(tostring(self.name) .. " tells you, \"Hey now, you have given me " .. obj_name(entry.armor) .. " already!\"")
        give_back()
        -- Halt here so the reward can't be given twice.
        return true
    end
else
    if gems < 3 then
        gems = gems + 1
        actor:set_quest_var("phase_armor", gem_key, gems)
        wait(2)
        actor:send(tostring(self.name) .. " tells you, \"Hey, very nice. It is good to see adventurers out conquering the\"")
        actor:send(tostring(self.name) .. " tells you, \"realm.  You have now given me " .. tostring(gems) .. " " .. obj_name(entry.gem) .. ".\"")
        world.destroy(object)
        actor:save()
    else
        wait(2)
        self:command("eye " .. tostring(actor.name))
        wait(1)
        actor:send(tostring(self.name) .. " tells you, \"Hey now, you have given me 3 already!\"")
        give_back()
        -- Halt here so the reward can't be given twice.
        return true
    end
end

-- Quest complete for this slot: armor piece plus all 3 gems.
if armor == 1 and gems == 3 then
    wait(2)
    actor:send(tostring(self.name) .. " tells you, \"Excellent intrepid adventurer, you have provided me with all\"")
    actor:send(tostring(self.name) .. " tells you, \"I need in order to reward you with " .. obj_name(entry.reward) .. "!\"")
    wait(1)
    local reward = self:spawn_object(math.floor(entry.reward / 100), entry.reward % 100)
    wait(1)
    actor:send("<b:yellow>You gain experience!</>")
    for _ = 1, entry.mult do
        actor:award_exp(29880)
    end
    if reward then
        self:command("give " .. bare_name(reward.name) .. " to " .. actor.name)
    end
end
return true$trig$, '4f9cacd304ea0e867f57d60af613acf3'),
  -- data/triggers/554/554_30_rogue_phase_2.lua
  (554, 30, $trig$-- Converted from DG Script #55430: rogue_phase_2
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
--
-- Phase armor turn-in (class and phase specific). Quest vars are keyed by the legacy object
-- vnum, as DG did: phase_armor:<armor vnum>_armor_acquired (1 piece) and
-- phase_armor:<gem vnum>_gems_acquired (3 gems). The zone 556 status scripts read these keys.
-- The runtime fires RECEIVE after the item is already in the mob's hands, so a refusal hands
-- it back with a give command (DG's `return 0`).

local class_ok = false
for _, c in ipairs({"rogue", "thief", "assassin", "mercenary"}) do
    if string.lower(actor.class or "") == c then
        class_ok = true
        break
    end
end

local function obj_name(vnum)
    return objects.template(math.floor(vnum / 100), vnum % 100).name
end

-- Item names carry a leading article ("a rusted helm"); give matches on the bare words.
local function bare_name(name)
    return (string.gsub(string.gsub(name, "^%s*[Tt]he%s+", ""), "^%s*[Aa]n?%s+", ""))
end

local function give_back()
    self:command("give " .. bare_name(object.name) .. " to " .. actor.name)
    actor:send(tostring(self.name) .. " returns your item to you.")
end

if not (class_ok and actor.level >= 21 and actor:get_quest_stage("phase_armor") >= 2) then
    -- not the right class / phase for this questmaster
    wait(1)
    self:command("eye " .. tostring(actor.name))
    actor:send(tostring(self.name) .. " tells you, 'I am not interested in this from you.'")
    give_back()
    return true
end

-- Slots for this class: destroyed armor, gem, reward (legacy 5-digit vnums) and exp multiplier.
local slots = {
    {slot = "helm", armor = 55341, gem = 55636, reward = 55482, mult = 7},
    {slot = "arm", armor = 55345, gem = 55647, reward = 55483, mult = 8},
    {slot = "chest", armor = 55353, gem = 55669, reward = 55484, mult = 10},
    {slot = "legs", armor = 55349, gem = 55658, reward = 55485, mult = 9},
    {slot = "boots", armor = 55333, gem = 55614, reward = 55486, mult = 5},
    {slot = "bracer", armor = 55337, gem = 55625, reward = 55487, mult = 6},
    {slot = "gloves", armor = 55329, gem = 55603, reward = 55488, mult = 4},
}

-- DG switch: an armor case falls through into its gem case, so both vnums map to the same slot.
local object_vnum = object.zone_id * 100 + object.id
local entry, is_armor
for _, s in ipairs(slots) do
    if object_vnum == s.armor then
        entry = s
        is_armor = true
        break
    elseif object_vnum == s.gem then
        entry = s
        is_armor = false
        break
    end
end
if not entry then
    wait(1)
    self:command("eye " .. tostring(actor.name))
    actor:send(tostring(self.name) .. " tells you, 'I am not interested in this from you.'")
    give_back()
    return true
end

local armor_key = tostring(entry.armor) .. "_armor_acquired"
local gem_key = tostring(entry.gem) .. "_gems_acquired"
local armor = tonumber(actor:get_quest_var("phase_armor:" .. armor_key)) or 0
local gems = tonumber(actor:get_quest_var("phase_armor:" .. gem_key)) or 0

if is_armor then
    if armor < 1 then
        armor = armor + 1
        actor:set_quest_var("phase_armor", armor_key, armor)
        wait(2)
        actor:send(tostring(self.name) .. " tells you, \"Hey now. what have we here?!  I've been looking for some of this\"")
        actor:send(tostring(self.name) .. " tells you, \"for quite some time.  You have now given me " .. obj_name(entry.armor) .. ".\"")
        world.destroy(object)
        actor:save()
    else
        wait(2)
        self:command("eye " .. tostring(actor.name))
        wait(1)
        actor:send(tostring(self.name) .. " tells you, \"Hey now, you have given me " .. obj_name(entry.armor) .. " already!\"")
        give_back()
        -- Halt here so the reward can't be given twice.
        return true
    end
else
    if gems < 3 then
        gems = gems + 1
        actor:set_quest_var("phase_armor", gem_key, gems)
        wait(2)
        actor:send(tostring(self.name) .. " tells you, \"Hey, very nice. It is good to see adventurers out conquering the\"")
        actor:send(tostring(self.name) .. " tells you, \"realm.  You have now given me " .. tostring(gems) .. " " .. obj_name(entry.gem) .. ".\"")
        world.destroy(object)
        actor:save()
    else
        wait(2)
        self:command("eye " .. tostring(actor.name))
        wait(1)
        actor:send(tostring(self.name) .. " tells you, \"Hey now, you have given me 3 already!\"")
        give_back()
        -- Halt here so the reward can't be given twice.
        return true
    end
end

-- Quest complete for this slot: armor piece plus all 3 gems.
if armor == 1 and gems == 3 then
    wait(2)
    actor:send(tostring(self.name) .. " tells you, \"Excellent intrepid adventurer, you have provided me with all\"")
    actor:send(tostring(self.name) .. " tells you, \"I need in order to reward you with " .. obj_name(entry.reward) .. "!\"")
    wait(1)
    local reward = self:spawn_object(math.floor(entry.reward / 100), entry.reward % 100)
    wait(1)
    actor:send("<b:yellow>You gain experience!</>")
    for _ = 1, entry.mult do
        actor:award_exp(29880)
    end
    if reward then
        self:command("give " .. bare_name(reward.name) .. " to " .. actor.name)
    end
end
return true$trig$, '0d8b2ebd8fd1c32e0d3217db9e52aa24'),
  -- data/triggers/554/554_40_warrior_phase_2.lua
  (554, 40, $trig$-- Converted from DG Script #55440: warrior_phase_2
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
--
-- Phase armor turn-in (class and phase specific). Quest vars are keyed by the legacy object
-- vnum, as DG did: phase_armor:<armor vnum>_armor_acquired (1 piece) and
-- phase_armor:<gem vnum>_gems_acquired (3 gems). The zone 556 status scripts read these keys.
-- The runtime fires RECEIVE after the item is already in the mob's hands, so a refusal hands
-- it back with a give command (DG's `return 0`).

local class_ok = false
for _, c in ipairs({"warrior"}) do
    if string.lower(actor.class or "") == c then
        class_ok = true
        break
    end
end

local function obj_name(vnum)
    return objects.template(math.floor(vnum / 100), vnum % 100).name
end

-- Item names carry a leading article ("a rusted helm"); give matches on the bare words.
local function bare_name(name)
    return (string.gsub(string.gsub(name, "^%s*[Tt]he%s+", ""), "^%s*[Aa]n?%s+", ""))
end

local function give_back()
    self:command("give " .. bare_name(object.name) .. " to " .. actor.name)
    actor:send(tostring(self.name) .. " returns your item to you.")
end

if not (class_ok and actor.level >= 21 and actor:get_quest_stage("phase_armor") >= 2) then
    -- not the right class / phase for this questmaster
    wait(1)
    self:command("eye " .. tostring(actor.name))
    actor:send(tostring(self.name) .. " tells you, 'I am not interested in this from you.'")
    give_back()
    return true
end

-- Slots for this class: destroyed armor, gem, reward (legacy 5-digit vnums) and exp multiplier.
local slots = {
    {slot = "helm", armor = 55340, gem = 55637, reward = 55412, mult = 7},
    {slot = "arm", armor = 55344, gem = 55648, reward = 55413, mult = 8},
    {slot = "chest", armor = 55352, gem = 55670, reward = 55414, mult = 10},
    {slot = "legs", armor = 55348, gem = 55659, reward = 55415, mult = 9},
    {slot = "boots", armor = 55332, gem = 55615, reward = 55416, mult = 5},
    {slot = "bracer", armor = 55336, gem = 55626, reward = 55417, mult = 6},
    {slot = "gloves", armor = 55328, gem = 55604, reward = 55418, mult = 4},
}

-- DG switch: an armor case falls through into its gem case, so both vnums map to the same slot.
local object_vnum = object.zone_id * 100 + object.id
local entry, is_armor
for _, s in ipairs(slots) do
    if object_vnum == s.armor then
        entry = s
        is_armor = true
        break
    elseif object_vnum == s.gem then
        entry = s
        is_armor = false
        break
    end
end
if not entry then
    wait(1)
    self:command("eye " .. tostring(actor.name))
    actor:send(tostring(self.name) .. " tells you, 'I am not interested in this from you.'")
    give_back()
    return true
end

local armor_key = tostring(entry.armor) .. "_armor_acquired"
local gem_key = tostring(entry.gem) .. "_gems_acquired"
local armor = tonumber(actor:get_quest_var("phase_armor:" .. armor_key)) or 0
local gems = tonumber(actor:get_quest_var("phase_armor:" .. gem_key)) or 0

if is_armor then
    if armor < 1 then
        armor = armor + 1
        actor:set_quest_var("phase_armor", armor_key, armor)
        wait(2)
        actor:send(tostring(self.name) .. " tells you, \"Hey now. what have we here?!  I've been looking for some of this\"")
        actor:send(tostring(self.name) .. " tells you, \"for quite some time.  You have now given me " .. obj_name(entry.armor) .. ".\"")
        world.destroy(object)
        actor:save()
    else
        wait(2)
        self:command("eye " .. tostring(actor.name))
        wait(1)
        actor:send(tostring(self.name) .. " tells you, \"Hey now, you have given me " .. obj_name(entry.armor) .. " already!\"")
        give_back()
        -- Halt here so the reward can't be given twice.
        return true
    end
else
    if gems < 3 then
        gems = gems + 1
        actor:set_quest_var("phase_armor", gem_key, gems)
        wait(2)
        actor:send(tostring(self.name) .. " tells you, \"Hey, very nice. It is good to see adventurers out conquering the\"")
        actor:send(tostring(self.name) .. " tells you, \"realm.  You have now given me " .. tostring(gems) .. " " .. obj_name(entry.gem) .. ".\"")
        world.destroy(object)
        actor:save()
    else
        wait(2)
        self:command("eye " .. tostring(actor.name))
        wait(1)
        actor:send(tostring(self.name) .. " tells you, \"Hey now, you have given me 3 already!\"")
        give_back()
        -- Halt here so the reward can't be given twice.
        return true
    end
end

-- Quest complete for this slot: armor piece plus all 3 gems.
if armor == 1 and gems == 3 then
    wait(2)
    actor:send(tostring(self.name) .. " tells you, \"Excellent intrepid adventurer, you have provided me with all\"")
    actor:send(tostring(self.name) .. " tells you, \"I need in order to reward you with " .. obj_name(entry.reward) .. "!\"")
    wait(1)
    local reward = self:spawn_object(math.floor(entry.reward / 100), entry.reward % 100)
    wait(1)
    actor:send("<b:yellow>You gain experience!</>")
    for _ = 1, entry.mult do
        actor:award_exp(29880)
    end
    if reward then
        self:command("give " .. bare_name(reward.name) .. " to " .. actor.name)
    end
end
return true$trig$, '2f9c7bd24c3f28120d169f61c892b560'),
  -- data/triggers/554/554_50_sorcerer_phase_2.lua
  (554, 50, $trig$-- Converted from DG Script #55450: sorcerer_phase_2
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
--
-- Phase armor turn-in (class and phase specific). Quest vars are keyed by the legacy object
-- vnum, as DG did: phase_armor:<armor vnum>_armor_acquired (1 piece) and
-- phase_armor:<gem vnum>_gems_acquired (3 gems). The zone 556 status scripts read these keys.
-- The runtime fires RECEIVE after the item is already in the mob's hands, so a refusal hands
-- it back with a give command (DG's `return 0`).

local class_ok = false
for _, c in ipairs({"sorcerer", "cryomancer", "pyromancer"}) do
    if string.lower(actor.class or "") == c then
        class_ok = true
        break
    end
end

local function obj_name(vnum)
    return objects.template(math.floor(vnum / 100), vnum % 100).name
end

-- Item names carry a leading article ("a rusted helm"); give matches on the bare words.
local function bare_name(name)
    return (string.gsub(string.gsub(name, "^%s*[Tt]he%s+", ""), "^%s*[Aa]n?%s+", ""))
end

local function give_back()
    self:command("give " .. bare_name(object.name) .. " to " .. actor.name)
    actor:send(tostring(self.name) .. " returns your item to you.")
end

if not (class_ok and actor.level >= 21 and actor:get_quest_stage("phase_armor") >= 2) then
    -- not the right class / phase for this questmaster
    wait(1)
    self:command("eye " .. tostring(actor.name))
    actor:send(tostring(self.name) .. " tells you, 'I am not interested in this from you.'")
    give_back()
    return true
end

-- Slots for this class: destroyed armor, gem, reward (legacy 5-digit vnums) and exp multiplier.
local slots = {
    {slot = "helm", armor = 55343, gem = 55631, reward = 55475, mult = 7},
    {slot = "arm", armor = 55347, gem = 55646, reward = 55476, mult = 8},
    {slot = "chest", armor = 55355, gem = 55668, reward = 55477, mult = 10},
    {slot = "legs", armor = 55351, gem = 55657, reward = 55478, mult = 9},
    {slot = "boots", armor = 55335, gem = 55613, reward = 55479, mult = 5},
    {slot = "bracer", armor = 55339, gem = 55624, reward = 55480, mult = 6},
    {slot = "gloves", armor = 55331, gem = 55602, reward = 55481, mult = 4},
}

-- DG switch: an armor case falls through into its gem case, so both vnums map to the same slot.
local object_vnum = object.zone_id * 100 + object.id
local entry, is_armor
for _, s in ipairs(slots) do
    if object_vnum == s.armor then
        entry = s
        is_armor = true
        break
    elseif object_vnum == s.gem then
        entry = s
        is_armor = false
        break
    end
end
if not entry then
    wait(1)
    self:command("eye " .. tostring(actor.name))
    actor:send(tostring(self.name) .. " tells you, 'I am not interested in this from you.'")
    give_back()
    return true
end

local armor_key = tostring(entry.armor) .. "_armor_acquired"
local gem_key = tostring(entry.gem) .. "_gems_acquired"
local armor = tonumber(actor:get_quest_var("phase_armor:" .. armor_key)) or 0
local gems = tonumber(actor:get_quest_var("phase_armor:" .. gem_key)) or 0

if is_armor then
    if armor < 1 then
        armor = armor + 1
        actor:set_quest_var("phase_armor", armor_key, armor)
        wait(2)
        actor:send(tostring(self.name) .. " tells you, \"Hey now. what have we here?!  I've been looking for some of this\"")
        actor:send(tostring(self.name) .. " tells you, \"for quite some time.  You have now given me " .. obj_name(entry.armor) .. ".\"")
        world.destroy(object)
        actor:save()
    else
        wait(2)
        self:command("eye " .. tostring(actor.name))
        wait(1)
        actor:send(tostring(self.name) .. " tells you, \"Hey now, you have given me " .. obj_name(entry.armor) .. " already!\"")
        give_back()
        -- Halt here so the reward can't be given twice.
        return true
    end
else
    if gems < 3 then
        gems = gems + 1
        actor:set_quest_var("phase_armor", gem_key, gems)
        wait(2)
        actor:send(tostring(self.name) .. " tells you, \"Hey, very nice. It is good to see adventurers out conquering the\"")
        actor:send(tostring(self.name) .. " tells you, \"realm.  You have now given me " .. tostring(gems) .. " " .. obj_name(entry.gem) .. ".\"")
        world.destroy(object)
        actor:save()
    else
        wait(2)
        self:command("eye " .. tostring(actor.name))
        wait(1)
        actor:send(tostring(self.name) .. " tells you, \"Hey now, you have given me 3 already!\"")
        give_back()
        -- Halt here so the reward can't be given twice.
        return true
    end
end

-- Quest complete for this slot: armor piece plus all 3 gems.
if armor == 1 and gems == 3 then
    wait(2)
    actor:send(tostring(self.name) .. " tells you, \"Excellent intrepid adventurer, you have provided me with all\"")
    actor:send(tostring(self.name) .. " tells you, \"I need in order to reward you with " .. obj_name(entry.reward) .. "!\"")
    wait(1)
    local reward = self:spawn_object(math.floor(entry.reward / 100), entry.reward % 100)
    wait(1)
    actor:send("<b:yellow>You gain experience!</>")
    for _ = 1, entry.mult do
        actor:award_exp(29880)
    end
    if reward then
        self:command("give " .. bare_name(reward.name) .. " to " .. actor.name)
    end
end
return true$trig$, '6de9a6af6f3f4c0140f39e30afe5facd'),
  -- data/triggers/554/554_60_anti-paladin_phase_3.lua
  (554, 60, $trig$-- Converted from DG Script #55460: anti-paladin_phase_3
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
--
-- Phase armor turn-in (class and phase specific). Quest vars are keyed by the legacy object
-- vnum, as DG did: phase_armor:<armor vnum>_armor_acquired (1 piece) and
-- phase_armor:<gem vnum>_gems_acquired (3 gems). The zone 556 status scripts read these keys.
-- The runtime fires RECEIVE after the item is already in the mob's hands, so a refusal hands
-- it back with a give command (DG's `return 0`).

local class_ok = false
for _, c in ipairs({"anti-paladin"}) do
    if string.lower(actor.class or "") == c then
        class_ok = true
        break
    end
end

local function obj_name(vnum)
    return objects.template(math.floor(vnum / 100), vnum % 100).name
end

-- Item names carry a leading article ("a rusted helm"); give matches on the bare words.
local function bare_name(name)
    return (string.gsub(string.gsub(name, "^%s*[Tt]he%s+", ""), "^%s*[Aa]n?%s+", ""))
end

local function give_back()
    self:command("give " .. bare_name(object.name) .. " to " .. actor.name)
    actor:send(tostring(self.name) .. " returns your item to you.")
end

if not (class_ok and actor.level >= 41 and actor:get_quest_stage("phase_armor") >= 2) then
    -- not the right class / phase for this questmaster
    wait(1)
    self:command("eye " .. tostring(actor.name))
    actor:send(tostring(self.name) .. " tells you, 'I am not interested in this from you.'")
    give_back()
    return true
end

-- Slots for this class: destroyed armor, gem, reward (legacy 5-digit vnums) and exp multiplier.
local slots = {
    {slot = "helm", armor = 55368, gem = 55704, reward = 55503, mult = 11},
    {slot = "arm", armor = 55372, gem = 55715, reward = 55504, mult = 12},
    {slot = "chest", armor = 55380, gem = 55737, reward = 55505, mult = 14},
    {slot = "legs", armor = 55376, gem = 55726, reward = 55506, mult = 13},
    {slot = "boots", armor = 55360, gem = 55682, reward = 55507, mult = 9},
    {slot = "bracer", armor = 55364, gem = 55693, reward = 55508, mult = 10},
    {slot = "gloves", armor = 55356, gem = 55671, reward = 55509, mult = 8},
}

-- DG switch: an armor case falls through into its gem case, so both vnums map to the same slot.
local object_vnum = object.zone_id * 100 + object.id
local entry, is_armor
for _, s in ipairs(slots) do
    if object_vnum == s.armor then
        entry = s
        is_armor = true
        break
    elseif object_vnum == s.gem then
        entry = s
        is_armor = false
        break
    end
end
if not entry then
    wait(1)
    self:command("eye " .. tostring(actor.name))
    actor:send(tostring(self.name) .. " tells you, 'I am not interested in this from you.'")
    give_back()
    return true
end

local armor_key = tostring(entry.armor) .. "_armor_acquired"
local gem_key = tostring(entry.gem) .. "_gems_acquired"
local armor = tonumber(actor:get_quest_var("phase_armor:" .. armor_key)) or 0
local gems = tonumber(actor:get_quest_var("phase_armor:" .. gem_key)) or 0

if is_armor then
    if armor < 1 then
        armor = armor + 1
        actor:set_quest_var("phase_armor", armor_key, armor)
        wait(2)
        actor:send(tostring(self.name) .. " tells you, \"Hey now. what have we here?!  I've been looking for some of this\"")
        actor:send(tostring(self.name) .. " tells you, \"for quite some time.  You have now given me " .. obj_name(entry.armor) .. ".\"")
        world.destroy(object)
        actor:save()
    else
        wait(2)
        self:command("eye " .. tostring(actor.name))
        wait(1)
        actor:send(tostring(self.name) .. " tells you, \"Hey now, you have given me " .. obj_name(entry.armor) .. " already!\"")
        give_back()
        -- Halt here so the reward can't be given twice.
        return true
    end
else
    if gems < 3 then
        gems = gems + 1
        actor:set_quest_var("phase_armor", gem_key, gems)
        wait(2)
        actor:send(tostring(self.name) .. " tells you, \"Hey, very nice. It is good to see adventurers out conquering the\"")
        actor:send(tostring(self.name) .. " tells you, \"realm.  You have now given me " .. tostring(gems) .. " " .. obj_name(entry.gem) .. ".\"")
        world.destroy(object)
        actor:save()
    else
        wait(2)
        self:command("eye " .. tostring(actor.name))
        wait(1)
        actor:send(tostring(self.name) .. " tells you, \"Hey now, you have given me 3 already!\"")
        give_back()
        -- Halt here so the reward can't be given twice.
        return true
    end
end

-- Quest complete for this slot: armor piece plus all 3 gems.
if armor == 1 and gems == 3 then
    wait(2)
    actor:send(tostring(self.name) .. " tells you, \"Excellent intrepid adventurer, you have provided me with all\"")
    actor:send(tostring(self.name) .. " tells you, \"I need in order to reward you with " .. obj_name(entry.reward) .. "!\"")
    wait(1)
    local reward = self:spawn_object(math.floor(entry.reward / 100), entry.reward % 100)
    wait(1)
    actor:send("<b:yellow>You gain experience!</>")
    for _ = 1, entry.mult do
        actor:award_exp(42840)
    end
    if reward then
        self:command("give " .. bare_name(reward.name) .. " to " .. actor.name)
    end
end
return true$trig$, 'aa2674dab91407caeb460896f1a415f2'),
  -- data/triggers/554/554_70_unused.lua
  (554, 70, $trig$-- Converted from DG Script #55470: **UNUSED**
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
--
-- Phase armor turn-in (class and phase specific). Quest vars are keyed by the legacy object
-- vnum, as DG did: phase_armor:<armor vnum>_armor_acquired (1 piece) and
-- phase_armor:<gem vnum>_gems_acquired (3 gems). The zone 556 status scripts read these keys.
-- The runtime fires RECEIVE after the item is already in the mob's hands, so a refusal hands
-- it back with a give command (DG's `return 0`).

local class_ok = false
for _, c in ipairs({"cleric", "priest"}) do
    if string.lower(actor.class or "") == c then
        class_ok = true
        break
    end
end

local function obj_name(vnum)
    return objects.template(math.floor(vnum / 100), vnum % 100).name
end

-- Item names carry a leading article ("a rusted helm"); give matches on the bare words.
local function bare_name(name)
    return (string.gsub(string.gsub(name, "^%s*[Tt]he%s+", ""), "^%s*[Aa]n?%s+", ""))
end

local function give_back()
    self:command("give " .. bare_name(object.name) .. " to " .. actor.name)
    actor:send(tostring(self.name) .. " returns your item to you.")
end

if not (class_ok and actor.level >= 41 and actor:get_quest_stage("phase_armor") >= 2) then
    -- not the right class / phase for this questmaster
    wait(1)
    self:command("eye " .. tostring(actor.name))
    actor:send(tostring(self.name) .. " tells you, 'I am not interested in this from you.'")
    give_back()
    return true
end

-- Slots for this class: destroyed armor, gem, reward (legacy 5-digit vnums) and exp multiplier.
local slots = {
    {slot = "helm", armor = 55368, gem = 55711, reward = 55510, mult = 11},
    {slot = "arm", armor = 55372, gem = 55722, reward = 55511, mult = 12},
    {slot = "chest", armor = 55380, gem = 55744, reward = 55512, mult = 14},
    {slot = "legs", armor = 55376, gem = 55733, reward = 55513, mult = 13},
    {slot = "boots", armor = 55360, gem = 55689, reward = 55514, mult = 9},
    {slot = "bracer", armor = 55364, gem = 55700, reward = 55515, mult = 10},
    {slot = "gloves", armor = 55356, gem = 55678, reward = 55516, mult = 8},
}

-- DG switch: an armor case falls through into its gem case, so both vnums map to the same slot.
local object_vnum = object.zone_id * 100 + object.id
local entry, is_armor
for _, s in ipairs(slots) do
    if object_vnum == s.armor then
        entry = s
        is_armor = true
        break
    elseif object_vnum == s.gem then
        entry = s
        is_armor = false
        break
    end
end
if not entry then
    wait(1)
    self:command("eye " .. tostring(actor.name))
    actor:send(tostring(self.name) .. " tells you, 'I am not interested in this from you.'")
    give_back()
    return true
end

local armor_key = tostring(entry.armor) .. "_armor_acquired"
local gem_key = tostring(entry.gem) .. "_gems_acquired"
local armor = tonumber(actor:get_quest_var("phase_armor:" .. armor_key)) or 0
local gems = tonumber(actor:get_quest_var("phase_armor:" .. gem_key)) or 0

if is_armor then
    if armor < 1 then
        armor = armor + 1
        actor:set_quest_var("phase_armor", armor_key, armor)
        wait(2)
        actor:send(tostring(self.name) .. " tells you, \"Hey now. what have we here?!  I've been looking for some of this\"")
        actor:send(tostring(self.name) .. " tells you, \"for quite some time.  You have now given me " .. obj_name(entry.armor) .. ".\"")
        world.destroy(object)
        actor:save()
    else
        wait(2)
        self:command("eye " .. tostring(actor.name))
        wait(1)
        actor:send(tostring(self.name) .. " tells you, \"Hey now, you have given me " .. obj_name(entry.armor) .. " already!\"")
        give_back()
        -- Halt here so the reward can't be given twice.
        return true
    end
else
    if gems < 3 then
        gems = gems + 1
        actor:set_quest_var("phase_armor", gem_key, gems)
        wait(2)
        actor:send(tostring(self.name) .. " tells you, \"Hey, very nice. It is good to see adventurers out conquering the\"")
        actor:send(tostring(self.name) .. " tells you, \"realm.  You have now given me " .. tostring(gems) .. " " .. obj_name(entry.gem) .. ".\"")
        world.destroy(object)
        actor:save()
    else
        wait(2)
        self:command("eye " .. tostring(actor.name))
        wait(1)
        actor:send(tostring(self.name) .. " tells you, \"Hey now, you have given me 3 already!\"")
        give_back()
        -- Halt here so the reward can't be given twice.
        return true
    end
end

-- Quest complete for this slot: armor piece plus all 3 gems.
if armor == 1 and gems == 3 then
    wait(2)
    actor:send(tostring(self.name) .. " tells you, \"Excellent intrepid adventurer, you have provided me with all\"")
    actor:send(tostring(self.name) .. " tells you, \"I need in order to reward you with " .. obj_name(entry.reward) .. "!\"")
    wait(1)
    local reward = self:spawn_object(math.floor(entry.reward / 100), entry.reward % 100)
    wait(1)
    actor:send("<b:yellow>You gain experience!</>")
    for _ = 1, entry.mult do
        actor:award_exp(42840)
    end
    if reward then
        self:command("give " .. bare_name(reward.name) .. " to " .. actor.name)
    end
end
return true$trig$, 'ac11df63c58dcb70265b9a2bb25e3af4'),
  -- data/triggers/554/554_80_diabolist_phase_3.lua
  (554, 80, $trig$-- Converted from DG Script #55480: diabolist_phase_3
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
--
-- Phase armor turn-in (class and phase specific). Quest vars are keyed by the legacy object
-- vnum, as DG did: phase_armor:<armor vnum>_armor_acquired (1 piece) and
-- phase_armor:<gem vnum>_gems_acquired (3 gems). The zone 556 status scripts read these keys.
-- The runtime fires RECEIVE after the item is already in the mob's hands, so a refusal hands
-- it back with a give command (DG's `return 0`).

local class_ok = false
for _, c in ipairs({"diabolist"}) do
    if string.lower(actor.class or "") == c then
        class_ok = true
        break
    end
end

local function obj_name(vnum)
    return objects.template(math.floor(vnum / 100), vnum % 100).name
end

-- Item names carry a leading article ("a rusted helm"); give matches on the bare words.
local function bare_name(name)
    return (string.gsub(string.gsub(name, "^%s*[Tt]he%s+", ""), "^%s*[Aa]n?%s+", ""))
end

local function give_back()
    self:command("give " .. bare_name(object.name) .. " to " .. actor.name)
    actor:send(tostring(self.name) .. " returns your item to you.")
end

if not (class_ok and actor.level >= 41 and actor:get_quest_stage("phase_armor") >= 2) then
    -- not the right class / phase for this questmaster
    wait(1)
    self:command("eye " .. tostring(actor.name))
    actor:send(tostring(self.name) .. " tells you, 'I am not interested in this from you.'")
    give_back()
    return true
end

-- Slots for this class: destroyed armor, gem, reward (legacy 5-digit vnums) and exp multiplier.
local slots = {
    {slot = "helm", armor = 55368, gem = 55705, reward = 55545, mult = 11},
    {slot = "arm", armor = 55372, gem = 55716, reward = 55546, mult = 12},
    {slot = "chest", armor = 55380, gem = 55738, reward = 55547, mult = 14},
    {slot = "legs", armor = 55376, gem = 55727, reward = 55548, mult = 13},
    {slot = "boots", armor = 55360, gem = 55683, reward = 55549, mult = 9},
    {slot = "bracer", armor = 55364, gem = 55694, reward = 55550, mult = 10},
    {slot = "gloves", armor = 55356, gem = 55672, reward = 55551, mult = 8},
}

-- DG switch: an armor case falls through into its gem case, so both vnums map to the same slot.
local object_vnum = object.zone_id * 100 + object.id
local entry, is_armor
for _, s in ipairs(slots) do
    if object_vnum == s.armor then
        entry = s
        is_armor = true
        break
    elseif object_vnum == s.gem then
        entry = s
        is_armor = false
        break
    end
end
if not entry then
    wait(1)
    self:command("eye " .. tostring(actor.name))
    actor:send(tostring(self.name) .. " tells you, 'I am not interested in this from you.'")
    give_back()
    return true
end

local armor_key = tostring(entry.armor) .. "_armor_acquired"
local gem_key = tostring(entry.gem) .. "_gems_acquired"
local armor = tonumber(actor:get_quest_var("phase_armor:" .. armor_key)) or 0
local gems = tonumber(actor:get_quest_var("phase_armor:" .. gem_key)) or 0

if is_armor then
    if armor < 1 then
        armor = armor + 1
        actor:set_quest_var("phase_armor", armor_key, armor)
        wait(2)
        actor:send(tostring(self.name) .. " tells you, \"Hey now. what have we here?!  I've been looking for some of this\"")
        actor:send(tostring(self.name) .. " tells you, \"for quite some time.  You have now given me " .. obj_name(entry.armor) .. ".\"")
        world.destroy(object)
        actor:save()
    else
        wait(2)
        self:command("eye " .. tostring(actor.name))
        wait(1)
        actor:send(tostring(self.name) .. " tells you, \"Hey now, you have given me " .. obj_name(entry.armor) .. " already!\"")
        give_back()
        -- Halt here so the reward can't be given twice.
        return true
    end
else
    if gems < 3 then
        gems = gems + 1
        actor:set_quest_var("phase_armor", gem_key, gems)
        wait(2)
        actor:send(tostring(self.name) .. " tells you, \"Hey, very nice. It is good to see adventurers out conquering the\"")
        actor:send(tostring(self.name) .. " tells you, \"realm.  You have now given me " .. tostring(gems) .. " " .. obj_name(entry.gem) .. ".\"")
        world.destroy(object)
        actor:save()
    else
        wait(2)
        self:command("eye " .. tostring(actor.name))
        wait(1)
        actor:send(tostring(self.name) .. " tells you, \"Hey now, you have given me 3 already!\"")
        give_back()
        -- Halt here so the reward can't be given twice.
        return true
    end
end

-- Quest complete for this slot: armor piece plus all 3 gems.
if armor == 1 and gems == 3 then
    wait(2)
    actor:send(tostring(self.name) .. " tells you, \"Excellent intrepid adventurer, you have provided me with all\"")
    actor:send(tostring(self.name) .. " tells you, \"I need in order to reward you with " .. obj_name(entry.reward) .. "!\"")
    wait(1)
    local reward = self:spawn_object(math.floor(entry.reward / 100), entry.reward % 100)
    wait(1)
    actor:send("<b:yellow>You gain experience!</>")
    for _ = 1, entry.mult do
        actor:award_exp(42840)
    end
    if reward then
        self:command("give " .. bare_name(reward.name) .. " to " .. actor.name)
    end
end
return true$trig$, '4459faef636541a101eb63ec0900645d'),
  -- data/triggers/554/554_90_druid_phase_3.lua
  (554, 90, $trig$-- Converted from DG Script #55490: druid_phase_3
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
--
-- Phase armor turn-in (class and phase specific). Quest vars are keyed by the legacy object
-- vnum, as DG did: phase_armor:<armor vnum>_armor_acquired (1 piece) and
-- phase_armor:<gem vnum>_gems_acquired (3 gems). The zone 556 status scripts read these keys.
-- The runtime fires RECEIVE after the item is already in the mob's hands, so a refusal hands
-- it back with a give command (DG's `return 0`).

local class_ok = false
for _, c in ipairs({"druid"}) do
    if string.lower(actor.class or "") == c then
        class_ok = true
        break
    end
end

local function obj_name(vnum)
    return objects.template(math.floor(vnum / 100), vnum % 100).name
end

-- Item names carry a leading article ("a rusted helm"); give matches on the bare words.
local function bare_name(name)
    return (string.gsub(string.gsub(name, "^%s*[Tt]he%s+", ""), "^%s*[Aa]n?%s+", ""))
end

local function give_back()
    self:command("give " .. bare_name(object.name) .. " to " .. actor.name)
    actor:send(tostring(self.name) .. " returns your item to you.")
end

if not (class_ok and actor.level >= 41 and actor:get_quest_stage("phase_armor") >= 2) then
    -- not the right class / phase for this questmaster
    wait(1)
    self:command("eye " .. tostring(actor.name))
    actor:send(tostring(self.name) .. " tells you, 'I am not interested in this from you.'")
    give_back()
    return true
end

-- Slots for this class: destroyed armor, gem, reward (legacy 5-digit vnums) and exp multiplier.
local slots = {
    {slot = "helm", armor = 55370, gem = 55706, reward = 55524, mult = 11},
    {slot = "arm", armor = 55374, gem = 55717, reward = 55525, mult = 12},
    {slot = "chest", armor = 55382, gem = 55739, reward = 55526, mult = 14},
    {slot = "legs", armor = 55378, gem = 55728, reward = 55527, mult = 13},
    {slot = "boots", armor = 55362, gem = 55684, reward = 55528, mult = 9},
    {slot = "bracer", armor = 55366, gem = 55695, reward = 55529, mult = 10},
    {slot = "gloves", armor = 55358, gem = 55673, reward = 55530, mult = 8},
}

-- DG switch: an armor case falls through into its gem case, so both vnums map to the same slot.
local object_vnum = object.zone_id * 100 + object.id
local entry, is_armor
for _, s in ipairs(slots) do
    if object_vnum == s.armor then
        entry = s
        is_armor = true
        break
    elseif object_vnum == s.gem then
        entry = s
        is_armor = false
        break
    end
end
if not entry then
    wait(1)
    self:command("eye " .. tostring(actor.name))
    actor:send(tostring(self.name) .. " tells you, 'I am not interested in this from you.'")
    give_back()
    return true
end

local armor_key = tostring(entry.armor) .. "_armor_acquired"
local gem_key = tostring(entry.gem) .. "_gems_acquired"
local armor = tonumber(actor:get_quest_var("phase_armor:" .. armor_key)) or 0
local gems = tonumber(actor:get_quest_var("phase_armor:" .. gem_key)) or 0

if is_armor then
    if armor < 1 then
        armor = armor + 1
        actor:set_quest_var("phase_armor", armor_key, armor)
        wait(2)
        actor:send(tostring(self.name) .. " tells you, \"Hey now. what have we here?!  I've been looking for some of this\"")
        actor:send(tostring(self.name) .. " tells you, \"for quite some time.  You have now given me " .. obj_name(entry.armor) .. ".\"")
        world.destroy(object)
        actor:save()
    else
        wait(2)
        self:command("eye " .. tostring(actor.name))
        wait(1)
        actor:send(tostring(self.name) .. " tells you, \"Hey now, you have given me " .. obj_name(entry.armor) .. " already!\"")
        give_back()
        -- Halt here so the reward can't be given twice.
        return true
    end
else
    if gems < 3 then
        gems = gems + 1
        actor:set_quest_var("phase_armor", gem_key, gems)
        wait(2)
        actor:send(tostring(self.name) .. " tells you, \"Hey, very nice. It is good to see adventurers out conquering the\"")
        actor:send(tostring(self.name) .. " tells you, \"realm.  You have now given me " .. tostring(gems) .. " " .. obj_name(entry.gem) .. ".\"")
        world.destroy(object)
        actor:save()
    else
        wait(2)
        self:command("eye " .. tostring(actor.name))
        wait(1)
        actor:send(tostring(self.name) .. " tells you, \"Hey now, you have given me 3 already!\"")
        give_back()
        -- Halt here so the reward can't be given twice.
        return true
    end
end

-- Quest complete for this slot: armor piece plus all 3 gems.
if armor == 1 and gems == 3 then
    wait(2)
    actor:send(tostring(self.name) .. " tells you, \"Excellent intrepid adventurer, you have provided me with all\"")
    actor:send(tostring(self.name) .. " tells you, \"I need in order to reward you with " .. obj_name(entry.reward) .. "!\"")
    wait(1)
    local reward = self:spawn_object(math.floor(entry.reward / 100), entry.reward % 100)
    wait(1)
    actor:send("<b:yellow>You gain experience!</>")
    for _ = 1, entry.mult do
        actor:award_exp(42840)
    end
    if reward then
        self:command("give " .. bare_name(reward.name) .. " to " .. actor.name)
    end
end
return true$trig$, '5f6356049888820462d382e963abcfb5'),
  -- data/triggers/555/555_00_sorcerer_phase_3.lua
  (555, 0, $trig$-- Converted from DG Script #55500: sorcerer_phase_3
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
--
-- Phase armor turn-in (class and phase specific). Quest vars are keyed by the legacy object
-- vnum, as DG did: phase_armor:<armor vnum>_armor_acquired (1 piece) and
-- phase_armor:<gem vnum>_gems_acquired (3 gems). The zone 556 status scripts read these keys.
-- The runtime fires RECEIVE after the item is already in the mob's hands, so a refusal hands
-- it back with a give command (DG's `return 0`).

local class_ok = false
for _, c in ipairs({"sorcerer", "cryomancer", "pyromancer"}) do
    if string.lower(actor.class or "") == c then
        class_ok = true
        break
    end
end

local function obj_name(vnum)
    return objects.template(math.floor(vnum / 100), vnum % 100).name
end

-- Item names carry a leading article ("a rusted helm"); give matches on the bare words.
local function bare_name(name)
    return (string.gsub(string.gsub(name, "^%s*[Tt]he%s+", ""), "^%s*[Aa]n?%s+", ""))
end

local function give_back()
    self:command("give " .. bare_name(object.name) .. " to " .. actor.name)
    actor:send(tostring(self.name) .. " returns your item to you.")
end

if not (class_ok and actor.level >= 41 and actor:get_quest_stage("phase_armor") >= 2) then
    -- not the right class / phase for this questmaster
    wait(1)
    self:command("eye " .. tostring(actor.name))
    actor:send(tostring(self.name) .. " tells you, 'I am not interested in this from you.'")
    give_back()
    return true
end

-- Slots for this class: destroyed armor, gem, reward (legacy 5-digit vnums) and exp multiplier.
local slots = {
    {slot = "helm", armor = 55371, gem = 55712, reward = 55552, mult = 11},
    {slot = "arm", armor = 55375, gem = 55723, reward = 55553, mult = 12},
    {slot = "chest", armor = 55383, gem = 55745, reward = 55554, mult = 14},
    {slot = "legs", armor = 55379, gem = 55734, reward = 55555, mult = 13},
    {slot = "boots", armor = 55363, gem = 55690, reward = 55556, mult = 9},
    {slot = "bracer", armor = 55367, gem = 55701, reward = 55557, mult = 10},
    {slot = "gloves", armor = 55359, gem = 55679, reward = 55558, mult = 8},
}

-- DG switch: an armor case falls through into its gem case, so both vnums map to the same slot.
local object_vnum = object.zone_id * 100 + object.id
local entry, is_armor
for _, s in ipairs(slots) do
    if object_vnum == s.armor then
        entry = s
        is_armor = true
        break
    elseif object_vnum == s.gem then
        entry = s
        is_armor = false
        break
    end
end
if not entry then
    wait(1)
    self:command("eye " .. tostring(actor.name))
    actor:send(tostring(self.name) .. " tells you, 'I am not interested in this from you.'")
    give_back()
    return true
end

local armor_key = tostring(entry.armor) .. "_armor_acquired"
local gem_key = tostring(entry.gem) .. "_gems_acquired"
local armor = tonumber(actor:get_quest_var("phase_armor:" .. armor_key)) or 0
local gems = tonumber(actor:get_quest_var("phase_armor:" .. gem_key)) or 0

if is_armor then
    if armor < 1 then
        armor = armor + 1
        actor:set_quest_var("phase_armor", armor_key, armor)
        wait(2)
        actor:send(tostring(self.name) .. " tells you, \"Hey now. what have we here?!  I've been looking for some of this\"")
        actor:send(tostring(self.name) .. " tells you, \"for quite some time.  You have now given me " .. obj_name(entry.armor) .. ".\"")
        world.destroy(object)
        actor:save()
    else
        wait(2)
        self:command("eye " .. tostring(actor.name))
        wait(1)
        actor:send(tostring(self.name) .. " tells you, \"Hey now, you have given me " .. obj_name(entry.armor) .. " already!\"")
        give_back()
        -- Halt here so the reward can't be given twice.
        return true
    end
else
    if gems < 3 then
        gems = gems + 1
        actor:set_quest_var("phase_armor", gem_key, gems)
        wait(2)
        actor:send(tostring(self.name) .. " tells you, \"Hey, very nice. It is good to see adventurers out conquering the\"")
        actor:send(tostring(self.name) .. " tells you, \"realm.  You have now given me " .. tostring(gems) .. " " .. obj_name(entry.gem) .. ".\"")
        world.destroy(object)
        actor:save()
    else
        wait(2)
        self:command("eye " .. tostring(actor.name))
        wait(1)
        actor:send(tostring(self.name) .. " tells you, \"Hey now, you have given me 3 already!\"")
        give_back()
        -- Halt here so the reward can't be given twice.
        return true
    end
end

-- Quest complete for this slot: armor piece plus all 3 gems.
if armor == 1 and gems == 3 then
    wait(2)
    actor:send(tostring(self.name) .. " tells you, \"Excellent intrepid adventurer, you have provided me with all\"")
    actor:send(tostring(self.name) .. " tells you, \"I need in order to reward you with " .. obj_name(entry.reward) .. "!\"")
    wait(1)
    local reward = self:spawn_object(math.floor(entry.reward / 100), entry.reward % 100)
    wait(1)
    actor:send("<b:yellow>You gain experience!</>")
    for _ = 1, entry.mult do
        actor:award_exp(42840)
    end
    if reward then
        self:command("give " .. bare_name(reward.name) .. " to " .. actor.name)
    end
end
return true$trig$, 'fa217eaec6a60979e907d9d0698a3f92'),
  -- data/triggers/555/555_10_monk_phase_3.lua
  (555, 10, $trig$-- Converted from DG Script #55510: monk_phase_3
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
--
-- Phase armor turn-in (class and phase specific). Quest vars are keyed by the legacy object
-- vnum, as DG did: phase_armor:<armor vnum>_armor_acquired (1 piece) and
-- phase_armor:<gem vnum>_gems_acquired (3 gems). The zone 556 status scripts read these keys.
-- The runtime fires RECEIVE after the item is already in the mob's hands, so a refusal hands
-- it back with a give command (DG's `return 0`).

local class_ok = false
for _, c in ipairs({"monk"}) do
    if string.lower(actor.class or "") == c then
        class_ok = true
        break
    end
end

local function obj_name(vnum)
    return objects.template(math.floor(vnum / 100), vnum % 100).name
end

-- Item names carry a leading article ("a rusted helm"); give matches on the bare words.
local function bare_name(name)
    return (string.gsub(string.gsub(name, "^%s*[Tt]he%s+", ""), "^%s*[Aa]n?%s+", ""))
end

local function give_back()
    self:command("give " .. bare_name(object.name) .. " to " .. actor.name)
    actor:send(tostring(self.name) .. " returns your item to you.")
end

if not (class_ok and actor.level >= 41 and actor:get_quest_stage("phase_armor") >= 2) then
    -- not the right class / phase for this questmaster
    wait(1)
    self:command("eye " .. tostring(actor.name))
    actor:send(tostring(self.name) .. " tells you, 'I am not interested in this from you.'")
    give_back()
    return true
end

-- Slots for this class: destroyed armor, gem, reward (legacy 5-digit vnums) and exp multiplier.
local slots = {
    {slot = "helm", armor = 55370, gem = 55707, reward = 55538, mult = 11},
    {slot = "arm", armor = 55374, gem = 55718, reward = 55539, mult = 12},
    {slot = "chest", armor = 55382, gem = 55740, reward = 55540, mult = 14},
    {slot = "legs", armor = 55378, gem = 55729, reward = 55541, mult = 13},
    {slot = "boots", armor = 55362, gem = 55685, reward = 55542, mult = 9},
    {slot = "bracer", armor = 55366, gem = 55696, reward = 55543, mult = 10},
    {slot = "gloves", armor = 55358, gem = 55674, reward = 55544, mult = 8},
}

-- DG switch: an armor case falls through into its gem case, so both vnums map to the same slot.
local object_vnum = object.zone_id * 100 + object.id
local entry, is_armor
for _, s in ipairs(slots) do
    if object_vnum == s.armor then
        entry = s
        is_armor = true
        break
    elseif object_vnum == s.gem then
        entry = s
        is_armor = false
        break
    end
end
if not entry then
    wait(1)
    self:command("eye " .. tostring(actor.name))
    actor:send(tostring(self.name) .. " tells you, 'I am not interested in this from you.'")
    give_back()
    return true
end

local armor_key = tostring(entry.armor) .. "_armor_acquired"
local gem_key = tostring(entry.gem) .. "_gems_acquired"
local armor = tonumber(actor:get_quest_var("phase_armor:" .. armor_key)) or 0
local gems = tonumber(actor:get_quest_var("phase_armor:" .. gem_key)) or 0

if is_armor then
    if armor < 1 then
        armor = armor + 1
        actor:set_quest_var("phase_armor", armor_key, armor)
        wait(2)
        actor:send(tostring(self.name) .. " tells you, \"Hey now. what have we here?!  I've been looking for some of this\"")
        actor:send(tostring(self.name) .. " tells you, \"for quite some time.  You have now given me " .. obj_name(entry.armor) .. ".\"")
        world.destroy(object)
        actor:save()
    else
        wait(2)
        self:command("eye " .. tostring(actor.name))
        wait(1)
        actor:send(tostring(self.name) .. " tells you, \"Hey now, you have given me " .. obj_name(entry.armor) .. " already!\"")
        give_back()
        -- Halt here so the reward can't be given twice.
        return true
    end
else
    if gems < 3 then
        gems = gems + 1
        actor:set_quest_var("phase_armor", gem_key, gems)
        wait(2)
        actor:send(tostring(self.name) .. " tells you, \"Hey, very nice. It is good to see adventurers out conquering the\"")
        actor:send(tostring(self.name) .. " tells you, \"realm.  You have now given me " .. tostring(gems) .. " " .. obj_name(entry.gem) .. ".\"")
        world.destroy(object)
        actor:save()
    else
        wait(2)
        self:command("eye " .. tostring(actor.name))
        wait(1)
        actor:send(tostring(self.name) .. " tells you, \"Hey now, you have given me 3 already!\"")
        give_back()
        -- Halt here so the reward can't be given twice.
        return true
    end
end

-- Quest complete for this slot: armor piece plus all 3 gems.
if armor == 1 and gems == 3 then
    wait(2)
    actor:send(tostring(self.name) .. " tells you, \"Excellent intrepid adventurer, you have provided me with all\"")
    actor:send(tostring(self.name) .. " tells you, \"I need in order to reward you with " .. obj_name(entry.reward) .. "!\"")
    wait(1)
    local reward = self:spawn_object(math.floor(entry.reward / 100), entry.reward % 100)
    wait(1)
    actor:send("<b:yellow>You gain experience!</>")
    for _ = 1, entry.mult do
        actor:award_exp(42840)
    end
    if reward then
        self:command("give " .. bare_name(reward.name) .. " to " .. actor.name)
    end
end
return true$trig$, '7ff0ba6bac37cfa9d2036abe4f7beb74'),
  -- data/triggers/555/555_20_necromancer_phase_3.lua
  (555, 20, $trig$-- Converted from DG Script #55520: necromancer_phase_3
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
--
-- Phase armor turn-in (class and phase specific). Quest vars are keyed by the legacy object
-- vnum, as DG did: phase_armor:<armor vnum>_armor_acquired (1 piece) and
-- phase_armor:<gem vnum>_gems_acquired (3 gems). The zone 556 status scripts read these keys.
-- The runtime fires RECEIVE after the item is already in the mob's hands, so a refusal hands
-- it back with a give command (DG's `return 0`).

local class_ok = false
for _, c in ipairs({"necromancer"}) do
    if string.lower(actor.class or "") == c then
        class_ok = true
        break
    end
end

local function obj_name(vnum)
    return objects.template(math.floor(vnum / 100), vnum % 100).name
end

-- Item names carry a leading article ("a rusted helm"); give matches on the bare words.
local function bare_name(name)
    return (string.gsub(string.gsub(name, "^%s*[Tt]he%s+", ""), "^%s*[Aa]n?%s+", ""))
end

local function give_back()
    self:command("give " .. bare_name(object.name) .. " to " .. actor.name)
    actor:send(tostring(self.name) .. " returns your item to you.")
end

if not (class_ok and actor.level >= 41 and actor:get_quest_stage("phase_armor") >= 2) then
    -- not the right class / phase for this questmaster
    wait(1)
    self:command("eye " .. tostring(actor.name))
    actor:send(tostring(self.name) .. " tells you, 'I am not interested in this from you.'")
    give_back()
    return true
end

-- Slots for this class: destroyed armor, gem, reward (legacy 5-digit vnums) and exp multiplier.
local slots = {
    {slot = "helm", armor = 55371, gem = 55708, reward = 55531, mult = 11},
    {slot = "arm", armor = 55375, gem = 55719, reward = 55532, mult = 12},
    {slot = "chest", armor = 55383, gem = 55741, reward = 55533, mult = 14},
    {slot = "legs", armor = 55379, gem = 55730, reward = 55534, mult = 13},
    {slot = "boots", armor = 55363, gem = 55686, reward = 55535, mult = 9},
    {slot = "bracer", armor = 55367, gem = 55697, reward = 55536, mult = 10},
    {slot = "gloves", armor = 55359, gem = 55675, reward = 55537, mult = 8},
}

-- DG switch: an armor case falls through into its gem case, so both vnums map to the same slot.
local object_vnum = object.zone_id * 100 + object.id
local entry, is_armor
for _, s in ipairs(slots) do
    if object_vnum == s.armor then
        entry = s
        is_armor = true
        break
    elseif object_vnum == s.gem then
        entry = s
        is_armor = false
        break
    end
end
if not entry then
    wait(1)
    self:command("eye " .. tostring(actor.name))
    actor:send(tostring(self.name) .. " tells you, 'I am not interested in this from you.'")
    give_back()
    return true
end

local armor_key = tostring(entry.armor) .. "_armor_acquired"
local gem_key = tostring(entry.gem) .. "_gems_acquired"
local armor = tonumber(actor:get_quest_var("phase_armor:" .. armor_key)) or 0
local gems = tonumber(actor:get_quest_var("phase_armor:" .. gem_key)) or 0

if is_armor then
    if armor < 1 then
        armor = armor + 1
        actor:set_quest_var("phase_armor", armor_key, armor)
        wait(2)
        actor:send(tostring(self.name) .. " tells you, \"Hey now. what have we here?!  I've been looking for some of this\"")
        actor:send(tostring(self.name) .. " tells you, \"for quite some time.  You have now given me " .. obj_name(entry.armor) .. ".\"")
        world.destroy(object)
        actor:save()
    else
        wait(2)
        self:command("eye " .. tostring(actor.name))
        wait(1)
        actor:send(tostring(self.name) .. " tells you, \"Hey now, you have given me " .. obj_name(entry.armor) .. " already!\"")
        give_back()
        -- Halt here so the reward can't be given twice.
        return true
    end
else
    if gems < 3 then
        gems = gems + 1
        actor:set_quest_var("phase_armor", gem_key, gems)
        wait(2)
        actor:send(tostring(self.name) .. " tells you, \"Hey, very nice. It is good to see adventurers out conquering the\"")
        actor:send(tostring(self.name) .. " tells you, \"realm.  You have now given me " .. tostring(gems) .. " " .. obj_name(entry.gem) .. ".\"")
        world.destroy(object)
        actor:save()
    else
        wait(2)
        self:command("eye " .. tostring(actor.name))
        wait(1)
        actor:send(tostring(self.name) .. " tells you, \"Hey now, you have given me 3 already!\"")
        give_back()
        -- Halt here so the reward can't be given twice.
        return true
    end
end

-- Quest complete for this slot: armor piece plus all 3 gems.
if armor == 1 and gems == 3 then
    wait(2)
    actor:send(tostring(self.name) .. " tells you, \"Excellent intrepid adventurer, you have provided me with all\"")
    actor:send(tostring(self.name) .. " tells you, \"I need in order to reward you with " .. obj_name(entry.reward) .. "!\"")
    wait(1)
    local reward = self:spawn_object(math.floor(entry.reward / 100), entry.reward % 100)
    wait(1)
    actor:send("<b:yellow>You gain experience!</>")
    for _ = 1, entry.mult do
        actor:award_exp(42840)
    end
    if reward then
        self:command("give " .. bare_name(reward.name) .. " to " .. actor.name)
    end
end
return true$trig$, '96d07418323faf0a10efbbe425b1f14d'),
  -- data/triggers/555/555_30_paladin_phase_3.lua
  (555, 30, $trig$-- Converted from DG Script #55530: paladin_phase_3
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
--
-- Phase armor turn-in (class and phase specific). Quest vars are keyed by the legacy object
-- vnum, as DG did: phase_armor:<armor vnum>_armor_acquired (1 piece) and
-- phase_armor:<gem vnum>_gems_acquired (3 gems). The zone 556 status scripts read these keys.
-- The runtime fires RECEIVE after the item is already in the mob's hands, so a refusal hands
-- it back with a give command (DG's `return 0`).

local class_ok = false
for _, c in ipairs({"paladin"}) do
    if string.lower(actor.class or "") == c then
        class_ok = true
        break
    end
end

local function obj_name(vnum)
    return objects.template(math.floor(vnum / 100), vnum % 100).name
end

-- Item names carry a leading article ("a rusted helm"); give matches on the bare words.
local function bare_name(name)
    return (string.gsub(string.gsub(name, "^%s*[Tt]he%s+", ""), "^%s*[Aa]n?%s+", ""))
end

local function give_back()
    self:command("give " .. bare_name(object.name) .. " to " .. actor.name)
    actor:send(tostring(self.name) .. " returns your item to you.")
end

if not (class_ok and actor.level >= 41 and actor:get_quest_stage("phase_armor") >= 2) then
    -- not the right class / phase for this questmaster
    wait(1)
    self:command("eye " .. tostring(actor.name))
    actor:send(tostring(self.name) .. " tells you, 'I am not interested in this from you.'")
    give_back()
    return true
end

-- Slots for this class: destroyed armor, gem, reward (legacy 5-digit vnums) and exp multiplier.
local slots = {
    {slot = "helm", armor = 55368, gem = 55709, reward = 55496, mult = 11},
    {slot = "arm", armor = 55372, gem = 55720, reward = 55497, mult = 12},
    {slot = "chest", armor = 55380, gem = 55742, reward = 55498, mult = 14},
    {slot = "legs", armor = 55376, gem = 55731, reward = 55499, mult = 13},
    {slot = "boots", armor = 55360, gem = 55687, reward = 55500, mult = 9},
    {slot = "bracer", armor = 55364, gem = 55698, reward = 55501, mult = 10},
    {slot = "gloves", armor = 55356, gem = 55676, reward = 55502, mult = 8},
}

-- DG switch: an armor case falls through into its gem case, so both vnums map to the same slot.
local object_vnum = object.zone_id * 100 + object.id
local entry, is_armor
for _, s in ipairs(slots) do
    if object_vnum == s.armor then
        entry = s
        is_armor = true
        break
    elseif object_vnum == s.gem then
        entry = s
        is_armor = false
        break
    end
end
if not entry then
    wait(1)
    self:command("eye " .. tostring(actor.name))
    actor:send(tostring(self.name) .. " tells you, 'I am not interested in this from you.'")
    give_back()
    return true
end

local armor_key = tostring(entry.armor) .. "_armor_acquired"
local gem_key = tostring(entry.gem) .. "_gems_acquired"
local armor = tonumber(actor:get_quest_var("phase_armor:" .. armor_key)) or 0
local gems = tonumber(actor:get_quest_var("phase_armor:" .. gem_key)) or 0

if is_armor then
    if armor < 1 then
        armor = armor + 1
        actor:set_quest_var("phase_armor", armor_key, armor)
        wait(2)
        actor:send(tostring(self.name) .. " tells you, \"Hey now. what have we here?!  I've been looking for some of this\"")
        actor:send(tostring(self.name) .. " tells you, \"for quite some time.  You have now given me " .. obj_name(entry.armor) .. ".\"")
        world.destroy(object)
        actor:save()
    else
        wait(2)
        self:command("eye " .. tostring(actor.name))
        wait(1)
        actor:send(tostring(self.name) .. " tells you, \"Hey now, you have given me " .. obj_name(entry.armor) .. " already!\"")
        give_back()
        -- Halt here so the reward can't be given twice.
        return true
    end
else
    if gems < 3 then
        gems = gems + 1
        actor:set_quest_var("phase_armor", gem_key, gems)
        wait(2)
        actor:send(tostring(self.name) .. " tells you, \"Hey, very nice. It is good to see adventurers out conquering the\"")
        actor:send(tostring(self.name) .. " tells you, \"realm.  You have now given me " .. tostring(gems) .. " " .. obj_name(entry.gem) .. ".\"")
        world.destroy(object)
        actor:save()
    else
        wait(2)
        self:command("eye " .. tostring(actor.name))
        wait(1)
        actor:send(tostring(self.name) .. " tells you, \"Hey now, you have given me 3 already!\"")
        give_back()
        -- Halt here so the reward can't be given twice.
        return true
    end
end

-- Quest complete for this slot: armor piece plus all 3 gems.
if armor == 1 and gems == 3 then
    wait(2)
    actor:send(tostring(self.name) .. " tells you, \"Excellent intrepid adventurer, you have provided me with all\"")
    actor:send(tostring(self.name) .. " tells you, \"I need in order to reward you with " .. obj_name(entry.reward) .. "!\"")
    wait(1)
    local reward = self:spawn_object(math.floor(entry.reward / 100), entry.reward % 100)
    wait(1)
    actor:send("<b:yellow>You gain experience!</>")
    for _ = 1, entry.mult do
        actor:award_exp(42840)
    end
    if reward then
        self:command("give " .. bare_name(reward.name) .. " to " .. actor.name)
    end
end
return true$trig$, '9f679ca814f98b32f5bb17dbdd24ded5'),
  -- data/triggers/555/555_40_ranger_phase_3.lua
  (555, 40, $trig$-- Converted from DG Script #55540: ranger_phase_3
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
--
-- Phase armor turn-in (class and phase specific). Quest vars are keyed by the legacy object
-- vnum, as DG did: phase_armor:<armor vnum>_armor_acquired (1 piece) and
-- phase_armor:<gem vnum>_gems_acquired (3 gems). The zone 556 status scripts read these keys.
-- The runtime fires RECEIVE after the item is already in the mob's hands, so a refusal hands
-- it back with a give command (DG's `return 0`).

local class_ok = false
for _, c in ipairs({"ranger"}) do
    if string.lower(actor.class or "") == c then
        class_ok = true
        break
    end
end

local function obj_name(vnum)
    return objects.template(math.floor(vnum / 100), vnum % 100).name
end

-- Item names carry a leading article ("a rusted helm"); give matches on the bare words.
local function bare_name(name)
    return (string.gsub(string.gsub(name, "^%s*[Tt]he%s+", ""), "^%s*[Aa]n?%s+", ""))
end

local function give_back()
    self:command("give " .. bare_name(object.name) .. " to " .. actor.name)
    actor:send(tostring(self.name) .. " returns your item to you.")
end

if not (class_ok and actor.level >= 41 and actor:get_quest_stage("phase_armor") >= 2) then
    -- not the right class / phase for this questmaster
    wait(1)
    self:command("eye " .. tostring(actor.name))
    actor:send(tostring(self.name) .. " tells you, 'I am not interested in this from you.'")
    give_back()
    return true
end

-- Slots for this class: destroyed armor, gem, reward (legacy 5-digit vnums) and exp multiplier.
local slots = {
    {slot = "helm", armor = 55369, gem = 55710, reward = 55517, mult = 11},
    {slot = "arm", armor = 55373, gem = 55721, reward = 55518, mult = 12},
    {slot = "chest", armor = 55381, gem = 55743, reward = 55519, mult = 14},
    {slot = "legs", armor = 55377, gem = 55732, reward = 55520, mult = 13},
    {slot = "boots", armor = 55361, gem = 55688, reward = 55521, mult = 9},
    {slot = "bracer", armor = 55365, gem = 55699, reward = 55522, mult = 10},
    {slot = "gloves", armor = 55357, gem = 55677, reward = 55523, mult = 8},
}

-- DG switch: an armor case falls through into its gem case, so both vnums map to the same slot.
local object_vnum = object.zone_id * 100 + object.id
local entry, is_armor
for _, s in ipairs(slots) do
    if object_vnum == s.armor then
        entry = s
        is_armor = true
        break
    elseif object_vnum == s.gem then
        entry = s
        is_armor = false
        break
    end
end
if not entry then
    wait(1)
    self:command("eye " .. tostring(actor.name))
    actor:send(tostring(self.name) .. " tells you, 'I am not interested in this from you.'")
    give_back()
    return true
end

local armor_key = tostring(entry.armor) .. "_armor_acquired"
local gem_key = tostring(entry.gem) .. "_gems_acquired"
local armor = tonumber(actor:get_quest_var("phase_armor:" .. armor_key)) or 0
local gems = tonumber(actor:get_quest_var("phase_armor:" .. gem_key)) or 0

if is_armor then
    if armor < 1 then
        armor = armor + 1
        actor:set_quest_var("phase_armor", armor_key, armor)
        wait(2)
        actor:send(tostring(self.name) .. " tells you, \"Hey now. what have we here?!  I've been looking for some of this\"")
        actor:send(tostring(self.name) .. " tells you, \"for quite some time.  You have now given me " .. obj_name(entry.armor) .. ".\"")
        world.destroy(object)
        actor:save()
    else
        wait(2)
        self:command("eye " .. tostring(actor.name))
        wait(1)
        actor:send(tostring(self.name) .. " tells you, \"Hey now, you have given me " .. obj_name(entry.armor) .. " already!\"")
        give_back()
        -- Halt here so the reward can't be given twice.
        return true
    end
else
    if gems < 3 then
        gems = gems + 1
        actor:set_quest_var("phase_armor", gem_key, gems)
        wait(2)
        actor:send(tostring(self.name) .. " tells you, \"Hey, very nice. It is good to see adventurers out conquering the\"")
        actor:send(tostring(self.name) .. " tells you, \"realm.  You have now given me " .. tostring(gems) .. " " .. obj_name(entry.gem) .. ".\"")
        world.destroy(object)
        actor:save()
    else
        wait(2)
        self:command("eye " .. tostring(actor.name))
        wait(1)
        actor:send(tostring(self.name) .. " tells you, \"Hey now, you have given me 3 already!\"")
        give_back()
        -- Halt here so the reward can't be given twice.
        return true
    end
end

-- Quest complete for this slot: armor piece plus all 3 gems.
if armor == 1 and gems == 3 then
    wait(2)
    actor:send(tostring(self.name) .. " tells you, \"Excellent intrepid adventurer, you have provided me with all\"")
    actor:send(tostring(self.name) .. " tells you, \"I need in order to reward you with " .. obj_name(entry.reward) .. "!\"")
    wait(1)
    local reward = self:spawn_object(math.floor(entry.reward / 100), entry.reward % 100)
    wait(1)
    actor:send("<b:yellow>You gain experience!</>")
    for _ = 1, entry.mult do
        actor:award_exp(42840)
    end
    if reward then
        self:command("give " .. bare_name(reward.name) .. " to " .. actor.name)
    end
end
return true$trig$, '95fcc14444b52ca77c22d3aa1291e89e'),
  -- data/triggers/555/555_50_rogue_phase_3.lua
  (555, 50, $trig$-- Converted from DG Script #55550: rogue_phase_3
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
--
-- Phase armor turn-in (class and phase specific). Quest vars are keyed by the legacy object
-- vnum, as DG did: phase_armor:<armor vnum>_armor_acquired (1 piece) and
-- phase_armor:<gem vnum>_gems_acquired (3 gems). The zone 556 status scripts read these keys.
-- The runtime fires RECEIVE after the item is already in the mob's hands, so a refusal hands
-- it back with a give command (DG's `return 0`).

local class_ok = false
for _, c in ipairs({"rogue", "thief", "assassin", "mercenary"}) do
    if string.lower(actor.class or "") == c then
        class_ok = true
        break
    end
end

local function obj_name(vnum)
    return objects.template(math.floor(vnum / 100), vnum % 100).name
end

-- Item names carry a leading article ("a rusted helm"); give matches on the bare words.
local function bare_name(name)
    return (string.gsub(string.gsub(name, "^%s*[Tt]he%s+", ""), "^%s*[Aa]n?%s+", ""))
end

local function give_back()
    self:command("give " .. bare_name(object.name) .. " to " .. actor.name)
    actor:send(tostring(self.name) .. " returns your item to you.")
end

if not (class_ok and actor.level >= 41 and actor:get_quest_stage("phase_armor") >= 2) then
    -- not the right class / phase for this questmaster
    wait(1)
    self:command("eye " .. tostring(actor.name))
    actor:send(tostring(self.name) .. " tells you, 'I am not interested in this from you.'")
    give_back()
    return true
end

-- Slots for this class: destroyed armor, gem, reward (legacy 5-digit vnums) and exp multiplier.
local slots = {
    {slot = "helm", armor = 55369, gem = 55713, reward = 55559, mult = 11},
    {slot = "arm", armor = 55373, gem = 55724, reward = 55560, mult = 12},
    {slot = "chest", armor = 55381, gem = 55746, reward = 55561, mult = 14},
    {slot = "legs", armor = 55377, gem = 55735, reward = 55562, mult = 13},
    {slot = "boots", armor = 55361, gem = 55691, reward = 55563, mult = 9},
    {slot = "bracer", armor = 55365, gem = 55702, reward = 55564, mult = 10},
    {slot = "gloves", armor = 55357, gem = 55680, reward = 55565, mult = 8},
}

-- DG switch: an armor case falls through into its gem case, so both vnums map to the same slot.
local object_vnum = object.zone_id * 100 + object.id
local entry, is_armor
for _, s in ipairs(slots) do
    if object_vnum == s.armor then
        entry = s
        is_armor = true
        break
    elseif object_vnum == s.gem then
        entry = s
        is_armor = false
        break
    end
end
if not entry then
    wait(1)
    self:command("eye " .. tostring(actor.name))
    actor:send(tostring(self.name) .. " tells you, 'I am not interested in this from you.'")
    give_back()
    return true
end

local armor_key = tostring(entry.armor) .. "_armor_acquired"
local gem_key = tostring(entry.gem) .. "_gems_acquired"
local armor = tonumber(actor:get_quest_var("phase_armor:" .. armor_key)) or 0
local gems = tonumber(actor:get_quest_var("phase_armor:" .. gem_key)) or 0

if is_armor then
    if armor < 1 then
        armor = armor + 1
        actor:set_quest_var("phase_armor", armor_key, armor)
        wait(2)
        actor:send(tostring(self.name) .. " tells you, \"Hey now. what have we here?!  I've been looking for some of this\"")
        actor:send(tostring(self.name) .. " tells you, \"for quite some time.  You have now given me " .. obj_name(entry.armor) .. ".\"")
        world.destroy(object)
        actor:save()
    else
        wait(2)
        self:command("eye " .. tostring(actor.name))
        wait(1)
        actor:send(tostring(self.name) .. " tells you, \"Hey now, you have given me " .. obj_name(entry.armor) .. " already!\"")
        give_back()
        -- Halt here so the reward can't be given twice.
        return true
    end
else
    if gems < 3 then
        gems = gems + 1
        actor:set_quest_var("phase_armor", gem_key, gems)
        wait(2)
        actor:send(tostring(self.name) .. " tells you, \"Hey, very nice. It is good to see adventurers out conquering the\"")
        actor:send(tostring(self.name) .. " tells you, \"realm.  You have now given me " .. tostring(gems) .. " " .. obj_name(entry.gem) .. ".\"")
        world.destroy(object)
        actor:save()
    else
        wait(2)
        self:command("eye " .. tostring(actor.name))
        wait(1)
        actor:send(tostring(self.name) .. " tells you, \"Hey now, you have given me 3 already!\"")
        give_back()
        -- Halt here so the reward can't be given twice.
        return true
    end
end

-- Quest complete for this slot: armor piece plus all 3 gems.
if armor == 1 and gems == 3 then
    wait(2)
    actor:send(tostring(self.name) .. " tells you, \"Excellent intrepid adventurer, you have provided me with all\"")
    actor:send(tostring(self.name) .. " tells you, \"I need in order to reward you with " .. obj_name(entry.reward) .. "!\"")
    wait(1)
    local reward = self:spawn_object(math.floor(entry.reward / 100), entry.reward % 100)
    wait(1)
    actor:send("<b:yellow>You gain experience!</>")
    for _ = 1, entry.mult do
        actor:award_exp(42840)
    end
    if reward then
        self:command("give " .. bare_name(reward.name) .. " to " .. actor.name)
    end
end
return true$trig$, 'a4b2f66b016f7f9f389dffdda4d87312'),
  -- data/triggers/555/555_60_warrior_phase_3.lua
  (555, 60, $trig$-- Converted from DG Script #55560: warrior_phase_3
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
--
-- Phase armor turn-in (class and phase specific). Quest vars are keyed by the legacy object
-- vnum, as DG did: phase_armor:<armor vnum>_armor_acquired (1 piece) and
-- phase_armor:<gem vnum>_gems_acquired (3 gems). The zone 556 status scripts read these keys.
-- The runtime fires RECEIVE after the item is already in the mob's hands, so a refusal hands
-- it back with a give command (DG's `return 0`).

local class_ok = false
for _, c in ipairs({"warrior"}) do
    if string.lower(actor.class or "") == c then
        class_ok = true
        break
    end
end

local function obj_name(vnum)
    return objects.template(math.floor(vnum / 100), vnum % 100).name
end

-- Item names carry a leading article ("a rusted helm"); give matches on the bare words.
local function bare_name(name)
    return (string.gsub(string.gsub(name, "^%s*[Tt]he%s+", ""), "^%s*[Aa]n?%s+", ""))
end

local function give_back()
    self:command("give " .. bare_name(object.name) .. " to " .. actor.name)
    actor:send(tostring(self.name) .. " returns your item to you.")
end

if not (class_ok and actor.level >= 41 and actor:get_quest_stage("phase_armor") >= 2) then
    -- not the right class / phase for this questmaster
    wait(1)
    self:command("eye " .. tostring(actor.name))
    actor:send(tostring(self.name) .. " tells you, 'I am not interested in this from you.'")
    give_back()
    return true
end

-- Slots for this class: destroyed armor, gem, reward (legacy 5-digit vnums) and exp multiplier.
local slots = {
    {slot = "helm", armor = 55368, gem = 55714, reward = 55489, mult = 11},
    {slot = "arm", armor = 55372, gem = 55725, reward = 55490, mult = 12},
    {slot = "chest", armor = 55380, gem = 55747, reward = 55491, mult = 14},
    {slot = "legs", armor = 55376, gem = 55736, reward = 55492, mult = 13},
    {slot = "boots", armor = 55360, gem = 55692, reward = 55493, mult = 9},
    {slot = "bracer", armor = 55364, gem = 55703, reward = 55494, mult = 10},
    {slot = "gloves", armor = 55356, gem = 55681, reward = 55495, mult = 8},
}

-- DG switch: an armor case falls through into its gem case, so both vnums map to the same slot.
local object_vnum = object.zone_id * 100 + object.id
local entry, is_armor
for _, s in ipairs(slots) do
    if object_vnum == s.armor then
        entry = s
        is_armor = true
        break
    elseif object_vnum == s.gem then
        entry = s
        is_armor = false
        break
    end
end
if not entry then
    wait(1)
    self:command("eye " .. tostring(actor.name))
    actor:send(tostring(self.name) .. " tells you, 'I am not interested in this from you.'")
    give_back()
    return true
end

local armor_key = tostring(entry.armor) .. "_armor_acquired"
local gem_key = tostring(entry.gem) .. "_gems_acquired"
local armor = tonumber(actor:get_quest_var("phase_armor:" .. armor_key)) or 0
local gems = tonumber(actor:get_quest_var("phase_armor:" .. gem_key)) or 0

if is_armor then
    if armor < 1 then
        armor = armor + 1
        actor:set_quest_var("phase_armor", armor_key, armor)
        wait(2)
        actor:send(tostring(self.name) .. " tells you, \"Hey now. what have we here?!  I've been looking for some of this\"")
        actor:send(tostring(self.name) .. " tells you, \"for quite some time.  You have now given me " .. obj_name(entry.armor) .. ".\"")
        world.destroy(object)
        actor:save()
    else
        wait(2)
        self:command("eye " .. tostring(actor.name))
        wait(1)
        actor:send(tostring(self.name) .. " tells you, \"Hey now, you have given me " .. obj_name(entry.armor) .. " already!\"")
        give_back()
        -- Halt here so the reward can't be given twice.
        return true
    end
else
    if gems < 3 then
        gems = gems + 1
        actor:set_quest_var("phase_armor", gem_key, gems)
        wait(2)
        actor:send(tostring(self.name) .. " tells you, \"Hey, very nice. It is good to see adventurers out conquering the\"")
        actor:send(tostring(self.name) .. " tells you, \"realm.  You have now given me " .. tostring(gems) .. " " .. obj_name(entry.gem) .. ".\"")
        world.destroy(object)
        actor:save()
    else
        wait(2)
        self:command("eye " .. tostring(actor.name))
        wait(1)
        actor:send(tostring(self.name) .. " tells you, \"Hey now, you have given me 3 already!\"")
        give_back()
        -- Halt here so the reward can't be given twice.
        return true
    end
end

-- Quest complete for this slot: armor piece plus all 3 gems.
if armor == 1 and gems == 3 then
    wait(2)
    actor:send(tostring(self.name) .. " tells you, \"Excellent intrepid adventurer, you have provided me with all\"")
    actor:send(tostring(self.name) .. " tells you, \"I need in order to reward you with " .. obj_name(entry.reward) .. "!\"")
    wait(1)
    local reward = self:spawn_object(math.floor(entry.reward / 100), entry.reward % 100)
    wait(1)
    actor:send("<b:yellow>You gain experience!</>")
    for _ = 1, entry.mult do
        actor:award_exp(42840)
    end
    if reward then
        self:command("give " .. bare_name(reward.name) .. " to " .. actor.name)
    end
end
return true$trig$, '678fe3737ba0b259a05fc785b1ff85aa'),
  -- data/triggers/556/556_12_phase_2_sorcerer_status.lua
  (556, 12, $trig$-- Converted from DG Script #55612: phase_2_sorcerer_status
-- Original: MOB trigger, flags: SPEECH_TO, num_arg: 0 (DG phrase mode, not a probability)

-- Status report. Quest vars are keyed by the legacy object vnum, as DG did:
-- phase_armor:<vnum>_armor_acquired and phase_armor:<vnum>_gems_acquired. The turn-in
-- scripts (zones 553-555) still write placeholder keys, so progress only shows here once
-- those are fixed.

-- Speech phrase: status (DG num_arg 0 = the speech contains the phrase, not a chance)
if not string.find(string.lower(speech), "status", 1, true) then
    return true  -- Not the phrase
end
local actor_class = string.lower(actor.class or "")
local right_class = false
for _, c in ipairs({"sorcerer", "cryomancer", "pyromancer"}) do
    if actor_class == c then
        right_class = true
        break
    end
end
local function obj_name(vnum)
    return objects.template(math.floor(vnum / 100), vnum % 100).name
end
local min_level = 21
local quest_stage = 2
if right_class then
    if actor.level < min_level then
        actor:send(tostring(self.name) .. " tells you, 'You need to gain more experience first.'")
    elseif actor:get_quest_stage("phase_armor") >= quest_stage then
        -- destroyed armor
        local id_destroyed_gloves = 55331
        local id_destroyed_boots = 55335
        local id_destroyed_bracer = 55339
        local id_destroyed_helm = 55343
        local id_destroyed_arm = 55347
        local id_destroyed_legs = 55351
        local id_destroyed_chest = 55355
        -- gems for this class
        local id_gem_gloves = 55602
        local id_gem_boots = 55613
        local id_gem_bracer = 55624
        local id_gem_helm = 55631
        local id_gem_arm = 55646
        local id_gem_legs = 55657
        local id_gem_chest = 55668
        -- rewards for this class
        local id_reward_helm = 55475
        local id_reward_arms = 55476
        local id_reward_chest = 55477
        local id_reward_legs = 55478
        local id_reward_boots = 55479
        local id_reward_bracer = 55480
        local id_reward_gloves = 55481
        local gloves_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_gloves .. "_armor_acquired")) or 0
        local boots_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_boots .. "_armor_acquired")) or 0
        local bracer_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_bracer .. "_armor_acquired")) or 0
        local helm_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_helm .. "_armor_acquired")) or 0
        local arm_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_arm .. "_armor_acquired")) or 0
        local legs_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_legs .. "_armor_acquired")) or 0
        local chest_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_chest .. "_armor_acquired")) or 0
        local gloves_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_gloves .. "_gems_acquired")) or 0
        local boots_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_boots .. "_gems_acquired")) or 0
        local bracer_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_bracer .. "_gems_acquired")) or 0
        local helm_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_helm .. "_gems_acquired")) or 0
        local arm_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_arm .. "_gems_acquired")) or 0
        local legs_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_legs .. "_gems_acquired")) or 0
        local chest_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_chest .. "_gems_acquired")) or 0
        local done_gloves = gloves_armor == 1  and  gloves_gems == 3
        local done_boots = boots_armor == 1  and  boots_gems == 3
        local done_bracer = bracer_armor == 1  and  bracer_gems == 3
        local done_helm = helm_armor == 1  and  helm_gems == 3
        local done_arm = arm_armor == 1  and  arm_gems == 3
        local done_legs = legs_armor == 1  and  legs_gems == 3
        local done_chest = chest_armor == 1  and  chest_gems == 3
        local given = gloves_armor + boots_armor + bracer_armor + helm_armor + arm_armor + legs_armor + chest_armor
        given = given + gloves_gems + boots_gems + bracer_gems + helm_gems + arm_gems + legs_gems + chest_gems
        if given > 0 then
            actor:send(tostring(self.name) .. " tells you, 'You have given me:'")
        else
            actor:send(tostring(self.name) .. " tells you, 'You haven't given me anything yet.'")
            return true
        end
        if gloves_armor > 0 and not done_gloves then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_gloves) .. "'")
        end
        if gloves_gems > 0 and not done_gloves then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(gloves_gems) .. " of " .. obj_name(id_gem_gloves) .. "'")
        end
        if boots_armor > 0 and not done_boots then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_boots) .. "'")
        end
        if boots_gems > 0 and not done_boots then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(boots_gems) .. " of " .. obj_name(id_gem_boots) .. "'")
        end
        if bracer_armor > 0 and not done_bracer then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_bracer) .. "'")
        end
        if bracer_gems > 0 and not done_bracer then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(bracer_gems) .. " of " .. obj_name(id_gem_bracer) .. "'")
        end
        if helm_armor > 0 and not done_helm then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_helm) .. "'")
        end
        if helm_gems > 0 and not done_helm then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(helm_gems) .. " of " .. obj_name(id_gem_helm) .. "'")
        end
        if arm_armor > 0 and not done_arm then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_arm) .. "'")
        end
        if arm_gems > 0 and not done_arm then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(arm_gems) .. " of " .. obj_name(id_gem_arm) .. "'")
        end
        if legs_armor > 0 and not done_legs then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_legs) .. "'")
        end
        if legs_gems > 0 and not done_legs then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(legs_gems) .. " of " .. obj_name(id_gem_legs) .. "'")
        end
        if chest_armor > 0 and not done_chest then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_chest) .. "'")
        end
        if chest_gems > 0 and not done_chest then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(chest_gems) .. " of " .. obj_name(id_gem_chest) .. "'")
        end
        if done_gloves or done_boots or done_bracer or done_helm or done_arm or done_legs or done_chest then
            actor:send(tostring(self.name) .. " tells you, 'You have completed quests for:'")
        end
        if done_gloves then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_gloves) .. "'")
        end
        if done_boots then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_boots) .. "'")
        end
        if done_bracer then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_bracer) .. "'")
        end
        if done_helm then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_helm) .. "'")
        end
        if done_arm then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_arms) .. "'")
        end
        if done_legs then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_legs) .. "'")
        end
        if done_chest then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_chest) .. "'")
        end
    else
        actor:send(tostring(self.name) .. " tells you, 'You haven't even talked to me about armor quests yet!'")
    end
end$trig$, '1833b72559b4c4562643a9e2122f3e70')
) AS v(zone_id, id, commands, old_md5)
WHERE t.zone_id = v.zone_id
  AND t.id = v.id
  AND md5(t.commands) = v.old_md5
  AND t.commands IS DISTINCT FROM v.commands;

COMMIT;
