-- Beast Master creature death (53:14): composite (zone, id) targets, group iteration rewritten, no branch-scoped locals (playtest 2026-10-11 round 2 #80)
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
  -- data/triggers/053/053_14_beast_master_creature_death.lua
  (53, 14, $trig$local TARGETS = {
    { zone = 30,  id = 133, stage = 1,  target = "abominable_slime_creature" },
    { zone = 120, id = 3,   stage = 2,  target = "buck" },
    { zone = 161, id = 5,   stage = 3,  target = "giant_scorpion" },
    { zone = 23,  id = 8,   stage = 4,  target = "monstrous_canopy_spider" },
    { zone = 481, id = 20,  stage = 5,  target = "chimera" },
    { zone = 237, id = 30,  stage = 6,  target = "drider_king" },
    { zone = 533, id = 5,   stage = 7,  target = "beholder" },
    { zone = 530, id = 3,   stage = 8,  target = "banshee" },
    { zone = 584, id = 1,   stage = 9,  target = "baba_yaga" },
    { zone = 520, id = 6,   stage = 10, target = "medusa" },
}

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
            if person:get_quest_stage("beast_master") == entry.stage
                and person:get_quest_var("beast_master:hunt") == "running" then
                person:set_quest_var("beast_master", "target1", entry.target)
                person:set_quest_var("beast_master", "hunt", "dead")
                person:send("<b:red>You cross " .. tostring(self.name) .. " off your list.</>")
            end
        end
    end
end$trig$, 'dfb06f641814c58149961fcf64a662e1')
) AS v(zone_id, id, commands, old_md5)
WHERE t.zone_id = v.zone_id
  AND t.id = v.id
  AND md5(t.commands) = v.old_md5
  AND t.commands IS DISTINCT FROM v.commands;

COMMIT;
