-- Trigger: UNUSED
-- Zone: 520, ID: 6
-- Type: WORLD, Flags: PREENTRY
-- Status: UNUSED
--
-- Original DG Script: #52006
-- Marked UNUSED in source data; retained for parity. Counts how many actors
-- entered room 520:59 in the last 5 ticks and stashes the delta in a global
-- so a sibling trigger can scale a fight to the group size. Only valid for
-- the most recent entry burst (legacy author flagged this limitation).

local peeps_before = get_room(520, 59).actor_count
wait(5)
globals.peeps = get_room(520, 59).actor_count - peeps_before