-- Trigger: hearts look table
-- Zone: 60, ID: 80
-- Type: OBJECT, Flags: COMMAND
-- Status: CLEAN
--
-- Look at the cards played this trick.
-- The rules live in the "hearts" script library; the game state is in
-- this object's `globals` (see script_libraries/hearts.lua).
--
-- Original DG Script: #6080

-- Only while the object lies in the room (legacy OCMD_ROOM=4).
if location ~= "room" then
    return true  -- Not in a location this trigger watches
end

-- The engine expands abbreviations, so `cmd` is the full command word.
if cmd ~= "look" then
    return true  -- Not our command
end
local hearts = require("hearts")
return hearts.look(globals, self.room, actor, arg)
