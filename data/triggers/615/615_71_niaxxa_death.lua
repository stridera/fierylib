-- Trigger: Niaxxa death
-- Zone: 615, ID: 71
-- Type: MOB, Flags: DEATH
-- Status: CLEAN
--
-- Original DG Script: #61571

-- Converted from DG Script #61571: Niaxxa death
-- Original: MOB trigger, flags: DEATH, probability: 100%
-- Award the Enchanted Hollow quest to every group-mate of the killer
-- who is in this room.
local size = actor.group_size or 0
if size > 0 then
    for a = 1, size do
        local person = actor.group_member and actor.group_member[a]
        if person and person.room == self.room then
            if person:get_quest_stage("enchanted_hollow_quest") and not person:get_has_completed("enchanted_hollow_quest") then
                person:complete_quest("enchanted_hollow_quest")
            end
        end
    end
elseif actor.room == self.room then
    if actor:get_quest_stage("enchanted_hollow_quest") and not actor:get_has_completed("enchanted_hollow_quest") then
        actor:complete_quest("enchanted_hollow_quest")
    end
end