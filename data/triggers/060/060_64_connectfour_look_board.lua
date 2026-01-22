-- Trigger: connectfour look board
-- Zone: 60, ID: 64
-- Type: OBJECT, Flags: COMMAND
-- Status: CLEAN
--   Complex nesting: 20 if statements
--   Large script: 6541 chars
--
-- Original DG Script: #6064

-- Converted from DG Script #6064: connectfour look board
-- Original: OBJECT trigger, flags: COMMAND, probability: 4%

-- 4% chance to trigger
if not percent_chance(4) then
    return true
end

-- Command filter: look
if not (cmd == "look") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
if (arg ~= "board") and (arg ~= "connectfour") and (arg ~= "game") then
    _return_value = false
    return _return_value
end
actor:send("<blue> Connect Four!</>")
actor:send("</>")
actor:send("<blue>+-+-+-+-+-+-+-+</>")
actor:send("<blue>|1|2|3|4|5|6|7|</>")
actor:send("<blue>+-+-+-+-+-+-+-+</>")
actor:send("<blue>|" .. tostring(a1) .. "<blue>|" .. tostring(a2) .. "<blue>|" .. tostring(a3) .. "<blue>|" .. tostring(a4) .. "<blue>|" .. tostring(a5) .. "<blue>|" .. tostring(a6) .. "<blue>|" .. tostring(a7) .. "<blue>|</>")
actor:send("<blue>+-+-+-+-+-+-+-+</>")
actor:send("<blue>|" .. tostring(b1) .. "<blue>|" .. tostring(b2) .. "<blue>|" .. tostring(b3) .. "<blue>|" .. tostring(b4) .. "<blue>|" .. tostring(b5) .. "<blue>|" .. tostring(b6) .. "<blue>|" .. tostring(b7) .. "<blue>|</>")
actor:send("<blue>+-+-+-+-+-+-+-+</>")
actor:send("<blue>|" .. tostring(c1) .. "<blue>|" .. tostring(c2) .. "<blue>|" .. tostring(c3) .. "<blue>|" .. tostring(c4) .. "<blue>|" .. tostring(c5) .. "<blue>|" .. tostring(c6) .. "<blue>|" .. tostring(c7) .. "<blue>|</>")
actor:send("<blue>+-+-+-+-+-+-+-+</>")
actor:send("<blue>|" .. tostring(d1) .. "<blue>|" .. tostring(d2) .. "<blue>|" .. tostring(d3) .. "<blue>|" .. tostring(d4) .. "<blue>|" .. tostring(d5) .. "<blue>|" .. tostring(d6) .. "<blue>|" .. tostring(d7) .. "<blue>|</>")
actor:send("<blue>+-+-+-+-+-+-+-+</>")
actor:send("<blue>|" .. tostring(e1) .. "<blue>|" .. tostring(e2) .. "<blue>|" .. tostring(e3) .. "<blue>|" .. tostring(e4) .. "<blue>|" .. tostring(e5) .. "<blue>|" .. tostring(e6) .. "<blue>|" .. tostring(e7) .. "<blue>|</>")
actor:send("<blue>+-+-+-+-+-+-+-+</>")
actor:send("<blue>|" .. tostring(f1) .. "<blue>|" .. tostring(f2) .. "<blue>|" .. tostring(f3) .. "<blue>|" .. tostring(f4) .. "<blue>|" .. tostring(f5) .. "<blue>|" .. tostring(f6) .. "<blue>|" .. tostring(f7) .. "<blue>|</>")
actor:send("<blue>+-+-+-+-+-+-+-+</>")
actor:send("<blue>|" .. tostring(g1) .. "<blue>|" .. tostring(g2) .. "<blue>|" .. tostring(g3) .. "<blue>|" .. tostring(g4) .. "<blue>|" .. tostring(g5) .. "<blue>|" .. tostring(g6) .. "<blue>|" .. tostring(g7) .. "<blue>|</>")
actor:send("<blue>+-+-+-+-+-+-+-+</>")
actor:send("</>")
if status == 0 then
    if player1 then
        if player2 then
            if player1.name == actor.name then
                actor:send("You and " .. tostring(player2.name) .. " are getting ready to start a game!")
                actor:send("You need to choose a color!  Say 'red' or 'black'.")
            elseif player2.name == actor.name then
                actor:send("You and " .. tostring(player1.name) .. " are getting ready to start a game!")
                actor:send("We are waiting for " .. tostring(player1.name) .. " to choose a color.")
            else
                actor:send(tostring(player1.name) .. " and " .. tostring(player2.name) .. " are getting ready to start a game.")
            end
        else
            if player1.name == actor.name then
                actor:send("You are waiting for someone to join you.")
                if p1desc then
                    actor:send("You are playing as " .. tostring(p1desc) .. ".")
                else
                    actor:send("You need to choose a color!  Say 'red' or 'black'.")
                end
            else
                actor:send(tostring(player1.name) .. " is waiting for someone to join " .. tostring(player1.object) .. ".")
                if p1desc then
                    actor:send(tostring(player1.name) .. " is playing as " .. tostring(p1desc) .. ".")
                end
            end
        end
    end
elseif status == 1 then
    if player1.name == actor.name then
        actor:send("You and " .. tostring(player2.name) .. " are playing.")
        actor:send("You are " .. tostring(p1desc) .. " and " .. tostring(player2.name) .. " is " .. tostring(p2desc) .. ".")
        if turn == 1 then
            actor:send("It's your turn!")
        else
            actor:send("It's " .. tostring(player2.name) .. "'s turn.")
        end
    elseif player2.name == actor.name then
        actor:send("You and " .. tostring(player1.name) .. " are playing.")
        actor:send("You are " .. tostring(p2desc) .. " and " .. tostring(player1.name) .. " is " .. tostring(p1desc) .. ".")
        if turn == 2 then
            actor:send("It's your turn!")
        else
            actor:send("It's " .. tostring(player1.name) .. "'s turn.")
        end
    else
        actor:send(tostring(player1.name) .. " and " .. tostring(player2.name) .. " are playing.")
        actor:send(tostring(player1.name) .. " is " .. tostring(p1desc) .. " and " .. tostring(player2.name) .. " is " .. tostring(p2desc) .. ".")
        if turn == 1 then
            actor:send("It's " .. tostring(player1.name) .. "'s turn.")
        else
            actor:send("It's " .. tostring(player2.name) .. "'s turn.")
        end
    end
elseif status == 2 then
    if player1.name == actor.name then
        actor:send("You and " .. tostring(player2.name) .. " were playing.")
    elseif player2.name == actor.name then
        actor:send("You and " .. tostring(player1.name) .. " were playing.")
    else
        actor:send(tostring(player1.name) .. " and " .. tostring(player2.name) .. " were playing.")
    end
    if p1win then
        if player1.name == actor.name then
            actor:send("You won the game!")
        else
            actor:send(tostring(player1.name) .. " won the game.")
        end
    elseif p2win then
        if player2.name == actor.name then
            actor:send("You won the game!")
        else
            actor:send(tostring(player2.name) .. " won the game.")
        end
    elseif p1forfeit == 2 then
        if player1.name == actor.name then
            actor:send("You forfeited the game.")
        else
            actor:send(tostring(player1.name) .. " forfeited the game.")
        end
    elseif p2forfeit == 2 then
        if player2.name == actor.name then
            actor:send("You forfeited the game.")
        else
            actor:send(tostring(player2.name) .. " forfeited the game.")
        end
    else
        actor:send("The game is over.")
    end
end
return _return_value