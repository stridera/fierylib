-- Trigger: connectfour start
-- Zone: 60, ID: 61
-- Type: OBJECT, Flags: COMMAND
-- Status: CLEAN
--   Complex nesting: 6 if statements
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
    _return_value = false
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