-- Trigger: connectfour forfeit game
-- Zone: 60, ID: 70
-- Type: OBJECT, Flags: COMMAND
--
-- TODO(parity): part of broken ConnectFour mini-game; see 060_61. Branch-scoped
-- `local p1forfeit/p2forfeit/status` writes never reach other triggers.
--
-- Original DG Script: #6070

-- Converted from DG Script #6070: connectfour forfeit game
-- Original: OBJECT trigger, flags: COMMAND, probability: 4%

-- Command location mask 4: legacy OCMD_EQUIP=1 (worn), OCMD_INVEN=2 (carried), OCMD_ROOM=4 (floor)
if not (location == "room") then
    return true  -- Not in a location this trigger watches
end

-- Command filter: forfeit
if not (cmd == "forfeit") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
-- switch on cmd
do
    local _sw1 = string.lower(tostring(cmd or ""))
    if _sw1 == "f" or _sw1 == "fo" or _sw1 == "for" then
        _return_value = true
        return _return_value
    end
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
            globals.p1forfeit = p1forfeit
        elseif player2.name == actor.name then
            local p2forfeit = 2
            globals.p2forfeit = p2forfeit
        end
        local status = 2
        globals.status = status
    else
        actor:send("Are you absolutely sure you want to forfeit?  If so, type 'forfeit yes'.")
        if player1.name == actor.name then
            local p1forfeit = 1
            globals.p1forfeit = p1forfeit
        elseif player2.name == actor.name then
            local p2forfeit = 1
            globals.p2forfeit = p2forfeit
        end
    end
else
    actor:send("You can't forfeit a game you're not even playing!")
end
return _return_value