-- Trigger: Spider builds webs
-- Zone: 615, ID: 16
-- Type: MOB, Flags: GLOBAL, RANDOM
-- Status: CLEAN
--
-- Original DG Script: #61516

-- Converted from DG Script #61516: Spider builds webs
-- Original: MOB trigger, flags: GLOBAL, RANDOM, probability: 100%
if in_battle ~= 1 then
    if self.room == 61549 then
        run_room_trigger(61517)
    end
end
local in_battle = 0
globals.in_battle = globals.in_battle or true