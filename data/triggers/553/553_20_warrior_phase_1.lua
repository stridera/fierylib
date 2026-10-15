-- Trigger: warrior_phase_1
-- Zone: 553, ID: 20
-- Type: MOB, Flags: RECEIVE
--
-- Original DG Script: #55320

-- Converted from DG Script #55320: warrior_phase_1
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

if not (class_ok and actor.level >= 1 and actor:get_quest_stage("phase_armor") >= 1) then
    -- not the right class / phase for this questmaster
    self:command("eye " .. tostring(actor.name))
    actor:send(tostring(self.name) .. " tells you, 'I am not interested in this from you.'")
    return false  -- legacy return 0: the giver keeps the item
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
    self:command("eye " .. tostring(actor.name))
    actor:send(tostring(self.name) .. " tells you, 'I am not interested in this from you.'")
    return false  -- legacy return 0: the giver keeps the item
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
        self:command("eye " .. tostring(actor.name))
        actor:send(tostring(self.name) .. " tells you, \"Hey now, you have given me " .. obj_name(entry.armor) .. " already!\"")
        -- Halt here so the reward can't be given twice.
        return false  -- legacy return 0: the giver keeps the item
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
        self:command("eye " .. tostring(actor.name))
        actor:send(tostring(self.name) .. " tells you, \"Hey now, you have given me 3 already!\"")
        -- Halt here so the reward can't be given twice.
        return false  -- legacy return 0: the giver keeps the item
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
        actor:award_exp(2640)
    end
    if reward then
        self:command("give " .. bare_name(reward.name) .. " to " .. actor.name)
    end
end
return true
