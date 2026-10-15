-- Converted triggers: undefined DG names (master, hellstage, outside/outdoors, person) and one kod_quest spelling
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
  -- data/triggers/004/004_60_eye_of_the_tiger_progress_journal.lua
  (4, 60, $trig$-- Converted from DG Script #460: Eye of the Tiger progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local function proto_key(vnum)
    vnum = tonumber(vnum)
    if not vnum then return nil end
    local zone = math.floor(vnum / 100)
    if zone == 0 then zone = 1000 end
    return zone, vnum % 100
end
local function proto_short(vnum)
    local zone, id = proto_key(vnum)
    local name = zone and objects.template(zone, id).name
    if not name or name == "" then return "[no description for object " .. tostring(vnum) .. "]" end
    return name
end
-- DG #460 printed an undefined %master% here ("Give  your old trophy."). The trophy is turned in
-- to Pumahl the Beast Master (mob 5306, trigger #5313 "Beast Master Ranger Trophy receive").
local master = mobiles.template(53, 6).name
local _return_value = true  -- Default: allow action
if string.find(arg, "eye of the tiger") or string.find(arg, "tiger") then
    local hunterclasses = "Warrior Ranger Berserker Mercenary"
    if string.find(string.lower(hunterclasses), actor.class, 1, true) then
        _return_value = true
        local huntstage = actor:get_quest_stage("beast_master")
        local trophystage = actor:get_quest_stage("ranger_trophy")
        local job1 = actor:get_quest_var("ranger_trophy:trophytask1")
        local job2 = actor:get_quest_var("ranger_trophy:trophytask2")
        local job3 = actor:get_quest_var("ranger_trophy:trophytask3")
        local job4 = actor:get_quest_var("ranger_trophy:trophytask4")
        actor:send("<b:u:green>Eye of the Tiger</>")
        local level
        if (trophystage or 0) == 0 then
            level = 10
        else
            level = trophystage * 10
        end
        if not actor:get_has_completed("ranger_trophy") then
            actor:send("Minimum Level: " .. tostring(level))
        end
        local status
        if actor:get_has_completed("ranger_trophy") then
            status = "Completed!"
        elseif (trophystage or 0) > 0 then
            status = "In Progress"
        else
            status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
        if actor.level >= level then
            if trophystage == 0 then
                actor:send("You must <b:cyan>[hunt]</> a great beast to demonstrate your skills first.")
                return _return_value
            elseif (trophystage >= huntstage) and not actor:get_has_completed("beast_master") then
                actor:send("Prove your dominion over some more great beasts before you can demonstrate your skills.")
                return _return_value
            end
            -- switch on trophystage
            local trophy
            local gem
            local place
            local hint
            do
                local _sw1 = string.lower(tostring(trophystage or ""))
                if tonumber(_sw1) == 1 then
                    trophy = 1607
                    gem = 55579
                    place = "A Coyote's Den"
                    hint = "near the Kingdom of the Meer Cats."
                elseif tonumber(_sw1) == 2 then
                    trophy = 17806
                    gem = 55591
                    place = "In the Lions' Den"
                    hint = "in the western reaches of Gothra."
                elseif tonumber(_sw1) == 3 then
                    trophy = 1805
                    gem = 55628
                    place = "either of the two Gigantic Roc Nests"
                    hint = "in the Wailing Mountains."
                elseif tonumber(_sw1) == 4 then
                    trophy = 62513
                    gem = 55652
                    place = "Chieftain's Lair"
                    hint = "in Nukreth Spire in South Caelia."
                elseif tonumber(_sw1) == 5 then
                    trophy = 23803
                    gem = 55664
                    place = "The Heart of the Den"
                    hint = "where the oldest unicorn in South Caelia makes its home."
                elseif tonumber(_sw1) == 6 then
                    trophy = 43009
                    gem = 55685
                    place = "Giant Lynx's Lair"
                    hint = "far to the north beyond Mt. Frostbite."
                elseif tonumber(_sw1) == 7 then
                    trophy = 47008
                    gem = 55705
                    place = "Giant Griffin's Nest"
                    hint = "tucked away in a secluded and well guarded corner of Griffin Island."
                elseif tonumber(_sw1) == 8 then
                    trophy = 53323
                    gem = 55729
                    place = "Witch's Den"
                    hint = "entombed with an ancient evil king."
                elseif tonumber(_sw1) == 9 then
                    trophy = 52014
                    gem = 55741
                    place = "Dargentan's Lair"
                    hint = "at the pinnacle of his flying fortress."
                end
            end
            local attack = trophystage * 100
            if job1 or job2 or job3 or job4 then
                actor:send("You've done the following:")
                if job1 then
                    actor:send("- attacked " .. tostring(attack) .. " times")
                end
                if job2 then
                    actor:send("- found " .. proto_short(trophy))
                end
                if job3 then
                    actor:send("- found " .. proto_short(gem))
                end
                if job4 then
                    actor:send("- foraged in " .. tostring(place))
                end
            end
            actor:send("</>")
            actor:send("You need to:")
            if job1 and job2 and job3 and job4 then
                actor:send("Give " .. tostring(master) .. " your old trophy.")
                return _return_value
            end
            if not job1 then
                local remaining = attack - (actor:get_quest_var("ranger_trophy:attack_counter") or 0)
                actor:send("- attack <b:green>" .. tostring(remaining) .. "</> more times while wearing your trophy.")
            end
            if not job2 then
                actor:send("- find <b:green>" .. proto_short(trophy) .. "</>")
            end
            if not job3 then
                actor:send("- find <b:green>" .. proto_short(gem) .. "</>")
            end
            if not job4 then
                actor:send("- <b:green>forage</> in a place called \"<b:green>" .. tostring(place) .. "</>\".")
                actor:send("</>   It's <b:green>" .. tostring(hint) .. "</>")
            end
        end
    end
end
return _return_value$trig$, 'a3ee44a96f615dc09d082e17e8bbcb52'),
  -- data/triggers/023/023_14_hell_trident_speech_trident_upgrades.lua
  (23, 14, $trig$-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local spell1, spell2, step
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"trident", "upgrades"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
wait(0.2)
local hellstep = actor:get_quest_stage("hell_trident")
local level
if hellstep == 1 then
    level = 65
elseif hellstep == 2 then
    level = 90
end
if (hellstep or 0) > 0 then
    -- switch on self.id
    do
        if (self.zone_id == 23 and self.id == 11) then
            -- switch on hellstep
            local response
            do
                local _sw2 = string.lower(tostring(hellstep or ""))
                if tonumber(_sw2) == 1 then
                    response = "stage2"
                elseif tonumber(_sw2) == 2 then
                    response = "stage3"
                else
                    if actor:get_has_completed("hell_trident") then
                        response = "complete"
                    end
                end
            end
        elseif (self.zone_id == 60 and self.id == 32) then
            step = 1
            spell1 = actor:get_has_completed("hellfire_brimstone")
            spell2 = actor:get_has_completed("banish")
            if not actor:get_quest_var("hell_trident:helltask6") then
                if actor:get_quest_stage("vilekka_stew") > 3 then
                    actor:set_quest_var("hell_trident", "helltask6", 1)
                end
            end
        elseif (self.zone_id == 125 and self.id == 26) then
            step = 2
            spell1 = actor:get_has_completed("resurrection_quest")
            spell2 = actor:get_has_completed("hell_gate")
        end
    end
    if not actor:get_quest_var("hell_trident:helltask5") then
        if spell1 then
            actor:set_quest_var("hell_trident", "helltask5", 1)
        end
    end
    if not actor:get_quest_var("hell_trident:helltask4") then
        if spell2 then
            actor:set_quest_var("hell_trident", "helltask4", 1)
        end
    end
    local response
    if actor:get_quest_stage("hell_trident") == step then
        if actor.level >= level then
            if (actor:get_quest_var("hell_trident:greet") or 0) == 0 then
                actor:set_quest_var("hell_trident", "greet", 1)
                if (self.zone_id == 60 and self.id == 32) then
                    actor:send("In the hissed whisper of ecstatic fervor " .. tostring(self.name) .. " says, 'Six thrice is the number of the greater demons.  Undertaking thus six and six, and six again, their interest can be piqued.'")
                    actor:send("</>")
                    actor:send("- Attempting to land <b:yellow>six and six and six</> in thrusts of your trident shall provide the pattern of the number.")
                    actor:send("</>")
                    actor:send("- <b:yellow>Six rubies, all uncut in nature, does double the signature.")
                    actor:send("</>")
                    actor:send("- Slay <b:yellow>six beings called angels</>, be they of any make or countenance, the number being counted thrice.")
                    actor:send("</>")
                    actor:send("- Sup on the grand powers of Hell to learn the most esoteric diablery.  Complete the quests for <b:yellow>Banish</> and <b:yellow>Hellfire and Brimstone</>.")
                    actor:send("</>")
                    actor:send("- Assist the High Priestess of Lolth in hunting down and destroying the heretics of her Goddess.")
                    wait(2)
                    actor:send(tostring(self.name) .. " says, 'In undertaking six in all will Hell be at your beck and call.'")
                elseif (self.zone_id == 125 and self.id == 26) then
                    actor:send(tostring(self.name) .. " says, 'Perhaps I will grant you a boon if you carry out sacrifices in my name.'")
                    actor:send("</>")
                    actor:send("- <b:yellow>Attack with " .. tostring(objects.template(23, 39).name) .. " 666 times</> as a sacrifice of power.")
                    actor:send("</>")
                    actor:send("- Bring me <b:yellow>six radiant rubies</> as a sacrifice of wealth.")
                    actor:send("</>")
                    actor:send("- Slay a combination of <b:yellow>six ghaeles, solars, or lesser seraphs</>.  Their suffering shall please me as a sacrifice of divinity.")
                    actor:send("</>")
                    actor:send("- Learn the most unholy of prayers.  Complete the quests for <b:yellow>Resurrection</> and <b:yellow>Hell Gate</> as a sacrifice of knowledge.")
                    actor:send("</>")
                    actor:send("- Finally, find one long-buried and branded an infidel.  <b:yellow>Finish his undying duel for him</> as a sacrifice of honor.")
                    wait(2)
                    actor:send(tostring(self.name) .. " says, 'Do this and I will lend you a greater share of my power.'")
                end
                wait(2)
                actor:send(tostring(self.name) .. " says, 'You can ask about your <b:cyan>[weapon progress]</> at any time.'")
            else
                actor:send(tostring(self.name) .. " says, 'Remember your six sacrifices.  Ask about your <b:cyan>[weapon progress]</> if you must.'")
            end
        else
            response = "level"
        end
    else
        if actor:get_has_completed("hell_trident") then
            response = "complete"
        elseif actor:get_quest_stage("hell_trident") < step then
            response = "stage1"
        else
            response = "stage3"
        end
    end
    if response == "stage1" then
        actor:send(tostring(self.name) .. " says, 'You must make the initial offerings with another dark priest.'")
    elseif response == "stage2" then
        if actor.level >= level then
            actor:send(tostring(self.name) .. " says, 'Hell hungers for more and will reward you greatly if you feed it.  Attack with that trident 666 times then seek out the Black Priestess, the left hand of Ruin Wormheart.  She will guide your offerings.'")
        else
            actor:send(tostring(self.name) .. " says, 'Other forces of Hell will eventually take notice of you too now.  Seek out the left hand of Ruin Wormheart, the Black Priestess, after you have grown more.  She will be your emissary.'")
            actor:send("<red>You must be level " .. tostring(level) .. " or greater to continue this quest.</>")
        end
    elseif response == "stage3" then
        if actor.level >= level then
            actor:send(tostring(self.name) .. " says, 'The Demon Lord Krisenna is known to traffic with mortals from time to time.  Impress him and perhaps he will grant you a boon.'")
        else
            actor:send(tostring(self.name) .. " says, 'Continue to prove your value to Hell and perhaps a Demon Lord might be willing to grant your their patronage.'")
            actor:send("<red>You must be level " .. tostring(level) .. " or greater to continue this quest.</>")
        end
    elseif response == "complete" then
        actor:send(tostring(self.name) .. " says, 'You've already marshalled the forces of Hell and Damnation to your side!'")
    elseif response == "level" then
        actor:send(tostring(self.name) .. " say, 'Stand before me again when you have achieved a larger measure of greatness.'")
        actor:send("<red>You must be level " .. tostring(level) .. " or greater to continue this quest.</>")
    end
end$trig$, '9e2639eff4c4aabcd5b29d30ef7b42ea'),
  -- data/triggers/030/030_83_dragon_slayer_isilynor_receive.lua
  (30, 83, $trig$-- Converted from DG Script #3083: Dragon Slayer Isilynor Receive
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
-- switch on object.id
-- hunt notices here
local stage, victim1, go, pendantstage, item
if (object.zone_id == 30 and object.id == 80) then
    stage = 1
    victim1 = "a dragon hedge"
    go = "hunt"
elseif (object.zone_id == 30 and object.id == 81) then
    stage = 2
    victim1 = "the green wyrmling"
    go = "hunt"
elseif (object.zone_id == 30 and object.id == 82) then
    stage = 3
    victim1 = "Wug the Fiery Drakling"
    go = "hunt"
elseif (object.zone_id == 30 and object.id == 83) then
    stage = 4
    victim1 = "the young blue dragon"
    go = "hunt"
elseif (object.zone_id == 30 and object.id == 84) then
    stage = 5
    victim1 = "a faerie dragon"
    go = "hunt"
elseif (object.zone_id == 30 and object.id == 85) then
    stage = 6
    victim1 = "the wyvern"
    go = "hunt"
elseif (object.zone_id == 30 and object.id == 86) then
    stage = 7
    victim1 = "an ice lizard"
    go = "hunt"
elseif (object.zone_id == 30 and object.id == 87) then
    stage = 8
    victim1 = "the Beast of Borgan"
    go = "hunt"
elseif (object.zone_id == 30 and object.id == 88) then
    stage = 9
    victim1 = "Tri-Aszp"
    go = "hunt"
elseif (object.zone_id == 30 and object.id == 89) then
    stage = 10
    victim1 = "the Hydra"
    go = "hunt"
    -- paladin pendant items start here
elseif object.id == 360 then
    pendantstage = 1
    item = "quest"
    go = "necklace"
elseif (object.zone_id == 120 and object.id == 3) then
    pendantstage = 1
    item = "necklace"
    go = "necklace"
elseif (object.zone_id == 555 and object.id == 82) then
    pendantstage = 1
    item = "gem"
    go = "necklace"
elseif object.id == 361 then
    pendantstage = 2
    item = "quest"
    go = "necklace"
elseif (object.zone_id == 237 and object.id == 8) then
    pendantstage = 2
    item = "necklace"
    go = "necklace"
elseif (object.zone_id == 555 and object.id == 90) then
    pendantstage = 2
    item = "gem"
    go = "necklace"
elseif object.id == 362 then
    pendantstage = 3
    item = "quest"
    go = "necklace"
elseif (object.zone_id == 580 and object.id == 5) then
    pendantstage = 3
    item = "necklace"
    go = "necklace"
elseif (object.zone_id == 556 and object.id == 22) then
    pendantstage = 3
    item = "gem"
    go = "necklace"
elseif object.id == 363 then
    pendantstage = 4
    item = "quest"
    go = "necklace"
elseif (object.zone_id == 481 and object.id == 23) then
    pendantstage = 4
    item = "necklace"
    go = "necklace"
elseif (object.zone_id == 556 and object.id == 54) then
    pendantstage = 4
    item = "gem"
    go = "necklace"
elseif object.id == 364 then
    pendantstage = 5
    item = "quest"
    go = "necklace"
elseif (object.zone_id == 123 and object.id == 36) then
    pendantstage = 5
    item = "necklace"
    go = "necklace"
elseif (object.zone_id == 556 and object.id == 62) then
    pendantstage = 5
    item = "gem"
    go = "necklace"
elseif object.id == 365 then
    pendantstage = 6
    item = "quest"
    go = "necklace"
elseif (object.zone_id == 430 and object.id == 19) then
    pendantstage = 6
    item = "necklace"
    go = "necklace"
elseif (object.zone_id == 556 and object.id == 77) then
    pendantstage = 6
    item = "gem"
    go = "necklace"
elseif object.id == 366 then
    pendantstage = 7
    item = "quest"
    go = "necklace"
elseif (object.zone_id == 370 and object.id == 15) then
    pendantstage = 7
    item = "necklace"
    go = "necklace"
elseif (object.zone_id == 557 and object.id == 9) then
    pendantstage = 7
    item = "gem"
    go = "necklace"
elseif object.id == 367 then
    pendantstage = 8
    item = "quest"
    go = "necklace"
elseif (object.zone_id == 584 and object.id == 29) then
    pendantstage = 8
    item = "necklace"
    go = "necklace"
elseif (object.zone_id == 557 and object.id == 38) then
    pendantstage = 8
    item = "gem"
    go = "necklace"
elseif object.id == 368 then
    pendantstage = 9
    item = "quest"
    go = "necklace"
elseif (object.zone_id == 520 and object.id == 10) then
    pendantstage = 9
    item = "necklace"
    go = "necklace"
elseif (object.zone_id == 557 and object.id == 39) then
    pendantstage = 9
    item = "gem"
    go = "necklace"
else
    _return_value = true
    self:command("shake")
    self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
    wait(0.2)
    self:say("What is this for?")
    return _return_value
end
if go == "hunt" then
    if actor:get_quest_stage("dragon_slayer") == "stage" and actor:get_quest_var("dragon_slayer:hunt") == "dead" then
        local anti = "Anti-Paladin"
        wait(0.2)
        world.destroy(object)
        self:command("cheer")
        actor:send(tostring(self.name) .. " says, 'Congratulations!  Here's your reward.'")
        local money = stage * 10
        self:command("give " .. tostring(money) .. " platinum " .. tostring(actor))
        local expcap
        if stage == 1 then
            expcap = 5
        else
            local bonus = (stage - 1) * 10
            expcap = bonus
        end
        local expmod
        if expcap < 9 then
            expmod = (((expcap * expcap) + expcap) / 2) * 55
        elseif expcap < 17 then
            expmod = 440 + ((expcap - 8) * 125)
        elseif expcap < 25 then
            expmod = 1440 + ((expcap - 16) * 175)
        elseif expcap < 34 then
            expmod = 2840 + ((expcap - 24) * 225)
        elseif expcap < 49 then
            expmod = 4640 + ((expcap - 32) * 250)
        elseif expcap < 90 then
            expmod = 8640 + ((expcap - 48) * 300)
        else
            expmod = 20940 + ((expcap - 89) * 600)
        end
        -- switch on actor.class
        if actor.class == "warrior" or actor.class == "berserker" then
            expmod = (expmod + (expmod / 10))
        elseif actor.class == "paladin" or actor.class == "anti-paladin" or actor.class == "ranger" then
            expmod = (expmod + ((expmod * 2) / 15))
        elseif actor.class == "sorcerer" or actor.class == "pyromancer" or actor.class == "cryomancer" or actor.class == "illusionist" or actor.class == "bard" then
            expmod = (expmod + (expmod / 5))
        elseif actor.class == "necromancer" or actor.class == "monk" then
            expmod = (expmod + (expmod * 2) / 5)
        else
            expmod = expmod
        end
        actor:send("<b:yellow>You gain experience!</>")
        local setexp = (expmod * 10)
        local loop = 0
        while loop < 3 do
            actor:award_exp(setexp)
            loop = loop + 1
        end
        actor:set_quest_var("dragon_slayer", "target1", 0)
        actor:set_quest_var("dragon_slayer", "hunt", 0)
        wait(0.2)
        if stage < 10 then
            actor:advance_quest("dragon_slayer")
            actor:send(tostring(self.name) .. " says, 'Check in again if you have time for more work.'")
        else
            actor:complete_quest("dragon_slayer")
            actor:send(tostring(self.name) .. " says, 'You have earned your place among the greatest dragon slayers in the realm!'")
            wait(1)
            actor:send(tostring(self.name) .. " says, 'I bestow upon you this crest in recognition of your might.  Wear this proudly.'")
            self.room:spawn_object(4, 149)
            self:command("give crest " .. tostring(actor))
        end
        if (string.find(actor.class, "paladin") or string.find(actor.class, "anti")) and actor:get_quest_stage("paladin_pendant") == 0 then
            wait(2)
            actor:send(tostring(self.name) .. " says, 'I think you've earned this too.'")
            self.room:spawn_object(2, 160)
            self:command("give necklace " .. tostring(actor))
            wait(1)
            actor:send(tostring(self.name) .. " says, 'Necklaces like these are proof of your devotion to your causes.'")
            actor:start_quest("paladin_pendant")
            wait(2)
            if actor.level > 9 then
                actor:send(tostring(self.name) .. " says, 'This is an opportune time to further prove your <b:cyan>[devotion]</>.'")
            else
                actor:send(tostring(self.name) .. " says, 'Come back with that necklace after you reach level 10.  We can discuss acts of devotion then.'")
            end
        end
    elseif actor:get_quest_stage("dragon_slayer") > stage then
        _return_value = true
        self:command("shake")
        self.room:send(tostring(self.name) .. " refuses the notice.")
        wait(0.2)
        actor:send(tostring(self.name) .. " says, 'You already killed this dragon!'")
    elseif actor:get_quest_stage("dragon_slayer") < stage then
        wait(0.2)
        self:command("eye " .. tostring(actor))
        actor:send(tostring(self.name) .. " says, 'How'd you get this?!  You steal it off someone else??'")
        self.room:send(tostring(self.name) .. " rips up the notice!")
        world.destroy(object)
    elseif actor:get_quest_var("dragon_slayer:hunt") ~= "dead" then
        _return_value = true
        self.room:send(tostring(self.name) .. " refuses the notice.")
        wait(0.2)
        actor:send(tostring(self.name) .. " says, 'You have to slay the dragon first!  " .. tostring(victim1) .. " is still out there.")
    end
elseif go == "necklace" then
    if actor:get_quest_stage("dragon_slayer") < actor:get_quest_stage("paladin_pendant") then
        _return_value = true
        self:command("shake")
        self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
        wait(0.2)
        actor:send(tostring(self.name) .. " says, 'Slay some more dragons first.'")
    elseif actor.level < (actor:get_quest_stage("paladin_pendant") * 10) then
        _return_value = true
        self:command("shake")
        self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
        wait(0.2)
        actor:send(tostring(self.name) .. " says, 'You need to gain some more experience first.'")
    elseif pendantstage > actor:get_quest_stage("paladin_pendant") then
        _return_value = true
        self:command("shake")
        self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
        wait(0.2)
        actor:send(tostring(self.name) .. " says, 'Your devotional act doesn't involve that yet.  Be patient!'")
    elseif pendantstage < actor:get_quest_stage("paladin_pendant") then
        _return_value = true
        self:command("shake")
        self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
        wait(0.2)
        actor:send(tostring(self.name) .. " says, 'You've already performed that act of devotion.'")
    else
        local accept
        if item == "quest" then
            local job1 = actor:get_quest_var("paladin_pendant:necklacetask1")
            local job2 = actor:get_quest_var("paladin_pendant:necklacetask2")
            local job3 = actor:get_quest_var("paladin_pendant:necklacetask3")
            local job4 = actor:get_quest_var("paladin_pendant:necklacetask4")
            if job1 and job2 and job3 and job4 then
                wait(0.2)
                local reward = object.id + 1
                world.destroy(object)
                self:command("nod")
                actor:send(tostring(self.name) .. " says, 'Well done!  You've proven your devotion.'")
                self.room:spawn_object(math.floor(reward / 100), reward % 100)
                self:command("give necklace " .. tostring(actor))
                local expcap = pendantstage * 10
                local expmod
                if expcap < 17 then
                    expmod = 440 + ((expcap - 8) * 125)
                elseif expcap < 25 then
                    expmod = 1440 + ((expcap - 16) * 175)
                elseif expcap < 34 then
                    expmod = 2840 + ((expcap - 24) * 225)
                elseif expcap < 49 then
                    expmod = 4640 + ((expcap - 32) * 250)
                elseif expcap < 90 then
                    expmod = 8640 + ((expcap - 48) * 300)
                else
                    expmod = 20940 + ((expcap - 89) * 600)
                end
                expmod = expmod + ((expmod * 2) / 15)
                actor:send("<b:yellow>You gain experience!</>")
                local setexp = (expmod * 10)
                local loop = 0
                while loop < 7 do
                    actor:award_exp(setexp)
                    loop = loop + 1
                end
                local number = 1
                while number < 5 do
                    actor:set_quest_var("paladin_pendant", "necklacetask%number%", 0)
                    number = number + 1
                end
                if actor:get_quest_stage("paladin_pendant") < 9 then
                    actor:advance_quest("paladin_pendant")
                else
                    actor:complete_quest("paladin_pendant")
                end
            else
                _return_value = true
                self:command("shake")
                self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
                wait(0.2)
                actor:send(tostring(self.name) .. " says, 'You need to do everything else before you offer up your necklace!'")
            end
        elseif item == "necklace" then
            if actor:get_quest_var("paladin_pendant:necklacetask2") == object.id then
                accept = "no"
            else
                accept = "yes"
                actor:set_quest_var("paladin_pendant", "necklacetask2", object.id)
            end
        elseif item == "gem" then
            if actor:get_quest_var("paladin_pendant:necklacetask3") == object.id then
                accept = "no"
            else
                accept = "yes"
                actor:set_quest_var("paladin_pendant", "necklacetask3", object.id)
            end
        end
        if accept == "no" then
            _return_value = true
            self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
            wait(0.2)
            actor:send(tostring(self.name) .. " says, 'You already gave me that.'")
        elseif accept == "yes" then
            wait(0.2)
            world.destroy(object)
            local job1 = actor:get_quest_var("paladin_pendant:necklacetask1")
            local job2 = actor:get_quest_var("paladin_pendant:necklacetask2")
            local job3 = actor:get_quest_var("paladin_pendant:necklacetask3")
            local job4 = actor:get_quest_var("paladin_pendant:necklacetask4")
            if job1 and job2 and job3 and job4 then
                actor:send(tostring(self.name) .. " says, 'Excellent.  Now turn over your current necklace as the final proof of your devotion.'")
            else
                actor:send(tostring(self.name) .. " says, 'Good, now finish the rest.'")
            end
        end
    end
end
return _return_value$trig$, '3867b1509a542ae1b78bca72f7f2ca76'),
  -- data/triggers/053/053_13_beast_master_ranger_trophy_receive.lua
  (53, 13, $trig$-- Converted from DG Script #5313: Beast Master Ranger Trophy receive
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
-- switch on object.id
-- hunt notices here
local stage, victim1, go, trophystage, item
if (object.zone_id == 53 and object.id == 0) then
    stage = 1
    victim1 = "an abominable slime creature"
    go = "hunt"
elseif (object.zone_id == 53 and object.id == 1) then
    stage = 2
    victim1 = "a large buck"
    go = "hunt"
elseif (object.zone_id == 53 and object.id == 2) then
    stage = 3
    victim1 = "the giant scorpion"
    go = "hunt"
elseif (object.zone_id == 53 and object.id == 3) then
    stage = 4
    victim1 = "a monstrous canopy spider"
    go = "hunt"
elseif (object.zone_id == 53 and object.id == 4) then
    stage = 5
    victim1 = "the chimera"
    go = "hunt"
elseif (object.zone_id == 53 and object.id == 5) then
    stage = 6
    victim1 = "the drider king"
    go = "hunt"
elseif (object.zone_id == 53 and object.id == 6) then
    stage = 7
    victim1 = "a beholder"
    go = "hunt"
elseif (object.zone_id == 53 and object.id == 7) then
    stage = 8
    victim1 = "the Banshee"
    go = "hunt"
elseif (object.zone_id == 53 and object.id == 8) then
    stage = 9
    victim1 = "Baba Yaga"
    go = "hunt"
elseif (object.zone_id == 53 and object.id == 9) then
    stage = 10
    victim1 = "the medusa"
    go = "hunt"
    -- ranger trophy items start here
elseif object.id == 370 then
    trophystage = 1
    item = "quest"
    go = "trophy"
elseif (object.zone_id == 16 and object.id == 7) then
    trophystage = 1
    item = "trophy"
    go = "trophy"
elseif (object.zone_id == 555 and object.id == 79) then
    trophystage = 1
    item = "gem"
    go = "trophy"
elseif object.id == 371 then
    trophystage = 2
    item = "quest"
    go = "trophy"
elseif (object.zone_id == 178 and object.id == 6) then
    trophystage = 2
    item = "trophy"
    go = "trophy"
elseif (object.zone_id == 555 and object.id == 91) then
    trophystage = 2
    item = "gem"
    go = "trophy"
elseif object.id == 372 then
    trophystage = 3
    item = "quest"
    go = "trophy"
elseif (object.zone_id == 18 and object.id == 5) then
    trophystage = 3
    item = "trophy"
    go = "trophy"
elseif (object.zone_id == 556 and object.id == 28) then
    trophystage = 3
    item = "gem"
    go = "trophy"
elseif object.id == 373 then
    trophystage = 4
    item = "quest"
    go = "trophy"
elseif (object.zone_id == 625 and object.id == 13) then
    trophystage = 4
    item = "trophy"
    go = "trophy"
elseif (object.zone_id == 556 and object.id == 52) then
    trophystage = 4
    item = "gem"
    go = "trophy"
elseif object.id == 374 then
    trophystage = 5
    item = "quest"
    go = "trophy"
elseif (object.zone_id == 238 and object.id == 3) then
    trophystage = 5
    item = "trophy"
    go = "trophy"
elseif (object.zone_id == 556 and object.id == 64) then
    trophystage = 5
    item = "gem"
    go = "trophy"
elseif object.id == 375 then
    trophystage = 6
    item = "quest"
    go = "trophy"
elseif (object.zone_id == 430 and object.id == 9) then
    trophystage = 6
    item = "trophy"
    go = "trophy"
elseif (object.zone_id == 556 and object.id == 85) then
    trophystage = 6
    item = "gem"
    go = "trophy"
elseif object.id == 376 then
    trophystage = 7
    item = "quest"
    go = "trophy"
elseif (object.zone_id == 470 and object.id == 8) then
    trophystage = 7
    item = "trophy"
    go = "trophy"
elseif (object.zone_id == 557 and object.id == 5) then
    trophystage = 7
    item = "gem"
    go = "trophy"
elseif object.id == 377 then
    trophystage = 8
    item = "quest"
    go = "trophy"
elseif (object.zone_id == 533 and object.id == 23) or (object.zone_id == 533 and object.id == 11) then
    trophystage = 8
    item = "trophy"
    go = "trophy"
elseif (object.zone_id == 557 and object.id == 29) then
    trophystage = 8
    item = "gem"
    go = "trophy"
elseif object.id == 378 then
    trophystage = 9
    item = "quest"
    go = "trophy"
elseif (object.zone_id == 520 and object.id == 14) then
    trophystage = 9
    item = "trophy"
    go = "trophy"
elseif (object.zone_id == 557 and object.id == 41) then
    trophystage = 9
    item = "gem"
    go = "trophy"
else
    _return_value = true
    self:command("shake")
    self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
    wait(0.2)
    self:say("What is this for?")
    return _return_value
end
if go == "hunt" then
    if actor:get_quest_stage("beast_master") == "stage" and actor:get_quest_var("beast_master:hunt") == "dead" then
        wait(0.2)
        world.destroy(object)
        self:command("cheer")
        actor:send(tostring(self.name) .. " says, 'Congratulations!  Here's your reward.'")
        local money = stage * 10
        self:command("give " .. tostring(money) .. " platinum " .. tostring(actor))
        local expcap
        if stage == 1 then
            expcap = 5
        else
            local bonus = (stage - 1) * 10
            expcap = bonus
        end
        local expmod
        if expcap < 9 then
            expmod = (((expcap * expcap) + expcap) / 2) * 55
        elseif expcap < 17 then
            expmod = 440 + ((expcap - 8) * 125)
        elseif expcap < 25 then
            expmod = 1440 + ((expcap - 16) * 175)
        elseif expcap < 34 then
            expmod = 2840 + ((expcap - 24) * 225)
        elseif expcap < 49 then
            expmod = 4640 + ((expcap - 32) * 250)
        elseif expcap < 90 then
            expmod = 8640 + ((expcap - 48) * 300)
        else
            expmod = 20940 + ((expcap - 89) * 600)
        end
        local anti = "Anti-Paladin"
        -- switch on actor.class
        if actor.class == "warrior" or actor.class == "berserker" then
            expmod = (expmod + (expmod / 10))
        elseif actor.class == "paladin" or actor.class == "anti-paladin" or actor.class == "ranger" then
            expmod = (expmod + ((expmod * 2) / 15))
        elseif actor.class == "sorcerer" or actor.class == "pyromancer" or actor.class == "cryomancer" or actor.class == "illusionist" or actor.class == "bard" then
            expmod = (expmod + (expmod / 5))
        elseif actor.class == "necromancer" or actor.class == "monk" then
            expmod = (expmod + (expmod * 2) / 5)
        else
            expmod = expmod
        end
        actor:send("<b:yellow>You gain experience!</>")
        local setexp = (expmod * 10)
        local loop = 0
        while loop < 3 do
            actor:award_exp(setexp)
            loop = loop + 1
        end
        actor:set_quest_var("beast_master", "target1", 0)
        actor:set_quest_var("beast_master", "hunt", 0)
        wait(0.2)
        if stage < 10 then
            actor:advance_quest("beast_master")
            actor:send(tostring(self.name) .. " says, 'Check in again if you have time for more hunts.'")
        else
            actor:complete_quest("beast_master")
            actor:send(tostring(self.name) .. " says, 'You have earned your place among the greatest Beast Masters in the realm!'")
            wait(1)
            actor:send(tostring(self.name) .. " says, 'Take these gloves.  Wear them to show everyone your unstoppable prowess.'")
            self.room:spawn_object(4, 13)
            self:command("give gloves " .. tostring(actor))
        end
        if (string.find(actor.class, "ranger") or string.find(actor.class, "warrior") or string.find(actor.class, "berserker") or string.find(actor.class, "mercenary")) and actor:get_quest_stage("ranger_trophy") == 0 then
            wait(2)
            actor:send(tostring(self.name) .. " says, 'I think you've earned this too.'")
            self.room:spawn_object(2, 170)
            self:command("give trophy " .. tostring(actor))
            wait(1)
            actor:send(tostring(self.name) .. " says, 'Trophies like these are proof of your skill as a hunter.'")
            actor:start_quest("ranger_trophy")
            wait(2)
            if actor.level > 9 then
                actor:send(tostring(self.name) .. " says, 'This is an opportune time to further demonstrate your <b:cyan>[skill]</>.'")
            else
                actor:send(tostring(self.name) .. " says, 'Come back with that trophy after you reach level 10.  We can discuss your skills then.'")
            end
        end
    elseif actor:get_quest_stage("beast_master") > stage then
        _return_value = true
        self:command("shake")
        self.room:send(tostring(self.name) .. " refuses the notice.")
        wait(0.2)
        actor:send(tostring(self.name) .. " says, 'You already killed this creature!'")
    elseif actor:get_quest_stage("beast_master") < stage then
        wait(0.2)
        self:command("eye " .. tostring(actor))
        actor:send(tostring(self.name) .. " says, 'How'd you get this?!  You steal it off someone else??'")
        self.room:send(tostring(self.name) .. " rips up the notice!")
        world.destroy(object)
    elseif actor:get_quest_var("beast_master:hunt") ~= "dead" then
        _return_value = true
        self.room:send(tostring(self.name) .. " refuses the notice.")
        wait(0.2)
        actor:send(tostring(self.name) .. " says, 'You have to slay kill the beast first!  " .. tostring(victim1) .. " is still out there.")
    end
elseif go == "trophy" then
    if actor.class ~= "warrior" and actor.class ~= "ranger" and actor.class ~= "mercenary" and actor.class ~= "berserker" then
        _return_value = true
        self:command("shake")
        self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
        wait(0.2)
        actor:send(tostring(self.name) .. " says, '" .. tostring(actor.class) .. "s aren't fit for these kinds of tests.'")
    elseif actor:get_quest_stage("beast_master") < actor:get_quest_stage("ranger_trophy") then
        _return_value = true
        self:command("shake")
        self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
        wait(0.2)
        actor:send(tostring(self.name) .. " says, 'Defeat some more monsters first.'")
    elseif actor.level < (actor:get_quest_stage("ranger_trophy") * 10) then
        _return_value = true
        self:command("shake")
        self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
        wait(0.2)
        actor:send(tostring(self.name) .. " says, 'You need to gain some more experience first.'")
    elseif trophystage > actor:get_quest_stage("ranger_trophy") then
        _return_value = true
        self:command("shake")
        self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
        wait(0.2)
        actor:send(tostring(self.name) .. " says, 'You don't need that to demonstrate your skills yet.  Be patient!'")
    elseif trophystage < actor:get_quest_stage("ranger_trophy") then
        _return_value = true
        self:command("shake")
        self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
        wait(0.2)
        actor:send(tostring(self.name) .. " says, 'You've already used that as proof.'")
    else
        local accept
        if item == "quest" then
            local job1 = actor:get_quest_var("ranger_trophy:trophytask1")
            local job2 = actor:get_quest_var("ranger_trophy:trophytask2")
            local job3 = actor:get_quest_var("ranger_trophy:trophytask3")
            local job4 = actor:get_quest_var("ranger_trophy:trophytask4")
            if job1 and job2 and job3 and job4 then
                wait(0.2)
                local reward = object.id + 1
                world.destroy(object)
                self:command("nod")
                actor:send(tostring(self.name) .. " says, 'Well done!  You've demonstrated your skills well.'")
                self.room:spawn_object(math.floor(reward / 100), reward % 100)
                self:command("give trophy " .. tostring(actor))
                local expcap = trophystage * 10
                local expmod
                if expcap < 17 then
                    expmod = 440 + ((expcap - 8) * 125)
                elseif expcap < 25 then
                    expmod = 1440 + ((expcap - 16) * 175)
                elseif expcap < 34 then
                    expmod = 2840 + ((expcap - 24) * 225)
                elseif expcap < 49 then
                    expmod = 4640 + ((expcap - 32) * 250)
                elseif expcap < 90 then
                    expmod = 8640 + ((expcap - 48) * 300)
                else
                    expmod = 20940 + ((expcap - 89) * 600)
                end
                -- switch on actor.class
                if actor.class == "warrior" or actor.class == "berserker" then
                    expmod = (expmod + (expmod / 10))
                elseif actor.class == "ranger" then
                    expmod = (expmod + ((expmod * 2) / 15))
                else
                    expmod = expmod
                end
                actor:send("<b:yellow>You gain experience!</>")
                local setexp = (expmod * 10)
                local loop = 0
                while loop < 7 do
                    actor:award_exp(setexp)
                    loop = loop + 1
                end
                local number = 1
                while number < 5 do
                    actor:set_quest_var("ranger_trophy", "trophytask%number%", 0)
                    number = number + 1
                end
                if actor:get_quest_stage("ranger_trophy") < 9 then
                    actor:advance_quest("ranger_trophy")
                else
                    actor:complete_quest("ranger_trophy")
                end
            else
                _return_value = true
                self:command("shake")
                self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
                wait(0.2)
                actor:send(tostring(self.name) .. " says, 'You need to do everything else before you exchange your trophy!'")
            end
        elseif item == "trophy" then
            local task2 = actor:get_quest_var("ranger_trophy:trophytask2")
            if task2 == object.id or ((object.zone_id == 533 and object.id == 11) and (task2 or 0) == 53323) or ((object.zone_id == 533 and object.id == 23) and (task2 or 0) == 53311) then
                accept = "no"
            else
                accept = "yes"
                actor:set_quest_var("ranger_trophy", "trophytask2", object.id)
            end
        elseif item == "gem" then
            if actor:get_quest_var("ranger_trophy:trophytask3") == object.id then
                accept = "no"
            else
                accept = "yes"
                actor:set_quest_var("ranger_trophy", "trophytask3", object.id)
            end
        end
        if accept == "no" then
            _return_value = true
            self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
            wait(0.2)
            actor:send(tostring(self.name) .. " says, 'You already gave me that.'")
        elseif accept == "yes" then
            wait(0.2)
            world.destroy(object)
            local job1 = actor:get_quest_var("ranger_trophy:trophytask1")
            local job2 = actor:get_quest_var("ranger_trophy:trophytask2")
            local job3 = actor:get_quest_var("ranger_trophy:trophytask3")
            local job4 = actor:get_quest_var("ranger_trophy:trophytask4")
            if job1 and job2 and job3 and job4 then
                actor:send(tostring(self.name) .. " says, 'Excellent.  Now give me your current trophy.'")
            else
                actor:send(tostring(self.name) .. " says, 'Good, now finish the rest.'")
            end
        end
    end
end
return _return_value$trig$, '64b50a4ad0b3805e520c8f0bcfce79b1'),
  -- data/triggers/053/053_23_honus_order_receive.lua
  (53, 23, $trig$-- Converted from DG Script #5323: Honus order receive
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
-- switch on object.id
-- hunt orders here
local stage, treasure1
if (object.zone_id == 53 and object.id == 10) then
    stage = 1
    treasure1 = "a singing chain"
elseif (object.zone_id == 53 and object.id == 11) then
    stage = 2
    treasure1 = "a fire ring"
elseif (object.zone_id == 53 and object.id == 12) then
    stage = 3
    treasure1 = "a sandstone ring"
elseif (object.zone_id == 53 and object.id == 13) then
    stage = 4
    treasure1 = "a crimson-tinged electrum hoop"
elseif (object.zone_id == 53 and object.id == 14) then
    stage = 5
    treasure1 = "a Rainbow Shell"
elseif (object.zone_id == 53 and object.id == 15) then
    stage = 6
    treasure1 = "the Stormshield"
elseif (object.zone_id == 53 and object.id == 16) then
    stage = 7
    treasure1 = "the Snow Leopard Cloak"
elseif (object.zone_id == 53 and object.id == 17) then
    stage = 8
    treasure1 = "a coiled rope ladder"
elseif (object.zone_id == 53 and object.id == 18) then
    stage = 9
    treasure1 = "a glowing phoenix feather"
elseif (object.zone_id == 53 and object.id == 19) then
    stage = 10
    treasure1 = "a piece of sleet armor"
end
if actor:get_quest_stage("treasure_hunter") == "stage" and actor:get_quest_var("treasure_hunter:hunt") == "returned" then
    local anti = "Anti-Paladin"
    wait(0.2)
    world.destroy(object)
    self:command("cheer")
    actor:send(tostring(self.name) .. " says, 'Congratulations!  Here's your reward.'")
    local money = stage * 10
    self:command("give " .. tostring(money) .. " platinum " .. tostring(actor))
    local expcap
    if stage == 1 then
        expcap = 5
    else
        local bonus = (stage - 1) * 10
        expcap = bonus
    end
    local expmod
    if expcap < 9 then
        expmod = (((expcap * expcap) + expcap) / 2) * 55
    elseif expcap < 17 then
        expmod = 440 + ((expcap - 8) * 125)
    elseif expcap < 25 then
        expmod = 1440 + ((expcap - 16) * 175)
    elseif expcap < 34 then
        expmod = 2840 + ((expcap - 24) * 225)
    elseif expcap < 49 then
        expmod = 4640 + ((expcap - 32) * 250)
    elseif expcap < 90 then
        expmod = 8640 + ((expcap - 48) * 300)
    else
        expmod = 20940 + ((expcap - 89) * 600)
    end
    -- switch on actor.class
    if actor.class == "warrior" or actor.class == "berserker" then
        expmod = (expmod + (expmod / 10))
    elseif actor.class == "paladin" or actor.class == "anti-paladin" or actor.class == "ranger" then
        expmod = (expmod + ((expmod * 2) / 15))
    elseif actor.class == "sorcerer" or actor.class == "pyromancer" or actor.class == "cryomancer" or actor.class == "illusionist" or actor.class == "bard" then
        expmod = (expmod + (expmod / 5))
    elseif actor.class == "necromancer" or actor.class == "monk" then
        expmod = (expmod + (expmod * 2) / 5)
    else
        expmod = expmod
    end
    actor:send("<b:yellow>You gain experience!</>")
    local setexp = (expmod * 10)
    local loop = 0
    while loop < 3 do
        actor:award_exp(setexp)
        loop = loop + 1
    end
    actor:set_quest_var("treasure_hunter", "treasure1", 0)
    actor:set_quest_var("treasure_hunter", "hunt", 0)
    wait(0.2)
    if stage < 10 then
        actor:advance_quest("treasure_hunter")
        actor:send(tostring(self.name) .. " says, 'Check in again if you have time for more work.'")
    else
        actor:complete_quest("treasure_hunter")
        actor:send(tostring(self.name) .. " says, 'You have earned your place among the greatest treasure hunters in the realm!'")
        wait(1)
        actor:send(tostring(self.name) .. " says, 'Here, take this bracelet as payment for all you've done.  Wear this proudly.'")
        self.room:spawn_object(123, 117)
        self:command("give bracelet " .. tostring(actor))
    end
    if (string.find(actor.class, "rogue") or string.find(actor.class, "thief") or string.find(actor.class, "bard")) and actor:get_quest_stage("rogue_cloak") == 0 then
        wait(2)
        actor:send(tostring(self.name) .. " says, 'I think you've earned this too.'")
        self.room:spawn_object(2, 180)
        self:command("give cloak " .. tostring(actor))
        wait(1)
        actor:send(tostring(self.name) .. " says, 'Cloaks like these show off your rank in the various cloak and dagger guilds.'")
        actor:start_quest("rogue_cloak")
        wait(2)
        if actor.level > 9 then
            actor:send(tostring(self.name) .. " says, 'This puts you in line for a <b:cyan>[promotion]</>.'")
        else
            actor:send(tostring(self.name) .. " says, 'Come back with that cloak after you reach level 10.  We can discuss a promotion then.'")
        end
    end
elseif actor:get_quest_stage("treasure_hunter") > stage then
    _return_value = true
    self:command("shake")
    self.room:send(tostring(self.name) .. " refuses the order.")
    wait(0.2)
    actor:send(tostring(self.name) .. " says, 'You already stole - er, recovered this treasure!'")
elseif actor:get_quest_stage("treasure_hunter") < stage then
    wait(0.2)
    self:command("eye " .. tostring(actor))
    actor:send(tostring(self.name) .. " says, 'How'd you get this?!  You steal it off someone else??'")
    self.room:send(tostring(self.name) .. " rips up the order!")
    world.destroy(object)
elseif actor:get_quest_var("treasure_hunter:hunt") == "running" then
    _return_value = true
    self.room:send(tostring(self.name) .. " refuses the order.")
    wait(0.2)
    actor:send(tostring(self.name) .. " says, 'You have to find the treasure still!  " .. tostring(treasure1) .. " is still out there.")
elseif actor:get_quest_var("treasure_hunter:hunt") == "found" then
    _return_value = true
    self.room:send(tostring(self.name) .. " refuses the order.")
    wait(0.2)
    actor:send(tostring(self.name) .. " says, 'You have to give me the treasure first!  You still have " .. tostring(treasure1) .. " in your possession.'")
end
return _return_value$trig$, 'a283d680938d1358e0dff92a2208d4fb'),
  -- data/triggers/053/053_24_treasure_hunter_treasure_get.lua
  (53, 24, $trig$-- Converted from DG Script #5324: Treasure Hunter treasure get
-- Original: OBJECT trigger, flags: GET, probability: 100%
-- switch on self.id
if (self.zone_id == 615 and self.id == 14) then
    -- singing chain
    local stage = 1
elseif (self.zone_id == 43 and self.id == 19) then
    -- fire ring
    local stage = 2
elseif (self.zone_id == 161 and self.id == 3) then
    -- sandstone ring
    local stage = 3
elseif (self.zone_id == 502 and self.id == 15) then
    -- electrum hoop
    local stage = 4
elseif (self.zone_id == 481 and self.id == 1) then
    -- rainbow shell
    local stage = 5
elseif (self.zone_id == 160 and self.id == 9) then
    -- stormshield
    local stage = 6
elseif (self.zone_id == 550 and self.id == 8) then
    -- snow leopard cloak
    local stage = 7
elseif (self.zone_id == 490 and self.id == 41) then
    -- rope ladder
    local stage = 8
elseif (self.zone_id == 584 and self.id == 1) then
    -- phoenix feather
    local stage = 9
elseif (self.zone_id == 534 and self.id == 100) or (self.zone_id == 534 and self.id == 101) or (self.zone_id == 534 and self.id == 105) or (self.zone_id == 534 and self.id == 106) then
    -- sleet armor
    local stage = 10
end
local person = actor
local i = person.group_size
local a
if i then
    a = 1
else
    a = 0
end
while i >= a do
    person = person.group_member[a]
    if person.room == self.room then
        if person:get_quest_stage("treasure_hunter") == "stage" and person:get_quest_var("treasure_hunter:hunt") == "running" then
            -- switch on self.id
            local variable
            if (self.zone_id == 615 and self.id == 14) then
                -- singing chain
                local stage = 1
                variable = person:get_has_completed("enchanted_hollow_quest")
            elseif (self.zone_id == 43 and self.id == 19) then
                -- fire ring
                local stage = 2
                variable = person:get_quest_var("theatre:fire_ring")
            elseif (self.zone_id == 161 and self.id == 3) then
                -- sandstone ring
                local stage = 3
                variable = person:get_quest_var("desert_quest:scorpion")
            elseif (self.zone_id == 502 and self.id == 15) then
                -- electrum hoop
                local stage = 4
                variable = person:get_has_completed("bayou_quest")
            elseif (self.zone_id == 481 and self.id == 1) then
                -- rainbow shell
                local stage = 5
                variable = person:get_quest_var("fieryisle_quest:shell")
            elseif (self.zone_id == 160 and self.id == 9) then
                -- stormshield
                local stage = 6
                if person:get_quest_var("mystwatch_quest:step") == "complete" then
                    variable = 1
                end
            elseif (self.zone_id == 550 and self.id == 8) then
                -- snow leopard cloak
                local stage = 7
                variable = person:get_quest_var("tech_mysteries_quest:cloak")
            elseif (self.zone_id == 490 and self.id == 41) then
                -- rope ladder
                local stage = 8
                variable = person:get_quest_var("griffin_quest:ladder")
            elseif (self.zone_id == 584 and self.id == 1) then
                -- phoenix feather
                local stage = 9
                variable = person:get_quest_var("kod_quest:feather")
            elseif (self.zone_id == 534 and self.id == 100) or (self.zone_id == 534 and self.id == 101) or (self.zone_id == 534 and self.id == 105) or (self.zone_id == 534 and self.id == 106) then
                -- sleet armor
                local stage = 10
                variable = person:get_quest_var("frost_valley_quest:elf")
            end
            if variable then
                person:set_quest_var("treasure_hunter", "hunt", "found")
                person:send("<b:yellow>You have found the treasure!</>")
            end
        end
    elseif person and person.is_player then
        i = i + 1
    end
    a = a + 1
end$trig$, 'da6d2170e17a02bf40738d69dd41258f'),
  -- data/triggers/053/053_32_treasure_hunter_object_give.lua
  (53, 32, $trig$-- Converted from DG Script #5332: Treasure Hunter object give
-- Original: OBJECT trigger, flags: GIVE, probability: 100%
-- switch on self.id
if (self.zone_id == 615 and self.id == 14) then
    -- singing chain
    local stage = 1
elseif (self.zone_id == 43 and self.id == 19) then
    -- fire ring
    local stage = 2
elseif (self.zone_id == 161 and self.id == 3) then
    -- sandstone ring
    local stage = 3
elseif (self.zone_id == 502 and self.id == 15) then
    -- electrum hoop
    local stage = 4
elseif (self.zone_id == 481 and self.id == 1) then
    -- rainbow shell
    local stage = 5
elseif (self.zone_id == 160 and self.id == 9) then
    -- stormshield
    local stage = 6
elseif (self.zone_id == 550 and self.id == 8) then
    -- snow leopard cloak
    local stage = 7
elseif (self.zone_id == 490 and self.id == 41) then
    -- rope ladder
    local stage = 8
elseif (self.zone_id == 584 and self.id == 1) then
    -- phoenix feather
    local stage = 9
elseif (self.zone_id == 534 and self.id == 100) or (self.zone_id == 534 and self.id == 101) or (self.zone_id == 534 and self.id == 105) or (self.zone_id == 534 and self.id == 106) then
    -- sleet armor
    local stage = 10
end
local person = victim
local i = person.group_size
local a
if i then
    a = 1
else
    a = 0
end
while i >= a do
    person = person.group_member[a]
    if person.room == self.room then
        if person:get_quest_stage("treasure_hunter") == "stage" and person:get_quest_var("treasure_hunter:hunt") == "running" then
            -- switch on self.id
            local variable
            if (self.zone_id == 615 and self.id == 14) then
                -- singing chain
                local stage = 1
                variable = person:get_has_completed("enchanted_hollow_quest")
            elseif (self.zone_id == 43 and self.id == 19) then
                -- fire ring
                local stage = 2
                variable = person:get_quest_var("theatre:fire_ring")
            elseif (self.zone_id == 161 and self.id == 3) then
                -- sandstone ring
                local stage = 3
                variable = person:get_quest_var("desert_quest:scorpion")
            elseif (self.zone_id == 502 and self.id == 15) then
                -- electrum hoop
                local stage = 4
                variable = person:get_has_completed("bayou_quest")
            elseif (self.zone_id == 481 and self.id == 1) then
                -- rainbow shell
                local stage = 5
                variable = person:get_quest_var("fieryisle_quest:shell")
            elseif (self.zone_id == 160 and self.id == 9) then
                -- stormshield
                local stage = 6
                if person:get_quest_var("mystwatch_quest:step") == "complete" then
                    variable = 1
                end
            elseif (self.zone_id == 550 and self.id == 8) then
                -- snow leopard cloak
                local stage = 7
                variable = person:get_quest_var("tech_mysteries_quest:cloak")
            elseif (self.zone_id == 490 and self.id == 41) then
                -- rope ladder
                local stage = 8
                variable = person:get_quest_var("griffin_quest:ladder")
            elseif (self.zone_id == 584 and self.id == 1) then
                -- phoenix feather
                local stage = 9
                variable = person:get_quest_var("kod_quest:feather")
            elseif (self.zone_id == 534 and self.id == 100) or (self.zone_id == 534 and self.id == 101) or (self.zone_id == 534 and self.id == 105) or (self.zone_id == 534 and self.id == 106) then
                -- sleet armor
                local stage = 10
                variable = person:get_quest_var("frost_valley_quest:elf")
            end
            if variable then
                person:set_quest_var("treasure_hunter", "hunt", "found")
                person:send("<b:yellow>You have found the treasure!</>")
            end
        end
    elseif person and person.is_player then
        i = i + 1
    end
    a = a + 1
end$trig$, '7a99c63c6759278674f91dc91a2a6824'),
  -- data/triggers/053/053_38_elemental_chaos_hakujo_mission_receive.lua
  (53, 38, $trig$-- Converted from DG Script #5338: Elemental Chaos Hakujo mission receive
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
-- switch on object.id
-- mission targets here
local stage, target1
if (object.zone_id == 53 and object.id == 20) then
    stage = 1
    target1 = "an imp"
elseif (object.zone_id == 53 and object.id == 21) then
    stage = 2
    target1 = "the Leading Player"
elseif (object.zone_id == 53 and object.id == 22) then
    stage = 3
    target1 = "the Chaos"
elseif (object.zone_id == 53 and object.id == 23) then
    stage = 4
    target1 = "whatever waits at the end of the shaman's vision quest"
elseif (object.zone_id == 53 and object.id == 24) then
    stage = 5
    target1 = "the Fangs of Yeenoghu"
elseif (object.zone_id == 53 and object.id == 25) then
    stage = 6
    target1 = "the fire elemental lord"
elseif (object.zone_id == 53 and object.id == 26) then
    stage = 7
    target1 = "an acolyte of Betrayal"
elseif (object.zone_id == 53 and object.id == 27) then
    stage = 8
    target1 = "for Cyprianum the Reaper"
elseif (object.zone_id == 53 and object.id == 28) then
    stage = 9
    target1 = "a Chaos Demon"
elseif (object.zone_id == 53 and object.id == 29) then
    stage = 10
    target1 = "the Norhamen"
end
if actor:get_quest_stage("elemental_chaos") == "stage" and actor:get_quest_var("elemental_chaos:bounty") == "dead" then
    local anti = "Anti-Paladin"
    wait(0.2)
    world.destroy(object)
    self:command("bow")
    actor:send(tostring(self.name) .. " says, 'Harmony follows your actions.'")
    local money = stage * 10
    self:command("give " .. tostring(money) .. " platinum " .. tostring(actor))
    local expcap
    if stage == 1 then
        expcap = 5
    else
        local bonus = (stage - 1) * 10
        expcap = bonus
    end
    local expmod
    if expcap < 9 then
        expmod = (((expcap * expcap) + expcap) / 2) * 55
    elseif expcap < 17 then
        expmod = 440 + ((expcap - 8) * 125)
    elseif expcap < 25 then
        expmod = 1440 + ((expcap - 16) * 175)
    elseif expcap < 34 then
        expmod = 2840 + ((expcap - 24) * 225)
    elseif expcap < 49 then
        expmod = 4640 + ((expcap - 32) * 250)
    elseif expcap < 90 then
        expmod = 8640 + ((expcap - 48) * 300)
    else
        expmod = 20940 + ((expcap - 89) * 600)
    end
    -- switch on actor.class
    if actor.class == "warrior" or actor.class == "berserker" then
        expmod = (expmod + (expmod / 10))
    elseif actor.class == "paladin" or actor.class == "anti-paladin" or actor.class == "ranger" then
        expmod = (expmod + ((expmod * 2) / 15))
    elseif actor.class == "sorcerer" or actor.class == "pyromancer" or actor.class == "cryomancer" or actor.class == "illusionist" or actor.class == "bard" then
        expmod = (expmod + (expmod / 5))
    elseif actor.class == "necromancer" or actor.class == "monk" then
        expmod = (expmod + (expmod * 2) / 5)
    else
        expmod = expmod
    end
    actor:send("<b:yellow>You gain experience!</>")
    local setexp = (expmod * 10)
    local loop = 0
    while loop < 3 do
        actor:award_exp(setexp)
        loop = loop + 1
    end
    actor:set_quest_var("elemental_chaos", "target1", 0)
    actor:set_quest_var("elemental_chaos", "bounty", 0)
    wait(0.2)
    if stage < 10 then
        actor:advance_quest("elemental_chaos")
        actor:send(tostring(self.name) .. " says, 'I will investigate further.  Return later and I shall tell you my findings.'")
    else
        actor:complete_quest("elemental_chaos")
        actor:send(tostring(self.name) .. " says, 'You have done Balance a great service.'")
        wait(1)
        actor:send(tostring(self.name) .. " says, 'May this ring ever remind you to ever walk the Way.'")
        self.room:spawn_object(123, 106)
        self:command("give ring " .. tostring(actor))
    end
    if string.find(actor.class, "monk") and actor:get_quest_stage("monk_vision") == 0 then
        wait(2)
        actor:send(tostring(self.name) .. " says, 'You are ready to begin your own path to <b:cyan>[Enlightenment]</>.'")
        self.room:spawn_object(2, 190)
        self:command("give vision " .. tostring(actor))
        wait(1)
        actor:send(tostring(self.name) .. " says, 'These markings represent your voyage.'")
        actor:start_quest("monk_vision")
        wait(2)
        if actor.level < 10 then
            actor:send(tostring(self.name) .. " says, 'Come back with that vision after you reach level 10.  We can discuss your voyage toward enlightenment then.'")
        end
    end
elseif actor:get_quest_stage("elemental_chaos") > stage then
    _return_value = true
    self:command("shake")
    self.room:send(tostring(self.name) .. " refuses the mission.")
    wait(0.2)
    actor:send(tostring(self.name) .. " says, 'You already accomplished this!'")
elseif actor:get_quest_stage("elemental_chaos") < stage then
    wait(0.2)
    self:command("eye " .. tostring(actor))
    actor:send(tostring(self.name) .. " says, 'How'd you get this?!  You steal it off someone else??'")
    self.room:send(tostring(self.name) .. " rips up the mission!")
    world.destroy(object)
elseif actor:get_quest_var("elemental_chaos:bounty") == "running" then
    _return_value = true
    self.room:send(tostring(self.name) .. " refuses the mission.")
    wait(0.2)
    actor:send(tostring(self.name) .. " says, 'You have to complete your mission first!")
    if stage == 5 then
        actor:send(tostring(target1) .. " are still out there.'")
    else
        actor:send(tostring(target1) .. " is still out there.'")
    end
end
return _return_value$trig$, '0c54db7878bcbe0fe13bf66ae7ab24f3'),
  -- data/triggers/188/188_70_smart_combat.lua
  (188, 70, $trig$local now = timestamp()
local level = self.level
local class = self.class
local flags = self.flags
-- DG #18870 tested %outside% and %outdoors% without ever setting them (always empty/false).
-- Both mean "this room is outdoors" (call lightning, earthquake, sunray).
local outdoors = self.room:is_outdoor()
local is_sor = class == "sorcerer"
local is_cry = class == "cryomancer"
local is_pyr = class == "pyromancer"
local is_nec = class == "necromancer"
local is_arc = is_sor  or  is_cry  or  is_pyr  or  is_nec
local is_war = class == "warrior"
local is_ran = class == "ranger"
local is_pal = class == "paladin"
local is_ant = class ~= nil and string.find(tostring(class), "anti") ~= nil
local is_mon = class == "monk"
local is_com = is_ran  or  is_pal  or  is_ant
local is_fig = is_war  or  is_mon  or  is_com
local is_rog = class == "rogue"
local is_thi = class == "thief"
local is_ass = class == "assassin"
local is_mer = class == "mercenary"
local is_bac = is_rog  or  is_thi  or  is_ass  or  is_mer
local is_cle = class == "cleric"
local is_pri = class == "priest"
local is_dia = class == "diabolist"
local is_dru = class == "druid"
local is_div = is_cle  or  is_pri  or  is_dia  or  is_dru
local is_mag = is_arc  or  is_div  or  is_com
local cir_2 = level >= 9
local cir_3 = level >= 17
local cir_4 = level >= 25
local cir_5 = level >= 33
local cir_6 = level >= 41
local cir_7 = level >= 49
local cir_8 = level >= 57
local cir_9 = level >= 65
local cir_10 = level >= 73
local cir_11 = level >= 81
local cir_12 = level >= 89
local cir_13 = level >= 97
wait(1)
local mode = random(1, 10)
-- Do fighter/rogue type stuff
if is_fig or is_bac then
    if (mode < 4) and ((is_ran and (level > 34)) or (is_war and (level > 14)) or ((is_ant or is_pal) and (level > 9))) then
        local max_tries = 5
        local attempted
        while max_tries > 0 do
            local victim = self.room.actors[random(1, #self.room.actors)]
            if victim and (victim.is_npc) and (victim.class ~= "warrior") and (victim.class ~= "ranger") and (not (string.find(victim.class, "anti"))) and (victim.class ~= "paladin") and (victim.class ~= "monk") then
                combat.rescue(self, victim.name)
                attempted = 1
            end
            max_tries = max_tries - 1
        end
        if attempted then
            return true
        end
    end
    if (is_war or is_ran or is_pal or is_ant or is_mer) and (level - actor.level >= 0) and (self:get_worn("11") ~= -1) then
        skills.execute(self, "bash", self.fighting)
    elseif (is_ass or is_thi or (is_rog and (level > 9)) or (is_mer and (level > 10))) and (self:get_worn("16") ~= -1) then
        skills.execute(self, "backstab", self.fighting)
    elseif (is_war and (level > 49)) or ((is_pal or is_ant) and (level > 79)) then
        self:attack_all()
    elseif ((is_war or is_ran or is_pal or is_ant or is_mon or is_mer) and (level >= 1)) or (is_ass and (level >= 36)) then
        skills.execute(self, "kick", self.fighting)
    end
    return true
end
-- Initialize chance to do support spells (per-mob persistent)
if not globals.defensive then
    globals.defensive = 5
end
local defensive = globals.defensive
-- Per-mob spell cooldown timestamps (default to far past so first cast fires)
local barkskin = globals.barkskin or -9999
local armor = globals.armor or -9999
local demonskin = globals.demonskin or -9999
local demonic = globals.demonic or -9999
local mirage = globals.mirage or -9999
-- Attempt to cast support spells
if mode <= defensive then
    -- TODO(parity): the `not (flags ~= "HASTE")` guards below mean "the mob is
    -- already affected by HASTE" (i.e. don't recast). Re-derive once the
    -- runtime exposes a real affect-bitvector check.
    if ((is_nec and cir_7) or (is_arc and (not is_nec) and cir_6)) and (not (flags ~= "HASTE")) then
        spells.cast(self, "haste")
    elseif ((is_nec and cir_12) or (is_arc and (not is_nec) and cir_6)) and (not (flags ~= "STONE")) then
        spells.cast(self, "stone skin")
    elseif ((is_ran and cir_3) or is_dru) and (barkskin + 6 + (level / 10) < now) then
        spells.cast(self, "barkskin")
        globals.barkskin = now
    elseif (is_cle or (is_pal and cir_2) or is_pri) and (armor + 10 < now) then
        spells.cast(self, "armor")
        globals.armor = now
    elseif (is_dia or (is_ant and cir_2)) and (demonskin + 10 + (level / 40) < now) then
        spells.cast(self, "demonskin")
        globals.demonskin = now
    elseif is_dia and cir_4 and (demonic + 11 < now) then
        spells.cast(self, "demonic aspect")
        globals.demonic = now
    elseif is_pyr and cir_4 and (mirage + 10 < now) then
        spells.cast(self, "mirage")
        globals.mirage = now
    else
        mode = 6  -- fall through to offensive branch
    end
end
if mode > 5 then
    if (is_sor or is_cry) and cir_8 then
        spells.cast(self, "chain lightning")
    elseif is_pyr and cir_6 then
        spells.cast(self, "firestorm")
    elseif (is_sor or is_cry) and cir_6 then
        spells.cast(self, "ice storm")
    elseif (self.alignment > 350) and ((is_cle and cir_6) or (is_pri and cir_9) or (is_pal and cir_10)) then
        spells.cast(self, "holy word")
    elseif (self.alignment < -350) and ((is_cle and cir_6) or (is_dia and cir_9) or (is_ant and cir_11)) then
        spells.cast(self, "unholy word")
    elseif is_sor and cir_9 and mode <= 2 then
        spells.cast(self, "disintegrate")
        -- elseif is_cry% && %cir_9%
        -- cast 'iceball'
        -- elseif is_pyr% && %cir_9%
        -- cast 'immolate'
    elseif is_dru and cir_9 and ((not (string.find(actor.flags, "BLIND"))) or not outdoors) then
        spells.cast(self, "sunray")
    elseif is_sor and cir_7 then
        spells.cast(self, "bigbys clenched fist")
    elseif outdoors and is_dru and cir_7 then
        spells.cast(self, "call lightning")
    elseif (is_cle and cir_7) or ((is_pri or is_dia) and cir_10) then
        spells.cast(self, "full harm")
    elseif is_arc and (not is_nec) and cir_4 and (not (string.find(actor.flags, "ENFEEB"))) then
        spells.cast(self, "ray of enfeeblement")
    elseif outdoors and ((is_dru and cir_4) or (is_div and (not is_dru) and cir_5)) then
        spells.cast(self, "earthquake")
    elseif is_pyr and cir_7 and mode <= 2 then
        spells.cast(self, "melt")
    elseif is_dia and cir_7 and (not (string.find(actor.flags, "INSANITY"))) then
        spells.cast(self, "insanity")
    elseif is_pri and cir_6 and (actor.alignment < 350) then
        spells.cast(self, "divine ray")
    elseif is_dia and cir_6 then
        spells.cast(self, "stygian eruption")
    elseif is_nec and cir_5 then
        spells.cast(self, "energy drain")
    elseif (is_sor or is_cry) and cir_5 then
        spells.cast(self, "cone of cold")
    elseif (is_cle or is_dru) and cir_5 then
        spells.cast(self, "harm")
    elseif is_pyr and cir_5 then
        spells.cast(self, "heatwave")
    elseif (is_cle or is_pri) and cir_4 and (actor.alignment <= 350) then
        spells.cast(self, "dispel evil")
    elseif (is_cle or is_dia) and cir_4 and (actor.alignment >= 350) then
        spells.cast(self, "dispel good")
    elseif ((is_div and (not is_dru) and cir_4) or (is_ant and cir_6)) and (not (string.find(actor.flags, "BLIND"))) then
        spells.cast(self, "blindness")
    elseif (is_sor and cir_6) or (is_pyr and cir_4) then
        spells.cast(self, "fireball")
    elseif is_cle and cir_4 and (self.alignment >= 350) then
        spells.cast(self, "flamestrike")
    elseif (is_arc and (not is_pyr) and cir_4) or (is_dru and cir_6) then
        spells.cast(self, "lightning bolt")
    elseif is_pri and cir_3 and (self.alignment >= 350) and (actor.alignment < 350) then
        spells.cast(self, "divine bolt")
    elseif is_dia and cir_3 and (actor.alignment > 350) then
        spells.cast(self, "hell bolt")
    elseif is_div and (not is_dru) and cir_3 then
        spells.cast(self, "cause critical")
    elseif is_arc and (not is_pyr) and cir_3 then
        spells.cast(self, "shocking grasp")
    elseif is_pyr and cir_3 and (not (string.find(actor.flags, "BLIND"))) then
        spells.cast(self, "smoke")
    elseif is_dru and cir_3 then
        spells.cast(self, "writhing weeds")
    elseif is_div and (not is_dru) and cir_2 then
        spells.cast(self, "cause serious")
    elseif is_arc and (not is_pyr) and cir_2 then
        spells.cast(self, "chill touch")
    elseif is_pyr and cir_2 then
        spells.cast(self, "fire darts")
    elseif is_pyr then
        spells.cast(self, "burning hands")
    elseif is_cry then
        spells.cast(self, "ice darts")
    elseif is_arc then
        spells.cast(self, "magic missile")
    elseif is_div and not is_dru then
        spells.cast(self, "cause light")
    end
end
globals.action = now$trig$, '5d298699a2151cfb97dc0d1d33b9e1d7')
) AS v(zone_id, id, commands, old_md5)
WHERE t.zone_id = v.zone_id
  AND t.id = v.id
  AND md5(t.commands) = v.old_md5
  AND t.commands IS DISTINCT FROM v.commands;

COMMIT;
