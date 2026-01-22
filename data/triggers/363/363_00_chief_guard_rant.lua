-- Trigger: chief_guard_rant
-- Zone: 363, ID: 0
-- Type: MOB, Flags: ENTRY
-- Status: CLEAN
--
-- Original DG Script: #36300

-- Converted from DG Script #36300: chief_guard_rant
-- Original: MOB trigger, flags: ENTRY, probability: 100%
wait(2)
local rnd = room.actors[random(1, #room.actors)]
if rnd.id == 36303 then
    self:command("poke 2.guard")
    self:command("glare 2.guard")
    self:say("My granny could do a better job guarding this place than you!")
    self:command("whap 2.guard")
    self:say("Chest out! Shoulders back!")
    self:command("steam")
end