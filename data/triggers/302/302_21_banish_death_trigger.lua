-- Trigger: Banish death trigger
-- Zone: 302, ID: 21
-- Type: MOB, Flags: DEATH
-- Status: NEEDS_REVIEW
--   TODO: Confirm the (zone, local_id) for each banish quest target. The original
--   used legacy vnums (41119 -> 411/19, etc.). Verify each splits correctly,
--   and confirm whether this trigger replaces the per-mob death triggers
--   (302_14..17, 302_20) or runs alongside them.
--
-- Original DG Script: #30221
-- Generic banish quest reward trigger applied to all six target mobs.

local mob_table = {
    -- [zone] = { [local_id] = { stage = N, letter = "X" } }
    [411] = { [19] = { stage = 1, letter = "V" } },  -- Sea Witch
    [533] = { [13] = { stage = 2, letter = "I" } },  -- Ice Lord
    [370] = { [0]  = { stage = 3, letter = "B" } },  -- Mesmeriz
    [480] = { [5]  = { stage = 4, letter = "U" } },  -- Eidolon
    [534] = { [17] = { stage = 5, letter = "G" } },  -- Chaos Demon
    [238] = { [11] = { stage = 6, letter = "P" } },  -- lesser seraph
}
local zone_entry = mob_table[self.zone_id]
local entry = zone_entry and zone_entry[self.local_id]
if not entry then
    return true
end
local target_stage = entry.stage
local letter = entry.letter

local function reward(person)
    if person and person.room == self.room
            and person:get_quest_stage("banish") == target_stage then
        person:advance_quest("banish")
        person:set_quest_var("banish", "greet", 0)
        person:send("<b:magenta>A single letter pops into your mind - <b:cyan>" .. tostring(letter) .. "</>")
    end
end

local size = actor.group_size or 0
if size > 0 then
    for a = 1, size do
        reward(actor.group_member[a])
    end
else
    reward(actor)
end