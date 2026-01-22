-- Trigger: smothering_avalanche
-- Zone: 534, ID: 1
-- Type: WORLD, Flags: RANDOM
-- Status: CLEAN
--
-- Original DG Script: #53401

-- Converted from DG Script #53401: smothering_avalanche
-- Original: WORLD trigger, flags: RANDOM, probability: 100%
local person = self.people
while person do
    local next = people.next_in_room
    local tithe = person.level * 2
    person:send("You are finding it harder to breathe now...and you can feel your life ebbing away.")
    local damage_dealt = person:damage(tithe)  -- type: physical
    local person = next
end