-- Trigger: Drop trigger for ambush staging room
-- Zone: 120, ID: 16
-- Type: WORLD, Flags: DROP
-- Status: CLEAN (fixed %direction% to direction variable)
--
-- Original DG Script: #12016

-- Converted from DG Script #12016: Drop trigger for ambush staging room
-- Original: WORLD trigger, flags: DROP, probability: 100%
if actor.id == 12019 then
    wait(1)
    local direction = "d"
    local dest_zone, dest_local = 120, 30
    if object.id == 12002 then
        local direction = "u"
        dest_zone, dest_local = 120, 95
    end
    world.destroy(object)
    if self:get_people("12021") then
        self.room:find_actor("dark-pixie-ambusher-male"):command(direction)
        wait(1)
        get_room(dest_zone, dest_local):at(function()
            self.room:find_actor("dark-pixie-ambusher-male"):command("kill haggard-brownie")
        end)
    end
    if self:get_people("12022") then
        self.room:find_actor("dark-pixie-ambusher-female"):command(direction)
        wait(1)
        get_room(dest_zone, dest_local):at(function()
            self.room:find_actor("dark-pixie-ambusher-female"):command("kill haggard-brownie")
        end)
    end
end  -- auto-close block