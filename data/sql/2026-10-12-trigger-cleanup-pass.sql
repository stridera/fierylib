-- Trigger cleanup pass: drop the converter's dead percent_chance(0) guard (speech phrases, receive arg-list exclusions) and turn same-zone vnum range comparisons into zone_id checks.
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
  -- data/triggers/002/002_120_phase_mace_dig_trigger.lua
  (2, 120, $trig$-- Command location mask 1: legacy OCMD_EQUIP=1 (worn), OCMD_INVEN=2 (carried), OCMD_ROOM=4 (floor)
if not (location == "equip") then
    return true  -- Not in a location this trigger watches
end

-- Command filter: dig (block "d" / "di" abbreviations)
if cmd == "d" or cmd == "di" then
    return true
end
if cmd ~= "dig" then
    return true
end
if actor:get_quest_stage("phase_mace") ~= 2 then
    return true
end
if actor:get_quest_var("phase_mace:graves") == "done" then
    actor:send("<b:yellow>You have already completed your pilgrimage.</>")
    return true
end
local room = actor.room
local dig, item, num
-- Graveyard*
if (room.zone_id == 470 or room.zone_id == 472) then
    dig, item, num = "yes", 22, 3
-- Cathedral*
elseif (room.zone_id == 85 and room.id >= 4 and room.id <= 9) then
    dig, item, num = "yes", 23, 4
-- Pyramid*
elseif (room.zone_id == 162) then
    dig, item, num = "yes", 24, 5
-- Barrow*
elseif (room.zone_id == 480) then
    dig, item, num = "yes", 25, 6
end
if dig == "yes" then
    actor:send("You dig up a handful of dirt.")
    self.room:spawn_object(185, item)
    actor:set_quest_var("phase_mace", "dirt" .. tostring(num), 1)
    actor:command("get dirt")
    local dirt3 = actor:get_quest_var("phase_mace:dirt3")
    local dirt4 = actor:get_quest_var("phase_mace:dirt4")
    local dirt5 = actor:get_quest_var("phase_mace:dirt5")
    local dirt6 = actor:get_quest_var("phase_mace:dirt6")
    if dirt3 and dirt4 and dirt5 and dirt6 then
        if not actor:get_quest_var("phase_mace:graves") then
            actor:send("<b:yellow>You have completed your pilgrimage.</>")
            actor:set_quest_var("phase_mace", "graves", "done")
        end
    end
else
    actor:send("This isn't the proper place to dig for grave dirt.")
end
return true$trig$, '9cd89095439f5d5407a3b335c5a782a5'),
  -- data/triggers/018/018_13_room_1888_-_cruel_teleportation.lua
  (18, 13, $trig$-- Converted from DG Script #1813: Room 1888 - Cruel teleportation
-- Original: MOB trigger, flags: SPEECH, probability: 0%

-- Speech phrase: submit (DG num_arg 0 = the speech contains the phrase, not a chance)
if not string.find(string.lower(speech), "submit", 1, true) then
    return true  -- Not the phrase
end
actor:command("forget all")
actor:send("You feel drained and disoriented.")
self.room:send_except(actor, tostring(actor.name) .. " fades from existence and disappears.")
local rm = random(1, 10)
-- switch on rm
if rm == 1 then
    actor:teleport(get_room(520, 70))
elseif rm == 2 then
    actor:teleport(get_room(480, 80))
elseif rm == 3 then
    actor:teleport(get_room(117, 134))
elseif rm == 4 then
    actor:teleport(get_room(117, 135))
elseif rm == 5 then
    actor:teleport(get_room(430, 144 + random(1, 13)))
elseif rm == 6 then
    actor:teleport(get_room(101, 0))
elseif rm == 7 then
    actor:teleport(get_room(551, 5))
elseif rm == 8 then
    actor:teleport(get_room(324, 189))
elseif rm == 9 then
    actor:teleport(get_room(127, 1))
    actor:teleport(get_room(520, 86))
end
self:command("force " .. tostring(actor.name) .. " look")$trig$, 'cec52fc7d9479cf493ce97dc1a706852'),
  -- data/triggers/018/018_28_blur_ranger_speech2.lua
  (18, 28, $trig$-- Converted from DG Script #1828: blur_ranger_speech2
-- Original: MOB trigger, flags: SPEECH, probability: 0%

-- Speech phrase: let's begin (DG num_arg 0 = the speech contains the phrase, not a chance)
if not string.find(string.lower(speech), "let's begin", 1, true) then
    return true  -- Not the phrase
end
actor:set_quest_var("blur", "east", 0)
actor:set_quest_var("blur", "west", 0)
actor:set_quest_var("blur", "south", 0)
actor:set_quest_var("blur", "north", 0)
if actor:get_quest_stage("blur") == 4 then
    wait(2)
    self:say("Ready...")
    wait(3)
    self:say("Set...")
    wait(3)
    self.room:send(tostring(self.name) .. " says, '<b:green>GO!!</>  Your time has begun!'")
    actor:set_quest_var("blur", "race", "go")
    self.room:send(tostring(self.name) .. " fades into the trees.")
    self:teleport(get_room(11, 0))
    local count = 1800
    actor:send("<b:white>24 hours (30:00 minutes) remain.</>")
    while count > 0 do
        if actor:get_has_completed("blur") then
            count = 0
        else
            actor:set_quest_var("blur", "timer", count)
            wait(25)
            count = count - 25
            if count == 900 then
                actor:send("<b:white>12 hours (15:00 minutes) remain.</>")
            elseif count == 450 then
                actor:send("<b:white>6 hours (7:30 minutes) remain.</>")
            elseif count == 300 then
                actor:send("<b:white>4 hours (5:00 minutes) remain.</>")
            elseif count == 150 then
                actor:send("<b:white>2 hours (2:30 minutes) remain.</>")
            elseif count == 75 then
                actor:send("<b:white>1 hour (1:15 minutes) remain.</>")
            elseif count == 0 then
                actor:send("<b:red>Time's up!!</>")
            end
        end
    end
    if not actor:get_has_completed("blur") then
        actor:fail_quest("blur")
        actor:set_quest_var("blur", "race", "off")
        actor:send(self.name .. " tells you, '" .. "You'll have to be a little quicker on your toes next time." .. "'")
        wait(2)
        actor:send(self.name .. " tells you, '" .. "'Come back to me if you want to try again.'" .. "'")
    end
end
world.destroy(self)$trig$, '8560d3a9dbc9df225cf2a82ce908f423'),
  -- data/triggers/022/022_29_reset_the_nine_hells_doors.lua
  (22, 29, $trig$-- Converted from DG Script #2229: RESET THE NINE HELLS DOORS
-- Original: WORLD trigger, flags: SPEECH, probability: 0%

-- Speech phrase: Restart the Nine Hells quest. (DG num_arg 0 = the speech contains the phrase, not a chance)
if not string.find(string.lower(speech), "restart the nine hells quest.", 1, true) then
    return true  -- Not the phrase
end
get_room(22, 1):exit("down"):set_state({hidden = true})
get_room(22, 10):exit("down"):set_state({hidden = true})
get_room(22, 11):exit("down"):set_state({hidden = true})
get_room(22, 12):exit("down"):set_state({hidden = true})
get_room(22, 13):exit("down"):set_state({hidden = true})
get_room(22, 14):exit("down"):set_state({hidden = true})
get_room(22, 15):exit("down"):set_state({hidden = true})
get_room(22, 16):exit("down"):set_state({hidden = true})
get_room(22, 17):exit("down"):set_state({hidden = true})
self.room:send("Doors reset.")$trig$, '8b3f42f74ad501cca1d9c5544f0bd43f'),
  -- data/triggers/022/022_32_start_the_nine_hells_quest.lua
  (22, 32, $trig$-- Converted from DG Script #2232: START THE NINE HELLS QUEST
-- Original: WORLD trigger, flags: SPEECH, probability: 0%

-- Speech phrase: Start the Nine Hells quest. (DG num_arg 0 = the speech contains the phrase, not a chance)
if not string.find(string.lower(speech), "start the nine hells quest.", 1, true) then
    return true  -- Not the phrase
end
get_room(22, 1):exit("down"):set_state({hidden = false})
get_room(22, 1):exit("down"):set_state({name = "hole"})
get_room(22, 1):exit("down"):set_state({description = "&1The hole in the earth seems to be a bottomless shaft, with the roiling flames of hell licking the edges.&0"})
get_room(22, 1):at(function()
    self.room:send("<red>The earth <yellow>heaves<red> and suddenly breaks open to reveal a <blue>fiery </><red>pit.</>")
end)
self.room:send("Quest started.")$trig$, '2d9be61915d302d7a5d7a4305386f5bc'),
  -- data/triggers/023/023_02_west-blessing.lua
  (23, 2, $trig$-- Speech phrase: I pray for a blessing from mother earth, creator of life and bringer of death (DG num_arg 0 = the speech contains the phrase, not a chance)
if not string.find(string.lower(speech), "i pray for a blessing from mother earth, creator of life and bringer of death", 1, true) then
    return true  -- Not the phrase
end
self.room:send("The &9<blue>stone monoliths</> begin to <b:cyan>glow</> with power.")
wait(4)
self.room:spawn_object(23, 33)
self.room:send("<green>The power seems to coalesce into a shining ball.</>")
wait(20)
self.room:purge()
self.room:send("The <green>shining ball</> dissapates back into nothingness.")
self.room:send("The &9<blue>stones</> stop glowing.")$trig$, '3e7c0c42d31ea02ab9bcedddd4cf2f06'),
  -- data/triggers/023/023_03_south-blessing.lua
  (23, 3, $trig$-- Speech phrase: I pray for a blessing from mother earth, creator of life and bringer of death (DG num_arg 0 = the speech contains the phrase, not a chance)
if not string.find(string.lower(speech), "i pray for a blessing from mother earth, creator of life and bringer of death", 1, true) then
    return true  -- Not the phrase
end
self.room:send("The &9<blue>stone monoliths</> begin to <b:cyan>glow</> with power.")
wait(4)
self.room:spawn_object(23, 31)
self.room:send("<b:white>The power seems to coalesce into a shining ball.</>")
wait(20)
self.room:purge()
self.room:send("The <b:white>shining ball</> dissapates back into nothingness.")
self.room:send("The &9<blue>stones</> stop glowing.")$trig$, '13caf1a6147690a0e32fa1e10dde5d54'),
  -- data/triggers/023/023_04_north-blessing.lua
  (23, 4, $trig$-- Speech phrase: I pray for a blessing from mother earth, creator of life and bringer of death (DG num_arg 0 = the speech contains the phrase, not a chance)
if not string.find(string.lower(speech), "i pray for a blessing from mother earth, creator of life and bringer of death", 1, true) then
    return true  -- Not the phrase
end
self.room:send("The &9<blue>stone monoliths</> begin to <b:cyan>glow</> with power.")
wait(4)
self.room:spawn_object(23, 32)
self.room:send("<green>The power seems to coalesce into a shining ball.</>")
wait(20)
self.room:purge()
self.room:send("The <green>shining ball</> dissapates back into nothingness.")
self.room:send("The &9<blue>stones</> stop glowing.")$trig$, '853d337fc12f3aee89d0c73969b422d5'),
  -- data/triggers/023/023_15_unused.lua
  (23, 15, $trig$local function maybe_drop_doom(person)
    if person.room ~= self.room then return end
    if person:get_quest_stage("creeping_doom") == 2
       or (person.level > 80 and (person.zone_id == 10 and person.id <= 38)) then
        if random(1, 50) <= self.level then
            self.room:spawn_object(615, 17)
        end
    end
end
if actor.group then
    for _, member in ipairs(actor.group) do
        maybe_drop_doom(member)
    end
else
    maybe_drop_doom(actor)
end
-- 
-- Death trigger for random gem and armor drops
-- 
-- set a random number to determine if a drop will
-- happen.
-- 
-- boss setup - 55580 boss_27
-- 
local bonus = random(1, 100)
local will_drop = random(1, 100)
-- 4 pieces of armor per sub_phase in phase_2
local what_armor_drop = random(1, 4)
-- 11 classes questing in phase_2
local what_gem_drop = random(1, 11)
-- 
if will_drop <= 20 then
    -- drop nothing and bail
    return true
end
if will_drop <= 60 then
    -- Normal non-bonus drops
    if bonus <= 50 then
        -- drop a gem from the previous wear pos set
        self.room:spawn_object(556, 4 + what_gem_drop)
    elseif bonus >= 51 and bonus <= 90 then
        -- We're in the Normal drops from current wear pos set
        -- drop a gem from the current wear pos set
        self.room:spawn_object(556, 15 + what_gem_drop)
    else
        -- We're in the BONUS ROUND!!
        -- drop a gem from the next wear pos set
        self.room:spawn_object(556, 26 + what_gem_drop)
    end
elseif will_drop >= 61 and will_drop <= 80 then
    -- Normal non-bonus drops
    if bonus <= 50 then
        -- drop destroyed armor 55299 is the ID before the
        -- first piece of armor.
        self.room:spawn_object(553, 31 + what_armor_drop)
    elseif bonus >= 51 and bonus <= 90 then
        -- We're in the Normal drops from current wear pos set
        -- drop armor from the current wear pos set
        self.room:spawn_object(553, 35 + what_armor_drop)
    else
        -- We're in the BONUS ROUND!!
        -- drop a piece of armor from next wear pos
        self.room:spawn_object(553, 39 + what_armor_drop)
    end
else
    -- Normal non-bonus drops
    if bonus <= 50 then
        -- drop armor and gem from previous wear pos
        self.room:spawn_object(556, 4 + what_gem_drop)
        self.room:spawn_object(553, 31 + what_armor_drop)
    elseif bonus >= 51 and bonus <= 90 then
        -- We're in the Normal drops from current wear pos set
        -- drop a gem and armor from the current wear pos set
        self.room:spawn_object(553, 35 + what_armor_drop)
        self.room:spawn_object(556, 15 + what_gem_drop)
    else
        -- We're in the BONUS ROUND!!
        -- drop armor and gem from next wear pos
        self.room:spawn_object(556, 26 + what_gem_drop)
        self.room:spawn_object(556, 39 + what_armor_drop)
    end
end$trig$, '0aca6b35432bc4ffc5d12751c4bda454'),
  -- data/triggers/030/030_35_magistrate_refuse.lua
  (30, 35, $trig$-- Converted from DG Script #3035: Magistrate refuse
-- Original: MOB trigger, flags: RECEIVE, probability: 0%

-- DG receive trigger, num_arg 0: the arg list (55211 55577 13614 58809 16023 340) holds the items
-- other triggers handle; this one runs for every other item. The runtime does not filter on
-- arg_list, so the exclusion lives here. (The converter's percent_chance(0) guard blocked it all.)
if (object.zone_id == 552 and object.id == 11)
    or (object.zone_id == 555 and object.id == 77)
    or (object.zone_id == 136 and object.id == 14)
    or (object.zone_id == 588 and object.id == 9)
    or (object.zone_id == 160 and object.id == 23)
    or (object.zone_id == 2 and object.id == 140) then
    return true
end
-- switch on objet.id
wait(1)
self:say("Thanks!")$trig$, '0afa54adecee60f2a8c519b0bbd464d5'),
  -- data/triggers/030/030_53_armor_exchange_receive_exchange.lua
  (30, 53, $trig$-- Converted from DG Script #3053: Armor Exchange receive exchange
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
local item = actor:get_quest_var("armor_exchange:armor_id")
if item ~= 0 then
    local found
    if item <= 55303 then
        if (object.zone_id == 553 and object.id <= 83) then
            found = 1
        end
    elseif item <= 55307 then
        if (object.zone_id == 553 and object.id >= 4 and object.id <= 83) then
            found = 1
        end
    elseif item <= 55311 then
        if (object.zone_id == 553 and object.id >= 8 and object.id <= 83) then
            found = 1
        end
    elseif item <= 55315 then
        if (object.zone_id == 553 and object.id >= 12 and object.id <= 83) then
            found = 1
        end
    elseif item <= 55319 then
        if (object.zone_id == 553 and object.id >= 16 and object.id <= 83) then
            found = 1
        end
    elseif item <= 55323 then
        if (object.zone_id == 553 and object.id >= 20 and object.id <= 83) then
            found = 1
        end
    elseif item <= 55327 then
        if (object.zone_id == 553 and object.id >= 24 and object.id <= 83) then
            found = 1
        end
    elseif item <= 55331 then
        if (object.zone_id == 553 and object.id >= 28 and object.id <= 83) then
            found = 1
        end
    elseif item <= 55335 then
        if (object.zone_id == 553 and object.id >= 32 and object.id <= 83) then
            found = 1
        end
    elseif item <= 55339 then
        if (object.zone_id == 553 and object.id >= 36 and object.id <= 83) then
            found = 1
        end
    elseif item <= 55343 then
        if (object.zone_id == 553 and object.id >= 40 and object.id <= 83) then
            found = 1
        end
    elseif item <= 55347 then
        if (object.zone_id == 553 and object.id >= 44 and object.id <= 83) then
            found = 1
        end
    elseif item <= 55351 then
        if (object.zone_id == 553 and object.id >= 48 and object.id <= 83) then
            found = 1
        end
    elseif item <= 55355 then
        if (object.zone_id == 553 and object.id >= 52 and object.id <= 83) then
            found = 1
        end
    elseif item <= 55359 then
        if (object.zone_id == 553 and object.id >= 56 and object.id <= 83) then
            found = 1
        end
    elseif item <= 55363 then
        if (object.zone_id == 553 and object.id >= 60 and object.id <= 83) then
            found = 1
        end
    elseif item <= 55367 then
        if (object.zone_id == 553 and object.id >= 64 and object.id <= 83) then
            found = 1
        end
    elseif item <= 55371 then
        if (object.zone_id == 553 and object.id >= 68 and object.id <= 83) then
            found = 1
        end
    elseif item <= 55375 then
        if (object.zone_id == 553 and object.id >= 72 and object.id <= 83) then
            found = 1
        end
    elseif item <= 55379 then
        if (object.zone_id == 553 and object.id >= 76 and object.id <= 83) then
            found = 1
        end
    elseif item <= 55783 then
        if (object.zone_id == 553 and object.id >= 80 and object.id <= 83) then
            found = 1
        end
    end
    if found == 1 then
        wait(2)
        actor:send(tostring(self.name) .. " says, 'Here you are my dear!'")
        world.destroy(object)
        self.room:spawn_object(math.floor(item / 100), item % 100)
        self:command("give all " .. tostring(actor))
        wait(2)
        actor:send(tostring(self.name) .. " says, 'A pleasure connecting lost things to their owners!'")
        actor:set_quest_var("armor_exchange", "armor_id", 0)
    else
        _return_value = true
        actor:send(tostring(self.name) .. " refuses to perform the exchange.")
        wait(1)
        if (object.zone_id == 553 and object.id <= 83) then
            actor:send(tostring(self.name) .. " says, 'That's not rare enough!  I won't take " .. tostring(object.shortdesc) .. " for " .. "%get.obj_shortdesc[%item%]%!'")
        else
            actor:send(tostring(self.name) .. " says, 'Sorry, " .. tostring(object.shortdesc) .. " isn't the kind of thing I keep around here...'")
        end
    end
else
    _return_value = true
    actor:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
    wait(1)
    actor:send(tostring(self.name) .. " says, 'I don't have any lost treasures for you dearie.'")
end
return _return_value$trig$, 'a66acfe3a6f5d70df194fe9bf920a109'),
  -- data/triggers/030/030_90_isilynor_new_contract.lua
  (30, 90, $trig$-- Converted from DG Script #3090: Isilynor new contract
-- Original: MOB trigger, flags: SPEECH, probability: 0%

-- Speech phrase: I need a new notice (DG num_arg 0 = the speech contains the phrase, not a chance)
if not string.find(string.lower(speech), "i need a new notice", 1, true) then
    return true  -- Not the phrase
end
wait(2)
if actor.level >= (actor:get_quest_stage("dragon_slayer") - 1) * 10 then
    if actor:get_quest_stage("dragon_slayer") then
        local notice
        -- switch on actor:get_quest_stage("dragon_slayer")
        if actor:get_quest_stage("dragon_slayer") == 1 then
            notice = 80
        elseif actor:get_quest_stage("dragon_slayer") == 2 then
            notice = 81
        elseif actor:get_quest_stage("dragon_slayer") == 3 then
            notice = 82
        elseif actor:get_quest_stage("dragon_slayer") == 4 then
            notice = 83
        elseif actor:get_quest_stage("dragon_slayer") == 5 then
            notice = 84
        elseif actor:get_quest_stage("dragon_slayer") == 6 then
            notice = 85
        elseif actor:get_quest_stage("dragon_slayer") == 7 then
            notice = 86
        elseif actor:get_quest_stage("dragon_slayer") == 8 then
            notice = 87
        elseif actor:get_quest_stage("dragon_slayer") == 9 then
            notice = 88
        elseif actor:get_quest_stage("dragon_slayer") == 10 then
            notice = 89
        end
        self:command("grumble")
        self.room:spawn_object(30, notice)
        self:command("give notice " .. tostring(actor))
        actor:send(tostring(self.name) .. " says, 'Truly, be less caprecious.'")
    end
end$trig$, '16c09486ec6597d12bbe354b8bf99766'),
  -- data/triggers/030/030_92_bigby_assistant_refuse.lua
  (30, 92, $trig$-- Converted from DG Script #3092: Bigby Assistant refuse
-- Original: MOB trigger, flags: RECEIVE, probability: 0%

-- DG receive trigger, num_arg 0: the arg list (300 310 320 330 55577 55575 55574 55576) holds the items
-- other triggers handle; this one runs for every other item. The runtime does not filter on
-- arg_list, so the exclusion lives here. (The converter's percent_chance(0) guard blocked it all.)
if (object.zone_id == 2 and object.id == 100)
    or (object.zone_id == 2 and object.id == 110)
    or (object.zone_id == 2 and object.id == 120)
    or (object.zone_id == 2 and object.id == 130)
    or (object.zone_id == 555 and object.id == 77)
    or (object.zone_id == 555 and object.id == 75)
    or (object.zone_id == 555 and object.id == 74)
    or (object.zone_id == 555 and object.id == 76) then
    return true
end
local _return_value = true  -- Default: allow action
-- switch on object.id
_return_value = true
self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
wait(2)
self:command("shake")
self:say("I don't need this.")
return _return_value$trig$, 'b047ca81d8b362803c85cb6a8baea3b0'),
  -- data/triggers/040/040_01_door_opener.lua
  (40, 1, $trig$-- Speech phrase: norhamen beneti sovering tarlon campri (DG num_arg 0 = the speech contains the phrase, not a chance)
if not string.find(string.lower(speech), "norhamen beneti sovering tarlon campri", 1, true) then
    return true  -- Not the phrase
end

get_room(40, 10):exit("down"):set_state({hidden = false})
self.room:send("The wall screams in vain as air thrust towards you.")
self.room:send("The wall fades out of view revealing a staircase downward.")
wait(10)
get_room(40, 10):exit("down"):set_state({hidden = true})$trig$, '1e147d4e2f43965aa3b9f2cebf98f00c'),
  -- data/triggers/040/040_02_auto_door_opener.lua
  (40, 2, $trig$-- Speech phrase: darkness hear my call unto you (DG num_arg 0 = the speech contains the phrase, not a chance)
if not string.find(string.lower(speech), "darkness hear my call unto you", 1, true) then
    return true  -- Not the phrase
end

get_room(40, 19):exit("up"):set_state({hidden = false})
self.room:send("The southern wall crumbles and falls as darkness flees from behind it.")
self.room:send("Unknowing steps are revealed ascending.")
wait(10)
get_room(40, 19):exit("up"):set_state({hidden = true})$trig$, 'e66ee964a785bf43373a7ebaf5803869'),
  -- data/triggers/043/043_09_karla_chichi.lua
  (43, 9, $trig$-- Converted from DG Script #4309: karla_chichi
-- Original: MOB trigger, flags: SPEECH, probability: 0%

-- Speech phrase: Don't you think so? (DG num_arg 0 = the speech contains the phrase, not a chance)
if not string.find(string.lower(speech), "don't you think so?", 1, true) then
    return true  -- Not the phrase
end
-- TODO(parity): original DG checked for chichi (mob 4301) in the room; rewrite
-- once the runtime exposes a way to look up actors by composite (zone, id) in a room.
if self.room:find_actor("chichi") then
    self:emote("gets up in a player's face.")
    self:say("Oh no you di'in' Chichi!")
    wait(5)
    self:say("You best step off!")
    self:emote("struts around the room, waiving her finger.")
end$trig$, '616f51851c731190649c603a5f6d60da'),
  -- data/triggers/043/043_10_chapman_rosa.lua
  (43, 10, $trig$-- Converted from DG Script #4310: chapman_rosa
-- Original: MOB trigger, flags: SPEECH, probability: 0%

-- Speech phrase: You best step off! (DG num_arg 0 = the speech contains the phrase, not a chance)
if not string.find(string.lower(speech), "you best step off!", 1, true) then
    return true  -- Not the phrase
end
if actor.zone_id == 43 and actor.local_id == 5 then
    self:emote("puts his hand up in a player's face.")
    wait(3)
    self:say("Oh yes I di' Rosa!")
    wait(3)
    self:say("You don' get ta tell me what ta do!")
    self:emote("puts one hand on his hip and flails the other hand around.")
end$trig$, 'd2e0ed40a9aab4592c06cb3b16c5f755'),
  -- data/triggers/043/043_53_leading_player_refuse.lua
  (43, 53, $trig$-- Converted from DG Script #4353: Leading Player refuse
-- Original: MOB trigger, flags: RECEIVE, probability: 0%

-- DG receive trigger, num_arg 0: the arg list (4357) holds the items
-- other triggers handle; this one runs for every other item. The runtime does not filter on
-- arg_list, so the exclusion lives here. (The converter's percent_chance(0) guard blocked it all.)
if (object.zone_id == 43 and object.id == 57) then
    return true
end
local _return_value = true  -- Default: allow action
-- switch on object.id
if actor:get_quest_stage("bard_subclass") == 4 then
    _return_value = true
    actor:send(tostring(self.name) .. " says, 'This isn't the script I sent you for.'")
    self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
    wait(1)
    actor:send(tostring(self.name) .. " says, 'I sure hope you didn't memorize anything from that!'")
else
    _return_value = true
    self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
    wait(1)
    actor:send(tostring(self.name) .. " says, 'Ummmmm, what exactly is this for?'")
end
return _return_value$trig$, '58975cd260cf4f35d1d45e1974868ee4'),
  -- data/triggers/049/049_00_td_wr_init.lua
  (49, 0, $trig$-- Speech phrase: TDCommand Start (DG num_arg 0 = the speech contains the phrase, not a chance)
if not string.find(string.lower(speech), "tdcommand start", 1, true) then
    return true  -- Not the phrase
end

local NUM_TEAMS = 4
local NUM_PYLONS = 10

globals.teams = NUM_TEAMS
globals.pylons = NUM_PYLONS
globals.pylonname = "Caelian Pylon"

globals.team = {
    [0] = "Mielikki's Champions",
    [1] = "Rangers of the North",
    [2] = "The Invasion Army",
    [3] = "The Miner's Guild",
}
globals.abbr = {
    [0] = "MC",
    [1] = "RN",
    [2] = "IA",
    [3] = "MG",
}

globals.pylon = {}
for i = 0, NUM_PYLONS - 1 do
    globals.pylon[i] = -1
end

-- Spawn the war-room control mob if not already present.
if world.count_mobiles(49, 0) < 1 then
    self.room:spawn_mobile(49, 0)
end

self.room:send("Team Domination War Room variables initialized to defaults.")
return true$trig$, 'd389691d646d1f4e686498fd780ae293'),
  -- data/triggers/049/049_01_td_wr_reset.lua
  (49, 1, $trig$-- Speech phrase: TDCommand Purge (DG num_arg 0 = the speech contains the phrase, not a chance)
if not string.find(string.lower(speech), "tdcommand purge", 1, true) then
    return true  -- Not the phrase
end

globals.teams = nil
globals.pylons = nil
globals.pylonname = nil
globals.team = nil
globals.abbr = nil
globals.pylon = nil

if world.count_mobiles(49, 0) > 0 then
    local mob = self.room:find_actor("teamdominationmc")
    if mob then
        world.destroy(mob)
    end
end

self.room:send("Team Domination War Room variables reset.")
return true$trig$, '38b70e5e01bcb45dfaf917a1110555c9'),
  -- data/triggers/049/049_02_td_wr_capture.lua
  (49, 2, $trig$-- Speech phrase: TDCommand Capture (DG num_arg 0 = the speech contains the phrase, not a chance)
if not string.find(string.lower(speech), "tdcommand capture", 1, true) then
    return true  -- Not the phrase
end

if not globals.pylons or not globals.teams then
    trigger_log("TD Error: WR Capture fired before Init")
    return true
end

-- Parse "T<team>T P<pylon>P" out of the speech.
local team_idx = tonumber(string.match(speech, "T(%d+)T"))
local pylon_idx = tonumber(string.match(speech, "P(%d+)P"))

if not pylon_idx or pylon_idx < 0 or pylon_idx >= globals.pylons then
    trigger_log("TD Error: Bad pylon identifier to WR Capture trigger")
    return true
end
if not team_idx or team_idx < 0 or team_idx >= globals.teams then
    trigger_log("TD Error: Bad team identifier to WR Capture trigger")
    return true
end

globals.pylon[pylon_idx] = team_idx

local team_name = globals.team and globals.team[team_idx] or ("team " .. team_idx)
local num = pylon_idx + 1
local suffix
if num == 1 then suffix = "st"
elseif num == 2 then suffix = "nd"
elseif num == 3 then suffix = "rd"
else suffix = "th"
end

local mc = self.room:find_actor("teamdominationmc")
if mc then
    mc:command("gossip " .. team_name .. " captures the " .. num .. suffix
               .. " " .. tostring(globals.pylonname) .. "!")
end
self.room:send("Team Domination pylon " .. pylon_idx
               .. " captured by team " .. team_idx .. ".")
return true$trig$, 'fb527d4554ca164589a583df36033358'),
  -- data/triggers/049/049_09_td_wr_countdown.lua
  (49, 9, $trig$-- Speech phrase: TDCommand Countdown (DG num_arg 0 = the speech contains the phrase, not a chance)
if not string.find(string.lower(speech), "tdcommand countdown", 1, true) then
    return true  -- Not the phrase
end

if not globals.pylons or not globals.teams then
    trigger_log("TD Error: WR Countdown fired before Init")
    return true
end

local team_idx = tonumber(string.match(speech, "T(%d+)T"))
local pylon_idx = tonumber(string.match(speech, "P(%d+)P"))

if not pylon_idx or pylon_idx < 0 or pylon_idx >= globals.pylons then
    trigger_log("TD Error: Bad pylon identifier to WR Countdown trigger")
    return true
end
if not team_idx or team_idx < 0 or team_idx >= globals.teams then
    trigger_log("TD Error: Bad team identifier to WR Countdown trigger")
    return true
end

local team_name = globals.team and globals.team[team_idx] or ("team " .. team_idx)
local num = pylon_idx + 1
local suffix
if num == 1 then suffix = "st"
elseif num == 2 then suffix = "nd"
elseif num == 3 then suffix = "rd"
else suffix = "th"
end

local mc = self.room:find_actor("teamdominationmc")
if mc then
    mc:command("gossip " .. team_name .. " infiltrates the " .. num .. suffix
               .. " " .. tostring(globals.pylonname)
               .. "!  1 minute to capture!")
end
self.room:send("Team Domination countdown started for pylon " .. pylon_idx
               .. "'s capture by team " .. team_idx .. ".")
return true$trig$, '7f7f15e3a4c0543d092d12f1045830ec'),
  -- data/triggers/049/049_10_td_wr_cancel.lua
  (49, 10, $trig$-- Speech phrase: TDCommand Cancel (DG num_arg 0 = the speech contains the phrase, not a chance)
if not string.find(string.lower(speech), "tdcommand cancel", 1, true) then
    return true  -- Not the phrase
end

if not globals.pylons or not globals.teams then
    trigger_log("TD Error: WR Cancel fired before Init")
    return true
end

local team_idx = tonumber(string.match(speech, "T(%d+)T"))
local pylon_idx = tonumber(string.match(speech, "P(%d+)P"))

if not pylon_idx or pylon_idx < 0 or pylon_idx >= globals.pylons then
    trigger_log("TD Error: Bad pylon identifier to WR Cancel trigger")
    return true
end
if not team_idx or team_idx < 0 or team_idx >= globals.teams then
    trigger_log("TD Error: Bad team identifier to WR Cancel trigger")
    return true
end

local team_name = globals.team and globals.team[team_idx] or ("team " .. team_idx)
local num = pylon_idx + 1

local mc = self.room:find_actor("teamdominationmc")
if mc then
    mc:command("gossip " .. team_name .. " disrupts the countdown for "
               .. tostring(globals.pylonname) .. " " .. num .. "'s capture!")
end
self.room:send("Team Domination countdown cancelled for pylon "
               .. pylon_idx .. "'s capture.")
return true$trig$, 'f7b31f913048e8d719be2488bc544267'),
  -- data/triggers/052/052_16_emmath_receive_decline.lua
  (52, 16, $trig$-- DG receive trigger, num_arg 0: the arg list (5211 5212 17308 23822 318) holds the items
-- other triggers handle; this one runs for every other item. The runtime does not filter on
-- arg_list, so the exclusion lives here. (The converter's percent_chance(0) guard blocked it all.)
if (object.zone_id == 52 and object.id == 11)
    or (object.zone_id == 52 and object.id == 12)
    or (object.zone_id == 173 and object.id == 8)
    or (object.zone_id == 238 and object.id == 22)
    or (object.zone_id == 2 and object.id == 118) then
    return true
end

local stage_subclass = actor:get_quest_stage("pyromancer_subclass") or 0
local response
if stage_subclass > 0 and stage_subclass <= 4 then
    response = "I asked you to bring me the " .. tostring(actor:get_quest_var("pyromancer_subclass:part")) .. " flame, not this nonsense."
elseif actor:get_quest_stage("type_wand") then
    response = "I can't craft with this!"
elseif (actor:get_quest_stage("emmath_flameball") or 0) > 1 then
    response = "You're supposed to be out collecting flames, not whatever this is."
else
    response = "Why are you bringing me this trash?"
end

self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
wait(2)
actor:send(tostring(self.name) .. " says, '" .. tostring(response) .. "'")
return true$trig$, '35b5392bbe8f5fdb70cd303cdb51ddfe'),
  -- data/triggers/053/053_33_pumahl_new_assignment.lua
  (53, 33, $trig$-- Converted from DG Script #5333: Pumahl new assignment
-- Original: MOB trigger, flags: SPEECH, probability: 0%

-- Speech phrase: I need a new assignment (DG num_arg 0 = the speech contains the phrase, not a chance)
if not string.find(string.lower(speech), "i need a new assignment", 1, true) then
    return true  -- Not the phrase
end
wait(2)
if actor.level >= (actor:get_quest_stage("beast_master") - 1) * 10 then
    if actor:get_quest_var("beast_master:hunt") then
        -- switch on actor:get_quest_stage("beast_master")
        local notice
        if actor:get_quest_stage("beast_master") == 1 then
            notice = 0
        elseif actor:get_quest_stage("beast_master") == 2 then
            notice = 1
        elseif actor:get_quest_stage("beast_master") == 3 then
            notice = 2
        elseif actor:get_quest_stage("beast_master") == 4 then
            notice = 3
        elseif actor:get_quest_stage("beast_master") == 5 then
            notice = 4
        elseif actor:get_quest_stage("beast_master") == 6 then
            notice = 5
        elseif actor:get_quest_stage("beast_master") == 7 then
            notice = 6
        elseif actor:get_quest_stage("beast_master") == 8 then
            notice = 7
        elseif actor:get_quest_stage("beast_master") == 9 then
            notice = 8
        elseif actor:get_quest_stage("beast_master") == 10 then
            notice = 9
        end
        self:command("grumble")
        self.room:spawn_object(53, notice)
        self:command("give assignment " .. tostring(actor))
        actor:send(tostring(self.name) .. " says, 'Don't lose this one!'")
    end
end$trig$, '3e7e4050009baa00104f6096beae9cd0'),
  -- data/triggers/053/053_34_honus_new_order.lua
  (53, 34, $trig$-- Converted from DG Script #5334: Honus new order
-- Original: MOB trigger, flags: SPEECH, probability: 0%

-- Speech phrase: I need a new order (DG num_arg 0 = the speech contains the phrase, not a chance)
if not string.find(string.lower(speech), "i need a new order", 1, true) then
    return true  -- Not the phrase
end
wait(2)
if actor.level >= (actor:get_quest_stage("treasure_hunter") - 1) * 10 then
    if actor:get_quest_var("treasure_hunter:hunt") then
        -- switch on actor:get_quest_stage("treasure_hunter")
        local order
        if actor:get_quest_stage("treasure_hunter") == 1 then
            order = 10
        elseif actor:get_quest_stage("treasure_hunter") == 2 then
            order = 11
        elseif actor:get_quest_stage("treasure_hunter") == 3 then
            order = 12
        elseif actor:get_quest_stage("treasure_hunter") == 4 then
            order = 13
        elseif actor:get_quest_stage("treasure_hunter") == 5 then
            order = 14
        elseif actor:get_quest_stage("treasure_hunter") == 6 then
            order = 15
        elseif actor:get_quest_stage("treasure_hunter") == 7 then
            order = 16
        elseif actor:get_quest_stage("treasure_hunter") == 8 then
            order = 17
        elseif actor:get_quest_stage("treasure_hunter") == 9 then
            order = 18
        elseif actor:get_quest_stage("treasure_hunter") == 10 then
            order = 19
        end
        self:command("grumble")
        self.room:spawn_object(53, order)
        self:command("give order " .. tostring(actor))
        actor:send(tostring(self.name) .. " says, 'Be more careful next time.'")
    end
end$trig$, '8ca1e9b81ba6bd40725c72b097ca6981'),
  -- data/triggers/053/053_45_elemental_chaos_hakujo_new_mission.lua
  (53, 45, $trig$-- Converted from DG Script #5345: Elemental Chaos Hakujo new mission
-- Original: MOB trigger, flags: SPEECH, probability: 0%

-- Speech phrase: I need a new note (DG num_arg 0 = the speech contains the phrase, not a chance)
if not string.find(string.lower(speech), "i need a new note", 1, true) then
    return true  -- Not the phrase
end
wait(2)
if actor.level >= (actor:get_quest_stage("elemental_chaos") - 1) * 10 then
    if actor:get_quest_var("elemental_chaos:bounty") then
        -- switch on actor:get_quest_stage("elemental_chaos")
        local mission
        if actor:get_quest_stage("elemental_chaos") == 1 then
            mission = 20
        elseif actor:get_quest_stage("elemental_chaos") == 2 then
            mission = 21
        elseif actor:get_quest_stage("elemental_chaos") == 3 then
            mission = 22
        elseif actor:get_quest_stage("elemental_chaos") == 4 then
            mission = 23
        elseif actor:get_quest_stage("elemental_chaos") == 5 then
            mission = 24
        elseif actor:get_quest_stage("elemental_chaos") == 6 then
            mission = 25
        elseif actor:get_quest_stage("elemental_chaos") == 7 then
            mission = 26
        elseif actor:get_quest_stage("elemental_chaos") == 8 then
            mission = 27
        elseif actor:get_quest_stage("elemental_chaos") == 9 then
            mission = 28
        elseif actor:get_quest_stage("elemental_chaos") == 10 then
            mission = 29
        end
        self:command("grumble")
        self.room:spawn_object(53, mission)
        self:command("give mission " .. tostring(actor))
        actor:send(tostring(self.name) .. " says, 'Be more careful next time.'")
    end
end$trig$, '39e3916e04fd686b991b9ab8bf135a32'),
  -- data/triggers/053/053_57_hell_trident_progress_tracker.lua
  (53, 57, $trig$-- Converted from DG Script #5357: Hell Trident progress tracker
-- Original: MOB trigger, flags: SPEECH, probability: 0%

-- Speech phrase: weapon progress (DG num_arg 0 = the speech contains the phrase, not a chance)
if not string.find(string.lower(speech), "weapon progress", 1, true) then
    return true  -- Not the phrase
end
wait(2)
if string.find(actor.class, "Diabolist") then
    local level, response
    if actor:get_quest_stage("hell_trident") then
        local hellstage = actor:get_quest_stage("hell_trident")
        if hellstage == 1 then
            level = 65
        elseif hellstage == 2 then
            level = 90
        end
        -- switch on self.id
        -- switch on hellstage
        if hellstage == 1 then
            response = "stage2"
        elseif hellstage == 2 then
            response = "stage3"
        else
            if actor:get_has_completed("hell_trident") then
                response = "complete"
            end
        end
        local step = 1
        local gem = 55662
        local pl_word = "angels"
        local word = "angel"
        local spell1 = "Hellfire and Brimstone"
        local quest1 = actor:get_has_completed("hellfire_brimstone")
        local spell2 = "Banish"
        local quest2 = actor:get_has_completed("banish")
        if not actor:get_quest_var("hell_trident:helltask6") and actor.level >= level and hellstage == 1 then
            if actor:get_quest_stage("vilekka_stew") > 3 then
                actor:set_quest_var("hell_trident", "helltask6", 1)
            end
        end
        local task6 = "assisted Vilekka Kar'Shezden"
        local task6do = "&3&bAssist the High Priestess of Lolth in hunting down and destroying the heretics of her Goddess.&0"
        local step = 2
        local gem = 55739
        local pl_word = "ghaeles, solars, or seraphs"
        local word = "ghaele, solar, or seraph"
        local spell1 = "Resurrect"
        local quest1 = actor:get_has_completed("resurrection_quest")
        local spell2 = "Hell Gate"
        local quest2 = actor:get_has_completed("hell_gate")
        local task6 = "Defeated the Undead Prince"
        local task6do = "find one long-buried and branded an infidel.  &3&bFinish his undying duel for him&0 as a sacrifice of honor."
        if hellstage == "step" then
            if actor.level >= level then
                if not actor:get_quest_var("hell_trident:helltask4") then
                    if quest1 then
                        actor:set_quest_var("hell_trident", "helltask4", 1)
                    end
                end
                if not actor:get_quest_var("hell_trident:helltask5") then
                    if quest2 then
                        actor:set_quest_var("hell_trident", "helltask5", 1)
                    end
                end
                if not actor:get_quest_var("hell_trident:greet") then
                    actor:send(tostring(self.name) .. " says, 'Tell me why you have come.'")
                else
                    local job1 = actor:get_quest_var("hell_trident:helltask1")
                    local job2 = actor:get_quest_var("hell_trident:helltask2")
                    local job3 = actor:get_quest_var("hell_trident:helltask3")
                    local job4 = actor:get_quest_var("hell_trident:helltask4")
                    local job5 = actor:get_quest_var("hell_trident:helltask5")
                    local job6 = actor:get_quest_var("hell_trident:helltask6")
                    if job1 or job2 or job3 or job4 or job5 or job6 then
                        actor:send(tostring(self.name) .. " says, 'You have done the following:'")
                        if job1 then
                            actor:send("- attacked 666 times")
                        end
                        if job2 then
                            actor:send("- slayed 6 " .. tostring(pl_word))
                        end
                        if job3 then
                            actor:send("- found 6 " .. "%get.obj_shortdesc[%gem%]%")
                        end
                        if job4 then
                            actor:send("- learned " .. tostring(spell1))
                        end
                        if job5 then
                            actor:send("- learned " .. tostring(spell2))
                        end
                        if job6 then
                            actor:send("- " .. tostring(task6))
                        end
                        actor:send("</>")
                    end
                    if job1 and job2 and job3 and job4 and job5 and job6 then
                        actor:send(tostring(self.name) .. " says, 'Give me your trident to finalize the pact.'")
                    else
                        actor:send("You must still:")
                        if not job1 then
                            local remaining = 666 - actor:get_quest_var("hell_trident:attack_counter")
                            if remaining > 1 then
                                actor:send("- <b:yellow>attack " .. tostring(remaining) .. " more times with your trident</>")
                            else
                                actor:send("- <b:yellow>attack " .. tostring(remaining) .. " more time with your trident</>")
                            end
                        end
                        if not job2 then
                            local kills = 6 - actor:get_quest_var("hell_trident:celestials")
                            if kills > 1 then
                                actor:send("- <b:yellow>slay " .. tostring(kills) .. " more " .. tostring(pl_word) .. "</>")
                            else
                                actor:send("- <b:yellow>slay " .. tostring(kills) .. " more " .. tostring(word) .. "</>")
                            end
                        end
                        if not job3 then
                            local gems = 6 - actor:get_quest_var("hell_trident:gems")
                            if gems > 1 then
                                actor:send("- <b:yellow>find " .. tostring(gems) .. " more " .. "%get.obj_pldesc[%gem%]%</>")
                            else
                                actor:send("- <b:yellow>find " .. tostring(gems) .. " more " .. "%get.obj_noadesc[%gem%]%</>")
                            end
                        end
                        if not job4 then
                            actor:send("- <b:yellow>learn " .. tostring(spell1) .. "</>")
                        end
                        if not job5 then
                            actor:send("- <b:yellow>learn " .. tostring(spell2) .. "</>")
                        end
                        if not job6 then
                            actor:send("- " .. tostring(task6do))
                        end
                    end
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
end$trig$, '2a770ece380ad6977a18aa078c5e7f6f'),
  -- data/triggers/060/060_24_timulos_refuse.lua
  (60, 24, $trig$-- Converted from DG Script #6024: Timulos refuse
-- Original: MOB trigger, flags: RECEIVE, probability: 0%

-- DG receive trigger, num_arg 0: the arg list (41014 3033 8813) holds the items
-- other triggers handle; this one runs for every other item. The runtime does not filter on
-- arg_list, so the exclusion lives here. (The converter's percent_chance(0) guard blocked it all.)
if (object.zone_id == 410 and object.id == 14)
    or (object.zone_id == 30 and object.id == 33)
    or (object.zone_id == 88 and object.id == 13) then
    return true
end
local _return_value = true  -- Default: allow action
-- switch on object.id
local response
if actor:get_quest_stage("merc_ass_thi_subclass") == 4 then
    wait(2)
    actor:send(tostring(self.name) .. " says, 'Well this is nifty, I think I will hold on to that, thank you.  Now go bring me what you were told.'")
    world.destroy(object)
else
    response = "What is this? Are you trying to trick me?"
end
if response then
    _return_value = true
    self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
    wait(2)
    self:command("eye " .. tostring(actor.name))
    actor:send(tostring(self.name) .. " says, '" .. tostring(response) .. "'")
end
return _return_value$trig$, '057cde982783eb3fe5166b59888e32ed'),
  -- data/triggers/060/060_60_berix_bounty_hunt_new_contract.lua
  (60, 60, $trig$-- Converted from DG Script #6060: Berix bounty hunt new contract
-- Original: MOB trigger, flags: SPEECH, probability: 0%

-- Speech phrase: I need a new contract (DG num_arg 0 = the speech contains the phrase, not a chance)
if not string.find(string.lower(speech), "i need a new contract", 1, true) then
    return true  -- Not the phrase
end
wait(2)
if actor.level >= (actor:get_quest_stage("bounty_hunt") - 1) * 10 then
    if actor:get_quest_var("bounty_hunt:bounty") then
        -- Hoisted: branch-scoped `local` would not be visible below.
        local contract
        -- switch on actor:get_quest_stage("bounty_hunt")
        if actor:get_quest_stage("bounty_hunt") == 1 then
            contract = 50
        elseif actor:get_quest_stage("bounty_hunt") == 2 then
            contract = 51
        elseif actor:get_quest_stage("bounty_hunt") == 3 then
            contract = 52
        elseif actor:get_quest_stage("bounty_hunt") == 4 then
            contract = 53
        elseif actor:get_quest_stage("bounty_hunt") == 5 then
            contract = 54
        elseif actor:get_quest_stage("bounty_hunt") == 6 then
            contract = 55
        elseif actor:get_quest_stage("bounty_hunt") == 7 then
            contract = 56
        elseif actor:get_quest_stage("bounty_hunt") == 8 then
            contract = 57
        elseif actor:get_quest_stage("bounty_hunt") == 9 then
            contract = 58
        elseif actor:get_quest_stage("bounty_hunt") == 10 then
            contract = 59
        else
            contract = 50
        end
        self:command("whap " .. tostring(actor))
        actor:send(tostring(self.name) .. " says, 'Don't be such an idiot again!'")
        self.room:spawn_object(60, contract)
        self:command("give contract " .. tostring(actor))
    end
end$trig$, '70c37e7618a689a015ea25b0828509eb'),
  -- data/triggers/123/123_02_priestess_speech2.lua
  (123, 2, $trig$-- Converted from DG Script #12302: priestess_speech2
-- Original: MOB trigger, flags: SPEECH, SPEECH_TO, probability: 0%

-- Speech phrase: great rite (DG num_arg 0 = the speech contains the phrase, not a chance)
if not string.find(string.lower(speech), "great rite", 1, true) then
    return true  -- Not the phrase
end
-- (the converter compared against upper-case text; `speech` is lower-case)
if string.find(speech, "great rite", 1, true) then
    wait(2)
    self.room:send(tostring(self.name) .. " says, 'For generations, our coven has scoured the face of Ethilien to find a place where the touch of the <b:cyan>Old Gods</> might still be found.'")
    wait(3)
    self.room:send(tostring(self.name) .. " says, 'Performed correctly, this ritual will allow us to call to our Goddess in the Dreaming and provide a bridge across space and time back into the mortal realm.'")
end$trig$, '9ce4d43a7117c8aa76cdbc35ee52305e'),
  -- data/triggers/123/123_10_megalith_quest_priestess_speech_invocation2.lua
  (123, 10, $trig$-- Converted from DG Script #12310: megalith_quest_priestess_speech_invocation2
-- Original: MOB trigger, flags: SPEECH, SPEECH_TO, probability: 0%

-- Speech phrase: we summon and stir thee (DG num_arg 0 = the speech contains the phrase, not a chance)
if not string.find(string.lower(speech), "we summon and stir thee", 1, true) then
    return true  -- Not the phrase
end
local speech1 = "we summon and stir thee"
local speech2 = "we summon and stir thee!"
local stage = actor:get_quest_stage("megalith_quest")
local summon = actor:get_quest_var("megalith_quest:summon")
if speech == speech1 or speech == speech2 then
    if (stage == 4) and (self.room.zone_id == 123 and self.room.local_id == 89) and (actor:get_quest_var("megalith_quest:prayer") == 2) then
        -- switch on summon
        if summon == 1 then
            run_room_trigger(123, 18)
            wait(5)
            self.room:send(tostring(self.name) .. " chants:")
            self.room:send("'By Earth, Air, Water, and Fire,")
            self.room:send("</>To bring you home is our desire.'")
            wait(4)
            run_room_trigger(123, 19)
            actor:set_quest_var("megalith_quest", "summon", 2)
        elseif summon == 2 then
            run_room_trigger(123, 20)
            wait(2)
            self.room:send(tostring(self.name) .. " chants:")
            self.room:send("'Through the plane of vaulted sky")
            self.room:send("</>On shooting stars and moonbridge high.'")
            wait(4)
            run_room_trigger(123, 21)
            actor:set_quest_var("megalith_quest", "summon", 3)
        elseif summon == 3 then
            -- 
            -- 12320 is a wecho of just the phrase 'We summon and stir thee'
            -- It is intentionally repeated at the top of this case to echo the questor
            -- 
            run_room_trigger(123, 20)
            wait(2)
            self.room:send(tostring(mobiles.template(123, 1).name) .. " says, '<b:cyan>We invoke thee</>!")
        end
    end
end$trig$, '5292b432572507e81ba6a1e37c426bc5'),
  -- data/triggers/123/123_11_megalith_quest_priestess_speech_end.lua
  (123, 11, $trig$-- Converted from DG Script #12311: megalith_quest_priestess_speech_end
-- Original: MOB trigger, flags: SPEECH, SPEECH_TO, probability: 0%

-- Speech phrase: we invoke thee (DG num_arg 0 = the speech contains the phrase, not a chance)
if not string.find(string.lower(speech), "we invoke thee", 1, true) then
    return true  -- Not the phrase
end
local _return_value = true
local speech1 = "we invoke thee"
local speech2 = "we invoke thee!"
local stage = actor:get_quest_stage("megalith_quest")
if (stage == 4) and (self.room.zone_id == 123 and self.room.local_id == 89) and (actor:get_quest_var("megalith_quest:summon") == 3) and (speech == speech1 or speech == speech2) then
    local invoke = actor:get_quest_var("megalith_quest:invoke") or 0
    local chant = invoke + 1
    if chant == 1 then
        actor:set_quest_var("megalith_quest", "invoke", 1)
        wait(2)
        run_room_trigger(123, 22)
        wait(1)
        self:say("Again!")
        self.room:send("<b:cyan>We invoke thee!</>")
    elseif chant == 2 then
        actor:set_quest_var("megalith_quest", "invoke", 2)
        wait(2)
        run_room_trigger(123, 22)
        wait(1)
        self:say("Once more!")
        self.room:send("<b:cyan>We invoke thee!</>")
    elseif chant == 3 then
        actor:set_quest_var("megalith_quest", "invoke", 0)
        actor:set_quest_var("megalith_quest", "reliquary", 0)
        actor:set_quest_var("megalith_quest", "summon", 0)
        actor:set_quest_var("megalith_quest", "prayer", 0)
        local bad1 = actor:get_quest_var("megalith_quest:bad1") and 1 or 0
        local bad2 = actor:get_quest_var("megalith_quest:bad2") and 1 or 0
        local bad3 = actor:get_quest_var("megalith_quest:bad3") and 1 or 0
        local bad4 = actor:get_quest_var("megalith_quest:bad4") and 1 or 0
        run_room_trigger(123, 22)
        wait(2)
        self.room:send(tostring(self.name) .. " cries, 'Great Mother, come to me!'")
        wait(2)
        self.room:send("The chanting harmonizes with the vibrations of the standing stones.")
        self.room:send("<b:yellow>Radiant energy washes out of the ancient stones in waves!</>")
        wait(4)
        self.room:send("<b:white>Stars <blue>begin to fall from the swirling vortex above.</>")
        wait(5)
        -- The worst ending
        if bad4 == 1 then
            -- TODO(parity): the elixir name lookup uses zone 584 / id 26
            -- as a guess at the legacy 58426 split. Verify the canonical
            -- (zone, id) before relying on this.
            self.room:send("The energies of the megalith buckle suddenly as <magenta>" .. tostring(objects.template(584, 26).name) .. "</> shatters.")
            wait(4)
            self.room:send("&9<blue>The harmonics shift into piercing discordant shrieks as</> <red>blood</> &9<blue>begins to pour from the altar!</>")
            wait(2)
            self.room:send("With a horrified look, " .. tostring(self.name) .. " screams, 'The Great Invocation has been corrupted!  What was in that <b:red>elixir</>?!'")
            wait(7)
            self.room:send("Rays of <b:white>s</><b:yellow>ea</><b:white>ring light</> shoot out in all directions as the world spins!")
            wait(6)
            self.room:send("Suddenly <magenta>bpitch black</> energies erupt from the altar, engulfing " .. tostring(mobiles.template(123, 7).name) .. "!")
            wait(8)
            self.room:send(tostring(mobiles.template(123, 7).name) .. " is ripped apart from within in an explosion of blood and gore!")
            local envoy = self.room:find_actor("celestial-envoy")
            if envoy then world.destroy(envoy) end
            self.room:send("Remaining in her place is a huge blood-covered abomination from beyond time and space made completely of iridescent black slime.")
            wait(4)
            self.room:send("Hundreds of eyes float just below the viscous membrane surrounding the ameboid creature.")
            wait(5)
            self.room:send("Suddenly it mutates into a huge creature with six enormous muscular legs and a massive maw!")
            wait(3)
            self.room:send("It roars with the voices of a thousand flayed beasts and attacks!")
            self.room:spawn_mobile(123, 21)
            local shoggoth = self.room:find_actor("shoggoth")
            if shoggoth then shoggoth:command("kill " .. tostring(actor.name)) end
            -- Clear all the bads, in case you try again later
            for slot = 1, 4 do
                actor:set_quest_var("megalith_quest", "bad" .. tostring(slot), 0)
            end
            actor:fail_quest("megalith_quest")
            return _return_value
        else
            local total = bad1 + bad2 + bad3
            -- The good ending - get two prizes
            if total == 0 then
                actor:advance_quest("megalith_quest")
                self.room:send("<b:white>Celestial light pours through the vortex.</>")
                self.room:send("<b:white>It forms a gentle <cyan>pool of radiance <white>in the eye of the cosmic maelstrom.</>")
                wait(5)
                self.room:send("<b:magenta>A beautiful tiny being with six gossamer butterfly wings descends from the moonbridge.</>")
                self.room:send("<b:white>She looks as old as time itself yet younger than a child.</>")
                wait(5)
                self.room:send(tostring(self.name) .. " exclaims, 'O Great Mother, Goddess of the moon and stars, joyously we welcome you!'")
                if world.count_mobiles(123, 0) == 0 then
                    self.room:spawn_mobile(123, 0)
                end
                local mother = mobiles.template(123, 0).name
                local witch = mobiles.template(123, 7).name
                self.room:send(tostring(self.name) .. " and " .. tostring(witch) .. " kneel before " .. tostring(mother) .. ".")
                wait(4)
                self.room:send(tostring(mother) .. " embraces her children, weeping with joy.")
                wait(5)
                self.room:send(tostring(mother) .. " says, 'Your efforts shone a beacon in the dark, lighting my way back to you my children.'")
                wait(4)
                self.room:send(tostring(mother) .. " says, 'I have watched from afar as you and your mothers and your grandmothers struggled to keep our traditions alive.'")
                wait(5)
                self.room:send(tostring(mother) .. " proclaims, 'But now is our time to flourish again!'")
                wait(2)
                self.room:send(tostring(mother) .. " proclaims, 'Let this sacred megalith be home to our coven from here after!'")
                wait(5)
                self.room:send(tostring(mother) .. " proclaims, 'Let us reignite the flames of passion, be the clay of reason, give the breath of life, be the ocean of serenity.'")
                wait(5)
                self.room:send(tostring(mother) .. " cries, 'So mote it be!'")
                wait(3)
                self.room:send("The coven cheers in unison, 'So mote it be!'")
                wait(4)
                self.room:send_except(actor, "Turning to " .. tostring(actor.name) .. ", " .. tostring(mother) .. " says, 'And you, " .. tostring(actor.name) .. ".")
                actor:send("Turning to you, " .. tostring(mother) .. " says, 'And you, " .. tostring(actor.name) .. ".")
                self.room:send("</>I wish to thank you for helping my daughters.  <b:cyan>Kneel</>, and receive my blessing.'")
                return _return_value
            -- The okay ending - get one prize
            elseif total == 1 then
                actor:advance_quest("megalith_quest")
                self.room:send("The stars coalesce into the nearly transparent form of a celestial, gossamer-winged goddess.")
                local mother = mobiles.template(123, 0).name
                local witch = mobiles.template(123, 7).name
                self.room:send(tostring(self.name) .. " and " .. tostring(witch) .. " bow before " .. tostring(mother) .. ".")
                self.room:send(tostring(self.name) .. " says, 'O Great Mother, watcher from the deep, we come to seek thy blessing!'")
                if world.count_mobiles(123, 0) == 0 then
                    self.room:spawn_mobile(123, 0)
                end
                self.room:send(tostring(mother) .. " says, 'My daughters, you shall always have my blessing.'")
                self.room:send(tostring(mother) .. " gently kisses each member of the coven on their forehead, leaving a glowing mote of <b:white>silvery light</>.")
                wait(5)
                self.room:send(tostring(mother) .. " says, 'Long has it been since the Nine Hells opened wide and I was cut off from the mortal world.'")
                wait(3)
                self.room:send(tostring(mother) .. " says, 'Yet through you and your mothers and grandmothers before you, my presence has been kept alive.'")
                self.room:send(tostring(mother) .. " smiles serenely.")
                wait(6)
                self.room:send(tostring(mother) .. " declares, 'Let this sacred megalith be home to our coven once again!  Thus I charge you with the tending and care of this holy monument.  May you keep well this sacred duty.'")
                wait(7)
                self.room:send_except(actor, "Turning to " .. tostring(actor.name) .. ", " .. tostring(mother) .. " says, 'And you, " .. tostring(actor.name) .. ".")
                actor:send("Turning to you, " .. tostring(mother) .. " says, 'And you, " .. tostring(actor.name) .. ".")
                self.room:send("</>I would thank you for helping my daughters.  If you wish to receive my blessing, <b:cyan>kneel</>.'")
                return _return_value
            -- The bad ending - get nothing
            elseif total >= 2 then
                self.room:send("&9<blue>The harmonics of the monolith begin to shift, falling out of balance.</>")
                wait(3)
                self.room:send("The energy of the megalith begins to dim.")
                self.room:send("In a despondent voice, " .. tostring(self.name) .. " cries out, 'The circle is failing!  <b:red>The tools or the reliquaries must have been flawed!</>'")
                wait(4)
                self.room:send("<b:yellow>Rapidly the radiance leaks out of the area.</>")
                wait(2)
                self.room:send("<b:white>The swirling vortex in the sky swiftly fades away.</>")
                wait(4)
                self.room:send("The Great Rite of Invocation ends as if nothing had ever happened.")
                wait(4)
                self.room:send(tostring(self.name) .. " says, 'So this is how it ends... not with a bang, but a whimper.'")
                self:emote("collapses, exhausted.")
                -- Clear all the Bads, just in case you try again
                for slot = 1, 5 do
                    actor:set_quest_var("megalith_quest", "bad" .. tostring(slot), 0)
                end
                actor:fail_quest("megalith_quest")
            end
        end
    end
end
return _return_value$trig$, '0a20275a3287e889798eaa525359e7b4'),
  -- data/triggers/123/123_17_megalith_quest_ritual_effects1.lua
  (123, 17, $trig$-- Converted from DG Script #12317: megalith_quest_ritual_effects1
-- Original: WORLD trigger, flags: GLOBAL, probability: 0%

-- Runs only through run_room_trigger() (DG probability 0 = never automatic); the converter's
-- percent_chance(0) guard blocked those calls.
wait(2)
zone.echo(123, "The Keepers call out, 'Great Lady of the Stars, hear our prayer!'")
wait(2)
zone.echo(123, "The voices of the coven call out in unison, 'Great Lady of the Stars, hear our prayer!'")$trig$, '8a93543edded7dab38010d4d44367293'),
  -- data/triggers/123/123_18_megalith_quest_ritual_effects2.lua
  (123, 18, $trig$-- Converted from DG Script #12318: megalith_quest_ritual_effects2
-- Original: WORLD trigger, flags: GLOBAL, probability: 0%

-- Runs only through run_room_trigger() (DG probability 0 = never automatic); the converter's
-- percent_chance(0) guard blocked those calls.
wait(2)
zone.echo(123, "The coven chants, 'We summon and stir thee!'")
wait(1)
zone.echo(123, "<green>The harmonic rumbling intensifies as the ground starts to shake as if awakening.</>")$trig$, 'e21199344fa62711025ef96cd334120e'),
  -- data/triggers/188/188_20_xcast_xcast.lua
  (188, 20, $trig$-- Command location mask 3: legacy OCMD_EQUIP=1 (worn), OCMD_INVEN=2 (carried), OCMD_ROOM=4 (floor)
if not (location == "equip" or location == "inventory") then
    return true  -- Not in a location this trigger watches
end

-- Command filter: xcast
if not (cmd == "xcast") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
-- 
-- X-cast
-- This trigger works with 18821, x-decide, to cast custom spells with various
-- effects.  It may only be used by mobiles in the 18820 to 18842 range,
-- Laoris' dragonquest mobiles.
-- 
-- Expected variables set by x-decide:
-- xid - unique integer identifier, like 1
-- xname - name of the spell, such as 'arctic blast'
-- xstars - duration to cast the spell, ie., 2
-- xmagic - magic words uttered at the end of the spell, like 'zimblo argis'
-- xeffect - actual effect of the spell, such as 'damage' or 'expel'
-- xmode - sets whether it's victim or self-only
-- xamount - only meaningful for some spell types, ie., 100
-- 
if (actor.zone_id == 188 and actor.id >= 20 and actor.id <= 42) then
    _return_value = false
    -- Must use x-decide to select a spell first
    if not xname then
        actor:send("You have not chosen a spell to x-cast yet!")
        -- No x-casting damage on self, immortals, or people in other rooms
    elseif (xmode == "victim") and (arg.name == actor.name) then
        actor:send("You cannot x-cast at yourself.")
    elseif (xmode == "victim") and (arg.room ~= actor.room) then
        actor:send("You must be in the same room as " .. tostring(arg.name) .. "!")
    elseif (xmode == "victim") and (arg.level > 99) then
        actor:send("You cannot x-cast at immortals!")
    else
        local notarg
        local spell_stop
        local damage
        if xmode ~= "victim" then
            notarg = 1
        end
        -- Begin casting messages
        if xmode == "victim" then
            arg:send(tostring(actor.name) .. " starts casting <b:yellow>'" .. tostring(xname) .. "'</> at <b:red>You</>!!!...")
            self.room:send_except(arg, tostring(actor.name) .. " starts casting <b:yellow>'" .. tostring(xname) .. "'</>...")
            actor:send("You start casting <b:yellow>'" .. tostring(xname) .. "'</>...")
        elseif xmode == "self" then
            self.room:send_except(actor, tostring(actor.name) .. " starts casting <b:yellow>'" .. tostring(xname) .. "'</>...")
        end
        actor:send("You start chanting...")
        wait(2)
        -- Imitate casting stars
        local stars = xstars
        while stars > 0 do
            if notarg or (arg.room == actor.room) then
                actor:send(tostring(stars) .. " remaining on " .. tostring(xname))
                wait(2)
                stars = stars - 1
            else
                spell_stop = 1
                stars = 0
            end
        end
        -- If player is still here, make with the magic
        if spell_stop ~= 1 then
            if notarg or (arg.room == actor.room) then
                if xmode == "victim" then
                    arg:send(tostring(actor.name) .. " stares at you and utters the words, '" .. tostring(xmagic) .. "'.")
                    self.room:send_except(arg, tostring(actor.name) .. " closes " .. tostring(actor.possessive) .. " eyes and utters the words, '" .. tostring(xmagic) .. "'.")
                elseif xmode == "self" then
                    self.room:send_except(actor, tostring(actor.name) .. " closes " .. tostring(actor.possessive) .. " eyes and utters the words, '" .. tostring(xmagic) .. "'.")
                end
                actor:send("You complete your spell.")
                if xeffect == "damage" then
                    damage = xamount + random(1, 50)
                end
                -- Show the message
                if xid == 1 then
                    self.room:send_except(actor, "<yellow>" .. tostring(actor.name) .. " lets out a <red>soul-rending<yellow> screech</>!")
                    actor:send("<yellow>You let out shattering screech!</>")
                elseif xid == 2 then
                    self.room:send_except(actor, "<b:white>" .. tostring(actor.name) .. " waves a taloned paw, bring down a </><cyan>bli<blue>zz</><cyan>ard<b:white> of snow!</>")
                    actor:send("<b:white>You wave a taloned paw at the room, bringing down a </><cyan>bli<blue>zz</><cyan>ard<b:white> of snow!</>")
                elseif xid == 3 then
                    self.room:send_except(actor, "<b:white>" .. tostring(actor.name) .. " looks much healthier than before!</>")
                    actor:send("<b:white>You feel MUCH healthier than before!</>")
                elseif xid == 4 then
                    self.room:send_except(arg, tostring(actor.name) .. " waves a hand at " .. tostring(arg.name) .. ", whisking " .. tostring(arg.object) .. " away!")
                    actor:send("You wave a hand at " .. tostring(arg.name) .. ", whisking " .. tostring(arg.object) .. " away!")
                elseif xid == 5 then
                    self.room:send_except(actor, "<b:white>" .. tostring(actor.name) .. " speaks a holy word of sanctification!</>")
                    actor:send("<b:white>You speak a holy word of sanctification!</>")
                elseif xid == 6 then
                    arg:send("&9<blue>" .. tostring(actor.name) .. " chants an arcane word at you, locking you in an iron maiden!</>")
                    self.room:send_except(arg, "&9<blue>" .. tostring(actor.name) .. " chants an arcane word at " .. tostring(arg.name) .. ", locking " .. tostring(arg.object) .. " in an iron maiden!</>")
                    actor:send("&9<blue>You chant an arcane word at " .. tostring(arg.name) .. ", locking " .. tostring(arg.object) .. " in an iron maiden!</>")
                elseif xid == 7 then
                    self.room:send_except(actor, "<blue>Lightning streaks out from " .. tostring(actor.name) .. "'s body, sizzling through the air.</>")
                    actor:send("<blue>Lightning streaks out from your body, crackling through the air.</>")
                elseif xid == 8 then
                    arg:send(tostring(actor.name) .. " screams a commination at you, causing runes to appear on your skin!  (<b:red>" .. tostring(damage) .. "</>)")
                    self.room:send_except(arg, "Runes appear on " .. tostring(arg.name) .. " as " .. tostring(actor.name) .. " screams an obloquy at " .. tostring(arg.object) .. "!  (<blue>" .. tostring(damage) .. "</>)")
                    actor:send("You scream a curse at " .. tostring(arg.name) .. ", causing runes to appear on " .. tostring(arg.possessive) .. " skin! (<yellow>" .. tostring(damage) .. "</>)")
                elseif xid == 9 then
                    arg:send(tostring(actor.name) .. " flings a ball of caustic acid at you, burning your flesh. (<b:red>" .. tostring(damage) .. "</>)")
                    self.room:send_except(arg, tostring(actor.name) .. " flings a ball of caustic acid at " .. tostring(arg.name) .. ", burning " .. tostring(actor.possessive) .. " flesh.  (<blue>" .. tostring(damage) .. "</>)")
                    actor:send("You throw a ball of caustic acid at " .. tostring(arg.name) .. ", burning " .. tostring(arg.possessive) .. " flesh. (<yellow>" .. tostring(damage) .. "</>)")
                else
                    self.room:send_except(actor, "X-cast failure.  Nothing happens.")
                    actor:send("Unrecognized xid number.")
                end
                -- Do the deed
                if xeffect == "damage" then
                    local damage_dealt = arg:damage(damage)  -- type: physical
                elseif xeffect == "heal" then
                    actor:heal(xamount)
                end
                if xeffect == "transport" then
                    if xamount == -1 then
                        arg:send(tostring(actor.name) .. " waves a hand at you, whisking you away!")
                        local max_tries = 20
                        while max_tries > 0 do
                            arg:teleport(get_room(math.floor(random(1, 60000 / 100)), (random(1, 60000 % 100))))
                            if arg.room ~= actor.room then
                                max_tries = 0
                            end
                            max_tries = max_tries - 1
                        end
                        -- TODO(parity): legacy used `if not max_tries` to detect "never escaped",
                        -- but the loop now decrements past zero so the original safety net
                        -- is dead code. Decide whether to bail to (0,0) on failure.
                    else
                        arg:teleport(get_room(math.floor(xamount / 100), xamount % 100))
                    end
                    arg:command("look")
                elseif xeffect == "area" then
                    local max_tries = 20
                    local target_list = ""
                    while max_tries > 0 do
                        local victim = room.actors[random(1, #room.actors)]
                        if victim then
                            if (victim.id ~= actor.id) and not (string.find(target_list, victim.name, 1, true)) then
                                target_list = target_list .. victim.name .. ","
                                damage = xamount + random(1, 50)
                                if xid == 1 then
                                    victim:send("<yellow>The screech pierces into your head, causing great pain!</> (<b:red>" .. tostring(damage) .. "</>)")
                                    self.room:send_except(victim, "<yellow>" .. tostring(victim.name) .. " grasps " .. tostring(victim.possessive) .. " head in pain.</> (<blue>" .. tostring(damage) .. "</>)")
                                    local damage_dealt = victim:damage(damage)  -- type: physical
                                elseif xid == 2 then
                                    victim:send("<cyan>The sudden blizzard <b:white>chills</><cyan> you to the bone!</> (<b:red>" .. tostring(damage) .. "</>)")
                                    self.room:send_except(victim, "<cyan>" .. tostring(victim.name) .. " shivers and turns blue in the blizzard.</> (<blue>" .. tostring(damage) .. "</>)")
                                    local damage_dealt = victim:damage(damage)  -- type: physical
                                elseif (xid == 5) and (victim.alignment <= -350) then
                                    victim:send("<b:white>You cry out in pain upon hearing " .. tostring(actor.name) .. "'s blessing!</> (<b:red>" .. tostring(damage) .. "</>)")
                                    self.room:send_except(victim, "<b:white>" .. tostring(victim.name) .. " grasps " .. tostring(victim.possessive) .. " head upon hearing " .. tostring(actor.name) .. "'s blessing!</> (<blue>" .. tostring(damage) .. "</>)")
                                    local damage_dealt = victim:damage(damage)  -- type: physical
                                elseif xid == 7 then
                                    victim:send("<blue>The lightning strikes you in the chest, shocking your body!</> (<b:red>" .. tostring(damage) .. "</>)")
                                    self.room:send_except(victim, "<blue>" .. tostring(victim.name) .. " reels back, struck in the chest by the lightning!</> (<blue>" .. tostring(damage) .. "</>)")
                                    local damage_dealt = victim:damage(damage)  -- type: physical
                                end
                            end
                        else
                            max_tries = 0
                        end
                        max_tries = max_tries - 1
                    end
                end
            else
                spell_stop = 1
            end
        end
        -- If the player left somewhere along the way, fail spell
        if spell_stop == 1 then
            actor:send("You stop invoking abruptly!")
            self.room:send_except(actor, tostring(actor.name) .. " stops invoking abruptly!")
        end
    end
else
    -- Do nothing for non-dragonquest mobs
    _return_value = true
end
return _return_value$trig$, '6142a3a80a786cbff65e9804cbf22cbe'),
  -- data/triggers/188/188_21_xcast_xdecide.lua
  (188, 21, $trig$-- Command location mask 3: legacy OCMD_EQUIP=1 (worn), OCMD_INVEN=2 (carried), OCMD_ROOM=4 (floor)
if not (location == "equip" or location == "inventory") then
    return true  -- Not in a location this trigger watches
end

-- Command filter: xdecide
if not (cmd == "xdecide") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
-- 
-- X-decide
-- This trigger works with 18820, x-cast, to cast custom spells with various
-- effects.  It may only be used by mobiles in the 18820 to 18842 range,
-- Laoris' dragonquest mobiles.
-- 
-- Expected variables set by x-decide:
-- xid - unique integer identifier, like 1
-- xname - name of the spell, such as 'arctic blast'
-- xstars - duration to cast the spell, ie., 2
-- xmagic - magic words uttered at the end of the spell, like 'zimblo argis'
-- xeffect - actual effect of the spell, such as 'damage' or 'expel'
-- xmode - sets whether it's victim or self-only
-- xamount - only meaningful for some spell types, ie., 100
-- 
if (actor.zone_id == 188 and actor.id >= 20 and actor.id <= 42) then
    -- Block 'Huh?!?' message
    _return_value = false
    -- Choose spell
    -- These if statements allow the user to only type part of the spell
    -- name, such as just 'arc' for 'arctic blast'.  However, this also
    -- allows 'blast', so making another spell 'blast of fire' is a bad
    -- idea.  Use unique spell names.
    local xid, xname, xstars, xmagic, xeffect, xmode, xamount
    local needle = arg or ""
    if string.find("deadly screech", needle, 1, true) then
        xid = 1; xname = "deadly screech"; xstars = 0
        xmagic = "shelak frhoonl"; xeffect = "area"; xmode = "self"; xamount = 300
    elseif string.find("blizzard", needle, 1, true) then
        xid = 2; xname = "blizzard"; xstars = 2
        xmagic = "shelaki"; xeffect = "area"; xmode = "self"; xamount = 300
    elseif string.find("reconstitution", needle, 1, true) then
        xid = 3; xname = "reconstitution"; xstars = 2
        xmagic = "mellagenipoir"; xeffect = "heal"; xmode = "self"; xamount = 1000
    elseif string.find("hand of transport", needle, 1, true) then
        xid = 4; xname = "hand of transport"; xstars = 2
        xmagic = "franti ay sakchorish"; xeffect = "transport"; xmode = "victim"; xamount = -1
    elseif string.find("defamation", needle, 1, true) then
        xid = 5; xname = "defamation"; xstars = 2
        xmagic = "rotulugeaf"; xeffect = "area"; xmode = "self"; xamount = 400
    elseif string.find("iron maiden", needle, 1, true) then
        xid = 6; xname = "iron maiden"; xstars = 1
        xmagic = "grak oblithron"; xeffect = "transport"; xmode = "victim"; xamount = 18820
    elseif string.find("bodily charge", needle, 1, true) then
        xid = 7; xname = "bodily charge"; xstars = 3
        xmagic = "corpeno elekar"; xeffect = "area"; xmode = "self"; xamount = 500
    elseif string.find("archons curse", needle, 1, true) then
        xid = 8; xname = "archons curse"; xstars = 2
        xmagic = "colrio goladhr"; xeffect = "damage"; xmode = "victim"; xamount = 500
    elseif string.find("caustic conflaguration", needle, 1, true) then
        xid = 9; xname = "caustic conflaguration"; xstars = 2
        xmagic = "akridsi donoeplarinius"; xeffect = "damage"; xmode = "victim"; xamount = 300
    else
        actor:send("That is not a valid x-cast spell.")
    end
    if xname then
        actor:send("x-cast spell set to: " .. tostring(xname))
        globals.xname = xname
        globals.xid = xid
        globals.xstars = xstars
        globals.xmagic = xmagic
        globals.xeffect = xeffect
        globals.xmode = xmode
        globals.xamount = xamount
    end
else
    -- Do nothing for non-dragonquest mobs
    _return_value = true
end
return _return_value$trig$, 'd0a6be4130d0552b9feabf4c3b169333'),
  -- data/triggers/188/188_23_xcast_xlist.lua
  (188, 23, $trig$-- Converted from DG Script #18823: xcast_xlist
-- Original: OBJECT trigger, flags: COMMAND, probability: 3%

-- Command location mask 3: legacy OCMD_EQUIP=1 (worn), OCMD_INVEN=2 (carried), OCMD_ROOM=4 (floor)
if not (location == "equip" or location == "inventory") then
    return true  -- Not in a location this trigger watches
end

-- Command filter: xlist
if not (cmd == "xlist") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
-- 
-- X-list
-- This trigger lists the spells available to x-decide and x-cast, triggers
-- 18820 and 18821.  It may only be used by mobiles in the 18820 to 18842
-- range, Laoris' dragonquest mobiles.
-- 
if (actor.zone_id == 188 and actor.id >= 20 and actor.id <= 42) then
    _return_value = false
    actor:send("X-cast spells:           type       stars  amount")
    actor:send("</> deadly screech          area       0      300")
    actor:send("</> blizzard                area       2      300")
    actor:send("</> reconstitution          heal       2      1000")
    actor:send("</> hand of transport       transport  2")
    actor:send("</> defamation              area       2      400")
    actor:send("</> iron maiden             transport  1")
    actor:send("</> bodily charge           area       3      500")
    actor:send("</> archons curse           damage     2      500")
    actor:send("</> caustic conflaguration  damage     2      300")
else
    _return_value = true
end
return _return_value$trig$, 'bf31cc0bed4d1e311c2fa3695cca4663'),
  -- data/triggers/390/390_04_flood_heart_speech.lua
  (390, 4, $trig$if cmd ~= "say" then
    return true
end
-- Command location mask 3: legacy OCMD_EQUIP=1 (worn), OCMD_INVEN=2 (carried), OCMD_ROOM=4 (floor)
if not (location == "equip" or location == "inventory") then
    return true  -- Not in a location this trigger watches
end

-- Legacy `return 0` ahead of the wait: the player's `say` goes ahead and the script carries on.
allow_command()
wait(2)
if actor:get_quest_stage("flood") == 1 then
    local room = actor.room
    local zone = room.id  -- TODO: should be a (zone_id, local_id) tuple
    if string.find(arg, "the Arabel ocean calls for aid") or string.find(arg, "spirit I have returned") or string.find(arg, "spirit, I have returned") then
        -- 
        -- for Blue-Fog River and Lake
        -- 
        if (room.zone_id == 28 and zone <= 110) then
            local color = "&4"
            local spirit = mobiles.template(390, 13).name
            if world.count_mobiles(390, 13) == 0 and not actor:get_quest_var("flood:water1") then
                self.room:send("<cyan>" .. tostring(self.shortdesc) .. " shimmers with pale light!</>")
                wait(1)
                self.room:spawn_mobile(390, 13)
                self.room:send(tostring(color) .. "A misty blue spirit rises from the water.</>")
            end
            -- 
            -- for Phoenix Feather Hot Springs
            -- 
        elseif (room.zone_id == 103 and zone == 14) or (room.zone_id == 103 and zone == 16) or (room.zone_id == 103 and zone >= 18 and zone <= 35) then
            local color = "&6"
            local spirit = mobiles.template(390, 14).name
            if world.count_mobiles(390, 14) == 0 and not actor:get_quest_var("flood:water2") then
                self.room:send("<cyan>" .. tostring(self.shortdesc) .. " shimmers with pale light!</>")
                wait(1)
                self.room:spawn_mobile(390, 14)
                self.room:send(tostring(color) .. "A shining watery bird rises from the water.</>")
            end
            -- 
            -- for Canyon - multiple lines because one is too long
            -- 
        elseif (room.zone_id == 178 and zone == 2) or (room.zone_id == 178 and zone >= 11 and zone <= 13) or (room.zone_id == 178 and zone == 16) or (room.zone_id == 178 and zone == 17) or (room.zone_id == 178 and zone >= 23 and zone <= 27) then
            local color = "&4&b"
            local spirit = mobiles.template(390, 15).name
            if world.count_mobiles(390, 15) == 0 and not actor:get_quest_var("flood:water3") then
                self.room:send("<cyan>" .. tostring(self.shortdesc) .. " shimmers with pale light!</>")
                wait(1)
                self.room:spawn_mobile(390, 15)
                self.room:send(tostring(color) .. "A three-faced humanoid figure rises from the water.</>")
            end
        elseif (room.zone_id == 178 and zone == 34) or (room.zone_id == 178 and zone >= 39 and zone <= 41) or (room.zone_id == 178 and zone == 47) or (room.zone_id == 178 and zone == 50) or (room.zone_id == 178 and zone >= 53 and zone <= 56) then
            local color = "&4&b"
            local spirit = mobiles.template(390, 15).name
            if world.count_mobiles(390, 15) == 0 and not actor:get_quest_var("flood:water3") then
                self.room:send("<cyan>" .. tostring(self.shortdesc) .. " shimmers with pale light!</>")
                wait(1)
                self.room:spawn_mobile(390, 15)
                self.room:send(tostring(color) .. "A three-faced humanoid figure rises from the water.</>")
            end
        elseif (room.zone_id == 178 and zone == 62) or (room.zone_id == 178 and zone == 67) then
            local color = "&4&b"
            local spirit = mobiles.template(390, 15).name
            if world.count_mobiles(390, 15) == 0 and not actor:get_quest_var("flood:water3") then
                self.room:send("<cyan>" .. tostring(self.shortdesc) .. " shimmers with pale light!</>")
                wait(1)
                self.room:spawn_mobile(390, 15)
                self.room:send(tostring(color) .. "A three-faced humanoid figure rises from the water.</>")
            end
            -- 
            -- for Greengreen Sea
            -- 
        elseif (room.zone_id == 362 and zone <= 31) then
            local color = "&2"
            local spirit = mobiles.template(390, 16).name
            if world.count_mobiles(390, 16) == 0 and not actor:get_quest_var("flood:water4") then
                self.room:send("<cyan>" .. tostring(self.shortdesc) .. " shimmers with pale light!</>")
                wait(1)
                self.room:spawn_mobile(390, 16)
                self.room:send(tostring(color) .. "A hideous creature with distended mouth and belly rises from the water.</>")
            end
            -- 
            -- for SeaWitch
            -- 
        elseif (room.zone_id == 411 and zone <= 142) then
            local color = "&4&b"
            local spirit = mobiles.template(390, 17).name
            actor:send("Watery song whispers in your ear, " .. tostring(color) .. "'The Sea Witch must be removed before I may</>")
            actor:send("</>" .. tostring(color) .. "speak to thee...  Call to me from the bottom of the sea...'</>")
        elseif (room.zone_id == 411 and zone == 143) then
            local color = "&4&b"
            local spirit = mobiles.template(390, 17).name
            if world.count_mobiles(411, 19) == 0 then
                if world.count_mobiles(390, 17) == 0 and not actor:get_quest_var("flood:water5") then
                    self.room:send("<cyan>" .. tostring(self.shortdesc) .. " shimmers with pale light!</>")
                    wait(1)
                    self.room:spawn_mobile(390, 17)
                    self.room:send(tostring(color) .. "The sea's currents noticeably ripple and flux in response.</>")
                end
            else
                actor:send(tostring(color) .. "Watery song whispers in your ear, 'The Sea Witch must be removed before I may</>")
                actor:send("</>" .. tostring(color) .. "speak to thee...'</>")
            end
            -- 
            -- for Frost Valley - two lines
            -- 
        elseif (room.zone_id == 534 and zone >= 38 and zone <= 40) or (room.zone_id == 534 and zone >= 45 and zone <= 49) or (room.zone_id == 534 and zone == 52) or (room.zone_id == 534 and zone == 55) or (room.zone_id == 534 and zone == 56) or (room.zone_id == 534 and zone == 64) then
            local color = "&7&b"
            local spirit = mobiles.template(390, 18).name
            if world.count_mobiles(390, 18) == 0 and not actor:get_quest_var("flood:water6") then
                self.room:send("<cyan>" .. tostring(self.shortdesc) .. " shimmers with pale light!</>")
                wait(1)
                self.room:spawn_mobile(390, 18)
                self.room:send(tostring(color) .. "A willowy white woman rises from the lake.</>")
            end
        elseif (room.zone_id == 534 and zone == 67) or (room.zone_id == 534 and zone == 68) or (room.zone_id == 534 and zone >= 72 and zone <= 75) or (room.zone_id == 534 and zone == 81) or (room.zone_id == 534 and zone == 82) then
            local color = "&7&b"
            local spirit = mobiles.template(390, 18).name
            if world.count_mobiles(390, 18) == 0 and actor:get_quest_var("flood:water6") then
                self.room:send("<cyan>" .. tostring(self.shortdesc) .. " shimmers with pale light!</>")
                wait(1)
                self.room:spawn_mobile(390, 18)
                self.room:send(tostring(color) .. "A willowy icy white woman rises from the lake.</>")
            end
            -- 
            -- for Black Lake
            -- 
        elseif (room.zone_id == 564 and zone >= 2 and zone <= 4) or (room.zone_id == 564 and zone >= 6 and zone <= 31) or (room.zone_id == 370 and zone == 72) then
            local color = "&9&b"
            local spirit = mobiles.template(390, 19).name
            if world.count_mobiles(390, 19) == 0 and not actor:get_quest_var("flood:water7") then
                self.room:send("<cyan>" .. tostring(self.shortdesc) .. " shimmers with pale light!</>")
                wait(1)
                self.room:spawn_mobile(390, 19)
                self.room:send(tostring(color) .. "An inky black shade rises from the depths.</>")
            end
            -- 
            -- for KoD
            -- 
        elseif (room.zone_id == 584 and zone >= 111 and zone <= 119) then
            local color = "&6&b"
            local spirit = mobiles.template(390, 20).name
            if time.hour > 19 or time.hour < 5 then
                if world.count_mobiles(390, 20) == 0 and not actor:get_quest_var("flood:water8") then
                    self.room:send("<cyan>" .. tostring(self.shortdesc) .. " shimmers with pale light!</>")
                    wait(1)
                    self.room:spawn_mobile(390, 20)
                    self.room:send(tostring(color) .. "In a spray of moon-lit iridescent mist, a beautiful translucent blue woman emerges from the stream.</>")
                end
            else
                self.room:send("A giggling voice says, " .. tostring(color) .. "'None dream while the sun shines.'</>")
            end
        end
        wait(1)
        if string.find(arg, "the arabel ocean calls for aid") then
            self.room:find_actor("spirit"):command("mecho %spirit% says, color%'Why does the ocean call for aid?'&0")
        else
            self.room:find_actor("spirit"):command("mecho %spirit% says, color%'Do you have what I asked for?'&0")
        end
    end
end
return true$trig$, 'c8da61b6445a722d5c6e710e1e072a74'),
  -- data/triggers/410/410_05_unused.lua
  (410, 5, $trig$-- 1. Creeping Doom relic drop, per eligible group member.
local function try_creeping_doom_drop(person)
    if person == nil or person.room ~= self.room then
        return
    end
    local stage_ok = person:get_quest_stage("creeping_doom") == 2
    local test_ok = person.level > 80 and (person.zone_id == 10 and person.id <= 38)
    if stage_ok or test_ok then
        if random(1, 50) <= self.level then
            self.room:spawn_object(615, 17)
        end
    end
end

local size = actor.group_size
if size and size > 0 then
    local i = size
    while i > 0 do
        try_creeping_doom_drop(actor.group_member[i])
        i = i - 1
    end
else
    try_creeping_doom_drop(actor)
end

-- 2. Phase 1 miniboss drop table.
local will_drop = random(1, 100)
if will_drop <= 30 then
    -- 30% no drop.
    return
end

local bonus = random(1, 100)
local what_armor_drop = random(1, 3) -- 3 pieces of armor per sub_phase
local what_gem_drop = random(1, 4)   -- 4 classes questing in phase_1

if will_drop <= 70 then
    -- Gem-only tier.
    if bonus <= 50 then
        -- Previous wear-position gem set.
        self.room:spawn_object(555, 73 + what_gem_drop)
    elseif bonus <= 90 then
        -- Current wear-position gem set.
        self.room:spawn_object(555, 77 + what_gem_drop)
    else
        -- Bonus: next wear-position gem set.
        self.room:spawn_object(555, 81 + what_gem_drop)
    end
elseif will_drop <= 90 then
    -- Armor-only tier.
    if bonus <= 50 then
        -- Previous wear-position armor set.
        self.room:spawn_object(553, 7 + what_armor_drop)
    elseif bonus <= 90 then
        -- Current wear-position armor set.
        self.room:spawn_object(553, 11 + what_armor_drop)
    else
        -- Bonus: next wear-position armor set.
        self.room:spawn_object(553, 15 + what_armor_drop)
    end
else
    -- Gem + armor tier (10%).
    if bonus <= 50 then
        self.room:spawn_object(555, 73 + what_gem_drop)
        self.room:spawn_object(553, 7 + what_armor_drop)
    elseif bonus <= 90 then
        self.room:spawn_object(553, 11 + what_armor_drop)
        self.room:spawn_object(555, 77 + what_gem_drop)
    else
        self.room:spawn_object(555, 81 + what_gem_drop)
        self.room:spawn_object(553, 15 + what_armor_drop)
    end
end$trig$, 'd5b917d8193d41e7eb755eb2f297cca7'),
  -- data/triggers/410/410_06_unused.lua
  (410, 6, $trig$-- 1. Creeping Doom relic drop, per eligible group member.
local function try_creeping_doom_drop(person)
    if person == nil or person.room ~= self.room then
        return
    end
    local stage_ok = person:get_quest_stage("creeping_doom") == 2
    local test_ok = person.level > 80 and (person.zone_id == 10 and person.id <= 38)
    if stage_ok or test_ok then
        if random(1, 50) <= self.level then
            self.room:spawn_object(615, 17)
        end
    end
end

local size = actor.group_size
if size and size > 0 then
    local i = size
    while i > 0 do
        try_creeping_doom_drop(actor.group_member[i])
        i = i - 1
    end
else
    try_creeping_doom_drop(actor)
end

-- 2. Phase 1 miniboss drop table.
local will_drop = random(1, 100)
if will_drop <= 30 then
    -- 30% no drop.
    return
end

local bonus = random(1, 100)
local what_armor_drop = random(1, 3) -- 3 pieces of armor per sub_phase
local what_gem_drop = random(1, 4)   -- 4 classes questing in phase_1

if will_drop <= 70 then
    -- Gem-only tier.
    if bonus <= 50 then
        -- Previous wear-position gem set.
        self.room:spawn_object(555, 69 + what_gem_drop)
    elseif bonus <= 90 then
        -- Current wear-position gem set.
        self.room:spawn_object(555, 73 + what_gem_drop)
    else
        -- Bonus: next wear-position gem set.
        self.room:spawn_object(555, 77 + what_gem_drop)
    end
elseif will_drop <= 90 then
    -- Armor-only tier.
    if bonus <= 50 then
        -- Previous wear-position armor set.
        self.room:spawn_object(553, 3 + what_armor_drop)
    elseif bonus <= 90 then
        -- Current wear-position armor set.
        self.room:spawn_object(553, 7 + what_armor_drop)
    else
        -- Bonus: next wear-position armor set.
        self.room:spawn_object(553, 11 + what_armor_drop)
    end
else
    -- Gem + armor tier (10%).
    if bonus <= 50 then
        self.room:spawn_object(555, 69 + what_gem_drop)
        self.room:spawn_object(553, 3 + what_armor_drop)
    elseif bonus <= 90 then
        self.room:spawn_object(553, 7 + what_armor_drop)
        self.room:spawn_object(555, 73 + what_gem_drop)
    else
        self.room:spawn_object(555, 77 + what_gem_drop)
        self.room:spawn_object(553, 11 + what_armor_drop)
    end
end$trig$, '8d79bb693b76875310343b7d2605e568'),
  -- data/triggers/410/410_07_unused.lua
  (410, 7, $trig$-- 1. Creeping Doom relic drop, per eligible group member.
local function try_creeping_doom_drop(person)
    if person == nil or person.room ~= self.room then
        return
    end
    local stage_ok = person:get_quest_stage("creeping_doom") == 2
    local test_ok = person.level > 80 and (person.zone_id == 10 and person.id <= 38)
    if stage_ok or test_ok then
        if random(1, 50) <= self.level then
            self.room:spawn_object(615, 17)
        end
    end
end

local size = actor.group_size
if size and size > 0 then
    local i = size
    while i > 0 do
        try_creeping_doom_drop(actor.group_member[i])
        i = i - 1
    end
else
    try_creeping_doom_drop(actor)
end

-- 2. Boss drop table.
local will_drop = random(1, 100)
if will_drop <= 20 then
    -- 20% no drop (boss has higher drop rate than minibosses).
    return
end

local bonus = random(1, 100)
local what_armor_drop = random(1, 3) -- 3 pieces of armor per sub_phase
local what_gem_drop = random(1, 4)   -- 4 classes questing in phase_1

if will_drop <= 60 then
    -- Gem-only tier.
    if bonus <= 50 then
        -- Previous wear-position gem set.
        self.room:spawn_object(555, 77 + what_gem_drop)
    elseif bonus <= 90 then
        -- Current wear-position gem set.
        self.room:spawn_object(555, 81 + what_gem_drop)
    else
        -- Bonus: next wear-position gem set.
        self.room:spawn_object(555, 85 + what_gem_drop)
    end
elseif will_drop <= 80 then
    -- Armor-only tier.
    if bonus <= 50 then
        -- Previous wear-position armor set.
        self.room:spawn_object(553, 11 + what_armor_drop)
    elseif bonus <= 90 then
        -- Current wear-position armor set.
        self.room:spawn_object(553, 15 + what_armor_drop)
    else
        -- Bonus: next wear-position armor set.
        self.room:spawn_object(553, 19 + what_armor_drop)
    end
else
    -- Gem + armor tier (20%).
    if bonus <= 50 then
        self.room:spawn_object(555, 77 + what_gem_drop)
        self.room:spawn_object(553, 11 + what_armor_drop)
    elseif bonus <= 90 then
        self.room:spawn_object(553, 15 + what_armor_drop)
        self.room:spawn_object(555, 81 + what_gem_drop)
    else
        self.room:spawn_object(555, 85 + what_gem_drop)
        self.room:spawn_object(553, 19 + what_armor_drop)
    end
end$trig$, 'f4da6d8f449610e1650a83603accd6fa'),
  -- data/triggers/481/481_01_open_volcano.lua
  (481, 1, $trig$-- Converted from DG Script #48101: open_volcano
-- Original: WORLD trigger, flags: SPEECH, probability: 0%

-- Speech phrase: buntoi nakkarri karisto (DG num_arg 0 = the speech contains the phrase, not a chance)
if not string.find(string.lower(speech), "buntoi nakkarri karisto", 1, true) then
    return true  -- Not the phrase
end
get_room(481, 48):at(function()
    self.room:send("There is a load groaning noise and a crack develops in the side of the volcano.")
end)
get_room(481, 47):at(function()
    self.room:send("There is a load groaning noise and a crack develops in the side of the volcano.")
end)
wait(2)
get_room(481, 47):at(function()
    self.room:send("Even as you watch the crack widens to the size of a doorway.")
end)
get_room(481, 48):at(function()
    self.room:send("Even as you watch the crack widens to the size of a doorway.")
end)
get_room(481, 47):exit("north"):set_state({hidden = false})
get_room(481, 47):exit("north"):set_state({description = "A passage leads into the heart of the volcano."})
get_room(481, 48):exit("south"):set_state({hidden = false})
get_room(481, 48):exit("south"):set_state({description = "You can see the sky through the doorway!"})
wait(10)
get_room(481, 47):at(function()
    self.room:send("There is a load groaning noise and the doorway starts to close!")
end)
get_room(481, 48):at(function()
    self.room:send("There is a load groaning noise and the doorway starts to close!")
end)
wait(2)
get_room(481, 47):at(function()
    self.room:send("The volcano shudders as it seals the entrance.")
end)
get_room(481, 48):at(function()
    self.room:send("The volcano shudders as it seals the entrance.")
end)
get_room(481, 47):exit("north"):set_state({hidden = true})
get_room(481, 48):exit("south"):set_state({hidden = true})$trig$, '8fd3a3cf32aa26187baf9ac7c7df7895'),
  -- data/triggers/481/481_149_mccabe_refuse.lua
  (481, 149, $trig$-- Converted from DG Script #48249: McCabe refuse
-- Original: MOB trigger, flags: RECEIVE, probability: 0%

-- DG receive trigger, num_arg 0: the arg list (48252 48251) holds the items
-- other triggers handle; this one runs for every other item. The runtime does not filter on
-- arg_list, so the exclusion lives here. (The converter's percent_chance(0) guard blocked it all.)
if (object.zone_id == 481 and object.id == 152)
    or (object.zone_id == 481 and object.id == 151) then
    return true
end
local _return_value = true  -- Default: allow action
local wand_ids = {
    -- (zone, local_id) pairs for type_wand craft items; populate when ported.
}
local function is_wand_item(obj)
    if not obj then return false end
    for _, pair in ipairs(wand_ids) do
        if obj.zone_id == pair[1] and obj.local_id == pair[2] then
            return true
        end
    end
    return false
end
if is_wand_item(object) then
    return _return_value
else
    _return_value = true
    self:command("eye")
    wait(1)
    actor:send(tostring(self.name) .. " tells you, 'And what exactly am I supposed to do with this?'")
end
return _return_value$trig$, '458abe3eb698f6863809e4f7a995bf1f'),
  -- data/triggers/481/481_163_meteorswarm_new_meteorite_replacement.lua
  (481, 163, $trig$-- Converted from DG Script #48263: meteorswarm_new_meteorite_replacement
-- Original: MOB trigger, flags: SPEECH, probability: 0%

-- Speech phrase: I lost the meteorite (DG num_arg 0 = the speech contains the phrase, not a chance)
if not string.find(string.lower(speech), "i lost the meteorite", 1, true) then
    return true  -- Not the phrase
end
if actor:get_quest_stage("meteorswarm") > 2 and not actor:get_quest_var("meteorswarm:air") then
    wait(2)
    self:command("gasp")
    actor:send(tostring(self.name) .. " says, 'WHAT?!'")
    wait(1)
    actor:send(tostring(self.name) .. " says, 'How could you be so careless??''")
    wait(3)
    actor:send(tostring(self.name) .. " says, 'You have no choice, you have to get a new meteorite.'")
    actor:set_quest_var("meteorswarm", "new", "yes")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'You already know where the rock demon is.'")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'Good luck.'")
end$trig$, 'b4770f971ed0948b3caad64793d102ed'),
  -- data/triggers/481/481_199_meteorswarm_status_checker.lua
  (481, 199, $trig$-- Converted from DG Script #48299: meteorswarm_status_checker
-- Original: MOB trigger, flags: SPEECH, probability: 0%

-- Speech phrase: spell progress (DG num_arg 0 = the speech contains the phrase, not a chance)
if not string.find(string.lower(speech), "spell progress", 1, true) then
    return true  -- Not the phrase
end
local stage = actor:get_quest_stage("meteorswarm")
wait(2)
if actor:get_quest_var("meteorswarm:new") ~= "yes" then
    actor:send(tostring(self.name) .. " says, 'Go find a new meteorite.'")
    return true
elseif actor:get_quest_var("meteorswarm:new") ~= "no" then
    actor:send(tostring(self.name) .. " says, 'Show me the meteorite again.'")
    return true
end
-- switch on stage
if stage == 1 then
    actor:send(tostring(self.name) .. " tells you, 'You need to find Jemnon and <b:cyan>ask about the rock demon</>.  He's in some <b:cyan>tavern</>, no doubt, waiting for some new blunder to embark on.'")
elseif stage == 2 then
    actor:send(tostring(self.name) .. " tells you, 'Find a suitable focus by defeating the rock demon in Templace.'")
    if actor:get_quest_var("meteorswarm:earth") == 0 then
    elseif stage == 3 then
        actor:send(tostring(self.name) .. " tells you, 'Show me the meteorite.'")
    else
        if actor:get_quest_var("meteorswarm:fire") == 0 then
            actor:send(tostring(self.name) .. " tells you, 'Find and kill the high fire priest in the Lava Tunnels.  Then enter the lava bubble below his secret chambers.'")
        else
            actor:send(tostring(self.name) .. " tells you, 'Find the lava bubble in the high fire priest's secret chambers.'")
        end
    end
    wait(1)
    actor:send(tostring(self.name) .. " says, 'If you somehow lost the meteorite, say <b:red>\"I lost the meteorite\"</>.'")
elseif stage == 4 then
    actor:send(tostring(self.name) .. " tells you, 'Convince the ancient dragon Dargentan to teach you the ways of air magic.'")
    wait(1)
    actor:send(tostring(self.name) .. " says, 'If you somehow lost the meteorite, say <b:red>\"I lost the meteorite\"</>.'")
    if actor:get_quest_var("meteorswarm:air") == 0 then
    elseif stage == 5 then
        actor:send(tostring(self.name) .. " tells you, 'Show me the meteorite now that you have mastered earth, fire, and air.'")
        wait(1)
        actor:send(tostring(self.name) .. " says, 'If you somehow lost the meteorite, say <b:red>\"I lost the meteorite\"</>.'")
    else
        actor:send(tostring(self.name) .. " tells you, 'Take your finished focus and unleash its potential!'")
    end
end$trig$, '1b2b4cce0521e36dc4e5ea060fb348f9'),
  -- data/triggers/484/484_103_mighty_druid_creeping_doom.lua
  (484, 103, $trig$-- Converted from DG Script #48503: mighty druid creeping doom
-- Original: WORLD trigger, flags: GLOBAL, probability: 100%
for _, person in ipairs(self:get_people()) do
    if (person.zone_id ~= 484 or person.id < 100 or person.id > 199) then
        local damage = 190 + random(1, 20)
        if person:has_effect(Effect.Sanctuary) then
            damage = damage / 2
        end
        if person:has_effect(Effect.Stone) then
            damage = damage / 2
        end
        self.room:send("<blue>&9The mighty druid sends out an endless wave of crawling </><red>arachnoids<blue>&9 and </><green>insects<blue>&9 to consume his foes!</> (<b:red>" .. tostring(damage) .. "</>)")
        local damage_dealt = person:damage(damage)  -- type: physical
    end
end$trig$, '4216cbfcdd2f8fb493f40c9470ce225e'),
  -- data/triggers/484/484_29_hunt_refuse.lua
  (484, 29, $trig$-- Converted from DG Script #48429: Hunt refuse
-- Original: MOB trigger, flags: RECEIVE, probability: 0%

-- DG receive trigger, num_arg 0: the arg list (48429) holds the items
-- other triggers handle; this one runs for every other item. The runtime does not filter on
-- arg_list, so the exclusion lives here. (The converter's percent_chance(0) guard blocked it all.)
if (object.zone_id == 484 and object.id == 29) then
    return true
end
local _return_value = true  -- Default: allow action
-- switch on object.id
local response = "Why do you bother the Goddess of the Hunt?"
if response then
    _return_value = true
    self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
    wait(2)
    actor:send(tostring(self.name) .. " says, '" .. tostring(response) .. "'")
end
return _return_value$trig$, '45dd029429a06ac7a38984d34d152057'),
  -- data/triggers/489/489_05_lokari_echoes_of_justice.lua
  (489, 5, $trig$-- Converted from DG Script #48905: lokari echoes of justice
-- Original: WORLD trigger, flags: GLOBAL, probability: 100%
self.room:send("Lokari starts casting <b:yellow>'echoes of justice'</>...")
wait(1)
self.room:send("Lokari utters the words, 'sdorj lp kandiso'.")
self.room:send("<green>Lokari's justice spreads through the room, striking down trespassers!</>")
for _, person in ipairs(self:get_people()) do
    if person and (person.zone_id ~= 489) and (person.level < 100) then
        local damage = 150 + random(1, 100)
        if person:has_effect(Effect.Sanctuary) then
            damage = damage / 2
        end
        if person:has_effect(Effect.Stone) then
            damage = damage / 2
        end
        -- Chance for critical hit
        local variant = random(1, 15)
        if variant == 1 then
            damage = damage / 2
        elseif variant == 15 then
            damage = damage * 2
        end
        local globed = person:has_effect(Effect.Major_Globe)
        if globed then
            damage = damage / 2
            self.room:send_except(person, "<b:red>The shimmering globe around " .. tostring(person.name) .. "'s body wavers under </><yellow>Lokari's justice<b:red>.</> (<blue>" .. tostring(damage) .. "</>)")
            person:send("<b:red>You shiver as </><yellow>Lokari's justice<b:red> rips through the shimmering globe around your body, striking you!</> (<b:red>" .. tostring(damage) .. "</>)")
        else
            self.room:send_except(person, "<yellow>" .. tostring(person.name) .. " slumps under the knowledge of " .. tostring(person.possessive) .. " own wrongdoing.</> (<blue>" .. tostring(damage) .. "</>)")
            person:send("<yellow>You slump under the knowledge of your own wrongdoing.</> (<b:red>" .. tostring(damage) .. "</>)")
        end
        person:damage(damage)  -- type: physical
    end
end$trig$, '816f5af8108fbab4a90faf627187b99a'),
  -- data/triggers/489/489_06_lokari_throw_player.lua
  (489, 6, $trig$-- TODO(parity): the converter botched the victim1/victim2 picking loops:
-- block-scoped `local max_tries = 0` rebinds didn't actually break the outer
-- loop, victim1 was scoped inside the loop so unreachable below, and the
-- `_return_value` orphan was undefined. The rewrite below restores intent.
local victim1
for _ = 1, 6 do
    local candidate = room.actors[random(1, #room.actors)]
    if candidate and (candidate.zone_id ~= 489) and (candidate.level < 100) then
        victim1 = candidate
        break
    end
end
if not victim1 then
    return true
end
local victim2
for _ = 1, 10 do
    local candidate = room.actors[random(1, #room.actors)]
    if candidate and (candidate.zone_id ~= 489) and (candidate.level < 100) and (victim1.name ~= candidate.name) then
        victim2 = candidate
        break
    end
end
if not victim2 then
    return true
end
local damage1 = 75 + random(1, 50)
local damage2 = 75 + random(1, 50)
if victim1:has_effect(Effect.Sanctuary) then
    -- Half damage for sanc
    damage1 = damage1 / 2
end
if victim1:has_effect(Effect.Stone) then
    -- Another 50 damage for target2 if target1 has stoneskin
    damage2 = damage2 + 50
end
-- Chance for critical hit
local variant = random(1, 15)
if variant == 1 then
    damage1 = damage1 / 2
elseif variant == 15 then
    damage1 = damage1 * 2
end
if victim2:has_effect(Effect.Sanctuary) then
    -- Half damage for sanc
    damage2 = damage2 / 2
end
if victim2:has_effect(Effect.Stone) then
    -- Another 50 damage for target1 if target2 has stoneskin
    damage1 = damage1 + 50
end
-- Chance for critical hit
local variant = random(1, 15)
if variant == 1 then
    damage2 = damage2 / 2
elseif variant == 15 then
    damage2 = damage2 * 2
end
self.room:send_except(victim1, "Lokari waves a hand at " .. tostring(victim1.name) .. ", picking " .. tostring(victim1.object) .. " up into the air!")
victim1:send("Lokari waves a hand at you, picking you up into the air!")
victim2:teleport(get_room(11, 0))
self.room:send_except(victim1, "Lokari smashes " .. tostring(victim1.name) .. " into " .. tostring(victim2.name) .. " with a flick of his wrist! (<blue>" .. tostring(damage1) .. "</>) (<blue>" .. tostring(damage2) .. "</>)")
victim1:send("Lokari smashes you into " .. tostring(victim2.name) .. " with a flick of his wrist! (<b:red>" .. tostring(damage1) .. "</>) (<blue>" .. tostring(damage2) .. "</>)")
victim2:send("Lokari smashes " .. tostring(victim1.name) .. " into you with a flick of his wrist! (<b:red>" .. tostring(damage2) .. "</>) (<blue>" .. tostring(damage1) .. "</>)")
victim2:teleport(get_room(489, 80))
local damage_dealt = victim1:damage(damage1)  -- type: physical
local damage_dealt = victim2:damage(damage2)  -- type: physical$trig$, 'ba8706bef65cd437efda182b445857db'),
  -- data/triggers/489/489_12_maid-cleric_spells.lua
  (489, 12, $trig$-- Clear stop-casting message
if globals.stop_casting then
    globals.stop_casting = nil
end
if globals.casting then
    return true
end
globals.casting = 1
local heal_chance = random(1, 10)
if (globals.healing and (heal_chance > 2)) or (heal_chance == 10) then
    self.room:send("A maid in waiting starts casting <b:yellow>'group heal'</>...")
    wait(5)
    if globals.stop_casting then
        -- Stop casting if we've been passed a stop-casting message
        globals.stop_casting = nil
        globals.casting = nil
        return true
    end
    self.room:send("A maid in waiting completes her spell...")
    self.room:send("A maid in waiting utters the words, 'craes poir'.")
    -- Heal Lokari and any of his three maids that are still alive.
    if world.count_mobiles(489, 1) > 0 then
        self.room:find_actor("lokari"):heal(450)
    end
    if world.count_mobiles(489, 15) > 0 then
        self.room:find_actor("maid-rogue"):heal(450)
    end
    if world.count_mobiles(489, 22) > 0 then
        self.room:find_actor("maid-sorcerer"):heal(450)
    end
    if world.count_mobiles(489, 23) > 0 then
        self.room:find_actor("maid-cleric"):heal(450)
    end
else
    -- Alternate between good and evil spells.
    if globals.spell == "good" then
        globals.spell = "evil"
    else
        globals.spell = "good"
    end
    local spell = globals.spell
    if spell == "good" then
        self.room:send("A maid in waiting starts casting <b:yellow>'consecration'</>...")
    else
        self.room:send("A maid in waiting starts casting <b:yellow>'sacrilege'</>...")
    end
    wait(2)
    if globals.stop_casting then
        -- Stop casting if we've been passed a stop-casting message
        globals.stop_casting = nil
        globals.casting = nil
        return true
    end
    if spell == "good" then
        self.room:send("A maid in waiting utters the words, 'parl xafm'.")
        self.room:send("<b:white>A maid in waiting speaks a word of divine consecration!</>")
    else
        self.room:send("A maid in waiting utters the words, 'ebparl xafm'.")
        self.room:send("<blue>&9A maid in waiting speaks a word of demonic sacrilege!</>")
    end
    for _, person in ipairs(self:get_people()) do
        if (person.zone_id ~= 489) and (person.level < 100) then
            local hit = (spell == "good" and person.alignment < -349)
                     or (spell == "evil" and person.alignment > 349)
            if hit then
                local globed = person:has_effect(Effect.Major_Globe)
                if globed then
                    -- No damage for major globe
                    self.room:send_except(person, "<b:red>The shimmering globe around " .. tostring(person.name) .. "'s body flares as the maid's spell flows around it.</>")
                    person:send("<b:red>The shimmering globe around your body flares as the spell flows around it.</>")
                else
                    local damage = 210 + random(1, 20)
                    if person:has_effect(Effect.Sanctuary) then
                        damage = damage / 2
                    end
                    if person:has_effect(Effect.Stone) then
                        damage = damage / 2
                    end
                    -- Chance for critical hit
                    local variant = random(1, 20)
                    if variant == 1 then
                        damage = damage / 2
                    elseif variant == 20 then
                        damage = damage * 2
                    end
                    if spell == "good" then
                        self.room:send_except(person, "<b:white>" .. tostring(person.name) .. " cries out in anguish upon hearing the maid's blessing!</> (<blue>" .. tostring(damage) .. "</>)")
                        person:send("<b:white>You cry out in anguish upon hearing the maid's blessing!</> (<b:red>" .. tostring(damage) .. "</>)")
                    else
                        self.room:send_except(person, "<blue>&9" .. tostring(person.name) .. " screams in torment upon hearing the maid's curse!</> (<blue>" .. tostring(damage) .. "</>)")
                        person:send("<blue>&9You scream in torment upon hearing the maid's curse!</> (<b:red>" .. tostring(damage) .. "</>)")
                    end
                    person:damage(damage)  -- type: physical
                end
            end
        end
    end
end
wait(2)
globals.casting = nil$trig$, '5e5e2c4363859584f97dfeae92481b5f'),
  -- data/triggers/489/489_25_dark_servant_fight.lua
  (489, 25, $trig$-- Stop combat if our current target is another doom mobile (48900-48999)
-- and rest in a holding room while we recover.
if (actor.zone_id == 489) then
    wait(1)
    get_room(11, 0):at(function()
        self.room:find_actor("dark-servant"):heal(1000)
    end)
end
wait(2)
local chance = random(1, 10)
if chance > 3 then
    -- 70% chance to do nothing this round.
    return true
elseif chance == 1 then
    -- 10% chance to hitall
    self:attack_all()
    return true
elseif (chance == 2) and (self.zone_id == 489 and self.id == 9) then
    -- 10% chance for the warrior dark-servant to re-target onto an
    -- Assassin or Thief in the room.
    local victim
    for _ = 1, 9 do
        local candidate = room.actors[random(1, #room.actors)]
        if candidate and (candidate.class == "Assassin" or candidate.class == "Thief") then
            victim = candidate
            break
        end
    end
    if victim and victim.is_player then
        combat.engage(victim)
    end
    return true
else
    -- Warrior servant: 10% chill-drain. Non-warrior servants: 20% chill-drain.
    -- Pick a non-doom player; fall back to the current attacker if it's the
    -- dark-servant's current victim and is itself a doom mob (matches the
    -- DG fallback path).
    local victim
    for _ = 1, 5 do
        local candidate = room.actors[random(1, #room.actors)]
        if candidate and (candidate.zone_id ~= 489) then
            victim = candidate
            break
        end
    end
    if not victim then
        if actor and (actor.zone_id == 489 and actor.id >= 1 and actor.id <= 98) then
            victim = actor
        else
            return true
        end
    end
    local casters = "Sorcerer Cryomancer Pyromancer Necromancer Cleric Priest Diabolist Druid Conjurer Shaman"
    -- Be nice to casters
    local damage
    if string.find(casters, tostring(victim.class)) then
        damage = 200 + random(1, 30)
    else
        damage = 380 + random(1, 30)
    end
    local damage_dealt = victim:damage(damage)  -- type: heal
    if damage_dealt == 0 then
        self.room:send_except(victim, tostring(self.name) .. " reaches a <blue>&9shadowy</> limb towards " .. tostring(victim.name) .. ", but cannot draw out any life. (<blue>" .. tostring(damage_dealt) .. "</>)")
        victim:send(tostring(self.name) .. " reaches a <blue>&9shadowy</> limb towards you, but cannot draw out any life. (<b:red>" .. tostring(damage_dealt) .. "</>)")
    else
        self.room:send_except(victim, tostring(self.name) .. " reaches a <blue>&9shadowy</> limb towards " .. tostring(victim.name) .. ", <b:blue>chilling</> " .. tostring(victim.object) .. " to the <b:white>bone</>! (<blue>" .. tostring(damage_dealt) .. "</>)")
        victim:send(tostring(self.name) .. " reaches a <blue>&9shadowy</> limb towards you, <b:blue>chilling</> you to the <b:white>bone</>! (<b:red>" .. tostring(damage_dealt) .. "</>)")
    end
    local amount = damage_dealt * 2
    self.room:find_actor("dark-servant"):heal(amount)
end$trig$, 'a4716d6d03b5141f984cd6501356fdcc'),
  -- data/triggers/489/489_26_sunchild_fight.lua
  (489, 26, $trig$-- Converted from DG Script #48926: sunchild fight
-- Original: MOB trigger, flags: FIGHT, probability: 100%
local chance = random(1, 10)
if (actor.zone_id == 489) then
    -- Stop combat if fighting another doom mobile
    wait(1)
    get_room(11, 0):at(function()
        self.room:find_actor("sunchild"):heal(1000)
    end)
elseif chance <= 2 then
    wait(2)
    self.room:send("<yellow>A Sunchild <blue>flares brightly</><yellow>, casting rays of <white>light<yellow> everywhere!</>")
    local room = self.room
    for _, person in ipairs(room:get_people()) do
        if person.is_player then
            spells.cast(self, "sunray", person, 100)
        end
    end
end$trig$, 'ccffa4d2dd622e89de1a482fa794d3d8'),
  -- data/triggers/489/489_27_jann_warrior_fight.lua
  (489, 27, $trig$-- Converted from DG Script #48927: jann warrior fight
-- Original: MOB trigger, flags: FIGHT, probability: 100%
if (actor.zone_id == 489) then
    -- Stop combat if fighting another doom mobile
    wait(1)
    get_room(11, 0):at(function()
        self.room:find_actor("jann"):heal(1000)
    end)
end
wait(2)
local action = random(1, 10)
if action > 9 then
    -- 10% chance
    self:attack_all()
elseif action > 7 then
    -- 20% chance
    skills.execute(self, "kick", self.fighting)
elseif action > 5 then
    -- 10% chance to dispel magic
    if actor.is_player then
        if (self.zone_id == 489 and self.id == 11) then
            self.room:spawn_object(489, 28)
        else
            self.room:spawn_object(489, 27)
        end
        self:command("recite dispel-scroll " .. tostring(actor.name))
        self:destroy_item("dispel-scroll")
    else
        self:command("roar")
    end
end$trig$, '8a8a767f06460cc82adf5e09eaa83535'),
  -- data/triggers/489/489_28_keep_servant_fight.lua
  (489, 28, $trig$-- Converted from DG Script #48928: keep servant fight
-- Original: MOB trigger, flags: FIGHT, probability: 100%
if (actor.zone_id == 489) then
    -- Stop combat if fighting another doom mobile
    wait(1)
    get_room(11, 0):at(function()
        self.room:find_actor("keep-servant"):heal(1000)
    end)
end$trig$, '6219c370a258b56b784165bfdf8924fd'),
  -- data/triggers/489/489_29_gardener_mystic_fight.lua
  (489, 29, $trig$-- Converted from DG Script #48929: gardener mystic fight
-- Original: MOB trigger, flags: FIGHT, probability: 100%
if (actor.zone_id == 489) then
    -- Stop combat if fighting another doom mobile
    wait(1)
    get_room(11, 0):at(function()
        self.room:find_actor("gardener-mystic"):heal(1000)
    end)
end$trig$, '0c37a850764896e650a14b5665cef09e'),
  -- data/triggers/489/489_30_lokari_s_wiseman_fight.lua
  (489, 30, $trig$-- Converted from DG Script #48930: lokari's wiseman fight
-- Original: MOB trigger, flags: FIGHT, probability: 100%
if (actor.zone_id == 489) then
    -- Stop combat if fighting another doom mobile
    wait(1)
    get_room(11, 0):at(function()
        self.room:find_actor("lokaris-wiseman"):heal(1000)
    end)
end$trig$, '11efddd26ea85eab90474acf1fb6b3e1'),
  -- data/triggers/489/489_31_wandering_minstrel_fight.lua
  (489, 31, $trig$if (actor.zone_id == 489) then
    -- Stop combat if fighting another doom mobile
    wait(1)
    get_room(11, 0):at(function()
        self.room:find_actor("wandering-minstrel"):heal(1000)
    end)
end
if self:get_eff_flagged("silence") then
    return true
end

-- TODO(parity): cooldown originally tracked via per-trigger globals `now`/
-- `now2`. We collapsed both into a single 5-tick gate keyed by
-- `globals.minstrel_song_cooldown`; revisit if the level branches need
-- independent cadence.
local cooldown = globals.minstrel_song_cooldown
if cooldown and (timestamp() - cooldown < 5) then
    return true
end

if self.level >= 70 then
    if actor.group_size and actor.group_size > 1 then
        for _, person in ipairs(self.room:get_people()) do
            if person.is_player and not person:get_has_spell("terror") and not person:get_has_spell("ballad of tears") then
                self:perform("ballad of tears", person, self.level)
                globals.minstrel_song_cooldown = timestamp()
                return true
            end
        end
    end
elseif self.level >= 10 then
    if actor and not actor:get_has_spell("terror") and not actor:get_has_spell("ballad of tears") then
        self:perform("terror", actor, self.level)
        globals.minstrel_song_cooldown = timestamp()
    end
end$trig$, '1b28648ae205ae211163434915f28975'),
  -- data/triggers/489/489_32_severan_fight.lua
  (489, 32, $trig$-- Converted from DG Script #48932: severan fight
-- Original: MOB trigger, flags: FIGHT, probability: 100%
if self.room ~= get_room(489, 60) then
    self:emote("emits a loud wail, and returns to the site where he is bound.")
    self:teleport(get_room(489, 60))
end
if (actor.zone_id == 489) then
    -- Stop combat if fighting another doom mobile
    wait(1)
    get_room(11, 0):at(function()
        self.room:find_actor("severan"):heal(1000)
    end)
end
wait(1)
local action = random(1, 10)
if action > 9 then
    -- 10% chance
    wait(1)
    self:attack_all()
elseif action > 6 then
    -- 20% chance for Shockwave area attack, 150-300 damage
    run_room_trigger(489, 33)
end
-- 70% chance to do nothing!$trig$, '8a19622779daba06b64d084bc66fca63'),
  -- data/triggers/489/489_33_severan_shockwave.lua
  (489, 33, $trig$self.room:send("<b:white>The white aura around Severan's body intensifies, increasing in brightness.</>")
wait(2)
self.room:send("<b:white>A powerful shockwave leaps off Severan's body as the aura flares wildly!</>")
local casters = "Sorcerer Necromancer Cryomancer Pyromancer Cleric Druid Diabolist Priest Shaman Conjurer"
for _, person in ipairs(self:get_people()) do
    if (person.zone_id ~= 489) and (person.level < 100) then
        local damage
        if string.find(casters, tostring(person.class)) then
            damage = 100 + random(1, 50)
        else
            damage = 250 + random(1, 50)
        end
        if person:has_effect(Effect.Sanctuary) then
            damage = damage / 2
        end
        if person:has_effect(Effect.Stone) then
            damage = damage / 2
        end
        -- Chance for critical hit
        local variant = random(1, 15)
        if variant == 1 then
            damage = damage / 2
        elseif variant == 15 then
            damage = damage * 2
        end
        -- Halve damage AGAIN for major globe
        local globed = person:has_effect(Effect.Major_Globe)
        if globed then
            damage = damage / 2
        end
        local damage_dealt = person:damage(damage)  -- type: crush
        if damage_dealt == 0 then
            self.room:send_except(person, "<b:white>The blast passes through " .. tostring(person.name) .. ", causing no damage.</>")
            person:send("<b:white>The blast passes through you harmlessly.</>")
        elseif globed then
            self.room:send_except(person, "<b:red>The shimmering globe around " .. tostring(person.name) .. "'s body wavers as the blast overwhelms it!</> (<blue>" .. tostring(damage_dealt) .. "</>)")
            person:send("<b:red>The <white>blast<red> passes through the shimmering globe around your body, striking you!</> (<b:red>" .. tostring(damage_dealt) .. "</>)")
        else
            self.room:send_except(person, "<b:white>The blast strikes " .. tostring(person.name) .. " violently, tearing at " .. tostring(person.possessive) .. " flesh!</> (<blue>" .. tostring(damage_dealt) .. "</>)")
            person:send("<b:white>The blast strikes you violently, rending your flesh!</> (<b:red>" .. tostring(damage_dealt) .. "</>)")
        end
    end
end$trig$, 'c9d37b54fc252ed5c4eacae59c7da0ba'),
  -- data/triggers/490/490_18_crowley_speak2.lua
  (490, 18, $trig$-- Converted from DG Script #49018: crowley_speak2
-- Original: MOB trigger, flags: SPEECH, probability: 0%

-- Speech phrase: the seer requests your assistance (DG num_arg 0 = the speech contains the phrase, not a chance)
if not string.find(string.lower(speech), "the seer requests your assistance", 1, true) then
    return true  -- Not the phrase
end
wait(2)
self:set_flag("sentinel", true)
if actor:get_quest_stage("griffin_quest") < 3 then
    self:say("Oh, does she now?  Are you certain?")
    self:command("peer " .. tostring(actor.name))
elseif actor.is_player then
    self:say("Oh, I had hoped this would never happen.")
    self:command("hiccup")
    wait(4)
    self.room:send(tostring(self.name) .. " says, 'I suppose she told you that I know where the cult's chapel is?'")
    self:command("sigh")
    wait(2)
    self.room:send(tostring(self.name) .. " says, 'I rolled a boulder over the entrance and persuaded Derceta to guard it.  I used to be quite strong in my youth.'")
    self:command("strut")
    wait(2)
    self:say("But drink has done away with that.")
    wait(3)
    self.room:send(tostring(self.name) .. " says, 'In fact, the only person who I can think of who could possibly move it would be Derceta.  I suggest you ask her to help move the boulder.'")
    wait(3)
    self:emote("takes a swig from his waterskin.")
    self:say("Ah, the drink helps me forget, but not for long.")
end
self:set_flag("sentinel", false)$trig$, '1eaf91cc4c3d8a22df21eef9dda7b26c'),
  -- data/triggers/490/490_20_seer_speak1.lua
  (490, 20, $trig$-- Converted from DG Script #49020: seer_speak1
-- Original: MOB trigger, flags: SPEECH, probability: 0%

-- Speech phrase: Earle sends me (DG num_arg 0 = the speech contains the phrase, not a chance)
if not string.find(string.lower(speech), "earle sends me", 1, true) then
    return true  -- Not the phrase
end
wait(2)
if self.room ~= get_room(490, 78) then
    self:say("I am powerless to help you outside my cave.")
else
    -- switch on actor:get_quest_stage("griffin_quest")
    if actor:get_quest_stage("griffin_quest") == 0 then
        self.room:send(tostring(self.name) .. " says, 'You say Earle sent you?  Hmm, he may have done, but there is nothing I can do for you.'")
    elseif actor:get_quest_stage("griffin_quest") == 1 then
        self.room:send(tostring(self.name) .. " says, 'Did you give the rune sword to Earle yet?  He has to verify that you can go through with this.'")
    else
        self.room:send(tostring(self.name) .. " says, 'Ah... my vision is coming true.  The cult grows in strength and will soon be strong enough to summon Dagon, the powerful griffin god.'")
        wait(3)
        self.room:send(tostring(self.name) .. " says, 'Seek ye that drunken lout, for he has found the path to the chapel.  Say to him, <b:white>'the seer requests your assistance'</> and he will tell you what he knows.'")
        self:emote("closers her eyes and goes into a trance.")
        wait(3)
        self:emote("wails with fear.")
        self.room:send(tostring(self.name) .. " says, 'I see the future, when an evil greater than Dagon will walk the island.'")
        self:emote("opens her eyes again.")
        wait(2)
        self:command("sigh")
        self:say("There is much to do, and little time to do it.")
    end
    local person = actor
    local stage = 2
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
            if person:get_quest_stage("griffin_quest") == stage then
                person:advance_quest("griffin_quest")
                person:send("<b:white>You have advanced the quest!</>")
            end
        elseif person and person.is_player then
            i = i + 1
        end
        a = a + 1
    end
end$trig$, 'aca86cdd43b98debec0ad115a0140500'),
  -- data/triggers/490/490_30_earle_refuse.lua
  (490, 30, $trig$-- Converted from DG Script #49030: Earle refuse
-- Original: MOB trigger, flags: RECEIVE, probability: 0%

-- DG receive trigger, num_arg 0: the arg list (49001 49029 49037 49045) holds the items
-- other triggers handle; this one runs for every other item. The runtime does not filter on
-- arg_list, so the exclusion lives here. (The converter's percent_chance(0) guard blocked it all.)
if (object.zone_id == 490 and object.id == 1)
    or (object.zone_id == 490 and object.id == 29)
    or (object.zone_id == 490 and object.id == 37)
    or (object.zone_id == 490 and object.id == 45) then
    return true
end
local _return_value = true  -- Default: allow action
-- switch on object.id
if actor:get_quest_stage("major_globe_spell") == 2 then
    if (object.zone_id == 534 and object.id == 51) then
        return _return_value
    end
    if actor:get_quest_stage("major_globe_spell") == 3 then
    elseif (object.zone_id == 580 and object.id == 2) then
        return _return_value
    end
    if actor:get_quest_stage("major_globe_spell") == 4 then
    elseif (object.zone_id == 586 and object.id == 9) then
        return _return_value
    end
end
_return_value = true
self.room:send_except(actor, tostring(actor.name) .. " gives " .. tostring(object.shortdesc) .. " to " .. tostring(self.name) .. ".")
actor:send("You give " .. tostring(object.shortdesc) .. " to " .. tostring(self.name) .. ".")
wait(4)
self:command("shake")
self:say("Sorry, I don't think this will be of any use.")
wait(8)
self:emote("returns " .. tostring(object.shortdesc) .. ".")
return _return_value$trig$, '217855ef08d5109420d9cc6e4155e7b6'),
  -- data/triggers/490/490_99_griffin_quest_status_checker.lua
  (490, 99, $trig$-- Converted from DG Script #49099: griffin_quest_status_checker
-- Original: MOB trigger, flags: SPEECH, probability: 0%

-- Speech phrase: quest progress (DG num_arg 0 = the speech contains the phrase, not a chance)
if not string.find(string.lower(speech), "quest progress", 1, true) then
    return true  -- Not the phrase
end
local stage = actor:get_quest_stage("griffin_quest")
wait(2)
if actor:get_has_completed("griffin_quest") then
    self.room:send(tostring(self.name) .. " says, 'You have destroyed Adramalech and his cult!  Thank you, " .. tostring(actor.name) .. "!'")
    return true
end
-- switch on stage
if stage == 0 then
    self.room:send(tostring(self.name) .. " says, 'I need to see if it is still possible to destroy the cult of the griffin.  Find the wreck of the St. Marvin and retrieve the cutting from the sacred oak.'")
elseif stage == 1 then
    self.room:send(tostring(self.name) .. " says, 'The sword used to cut the oak is also critical.  Bring me the mystic sword from the wreck of the St. Marvin.'")
elseif stage == 2 then
    self.room:send(tostring(self.name) .. " says, 'You'll need oracular guidance.  Go to the Seer and say <b:white>'Earle sends me'</>'")
elseif stage == 3 then
    self.room:send(tostring(self.name) .. " says, 'Get assistance from the strongest person on the island.  Find Derceta and return her crystal earring to her.'")
elseif stage == 4 then
    self.room:send(tostring(self.name) .. " says, 'The entrance to the cult's lair is hidden under a massive boulder.  Find Derceta, return her earring again, and ask her to move the boulder.'")
elseif stage == 5 then
    self.room:send(tostring(self.name) .. " says, 'Find the cult's altar and destroy it.  Go through the gate Derceta unearthed and drop the sapling at the cult's altar.'")
elseif stage == 6 then
    self:say("It is time to destroy the cult!  Slay Dagon!")
elseif stage == 7 then
    self:say("Bring the griffin skin to Awura.")
elseif stage == 8 then
    self.room:send(tostring(self.name) .. " says, 'Now you can strike the final blow and destroy the essence of the god of the cult itself.  Seek out the hidden entrance to the other realms and destroy Adramalech.'")
end$trig$, '0585d848f2290690b78bdb0e0e66b572'),
  -- data/triggers/492/492_25_golden_quill_load.lua
  (492, 25, $trig$-- Converted from DG Script #49225: Golden_quill_load
-- Original: WORLD trigger, flags: GLOBAL, probability: 0%

-- Runs only through run_room_trigger() (DG probability 0 = never automatic); the converter's
-- percent_chance(0) guard blocked those calls.
get_room(584, 122):at(function()
    self.room:spawn_object(492, 51)
end)$trig$, '36e2c6c3c80c3a199ce619d921d8373a'),
  -- data/triggers/550/550_08_master_shaman_refuse.lua
  (550, 8, $trig$-- Converted from DG Script #55008: Master Shaman refuse
-- Original: MOB trigger, flags: RECEIVE, probability: 0%

-- DG receive trigger, num_arg 0: the arg list (55005 55023) holds the items
-- other triggers handle; this one runs for every other item. The runtime does not filter on
-- arg_list, so the exclusion lives here. (The converter's percent_chance(0) guard blocked it all.)
if (object.zone_id == 550 and object.id == 5)
    or (object.zone_id == 550 and object.id == 23) then
    return true
end
local stage = actor:get_quest_stage("wizard_eye")
local desc = tostring(object.shortdesc)
local response
if stage == 2 then
    response = "Is " .. desc .. " really what she sent you to find?"
elseif stage == 5 or stage == 8 then
    response = "Is " .. desc .. " really what she suggested you use?"
elseif stage == 11 then
    response = "What?  " .. desc .. "?  This can't be right."
else
    response = "What is this?"
end
self:command("eye " .. tostring(actor.name))
actor:send(tostring(self.name) .. " says, '" .. response .. "'")
self.room:send(tostring(self.name) .. " refuses " .. desc .. ".")
return true$trig$, 'ff47219b32bc944aef362cd37fcb051e'),
  -- data/triggers/550/550_26_quest_suralla_endquest.lua
  (550, 26, $trig$-- Converted from DG Script #55026: quest_suralla_endquest
-- Original: MOB trigger, flags: SPEECH, probability: 0%

-- Speech phrase: the shrub suffers no longer (DG num_arg 0 = the speech contains the phrase, not a chance)
if not string.find(string.lower(speech), "the shrub suffers no longer", 1, true) then
    return true  -- Not the phrase
end
wait(2)
-- switch on actor:get_quest_stage("cryomancer_subclass")
if actor:get_quest_stage("cryomancer_subclass") == 1 or actor:get_quest_stage("cryomancer_subclass") == 2 then
    actor:send(tostring(self.name) .. " says, 'Interesting, how could you have completed the quest without actually knowing what it is?'")
elseif actor:get_quest_stage("cryomancer_subclass") == 3 then
    actor:send(tostring(self.name) .. " says, 'Nay, you did not partake in ending its suffering.'")
elseif actor:get_quest_stage("cryomancer_subclass") == 4 then
    self:command("thank " .. tostring(actor.name))
    actor:send(tostring(self.name) .. " says, 'Thank you so very much for righting my wrong.'")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'It is for the best.'")
    wait(2)
    self:command("bow " .. tostring(actor.name))
    wait(2)
    actor:send(tostring(self.name) .. " says, 'Type <b:cyan>'subclass'</> to proceed.'")
    actor:complete_quest("cryomancer_subclass")
else
    actor:send(tostring(self.name) .. " says, 'What is going on?  The voices again, it is all happening again......'")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'Wait, I seem to remember something about a quest...  Pity you were not on it.'")
end$trig$, 'aa166233465936509de8184a8ec536f6'),
  -- data/triggers/550/550_28_cryomancer_subclass_status.lua
  (550, 28, $trig$-- Converted from DG Script #55028: cryomancer_subclass_status
-- Original: MOB trigger, flags: SPEECH, probability: 0%

-- Speech phrase: subclass progress (DG num_arg 0 = the speech contains the phrase, not a chance)
if not string.find(string.lower(speech), "subclass progress", 1, true) then
    return true  -- Not the phrase
end
-- switch on actor:get_quest_stage("cryomancer_subclass")
if actor:get_quest_stage("cryomancer_subclass") == 1 then
    wait(2)
    actor:send(tostring(self.name) .. " says, 'It will take a great mage with a dedication to the cold arts to complete the <b:cyan>quest</> I lay before you.  Your reward is simple if you succeed, and I am sure you will enjoy a life of the cold.'")
elseif actor:get_quest_stage("cryomancer_subclass") == 2 then
    wait(2)
    actor:send(tostring(self.name) .. " says, 'It is quite simple.")
    wait(1)
    actor:send(tostring(self.name) .. " says, 'My counterpart, the great Emmath Firehand, long ago battled with me once.'")
    self:emote("reminisces for a brief moment, looking thoughtful.")
    wait(1)
    actor:send(tostring(self.name) .. " says, 'It was not serious by any means, but it did end in a stalemate.  The catch however...'")
    self:command("sigh")
    wait(1)
    actor:send(tostring(self.name) .. " says, 'Is that what we battled over may still be <b:cyan>suffering</>.'")
    self:emote("sighs deeply again.")
elseif actor:get_quest_stage("cryomancer_subclass") == 3 then
    wait(2)
    self:emote("smiles sadly.")
    actor:send(tostring(self.name) .. " says, 'It is a shame really, that poor shrub, it really was an innocent in all of that.'")
    wait(1)
    actor:send(tostring(self.name) .. " says, 'I do feel bad about it.  The poor thing tried to flee us and sought the shaman who created him.'")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'I do not know if that will help you end his suffering or not, but I hope it does.'")
    self:command("grin")
    wait(1)
    actor:send(tostring(self.name) .. " says, 'And the reward will be great if you do.")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'The shrub muttered something about a place with rushing water and some odd warriors being his safety.'")
    wait(1)
    actor:send(tostring(self.name) .. " says, 'Oh!  One last thing.  When you return to claim your reward, be sure to say to me <b:cyan>\"The shrub suffers no longer\"</>, and the prize will be yours.'")
    self:command("smile")
    actor:send(tostring(self.name) .. " says, 'Go about it now.")
elseif actor:get_quest_stage("cryomancer_subclass") == 4 then
    wait(2)
    actor:send(tostring(self.name) .. " says, 'Say <b:cyan>\"The shrub suffers no longer\"</>, and the prize will be yours.'")
else
    if string.find(string.lower(actor.class), "sorcerer") then
        if actor.level >= 10 and actor.level <= 45 then
            if actor.race == "dragonborn_fire" or actor.race == "arborean" then
                actor:send("<red>Your race cannot subclass to cryomancer.</>")
            else
                wait(2)
                actor:send(tostring(self.name) .. " says, 'You are not yet on my quest.'")
            end
        elseif actor.level < 10 then
            wait(2)
            actor:send(tostring(self.name) .. " says, 'Come back to me once you've gained more experience.'")
        elseif actor.level > 45 then
            wait(2)
            actor:send(tostring(self.name) .. " says, 'Unfortunately you are too dedicated to your universalist ways for me to teach you now.'")
        end
    end
end$trig$, '2679e914cb2e6c77896323ba96e1929f'),
  -- data/triggers/550/550_42_wizard_eye_status_checker.lua
  (550, 42, $trig$-- Converted from DG Script #55042: wizard_eye_status_checker
-- Original: MOB trigger, flags: SPEECH, probability: 0%

-- Speech phrase: spell progress (DG num_arg 0 = the speech contains the phrase, not a chance)
if not string.find(string.lower(speech), "spell progress", 1, true) then
    return true  -- Not the phrase
end

local stage = actor:get_quest_stage("wizard_eye")
local item1 = actor:get_quest_var("wizard_eye:item1")
local item2 = actor:get_quest_var("wizard_eye:item2")
local item3 = actor:get_quest_var("wizard_eye:item3")
local item4 = actor:get_quest_var("wizard_eye:item4")
wait(2)
if actor:get_has_completed("wizard_eye") then
    actor:send(tostring(self.name) .. " says, 'You already have the sight of the Great Snow Leopard.'")
    return true
end

local who, visit, thing1, thing2, thing3, thing4

if stage == 1 then
    actor:send(tostring(self.name) .. " says, 'You are trying to find the <b:cyan>gypsy witch in South Caelia Highlands.  Ask her about Wizard Eye.</>'")
    return true
elseif stage == 2 then
    actor:send(tostring(self.name) .. " says, 'The gypsy witch says to find <b:yellow>marigold poultice</> from a healer on the beachhead.'")
    return true
elseif stage == 3 then
    actor:send(tostring(self.name) .. " says, 'Go visit the <b:cyan>Seer of Griffin Isle</> to see what you need to do next.  <b:cyan>Ask her about Wizard Eye</>.'")
    return true
elseif stage == 4 then
    who = "her"
    visit = "have the Seer make you an herbal sachet"
    thing1 = objects.template(23, 29).name
    thing2 = objects.template(237, 53).name
    thing3 = objects.template(480, 5).name
elseif stage == 5 then
    actor:send(tostring(self.name) .. " says, 'Give me the sachet.'")
    return true
elseif stage == 6 then
    actor:send(tostring(self.name) .. " says, 'You are looking for <b:cyan>the apothecary in Anduin</>.'")
    return true
elseif stage == 7 then
    who = "her"
    visit = "get The Green Woman to make you incense"
    thing1 = objects.template(237, 54).name
    thing2 = objects.template(30, 298).name
    thing3 = objects.template(238, 47).name
    thing4 = objects.template(180, 1).name
elseif stage == 8 then
    actor:send(tostring(self.name) .. " says, 'Give me the incense.'")
    return true
elseif stage == 9 or stage == 10 then
    who = "him"
    visit = "see the Oracle of Justice"
    thing1 = objects.template(30, 218).name
    thing2 = objects.template(534, 24).name
    thing3 = objects.template(430, 21).name
    thing4 = objects.template(40, 3).name
elseif stage == 11 then
    actor:send(tostring(self.name) .. " says, 'Give me the crystal ball.'")
    return true
elseif stage == 12 then
    actor:send(tostring(self.name) .. " says, 'All you need to do now is lay back and go to <b:cyan>sleep</>.'")
    return true
else
    actor:send(tostring(self.name) .. " says, 'Progress on what spell?  I am not guiding you.'")
    return true
end

actor:send(tostring(self.name) .. " says, 'You need to " .. visit .. ".'")
if item1 or item2 or item3 or item4 then
    actor:send(tostring(self.name) .. " says, 'You have already given " .. who .. ":'")
    if item1 then
        actor:send("- " .. tostring(thing1))
    end
    if item2 then
        actor:send("- " .. tostring(thing2))
    end
    if item3 then
        actor:send("- " .. tostring(thing3))
    end
    if item4 and thing4 then
        actor:send("- " .. tostring(thing4))
    end
end
actor:send(tostring(self.name) .. " says, 'You still need to bring " .. who .. ":'")
if not item1 then
    actor:send("- <b:yellow>" .. tostring(thing1) .. "</>")
end
if not item2 then
    actor:send("- <b:yellow>" .. tostring(thing2) .. "</>")
end
if not item3 then
    actor:send("- <b:yellow>" .. tostring(thing3) .. "</>")
end
if stage ~= 4 and not item4 and thing4 then
    actor:send("- <b:yellow>" .. tostring(thing4) .. "</>")
end
return true$trig$, 'ecb03f6bbfafaf72e39e05b61dde3c5d'),
  -- data/triggers/580/580_06_charm_person_serenade_speech.lua
  (580, 6, $trig$-- Speech phrase: let me serenade you (DG num_arg 0 = the speech contains the phrase, not a chance)
if not string.find(string.lower(speech), "let me serenade you", 1, true) then
    return true  -- Not the phrase
end
local _return_value = true  -- Default: allow action
if actor:get_quest_stage("charm_person") == 4 then
    wait(2)
    -- switch on self.id
    if (self.zone_id == 30 and self.id == 10) then
        self:say("A little music sounds delightful.  I enjoy the gentle strum of a mandolin.")
    elseif (self.zone_id == 580 and self.id == 17) then
        self:say("How unconventional!  Usually I'm the one doing the wooing.  I dearly love the willowy call of the flute.")
    elseif (self.zone_id == 43 and self.id == 53) then
        self:say("Oh of course.")
        self:command("lick")
        wait(1)
        self:say("What can I say, I'm a sucker for a hot, long pipe.")
        self:command("grin")
    elseif (self.zone_id == 237 and self.id == 21) then
        actor:send(tostring(self.name) .. " tells you telepathically, 'A very strange request.  The only surface-dwelling music I can tolerate is the lute.'")
    elseif (self.zone_id == 584 and self.id == 6) then
        self:say("I would love to hear a tune!  Instruments that sound like the wind meeting the water are my favorite.")
    else
        _return_value = true
    end
end
return _return_value$trig$, '571de3acf400f3003503483f34b3b5ec'),
  -- data/triggers/580/580_08_charm_person_status_checker.lua
  (580, 8, $trig$-- Speech phrase: spell progress (DG num_arg 0 = the speech contains the phrase, not a chance)
if not string.find(string.lower(speech), "spell progress", 1, true) then
    return true  -- Not the phrase
end
wait(2)
local stage = actor:get_quest_stage("charm_person")
if actor:get_has_completed("charm_person") then
    self:say("I have already taught you my signature spell.")
elseif stage == 0 then
    self:say("I have not yet agreed to train you.")
elseif stage == 1 then
    self.room:send(tostring(self.name) .. " says, 'You must find the rod that casts Charm Person in the crypt in")
    self.room:send("</>the Iron Hills.'")
elseif stage == 2 then
    self.room:send(tostring(self.name) .. " says, 'Help the theatre company in Anduin perform their grand finale")
    self.room:send("</>and bring back the unique fire ring they give out afterward.'")
    wait(1)
    self.room:send(tostring(self.name) .. " says, 'They have a number of problems which you will need to work out")
    self.room:send("</>before you can seek out their replacement \"Pippin\" and lure him to his fiery grave.'")
elseif stage == 3 then
    self:say("Locate five musical instruments and bring them to me.")
    if actor:get_quest_var("charm_person:58017") or actor:get_quest_var("charm_person:16312") or actor:get_quest_var("charm_person:48925") or actor:get_quest_var("charm_person:37012") or actor:get_quest_var("charm_person:41119") then
        -- (empty room echo)
        self.room:send("You have already brought me:")
        if actor:get_quest_var("charm_person:58017") then
            self.room:send("- <magenta>" .. tostring(objects.template(580, 17).name) .. "</>")
        end
        if actor:get_quest_var("charm_person:16312") then
            self.room:send("- <magenta>" .. tostring(objects.template(163, 12).name) .. "</>")
        end
        if actor:get_quest_var("charm_person:48925") then
            self.room:send("- <magenta>" .. tostring(objects.template(489, 25).name) .. "</>")
        end
        if actor:get_quest_var("charm_person:37012") then
            self.room:send("- <magenta>" .. tostring(objects.template(370, 12).name) .. "</>")
        end
        if actor:get_quest_var("charm_person:41119") then
            self.room:send("- <magenta>" .. tostring(objects.template(411, 19).name) .. "</>")
        end
    end
    -- (empty room echo)
    self.room:send("You still need to find:")
    if not actor:get_quest_var("charm_person:58017") then
        self.room:send("- <b:magenta>" .. tostring(objects.template(580, 17).name) .. "</>")
    end
    if not actor:get_quest_var("charm_person:16312") then
        self.room:send("- <b:magenta>" .. tostring(objects.template(163, 12).name) .. "</>")
    end
    if not actor:get_quest_var("charm_person:48925") then
        self.room:send("- <b:magenta>" .. tostring(objects.template(489, 25).name) .. "</>")
    end
    if not actor:get_quest_var("charm_person:37012") then
        self.room:send("- <b:magenta>" .. tostring(objects.template(370, 12).name) .. "</>")
    end
    if not actor:get_quest_var("charm_person:41119") then
        self.room:send("- <b:magenta>" .. tostring(objects.template(411, 19).name) .. "</>")
    end
elseif stage == 4 then
    self:say("You must charm the five master charmers.")
    self.room:send("Ask them <b:white>[Let me serenade you]</>.")
    if actor:get_quest_var("charm_person:charm1") or actor:get_quest_var("charm_person:charm2") or actor:get_quest_var("charm_person:charm3") or actor:get_quest_var("charm_person:charm4") or actor:get_quest_var("charm_person:charm5") then
        -- (empty room echo)
        self.room:send("You have already charmed:")
        if actor:get_quest_var("charm_person:charm1") then
            self.room:send("- <magenta>" .. tostring(mobiles.template(30, 10).name) .. "</>")
        end
        if actor:get_quest_var("charm_person:charm2") then
            self.room:send("- <magenta>" .. tostring(mobiles.template(580, 17).name) .. "</>")
        end
        if actor:get_quest_var("charm_person:charm3") then
            self.room:send("- <magenta>" .. tostring(mobiles.template(43, 53).name) .. "</>")
        end
        if actor:get_quest_var("charm_person:charm4") then
            self.room:send("- <magenta>" .. tostring(mobiles.template(237, 21).name) .. "</>")
        end
        if actor:get_quest_var("charm_person:charm5") then
            self.room:send("- <magenta>" .. tostring(mobiles.template(584, 6).name) .. "</>")
        end
    end
    -- (empty room echo)
    self.room:send("You still need to find:")
    if not actor:get_quest_var("charm_person:charm1") then
        self.room:send("- <b:magenta>" .. tostring(mobiles.template(30, 10).name) .. "</>")
    end
    if not actor:get_quest_var("charm_person:charm2") then
        self.room:send("- <b:magenta>" .. tostring(mobiles.template(580, 17).name) .. "</>")
    end
    if not actor:get_quest_var("charm_person:charm3") then
        self.room:send("- <b:magenta>" .. tostring(mobiles.template(43, 53).name) .. "</>")
    end
    if not actor:get_quest_var("charm_person:charm4") then
        self.room:send("- <b:magenta>" .. tostring(mobiles.template(237, 21).name) .. "</>")
    end
    if not actor:get_quest_var("charm_person:charm5") then
        self.room:send("- <b:magenta>" .. tostring(mobiles.template(584, 6).name) .. "</>")
    end
end$trig$, '33946572c70f1a327746585561127055'),
  -- data/triggers/615/615_54_creeping_doom_bugs_death.lua
  (615, 54, $trig$-- Converted from DG Script #61554: creeping_doom_bugs_death
-- Original: MOB trigger, flags: DEATH, probability: 100%
-- TODO(parity): The original DG iterated actor.group_member; the
-- (person.id >= 1000 and person.id <= 1038) test appears to be an old
-- player-id range check from CircleMUD that no longer makes sense
-- against the new schema. Preserved as-is so behaviour matches the
-- pre-conversion intent until we have a confirmed mapping.
local function maybe_drop(person)
    if person and person.room == self.room then
        if person:get_quest_stage("creeping_doom") == 2
            or (person.level > 80 and (person.zone_id == 10 and person.id <= 38)) then
            if random(1, 50) <= self.level then
                self.room:spawn_object(615, 17)
            end
        end
    end
end

local size = actor.group_size or 0
if size > 0 then
    for a = 1, size do
        maybe_drop(actor.group_member and actor.group_member[a])
    end
else
    maybe_drop(actor)
end$trig$, '4ceffe2b4fbfd10b1e284eb448cdeaa1'),
  -- data/triggers/625/625_05_treant_refuse.lua
  (625, 5, $trig$-- Converted from DG Script #62505: Treant refuse
-- Original: MOB trigger, flags: RECEIVE, probability: 0%
--
-- TODO(parity): The legacy script's RECEIVE filter referenced three
-- variable IDs (%wandgem%, %wand_id%, %wandtask3%) that came from a
-- separate phase-wand quest's load script and are not in scope here.
-- DG num_arg 0 = every item not on the arg list (62504), which is excluded below.

-- DG receive trigger, num_arg 0: the arg list (62504) holds the items
-- other triggers handle; this one runs for every other item. The runtime does not filter on
-- arg_list, so the exclusion lives here. (The converter's percent_chance(0) guard blocked it all.)
if (object.zone_id == 625 and object.id == 4) then
    return true
end
wait(1)
self:command("grumble")
self:command("drop " .. tostring(object))$trig$, '912cf1fe1ac17340c0bf89fb7e97a65a'),
  -- data/triggers/625/625_49_undefined.lua
  (625, 49, $trig$-- Converted from DG Script #62549: undefined
-- Original: MOB trigger, flags: DEATH, probability: 0%
--
-- TODO(parity): The legacy script had no body and ran at 0%
-- probability — effectively a placeholder. Left as a no-op.

-- DG death triggers have no chance roll; the converter's percent_chance(0) guard is gone.
return true$trig$, '62cb7e46bf69e2e0964f4f086a8b7d51')
) AS v(zone_id, id, commands, old_md5)
WHERE t.zone_id = v.zone_id
  AND t.id = v.id
  AND md5(t.commands) = v.old_md5
  AND t.commands IS DISTINCT FROM v.commands;

COMMIT;
