-- Trigger: Orbweaver builds a web to the north
-- Zone: 615, ID: 32
-- Type: MOB, Flags: GLOBAL, RANDOM
-- Status: CLEAN
--
-- Original DG Script: #61532

-- Converted from DG Script #61532: Orbweaver builds a web to the north
-- Original: MOB trigger, flags: GLOBAL, RANDOM, probability: 100%
if globals.in_battle ~= 1 then
    if self.room.zone_id == 615 and self.room.local_id == 66 then
        run_room_trigger(615, 33)
    end
end
globals.in_battle = 0