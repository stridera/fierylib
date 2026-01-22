-- Trigger: stablehand_buy
-- Zone: 23, ID: 50
-- Type: MOB, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #2350

-- Converted from DG Script #2350: stablehand_buy
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: buy
if not (cmd == "buy") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
_return_value = true
if arg == "steady" or arg == "warhorse" or arg == "horse" then
    actor:teleport(get_room(30, 91))
    get_room(30, 91):at(function()
        actor:command("buy warhorse")
    end)
    get_room(30, 91):at(function()
        actor:teleport(get_room(23, 48))
    end)
    get_room(30, 91):at(function()
        self.room:find_actor("warhorse"):teleport(get_room(23, 48))
    end)
    self.room:send_except(actor, "A steady warhorse starts following " .. tostring(actor.name) .. ".")
else
    actor:send("There is no such pet!")
end
return _return_value