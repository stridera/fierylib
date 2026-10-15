-- Trigger: **UNUSED**
-- Zone: 554, ID: 70
-- Type: MOB, Flags: RECEIVE
--
-- Original DG Script: #55470

-- Converted from DG Script #55470: **UNUSED**
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
    wait(0.1)
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
    wait(0.1)
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
        wait(0.2)
        actor:send(tostring(self.name) .. " tells you, \"Hey now. what have we here?!  I've been looking for some of this\"")
        actor:send(tostring(self.name) .. " tells you, \"for quite some time.  You have now given me " .. obj_name(entry.armor) .. ".\"")
        world.destroy(object)
        actor:save()
    else
        wait(0.2)
        self:command("eye " .. tostring(actor.name))
        wait(0.1)
        actor:send(tostring(self.name) .. " tells you, \"Hey now, you have given me " .. obj_name(entry.armor) .. " already!\"")
        give_back()
        -- Halt here so the reward can't be given twice.
        return true
    end
else
    if gems < 3 then
        gems = gems + 1
        actor:set_quest_var("phase_armor", gem_key, gems)
        wait(0.2)
        actor:send(tostring(self.name) .. " tells you, \"Hey, very nice. It is good to see adventurers out conquering the\"")
        actor:send(tostring(self.name) .. " tells you, \"realm.  You have now given me " .. tostring(gems) .. " " .. obj_name(entry.gem) .. ".\"")
        world.destroy(object)
        actor:save()
    else
        wait(0.2)
        self:command("eye " .. tostring(actor.name))
        wait(0.1)
        actor:send(tostring(self.name) .. " tells you, \"Hey now, you have given me 3 already!\"")
        give_back()
        -- Halt here so the reward can't be given twice.
        return true
    end
end

-- Quest complete for this slot: armor piece plus all 3 gems.
if armor == 1 and gems == 3 then
    wait(0.2)
    actor:send(tostring(self.name) .. " tells you, \"Excellent intrepid adventurer, you have provided me with all\"")
    actor:send(tostring(self.name) .. " tells you, \"I need in order to reward you with " .. obj_name(entry.reward) .. "!\"")
    wait(0.1)
    local reward = self:spawn_object(math.floor(entry.reward / 100), entry.reward % 100)
    wait(0.1)
    actor:send("<b:yellow>You gain experience!</>")
    for _ = 1, entry.mult do
        actor:award_exp(42840)
    end
    if reward then
        self:command("give " .. bare_name(reward.name) .. " to " .. actor.name)
    end
end
return true
