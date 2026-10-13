-- Soak round 2: 30:163/30:164 Julk fight triggers indexed a boolean (is_fighting); 625:71 same; 520:1 indexed has_equipped boolean; has_equipped/has_item legacy string vnums and nil ids fixed to (zone, id) across 20 scripts.
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
  -- data/triggers/002/002_100_phase_wand_bigby_research_assistant_greet.lua
  (2, 100, $trig$if self:has_effect(Effect.Invisible) then
    self:command("vis")
end
wait(2)
local air = actor:get_quest_stage("air_wand") or 0
local fire = actor:get_quest_stage("fire_wand") or 0
local ice = actor:get_quest_stage("ice_wand") or 0
local acid = actor:get_quest_stage("acid_wand") or 0
local airgreet = actor:get_quest_var("air_wand:greet")
local firegreet = actor:get_quest_var("fire_wand:greet")
local icegreet = actor:get_quest_var("ice_wand:greet")
local acidgreet = actor:get_quest_var("acid_wand:greet")
if air > 2 or fire > 2 or ice > 2 or acid > 2 or airgreet or firegreet or icegreet or acidgreet then
    self:say("Ah, welcome back " .. tostring(actor.name) .. "!")
    wait(2)
end
local class = actor.class or ""
if not (string.find(class, "sorcerer") or string.find(class, "pyromancer")
        or string.find(class, "cryomancer") or string.find(class, "illusionist")
        or string.find(class, "necromancer")) then
    return
end
if actor.level < 10 then return end

local offer, continue = false, false
local function check(stage, q, wand_zone, wand_id)
    if (actor:has_equipped(wand_zone, wand_id) or actor:has_item(wand_zone, wand_id)) and stage < 2 then
        if stage == 0 then
            actor:start_quest(q)
        end
        actor:set_quest_var(q, "greet", 1)
        offer = true
    elseif stage == 2 then
        continue = true
    end
end
check(air, "air_wand", 2, 100)
check(fire, "fire_wand", 2, 110)
check(ice, "ice_wand", 2, 120)
check(acid, "acid_wand", 2, 130)

if continue then
    self:say("Have you been practicing and looking for the gems you need?")
    wait(2)
end
if offer then
    self.room:send(tostring(self.name) .. " says, 'I see you have a new elemental wand!  I can <b:cyan>upgrade</> basic wands.'")
    wait(2)
end
if air > 2 or fire > 2 or ice > 2 or acid > 2 then
    self.room:send(tostring(self.name) .. " says, 'If you want to upgrade a wand again, I can point you in the right direction.  Just tell me which energy type you want to work on: <green>acid</>, <b:white>air</>, <red>fire</>, or <b:blue>ice</>.'")
end$trig$, 'e0ececf7b40cd6358a26ba26ff29d18e'),
  -- data/triggers/004/004_28_supernova_progress_journal.lua
  (4, 28, $trig$-- Converted from DG Script #428: Supernova progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if string.find(arg, "supernova") or string.find(arg, "nova") then
    if actor.level >= 85 and string.find(actor.class, "pyromancer") then
        _return_value = true
        local stage = actor:get_quest_stage("supernova")
        actor:send("<b:green>&uSupernova</>")
        actor:send("Minimum Level: 89")
        local status
        if actor:get_has_completed("supernova") then
            status = "Completed!"
        elseif (stage or 0) > 0 then
            status = "In Progress"
        else
            status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
        if stage > 0 and not actor:get_has_completed("supernova") then
            actor:send("Quest Master: the pyromancer guildmasters")
            actor:send("</>")
            actor:send("Your task is to:")
            -- switch on stage
            if stage == 1 then
                actor:send("Find one of Phayla's lamps.")
            elseif stage == 2 then
                actor:send("Return to a pyromancer guildmaster with Phayla's lamp and ask about Supernova.")
            elseif stage == 3 then
                actor:send("Find clues to Phayla's whereabouts.")
                actor:send("</>")
                actor:send("She likes to visit the material plane to engage in her favorite leisure activities.")
                local clue = actor:get_quest_var("supernova:step3")
                -- switch on clue
                if clue == 4318 then
                    actor:send("Recently, she was spotted in Anduin, taking in a show from the best seat in the house.")
                elseif clue == 10316 then
                    actor:send("I understand she frequents the hottest spring at the popular resort up north.")
                elseif clue == 58062 then
                    actor:send("She occasionally visits a small remote island theatre, where she enjoys meditating in their reflecting room.")
                end
                actor:send("Find further clues to Phayla's whereabouts.")
                actor:send("</>")
                -- switch on actor:get_quest_var("supernova:step4")
                local clue2
                if actor:get_quest_var("supernova:step4") == 18577 then
                    clue2 = "I continue my journey where the sun rises amidst a sea of swirling worlds."
                    -- The Abbey, the rising sun room
                elseif actor:get_quest_var("supernova:step4") == 17277 then
                    clue2 = "Atop a tower I visit a master who waits to give his final examination."
                    -- Citadel of Testing
                elseif actor:get_quest_var("supernova:step4") == 8561 then
                    clue2 = "I study in a secret place above a hall of misery beyond a gallery of horrors."
                    -- Cathedral of Betrayal near Norisent
                end
                -- end clue2 switch
                actor:send("Find yet another clue to Phayla's whereabouts.")
                actor:send("</>")
                -- switch on actor:get_quest_var("supernova:step5")
                local clue3
                if actor:get_quest_var("supernova:step5") == 53219 then
                    clue3 = "Where DID the lizard men get that throne from?  I'll see if I can find out."
                    -- Lizard King's throne room, Sunken
                elseif actor:get_quest_var("supernova:step5") == 47343 then
                    clue3 = "They often wonder what would happen if bones could talk.  I'll ask one who can make that happen!"
                    -- Kryzanthor, Graveyard
                elseif actor:get_quest_var("supernova:step5") == 16278 then
                    clue3 = "Waves of sand hold the remains of a child of the Sun God.  Supposedly.  I'll have to see for myself."
                    -- Imanhotep, Pyramid
                end
                -- end clue3 switch
                actor:send("Solve the riddle to deduce the location of the gateway to Phayla's realm.")
                actor:send("</>")
                local step7 = actor:get_quest_var("supernova:step7")
                -- switch on actor:get_quest_var("supernova:step6")
                if actor:get_quest_var("supernova:step6") == 58657 then
                    -- A Hummock of Grass in the Beachhead
                    local clue4
                    if step7 == 1 then
                        clue4 = "s pfqzqgc wq kecwk qy xug fwinlugev"
                    elseif step7 == 2 then
                        clue4 = "d hlwzsuc rf xbnwk aq tyo oisukhvkq"
                    elseif step7 == 3 then
                        clue4 = "s oidfgjy fy yyojl au hyx tlotazlou"
                    end
                elseif actor:get_quest_var("supernova:step6") == 35119 then
                    -- A Pile of Stones in the Brush Lands
                    local clue4
                    if step7 == 1 then
                        clue4 = "s xtpr qj kbzrru mf bsi otykp weafw"
                    elseif step7 == 2 then
                        clue4 = "d pzvr sx kwoeof mf lke sbhwz ddnuc"
                    elseif step7 == 3 then
                        clue4 = "s wwcx gm gkhflg zg los skmzv ctfkg"
                    end
                elseif actor:get_quest_var("supernova:step6") == 55422 then
                    -- The Trail Overlooking the Falls in the dark mountains
                    local clue4
                    if step7 == 1 then
                        clue4 = "lpp xecmd wgiensgstrt vlw nlpyu mf bsi qcvc uzyaveavd"
                    elseif step7 == 2 then
                        clue4 = "whv deead ovvbysgclnx dui xsolj sa xzw gaiu zsmfwazxf"
                    elseif step7 == 3 then
                        clue4 = "los kkspz fowyzfhcpbx mzl tredz we mzl rrkc tclglhwel"
                    end
                end
                -- end clue4 switch
                -- switch on step7
                local clue5
                if step7 == 1 then
                    clue5 = "What disappears as soon as you say its name?"
                    -- Answer: Silence
                elseif step7 == 2 then
                    clue5 = "The more there is, the less you see. What am I?"
                    -- Answer: Darkness
                elseif step7 == 3 then
                    clue5 = "What word becomes shorter when you add two to it?"
                    -- Answer: Short
                end
                -- end clue 5 switch
                actor:send("Talk to Phayla.")
            elseif stage > 3 then
                if actor:has_item(489, 17) or actor:has_equipped(489, 17) then
                    if stage == 4 then
                        actor:send("Learning is a life-long process.")
                        actor:send(tostring(clue2))
                    elseif stage == 5 then
                        actor:send("History is so fascinating!")
                        actor:send(tostring(clue3))
                    elseif stage == 6 then
                        actor:send("I know you're following me.  Answer this:")
                        actor:send("\"" .. tostring(clue5) .. "\"")
                        actor:send("With the answer you can find the gate to my home here:")
                        actor:send(tostring(clue4))
                        actor:send("</>")
                        actor:send("You will need additional solar energy to power the gate.")
                        actor:send("Hidden in the dimensional folds around Nordus is an appropriate source.")
                    end
                else
                    actor:send("Your notes are a jumble of unintelligible squiggles.")
                    actor:send("You must have " .. tostring(objects.template(489, 17).name) .. " to read them!")
                end
            end
        end
    end
end  -- auto-close block
return _return_value$trig$, '2056fc7a42ddea453f3060bc044a790b'),
  -- data/triggers/028/028_05_waterform_water_death.lua
  (28, 5, $trig$local function region_for(zone, local_id)
    if zone == 28 and (local_id == 5 or local_id == 8 or local_id == 9) then
        return 1
    elseif zone == 118 and local_id == 5 then
        return 1
    elseif zone == 510 and (local_id == 1 or local_id == 19 or local_id == 21) then
        return 2
    elseif zone == 40 and local_id == 2 then
        return 3
    elseif zone == 530 and local_id == 4 then
        return 5
    elseif zone == 486 and local_id == 31 then
        return nil  -- excluded
    else
        return 4
    end
end

local function maybe_credit(person)
    if person.room ~= self.room then
        return
    end
    if person:get_quest_stage("waterform") ~= 4 then
        return
    end
    -- Must have the dragon bone cup (28:8) in inventory or equipped.
    if not (person:has_item(28, 8) or person:has_equipped(28, 8)) then
        return
    end
    local number = region_for(self.zone_id, self.local_id)
    if not number then
        return
    end
    local region_key = "region" .. tostring(number)
    if not person:get_quest_var("waterform:" .. region_key) then
        person:set_quest_var("waterform", region_key, 1)
        person:send("<b:blue>You gather part of " .. tostring(self.name) ..
            " in " .. tostring(objects.template(28, 8).name) .. ".</>")
        self.room:send_except(person, "<b:blue>" .. tostring(person.name) ..
            " gathers part of " .. tostring(self.name) ..
            " in " .. tostring(objects.template(28, 8).name) .. ".</>")
    end
    local total = 0
    for r = 1, 5 do
        if person:get_quest_var("waterform:region" .. tostring(r)) then
            total = total + 1
        end
    end
    if total > 3 then
        person:send("<b:blue>You have gathered all the samples of living water you need!</>")
        person:advance_quest("waterform")
    end
end

if actor.group then
    for _, member in ipairs(actor.group) do
        maybe_credit(member)
    end
else
    maybe_credit(actor)
end$trig$, '2c718b066a1a54c909f49d55cb4b9eef'),
  -- data/triggers/028/028_06_waterform_waters_examine.lua
  (28, 6, $trig$if actor:get_quest_stage("waterform") == 6
   and (actor:has_equipped(28, 8) or actor:has_item(28, 8)) then
    if actor:get_quest_var("waterform:" .. tostring(self.zone_id) .. "_" .. tostring(self.local_id)) then
        wait(1)
        actor:send("<b:blue>You have already examined this source.</>")
        return true
    else
        wait(1)
        actor:send("<b:blue>You gather some water from " .. tostring(self.shortdesc) .. " in " .. tostring(objects.template(28, 8).name) .. ".</>")
        actor:set_quest_var("waterform", (tostring(self.zone_id) .. "_" .. tostring(self.local_id)), 1)
        self.room:send_except(actor, "<blue>" .. tostring(actor.name) .. " gathers some water from " .. tostring(self.shortdesc) .. " in " .. tostring(objects.template(28, 8).name) .. ".</>")
    end
    -- Composite IDs: 32:96 Mielikki granite pool, 584:5 King of Dreams artesian
    -- well, 533:19 Ice Cult fountain, 558:4 Eldorian creek, 587:1 Dancing Dolphin
    -- wishing well, 370:14 Minithawkin underground brook.
    local water1 = actor:get_quest_var("waterform:32_96")
    local water2 = actor:get_quest_var("waterform:584_5")
    local water3 = actor:get_quest_var("waterform:533_19")
    local water4 = actor:get_quest_var("waterform:558_4")
    local water5 = actor:get_quest_var("waterform:587_1")
    local water6 = actor:get_quest_var("waterform:370_14")
    if water1 and water2 and water3 and water4 and water5 and water6 then
        actor:advance_quest("waterform")
        actor:send("<b:blue>Your examinations of the water sources are complete!</>")
    end
end$trig$, '659222030f952913a6581d566f1c20cb'),
  -- data/triggers/028/028_08_unused.lua
  (28, 8, $trig$local _return_value = true  -- Default: allow action
local i = actor.group_size
if i then
    while i > 0 do
        local person = actor.group_member[i]
        if person.room == self.room then
            if person:get_quest_stage("waterform") == 4 and (person:has_item(28, 8) or person:has_equipped(28, 8)) then
                -- switch on self.id
                if (self.zone_id == 28 and self.id == 5) or (self.zone_id == 28 and self.id == 8) or (self.zone_id == 28 and self.id == 9) or (self.zone_id == 117 and self.id == 105) then
                    local number = 1
                elseif (self.zone_id == 510 and self.id == 1) or (self.zone_id == 510 and self.id == 19) or (self.zone_id == 510 and self.id == 21) then
                    local number = 2
                elseif (self.zone_id == 40 and self.id == 2) then
                    local number = 3
                elseif (self.zone_id == 484 and self.id == 231) then
                    local number = 4
                elseif (self.zone_id == 530 and self.id == 4) then
                    local number = 5
                else
                    _return_value = true
                end
                if person:get_quest_var("waterform:regionnumber") == 0 then
                    person:set_quest_var("waterform", "region%number%", 1)
                    person:send("<b:blue>You gather part of " .. tostring(self.name) .. " in " .. tostring(objects.template(28, 8).name) .. ".</>")
                    self.room:send_except(person, "<b:blue>" .. tostring(person.name) .. " gathers part of " .. tostring(self.name) .. " in " .. tostring(objects.template(28, 8).name) .. ".</>")
                end
                local region1 = person:get_quest_var("waterform:region1")
                local region2 = person:get_quest_var("waterform:region2")
                local region3 = person:get_quest_var("waterform:region3")
                local region4 = person:get_quest_var("waterform:region4")
                local region5 = person:get_quest_var("waterform:region5")
                if region1 + region2 + region3 + region4 + region5 > 3 then
                    person:send("<b:blue>You have gathered all the samples of living water you need!</>")
                    person:advance_quest("waterform")
                end
            end
        end
        i = i - 1
    end
elseif actor:get_quest_stage("waterform") == 4 and (actor:has_item(28, 8) or actor:has_equipped(28, 8)) then
    -- switch on self.id
    if (self.zone_id == 28 and self.id == 5) or (self.zone_id == 28 and self.id == 8) or (self.zone_id == 28 and self.id == 9) or (self.zone_id == 117 and self.id == 105) then
        local number = 1
    elseif (self.zone_id == 510 and self.id == 1) or (self.zone_id == 510 and self.id == 19) or (self.zone_id == 510 and self.id == 21) then
        local number = 2
    elseif (self.zone_id == 40 and self.id == 2) then
        local number = 3
    elseif (self.zone_id == 484 and self.id == 231) then
        local number = 4
    elseif (self.zone_id == 530 and self.id == 4) then
        local number = 5
    else
        _return_value = true
    end
    if actor:get_quest_var("waterform:regionnumber") == 0 then
        actor:set_quest_var("waterform", "region%number%", 1)
        actor:send("<b:blue>You gather part of " .. tostring(self.name) .. " in " .. tostring(objects.template(28, 8).name) .. ".</>")
        self.room:send_except(actor, "<b:blue>" .. tostring(actor.name) .. " gathers part of " .. tostring(self.name) .. " in " .. tostring(objects.template(28, 8).name) .. ".</>")
    end
    local region1 = actor:get_quest_var("waterform:region1")
    local region2 = actor:get_quest_var("waterform:region2")
    local region3 = actor:get_quest_var("waterform:region3")
    local region4 = actor:get_quest_var("waterform:region4")
    local region5 = actor:get_quest_var("waterform:region5")
    if region1 + region2 + region3 + region4 + region5 > 3 then
        actor:send("<b:blue>You have gathered all the samples of living water you need!</>")
        actor:advance_quest("waterform")
    end
end
-- 
-- p3 mini boss death trigger 55599
-- 
-- Death trigger for random gem and armor drops
-- 
-- set a random number to determine if a drop will
-- happen.
-- 
-- Miniboss setup
-- 
local bonus = random(1, 100)
local will_drop = random(1, 100)
-- 4 pieces of armor per sub_phase in phase_3
local what_armor_drop = random(1, 4)
-- 11 classes questing in phase_3
local what_gem_drop = random(1, 11)
-- 
if will_drop <= 30 then
    -- drop nothing and bail
    return _return_value
end
if will_drop <= 70 then
    -- Normal non-bonus drops
    if bonus <= 50 then
        -- drop a gem from the previous wear pos set
        self.room:spawn_object(557, 14 + what_gem_drop)
    elseif bonus >= 51 and bonus <= 90 then
        -- We're in the Normal drops from current wear pos set
        -- drop a gem from the current wear pos set
        self.room:spawn_object(557, 25 + what_gem_drop)
    else
        -- We're in the BONUS ROUND!!
        -- drop a gem from the next wear pos set
        self.room:spawn_object(557, 36 + what_gem_drop)
    end
elseif will_drop >= 71 and will_drop <= 90 then
    -- Normal non-bonus drops
    if bonus <= 50 then
        -- 
        self.room:spawn_object(553, 71 + what_armor_drop)
    elseif bonus >= 51 and bonus <= 90 then
        -- We're in the Normal drops from current wear pos set
        -- drop armor from the current wear pos set
        self.room:spawn_object(553, 75 + what_armor_drop)
    else
        -- We're in the BONUS ROUND!!
        -- drop a piece of armor from next wear pos
        self.room:spawn_object(553, 79 + what_armor_drop)
    end
else
    -- Normal non-bonus drops
    if bonus <= 50 then
        -- drop armor and gem from previous wear pos
        self.room:spawn_object(557, 14 + what_gem_drop)
        self.room:spawn_object(553, 71 + what_armor_drop)
    elseif bonus >= 51 and bonus <= 90 then
        -- We're in the Normal drops from current wear pos set
        -- drop a gem and armor from the current wear pos set
        self.room:spawn_object(553, 75 + what_armor_drop)
        self.room:spawn_object(557, 25 + what_gem_drop)
    else
        -- We're in the BONUS ROUND!!
        -- drop armor and gem from next wear pos
        self.room:spawn_object(557, 36 + what_gem_drop)
        self.room:spawn_object(553, 79 + what_armor_drop)
    end
end
return _return_value$trig$, 'f25cba286669b06230360c36eb340d38'),
  -- data/triggers/030/030_133_random_bells.lua
  (30, 133, $trig$-- Converted from DG Script #3133: Random Bells
-- Original: OBJECT trigger, flags: RANDOM, GET, WEAR, REMOVE, probability: 100%
if actor then
    -- this is a wear trigger
    local myowner = actor
    globals.myowner = globals.myowner or true
    self.room:send_except(myowner, "Bells ring on " .. tostring(myowner.name) .. "'s hat as " .. tostring(myowner.name) .. " moves.")
    myowner:send("The bells on your hat ring as you shift your position.")
else
    -- this is a random trigger
    if myowner then
        if myowner:has_equipped(30, 306) then
            -- the global variable was set (by the wear trigger)
            self.room:send_except(myowner, "Bells ring on " .. tostring(myowner.name) .. "'s hat as " .. tostring(myowner.name) .. " moves.")
            myowner:send("The bells on your hat ring as you shift your position.")
        else
            -- hat not worn, so assume it was removed
            myowner = nil
        end
    end
end$trig$, 'c5456a66642239020847f598f244fa99'),
  -- data/triggers/030/030_163_julks_fight_trigger.lua
  (30, 163, $trig$-- Converted from DG Script #3163: julks fight trigger
-- Original: MOB trigger, flags: FIGHT, probability: 100%
-- FIGHT trigger: `self` is the mob being hit, `actor` is whoever just attacked it.
-- The legacy script read %self.fighting% (the mob's opponent) and %target.fighting%
-- (whom that opponent fights, "tank"). In mud-script `is_fighting` is only a
-- boolean and there is no opponent accessor, so the attacker stands in for the
-- opponent (it just swung at us, so it is fighting us: tank == self) and the
-- skills run with no target, which uses the mob's current opponent.
local mode = random(1, 10)
local target = actor
if target and target.is_fighting then
    if mode > 6 then
        skills.execute(self, "kick", nil)
    else
        skills.execute(self, "bash", nil)
    end
    wait(3)
end$trig$, 'a6f7bc3e3edfbf5534e4ca250b8b32be'),
  -- data/triggers/030/030_164_mrs_julk_fight_trigger.lua
  (30, 164, $trig$-- Converted from DG Script #3164: mrs julk fight trigger
-- Original: MOB trigger, flags: FIGHT, probability: 100%
-- FIGHT trigger: `self` is the mob being hit, `actor` is whoever just attacked it.
-- The legacy script read %self.fighting% (the mob's opponent) and %target.fighting%
-- (whom that opponent fights, "tank"). In mud-script `is_fighting` is only a
-- boolean and there is no opponent accessor, so the attacker stands in for the
-- opponent (it just swung at us, so it is fighting us: tank == self) and the
-- skills run with no target, which uses the mob's current opponent.
local mode = random(1, 10)
local target = actor
if target and target.is_fighting then
    if mode > 6 then
        skills.execute(self, "kick", nil)
    end
    wait(3)
end$trig$, '971209dd2860a65687493d63f2a50d31'),
  -- data/triggers/030/030_25_magistrate_intro.lua
  (30, 25, $trig$-- Converted from DG Script #3025: Magistrate_intro
-- Original: MOB trigger, flags: GREET, probability: 100%
if actor.is_player then
    wait(5)
    actor:send(tostring(self.name) .. " says to you, 'Greetings, " .. tostring(actor.name) .. ".  It is good to see you.  If you would like, I have some <b:cyan>[quests]</> you could give me a hand with.'")
    wait(1)
    if (actor:get_quest_stage("phase_mace") == 1 or (actor:get_quest_stage("phase_mace") == 0 and (actor:has_equipped(2, 140) or actor:has_item(2, 140)))) and not actor:get_quest_var("phase_mace:greet") then
        actor:send(tostring(self.name) .. " says, 'Oh and you've found quite an unusual mace!  I could probably help you <b:cyan>[upgrade]</> it.'")
    elseif actor:get_quest_stage("phase_mace") == 1 and actor:get_quest_var("phase_mace:greet") then
        actor:send(tostring(self.name) .. " says, 'Have you found what I require?'")
    end
end$trig$, '1e8de015553da7977f5a9cd5dd8f9608'),
  -- data/triggers/030/030_31_phase_mace_templar_speech_upgrade.lua
  (30, 31, $trig$-- Converted from DG Script #3031: Phase Mace Templar speech upgrade
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: upgrade upgrades upgrading improvement improvements blessing blessings
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "upgrade") or string.find(string.lower(speech), "upgrades") or string.find(string.lower(speech), "upgrading") or string.find(string.lower(speech), "improvement") or string.find(string.lower(speech), "improvements") or string.find(string.lower(speech), "blessing") or string.find(string.lower(speech), "blessings")) then
    return true  -- No matching keywords
end
wait(2)
if actor.level > 9 then
    if actor:get_quest_stage("phase_mace") == 1 or (actor:get_quest_stage("phase_mace") == 0 and (actor:has_equipped(2, 140) or actor:has_item(2, 140))) then
        if actor:get_quest_stage("phase_mace") == 0 then
            actor:start_quest("phase_mace")
        end
        actor:set_quest_var("phase_mace", "greet", 1)
        actor:send(tostring(self.name) .. " says, 'I could bless your mace against the undead, if I had the proper materials.'")
        actor:send("</>")
        actor:send("Bring me the following:")
        actor:send("- <b:yellow>" .. tostring(objects.template(552, 11).name) .. "</> to use as a model")
        actor:send("- <b:yellow>" .. tostring(objects.template(555, 77).name) .. "</> and")
        actor:send("- <b:yellow>" .. tostring(objects.template(136, 14).name) .. "</> for their protection against malevolent spirits")
        actor:send("- <b:yellow>" .. tostring(objects.template(588, 9).name) .. "</> as a flame to ward against the dark")
        actor:send("</>")
        actor:send("Also attack with " .. tostring(objects.template(2, 140).name) .. " <b:yellow>50</> times to fully bond with it.")
        wait(2)
        actor:send(tostring(self.name) .. " says, 'You can ask about your <b:cyan>[mace progress]</> at any time.'")
    elseif actor:get_has_completed("phase_mace") then
        self:say("There is no weapon greater than the mace of disruption!")
    else
        actor:send(tostring(self.name) .. " says, 'I've already done all I can.  If you want to further improve your mace, you'll have to seek out a different master crafter.'")
        wait(1)
        -- switch on actor:get_quest_stage("phase_mace")
        if actor:get_quest_stage("phase_mace") == 2 then
            actor:send(tostring(self.name) .. " says, 'Someone familiar with the grave will be able to work on this mace.  Seek out the Sexton in the Abbey west of the Village of Mielikki.'")
        elseif actor:get_quest_stage("phase_mace") == 3 then
            actor:send(tostring(self.name) .. " says, 'The Cleric Guild is capable of some miraculous crafting.  Visit the Cleric Guild Master in the Arctic Village of Ickle and talk to High Priest Zalish.  He should be able to help you.'")
        elseif actor:get_quest_stage("phase_mace") == 4 then
            actor:send(tostring(self.name) .. " says, 'Continue with the Cleric Guild Masters.  Check in with the High Priestess in the City of Anduin.'")
        elseif actor:get_quest_stage("phase_mace") == 5 then
            actor:send(tostring(self.name) .. " says, 'Sometimes to battle the dead, we need to use their own dark natures against them.  Few are as knowledgeable about the dark arts as Ziijhan, the Defiler, in the Cathedral of Betrayal.'")
        elseif actor:get_quest_stage("phase_mace") == 6 then
            actor:send(tostring(self.name) .. " says, 'Return again to the Abbey of St. George and seek out Silania.  Her mastry of spiritual matters will be necessary to improve this mace any further.'")
        elseif actor:get_quest_stage("phase_mace") == 7 then
            actor:send(tostring(self.name) .. " says, 'I'm loathe to admit it, but of the few remaining who are capable of improving your weapon, one is a priest of a god most foul.  Find Ruin Wormheart, that most heinous of Blackmourne's servators.'")
        elseif actor:get_quest_stage("phase_mace") == 8 then
            actor:send(tostring(self.name) .. " says, 'The most powerful force in the war against the dead is the sun itself.  Consult with the sun's Oracle in the ancient pyramid near Anduin.'")
        elseif actor:get_quest_stage("phase_mace") == 9 then
            actor:send(tostring(self.name) .. " says, 'With everything prepared, return to the very beginning of your journey.  The High Priestess of Mielikki, the very center of the Cleric Guild, will know what to do.'")
        end
    end
else
    actor:send(tostring(self.name) .. " says, 'Come back after you've gained some more experience.  I can help you then.'")
end$trig$, '1128d006acca7fafcefd04785c422864'),
  -- data/triggers/053/053_42_monk_vision_command_read.lua
  (53, 42, $trig$-- Converted from DG Script #5342: Monk Vision command read
-- Original: OBJECT trigger, flags: COMMAND, probability: 3%

-- Command location mask 3: legacy OCMD_EQUIP=1 (worn), OCMD_INVEN=2 (carried), OCMD_ROOM=4 (floor)
if not (location == "equip" or location == "inventory") then
    return true  -- Not in a location this trigger watches
end

-- Command filter: read
if not (cmd == "read") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
-- switch on cmd
if cmd == "r" or cmd == "re" then
    _return_value = true
    return _return_value
end
local visionstage = actor:get_quest_stage("monk_vision")
-- switch on self.id
local place, hasgem, hasvision
if (self.zone_id == 590 and self.id == 6) then
    place = 4328
    local stage = 1
    if actor:has_item(555, 82) then
        hasgem = 1
    end
    if actor:has_equipped(2, 190) then
        hasvision = 1
    end
elseif (self.zone_id == 185 and self.id == 5) then
    place = 58707
    local stage = 2
    if actor:has_item(555, 91) then
        hasgem = 1
    end
    if actor:has_equipped(2, 191) then
        hasvision = 1
    end
elseif (self.zone_id == 85 and self.id == 1) then
    place = 18597
    local stage = 3
    if actor:has_item(556, 23) then
        hasgem = 1
    end
    if actor:has_equipped(2, 192) then
        hasvision = 1
    end
elseif (self.zone_id == 125 and self.id == 32) then
    place = 58102
    local stage = 4
    if actor:has_item(556, 55) then
        hasgem = 1
    end
    if actor:has_equipped(2, 193) then
        hasvision = 1
    end
elseif (self.zone_id == 162 and self.id == 9) then
    place = 16057
    local stage = 5
    if actor:has_item(556, 65) then
        hasgem = 1
    end
    if actor:has_equipped(2, 194) then
        hasvision = 1
    end
elseif (self.zone_id == 430 and self.id == 13) then
    place = 59054
    local stage = 6
    if actor:has_item(556, 78) then
        hasgem = 1
    end
    if actor:has_equipped(2, 195) then
        hasvision = 1
    end
elseif (self.zone_id == 530 and self.id == 9) then
    place = 49079
    local stage = 7
    if actor:has_item(557, 10) then
        hasgem = 1
    end
    if actor:has_equipped(2, 196) then
        hasvision = 1
    end
elseif (self.zone_id == 584 and self.id == 15) then
    place = 11820
    local stage = 8
    if actor:has_item(557, 22) then
        hasgem = 1
    end
    if actor:has_equipped(2, 197) then
        hasvision = 1
    end
elseif (self.zone_id == 584 and self.id == 12) then
    place = 52075
    local stage = 9
    if actor:has_item(557, 41) then
        hasgem = 1
    end
    if actor:has_equipped(2, 198) then
        hasvision = 1
    end
end
local continue
if place == actor.room and visionstage == "stage" and hasvision and hasgem then
    if actor:get_quest_var("monk_vision:visiontask4") then
        actor:send("<magenta>You have already expanded your mind to its current limits.</>")
        return _return_value
    else
        continue = "yes"
    end
end
if continue == "yes" then
    if actor.is_fighting then
        actor:send("<magenta>You cannot properly focus while fighting!</>")
        return _return_value
    else
        actor:send("<magenta>You begin to read " .. tostring(self.shortdesc) .. "...</>")
        wait(4)
        if actor.is_fighting then
            actor:send("<magenta>You cannot properly focus while fighting!</>")
            return _return_value
        end
        if actor.room ~= "place" then
            actor:send("<magenta>You must be in the proper place to keep reading!</>")
            return _return_value
        end
        local i = 0
        while i < 3 do
            actor:send("<magenta>You continue to read...</>")
            wait(4)
            i = i + 1
            if actor.is_fighting then
                actor:send("<magenta>You cannot properly focus while fighting!</>")
                return _return_value
            end
            if actor.room ~= "place" then
                actor:send("<magenta>You must be in the proper place to keep reading!</>")
                return _return_value
            end
        end
        actor:send("<b:magenta>You feel your awareness broadening!</>")
        actor:set_quest_var("monk_vision", "visiontask4", 1)
    end
else
    _return_value = true
end
return _return_value$trig$, '7f6e5142c88e2b076e690a846dac964f'),
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
local visionstage, level, mark, text1, text2
if (self.zone_id == 18 and self.id == 7) then
    visionstage = 3
    local chantstage = 1
    level = 30
    local place = 3205
    if actor:has_equipped(2, 193) or actor:has_equipped(2, 194) or actor:has_equipped(2, 195) or actor:has_equipped(2, 196) or actor:has_equipped(2, 197) or actor:has_equipped(2, 198) or actor:has_equipped(2, 199) then
        mark = "yes"
    end
    text1 = "&3The power of the earth begins to flow through your fists!&0"
    text2 = "&3You have learned Tremors of Saint Augustine.&0"
    local chant = "tremors of saint augustine"
elseif (self.zone_id == 125 and self.id == 8) then
    visionstage = 4
    local chantstage = 2
    level = 40
    local place = 4752
    if actor:has_equipped(2, 194) or actor:has_equipped(2, 195) or actor:has_equipped(2, 196) or actor:has_equipped(2, 197) or actor:has_equipped(2, 198) or actor:has_equipped(2, 199) then
        mark = "yes"
    end
    text1 = "&4&bThe power of the storm begins to flow through your fists!&0"
    text2 = "&4&bYou have learned Tempest of Saint Augustine.&0"
    local chant = "tempest of saint augustine"
elseif (self.zone_id == 550 and self.id == 3) then
    visionstage = 5
    local chantstage = 3
    level = 50
    local place = 11837
    if actor:has_equipped(2, 195) or actor:has_equipped(2, 196) or actor:has_equipped(2, 197) or actor:has_equipped(2, 198) or actor:has_equipped(2, 199) then
        mark = "yes"
    end
    text1 = "&6&bThe power of ice begins to flow through your fists!&0"
    text2 = "&6&bYou have learned Blizzards of Saint Augustine.&0"
    local chant = "blizzards of saint augustine"
elseif (self.zone_id == 550 and self.id == 4) then
    visionstage = 6
    local chantstage = 4
    level = 60
    local place = 2786
    if actor:has_equipped(2, 196) or actor:has_equipped(2, 197) or actor:has_equipped(2, 198) or actor:has_equipped(2, 199) then
        mark = "yes"
    end
    text1 = "&bReverberating from the walls are the discordant words of power!&0"
    text2 = "&bYou have learned Aria of Dissonance.&0"
    local chant = "aria of dissonance"
elseif (self.zone_id == 490 and self.id == 66) then
    visionstage = 7
    local chantstage = 5
    level = 75
    local place = 16057
    if actor:has_equipped(2, 197) or actor:has_equipped(2, 198) or actor:has_equipped(2, 199) then
        mark = "yes"
    end
    text1 = "&5The roaring of the dead forms into a chant!&0"
    text2 = "&5You have learned Apocalyptic Anthem.&0"
    local chant = "apocalyptic anthem"
elseif (self.zone_id == 238 and self.id == 26) then
    visionstage = 8
    local chantstage = 6
    level = 80
    local place = 5272
    if actor:has_equipped(2, 198) or actor:has_equipped(2, 199) then
        mark = "yes"
    end
    text1 = "&1&bThe power of fire begins to flow through your fists!&0"
    text2 = "&1&bYou have learned Fires of Saint Augustine.&0"
    local chant = "fires of saint augustine"
elseif (self.zone_id == 480 and self.id == 37) then
    visionstage = 9
    local chantstage = 7
    level = 99
    local place = 48913
    if actor:has_equipped(2, 199) then
        mark = "yes"
    end
    text1 = "&9&bThe chant to engender catastrophe echoes from the altar!&0"
    text2 = "&9&bYou have learned Seed of Destruction.&0"
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
return _return_value$trig$, 'f17a2d410f884e76c74dee2acbef7ba5'),
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
    if actor:has_equipped(2, 194) or actor:has_equipped(2, 195) or actor:has_equipped(2, 196) or actor:has_equipped(2, 197) or actor:has_equipped(2, 198) or actor:has_equipped(2, 199) then
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
return _return_value$trig$, '827e7ef02e9cbdc9227758e89765391f'),
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
    if actor:has_equipped(2, 195) or actor:has_equipped(2, 196) or actor:has_equipped(2, 197) or actor:has_equipped(2, 198) or actor:has_equipped(2, 199) then
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
return _return_value$trig$, '5256d0ea7e93d9eb8f71cbe336731af2'),
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
    if actor:has_equipped(2, 196) or actor:has_equipped(2, 197) or actor:has_equipped(2, 198) or actor:has_equipped(2, 199) then
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
return _return_value$trig$, '371694f00e36e08ad0ab7c6206b3cdc8'),
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
    if actor:has_equipped(2, 197) or actor:has_equipped(2, 198) or actor:has_equipped(2, 199) then
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
return _return_value$trig$, '1738078503124c1a2eb1185bb9f5a2a5'),
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
    if actor:has_equipped(2, 198) or actor:has_equipped(2, 199) then
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
return _return_value$trig$, '7c738844efd211a904d4da7c873c8680'),
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
    if actor:has_equipped(2, 199) then
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
return _return_value$trig$, '77f64c7edc211a3110a3b953fcc46276'),
  -- data/triggers/188/188_22_scepter_reform.lua
  (188, 22, $trig$-- Converted from DG Script #18822: scepter_reform
-- Original: OBJECT trigger, flags: GLOBAL, WEAR, probability: 100%
if ((self.zone_id == 188 and self.id == 22) and actor:has_equipped(188, 23)) or ((self.zone_id == 188 and self.id == 23) and actor:has_equipped(188, 22)) then
    wait(1)
    self.room:send_except(actor, tostring(actor.name) .. " places the ruby in the mouth of the scepter's dragon.")
    actor:send("You place the ruby in the mouth of the dragon.")
    self.room:send("The ruby flares, and the scepter begins to glow <red>red</>.")
    wait(1)
    self.room:send_except(actor, tostring(actor.name) .. " yelps as the scepter burns " .. tostring(actor.object) .. ", dropping it!")
    actor:send("The scepter burns you, and you drop it!")
    if (self.zone_id == 188 and self.id == 22) then
        world.destroy(self.room:find_object("ruby-duclia"))
    elseif (self.zone_id == 188 and self.id == 23) then
        world.destroy(self.room:find_object("scepter-duclia"))
    end
    self.room:spawn_object(188, 24)
    world.destroy(self)
end$trig$, '10d6e53652577f79c4df70cac77e2518'),
  -- data/triggers/188/188_81_ctf_flag_get.lua
  (188, 81, $trig$local _return_value = true  -- Default: allow action
-- *** Set entity IDs ****
local referee = 18880
local flag_a = 18882
local flag_b = 18883
local enemy_flag
-- Player is on team A
if actor:has_equipped(188, 80) then
    -- Player is trying to pick up team A's flag
    if self.id ~= "flag_a" then
        enemy_flag = "yes"
    end
    -- Player is on team B
elseif actor.wearing[18881] then
    -- Player is trying to pick up team B's flag
    if self.id ~= "flag_b" then
        enemy_flag = "yes"
    end
end
if enemy_flag == "yes" then
    local hands = 0
    if actor:get_worn("held") then
        hands = 1
    end
    if actor:get_worn("held2") then
        hands = hands + 1
    end
    if actor:get_worn("wield") then
        hands = hands + 1
    end
    if actor:get_worn("wield2") then
        hands = hands + 1
    end
    if actor:get_worn("2hwield") then
        hands = hands + 1
    end
    if actor:get_worn("shield") then
        hands = 2
    end
    if hands < 2 then
        _return_value = false
        wait(1)
        actor:command("hold flag")
    else
        _return_value = true
        actor:send("You must have a free hand to pick up the flag!")
    end
else
    _return_value = true
    actor:send("You can't pick that up!")
end
return _return_value$trig$, '680ba7b734df96ae2d45a665d6122b9c'),
  -- data/triggers/188/188_99_fierytag_bat_shippotori.lua
  (188, 99, $trig$-- Converted from DG Script #18899: fierytag_bat_shippotori
-- Original: OBJECT trigger, flags: COMMAND, probability: 1%

-- Command location mask 1: legacy OCMD_EQUIP=1 (worn), OCMD_INVEN=2 (carried), OCMD_ROOM=4 (floor)
if not (location == "equip") then
    return true  -- Not in a location this trigger watches
end

-- Command filter: tag
if not (cmd == "tag") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
-- switch on cmd
if cmd == "t" or cmd == "ta" then
    _return_value = true
    return _return_value
end
if (arg == "self") or (actor.name == arg.name) then
    actor:send("Now that seems a little pointless, doesn't it?")
elseif actor.room ~= arg.room then
    actor:send("Tag who? They don't seem to be here!")
elseif arg.is_npc then
    actor:send("You can only tag players!")
elseif arg.level > 99 then
    actor:send("You cannot tag immortals!")
elseif arg:has_equipped(188, 99) then
    arg:teleport(get_room(0, 0))
    self.room:send_except(actor, tostring(actor.name) .. " tags " .. tostring(arg.name) .. " with a FieryTag bat!")
    arg:teleport(actor.room)
    actor:send("You tag " .. tostring(arg.name) .. " with a whack of your FieryTag bat!")
    arg:send("Tag! " .. tostring(actor.name) .. " tags you with a whack of " .. tostring(actor.possessive) .. " FieryTag bat!")
    self.room:spawn_mobile(188, 96)
    self.room:find_actor("fiery-tagger-announcer"):command("gossip %actor.name% has tagged %arg.name%!  %arg.name% is out!")
    world.destroy(self.room:find_object("fiery-tagger-announcer"))
    arg:command("rem bat")
else
    actor:send(tostring(arg.name) .. " isn't in the game!")
end
return _return_value$trig$, 'ee2ea7dd4b47b04426a724b68ad9a4fe'),
  -- data/triggers/481/481_11_bad_wedding_ring.lua
  (481, 11, $trig$-- Converted from DG Script #48111: bad_wedding_ring
-- Original: OBJECT trigger, flags: GET, probability: 100%
if not (actor.zone_id == 481 and actor.local_id == 5) then
    wait(2)
    self.room:send("The ivory ring flares brightly!")
    actor:damage(100)  -- type: fire
    if damage_dealt ~= 0 then
        self.room:send_except(actor, tostring(actor.name) .. " shouts in surprise and pain. (<b:red>" .. tostring(damage_dealt) .. "</>)")
        if actor:has_item(self.zone_id, self.id) then
            actor:send("You are burnt by the ring and drop it! (<b:red>" .. tostring(damage_dealt) .. "</>)")
            actor:command("drop ivory-ring")
        else
            actor:send("You are burnt by the ring! (<b:red>" .. tostring(damage_dealt) .. "</>)")
        end
        -- TODO(parity): legacy DG referenced room vnum 48223 (likely a typo
        -- for 48123 == (481,123), Vulcera's punishment chamber).
        if actor.room and actor.room.zone_id == 481 and actor.room.local_id == 123 then
            self.room:find_actor("vulcera"):command("get ivory-ring")
        end
    end
end$trig$, 'f8cd14e69eb9fea847377bd7b5318e39'),
  -- data/triggers/520/520_01_grow_hydra_head.lua
  (520, 1, $trig$-- Converted from DG Script #52001: grow_hydra_head
-- Original: MOB trigger, flags: DEATH, probability: 100%
-- Only do this if killer %actor% exists, otherwise they were killed by death of body!
if actor then
    -- If killer holds a lit branch (obj 520:34) or burning branch (520:35),
    -- the wound cauterises and no new head grows.
    -- has_equipped returns a boolean, so remember which branch matched and
    -- take the display name from the object template.
    local no_head
    if actor:has_equipped(520, 35) then
        no_head = objects.template(520, 35)
    elseif actor:has_equipped(520, 34) then
        no_head = objects.template(520, 34)
    end
    if no_head then
        self.room:send_except(actor, tostring(actor.name) .. " seals the Hydra's neck with " .. tostring(no_head.name) .. ", preventing another head from growing!")
        actor:send("You cauterize the wound with " .. tostring(no_head.name) .. " - no more heads from there!")
    elseif random(1, 100) > 65 then
        self.room:send_except(actor, "As soon as " .. tostring(actor.name) .. " strikes the head from the body a new one grows!")
        actor:send("As soon as you chop the head off, another one starts to grow!")
        self.room:spawn_mobile(520, 9)
    else
        self.room:send_except(actor, "As soon as " .. tostring(actor.name) .. " strikes the head from the body TWO new ones grow!")
        actor:send("As soon as you chop the head off, TWO new ones appear!")
        self.room:spawn_mobile(520, 9)
        self.room:spawn_mobile(520, 9)
    end
    if world.count_mobiles(520, 9) >= 30 then
        self.room:send("The heads begin to scream and fly in all directions, and COMPLETELY ANNIHILATE YOU!")
    end
end
return true$trig$, 'ec2a348b06b07c982a52aafbc17b0e89'),
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
if (self.zone_id ~= 30 or self.id ~= 10) then
    if arg == "mandolin" then
        _return_value = true
        return _return_value
    elseif actor:get_quest_stage("charm_person") == 4 and (self.zone_id == 30 and self.id == 10) and (actor:has_equipped(489, 25) or actor:has_item(489, 25)) then
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
    if actor:get_quest_stage("charm_person") == 4 and (self.zone_id == 580 and self.id == 17) and (actor:has_equipped(370, 12) or actor:has_item(370, 12)) then
    elseif arg == "flute" then
        actor:send("You play a melodious tune on the flute.")
        self.room:send_except(actor, tostring(actor.name) .. " plays a melodious tune on the flute.")
        wait(2)
        self.room:send(tostring(self.name) .. " blushes furiously.")
        actor:set_quest_var("charm_person", "charm2", 1)
        actor:send("<b:magenta>" .. tostring(self.name) .. " is charmed by your playing!</>")
    elseif actor:get_quest_stage("charm_person") == 4 and (self.zone_id == 584 and self.id == 6) and (actor:has_equipped(411, 19) or actor:has_item(411, 19)) then
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
    if actor:get_quest_stage("charm_person") == 4 and (self.zone_id == 43 and self.id == 53) and (actor:has_equipped(163, 12) or actor:has_item(163, 12)) then
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
    if actor:get_quest_stage("charm_person") == 4 and (self.zone_id == 237 and self.id == 21) and (actor:has_equipped(580, 17) or actor:has_item(580, 17)) then
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
    if actor:get_quest_stage("charm_person") == 4 and (self.zone_id == 584 and self.id == 6) and (actor:has_equipped(411, 19) or actor:has_item(411, 19)) then
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
return _return_value$trig$, '3826395481bca318a91f36eabc7f7c12'),
  -- data/triggers/625/625_71_the_big_hurt.lua
  (625, 71, $trig$local wielder = self.worn_by
if not wielder then return true end
-- `is_fighting` is a boolean in mud-script (there is no opponent accessor), so
-- the opponent is taken to be a mob in the wielder's room that is in a fight.
if not wielder.is_fighting then return true end
local room = wielder.room
local target
if room then
    for i = 1, room.actor_count do
        local a = room.actors[i]
        if a and a.is_mob and a.is_fighting and a.name ~= wielder.name then
            target = a
            break
        end
    end
end
if not target then return true end
-- Size gate: only triggers for non-medium wielders (giants, etc.).
if wielder.size == "medium" then
    return true
end
local pick = random(1, 16)
if pick == 6 then
    local dam = 150 + random(1, 100)
    local damage_dealt = target:damage(dam)  -- type: crush
    wielder:send("You send " .. tostring(target.name) .. " skidding on " .. tostring(target.possessive) .. " back, with your power-swing from " .. tostring(self.shortdesc) .. "! (<yellow>" .. tostring(damage_dealt) .. "</>)")
    self.room:send_except(wielder, tostring(target.name) .. " goes skidding on " .. tostring(target.possessive) .. " back after a powerful blow from " .. tostring(wielder.name) .. "!</> (<blue>" .. tostring(damage_dealt) .. "</>)")
    target:command("abort")
elseif pick == 7 then
    local dam = 150 + random(1, 100)
    local damage_dealt = target:damage(dam)  -- type: pierce
    wielder:send("A branch of your oak tree catches " .. tostring(target.name) .. ", goring him! (<yellow>" .. tostring(damage_dealt) .. "</>)")
    self.room:send_except(wielder, "A branch of " .. tostring(wielder.name) .. "'s oak tree catches " .. tostring(target.name) .. ", goring him! (<blue>" .. tostring(damage_dealt) .. "</>)")
    target:command("abort")
elseif pick == 8 then
    local dam = 150 + random(1, 100)
    local damage_dealt = target:damage(dam)  -- type: crush
    wielder:send("Your blow catches " .. tostring(target.name) .. " in the back of the head! (<yellow>" .. tostring(damage_dealt) .. "</>)")
    self.room:send_except(wielder, tostring(wielder.name) .. "'s blow catches " .. tostring(target.name) .. " in the back of the head! (<blue>" .. tostring(damage_dealt) .. "</>)")
    target:command("abort")
elseif pick == 9 then
    local dam = 150 + random(1, 100)
    local damage_dealt = target:damage(dam)  -- type: crush
    wielder:send("Your blow catches " .. tostring(target.name) .. " below the knees, sending him heels-up. (<yellow>" .. tostring(damage_dealt) .. "</>)")
    self.room:send_except(wielder, tostring(wielder.name) .. "'s blow catches " .. tostring(target.name) .. " below the knees, sending him heels-up. (<blue>" .. tostring(damage_dealt) .. "</>)")
    target:command("abort")
elseif pick == 10 then
    local dam = 150 + random(1, 100)
    local damage_dealt = target:damage(dam)  -- type: crush
    wielder:send("You stand " .. tostring(self.shortdesc) .. " on end directly on top of " .. tostring(target.name) .. "'s little body. (<yellow>" .. tostring(damage_dealt) .. "</>)")
    self.room:send_except(wielder, tostring(wielder.name) .. " brings " .. tostring(self.shortdesc) .. " down end-first on top of " .. tostring(target.name) .. ". (<blue>" .. tostring(damage_dealt) .. "</>)")
    target:command("abort")
elseif pick == 11 then
    local dam = 150 + random(1, 100)
    local damage_dealt = target:damage(dam)  -- type: pierce
    wielder:send("You jab " .. tostring(target.name) .. " with the end of " .. tostring(self.shortdesc) .. ", puncturing " .. tostring(target.possessive) .. " side. (<yellow>" .. tostring(damage_dealt) .. "</>)")
    self.room:send_except(wielder, tostring(wielder.name) .. " jabs " .. tostring(target.name) .. " with the end of " .. tostring(self.shortdesc) .. ". (<blue>" .. tostring(damage_dealt) .. "</>)")
    target:command("abort")
end$trig$, '4f93f6ce84928f75cdb77fcad2bdf6fb')
) AS v(zone_id, id, commands, old_md5)
WHERE t.zone_id = v.zone_id
  AND t.id = v.id
  AND md5(t.commands) = v.old_md5
  AND t.commands IS DISTINCT FROM v.commands;

COMMIT;
