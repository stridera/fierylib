-- Trigger: connectfour reset game
-- Zone: 60, ID: 68
-- Type: OBJECT, Flags: COMMAND
--
-- TODO(parity): part of broken ConnectFour mini-game; see 060_61. The reset
-- writes are all branch-scoped `local` — invisible to other triggers. Needs a
-- full rewrite to clear server-side game state.
--
-- Original DG Script: #6068

-- Converted from DG Script #6068: connectfour reset game
-- Original: OBJECT trigger, flags: COMMAND, probability: 4%

-- Command location mask 4: legacy OCMD_EQUIP=1 (worn), OCMD_INVEN=2 (carried), OCMD_ROOM=4 (floor)
if not (location == "room") then
    return true  -- Not in a location this trigger watches
end

-- Command filter: reset
if not (cmd == "reset") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
-- switch on cmd
do
    local _sw1 = string.lower(tostring(cmd or ""))
    if _sw1 == "r" or _sw1 == "re" or _sw1 == "res" then
        _return_value = true
        return _return_value
    end
end
if status == 2 then
    self.room:send("Resetting ConnectFour.")
    local a1 = 0
    local a2 = 0
    local a3 = 0
    local a4 = 0
    local a5 = 0
    local a6 = 0
    local a7 = 0
    local b1 = 0
    local b2 = 0
    local b3 = 0
    local b4 = 0
    local b5 = 0
    local b6 = 0
    local b7 = 0
    local c1 = 0
    local c2 = 0
    local c3 = 0
    local c4 = 0
    local c5 = 0
    local c6 = 0
    local c7 = 0
    local d1 = 0
    local d2 = 0
    local d3 = 0
    local d4 = 0
    local d5 = 0
    local d6 = 0
    local d7 = 0
    local e1 = 0
    local e2 = 0
    local e3 = 0
    local e4 = 0
    local e5 = 0
    local e6 = 0
    local e7 = 0
    local f1 = 0
    local f2 = 0
    local f3 = 0
    local f4 = 0
    local f5 = 0
    local f6 = 0
    local f7 = 0
    local g1 = 0
    local g2 = 0
    local g3 = 0
    local g4 = 0
    local g5 = 0
    local g6 = 0
    local g7 = 0
    local player1 = 0
    local player2 = 0
    local status = 0
    local p1col = 0
    local p2col = 0
    local p1desc = 0
    local p2desc = 0
    local p1win = 0
    local p2win = 0
    local p1forfeit = 0
    local p2forfeit = 0
    -- Fragment (possible truncation): set turn
    globals.a1 = a1
    globals.a2 = a2
    globals.a3 = a3
    globals.a4 = a4
    globals.a5 = a5
    globals.a6 = a6
    globals.a7 = a7
    globals.b1 = b1
    globals.b2 = b2
    globals.b3 = b3
    globals.b4 = b4
    globals.b5 = b5
    globals.b6 = b6
    globals.b7 = b7
    globals.c1 = c1
    globals.c2 = c2
    globals.c3 = c3
    globals.c4 = c4
    globals.c5 = c5
    globals.c6 = c6
    globals.c7 = c7
    globals.d1 = d1
    globals.d2 = d2
    globals.d3 = d3
    globals.d4 = d4
    globals.d5 = d5
    globals.d6 = d6
    globals.d7 = d7
    globals.e1 = e1
    globals.e2 = e2
    globals.e3 = e3
    globals.e4 = e4
    globals.e5 = e5
    globals.e6 = e6
    globals.e7 = e7
    globals.f1 = f1
    globals.f2 = f2
    globals.f3 = f3
    globals.f4 = f4
    globals.f5 = f5
    globals.f6 = f6
    globals.f7 = f7
    globals.g1 = g1
    globals.g2 = g2
    globals.g3 = g3
    globals.g4 = g4
    globals.g5 = g5
    globals.g6 = g6
    globals.g7 = g7
    globals.player1 = player1
    globals.player2 = player2
    globals.status = status
    globals.p1col = p1col
    globals.p2col = p2col
    globals.p1desc = p1desc
    globals.p2desc = p2desc
    globals.p1win = p1win
    globals.p2win = p2win
    globals.p1forfeit = p1forfeit
    globals.p2forfeit = p2forfeit
    -- (the DG `set turn ...` was truncated by the converter; the first player moves first)
    self.room:send("Board cleared.")
elseif status == 1 then
    if (actor.name == player1.name) or (actor.name == player2.name) then
        actor:send("If you want to end the game, forfeit first, then reset.")
    else
        actor:send("Wait until " .. tostring(player1.name) .. " and " .. tostring(player2.name) .. " are done playing!")
    end
elseif status == 0 then
    if player1 and (actor.name == player1.name) then
        actor:send("You can't reset the board until the game is over.")
    else
        actor:send("The board is already cleared!")
    end
end
return _return_value