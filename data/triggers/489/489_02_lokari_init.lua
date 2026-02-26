-- Trigger: lokari init
-- Zone: 489, ID: 2
-- Type: MOB, Flags: LOAD
-- Status: NEEDS_REVIEW
--   Complex nesting: 7 if statements
--
-- Original DG Script: #48902

-- Converted from DG Script #48902: lokari init
-- Original: MOB trigger, flags: LOAD, probability: 100%
self:teleport(get_room(11, 0))
if world.count_mobiles(489, 15) > 0 then
    do
        local _mob = world.find_mobile("maid-rogue")
        if _mob then
            _mob.room:at(function()
                self.room:find_actor("maid-rogue"):teleport(get_room(489, 80))
            end)
        end
    end
    get_room(489, 80):at(function()
        self.room:find_actor("maid-rogue"):heal(32000)
    end)
else
    local rogue = self.room:spawn_mobile(489, 15)
    if rogue then
        if world.count_objects(489, 26) > 0 then
            rogue:spawn_object(10, 12)
            rogue:command("wield thin-dagger")
        else
            rogue:spawn_object(489, 26)
            rogue:command("wield wrist-dagger")
        end
        rogue:teleport(get_room(489, 80))
    end
end
if world.count_mobiles(489, 22) > 0 then
    do
        local _mob = world.find_mobile("maid-sorcerer")
        if _mob then
            _mob.room:at(function()
                self.room:find_actor("maid-sorcerer"):teleport(get_room(489, 80))
            end)
        end
    end
    get_room(489, 80):at(function()
        self.room:find_actor("maid-sorcerer"):heal(32000)
    end)
else
    local sorcerer = self.room:spawn_mobile(489, 22)
    if sorcerer then
        sorcerer:teleport(get_room(489, 80))
    end
end
if world.count_mobiles(489, 23) > 0 then
    do
        local _mob = world.find_mobile("maid-cleric")
        if _mob then
            _mob.room:at(function()
                self.room:find_actor("maid-cleric"):teleport(get_room(489, 80))
            end)
        end
    end
    get_room(489, 80):at(function()
        self.room:find_actor("maid-cleric"):heal(32000)
    end)
else
    local cleric = self.room:spawn_mobile(489, 23)
    if cleric then
        cleric:teleport(get_room(489, 80))
    end
end
self:teleport(get_room(489, 80))
