-- Trigger: Wear membership ring and portal opens
-- Zone: 15, ID: 3
-- Type: WORLD, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #1503
--
-- After a player issues `wear`, briefly waits and checks whether they are
-- now equipping the WoF Soul Gem (obj 15:0). If so, opens the eastward
-- portal in The Blue Fog Sea (390:23) for a brief window. globals.wof_exit
-- prevents concurrent firings from stacking portal openings.

if cmd ~= "wear" then
    return true
end

wait(2)
if actor:has_equipped(15, 0) then
    if not globals.wof_exit then
        globals.wof_exit = true
        wait(4)
        self.room:send_except(actor, tostring(actor.name) .. "'s <magenta>Soul Gem</> begins to glow.")
        actor:send("Your <magenta>Soul Gem</> begins to glow.")
        self.room:send("A light shimmering develops to the east, and resolves itself into a portal.")
        get_room(390, 23):exit("east"):set_state({hidden = false})
        get_room(390, 23):exit("east"):set_state({description = "A slowly shimmering portal leads east."})
        wait(8)
        self.room:send("The shimmering of the eastern exit is a bit faster now.")
        wait(8)
        self.room:send("The eastern portal is positively spinning, and seems to be fading.")
        wait(4)
        self.room:send("There is a sharp *snap* and the portal collapses into nothingness.")
        get_room(390, 23):exit("east"):set_state({hidden = true})
        get_room(390, 23):exit("east"):set_state({description = "The Blue Fog Sea rolls on to the East."})
        globals.wof_exit = false
    end
end
return true
