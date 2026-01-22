-- Trigger: connectfour drop piece
-- Zone: 60, ID: 66
-- Type: OBJECT, Flags: COMMAND
-- Status: NEEDS_REVIEW
--   Complex nesting: 21 if statements
--   Large script: 8646 chars
--
-- Original DG Script: #6066

-- Converted from DG Script #6066: connectfour drop piece
-- Original: OBJECT trigger, flags: COMMAND, probability: 4%

-- 4% chance to trigger
if not percent_chance(4) then
    return true
end

-- Command filter: drop
if not (cmd == "drop") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
-- switch on cmd
if cmd == "d" or cmd == "dr" then
    _return_value = false
    return _return_value
end
if (actor.name == player1.name) or (actor.name == player2.name) then
    if status == 0 then
        actor:send("The game hasn't started yet!")
        return _return_value
    elseif status == 2 then
        actor:send("The game is already over!")
        return _return_value
    end
end
if actor.name == player1.name then
    if turn ~= 1 then
        actor:send("It's not your turn!")
        return _return_value
    end
    local piece = p1colO&0
elseif actor.name == player2.name then
    if turn ~= 2 then
        actor:send("It's not your turn!")
        return _return_value
    end
    local piece = p2colO&0
else
    _return_value = false
    return _return_value
end
if arg == 1 then
    if g1 == "O" then
        local g1 = piece
        globals.g1 = globals.g1 or true
    elseif f1 == "O" then
        local f1 = piece
        globals.f1 = globals.f1 or true
    elseif e1 == "O" then
        local e1 = piece
        globals.e1 = globals.e1 or true
    elseif d1 == "O" then
        local d1 = piece
        globals.d1 = globals.d1 or true
    elseif c1 == "O" then
        local c1 = piece
        globals.c1 = globals.c1 or true
    elseif b1 == "O" then
        local b1 = piece
        globals.b1 = globals.b1 or true
    elseif a1 == "O" then
        local a1 = piece
        globals.a1 = globals.a1 or true
    else
        local full = 1
    end
elseif arg == 2 then
    if g2 == "O" then
        local g2 = piece
        globals.g2 = globals.g2 or true
    elseif f2 == "O" then
        local f2 = piece
        globals.f2 = globals.f2 or true
    elseif e2 == "O" then
        local e2 = piece
        globals.e2 = globals.e2 or true
    elseif d2 == "O" then
        local d2 = piece
        globals.d2 = globals.d2 or true
    elseif c2 == "O" then
        local c2 = piece
        globals.c2 = globals.c2 or true
    elseif b2 == "O" then
        local b2 = piece
        globals.b2 = globals.b2 or true
    elseif a2 == "O" then
        local a2 = piece
        globals.a2 = globals.a2 or true
    else
        local full = 1
    end
elseif arg == 3 then
    if g3 == "O" then
        local g3 = piece
        globals.g3 = globals.g3 or true
    elseif f3 == "O" then
        local f3 = piece
        globals.f3 = globals.f3 or true
    elseif e3 == "O" then
        local e3 = piece
        globals.e3 = globals.e3 or true
    elseif d3 == "O" then
        local d3 = piece
        globals.d3 = globals.d3 or true
    elseif c3 == "O" then
        local c3 = piece
        globals.c3 = globals.c3 or true
    elseif b3 == "O" then
        local b3 = piece
        globals.b3 = globals.b3 or true
    elseif a3 == "O" then
        local a3 = piece
        globals.a3 = globals.a3 or true
    else
        local full = 1
    end
elseif arg == 4 then
    if g4 == "O" then
        local g4 = piece
        globals.g4 = globals.g4 or true
    elseif f4 == "O" then
        local f4 = piece
        globals.f4 = globals.f4 or true
    elseif e4 == "O" then
        local e4 = piece
        globals.e4 = globals.e4 or true
    elseif d4 == "O" then
        local d4 = piece
        globals.d4 = globals.d4 or true
    elseif c4 == "O" then
        local c4 = piece
        globals.c4 = globals.c4 or true
    elseif b4 == "O" then
        local b4 = piece
        globals.b4 = globals.b4 or true
    elseif a4 == "O" then
        local a4 = piece
        globals.a4 = globals.a4 or true
    else
        local full = 1
    end
elseif arg == 5 then
    if g5 == "O" then
        local g5 = piece
        globals.g5 = globals.g5 or true
    elseif f5 == "O" then
        local f5 = piece
        globals.f5 = globals.f5 or true
    elseif e5 == "O" then
        local e5 = piece
        globals.e5 = globals.e5 or true
    elseif d5 == "O" then
        local d5 = piece
        globals.d5 = globals.d5 or true
    elseif c5 == "O" then
        local c5 = piece
        globals.c5 = globals.c5 or true
    elseif b5 == "O" then
        local b5 = piece
        globals.b5 = globals.b5 or true
    elseif a5 == "O" then
        local a5 = piece
        globals.a5 = globals.a5 or true
    else
        local full = 1
    end
elseif arg == 6 then
    if g6 == "O" then
        local g6 = piece
        globals.g6 = globals.g6 or true
    elseif f6 == "O" then
        local f6 = piece
        globals.f6 = globals.f6 or true
    elseif e6 == "O" then
        local e6 = piece
        globals.e6 = globals.e6 or true
    elseif d6 == "O" then
        local d6 = piece
        globals.d6 = globals.d6 or true
    elseif c6 == "O" then
        local c6 = piece
        globals.c6 = globals.c6 or true
    elseif b6 == "O" then
        local b6 = piece
        globals.b6 = globals.b6 or true
    elseif a6 == "O" then
        local a6 = piece
        globals.a6 = globals.a6 or true
    else
        local full = 1
    end
elseif arg == 7 then
    if g7 == "O" then
        local g7 = piece
        globals.g7 = globals.g7 or true
    elseif f7 == "O" then
        local f7 = piece
        globals.f7 = globals.f7 or true
    elseif e7 == "O" then
        local e7 = piece
        globals.e7 = globals.e7 or true
    elseif d7 == "O" then
        local d7 = piece
        globals.d7 = globals.d7 or true
    elseif c7 == "O" then
        local c7 = piece
        globals.c7 = globals.c7 or true
    elseif b7 == "O" then
        local b7 = piece
        globals.b7 = globals.b7 or true
    elseif a7 == "O" then
        local a7 = piece
        globals.a7 = globals.a7 or true
    else
        local full = 1
    end
else
    actor:send("Drop a piece in where!?")
    return _return_value
end
if full then
    actor:send("Column " .. tostring(arg) .. " is full!  Try a different one.")
    return _return_value
end
actor:send("You drop a piece in column " .. tostring(arg) .. ".")
self.room:send_except(actor, tostring(actor.name) .. " drops a piece in column " .. tostring(arg) .. ".")
local row1 = a1a2a3a4a5a6a7
local row2 = b1b2b3b4b5b6b7
local row3 = c1c2c3c4c5c6c7
local row4 = d1d2d3d4d5d6d7
local row5 = e1e2e3e4e5e6e7
local row6 = f1f2f3f4f5f6f7
local row7 = g1g2g3g4g5g6g7
local col1 = a1b1c1d1e1f1g1
local col2 = a2b2c2d2e2f2g2
local col3 = a3b3c3d3e3f3g3
local col4 = a4b4c4d4e4f4g4
local col5 = a5b5c5d5e5f5g5
local col6 = a6b6c6d6e6f6g6
local col7 = a7b7c7d7e7f7g7
local dnw1 = d1e2f3g4
local dnw2 = c1d2e3f4g5
local dnw3 = b1c2d3e4f5g6
local dnw4 = a1b2c3d4e5f6g7
local dnw5 = a2b3c4d5e6f7
local dnw6 = a3b4c5d6e7
local dnw7 = a4b5c6d7
local dne1 = a4b3c2d1
local dne2 = a5b4c3d2e1
local dne3 = a6b5c4d3e2f1
local dne4 = a7b6c5d4e3f2g1
local dne5 = b7c6d5e4f3g2
local dne6 = c7d6e5f4g3
local dne7 = d7e6f5g4
local streak = piecepiecepiecepiece
if (string.find(row1, "streak")) or (string.find(row2, "streak")) or (string.find(row3, "streak")) or (string.find(row4, "streak")) or (string.find(row5, "streak")) or (string.find(row6, "streak")) or (string.find(row7, "streak")) then
    local win = 1
elseif (string.find(col1, "streak")) or (string.find(col2, "streak")) or (string.find(col3, "streak")) or (string.find(col4, "streak")) or (string.find(col5, "streak")) or (string.find(col6, "streak")) or (string.find(col7, "streak")) then
    local win = 1
elseif (string.find(dnw1, "streak")) or (string.find(dnw2, "streak")) or (string.find(dnw3, "streak")) or (string.find(dnw4, "streak")) or (string.find(dnw5, "streak")) or (string.find(dnw6, "streak")) or (string.find(dnw7, "streak")) then
    local win = 1
elseif (string.find(dne1, "streak")) or (string.find(dne2, "streak")) or (string.find(dne3, "streak")) or (string.find(dne4, "streak")) or (string.find(dne5, "streak")) or (string.find(dne6, "streak")) or (string.find(dne7, "streak")) then
    local win = 1
end
if win then
    actor:send("You win!")
    self.room:send_except(actor, tostring(actor.name) .. " wins!")
    if player1.name == actor.name then
        local p1win = 1
        globals.p1win = globals.p1win or true
    else
        local p2win = 1
        globals.p2win = globals.p2win or true
    end
    local status = 2
    globals.status = globals.status or true
end
if turn == 1 then
    local turn = 2
else
    local turn = 1
end
globals.turn = globals.turn or true
return _return_value