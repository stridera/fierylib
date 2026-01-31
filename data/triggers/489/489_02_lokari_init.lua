-- Trigger: lokari init
-- Zone: 489, ID: 2
-- Type: MOB, Flags: LOAD
-- Status: NEEDS_REVIEW
--   Complex nesting: 7 if statements
--
-- Original DG Script: #48902

-- Converted from DG Script #48902: lokari init
-- Original: MOB trigger, flags: LOAD, probability: 100%
local staging_room = get_room(11, 0)
local dest_room = get_room(489, 80)
if not staging_room or not dest_room then return end

self:teleport(staging_room)

-- Handle maid-rogue (489:15)
local rogue = world.find_mobile("maid-rogue")
if rogue then
    rogue:teleport(dest_room)
    rogue:heal(32000)
else
    rogue = self.room:spawn_mobile(489, 15)
    if rogue then
        if world.count_objects("48926") > 0 then
            rogue:spawn_object(10, 12)
            rogue:command("wield thin-dagger")
        else
            rogue:spawn_object(489, 26)
            rogue:command("wield wrist-dagger")
        end
        rogue:teleport(dest_room)
    end
end

-- Handle maid-sorcerer (489:22)
local sorcerer = world.find_mobile("maid-sorcerer")
if sorcerer then
    sorcerer:teleport(dest_room)
    sorcerer:heal(32000)
else
    sorcerer = self.room:spawn_mobile(489, 22)
    if sorcerer then
        sorcerer:teleport(dest_room)
    end
end

-- Handle maid-cleric (489:23)
local cleric = world.find_mobile("maid-cleric")
if cleric then
    cleric:teleport(dest_room)
    cleric:heal(32000)
else
    cleric = self.room:spawn_mobile(489, 23)
    if cleric then
        cleric:teleport(dest_room)
    end
end

self:teleport(dest_room)