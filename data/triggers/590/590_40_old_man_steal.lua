-- Trigger: old_man_steal
-- Zone: 590, ID: 40
-- Type: MOB, Flags: GREET
-- Status: CLEAN
--
-- Original DG Script: #59040

-- Converted from DG Script #59040: old_man_steal
-- Original: MOB trigger, flags: GREET, probability: 100%
local target = room.actors[random(1, #room.actors)]
local rnd = random(1, 100)
local loot
if rnd > 99 then
    loot = "gem"
elseif rnd == 99 then
    loot = "iron"
elseif (rnd <= 98) and (rnd >= 97) then
    loot = "cloth"
elseif (rnd <= 96) and (rnd >= 95) then
    loot = "wood"
elseif (rnd <= 94) and (rnd >= 93) then
    loot = "white"
elseif (rnd <= 92) and (rnd >= 90) then
    loot = "red"
elseif (rnd <= 89) and (rnd >= 85) then
    loot = "blue"
elseif (rnd <= 84) and (rnd >= 80) then
    loot = "green"
elseif (rnd <= 79) and (rnd >= 76) then
    loot = "black"
elseif (rnd <= 75) and (rnd >= 71) then
    loot = "dagger"
elseif (rnd <= 70) and (rnd >= 66) then
    loot = "shield"
elseif (rnd <= 65) and (rnd >= 61) then
    loot = "sword"
elseif (rnd <= 60) and (rnd >= 56) then
    loot = "leather"
elseif (rnd <= 55) and (rnd >= 46) then
    loot = "raft"
elseif (rnd <= 45) and (rnd >= 36) then
    loot = "canoe"
elseif (rnd <= 35) and (rnd >= 26) then
    loot = "sack"
elseif (rnd <= 25) and (rnd >= 16) then
    loot = "bag"
elseif rnd <= 15 then
    loot = "gem"
end
if loot and target.is_player and target.level < 100 then
    self:command("steal " .. tostring(loot) .. " " .. tostring(target.name))
end