-- Trigger: maze_room_one
-- Zone: 510, ID: 1
-- Type: WORLD, Flags: PREENTRY
-- Status: NEEDS_REVIEW
--   Syntax error: luac: <maze_room_one>:15: unexpected symbol near '%'
--
-- Original DG Script: #51001

-- Converted from DG Script #51001: maze_room_one
-- Original: WORLD trigger, flags: PREENTRY, probability: 100%
if exitdone ~= 1 then
    -- flag to prevent group members retriggering
    local exitdone = 1
    globals.exitdone = globals.exitdone or true
    self:exit("north"):set_state({hidden = true})
    self:exit("south"):set_state({hidden = true})
    self:exit("west"):set_state({hidden = true})
    self:exit("east"):set_state({hidden = true})
    self:exit("up"):set_state({hidden = true})
    self:exit("down"):set_state({hidden = true})
    local exitsreq = random(1, 6)
    local exitsdone = 0
    while exitsdone < exitsreq do
        local exitdir = random(1, 6)
        local toroom = get_room(510, 71 + random(1, 5))
        if exitdir == 1 then
            self:exit("north"):set_destination(toroom)
            self:exit("north"):set_state({description = "The entrance wavers slightly as you look at it."})
            exitsdone = exitsdone + 1
        elseif exitdir == 2 then
            self:exit("south"):set_destination(toroom)
            self:exit("south"):set_state({description = "The entrance wavers slightly as you look at it."})
            exitsdone = exitsdone + 1
        elseif exitdir == 3 then
            self:exit("east"):set_destination(toroom)
            self:exit("east"):set_state({description = "The entrance wavers slightly as you look at it."})
            exitsdone = exitsdone + 1
        elseif exitdir == 4 then
            self:exit("west"):set_destination(toroom)
            self:exit("west"):set_state({description = "The entrance wavers slightly as you look at it."})
            exitsdone = exitsdone + 1
        elseif exitdir == 5 then
            self:exit("up"):set_destination(toroom)
            self:exit("up"):set_state({description = "The entrance wavers slightly as you look at it."})
            exitsdone = exitsdone + 1
        elseif exitdir == 6 then
            self:exit("down"):set_destination(toroom)
            self:exit("down"):set_state({description = "The entrance wavers slightly as you look at it."})
            exitsdone = exitsdone + 1
        end
    end
    -- now add a special case which exits from the maze totally
    if random(1, 100) < 30 then
        self:exit("up"):set_destination(get_room(510, 77))
        self:exit("up"):set_state({description = "This doorway looks more solid than the others."})
    end
    wait(1)
    exitdone = nil
end
