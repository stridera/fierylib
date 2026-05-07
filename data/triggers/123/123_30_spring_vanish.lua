-- Trigger: spring_vanish
-- Zone: 123, ID: 30
-- Type: WORLD, Flags: RANDOM
-- Status: CLEAN
--
-- Original DG Script: #12330

-- Converted from DG Script #12330: spring_vanish
-- Original: WORLD trigger, flags: RANDOM, probability: 100%
if time.hour > 5 and time.hour < 19 then
    -- self.people in DG was an integer count; in the new runtime,
    -- self.room.people is a list head. Treat presence as truthy.
    if self.room.people then
        self.room:send("As the moon sets, the world shifts and the spring fades from view.")
        self.room:teleport_all(get_room(123, 100))
    end
end