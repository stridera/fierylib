-- Trigger: drow-heart-spawn
-- Zone: 237, ID: 55
-- Type: MOB, Flags: DEATH
-- Status: CLEAN
--
-- Original DG Script: #23755

-- Converted from DG Script #23755: drow-heart-spawn
-- Original: MOB trigger, flags: DEATH, probability: 100%
-- vilekka_stew stage 1: when the drow master dies, drop the heart (237/21)
-- iff at least one group member in the room is on stage 1 of the quest.
local on_quest = false
for _, person in ipairs(actor.group) do
    if person.room == self.room and person:get_quest_stage("vilekka_stew") == 1 then
        on_quest = true
        break
    end
end
if on_quest then
    self.room:spawn_object(237, 21)
    self.room:send("The drow master's last breath echoes softly as he dies.")
    self.room:send("'Mother...why...'")
end
return true
