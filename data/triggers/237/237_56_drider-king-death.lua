-- Trigger: drider-king-death
-- Zone: 237, ID: 56
-- Type: MOB, Flags: DEATH
-- Status: CLEAN
--
-- Original DG Script: #23756

-- Converted from DG Script #23756: drider-king-death
-- Original: MOB trigger, flags: DEATH, probability: 100%
-- vilekka_stew stage 3: when the drider king dies, drop his head (237/20)
-- iff at least one group member in the room is on stage 3 of the quest.
local on_quest = false
for _, person in ipairs(actor.group) do
    if person.room == self.room and person:get_quest_stage("vilekka_stew") == 3 then
        on_quest = true
        break
    end
end
if on_quest then
    self.room:send("With a horrible shriek, the drider king's body melts!")
    self.room:spawn_object(237, 20)
end
return true
