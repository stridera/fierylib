-- Trigger skills.set_level fixes: the binding's level is proficiency on a 0..1000 scale (100 = 10%), so the legacy literal 100 (meant as 100%) becomes 1000, and calls that passed actor.name / person.name (a string) now pass the actor, which the binding requires.
--
-- Idempotent: a row already holding the new body is left alone, so rerunning
-- updates nothing. Keyed by the composite primary key (zone_id, id).
-- Guarded: a row is only touched while it still holds the previous committed
-- body (md5), so rows edited in Muditor since then are left alone.

BEGIN;

UPDATE "Triggers" AS t
SET commands = v.commands,
    updated_at = now()
FROM (VALUES
  -- data/triggers/001/001_00_set_breathe_fire.lua
  (1, 0, $trig$-- Converted from DG Script #100: set Breathe Fire
-- Original: MOB trigger, flags: LOAD, probability: 100%
skills.set_level(self, "breathe fire", 1000)
skills.set_level(self, "fire breath", 1000)$trig$, '74bebaad9126fc59fa0e3116a5ca982b'),
  -- data/triggers/001/001_01_set_breathe_frost.lua
  (1, 1, $trig$-- Converted from DG Script #101: set Breathe Frost
-- Original: MOB trigger, flags: LOAD, probability: 100%
skills.set_level(self, "breathe frost", 1000)
skills.set_level(self, "frost breath", 1000)$trig$, 'b25450ea152b500daaba5020a1c5c436'),
  -- data/triggers/001/001_02_set_breathe_acid.lua
  (1, 2, $trig$-- Converted from DG Script #102: set Breathe Acid
-- Original: MOB trigger, flags: LOAD, probability: 100%
skills.set_level(self, "breathe acid", 1000)
skills.set_level(self, "acid breath", 1000)$trig$, '08b4e3b74bf9625c7d79047e9aca8275'),
  -- data/triggers/001/001_03_set_breathe_gas.lua
  (1, 3, $trig$-- Converted from DG Script #103: set Breathe Gas
-- Original: MOB trigger, flags: LOAD, probability: 100%
skills.set_level(self, "breathe gas", 1000)
skills.set_level(self, "gas breath", 1000)$trig$, 'bc892403ed05ad8a6e2c0fc44f5775a7'),
  -- data/triggers/001/001_04_set_breathe_lightning.lua
  (1, 4, $trig$-- Converted from DG Script #104: set Breathe Lightning
-- Original: MOB trigger, flags: LOAD, probability: 100%
skills.set_level(self, "breathe lightning", 1000)
skills.set_level(self, "lightning breath", 1000)$trig$, '582e16af3088c10a0c7222ad07b47022'),
  -- data/triggers/001/001_05_set_roar.lua
  (1, 5, $trig$-- Converted from DG Script #105: set Roar
-- Original: MOB trigger, flags: LOAD, probability: 100%
skills.set_level(self, "roar", 1000)$trig$, '66501017146522ebb3e422e3798eec94'),
  -- data/triggers/018/018_34_blur_winds_speech.lua
  (18, 34, $trig$-- Converted from DG Script #1834: blur_winds_speech
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: yes sure yep okay
local speech_lower = string.lower(speech)
if not (string.find(speech_lower, "yes") or string.find(speech_lower, "sure") or string.find(speech_lower, "yep") or string.find(speech_lower, "okay")) then
    return true  -- No matching keywords
end

if actor:get_quest_stage("blur") ~= 4 then
    return true
end

wait(2)

-- Hoist all branch-scoped locals.
local direction
local home_zone
local home_id
local color

if self.zone_id == 18 and self.local_id == 19 then  -- North Wind
    direction = "north"
    home_zone, home_id = 302, 62  -- legacy 30262
    color = "&2&b"
    local room = get_room(home_zone, home_id)
    local rname = room and room.name or "the northern peak"
    self.room:send(tostring(self.name) .. " says, 'Then you will have to beat me to: " .. tostring(color) .. tostring(rname) .. "</>")
    self.room:send("</>in Bluebonnet Pass.'")
    self:emote("laughs mightily as it vanishes!")
    actor:set_quest_var("blur", direction, 1)
elseif self.zone_id == 18 and self.local_id == 20 then  -- South Wind
    direction = "south"
    home_zone, home_id = 535, 57  -- legacy 53557
    color = "&1&b"
    local room = get_room(home_zone, home_id)
    local rname = room and room.name or "the standing stones"
    self.room:send(tostring(self.name) .. " says, 'Long has it been since one such as yourself has made this")
    self.room:send("</>request.  Now show me your speed!'")
    wait(1)
    self.room:send(tostring(self.name) .. " says, 'Try to reach " .. tostring(color) .. tostring(rname) .. "</>")
    self.room:send("</>before I do!'")
    self:emote("rustles away with the sound of the leaves.")
    actor:set_quest_var("blur", direction, 1)
elseif self.zone_id == 18 and self.local_id == 21 then  -- East Wind
    direction = "east"
    home_zone, home_id = 125, 97  -- legacy 12597
    color = "&3&b"
    local room = get_room(home_zone, home_id)
    local rname = room and room.name or "the volcano caldera"
    if world.count_mobiles(481, 5) == 0 then
        self:say("Then let it be so!")
        wait(1)
        self.room:send(tostring(self.name) .. " says, 'Reach " .. tostring(color) .. tostring(rname) .. "</>")
        self.room:send("</>before me!'")
        actor:set_quest_var("blur", direction, 1)
    else
        self:say("Then please help me escape from the clutches of this madwoman!")
        wait(1)
        self.room:send("Vulcera throws back her head and cackles!")
    end
elseif self.zone_id == 18 and self.local_id == 22 then  -- West Wind
    direction = "west"
    home_zone, home_id = 42, 36  -- legacy 4236
    color = "&6&b"
    self:say("Well, let's play a different game first...")
    wait(3)
    self.room:send(tostring(self.name) .. " says, 'I'll be riding the fastest animal in Gothra!")
    self.room:send("</>If you can find me, then we can race!'")
    get_room(203, 8 + random(1, 46)):at(function()
        self.room:spawn_mobile(203, 21)
    end)
end

if not direction then
    return true
end

self:teleport(get_room(11, 0))

-- Polling loop: stop when player reaches the home room or the timer expires.
local count = 450
while count > 0 do
    if actor.room and actor.room.zone_id == home_zone and actor.room.local_id == home_id then
        count = 0
    else
        actor:set_quest_var("blur", direction .. "_timer", count)
        wait(5)
        count = count - 5
    end
end

local arrived = actor.room and actor.room.zone_id == home_zone and actor.room.local_id == home_id
if actor:get_quest_var("blur:" .. direction) == 2 then
    world.destroy(self)
elseif arrived then
    if actor:get_quest_var("blur:" .. direction) == 1 then
        actor:send(tostring(self.name) .. " tells you, '" .. tostring(color) .. "Wow you're fast!  Incredible!</>'")
        actor:set_quest_var("blur", direction, 2)
        if actor:get_quest_var("blur:east") == 2 and actor:get_quest_var("blur:west") == 2 and actor:get_quest_var("blur:north") == 2 and actor:get_quest_var("blur:south") == 2 then
            skills.set_level(actor, "blur", 1000)
            wait(2)
            actor:send("You have matched the greatest speeds of nature!")
            actor:send("You have learned <red>Blur</>!")
            actor:complete_quest("blur")
        end
    else
        if self.zone_id == 18 and self.local_id == 22 then
            actor:send(tostring(self.name) .. " tells you, '" .. tostring(color) .. "You never found me, too bad!</>'")
            actor:set_quest_var("blur", direction, 0)
        elseif self.zone_id == 18 and self.local_id == 21 then
            actor:send(tostring(self.name) .. " tells you, '" .. tostring(color) .. "You didn't rescue me in time!</>'")
            actor:set_quest_var("blur", direction, 0)
        end
    end
else
    actor:send(tostring(self.name) .. " tells you, '" .. tostring(color) .. "Sorry, too slow!</>'")
    actor:send(tostring(self.name) .. " tells you, '" .. tostring(color) .. "Come back if you want a rematch!</>'")
    actor:set_quest_var("blur", direction, 0)
end

world.destroy(self)
return true$trig$, '29117c0a6ffc33481e7baadc1a40ad84'),
  -- data/triggers/023/023_01_patriarch_receives_truthstone.lua
  (23, 1, $trig$local _return_value = true  -- Default: allow action
-- 
-- original Smoldering Trident trigger
-- 
if object.id == 2300 then
    wait(1)
    local object_shortdesc = object.shortdesc
    world.destroy(object)
    wait(3)
    self.room:send_except(actor, tostring(self.name) .. " stops tossing meat into the fire and peers at " .. tostring(actor.name) .. ".")
    actor:send(tostring(self.name) .. " stops tossing meat into the fire and looks at you.")
    wait(3)
    if actor.class == "Diabolist" then
        if actor.level >= 35 then
            self:command("smile")
            self:say("Excellent...very, very excellent.")
            self:emote("pockets " .. tostring(object_shortdesc) .. ".")
            wait(2)
            self:say("He will be very happy with this.")
            self:emote("turns towards the fire and begins chanting in an arcane tongue.")
            wait(3)
            self:emote("chants, 'Olarag hroshi nofaraio...'")
            wait(2)
            self.room:send("The flames begin to <blue>fl<blue>are</>, licking the cavern roof above!")
            wait(2)
            self:emote("chants, 'Dala kenthu sarijko dennal...'")
            wait(2)
            self.room:send("The &9<blue>un</><magenta>ho<blue>ly</> <blue>fi<blue>re</> continues to grow, nearly engulfing " .. tostring(self.name) .. "!")
            wait(2)
            self:emote("chants, 'Yarak tilaru kenzo jing!'")
            self.room:send("As " .. tostring(self.name) .. " completes " .. tostring(self.possessive) .. " chant, the <blue>fla<blue>mes</> suddenly contract into a ball.")
            wait(3)
            self.room:send("A <yellow>chi<blue>ll<green>ing</> voice croaks something in a language you do not understand.")
            wait(2)
            self.room:send("The ball of <blue>fl<blue>ame</> slowly begins to change shape, elongating and pulsating.")
            self.room:send("The <blue>fl<blue>ames</> take the shape of a <red>scar<blue>let <yellow>trident</>.")
            wait(3)
            self.room:send("The trident falls to the ground by the &9<blue>smoldering <red>emb<blue>ers</>.")
            wait(1)
            self:emote("gets a smoldering trident.")
            wait(1)
            self:say("Yes, I believe you have proven yourself indeed.")
            self:command("smile")
            wait(2)
            self:say("The weapon is for you.")
            wait(1)
            if actor.gender == "Female" then
                self:say("Go forth and smite those who might stand against us, sister.")
            elseif actor.gender == "Male" then
                self:say("Go forth and smite those who might stand against us, brother.")
            else
                self:say("Go forth and smite those who might stand against us.")
            end
            self.room:spawn_object(23, 34)
            self:command("give smoldering-trident " .. tostring(actor.name))
            if not actor:get_quest_stage("hell_trident") then
                actor:start_quest("hell_trident")
            end
            wait(1)
            -- 
            -- for Hellfire Trident
            -- 
            if actor.level >= 65 then
                self:say("Hell hungers for more and will reward you greatly if you feed it.  Attack with that trident 666 times then seek out the Black Priestess, the left hand of Ruin Wormheart.  She will guide your offerings.")
            else
                self:say("Other forces of Hell will eventually take notice of you too now.  Seek out the left hand of Ruin Wormheart, the Black Priestess, after you have grown more.  She will be your emissary.")
                actor:send("<red>Reach level 65 to continue this quest.</>")
            end
            -- 
            -- for Hellfire and Brimstone
            -- 
            if (actor.level > 56) and not actor:get_quest_stage("hellfire_brimstone") then
                wait(2)
                self:say("You seem to be quite powerful already.  Powerful enough in fact to handle the Fire of the Dark One.")
                wait(2)
                self:say("Would you like to learn to rain fire and brimstone down on your enemies?")
            end
            -- 
            -- original Smoldering Trident trigger
            -- 
        else
            self:command("blink")
            self:say("Quite amazing that you were able to retrieve " .. tostring(object_shortdesc) .. ".")
            self:command("peer " .. tostring(actor.name))
            wait(2)
            self:say("Unfortunately, I don't think the Dark One would want to see such a weakling.  Return here again when you are more powerful.")
        end
    else
        self:command("snicker " .. tostring(actor.name))
        self:say("You are no diabolist!  You no more deserve this power than Mielikki herself!")
        self:emote("tosses " .. tostring(object_shortdesc) .. " in the flames.")
        wait(2)
        self:say("Run along now, there is nothing more for you here.")
    end
end
-- 
-- Hellfire and Brimstone continued
-- 
if actor:get_quest_stage("hellfire_brimstone") == 3 then
    if object.id == 4318 or object.id == 5211 or object.id == 5212 or object.id == 17308 or object.id == 48110 or object.id == 53000 then
        if actor:get_quest_var("hellfire_brimstone:" .. tostring(object.zone_id) .. "_" .. tostring(object.local_id)) then
            _return_value = true
            self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
            wait(2)
            self:say("I have no need for a second " .. tostring(objects.template(object.zone_id, object.local_id).name) .. "!")
        else
            wait(2)
            actor:set_quest_var("hellfire_brimstone", (tostring(object.zone_id) .. "_" .. tostring(object.local_id)), 1)
            self.room:send(tostring(self.name) .. " holds " .. tostring(object.shortdesc) .. " in his gnarled fist.")
            self:say("You have done well " .. tostring(actor.name) .. ".")
            world.destroy(object)
        end
        wait(2)
        local item1 = actor:get_quest_var("hellfire_brimstone:4318")
        local item2 = actor:get_quest_var("hellfire_brimstone:5211")
        local item3 = actor:get_quest_var("hellfire_brimstone:5212")
        local item4 = actor:get_quest_var("hellfire_brimstone:17308")
        local item5 = actor:get_quest_var("hellfire_brimstone:48110")
        local item6 = actor:get_quest_var("hellfire_brimstone:53000")
        if item1 and item2 and item3 and item4 and item5 and item6 then
            self:emote("laughs with dark pleasure!")
            self:say("A fine set of tributes to the Dark One!")
            wait(4)
            self:say("Now behold as I set this cavern alight!")
            wait(2)
            self.room:send("<b:red>" .. tostring(self.name) .. " spreads the flaming tributes throughout the cavern.</>")
            self.room:send("<b:red>The piles of brimstone burn hot and bright!</>")
            wait(3)
            self.room:send("<b:red>The fires trace out lines on the cavern floor, forming a huge burning sigil.</>")
            wait(4)
            actor:send("<b:red>Gazing into the burning sigil, you feel the words to a prayer to the Dark One forming in your soul.</>_")
            actor:send("You have learned the prayers for <b:red>H<yellow>e<red>llf<yellow>i<red>re</> <red>and <blue>Br<yellow>i<red>mst<yellow>o<red>ne</>!")
            actor:complete_quest("hellfire_brimstone")
            if not actor:get_quest_var("hell_trident:helltask4") and actor:get_quest_stage("hell_trident") == 1 then
                actor:set_quest_var("hell_trident", "helltask4", 1)
            end
            skills.set_level(actor, "hellfire and brimstone", 1000)
        else
            self:say("Bring me the rest of the fiery tributes!")
        end
    else
        _return_value = true
        self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
        wait(2)
        self:say("I have no need for this!")
    end
end
return _return_value$trig$, 'd80ea79925c4be4d350f568a1775b26e'),
  -- data/triggers/028/028_02_waterform_wave_receive.lua
  (28, 2, $trig$local stage = actor:get_quest_stage("waterform")
if actor:get_quest_var("waterform:new") == "yes" then
    if object.zone_id == 28 and object.local_id == 7 then
        wait(2)
        self:say("Yes, I can make a new dragon bone cup from this.")
        world.destroy(object)
        actor:set_quest_var("waterform", "new", 0)
        wait(2)
        self.room:send(tostring(self.name) .. " transforms into a torrential swirling column!")
        self.room:send("The riptide whittles away at the ice white bone, carving it into a smooth cup.")
        self.room:send(tostring(self.name) .. " slowly resumes into its gentle undulating form, the cup floating on its crest.")
        self.room:spawn_object(28, 8)
        wait(2)
        self:command("give dragon-bone-cup " .. tostring(actor.name))
        self:say("Don't lose this again!")
    else
        wait(2)
        self:say("I can't make a new cup from this.")
        self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
    end
elseif stage == 1 then
    if object.zone_id == 510 and object.local_id == 9 then
        actor:advance_quest("waterform")
        wait(2)
        self:destroy_item("shield")
        self:say("Yes, this will do nicely.")
        self.room:send(tostring(self.name) .. " absorbs " .. tostring(objects.template(510, 9).name) .. " into its massive form!")
        wait(2)
        self:say("Now hold still.")
        wait(2)
        self.room:send(tostring(self.name) .. " crests up to a monumental height and pauses for just a moment.")
        wait(4)
        actor:send(tostring(self.name) .. " CRASHES down and engulfs you!")
        self.room:send_except(actor, tostring(self.name) .. " CRASHES down and engulfs " .. tostring(actor.name) .. "!")
        wait(4)
        actor:send("You feel your body start to soften and flow!")
        actor:send("You feel at one with the Great Wave!")
        self.room:send_except(actor, tostring(actor.name) .. " to merges with the Great Wave!")
        wait(6)
        actor:send("Suddenly you feel your body solidify again.")
        actor:send("You begin to choke!")
        self.room:send_except(actor, tostring(actor.name) .. " begins to struggle against the torrent!")
        wait(5)
        self.room:send_except(actor, tostring(self.name) .. " recedes leaving " .. tostring(actor.name) .. " heaving for breath.")
        actor:send(tostring(self.name) .. " recedes, leaving you gasping for air.")
        wait(5)
        self.room:send(tostring(self.name) .. " says, 'That didn't work quite right.  The Amorphous Shield alone")
        self.room:send("</>must not be powerful enough to sustain the transformation.  Perhaps we will")
        self.room:send("</>need to add a few other elements.'")
        wait(3)
        self.room:send(tostring(self.name) .. " says, 'I apologize, but if you wish to continue, you will have")
        self.room:send("</>to find a few other things.'")
    else
        self:say("This isn't armor made of water.")
        self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
    end
elseif stage == 3 then
    if object.zone_id == 28 and object.local_id == 7 then
        actor:advance_quest("waterform")
        wait(2)
        self.room:send(tostring(self.name) .. " examines " .. tostring(object.shortdesc) .. ".")
        self:destroy_item("thigh-bone")
        self:say("This bone will make an excellent water vessel.")
        wait(2)
        self.room:send(tostring(self.name) .. " transforms into a torrential swirling column!")
        self.room:send("The riptide whittles away at the ice white bone, carving it into a smooth cup.")
        wait(5)
        self.room:send(tostring(self.name) .. " slowly resumes into its gentle undulating form, the cup floating on its crest.")
        self.room:spawn_object(28, 8)
        wait(1)
        self:command("give dragon-bone-cup " .. tostring(actor.name))
        self.room:send(tostring(self.name) .. " says, 'Take this cup.  With it, take samples of <b:blue>four living</>")
        self.room:send("</>water creatures</>.'")
        -- (empty room echo)
        self.room:send(tostring(self.name) .. " says, 'Each creature must come from a <b:cyan>different region</> of")
        self.room:send("</>the world.  So you'll need samples from more than just the denizens of the")
        self.room:send("</>Blue-Fog river and road.'")
        wait(6)
        self.room:send(tostring(self.name) .. " says, 'Once you've gathered the four samples, return and give me")
        self.room:send("</>the cup.'")
    else
        self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
        self:say("This won't make a usable vessel.")
    end
elseif stage == 4 then
    if object.zone_id == 28 and object.local_id == 8 then
        self:say("It seems you haven't collected all four samples yet.")
        self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
        wait(1)
        self.room:send(tostring(self.name) .. " says, 'Do you need a reminder of your <b:white>[progress]</>?'")
    else
        self:say("Why are you bringing me this?")
        self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
        wait(1)
        self:say("You should be out collecting living water samples.")
    end
elseif stage == 5 then
    if object.zone_id == 28 and object.local_id == 8 then
        actor:advance_quest("waterform")
        self:say("Yes, these samples are perfect.")
        wait(2)
        self:emote("rises up, coaxing wavering orbs of water out of the dragon bone cup.")
        self:emote("raises up the shield and merges the watery orbs with it.")
        wait(3)
        self.room:send(tostring(self.name) .. " says, 'One last thing, just to be sure.  Develop a deeper")
        self.room:send("</>personal insight on the nature of water.'")
        wait(1)
        self.room:send(tostring(self.name) .. " says, 'Using the cup again, <b:cyan>examine</> six unique sources of")
        self.room:send("</>water.'")
        -- (empty room echo)
        self.room:send(tostring(self.name) .. " says, 'Seek out:'")
        self.room:send("- <b:blue>a granite pool in the village of Mielikki</>")
        -- (empty room echo)
        self.room:send("- <b:blue>a sparkling artesian well in the Realm of the King of Dreams</>")
        -- (empty room echo)
        self.room:send("- <b:blue>a crystal clear fountain in the caverns of the Ice Cult</>")
        -- (empty room echo)
        self.room:send("- <b:blue>the creek in the Eldorian Foothills</>")
        -- (empty room echo)
        self.room:send("- <b:blue>the wishing well at the Dancing Dolphin in South Caelia</>")
        -- (empty room echo)
        self.room:send("- <b:blue>an underground brook in the Minithawkin Mines</>")
        wait(6)
        self.room:send(tostring(self.name) .. " says, 'Once you have examined all six sites, return and I shall")
        self.room:send("</>try the transformation again.'")
    else
        self.room:send(tostring(self.name) .. " says, 'You haven't been trying to collect samples in this have")
        self.room:send("</>you?'")
    end
elseif stage == 6 then
    if object.zone_id == 28 and object.local_id == 8 then
        self:say("You haven't completed all of your examinations yet!")
        self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
        wait(1)
        self.room:send(tostring(self.name) .. " says, 'Do you need a reminder of your <b:white>[progress]</>?'")
    else
        self:say("What is this for?")
        self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
        wait(1)
        self.room:send(tostring(self.name) .. " says, 'Do you need a reminder of your <b:white>[progress]</>?'")
    end
elseif stage == 7 then
    if object.zone_id == 28 and object.local_id == 8 then
        wait(2)
        self:destroy_item("dragon-bone-cup")
        self.room:send(tostring(self.name) .. " says, 'Everything is ready!  I shall attempt the transformation")
        self.room:send("</>again.'")
        wait(2)
        self.room:send(tostring(self.name) .. " rises up like a tower on the water.")
        self.room:send("The Great Wave swells as the waters of the Blue Lake rise to meet it.")
        wait(4)
        actor:send(tostring(self.name) .. " crests and breaks, washing over you!")
        self.room:send_except(actor, tostring(self.name) .. " crests and breaks, washing over " .. tostring(actor.name) .. "!")
        wait(6)
        actor:send("You feel your body liquify as the Great Wave swirls over, in, and through you.")
        actor:send("You can feel the rushing waters of the world in every particle of your being as you join with the Great Wave and the Blue Lake.")
        self.room:send_except(actor, tostring(actor.name) .. " liquifies and joins with the waters of the Great Wave and the Blue Lake.")
        wait(5)
        skills.set_level(actor, "waterform", 1000)
        actor:send("<b:blue>The Great Wave imparts the method to transform your body into pure raging water!</>")
        actor:complete_quest("waterform")
    else
        self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
        self:say("This is not the dragon bone cup.")
    end
else
    self:say("I don't remember asking you to retrieve this.")
    self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
end
return true$trig$, 'ec7bce36c80e9d93c02537b7f3a68dac'),
  -- data/triggers/030/030_09_erasmus_responds_to_charm_person.lua
  (30, 9, $trig$-- Converted from DG Script #3009: Erasmus responds to "charm person"
-- Original: MOB trigger, flags: SPEECH_TO, probability: 100%
wait(2)
if string.find(actor.class, "Illusionist") then
    if actor:has_skill("charm person") == 100 then
        self:say("A nice spell, isn't it?  I hope you're enjoying it.")
    elseif actor.level < 17 then
        self:say("Ah, charm person.  A powerful spell, capable of great evil - or good.")
        wait(2)
        self:say("Come back when you have a bit more experience, and I'll teach it to you.")
    else
        self:say("Oh, the charm person spell.  You're ready to learn that one!")
        wait(2)
        self:say("Stand still there while I teach you.")
        wait(2)
        self:emote("launches into a marathon of lectures and speeches about diverse arcana.")
        wait(5)
        self:emote("is still spewing forth obscure knowledge at a furious rate!")
        wait(5)
        self:emote("seems to be winding down, as if the lesson were almost over.")
        wait(5)
        if actor.room == self.room then
            self:say("I'm impressed with your attentiveness, " .. tostring(actor.name) .. ".")
            wait(3)
            self:say("I can see that you've learned charm person rather well.")
            skills.set_level(actor, "charm person", 1000)
        else
            self:say("Eh?  Where did " .. tostring(actor.name) .. " go?  Must not have a thirst for knowledge!")
        end
    end
elseif string.find(actor.class, "Sorcerer") then
    if actor:has_skill("charm person") == 100 then
        self:command("gasp")
        wait(3)
        self:say("What's this?  An ordinary sorcerer with charm person?!")
        wait(5)
        self:say("Will wonders never cease!")
        wait(5)
        self:command("shake")
    else
        self:say("Don't look at me!  I'm a legendary teacher, but some things are just beyond me!")
        wait(5)
        self:say("You sorcerers require extra help learning this... rather simple spell.")
        wait(5)
        self:say("And you'll get none of it for me, because I have better things to do.")
    end
else
    self:command("sigh")
    wait(3)
    self:say("Yes, yes, a wonderful spell, how incredible we illusionists are, certainly.")
    wait(3)
    self:command("roll")
    wait(3)
    self:say("Why don't you go bash some poor rodents' heads in.  Or whatever it is you do.")
end$trig$, 'bd9e1f405b737051bc879a251207845b'),
  -- data/triggers/030/030_161_pay_for_training.lua
  (30, 161, $trig$-- Converted from DG Script #3161: pay for training
-- Original: MOB trigger, flags: BRIBE, probability: 1%

-- 1% chance to trigger
if not percent_chance(1) then
    return true
end
local _return_value = true  -- Default: allow action
local full_skill
if actor:get_quest_var("trainer_3160:word2") then
    full_skill = tostring(actor:get_quest_var("trainer_3160:skill_name")) .. " " .. tostring(actor:get_quest_var("trainer_3160:word2"))
elseif actor:get_quest_var("trainer_3160:skill_name") then
    full_skill = actor:get_quest_var("trainer_3160:skill_name")
end
wait(1)
if actor:get_quest_var("trainer_3160:actor_level") == actor.level then
    if value >= actor:get_quest_var("trainer_3160:price") then
        self:command("grin " .. tostring(actor.name))
        wait(1)
        actor:send(tostring(self.name) .. " says, 'Fantastic. Let's get started...'")
        wait(5)
        actor:send("Some time passes...")
        wait(3)
        actor:send("You feel you are getting the hang of things.")
        wait(3)
        actor:send("You feel your skill in " .. tostring(full_skill) .. " improving dramatically!")
        skills.set_level(actor, full_skill, 1000)
        actor:erase_quest("trainer_3160")
    else
        actor:send(tostring(self.name) .. " says, 'I appreciate your voluntary donation, but I'm afraid that's all it was.'")
        self:command("snicker " .. tostring(actor))
        actor:send("</>")
        actor:send(tostring(self.name) .. " says, 'I don't accept installments.  It's got to be all up front.'")
    end
else
    _return_value = true
    wait(2)
    self:command("consider " .. tostring(actor))
    wait(2)
    self:command("ponder")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'Something's different about you.  What skill were you going to train again?'")
    actor:erase_quest("trainer_3160")
end
return _return_value$trig$, '5cbf17a53a0292a72432c824e2825279'),
  -- data/triggers/030/030_166_pay_for_training.lua
  (30, 166, $trig$-- Converted from DG Script #3166: pay for training
-- Original: MOB trigger, flags: BRIBE, probability: 1%

-- 1% chance to trigger
if not percent_chance(1) then
    return true
end
local _return_value = true  -- Default: allow action
local full_skill
if actor:get_quest_var("trainer_3165:word2") then
    full_skill = tostring(actor:get_quest_var("trainer_3165:skill_name")) .. " " .. tostring(actor:get_quest_var("trainer_3165:word2"))
elseif actor:get_quest_var("trainer_3165:skill_name") then
    full_skill = actor:get_quest_var("trainer_3165:skill_name")
end
wait(1)
if actor:get_quest_var("trainer_3165:actor_level") == actor.level then
    if value >= actor:get_quest_var("trainer_3165:price") then
        self:command("grin " .. tostring(actor.name))
        wait(1)
        actor:send(tostring(self.name) .. " says, 'Fantastic. Let's get started...'")
        wait(5)
        actor:send("Some time passes...")
        wait(3)
        actor:send("You feel you are getting the hang of things.")
        wait(3)
        actor:send("You feel your skill in " .. tostring(full_skill) .. " improving dramatically!")
        skills.set_level(actor, full_skill, 1000)
        actor:erase_quest("trainer_3165")
    else
        actor:send(tostring(self.name) .. " says, 'I appreciate your voluntary donation, but I'm afraid that's all it was.'")
        self:command("snicker " .. tostring(actor))
        actor:send(tostring(self.name) .. " says, 'I don't accept installments.  It's got to be all up front.'")
    end
else
    _return_value = true
    wait(2)
    self:command("consider " .. tostring(actor))
    wait(2)
    self:command("ponder")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'Something is different about you.  What skill were you going to train again?'")
    actor:erase_quest("trainer_3165")
end
return _return_value$trig$, '57b8c6a73ec882230d18ceee81190f43'),
  -- data/triggers/030/030_171_shaman_pay_for_training.lua
  (30, 171, $trig$-- Converted from DG Script #3171: shaman pay for training
-- Original: MOB trigger, flags: BRIBE, probability: 1%

-- 1% chance to trigger
if not percent_chance(1) then
    return true
end
local _return_value = true  -- Default: allow action
local full_skill
if actor:get_quest_var("trainer_3170:word2") then
    if actor:get_quest_var("trainer_3170:skill_name") ~= "sphere" then
        full_skill = tostring(actor:get_quest_var("trainer_3170:skill_name")) .. " of " .. tostring(actor:get_quest_var("trainer_3170:word2"))
    else
        full_skill = tostring(actor:get_quest_var("trainer_3170:skill_name")) .. " " .. tostring(actor:get_quest_var("trainer_3170:word2"))
    end
elseif actor:get_quest_var("trainer_3170:skill_name") then
    full_skill = actor:get_quest_var("trainer_3170:skill_name")
end
wait(1)
if actor:get_quest_var("trainer_3170:actor_level") == actor.level then
    if value >= actor:get_quest_var("trainer_3170:price") then
        self:command("grin " .. tostring(actor.name))
        wait(1)
        actor:send(tostring(self.name) .. " says, 'Fantastic.  Let's get started...'")
        wait(5)
        actor:send("Some time passes...")
        wait(3)
        actor:send("You feel you are getting the hang of things.")
        wait(3)
        actor:send("You feel your skill in " .. tostring(full_skill) .. " improving dramatically!")
        skills.set_level(actor, full_skill, 1000)
        actor:erase_quest("trainer_3170")
    else
        actor:send(tostring(self.name) .. " says, 'I appreciate your voluntary donation, but I'm afraid that's all it was.'")
        self:command("snicker " .. tostring(actor))
        actor:send("</>")
        actor:send(tostring(self.name) .. " says, 'I don't accept installments.  It's got to be all up front.'")
    end
else
    _return_value = true
    wait(2)
    self:command("consider " .. tostring(actor))
    wait(2)
    self:command("ponder")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'Something is different about you.  What skill were you going to train again?'")
    actor:erase_quest("trainer_3170")
end
return _return_value$trig$, 'cc508aa68047afa9076364ed130fe7b7'),
  -- data/triggers/030/030_184_corpse_retrieval_load.lua
  (30, 184, $trig$-- Converted from DG Script #3184: corpse retrieval load
-- Original: MOB trigger, flags: LOAD, probability: 100%
skills.set_level(self, "shift corpse", 1000)$trig$, '236796be8e8209639e6ee6781a380ba2'),
  -- data/triggers/053/053_47_monk_chants_command_meditate.lua
  (53, 47, $trig$-- Converted from DG Script #5347: Monk Chants command meditate
-- Original: OBJECT trigger, flags: COMMAND, probability: 3%

-- Command location mask 3: legacy OCMD_EQUIP=1 (worn), OCMD_INVEN=2 (carried), OCMD_ROOM=4 (floor)
if not (location == "equip" or location == "inventory") then
    return true  -- Not in a location this trigger watches
end

-- Command filter: meditate
if not (cmd == "meditate") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
-- switch on cmd
if cmd == "m" or cmd == "me" then
    _return_value = true
    return _return_value
end
-- switch on self.id
if self.id == 1807 then
    local visionstage = 3
    local chantstage = 1
    local level = 30
    local place = 3205
    if actor:has_equipped("393") or actor:has_equipped("394") or actor:has_equipped("395") or actor:has_equipped("396") or actor:has_equipped("397") or actor:has_equipped("398") or actor:has_equipped("399") then
        local mark = "yes"
    end
    local text1 = "&3The power of the earth begins to flow through your fists!&0"
    local text2 = "&3You have learned Tremors of Saint Augustine.&0"
    local chant = "tremors of saint augustine"
elseif self.id == 12508 then
    local visionstage = 4
    local chantstage = 2
    local level = 40
    local place = 4752
    if actor:has_equipped("394") or actor:has_equipped("395") or actor:has_equipped("396") or actor:has_equipped("397") or actor:has_equipped("398") or actor:has_equipped("399") then
        local mark = "yes"
    end
    local text1 = "&4&bThe power of the storm begins to flow through your fists!&0"
    local text2 = "&4&bYou have learned Tempest of Saint Augustine.&0"
    local chant = "tempest of saint augustine"
elseif self.id == 55003 then
    local visionstage = 5
    local chantstage = 3
    local level = 50
    local place = 11837
    if actor:has_equipped("395") or actor:has_equipped("396") or actor:has_equipped("397") or actor:has_equipped("398") or actor:has_equipped("399") then
        local mark = "yes"
    end
    local text1 = "&6&bThe power of ice begins to flow through your fists!&0"
    local text2 = "&6&bYou have learned Blizzards of Saint Augustine.&0"
    local chant = "blizzards of saint augustine"
elseif self.id == 55004 then
    local visionstage = 6
    local chantstage = 4
    local level = 60
    local place = 2786
    if actor:has_equipped("396") or actor:has_equipped("397") or actor:has_equipped("398") or actor:has_equipped("399") then
        local mark = "yes"
    end
    local text1 = "&bReverberating from the walls are the discordant words of power!&0"
    local text2 = "&bYou have learned Aria of Dissonance.&0"
    local chant = "aria of dissonance"
elseif self.id == 49066 then
    local visionstage = 7
    local chantstage = 5
    local level = 75
    local place = 16057
    if actor:has_equipped("397") or actor:has_equipped("398") or actor:has_equipped("399") then
        local mark = "yes"
    end
    local text1 = "&5The roaring of the dead forms into a chant!&0"
    local text2 = "&5You have learned Apocalyptic Anthem.&0"
    local chant = "apocalyptic anthem"
elseif self.id == 23826 then
    local visionstage = 8
    local chantstage = 6
    local level = 80
    local place = 5272
    if actor:has_equipped("398") or actor:has_equipped("399") then
        local mark = "yes"
    end
    local text1 = "&1&bThe power of fire begins to flow through your fists!&0"
    local text2 = "&1&bYou have learned Fires of Saint Augustine.&0"
    local chant = "fires of saint augustine"
elseif self.id == 48037 then
    local visionstage = 9
    local chantstage = 7
    local level = 99
    local place = 48913
    if actor:has_equipped("399") then
        local mark = "yes"
    end
    local text1 = "&9&bThe chant to engender catastrophe echoes from the altar!&0"
    local text2 = "&9&bYou have learned Seed of Destruction.&0"
    local chant = "seed of destruction"
end
if actor:get_quest_stage("monk_vision") > visionstage and actor:get_quest_stage("monk_chants") == "chantstage" and actor.level >= level and actor.room == "place" then
    if mark then
        if actor.is_fighting then
            actor:send("<magenta>You cannot properly focus while fighting!</>")
            return _return_value
        elseif actor.position ~= "sitting" then
            actor:send("<magenta>You cannot properly focus while " .. tostring(actor.position) .. "!</>")
            return _return_value
        else
            actor:send("<magenta>You begin to meditate...</>")
            wait(4)
            if actor.room ~= "place" then
                actor:send("<magenta>You must be in the proper place to keep meditating!</>")
                return _return_value
            elseif actor.is_fighting then
                actor:send("<magenta>You cannot properly focus while fighting!</>")
                return _return_value
            elseif actor.position ~= "sitting" then
                actor:send("<magenta>You cannot properly focus while " .. tostring(actor.position) .. "!</>")
                return _return_value
            end
            local i = 0
            while i < 3 do
                actor:send("<magenta>You continue to meditate...</>")
                wait(4)
                i = i + 1
                if actor.room ~= "place" then
                    actor:send("<magenta>You must be in the proper place to keep reading!</>")
                    return _return_value
                elseif actor.is_fighting then
                    actor:send("<magenta>You cannot properly focus while fighting!</>")
                    return _return_value
                elseif actor.position ~= "sitting" then
                    actor:send("<magenta>You cannot properly focus while " .. tostring(actor.position) .. "!</>")
                    return _return_value
                end
            end
            actor:send(tostring(text1))
            actor:send(tostring(text2))
            skills.set_level(actor, "%chant%", 1000)
            if actor:get_quest_stage("monk_chants") < 7 then
                actor:advance_quest("monk_chants")
            else
                actor:complete_quest("monk_chants")
            end
            wait(2)
            actor:send(tostring(self.shortdesc) .. " crumbles to dust and blows away...")
            world.destroy(self)
        end
    else
        _return_value = true
    end
else
    _return_value = true
end
return _return_value$trig$, '073cb15b3dfc60b7ec85ee4ba656c4af'),
  -- data/triggers/053/053_48_unused.lua
  (53, 48, $trig$-- Converted from DG Script #5348: **UNUSED**
-- Original: OBJECT trigger, flags: COMMAND, probability: 3%

-- Command location mask 3: legacy OCMD_EQUIP=1 (worn), OCMD_INVEN=2 (carried), OCMD_ROOM=4 (floor)
if not (location == "equip" or location == "inventory") then
    return true  -- Not in a location this trigger watches
end

-- Command filter: meditate
if not (cmd == "meditate") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
-- For Tempest of Saint Augustine on item 12508
-- switch on cmd
if cmd == "m" or cmd == "me" then
    _return_value = true
    return _return_value
end
if actor:get_quest_stage("monk_vision") > 4 and actor:get_quest_stage("monk_chants") == 2 and actor.level >= 40 and actor.room == 58186 then
    if actor:has_equipped("394") or actor:has_equipped("395") or actor:has_equipped("396") or actor:has_equipped("397") or actor:has_equipped("398") or actor:has_equipped("399") then
        if actor.is_fighting then
            actor:send("<magenta>You cannot properly focus while fighting!</>")
            return _return_value
        elseif actor.position ~= "sitting" then
            actor:send("<magenta>You cannot properly focus while " .. tostring(actor.position) .. "!</>")
            return _return_value
        else
            actor:send("<magenta>You begin to meditate...</>")
            wait(4)
            if actor.room ~= "place" then
                actor:send("<magenta>You must be in the proper place to keep meditating!</>")
                return _return_value
            elseif actor.is_fighting then
                actor:send("<magenta>You cannot properly focus while fighting!</>")
                return _return_value
            elseif actor.position ~= "sitting" then
                actor:send("<magenta>You cannot properly focus while " .. tostring(actor.position) .. "!</>")
                return _return_value
            end
            local i = 0
            while i < 3 do
                actor:send("<magenta>You continue to meditate...</>")
                wait(4)
                i = i + 1
                if actor.room ~= "place" then
                    actor:send("<magenta>You must be in the proper place to keep reading!</>")
                    return _return_value
                elseif actor.is_fighting then
                    actor:send("<magenta>You cannot properly focus while fighting!</>")
                    return _return_value
                elseif actor.position ~= "sitting" then
                    actor:send("<magenta>You cannot properly focus while " .. tostring(actor.position) .. "!</>")
                    return _return_value
                end
            end
            actor:send("<b:yellow>The power of the storm begins to flow through your fists!</>")
            actor:send("<b:yellow>You have learned Tempest of Saint Augustine.</>")
            skills.set_level(actor, "tempest of saint augustine", 1000)
            actor:advance_quest("monk_chants")
            wait(2)
            actor:send(tostring(self.shortdesc) .. " crumbles to dust and blows away...")
            world.destroy(self)
        end
    else
        _return_value = true
    end
else
    _return_value = true
end
return _return_value$trig$, '893650b0341c96cf347cbeb8e9e3550d'),
  -- data/triggers/053/053_49_unused.lua
  (53, 49, $trig$-- Converted from DG Script #5349: **UNUSED**
-- Original: OBJECT trigger, flags: COMMAND, probability: 3%

-- Command location mask 3: legacy OCMD_EQUIP=1 (worn), OCMD_INVEN=2 (carried), OCMD_ROOM=4 (floor)
if not (location == "equip" or location == "inventory") then
    return true  -- Not in a location this trigger watches
end

-- Command filter: meditate
if not (cmd == "meditate") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
-- For Blizzards of Saint Augustine on item 55003
-- switch on cmd
if cmd == "m" or cmd == "me" then
    _return_value = true
    return _return_value
end
if actor:get_quest_stage("monk_vision") > 5 and actor:get_quest_stage("monk_chants") == 3 and actor.level >= 50 and actor.room == 11837 then
    if actor:has_equipped("395") or actor:has_equipped("396") or actor:has_equipped("397") or actor:has_equipped("398") or actor:has_equipped("399") then
        if actor.is_fighting then
            actor:send("<magenta>You cannot properly focus while fighting!</>")
            return _return_value
        elseif actor.position ~= "sitting" then
            actor:send("<magenta>You cannot properly focus while " .. tostring(actor.position) .. "!</>")
            return _return_value
        else
            actor:send("<magenta>You begin to meditate...</>")
            wait(4)
            if actor.room ~= "place" then
                actor:send("<magenta>You must be in the proper place to keep meditating!</>")
                return _return_value
            elseif actor.is_fighting then
                actor:send("<magenta>You cannot properly focus while fighting!</>")
                return _return_value
            elseif actor.position ~= "sitting" then
                actor:send("<magenta>You cannot properly focus while " .. tostring(actor.position) .. "!</>")
                return _return_value
            end
            local i = 0
            while i < 3 do
                actor:send("<magenta>You continue to meditate...</>")
                wait(4)
                i = i + 1
                if actor.room ~= "place" then
                    actor:send("<magenta>You must be in the proper place to keep reading!</>")
                    return _return_value
                elseif actor.is_fighting then
                    actor:send("<magenta>You cannot properly focus while fighting!</>")
                    return _return_value
                elseif actor.position ~= "sitting" then
                    actor:send("<magenta>You cannot properly focus while " .. tostring(actor.position) .. "!</>")
                    return _return_value
                end
            end
            actor:send("<b:cyan>The power of ice begins to flow through your fists!</>")
            actor:send("<b:cyan>You have learned Blizzards of Saint Augustine.</>")
            skills.set_level(actor, "blizzards of saint augustine", 1000)
            actor:advance_quest("monk_chants")
            wait(2)
            actor:send(tostring(self.shortdesc) .. " crumbles to dust and blows away...")
            world.destroy(self)
        end
    else
        _return_value = true
    end
else
    _return_value = true
end
return _return_value$trig$, 'cddcb6fbee13839338d186182170b0d5'),
  -- data/triggers/053/053_50_unused.lua
  (53, 50, $trig$-- Converted from DG Script #5350: **UNUSED**
-- Original: OBJECT trigger, flags: COMMAND, probability: 3%

-- Command location mask 3: legacy OCMD_EQUIP=1 (worn), OCMD_INVEN=2 (carried), OCMD_ROOM=4 (floor)
if not (location == "equip" or location == "inventory") then
    return true  -- Not in a location this trigger watches
end

-- Command filter: meditate
if not (cmd == "meditate") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
-- For Aria of Dissonance on item 55004
-- switch on cmd
if cmd == "m" or cmd == "me" then
    _return_value = true
    return _return_value
end
if actor:get_quest_stage("monk_vision") > 6 and actor:get_quest_stage("monk_chants") == 4 and actor.level >= 60 and actor.room == 2786 then
    if actor:has_equipped("396") or actor:has_equipped("397") or actor:has_equipped("398") or actor:has_equipped("399") then
        if actor.is_fighting then
            actor:send("<magenta>You cannot properly focus while fighting!</>")
            return _return_value
        elseif actor.position ~= "sitting" then
            actor:send("<magenta>You cannot properly focus while " .. tostring(actor.position) .. "!</>")
            return _return_value
        else
            actor:send("<magenta>You begin to meditate...</>")
            wait(4)
            if actor.room ~= "place" then
                actor:send("<magenta>You must be in the proper place to keep meditating!</>")
                return _return_value
            elseif actor.is_fighting then
                actor:send("<magenta>You cannot properly focus while fighting!</>")
                return _return_value
            elseif actor.position ~= "sitting" then
                actor:send("<magenta>You cannot properly focus while " .. tostring(actor.position) .. "!</>")
                return _return_value
            end
            local i = 0
            while i < 3 do
                actor:send("<magenta>You continue to meditate...</>")
                wait(4)
                i = i + 1
                if actor.room ~= "place" then
                    actor:send("<magenta>You must be in the proper place to keep reading!</>")
                    return _return_value
                elseif actor.is_fighting then
                    actor:send("<magenta>You cannot properly focus while fighting!</>")
                    return _return_value
                elseif actor.position ~= "sitting" then
                    actor:send("<magenta>You cannot properly focus while " .. tostring(actor.position) .. "!</>")
                    return _return_value
                end
            end
            actor:send("<blue>Reverberating from the walls are the discordant words of power!</>")
            actor:send("<blue>You have learned Aria of Dissonance.</>")
            skills.set_level(actor, "aria of dissonance", 1000)
            actor:advance_quest("monk_chants")
            wait(2)
            actor:send(tostring(self.shortdesc) .. " crumbles to dust and blows away...")
            world.destroy(self)
        end
    else
        _return_value = true
    end
else
    _return_value = true
end
return _return_value$trig$, 'db1fc0c394c362f42bbd2d221025c6d1'),
  -- data/triggers/053/053_51_unused.lua
  (53, 51, $trig$-- Converted from DG Script #5351: **UNUSED**
-- Original: OBJECT trigger, flags: COMMAND, probability: 3%

-- Command location mask 3: legacy OCMD_EQUIP=1 (worn), OCMD_INVEN=2 (carried), OCMD_ROOM=4 (floor)
if not (location == "equip" or location == "inventory") then
    return true  -- Not in a location this trigger watches
end

-- Command filter: meditate
if not (cmd == "meditate") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
-- For Apocalyptic Anthem on item 49066
-- switch on cmd
if cmd == "m" or cmd == "me" then
    _return_value = true
    return _return_value
end
if actor:get_quest_stage("monk_vision") > 7 and actor:get_quest_stage("monk_chants") == 5 and actor.level >= 75 and actor.room == 16072 then
    if actor:has_equipped("397") or actor:has_equipped("398") or actor:has_equipped("399") then
        if actor.is_fighting then
            actor:send("<magenta>You cannot properly focus while fighting!</>")
            return _return_value
        elseif actor.position ~= "sitting" then
            actor:send("<magenta>You cannot properly focus while " .. tostring(actor.position) .. "!</>")
            return _return_value
        else
            actor:send("<magenta>You begin to meditate...</>")
            wait(4)
            if actor.room ~= "place" then
                actor:send("<magenta>You must be in the proper place to keep meditating!</>")
                return _return_value
            elseif actor.is_fighting then
                actor:send("<magenta>You cannot properly focus while fighting!</>")
                return _return_value
            elseif actor.position ~= "sitting" then
                actor:send("<magenta>You cannot properly focus while " .. tostring(actor.position) .. "!</>")
                return _return_value
            end
            local i = 0
            while i < 3 do
                actor:send("<magenta>You continue to meditate...</>")
                wait(4)
                i = i + 1
                if actor.room ~= "place" then
                    actor:send("<magenta>You must be in the proper place to keep reading!</>")
                    return _return_value
                elseif actor.is_fighting then
                    actor:send("<magenta>You cannot properly focus while fighting!</>")
                    return _return_value
                elseif actor.position ~= "sitting" then
                    actor:send("<magenta>You cannot properly focus while " .. tostring(actor.position) .. "!</>")
                    return _return_value
                end
            end
            actor:send("<magenta>The roaring of the dead forms into a chant!</>")
            actor:send("<magenta>You have learned Apocalyptic Anthem.</>")  -- typo: sent
            skills.set_level(actor, "Apocalyptic anthem", 1000)
            actor:advance_quest("monk_chants")
            wait(2)
            actor:send(tostring(self.shortdesc) .. " crumbles to dust and blows away...")
            world.destroy(self)
        end
    else
        _return_value = true
    end
else
    _return_value = true
end
return _return_value$trig$, '79c59e4801f9b1cc3a85c58700026c78'),
  -- data/triggers/053/053_52_unused.lua
  (53, 52, $trig$-- Converted from DG Script #5352: **UNUSED**
-- Original: OBJECT trigger, flags: COMMAND, probability: 3%

-- Command location mask 3: legacy OCMD_EQUIP=1 (worn), OCMD_INVEN=2 (carried), OCMD_ROOM=4 (floor)
if not (location == "equip" or location == "inventory") then
    return true  -- Not in a location this trigger watches
end

-- Command filter: meditate
if not (cmd == "meditate") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
-- For Fires of Saint Augustine on item 23826
-- switch on cmd
if cmd == "m" or cmd == "me" then
    _return_value = true
    return _return_value
end
if actor:get_quest_stage("monk_vision") > 8 and actor:get_quest_stage("monk_chants") == 6 and actor.level >= 80 and actor.room == 5272 then
    if actor:has_equipped("398") or actor:has_equipped("399") then
        if actor.is_fighting then
            actor:send("<magenta>You cannot properly focus while fighting!</>")
            return _return_value
        elseif actor.position ~= "sitting" then
            actor:send("<magenta>You cannot properly focus while " .. tostring(actor.position) .. "!</>")
            return _return_value
        else
            actor:send("<magenta>You begin to meditate...</>")
            wait(4)
            if actor.room ~= "place" then
                actor:send("<magenta>You must be in the proper place to keep meditating!</>")
                return _return_value
            elseif actor.is_fighting then
                actor:send("<magenta>You cannot properly focus while fighting!</>")
                return _return_value
            elseif actor.position ~= "sitting" then
                actor:send("<magenta>You cannot properly focus while " .. tostring(actor.position) .. "!</>")
                return _return_value
            end
            local i = 0
            while i < 3 do
                actor:send("<magenta>You continue to meditate...</>")
                wait(4)
                i = i + 1
                if actor.room ~= "place" then
                    actor:send("<magenta>You must be in the proper place to keep reading!</>")
                    return _return_value
                elseif actor.is_fighting then
                    actor:send("<magenta>You cannot properly focus while fighting!</>")
                    return _return_value
                elseif actor.position ~= "sitting" then
                    actor:send("<magenta>You cannot properly focus while " .. tostring(actor.position) .. "!</>")
                    return _return_value
                end
            end
            actor:send("<b:red>The power of fire begins to flow through your fists!</>")
            actor:send("<b:red>You have learned Fires of Saint Augustine.</>")  -- typo: sent
            skills.set_level(actor, "fires of saint augustine", 1000)
            actor:advance_quest("monk_chants")
            wait(2)
            actor:send(tostring(self.shortdesc) .. " crumbles to dust and blows away...")
            world.destroy(self)
        end
    else
        _return_value = true
    end
else
    _return_value = true
end
return _return_value$trig$, 'e69d17b873c02a317fec6cc626b854eb'),
  -- data/triggers/053/053_53_unused.lua
  (53, 53, $trig$-- Converted from DG Script #5353: **UNUSED**
-- Original: OBJECT trigger, flags: COMMAND, probability: 3%

-- Command location mask 3: legacy OCMD_EQUIP=1 (worn), OCMD_INVEN=2 (carried), OCMD_ROOM=4 (floor)
if not (location == "equip" or location == "inventory") then
    return true  -- Not in a location this trigger watches
end

-- Command filter: meditate
if not (cmd == "meditate") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
-- For Seed of Destruction on item 48037
-- switch on cmd
if cmd == "m" or cmd == "me" then
    _return_value = true
    return _return_value
end
if actor:get_quest_stage("monk_vision") >= 9 and actor:get_quest_stage("monk_chants") == 7 and actor.level == 99 and actor.room == 48913 then
    if actor:has_equipped("399") then
        if actor.is_fighting then
            actor:send("<magenta>You cannot properly focus while fighting!</>")
            return _return_value
        elseif actor.position ~= "sitting" then
            actor:send("<magenta>You cannot properly focus while " .. tostring(actor.position) .. "!</>")
            return _return_value
        else
            actor:send("<magenta>You begin to meditate...</>")
            wait(4)
            if actor.room ~= "place" then
                actor:send("<magenta>You must be in the proper place to keep meditating!</>")
                return _return_value
            elseif actor.is_fighting then
                actor:send("<magenta>You cannot properly focus while fighting!</>")
                return _return_value
            elseif actor.position ~= "sitting" then
                actor:send("<magenta>You cannot properly focus while " .. tostring(actor.position) .. "!</>")
                return _return_value
            end
            local i = 0
            while i < 3 do
                actor:send("<magenta>You continue to meditate...</>")
                wait(4)
                i = i + 1
                if actor.room ~= "place" then
                    actor:send("<magenta>You must be in the proper place to keep reading!</>")
                    return _return_value
                elseif actor.is_fighting then
                    actor:send("<magenta>You cannot properly focus while fighting!</>")
                    return _return_value
                elseif actor.position ~= "sitting" then
                    actor:send("<magenta>You cannot properly focus while " .. tostring(actor.position) .. "!</>")
                    return _return_value
                end
            end
            actor:send("&9<blue>The chant to engender catastrophe echoes from the altar!</>")
            actor:send("&9<blue>You have learned Seed of Destruction.</>")  -- typo: sent
            skills.set_level(actor, "seed of destruction", 1000)
            actor:complete_quest("monk_chants")
            wait(2)
            actor:send(tostring(self.shortdesc) .. " crumbles to dust and blows away...")
            world.destroy(self)
        end
    else
        _return_value = true
    end
else
    _return_value = true
end
return _return_value$trig$, '5d4b7fb360bdaed08309e7074f22db97'),
  -- data/triggers/055/055_21_degeneration_cat_receive.lua
  (55, 21, $trig$-- Converted from DG Script #5521: degeneration_cat_receive
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
local stage = actor:get_quest_stage("degeneration")
if stage == 0 then
    _return_value = true
    self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
    self:command("hiss actor")
    wait(2)
    self:say("Who are you?  Why are you giving me this?")
elseif stage == 1 and object.id == 58008 then
    actor:advance_quest("degeneration")
    wait(1)
    self:destroy_item("book")
    self:emote("studies the book closely.")
    wait(3)
    self.room:send(tostring(self.name) .. " says, 'Hmmm, that's an unusual configuration...  The cage must have")
    self.room:send("</>been part of the secret.'")
    wait(2)
    self:emote("closes the book.")
    wait(2)
    self.room:send(tostring(self.name) .. " says, 'Yajiro was on to something, though his understanding was")
    self.room:send("</>quite rudimentary.  I need to dig a little deeper.'")
    wait(4)
    self:say("Literally and figuratively!")
    wait(2)
    self.room:send(tostring(self.name) .. " says, 'A troll sorcerer by the name of Mesmeriz has set up an")
    self.room:send("</>illusory lair in the Minithawkin Mines.'")
    wait(4)
    self.room:send(tostring(self.name) .. " says, 'Word among the dark practitioners is, he's trying to perform")
    self.room:send("</>the Ritual of Night and become a lich.'")
    wait(4)
    self.room:send(tostring(self.name) .. " says, 'Bring back the necklace he carries so I can see how much")
    self.room:send("</>progress he's made.'")
elseif stage == 2 and object.id == 37015 then
    actor:advance_quest("degeneration")
    wait(1)
    self:destroy_item("necklace")
    self.room:send(tostring(self.name) .. " utters the words, '<b:yellow>oculoinfra kariq</>'.")
    self.room:send(tostring(self.name) .. "'s eyes flash bright yellow!")
    wait(1)
    self:emote("examines " .. tostring(objects.template(370, 15).name))
    wait(3)
    self.room:send(tostring(self.name) .. " says, 'Mesmeriz was remarkably close to his goal.  The principles")
    self.room:send("</>of energy transfer he was using were quite unique.'")
    wait(4)
    self:say("It seems all he was missing was a suitable phylactery.")
    wait(3)
    self.room:send(tostring(self.name) .. " says, 'There's another wizard who has been working in body")
    self.room:send("</>modification, but on a massive scale.'")
    wait(4)
    self.room:send(tostring(self.name) .. " says, 'He's enchanted the entire town of Nordus and is")
    self.room:send("</>experimenting on the villagers.  Rumor is he's trying to grow bodies as fodder")
    self.room:send("</>for mass animation.'")
    wait(5)
    self:say("I must admit, I'm impressed.")
    wait(2)
    self.room:send(tostring(self.name) .. " says, 'He has a mask made from the face of one of his many victims")
    self.room:send("</>which he uses as his focus.  It's a bit vulgar, but it should serve my")
    self.room:send("</>purposes.  Secure it and bring it back.'")
elseif stage == 3 and object.id == 51075 then
    actor:advance_quest("degeneration")
    wait(1)
    self:destroy_item("mask")
    wait(1)
    self:emote("greedily devours the " .. get_obj_noadesc(510, 75) .. "!")
    wait(3)
    self:command("lick")
    self:say("Nothing makes you more familiar with magic than the taste!")
    wait(3)
    self.room:send(tostring(self.name) .. " says, 'Some impressive potency to use transmutation at that scale.")
    self.room:send("</>Plus some powerful evocation.'")
    wait(4)
    self:command("burp")
    self:say("Spicy!")
    wait(2)
    self.room:send(tostring(self.name) .. " says, 'But Luchiaans wasn't a very skilled necromancer it seems.")
    self.room:send("</>Still, it gives me some ideas.'")
    wait(4)
    self.room:send(tostring(self.name) .. " says, 'I need something of a more demonic nature to compare notes")
    self.room:send("</>to.'")
    wait(3)
    self.room:send(tostring(self.name) .. " says, 'Cyprianum, the ruler of Demise Keep, has a particularly")
    self.room:send("</>prized servant, Voliangloch the Evil.  As a devotee of the demonic Cyprianum,")
    self.room:send("</>Voliangloch may have struck that special balance between arcane and divine.'")
    wait(7)
    self.room:send(tostring(self.name) .. " says, 'Bring me his magical focus, " .. tostring(objects.template(430, 20).name) .. ".")
    self.room:send("</>It should give me sufficient insight to Voliangloch's magic.'")
elseif stage == 4 and object.id == 43020 then
    actor:advance_quest("degeneration")
    wait(1)
    self:destroy_item("rod")
    wait(1)
    self:emote("bats " .. tostring(objects.template(430, 20).name) .. " around a bit.")
    wait(3)
    self:emote("bats " .. tostring(objects.template(430, 20).name) .. " around some more.")
    wait(5)
    self:emote("frantically swats " .. tostring(objects.template(430, 20).name) .. " around and sends it flying!")
    self:command("hiss")
    wait(3)
    self:say("Well that was most informative.")
    wait(3)
    self:say("Interesting blending technique Voliangloch employed.")
    wait(3)
    self.room:send(tostring(self.name) .. " says, 'It looks like we have to approach the big players for more")
    self.room:send("</>information now.'")
    wait(3)
    self.room:send(tostring(self.name) .. " says, 'The first of the true necromancers I need you to \"visit\" is")
    self.room:send("</>Kryzanthor.  He's created a vast necropolis near Anduin, the likes of which")
    self.room:send("</>most beings can only dream about!'")
    wait(6)
    self.room:send(tostring(self.name) .. " says, 'He wears a unique robe that I'd like to get my paws on.  Get")
    self.room:send("</>it and bring it back to me.'")
elseif stage == 5 and object.id == 47003 then
    actor:advance_quest("degeneration")
    wait(1)
    self:destroy_item("robe")
    self:emote("gingerly sniffs " .. tostring(objects.template(470, 3).name) .. ".")
    wait(2)
    self.room:send(tostring(self.name) .. " says, 'Yes, this makes more sense.  Needing a physical conduit to")
    self.room:send("</>focus the transference of energies through while simultaneously shielding the")
    self.room:send("</>body appears to be critical here.'")
    wait(6)
    self.room:send(tostring(self.name) .. " says, 'Kryzanthor had mastered suffusing the dead with animating")
    self.room:send("</>energies, but he didn't quite have the mastery of draining life force from")
    self.room:send("</>the living.'")
    wait(6)
    self:say("There is one whom I have heard does have such a power.")
    wait(3)
    self.room:send(tostring(self.name) .. " says, 'In the Iron Hills there is an ancient barrow where several")
    self.room:send("</>kings have been laid to rest.  What's more, those of us who deal in death know")
    self.room:send("</>it's the lair of one of the two known liches in the world, King Ureal.'")
    wait(7)
    self.room:send(tostring(self.name) .. " says, 'In particular, he has a statuette I'm most interested in.")
    self.room:send("</>It supposedly can drain the energy of the living.'")
    wait(5)
    self.room:send(tostring(self.name) .. " says, 'If that's true, then it would be a huge missing piece of the")
    self.room:send("</>puzzle.'")
    wait(3)
    self:say("I'm quite excited for this one, so hurry up!")
elseif stage == 6 and object.id == 48009 then
    actor:advance_quest("degeneration")
    wait(1)
    self:destroy_item("statuette")
    self:say("Well done my little one, well done.")
    self:emote("meows in gratitude.")
    wait(2)
    self:emote("repeatedly rubs up against the statuette.")
    self.room:send("The statuette begins to glow <b:green>bright green!</>")
    wait(1)
    self:say("Fascinating...")
    wait(3)
    self:say("This is definitely helpful.")
    wait(4)
    self.room:send(tostring(self.name) .. " says, 'The last person I need information from is a curmudgeonly")
    self.room:send("</>old thing, Norisent.'")
    wait(4)
    self.room:send(tostring(self.name) .. " says, 'He sought to raise the dead, not just in a state of undeath,")
    self.room:send("</>but to truly restore them to life.'")
    wait(4)
    self.room:send(tostring(self.name) .. " says, 'Unfortunately for him, his experiments failed and he turned")
    self.room:send("</>himself into a lich instead.'")
    wait(2)
    self:command("roll")
    wait(4)
    self.room:send(tostring(self.name) .. " says, 'Regardless, he's been hiding out at the Cathedral of")
    self.room:send("</>Betrayal for decades now.'")
    wait(4)
    self.room:send(tostring(self.name) .. " says, 'Find Norisent and whatever book he's keeping notes in these")
    self.room:send("</>days.  While I think I could manage this without his notes, I want to be")
    self.room:send("</>completely sure.'")
elseif stage == 8 and object.id == 8551 then
    actor:advance_quest("degeneration")
    wait(1)
    self:destroy_item("book")
    self:emote("flips through the pages of the book.")
    wait(2)
    self:command("gasp")
    wait(1)
    self.room:send(tostring(self.name) .. " says, 'It's a good thing I have these notes or my planned matrix")
    self.room:send("</>configuration would have completely backfired!  I'll make the necessary")
    self.room:send("</>adjustments to the final casting.'")
    wait(2)
    self.room:send(tostring(self.name) .. " says, 'The other thing these notes show me is I'm missing")
    self.room:send("</>something to channel the transferring energy through.'")
    wait(4)
    self:say("Hmmmmm...")
    wait(2)
    self.room:send(tostring(self.name) .. " says, 'The statuette is too strongly attuned to Ureal to be")
    self.room:send("</>suitable...'")
    wait(3)
    self:say("Let me see...")
    wait(3)
    self.room:send(tostring(self.name) .. " utters the words, <b:yellow>'hiqi avykamina'</>.")
    wait(4)
    self.room:send(tostring(self.name) .. " says, 'It seems there is a dangerous ruby hidden under some kind")
    self.room:send("</>of stairway?  That makes no sense.  Yet my divination indicates it would be an")
    self.room:send("</>acceptable conduit for this spell.'")
    wait(6)
    self:say("Seek it out!")
elseif stage == 9 and object.id == 12526 then
    wait(1)
    self:destroy_item("ruby")
    self.room:send(tostring(self.name) .. "'s eyes widen and gleam at the sight of the ruby!")
    self:say("Magnificent!  I've never seen anything quite like it.")
    wait(3)
    self:emote("scratches out a huge diagram in the earth inside the tent.")
    self.room:send(tostring(self.name) .. " carefully places " .. tostring(objects.template(125, 26).name) .. " in the center of the diagram.")
    wait(4)
    self.room:send(tostring(self.name) .. " utters the word, <b:yellow>'oculotunsofihuab'</>.")
    self.room:send("Waves of necrotic energy rush blast out from the diagram bolstering the forces of the Third Black Legion!")
    wait(4)
    self:command("cackle")
    self.room:send(tostring(self.name) .. " says, 'I've done it!  I've perfected the formula for Degeneration!!")
    self.room:send("</>Here, see how it works!!'")
    wait(4)
    actor:send("Looking at the notes, you understand what " .. tostring(self.name) .. " has done.")
    actor:send("<b:white>You have learned &9Degeneration<white>!</>")
    skills.set_level(actor, "degeneration", 1000)
    actor:complete_quest("degeneration")
else
    _return_value = true
    self:command("hiss " .. tostring(actor.name))
    self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
    wait(2)
    self.room:send(tostring(self.name) .. " says, 'This isn't what I asked for. What are you, stupid?")
    self.room:send("</>Do you need me to remind you of your <b:white>[spell progress]</>?'")
end
return _return_value$trig$, '2c031a87b078bfbc9a4c58a5c452ddf5'),
  -- data/triggers/062/062_12_supernova_phayla_receive.lua
  (62, 12, $trig$-- TODO(parity): legacy used `skills.set_level(actor.name, "supernova", 100)`.
-- Confirm the runtime API (likely `actor:set_skill_level("supernova", 100)`)
-- and migrate; left as-is to preserve original behavior.

local function payment_key(obj)
    return tostring(obj.zone_id) .. "_" .. tostring(obj.local_id)
end

local is_sun = (object.zone_id == 510 and object.local_id == 73)
local is_lamp = (object.zone_id == 489 and object.local_id == 17)

if is_sun or is_lamp then
    if actor:get_quest_var("supernova:" .. payment_key(object)) == 1 then
        self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
        self:say("You've already given me this.")
    else
        actor:set_quest_var("supernova", payment_key(object), 1)
        wait(2)
        self:command("nod")
        world.destroy(object)
        if actor:get_quest_var("supernova:510_73") == 1 and actor:get_quest_var("supernova:489_17") == 1 then
            self:say("Alright, get comfortable.  This may take a while.")
            wait(3)
            self.room:send(tostring(self.name) .. " demonstrates some of the basics.")
            actor:send("You take notes and try to follow along.")
            wait(5)
            self:say("No, the diagrams need to look like this...")
            self.room:send_except(actor, tostring(self.name) .. " makes changes to " .. tostring(actor.name) .. "'s notes.")
            actor:send(tostring(self.name) .. " makes changes to your notes.")
            wait(5)
            self:say("Yes, that's good.  Move your hands like this.")
            self.room:send(tostring(self.name) .. " waves her hands about.")
            wait(5)
            self:say("Yes, that's much closer.")
            actor:send("You feel you're starting to get the hang of it!")
            self.room:send_except(actor, "It seems " .. tostring(actor.name) .. " is starting to get the hang of it!")
            wait(9)
            actor:send("You have a breakthrough!")
            self.room:send_except(actor, tostring(actor.name) .. " has a breakthrough!")
            wait(1)
            self:say("That's it!!  You've got it!")
            self.room:send_except(actor, tostring(actor.name) .. " radiates with inner arcane fire!")
            actor:send("<b:red>You have mastered Supernova!</>")
            skills.set_level(actor, "supernova", 1000)
            actor:complete_quest("supernova")
        else
            self:say("And the other?")
        end
    end
else
    self:say("This isn't acceptable payment.")
    self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
end
return true$trig$, '82456772735b1972621ca70f4411e862'),
  -- data/triggers/103/103_24_ice_shards_khysan_receive7.lua
  (103, 24, $trig$if actor:get_quest_stage("ice_shards") == 10 then
    wait(2)
    self:destroy_item("book")
    self:command("hug " .. actor.name)
    self:say("I don't know how I can ever express my gratitude to you for bringing this to me.  The Sunfire clan will be sure this knowledge is never lost again.")
    wait(4)
    self:say("Come, let's read this together.")
    self:emote("opens the book and flips forward a few pages.")
    wait(3)
    self:emote("points to a page.")
    self:say("Here it is!")
    wait(2)
    actor:send("Although the spell is written in ancient Elvish, the intent and meaning are clear enough to replicate it!")
    actor:complete_quest("ice_shards")
    skills.set_level(actor, "ice shards", 1000)
    actor:send("<b:cyan>You have learned Ice Shards!</>")
end$trig$, '2f45d49d553f86a01f9f3a132729c5f5'),
  -- data/triggers/117/117_111_assassin_vine_load.lua
  (117, 111, $trig$-- Converted from DG Script #11811: assassin_vine_load
-- Original: MOB trigger, flags: LOAD, probability: 100%
skills.set_level(self, "backstab", 1000)$trig$, '512ad4da9194be807bc9c7c9a1d84457'),
  -- data/triggers/133/133_12_tell_raph_please.lua
  (133, 12, $trig$wait(2)

if not actor.is_player then
    return true
end

if actor:get_quest_stage("get_raph_food") ~= 9 then
    actor:send(self.name .. " tells you, '" .. "What do you want, go about your business." .. "'")
    return true
end

actor:complete_quest("get_raph_food")

-- Spell rewards (full caster classes). The threshold messages warn the
-- player that their level is not yet high enough to actually cast the spell.
local spell_rewards = {
    Cleric      = { spell = "group heal",       min_level = 57 },
    Priest      = { spell = "group heal",       min_level = 57 },
    Diabolist   = { spell = "group heal",       min_level = 57 },
    Druid       = { spell = "invigorate",       min_level = 65 },
    Sorcerer    = { spell = "major globe",      min_level = 57 },
    Pyromancer  = { spell = "major globe",      min_level = 57 },
    Cryomancer  = { spell = "major globe",      min_level = 57 },
    Necromancer = { spell = "summon dracolich", min_level = 73 },
}

-- Skill rewards (martial / hybrid classes). proficiency = level * 10 + 50.
local skill_rewards = {
    Warrior    = "switch",
    Thief      = "pick lock",
    Paladin    = "switch",
    Antipaladin = "switch",
    Ranger     = "switch",
    Assassin   = "pick lock",
    Mercenary  = "switch",
    Monk       = "switch",
    Berserker  = "switch",
    Rogue      = "pick lock",
    Bard       = "pick lock",
}

local class = actor.class

for class_name, reward in pairs(spell_rewards) do
    if string.find(class, class_name) then
        self:command("smile " .. tostring(actor.name))
        skills.set_level(actor, reward.spell, 1000)
        if actor.level < reward.min_level then
            actor:send(self.name .. " tells you, '" .. "You will not be able to use your new ability for several levels." .. "'")
        end
        actor:save()
        actor:send(self.name .. " tells you, '" .. "There you go, enjoy your new powers." .. "'")
        return true
    end
end

for class_name, skill in pairs(skill_rewards) do
    if string.find(class, class_name) then
        self:command("smile " .. tostring(actor.name))
        local total = actor.level * 10 + 50
        skills.set_level(actor, skill, total)
        actor:save()
        actor:send(self.name .. " tells you, '" .. "There you go, enjoy your enhanced skills." .. "'")
        return true
    end
end

return true$trig$, '92736cbaf4eb93a2a8cb792bf617f2e5'),
  -- data/triggers/133/133_30_heavens_gate_starlight_speech1.lua
  (133, 30, $trig$local required = { "hark", "ye", "starry", "angels", "and", "open",
                   "the", "heavenly", "gates", "before", "me" }
local speech_lower = string.lower(speech)
for _, word in ipairs(required) do
    if not string.find(speech_lower, word) then
        return true
    end
end

if actor:get_quest_stage("heavens_gate") ~= 4 then
    return true
end

wait(1)
self.room:send("<b:white>Starlight spreads wide across the cavern.</>")
self.room:send("<cyan>A <blue>tunnel of <white>light <cyan>opens up!</>")
wait(3)
actor:send("<b:white>From the reaches of the heavens some unknowable entity touches your soul.</>")
actor:send("<b:white>It imparts a prayer to you.</>")
skills.set_level(actor, "heavens gate", 1000)
actor:complete_quest("heavens_gate")
actor:send("<b:cyan>You have learned <white>Heavens Gate<cyan>!</>")
wait(2)
self.room:send("<b:white>The starlight pours into the <b:cyan>tunnel <b:white>and is gone!</>")
world.destroy(self)

return true$trig$, '5b2dfe69ebbf8f30409ee8588aa644f9'),
  -- data/triggers/163/163_63_moonwell_map_5_receive.lua
  (163, 63, $trig$if actor:get_quest_stage("moonwell_spell_quest") ~= 11 then
    return true
end

if actor:get_quest_var("moonwell_spell_quest:map") ~= 1 then
    self:command("shake")
    self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
    wait(2)
    actor:send(tostring(self.name) .. " tells you, 'I need the ring first.'")
    return true
end

wait(15)
self:destroy_item("map")
self.room:spawn_object(163, 66)
self.room:send(tostring(self.name) .. " completes her drawing on the bark map.")
wait(15)
self:command("give map " .. tostring(actor.name))
if actor.gender == "female" then
    actor:send(tostring(self.name) .. " tells you, 'Keep that map Sister, that you may never forget how to\n"
        .. "</>conduct this ceremony.'")
else
    actor:send(tostring(self.name) .. " tells you, 'Keep that map Brother, that you may never forget how to\n"
        .. "</>conduct this ceremony.'")
end
wait(20)
actor:send(tostring(self.name) .. " tells you, 'Let us finish the ceremony.'")
self.room:send(tostring(self.name) .. " places " .. tostring(objects.template(550, 20).name) .. " at the edge of the circle and prays.")
wait(5)
self.room:send("<magenta>A </>moonwell <magenta>appears at " .. tostring(self.name) .. "'s feet!</>")
wait(20)
self.room:send("<b:cyan>The moonwell begins to <b:magenta>swirl</>!")
wait(25)
run_room_trigger(163, 48)
wait(30)
self.room:send("A soft yet loud voice says, 'You have done well young dryad.  Perhaps you truly\n"
    .. "</>are repentant.  For your service, I release you from your shackles.'")
wait(10)
self.room:send("The voice says, 'Remember this always.'")
wait(15)
self.room:send("A bright flash of light pierces the area and the dryad is transformed into a beautiful mortal woman!")
wait(10)
self.room:send("The beautiful druid says, 'Thank you my Goddess, Mielikki!  At last, I am free\n"
    .. "</>again!'")
wait(2)
self.room:send("The beautiful druid bows deeply, enters the moonwell and disappears!")
actor:complete_quest("moonwell_spell_quest")
skills.set_level(actor, "moonwell", 1000)
world.destroy(self)
return true$trig$, '85ea65661e2ee1d5f88bc6c638dfb125'),
  -- data/triggers/302/302_18_banish_murgbol_speech2.lua
  (302, 18, $trig$-- Speech keyword: vibugp
local speech_lower = string.lower(speech)
if not string.find(speech_lower, "vibugp") then
    return true  -- No matching keywords
end
wait(2)
if actor:get_quest_stage("banish") == 7 then
    actor:send(tostring(self.name) .. " chants along with you.")
    self.room:send_except(actor, tostring(self.name) .. " chants along with " .. tostring(actor.name) .. ".")
    self.room:send(tostring(self.name) .. " starts casting, <b:yellow>'Vibugp'</>...")
    wait(2)
    actor:send("There is a bright flash as you feel the power of the spell well up in the words, <b:red>'I banish thee!'</>")
    skills.set_level(actor, "banish", 1000)
    wait(1)
    actor:send("<b:red>You have mastered the prayer for Banish!</>")
    actor:complete_quest("banish")
    if not actor:get_quest_var("hell_trident:helltask5") and actor:get_quest_stage("hell_trident") == 1 then
        actor:set_quest_var("hell_trident", "helltask5", 1)
    end
    self.room:send_except(actor, "There is a bright flash as the spell goes off!")
    self.room:send_except(actor, tostring(actor.name) .. " seems to be more connected to the universe!")
end$trig$, 'ba1e6a16c9cfd8c53cd09e319c77da44'),
  -- data/triggers/390/390_07_flood_spirits_receive.lua
  (390, 7, $trig$local _return_value = true  -- Default: allow action
local stage = actor:get_quest_stage("flood")
-- switch on self.id
if stage == 2 then
    if object.id == 39000 then
        if self.id == 39012 then
            self:destroy_item("heart-ocean")
            wait(1)
            self.room:send(tostring(self.name) .. " screams, 'LET THE SIEGE BEGIN!!'")
            -- (empty room echo)
            self.room:send("The ocean erupts in a violent frenzy.")
            wait(3)
            self.room:send("Massive waves begin to crest and smash against the settlement gate.")
            self.room:send(tostring(self.name) .. " screams with reckless abandon like the most terrifying of barbarian berserkers.")
            wait(6)
            self.room:send("Spirits rise up through the churning ocean.")
            self.room:send("Giant black waves and enormous icebergs assault the rocky shores!")
            self.room:send(tostring(self.name) .. " wails, 'YOU SHALL DIE FOR STEALING FROM ME.'")
            wait(7)
            self.room:send("The nine Great Waters pull away from the settlement's borders as if granting a moment of reprieve.")
            wait(4)
            self.room:send("The ocean's level drops as the waters quickly rush away.")
            wait(4)
            self.room:send("On the horizon, a titanic wall of water rises up like a hellish behemoth.")
            wait(2)
            self.room:send("The gargantuan tsunami rushes toward the rocks and SMASHES through the settlement gate!")
            wait(6)
            self.room:send("Screaming voices are instantly snuffed out.")
            self.room:send("Dozens of bodies smash into the rocks and shatter like glass as the tsunami obliterates the settlement.")
            wait(8)
            self.room:send("As quickly as it began, the flood waters recede leaving nothing but chilling silence and carnage in its wake.")
            wait(6)
            self.room:send("The Lady of the Sea vanishes beneath the waves.")
            run_room_trigger(390, 13)
            wait(4)
            actor:send("A watery voice floats past your ear:")
            actor:send("'Never forget what you have witnessed here today.'")
            wait(1)
            actor:send("It whispers the eldritch formula for summoning such a cataclysm again.")
            actor:complete_quest("flood")
            skills.set_level(actor, "flood", 1000)
            actor:send("<b:blue>You have learned Flood.</>")
            wait(2)
            actor:send("'Thank you for the role you played.'")
            world.destroy(self)
        else
            _return_value = true
            self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
            self:say("This is not my heart!")
            wait(1)
            self.room:send(tostring(self.name) .. " bellows, 'GIVE IT BACK OR I WILL DESTROY YOU.'")
        end
    end
elseif self.id == 39014 then
    local color = "&6"
    if stage == 1 then
        if object.id == 58401 then
            self:destroy_item("feather")
            wait(1)
            self.room:send(tostring(self.name) .. " submerges the feather in the steaming water.")
            self.room:send(tostring(self.name) .. " says, " .. tostring(color) .. "'I can entrust the safety of the springs to this</>")
            self.room:send("</>" .. tostring(color) .. "feather's magical energy for a short while.  I will join the ocean's crusade.'</>")
            actor:set_quest_var("flood", "water2", 1)
            wait(2)
            self.room:send(tostring(color) .. "With a mighty cry " .. tostring(self.name) .. " dives back into the water.</>")
        else
            _return_value = true
            self.room:send(tostring(self.name) .. " says, " .. tostring(color) .. "'This will not keep my spring sufficiently warm.'</>")
        end
    else
        _return_value = true
        self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
        self.room:send(tostring(self.name) .. " says, " .. tostring(color) .. "'I need nothing from you.'</>")
    end
elseif self.id == 39016 then
    local color = "&2"
    if stage == 1 then
        if object.type == "FOOD" then
            if actor:get_quest_var("flood:" .. tostring(object.zone_id) .. "_" .. tostring(object.local_id)) then
                wait(2)
                self.room:send(tostring(self.name) .. " wails in anger as she thrashes about!")
                self.room:send(tostring(self.name) .. " throws " .. tostring(object.shortdesc) .. " into the sea!")
                self.room:send(tostring(self.name) .. " says, " .. tostring(color) .. "'I have already eaten that!  I refuse to eat it again!'</>")
            else
                actor:set_quest_var("flood", (tostring(object.zone_id) .. "_" .. tostring(object.local_id)), 1)
                local full = actor:get_quest_var("flood:hunger")
                local hunger = (full + object.val0)
                actor:set_quest_var("flood", "hunger", hunger)
                self:destroy_item("food")
                self.room:send(tostring(self.name) .. " greedily devours " .. tostring(object.shortdesc) .. ".")
                if hunger >= 200 then
                    wait(2)
                    self.room:send(tostring(self.name) .. " licks her massive chops.</>")
                    wait(1)
                    self:command("burp")
                    self.room:send(tostring(self.name) .. " says, " .. tostring(color) .. "'The dead within me are sated.'")
                    wait(1)
                    self.room:send(tostring(self.name) .. " says, " .. tostring(color) .. "'For now.'")
                    wait(1)
                    self.room:send(tostring(self.name) .. " says, " .. tostring(color) .. "'We will join with the ocean in her revenge.'")
                    wait(1)
                    self.room:send(tostring(color) .. tostring(self.name) .. " sinks beneath the waves.</>")
                    actor:set_quest_var("flood", "water4", 1)
                else
                    wait(2)
                    self.room:send(tostring(self.name) .. " licks her massive chops.")
                    self.room:send(tostring(self.name) .. " says, " .. tostring(color) .. "'Bring me more!'</>")
                    return _return_value
                end
            end
        else
            _return_value = true
            self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
            self.room:send(tostring(self.name) .. " says, " .. tostring(color) .. "'This is not food!!'</>")
        end
    else
        _return_value = true
        self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
        self.room:send(tostring(self.name) .. " says, " .. tostring(color) .. "'I want nothing from you.'</>")
    end
elseif self.id == 39019 then
    local color = "&9&b"
    if stage == 1 then
        if object.type == "LIGHT" then
            if object.val1 == -1 then
                actor:set_quest_var("flood", "water7", 1)
                wait(2)
                self.room:send(tostring(self.name) .. " grins with a sick malevolence.")
                wait(2)
                self.room:send(tostring(self.name) .. " says, " .. tostring(color) .. "'I'll take great joy in this!'</>")
                wait(2)
                self.room:send(tostring(self.name) .. " plunges the light into the depths of the Black Lake.")
                world.destroy(object)
                wait(3)
                self.room:send("The light twinkles for a few moments as it sinks into the darkness before fading forever.")
                wait(4)
                self:command("laugh")
                self.room:send(tostring(self.name) .. " says, " .. tostring(color) .. "'Intoxicating.'</>")
                wait(2)
                self.room:send(tostring(self.name) .. " says," .. tostring(color) .. " 'I will join the Arabel Ocean with pleasure.'</>")
                self:command("bow")
                wait(2)
                self.room:send(tostring(color) .. tostring(self.name) .. " splashes back into the inky blackness of the lake.</>")
            else
                _return_value = true
                self.room:send(tostring(self.name) .. " scoffs.")
                self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
                self.room:send(tostring(self.name) .. " says, " .. tostring(color) .. "'This wouldn't glow forever even before I consume it.'</>")
            end
        else
            _return_value = true
            self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
            self.room:send(tostring(self.name) .. " says, " .. tostring(color) .. "'This isn't even a light!'</>")
        end
    else
        _return_value = true
        self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
        self.room:send(tostring(self.name) .. " says, " .. tostring(color) .. "'You have nothing to offer me.'</>")
    end
else
    _return_value = true
    self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
    self.room:send(tostring(self.name) .. " says, " .. tostring(color) .. "'I have no need for this.'</>")
end
if stage == 1 then
    local water1 = actor:get_quest_var("flood:water1")
    local water2 = actor:get_quest_var("flood:water2")
    local water3 = actor:get_quest_var("flood:water3")
    local water4 = actor:get_quest_var("flood:water4")
    local water5 = actor:get_quest_var("flood:water5")
    local water6 = actor:get_quest_var("flood:water6")
    local water7 = actor:get_quest_var("flood:water7")
    local water8 = actor:get_quest_var("flood:water8")
    if water1 and water2 and water3 and water4 and water5 and water6 and water7 and water8 then
        actor:advance_quest("flood")
        wait(1)
        actor:send("<b:blue>You have garnered the support of all the great waters!</>")
    end
end
world.destroy(self)
return _return_value$trig$, 'cadc5623b7aafac8e020cb108b4ecc6a'),
  -- data/triggers/390/390_07_flood_spirits_receive.lua (same new body; also accepted: the
  -- comment-header-included body that 2026-10-10-trigger-type-fixes.sql wrote for this row)
  (390, 7, $trig$local _return_value = true  -- Default: allow action
local stage = actor:get_quest_stage("flood")
-- switch on self.id
if stage == 2 then
    if object.id == 39000 then
        if self.id == 39012 then
            self:destroy_item("heart-ocean")
            wait(1)
            self.room:send(tostring(self.name) .. " screams, 'LET THE SIEGE BEGIN!!'")
            -- (empty room echo)
            self.room:send("The ocean erupts in a violent frenzy.")
            wait(3)
            self.room:send("Massive waves begin to crest and smash against the settlement gate.")
            self.room:send(tostring(self.name) .. " screams with reckless abandon like the most terrifying of barbarian berserkers.")
            wait(6)
            self.room:send("Spirits rise up through the churning ocean.")
            self.room:send("Giant black waves and enormous icebergs assault the rocky shores!")
            self.room:send(tostring(self.name) .. " wails, 'YOU SHALL DIE FOR STEALING FROM ME.'")
            wait(7)
            self.room:send("The nine Great Waters pull away from the settlement's borders as if granting a moment of reprieve.")
            wait(4)
            self.room:send("The ocean's level drops as the waters quickly rush away.")
            wait(4)
            self.room:send("On the horizon, a titanic wall of water rises up like a hellish behemoth.")
            wait(2)
            self.room:send("The gargantuan tsunami rushes toward the rocks and SMASHES through the settlement gate!")
            wait(6)
            self.room:send("Screaming voices are instantly snuffed out.")
            self.room:send("Dozens of bodies smash into the rocks and shatter like glass as the tsunami obliterates the settlement.")
            wait(8)
            self.room:send("As quickly as it began, the flood waters recede leaving nothing but chilling silence and carnage in its wake.")
            wait(6)
            self.room:send("The Lady of the Sea vanishes beneath the waves.")
            run_room_trigger(390, 13)
            wait(4)
            actor:send("A watery voice floats past your ear:")
            actor:send("'Never forget what you have witnessed here today.'")
            wait(1)
            actor:send("It whispers the eldritch formula for summoning such a cataclysm again.")
            actor:complete_quest("flood")
            skills.set_level(actor, "flood", 1000)
            actor:send("<b:blue>You have learned Flood.</>")
            wait(2)
            actor:send("'Thank you for the role you played.'")
            world.destroy(self)
        else
            _return_value = true
            self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
            self:say("This is not my heart!")
            wait(1)
            self.room:send(tostring(self.name) .. " bellows, 'GIVE IT BACK OR I WILL DESTROY YOU.'")
        end
    end
elseif self.id == 39014 then
    local color = "&6"
    if stage == 1 then
        if object.id == 58401 then
            self:destroy_item("feather")
            wait(1)
            self.room:send(tostring(self.name) .. " submerges the feather in the steaming water.")
            self.room:send(tostring(self.name) .. " says, " .. tostring(color) .. "'I can entrust the safety of the springs to this</>")
            self.room:send("</>" .. tostring(color) .. "feather's magical energy for a short while.  I will join the ocean's crusade.'</>")
            actor:set_quest_var("flood", "water2", 1)
            wait(2)
            self.room:send(tostring(color) .. "With a mighty cry " .. tostring(self.name) .. " dives back into the water.</>")
        else
            _return_value = true
            self.room:send(tostring(self.name) .. " says, " .. tostring(color) .. "'This will not keep my spring sufficiently warm.'</>")
        end
    else
        _return_value = true
        self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
        self.room:send(tostring(self.name) .. " says, " .. tostring(color) .. "'I need nothing from you.'</>")
    end
elseif self.id == 39016 then
    local color = "&2"
    if stage == 1 then
        if object.type == "FOOD" then
            if actor:get_quest_var("flood:" .. tostring(object.zone_id) .. "_" .. tostring(object.local_id)) then
                wait(2)
                self.room:send(tostring(self.name) .. " wails in anger as she thrashes about!")
                self.room:send(tostring(self.name) .. " throws " .. tostring(object.shortdesc) .. " into the sea!")
                self.room:send(tostring(self.name) .. " says, " .. tostring(color) .. "'I have already eaten that!  I refuse to eat it again!'</>")
            else
                actor:set_quest_var("flood", (tostring(object.zone_id) .. "_" .. tostring(object.local_id)), 1)
                local full = actor:get_quest_var("flood:hunger")
                local hunger = (full + object.val0)
                actor:set_quest_var("flood", "hunger", hunger)
                self:destroy_item("food")
                self.room:send(tostring(self.name) .. " greedily devours " .. tostring(object.shortdesc) .. ".")
                if hunger >= 200 then
                    wait(2)
                    self.room:send(tostring(self.name) .. " licks her massive chops.</>")
                    wait(1)
                    self:command("burp")
                    self.room:send(tostring(self.name) .. " says, " .. tostring(color) .. "'The dead within me are sated.'")
                    wait(1)
                    self.room:send(tostring(self.name) .. " says, " .. tostring(color) .. "'For now.'")
                    wait(1)
                    self.room:send(tostring(self.name) .. " says, " .. tostring(color) .. "'We will join with the ocean in her revenge.'")
                    wait(1)
                    self.room:send(tostring(color) .. tostring(self.name) .. " sinks beneath the waves.</>")
                    actor:set_quest_var("flood", "water4", 1)
                else
                    wait(2)
                    self.room:send(tostring(self.name) .. " licks her massive chops.")
                    self.room:send(tostring(self.name) .. " says, " .. tostring(color) .. "'Bring me more!'</>")
                    return _return_value
                end
            end
        else
            _return_value = true
            self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
            self.room:send(tostring(self.name) .. " says, " .. tostring(color) .. "'This is not food!!'</>")
        end
    else
        _return_value = true
        self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
        self.room:send(tostring(self.name) .. " says, " .. tostring(color) .. "'I want nothing from you.'</>")
    end
elseif self.id == 39019 then
    local color = "&9&b"
    if stage == 1 then
        if object.type == "LIGHT" then
            if object.val1 == -1 then
                actor:set_quest_var("flood", "water7", 1)
                wait(2)
                self.room:send(tostring(self.name) .. " grins with a sick malevolence.")
                wait(2)
                self.room:send(tostring(self.name) .. " says, " .. tostring(color) .. "'I'll take great joy in this!'</>")
                wait(2)
                self.room:send(tostring(self.name) .. " plunges the light into the depths of the Black Lake.")
                world.destroy(object)
                wait(3)
                self.room:send("The light twinkles for a few moments as it sinks into the darkness before fading forever.")
                wait(4)
                self:command("laugh")
                self.room:send(tostring(self.name) .. " says, " .. tostring(color) .. "'Intoxicating.'</>")
                wait(2)
                self.room:send(tostring(self.name) .. " says," .. tostring(color) .. " 'I will join the Arabel Ocean with pleasure.'</>")
                self:command("bow")
                wait(2)
                self.room:send(tostring(color) .. tostring(self.name) .. " splashes back into the inky blackness of the lake.</>")
            else
                _return_value = true
                self.room:send(tostring(self.name) .. " scoffs.")
                self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
                self.room:send(tostring(self.name) .. " says, " .. tostring(color) .. "'This wouldn't glow forever even before I consume it.'</>")
            end
        else
            _return_value = true
            self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
            self.room:send(tostring(self.name) .. " says, " .. tostring(color) .. "'This isn't even a light!'</>")
        end
    else
        _return_value = true
        self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
        self.room:send(tostring(self.name) .. " says, " .. tostring(color) .. "'You have nothing to offer me.'</>")
    end
else
    _return_value = true
    self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
    self.room:send(tostring(self.name) .. " says, " .. tostring(color) .. "'I have no need for this.'</>")
end
if stage == 1 then
    local water1 = actor:get_quest_var("flood:water1")
    local water2 = actor:get_quest_var("flood:water2")
    local water3 = actor:get_quest_var("flood:water3")
    local water4 = actor:get_quest_var("flood:water4")
    local water5 = actor:get_quest_var("flood:water5")
    local water6 = actor:get_quest_var("flood:water6")
    local water7 = actor:get_quest_var("flood:water7")
    local water8 = actor:get_quest_var("flood:water8")
    if water1 and water2 and water3 and water4 and water5 and water6 and water7 and water8 then
        actor:advance_quest("flood")
        wait(1)
        actor:send("<b:blue>You have garnered the support of all the great waters!</>")
    end
end
world.destroy(self)
return _return_value$trig$, 'ed8daeb7a8192207810d6590508f9ad4'),
  -- data/triggers/430/430_54_word_command_dargo_escape.lua
  (430, 54, $trig$-- Converted from DG Script #43054: word_command_dargo_escape
-- Original: MOB trigger, flags: ENTRY, probability: 100%
wait(2)
if not globals.questor then
    return true
end
local questor = self.room:find_actor(globals.questor)
if self.room.zone_id == 430 and self.room.local_id == 37 then
    if world.count_mobiles(430, 17) > 0 then
        get_room(430, 176):at(function()
            self.room:find_actor("cyprianum"):shout("You can never escape me!")
        end)
        self.room:send("<red>" .. tostring(self.name) .. " vanishes in a flash of light and crimson haze!</>")
        self:emote("shrieks as he disappears!")
        self.room:send("Cackling laughter echoes through the halls.")
        self:teleport(get_room(430, 148))
    else
        local escape = false
        if questor then
            for _, person in ipairs(questor.group) do
                if person.room == self.room and person:get_quest_stage("word_command") == 3 then
                    escape = true
                end
            end
        end
        if not escape then
            get_room(430, 92):at(function()
                self.room:spawn_mobile(430, 16)
            end)
            self.room:send("Cyprianum the Reaper shouts, 'You didn't think you could escape without confronting me and my servant, did you Dargo?'")
            get_room(430, 176):at(function()
                self.room:spawn_mobile(430, 17)
            end)
            self.room:send(tostring(self.name) .. " shrieks as he vanishes in a flash of light and crimson haze!")
            self:teleport(get_room(430, 148))
        end
    end
elseif self.room.zone_id == 430 and self.room.local_id == 176 then
    if world.count_mobiles(430, 16) > 0 then
        self.room:send(tostring(mobiles.template(430, 16).name) .. " shouts, 'I will never allow you to harm my master!'")
        self.room:send("<b:red>" .. tostring(self.name) .. " is consumed in a crackle of red lightning and vanishes!</>")
        self.room:send("Cackling laughter echoes through the maze!")
        self:teleport(get_room(430, 148))
    end
elseif self.room.zone_id == 430 and self.room.local_id == 0 then
    if world.count_mobiles(430, 17) > 0 then
        get_room(430, 176):at(function()
            self.room:find_actor("cyprianum"):shout("You can never escape me!")
        end)
        self.room:send("<red>" .. tostring(self.name) .. " vanishes in a flash of light and crimson haze!</>")
        self:emote("shrieks as he disappears!")
        self.room:send("Cackling laughter echoes through the halls.")
        self:teleport(get_room(430, 148))
    else
        self:command("cheer")
        self:say("Thank you so much!")
        if questor then
            for _, person in ipairs(questor.group) do
                if person.room == self.room then
                    if person:get_quest_stage("word_command") == 3 then
                        person:send(self.name .. " tells you, 'As promised, here is the spell.'")
                        person:send(tostring(self.name) .. " gives you a disintegrating scroll with an ancient spell on it.")
                        skills.set_level(person, "word of command", 1000)
                        person:send("<b:magenta>You have learned Word of Command!</>")
                        person:complete_quest("word_command")
                    elseif person.is_player then
                        person:send(self.name .. " tells you, 'To show my gratitude, take this.'")
                        local count = 0
                        while count < 3 do
                            local what_gem_drop = random(1, 11)
                            self.room:spawn_object(557, 36 + what_gem_drop)
                            count = count + 1
                        end
                        self:command("give all.gem " .. tostring(person.name))
                    end
                end
            end
        end
        self.room:send(tostring(self.name) .. " waves farewell!")
        world.destroy(self)
    end
end$trig$, 'f661fbbb45e29955b715d2fa3285f01d'),
  -- data/triggers/481/481_151_meteor_grants_sworm.lua
  (481, 151, $trig$-- Converted from DG Script #48251: meteor grants sworm
-- Original: OBJECT trigger, flags: USE, probability: 100%
if actor:get_quest_stage("meteorswarm") == 5 then
    wait(1)
    skills.set_level(actor, "meteorswarm", 1000)
    actor:complete_quest("meteorswarm")
    actor:send("<b:red>You have learned the ability to call meteors from the sky!</>")
    wait(1)
    self.room:send("The meteorite crumbles to ash and blows away.")
    world.destroy(self)
end$trig$, '938236bebc611aeacd954a836582e89d'),
  -- data/triggers/481/481_154_mccabe_load.lua
  (481, 154, $trig$-- Converted from DG Script #48254: mccabe load
-- Original: MOB trigger, flags: LOAD, probability: 100%
skills.set_level(self, "meteorswarm", 1000)
skills.set_level(self, "major globe", 1000)$trig$, 'b5d47dc7dd002283a75a6beda5f6037d'),
  -- data/triggers/489/489_07_lokari_death.lua
  (489, 7, $trig$-- Converted from DG Script #48907: lokari death
-- Original: MOB trigger, flags: DEATH, probability: 100%
--
-- Lokari banishes himself, drops the glass-shard for the body-loader, and
-- awards the shift-corpse spell to anyone in his group at quest stage 2.
self.room:send("Lokari's form dissipates, banished from this realm.")
self.room:send(tostring(objects.template(489, 14).name) .. " falls from Lokari's hand as he disappears.")
self:destroy_item("glass-shard")
run_room_trigger(489, 16)

local function award_shift_corpse(person)
    if not person or person.room ~= self.room then
        return
    end
    if person:get_quest_stage("shift_corpse") ~= 2 then
        return
    end
    self.room:send("<blue>&9Swirling energy as black as the moonless night slithers from " .. tostring(objects.template(62, 28).name) .. ".<blue>&9")
    person:send("<blue>&9It fills you with limitless arcane power as it forces its way into your body!</>")
    person:send("<blue>&9Your awareness of death now stretches beyond the boundaries of the planes themselves!</>")
    self.room:send_except(person, "<blue>&9It forces its way into " .. tostring(person.name) .. "'s body!</>")
    person:complete_quest("shift_corpse")
    skills.set_level(person, "shift corpse", 1000)
end

if actor and actor.group and #actor.group > 0 then
    for _, person in ipairs(actor.group) do
        award_shift_corpse(person)
    end
else
    award_shift_corpse(actor)
end
self:teleport(get_room(11, 0))
return true$trig$, '2f74623be791cea2073e7f5ebaca1db4'),
  -- data/triggers/492/492_54_quest_relocate_receive.lua
  (492, 54, $trig$-- Converted from DG Script #49254: quest_relocate_receive
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action (item kept by mob)
-- 
-- edit 3-7-2021 by Daedela: Acerites code was throwing errors because of the logic flow.
-- It worked when the questor did exactly as told, but deviating risked system failure.
-- The quest is identical, but the logic has been completely re-written to eliminate the errors.
-- Comments about Acerites hatred of ampersands is preserved for posterity and the previous code is logged on the Wiki.
local stage = actor:get_quest_stage("relocate_spell_quest")
if stage == 1 then
    if object.id == 49250 then
        wait(1)
        self:destroy_item("mystics")
        self.room:send("A lost mage examines the Druidstaff carefully.")
        wait(1)
        self:command("glare " .. tostring(actor.name))
        self.room:send(tostring(self.name) .. " says, 'No no, it is of no use to me unless you destroy the druid")
        self.room:send("</>YOURSELF!  Try again.'")
        wait(1)
        self:command("frown")
    end
elseif stage == 2 then
    if object.id == 49250 then
        wait(2)
        actor:advance_quest("relocate_spell_quest")
        actor:send("A lost mage tells you, 'Excellent, thank you! Thank you!'")
        wait(10)
        self:command("hold mystics")
        wait(10)
        actor:send("A lost mage tells you, 'Ok, the next thing required is the Crystal")
        actor:send("</>Telescope.  An observer of the cold village holds it, but you must not harm")
        actor:send("</>him.  Convince him to give it to you, then bring it back to me.'")
        self.room:send_except(actor, "A lost mage tells something to " .. tostring(actor.name) .. ".")
        wait(20)
        actor:send("A lost mage tells you, 'Go now, I must start with the staff!'")
        self.room:send_except(actor, "A lost mage tells something to " .. tostring(actor.name) .. ".")
    end
elseif stage == 4 then
    if object.id == 49252 then
        wait(1)
        self:destroy_item("telescope")
        self.room:send("A lost mage examines the telescope carefully.")
        wait(1)
        self:command("frown " .. tostring(actor.name))
        self.room:send(tostring(self.name) .. " says, 'How did you get this? There's something missing here.")
        self.room:send("</>You must earn this properly. Go NOW!'")
    end
elseif stage == 5 then
    if object.id == 49252 then
        wait(2)
        actor:advance_quest("relocate_spell_quest")
        actor:send("A lost mage tells you, 'Yes, yes! Thank you!")
        wait(10)
        self:command("hold telescope")
        wait(10)
        actor:send("A lost mage tells you, 'Ok ok, you've done well, the next item I need is the")
        actor:send("</>spellbook.'")
        wait(20)
        actor:send("A lost mage tells you, 'But not just any spellbook.  This one is held deep")
        actor:send("</>inside a very powerful tower.  To find the tower you must look within the")
        actor:send("</>destroyed land.  That is all I can say.  Go now!'")
        self.room:send_except(actor, "A lost mage tells something to " .. tostring(actor.name) .. ".")
    end
elseif stage == 6 then
    if object.id == 12520 then
        actor:advance_quest("relocate_spell_quest")
        actor:save()
        wait(2)
        actor:send("A lost mage tells you, 'Perfect! Only two items left!'")
        wait(10)
        self:command("rem mystics")
        self:destroy_item("mystics")
        self:command("hold spellbook")
        wait(10)
        actor:send("A lost mage tells you, 'There is something I need from South Caelia.  I don't")
        actor:send("</>know the area well, but I know someone who does.  I once met a man that mapped")
        actor:send("</>everything he saw.  Please get me his map.'")
        self.room:send_except(actor, "A lost mage tells something to " .. tostring(actor.name) .. ".")
        wait(10)
        self:command("ponder")
        wait(10)
        actor:send("A lost mage tells you, 'I think he said something about the ocean and the")
        actor:send("</>beach, that's all I know.'")
        self.room:send_except(actor, "A lost mage tells something to " .. tostring(actor.name) .. ".")
    end
elseif stage == 7 then
    if object.id == 58608 then
        actor:advance_quest("relocate_spell_quest")
        wait(2)
        actor:send("A lost mage tells you, 'Almost there, one more!'")
        wait(10)
        self:command("rem telescope")
        self:destroy_item("telescope")
        self:command("hold map")
        wait(10)
        actor:send("A lost mage tells you, 'The only thing left that I need is something to write")
        actor:send("</>with.  A while back I dropped something while engaged in a little confrontation")
        actor:send("</>with that witch Baba.  Luckily, I don't think she saw me drop it, so it should")
        actor:send("</>still be hidden around there.'")
        self.room:send_except(actor, "A lost mage tells something to " .. tostring(actor.name) .. ".")
        wait(4)
        self:command("sigh")
        wait(1)
        actor:send("A lost mage tells you, 'Please get my quill back, then I shall share the spell")
        actor:send("</>with you!'")
        self.room:send_except(actor, "A lost mage tells something to " .. tostring(actor.name) .. ".")
        run_room_trigger(492, 25)
    end
elseif stage == 8 then
    if object.id == 49251 then
        wait(1)
        self.room:send("A lost mage examines the golden quill.")
        wait(1)
        self:command("sigh")
        self.room:send(tostring(self.name) .. " says, 'You did not get this yourself.  Unfortunately this is a")
        self.room:send("</>problem, as now that another has touched this it has lost its power.'")
        self:command("frown")
    end
elseif stage == 9 then
    if object.id == 49251 then
        wait(20)
        actor:send("A lost mage tells you, 'Excellent, Thank you so much, please wait while I")
        actor:send("</>scribe my spell!'")
        self.room:send_except(actor, "A lost mage tells something to " .. tostring(actor.name) .. ".")
        wait(1)
        self:command("sit")
        self:command("rem map")
        self:destroy_item("map")
        self:command("hold quill")
        self.room:send("A lost mage puts on her spectacles and begins to scribe.")
        wait(20)
        self.room:send("A lost mage puts away her spectacles and stops scribing.")
        self:command("stand")
        self:command("fly")
        wait(1)
        actor:send("A lost mage tells you, 'Very well, I'm done!  Thank you so much,")
        actor:send("</>" .. tostring(actor.name) .. "!'")
        wait(20)
        actor:send("A lost mage tells you, 'And, as I promised, here is the spell!'")
        actor:send("A lost mage shows you the spell scribed in her spellbook.")
        skills.set_level(actor, "relocate", 1000)
        actor:complete_quest("relocate_spell_quest")
        self.room:send_except(actor, "A lost mage shows " .. tostring(actor.name) .. " her spellbook, teaching " .. tostring(actor.possessive) .. " her secrets.")
        wait(20)
        self.room:send("A lost mage starts casting <b:yellow>'relocate'</>...")
        wait(15)
        self.room:send("<b:white>A lost mage's molecules loosen and eventually dissipate into thin air.</>")
        self:teleport(get_room(492, 99))
        world.destroy(self)
    end
else
    -- Legacy DG returned 0 here (refuse the item, return it to actor).
    _return_value = false
    wait(2)
    actor:send("A lost mage tells you, 'This item doesn't help me.'")
    actor:send("A lost mage returns your item.")
    self.room:send_except(actor, "A lost mage returns " .. tostring(actor.name) .. "'s item.")
end
return _return_value$trig$, 'f59b6e44a1ba075ca616357beb822217'),
  -- data/triggers/533/533_10_wall_ice_crystalize_speech.lua
  (533, 10, $trig$-- 1% chance to trigger (preserved from DG)
if not percent_chance(1) then
    return true
end

-- Speech keywords: crystalize
local speech_lower = string.lower(speech)
if not string.find(speech_lower, "crystalize") then
    return true  -- No matching keywords
end

if actor:get_quest_stage("wall_ice") == 1 and actor:has_item(533, 26) and self.id ~= 53316 then
    if self.flags and self.flags.ice_crystalize_attempted then
        actor:send("<cyan>You have already cast this spell on " .. tostring(self.name) .. "!</>")
    else
        local roll = random(1, 100)
        local drop = tonumber(actor:get_quest_var("wall_ice:drop")) or 0
        if drop < 21 then
            if roll <= self.level then
                self.room:send("<cyan>A dark glow surrounds <b:cyan>" .. tostring(self.name) .. "</><cyan> briefly!</>")
                self.flags = self.flags or {}
                self.flags.ice_crystalize_attempted = true
                self.flags.ice_crystalize_success = true
                actor:set_quest_var("wall_ice", "drop", drop + 1)
            else
                self.room:send("<cyan>The spell seems to have no effect!</>")
                self.flags = self.flags or {}
                self.flags.ice_crystalize_attempted = true
            end
        end
    end
elseif self.id == 53316 and actor:get_quest_stage("wall_ice") == 2 and actor:has_item(533, 26) then
    self.room:send("<b:cyan>The blocks of living ice slowly fuse together!</>")
    wait(1)
    self:say("Well done!")
    self:command("nod " .. tostring(actor.name))
    wait(1)
    self:say("All in a good day's work!")
    wait(1)
    self:say("Keep the notes.  It should be everything you need to cast Wall of Ice yourself.")
    actor:send("<b:cyan>You have learned Wall of Ice!</>")
    actor:complete_quest("wall_ice")
    skills.set_level(actor, "wall of ice", 1000)
end$trig$, 'd1869339678e6c6384bb67f8521c221e'),
  -- data/triggers/534/534_68_major_globe_lirne_receive_4.lua
  (534, 68, $trig$-- Converted from DG Script #53468: Major Globe Lirne receive 4
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local stage = actor:get_quest_stage("major_globe_spell")
local response
if stage == 10 then
    -- final_item quest var stores the chosen object's local id within zone 534
    if actor:get_quest_var("major_globe_spell:final_item") == object.local_id then
        wait(1)
        self:destroy_item("majorglobe-channel")
        skills.set_level(actor, "major globe", 1000)
        self:emote("grins excitedly.")
        actor:send(tostring(self.name) .. " says, 'Yes!  Now I can cast the spell... and defeat the demon!'")
        self:emote("holds the wards in one hand.")
        wait(2)
        actor:send(tostring(self.name) .. " starts casting <b:yellow>'major globe'</>...")
        wait(2)
        self:emote("completes his spell...")
        self:emote("closes his eyes and utters the words, 'wiyaf travo'.")
        self.room:send("<b:red>A shimmering globe of force wraps around " .. tostring(self.name) .. "'s body.</>")
        wait(2)
        self:command("smile")
        actor:send(tostring(self.name) .. " says, 'I feel much better too!  My sincerest thanks for your help.  As thanks, I offer you knowledge of this ancient spell also.'")
        wait(1)
        actor:send(tostring(self.name) .. " stares at you and utters a quick incantation.")
        actor:send("<b:white>You feel your skill in spell knowledge improving!</>")
        self.room:send_except(actor, tostring(self.name) .. " stares at " .. tostring(actor.name) .. " and utters a quick incantation.")
        wait(1)
        actor:complete_quest("major_globe_spell")
        wait(1)
        actor:send(tostring(self.name) .. " says, 'Now I must take my leave.  Wish me well!'")
        self:emote("hurries out of the room.")
        self:teleport(get_room(11, 0))
        world.destroy(self)
    else
        response = "This isn't what the spell calls for..."
    end
elseif stage < 10 then
    response = "I'm not ready for that yet.  Do the quest in the right order."
end
if response then
    self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
    wait(2)
    actor:send(tostring(self.name) .. " says, '" .. tostring(response) .. "'")
end
return true$trig$, 'a8a6f2413ade523dfc421bdc0f53b733'),
  -- data/triggers/550/550_41_wizard_eye_shaman_sleep.lua
  (550, 41, $trig$-- Converted from DG Script #55041: wizard_eye_shaman_sleep
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: sleep
if not (cmd == "sleep") then
    return true  -- Not our command
end
if actor:get_quest_stage("wizard_eye") == 12 then
    allow_command()  -- legacy `return 0` ahead of the wait: the sleep goes ahead
    wait(1)
    actor:send("A hazy dreamscape appears before you.")
    -- (empty room echo)
    actor:send("The Great Snow Leopard comes into focus!")
    actor:send("The Great Snow Leopard says, 'Come, follow where I walk.'")
    wait(2)
    actor:send("The Great Snow Leopard leads you on a journey through crisp, cold, snowy mountains...")
    wait(3)
    actor:send("hot burning deserts, sweltering jungles of sweet scented flowers...")
    wait(3)
    actor:send("distant mysterious islands of alien sounds...")
    wait(3)
    actor:send("through cities of people speaking languages you do not understand...")
    wait(6)
    actor:send("Soaring through the open sky, the Great Snow Leopard roars to shake the heavens!")
    -- (empty room echo)
    actor:send("In the echoes of the roar, you can see shape distant lands!")
    actor:send("The nature of the spell becomes clear!")
    actor:complete_quest("wizard_eye")
    skills.set_level(actor, "wizard eye", 1000)
    actor:send("<b:cyan>You have learned Wizard Eye!</>")
end
return true$trig$, '75bc2def47f61b26ca10932bba85fa57'),
  -- data/triggers/580/580_07_charm_person_instruments_command.lua
  (580, 7, $trig$local _return_value = true  -- Default: allow action
if actor:get_quest_stage("charm_person") == 4 then
    _return_value = true
    local room = actor.room
    -- switch on self.id
    if room:get_people(30, 10) then
        if self.id == 48925 then
            wait(2)
            self.room:send(tostring(mobiles.template(30, 10).name) .. " hums along dreamily.")
            actor:set_quest_var("charm_person", "charm1", 1)
            actor:send("<b:magenta>" .. tostring(mobiles.template(30, 10).name) .. " is charmed by your playing!</>")
        end
        if room:get_people(580, 17) then
        elseif self.id == 37012 then
            wait(2)
            self.room:send(tostring(mobiles.template(580, 17).name) .. " blushes furiously.")
            actor:set_quest_var("charm_person", "charm2", 1)
            actor:send("<b:magenta>" .. tostring(mobiles.template(580, 17).name) .. " is charmed by your playing!</>")
        end
        if room:get_people(584, 6) then
        elseif self.id == 41119 then
            wait(2)
            self.room:send(tostring(mobiles.template(584, 6).name) .. " sighs sweetly.")
            actor:set_quest_var("charm_person", "charm5", 1)
            actor:send("<b:magenta>" .. tostring(mobiles.template(584, 6).name) .. " is charmed by your playing!</>")
        end
        if room:get_people(43, 53) then
        elseif self.id == 16312 then
            wait(2)
            self.room:send(tostring(mobiles.template(43, 53).name) .. " closes her eyes and smiles.")
            actor:set_quest_var("charm_person", "charm3", 1)
            actor:send("<b:magenta>" .. tostring(mobiles.template(43, 53).name) .. " is charmed by your playing!</>")
        end
        if room:get_people(237, 21) then
        elseif self.id == 58017 then
            wait(2)
            self.room:send(tostring(mobiles.template(237, 21).name) .. " burbles with contentment.")
            actor:set_quest_var("charm_person", "charm4", 1)
            actor:send("<b:magenta>" .. tostring(mobiles.template(237, 21).name) .. " is charmed by your playing!</>")
        end
    end
    if actor:get_quest_var("charm_person:charm1") and actor:get_quest_var("charm_person:charm2") and actor:get_quest_var("charm_person:charm3") and actor:get_quest_var("charm_person:charm4") and actor:get_quest_var("charm_person:charm5") then
        wait(4)
        actor:send("Your skill in charming has greatly improved!")
        actor:send("Hinazuru's training has paid off!")
        actor:complete_quest("charm_person")
        actor:send("<b:magenta>You have learned Charm Person!</>")
        skills.set_level(actor, "charm person", 1000)
    end
end
return _return_value$trig$, 'a34070d5656740cce547e602ba7bfbd7'),
  -- data/triggers/580/580_10_charm_person_mobs_play_command.lua
  (580, 10, $trig$-- Command filter: play
if not (cmd == "play") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
if actor:get_quest_stage("charm_person") ~= 4 then
    _return_value = true
    return _return_value
end
-- switch on arg
if self.id ~= 3010 then
    if arg == "mandolin" then
        _return_value = true
        return _return_value
    elseif actor:get_quest_stage("charm_person") == 4 and self.id ==3010 and (actor:has_equipped("48925") or actor:has_item("48925")) then
        actor:send("You strum a beautiful tune on the mandolin.")
        self.room:send_except(actor, tostring(actor.name) .. " strums a beautiful tune on the mandolin.")
        wait(2)
        self.room:send(tostring(self.name) .. " hums along dreamily.")
        actor:set_quest_var("charm_person", "charm1", 1)
        actor:send("<b:magenta>" .. tostring(self.name) .. " is charmed by your playing!</>")
    else
        _return_value = true
        return _return_value
    end
    if actor:get_quest_stage("charm_person") == 4 and self.id == 58017 and (actor:has_equipped("37012") or actor:has_item("37012")) then
    elseif arg == "flute" then
        actor:send("You play a melodious tune on the flute.")
        self.room:send_except(actor, tostring(actor.name) .. " plays a melodious tune on the flute.")
        wait(2)
        self.room:send(tostring(self.name) .. " blushes furiously.")
        actor:set_quest_var("charm_person", "charm2", 1)
        actor:send("<b:magenta>" .. tostring(self.name) .. " is charmed by your playing!</>")
    elseif actor:get_quest_stage("charm_person") == 4 and self.id == 58406 and (actor:has_equipped("41119") or actor:has_item("41119")) then
        actor:send("You play a haunting, dulcet tune on the Sea's Flute.")
        self.room:send_except(actor, tostring(actor.name) .. " plays a haunting, dulcet tune on the Sea's Flute.")
        wait(2)
        self.room:send(tostring(self.name) .. " sighs with nostalgia and longing.")
        actor:set_quest_var("charm_person", "charm5", 1)
        actor:send("<b:magenta>" .. tostring(self.name) .. " is charmed by your playing!</>")
    else
        _return_value = true
        return _return_value
    end
    if actor:get_quest_stage("charm_person") == 4 and self.id == 4353 and (actor:has_equipped("16312") or actor:has_item("16312")) then
    elseif arg == "pipe" then
        actor:send("You blow a wistful melody on the pipe.")
        self.room:send_except(actor, tostring(actor.name) .. " blows a wistful melody on the pipe.")
        wait(2)
        self.room:send(tostring(self.name) .. " closes her eyes and smiles.")
        actor:set_quest_var("charm_person", "charm3", 1)
        actor:send("<b:magenta>" .. tostring(self.name) .. " is charmed by your playing!</>")
    else
        _return_value = true
        return _return_value
    end
    if actor:get_quest_stage("charm_person") == 4 and self.id == 23721 and (actor:has_equipped("58017") or actor:has_item("58017")) then
    elseif arg == "biwa" then
        actor:send("You pluck out a strange, complex arrangement on the biwa.")
        self.room:send_except(actor, tostring(actor.name) .. " plucks out a strange, complex arrangement on the biwa.")
        wait(2)
        self.room:send(tostring(self.name) .. " burbles with contentment.")
        actor:set_quest_var("charm_person", "charm4", 1)
        actor:send("<b:magenta>" .. tostring(self.name) .. " is charmed by your playing!</>")
    else
        _return_value = true
        return _return_value
    end
    if actor:get_quest_stage("charm_person") == 4 and self.id == 58406 and (actor:has_equipped("41119") or actor:has_item("41119")) then
    elseif arg == "sea" or arg == "seas" then
        actor:send("You play a haunting, dulcet tune on the Sea's Flute.")
        self.room:send_except(actor, tostring(actor.name) .. " plays a haunting, dulcet tune on the Sea's Flute.")
        wait(2)
        self.room:send(tostring(self.name) .. " sighs with nostalgia and longing.")
        actor:set_quest_var("charm_person", "charm5", 1)
        actor:send("<b:magenta>" .. tostring(self.name) .. " is charmed by your playing!</>")
    else
        _return_value = true
        return _return_value
    end
else
    _return_value = true
end
if actor:get_quest_var("charm_person:charm1") and actor:get_quest_var("charm_person:charm2") and actor:get_quest_var("charm_person:charm3") and actor:get_quest_var("charm_person:charm4") and actor:get_quest_var("charm_person:charm5") then
    wait(4)
    actor:send("Your skill in charming has greatly improved!")
    actor:send("Hinazuru's training has paid off!")
    actor:complete_quest("charm_person")
    actor:send("<b:magenta>You have learned Charm Person!</>")
    skills.set_level(actor, "charm person", 1000)
end
return _return_value$trig$, '82803631b3ecafe464c53c0e7d307e9c'),
  -- data/triggers/590/590_46_group_armor_forgemaster_receive.lua
  (590, 46, $trig$-- Converted from DG Script #59046: group_armor_forgemaster_receive
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
local stage = actor:get_quest_stage("group_armor")
-- switch on stage
if object.id == 6118 or object.id == 11704 or object.id == 11707 or object.id == 16906 then
    if actor:get_quest_var("group_armor:" .. tostring(object.zone_id) .. "_" .. tostring(object.local_id)) == 1 then
        if stage == 1 then
            _return_value = true
            self:say("You already brought me " .. tostring(object.shortdesc) .. "!")
        else
            actor:set_quest_var("group_armor", (tostring(object.zone_id) .. "_" .. tostring(object.local_id)), 1)
            wait(2)
            world.destroy(object.name)
            wait(2)
            self:say("Aye, this'll do.")
            local item1 = actor:get_quest_var("group_armor:6118")
            local item2 = actor:get_quest_var("group_armor:11704")
            local item3 = actor:get_quest_var("group_armor:11707")
            local item4 = actor:get_quest_var("group_armor:16906")
            if item1 and item2 and item3 and item4 then
                actor:advance_quest("group_armor")
                wait(2)
                self:say("That looks like everything!")
                self:emote("places the four objects near the altar.")
                wait(4)
                self:say("Bad news though.")
                wait(1)
                self.room:send(tostring(self.name) .. " says, 'The Haven was attacked by orcs from Bluebonnet Pass")
                self.room:send("</>while you were gone!'")
                wait(4)
                self.room:send(tostring(self.name) .. " says, 'Fortunately no one was killed, but I had to use")
                self.room:send("</>my consecrated forging hammer to defend myself.  It's no good for works of")
                self.room:send("</>holy creation now.'")
                wait(4)
                self.room:send(tostring(self.name) .. " says, 'Since I need to fix up the forge after the attack")
                self.room:send("</>would you be willing to find me another forging hammer?'")
            else
                local total = (item1 + item2 + item3 + item4)
                wait(2)
                if total <= 2 then
                    self:say("Do you have any of the other items?")
                elseif total == 3 then
                    self:say("Do you have the last one?")
                end
            end
        end
    else
        _return_value = true
        self:say(tostring(object.shortdesc) .. " doesn't cast Armor ya daffy spriggan!")
        self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
        self:command("laugh")
    end
    if object.id == 8701 then
    elseif stage == 2 then
        wait(2)
        self:emote("examines the hammer.")
        self:say("This will do!")
        wait(1)
        self.room:send(tostring(self.name) .. " says, 'To consecrate the hammer again you'll need to")
        self.room:send("</>find a place where the light of the sun reaches deep into the bowels of")
        self.room:send("</>Ethilien and <b:white>[commune]</> with the spirits there.'")
        wait(2)
        self:command("give hammer " .. tostring(actor.name))
        wait(4)
        self.room:send(tostring(self.name) .. " says, 'Places where ore and stone are mined often become")
        self.room:send("</>sacred places for us dwarves.'")
        actor:advance_quest("group_armor")
    else
        _return_value = true
        self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
        self:say("This isn't a forging hammer!")
    end
elseif stage == 3 then
    _return_value = true
    if object.id == 59039 then
        self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
        self:say("Where did you find this?")
        wait(1)
        self:say("This can't be the same hammer you brought me before.")
    elseif object.id == 8701 then
        self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
        self.room:send(tostring(self.name) .. " says, 'You need to bring me the consecrated hammer.")
        self.room:send("</>Another mundane forging hammer is useless.'")
    end
    if object.id == 59039 then
    elseif stage == 4 then
        actor:advance_quest("group_armor")
        wait(2)
        world.destroy(object.name)
        wait(2)
        self:say("Moradin's flames, this is splendid!")
        wait(1)
        self.room:send(tostring(self.name) .. " gives the new hammer a few practice swings.")
        self:say("Aye, that's a fine hammer!")
        wait(3)
        self:say("Let us continue!")
        wait(1)
        self.room:send(tostring(self.name) .. " says, 'This spell needs to be contained in a holy symbol of")
        self.room:send("</>some kind.  There is an amulet, an Aegis amulet, that would serve well for this")
        self.room:send("</>purpose.'")
        wait(3)
        self:say("Find it and bring it back here.")
    else
        _return_value = true
        self:say("What in the heck is this?")
        actor:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
    end
    if object.id == 12500 then
    elseif stage == 5 then
        wait(2)
        self.room:send(tostring(self.name) .. " scrutinizes " .. tostring(object.shortdesc) .. " with a discerning glance.")
        world.destroy(object.name)
        wait(2)
        self:command("nod")
        self:say("Mmhmmm.  Mhmmm.")
        wait(1)
        self:say("Yes, this will be an excellent divine focus.")
        wait(2)
        self.room:send(tostring(self.name) .. " says, 'Finally, I need to capture the intangible protective")
        self.room:send("</>essence of ethereal armor to finish the amulet.  I know of three pieces:'")
        self.room:send("<b:white>a breastplate</>")
        self.room:send("<b:white>a ring</>")
        self.room:send("<b:white>a bracelet</>")
        wait(4)
        self.room:send(tostring(self.name) .. " says, 'See if you can find them.  Items like these are")
        self.room:send("</>often worn by the dead as they can interact with them.'")
        wait(2)
        self:say("Good luck and Moradin guard you!")
        actor:advance_quest("group_armor")
    else
        _return_value = true
        self:say("This won't be a very effective focus.")
        self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
    end
    if object.id == 47004 or object.id == 47018 or object.id == 53003 then
        if actor:get_quest_var("group_armor:" .. tostring(object.zone_id) .. "_" .. tostring(object.local_id)) == 1 then
        elseif stage == 6 then
            _return_value = true
            self:say("You already brought me " .. tostring(object.shortdesc) .. "!")
        else
            wait(2)
            actor:set_quest_var("group_armor", (tostring(object.zone_id) .. "_" .. tostring(object.local_id)), 1)
            self.room:send(tostring(self.name) .. " places " .. tostring(object.shortdesc) .. " near the altar.")
            world.destroy(object.name)
            wait(1)
            local item1 = actor:get_quest_var("group_armor:47004")
            local item2 = actor:get_quest_var("group_armor:47018")
            local item3 = actor:get_quest_var("group_armor:53003")
            if item1 and item2 and item3 then
                self:command("grin")
                self:say("With everything gathered, I can get to work!")
                wait(2)
                self.room:send(tostring(self.name) .. " lays the ethereal breastplate on the anvil.")
                wait(4)
                self.room:send(tostring(self.name) .. " thrusts his hammer into the forge.")
                self.room:send(tostring(self.name) .. " entones, 'Dwarffather, hear my prayer.'")
                wait(4)
                self.room:send(tostring(self.name) .. " raises the <b:red>glowing</> hamer.")
                wait(4)
                self.room:send(tostring(self.name) .. " entones, 'Bless my hammer in this act of Creation.'")
                wait(3)
                self.room:send("The hammer turns <b:white>white</> with holy energy.")
                wait(5)
                self.room:send(tostring(self.name) .. " brings the hammer down on the ethereal breastplate!")
                self.room:send("The breastplate ripples from the force of the hit like the surface of a lake struck by a drop of water.")
                wait(5)
                self:say("Now we add the extra magic!")
                wait(2)
                self.room:send(tostring(self.name) .. " grabs the broom and the hardened stick of leather.")
                self.room:send(tostring(self.name) .. " points them at the ethereal breastplate and releases their magic.")
                wait(4)
                self.room:send("The ethereal breastplate glows white-hot and starts to sizzle!")
                wait(4)
                self.room:send(tostring(self.name) .. " takes a pair of tongs and lays the ethereal bracelet on the radiating breastplate.")
                wait(5)
                self.room:send(tostring(self.name) .. " uncorks the violet potion and pours it over the breastplate.")
                self.room:send("The glow of the breastplate begins to seep into the bracelet!")
                wait(5)
                self:say("Let Creation ring throughout this hallowed forge!")
                wait(4)
                self.room:send(tostring(self.name) .. " strikes the ethereal metals again, melding the bracelet into the armor.")
                wait(4)
                self.room:send("The armor begins to decohere.")
                wait(5)
                self.room:send(tostring(self.name) .. " places the ethereal ring on the shifting energies.")
                self.room:send(tostring(self.name) .. " pours the green potion over the ring, which quickly dissolves.")
                wait(5)
                self.room:send(tostring(self.name) .. " strikes the ethereal mass over and over, chanting prayers to Moradin.")
                wait(5)
                self.room:send("The ethereal energies completely decohere!")
                self.room:send("The forge is filled with hot energy like a basin filled with water.")
                wait(5)
                self.room:send(tostring(self.name) .. " raises the Aegis amulet over his head.")
                wait(2)
                self:say("Soul Forger, let this amulet grant us Your protection!")
                wait(4)
                self.room:send("The Aegis amulet begins to <b:yellow>glow!</>")
                wait(4)
                self.room:send("All sound falls away as the radiant energies of the forge are absorbed into the amulet!")
                wait(4)
                self.room:send(tostring(self.name) .. " places the amulet on the forge anvil.")
                wait(4)
                self.room:send("With a final ceremonial blow, " .. tostring(self.name) .. " seals the protective energies into their new form!")
                wait(7)
                self.room:send("Slowly sound returns as the ringing of an anvil.")
                wait(2)
                self.room:send(tostring(self.name) .. " inspects the new holy amulet.")
                wait(2)
                self:say("Aye, our work is finished.  Thank you acolyte.")
                self:emote("bows and says, 'May the Dwarffather shield you ever more!'")
                wait(2)
                actor:complete_quest("group_armor")
                actor:send("You feel a stirring in your soul!")
                actor:send("<b:white>Moradin blesses you with the knowledge of Group Armor!</>")
                skills.set_level(actor, "group armor", 1000)
            else
                self:say("Did ya find anything else?")
            end
        end
    else
        _return_value = true
        self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
        self:say("This isn't going to serve for Group Armor.")
    end
else
    _return_value = true
    self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
    self:say("What is this for?")
end
return _return_value$trig$, 'c832b298c3bfca75c40152580957c065'),
  -- data/triggers/615/615_51_creeping_doom_pixie_greet.lua
  (615, 51, $trig$-- Converted from DG Script #61551: creeping_doom_pixie_greet
-- Original: MOB trigger, flags: GREET_ALL, probability: 100%
wait(2)
if string.find(actor.class, "Druid") then
    if actor.level > 80 then
        if actor:get_quest_stage("creeping_doom") == 0 then
            self:emote("grumbles about pathetic mortals ruining the world.")
            self:say("Oh what's this?")
            self:command("peer " .. tostring(actor))
            wait(1)
            self:say("A servant of Nature!")
            wait(2)
            self:say("And a powerful one at that!")
            wait(1)
            self.room:send(tostring(self.name) .. " says, 'You!")
            self.room:send("</>You can help us remind the mortals how to treat the majesty of Nature!'")
        elseif actor:get_quest_stage("creeping_doom") == 5 then
            actor:send(tostring(self.name) .. " rushes to congratulate you!")
            wait(1)
            self.room:send(tostring(self.name) .. " says, 'The forest sings of your deed!  Raining doom down on")
            self.room:send("</>that place of genocide has restored balance to part of the Black Woods.'")
            wait(2)
            self.room:send(tostring(self.name) .. " says, 'You earned the right to be called Nature's Avenger")
            self.room:send("</>and the power that brings.'")
            wait(2)
            skills.set_level(actor, "creeping doom", 1000)
            actor:send("<blue>&9The nightmare of the Deep Dreaming touches your soul!")
            actor:send("You have mastered</> <red>Creeping <green>Doom<blue>&9!</>")
            actor:complete_quest("creeping_doom")
        elseif actor:get_quest_stage("creeping_doom") == 4 then
            self.room:send(tostring(self.name) .. " says, 'Is everything alright?")
            self.room:send("</>Do you need another seed?'")
        elseif actor:get_has_completed("creeping_doom") then
            self:say("Welcome back Avenger.")
        else
            self:say("Welcome back Dreamer.")
        end
    else
        self:say("Oh what's this?")
        self:command("peer " .. tostring(actor))
        wait(1)
        self:say("A servant of Nature!")
        wait(1)
        self.room:send(tostring(self.name) .. " says, 'You certainly have promise.  But you're too")
        self.room:send("</>inexperienced to act as Nature's Avenger.  Come back when you're ready for the")
        self.room:send("</>darkest of dreams.'")
    end
end$trig$, '65a9e6f0cfb8ae770e09273420f20720'),
  -- data/triggers/625/625_17_ursa_load.lua
  (625, 17, $trig$-- Converted from DG Script #62517: ursa load
-- Original: MOB trigger, flags: LOAD, probability: 100%
skills.set_level(self, "hitall", 1000)
skills.set_level(self, "roar", 1000)
self:command("roar")
local hit = self.room.actors[random(1, #self.room.actors)]
-- Skip if rolled the mild merchant himself (625, 6).
if hit.zone_id ~= 625 or hit.local_id ~= 6 then
    combat.engage(self, hit)
end$trig$, '7ddc13356b0821bac76abe1f7fcfed25')
) AS v(zone_id, id, commands, old_md5)
WHERE t.zone_id = v.zone_id
  AND t.id = v.id
  AND md5(t.commands) = v.old_md5
  AND t.commands IS DISTINCT FROM v.commands;

COMMIT;
