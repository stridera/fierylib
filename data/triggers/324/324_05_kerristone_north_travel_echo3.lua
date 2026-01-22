-- Trigger: Kerristone_north_travel_echo3
-- Zone: 324, ID: 5
-- Type: MOB, Flags: RANDOM
-- Status: CLEAN
--
-- Original DG Script: #32405

-- Converted from DG Script #32405: Kerristone_north_travel_echo3
-- Original: MOB trigger, flags: RANDOM, probability: 100%
get_room(325, 97):at(function()
    self.room:send("You catch a glimpse of the passing countryside!")
end)
get_room(325, 97):at(function()
    -- (empty room echo)
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
get_room(325, 97):at(function()
    -- (empty room echo)
end)
wait(4)
get_room(325, 97):at(function()
    self.room:send("The world rushes by at incredible speed!")
end)