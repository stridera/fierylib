-- Trigger: illusory_wall_lyara_status
-- Zone: 364, ID: 6
-- Type: MOB, Flags: SPEECH
-- Status: NEEDS_REVIEW
--   Complex nesting: 106 if statements
--   Large script: 14518 chars
--
-- Original DG Script: #36406

-- Converted from DG Script #36406: illusory_wall_lyara_status
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: status status? progress progress?
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "status") or string.find(string.lower(speech), "status?") or string.find(string.lower(speech), "progress") or string.find(string.lower(speech), "progress?")) then
    return true  -- No matching keywords
end
local stage = actor:get_quest_stage("illusory_wall")
local item1 = actor:get_quest_var("illusory_wall:10307")
local item2 = actor:get_quest_var("illusory_wall:18511")
local item3 = actor:get_quest_var("illusory_wall:41005")
local item4 = actor:get_quest_var("illusory_wall:51017")
wait(2)
if actor.class ~= "illusionist" and actor.class ~= "bard" then
    self.room:send(tostring(self.name) .. " says, 'I appreciate your interest but I have nothing I")
    self.room:send("</>can teach you.'")
elseif actor:get_has_completed("illusory_wall") then
    self.room:send(tostring(self.name) .. " says, 'I have already taught you <b:magenta>I<cyan>l<magenta>l<cyan>u<magenta>s<cyan>o<magenta>r<cyan>y <magenta>W<cyan>a<magenta>l<cyan>l</>.")
    self.room:send("</>I have nothing else to teach you, soldier.'")
    self:command("salute " .. tostring(actor.name))
elseif stage == 0 then
    self:say("I haven't agreed to teach you yet.")
elseif stage == 1 then
    self:say("You're looking for things to make magical spectacles.")
    if item1 or item2 or item3 or item4 then
        -- (empty room echo)
        self.room:send("</>You have already brought me:")
        if item1 then
            self.room:send("- <b:white>" .. tostring(objects.template(103, 7).name) .. "</>")
        end
        if item2 then
            self.room:send("- <b:white>" .. tostring(objects.template(185, 11).name) .. "</>")
        end
        if item3 then
            self.room:send("- <b:white>" .. tostring(objects.template(410, 5).name) .. "</>")
        end
        if item4 then
            self.room:send("- <b:white>" .. tostring(objects.template(510, 17).name) .. "</>")
        end
    end
    -- (empty room echo)
    self.room:send("You still need to find:")
    if not item1 and not item2 then
        self.room:send("- <b:yellow>" .. "%get.obj_shortdesc[10307]%</> or <b:yellow>%get.obj_shortdesc[18511]%</>")
    end
    if not item3 then
        self.room:send("- <b:yellow>" .. tostring(objects.template(410, 5).name) .. "</>")
    end
    if not item4 then
        self.room:send("- <b:yellow>" .. tostring(objects.template(510, 17).name) .. "</>")
    end
elseif stage == 2 then
    self:say("Complete your study of doors in 20 regions.")
    -- (empty room echo)
    local doors = actor:get_quest_var("illusory_wall:total")
    self.room:send("You have examined doors in <b:magenta>" .. tostring(doors) .. "</> regions:")
    if actor:get_quest_var("illusory_wall:Outback") then
        self.room:send("- <blue>Rocky Outback</>")
    end
    if actor:get_quest_var("illusory_wall:Shadows") then
        self.room:send("- <blue>Forest of Shadows</>")
    end
    if actor:get_quest_var("illusory_wall:Merchant") then
        self.room:send("- <blue>Old Merchant Trail</>")
    end
    if actor:get_quest_var("illusory_wall:Caelia_West") then
        self.room:send("- <blue>South Caelia West</>")
    end
    if actor:get_quest_var("illusory_wall:River") then
        self.room:send("- <blue>Blue-Fog River</>")
    end
    if actor:get_quest_var("illusory_wall:Mielikki") then
        self.room:send("- <blue>The Village of Mielikki</>")
    end
    if actor:get_quest_var("illusory_wall:Mielikki_Forest") then
        self.room:send("- <blue>Mielikki's Forests</>")
    end
    if actor:get_quest_var("illusory_wall:Labyrinth") then
        self.room:send("- <blue>Laveryn Labyrinth</>")
    end
    if actor:get_quest_var("illusory_wall:Split") then
        self.room:send("- <blue>Split Skull</>")
    end
    if actor:get_quest_var("illusory_wall:Theatre") then
        self.room:send("- <blue>The Theatre in Anduin</>")
    end
    if actor:get_quest_var("illusory_wall:Rocky_Tunnels") then
        self.room:send("- <blue>Rocky Tunnels</>")
    end
    if actor:get_quest_var("illusory_wall:Lava") then
        self.room:send("- <blue>Lava Tunnels</>")
    end
    if actor:get_quest_var("illusory_wall:Misty") then
        self.room:send("- <blue>Misty Caverns</>")
    end
    if actor:get_quest_var("illusory_wall:Combat") then
        self.room:send("- <blue>Combat in Eldoria</>")
    end
    if actor:get_quest_var("illusory_wall:Anduin") then
        self.room:send("- <blue>The City of Anduin</>")
    end
    if actor:get_quest_var("illusory_wall:Pastures") then
        self.room:send("- <blue>Anduin Pastures</>")
    end
    if actor:get_quest_var("illusory_wall:Great_Road") then
        self.room:send("- <blue>The Great Road</>")
    end
    if actor:get_quest_var("illusory_wall:Nswamps") then
        self.room:send("- <blue>The Northern Swamps</>")
    end
    if actor:get_quest_var("illusory_wall:Farmlands") then
        self.room:send("- <blue>Mielikki Farmlands</>")
    end
    if actor:get_quest_var("illusory_wall:Frakati") then
        self.room:send("- <blue>Frakati Reservation</>")
    end
    if actor:get_quest_var("illusory_wall:Cathedral") then
        self.room:send("- <blue>Cathedral of Betrayal</>")
    end
    if actor:get_quest_var("illusory_wall:Meercats") then
        self.room:send("- <blue>Kingdom of the Meer Cats</>")
    end
    if actor:get_quest_var("illusory_wall:Logging") then
        self.room:send("- <blue>The Logging Camp</>")
    end
    if actor:get_quest_var("illusory_wall:Dairy") then
        self.room:send("- <blue>The Dairy Farm</>")
    end
    if actor:get_quest_var("illusory_wall:Ickle") then
        self.room:send("- <blue>Ickle</>")
    end
    if actor:get_quest_var("illusory_wall:Frostbite") then
        self.room:send("- <blue>Mount Frostbite</>")
    end
    if actor:get_quest_var("illusory_wall:Phoenix") then
        self.room:send("- <blue>Phoenix Feather Hot Spring</>")
    end
    if actor:get_quest_var("illusory_wall:Blue_Fog_Trail") then
        self.room:send("- <blue>Blue-Fog Trail</>")
    end
    if actor:get_quest_var("illusory_wall:Twisted") then
        self.room:send("- <blue>Twisted Forest</>")
    end
    if actor:get_quest_var("illusory_wall:Megalith") then
        self.room:send("- <blue>The Sacred Megalith</>")
    end
    if actor:get_quest_var("illusory_wall:Tower") then
        self.room:send("- <blue>The Tower in the Wasted</>")
    end
    if actor:get_quest_var("illusory_wall:Miner") then
        self.room:send("- <blue>The Miner's Cavern</>")
    end
    if actor:get_quest_var("illusory_wall:Morgan") then
        self.room:send("- <blue>Morgan Hill</>")
    end
    if actor:get_quest_var("illusory_wall:Mystwatch") then
        self.room:send("- <blue>The Fortress of Mystwatch</>")
    end
    if actor:get_quest_var("illusory_wall:Desert") then
        self.room:send("- <blue>Gothra Desert</>")
    end
    if actor:get_quest_var("illusory_wall:Pyramid") then
        self.room:send("- <blue>Gothra Pyramid</>")
    end
    if actor:get_quest_var("illusory_wall:Highlands") then
        self.room:send("- <blue>Highlands</>")
    end
    if actor:get_quest_var("illusory_wall:Haunted") then
        self.room:send("- <blue>The Haunted House</>")
    end
    if actor:get_quest_var("illusory_wall:Citadel") then
        self.room:send("- <blue>The Citadel of Testing</>")
    end
    if actor:get_quest_var("illusory_wall:Chaos") then
        self.room:send("- <blue>Temple of Chaos</>")
    end
    if actor:get_quest_var("illusory_wall:Canyon") then
        self.room:send("- <blue>Canyon</>")
    end
    if actor:get_quest_var("illusory_wall:Topiary") then
        self.room:send("- <blue>Mielikki's Topiary</>")
    end
    if actor:get_quest_var("illusory_wall:Abbey") then
        self.room:send("- <blue>The Abbey</>")
    end
    if actor:get_quest_var("illusory_wall:Plains") then
        self.room:send("- <blue>Gothra Plains</>")
    end
    if actor:get_quest_var("illusory_wall:Dheduu") then
        self.room:send("- <blue>Dheduu</>")
    end
    if actor:get_quest_var("illusory_wall:Dargentan") then
        self.room:send("- <blue>Dargentan's Lair</>")
    end
    if actor:get_quest_var("illusory_wall:Ogakh") then
        self.room:send("- <blue>Ogakh</>")
    end
    if actor:get_quest_var("illusory_wall:Bluebonnet") then
        self.room:send("- <blue>Bluebonnet Pass</>")
    end
    if actor:get_quest_var("illusory_wall:Caelia_East") then
        self.room:send("- <blue>South Caelia East</>")
    end
    if actor:get_quest_var("illusory_wall:Brush") then
        self.room:send("- <blue>Brush Lands</>")
    end
    if actor:get_quest_var("illusory_wall:Kaaz") then
        self.room:send("- <blue>Temple of the Kaaz</>")
    end
    if actor:get_quest_var("illusory_wall:SeaWitch") then
        self.room:send("- <blue>Sea's Lullaby</>")
    end
    if actor:get_quest_var("illusory_wall:Smuggler") then
        self.room:send("- <blue>Smuggler's Hideout</>")
    end
    if actor:get_quest_var("illusory_wall:Sirestis") then
        self.room:send("- <blue>Sirestis' Folly</>")
    end
    if actor:get_quest_var("illusory_wall:Ancient_Ruins") then
        self.room:send("- <blue>Ancient Ruins</>")
    end
    if actor:get_quest_var("illusory_wall:Minithawkin") then
        self.room:send("- <blue>Minithawkin Mines</>")
    end
    if actor:get_quest_var("illusory_wall:Arabel") then
        self.room:send("- <blue>Arabel Ocean</>")
    end
    if actor:get_quest_var("illusory_wall:Hive") then
        self.room:send("- <blue>Hive</>")
    end
    if actor:get_quest_var("illusory_wall:Demise") then
        self.room:send("- <blue>Demise Keep</>")
    end
    if actor:get_quest_var("illusory_wall:Aviary") then
        self.room:send("- <blue>Ickle's Aviary</>")
    end
    if actor:get_quest_var("illusory_wall:Graveyard") then
        self.room:send("- <blue>The Graveyard</>")
    end
    if actor:get_quest_var("illusory_wall:Earth") then
        self.room:send("- <blue>The Plane of Earth</>")
    end
    if actor:get_quest_var("illusory_wall:Water") then
        self.room:send("- <blue>The Plane of Water</>")
    end
    if actor:get_quest_var("illusory_wall:Fire") then
        self.room:send("- <blue>The Plane of Fire</>")
    end
    if actor:get_quest_var("illusory_wall:Barrow") then
        self.room:send("- <blue>The Barrow</>")
    end
    if actor:get_quest_var("illusory_wall:Fiery") then
        self.room:send("- <blue>Fiery Island</>")
    end
    if actor:get_quest_var("illusory_wall:Nukreth") then
        self.room:send("- <blue>Nukreth Spire</>")
    end
    if actor:get_quest_var("illusory_wall:Doom") then
        self.room:send("- <blue>An Ancient Forest and Pyramid</>")
    end
    if actor:get_quest_var("illusory_wall:Air") then
        self.room:send("- <blue>The Plane of Air</>")
    end
    if actor:get_quest_var("illusory_wall:Lokari") then
        self.room:send("- <blue>Lokari's Keep</>")
    end
    if actor:get_quest_var("illusory_wall:Griffin") then
        self.room:send("- <blue>Griffin Island</>")
    end
    if actor:get_quest_var("illusory_wall:BlackIce") then
        self.room:send("- <blue>Black-Ice Desert</>")
    end
    if actor:get_quest_var("illusory_wall:Nymrill") then
        self.room:send("- <blue>The Lost City of Nymrill</>")
    end
    if actor:get_quest_var("illusory_wall:Bayou") then
        self.room:send("- <blue>The Bayou</>")
    end
    if actor:get_quest_var("illusory_wall:Nordus") then
        self.room:send("- <blue>The Enchanted Village of Nordus</>")
    end
    if actor:get_quest_var("illusory_wall:Templace") then
        self.room:send("- <blue>Templace</>")
    end
    if actor:get_quest_var("illusory_wall:Sunken") then
        self.room:send("- <blue>Sunken Castle</>")
    end
    if actor:get_quest_var("illusory_wall:Cult") then
        self.room:send("- <blue>Ice Cult</>")
    end
    if actor:get_quest_var("illusory_wall:Frost") then
        self.room:send("- <blue>Frost Valley</>")
    end
    if actor:get_quest_var("illusory_wall:Technitzitlan") then
        self.room:send("- <blue>Technitzitlan</>")
    end
    if actor:get_quest_var("illusory_wall:Black_Woods") then
        self.room:send("- <blue>Black Woods</>")
    end
    if actor:get_quest_var("illusory_wall:Kaas_Plains") then
        self.room:send("- <blue>Kaas Plains</>")
    end
    if actor:get_quest_var("illusory_wall:Dark_Mountains") then
        self.room:send("- <blue>Dark Mountains</>")
    end
    if actor:get_quest_var("illusory_wall:Cold_Fields") then
        self.room:send("- <blue>Cold Fields</>")
    end
    if actor:get_quest_var("illusory_wall:Iron") then
        self.room:send("- <blue>Iron Hills</>")
    end
    if actor:get_quest_var("illusory_wall:Blackrock") then
        self.room:send("- <blue>Black Rock Trail</>")
    end
    if actor:get_quest_var("illusory_wall:Eldorian") then
        self.room:send("- <blue>Eldorian Foothills</>")
    end
    if actor:get_quest_var("illusory_wall:Blacklake") then
        self.room:send("- <blue>Black Lake</>")
    end
    if actor:get_quest_var("illusory_wall:Odz") then
        self.room:send("- <blue>Odaishyozen</>")
    end
    if actor:get_quest_var("illusory_wall:Syric") then
        self.room:send("- <blue>Syric Mountain Trail</>")
    end
    if actor:get_quest_var("illusory_wall:KoD") then
        self.room:send("- <blue>Kingdom of Dreams</>")
    end
    if actor:get_quest_var("illusory_wall:Beachhead") then
        self.room:send("- <blue>Beachhead</>")
    end
    if actor:get_quest_var("illusory_wall:Ice_Warrior") then
        self.room:send("- <blue>The Ice Warrior's Compound</>")
    end
    if actor:get_quest_var("illusory_wall:Haven") then
        self.room:send("- <blue>Sacred Haven</>")
    end
    if actor:get_quest_var("illusory_wall:Hollow") then
        self.room:send("- <blue>Enchanted Hollow</>")
    end
    if actor:get_quest_var("illusory_wall:Rhell") then
        self.room:send("- <blue>The Rhell Forest</>")
    end
    -- (empty room echo)
    local remaining = (20 - doors)
    self.room:send("Locate doors in <b:magenta>" .. tostring(remaining) .. "</> more regions.")
    -- (empty room echo)
    self.room:send("If you need new lenses say, <b:magenta>\"I need new glasses\"</>.")
end