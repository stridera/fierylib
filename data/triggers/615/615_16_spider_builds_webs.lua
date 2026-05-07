-- Trigger: Spider builds webs
-- Zone: 615, ID: 16
-- Type: MOB, Flags: GLOBAL, RANDOM
-- Status: CLEAN
--
-- Original DG Script: #61516

-- Converted from DG Script #61516: Spider builds webs
-- Original: MOB trigger, flags: GLOBAL, RANDOM, probability: 100%
if globals.in_battle ~= 1 then
    if self.room.zone_id == 615 and self.room.local_id == 49 then
        run_room_trigger(615, 17)
    end
end
globals.in_battle = 0