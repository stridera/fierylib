-- Trigger: Orbweaver builds a web to the north
-- Zone: 615, ID: 32
-- Type: MOB, Flags: GLOBAL, RANDOM
-- Status: CLEAN
--
-- Original DG Script: #61532

-- Converted from DG Script #61532: Orbweaver builds a web to the north
-- Original: MOB trigger, flags: GLOBAL, RANDOM, probability: 100%
if in_battle ~= 1 then
    if self.room == 61566 then
        run_room_trigger(61533)
    end
end
local in_battle = 0
globals.in_battle = globals.in_battle or true