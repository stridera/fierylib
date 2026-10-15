-- Trigger: hearts start
-- Zone: 60, ID: 75
-- Type: OBJECT, Flags: COMMAND
-- Status: CLEAN
--
-- Take a seat at the Hearts table.
-- The rules live in the "hearts" script library; the game state is in
-- this object's `globals` (see script_libraries/hearts.lua).
--
-- Original DG Script: #6075

-- Only while the object lies in the room (legacy OCMD_ROOM=4).
if location ~= "room" then
    return true  -- Not in a location this trigger watches
end

-- The engine expands abbreviations, so `cmd` is the full command word.
if cmd ~= "start" then
    return true  -- Not our command
end
local hearts = require("hearts")
return hearts.start(globals, self.room, actor, arg)
