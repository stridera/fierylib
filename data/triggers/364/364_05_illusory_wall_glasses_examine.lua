-- Trigger: illusory_wall_glasses_examine
-- Zone: 364, ID: 5
-- Type: OBJECT, Flags: COMMAND
-- Status: CLEAN (reviewed 2026-01-22)
--   Complex nesting: 9 if statements
--   Large script: 8193 chars
--
-- Original DG Script: #36405

-- Converted from DG Script #36405: illusory_wall_glasses_examine
-- Original: OBJECT trigger, flags: COMMAND, probability: 3%

-- 3% chance to trigger
if not percent_chance(3) then
    return true
end

-- Command filter: examine
if not (cmd == "examine") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
-- switch on cmd
if cmd == "e" then
    _return_value = false
    return _return_value
end
if arg then
    _return_value = false
    return _return_value
end
local room = self.room
local zone = (room.id / 100)
local region = nil
-- switch on zone
if zone == 16 then
    region = "outback"
elseif zone == 18 then
    region = "shadows"
elseif zone == 20 then
    region = "merchant"
elseif zone == 23 or zone == 24 or zone == 25 or zone == 26 or zone == 27 then
    region = "caelia_west"
elseif zone == 28 then
    region = "river"
elseif zone == 30 or zone == 31 or zone == 32 or zone == 33 or zone == 34 or zone == 53 then
    region = "mielikki"
elseif zone == 35 or zone == 36 or zone == 37 then
    region = "mielikki_forest"
elseif zone == 40 then
    region = "labyrinth"
elseif zone == 41 or zone == 42 then
    region = "split"
elseif zone == 43 then
    region = "theater"
elseif zone == 51 then
    region = "rocky_tunnels"
elseif zone == 52 then
    region = "lava"
elseif zone == 54 or zone == 127 or zone == 128 or zone == 361 then
    region = "misty"
elseif zone == 55 then
    region = "combat"
elseif zone == 60 or zone == 61 or zone == 62 then
    region = "anduin"
elseif zone == 69 then
    region = "pastures"
elseif zone == 70 then
    region = "great_road"
elseif zone == 73 then
    region = "nswamps"
elseif zone == 80 or zone == 81 or zone == 82 then
    region = "farmlands"
elseif zone == 83 then
    region = "frakati"
elseif zone == 85 then
    region = "cathedral"
elseif zone == 86 then
    region = "meercats"
elseif zone == 87 then
    region = "logging"
elseif zone == 88 then
    region = "dairy"
elseif zone == 100 then
    region = "ickle"
elseif zone == 102 then
    region = "frostbite"
elseif zone == 103 then
    region = "phoenix"
elseif zone == 117 or zone == 118 or zone == 119 then
    region = "blue_fog_trail"
elseif zone == 120 or zone == 121 or zone == 122 then
    region = "twisted"
elseif zone == 123 or zone == 124 then
    region = "megalith"
elseif zone == 125 or zone == 126 then
    region = "tower"
elseif zone == 133 then
    region = "miner"
elseif zone == 136 then
    region = "morgan"
elseif zone == 160 or zone == 164 then
    region = "mystwatch"
elseif zone == 161 then
    region = "desert"
elseif zone == 162 then
    region = "pyramid"
elseif zone == 163 then
    region = "highlands"
elseif zone == 169 then
    region = "haunted"
elseif zone == 172 then
    region = "citadel"
elseif zone == 173 then
    region = "chaos"
elseif zone == 178 then
    region = "canyon"
elseif zone == 180 then
    region = "topiary"
elseif zone == 185 then
    region = "abbey"
elseif zone == 203 then
    region = "plains"
elseif zone == 237 then
    region = "dheduu"
elseif zone == 238 then
    region = "dargentan"
elseif zone == 300 or zone == 301 then
    region = "ogakh"
elseif zone == 302 then
    region = "bluebonnet"
elseif zone == 324 or zone == 325 then
    region = "caelia_east"
elseif zone == 350 or zone == 351 then
    region = "brush"
elseif zone == 360 then
    region = "kaaz"
elseif zone == 362 or zone == 411 or zone == 412 then
    region = "seawitch"
elseif zone == 363 then
    region = "smuggler"
elseif zone == 364 then
    region = "sirestis"
elseif zone == 365 then
    region = "ancient_ruins"
elseif zone == 370 then
    region = "minithawkin"
elseif zone == 390 or zone == 391 then
    region = "arabel"
elseif zone == 410 then
    region = "hive"
elseif zone == 430 or zone == 431 or zone == 432 then
    region = "demise"
elseif zone == 462 then
    region = "nukreth"
elseif zone == 464 then
    region = "aviary"
elseif zone == 470 or zone == 471 or zone == 472 or zone == 473 or zone == 474 then
    region = "graveyard"
elseif zone == 476 then
    region = "earth"
elseif zone == 477 then
    region = "water"
elseif zone == 478 then
    region = "fire"
elseif zone == 480 then
    region = "barrow"
elseif zone == 481 or zone == 482 then
    region = "fiery"
elseif zone == 484 then
    region = "doom"
elseif zone == 488 then
    region = "air"
elseif zone == 489 then
    region = "lokari"
elseif zone == 490 or zone == 491 then
    region = "griffin"
elseif zone == 492 then
    region = "blackice"
elseif zone == 495 then
    region = "nymrill"
elseif zone == 502 then
    region = "bayou"
elseif zone == 510 or zone == 511 then
    region = "nordus"
elseif zone == 520 then
    region = "templace"
elseif zone == 530 or zone == 531 or zone == 532 then
    region = "sunken"
elseif zone == 533 then
    region = "cult"
elseif zone == 534 or zone == 535 then
    region = "frost"
elseif zone == 550 or zone == 551 then
    region = "tech"
elseif zone == 552 then
    region = "black_woods"
elseif zone == 553 then
    region = "kaas_plains"
elseif zone == 554 then
    region = "dark_mountains"
elseif zone == 555 then
    region = "cold_fields"
elseif zone == 556 then
    region = "iron"
elseif zone == 557 then
    region = "blackrock"
elseif zone == 558 or zone == 559 then
    region = "eldorian"
elseif zone == 564 then
    region = "blacklake"
elseif zone == 580 or zone == 581 or zone == 582 then
    region = "odz"
elseif zone == 583 then
    region = "syric"
elseif zone == 584 or zone == 585 then
    region = "kod"
elseif zone == 586 or zone == 587 then
    region = "beachhead"
elseif zone == 588 or zone == 589 then
    region = "ice_warrior"
elseif zone == 590 then
    region = "haven"
elseif zone == 615 then
    region = "hollow"
elseif zone == 625 then
    region = "rhell"
else
    return _return_value
end
if actor:get_quest_stage("illusory_wall") == 2 and not actor:get_has_completed("illusory_wall") then
    if room:get_up("bits") ~= DOOR or room:get_down("bits") ~= DOOR or room:get_east("bits") ~= DOOR or room:get_west("bits") ~= DOOR or room:get_north("bits") ~= DOOR or room:get_south("bits") ~= DOOR then
        if actor:get_quest_var("illusory_wall:" .. region) then
            actor:send("<b:white>You have already learned all you can from this region.</>")
            _return_value = false
            return _return_value
        else
            actor:set_quest_var("illusory_wall", region, 1)
            local clue = actor:get_quest_var("illusory_wall:total") + 1
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
            if actor:get_quest_var("illusory_wall:total") >= 20 then
                wait(2)
                self.room:spawn_mobile(364, 2)
                self.room:find_actor("post-commander"):command("mskillset %actor.name% illusory wall")
                actor:send("<b:cyan>You have learned everything you need to cast illusory walls!</>")
                actor:complete_quest("illusory_wall")
                wait(1)
                world.destroy(mob)
            end
        end
    else
        _return_value = false
    end
else
    _return_value = false
end
return _return_value