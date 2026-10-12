-- Trigger: Elemental Chaos target death
-- Zone: 53, ID: 46
-- Type: MOB, Flags: DEATH
-- Status: CLEAN
--
-- Original DG Script: #5346
--
-- Elemental Chaos bounty (quest "elemental_chaos"): when one of the hunt targets dies, every
-- player in the killer's group who is standing in the room, is on that target's stage and
-- has an active bounty ("running") has the kill recorded in the quest variable
-- "target<slot>". Stage 5 has three targets (the Fangs, slots 1-3) and is finished only
-- once all three are down; every other stage has one target and is finished by its kill.
-- Finishing sets the bounty to "dead" and the player goes back to Hakujo to hand it in.
--
-- The DG original switched on legacy vnums; the targets are keyed by composite (zone, id)
-- here and matched against self.zone_id / self.local_id. Stages 1-10 follow Hakujo's
-- mission list (see 053_37 speech_yes).

local TARGETS = {
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

-- get_quest_var returns nil for an unset variable (and "" is tolerated for old rows).
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
end
