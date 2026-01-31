-- Trigger: Wear membership ring and portal opens
-- Zone: 15, ID: 3
-- Type: WORLD, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #1503

-- Converted from DG Script #1503: Wear membership ring and portal opens
-- Original: WORLD trigger, flags: COMMAND, probability: 100%

-- Command filter: wear
if not (cmd == "wear") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
_return_value = false
wait(2)
if actor:has_equipped("1500") then
    if wof_exit ~= 1 then
        local wof_exit = 1
        globals.wof_exit = globals.wof_exit or true
        wait(4)
        self.room:send_except(actor, tostring(actor.name) .. "'s <magenta>Soul Gem</> begins to glow.")
        actor:send("Your <magenta>Soul Gem</> begins to glow.")
        self.room:send("A light shimmering develops to the east, and resolves itself into a portal.")
        get_room(390, 23):exit("east"):set_state({hidden = true})
        get_room(390, 23):exit("east"):set_state({hidden = false})
        get_room(390, 23):exit("east"):set_state({description = "A slowly shimmering portal leads east."})
        wait(8)
        self.room:send("The shimmering of the eastern exit is a bit faster now.")
        wait(8)
        self.room:send("The eastern portal is positively spinning, and seems to be fading.")
        wait(4)
        self.room:send("There is a sharp *snap* and the portal collapses into nothingness.")
        get_room(390, 23):exit("east"):set_state({hidden = true})
        get_room(390, 23):exit("east"):set_state({hidden = false})
        get_room(390, 23):exit("east"):set_state({description = "The Blue Fog Sea rolls on to the East."})
        local wof_exit = 0
        globals.wof_exit = globals.wof_exit or true
    end
end
return _return_value