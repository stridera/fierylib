-- Trigger: smothering_avalanche
-- Zone: 534, ID: 1
-- Type: WORLD, Flags: RANDOM
-- Status: CLEAN
--
-- Original DG Script: #53401

-- Converted from DG Script #53401: smothering_avalanche
-- Original: WORLD trigger, flags: RANDOM, probability: 100%
-- TODO(parity): original DG iterated room people via .people / .next_in_room
-- and dealt level*2 physical damage to each (suffocation under snow). Runtime
-- API exposes room.actors as a list; rewrite once iteration semantics are
-- confirmed (does damage during iteration mutate the list?).
for _, person in ipairs(self.room.actors) do
    local tithe = person.level * 2
    person:send("You are finding it harder to breathe now...and you can feel your life ebbing away.")
    person:damage(tithe)  -- type: physical
end