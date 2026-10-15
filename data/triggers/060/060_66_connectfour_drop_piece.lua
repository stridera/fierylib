-- Trigger: connectfour drop piece
-- Zone: 60, ID: 66
-- Type: OBJECT, Flags: COMMAND
-- Status: CLEAN
--
-- Drop a piece into a column.
-- The rules live in the "connectfour" script library; the game state is in
-- this object's `globals` (see script_libraries/connectfour.lua).
--
-- Original DG Script: #6066

-- Only while the object lies in the room (legacy OCMD_ROOM=4).
if location ~= "room" then
    return true  -- Not in a location this trigger watches
end

-- The engine expands abbreviations, so `cmd` is the full command word.
if cmd ~= "drop" then
    return true  -- Not our command
end
local connectfour = require("connectfour")
return connectfour.drop(globals, self.room, actor, arg)
