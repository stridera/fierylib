-- Trigger: Horse_ride_room_spam3
-- Zone: 324, ID: 17
-- Type: WORLD, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #32417

-- Converted from DG Script #32417: Horse_ride_room_spam3
-- Original: WORLD trigger, flags: COMMAND, probability: 100%

-- Command filter: do_it_to_it3
if not (cmd == "do_it_to_it3") then
    return true  -- Not our command
end
local counter = 5
while counter do
    get_room(325, 98):at(function()
        self.room:send("You catch a glimpse of the passing countryside!")
    end)
    get_room(325, 98):at(function()
        self.room:send("<yellow>Road through the </>&9<blue>Rugged Hills</>")
    end)
    get_room(325, 98):at(function()
        self.room:send("<yellow>   This simple dirt road cuts through the hilly landscape with great")
    end)
    get_room(325, 98):at(function()
        self.room:send("precision, winding through the obstacles with perfect planning. The road")
    end)
    get_room(325, 98):at(function()
        self.room:send("engineer must have spent ages mapping out this road system, though over the")
    end)
    get_room(325, 98):at(function()
        self.room:send("years it has started to show signs of disrepair. The rocky hills surrounding")
    end)
    get_room(325, 98):at(function()
        self.room:send("the road look cold and bleak, the gloomy terrain only broken by the")
    end)
    get_room(325, 98):at(function()
        self.room:send("occasional patch of snow or copse of pine trees. Black boulders cover many")
    end)
    get_room(325, 98):at(function()
        self.room:send("of the hills, their outline weathered into grotesque shapes.</>")
    end)
    wait(4)
    get_room(325, 98):at(function()
        self.room:send("You catch a glimpse of the passing countryside!")
    end)
    get_room(325, 98):at(function()
        self.room:send("<yellow>Road through the </>&9<blue>Rugged Hills</>")
    end)
    get_room(325, 98):at(function()
        self.room:send("<yellow>   This simple dirt road cuts through the hilly landscape with great")
    end)
    get_room(325, 98):at(function()
        self.room:send("precision, winding through the obstacles with perfect planning. The road")
    end)
    get_room(325, 98):at(function()
        self.room:send("engineer must have spent ages mapping out this road system, though over the")
    end)
    get_room(325, 98):at(function()
        self.room:send("years it has started to show signs of disrepair. The rocky hills surrounding")
    end)
    get_room(325, 98):at(function()
        self.room:send("the road look cold and bleak, the gloomy terrain only broken by the")
    end)
    get_room(325, 98):at(function()
        self.room:send("occasional patch of snow or copse of pine trees. Black boulders cover many")
    end)
    get_room(325, 98):at(function()
        self.room:send("of the hills, their outline weathered into grotesque shapes.</>")
    end)
    local counter = counter -1
    wait(1)
    if counter == 0 then
        -- Label reference: do_it_to_it4
    else
    end
end
self.room:find_actor("horse"):command("do_it_to_it4")