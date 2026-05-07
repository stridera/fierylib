-- Trigger: creeping_doom_bugs_death
-- Zone: 615, ID: 54
-- Type: MOB, Flags: DEATH
-- Status: CLEAN
--
-- Original DG Script: #61554

-- Converted from DG Script #61554: creeping_doom_bugs_death
-- Original: MOB trigger, flags: DEATH, probability: 100%
-- TODO(parity): The original DG iterated actor.group_member; the
-- (person.id >= 1000 and person.id <= 1038) test appears to be an old
-- player-id range check from CircleMUD that no longer makes sense
-- against the new schema. Preserved as-is so behaviour matches the
-- pre-conversion intent until we have a confirmed mapping.
local function maybe_drop(person)
    if person and person.room == self.room then
        if person:get_quest_stage("creeping_doom") == 2
            or (person.level > 80 and person.id >= 1000 and person.id <= 1038) then
            if random(1, 50) <= self.level then
                self.room:spawn_object(615, 17)
            end
        end
    end
end

local size = actor.group_size or 0
if size > 0 then
    for a = 1, size do
        maybe_drop(actor.group_member and actor.group_member[a])
    end
else
    maybe_drop(actor)
end