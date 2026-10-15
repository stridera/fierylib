-- Trigger: connectfour leave
-- Zone: 60, ID: 84
-- Type: OBJECT, Flags: LEAVE
-- Status: CLEAN
--
-- A player walking out of the room forfeits their Connect Four game (or gives
-- up their seat) at once, instead of when somebody next uses the board.
-- New in the Lua rewrite: the DG scripts had no leave trigger and the rules
-- text promised "if you leave the room, you automatically forfeit".
-- The rules live in the "connectfour" script library; the game state is in
-- this object's `globals` (see script_libraries/connectfour.lua).

local connectfour = require("connectfour")
return connectfour.leave(globals, self.room, actor)
