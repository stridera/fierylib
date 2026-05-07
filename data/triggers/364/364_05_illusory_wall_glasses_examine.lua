-- Trigger: illusory_wall_glasses_examine
-- Zone: 364, ID: 5
-- Type: OBJECT, Flags: COMMAND
-- Status: CLEAN
--
-- Worn glasses intercept the player's `examine` command and let them study
-- doors of the room they are in. Each region (group of legacy zones) only
-- counts once. After studying doors in 20 distinct regions, Lyara is
-- summoned to teach Illusory Wall and the quest completes.
--
-- Original DG Script: #36405

-- Command filter: examine (full word; ignore the standalone "e" abbrev)
if cmd ~= "examine" then
    return true
end
-- DG passed `arg` to mean "user supplied an argument"; if so, leave to default.
if arg and arg ~= "" then
    return true
end

-- Zone -> region key. Legacy zones grouped by area name.
local ZONE_TO_REGION = {
    [16]  = "Outback",
    [18]  = "Shadows",
    [20]  = "Merchant",
    [23]  = "Caelia_West", [24] = "Caelia_West", [25] = "Caelia_West",
    [26]  = "Caelia_West", [27] = "Caelia_West",
    [28]  = "River",
    [30]  = "Mielikki", [31] = "Mielikki", [32] = "Mielikki",
    [33]  = "Mielikki", [34] = "Mielikki", [53] = "Mielikki",
    [35]  = "Mielikki_Forest", [36] = "Mielikki_Forest", [37] = "Mielikki_Forest",
    [40]  = "Labyrinth",
    [41]  = "Split", [42] = "Split",
    [43]  = "Theatre",
    [51]  = "Rocky_Tunnels",
    [52]  = "Lava",
    [54]  = "Misty", [127] = "Misty", [128] = "Misty", [361] = "Misty",
    [55]  = "Combat",
    [60]  = "Anduin", [61] = "Anduin", [62] = "Anduin",
    [69]  = "Pastures",
    [70]  = "Great_Road",
    [73]  = "Nswamps",
    [80]  = "Farmlands", [81] = "Farmlands", [82] = "Farmlands",
    [83]  = "Frakati",
    [85]  = "Cathedral",
    [86]  = "Meercats",
    [87]  = "Logging",
    [88]  = "Dairy",
    [100] = "Ickle",
    [102] = "Frostbite",
    [103] = "Phoenix",
    [117] = "Blue_Fog_Trail", [118] = "Blue_Fog_Trail", [119] = "Blue_Fog_Trail",
    [120] = "Twisted", [121] = "Twisted", [122] = "Twisted",
    [123] = "Megalith", [124] = "Megalith",
    [125] = "Tower", [126] = "Tower",
    [133] = "Miner",
    [136] = "Morgan",
    [160] = "Mystwatch", [164] = "Mystwatch",
    [161] = "Desert",
    [162] = "Pyramid",
    [163] = "Highlands",
    [169] = "Haunted",
    [172] = "Citadel",
    [173] = "Chaos",
    [178] = "Canyon",
    [180] = "Topiary",
    [185] = "Abbey",
    [203] = "Plains",
    [237] = "Dheduu",
    [238] = "Dargentan",
    [300] = "Ogakh", [301] = "Ogakh",
    [302] = "Bluebonnet",
    [324] = "Caelia_East", [325] = "Caelia_East",
    [350] = "Brush", [351] = "Brush",
    [360] = "Kaaz",
    [362] = "SeaWitch", [411] = "SeaWitch", [412] = "SeaWitch",
    [363] = "Smuggler",
    [364] = "Sirestis",
    [365] = "Ancient_Ruins",
    [370] = "Minithawkin",
    [390] = "Arabel", [391] = "Arabel",
    [410] = "Hive",
    [430] = "Demise", [431] = "Demise", [432] = "Demise",
    [462] = "Nukreth",
    [464] = "Aviary",
    [470] = "Graveyard", [471] = "Graveyard", [472] = "Graveyard",
    [473] = "Graveyard", [474] = "Graveyard",
    [476] = "Earth",
    [477] = "Water",
    [478] = "Fire",
    [480] = "Barrow",
    [481] = "Fiery", [482] = "Fiery",
    [484] = "Doom",
    [488] = "Air",
    [489] = "Lokari",
    [490] = "Griffin", [491] = "Griffin",
    [492] = "BlackIce",
    [495] = "Nymrill",
    [502] = "Bayou",
    [510] = "Nordus", [511] = "Nordus",
    [520] = "Templace",
    [530] = "Sunken", [531] = "Sunken", [532] = "Sunken",
    [533] = "Cult",
    [534] = "Frost", [535] = "Frost",
    [550] = "Technitzitlan", [551] = "Technitzitlan",
    [552] = "Black_Woods",
    [553] = "Kaas_Plains",
    [554] = "Dark_Mountains",
    [555] = "Cold_Fields",
    [556] = "Iron",
    [557] = "Blackrock",
    [558] = "Eldorian", [559] = "Eldorian",
    [564] = "Blacklake",
    [580] = "Odz", [581] = "Odz", [582] = "Odz",
    [583] = "Syric",
    [584] = "KoD", [585] = "KoD",
    [586] = "Beachhead", [587] = "Beachhead",
    [588] = "Ice_Warrior", [589] = "Ice_Warrior",
    [590] = "Haven",
    [615] = "Hollow",
    [625] = "Rhell",
}

local room = self.room
local region = ZONE_TO_REGION[room.zone_id]
if not region then
    return true
end

if actor:get_quest_stage("illusory_wall") ~= 2 or actor:get_has_completed("illusory_wall") then
    return true
end

-- TODO(parity): legacy DG only credits a room if it has at least one DOOR-flag
-- exit in every cardinal direction (n/s/e/w/u/d). The runtime exit API we
-- currently expose does not expose the DOOR flag in a uniform way, so for now
-- we credit the room if it has any closeable exit. Once `exit:has_door()` (or
-- equivalent) lands, gate this check on it.
local has_any_door = false
for _, dir in ipairs({"north", "south", "east", "west", "up", "down"}) do
    local ex = room["exit_" .. dir] or (room.exit and room:exit(dir))
    if ex then has_any_door = true; break end
end
if not has_any_door then
    return true
end

local region_key = "illusory_wall:" .. region
if actor:get_quest_var(region_key) then
    actor:send("<b:white>You have already learned all you can from this region.</>")
    return true
end

actor:set_quest_var("illusory_wall", region, 1)
local clue = (actor:get_quest_var("illusory_wall:total") or 0) + 1
actor:send("<b:white>You begin to analyze the room.</>")
wait(3)
actor:send("<b:yellow>Analyzing...</>")
wait(3)
actor:send("<b:yellow>Analyzing...</>")
wait(3)
actor:send("<b:yellow>Analyzing...</>")
wait(3)
actor:send("<b:cyan>You gain more insight on doors and barriers!</>")
actor:set_quest_var("illusory_wall", "total", clue)

if clue >= 20 then
    wait(2)
    self.room:spawn_mobile(364, 2)
    local lyara = self.room:find_actor("post-commander")
    if lyara then
        lyara:command("mskillset " .. tostring(actor.name) .. " illusory wall")
    end
    actor:send("<b:cyan>You have learned everything you need to cast illusory walls!</>")
    actor:complete_quest("illusory_wall")
    wait(1)
    if lyara then
        world.destroy(lyara)
    end
end
return true
