-- Trigger: hearts leave
-- Zone: 60, ID: 85
-- Type: OBJECT, Flags: LEAVE
-- Status: CLEAN
--
-- A seated player walking out of the room calls the Hearts game off at once,
-- instead of when somebody next uses the table.
-- New in the Lua rewrite: the DG scripts had no leave trigger.
-- The rules live in the "hearts" script library; the game state is in
-- this object's `globals` (see script_libraries/hearts.lua).

local hearts = require("hearts")
return hearts.leave(globals, self.room, actor)
