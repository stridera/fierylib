-- Trigger: guardian_of_book_reset
-- Zone: 510, ID: 10
-- Type: OBJECT, Flags: DROP
--
-- Original DG Script: #51010
-- Clears the `alreadyrun` latch set by 510_09 so the next pick-up
-- re-spawns a fresh guardian.
globals.alreadyrun = nil
