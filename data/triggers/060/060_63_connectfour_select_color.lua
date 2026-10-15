-- Trigger: connectfour select color
-- Zone: 60, ID: 63
-- Type: OBJECT, Flags: COMMAND
-- Status: CLEAN
--
-- Player 1 picks red or black.
-- The rules live in the "connectfour" script library; the game state is in
-- this object's `globals` (see script_libraries/connectfour.lua).
--
-- Original DG Script: #6063

-- Only while the object lies in the room (legacy OCMD_ROOM=4).
if location ~= "room" then
    return true  -- Not in a location this trigger watches
end

-- The engine expands abbreviations, so `cmd` is the full command word.
if cmd ~= "select" then
    return true  -- Not our command
end
local connectfour = require("connectfour")
return connectfour.select(globals, self.room, actor, arg)
