-- Trigger: Entrance opens for members
-- Zone: 15, ID: 0
-- Type: WORLD, Flags: PREENTRY
-- Status: CLEAN
--
-- Original DG Script: #1500
--
-- When a member of the Wave of Fire clan (wearing the Soul Gem, obj 15:0)
-- enters the room, opens the eastward portal in The Blue Fog Sea (390:23)
-- for a brief window before collapsing it again. globals.wof_exit guards
-- against concurrent firings opening overlapping portals.

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
