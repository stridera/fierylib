-- Trigger: hellfire_brimstone_fiery_death
-- Zone: 23, ID: 11
-- Type: MOB, Flags: DEATH
-- Status: REVIEWED (DG room iteration converted)
--
-- Original DG Script: #2311
-- On a fiery-spirit death, ~40% chance to drop brimstone (23, 37) for any
-- player in the room who has the hellfire_brimstone quest active.
--
-- TODO(parity): get_quest_stage returns a stage number; legacy code's
-- truthiness check (any active stage) is preserved here, but the original
-- intent was likely stage 2 (the brimstone-collection phase). Confirm and
-- tighten to == 2 when the quest design is reviewed.
for _, person in ipairs(self.room.people) do
    if person:get_quest_stage("hellfire_brimstone") and random(1, 10) > 6 then
        self.room:spawn_object(23, 37)
    end
end