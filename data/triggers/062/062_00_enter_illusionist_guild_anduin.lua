-- Trigger: Enter Illusionist Guild Anduin
-- Zone: 62, ID: 0
-- Type: WORLD, Flags: COMMAND
--
-- A WORLD command trigger that catches the "south" command in this room and
-- shuttles the actor through the hidden south exit of room (62, 4) into the
-- Illusionist Guild, leaving the door closed behind them.
--
-- Original DG Script: #6200

-- Command filter: south
if not (cmd == "south") then
    return true  -- Not our command
end
-- Temporarily unhide the south exit, walk the actor through it, then re-hide it.
-- Returning false here suppresses the original "south" command since we already moved them.
get_room(62, 4):exit("south"):set_state({hidden = false})
actor:move("south")
get_room(62, 4):exit("south"):set_state({hidden = true})
return false