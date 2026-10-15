-- Playtest r13 content fixes: handle-vs-number room compares (druid 120:3 and the quest triggers with the same bug), Calken and Vityaz text, ConnectFour/Hearts start disambiguation.
--
-- Idempotent: a row already holding the new body is left alone, so rerunning
-- updates nothing. Keyed by the composite primary key (zone_id, id).
-- Guarded: a row is only touched while it still holds the previous committed
-- file (md5 of the body or of the whole file, with or without the final
-- newline), so rows edited in Muditor since then are left alone.

BEGIN;

UPDATE "Triggers" AS t
SET commands = v.commands,
    updated_at = now()
FROM (VALUES
  -- data/triggers/030/030_154_transport_agents_ask.lua
  (30, 154, $trig$-- Converted from DG Script #3154: Transport agents ask
-- Original: MOB trigger, flags: SPEECH_TO, probability: 100%
-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"transport"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end

-- This is the ask trigger for intercity transport questmasters.
-- It allows level 1-15 people to get transport by asking to
-- Anduin, Ickle, or Mielikki.
-- Much of this trigger is a copy of 3152.
-- ******************
-- * GENERAL SETUP **
-- ******************
local minlevel = 1
local maxlevel = 15
-- switch on self.id
local myname = "elf"
local dest_room = 3016
local dsname = "Mielikki"
if (self.zone_id == 30 and self.id == 151) or (self.zone_id == 300 and self.id == 75) then
    -- barbarian, sends to Ickle
    myname = "barbarian"
    dest_room = 10046
    dsname = "Ickle"
elseif (self.zone_id == 30 and self.id == 152) then
    -- dwarf, sends to Anduin
    myname = "dwarf"
    dest_room = 6015
    dsname = "Anduin"
elseif (self.zone_id == 300 and self.id == 74) then
    myname = "drow"
    dest_room = 6015
    dsname = "Anduin"
elseif (self.zone_id == 300 and self.id == 76) then
    myname = "human"
    dest_room = 3016
    dsname = "Mielikki"
elseif (self.zone_id == 300 and self.id == 77) then
    myname = "orc"
    dest_room = 30115
    dsname = "Ogakh"
elseif (self.zone_id == 30 and self.id == 150) then
    -- legacy: questmaster 3150 had no agent record; bail
    return true
end
wait(0.4)
-- **************************
-- * Check for eligibility **
-- **************************
if actor.level > 99 then
    self:command("eyebrow " .. tostring(actor.name))
    actor:send("<blue>The " .. tostring(myname) .. " tells you, 'Just goto " .. tostring(dest_room) .. ".'")
    return _return_value
elseif minlevel > actor.level then
    self:command("shake")
    actor:send("<blue>The " .. tostring(myname) .. " tells you, 'You are not experienced enough to go to " .. tostring(dsname) .. ".'</>")
    return _return_value
elseif actor.level > maxlevel then
    self:command("eyebrow " .. tostring(actor.name))
    actor:send("<blue>The " .. tostring(myname) .. " tells you, 'You are too powerful for me to transport.'</>")
    return _return_value
end
-- **************************
-- * Set origination color **
-- **************************
-- The color says where they came from.
-- It is seen by anyone standing at the destination.
local dcolor
if (self.room.zone_id == 30 and self.room.local_id == 16) then
    -- Mielikki - GREEN
    dcolor = "<green>green</>"
elseif (self.room.zone_id == 60 and self.room.local_id == 15) then
    -- Anduin - RED
    dcolor = "<red>red</>"
elseif (self.room.zone_id == 300 and self.room.local_id == 115) then
    -- Ogakh - GRAY
    dcolor = "<b:black>gray</>"
else
    -- Ickle - BLUE
    dcolor = "<blue>blue</>"
end
-- **********************
-- * Perform transport **
-- **********************
self.room:send_except(actor, tostring(self.name) .. " nods briefly to " .. tostring(actor.name) .. ".")
actor:send(tostring(self.name) .. " nods briefly to you.")
wait(0.4)
self.room:send_except(actor, tostring(self.name) .. " makes a magical gesture at " .. tostring(actor.name) .. ".")
actor:send(tostring(self.name) .. " makes a magical gesture at you.")
self.room:send_except(actor, tostring(actor.name) .. " disappears in a cloud of gray smoke.")
actor:teleport(get_room(math.floor(dest_room / 100), dest_room % 100))
get_room(math.floor(dest_room / 100), dest_room % 100):at(function()
    self.room:send_except(actor, tostring(actor.name) .. " arrives in a cloud of " .. tostring(dcolor) .. " smoke.")
end)
-- actor looks around$trig$, ARRAY['3a87c2031cf0ec988c8580adaee4ee72', '3cd6dabe1caeabcf7b8d49c069ea1d94', '372f2436a90fe703d1f371ef7ba10dd5']),
  -- data/triggers/030/030_165_calken_trainer_speech.lua
  (30, 165, $trig$-- Converted from DG Script #3165: Calken trainer speech
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"training", "yes", "2h", "dodge", "parry", "riposte", "hitall", "barehand", "bash", "disarm", "first", "guard", "kick", "mount", "rescue", "riding", "safefall", "springleap", "tame", "tantrum", "maul", "berserk", "ground", "battle", "roundhouse"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
wait(0.2)
-- make sure they have a quest record for saving variables
if actor:get_quest_stage("trainer_3165") < 1 then
    actor:start_quest("trainer_3165")
else
    actor:erase_quest("trainer_3165")
    actor:start_quest("trainer_3165")
end
-- Which topic was asked about?  The player may wrap it in other words ("dodge please"), so look for the
-- longest known topic named as a whole word or phrase; the greeting words rank last.
local topic
for _, name in ipairs({"ground shaker", "battle howl", "roundhouse", "springleap", "first aid", "barehand", "safefall", "berserk", "riposte", "tantrum", "disarm", "hitall", "rescue", "riding", "dodge", "guard", "mount", "parry", "track", "bash", "kick", "maul", "tame", "training", "yes"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(name, "%p", "%%%0") .. "[%s%p]") then
        topic = name
        break
    end
end
-- introductions: lists the skills available
if topic == "training" or topic == "yes" then
    self.room:send(tostring(self.name) .. " says, 'Sure, I can help you improve just about any necessary martial")
    self.room:send("</>talent.  But remember, I can't teach you skills you don't already know.'")
    self.room:send("</>")
    self.room:send("</>Just ask me about a skill, and I'll give you a quote:")
    self.room:send("</>")
    self.room:send("</>2H bludgeoning weapons, 2H piercing weapons, 2H slashing weapons, barehand,")
    self.room:send("</>bash, battle howl, berserk, disarm, dodge, first aid, ground shaker, guard,")
    self.room:send("</>hitall, kick, maul, mount, parry, rescue, riding, riposte, roundhouse,")
    self.room:send("</>safefall, springleap, tame, tantrum.")
    wait(2)
    self:say("Feel free to ask me about one of them and I'll give you a price.")
    return _return_value
else
    -- defining variables for this script
    speech = topic or speech  -- canonical topic name: it is echoed and saved as the skill below
    local name = actor.name
    local cha = actor.real_cha
    local int = actor.real_int
    -- 
    -- Identify the skill to be trained
    local skill, word2
    if topic == "bash" then
        skill = actor:get_skill("bash")
    elseif string.find(speech, "2h") then
        if string.find(speech, "bludgeoning") then
            word2 = "bludgeoning"
            skill = actor:get_skill("2H bludgeoning weapons")
        elseif string.find(speech, "piercing") then
            word2 = "piercing"
            skill = actor:get_skill("2H piercing weapons")
        elseif string.find(speech, "slashing") then
            word2 = "slashing"
            skill = actor:get_skill("2H slashing weapons")
        else
            self:say("Not sure that I've heard of that one.  What was it again?")
            return _return_value
        end
    elseif topic == "disarm" then
        skill = actor:get_skill("disarm")
    elseif topic == "dodge" then
        skill = actor:get_skill("dodge")
    elseif topic == "parry" then
        skill = actor:get_skill("parry")
    elseif topic == "riposte" then
        skill = actor:get_skill("riposte")
    elseif topic == "hitall" then
        skill = actor:get_skill("hitall")
    elseif topic == "barehand" then
        skill = actor:get_skill("barehand")
    elseif topic == "springleap" then
        skill = actor:get_skill("springleap")
    elseif topic == "safefall" then
        skill = actor:get_skill("safefall")
    elseif topic == "bash" then
        skill = actor:get_skill("bash")
    elseif topic == "guard" then
        skill = actor:get_skill("guard")
    elseif topic == "rescue" then
        skill = actor:get_skill("rescue")
    elseif topic == "kick" then
        skill = actor:get_skill("kick")
    elseif topic == "first aid" then
        word2 = "aid"
        skill = actor:get_skill("first aid")
    elseif topic == "mount" then
        skill = actor:get_skill("mount")
    elseif topic == "riding" then
        skill = actor:get_skill("riding")
    elseif topic == "tame" then
        skill = actor:get_skill("tame")
    elseif topic == "ground shaker" then
        word2 = "shaker"
        skill = actor:get_skill("ground shaker")
    elseif topic == "battle howl" then
        word2 = "howl"
        skill = actor:get_skill("battle howl")
    elseif topic == "maul" then
        skill = actor:get_skill("maul")
    elseif topic == "tantrum" then
        skill = actor:get_skill("tantrum")
    elseif topic == "berserk" then
        skill = actor:get_skill("berserk")
    elseif topic == "roundhouse" then
        skill = actor:get_skill("roundhouse")
    else
        self:say("I'm not familiar with " .. tostring(speech) .. ".")
        return _return_value
    end
    -- 
    -- Check to see if a skill should be taught at all
    -- 
    -- get_skill is the 0..1000 proficiency (DG %actor.skill[]% was 0..100, hence its `10 *`)
    skill = skill or 0
    local maxskill = actor.level * 10 + 60
    -- check for capped skills
    local cap = 1000
    if topic == "track" then
        -- switch on actor.class
        if actor.class == "mercenary" then
            cap = 850
        elseif actor.class == "rogue" then
            cap = 650
        elseif actor.class == "thief" then
            cap = 600
        elseif actor.class == "assassin" then
            cap = 750
        end
    elseif topic == "dodge" or topic == "parry" then
        -- switch on actor.race
        if actor.race == "ogre" or actor.race == "troll" then
            cap = 700
        end
    elseif topic == "riposte" then
        -- switch on actor.race
        if actor.race == "ogre" then
            cap = 700
        end
    end
    if skill < 50 then
        self.room:send(tostring(self.name) .. " says, 'I wouldn't know where to start.")
        self.room:send("</>Let's talk about improving a skill you actually know.'")
        return _return_value
    elseif skill >= cap or skill >= maxskill then
        self:say("There is nothing left to teach you - you've mastered " .. tostring(speech) .. "!")
        return _return_value
    end
    if cap < maxskill then
        maxskill = cap
    end
    -- This portion is for smooth speech indicating the effects of a players cha or int
    self:command("score")
    if cha > 70 then
        self:say("I like you.")
        if int > 70 then
            -- (empty room echo)
            self.room:send(tostring(self.name) .. " says, '...and you're pretty bright.")
            self.room:send("I'll give you a good deal.'")
        elseif int < 50 then
            -- (empty room echo)
            self:say("...but you aren't the smartest.")
        end
    elseif cha < 50 then
        self:say("I don't like you much.")
        if int > 70 then
            -- (empty room echo)
            self:say("...but you are pretty bright.")
        elseif int < 50 then
            -- (empty room echo)
            self:say("...and you aren't the smartest.")
        else
        end
    else
        self:say("You're alright.")
        if int > 70 then
            -- (empty room echo)
            self:say("...and you're pretty bright.")
        elseif int < 50 then
            -- (empty room echo)
            self:say("...but you aren't the smartest.")
        end
    end
    -- (empty room echo)
    -- Now a price is calculated
    local change = maxskill - skill
    local opinion = 200 - (cha + int)
    local price = math.floor(change * opinion * actor.level * actor.level / (skill * 20))
    -- 
    -- now the price in copper has to be divided into coinage.
    local plat = price // 1000
    local gold = price // 100 - plat * 10
    local silv = price // 10 - plat * 100 - gold * 10
    local copp = price  - plat * 1000 - gold * 100 - silv * 10
    -- now the price can be reported
    self:say("I'll teach you " .. tostring(speech) .. " for " .. tostring(plat) .. " platinum, " .. tostring(gold) .. " gold, " .. tostring(silv) .. " silver, " .. tostring(copp) .. " copper.")
    -- (empty room echo)
    self:say("Just get me the money, and I'll get started.")
    actor:set_quest_var("trainer_3165", "skill_name", speech)
    if word2 then
        actor:set_quest_var("trainer_3165", "word2", word2)
    end
    actor:set_quest_var("trainer_3165", "skill_level", skill)
    actor:set_quest_var("trainer_3165", "max_skill", maxskill)
    actor:set_quest_var("trainer_3165", "price", price)
    actor:set_quest_var("trainer_3165", "actor_level", actor.level)
end$trig$, ARRAY['3520334bb5d51a4ae3aab5b9930e7550', 'b9f469cd0d880899c114c8538602aec3', '7b6c68acd0dd00963efeeff642d22951']),
  -- data/triggers/030/030_88_paladin_pendant_command_pray.lua
  (30, 88, $trig$-- Converted from DG Script #3088: Paladin pendant command pray
-- Original: OBJECT trigger, flags: COMMAND, probability: 3%

-- Command location mask 3: legacy OCMD_EQUIP=1 (worn), OCMD_INVEN=2 (carried), OCMD_ROOM=4 (floor)
if not (location == "equip" or location == "inventory") then
    return true  -- Not in a location this trigger watches
end

-- Command filter: pray
if not (cmd == "pray") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
-- switch on cmd
do
    local _sw1 = string.lower(tostring(cmd or ""))
    if _sw1 == "p" then
        _return_value = true
        return _return_value
    end
end
local anti = "Anti-Paladin"
local pendantstage = actor:get_quest_stage("paladin_pendant")
-- switch on self.id
local continue
do
    if (self.zone_id == 2 and self.id == 160) then
        if (actor.room.zone_id == 54 and actor.room.local_id == 79) and pendantstage == 1 then
            continue = "yes"
        end
    elseif (self.zone_id == 2 and self.id == 161) then
        if ((actor.room.zone_id == 173 and actor.room.local_id == 45) or (actor.room.zone_id == 173 and actor.room.local_id == 46) or (actor.room.zone_id == 173 and actor.room.local_id == 51) or (actor.room.zone_id == 173 and actor.room.local_id == 52)) and pendantstage == 2 then
            continue = "yes"
        end
    elseif (self.zone_id == 2 and self.id == 162) then
        if (actor.room.zone_id == 495 and actor.room.local_id == 16) and pendantstage == 3 then
            continue = "yes"
        end
    elseif (self.zone_id == 2 and self.id == 163) then
        if (actor.room.zone_id == 23 and actor.room.local_id == 108) and pendantstage == 4 then
            continue = "yes"
        end
    elseif (self.zone_id == 2 and self.id == 164) then
        if (actor.room.zone_id == 551 and actor.room.local_id == 5) and pendantstage == 5 then
            continue = "yes"
        end
    elseif (self.zone_id == 2 and self.id == 165) then
        if (actor.room.zone_id == 530 and actor.room.local_id == 159) and pendantstage == 6 then
            continue = "yes"
        end
    elseif (self.zone_id == 2 and self.id == 166) then
        if (actor.room.zone_id == 584 and actor.room.local_id == 24) and pendantstage == 7 then
            continue = "yes"
        end
    elseif (self.zone_id == 2 and self.id == 167) then
        if (actor.room.zone_id == 480 and actor.room.local_id == 32) and pendantstage == 8 then
            continue = "yes"
        end
    elseif (self.zone_id == 2 and self.id == 168) then
        if (actor.room.zone_id == 488 and actor.room.local_id == 80) and pendantstage == 9 then
            continue = "yes"
        end
    end
end
if continue == "yes" then
    actor:command("pray")
    wait(0.2)
    if actor.class == "paladin" then
        actor:send("<b:yellow>You have gained new insights on your righteous cause!</>")
    elseif actor.class == "anti-paladin" then
        actor:send("<b:red>You have gained new insights on your ruinouse cause!</>")
    end
    actor:set_quest_var("paladin_pendant", "necklacetask4", 1)
else
    _return_value = true
end
return _return_value$trig$, ARRAY['7bdcf68db2c5be0bc96b3e6ce32cc60f', '0ed8ad4c0e117ce79f49f0326b2adee9', '29cf9406b47da0f53eeae1eb5414b298']),
  -- data/triggers/053/053_18_ranger_trophy_command_forage.lua
  (53, 18, $trig$-- Converted from DG Script #5318: Ranger Trophy command forage
-- Original: OBJECT trigger, flags: COMMAND, probability: 3%

-- Command location mask 3: legacy OCMD_EQUIP=1 (worn), OCMD_INVEN=2 (carried), OCMD_ROOM=4 (floor)
if not (location == "equip" or location == "inventory") then
    return true  -- Not in a location this trigger watches
end

-- Command filter: forage
if not (cmd == "forage") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
-- switch on cmd
do
    local _sw1 = string.lower(tostring(cmd or ""))
    if _sw1 == "f" or _sw1 == "fo" or _sw1 == "for" then
        _return_value = true
        return _return_value
    end
end
local trophystage = actor:get_quest_stage("ranger_trophy")
-- switch on self.id
local continue
do
    if (self.zone_id == 2 and self.id == 170) then
        if (actor.room.zone_id == 86 and actor.room.local_id == 14) and trophystage == 1 then
            continue = "yes"
        end
    elseif (self.zone_id == 2 and self.id == 171) then
        if (actor.room.zone_id == 203 and actor.room.local_id >= 52 and actor.room.local_id <= 54) and trophystage == 2 then
            continue = "yes"
        end
    elseif (self.zone_id == 2 and self.id == 172) then
        if ((actor.room.zone_id == 23 and actor.room.local_id == 92) or (actor.room.zone_id == 23 and actor.room.local_id == 110)) and trophystage == 3 then
            continue = "yes"
        end
    elseif (self.zone_id == 2 and self.id == 173) then
        if (actor.room.zone_id == 462 and actor.room.local_id == 44) and trophystage == 4 then
            continue = "yes"
        end
    elseif (self.zone_id == 2 and self.id == 174) then
        if (actor.room.zone_id == 123 and actor.room.local_id == 129) and trophystage == 5 then
            continue = "yes"
        end
    elseif (self.zone_id == 2 and self.id == 175) then
        if (actor.room.zone_id == 534 and actor.room.local_id == 168) and trophystage == 6 then
            continue = "yes"
        end
    elseif (self.zone_id == 2 and self.id == 176) then
        if (actor.room.zone_id == 490 and actor.room.local_id == 94) and trophystage == 7 then
            continue = "yes"
        end
    elseif (self.zone_id == 2 and self.id == 177) then
        if (actor.room.zone_id == 480 and actor.room.local_id == 80) and trophystage == 8 then
            continue = "yes"
        end
    elseif (self.zone_id == 2 and self.id == 178) then
        if (actor.room.zone_id == 238 and actor.room.local_id == 92) and trophystage == 9 then
            continue = "yes"
        end
    end
end
if continue == "yes" then
    actor:send("You forage through the lair.")
    wait(0.2)
    actor:send("<b:green>Your connection to " .. tostring(self.shortdesc) .. " takes on new meaning!</>")
    actor:set_quest_var("ranger_trophy", "trophytask4", 1)
else
    _return_value = true
end
return _return_value$trig$, ARRAY['9c2f3331dc691185a8498afd0d374ef3', 'edfc3ce4ad6a734f6c470617bb674ec1', '378a2acd5e7e96f03d640076d50030fe']),
  -- data/triggers/053/053_29_rogue_cloak_search.lua
  (53, 29, $trig$-- Converted from DG Script #5329: Rogue cloak search
-- Original: OBJECT trigger, flags: COMMAND, probability: 3%

-- Command location mask 3: legacy OCMD_EQUIP=1 (worn), OCMD_INVEN=2 (carried), OCMD_ROOM=4 (floor)
if not (location == "equip" or location == "inventory") then
    return true  -- Not in a location this trigger watches
end

-- Command filter: search
if not (cmd == "search") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
-- switch on cmd
do
    local _sw1 = string.lower(tostring(cmd or ""))
    if _sw1 == "s" or _sw1 == "se" then
        _return_value = true
        return _return_value
    end
end
local cloakstage = actor:get_quest_stage("rogue_cloak")
-- switch on self.id
local continue
do
    if (self.zone_id == 2 and self.id == 180) then
        if (actor.room.zone_id == 136 and actor.room.local_id == 60) and cloakstage == 1 then
            continue = "yes"
        end
    elseif (self.zone_id == 2 and self.id == 181) then
        if (actor.room.zone_id == 185 and actor.room.local_id == 49) and cloakstage == 2 then
            continue = "yes"
        end
    elseif (self.zone_id == 2 and self.id == 182) then
        if ((actor.room.zone_id == 590 and actor.room.local_id == 80) or (actor.room.zone_id == 590 and actor.room.local_id == 81)) and cloakstage == 3 then
            continue = "yes"
        end
    elseif (self.zone_id == 2 and self.id == 183) then
        if (actor.room.zone_id == 126 and actor.room.local_id == 26) and cloakstage == 4 then
            continue = "yes"
        end
    elseif (self.zone_id == 2 and self.id == 184) then
        if (actor.room.zone_id == 160 and actor.room.local_id == 68) and cloakstage == 5 then
            continue = "yes"
        end
    elseif (self.zone_id == 2 and self.id == 185) then
        if ((actor.room.zone_id == 162 and actor.room.local_id == 15) or (actor.room.zone_id == 162 and actor.room.local_id == 20)) and cloakstage == 6 then
            continue = "yes"
        end
    elseif (self.zone_id == 2 and self.id == 186) then
        if (actor.room.zone_id == 370 and actor.room.local_id == 62) and cloakstage == 7 then
            continue = "yes"
        end
    elseif (self.zone_id == 2 and self.id == 187) then
        if (actor.room.zone_id == 530 and actor.room.local_id == 103) and cloakstage == 8 then
            continue = "yes"
        end
    elseif (self.zone_id == 2 and self.id == 188) then
        if (actor.room.zone_id == 480 and actor.room.local_id == 83) and cloakstage == 9 then
            continue = "yes"
        end
    end
end
if continue == "yes" then
    actor:command("search")
    actor:send("<b:yellow>You have found your target!</>")
    actor:set_quest_var("rogue_cloak", "cloaktask4", 1)
else
    _return_value = true
end
return _return_value$trig$, ARRAY['6ec4894ef052109af602e2941c545325', 'f2b0738f3fc82bcb85e47d2b24c07825', 'dbf17a2b09c98fe0075ae5ade9e1e705']),
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
do
    local _sw1 = string.lower(tostring(cmd or ""))
    if _sw1 == "m" or _sw1 == "me" then
        _return_value = true
        return _return_value
    end
end
if actor:get_quest_stage("monk_vision") > 4 and actor:get_quest_stage("monk_chants") == 2 and actor.level >= 40 and (actor.room.zone_id == 580 and actor.room.local_id == 186) then
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
return _return_value$trig$, ARRAY['70c53e29d79adbe89e02fea9806ee7f3', '95bbb699a82b112de52c1c8294375490', 'aed15af020397d6a8033f40fc7840706']),
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
do
    local _sw1 = string.lower(tostring(cmd or ""))
    if _sw1 == "m" or _sw1 == "me" then
        _return_value = true
        return _return_value
    end
end
if actor:get_quest_stage("monk_vision") > 5 and actor:get_quest_stage("monk_chants") == 3 and actor.level >= 50 and (actor.room.zone_id == 117 and actor.room.local_id == 137) then
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
return _return_value$trig$, ARRAY['e421bba42d8bbae9825515b50e8ecbc0', 'e32cb26db48ba934dd2222e1a0c7c703', '22c55b7f9e2f31f0b4a3b0e153d6e1a6']),
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
do
    local _sw1 = string.lower(tostring(cmd or ""))
    if _sw1 == "m" or _sw1 == "me" then
        _return_value = true
        return _return_value
    end
end
if actor:get_quest_stage("monk_vision") > 6 and actor:get_quest_stage("monk_chants") == 4 and actor.level >= 60 and (actor.room.zone_id == 23 and actor.room.local_id == 486) then
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
return _return_value$trig$, ARRAY['75cbe248ef0e24d0df7cc2686478dc4b', '760827d290c0345c5a2cdb29a2e41d29', '2ca23f6065c24923ab6732302293a1c1']),
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
do
    local _sw1 = string.lower(tostring(cmd or ""))
    if _sw1 == "m" or _sw1 == "me" then
        _return_value = true
        return _return_value
    end
end
if actor:get_quest_stage("monk_vision") > 7 and actor:get_quest_stage("monk_chants") == 5 and actor.level >= 75 and (actor.room.zone_id == 160 and actor.room.local_id == 72) then
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
return _return_value$trig$, ARRAY['3dffab1dc3ba9154808f0185d748bf4b', '9f48c6c5a3c146623a3ab3cbd2ca611e', 'e9292f05fcdaf7e86df48e589b3450d1']),
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
do
    local _sw1 = string.lower(tostring(cmd or ""))
    if _sw1 == "m" or _sw1 == "me" then
        _return_value = true
        return _return_value
    end
end
if actor:get_quest_stage("monk_vision") > 8 and actor:get_quest_stage("monk_chants") == 6 and actor.level >= 80 and (actor.room.zone_id == 52 and actor.room.local_id == 72) then
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
return _return_value$trig$, ARRAY['c65bb70e1b4d96d92fbd96d006435ee3', '5ec91f44c173ea2b8a54a9ed42140a25', 'aac15b55d26dd382f3781d691efd9e30']),
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
do
    local _sw1 = string.lower(tostring(cmd or ""))
    if _sw1 == "m" or _sw1 == "me" then
        _return_value = true
        return _return_value
    end
end
if actor:get_quest_stage("monk_vision") >= 9 and actor:get_quest_stage("monk_chants") == 7 and actor.level == 99 and (actor.room.zone_id == 489 and actor.room.local_id == 13) then
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
            actor:send("<b:black>The chant to engender catastrophe echoes from the altar!</>")
            actor:send("<b:black>You have learned Seed of Destruction.</>")  -- typo: sent
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
return _return_value$trig$, ARRAY['1fa2ecddab09c6110488ac96f84dc081', 'a99dd375429b8d3ca6a946ed39ac5507', 'df52fb8bcfd7846ca541c684c9f3cea1']),
  -- data/triggers/060/060_20_quest_obj_package_8813.lua
  (60, 20, $trig$-- Converted from DG Script #6020: quest_obj_package(8813)
-- Original: OBJECT trigger, flags: GET, probability: 100%
local _return_value = true  -- Default: allow action
if actor:get_quest_var("merc_ass_thi_subclass:subclass_name") == "thief" and actor:get_quest_stage("merc_ass_thi_subclass") == 3 then
    if not (self.room.zone_id == 88 and self.room.local_id == 28) then
        _return_value = true
        self.room:send_except(actor, tostring(self.shortdesc) .. " suddenly bursts into flames!")
        actor:send(tostring(self.shortdesc) .. " suddenly bursts into flames from being handled too much!")
        world.destroy(self)
    else
        actor:advance_quest("merc_ass_thi_subclass")
        actor:send("<b:black>You've secured the package!")
        actor:send("Now get out carefully!</>")
    end
end
return _return_value$trig$, ARRAY['0c34f2d1dc9ba0c290bbac98ac597993', '2b2845fb8c0798c625c967db3976341e', 'e584a5bb65146128da89444d00d9866d']),
  -- data/triggers/060/060_26_thief_subclass_package_give.lua
  (60, 26, $trig$-- Converted from DG Script #6026: thief_subclass_package_give
-- Original: OBJECT trigger, flags: GIVE, probability: 100%
local _return_value = true  -- Default: allow action
if victim:get_quest_var("merc_ass_thi_subclass:subclass_name") == "thief" and victim:get_quest_stage("merc_ass_thi_subclass") == 3 then
    if not (self.room.zone_id == 88 and self.room.local_id == 28) then
        _return_value = true
        self.room:send_except(actor, tostring(self.shortdesc) .. " suddenly bursts into flames!")
        actor:send(tostring(self.shortdesc) .. " suddenly bursts into flames from being handled too much!")
        world.destroy(self)
    else
        victim:advance_quest("merc_ass_thi_subclass")
        victim:send("You've secured the package!")
    end
end
return _return_value$trig$, ARRAY['8ae030d7fe926ada099ad60dbd2ae4ad', 'ef465114efa8a7460cafa667c9778e17', 'd6db3a1608a8d40a2f870912ac79296f']),
  -- data/triggers/060/060_29_assassin_subclass_command_pick.lua
  (60, 29, $trig$-- Converted from DG Script #6029: assassin_subclass_command_pick
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: pick
if not (cmd == "pick") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
if (self.room.zone_id == 30 and self.room.local_id == 62) then
    -- switch on arg
    do
        local _sw1 = string.lower(tostring(arg or ""))
        if _sw1 == "d" or _sw1 == "do" or _sw1 == "doo" or _sw1 == "door" then
            actor:send("You begin to pick the lock when " .. tostring(self.name) .. " interrupts you.")
            self.room:send(tostring(self.name) .. " says, 'Hey!  You there!  What are you doing?!'")
            self.room:send_except(actor, tostring(self.name) .. " shoves " .. tostring(actor.name) .. " away from the door.")
            actor:send(tostring(self.name) .. " shoves you away from the door.")
        else
            _return_value = true
        end
    end
else
    _return_value = true
end
return _return_value$trig$, ARRAY['11681cece816f18b47718cd71f32b351', 'c0e8a8e36a3a2dc16e5097bcee81edda', '214fd07c1b3f1484dc89987651cb746e']),
  -- data/triggers/060/060_58_assassin_mask_command_hide.lua
  (60, 58, $trig$-- Converted from DG Script #6058: Assassin mask command hide
-- Original: OBJECT trigger, flags: COMMAND, probability: 3%

-- Command location mask 3: legacy OCMD_EQUIP=1 (worn), OCMD_INVEN=2 (carried), OCMD_ROOM=4 (floor)
if not (location == "equip" or location == "inventory") then
    return true  -- Not in a location this trigger watches
end

-- Command filter: hide
if not (cmd == "hide") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
-- switch on cmd
do
    local _sw1 = string.lower(tostring(cmd or ""))
    if _sw1 == "h" or _sw1 == "hi" then
        _return_value = true
        return _return_value
    end
end
local maskstage = actor:get_quest_stage("assassin_mask")
-- switch on self.id
local continue
do
    if (self.zone_id == 2 and self.id == 150) then
        if (actor.room.zone_id == 54 and actor.room.local_id >= 36 and actor.room.local_id <= 40) and maskstage == 1 then
            continue = "yes"
        end
    elseif (self.zone_id == 2 and self.id == 151) then
        if (actor.room.zone_id == 161 and actor.room.local_id >= 65 and actor.room.local_id <= 73) and maskstage == 2 then
            continue = "yes"
        end
    elseif (self.zone_id == 2 and self.id == 152) then
        if (actor.room.zone_id == 237 and actor.room.local_id >= 11 and actor.room.local_id <= 15) and maskstage == 3 then
            continue = "yes"
        end
    elseif (self.zone_id == 2 and self.id == 153) then
        if (actor.room.zone_id == 160 and actor.room.local_id == 87) and maskstage == 4 then
            continue = "yes"
        end
    elseif (self.zone_id == 2 and self.id == 154) then
        if (actor.room.zone_id == 510 and actor.room.local_id == 23) and maskstage == 5 then
            continue = "yes"
        end
    elseif (self.zone_id == 2 and self.id == 155) then
        if (actor.room.zone_id == 481 and ((actor.room.local_id >= 91 and actor.room.local_id <= 96) or (actor.room.local_id >= 125 and actor.room.local_id <= 132))) and maskstage == 6 then
            continue = "yes"
        end
    elseif (self.zone_id == 2 and self.id == 156) then
        if (actor.room.zone_id == 40 and actor.room.local_id == 64) and maskstage == 7 then
            continue = "yes"
        end
    elseif (self.zone_id == 2 and self.id == 157) then
        if (actor.room.zone_id == 480 and actor.room.local_id == 45) and maskstage == 8 then
            continue = "yes"
        end
    elseif (self.zone_id == 2 and self.id == 158) then
        if (actor.room.zone_id == 520 and actor.room.local_id == 46) and maskstage == 9 then
            continue = "yes"
        end
    end
end
if continue == "yes" then
    actor:command("hide")
    wait(0.2)
    actor:send("<b:black>" .. tostring(self.shortdesc) .. " seems to absorb the shadowy darkness around you!")
    actor:set_quest_var("assassin_mask", "masktask4", 1)
else
    _return_value = true
end
return _return_value$trig$, ARRAY['10b7196a25db27c3a9c9331f1890fb03', '8a5d450850d6a1a04045901b12d3e234', 'be3e8785faca1f87f9cef69beaa7bddc']),
  -- data/triggers/120/120_03_druid_receive.lua
  (120, 3, $trig$local stage = actor:get_quest_stage("twisted_sorrow")

-- Quest already complete: politely refuse.
if stage > 1 then
    self.room:send_except(actor, actor.name .. " gives " .. object.shortdesc .. " to " .. self.name .. ".")
    actor:send("You give " .. object.shortdesc .. " to " .. self.name .. ".")
    self:say("No further offerings are necessary.")
    actor:send(self.name .. " returns " .. object.shortdesc .. " to you.")
    self.room:send_except(actor, self.name .. " returns " .. object.shortdesc .. " to " .. actor.name .. ".")
    return false  -- legacy return 0: the giver keeps the item
end

-- Quest not yet started: refuse with confusion.
if stage ~= 1 then
    self.room:send_except(actor, actor.name .. " gives " .. object.shortdesc .. " to " .. self.name .. ".")
    actor:send("You give " .. object.shortdesc .. " to " .. self.name .. ".")
    self:say("Why do you give me this?")
    actor:send(self.name .. " returns " .. object.shortdesc .. " to you.")
    self.room:send_except(actor, self.name .. " returns " .. object.shortdesc .. " to " .. actor.name .. ".")
    return false  -- legacy return 0: the giver keeps the item
end

-- Stage 1: must be a liquid container.
if object.type ~= "DRINKCONTAINER" then
    self.room:send_except(actor, actor.name .. " gives " .. object.shortdesc .. " to " .. self.name .. ".")
    actor:send("You give " .. object.shortdesc .. " to " .. self.name .. ".")
    self:say("This is not a liquid container.")
    actor:send(self.name .. " returns " .. object.shortdesc .. " to you.")
    self.room:send_except(actor, self.name .. " returns " .. object.shortdesc .. " to " .. actor.name .. ".")
    return false  -- legacy return 0: the giver keeps the item
end

-- Druid's home grove (no tree): redirect player.
if (self.room.zone_id == 120 and self.room.local_id == 15) then
    self.room:send_except(actor, actor.name .. " gives " .. object.shortdesc .. " to " .. self.name .. ".")
    actor:send("You give " .. object.shortdesc .. " to " .. self.name .. ".")
    self:say("Let us move to one of the mighty Rhells first, friend.")
    actor:send(self.name .. " returns " .. object.shortdesc .. " to you.")
    self.room:send_except(actor, self.name .. " returns " .. object.shortdesc .. " to " .. actor.name .. ".")
    return false  -- legacy return 0: the giver keeps the item
end

-- Empty container: refuse.
if object.val1 == 0 then
    self.room:send_except(actor, actor.name .. " gives " .. object.shortdesc .. " to " .. self.name .. ".")
    actor:send("You give " .. object.shortdesc .. " to " .. self.name .. ".")
    self:emote("peers into " .. object.shortdesc .. ".")
    self:say("This won't do at all!  It's empty.")
    actor:send(self.name .. " returns " .. object.shortdesc .. " to you.")
    self.room:send_except(actor, self.name .. " returns " .. object.shortdesc .. " to " .. actor.name .. ".")
    return false  -- legacy return 0: the giver keeps the item
end

-- Quest variables are keyed by the tree's legacy room number (12016, ...): the journal and
-- status triggers (4:18, 120:99) read them that way.
local tree = require("dg").to_vnum(self.room.zone_id, self.room.local_id)

-- This tree already satisfied: refuse.
if (actor:get_quest_var("twisted_sorrow:satisfied_tree:" .. tree) or 0) == 1 then
    self.room:send_except(actor, actor.name .. " gives " .. object.shortdesc .. " to " .. self.name .. ".")
    actor:send("You give " .. object.shortdesc .. " to " .. self.name .. ".")
    self:say("This tree is already satisfied, my friend.")
    actor:send(self.name .. " returns " .. object.shortdesc .. " to you.")
    self.room:send_except(actor, self.name .. " returns " .. object.shortdesc .. " to " .. actor.name .. ".")
    return false  -- legacy return 0: the giver keeps the item
end

-- Otherwise: druid consumes the offering and may advance the quest.
wait(1)
self:emote("peers into " .. object.shortdesc .. ".")
wait(2)
self:command("nod")
wait(2)
self:command("kneel")
self:emote("places his hands on the mighty Rhell's roots.")
wait(5)
self:emote("continues to kneel, making no sound.")
wait(7)
self:command("stand")

-- Match liquid type to tree (object.val2 = liquid type code).
local success = false
if (self.room.zone_id == 120 and self.room.local_id == 16) and object.val2 == 11 then            -- Tree of Luck: tea
    success = true
elseif (self.room.zone_id == 120 and self.room.local_id == 17) and object.val2 > 0 and object.val2 < 5 then  -- Reverence: alcohol
    success = true
elseif (self.room.zone_id == 120 and self.room.local_id == 18) and object.val2 == 0 then          -- Self-reliance: water
    success = true
elseif (self.room.zone_id == 120 and self.room.local_id == 14) and object.val2 == 12 then         -- Nimbleness: coffee
    success = true
elseif (self.room.zone_id == 120 and self.room.local_id == 46) and object.val2 == 10 then         -- Kindness: milk
    success = true
end

self.room:send(self.name .. " carefully pours out " .. object.shortdesc .. " onto the Rhell's roots.")
wait(0.1)
world.destroy(object)
wait(0.8)

if not success then
    self:command("sigh")
    wait(0.8)
    self:say("The tree is not responding.")
    wait(1)
    self:say("I fear it has little liking for that drink.")
    return false
end

local num_trees = 1 + (actor:get_quest_var("twisted_sorrow:num_trees") or 0)
actor:set_quest_var("twisted_sorrow", "num_trees", num_trees)
actor:set_quest_var("twisted_sorrow", "satisfied_tree:" .. tree, 1)
self.room:send("A deep throbbing hum is emanating from the ground.")
wait(3)
self.room:send("The hum gets louder and louder, causing twigs and leaves to dance upon the ground!")
self.room:send("It is overwhelming, yet soothing.")
wait(5)
self.room:send("The hum fades slowly away, and all is quiet again.")
wait(3)
self:command("smile")
wait(2)

if num_trees < 4 then
    self:say("You have done this tree a great service.")
elseif num_trees == 4 then
    self:say("I sense that yet another tree waits in loneliness.")
    wait(1)
    self:say("There can be no peace until it, too, is satisfied.")
elseif num_trees == 5 then
    self:say("Excellent, my friend!  The trees are satisfied.")
    wait(0.8)
    self:say("Please take this gift on their behalf.")
    wait(0.8)
    self.room:spawn_object(120, 18)
    self:command("give sleeves-sorrow " .. actor.name)
    wait(0.4)
    self:emote("walks away quietly.")
    actor:complete_quest("twisted_sorrow")

    -- Compute experience award scaled by capped level.
    local expcap
    if actor.level < 10 then
        expcap = actor.level
    else
        expcap = 10
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

    -- Class scaling so all classes receive the same proportionate amount.
    if actor.class == "warrior" or actor.class == "berserker" then
        expmod = expmod + (expmod / 10)                       -- 110%
    elseif actor.class == "paladin" or actor.class == "anti-paladin" or actor.class == "ranger" then
        expmod = expmod + ((expmod * 2) / 15)                 -- 115%
    elseif actor.class == "sorcerer" or actor.class == "pyromancer" or actor.class == "cryomancer" or actor.class == "illusionist" or actor.class == "bard" then
        expmod = expmod + (expmod / 5)                        -- 120%
    elseif actor.class == "necromancer" or actor.class == "monk" then
        expmod = expmod + ((expmod * 2) / 5)                  -- 130%
    end

    actor:send("<b:yellow>You gain experience!</>")
    -- Legacy DG awarded expmod ten times in a loop; preserved for parity.
    for _ = 1, 10 do
        actor:award_exp(expmod)
    end
    self:teleport(get_room(120, 15))
end

return false$trig$, ARRAY['574ce25a5a12f9d18a61a8ae13ce7b8a', '80b31cf663606bdb1938da0ec2b914cf', '9479855912bc5803574ba5f847db69be']),
  -- data/triggers/120/120_06_haggard_brownie_greets.lua
  (120, 6, $trig$-- Converted from DG Script #12006: Haggard brownie greets
-- Original: MOB trigger, flags: GREET, probability: 100%
if actor.is_player and (self.room.zone_id == 120 and self.room.local_id == 103) then
    wait(0.3)
    self:emote("looks at you with desperation.")
    wait(0.8)
    -- Mob 120-20 = dark pixie tormentor. Present in this room?
    local tormentor = self.room:find_actor("dark-pixie-tormentor")
    if tormentor then
        self:say("Please, help me escape from these fiends!")
        wait(3)
        tormentor:command("slap haggard-brownie")
        tormentor:emote("hisses, 'It will be ssssilent!'")
        wait(2)
        self:emote("cringes away, uttering a little yelp.")
    else
        self:say("I am so lost!  Will you help me get home?")
        self:say("Say 'I will escort you' if so.  But beware!")
        self:say("The forces of darkness hunt me...")
        wait(4)
        self:command("scan")
    end
end$trig$, ARRAY['8eee029f12b8456d138bf16b0fed7c6d', '53d3fc4e84c0f85363ad6560f644e56b', '172cc3d6f04713ec123b6047a9601d71']),
  -- data/triggers/120/120_09_dark_pixie_tormentor_dies.lua
  (120, 9, $trig$-- Converted from DG Script #12009: Dark pixie tormentor dies
-- Original: MOB trigger, flags: DEATH, probability: 100%
if (self.room.zone_id == 120 and self.room.local_id == 103) then
    run_room_trigger(120, 8)
end$trig$, ARRAY['9b3f75b6eefb066d5aab75f059a0ffe1', '0419f1b7ed11565e77000ae0a1206f9e', '522afa8e680262409d6e6ff56e1f4768']),
  -- data/triggers/120/120_10_haggard_brownie_hears_escort.lua
  (120, 10, $trig$-- Converted from DG Script #12010: Haggard brownie hears 'escort'
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"escort"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
-- Remember who is escorting us so trigger 120-21 can hand out the reward.
globals.rescuer = actor
if not (self.room.zone_id == 120 and self.room.local_id == 103) and not (self.room.zone_id == 120 and self.room.local_id == 95) and not (self.room.zone_id == 120 and self.room.local_id == 30) then
    wait(0.4)
    self:follow(actor)
end$trig$, ARRAY['1fb95a1448fe1e522fb75f67b58266c9', '883653636704c78a353e48946d4efbf3', 'a4d3164c3a8ebab41334addd50deb7be']),
  -- data/triggers/123/123_36_vityaz_exposition.lua
  (123, 36, $trig$-- Converted from DG Script #12336: vityaz_exposition
-- Original: MOB trigger, flags: SPEECH, SPEECH_TO, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"who", "continue"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
if (string.find(speech, "who are you") or string.find(speech, "continue")) and actor.is_player then
    wait(0.2)
    if (actor:get_quest_var("megalith_quest:vexpo") or 0) == 0 then
        self:say("I am a sorcerer-warrior of the Tzigane people.  Though others call us by a cruder name, you've certainly seen us around the world before.  I myself come from a family caravan which is usually camped not far to the east of here.")
        wait(4)
        self:say("When I was a girl, the old witchy woman of my caravan saw mystic potential in me.  She took me under her wing and taught me to utilize that potential to defend my family and our home.")
        wait(0.2)
        self.room:send(tostring(self.name) .. " says, 'Say <b:cyan>continue</> when you want to hear more.'")
        actor:set_quest_var("megalith_quest", "vexpo", 1)
    elseif (actor:get_quest_var("megalith_quest:vexpo") or 0) == 1 then
        self:say("Shortly after I came of age, I heard a voice calling to me in my dreams.  It told me new Sisters were waiting for me, in need of my defense.")
        wait(4)
        self:say("I came upon several sisters of the coven besieged by the walking dead outside the graveyard near Anduin.  My added strength turned the tide of battle.")
        wait(5)
        self:say("They styled me \"Vityaz,\" meaning \"Hero\" in the old tongue of my people, and I have guarded them ever since.")
        wait(0.2)
        self.room:send(tostring(self.name) .. " says, 'Say <b:cyan>continue</> when you want to hear more.'")
        actor:set_quest_var("megalith_quest", "vexpo", 2)
    elseif (actor:get_quest_var("megalith_quest:vexpo") or 0) == 2 then
        self:say("To assist in the Great Rite of Invocation, in my duty as defender, I am casting and reinforcing a circle of protection between these smaller menhir.")
        wait(4)
        self:say("I will maintain it throughout the rite.")
        actor:set_quest_var("megalith_quest", "vexpo", 0)
    end
end$trig$, ARRAY['88f83ec8fcef74ea35f6e62d9fe90ef4', 'a68d7f671f9f892338bb003c1801ef02', 'ba9152e693fc4552ba7ff05c85648aea']),
  -- data/triggers/185/185_21_group_heal_room_search.lua
  (185, 21, $trig$if not (cmd == "search") then
    return true
end

if arg == "s" or arg == "se" then
    return true
end

if actor:get_quest_stage("group_heal") == 3 and actor:get_quest_var("group_heal:room") == require("dg").to_vnum(self.zone_id, self.id) then
    self.room:spawn_object(185, 14)
    self.room:send_except(actor, tostring(actor.name) .. " finds " .. tostring(objects.template(185, 14).name) .. "!")
    actor:send("<blue>You have found " .. tostring(objects.template(185, 14).name) .. "!</>")
    actor:advance_quest("group_heal")
end
return true$trig$, ARRAY['6b4555a378d1f39781a490d0567a63c4', 'f0d544e853d9f927624c4d889b38465b', 'b13d311345cd6604c4f3aa3b9f399d3d']),
  -- data/triggers/188/188_01_teleport_to_clanhall.lua
  (188, 1, $trig$-- Converted from DG Script #18801: Teleport_to_clanhall
-- Original: OBJECT trigger, flags: COMMAND, probability: 1%

-- Command location mask 1: legacy OCMD_EQUIP=1 (worn), OCMD_INVEN=2 (carried), OCMD_ROOM=4 (floor)
if not (location == "equip") then
    return true  -- Not in a location this trigger watches
end

-- Command filter: sneak
if not (cmd == "sneak") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
if arg == "out" then
    if not (actor.room.zone_id == 188 and actor.room.local_id == 0) then
        _return_value = false
        self.room:send_except(actor, tostring(actor.name) .. " ducks quietly out of the room.")
        actor:send("Glancing around, you duck quietly out of the room.")
        actor:teleport(get_room(188, 0))
        self.room:send_except(actor, tostring(actor.name) .. " suddenly fades into existance, walking in from the east.")
        actor:command("look")
    else
        _return_value = true
    end
else
    _return_value = true
end
return _return_value$trig$, ARRAY['f7d55b25f2359569cc6d37accb376d7a', 'bcc6e9a811d9b4bb1faf41b900d4a908', '908f9277d5784982cf21c47970343754']),
  -- data/triggers/484/484_20_wild-hunt_death.lua
  (484, 20, $trig$-- Converted from DG Script #48420: wild-hunt death
-- Original: MOB trigger, flags: GLOBAL, DEATH, probability: 100%
-- The 55214 branch (a normal deer) puts two more deer in random rooms of zone 552 through
-- get_room(552, 11..92) + room:at (legacy `at 55211..55292`).
local _return_value = true  -- Default: allow action
-- If this deer is the white hart, load the spirit of the white
-- hart who runs away from the questor.
-- If this deer is normal, load two more deer.
-- If this deer is the spirit of the white hart, load the antlers.
if (self.zone_id == 552 and self.id == 44) then
    if actor:get_quest_stage("doom_entrance") == 1 then
        _return_value = true
        self.room:send("The spirit of the white hart breaks from the body and scampers off!")
        self.room:spawn_mobile(552, 45)
    end
elseif (self.zone_id == 552 and self.id == 14) then
    if actor:get_quest_stage("doom_entrance") == 1 then
        -- Two more deer, each in a random room of 552:11-92 (legacy rooms 55211-55292).
        for _ = 1, 2 do
            local room = get_room(552, random(11, 92))
            if room then
                room:at(function()
                    self.room:spawn_mobile(552, 14)
                end)
            end
        end
    end
elseif (self.zone_id == 552 and self.id == 45) then
    local i = actor.group_size
    local a
    if i then
        a = 1
    else
        a = 0
    end
    local load_obj
    while i >= a do
        local person = actor.group_member[a]
        if person.room == self.room then
            if person:get_quest_stage("doom_entrance") == 1 then
                person:advance_quest("doom_entrance")
                person:send("<b:white>You have advanced the quest!</>")
                load_obj = "yes"
            end
        elseif person then
            i = i + 1
        end
        a = a + 1
    end
    if load_obj == "yes" then
        self.room:spawn_object(484, 29)
    end
end
return _return_value$trig$, ARRAY['fa1a2c5a72b878e55181f5430dbfba6d', 'c1ce0a0d1e67035c1219c9fe53240d62', '10e79dff183c07a76cd2e93702fb62e5']),
  -- data/triggers/484/484_23_vial-drop.lua
  (484, 23, $trig$-- Converted from DG Script #48423: vial-drop
-- Original: OBJECT trigger, flags: DROP, probability: 100%
local _return_value = true  -- Default: allow action
_return_value = true
if actor:get_quest_stage("doom_entrance") == 5 then
    if (actor.room.zone_id == 237 and actor.room.local_id == 31) then
        self.room:send("The vial of sunlight <b:white>flares brightly!</>")
        wait(2)
        self.room:send("<b:yellow>Sunlight fills the darkened cavern and voices cry out in pain!</>")
        local person = actor
        local i = person.group_size
        local a
        if i then
            a = 1
        else
            a = 0
        end
        while i >= a do
            local person = actor.group_member[a]
            if person.room == self.room then
                if person:get_quest_stage("doom_entrance") == 5 then
                    person:advance_quest("doom_entrance")
                    person:send("<b:white>You have advanced the quest!</>")
                end
            elseif person then
                i = i + 1
            end
            a = a + 1
        end
        self.room:send("<b:black>The vial dissolves in a flash of light.</>")
        world.destroy(self)
    else
        self.room:send("Dropping the vial here would have no effect!")
    end
end
return _return_value$trig$, ARRAY['fb07d6cc931657f498e616d3144bc778', '67bd91d23994561c3c5d62427618d211', '7ed171389025682e1f1595d6472c5c06']),
  -- data/triggers/488/488_53_unused.lua
  (488, 53, $trig$do return true end
-- This trigger is now handled in 48806
if not tank then
    return _return_value
end
for _, person in ipairs(self:get_people()) do
    if string.find(tank, "person.name") then
        local damage
        if person.is_player then
            damage = 390 + random(1, 40)
        else
            -- If a mob is tanking, hit it for massive damage!
            damage = 1000 + random(1, 200)
        end
        -- Halve damage for sanc
        if person:has_effect(Effect.Sanctuary) then
            damage = damage / 2
        end
        self.room:send_except(person, "Lightning crackles around the Stormchild as she points a finger at " .. tostring(person.name) .. ".")
        person:send("Lightning crackles around the Stormchild as she points a finger at you!")
        wait(2)
        if person and ((person.room.zone_id == 488 and person.room.local_id == 51)) then
            local damage_dealt = person:damage(damage)  -- type: shock
            person:send("The lightning overloads, flowing into a shocking blast flowing straight for you!")
            self.room:send_except(person, "The lightning overloads, flowing into a shocking blast flowing straight for " .. tostring(person.name) .. "!")
            if damage_dealt == 0 then
                self.room:send_except(person, "<blue>The blast passes right through " .. tostring(person.name) .. "'s chest!</>")
                person:send("<blue>The blast goes right through you, striking the wall!</>")
            else
                self.room:send_except(person, "<blue>The blast strikes " .. tostring(person.name) .. " in the chest, throwing " .. tostring(person.object) .. " into the wall!</> (<blue>" .. tostring(damage_dealt) .. "</>)")
                person:send("<blue>The blast strikes you square in the chest, throwing you into the wall!</> (<b:red>" .. tostring(damage_dealt) .. "</>)")
            end
        else
            self.room:send("The lightning fizzles out around the Stormchild.")
        end
        tank = nil
        return _return_value
    end
end$trig$, ARRAY['da3718ecedebaa92d83f7acd1fd3ea61', 'ee33137be1430b311bfc3335c3602205', '31aac28e925d547fca8f51f9a803bf4e']),
  -- data/triggers/534/534_55_major_globe_command_search.lua
  (534, 55, $trig$-- Converted from DG Script #53455: major_globe_command_search
-- Original: WORLD trigger, flags: GLOBAL, COMMAND, probability: 100%

-- Command filter: search
if not (cmd == "search") then
    return true  -- Not our command
end
-- 534_65 stores the target room as a legacy vnum (zone * 100 + id) in `major_globe_spell:room`;
-- the room handle is turned into that number to compare.
if (actor:get_quest_stage("major_globe_spell") == 6) and (actor:get_quest_var("major_globe_spell:room") == require("dg").to_vnum(actor.room.zone_id, actor.room.local_id)) then
    self.room:spawn_object(534, 52)
    self.room:send_except(actor, tostring(actor.name) .. " finds " .. tostring(objects.template(534, 52).name) .. "!")
    actor:send("<blue>You have found " .. tostring(objects.template(534, 52).name) .. "!</>")
    actor:advance_quest("major_globe_spell")
end
return true$trig$, ARRAY['e2fed44368d4abce8c14ba3225de7c68', '8a91fd9f7361ff2bbe40109b4bf128f3', 'f904129f23adcb0bfd8a11bf6ba4c630'])
) AS v(zone_id, id, commands, old_md5s)
WHERE t.zone_id = v.zone_id
  AND t.id = v.id
  AND md5(t.commands) = ANY (v.old_md5s)
  AND t.commands IS DISTINCT FROM v.commands;

-- New LEAVE triggers on the zone 60 games (F6): a player who walks out of the room forfeits
-- ConnectFour (60:84, on the board 60:60) or calls off Hearts (60:85, on the table 60:75) at
-- once instead of at the next game command. Rerunning inserts nothing.

INSERT INTO "Triggers" ("zone_id", "id", "name", "attachType", "num_args", "arg_list", "commands", "flags", "updated_at")
VALUES (60, 84, 'connectfour leave', 'OBJECT', 0, ARRAY[]::text[], $trig$local connectfour = require("connectfour")
return connectfour.leave(globals, self.room, actor)$trig$, ARRAY['LEAVE']::"TriggerFlag"[], now())
ON CONFLICT ("zone_id", "id") DO NOTHING;

INSERT INTO "Triggers" ("zone_id", "id", "name", "attachType", "num_args", "arg_list", "commands", "flags", "updated_at")
VALUES (60, 85, 'hearts leave', 'OBJECT', 0, ARRAY[]::text[], $trig$local hearts = require("hearts")
return hearts.leave(globals, self.room, actor)$trig$, ARRAY['LEAVE']::"TriggerFlag"[], now())
ON CONFLICT ("zone_id", "id") DO NOTHING;

-- Board instances already lying in the world keep the triggers they were spawned with, so the
-- LEAVE triggers reach a board or table the next time it spawns (the zone60-game-resets patch
-- places them; that needs the next restart anyway).
INSERT INTO "ObjectTriggers" ("object_zone_id", "object_id", "trigger_zone_id", "trigger_id")
SELECT v.oz, v.oid, 60, v.tid
FROM (VALUES (60, 60, 84), (60, 75, 85)) AS v(oz, oid, tid)
WHERE EXISTS (SELECT 1 FROM "Objects" WHERE "zone_id" = v.oz AND "id" = v.oid)
  AND EXISTS (SELECT 1 FROM "Triggers" WHERE "zone_id" = 60 AND "id" = v.tid)
ON CONFLICT DO NOTHING;

-- The script libraries behind the games (data/script_libraries/connectfour.lua and hearts.lua, the
-- bodies `fierylib seed script-libraries` would write): coloured glyphs, `start <game>`, leave
-- handling. Guarded: a library is only rewritten while it still holds the previous committed file
-- (md5 of its code), and rerunning rewrites nothing.
INSERT INTO "ScriptLibrary" ("name", "zone_id", "description", "code", "updated_at")
VALUES ('connectfour', 60, 'Connect Four rules for the zone 60 board (triggers 60:61-72).', $lib$--
-- The board object's triggers (start, select, look, drop, reset, forfeit,
-- rules) each call one function here; the game itself lives in the board's
-- `globals.cf` table, so it is per board and ends when the board despawns.
--
--   local cf = require("connectfour")
--   return cf.drop(globals, self.room, actor, arg)
--
-- Every command function returns true when the command should carry on to
-- the normal handler ("not my command") and false when it was consumed, the
-- same convention as a COMMAND trigger's return value.
--
-- State (globals.cf): status 0 setting up, 1 playing, 2 over; p1, p2 are the
-- players' names; p1col, p2col are "red" or "black"; turn is 1 or 2; board
-- is 7 rows (1 = top) of 7 cells, each 0 (empty), 1 or 2 (a player's piece).
-- Only plain data is stored, never actor handles.
--
-- Ported from DG scripts #6061-#6072, which kept 49 board cells in globals
-- and tested rows with string searches. The rules are the same: four in a
-- line wins, vertically, horizontally or diagonally. Additions: a full board
-- is a draw, and a player who leaves the room forfeits (as the rules text
-- always said).

local M = {}

local ROWS, COLS, WIN = 7, 7, 4

-- Each colour has its own glyph so the board reads without ANSI colour too
-- (logs, screen readers, bold black on a dark terminal): red is X, black
-- is O, an empty cell is a dot.
local EMPTY = "."
local COLOUR = {
    red = { cell = "<b:red>X</>", word = "<b:red>red</>" },
    black = { cell = "<b:black>O</>", word = "<b:black>black</>" },
}

-- What to type after `start` to pick this game when a Hearts table (60:75)
-- shares the room.
local KEYWORDS = {
    connectfour = true, ["connect-four"] = true, connect = true,
    four = true, c4 = true, board = true,
}

local RULES = {
    "Playing Connect Four is simple!  Your goal is simply to get four of",
    "your pieces in a line before your opponent.  The pieces can be",
    "horizontal, vertical, or even diagonal.",
    "</>",
    "To begin a game, you and a friend must type 'start' in the room with",
    "the game.  Whoever starts first gets to select their color, red or",
    "black, with 'select red' or 'select black'.  The second player",
    "automatically gets the other color.  If you type 'start' first, you",
    "also get the first turn.  If the room has a Hearts table as well, type",
    "'start connectfour' so the board knows you mean it.",
    "</>",
    "At any time, you can 'look board' to see what the board looks like.",
    "</>",
    "On your turn, you can 'drop' a piece into one of the 7 columns.  For",
    "instance, if you want to drop a piece in the third column, you'd type",
    "'drop 3'.  The piece will then fall down to the bottom of the third",
    "column.  If the column is full, you'll have to pick another one.",
    "</>",
    "During the game, you may use the 'forfeit' command to end the game.",
    "If you leave the room, you automatically forfeit.",
    "</>",
    "Once a game is over, either by someone winning or forfeiture, anyone",
    "in the room can use the 'reset' command to clear the board to start a",
    "new game.",
}

local function blank_board()
    local board = {}
    for r = 1, ROWS do
        board[r] = {}
        for c = 1, COLS do board[r][c] = 0 end
    end
    return board
end

function M.new()
    return { status = 0, turn = 0, board = blank_board() }
end

-- The game stored in `globals`, created on first use.
function M.state(globals)
    if type(globals.cf) ~= "table" then globals.cf = M.new() end
    return globals.cf
end

-- Empty the game in place.
local function clear(g)
    for k in pairs(g) do g[k] = nil end
    for k, v in pairs(M.new()) do g[k] = v end
end

-- Drop a piece for player `who` (1 or 2) into column `col`. Returns the row
-- it landed in, or nil when the column is full.
function M.drop_piece(board, col, who)
    for r = ROWS, 1, -1 do
        if board[r][col] == 0 then
            board[r][col] = who
            return r
        end
    end
    return nil
end

-- True when `who` has four pieces in a line anywhere on the board.
function M.has_four(board, who)
    local dirs = { { 0, 1 }, { 1, 0 }, { 1, 1 }, { 1, -1 } }
    for r = 1, ROWS do
        for c = 1, COLS do
            for _, d in ipairs(dirs) do
                local n = 0
                while n < WIN do
                    local row = board[r + d[1] * n]
                    if not row or row[c + d[2] * n] ~= who then break end
                    n = n + 1
                end
                if n == WIN then return true end
            end
        end
    end
    return false
end

function M.is_full(board)
    for c = 1, COLS do
        if board[1][c] == 0 then return false end
    end
    return true
end

-- The lines of the board as drawn for `look board`.
function M.render(g)
    local border = "<blue>+-+-+-+-+-+-+-+</>"
    local lines = {
        "<blue> Connect Four!</>",
        "</>",
        border,
        "<blue>|1|2|3|4|5|6|7|</>",
        border,
    }
    for r = 1, ROWS do
        local cells = {}
        for c = 1, COLS do
            local v = g.board[r][c]
            local col = (v == 1 and g.p1col) or (v == 2 and g.p2col)
            cells[c] = col and COLOUR[col].cell or EMPTY
        end
        lines[#lines + 1] = "<blue>|" .. table.concat(cells, "<blue>|")
            .. "<blue>|</>"
        lines[#lines + 1] = border
    end
    lines[#lines + 1] = "<b:red>X</> is red, <b:black>O</> is black."
    lines[#lines + 1] = "</>"
    return lines
end

-- Who `name` is in this game: 1, 2 or nil.
local function seat(g, name)
    if g.p1 == name then return 1 end
    if g.p2 == name then return 2 end
    return nil
end

local function present(room, name)
    for _, a in ipairs(room.actors) do
        if a.name == name then return a end
    end
    return nil
end

-- Message the named player wherever they stand in the room.
local function tell(room, name, msg)
    local a = name and present(room, name)
    if a then a:send(msg) end
end

-- DG oechoaround: everyone in the room except the named player.
local function around(room, name, msg)
    local a = present(room, name)
    if a then room:send_except(a, msg) else room:send(msg) end
end

local function colour_word(g, who)
    local col = (who == 1) and g.p1col or g.p2col
    return col and COLOUR[col].word
end

local function trim(s) return s:match("^%s*(.-)%s*$") end

-- A player who left the room before the game started loses their seat; one
-- who left mid-game forfeits.
local function settle(g, room)
    if g.status == 1 then
        for who = 1, 2 do
            local name = (who == 1) and g.p1 or g.p2
            if not present(room, name) then
                g.forfeit = who
                g.status = 2
                room:send(name .. " left the room and forfeits the game.")
                return
            end
        end
    elseif g.status == 0 then
        if g.p1 and not present(room, g.p1) then
            clear(g)
        elseif g.p2 and not present(room, g.p2) then
            g.p2 = nil
        end
    end
end

-- Wrap a command so it runs against the stored game and writes it back.
local function command(fn)
    return function(globals, room, actor, arg)
        local g = M.state(globals)
        settle(g, room)
        local pass = fn(g, room, actor, trim(string.lower(arg or "")))
        globals.cf = g
        return pass
    end
end

local start_game = command(function(g, room, actor)
    if g.p1 then
        if g.p2 then
            if g.status == 2 then
                actor:send("That game is over.  Type 'reset' to clear "
                    .. "the board.")
            else
                actor:send(g.p1 .. " and " .. g.p2
                    .. " are already playing ConnectFour!")
            end
        elseif actor.name == g.p1 then
            actor:send("You're already in the game!")
        else
            room:send_except(actor, actor.name
                .. " joins the ConnectFour game as player 2.")
            actor:send("You are now joining the ConnectFour game!")
            g.p2 = actor.name
            if g.p2col then
                local word = colour_word(g, 2)
                actor:send("You are the " .. word .. " pieces!")
                room:send_except(actor, actor.name .. " gets the " .. word
                    .. " pieces.")
                tell(room, g.p1, "You get to go first!")
                g.status = 1
                g.turn = 1
            end
        end
    else
        room:send_except(actor, actor.name
            .. " starts a new ConnectFour game as player 1.")
        actor:send("Alright!  Starting new ConnectFour game.  "
            .. "You are player 1.")
        actor:send("Do you want to be red or black?  "
            .. "Use the select command to choose.")
        g.p1 = actor.name
    end
    return false
end)

-- `start` joins this game. With a Hearts table in the room too, `start
-- connectfour` picks this one, `start hearts` is left to the table, and a bare
-- `start` asks which. Alone in the room, a bare `start` just works.
function M.start(globals, room, actor, arg)
    local words = trim(string.lower(arg or ""))
    if words ~= "" then
        for word in words:gmatch("%S+") do
            if KEYWORDS[word] then
                return start_game(globals, room, actor, arg)
            end
        end
        return true
    end
    if room:get_objects(60, 75) then
        actor:send("Start which game?  Type 'start connectfour' or "
            .. "'start hearts'.")
        return false
    end
    return start_game(globals, room, actor, arg)
end

M.select = command(function(g, room, actor, arg)
    if g.status ~= 0 or g.p1 ~= actor.name then return true end
    if arg ~= "red" and arg ~= "black" then
        actor:send("You may only select 'red' or 'black'.")
        return false
    end
    local other = (arg == "red") and "black" or "red"
    g.p1col, g.p2col = arg, other
    actor:send("You are the " .. COLOUR[arg].word .. " pieces!")
    room:send_except(actor, actor.name .. " chooses to play with the "
        .. COLOUR[arg].word .. " pieces!")
    if g.p2 then
        tell(room, g.p2, "You are the " .. COLOUR[other].word .. " pieces!")
        around(room, g.p2, g.p2 .. " gets the " .. COLOUR[other].word
            .. " pieces.")
        actor:send("You get to go first!")
        g.status = 1
        g.turn = 1
    end
    return false
end)

M.drop = command(function(g, room, actor, arg)
    local me = seat(g, actor.name)
    if not me then return true end
    local col = tonumber(arg)
    -- `drop sword` is an ordinary drop; only a column (or nothing) is ours
    if arg ~= "" and not col then return true end
    if g.status == 0 then
        actor:send("The game hasn't started yet!")
        return false
    elseif g.status == 2 then
        actor:send("The game is already over!")
        return false
    elseif g.turn ~= me then
        actor:send("It's not your turn!")
        return false
    end
    if not col or col < 1 or col > COLS or col ~= math.floor(col) then
        actor:send("Drop a piece in where!?")
        return false
    end
    if not M.drop_piece(g.board, col, me) then
        actor:send("Column " .. arg .. " is full!  Try a different one.")
        return false
    end
    actor:send("You drop a piece in column " .. arg .. ".")
    room:send_except(actor, actor.name .. " drops a piece in column "
        .. arg .. ".")
    if M.has_four(g.board, me) then
        actor:send("You win!")
        room:send_except(actor, actor.name .. " wins!")
        g.winner = me
        g.status = 2
    elseif M.is_full(g.board) then
        room:send("The board is full: the game is a draw!")
        g.draw = true
        g.status = 2
    end
    g.turn = (me == 1) and 2 or 1
    return false
end)

M.forfeit = command(function(g, room, actor, arg)
    local me = seat(g, actor.name)
    if g.status == 0 or not g.p1 or not g.p2 then
        actor:send("But the game hasn't even started yet!")
    elseif not me then
        actor:send("You can't forfeit a game you're not even playing!")
    elseif g.status == 2 then
        actor:send("But the game's already over!")
    elseif arg == "yes" then
        actor:send("You forfeit the game!")
        room:send_except(actor, actor.name .. " forfeits the game!")
        g.forfeit = me
        g.status = 2
    else
        actor:send("Are you absolutely sure you want to forfeit?  "
            .. "If so, type 'forfeit yes'.")
    end
    return false
end)

M.reset = command(function(g, room, actor)
    local me = seat(g, actor.name)
    if g.status == 2 then
        room:send("Resetting ConnectFour.")
        clear(g)
        room:send("Board cleared.")
    elseif g.status == 1 then
        if me then
            actor:send("If you want to end the game, forfeit first, "
                .. "then reset.")
        else
            actor:send("Wait until " .. g.p1 .. " and " .. g.p2
                .. " are done playing!")
        end
    elseif me == 1 then
        actor:send("You can't reset the board until the game is over.")
    else
        actor:send("The board is already cleared!")
    end
    return false
end)

M.rules = function(globals, room, actor)
    for _, line in ipairs(RULES) do actor:send(line) end
    return false
end

-- Who is playing and whose turn it is, from `viewer`'s point of view.
local function status_lines(g, room, viewer)
    local out = {}
    local function add(s) out[#out + 1] = s end
    local p1, p2 = g.p1, g.p2
    local d1, d2 = colour_word(g, 1), colour_word(g, 2)
    if g.status == 0 then
        if not p1 then return out end
        if p2 then
            if viewer == p1 then
                add("You and " .. p2 .. " are getting ready to start a game!")
                add("You need to choose a color!  Type 'select red' or "
                    .. "'select black'.")
            elseif viewer == p2 then
                add("You and " .. p1 .. " are getting ready to start a game!")
                add("We are waiting for " .. p1 .. " to choose a color.")
            else
                add(p1 .. " and " .. p2
                    .. " are getting ready to start a game.")
            end
        elseif viewer == p1 then
            add("You are waiting for someone to join you.")
            if d1 then
                add("You are playing as " .. d1 .. ".")
            else
                add("You need to choose a color!  Type 'select red' or "
                    .. "'select black'.")
            end
        else
            local a = present(room, p1)
            add(p1 .. " is waiting for someone to join "
                .. (a and a.objective or "them") .. ".")
            if d1 then add(p1 .. " is playing as " .. d1 .. ".") end
        end
    elseif g.status == 1 then
        if viewer == p1 or viewer == p2 then
            local me, you = p1, p2
            local mine, yours, mynum = d1, d2, 1
            if viewer == p2 then
                me, you, mine, yours, mynum = p2, p1, d2, d1, 2
            end
            add("You and " .. you .. " are playing.")
            add("You are " .. mine .. " and " .. you .. " is " .. yours .. ".")
            if g.turn == mynum then
                add("It's your turn!")
            else
                add("It's " .. you .. "'s turn.")
            end
        else
            add(p1 .. " and " .. p2 .. " are playing.")
            add(p1 .. " is " .. d1 .. " and " .. p2 .. " is " .. d2 .. ".")
            add("It's " .. (g.turn == 1 and p1 or p2) .. "'s turn.")
        end
    elseif g.status == 2 then
        if viewer == p1 then
            add("You and " .. p2 .. " were playing.")
        elseif viewer == p2 then
            add("You and " .. p1 .. " were playing.")
        else
            add(p1 .. " and " .. p2 .. " were playing.")
        end
        local names = { p1, p2 }
        if g.winner then
            add(viewer == names[g.winner] and "You won the game!"
                or names[g.winner] .. " won the game.")
        elseif g.forfeit then
            add(viewer == names[g.forfeit] and "You forfeited the game."
                or names[g.forfeit] .. " forfeited the game.")
        elseif g.draw then
            add("The game ended in a draw.")
        else
            add("The game is over.")
        end
    end
    return out
end

M.look = command(function(g, room, actor, arg)
    if arg ~= "board" and arg ~= "connectfour" and arg ~= "game" then
        return true
    end
    for _, line in ipairs(M.render(g)) do actor:send(line) end
    for _, line in ipairs(status_lines(g, room, actor.name)) do
        actor:send(line)
    end
    return false
end)

-- A LEAVE trigger on the board: `actor` is walking out and is still in the
-- room, so settle their seat by name at once instead of at the next game
-- command. Always lets them go. (Leaving by other means, such as a teleport,
-- is still settled lazily by `settle`.)
function M.leave(globals, room, actor)
    local g = M.state(globals)
    local me = seat(g, actor.name)
    if me and g.status == 1 then
        g.forfeit = me
        g.status = 2
        room:send(actor.name .. " left the room and forfeits the game.")
    elseif me and g.status == 0 then
        if me == 1 then clear(g) else g.p2 = nil end
    end
    globals.cf = g
    return true
end

return M
$lib$, now())
ON CONFLICT ("name") DO UPDATE
SET "zone_id" = EXCLUDED."zone_id",
    "description" = EXCLUDED."description",
    "code" = EXCLUDED."code",
    "updated_at" = now()
WHERE "ScriptLibrary"."code" IS DISTINCT FROM EXCLUDED."code"
  AND md5("ScriptLibrary"."code") = '6395ac23ed4dcefb94fca6bf37a47629';

INSERT INTO "ScriptLibrary" ("name", "zone_id", "description", "code", "updated_at")
VALUES ('hearts', 60, 'Hearts card game rules for the zone 60 table (60:75-83).', $lib$--
-- The table object's triggers (start, deal, hand, look, play, endgame) each
-- call one function here; the game itself lives in the table's
-- `globals.hearts`, so it is per table and ends when the table despawns.
--
--   local hearts = require("hearts")
--   return hearts.play(globals, self.room, actor, arg, random)
--
-- Every command function returns true when the command should carry on to
-- the normal handler ("not my command") and false when it was consumed, the
-- same convention as a COMMAND trigger's return value.
--
-- Cards are numbered 1-52 as in the DG scripts: suit = (card - 1) // 13
-- (0 clubs, 1 diamonds, 2 spades, 3 hearts), rank = (card - 1) % 13 + 1
-- (1 = Two ... 13 = Ace). Card 1, the Two of Clubs, leads the first trick.
--
-- State (globals.hearts), plain data only (no actor handles):
--   players  names in seat order (1-4)
--   status   0 gathering players, 1 four seated and ready to deal,
--            3 a hand is being played, 4 the hand is over (scored at once)
--   hands    hands[seat] = the cards still held, sorted
--   trick    cards on the table, in play order: { { card = 12, seat = 2 } }
--   taken    taken[seat] = cards that seat has won this hand
--   turn     seat to play; first_turn is true until the Two of Clubs is led
--   played   cards played this hand; totals[seat] = points over the game
--
-- Ported from DG scripts #6075-#6083. Rules as written there: follow suit
-- when you can, a trick goes to the highest card of the suit led, each heart
-- scores 1 and the Queen of Spades 13, taking all 26 points gives you 0 and
-- everyone else 26 ("shooting the moon"), and the game ends once someone is
-- over 99. There is no passing and hearts need not be broken. Changes: the
-- hand is scored when the last card is played, totals reset when a game
-- ends, and a table whose player has left the room is cleared.

local M = {}

local RANKS = {
    "Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine", "Ten",
    "Jack", "Queen", "King", "Ace",
}
local SUITS = { [0] = "Clubs", "Diamonds", "Spades", "Hearts" }
local HEARTS, QUEEN_OF_SPADES = 3, 37
local LIMIT = 99

function M.suit(card) return (card - 1) // 13 end
function M.rank(card) return (card - 1) % 13 + 1 end

function M.card_name(card)
    return RANKS[M.rank(card)] .. " of " .. SUITS[M.suit(card)]
end

-- Penalty points a card is worth in the score.
function M.points(card)
    if card == QUEEN_OF_SPADES then return 13 end
    if M.suit(card) == HEARTS then return 1 end
    return 0
end

function M.new()
    return {
        players = {}, status = 0, hands = {}, trick = {}, taken = {},
        turn = 0, first_turn = false, played = 0, totals = { 0, 0, 0, 0 },
    }
end

-- The game stored in `globals`, created on first use.
function M.state(globals)
    if type(globals.hearts) ~= "table" then globals.hearts = M.new() end
    return globals.hearts
end

local function clear(g)
    for k in pairs(g) do g[k] = nil end
    for k, v in pairs(M.new()) do g[k] = v end
end

local function seat_of(g, name)
    for i, p in ipairs(g.players) do
        if p == name then return i end
    end
    return nil
end

-- Shuffle with `rand(low, high)` (the engine's `random`) and give each seat
-- 13 cards. Sets the turn to whoever holds the Two of Clubs.
function M.deal_cards(g, rand)
    local deck = {}
    for i = 1, 52 do deck[i] = i end
    for i = 52, 2, -1 do
        local j = rand(1, i)
        deck[i], deck[j] = deck[j], deck[i]
    end
    g.hands, g.taken, g.trick = {}, {}, {}
    for seat = 1, 4 do
        local hand = {}
        for i = 1, 13 do hand[i] = deck[(seat - 1) * 13 + i] end
        table.sort(hand)
        g.hands[seat] = hand
        g.taken[seat] = {}
        if hand[1] == 1 then g.turn = seat end
    end
    g.first_turn = true
    g.played = 0
    g.status = 3
end

local function has_suit(hand, suit)
    for _, c in ipairs(hand) do
        if M.suit(c) == suit then return true end
    end
    return false
end

-- Can `seat` play hand position `index`? Returns the card, or nil and the
-- message to show.
function M.check_play(g, seat, index)
    local hand = g.hands[seat]
    if g.first_turn and index ~= 1 then
        return nil, "You must start the game by playing the "
            .. M.card_name(1) .. "!"
    end
    local card = hand[index]
    if not card then return nil, "You don't have that many cards!" end
    local lead = g.trick[1] and M.suit(g.trick[1].card)
    if lead and M.suit(card) ~= lead and has_suit(hand, lead) then
        return nil, "You must follow suit!"
    end
    return card
end

-- Seat that wins a full trick: the highest card of the suit that was led.
function M.trick_winner(trick)
    local lead = M.suit(trick[1].card)
    local best = trick[1]
    for i = 2, #trick do
        local t = trick[i]
        if M.suit(t.card) == lead and M.rank(t.card) > M.rank(best.card) then
            best = t
        end
    end
    return best.seat
end

-- Points each seat took this hand, after the shooting-the-moon rule.
-- Returns the four scores and the seat that shot the moon (or nil).
function M.hand_scores(g)
    local scores, moon = {}, nil
    for seat = 1, 4 do
        local sum = 0
        for _, c in ipairs(g.taken[seat]) do sum = sum + M.points(c) end
        scores[seat] = sum
        if sum == 26 then moon = seat end
    end
    if moon then
        for seat = 1, 4 do scores[seat] = (seat == moon) and 0 or 26 end
    end
    return scores, moon
end

local function present(room, name)
    for _, a in ipairs(room.actors) do
        if a.name == name then return a end
    end
    return nil
end

local function tell(room, name, msg)
    local a = present(room, name)
    if a then a:send(msg) end
end

-- DG oechoaround: everyone in the room except the named player.
local function around(room, name, msg)
    local a = present(room, name)
    if a then room:send_except(a, msg) else room:send(msg) end
end

-- Score the finished hand, report it, and either ready the next deal or
-- end the game.
function M.finish_hand(g, room)
    local names = g.players
    local scores, moon = M.hand_scores(g)
    if moon then
        for seat = 1, 4 do
            if seat == moon then
                tell(room, names[seat], "You took all the point cards!  "
                    .. "Everyone else gets 26 points.")
            else
                tell(room, names[seat], names[moon] .. " took all the "
                    .. "point cards, so you get 26 points.")
            end
        end
    end
    for seat = 1, 4 do
        g.totals[seat] = g.totals[seat] + scores[seat]
        tell(room, names[seat], "You scored " .. scores[seat]
            .. " points this round, bringing your total to "
            .. g.totals[seat] .. ".")
    end
    local over = false
    for seat = 1, 4 do
        if g.totals[seat] > LIMIT then over = true end
    end
    if not over then
        g.status = 1
        return
    end
    room:send("The game is over!")
    local low = 1
    for seat = 1, 4 do
        room:send(names[seat] .. " scored a total of " .. g.totals[seat]
            .. " points.")
        if g.totals[seat] < g.totals[low] then low = seat end
    end
    room:send(names[low] .. " has the lowest score and wins!")
    clear(g)
end

local function trim(s) return s:match("^%s*(.-)%s*$") end

-- What to type after `start` to pick this game when a ConnectFour board
-- (60:60) shares the room.
local KEYWORDS = {
    hearts = true, heart = true, ["hearts-table"] = true, table = true,
    cards = true,
}

-- Wrap a command so it runs against the stored game and writes it back.
local function command(fn)
    return function(globals, room, actor, arg, rand)
        local g = M.state(globals)
        for _, name in ipairs(g.players) do
            if not present(room, name) then
                room:send(name .. " has left the table; the Hearts game "
                    .. "is called off.")
                clear(g)
                break
            end
        end
        local pass = fn(g, room, actor, trim(string.lower(arg or "")), rand)
        globals.hearts = g
        return pass
    end
end

local start_game = command(function(g, room, actor)
    if g.status ~= 0 then
        actor:send("The game has already started.  "
            .. "You must wait for it to finish.")
        return false
    end
    local n = #g.players
    if seat_of(g, actor.name) then
        actor:send("You're already in the game!")
        return false
    end
    local seat = n + 1
    g.players[seat] = actor.name
    if seat == 1 then
        room:send_except(actor, actor.name
            .. " starts a new game of Hearts as player 1.")
        actor:send("Alright!  Starting a new game of Hearts.  "
            .. "You are player 1.")
        return false
    end
    room:send_except(actor, actor.name .. " joins the Hearts game as player "
        .. seat .. ".")
    actor:send("You are now joining the Hearts game as player " .. seat
        .. ".")
    if seat == 4 then
        for _, name in ipairs(g.players) do
            tell(room, name, "The cards are now ready to be dealt.")
        end
        g.status = 1
    end
    return false
end)

-- `start` takes a seat. With a ConnectFour board in the room too, `start
-- hearts` picks this table, `start connectfour` is left to the board, and a
-- bare `start` asks which. Alone in the room, a bare `start` just works.
function M.start(globals, room, actor, arg, rand)
    local words = trim(string.lower(arg or ""))
    if words ~= "" then
        for word in words:gmatch("%S+") do
            if KEYWORDS[word] then
                return start_game(globals, room, actor, arg, rand)
            end
        end
        return true
    end
    if room:get_objects(60, 60) then
        actor:send("Start which game?  Type 'start connectfour' or "
            .. "'start hearts'.")
        return false
    end
    return start_game(globals, room, actor, arg, rand)
end

M.deal = command(function(g, room, actor, arg, rand)
    local me = seat_of(g, actor.name)
    if #g.players < 4 then
        if not me then return true end
        actor:send("You can't deal until four people have joined!")
        return false
    end
    if not me then return true end
    if g.status > 1 then
        actor:send("Wait for this hand to end before dealing again!")
        return false
    end
    actor:send("You deal the cards across the table.")
    room:send_except(actor, actor.name
        .. " deals the cards, beginning a new round.")
    M.deal_cards(g, rand)
    tell(room, g.players[g.turn], "It's your turn first; you must play the "
        .. M.card_name(1) .. ".")
    return false
end)

M.hand = command(function(g, room, actor)
    local me = seat_of(g, actor.name)
    if not me then return true end
    if g.status < 2 then
        actor:send("The game hasn't started yet!  "
            .. "You don't have any cards.")
    elseif g.status > 3 then
        actor:send("The game is over already!")
    else
        actor:send("Your hand contains:")
        for i, card in ipairs(g.hands[me]) do
            actor:send("</> " .. i .. ". " .. M.card_name(card))
        end
    end
    return false
end)

M.look = command(function(g, room, actor, arg)
    if arg ~= "table" and arg ~= "hearts" then return true end
    if g.status < 3 then
        actor:send("The deck of cards is undealt.")
    elseif g.status > 3 then
        actor:send("The table is empty.")
    else
        if #g.trick == 0 then
            actor:send("No cards have been played yet this trick.")
        else
            actor:send("The following cards have been played this trick:")
            for _, t in ipairs(g.trick) do
                actor:send("</>  " .. M.card_name(t.card))
            end
            actor:send("The trick was led by the "
                .. M.card_name(g.trick[1].card) .. ".")
        end
        actor:send("It is " .. g.players[g.turn] .. "'s turn.")
    end
    return false
end)

M.play = command(function(g, room, actor, arg)
    local me = seat_of(g, actor.name)
    if not me then return true end
    if g.status < 3 then
        actor:send("The game hasn't started yet!")
        return false
    elseif g.status > 3 then
        actor:send("The game is over already!")
        return false
    elseif g.turn ~= me then
        actor:send("It's not your turn.")
        return false
    end
    local index = tonumber(arg)
    if not index or index < 1 or index > 13 or index ~= math.floor(index) then
        actor:send("Play what!?")
        return false
    end
    local card, err = M.check_play(g, me, index)
    if not card then
        actor:send(err)
        return false
    end
    table.remove(g.hands[me], index)
    g.trick[#g.trick + 1] = { card = card, seat = me }
    g.first_turn = false
    g.played = g.played + 1
    actor:send("You play the " .. M.card_name(card) .. ".")
    room:send_except(actor, actor.name .. " plays the " .. M.card_name(card)
        .. ".")
    g.turn = me % 4 + 1
    if #g.trick == 4 then
        local winner = M.trick_winner(g.trick)
        for _, t in ipairs(g.trick) do
            table.insert(g.taken[winner], t.card)
        end
        tell(room, g.players[winner], "You take the trick.")
        around(room, g.players[winner], g.players[winner]
            .. " takes the trick.")
        g.trick = {}
        g.turn = winner
    end
    if g.played == 52 then
        g.status = 4
        M.finish_hand(g, room)
        return false
    end
    local next_name = g.players[g.turn]
    tell(room, next_name, "It's now your turn.")
    around(room, next_name, "It's now " .. next_name .. "'s turn.")
    return false
end)

-- The DG `endgame` command scored a finished hand. play now scores it as
-- the last card falls, so this only matters if a hand is ever left at 4.
M.endgame = command(function(g, room, actor)
    if g.status ~= 4 then return true end
    M.finish_hand(g, room)
    return false
end)

-- A LEAVE trigger on the table: `actor` is walking out and is still in the
-- room, so a seated player calls the game off at once instead of at the next
-- game command. Always lets them go. (Leaving by other means, such as a
-- teleport, is still settled lazily by `command`.)
function M.leave(globals, room, actor)
    local g = M.state(globals)
    if seat_of(g, actor.name) then
        room:send(actor.name .. " has left the table; the Hearts game "
            .. "is called off.")
        clear(g)
    end
    globals.hearts = g
    return true
end

return M
$lib$, now())
ON CONFLICT ("name") DO UPDATE
SET "zone_id" = EXCLUDED."zone_id",
    "description" = EXCLUDED."description",
    "code" = EXCLUDED."code",
    "updated_at" = now()
WHERE "ScriptLibrary"."code" IS DISTINCT FROM EXCLUDED."code"
  AND md5("ScriptLibrary"."code") = '5750779b4bec01c08946e79af93e1b9c';

COMMIT;
