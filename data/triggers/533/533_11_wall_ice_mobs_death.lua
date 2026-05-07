-- Trigger: wall_ice_mobs_death
-- Zone: 533, ID: 11
-- Type: MOB, Flags: DEATH
-- Status: NEEDS_REVIEW
--
-- Original DG Script: #53311
--
-- On death, if this ice creature was successfully crystalized (flag
-- set by trigger 533/10), drop a block of living ice (533, 27) into
-- the room.
--
-- TODO: Original used a global `ice` variable set on the mob. Pairs
-- with companion trigger 533/10. Verify the per-mob flag survives
-- between the speech trigger firing and death.

if self.flags and self.flags.ice_crystalize_success then
    self.room:spawn_object(533, 27)
end
