-- Trigger: connectfour look board
-- Zone: 60, ID: 64
-- Type: OBJECT, Flags: COMMAND
-- Status: CLEAN
--
-- Look at the board and who is playing.
-- The rules live in the "connectfour" script library; the game state is in
-- this object's `globals` (see script_libraries/connectfour.lua).
--
-- Original DG Script: #6064

-- Only while the object lies in the room (legacy OCMD_ROOM=4).
if location ~= "room" then
    return true  -- Not in a location this trigger watches
end

-- The engine expands abbreviations, so `cmd` is the full command word.
if cmd ~= "look" then
    return true  -- Not our command
end
local connectfour = require("connectfour")
return connectfour.look(globals, self.room, actor, arg)
