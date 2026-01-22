-- Trigger: hearts start
-- Zone: 60, ID: 75
-- Type: OBJECT, Flags: COMMAND
-- Status: NEEDS_REVIEW
--   Complex nesting: 11 if statements
--
-- Original DG Script: #6075

-- Converted from DG Script #6075: hearts start
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
if status then
    actor:send("The game has already started.  You must wait for it to finish.")
end
if player1 then
    if player2 then
        if player3 then
            if player4 then
                actor:send("Sorry, four people are already playing Hearts.")
                actor:send("You'll have to wait for the next game.")
            else
                if (actor.name == player1.name) or (actor.name == player2.name) or (actor.name == player3.name) then
                    actor:send("You're already in the game!")
                else
                    self.room:send_except(actor, tostring(actor.name) .. " joins the Hearts game as player 4.")
                    actor:send("You are now joining the Hearts game as player 4.")
                    local player4 = actor
                    globals.player4 = globals.player4 or true
                    player1:send("The cards are now ready to be dealt.")
                    player2:send("The cards are now ready to be dealt.")
                    player3:send("The cards are now ready to be dealt.")
                    actor:send("The cards are now ready to be dealt.")
                    local status = 1
                    globals.status = globals.status or true
                end
            end
        else
            if (actor.name == player1.name) or (actor.name == player2.name) then
                actor:send("You're already in the game!")
            else
                self.room:send_except(actor, tostring(actor.name) .. " joins the Hearts game as player 3.")
                actor:send("You are now joining the Hearts game as player 3.")
                local player3 = actor
                globals.player3 = globals.player3 or true
            end
        end
    else
        if actor.name == player1.name then
            actor:send("You're already in the game!")
        else
            self.room:send_except(actor, tostring(actor.name) .. " joins the Hearts game as player 2.")
            actor:send("You are now joining the Hearts game as player 2.")
            local player2 = actor
            globals.player2 = globals.player2 or true
        end
    end
else
    self.room:send_except(actor, tostring(actor.name) .. " starts a new game of Hearts as player 1.")
    actor:send("Alright!  Starting a new game of Hearts.  You are player 1.")
    local player1 = actor
    globals.player1 = globals.player1 or true
end
return _return_value