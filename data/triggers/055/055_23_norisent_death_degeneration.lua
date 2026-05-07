-- Trigger: Norisent_death_degeneration
-- Zone: 55, ID: 23
-- Type: MOB, Flags: DEATH
-- Status: CLEAN
--
-- Original DG Script: #5523

-- Converted from DG Script #5523: Norisent_death_degeneration
-- Original: MOB trigger, flags: DEATH, probability: 100%
-- When Norisent dies, drop his book (zone 85, id 51) for any party member
-- in the room who is on Degeneration quest stage 7. Falls back to the
-- killing actor if they are not in a group.
local advanced = false
if actor.group then
    for _, person in ipairs(actor.group) do
        if person.room == self.room and person:get_quest_stage("degeneration") == 7 then
            person:advance_quest("degeneration")
            advanced = true
        end
    end
end
if not advanced and actor:get_quest_stage("degeneration") == 7 then
    actor:advance_quest("degeneration")
    advanced = true
end
if advanced then
    self.room:spawn_object(85, 51)
    self.room:send("<b:green>A small book slips from " .. tostring(self.name) .. "'s robes.</>")
end