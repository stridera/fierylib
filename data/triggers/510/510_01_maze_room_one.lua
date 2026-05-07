-- Trigger: maze_room_one
-- Zone: 510, ID: 1
-- Type: WORLD, Flags: PREENTRY
--
-- Original DG Script: #51001
-- On first entry into a maze room, randomly wires 1-6 of the six
-- compass exits to other maze rooms (510, 71..76), with a 30% chance
-- of an "up" exit out of the maze entirely (to 510, 77). Re-arms the
-- room after a short cooldown.

-- TODO(parity): The Lua runtime does not yet expose dynamic exit/door
-- mutation (no `room:exit(dir):set_destination(room)` /
-- `:set_state{hidden = ..., description = ...}`). The original intent:
--   1. Hide all six compass exits.
--   2. Pick `exitsreq` = random(1, 6) and randomly assign that many
--      directions to a random destination in (510, 71..76), each with
--      description "The entrance wavers slightly as you look at it."
--   3. With 30% probability also set `up` to (510, 77) with description
--      "This doorway looks more solid than the others." (the maze exit).
--   4. After 1 tick, clear the `exitdone` global so the next group
--      passing through re-rolls.
-- Restore the body below when the door-mutation API lands.

if exitdone == 1 then
    return true
end
exitdone = 1

-- Placeholder: keep the gate so we don't busy-loop, but the maze
-- shuffle itself is a no-op until the door API exists.
wait(1)
exitdone = nil
