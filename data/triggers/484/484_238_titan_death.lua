-- Trigger: titan death
-- Zone: 484, ID: 238
-- Type: MOB, Flags: DEATH
-- Status: CLEAN
--
-- Original DG Script: #48638

-- Converted from DG Script #48638: titan death
-- Original: MOB trigger, flags: DEATH, probability: 100%
-- TODO(parity): has_equipped takes (zone_id, local_id), not a vnum
--   string. The legacy vnum 48424 corresponds to (484, 24) — Timun's
--   golden sphere — but verify against the converted catalog before
--   trusting this mapping.
if self:has_equipped(484, 24) then
    -- get rid of the staff sphere and load the key one
    self:destroy_item("timuns-golden-sphere")
    self.room:spawn_object(484, 22)
end