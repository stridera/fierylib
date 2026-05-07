-- Trigger: all_hydra_heads_die
-- Zone: 520, ID: 4
-- Type: WORLD, Flags: GLOBAL
-- Status: CLEAN
--
-- Original DG Script: #52004

-- Converted from DG Script #52004: all_hydra_heads_die
-- Original: WORLD trigger, flags: GLOBAL, probability: 100%
-- Walk every actor in the room and slay any remaining hydra-head mobile (520:9).
-- Used by hydra_death_cry (520:3) so killing the body cleans up loose heads.
local person = self.people
while person do
    local next_person = person.next_in_room
    if person.zone_id == 520 and person.local_id == 9 then
        person:damage(50000)  -- physical, lethal
    end
    person = next_person
end