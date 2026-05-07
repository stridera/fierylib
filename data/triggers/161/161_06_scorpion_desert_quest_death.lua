-- Trigger: Scorpion desert quest death
-- Zone: 161, ID: 6
-- Type: MOB, Flags: DEATH
-- Status: CLEAN
--
-- Original DG Script: #16106
--
-- When the giant scorpion dies, mark the desert_quest scorpion-step complete
-- for every grouped player who is in the room and on the quest.
local size = actor.group_size or 0
if size > 0 then
    for i = 1, size do
        local person = actor.group_member[i]
        if person and person.room == self.room
                and person:get_quest_stage("desert_quest") then
            person:set_quest_var("desert_quest", "scorpion", 1)
        end
    end
elseif actor:get_quest_stage("desert_quest") then
    actor:set_quest_var("desert_quest", "scorpion", 1)
end