-- Trigger: Clean_room_echo
-- Zone: 16, ID: 79
-- Type: WORLD, Flags: RANDOM
-- Status: CLEAN
--
-- Original DG Script: #1679

-- Converted from DG Script #1679: Clean_room_echo
-- Original: WORLD trigger, flags: RANDOM, probability: 50%

-- 50% chance to trigger
if not percent_chance(50) then
    return true
end
if self.actor_count then
    self.room:send("A large arm swings over your head, spraying you with a chemical mix.")
end