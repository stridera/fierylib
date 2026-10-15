-- Trigger fixes: the Black Legion / Eldorian Guard turn-ins (041_03, 041_07, 055_03, 055_07 match the received object on its (zone, id)), the Major Globe journal (004_19 stage dispatch) and the phase wand / mace questmaster receive and status scripts (002_108, 002_114, 002_126). Guarded on the md5 of the bodies at bc35ab3 (= prod post-bc35ab3), so rows edited in Muditor since are left alone.
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
  -- data/triggers/002/002_108_phase_wand_general_receive.lua
  (2, 108, $trig$local function vkey(vnum)
    if vnum >= 200 and vnum <= 399 then return 2, vnum - 200 end
    if vnum >= 11700 and vnum <= 11840 then return 117, vnum - 11700 end
    return math.floor(vnum / 100), vnum % 100
end
local function oname(vnum)
    local z, i = vkey(vnum)
    return objects.template(z, i).name
end
local function mname(vnum)
    local z, i = vkey(vnum)
    return mobiles.template(z, i).name
end
local function is_obj(vnum)
    if type(vnum) ~= "number" then return false end
    local z, i = vkey(vnum)
    return object.zone_id == z and object.id == i
end
-- A quest flag is set when it holds a non-zero value (0 is truthy in Lua).
local function set_(v) return v ~= nil and v ~= 0 and v ~= "" end

local function give_back()
    local bare = string.gsub(string.gsub(object.name, "^%s*[Tt]he%s+", ""), "^%s*[Aa]n?%s+", "")
    self:command("give " .. bare .. " " .. actor.name)
end

local wandstep = globals.wandstep
if not wandstep then return true end
local quest_type = globals.type
local weapon = globals.weapon
local wandgem = globals.wandgem
local wandtask3 = globals.wandtask3
local wandtask4 = globals.wandtask4
local wandvnum = globals.wand_id
local quest = quest_type .. "_wand"
local reward = wandvnum + 1
local minlevel = (wandstep - 1) * 10
local vulcera = (self.zone_id == 481 and self.id == 5)

local job1 = actor:get_quest_var(quest .. ":wandtask1")
local job2 = actor:get_quest_var(quest .. ":wandtask2")
local job3 = actor:get_quest_var(quest .. ":wandtask3")
local job4 = actor:get_quest_var(quest .. ":wandtask4")
local job5 = actor:get_quest_var(quest .. ":wandtask5")
local stage = actor:get_quest_stage(quest)

if not (is_obj(wandgem) or is_obj(wandvnum) or is_obj(wandtask3) or is_obj(wandtask4)) then
    return true
end

-- Note: Vulcera (481/5) has slightly modified responses because she's a real asshole.
local response, check, continue
if stage == 0 then
    response = "You haven't even begun this process yet!"
elseif actor.level < minlevel then
    if vulcera then
        response = "You're far too pathetic to help yet."
    else
        response = "You'll need to be at least level " .. minlevel .. " before I can improve your bond with your weapon."
    end
elseif actor:get_has_completed(quest) then
    if vulcera then
        response = "Idiot.  You already have the most powerful " .. quest_type .. " staff a mere mortal can handle."
    else
        response = "You already have the most powerful " .. quest_type .. " staff in existence!"
    end
elseif stage < wandstep then
    if vulcera then
        response = "Your " .. weapon .. " is far too weak to craft."
    else
        response = "Your " .. weapon .. " isn't ready for improvement yet."
    end
elseif stage > wandstep then
    if vulcera then
        response = "You still expect more of me??  Bah!  Begone."
    else
        response = "I've done all I can already."
    end
elseif (actor:get_quest_var(quest .. ":greet") or 0) == 0 then
    response = "Tell me why you're here first."
elseif (is_obj(wandgem) and set_(job2)) or (is_obj(wandtask3) and set_(job3)) or (is_obj(wandtask4) and set_(job4))
        or ((stage == 6 or stage == 8) and is_obj(wandvnum) and set_(job5)) then
    response = "You already gave me this."
elseif is_obj(wandgem) then
    actor:set_quest_var(quest, "wandtask2", 1)
    check = "yes"
elseif is_obj(wandtask3) then
    actor:set_quest_var(quest, "wandtask3", 1)
    check = "yes"
elseif is_obj(wandtask4) then
    actor:set_quest_var(quest, "wandtask4", 1)
    check = "yes"
elseif is_obj(wandvnum) then
    job1 = actor:get_quest_var(quest .. ":wandtask1")
    job2 = actor:get_quest_var(quest .. ":wandtask2")
    job3 = actor:get_quest_var(quest .. ":wandtask3")
    job4 = actor:get_quest_var(quest .. ":wandtask4")
    if set_(job1) and set_(job2) and set_(job3) and set_(job4) then
        if stage ~= 3 and stage ~= 6 and stage ~= 8 and stage ~= 10 then
            continue = "yes"
        elseif stage == 6 or stage == 8 then
            actor:set_quest_var(quest, "wandtask5", 1)
            self:spawn_object(vkey(wandtask4))
            wait(0.2)
            if stage == 6 then
                wait(0.2)
                self.room:send(self.name .. " slides " .. oname(wandtask3) .. " around " .. oname(wandvnum) .. ".")
                wait(3)
                self.room:send(self.name .. " whispers some arcane syllables.")
                wait(3)
                self.room:send(oname(wandvnum) .. " begins to hum!")
                wait(2)
                self.room:send(self.name .. " says, 'Now, <b:cyan>play</> " .. oname(wandtask4) .. " to unlock your wand's full potential.'")
            elseif stage == 8 then
                local place
                if quest_type == "air" then
                    place = "the crystal megalith on Griffin Isle"
                elseif quest_type == "acid" then
                    place = "the sacred grove in the Highlands"
                elseif quest_type == "ice" then
                    place = "the Altar of the Snow Leopard"
                elseif quest_type == "fire" then
                    place = "the Fire Temple altar"
                end
                wait(0.2)
                self.room:send(self.name .. " utters a powerful enchantment over " .. object.shortdesc .. ".")
                wait(3)
                self.room:send(object.shortdesc .. " begins to glow!")
                wait(1)
                self.room:send(self.name .. " says, 'Now that your staff is primed, take both it and the ward to:")
                self.room:send("- <b:yellow>" .. tostring(place) .. "</>")
                self.room:send("</>and <b:cyan>imbue</> them both with the energies of that place to forge your new staff.'")
            end
            wait(0.2)
            self:command("give all " .. actor.name)
        end
    elseif set_(job1) and set_(job2) and set_(job3) then
        if stage == 10 then
            local room = get_room(vkey(wandtask4))
            actor:set_quest_var(quest, "wandtask4", 1)
            wait(0.2)
            self.room:send(self.name .. " utters eldritch incantations over " .. object.shortdesc .. ".")
            wait(2)
            self.room:send(object.shortdesc .. " begins to crackle with supreme elemental power!")
            wait(1)
            self.room:send(self.name .. " says, 'Now that you've captured the demon's energies, you must make your way deep into the elemental planes.  There, in the full glory of elemental " .. quest_type .. ", find <b:cyan>" .. tostring(room and room.name or "the plane's heart") .. "</> and <b:cyan>imbue</> it with the energy of the plane.'")
            wait(6)
            self:say("It will forge the most powerful staff of " .. quest_type .. " in all the realms!")
            self:command("give all " .. actor.name)
        elseif stage == 3 then
            continue = "yes"
        else
            continue = "no"
        end
    else
        continue = "no"
    end
else
    give_back()
    self.room:send(self.name .. " refuses " .. object.shortdesc .. ".")
    wait(0.2)
    self:say("What's that for?")
end

if continue == "yes" then
    wait(0.2)
    actor:advance_quest(quest)
    world.destroy(object)
    wait(1)
    self:say("Perfect, let me get to work.")
    wait(0.2)
    if stage ~= 7 then
        self.room:send(self.name .. " inlays " .. oname(wandgem) .. " in " .. oname(wandvnum) .. ".")
        wait(2)
    end
    if stage == 3 then
        self.room:send(self.name .. " burns " .. oname(wandtask3) .. " and passes " .. oname(wandvnum) .. " through the smoke.")
    elseif stage == 4 then
        self.room:send(self.name .. " melds " .. oname(wandtask3) .. " with " .. oname(wandvnum) .. ".")
        wait(2)
        self.room:send(self.name .. " binds " .. oname(wandtask4) .. " to the top of " .. oname(wandvnum) .. ".")
    elseif stage == 5 then
        self.room:send(self.name .. " discharges the potency of " .. oname(wandtask3) .. " into " .. oname(wandvnum) .. ".")
    elseif stage == 7 then
        if vulcera then
            self.room:send(self.name .. " lavishly discharges the power of " .. oname(wandvnum) .. " into " .. oname(wandtask3) .. ", transferring its power.")
        else
            self.room:send(self.name .. " discharges the power of " .. oname(wandvnum) .. " into " .. oname(wandtask3) .. ", transferring its power.")
        end
        wait(2)
        self.room:send(self.name .. " inlays " .. oname(wandgem) .. " in " .. oname(wandtask3) .. " and afixes " .. oname(wandtask4) .. " to the top.")
    elseif stage == 9 then
        self.room:send(self.name .. " carefully speaks an incantation to unravel the magic bindings of " .. oname(wandtask3) .. ".")
        wait(2)
        self.room:send(self.name .. " draws the power out of " .. oname(wandtask3) .. " and fuses it into " .. oname(wandvnum) .. ".")
    end
    wait(2)
    self.room:send(self.name .. " utters a few mystic words.")
    wait(1)
    if stage == 7 then
        self.room:send(oname(wandtask3) .. " is transformed into " .. oname(reward) .. "!")
    else
        self.room:send(oname(wandvnum) .. " is transformed into " .. oname(reward) .. "!")
    end
    wait(1)
    if stage == 7 then
        if vulcera then
            self:say("Here.  Be grateful.  Leave.")
        else
            self:say("Here you go, your new staff!")
        end
    else
        self:say("Here you go, your new " .. weapon .. "!")
    end
    self:spawn_object(vkey(reward))
    self:command("give all " .. actor.name)

    -- Experience: a level-band curve on the step's level cap, scaled by class so every class
    -- receives the same proportion of a level.
    local expcap = (wandstep - 1) * 10
    local expmod = 0
    if expcap < 9 then
        expmod = math.floor(((expcap * expcap) + expcap) / 2) * 55
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
    local class = actor.class
    if class == "warrior" or class == "berserker" then
        expmod = expmod + math.floor(expmod / 10)
    elseif class == "paladin" or class == "anti-paladin" or class == "ranger" then
        expmod = expmod + math.floor((expmod * 2) / 15)
    elseif class == "sorcerer" or class == "pyromancer" or class == "cryomancer" or class == "illusionist" or class == "bard" then
        expmod = expmod + math.floor(expmod / 5)
    elseif class == "necromancer" or class == "monk" then
        expmod = expmod + math.floor((expmod * 2) / 5)
    end
    actor:send("<b:yellow>You gain experience!</>")
    local setexp = expmod * 10
    for _ = 1, 5 do
        actor:award_exp(setexp)
    end
    actor:set_quest_var(quest, "greet", 0)
    actor:set_quest_var(quest, "attack_counter", 0)
    for number = 1, 5 do
        actor:set_quest_var(quest, "wandtask" .. number, 0)
    end
elseif continue == "no" then
    give_back()
    self.room:send(self.name .. " refuses " .. object.shortdesc .. ".")
    wait(0.2)
    if not set_(job1) and (not set_(job2) or not set_(job3) or not set_(job4)) then
        local counter = 50
        local remaining = ((actor:get_quest_stage(quest) - 1) * counter) - (actor:get_quest_var(quest .. ":attack_counter") or 0)
        self.room:send(self.name .. " says, 'You still need to attack <b:yellow>" .. remaining .. "</> more times to fully bond with your " .. weapon .. "!'")
        wait(1)
        self:say("I need the other items as well.")
    elseif set_(job1) and (not set_(job2) or not set_(job3) or not set_(job4)) then
        self:say("You have to give me everything else first.")
    end
elseif check == "yes" then
    wait(0.2)
    world.destroy(object)
    self:say("This is just what I need.")
    wait(0.2)
    job1 = actor:get_quest_var(quest .. ":wandtask1")
    job2 = actor:get_quest_var(quest .. ":wandtask2")
    job3 = actor:get_quest_var(quest .. ":wandtask3")
    job4 = actor:get_quest_var(quest .. ":wandtask4")
    if set_(job1) and set_(job2) and set_(job3) and set_(job4) then
        if stage ~= 3 and stage ~= 6 and stage ~= 8 and stage ~= 10 then
            self:say("That's everything!  Now just give me your " .. weapon .. ".")
        elseif stage == 6 or stage == 8 then
            self:say("Let me prime your " .. weapon .. ".")
        end
    elseif (set_(job1) and set_(job2) and set_(job3)) and (stage == 10 or stage == 5 or stage == 3 or stage == 9) then
        if stage == 10 then
            self:say("Let me prime your " .. weapon .. ".")
        elseif stage == 3 then
            self:say("That's everything!  Now just give me your " .. weapon .. ".")
        elseif stage == 5 then
            self.room:send(self.name .. " says, 'Now go <b:cyan>imbue</> your " .. weapon .. " at " .. tostring(wandtask4) .. " and bring it back to me.'")
        elseif stage == 9 then
            self:say("Now go defeat " .. mname(wandtask4) .. ".")
        end
    elseif set_(job1) and set_(job2) and stage == 10 then
        self:say("Now go defeat " .. mname(wandtask3) .. ".")
    elseif (stage == 3 or stage == 10) and (not set_(job1) and set_(job2) and set_(job3)) then
        self:say("Finish bonding with your " .. weapon .. " and bring it to me.")
    elseif not set_(job1) and set_(job2) and set_(job3) and set_(job4) then
        self:say("Finish bonding with your " .. weapon .. " and bring it to me.")
    else
        self:say("Do you have the rest?")
    end
elseif response then
    give_back()
    self.room:send(self.name .. " refuses " .. object.shortdesc .. ".")
    wait(0.2)
    self:say(response)
end
return true$trig$, 'dc4f273a0e643c0327a9a2bc8c96b010'),
  -- data/triggers/002/002_114_phase_wand_status_checker_questmasters.lua
  (2, 114, $trig$local function vkey(vnum)
    if vnum >= 11700 and vnum <= 11840 then return 117, vnum - 11700 end
    return math.floor(vnum / 100), vnum % 100
end
local function oname(vnum)
    local z, i = vkey(vnum)
    return objects.template(z, i).name
end
local function mname(vnum)
    local z, i = vkey(vnum)
    return mobiles.template(z, i).name
end
-- A quest flag is set when it holds a non-zero value (0 is truthy in Lua).
local function set_(v) return v ~= nil and v ~= 0 and v ~= "" end

-- Who to see next, by quest type and the stage the player has already passed (DG #314 text).
local HINTS = {
    air = {
        [3] = "Speak with the old Abbot in the Abbey of St. George.",
        [4] = "The keeper of a southern coastal tower will have advice for you.",
        [5] = "A master of air near the megalith in South Caelia will be able to help next.",
        [6] = "Seek out the warrior-witch at the center of the southern megalith.",
        [7] = "She's hard to deal with, but the Seer of Griffin Isle should have some additional guidance for you.",
        [8] = "In the diabolist's church is a seer who cannot see.  He's a good resource for this kind of work.",
        [9] = "The guardian ranger of the Druid Guild in the Red City has some helpful crafting tips.",
        [10] = "Silania will help you craft the finest of air weapons.",
    },
    fire = {
        [3] = "A minion of the dark flame out east will know what to do.",
        [4] = "There's a fire master in the frozen north who likes to spend his time at the hot springs.",
        [5] = "A master of fire near the megalith in South Caelia will be able to help next.",
        [6] = "A seraph crafts with the power of the sun and sky.  It can be found in the floating fortress in South Caelia.",
        [7] = "I hate to admit it, but Vulcera is your next crafter.  Good luck appeasing her though...",
        [8] = "You're headed back to Fiery Island.  Crazy old McCabe can help you improve your staff further.",
        [9] = "Seek out the one who speaks for the Sun near Anduin.  He can upgrade your staff.",
        [10] = "Surely you've heard of Emmath Firehand.  He's the supreme artisan of fiery goods.  He can help you make the final improvements to your staff.",
    },
    ice = {
        [3] = "The shaman near Three-Falls River has developed a powerful affinity for water from his life in the canyons.  Seek his advice.",
        [4] = "Many of the best craftspeople aren't even mortal.  There is a water sprite of some renown deep in Anlun Vale.",
        [5] = "A master of spirits in the far north will be able to help next.",
        [6] = "Your next crafter is a distant relative of the Sunfire clan.  He's been squatting in a flying fortress for many months, trying to unlock its secrets.",
        [7] = "You'll need the advice of a master ice sculptor.  One works regularly up in Mt. Frostbite.",
        [8] = "There's another distant relative of the Sunfire clan who runs the hot springs near Ickle.  He's book smart and knows a thing or two about jewel crafting.",
        [9] = "The guild guard for the Sorcerer Guild in Ickle has learned plenty of secrets from the inner sanctum.  Talk to him.",
        [10] = "You must know Suralla Iceeye by now.  She's the master artisan of cold and ice.  She'll know how to make the final improvements to your staff.",
    },
    acid = {
        [3] = "First, seek the one who guards the eastern gates of Ickle.",
        [4] = "The next two artisans dwell in the Rhell Forest south-east of Mielikki.",
        [5] = "Your next crafter isn't exactly part of the ranger network...  It's not actually a person at all.  Find the treant in the Rhell forest and ask it for guidance.",
        [6] = "The ranger who guards the massive necropolis near Anduin has wonderful insights on crafting with decay.",
        [7] = "Your next guide may be hard to locate...  I believe they guard the entrance to a long-lost kingdom beyond a frozen desert.",
        [8] = "Next, consult with another ranger who guards a place crawling with the dead.  The dwarf ranger in the iron hills will know how to help you.",
        [9] = "The guard of the only known Ranger Guild in the world is also an excellent craftswoman.  Consult with her.",
        [10] = "Your last guide is the head of the ranger network himself, Eleweiss.  He can help make the final improvements to your staff.",
    },
}

-- Where stage 8 sends the player to imbue the primed staff (DG `place`, set by 002_111).
local IMBUE_ROOM = { air = 49007, fire = 5272, ice = 55105, acid = 16355 }

-- Speech phrase: wand progress (DG num_arg 0 = the speech contains the whole phrase, on word boundaries)
local speech_padded = " " .. string.lower(speech or "") .. " "
if not string.find(speech_padded, "[%s%p]wand progress[%s%p]") then
    return true  -- Not the phrase
end
local wandstep = globals.wandstep
if not wandstep then return true end
wait(0.2)
if actor.class ~= "sorcerer" and actor.class ~= "cryomancer" and actor.class ~= "pyromancer"
        and actor.class ~= "illusionist" and actor.class ~= "necromancer" then
    self:say("This weapon is only for students of the arcane arts.")
    return true
end
local quest_type = globals.type
local weapon = globals.weapon
local wandgem = globals.wandgem
local wandtask3 = globals.wandtask3
local wandtask4 = globals.wandtask4
local quest = quest_type .. "_wand"
local stage = actor:get_quest_stage(quest)
local job1 = actor:get_quest_var(quest .. ":wandtask1")
local job2 = actor:get_quest_var(quest .. ":wandtask2")
local job3 = actor:get_quest_var(quest .. ":wandtask3")
local job4 = actor:get_quest_var(quest .. ":wandtask4")
local job5 = actor:get_quest_var(quest .. ":wandtask5")
local room = self.room

if actor:get_has_completed(quest) then
    self:say("It looks like you already have the most powerful staff of " .. quest_type .. " in existence!")
elseif stage == wandstep and actor.level >= (wandstep - 1) * 10 then
    if (actor:get_quest_var(quest .. ":greet") or 0) == 0 then
        self:say("Tell me why you're here first.")
    else
        self:say("I'm improving your " .. quest_type .. " weapon.")
        if set_(job1) or set_(job2) or set_(job3) or set_(job4) then
            room:send("")
            self:say("You've done the following:")
            if set_(job1) then
                room:send("- attacked " .. globals.wandattack .. " times")
            end
            if set_(job2) then
                room:send("- found " .. oname(wandgem))
            end
            if set_(job3) then
                if wandstep ~= 10 then
                    room:send("- found " .. oname(wandtask3))
                else
                    room:send("- slayed " .. mname(wandtask3))
                end
            end
            if set_(job4) then
                if wandstep ~= 5 and wandstep ~= 9 and wandstep ~= 10 then
                    room:send("- found " .. oname(wandtask4))
                elseif wandstep == 5 then
                    room:send("- communed in " .. tostring(wandtask4))
                elseif wandstep == 9 then
                    room:send("- slayed " .. mname(wandtask4))
                end
            end
        end
        room:send("")
        room:send("You need to:")
        if set_(job1) and set_(job2) and set_(job3) and set_(job4) then
            if wandstep ~= 6 and wandstep ~= 8 and wandstep ~= 10 then
                room:send("Just give me your " .. weapon .. ".")
            elseif wandstep == 6 then
                if not set_(job5) then
                    room:send("Just give me your " .. weapon .. ".")
                else
                    room:send("- <b:cyan>play</> " .. oname(wandtask4))
                end
            elseif wandstep == 8 then
                if not set_(job5) then
                    room:send("Just give me your " .. weapon .. ".")
                else
                    local imbue = get_room(vkey(IMBUE_ROOM[quest_type]))
                    room:send("- imbue your " .. weapon .. " at " .. tostring(imbue and imbue.name) .. ".")
                end
            elseif wandstep == 10 then
                local imbue = get_room(vkey(wandtask4))
                room:send("- imbue your " .. weapon .. " at " .. tostring(imbue and imbue.name) .. ".")
            end
        end
        if not set_(job1) then
            local counter = 50
            local remaining = ((stage - 1) * counter) - (actor:get_quest_var(quest .. ":attack_counter") or 0)
            room:send("- <b:yellow>attack " .. remaining .. " more times with your " .. weapon .. "</>")
        end
        if not set_(job2) then
            room:send("- <b:yellow>find " .. oname(wandgem) .. "</>")
        end
        if not set_(job3) then
            if wandstep ~= 10 then
                room:send("- <b:yellow>find " .. oname(wandtask3) .. "</>")
                if wandstep == 4 then
                    room:send("</>    Blessings can be called at the smaller groups of standing stones in South Caelia.")
                    if self.zone_id == 586 and self.id == 1 then
                        room:send("</>    Search the far eastern edge of the continent.")
                    elseif self.zone_id == 103 and self.id == 6 then
                        room:send("</>    Search the south point beyond Anlun Vale.")
                    elseif self.zone_id == 23 and self.id == 37 then
                        room:send("</>    Search the surrounding forest.")
                    elseif self.zone_id == 625 and self.id == 4 then
                        room:send("</>    Search in the heart of the heart of the thorns.")
                    end
                    room:send("</>    The phrase to call the blessing is:")
                    room:send("</>    <b:cyan>I pray for a blessing from mother earth, creator of life and bringer of death</>")
                end
            else
                room:send("- <b:yellow>slay " .. mname(wandtask3) .. "</>")
            end
        end
        if not set_(job4) then
            if wandstep ~= 3 and wandstep ~= 5 and wandstep ~= 9 and wandstep ~= 10 then
                room:send("- <b:yellow>find " .. oname(wandtask4) .. "</>")
            elseif wandstep == 5 then
                if quest_type == "air" then
                    room:send("- <b:yellow>imbue your " .. weapon .. " on " .. tostring(wandtask4) .. "</>")
                else
                    room:send("- <b:yellow>imbue your " .. weapon .. " in " .. tostring(wandtask4) .. "</>")
                end
            elseif wandstep == 9 then
                room:send("- <b:yellow>slay " .. mname(wandtask4) .. "</>")
            elseif wandstep == 10 then
                if set_(job1) and set_(job2) and set_(job3) then
                    room:send("Just give me your " .. weapon .. ".")
                end
            end
        end
    end
elseif stage > wandstep then
    self:say("I can't help you anymore, but I know who can.")
    local hint = HINTS[quest_type] and HINTS[quest_type][stage]
    if hint then
        room:send("")
        self:say(hint)
    end
elseif stage < wandstep then
    self:say("You need to make more improvements to your " .. weapon .. " before I can work with it.")
elseif actor.level < (wandstep - 1) * 10 then
    self:say("Come back after you've gained some more experience.  I can help you then.")
end
return true$trig$, '39cf8e1fb60a5e22a77d78ff416d61eb'),
  -- data/triggers/002/002_126_phase_mace_receive.lua
  (2, 126, $trig$local function vkey(vnum)
    if vnum >= 200 and vnum <= 399 then return 2, vnum - 200 end
    if vnum >= 3000 and vnum <= 3499 then return 30, vnum - 3000 end
    return math.floor(vnum / 100), vnum % 100
end
local function oname(vnum)
    local z, i = vkey(vnum)
    return objects.template(z, i).name
end
local function is_obj(vnum)
    if type(vnum) ~= "number" then return false end
    local z, i = vkey(vnum)
    return object.zone_id == z and object.id == i
end
-- A quest flag is set when it holds a non-zero value (0 is truthy in Lua).
local function set_(v) return v ~= nil and v ~= 0 and v ~= "" end

local function give_back()
    local bare = string.gsub(string.gsub(object.name, "^%s*[Tt]he%s+", ""), "^%s*[Aa]n?%s+", "")
    self:command("give " .. bare .. " " .. actor.name)
end
local function says(msg)
    actor:send(self.name .. " says, '" .. msg .. "'")
end

-- What a questmaster tells a player who has already passed this step, by that player's stage.
local PASSED = {
    [2] = "Someone familiar with the grave will be able to work on this mace.  Seek out the Sexton in the Abbey west of the Village of Mielikki.",
    [3] = "The Cleric Guild is capable of some miraculous crafting.  Visit the Cleric Guild Master in the Arctic Village of Ickle and talk to High Priest Zalish.  He should be able to help you.",
    [4] = "Continue with the Cleric Guild Masters.  Check in with the High Priestess in the City of Anduin.",
    [5] = "Sometimes to battle the dead, we need to use their own dark natures against them.  Few are as knowledgeable about the dark arts as Ziijhan, the Defiler, in the Cathedral of Betrayal.",
    [6] = "Return again to the Abbey of St. George and seek out Silania.  Her mastery of spiritual matters will be necessary to improve this mace any further.",
    [7] = "I'm loathe to admit it, but of the few remaining who are capable of improving your weapon, one is a priest of a god most foul.  Find Ruin Wormheart, that most heinous of Blackmourne's servitors.",
    [8] = "The most powerful force in the war against the dead is the sun itself.  Consult with the sun's Oracle in the ancient pyramid near Anduin.",
    [9] = "With everything prepared, return to the very beginning of your journey.  The High Priestess of Mielikki, the very center of the Cleric Guild, will know what to do.",
}

local macestep = globals.macestep
if not macestep then return true end
local maceitems = { globals.maceitem2, globals.maceitem3, globals.maceitem4, globals.maceitem5, globals.maceitem6 }
local macevnum = globals.mace_id
local reward_mace = globals.reward_mace
local quest = "phase_mace"
local priest = (self.zone_id == 185 and self.id == 2)

local number
for n = 2, 6 do
    if is_obj(maceitems[n - 1]) then
        number = n
        break
    end
end
if not (number or is_obj(macevnum)) then
    return true
end

if priest then
    self:set_flag("sentinel", true)
end

local function jobs()
    local j = {}
    for n = 1, 6 do
        j[n] = set_(actor:get_quest_var(quest .. ":macetask" .. n))
    end
    return j
end

local response, check, reward
local stage = actor:get_quest_stage(quest)
if actor.class == "cleric" or actor.class == "priest" then
    if actor.level >= macestep * 10 then
        if stage == macestep then
            if (actor:get_quest_var(quest .. ":greet") or 0) == 1 then
                if number then
                    if set_(actor:get_quest_var(quest .. ":macetask" .. number)) then
                        response = "You already gave me " .. object.shortdesc .. "."
                    elseif macestep == 2 and number > 2 and not set_(actor:get_quest_var(quest .. ":dirt" .. number)) then
                        wait(0.2)
                        self:command("shake")
                        world.destroy(object)
                        actor:send(self.name .. " scatters the dirt in the wind.")
                        wait(0.2)
                        says("You need to make the pilgrimage to these places yourself.")
                        wait(1)
                        says("Return with fresh earth when you have.")
                    else
                        actor:set_quest_var(quest, "macetask" .. number, 1)
                        wait(0.2)
                        world.destroy(object)
                        says("Ah yes, this will do.")
                        local j = jobs()
                        if macestep == 2 then
                            if j[1] and j[2] and j[3] and j[4] and j[5] and j[6] then
                                check = "continue"
                            elseif not j[1] and j[2] and j[3] and j[4] and j[5] and j[6] then
                                check = "count"
                            else
                                check = "stop"
                            end
                        else
                            if j[1] and j[2] and j[3] and j[4] and j[5] then
                                check = "continue"
                            elseif not j[1] and j[2] and j[3] and j[4] and j[5] then
                                check = "count"
                            else
                                check = "stop"
                            end
                        end
                    end
                else
                    -- the mace itself
                    local j = jobs()
                    if macestep == 2 then
                        if j[1] and j[2] and j[3] and j[4] and j[5] and j[6] then
                            reward = "yes"
                        elseif not j[1] and j[3] and j[4] and j[5] and j[6] then
                            reward = "count"
                        else
                            reward = "stop"
                        end
                    else
                        if j[1] and j[2] and j[3] and j[4] and j[5] then
                            reward = "yes"
                        elseif not j[1] and j[2] and j[3] and j[4] and j[5] then
                            reward = "count"
                        else
                            reward = "stop"
                        end
                    end
                end
            else
                response = "Tell me why you're here first."
            end
        elseif stage > macestep then
            response = PASSED[stage]
        else
            response = "Your mace isn't advanced enough for me to work on yet."
        end
    else
        response = "Come back after you've grown some more."
    end
else
    response = "This is only needed for the priestly classes."
end

if check == "continue" then
    wait(1)
    self:command("nod")
    local z, i = vkey(macevnum)
    says("Give me the " .. get_obj_noadesc(z, i) .. ".")
elseif check == "count" then
    wait(0.2)
    says("Now just keep practicing with " .. oname(macevnum) .. ".")
elseif check == "stop" then
    wait(0.2)
    says("Do you have the other materials?")
elseif reward == "yes" then
    actor:advance_quest(quest)
    actor:set_quest_var(quest, "attack_counter", 0)
    actor:set_quest_var(quest, "greet", 0)
    for loop = 1, 6 do
        actor:set_quest_var(quest, "macetask" .. loop, 0)
    end
    wait(1)
    world.destroy(object)
    self:command("nod")
    says("Yes, this is everything.")
    wait(1)
    actor:send(self.name .. " inlays " .. oname(maceitems[1]) .. " into " .. oname(macevnum) .. ".")
    wait(2)
    if priest then
        actor:send(self.name .. " recites several long prayers as he sprinkles the handfuls of dirt over " .. oname(macevnum) .. ".")
    else
        actor:send(self.name .. " etches the markings from " .. oname(maceitems[2]) .. " to " .. oname(macevnum) .. ".")
        wait(3)
        actor:send("By the light of " .. oname(maceitems[4]) .. ", " .. self.name .. " sets recites several long prayers.")
    end
    wait(2)
    actor:send(oname(macevnum) .. " is transformed!")
    wait(1)
    says("Here you are, " .. oname(reward_mace) .. "!")
    self:spawn_object(vkey(reward_mace))
    self:command("give mace " .. actor.name)
    local expcap = macestep * 10
    local expmod
    if expcap < 25 then
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
    actor:send("<b:yellow>You gain experience!</>")
    local setexp = expmod * 10
    for _ = 1, 10 do
        actor:award_exp(setexp)
    end
elseif reward == "count" then
    response = "Keep practicing with " .. oname(macevnum) .. "."
elseif reward == "stop" then
    response = "Bring me the other materials first."
end

if response then
    give_back()
    actor:send(self.name .. " refuses " .. object.shortdesc .. ".")
    wait(0.2)
    says(response)
end

if priest then
    self:set_flag("sentinel", false)
end
return true$trig$, 'c368f9705739feb5815c44dc1a1aa284'),
  -- data/triggers/004/004_19_major_globe_progress_journal.lua
  (4, 19, $trig$-- Converted from DG Script #419: Major Globe progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
-- final_item is a local id in zone 534; nil (never picked) reads as a missing description.
local function final_item_name(local_id)
    local name = local_id and objects.template(534, local_id).name
    if not name or name == "" then return "[no description for object " .. tostring(local_id) .. "]" end
    return name
end
local wards_left, plant, mist, water, flame, ice
local _return_value = true  -- Default: allow action
if string.find(arg, "major globe") or string.find(arg, "globe") or string.find(arg, "major_globe") or string.find(arg, "major_globe_spell") then
    local relocateclasses = "Sorcerer Cryomancer Pyromancer"
    if actor.level >= 50 and string.find(string.lower(relocateclasses), actor.class, 1, true) then
        _return_value = true
        local stage = actor:get_quest_stage("major_globe_spell")
        actor:send("<b:u:green>Major Globe</>")
        actor:send("Minimum Level: 57")
        local status
        if actor:get_has_completed("major_globe_spell") then
            status = "Completed!"
        elseif actor:get_quest_stage("major_globe_spell") > 0 then
            status = "In Progress"
        else
            status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
        if stage > 0 and not actor:get_has_completed("major_globe_spell") then
            -- switch on stage
            local master, task
            if stage == 1 then
                master = mobiles.template(534, 50).name
                task = "Find Earle and tell him \"Lirne sends me.\""
            elseif stage == 2 then
                master = mobiles.template(490, 8).name
                task = "Find shale on Fiery Island."
            elseif stage == 3 then
                master = mobiles.template(490, 8).name
                task = "Find sake in Odaishyozen."
            elseif stage == 4 then
                master = mobiles.template(490, 8).name
                task = "Find a marigold poultice on a healer in South Caelia."
            elseif stage == 5 then
                master = mobiles.template(534, 50).name
                task = "Bring " .. tostring(master) .. " the salve Earle prepared."
            elseif stage == 6 then
                master = mobiles.template(534, 50).name
                task = "<b:cyan>Search</> in each <b:green>library</> or <b:green>stack</> to find the lost spellbook."
            elseif stage == 7 then
                master = mobiles.template(534, 50).name
                task = "Bring " .. tostring(objects.template(534, 52).name) .. " to " .. tostring(master) .. "."
            elseif stage == 8 then
                master = mobiles.template(534, 50).name
                plant = actor:get_quest_var("major_globe_spell:ward_53")
                mist = actor:get_quest_var("major_globe_spell:ward_54")
                water = actor:get_quest_var("major_globe_spell:ward_55")
                flame = actor:get_quest_var("major_globe_spell:ward_56")
                ice = actor:get_quest_var("major_globe_spell:ward_57")
                wards_left = 5 - (actor:get_quest_var("major_globe_spell:ward_count") or 0)
                task = "Bring " .. tostring(master) .. " <b:yellow>" .. tostring(wards_left) .. " more elemental wards</>, one each from a mist, a water, an ice, a flame, and a plant elemental."
            elseif stage == 9 then
                master = mobiles.template(534, 50).name
                -- final_item holds the chosen object's local id within zone 534 (58-61), see 534_67
                local final_item = actor:get_quest_var("major_globe_spell:final_item")
                -- switch on final_item
                local place
                if (final_item or 0) == 58 then
                    place = "in a border keep"
                elseif (final_item or 0) == 59 then
                    place = "on an emerald isle"
                elseif (final_item or 0) == 60 then
                    place = "within a misty fortress"
                else
                    place = "in an underground city"
                end
                task = "Find " .. final_item_name(final_item) .. " " .. tostring(place) .. "."
            elseif stage == 10 then
                master = mobiles.template(534, 50).name
                local final_item = actor:get_quest_var("major_globe_spell:final_item")
                task = "Deliver " .. final_item_name(final_item) .. " to " .. tostring(master) .. "."
            end
            actor:send("Quest Master: " .. tostring(master))
            actor:send("</>")
            actor:send(tostring(task))
            if stage == 8 then
                if wards_left < 5 then
                    actor:send("You have found:")
                    if plant == 2 then
                        actor:send(tostring(objects.template(534, 53).name))
                    end
                    if mist == 2 then
                        actor:send(tostring(objects.template(534, 54).name))
                    end
                    if water == 2 then
                        actor:send(tostring(objects.template(534, 55).name))
                    end
                    if flame == 2 then
                        actor:send(tostring(objects.template(534, 56).name))
                    end
                    if ice == 2 then
                        actor:send(tostring(objects.template(534, 57).name))
                    end
                end
            end
        end
    end
end  -- auto-close block
return _return_value$trig$, 'c6b3cce89d2d10e2f33068dac7832416'),
  -- data/triggers/041/041_03_3bl_turn_in.lua
  (41, 3, $trig$local function proto_key(vnum)
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
local _return_value = true  -- Default: allow action
-- The runtime fires RECEIVE after the item is already in the mob's hands, so a refusal hands it
-- back with a give command (DG's `return 0`).
local function give_back()
    local bare = string.gsub(string.gsub(object.name, "^%s*[Tt]he%s+", ""), "^%s*[Aa]n?%s+", "")
    self:command("give " .. bare .. " " .. actor.name)
end
-- 
-- This is the main receive trigger for the Edorian
-- combat quests installed on the mud. This trigger
-- will be generic and the IDs and variables set
-- to reflect which faction it applies to.
-- 
-- The original zone using these quests was
-- 55 Combat in Eldoria.  I'm adapting the
-- format of the quest mechanics to spread the
-- vast wealth of these quests to other zones
-- such that there isn't so much loot in one zone.
-- 
-- 3bl is Third Black Legion - The player MUST be
-- on the quest already in order to turn in because
-- the variables are not set yet!
if actor:get_quest_var("Black_Legion:eg_ally") then
    actor:send(tostring(self.name) .. " tells you, 'You have already chosen your side!  Be")
    actor:send("</>gone, filth!'")
    return _return_value
end
-- 
if actor.alignment <= 150 and actor:get_quest_stage("Black_Legion") > 0 then
    actor:set_quest_var("Black_Legion", "bl_ally", 1)
    -- 
    -- Objects this questmaster accepts, as the legacy vnums (zone * 100 + id) the DG script used:
    -- `item` is what the player hands over, `reward` the item given back for a gem. Quest-variable
    -- keys stay <vnum>_trophies / <vnum>_reward like legacy.
    local TURNIN = {
        { item = 55570, exp = 10, faction = 1, reward = 5517, faction_required = 20 },  -- gem_3bl_cap
        { item = 55566, exp = 10, faction = 1, reward = 5555, faction_required = 20 },  -- gem_3bl_food
        { item = 55567, exp = 10, faction = 1, reward = 5557, faction_required = 20 },  -- gem_3bl_drink
        { item = 55582, exp = 10, faction = 1, reward = 5540, faction_required = 20 },  -- gem_3bl_ssword
        { item = 55571, exp = 12, faction = 1, reward = 5519, faction_required = 40 },  -- gem_3bl_neck
        { item = 55581, exp = 12, faction = 1, reward = 5539, faction_required = 40 },  -- gem_3bl_staff
        { item = 55572, exp = 14, faction = 1, reward = 5521, faction_required = 55 },  -- gem_3bl_arm
        { item = 55583, exp = 14, faction = 1, reward = 5541, faction_required = 55 },  -- gem_3bl_whammer
        { item = 55573, exp = 16, faction = 1, reward = 5523, faction_required = 70 },  -- gem_3bl_wrist
        { item = 55584, exp = 16, faction = 1, reward = 5542, faction_required = 70 },  -- gem_3bl_flail
        { item = 5504, exp = 2, faction = 1 },  -- 3el_skull (trophy)
        { item = 5506, exp = 2, faction = 1 },  -- 3el_ring (trophy)
        { item = 5508, exp = 2, faction = 1 },  -- 3el_badge (trophy)
        { item = 5510, exp = 2, faction = 2 },  -- 3el_token (trophy)
        { item = 5512, exp = 2, faction = 2 },  -- 3el_insignia (trophy)
        { item = 5514, exp = 2, faction = 2 },  -- 3el_wand (trophy)
        { item = 5516, exp = 2, faction = 3 },  -- 3el_symbol (trophy)
    }
    local is_gem, exp_multiplier, id_reward, faction_required, faction_multiplier
    local id_trophy
    local entry
    for _, t in ipairs(TURNIN) do
        local z, i = proto_key(t.item)
        if object.zone_id == z and object.id == i then
            entry = t
            break
        end
    end
    if entry then
        exp_multiplier = entry.exp
        faction_multiplier = entry.faction
        if entry.reward then
            is_gem = 1
            id_reward = entry.reward
            faction_required = entry.faction_required
        else
            id_trophy = entry.item
        end
    else
        give_back()
        wait(0.1)
        self:command("eye " .. tostring(actor.name))
        actor:send(tostring(self.name) .. " tells you, 'I am not interested in this from you.'")
        actor:send(tostring(self.name) .. " returns your item to you.")
        return _return_value
    end
    -- 
    -- need to force character saving after each turnin.
    -- 
    if not is_gem then
        local faction_advance = 0
        local exp_advance = 0
        -- hrmm Jelos' magical variable declaration
        if actor:get_quest_var("black_legion:" .. tostring(id_trophy) .. "_trophies") then
        else
            actor:set_quest_var("black_legion", tostring(id_trophy) .. "_trophies", 0)
        end
        local trophies = actor:get_quest_var("black_legion:" .. tostring(id_trophy) .. "_trophies")
        actor:set_quest_var("black_legion", tostring(id_trophy) .. "_trophies", trophies)
        -- The highest faction a player can gain from interacting with the 3rd front creatures will
        -- be 200.  For this section the trophy turn in will reply on this and other checks.
        if (actor:get_quest_var("black_legion:bl_faction") or 0) < 100 then
            local trophies = (actor:get_quest_var("black_legion:" .. tostring(id_trophy) .. "_trophies") or 0) + 1
            actor:set_quest_var("black_legion", tostring(id_trophy) .. "_trophies", trophies)
            wait(0.2)
            actor:send(tostring(self.name) .. " tells you, 'Hrm, I see you have been out raiding the")
            actor:send("</>monks assisting the Eldorians.  According to my records you have now turned in")
            actor:send("</>have now turned in <b:yellow>" .. tostring(trophies) .. "</> <b:white>" .. proto_short(id_trophy) .. "</>.'")
            world.destroy(object)
            actor:save()
            if trophies < 10 then
                faction_advance = 1
                exp_advance = 1
            else
                faction_advance = 1
            end
        else
            if (trophies or 0) < 10 then
                exp_advance = 1
                local trophies = (actor:get_quest_var("black_legion:" .. tostring(id_trophy) .. "_trophies") or 0) + 1
                actor:set_quest_var("black_legion", tostring(id_trophy) .. "_trophies", trophies)
            else
                give_back()
            end
            wait(0.2)
            self:command("eye " .. tostring(actor.name))
            actor:send(tostring(self.name) .. " tells you, 'You have garnered as much favor with the")
            actor:send("</>Black Legion as you possibly can by raiding the Abbey.'")
            -- (empty send to actor)
            actor:send(tostring(self.name) .. " tells you, 'You may find other more difficult battles")
            actor:send("</>in Eldoria.'")
            -- (empty send to actor)
            actor:send(tostring(self.name) .. " tells you, 'Seek out the Third Black Legion Recruiter")
            actor:send("</>at the base of Tarelithis in order to curry more favor with our")
            actor:send("</>lords.'")
        end
        -- 
        -- Double check that the criteria for rewards for this section are met.
        -- 
        if exp_advance > 0 then
            -- 
            -- loop for exp award.
            -- 
            -- (empty send to actor)
            actor:send("<b:yellow>You gain experience!</>")
            local lap = 1
            while lap <= exp_multiplier do
                actor:award_exp(2640)
                lap = lap + 1
            end
            -- 
            -- end exp loop
            -- 
            -- all other items should be mpjunked or whatever by now
        end
        if faction_advance > 0 then
            -- 
            -- loop for faction award.
            -- 
            actor:send("<b:yellow>Your curry favor with the Black Legion!</>")
            actor:send("<b:red>You feel more hated by the Eldorian Guard!</>")
            local lap = 1
            while lap <= faction_multiplier do
                local faction = (actor:get_quest_var("black_legion:bl_faction") or 0) + 1
                actor:set_quest_var("black_legion", "bl_faction", faction)
                -- 
                -- 
                -- slight bug for now the trigger code can't seem to evaluate negative numbers?
                -- 
                -- 
                local faction2 = (actor:get_quest_var("black_legion:eg_faction") or 0) - 1
                actor:set_quest_var("black_legion", "eg_faction", faction2)
                lap = lap + 1
            end
            -- 
            -- end faction loop
            -- 
            -- all other items should be mpjunked or whatever by now
        end
        -- end of !if_gem section or trophy endif
        actor:save()
    end
    if is_gem then
        -- hrmm Jelos' magical variable declaration
        if actor:get_quest_var("black_legion:" .. tostring(id_reward) .. "_reward") then
        else
            actor:set_quest_var("black_legion", tostring(id_reward) .. "_reward", 0)
        end
        local rewards = actor:get_quest_var("black_legion:" .. tostring(id_reward) .. "_reward")
        actor:set_quest_var("black_legion", tostring(id_reward) .. "_reward", rewards)
        if actor.alignment >= 151 then
            give_back()
            wait(0.2)
            actor:send(tostring(self.name) .. " tells you, 'You aren't quite evil enough for these")
            actor:send("</>rewards.'")
            return _return_value
        end
        if (actor:get_quest_var("black_legion:bl_faction") or 0) >= faction_required then
            local rewards = (actor:get_quest_var("black_legion:" .. tostring(id_reward) .. "_reward") or 0) + 1
            actor:set_quest_var("black_legion", tostring(id_reward) .. "_reward", rewards)
            wait(0.2)
            actor:send(tostring(self.name) .. " tells you, 'Ah yes, the Legion thanks you for your")
            actor:send("</>efforts.  Take this to aid you in your battles.'")
            wait(0.1)
            self:spawn_object(proto_key(id_reward))
            wait(0.1)
            if (actor:get_quest_var("black_legion:" .. tostring(id_reward) .. "_reward") or 0) == 1 then
                -- 
                -- loop for exp award.
                -- 
                -- (empty send to actor)
                actor:send("<b:yellow>You gain experience!</>")
                local lap = 1
                while lap <= exp_multiplier do
                    actor:award_exp(2640)
                    lap = lap + 1
                end
                -- 
                -- end exp loop
                -- 
                -- all other items should be mpjunked or whatever by now
            end
            if (actor:get_quest_var("black_legion:bl_faction") or 0) < 200 then
                -- 
                -- loop for faction award.
                -- 
                actor:send("<b:yellow>Your curry favor with the Black Legion!</>")
                actor:send("<b:red>You feel more hated by the Eldorian Guard!</>")
                local lap = 1
                while lap <= faction_multiplier do
                    local faction = (actor:get_quest_var("black_legion:bl_faction") or 0) + 1
                    actor:set_quest_var("black_legion", "bl_faction", faction)
                    -- 
                    -- 
                    -- slight bug for now the trigger code can't seem to evaluate negative numbers?
                    -- 
                    -- 
                    local faction2 = (actor:get_quest_var("black_legion:eg_faction") or 0) - 1
                    actor:set_quest_var("black_legion", "eg_faction", faction2)
                    lap = lap + 1
                end
                -- 
                -- end faction loop
                -- 
                -- all other items should be mpjunked or whatever by now
            end
            world.destroy(object)
            self:destroy_item("all.eldoria-trophy")
            self:command("give all " .. tostring(actor.name))
            actor:save()
        else
            give_back()
            wait(0.2)
            actor:send(tostring(self.name) .. " tells you, 'You aren't quite allied enough with our")
            actor:send("</>cause to earn that reward.'")
            return _return_value
        end
        -- end of if_gem section
    end
else
    -- Alignment not low enough or hasn't started the quest yet.
    give_back()
    wait(0.2)
    actor:send(tostring(self.name) .. " tells you, 'You aren't quite allied enough with our")
    actor:send("</>cause to earn our rewards.  You need a lower alignement, or to start these")
    actor:send("</>quests by saying <b:white>[yes]</>, <b:white>[quest]</>, or <b:white>[hello]</>.'")
end
return _return_value$trig$, '0d6ce333de5cec25a4979d7ea46ff777'),
  -- data/triggers/041/041_07_3eg_turn_in.lua
  (41, 7, $trig$local function proto_key(vnum)
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
local _return_value = true  -- Default: allow action
-- The runtime fires RECEIVE after the item is already in the mob's hands, so a refusal hands it
-- back with a give command (DG's `return 0`).
local function give_back()
    local bare = string.gsub(string.gsub(object.name, "^%s*[Tt]he%s+", ""), "^%s*[Aa]n?%s+", "")
    self:command("give " .. bare .. " " .. actor.name)
end
-- 
-- This is the main receive trigger for the Edorian
-- combat quests installed on the mud. This trigger
-- will be generic and the IDs and variables set
-- to reflect which faction it applies to.
-- 
if actor:get_quest_var("Black_Legion:bl_ally") then
    actor:send(tostring(self.name) .. " tells you, 'You have pledged yourself to the forces of")
    actor:send("</>darkness!  Suffer under your choice!'")
    return _return_value
end
-- 3eg is Third Eldorian Guard
if actor.alignment >= -150 and actor:get_quest_stage("Black_Legion") > 0 then
    actor:set_quest_var("Black_Legion", "eg_ally", 1)
    -- 
    -- Objects this questmaster accepts, as the legacy vnums (zone * 100 + id) the DG script used:
    -- `item` is what the player hands over, `reward` the item given back for a gem. Quest-variable
    -- keys stay <vnum>_trophies / <vnum>_reward like legacy.
    local TURNIN = {
        { item = 55570, exp = 10, faction = 1, reward = 5518, faction_required = 20 },  -- gem_3eg_cap
        { item = 55566, exp = 10, faction = 1, reward = 5556, faction_required = 20 },  -- gem_3eg_food
        { item = 55567, exp = 10, faction = 1, reward = 5558, faction_required = 20 },  -- gem_3eg_drink
        { item = 55582, exp = 10, faction = 1, reward = 5547, faction_required = 20 },  -- gem_3eg_ssword
        { item = 55571, exp = 12, faction = 1, reward = 5520, faction_required = 40 },  -- gem_3eg_neck
        { item = 55581, exp = 12, faction = 1, reward = 5546, faction_required = 40 },  -- gem_3eg_staff
        { item = 55572, exp = 14, faction = 1, reward = 5522, faction_required = 55 },  -- gem_3eg_arm
        { item = 55583, exp = 14, faction = 1, reward = 5548, faction_required = 55 },  -- gem_3eg_whammer
        { item = 55573, exp = 16, faction = 1, reward = 5524, faction_required = 70 },  -- gem_3eg_wrist
        { item = 55584, exp = 16, faction = 1, reward = 5549, faction_required = 70 },  -- gem_3eg_flail
        { item = 5503, exp = 2, faction = 1 },  -- 3bl_skull (trophy)
        { item = 5505, exp = 2, faction = 1 },  -- 3bl_ring (trophy)
        { item = 5507, exp = 2, faction = 1 },  -- 3bl_badge (trophy)
        { item = 5509, exp = 2, faction = 2 },  -- 3bl_token (trophy)
        { item = 5511, exp = 2, faction = 2 },  -- 3bl_insignia (trophy)
        { item = 5513, exp = 2, faction = 2 },  -- 3bl_wand (trophy)
        { item = 5515, exp = 2, faction = 3 },  -- 3bl_symbol (trophy)
    }
    local is_gem, exp_multiplier, id_reward, faction_required, faction_multiplier
    local id_trophy
    local entry
    for _, t in ipairs(TURNIN) do
        local z, i = proto_key(t.item)
        if object.zone_id == z and object.id == i then
            entry = t
            break
        end
    end
    if entry then
        exp_multiplier = entry.exp
        faction_multiplier = entry.faction
        if entry.reward then
            is_gem = 1
            id_reward = entry.reward
            faction_required = entry.faction_required
        else
            id_trophy = entry.item
        end
    else
        give_back()
        wait(0.1)
        self:command("eye " .. tostring(actor.name))
        actor:send(tostring(self.name) .. " tells you, 'I am not interested in this from you.'")
        actor:send(tostring(self.name) .. " returns your item to you.")
        return _return_value
    end
    -- 
    -- need to force character saving after each turnin.
    -- 
    if not is_gem then
        local faction_advance = 0
        local exp_advance = 0
        -- hrmm Jelos' magical variable declaration
        if actor:get_quest_var("black_legion:" .. tostring(id_trophy) .. "_trophies") then
        else
            actor:set_quest_var("black_legion", tostring(id_trophy) .. "_trophies", 0)
        end
        local trophies = actor:get_quest_var("black_legion:" .. tostring(id_trophy) .. "_trophies")
        actor:set_quest_var("black_legion", tostring(id_trophy) .. "_trophies", trophies)
        -- The highest faction a player can gain from interacting with the 3rd front creatures will
        -- be 200.  For this section the trophy turn in will reply on this and other checks.
        if (actor:get_quest_var("black_legion:eg_faction") or 0) < 100 then
            local trophies = (actor:get_quest_var("black_legion:" .. tostring(id_trophy) .. "_trophies") or 0) + 1
            actor:set_quest_var("black_legion", tostring(id_trophy) .. "_trophies", trophies)
            wait(0.2)
            actor:send(tostring(self.name) .. " tells you, 'Hrm, yes... you have been out fighting the")
            actor:send("</>influence of the Black Legion.  I see from my records you have now turned in")
            actor:send("</><b:yellow>" .. tostring(trophies) .. "</> <b:white>" .. proto_short(id_trophy) .. "</>.'")
            world.destroy(object)
            actor:save()
            if trophies < 10 then
                faction_advance = 1
                exp_advance = 1
            else
                faction_advance = 1
            end
        else
            if (trophies or 0) < 10 then
                exp_advance = 1
                local trophies = (actor:get_quest_var("black_legion:" .. tostring(id_trophy) .. "_trophies") or 0) + 1
                actor:set_quest_var("black_legion", tostring(id_trophy) .. "_trophies", trophies)
            else
                give_back()
            end
            wait(0.2)
            self:command("eye " .. tostring(actor.name))
            actor:send(tostring(self.name) .. " tells you, 'You have garnered as much favor with the")
            actor:send("</>Eldorian Guard as you possibly can by raiding Split Skull.'")
            -- (empty send to actor)
            actor:send(tostring(self.name) .. " tells you, 'You will find other more difficult battles")
            actor:send("</>with the Legion that will curry more favor with our masters in Eldoria.'")
            -- (empty send to actor)
            actor:send(tostring(self.name) .. " tells you, 'Go to Tarelithis and seek the Recruiter of")
            actor:send("</>the Third Eldorian Guard!'")
        end
        -- 
        -- Double check that the criteria for rewards for this section are met.
        -- 
        if exp_advance > 0 then
            -- 
            -- loop for exp award.
            -- 
            -- (empty send to actor)
            actor:send("<b:yellow>You gain experience!</>")
            local lap = 1
            while lap <= exp_multiplier do
                actor:award_exp(2640)
                lap = lap + 1
            end
            -- 
            -- end exp loop
            -- 
            -- all other items should be mpjunked or whatever by now
        end
        if faction_advance > 0 then
            -- 
            -- loop for faction award.
            -- 
            actor:send("<b:yellow>Your curry favor with the Eldorian Guard!</>")
            actor:send("<b:red>You feel more hated by the Black Legion!</>")
            local lap = 1
            while lap <= faction_multiplier do
                local faction = (actor:get_quest_var("black_legion:eg_faction") or 0) + 1
                actor:set_quest_var("black_legion", "eg_faction", faction)
                -- 
                -- slight bug for now the trigger code can't seem to evaluate negative numbers?
                -- 
                local faction2 = (actor:get_quest_var("black_legion:bl_faction") or 0) - 1
                actor:set_quest_var("black_legion", "bl_faction", faction2)
                lap = lap + 1
            end
            -- 
            -- end faction loop
            -- 
            -- all other items should be mpjunked or whatever by now
        end
        actor:save()
        -- end of !if_gem section or trophy endif
    end
    if is_gem then
        -- hrmm Jelos' magical variable declaration
        if actor:get_quest_var("black_legion:" .. tostring(id_reward) .. "_reward") then
        else
            actor:set_quest_var("black_legion", tostring(id_reward) .. "_reward", 0)
        end
        local rewards = actor:get_quest_var("black_legion:" .. tostring(id_reward) .. "_reward")
        actor:set_quest_var("black_legion", tostring(id_reward) .. "_reward", rewards)
        if actor.alignment <= -151 then
            give_back()
            wait(0.2)
            actor:send(tostring(self.name) .. " tells you, 'You aren't quite good enough for these")
            actor:send("</>rewards.'")
            return _return_value
        end
        if (actor:get_quest_var("black_legion:eg_faction") or 0) >= faction_required then
            local rewards = (actor:get_quest_var("black_legion:" .. tostring(id_reward) .. "_reward") or 0) + 1
            actor:set_quest_var("black_legion", tostring(id_reward) .. "_reward", rewards)
            wait(0.2)
            actor:send(tostring(self.name) .. " tells you, 'Ah yes, the Guard thanks you for your")
            actor:send("</>efforts.  Take this to aid you in your battles.'")
            wait(0.1)
            self:spawn_object(proto_key(id_reward))
            wait(0.1)
            if (actor:get_quest_var("black_legion:" .. tostring(id_reward) .. "_reward") or 0) == 1 then
                -- 
                -- loop for exp award.
                -- 
                -- (empty send to actor)
                actor:send("<b:yellow>You gain experience!</>")
                local lap = 1
                while lap <= exp_multiplier do
                    actor:award_exp(2640)
                    lap = lap + 1
                end
                -- 
                -- end exp loop
                -- 
                -- all other items should be mpjunked or whatever by now
            end
            if (actor:get_quest_var("black_legion:eg_faction") or 0) < 200 then
                -- 
                -- loop for faction award.
                -- 
                actor:send("<b:yellow>Your curry favor with the Eldorian Guard!</>")
                actor:send("<b:red>You feel more hated by the Black Legion!</>")
                local lap = 1
                while lap <= faction_multiplier do
                    local faction = (actor:get_quest_var("black_legion:eg_faction") or 0) + 1
                    actor:set_quest_var("black_legion", "eg_faction", faction)
                    -- 
                    -- 
                    -- slight bug for now the trigger code can't seem to evaluate negative numbers?
                    -- 
                    -- 
                    local faction2 = (actor:get_quest_var("black_legion:bl_faction") or 0) - 1
                    actor:set_quest_var("black_legion", "bl_faction", faction2)
                    lap = lap + 1
                end
                -- 
                -- end faction loop
                -- 
                -- all other items should be mpjunked or whatever by now
            end
            world.destroy(object)
            self:destroy_item("all.eldoria-trophy")
            self:command("give all " .. tostring(actor.name))
            actor:save()
        else
            give_back()
            wait(0.2)
            actor:send(tostring(self.name) .. " tells you, 'You aren't quite allied enough with our cause")
            actor:send("</>to earn that reward.'")
            return _return_value
        end
        -- end of if_gem section
    end
else
    -- Alignment not high enough or hasn't started the quest yet.
    give_back()
    wait(0.2)
    actor:send(tostring(self.name) .. " tells you, 'You aren't quite allied enough with our cause")
    actor:send("</>to earn our rewards.  You need a higher alignment or to start these quests by")
    actor:send("</>saying <b:white>[yes]</> or <b:white>[quest]</> or <b:white>[hello]</>.'")
end
return _return_value$trig$, '53ee35814f1b6b5b8b8e79587f0d7860'),
  -- data/triggers/055/055_03_3bl_turn_in.lua
  (55, 3, $trig$-- Converted from DG Script #5503: 3bl_turn_in
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
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
local _return_value = true  -- Default: allow action
-- The runtime fires RECEIVE after the item is already in the mob's hands, so a refusal hands it
-- back with a give command (DG's `return 0`).
local function give_back()
    local bare = string.gsub(string.gsub(object.name, "^%s*[Tt]he%s+", ""), "^%s*[Aa]n?%s+", "")
    self:command("give " .. bare .. " " .. actor.name)
end
-- 
-- This is the main receive trigger for the Edorian
-- combat quests installed on the mud. This trigger
-- will be generic and the IDs and variables set
-- to reflect which faction it applies to.
-- 
-- 3bl is Third Black Legion - The player MUST be
-- on the quest already in order to turn in because
-- the variables are not set yet!
if actor:get_quest_var("Black_Legion:eg_ally") then
    actor:send(tostring(self.name) .. " tells you, 'You have already chosen your side!")
    actor:send("</>Be gone, filth!'")
    return _return_value
end
if actor.alignment <= 150 and actor:get_quest_stage("Black_Legion") > 0 then
    actor:set_quest_var("Black_Legion", "bl_ally", 1)
    -- 
    -- Objects this questmaster accepts, as the legacy vnums (zone * 100 + id) the DG script used:
    -- `item` is what the player hands over, `reward` the item given back for a gem. Quest-variable
    -- keys stay <vnum>_trophies / <vnum>_reward like legacy.
    local TURNIN = {
        { item = 55570, exp = 10, faction = 1, reward = 5517, faction_required = 20 },  -- gem_3bl_cap
        { item = 55566, exp = 10, faction = 1, reward = 5555, faction_required = 20 },  -- gem_3bl_food
        { item = 55567, exp = 10, faction = 1, reward = 5557, faction_required = 20 },  -- gem_3bl_drink
        { item = 55582, exp = 10, faction = 1, reward = 5540, faction_required = 20 },  -- gem_3bl_ssword
        { item = 55571, exp = 12, faction = 1, reward = 5519, faction_required = 40 },  -- gem_3bl_neck
        { item = 55581, exp = 12, faction = 1, reward = 5539, faction_required = 40 },  -- gem_3bl_staff
        { item = 55572, exp = 14, faction = 1, reward = 5521, faction_required = 55 },  -- gem_3bl_arm
        { item = 55583, exp = 14, faction = 1, reward = 5541, faction_required = 55 },  -- gem_3bl_whammer
        { item = 55573, exp = 16, faction = 1, reward = 5523, faction_required = 70 },  -- gem_3bl_wrist
        { item = 55584, exp = 16, faction = 1, reward = 5542, faction_required = 70 },  -- gem_3bl_flail
        { item = 55574, exp = 18, faction = 1, reward = 5525, faction_required = 85 },  -- gem_3bl_gloves
        { item = 55580, exp = 18, faction = 1, reward = 5515, faction_required = 85 },  -- gem_3bl_symbol
        { item = 55576, exp = 20, faction = 1, reward = 5529, faction_required = 100 },  -- gem_3bl_belt
        { item = 55585, exp = 20, faction = 1, reward = 5543, faction_required = 100 },  -- gem_3bl_shiv
        { item = 55578, exp = 22, faction = 2, reward = 5533, faction_required = 115 },  -- gem_3bl_boots
        { item = 55586, exp = 22, faction = 2, reward = 5544, faction_required = 115 },  -- gem_3bl_lsword
        { item = 55577, exp = 24, faction = 2, reward = 5531, faction_required = 130 },  -- gem_3bl_legs
        { item = 55589, exp = 26, faction = 2, reward = 5537, faction_required = 145 },  -- gem_3bl_robe
        { item = 55575, exp = 26, faction = 2, reward = 5527, faction_required = 145 },  -- gem_3bl_jerkin
        { item = 55588, exp = 26, faction = 2, reward = 5553, faction_required = 85 },  -- gem_3bl_light
        { item = 55579, exp = 28, faction = 3, reward = 5535, faction_required = 160 },  -- gem_3bl_mask
        { item = 55587, exp = 28, faction = 3, reward = 5545, faction_required = 160 },  -- gem_3bl_smace
        { item = 5504, exp = 2, faction = 1 },  -- 3el_skull (trophy)
        { item = 5506, exp = 2, faction = 1 },  -- 3el_ring (trophy)
        { item = 5508, exp = 2, faction = 1 },  -- 3el_badge (trophy)
        { item = 5510, exp = 2, faction = 2 },  -- 3el_token (trophy)
        { item = 5512, exp = 2, faction = 2 },  -- 3el_insignia (trophy)
        { item = 5514, exp = 2, faction = 2 },  -- 3el_wand (trophy)
        { item = 5516, exp = 2, faction = 3 },  -- 3el_symbol (trophy)
    }
    local is_gem, exp_multiplier, id_reward, faction_required, faction_multiplier
    local id_trophy
    local entry
    for _, t in ipairs(TURNIN) do
        local z, i = proto_key(t.item)
        if object.zone_id == z and object.id == i then
            entry = t
            break
        end
    end
    if entry then
        exp_multiplier = entry.exp
        faction_multiplier = entry.faction
        if entry.reward then
            is_gem = 1
            id_reward = entry.reward
            faction_required = entry.faction_required
        else
            id_trophy = entry.item
        end
    else
        give_back()
        wait(0.1)
        self:command("eye " .. tostring(actor.name))
        actor:send(tostring(self.name) .. " tells you, 'I am not interested in this from you.'")
        actor:send(tostring(self.name) .. " returns your item to you.")
        return _return_value
    end
    -- 
    -- need to force character saving after each turnin.
    -- 
    if not is_gem then
        local faction_advance = 0
        local exp_advance = 0
        -- hrmm Jelos' magical variable declaration
        if actor:get_quest_var("black_legion:" .. tostring(id_trophy) .. "_trophies") then
        else
            actor:set_quest_var("black_legion", tostring(id_trophy) .. "_trophies", 0)
        end
        local trophies = actor:get_quest_var("black_legion:" .. tostring(id_trophy) .. "_trophies")
        actor:set_quest_var("black_legion", tostring(id_trophy) .. "_trophies", trophies)
        -- The highest faction a player can gain from interacting with the 3rd front creatures will
        -- be 200.  For this section the trophy turn in will reply on this and other checks.
        if (actor:get_quest_var("black_legion:bl_faction") or 0) < 200 then
            local trophies = (actor:get_quest_var("black_legion:" .. tostring(id_trophy) .. "_trophies") or 0) + 1
            actor:set_quest_var("black_legion", tostring(id_trophy) .. "_trophies", trophies)
            wait(0.2)
            actor:send(tostring(self.name) .. " tells you, 'Hrm, yes.. you have been out")
            actor:send("</>fighting the Eldorian Guard.  I see from my records you have now given me")
            actor:send("</><b:yellow>" .. tostring(trophies) .. "</> <b:white>" .. proto_short(id_trophy) .. "</>.'")
            world.destroy(object)
            actor:save()
            if trophies < 10 then
                faction_advance = 1
                exp_advance = 1
            else
                faction_advance = 1
            end
        else
            if (trophies or 0) < 10 then
                exp_advance = 1
                local trophies = (actor:get_quest_var("black_legion:" .. tostring(id_trophy) .. "_trophies") or 0) + 1
                actor:set_quest_var("black_legion", tostring(id_trophy) .. "_trophies", trophies)
            else
                give_back()
            end
            wait(0.2)
            self:command("eye " .. tostring(actor.name))
            actor:send(tostring(self.name) .. " tells you, 'You have garnered as much favor with")
            actor:send("</>the Black Legion as you possibly can by fighting the Third Eldrian Guard.  You")
            actor:send("</>may one day find other more difficult battles with those tree rats that will")
            actor:send("</>curry more favor with our lords.'")
        end
        -- 
        -- Double check that the criteria for rewards for this section are met.
        -- 
        if exp_advance > 0 then
            -- 
            -- loop for exp award.
            -- 
            -- (empty send to actor)
            actor:send("<b:yellow>You gain experience!</>")
            local lap = 1
            while lap <= exp_multiplier do
                actor:award_exp(2640)
                lap = lap + 1
            end
            -- 
            -- end exp loop
            -- 
            -- all other items should be mpjunked or whatever by now
        end
        if faction_advance > 0 then
            -- 
            -- loop for faction award.
            -- 
            actor:send("<b:yellow>Your curry favor with the Black Legion!</>")
            actor:send("<b:red>You feel more hated by the Eldorian Guard!</>")
            local lap = 1
            while lap <= faction_multiplier do
                local faction = (actor:get_quest_var("black_legion:bl_faction") or 0) + 1
                actor:set_quest_var("black_legion", "bl_faction", faction)
                -- 
                -- slight bug for now the trigger code can't seem to evaluate negative numbers?
                -- 
                local faction2 = (actor:get_quest_var("black_legion:eg_faction") or 0) - 1
                actor:set_quest_var("black_legion", "eg_faction", faction2)
                lap = lap + 1
            end
            -- 
            -- end faction loop
            -- 
            -- all other items should be mpjunked or whatever by now
        end
        -- end of !if_gem section or trophy endif
        actor:save()
    end
    if is_gem then
        -- hrmm Jelos' magical variable declaration
        if actor:get_quest_var("black_legion:" .. tostring(id_reward) .. "_reward") then
        else
            actor:set_quest_var("black_legion", tostring(id_reward) .. "_reward", 0)
        end
        local rewards = actor:get_quest_var("black_legion:" .. tostring(id_reward) .. "_reward")
        actor:set_quest_var("black_legion", tostring(id_reward) .. "_reward", rewards)
        if actor.alignment >= 151 then
            give_back()
            wait(0.2)
            actor:send(tostring(self.name) .. " tells you, 'You aren't quite evil enough for")
            actor:send("</>these rewards.'")
            return _return_value
        end
        if (actor:get_quest_var("black_legion:bl_faction") or 0) >= faction_required then
            local rewards = (actor:get_quest_var("black_legion:" .. tostring(id_reward) .. "_reward") or 0) + 1
            actor:set_quest_var("black_legion", tostring(id_reward) .. "_reward", rewards)
            wait(0.2)
            actor:send(tostring(self.name) .. " tells you, 'Ah yes, the Legion thanks you for")
            actor:send("</>your efforts.  Take this to aid you in your battles.'")
            wait(0.1)
            self:spawn_object(proto_key(id_reward))
            wait(0.1)
            if (actor:get_quest_var("black_legion:" .. tostring(id_reward) .. "_reward") or 0) == 1 then
                -- 
                -- loop for exp award.
                -- 
                -- (empty send to actor)
                actor:send("<b:yellow>You gain experience!</>")
                local lap = 1
                while lap <= exp_multiplier do
                    actor:award_exp(2640)
                    lap = lap + 1
                end
                -- 
                -- end exp loop
                -- 
                -- all other items should be mpjunked or whatever by now
            end
            if (actor:get_quest_var("black_legion:bl_faction") or 0) < 200 then
                -- 
                -- loop for faction award.
                -- 
                actor:send("<b:yellow>Your curry favor with the Black Legion!</>")
                actor:send("<b:red>You feel more hated by the Eldorian Guard!</>")
                local lap = 1
                while lap <= faction_multiplier do
                    local faction = (actor:get_quest_var("black_legion:bl_faction") or 0) + 1
                    actor:set_quest_var("black_legion", "bl_faction", faction)
                    -- 
                    -- slight bug for now the trigger code can't seem to evaluate negative numbers?
                    -- 
                    local faction2 = (actor:get_quest_var("black_legion:eg_faction") or 0) - 1
                    actor:set_quest_var("black_legion", "eg_faction", faction2)
                    lap = lap + 1
                end
                -- 
                -- end faction loop
                -- 
                -- all other items should be mpjunked or whatever by now
            end
            world.destroy(object)
            self:destroy_item("all.eldoria-trophy")
            self:command("give all " .. tostring(actor.name))
            actor:save()
        else
            give_back()
            wait(0.2)
            actor:send(tostring(self.name) .. " tells you, 'You aren't quite allied enough")
            actor:send("</>with our cause to earn that reward.'")
            return _return_value
        end
        -- end of if_gem section
    end
else
    -- Alignment not low enough or hasn't started the quest yet.
    give_back()
    wait(0.2)
    actor:send(tostring(self.name) .. " tells you, 'You aren't quite allied enough with")
    actor:send("</>our cause to earn our rewards.  You need a lower alignment or to start these")
    actor:send("</>quests by saying <b:white>[yes]</> or <b:white>[quest]</> or <b:white>[hello]</>.'")
end
return _return_value$trig$, 'b8baf9af5bbe0ae81107a90986a05e5f'),
  -- data/triggers/055/055_07_3eg_turn_in.lua
  (55, 7, $trig$-- Converted from DG Script #5507: 3eg_turn_in
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
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
local _return_value = true  -- Default: allow action
-- The runtime fires RECEIVE after the item is already in the mob's hands, so a refusal hands it
-- back with a give command (DG's `return 0`).
local function give_back()
    local bare = string.gsub(string.gsub(object.name, "^%s*[Tt]he%s+", ""), "^%s*[Aa]n?%s+", "")
    self:command("give " .. bare .. " " .. actor.name)
end
-- 
-- This is the main receive trigger for the Edorian
-- combat quests installed on the mud. This trigger
-- will be generic and the IDs and variables set
-- to reflect which faction it applies to.
-- 
-- 3eg is Third Eldorian Guard
if actor:get_quest_var("Black_Legion:bl_ally") then
    actor:send(tostring(self.name) .. " tells you, 'You have pledged")
    actor:send("</>yourself to the forces of darkness!  Suffer under your choice!'")
    return _return_value
end
if actor.alignment >= -150 and actor:get_quest_stage("Black_Legion") > 0 then
    actor:set_quest_var("Black_Legion", "eg_ally", 1)
    -- 
    -- Objects this questmaster accepts, as the legacy vnums (zone * 100 + id) the DG script used:
    -- `item` is what the player hands over, `reward` the item given back for a gem. Quest-variable
    -- keys stay <vnum>_trophies / <vnum>_reward like legacy.
    local TURNIN = {
        { item = 55570, exp = 10, faction = 1, reward = 5518, faction_required = 20 },  -- gem_3eg_cap
        { item = 55566, exp = 10, faction = 1, reward = 5556, faction_required = 20 },  -- gem_3eg_food
        { item = 55567, exp = 10, faction = 1, reward = 5558, faction_required = 20 },  -- gem_3eg_drink
        { item = 55582, exp = 10, faction = 1, reward = 5547, faction_required = 20 },  -- gem_3eg_ssword
        { item = 55571, exp = 12, faction = 1, reward = 5520, faction_required = 40 },  -- gem_3eg_neck
        { item = 55581, exp = 12, faction = 1, reward = 5546, faction_required = 40 },  -- gem_3eg_staff
        { item = 55572, exp = 14, faction = 1, reward = 5522, faction_required = 55 },  -- gem_3eg_arm
        { item = 55583, exp = 14, faction = 1, reward = 5548, faction_required = 55 },  -- gem_3eg_whammer
        { item = 55573, exp = 16, faction = 1, reward = 5524, faction_required = 70 },  -- gem_3eg_wrist
        { item = 55584, exp = 16, faction = 1, reward = 5549, faction_required = 70 },  -- gem_3eg_flail
        { item = 55574, exp = 18, faction = 1, reward = 5526, faction_required = 85 },  -- gem_3eg_gloves
        { item = 55580, exp = 18, faction = 1, reward = 5516, faction_required = 85 },  -- gem_3eg_symbol
        { item = 55576, exp = 20, faction = 1, reward = 5530, faction_required = 100 },  -- gem_3eg_belt
        { item = 55585, exp = 20, faction = 1, reward = 5550, faction_required = 100 },  -- gem_3eg_shiv
        { item = 55578, exp = 22, faction = 2, reward = 5534, faction_required = 115 },  -- gem_3eg_boots
        { item = 55586, exp = 22, faction = 2, reward = 5551, faction_required = 115 },  -- gem_3eg_lsword
        { item = 55577, exp = 24, faction = 2, reward = 5532, faction_required = 130 },  -- gem_3eg_legs
        { item = 55589, exp = 26, faction = 2, reward = 5538, faction_required = 145 },  -- gem_3eg_robe
        { item = 55575, exp = 26, faction = 2, reward = 5528, faction_required = 145 },  -- gem_3eg_jerkin
        { item = 55588, exp = 26, faction = 2, reward = 5554, faction_required = 85 },  -- gem_3eg_light
        { item = 55579, exp = 28, faction = 3, reward = 5536, faction_required = 160 },  -- gem_3eg_mask
        { item = 55587, exp = 28, faction = 3, reward = 5552, faction_required = 160 },  -- gem_3eg_smace
        { item = 5503, exp = 2, faction = 1 },  -- 3bl_skull (trophy)
        { item = 5505, exp = 2, faction = 1 },  -- 3bl_ring (trophy)
        { item = 5507, exp = 2, faction = 1 },  -- 3bl_badge (trophy)
        { item = 5509, exp = 2, faction = 2 },  -- 3bl_token (trophy)
        { item = 5511, exp = 2, faction = 2 },  -- 3bl_insignia (trophy)
        { item = 5513, exp = 2, faction = 2 },  -- 3bl_wand (trophy)
        { item = 5515, exp = 2, faction = 3 },  -- 3bl_symbol (trophy)
    }
    local is_gem, exp_multiplier, id_reward, faction_required, faction_multiplier
    local id_trophy
    local entry
    for _, t in ipairs(TURNIN) do
        local z, i = proto_key(t.item)
        if object.zone_id == z and object.id == i then
            entry = t
            break
        end
    end
    if entry then
        exp_multiplier = entry.exp
        faction_multiplier = entry.faction
        if entry.reward then
            is_gem = 1
            id_reward = entry.reward
            faction_required = entry.faction_required
        else
            id_trophy = entry.item
        end
    else
        give_back()
        wait(0.1)
        self:command("eye " .. tostring(actor.name))
        actor:send(tostring(self.name) .. " tells you, 'I am not interested in this from you.'")
        actor:send(tostring(self.name) .. " returns your item to you.")
        return _return_value
    end
    -- 
    -- need to force character saving after each turnin.
    -- 
    if not is_gem then
        local faction_advance = 0
        local exp_advance = 0
        -- hrmm Jelos' magical variable declaration
        if actor:get_quest_var("black_legion:" .. tostring(id_trophy) .. "_trophies") then
        else
            actor:set_quest_var("black_legion", tostring(id_trophy) .. "_trophies", 0)
        end
        local trophies = actor:get_quest_var("black_legion:" .. tostring(id_trophy) .. "_trophies")
        actor:set_quest_var("black_legion", tostring(id_trophy) .. "_trophies", trophies)
        -- The highest faction a player can gain from interacting with the 3rd front creatures will
        -- be 200.  For this section the trophy turn in will reply on this and other checks.
        if (actor:get_quest_var("black_legion:eg_faction") or 0) < 200 then
            local trophies = (actor:get_quest_var("black_legion:" .. tostring(id_trophy) .. "_trophies") or 0) + 1
            actor:set_quest_var("black_legion", tostring(id_trophy) .. "_trophies", trophies)
            wait(0.2)
            actor:send(tostring(self.name) .. " tells you, 'Hrm, yes... you have")
            actor:send("</>been out fighting the Black Legion.  I see from my records you have now given")
            actor:send("</>me <b:yellow>" .. tostring(trophies) .. " <white>" .. proto_short(id_trophy) .. "</>.'")
            world.destroy(object)
            actor:save()
            if trophies < 10 then
                faction_advance = 1
                exp_advance = 1
            else
                faction_advance = 1
            end
        else
            if (trophies or 0) < 10 then
                exp_advance = 1
                local trophies = (actor:get_quest_var("black_legion:" .. tostring(id_trophy) .. "_trophies") or 0) + 1
                actor:set_quest_var("black_legion", tostring(id_trophy) .. "_trophies", trophies)
            else
                give_back()
            end
            wait(0.2)
            self:command("eye " .. tostring(actor.name))
            actor:send(tostring(self.name) .. " tells you, 'You have garnered as")
            actor:send("</>much favor with the Eldorian Guard as you possibly can by fighting the Third")
            actor:send("</>Black Legion.  You may one day find other more difficult battles with those")
            actor:send("</>tree rats that will curry more favor with our masters.'")
        end
        -- 
        -- Double check that the criteria for rewards for this section are met.
        -- 
        if exp_advance > 0 then
            -- 
            -- loop for exp award.
            -- 
            -- (empty send to actor)
            actor:send("<b:yellow>You gain experience!</>")
            local lap = 1
            while lap <= exp_multiplier do
                actor:award_exp(2640)
                lap = lap + 1
            end
            -- 
            -- end exp loop
            -- 
            -- all other items should be mpjunked or whatever by now
        end
        if faction_advance > 0 then
            -- 
            -- loop for faction award.
            -- 
            actor:send("<b:yellow>Your curry favor with the Eldorian Guard!</>")
            actor:send("<b:red>You feel more hated by the Black Legion!</>")
            local lap = 1
            while lap <= faction_multiplier do
                local faction = (actor:get_quest_var("black_legion:eg_faction") or 0) + 1
                actor:set_quest_var("black_legion", "eg_faction", faction)
                -- 
                -- slight bug for now the trigger code can't seem to evaluate negative numbers?
                -- 
                local faction2 = (actor:get_quest_var("black_legion:bl_faction") or 0) - 1
                actor:set_quest_var("black_legion", "bl_faction", faction2)
                lap = lap + 1
            end
            -- 
            -- end faction loop
            -- 
            -- all other items should be mpjunked or whatever by now
        end
        actor:save()
        -- end of !if_gem section or trophy endif
    end
    if is_gem then
        -- hrmm Jelos' magical variable declaration
        if actor:get_quest_var("black_legion:" .. tostring(id_reward) .. "_reward") then
        else
            actor:set_quest_var("black_legion", tostring(id_reward) .. "_reward", 0)
        end
        local rewards = actor:get_quest_var("black_legion:" .. tostring(id_reward) .. "_reward")
        actor:set_quest_var("black_legion", tostring(id_reward) .. "_reward", rewards)
        if actor.alignment <= -151 then
            give_back()
            wait(0.2)
            actor:send(tostring(self.name) .. " tells you, 'You aren't quite good")
            actor:send("</>enough for these rewards.'")
            return _return_value
        end
        if (actor:get_quest_var("black_legion:eg_faction") or 0) >= faction_required then
            local rewards = (actor:get_quest_var("black_legion:" .. tostring(id_reward) .. "_reward") or 0) + 1
            actor:set_quest_var("black_legion", tostring(id_reward) .. "_reward", rewards)
            wait(0.2)
            actor:send(tostring(self.name) .. " tells you, 'Ah yes, the Guard")
            actor:send("</>thanks you for your efforts.  Take this to aid you in your battles.'")
            wait(0.1)
            self:spawn_object(proto_key(id_reward))
            wait(0.1)
            if (actor:get_quest_var("black_legion:" .. tostring(id_reward) .. "_reward") or 0) == 1 then
                -- 
                -- loop for exp award.
                -- 
                -- (empty send to actor)
                actor:send("<b:yellow>You gain experience!</>")
                local lap = 1
                while lap <= exp_multiplier do
                    actor:award_exp(2640)
                    lap = lap + 1
                end
                -- 
                -- end exp loop
                -- 
                -- all other items should be mpjunked or whatever by now
            end
            if (actor:get_quest_var("black_legion:eg_faction") or 0) < 200 then
                -- 
                -- loop for faction award.
                -- 
                actor:send("<b:yellow>Your curry favor with the Eldorian Guard!</>")
                actor:send("<b:red>You feel more hated by the Black Legion!</>")
                local lap = 1
                while lap <= faction_multiplier do
                    local faction = (actor:get_quest_var("black_legion:eg_faction") or 0) + 1
                    actor:set_quest_var("black_legion", "eg_faction", faction)
                    -- 
                    -- slight bug for now the trigger code can't seem to evaluate negative numbers?
                    -- 
                    local faction2 = (actor:get_quest_var("black_legion:bl_faction") or 0) - 1
                    actor:set_quest_var("black_legion", "bl_faction", faction2)
                    lap = lap + 1
                end
                -- 
                -- end faction loop
                -- 
                -- all other items should be mpjunked or whatever by now
            end
            world.destroy(object)
            self:destroy_item("all.eldoria-trophy")
            self:command("give all " .. tostring(actor.name))
            actor:save()
        else
            give_back()
            wait(0.2)
            actor:send(tostring(self.name) .. " tells you, 'You aren't quite allied")
            actor:send("</>enough with our cause to earn that reward.'")
            return _return_value
        end
        -- end of if_gem section
    end
else
    -- Alignment not high enough or hasn't started the quest yet.
    give_back()
    wait(0.2)
    actor:send(tostring(self.name) .. " tells you, 'You aren't quite allied")
    actor:send("</>enough with our cause to earn our rewards.  You need a higher alignment or to")
    actor:send("</>start these quests by saying <b:white>[yes]</> or <b:white>[quest]</> or <b:white>[hello]</>.'")
end
return _return_value$trig$, 'be5eec34228cef83a61e824fce5dc98e')
) AS v(zone_id, id, commands, old_md5)
WHERE t.zone_id = v.zone_id
  AND t.id = v.id
  AND md5(t.commands) = v.old_md5
  AND t.commands IS DISTINCT FROM v.commands;

COMMIT;
