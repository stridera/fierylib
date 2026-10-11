-- Trigger: Beast Master creature death
-- Zone: 53, ID: 14
-- Type: MOB, Flags: DEATH
-- Status: CLEAN
--
-- Original DG Script: #5314
--
-- Beast Master hunt (quest "beast_master"): when one of the ten hunt targets dies, every
-- player in the killer's group who is standing in the room, is on that target's stage and
-- has an active hunt ("running") has the hunt marked "dead" and the kill recorded in the
-- quest variable "target1". They then go back to Pumahl to hand the assignment in.
--
-- The DG original switched on legacy vnums; the targets are keyed by composite (zone, id)
-- here and matched against self.zone_id / self.local_id. Stages 1-10 follow Pumahl's
-- assignment list (see 053_12 speech_yes).

local TARGETS = {
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
end
