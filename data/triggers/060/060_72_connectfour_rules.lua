-- Trigger: connectfour rules
-- Zone: 60, ID: 72
-- Type: OBJECT, Flags: COMMAND
-- Status: CLEAN
--
-- Show the rules.
-- The rules live in the "connectfour" script library; the game state is in
-- this object's `globals` (see data/script_libraries/connectfour.lua).
--
-- Original DG Script: #6072

-- Only while the object lies in the room (legacy OCMD_ROOM=4).
if location ~= "room" then
    return true  -- Not in a location this trigger watches
end

-- The engine expands abbreviations, so `cmd` is the full command word.
if cmd ~= "rules" then
    return true  -- Not our command
end
local connectfour = require("connectfour")
return connectfour.rules(globals, self.room, actor, arg)
