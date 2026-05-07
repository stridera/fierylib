-- Trigger: thief_steal_stuff
-- Zone: 103, ID: 0
-- Type: MOB, Flags: GREET
-- Status: CLEAN
--
-- Original DG Script: #10300
-- Thief greet trigger. Picks a random keyword from a weighted set
-- and tries to steal an item that matches it from the actor.

local rnd = random(1, 100)
local loot
if rnd > 99 then
    loot = "gem"
elseif rnd == 99 then
    loot = "iron"
elseif rnd >= 97 then
    loot = "cloth"
elseif rnd >= 95 then
    loot = "wood"
elseif rnd >= 93 then
    loot = "white"
elseif rnd >= 90 then
    loot = "red"
elseif rnd >= 85 then
    loot = "blue"
elseif rnd >= 80 then
    loot = "green"
elseif rnd >= 76 then
    loot = "black"
elseif rnd >= 71 then
    loot = "dagger"
elseif rnd >= 66 then
    loot = "shield"
elseif rnd >= 61 then
    loot = "sword"
elseif rnd >= 56 then
    loot = "leather"
elseif rnd >= 46 then
    loot = "raft"
elseif rnd >= 36 then
    loot = "canoe"
elseif rnd >= 26 then
    loot = "sack"
elseif rnd >= 16 then
    loot = "bag"
else
    loot = "gem"
end

self:command("steal " .. loot .. " " .. actor.name)
