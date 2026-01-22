-- Trigger: illusory_wall_glasses_examine
-- Zone: 364, ID: 5
-- Type: OBJECT, Flags: COMMAND
-- Status: NEEDS_REVIEW
--   -- UNCONVERTED: breal
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
-- switch on zone
if zone == 16 then
    local region = "outback"
elseif zone == 18 then
    local region = "shadows"
elseif zone == 20 then
    local region = "merchant"
elseif zone == 23 or zone == 24 or zone == 25 or zone == 26 or zone == 27 then
    local region = "caelia_west"
elseif zone == 28 then
    local region = "river"
elseif zone == 30 or zone == 31 or zone == 32 or zone == 33 or zone == 34 or zone == 53 then
    local region = "mielikki"
elseif zone == 35 or zone == 36 or zone == 37 then
    local region = "mielikki_forest"
elseif zone == 40 then
    local region = "labyrinth"
elseif zone == 41 or zone == 42 then
    local region = "split"
elseif zone == 43 then
    local region = "theater"
elseif zone == 51 then
    local region = "rocky_tunnels"
elseif zone == 52 then
    local region = "lava"
elseif zone == 54 or zone == 127 or zone == 128 or zone == 361 then
    local region = "misty"
elseif zone == 55 then
    local region = "combat"
elseif zone == 60 or zone == 61 or zone == 62 then
    local region = "anduin"
elseif zone == 69 then
    local region = "pastures"
elseif zone == 70 then
    local region = "great_road"
elseif zone == 73 then
    local region = "nswamps"
elseif zone == 80 or zone == 81 or zone == 82 then
    local region = "farmlands"
elseif zone == 83 then
    local region = "frakati"
elseif zone == 85 then
    local region = "cathedral"
elseif zone == 86 then
    local region = "meercats"
elseif zone == 87 then
    local region = "logging"
elseif zone == 88 then
    local region = "dairy"
elseif zone == 100 then
    local region = "ickle"
elseif zone == 102 then
    local region = "frostbite"
elseif zone == 103 then
    local region = "phoenix"
elseif zone == 117 or zone == 118 or zone == 119 then
    local region = "blue_fog_trail"
elseif zone == 120 or zone == 121 or zone == 122 then
    local region = "twisted"
elseif zone == 123 or zone == 124 then
    local region = "megalith"
elseif zone == 125 or zone == 126 then
    local region = "tower"
elseif zone == 133 then
    local region = "miner"
elseif zone == 136 then
    local region = "morgan"
elseif zone == 160 or zone == 164 then
    local region = "mystwatch"
elseif zone == 161 then
    local region = "desert"
elseif zone == 162 then
    local region = "pyramid"
elseif zone == 163 then
    local region = "highlands"
elseif zone == 169 then
    local region = "haunted"
elseif zone == 172 then
    local region = "citadel"
elseif zone == 173 then
    local region = "chaos"
elseif zone == 178 then
    local region = "canyon"
elseif zone == 180 then
    local region = "topiary"
elseif zone == 185 then
    local region = "abbey"
elseif zone == 203 then
    local region = "plains"
elseif zone == 237 then
    local region = "dheduu"
elseif zone == 238 then
    local region = "dargentan"
elseif zone == 300 or zone == 301 then
    local region = "ogakh"
elseif zone == 302 then
    local region = "bluebonnet"
elseif zone == 324 or zone == 325 then
    local region = "caelia_east"
elseif zone == 350 or zone == 351 then
    local region = "brush"
elseif zone == 360 then
    local region = "kaaz"
elseif zone == 362 or zone == 411 or zone == 412 then
    local region = "seawitch"
elseif zone == 363 then
    local region = "smuggler"
elseif zone == 364 then
    local region = "sirestis"
elseif zone == 365 then
    local region = "ancient_ruins"
elseif zone == 370 then
    local region = "minithawkin"
elseif zone == 390 or zone == 391 then
    local region = "arabel"
elseif zone == 410 then
    local region = "hive"
elseif zone == 430 or zone == 431 or zone == 432 then
    local region = "demise"
elseif zone == 462 then
    local region = "nukreth"
elseif zone == 464 then
    local region = "aviary"
elseif zone == 470 or zone == 471 or zone == 472 or zone == 473 or zone == 474 then
    local region = "graveyard"
elseif zone == 476 then
    local region = "earth"
elseif zone == 477 then
    local region = "water"
    -- UNCONVERTED: breal
elseif zone == 478 then
    local region = "fire"
elseif zone == 480 then
    local region = "barrow"
elseif zone == 481 or zone == 482 then
    local region = "fiery"
elseif zone == 484 then
    local region = "doom"
elseif zone == 488 then
    local region = "air"
elseif zone == 489 then
    local region = "lokari"
elseif zone == 490 or zone == 491 then
    local region = "griffin"
elseif zone == 492 then
    local region = "blackice"
elseif zone == 495 then
    local region = "nymrill"
elseif zone == 502 then
    local region = "bayou"
elseif zone == 510 or zone == 511 then
    local region = "nordus"
elseif zone == 520 then
    local region = "templace"
elseif zone == 530 or zone == 531 or zone == 532 then
    local region = "sunken"
elseif zone == 533 then
    local region = "cult"
elseif zone == 534 or zone == 535 then
    local region = "frost"
elseif zone == 550 or zone == 551 then
    local region = "tech"
elseif zone == 552 then
    local region = "black_woods"
elseif zone == 553 then
    local region = "kaas_plains"
elseif zone == 554 then
    local region = "dark_mountains"
elseif zone == 555 then
    local region = "cold_fields"
elseif zone == 556 then
    local region = "iron"
elseif zone == 557 then
    local region = "blackrock"
elseif zone == 558 or zone == 559 then
    local region = "eldorian"
elseif zone == 564 then
    local region = "blacklake"
elseif zone == 580 or zone == 581 or zone == 582 then
    local region = "odz"
elseif zone == 583 then
    local region = "syric"
elseif zone == 584 or zone == 585 then
    local region = "kod"
elseif zone == 586 or zone == 587 then
    local region = "beachhead"
elseif zone == 588 or zone == 589 then
    local region = "ice_warrior"
elseif zone == 590 then
    local region = "haven"
elseif zone == 615 then
    local region = "hollow"
elseif zone == 625 then
    local region = "rhell"
else
    return _return_value
end
if actor:get_quest_stage("illusory_wall") == 2 and not actor:get_has_completed("illusory_wall") then
    if room:get_up("bits") /= DOOR or room:get_down("bits") /= DOOR or room:get_east("bits") /= DOOR or room:get_west("bits") /= DOOR or room:get_north("bits") /= DOOR or room:get_south("bits") /= DOOR then
        if actor.quest_variable[illusory_wall:region] then
            actor:send("<b:white>You have already learned all you can from this region.</>")
            _return_value = false
            return _return_value
        else
            actor.name:set_quest_var("illusory_wall", "%region%", 1)
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
            actor.name:set_quest_var("illusory_wall", "total", clue)
            if actor:get_quest_var("illusory_wall:total") >= 20 then
                wait(2)
                self.room:spawn_mobile(364, 2)
                self.room:find_actor("post-commander"):command("mskillset %actor.name% illusory wall")
                actor:send("<b:cyan>You have learned everything you need to cast illusory walls!</>")
                actor.name:complete_quest("illusory_wall")
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