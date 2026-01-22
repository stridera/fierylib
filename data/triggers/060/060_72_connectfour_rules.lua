-- Trigger: connectfour rules
-- Zone: 60, ID: 72
-- Type: OBJECT, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #6072

-- Converted from DG Script #6072: connectfour rules
-- Original: OBJECT trigger, flags: COMMAND, probability: 4%

-- 4% chance to trigger
if not percent_chance(4) then
    return true
end

-- Command filter: rules
if not (cmd == "rules") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
-- switch on cmd
if cmd == "r" or cmd == "ru" then
    _return_value = false
    return _return_value
end
actor:send("Playing Connect Four is simple!  Your goal is simply to get four of your pieces")
actor:send("in a line before your opponent.  The pieces can be horizontal, vertical, or")
actor:send("even diagonal.")
actor:send("</>")
actor:send("To begin a game, you and a friend must type 'start' in the room with the game.")
actor:send("Whoever starts first gets to select their color, red or black.  The second")
actor:send("player automatically gets the other color.  If you type 'start' first, you also")
actor:send("get the first turn.")
actor:send("</>")
actor:send("At any time, you can 'look board' to see what the board looks like.")
actor:send("</>")
actor:send("On your turn, you can 'drop' a piece into one of the 7 columns.  For instance,")
actor:send("if you want to drop a piece in the third column, you'd type 'drop 3'.  The")
actor:send("piece will then fall down to the bottom of the third column.  If the column is")
actor:send("full, you'll have to pick another one.")
actor:send("</>")
actor:send("During the game, you may use the 'forfeit' command to end the game.  If you")
actor:send("leave the room, you automatically forfeit.")
actor:send("</>")
actor:send("Once a game is over, either by someone winning or forfeiture, anyone in the")
actor:send("room can use the 'reset' command to clear the board to start a new game.")
return _return_value