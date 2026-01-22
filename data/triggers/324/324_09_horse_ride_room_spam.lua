-- Trigger: Horse_ride_room_spam
-- Zone: 324, ID: 9
-- Type: WORLD, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #32409

-- Converted from DG Script #32409: Horse_ride_room_spam
-- Original: WORLD trigger, flags: COMMAND, probability: 100%

-- Command filter: do_it_to_it
if not (cmd == "do_it_to_it") then
    return true  -- Not our command
end
local counter = 25
while counter do
    get_room(325, 97):at(function()
        self.room:send("You catch a glimpse of the passing countryside!")
    end)
    get_room(325, 97):at(function()
        self.room:send("</><yellow>Dirt Road</> cutting through </><green>Vast Grasslands</>")
    end)
    get_room(325, 97):at(function()
        self.room:send("<yellow>   This simple yet well mantained road runs a relativly straight direction,")
    end)
    get_room(325, 97):at(function()
        self.room:send("both north and south, though many twists and bends add to its character. Its")
    end)
    get_room(325, 97):at(function()
        self.room:send("brown surface cuts a path through the vast grasslands on either side, their")
    end)
    get_room(325, 97):at(function()
        self.room:send("endless lengths appearing to stretch on forever. Though the scenary is")
    end)
    get_room(325, 97):at(function()
        self.room:send("serene, danger could be lurking close by in many forms, including bandits.")
    end)
    get_room(325, 97):at(function()
        self.room:send("An occasional patrol from Kerristone passes through the area, though for the most")
    end)
    get_room(325, 97):at(function()
        self.room:send("part travelers are left to fend for themselves.</>")
    end)
    wait(4)
    get_room(325, 97):at(function()
        self.room:send("</><yellow>Dirt Road</> cutting through </><green>Vast Grasslands</>")
    end)
    get_room(325, 97):at(function()
        self.room:send("<yellow>   This simple yet well mantained road runs a relativly straight direction,")
    end)
    get_room(325, 97):at(function()
        self.room:send("both north and south, though many twists and bends add to its character. Its")
    end)
    get_room(325, 97):at(function()
        self.room:send("brown surface cuts a path through the vast grasslands on either side, their")
    end)
    get_room(325, 97):at(function()
        self.room:send("endless lengths appearing to stretch on forever. Though the scenary is")
    end)
    get_room(325, 97):at(function()
        self.room:send("serene, danger could be lurking close by in many forms, including bandits.")
    end)
    get_room(325, 97):at(function()
        self.room:send("An occasional patrol from Kerristone passes through the area, though for the most")
    end)
    get_room(325, 97):at(function()
        self.room:send("part travelers are left to fend for themselves.</>")
    end)
    local counter = counter -1
    wait(1)
    if counter == 0 then
    else
    end
end