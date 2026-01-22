-- Trigger: Horse_ride_room_spam2
-- Zone: 324, ID: 16
-- Type: WORLD, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #32416

-- Converted from DG Script #32416: Horse_ride_room_spam2
-- Original: WORLD trigger, flags: COMMAND, probability: 100%

-- Command filter: do_it_to_it2
if not (cmd == "do_it_to_it2") then
    return true  -- Not our command
end
local counter = 7
while counter do
    get_room(325, 98):at(function()
        self.room:send("You catch a glimpse of the passing countryside!")
    end)
    get_room(325, 98):at(function()
        self.room:send("<yellow>Dirt Road</> through the Sloping </><yellow>Highlands</>")
    end)
    get_room(325, 98):at(function()
        self.room:send("<yellow>   A dirt road cuts through the uneven landscape, over rolling hills and")
    end)
    get_room(325, 98):at(function()
        self.room:send("shallow valleys. Though not as well kept as some of the southern roads, it")
    end)
    get_room(325, 98):at(function()
        self.room:send("still surves its purpose. Wagon tracks cover most of its surface, both")
    end)
    get_room(325, 98):at(function()
        self.room:send("recent and ancient, their existance testimony to the traffic this road has")
    end)
    get_room(325, 98):at(function()
        self.room:send("sustained over the many years. The surrounding hills are mostly bare, though")
    end)
    get_room(325, 98):at(function()
        self.room:send("some contain small groups of trees or thick underbrush. The occasional")
    end)
    get_room(325, 98):at(function()
        self.room:send("glint of water can be seen, coming from one of the many small ponds that")
    end)
    get_room(325, 98):at(function()
        self.room:send("are tucked between the steep hillsides.</>")
    end)
    wait(4)
    get_room(325, 98):at(function()
        self.room:send("You catch a glimpse of the passing countryside!")
    end)
    get_room(325, 98):at(function()
        self.room:send("<yellow>Dirt Road</> through the Sloping </><yellow>Highlands</>")
    end)
    get_room(325, 98):at(function()
        self.room:send("<yellow>   A dirt road cuts through the uneven landscape, over rolling hills and")
    end)
    get_room(325, 98):at(function()
        self.room:send("shallow valleys. Though not as well kept as some of the southern roads, it")
    end)
    get_room(325, 98):at(function()
        self.room:send("still surves its purpose. Wagon tracks cover most of its surface, both")
    end)
    get_room(325, 98):at(function()
        self.room:send("recent and ancient, their existance testimony to the traffic this road has")
    end)
    get_room(325, 98):at(function()
        self.room:send("sustained over the many years. The surrounding hills are mostly bare, though")
    end)
    get_room(325, 98):at(function()
        self.room:send("some contain small groups of trees or thick underbrush. The occasional")
    end)
    get_room(325, 98):at(function()
        self.room:send("glint of water can be seen, coming from one of the many small ponds that")
    end)
    get_room(325, 98):at(function()
        self.room:send("are tucked between the steep hillsides.</>")
    end)
    local counter = counter -1
    wait(1)
    if counter == 0 then
    else
    end
end
self.room:find_actor("horse"):command("do_it_to_it3")