-- Trigger: thief_steal_stuff
-- Zone: 103, ID: 0
-- Type: MOB, Flags: GREET
-- Status: CLEAN
--
-- Original DG Script: #10300

-- Converted from DG Script #10300: thief_steal_stuff
-- Original: MOB trigger, flags: GREET, probability: 100%
-- Thief steal stuff trigger...
-- Chose a set of common keywords and aligned percentage chances
-- so that it has a random chance to steal any of the keywords
local rnd = random(1, 100)
if rnd > 99 then
    local loot = "gem"
elseif rnd == 99 then
    local loot = "iron"
elseif rnd <= 98 and rnd >= 97 then
    local loot = "cloth"
elseif rnd <= 96 and rnd >= 95 then
    local loot = "wood"
elseif rnd <= 94 and rnd >= 93 then
    local loot = "white"
elseif rnd <= 92 and rnd >= 90 then
    local loot = "red"
elseif rnd <= 89 and rnd >= 85 then
    local loot = "blue"
elseif rnd <= 84 and rnd >= 80 then
    local loot = "green"
elseif rnd <= 79 and rnd >= 76 then
    local loot = "black"
elseif rnd <= 75 and rnd >= 71 then
    local loot = "dagger"
elseif rnd <= 70 and rnd >= 66 then
    local loot = "shield"
elseif rnd <= 65 and rnd >= 61 then
    local loot = "sword"
elseif rnd <= 60 and rnd >= 56 then
    local loot = "leather"
elseif rnd <= 55 and rnd >= 46 then
    local loot = "raft"
elseif rnd <= 45 and rnd >= 36 then
    local loot = "canoe"
elseif rnd <= 35 and rnd >= 26 then
    local loot = "sack"
elseif rnd <= 25 and rnd >= 16 then
    local loot = "bag"
elseif rnd <= 15 then
    local loot = "gem"
end
-- now the real command!
self:command("steal " .. tostring(loot) .. " " .. tostring(actor.name))