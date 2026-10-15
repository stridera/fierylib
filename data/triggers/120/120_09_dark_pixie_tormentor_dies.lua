-- Trigger: Dark pixie tormentor dies
-- Zone: 120, ID: 9
-- Type: MOB, Flags: DEATH
-- Status: CLEAN
--
-- Original DG Script: #12009

-- Converted from DG Script #12009: Dark pixie tormentor dies
-- Original: MOB trigger, flags: DEATH, probability: 100%
if (self.room.zone_id == 120 and self.room.local_id == 103) then
    run_room_trigger(120, 8)
end