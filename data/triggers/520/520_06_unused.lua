-- Trigger: UNUSED
-- Zone: 520, ID: 6
-- Type: WORLD, Flags: PREENTRY
-- Status: CLEAN
--
-- Original DG Script: #52006

-- Converted from DG Script #52006: UNUSED
-- Original: WORLD trigger, flags: PREENTRY, probability: 100%
-- hope this works as well as the theory
-- idea is that this trigger runs _before_ players
-- enter. Course it only calcs the size of the last
-- group to enter, so if a player comes in later
-- the global var gets scragged :-(
-- hehe if only room had a vnum field this could be generic!
local peeps = people.52059
wait(5)
local peeps = people.52059 - peeps
globals.peeps = globals.peeps or true