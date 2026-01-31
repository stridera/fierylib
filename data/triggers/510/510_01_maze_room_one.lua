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
    get_room(self.zone_id, self.id):exit("north"):set_state({hidden = true})
    get_room(self.zone_id, self.id):exit("south"):set_state({hidden = true})
    get_room(self.zone_id, self.id):exit("west"):set_state({hidden = true})
    get_room(self.zone_id, self.id):exit("east"):set_state({hidden = true})
    get_room(self.zone_id, self.id):exit("up"):set_state({hidden = true})
    get_room(self.zone_id, self.id):exit("down"):set_state({hidden = true})
    local exitsreq = random(1, 6)
    local exitsdone = 0
    -- toroom: 51071 + offset => zone 510, local_id 71 + offset
    local toroom_zone = 510
    while exitsdone < exitsreq do
        local exitdir = random(1, 6)
        local toroom_local = 71 + random(1, 5)
        if toroom_local ~= self.id then
            -- switch on exitdir
            if exitdir == 1 then
                get_room(self.zone_id, self.id):exit("north"):set_destination(get_room(toroom_zone, toroom_local))
                get_room(self.zone_id, self.id):exit("north"):set_state({description = "The entrance wavers slightly as you look at it."})
                exitsdone = exitsdone + 1
            elseif exitdir == 2 then
                get_room(self.zone_id, self.id):exit("south"):set_destination(get_room(toroom_zone, toroom_local))
                get_room(self.zone_id, self.id):exit("south"):set_state({description = "The entrance wavers slightly as you look at it."})
                exitsdone = exitsdone + 1
            elseif exitdir == 3 then
                get_room(self.zone_id, self.id):exit("east"):set_destination(get_room(toroom_zone, toroom_local))
                get_room(self.zone_id, self.id):exit("east"):set_state({description = "The entrance wavers slightly as you look at it."})
                exitsdone = exitsdone + 1
            elseif exitdir == 4 then
                get_room(self.zone_id, self.id):exit("west"):set_destination(get_room(toroom_zone, toroom_local))
                get_room(self.zone_id, self.id):exit("west"):set_state({description = "The entrance wavers slightly as you look at it."})
                exitsdone = exitsdone + 1
            elseif exitdir == 5 then
                get_room(self.zone_id, self.id):exit("up"):set_destination(get_room(toroom_zone, toroom_local))
                get_room(self.zone_id, self.id):exit("up"):set_state({description = "The entrance wavers slightly as you look at it."})
                exitsdone = exitsdone + 1
            elseif exitdir == 6 then
                get_room(self.zone_id, self.id):exit("down"):set_destination(get_room(toroom_zone, toroom_local))
                get_room(self.zone_id, self.id):exit("down"):set_state({description = "The entrance wavers slightly as you look at it."})
                exitsdone = exitsdone + 1
            end
        end
    end
    -- now add a special case which exits from the maze totally
    if random(1, 100) < 30 then
        get_room(self.zone_id, self.id):exit("up"):set_destination(get_room(510, 77))
        get_room(self.zone_id, self.id):exit("up"):set_state({description = "This doorway looks more solid than the others."})
    end
    wait(1)
    exitdone = nil
end