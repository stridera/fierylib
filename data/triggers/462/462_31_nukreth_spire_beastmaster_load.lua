-- Trigger: Nukreth Spire beastmaster load
-- Zone: 462, ID: 31
-- Type: MOB, Flags: LOAD
-- Status: CLEAN
--
-- Original DG Script: #46231

-- Converted from DG Script #46231: Nukreth Spire beastmaster load
-- Original: MOB trigger, flags: LOAD, probability: 100%
local room = self.room
local staging_room = get_room(11, 0)
if not staging_room then return end

self:teleport(staging_room)

-- Spawn hyenas and have them follow the beastmaster
local hyena1 = self.room:spawn_mobile(462, 13)
if hyena1 then
    hyena1:follow(self)
    hyena1:teleport(room)
end

local hyena2 = self.room:spawn_mobile(462, 13)
if hyena2 then
    hyena2:follow(self)
    hyena2:teleport(room)
end

local hyena3 = self.room:spawn_mobile(462, 15)
if hyena3 then
    hyena3:follow(self)
    hyena3:teleport(room)
end

self:teleport(room)