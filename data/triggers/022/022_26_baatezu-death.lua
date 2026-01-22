-- Trigger: baatezu-death
-- Zone: 22, ID: 26
-- Type: MOB, Flags: DEATH
-- Status: CLEAN
--
-- Original DG Script: #2226

-- Converted from DG Script #2226: baatezu-death
-- Original: MOB trigger, flags: DEATH, probability: 100%
if self.room == 2217 then
    self.room:send("<red>A hideous <blue>roar</><red> fades into &9<blue>nothingness.</>")
    run_room_trigger(2227)
end