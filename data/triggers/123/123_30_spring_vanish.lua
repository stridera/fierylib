-- Trigger: spring_vanish
-- Zone: 123, ID: 30
-- Type: WORLD, Flags: RANDOM
-- Status: CLEAN
--
-- Original DG Script: #12330

-- Converted from DG Script #12330: spring_vanish
-- Original: WORLD trigger, flags: RANDOM, probability: 100%
if time.hour > 5 and time.hour < 19 then
    if self.people ~= 0 then
        self.room:send("As the moon sets, the world shifts and the spring fades from view.")
        self.room:teleport_all(get_room(124, 0))
    end
end