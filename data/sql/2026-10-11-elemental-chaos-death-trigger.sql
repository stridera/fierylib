-- Elemental Chaos target death (53:46): composite (zone, id) targets, group iteration rewritten, no branch-scoped locals, unset quest vars tested as empty strings
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
  -- data/triggers/053/053_46_elemental_chaos_target_death.lua
  (53, 46, $trig$local TARGETS = {
    { zone = 588, id = 8,  stage = 1,  slot = 1, target = "imp" },
    { zone = 43,  id = 99, stage = 2,  slot = 1, target = "Leading_player" },
    { zone = 173, id = 6,  stage = 3,  slot = 1, target = "Chaos" },
    { zone = 178, id = 11, stage = 4,  slot = 1, target = "Fetch" },
    { zone = 462, id = 6,  stage = 5,  slot = 1, target = "shaman_Fang" },
    { zone = 462, id = 7,  stage = 5,  slot = 2, target = "necro_Fang" },
    { zone = 462, id = 8,  stage = 5,  slot = 3, target = "dia_Fang" },
    { zone = 125, id = 23, stage = 6,  slot = 1, target = "fire_lord" },
    { zone = 85,  id = 9,  stage = 7,  slot = 1, target = "acolyte" },
    { zone = 430, id = 17, stage = 8,  slot = 1, target = "Cyprianum" },
    { zone = 534, id = 17, stage = 9,  slot = 1, target = "Chaos_Demon" },
    { zone = 40,  id = 9,  stage = 10, slot = 1, target = "Norhamen" },
}

-- get_quest_var returns "" for an unset variable, and "" is truthy in Lua.
local function is_set(v)
    return v ~= nil and v ~= ""
end

local entry = nil
for _, t in ipairs(TARGETS) do
    if t.zone == self.zone_id and t.id == self.local_id then
        entry = t
        break
    end
end
-- The killer's group (a lone killer is a group of one).
if entry and actor then
    local members = actor.group_member
    for i = 1, actor.group_size do
        local person = members[i]
        if person and person.is_player and person.room == self.room then
            if person:get_quest_stage("elemental_chaos") == entry.stage
                and person:get_quest_var("elemental_chaos:bounty") == "running" then
                person:set_quest_var("elemental_chaos", "target" .. entry.slot, entry.target)
                person:send("<b:red>You cross " .. tostring(self.name) .. " off your list.</>")
                if entry.stage == 5 then
                    if is_set(person:get_quest_var("elemental_chaos:target1"))
                        and is_set(person:get_quest_var("elemental_chaos:target2"))
                        and is_set(person:get_quest_var("elemental_chaos:target3")) then
                        person:set_quest_var("elemental_chaos", "bounty", "dead")
                    end
                else
                    person:set_quest_var("elemental_chaos", "bounty", "dead")
                end
            end
        end
    end
end$trig$, 'eccfd920b4fab3205865a2eec15a82cf')
) AS v(zone_id, id, commands, old_md5)
WHERE t.zone_id = v.zone_id
  AND t.id = v.id
  AND md5(t.commands) = v.old_md5
  AND t.commands IS DISTINCT FROM v.commands;

COMMIT;
