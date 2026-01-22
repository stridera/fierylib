-- Trigger: maze_room_one
-- Zone: 510, ID: 1
-- Type: WORLD, Flags: PREENTRY
-- Status: CLEAN (reviewed 2026-01-22)
--
-- Original DG Script: #51001

-- Converted from DG Script #51001: maze_room_one
-- Original: WORLD trigger, flags: PREENTRY, probability: 100%
if exitdone ~= 1 then
    -- flag to prevent group members retriggering
    local exitdone = 1
    globals.exitdone = globals.exitdone or true
    doors.set_state(get_room(vnum_to_zone(self.id), vnum_to_local(self.id)), "north", {action = "purge"})
    doors.set_state(get_room(vnum_to_zone(self.id), vnum_to_local(self.id)), "south", {action = "purge"})
    doors.set_state(get_room(vnum_to_zone(self.id), vnum_to_local(self.id)), "west", {action = "purge"})
    doors.set_state(get_room(vnum_to_zone(self.id), vnum_to_local(self.id)), "east", {action = "purge"})
    doors.set_state(get_room(vnum_to_zone(self.id), vnum_to_local(self.id)), "up", {action = "purge"})
    doors.set_state(get_room(vnum_to_zone(self.id), vnum_to_local(self.id)), "down", {action = "purge"})
    local exitsreq = random(1, 6)
    local exitsdone = 0
    while exitsdone < exitsreq do
        local exitdir = random(1, 6)
        local toroom = 51071 + random(1, 5)
        if toroom ~= self.id then
            -- switch on exitdir
            if exitdir == 1 then
                doors.set_exit(get_room(vnum_to_zone(self.id), vnum_to_local(self.id)), "north", toroom)
                doors.set_description(get_room(vnum_to_zone(self.id), vnum_to_local(self.id)), "north", "The entrance wavers slightly as you look at it.")
                exitsdone = exitsdone + 1
            elseif exitdir == 2 then
                doors.set_exit(get_room(vnum_to_zone(self.id), vnum_to_local(self.id)), "south", toroom)
                doors.set_description(get_room(vnum_to_zone(self.id), vnum_to_local(self.id)), "south", "The entrance wavers slightly as you look at it.")
                exitsdone = exitsdone + 1
            elseif exitdir == 3 then
                doors.set_exit(get_room(vnum_to_zone(self.id), vnum_to_local(self.id)), "east", toroom)
                doors.set_description(get_room(vnum_to_zone(self.id), vnum_to_local(self.id)), "east", "The entrance wavers slightly as you look at it.")
                exitsdone = exitsdone + 1
            elseif exitdir == 4 then
                doors.set_exit(get_room(vnum_to_zone(self.id), vnum_to_local(self.id)), "west", toroom)
                doors.set_description(get_room(vnum_to_zone(self.id), vnum_to_local(self.id)), "west", "The entrance wavers slightly as you look at it.")
                exitsdone = exitsdone + 1
            elseif exitdir == 5 then
                doors.set_exit(get_room(vnum_to_zone(self.id), vnum_to_local(self.id)), "up", toroom)
                doors.set_description(get_room(vnum_to_zone(self.id), vnum_to_local(self.id)), "up", "The entrance wavers slightly as you look at it.")
                exitsdone = exitsdone + 1
            elseif exitdir == 6 then
                doors.set_exit(get_room(vnum_to_zone(self.id), vnum_to_local(self.id)), "down", toroom)
                doors.set_description(get_room(vnum_to_zone(self.id), vnum_to_local(self.id)), "down", "The entrance wavers slightly as you look at it.")
                exitsdone = exitsdone + 1
            end
        end
    end
    -- now add a special case which exits from the maze totally
    if random(1, 100) < 30 then
        doors.set_exit(get_room(vnum_to_zone(self.id), vnum_to_local(self.id)), "up", get_room(510, 77))
        doors.set_description(get_room(vnum_to_zone(self.id), vnum_to_local(self.id)), "up", "This doorway looks more solid than the others.")
    end
    wait(1)
    exitdone = nil
end