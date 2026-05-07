-- Trigger: Drop trigger for ambush staging room
-- Zone: 120, ID: 16
-- Type: WORLD, Flags: DROP
-- Status: CLEAN
--
-- Original DG Script: #12016

-- Converted from DG Script #12016: Drop trigger for ambush staging room
-- Original: WORLD trigger, flags: DROP, probability: 100%
--
-- When the haggard brownie (mob 120-19) drops bait in the staging room,
-- send the ambushers up or down to chase her. Object 120-1 (passionfruit)
-- means she came from below (chase down to room 30); object 120-2 (meat-pie)
-- means she came from above (chase up to room 95).
if actor.zone_id == 120 and actor.local_id == 19 then
    wait(1)
    local direction, destination = "d", 30
    if object.zone_id == 120 and object.local_id == 2 then
        direction, destination = "u", 95
    end
    world.destroy(object)
    local male = self.room:find_actor("dark-pixie-ambusher-male")
    if male then
        male:command(direction)
        wait(1)
        get_room(120, destination):at(function()
            local m = get_room(120, destination):find_actor("dark-pixie-ambusher-male")
            if m then m:command("kill haggard-brownie") end
        end)
    end
    local female = self.room:find_actor("dark-pixie-ambusher-female")
    if female then
        female:command(direction)
        wait(1)
        get_room(120, destination):at(function()
            local f = get_room(120, destination):find_actor("dark-pixie-ambusher-female")
            if f then f:command("kill haggard-brownie") end
        end)
    end
end