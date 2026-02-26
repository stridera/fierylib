-- Trigger: connectfour reset game
-- Zone: 60, ID: 68
-- Type: OBJECT, Flags: COMMAND
-- Status: NEEDS_REVIEW
--   Complex nesting: 6 if statements
--
-- Original DG Script: #6068

-- Converted from DG Script #6068: connectfour reset game
-- Original: OBJECT trigger, flags: COMMAND, probability: 4%

-- 4% chance to trigger
if not percent_chance(4) then
    return true
end

-- Command filter: reset
if not (cmd == "reset") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
-- switch on cmd
if cmd == "r" or cmd == "re" or cmd == "res" then
    _return_value = false
    return _return_value
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
    globals.a1 = globals.a1 or true
    globals.a2 = globals.a2 or true
    globals.a3 = globals.a3 or true
    globals.a4 = globals.a4 or true
    globals.a5 = globals.a5 or true
    globals.a6 = globals.a6 or true
    globals.a7 = globals.a7 or true
    globals.b1 = globals.b1 or true
    globals.b2 = globals.b2 or true
    globals.b3 = globals.b3 or true
    globals.b4 = globals.b4 or true
    globals.b5 = globals.b5 or true
    globals.b6 = globals.b6 or true
    globals.b7 = globals.b7 or true
    globals.c1 = globals.c1 or true
    globals.c2 = globals.c2 or true
    globals.c3 = globals.c3 or true
    globals.c4 = globals.c4 or true
    globals.c5 = globals.c5 or true
    globals.c6 = globals.c6 or true
    globals.c7 = globals.c7 or true
    globals.d1 = globals.d1 or true
    globals.d2 = globals.d2 or true
    globals.d3 = globals.d3 or true
    globals.d4 = globals.d4 or true
    globals.d5 = globals.d5 or true
    globals.d6 = globals.d6 or true
    globals.d7 = globals.d7 or true
    globals.e1 = globals.e1 or true
    globals.e2 = globals.e2 or true
    globals.e3 = globals.e3 or true
    globals.e4 = globals.e4 or true
    globals.e5 = globals.e5 or true
    globals.e6 = globals.e6 or true
    globals.e7 = globals.e7 or true
    globals.f1 = globals.f1 or true
    globals.f2 = globals.f2 or true
    globals.f3 = globals.f3 or true
    globals.f4 = globals.f4 or true
    globals.f5 = globals.f5 or true
    globals.f6 = globals.f6 or true
    globals.f7 = globals.f7 or true
    globals.g1 = globals.g1 or true
    globals.g2 = globals.g2 or true
    globals.g3 = globals.g3 or true
    globals.g4 = globals.g4 or true
    globals.g5 = globals.g5 or true
    globals.g6 = globals.g6 or true
    globals.g7 = globals.g7 or true
    globals.player1 = globals.player1 or true
    globals.player2 = globals.player2 or true
    globals.status = globals.status or true
    globals.p1col = globals.p1col or true
    globals.p2col = globals.p2col or true
    globals.p1desc = globals.p1desc or true
    globals.p2desc = globals.p2desc or true
    globals.p1win = globals.p1win or true
    globals.p2win = globals.p2win or true
    globals.p1forfeit = globals.p1forfeit or true
    globals.p2forfeit = globals.p2forfeit or true
    globals.turn = globals.turn or true
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