-- Trigger: Illusory Wall progress journal
-- Zone: 4, ID: 47
-- Type: OBJECT, Flags: LOOK
-- Status: NEEDS_REVIEW
--   Syntax error: luac: <Illusory Wall progress journal>:4: 'then' expected near 'wall'
--   Complex nesting: 109 if statements
--   Large script: 18084 chars
--
-- Original DG Script: #447

-- Converted from DG Script #447: Illusory Wall progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if string.find(arg, "illusory") or string.find(arg, "illusory") wall or string.find(arg, "illusory_wall") then
    if (string.find(actor.class, "Illusionist") or string.find(actor.class, "Bard")) and actor.level >= 50 then
        _return_value = false
        local stage = actor:get_quest_stage("illusory_wall")
        local master = mobiles.template(364, 2).name
        actor:send("<b:green>&uIllusory Wall</>")
        actor:send("Minimum Level: 57")
        if actor:get_has_completed("illusory_wall") then
            local status = "Completed!"
        elseif stage then
            local status = "In Progress"
        else
            local status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
        if stage > 0 and not actor:get_has_completed("illusory_wall") then
            actor:send("Quest Master: " .. tostring(master))
            -- switch on stage
            if stage == 1 then
                local item1 = actor:get_quest_var("illusory_wall:10307")
                local item2 = actor:get_quest_var("illusory_wall:18511")
                local item3 = actor:get_quest_var("illusory_wall:41005")
                local item4 = actor:get_quest_var("illusory_wall:51017")
                actor:send("You're looking for things to make magical spectacles.")
                if item1 or item2 or item3 or item4 then
                    actor:send("</>")
                    actor:send("</>You have already brought me:")
                    if item1 then
                        actor:send("- <b:white>" .. tostring(objects.template(103, 7).name) .. "</>")
                    end
                    if item2 then
                        actor:send("- <b:white>" .. tostring(objects.template(185, 11).name) .. "</>")
                    end
                    if item3 then
                        actor:send("- <b:white>" .. tostring(objects.template(410, 5).name) .. "</>")
                    end
                    if item4 then
                        actor:send("- <b:white>" .. tostring(objects.template(510, 17).name) .. "</>")
                    end
                end
                actor:send("</>")
                actor:send("You still need to find:")
                if not item1 and not item2 then
                    actor:send("- <b:yellow>" .. "%get.obj_shortdesc[10307]%</> or <b:yellow>%get.obj_shortdesc[18511]%</>")
                end
                if not item3 then
                    actor:send("- <b:yellow>" .. tostring(objects.template(410, 5).name) .. "</>")
                end
                if not item4 then
                    actor:send("- <b:yellow>" .. tostring(objects.template(510, 17).name) .. "</>")
                end
            elseif stage == 2 then
                actor:send("Complete your study of doors in 20 regions.")
                actor:send("</>")
                local doors = actor:get_quest_var("illusory_wall:total")
                actor:send("You have examined doors in <b:magenta>" .. tostring(doors) .. "</> regions:")
                if actor:get_quest_var("illusory_wall:Outback") then
                    actor:send("- <blue>Rocky Outback</>")
                end
                if actor:get_quest_var("illusory_wall:Shadows") then
                    actor:send("- <blue>Forest of Shadows</>")
                end
                if actor:get_quest_var("illusory_wall:Merchant") then
                    actor:send("- <blue>Old Merchant Trail</>")
                end
                if actor:get_quest_var("illusory_wall:Caelia_West") then
                    actor:send("- <blue>South Caelia West</>")
                end
                if actor:get_quest_var("illusory_wall:River") then
                    actor:send("- <blue>Blue-Fog River</>")
                end
                if actor:get_quest_var("illusory_wall:Mielikki") then
                    actor:send("- <blue>The Village of Mielikki</>")
                end
                if actor:get_quest_var("illusory_wall:Mielikki_Forest") then
                    actor:send("- <blue>Mielikki's Forests</>")
                end
                if actor:get_quest_var("illusory_wall:Labyrinth") then
                    actor:send("- <blue>Laveryn Labyrinth</>")
                end
                if actor:get_quest_var("illusory_wall:Split") then
                    actor:send("- <blue>Split Skull</>")
                end
                if actor:get_quest_var("illusory_wall:Theatre") then
                    actor:send("- <blue>The Theatre in Anduin</>")
                end
                if actor:get_quest_var("illusory_wall:Rocky_Tunnels") then
                    actor:send("- <blue>Rocky Tunnels</>")
                end
                if actor:get_quest_var("illusory_wall:Lava") then
                    actor:send("- <blue>Lava Tunnels</>")
                end
                if actor:get_quest_var("illusory_wall:Misty") then
                    actor:send("- <blue>Misty Caverns</>")
                end
                if actor:get_quest_var("illusory_wall:Combat") then
                    actor:send("- <blue>Combat in Eldoria</>")
                end
                if actor:get_quest_var("illusory_wall:Anduin") then
                    actor:send("- <blue>The City of Anduin</>")
                end
                if actor:get_quest_var("illusory_wall:Pastures") then
                    actor:send("- <blue>Anduin Pastures</>")
                end
                if actor:get_quest_var("illusory_wall:Great_Road") then
                    actor:send("- <blue>The Great Road</>")
                end
                if actor:get_quest_var("illusory_wall:Nswamps") then
                    actor:send("- <blue>The Northern Swamps</>")
                end
                if actor:get_quest_var("illusory_wall:Farmlands") then
                    actor:send("- <blue>Mielikki Farmlands</>")
                end
                if actor:get_quest_var("illusory_wall:Frakati") then
                    actor:send("- <blue>Frakati Reservation</>")
                end
                if actor:get_quest_var("illusory_wall:Cathedral") then
                    actor:send("- <blue>Cathedral of Betrayal</>")
                end
                if actor:get_quest_var("illusory_wall:Meercats") then
                    actor:send("- <blue>Kingdom of the Meer Cats</>")
                end
                if actor:get_quest_var("illusory_wall:Logging") then
                    actor:send("- <blue>The Logging Camp</>")
                end
                if actor:get_quest_var("illusory_wall:Dairy") then
                    actor:send("- <blue>The Dairy Farm</>")
                end
                if actor:get_quest_var("illusory_wall:Ickle") then
                    actor:send("- <blue>Ickle</>")
                end
                if actor:get_quest_var("illusory_wall:Frostbite") then
                    actor:send("- <blue>Mount Frostbite</>")
                end
                if actor:get_quest_var("illusory_wall:Phoenix") then
                    actor:send("- <blue>Phoenix Feather Hot Spring</>")
                end
                if actor:get_quest_var("illusory_wall:Blue_Fog_Trail") then
                    actor:send("- <blue>Blue-Fog Trail</>")
                end
                if actor:get_quest_var("illusory_wall:Twisted") then
                    actor:send("- <blue>Twisted Forest</>")
                end
                if actor:get_quest_var("illusory_wall:Megalith") then
                    actor:send("- <blue>The Sacred Megalith</>")
                end
                if actor:get_quest_var("illusory_wall:Tower") then
                    actor:send("- <blue>The Tower in the Wasted</>")
                end
                if actor:get_quest_var("illusory_wall:Miner") then
                    actor:send("- <blue>The Miner's Cavern</>")
                end
                if actor:get_quest_var("illusory_wall:Morgan") then
                    actor:send("- <blue>Morgan Hill</>")
                end
                if actor:get_quest_var("illusory_wall:Mystwatch") then
                    actor:send("- <blue>The Fortress of Mystwatch</>")
                end
                if actor:get_quest_var("illusory_wall:Desert") then
                    actor:send("- <blue>Gothra Desert</>")
                end
                if actor:get_quest_var("illusory_wall:Pyramid") then
                    actor:send("- <blue>Gothra Pyramid</>")
                end
                if actor:get_quest_var("illusory_wall:Highlands") then
                    actor:send("- <blue>Highlands</>")
                end
                if actor:get_quest_var("illusory_wall:Haunted") then
                    actor:send("- <blue>The Haunted House</>")
                end
                if actor:get_quest_var("illusory_wall:Citadel") then
                    actor:send("- <blue>The Citadel of Testing</>")
                end
                if actor:get_quest_var("illusory_wall:Chaos") then
                    actor:send("- <blue>Temple of Chaos</>")
                end
                if actor:get_quest_var("illusory_wall:Canyon") then
                    actor:send("- <blue>Canyon</>")
                end
                if actor:get_quest_var("illusory_wall:Topiary") then
                    actor:send("- <blue>Mielikki's Topiary</>")
                end
                if actor:get_quest_var("illusory_wall:Abbey") then
                    actor:send("- <blue>The Abbey</>")
                end
                if actor:get_quest_var("illusory_wall:Plains") then
                    actor:send("- <blue>Gothra Plains</>")
                end
                if actor:get_quest_var("illusory_wall:Dheduu") then
                    actor:send("- <blue>Dheduu</>")
                end
                if actor:get_quest_var("illusory_wall:Dargentan") then
                    actor:send("- <blue>Dargentan's Lair</>")
                end
                if actor:get_quest_var("illusory_wall:Ogakh") then
                    actor:send("- <blue>Ogakh</>")
                end
                if actor:get_quest_var("illusory_wall:Bluebonnet") then
                    actor:send("- <blue>Bluebonnet Pass</>")
                end
                if actor:get_quest_var("illusory_wall:Caelia_East") then
                    actor:send("- <blue>South Caelia East</>")
                end
                if actor:get_quest_var("illusory_wall:Brush") then
                    actor:send("- <blue>Brush Lands</>")
                end
                if actor:get_quest_var("illusory_wall:Kaaz") then
                    actor:send("- <blue>Temple of the Kaaz</>")
                end
                if actor:get_quest_var("illusory_wall:SeaWitch") then
                    actor:send("- <blue>Sea's Lullaby</>")
                end
                if actor:get_quest_var("illusory_wall:Smuggler") then
                    actor:send("- <blue>Smuggler's Hideout</>")
                end
                if actor:get_quest_var("illusory_wall:Sirestis") then
                    actor:send("- <blue>Sirestis' Folly</>")
                end
                if actor:get_quest_var("illusory_wall:Ancient_Ruins") then
                    actor:send("- <blue>Ancient Ruins</>")
                end
                if actor:get_quest_var("illusory_wall:Minithawkin") then
                    actor:send("- <blue>Minithawkin Mines</>")
                end
                if actor:get_quest_var("illusory_wall:Arabel") then
                    actor:send("- <blue>Arabel Ocean</>")
                end
                if actor:get_quest_var("illusory_wall:Hive") then
                    actor:send("- <blue>Hive</>")
                end
                if actor:get_quest_var("illusory_wall:Demise") then
                    actor:send("- <blue>Demise Keep</>")
                end
                if actor:get_quest_var("illusory_wall:Aviary") then
                    actor:send("- <blue>Ickle's Aviary</>")
                end
                if actor:get_quest_var("illusory_wall:Graveyard") then
                    actor:send("- <blue>The Graveyard</>")
                end
                if actor:get_quest_var("illusory_wall:Earth") then
                    actor:send("- <blue>The Plane of Earth</>")
                end
                if actor:get_quest_var("illusory_wall:Water") then
                    actor:send("- <blue>The Plane of Water</>")
                end
                if actor:get_quest_var("illusory_wall:Fire") then
                    actor:send("- <blue>The Plane of Fire</>")
                end
                if actor:get_quest_var("illusory_wall:Barrow") then
                    actor:send("- <blue>The Barrow</>")
                end
                if actor:get_quest_var("illusory_wall:Fiery") then
                    actor:send("- <blue>Fiery Island</>")
                end
                if actor:get_quest_var("illusory_wall:Nukreth") then
                    actor:send("- <blue>Nukreth Spire</>")
                end
                if actor:get_quest_var("illusory_wall:Doom") then
                    actor:send("- <blue>An Ancient Forest and Pyramid</>")
                end
                if actor:get_quest_var("illusory_wall:Air") then
                    actor:send("- <blue>The Plane of Air</>")
                end
                if actor:get_quest_var("illusory_wall:Lokari") then
                    actor:send("- <blue>Lokari's Keep</>")
                end
                if actor:get_quest_var("illusory_wall:Griffin") then
                    actor:send("- <blue>Griffin Island</>")
                end
                if actor:get_quest_var("illusory_wall:BlackIce") then
                    actor:send("- <blue>Black-Ice Desert</>")
                end
                if actor:get_quest_var("illusory_wall:Nymrill") then
                    actor:send("- <blue>The Lost City of Nymrill</>")
                end
                if actor:get_quest_var("illusory_wall:Bayou") then
                    actor:send("- <blue>The Bayou</>")
                end
                if actor:get_quest_var("illusory_wall:Nordus") then
                    actor:send("- <blue>The Enchanted Village of Nordus</>")
                end
                if actor:get_quest_var("illusory_wall:Templace") then
                    actor:send("- <blue>Templace</>")
                end
                if actor:get_quest_var("illusory_wall:Sunken") then
                    actor:send("- <blue>Sunken Castle</>")
                end
                if actor:get_quest_var("illusory_wall:Cult") then
                    actor:send("- <blue>Ice Cult</>")
                end
                if actor:get_quest_var("illusory_wall:Frost") then
                    actor:send("- <blue>Frost Valley</>")
                end
                if actor:get_quest_var("illusory_wall:Technitzitlan") then
                    actor:send("- <blue>Technitzitlan</>")
                end
                if actor:get_quest_var("illusory_wall:Black_Woods") then
                    actor:send("- <blue>Black Woods</>")
                end
                if actor:get_quest_var("illusory_wall:Kaas_Plains") then
                    actor:send("- <blue>Kaas Plains</>")
                end
                if actor:get_quest_var("illusory_wall:Dark_Mountains") then
                    actor:send("- <blue>Dark Mountains</>")
                end
                if actor:get_quest_var("illusory_wall:Cold_Fields") then
                    actor:send("- <blue>Cold Fields</>")
                end
                if actor:get_quest_var("illusory_wall:Iron") then
                    actor:send("- <blue>Iron Hills</>")
                end
                if actor:get_quest_var("illusory_wall:Blackrock") then
                    actor:send("- <blue>Black Rock Trail</>")
                end
                if actor:get_quest_var("illusory_wall:Eldorian") then
                    actor:send("- <blue>Eldorian Foothills</>")
                end
                if actor:get_quest_var("illusory_wall:Blacklake") then
                    actor:send("- <blue>Black Lake</>")
                end
                if actor:get_quest_var("illusory_wall:Odz") then
                    actor:send("- <blue>Odaishyozen</>")
                end
                if actor:get_quest_var("illusory_wall:Syric") then
                    actor:send("- <blue>Syric Mountain Trail</>")
                end
                if actor:get_quest_var("illusory_wall:KoD") then
                    actor:send("- <blue>Kingdom of Dreams</>")
                end
                if actor:get_quest_var("illusory_wall:Beachhead") then
                    actor:send("- <blue>Beachhead</>")
                end
                if actor:get_quest_var("illusory_wall:Ice_Warrior") then
                    actor:send("- <blue>The Ice Warrior's Compound</>")
                end
                if actor:get_quest_var("illusory_wall:Haven") then
                    actor:send("- <blue>Sacred Haven</>")
                end
                if actor:get_quest_var("illusory_wall:Hollow") then
                    actor:send("- <blue>Enchanted Hollow</>")
                end
                if actor:get_quest_var("illusory_wall:Rhell") then
                    actor:send("- <blue>The Rhell Forest</>")
                end
                actor:send("</>")
                local remaining = (20 - doors)
                actor:send("Locate doors in <b:magenta>" .. tostring(remaining) .. "</> more regions.")
                actor:send("</>")
                actor:send("If you need new lenses return to " .. tostring(master) .. " and say, <b:magenta>\"I need new glasses\"</>.")
            end
        end
    end
end
return _return_value