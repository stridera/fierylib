-- Trigger: connectfour select color
-- Zone: 60, ID: 63
-- Type: OBJECT, Flags: COMMAND
-- Status: CLEAN
--   Complex nesting: 7 if statements
--   Large script: 5212 chars
--
-- Original DG Script: #6063

-- Converted from DG Script #6063: connectfour select color
-- Original: OBJECT trigger, flags: COMMAND, probability: 4%

-- 4% chance to trigger
if not percent_chance(4) then
    return true
end

-- Command filter: select
if not (cmd == "select") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
-- switch on cmd
if cmd == "s" or cmd == "se" or cmd == "sel" then
    _return_value = false
    return _return_value
end
if (status == 0) and player1 and (actor.name == player1.name) then
    if arg == "red" then
        actor:send("You are the <b:red>red</> pieces!")
        self.room:send_except(actor, tostring(actor.name) .. " chooses to play with the <b:red>red</> pieces!")
        if player2 then
            player2:send("You are the <blue>&9black</> pieces!")
            self.room:send_except(player2, tostring(player2.name) .. " gets the <blue>&9black</> pieces.")
            actor:send("You get to go first!")
            local status = 1
            globals.status = globals.status or true
            local turn = 1
            globals.turn = globals.turn or true
        end
        local p1col = "&1&b"
        globals.p1col = globals.p1col or true
        local p2col = "&b&9"
        globals.p2col = globals.p2col or true
        local p1desc = "&1&bred&0"
        globals.p1desc = globals.p1desc or true
        local p2desc = "&b&9black&0"
        globals.p2desc = globals.p2desc or true
    elseif arg == "black" then
        actor:send("You are the <blue>&9black</> pieces!")
        self.room:send_except(actor, tostring(actor.name) .. " chooses to play with the <blue>&9black</> pieces!")
        if player2 then
            player2:send("You are the <b:red>red</> pieces!")
            self.room:send_except(player2, tostring(player2.name) .. " gets the <b:red>red</> pieces.")
            actor:send("You get to go first!")
            local status = 1
            globals.status = globals.status or true
            local turn = 1
            globals.turn = globals.turn or true
        end
        local p1col = "&b&9"
        globals.p1col = globals.p1col or true
        local p2col = "&1&b"
        globals.p2col = globals.p2col or true
        local p1desc = "&b&9black&0"
        globals.p1desc = globals.p1desc or true
        local p2desc = "&1&bred&0"
        globals.p2desc = globals.p2desc or true
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
else
    _return_value = false
end
return _return_value