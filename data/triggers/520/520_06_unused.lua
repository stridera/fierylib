-- Trigger: UNUSED
-- Zone: 520, ID: 6
-- Type: WORLD, Flags: PREENTRY
-- Status: NEEDS_REVIEW
--   Syntax error: luac: <UNUSED>:9: unexpected symbol near '.52059'
--
-- Original DG Script: #52006

-- Converted from DG Script #52006: UNUSED
-- Original: WORLD trigger, flags: PREENTRY, probability: 100%
-- hope this works as well as the theory
-- idea is that this trigger runs _before_ players
-- enter. Course it only calcs the size of the last
-- group to enter, so if a player comes in later
-- the global var gets scragged :-(
-- hehe if only room had an ID field this could be generic!
local peeps = get_room(520, 59).actor_count
wait(5)
local peeps = get_room(520, 59).actor_count - peeps
globals.peeps = globals.peeps or true