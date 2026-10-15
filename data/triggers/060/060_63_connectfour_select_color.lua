-- Trigger: connectfour select color
-- Zone: 60, ID: 63
-- Type: OBJECT, Flags: COMMAND
--
-- TODO(parity): part of broken ConnectFour mini-game; see 060_61. Branch-scoped
-- `local p1col`/`p2col`/`p1desc`/`p2desc` writes are invisible to the rest of
-- the trigger family. Needs a full rewrite to server-side game state.
--
-- Original DG Script: #6063

-- Converted from DG Script #6063: connectfour select color
-- Original: OBJECT trigger, flags: COMMAND, probability: 4%

-- Command location mask 4: legacy OCMD_EQUIP=1 (worn), OCMD_INVEN=2 (carried), OCMD_ROOM=4 (floor)
if not (location == "room") then
    return true  -- Not in a location this trigger watches
end

-- Command filter: select
if not (cmd == "select") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
-- switch on cmd
do
    local _sw1 = string.lower(tostring(cmd or ""))
    if _sw1 == "s" or _sw1 == "se" or _sw1 == "sel" then
        _return_value = true
        return _return_value
    end
end
if (status == 0) and player1 and (actor.name == player1.name) then
    if arg == "red" then
        actor:send("You are the <b:red>red</> pieces!")
        self.room:send_except(actor, tostring(actor.name) .. " chooses to play with the <b:red>red</> pieces!")
        if player2 then
            player2:send("You are the <b:black>black</> pieces!")
            self.room:send_except(player2, tostring(player2.name) .. " gets the <b:black>black</> pieces.")
            actor:send("You get to go first!")
            local status = 1
            globals.status = status
            local turn = 1
            globals.turn = turn
        end
        local p1col = "<b:red>"
        globals.p1col = p1col
        local p2col = "<b:black>"
        globals.p2col = p2col
        local p1desc = "<b:red>red</>"
        globals.p1desc = p1desc
        local p2desc = "<b:black>black</>"
        globals.p2desc = p2desc
    elseif arg == "black" then
        actor:send("You are the <b:black>black</> pieces!")
        self.room:send_except(actor, tostring(actor.name) .. " chooses to play with the <b:black>black</> pieces!")
        if player2 then
            player2:send("You are the <b:red>red</> pieces!")
            self.room:send_except(player2, tostring(player2.name) .. " gets the <b:red>red</> pieces.")
            actor:send("You get to go first!")
            local status = 1
            globals.status = status
            local turn = 1
            globals.turn = turn
        end
        local p1col = "<b:black>"
        globals.p1col = p1col
        local p2col = "<b:red>"
        globals.p2col = p2col
        local p1desc = "<b:black>black</>"
        globals.p1desc = p1desc
        local p2desc = "<b:red>red</>"
        globals.p2desc = p2desc
    else
        actor:send("You may only select 'red' or 'black'.")
    end
    local a1 = "O"
    local a2 = "O"
    local a3 = "O"
    local a4 = "O"
    local a5 = "O"
    local a6 = "O"
    local a7 = "O"
    local b1 = "O"
    local b2 = "O"
    local b3 = "O"
    local b4 = "O"
    local b5 = "O"
    local b6 = "O"
    local b7 = "O"
    local c1 = "O"
    local c2 = "O"
    local c3 = "O"
    local c4 = "O"
    local c5 = "O"
    local c6 = "O"
    local c7 = "O"
    local d1 = "O"
    local d2 = "O"
    local d3 = "O"
    local d4 = "O"
    local d5 = "O"
    local d6 = "O"
    local d7 = "O"
    local e1 = "O"
    local e2 = "O"
    local e3 = "O"
    local e4 = "O"
    local e5 = "O"
    local e6 = "O"
    local e7 = "O"
    local f1 = "O"
    local f2 = "O"
    local f3 = "O"
    local f4 = "O"
    local f5 = "O"
    local f6 = "O"
    local f7 = "O"
    local g1 = "O"
    local g2 = "O"
    local g3 = "O"
    local g4 = "O"
    local g5 = "O"
    local g6 = "O"
    local g7 = "O"
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
else
    _return_value = true
end
return _return_value