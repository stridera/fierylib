-- Trigger: Horse_ride_room_spam4
-- Zone: 324, ID: 18
-- Type: WORLD, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #32418

-- Converted from DG Script #32418: Horse_ride_room_spam4
-- Original: WORLD trigger, flags: COMMAND, probability: 100%

-- Command filter: do_it_to_it4
if not (cmd == "do_it_to_it4") then
    return true  -- Not our command
end
local counter = 3
while counter do
    get_room(325, 98):at(function()
        self.room:send("You catch a glimpse of the passing countryside!")
    end)
    get_room(325, 98):at(function()
        self.room:send("<yellow>Dirt</> Road along the Shores of </><b:blue>Lake Fedis</>")
    end)
    get_room(325, 98):at(function()
        self.room:send("<yellow>   This curving dirt road leads along the shores of Lake Fedis, one of")
    end)
    get_room(325, 98):at(function()
        self.room:send("the largest lakes found in the highlands. Its icy waters are constantly fed by")
    end)
    get_room(325, 98):at(function()
        self.room:send("the WhiteFox river, which is created by melting snow in the Wailing")
    end)
    get_room(325, 98):at(function()
        self.room:send("Mountains. The road itself is wide enough to allow two or three merchant")
    end)
    get_room(325, 98):at(function()
        self.room:send("wagons to pass at once, though if there should be an accident the sloping")
    end)
    get_room(325, 98):at(function()
        self.room:send("ditches could provide a problem. Rumors persist about Lake Fedis, some")
    end)
    get_room(325, 98):at(function()
        self.room:send("speaking of an ancient lake beast that lives within its depths. The Lakefolk")
    end)
    get_room(325, 98):at(function()
        self.room:send("who have made their home on its shores do not speak of such things, fearing")
    end)
    get_room(325, 98):at(function()
        self.room:send("that it will bring bad luck.</>")
    end)
    wait(4)
    get_room(325, 98):at(function()
        self.room:send("You catch a glimpse of the passing countryside!")
    end)
    get_room(325, 98):at(function()
        self.room:send("<yellow>Dirt</> Road along the Shores of </><b:blue>Lake Fedis</>")
    end)
    get_room(325, 98):at(function()
        self.room:send("<yellow>   This curving dirt road leads along the shores of Lake Fedis, one of")
    end)
    get_room(325, 98):at(function()
        self.room:send("the largest lakes found in the highlands. Its icy waters are constantly fed by")
    end)
    get_room(325, 98):at(function()
        self.room:send("the WhiteFox river, which is created by melting snow in the Wailing")
    end)
    get_room(325, 98):at(function()
        self.room:send("Mountains. The road itself is wide enough to allow two or three merchant")
    end)
    get_room(325, 98):at(function()
        self.room:send("wagons to pass at once, though if there should be an accident the sloping")
    end)
    get_room(325, 98):at(function()
        self.room:send("ditches could provide a problem. Rumors persist about Lake Fedis, some")
    end)
    get_room(325, 98):at(function()
        self.room:send("speaking of an ancient lake beast that lives within its depths. The Lakefolk")
    end)
    get_room(325, 98):at(function()
        self.room:send("who have made their home on its shores do not speak of such things, fearing")
    end)
    get_room(325, 98):at(function()
        self.room:send("that it will bring bad luck.</>")
    end)
    local counter = counter -1
    wait(1)
    if counter == 0 then
    else
    end
end