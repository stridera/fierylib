-- Trigger: baatezu-death
-- Zone: 22, ID: 26
-- Type: MOB, Flags: DEATH
-- Status: CLEAN
--
-- Original DG Script: #2226

-- Converted from DG Script #2226: baatezu-death
-- Original: MOB trigger, flags: DEATH, probability: 100%
-- TODO(parity): legacy `self.room == 2217` (vnum) — verify mob room is (22, 17) before opening vault exit
if self.room and self.room.zone_id == 22 and self.room.local_id == 17 then
    self.room:send("<red>A hideous <blue>roar</><red> fades into &9<blue>nothingness.</>")
    run_room_trigger(22, 27)
end