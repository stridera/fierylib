-- Trigger: hellfire_brimstone_meat_death
-- Zone: 23, ID: 9
-- Type: MOB, Flags: DEATH
-- Status: REVIEWED (group iteration normalized)
--
-- Original DG Script: #2309
-- On the meat-source mob's death, drop a chunk of paladin flesh (23, 38)
-- with ~30% chance for any group member in the same room who is on
-- hellfire_brimstone stage 1.

local function maybe_drop_meat(person)
    if person.room == self.room
       and person:get_quest_stage("hellfire_brimstone") == 1
       and random(1, 10) > 7 then
        self.room:spawn_object(23, 38)
    end
end

if actor.group then
    for _, member in ipairs(actor.group) do
        maybe_drop_meat(member)
    end
else
    maybe_drop_meat(actor)
end