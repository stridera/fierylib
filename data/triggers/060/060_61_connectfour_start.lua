-- Trigger: connectfour start
-- Zone: 60, ID: 61
-- Type: OBJECT, Flags: COMMAND
--
-- TODO(parity): the entire ConnectFour mini-game (#6061-#6072) was converted
-- with severely broken DG semantics. Issues include: branch-scoped `local`
-- writes that the runtime never sees, board cells stored as separate `globals`
-- requiring single-instance ownership, color codes used as bare identifiers,
-- and string-find checks against undefined "row"/"col"/"streak" identifiers
-- (e.g. `local row1 = a1a2a3a4a5a6a7`, `local streak = piecepiecepiecepiece`,
-- `local piece = p1colO&0`). These are not safely fixable in place — the
-- mini-game needs a full rewrite to a server-side board state. Triggers
-- still parse so the converter doesn't fail; runtime behavior is broken.
--
-- Original DG Script: #6061

-- Converted from DG Script #6061: connectfour start
-- Original: OBJECT trigger, flags: COMMAND, probability: 4%

-- 4% chance to trigger
if not percent_chance(4) then
    return true
end

-- Command filter: start
if not (cmd == "start") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
-- switch on cmd
if cmd == "s" or cmd == "st" or cmd == "sta" or cmd == "star" then
    _return_value = true
    return _return_value
end
if player1 then
    if player2 then
        actor:send(tostring(player1.name) .. " and " .. tostring(player2.name) .. " are already playing ConnectFour!")
    else
        self.room:send_except(actor, tostring(actor.name) .. " joins the ConnectFour game as player 2.")
        actor:send("You are now joining the ConnectFour game!")
        if p2col == "&1&b" then
            actor:send("You are the <b:red>red</> pieces!")
            self.room:send_except(actor, tostring(actor.name) .. " gets the <b:red>red</> pieces.")
            player1:send("You get to go first!")  -- fixed: space in var name
            local status = 1
            globals.status = globals.status or true
            local turn = 1
            globals.turn = globals.turn or true
        elseif p2col == "&b&9" then
            actor:send("You are the <blue>&9black</> pieces!")
            self.room:send_except(actor, tostring(actor.name) .. " gets the <blue>&9black</> pieces.")
            player1:send("You get to go first!")
            local status = 1
            globals.status = globals.status or true
            local turn = 1
            globals.turn = globals.turn or true
        end
        local player2 = actor
        globals.player2 = globals.player2 or true
    end
else
    self.room:send_except(actor, tostring(actor.name) .. " starts a new ConnectFour game as player 1.")
    actor:send("Alright!  Starting new ConnectFour game.  You are player 1.")
    actor:send("Do you want to be red or black?  Use the select command to choose.")
    local player1 = actor
    globals.player1 = globals.player1 or true
end
return _return_value