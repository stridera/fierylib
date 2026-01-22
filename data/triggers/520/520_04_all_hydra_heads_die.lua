-- Trigger: all_hydra_heads_die
-- Zone: 520, ID: 4
-- Type: WORLD, Flags: GLOBAL
-- Status: CLEAN
--
-- Original DG Script: #52004

-- Converted from DG Script #52004: all_hydra_heads_die
-- Original: WORLD trigger, flags: GLOBAL, probability: 100%
local person = self.people
while person do
    local next = person.next_in_room
    if person.id == 52009 then
        person:damage(50000)  -- type: physical
    end
    local person = next
end