-- Trigger: connectfour forfeit game
-- Zone: 60, ID: 70
-- Type: OBJECT, Flags: COMMAND
-- Status: NEEDS_REVIEW
--   Complex nesting: 8 if statements
--
-- Original DG Script: #6070

-- Converted from DG Script #6070: connectfour forfeit game
-- Original: OBJECT trigger, flags: COMMAND, probability: 4%

-- 4% chance to trigger
if not percent_chance(4) then
    return true
end

-- Command filter: forfeit
if not (cmd == "forfeit") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
-- switch on cmd
if cmd == "f" or cmd == "fo" or cmd == "for" then
    _return_value = false
    return _return_value
end
if (status == 0) or (not player1) or (not player2) then
    actor:send("But the game hasn't even started yet!")
elseif (player1.name == actor.name) or (player2.name == actor.name) then
    if status == 2 then
        actor:send("But the game's already over!")
        return _return_value
    end
    if arg == "yes" then
        actor:send("You forfeit the game!")
        self.room:send_except(actor, tostring(actor.name) .. " forfeits the game!")
        if player1.name == actor.name then
            local p1forfeit = 2
            globals.p1forfeit = globals.p1forfeit or true
        elseif player2.name == actor.name then
            local p2forfeit = 2
            globals.p2forfeit = globals.p2forfeit or true
        end
        local status = 2
        globals.status = globals.status or true
    else
        actor:send("Are you absolutely sure you want to forfeit?  If so, type 'forfeit yes'.")
        if player1.name == actor.name then
            local p1forfeit = 1
            globals.p1forfeit = globals.p1forfeit or true
        elseif player2.name == actor.name then
            local p2forfeit = 1
            globals.p2forfeit = globals.p2forfeit or true
        end
    end
else
    actor:send("You can't forfeit a game you're not even playing!")
end
return _return_value