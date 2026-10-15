-- Mob RECEIVE triggers: refusals return false before any wait and no longer queue a give-back (the engine returns the item).
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
  -- data/triggers/002/002_102_phase_wands_bigby_research_assistant_receive.lua
  (2, 102, $trig$local dg = require("dg")

local function give_back()
    dg.give(self, object, actor)
end

local quest_type, wandgem, wand, next_id
if object.zone_id == 2 and object.id == 100 then
    quest_type, wandgem, wand, next_id = "air", 55577, true, 101
elseif object.zone_id == 2 and object.id == 110 then
    quest_type, wandgem, wand, next_id = "fire", 55575, true, 111
elseif object.zone_id == 2 and object.id == 120 then
    quest_type, wandgem, wand, next_id = "ice", 55574, true, 121
elseif object.zone_id == 2 and object.id == 130 then
    quest_type, wandgem, wand, next_id = "acid", 55576, true, 131
elseif object.zone_id == 555 and object.id == 77 then
    quest_type, wandgem = "air", true
elseif object.zone_id == 555 and object.id == 75 then
    quest_type, wandgem = "fire", true
elseif object.zone_id == 555 and object.id == 74 then
    quest_type, wandgem = "ice", true
elseif object.zone_id == 555 and object.id == 76 then
    quest_type, wandgem = "acid", true
end
if not quest_type then
    return true
end

local quest = quest_type .. "_wand"
local times = 50
local stage = actor:get_quest_stage(quest)

if stage == 2 then
    if wand then
        if dg.flag(actor:get_quest_var(quest .. ":wandtask1")) and dg.flag(actor:get_quest_var(quest .. ":wandtask2")) then
            actor:advance_quest(quest)
            actor:set_quest_var(quest, "greet", 0)
            actor:set_quest_var(quest, "attack_counter", 0)
            for n = 1, 5 do
                actor:set_quest_var(quest, "wandtask" .. tostring(n), 0)
            end
            wait(2)
            self:say("Fantastic work!  This is everything.")
            wait(1)
            self.room:send(tostring(self.name) .. " combines the materials to empower " .. tostring(object.shortdesc) .. "!")
            world.destroy(object)
            wait(2)
            actor:send(tostring(self.name) .. " presents you with a new wand!")
            dg.give(self, self:spawn_object(2, next_id), actor)
            local expmod = 690
            if actor.class == "sorcerer" or actor.class == "pyromancer" or actor.class == "cryomancer" or actor.class == "illusionist" or actor.class == "bard" then
                expmod = expmod + math.floor(expmod / 5)
            elseif actor.class == "necromancer" then
                expmod = expmod + math.floor((expmod * 2) / 5)
            end
            actor:send("<b:yellow>You gain experience!</>")
            local setexp = expmod * 10
            for _ = 1, 5 do
                actor:award_exp(setexp)
            end
            wait(2)
            if actor.level < 20 then
                self:say("In time, you'll be able to take another step.  Come back when you've seen some more of the world.")
            else
                self:say("You're ready to take the next step.")
                wait(1)
                if quest_type == "air" then
                    self:say("Speak with the old Abbot in the Abbey of St. George.")
                elseif quest_type == "fire" then
                    self:say("The keeper of the temple to the dark flame out east will know what to do.")
                elseif quest_type == "ice" then
                    self:say("The shaman near Three-Falls River has developed a powerful affinity for water from his life in the canyons.  Seek his advice.")
                elseif quest_type == "acid" then
                    self:say("First, seek the one who guards the eastern gates of Ickle.")
                end
            end
        else
            self.room:send(tostring(self.name) .. " scrutinizes " .. tostring(object.shortdesc) .. " with suspicion.")
            self.room:send(tostring(self.name) .. " returns " .. tostring(object.shortdesc) .. ".")
            self:say("You haven't finished all the tasks to prime the wand yet.")
            return false  -- legacy return 0: the giver keeps the item
        end
    elseif wandgem then
        actor:set_quest_var(quest, "wandtask2", 1)
        wait(2)
        world.destroy(object)
        self:say("Yes, this is exactly what I need!")
        wait(1)
        if dg.flag(actor:get_quest_var(quest .. ":wandtask1")) then
            self:say("Give me the wand to improve.")
        else
            self:say("Keep practicing with your wand!")
            wait(2)
            self:say("Come back when you've attacked " .. tostring(times) .. " times.")
        end
    end
elseif stage < 2 then
    if wand then
        wait(2)
        if stage == 0 then
            actor:start_quest(quest)
            self:say("I can upgrade your " .. quest_type .. " wand!  But what I will do is just the first step in a life-long journey.")
            wait(2)
            self.room:send(tostring(self.name) .. " says, 'This step is relatively simple though.  You can check your <b:cyan>[wand progress]</> with me as well.'")
            wait(1)
        end
        actor:advance_quest(quest)
        self:command("nod")
        self:say("Yes, this is a good match for you.")
        wait(1)
        self:say("To upgrade your wand:")
        self.room:send("- attack <b:yellow>" .. tostring(times) .. "</> times with it")
        self.room:send("- bring me <b:yellow>" .. dg.oname(wandgem) .. "</>")
        wait(2)
        self:say("Do that and I'll be able to improve it.")
        give_back()
    elseif wandgem then
        self.room:send(tostring(self.name) .. " declines " .. tostring(object.shortdesc) .. ".")
        self:say("Before you give me anything else, give me the wand you wish to improve.")
        return false  -- legacy return 0: the giver keeps the item
    end
else
    self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
    self:say("I've already upgraded your wand as much as I know how.")
    return false  -- legacy return 0: the giver keeps the item
end
return true$trig$, 'fc7bd05b604834c33523976bea8f56d8'),
  -- data/triggers/002/002_108_phase_wand_general_receive.lua
  (2, 108, $trig$local dg = require("dg")

local function vkey(vnum) return dg.obj(vnum) end
local function oname(vnum) return dg.oname(vnum) end
local function mname(vnum) return dg.mname(vnum) end
local function is_obj(vnum) return dg.is_obj(object, vnum) end
-- A quest flag is set when it holds a non-zero value (0 is truthy in Lua).
local set_ = dg.flag

local function give_back()
    dg.give(self, object, actor)
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
            local primed_item = self:spawn_object(vkey(wandtask4))
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
            give_back()
            dg.give(self, primed_item, actor)
        end
    elseif set_(job1) and set_(job2) and set_(job3) then
        if stage == 10 then
            local room = get_room(dg.room(wandtask4))
            actor:set_quest_var(quest, "wandtask4", 1)
            wait(0.2)
            self.room:send(self.name .. " utters eldritch incantations over " .. object.shortdesc .. ".")
            wait(2)
            self.room:send(object.shortdesc .. " begins to crackle with supreme elemental power!")
            wait(1)
            self.room:send(self.name .. " says, 'Now that you've captured the demon's energies, you must make your way deep into the elemental planes.  There, in the full glory of elemental " .. quest_type .. ", find <b:cyan>" .. tostring(room and room.name or "the plane's heart") .. "</> and <b:cyan>imbue</> it with the energy of the plane.'")
            wait(6)
            self:say("It will forge the most powerful staff of " .. quest_type .. " in all the realms!")
            give_back()
        elseif stage == 3 then
            continue = "yes"
        else
            continue = "no"
        end
    else
        continue = "no"
    end
else
    self.room:send(self.name .. " refuses " .. object.shortdesc .. ".")
    self:say("What's that for?")
    return false  -- legacy return 0: the giver keeps the item
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
    dg.give(self, self:spawn_object(vkey(reward)), actor)

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
    self.room:send(self.name .. " refuses " .. object.shortdesc .. ".")
    if not set_(job1) and (not set_(job2) or not set_(job3) or not set_(job4)) then
        local counter = 50
        local remaining = ((actor:get_quest_stage(quest) - 1) * counter) - (actor:get_quest_var(quest .. ":attack_counter") or 0)
        self.room:send(self.name .. " says, 'You still need to attack <b:yellow>" .. remaining .. "</> more times to fully bond with your " .. weapon .. "!'")
        self:say("I need the other items as well.")
    elseif set_(job1) and (not set_(job2) or not set_(job3) or not set_(job4)) then
        self:say("You have to give me everything else first.")
    end
    return false  -- legacy return 0: the giver keeps the item
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
    self.room:send(self.name .. " refuses " .. object.shortdesc .. ".")
    self:say(response)
    return false  -- legacy return 0: the giver keeps the item
end
return true$trig$, '784b44ffb40ab89feb3a0a5c124a778e'),
  -- data/triggers/002/002_126_phase_mace_receive.lua
  (2, 126, $trig$local dg = require("dg")

local function vkey(vnum) return dg.obj(vnum) end
local function oname(vnum) return dg.oname(vnum) end
local function is_obj(vnum) return dg.is_obj(object, vnum) end
-- A quest flag is set when it holds a non-zero value (0 is truthy in Lua).
local set_ = dg.flag

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
    dg.give(self, self:spawn_object(vkey(reward_mace)), actor)
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
    actor:send(self.name .. " refuses " .. object.shortdesc .. ".")
    says(response)
    return false  -- legacy return 0: the giver keeps the item
end

if priest then
    self:set_flag("sentinel", false)
end
return true$trig$, '027f0149e941a2fa96a0bd1ab4fdff18'),
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
-- The give command takes one word for the item and has no "give all", so items go over one by
-- one through dg.give, by their first keyword.
local dg = require("dg")
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
if actor:get_quest_var("black_legion:eg_ally") then
    actor:send(tostring(self.name) .. " tells you, 'You have already chosen your side!  Be")
    actor:send("</>gone, filth!'")
    return _return_value
end
-- 
if actor.alignment <= 150 and actor:get_quest_stage("black_legion") > 0 then
    actor:set_quest_var("black_legion", "bl_ally", 1)
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
        self:command("eye " .. tostring(actor.name))
        actor:send(tostring(self.name) .. " tells you, 'I am not interested in this from you.'")
        actor:send(tostring(self.name) .. " returns your item to you.")
        return false  -- legacy return 0: the giver keeps the item
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
                return false  -- legacy return 0: the giver keeps the item
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
            actor:send(tostring(self.name) .. " tells you, 'You aren't quite evil enough for these")
            actor:send("</>rewards.'")
            return false  -- legacy return 0: the giver keeps the item
        end
        if (actor:get_quest_var("black_legion:bl_faction") or 0) >= faction_required then
            local rewards = (actor:get_quest_var("black_legion:" .. tostring(id_reward) .. "_reward") or 0) + 1
            actor:set_quest_var("black_legion", tostring(id_reward) .. "_reward", rewards)
            wait(0.2)
            actor:send(tostring(self.name) .. " tells you, 'Ah yes, the Legion thanks you for your")
            actor:send("</>efforts.  Take this to aid you in your battles.'")
            wait(0.1)
            local reward_item = self:spawn_object(proto_key(id_reward))
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
            dg.give(self, reward_item, actor)
            actor:save()
        else
            actor:send(tostring(self.name) .. " tells you, 'You aren't quite allied enough with our")
            actor:send("</>cause to earn that reward.'")
            return false  -- legacy return 0: the giver keeps the item
        end
        -- end of if_gem section
    end
else
    -- Alignment not low enough or hasn't started the quest yet.
    actor:send(tostring(self.name) .. " tells you, 'You aren't quite allied enough with our")
    actor:send("</>cause to earn our rewards.  You need a lower alignement, or to start these")
    actor:send("</>quests by saying <b:white>[yes]</>, <b:white>[quest]</>, or <b:white>[hello]</>.'")
    return false  -- legacy return 0: the giver keeps the item
end
return _return_value$trig$, 'e500b49925f73b863987ac4040fe5093'),
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
-- The give command takes one word for the item and has no "give all", so items go over one by
-- one through dg.give, by their first keyword.
local dg = require("dg")
-- 
-- This is the main receive trigger for the Edorian
-- combat quests installed on the mud. This trigger
-- will be generic and the IDs and variables set
-- to reflect which faction it applies to.
-- 
if actor:get_quest_var("black_legion:bl_ally") then
    actor:send(tostring(self.name) .. " tells you, 'You have pledged yourself to the forces of")
    actor:send("</>darkness!  Suffer under your choice!'")
    return _return_value
end
-- 3eg is Third Eldorian Guard
if actor.alignment >= -150 and actor:get_quest_stage("black_legion") > 0 then
    actor:set_quest_var("black_legion", "eg_ally", 1)
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
        self:command("eye " .. tostring(actor.name))
        actor:send(tostring(self.name) .. " tells you, 'I am not interested in this from you.'")
        actor:send(tostring(self.name) .. " returns your item to you.")
        return false  -- legacy return 0: the giver keeps the item
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
                self:command("eye " .. tostring(actor.name))
                actor:send(tostring(self.name) .. " tells you, 'You have garnered as much favor with the")
                actor:send("</>Eldorian Guard as you possibly can by raiding Split Skull.'")
                -- (empty send to actor)
                actor:send(tostring(self.name) .. " tells you, 'You will find other more difficult battles")
                actor:send("</>with the Legion that will curry more favor with our masters in Eldoria.'")
                -- (empty send to actor)
                actor:send(tostring(self.name) .. " tells you, 'Go to Tarelithis and seek the Recruiter of")
                actor:send("</>the Third Eldorian Guard!'")
                return false  -- legacy return 0: the giver keeps the item
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
            actor:send(tostring(self.name) .. " tells you, 'You aren't quite good enough for these")
            actor:send("</>rewards.'")
            return false  -- legacy return 0: the giver keeps the item
        end
        if (actor:get_quest_var("black_legion:eg_faction") or 0) >= faction_required then
            local rewards = (actor:get_quest_var("black_legion:" .. tostring(id_reward) .. "_reward") or 0) + 1
            actor:set_quest_var("black_legion", tostring(id_reward) .. "_reward", rewards)
            wait(0.2)
            actor:send(tostring(self.name) .. " tells you, 'Ah yes, the Guard thanks you for your")
            actor:send("</>efforts.  Take this to aid you in your battles.'")
            wait(0.1)
            local reward_item = self:spawn_object(proto_key(id_reward))
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
            dg.give(self, reward_item, actor)
            actor:save()
        else
            actor:send(tostring(self.name) .. " tells you, 'You aren't quite allied enough with our cause")
            actor:send("</>to earn that reward.'")
            return false  -- legacy return 0: the giver keeps the item
        end
        -- end of if_gem section
    end
else
    -- Alignment not high enough or hasn't started the quest yet.
    actor:send(tostring(self.name) .. " tells you, 'You aren't quite allied enough with our cause")
    actor:send("</>to earn our rewards.  You need a higher alignment or to start these quests by")
    actor:send("</>saying <b:white>[yes]</> or <b:white>[quest]</> or <b:white>[hello]</>.'")
    return false  -- legacy return 0: the giver keeps the item
end
return _return_value$trig$, '3985946aa7b7b8f812645c659dd7f32c'),
  -- data/triggers/051/051_02_stone-statue-ring--dagger.lua
  (51, 2, $trig$-- Converted from DG Script #5102: Stone-statue-ring--dagger
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
--
-- When the player offers the stone-ring (51/2) to the statue, the statue
-- "comes to life", consumes the ring, and triggers room script 51/1 which
-- spawns the stone dagger. Any other object: refuse with flavor text.
--
-- TODO: object.id == 5102 is a legacy DG vnum check. The receive trigger
-- here is matched on object 51/2 (the stone ring), so this comparison
-- still selects the right object, but it should be rewritten using the
-- composite (zone_id, local_id) check once we're confident in the API.
if not actor.is_player then
    return true
end
if (object.zone_id == 51 and object.id == 2) then
    wait(2)
    self.room:send("<b:blue>The eyes of the immense stone statue glow <b:red>red</> <b:blue>as a deafening hum shakes the cavern!</>")
    wait(2)
    self.room:send("<b:yellow>The statue comes to life!</>")
    wait(1)
    self.room:send("<blue>The statue makes your soul quake with a vicious</> <b:red>ROOOOOAAAAAARRRRRR!</>")
    self.room:send("You panic, but you can not escape!")
    wait(1)
    self.room:send("<b:cyan>The statue shouts 'I will free you my master!'</>")
    wait(0.4)
    self.room:send("<b:yellow>The statue starts casting a spell...</>")
    wait(3)
    self.room:send("<b:yellow>The statue's molecules loosen and eventually compress into a ball of light!</>")
    wait(0.4)
    self.room:send("<b:cyan>The ball disappears like</> <b:blue>lightning</> <b:cyan>with a loud crackle of energy!</>")
    wait(0.4)
    self.room:send("A small stone dagger falls from its place, a gift for freedom.")
    run_room_trigger(51, 1)
    world.destroy(self.room:find_actor("stone-ring"))
    world.destroy(self.room:find_actor("statue"))
    return false
end
self.room:send_except(actor, actor.name .. " offers " .. object.shortdesc .. " to " .. self.name .. ".")
self.room:send_except(actor, self.name .. " does not stir.")
actor:send("You offer up " .. object.shortdesc .. " to " .. self.name .. ", but there is no reaction.")
return false  -- legacy return 0: the giver keeps the item$trig$, '12e00d6527b52b8cc05a30e149a46b16'),
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

local dg = require("dg")
if dg.gone(object) then return true end  -- an earlier receive trigger already took it
local wand_quest = (globals.type or "type") .. "_wand"
local stage_subclass = actor:get_quest_stage("pyromancer_subclass") or 0
local response
if stage_subclass > 0 and stage_subclass <= 4 then
    response = "I asked you to bring me the " .. tostring(actor:get_quest_var("pyromancer_subclass:part")) .. " flame, not this nonsense."
elseif globals.wandstep and actor:get_quest_stage(wand_quest) == globals.wandstep then
    response = "I can't craft with this!"
elseif (actor:get_quest_stage("emmath_flameball") or 0) > 1 then
    response = "You're supposed to be out collecting flames, not whatever this is."
else
    response = "Why are you bringing me this trash?"
end

self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
actor:send(tostring(self.name) .. " says, '" .. tostring(response) .. "'")
return false  -- legacy return 0: the giver keeps the item$trig$, '71877de7ab1415da2c70123efd022632'),
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
-- The give command takes one word for the item and has no "give all", so items go over one by
-- one through dg.give, by their first keyword.
local dg = require("dg")
-- 
-- This is the main receive trigger for the Edorian
-- combat quests installed on the mud. This trigger
-- will be generic and the IDs and variables set
-- to reflect which faction it applies to.
-- 
-- 3bl is Third Black Legion - The player MUST be
-- on the quest already in order to turn in because
-- the variables are not set yet!
if actor:get_quest_var("black_legion:eg_ally") then
    actor:send(tostring(self.name) .. " tells you, 'You have already chosen your side!")
    actor:send("</>Be gone, filth!'")
    return _return_value
end
if actor.alignment <= 150 and actor:get_quest_stage("black_legion") > 0 then
    actor:set_quest_var("black_legion", "bl_ally", 1)
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
        self:command("eye " .. tostring(actor.name))
        actor:send(tostring(self.name) .. " tells you, 'I am not interested in this from you.'")
        actor:send(tostring(self.name) .. " returns your item to you.")
        return false  -- legacy return 0: the giver keeps the item
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
                self:command("eye " .. tostring(actor.name))
                actor:send(tostring(self.name) .. " tells you, 'You have garnered as much favor with")
                actor:send("</>the Black Legion as you possibly can by fighting the Third Eldrian Guard.  You")
                actor:send("</>may one day find other more difficult battles with those tree rats that will")
                actor:send("</>curry more favor with our lords.'")
                return false  -- legacy return 0: the giver keeps the item
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
            actor:send(tostring(self.name) .. " tells you, 'You aren't quite evil enough for")
            actor:send("</>these rewards.'")
            return false  -- legacy return 0: the giver keeps the item
        end
        if (actor:get_quest_var("black_legion:bl_faction") or 0) >= faction_required then
            local rewards = (actor:get_quest_var("black_legion:" .. tostring(id_reward) .. "_reward") or 0) + 1
            actor:set_quest_var("black_legion", tostring(id_reward) .. "_reward", rewards)
            wait(0.2)
            actor:send(tostring(self.name) .. " tells you, 'Ah yes, the Legion thanks you for")
            actor:send("</>your efforts.  Take this to aid you in your battles.'")
            wait(0.1)
            local reward_item = self:spawn_object(proto_key(id_reward))
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
            dg.give(self, reward_item, actor)
            actor:save()
        else
            actor:send(tostring(self.name) .. " tells you, 'You aren't quite allied enough")
            actor:send("</>with our cause to earn that reward.'")
            return false  -- legacy return 0: the giver keeps the item
        end
        -- end of if_gem section
    end
else
    -- Alignment not low enough or hasn't started the quest yet.
    actor:send(tostring(self.name) .. " tells you, 'You aren't quite allied enough with")
    actor:send("</>our cause to earn our rewards.  You need a lower alignment or to start these")
    actor:send("</>quests by saying <b:white>[yes]</> or <b:white>[quest]</> or <b:white>[hello]</>.'")
    return false  -- legacy return 0: the giver keeps the item
end
return _return_value$trig$, '52390dc52c722f1abbc0507ade393bad'),
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
-- The give command takes one word for the item and has no "give all", so items go over one by
-- one through dg.give, by their first keyword.
local dg = require("dg")
-- 
-- This is the main receive trigger for the Edorian
-- combat quests installed on the mud. This trigger
-- will be generic and the IDs and variables set
-- to reflect which faction it applies to.
-- 
-- 3eg is Third Eldorian Guard
if actor:get_quest_var("black_legion:bl_ally") then
    actor:send(tostring(self.name) .. " tells you, 'You have pledged")
    actor:send("</>yourself to the forces of darkness!  Suffer under your choice!'")
    return _return_value
end
if actor.alignment >= -150 and actor:get_quest_stage("black_legion") > 0 then
    actor:set_quest_var("black_legion", "eg_ally", 1)
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
        self:command("eye " .. tostring(actor.name))
        actor:send(tostring(self.name) .. " tells you, 'I am not interested in this from you.'")
        actor:send(tostring(self.name) .. " returns your item to you.")
        return false  -- legacy return 0: the giver keeps the item
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
                self:command("eye " .. tostring(actor.name))
                actor:send(tostring(self.name) .. " tells you, 'You have garnered as")
                actor:send("</>much favor with the Eldorian Guard as you possibly can by fighting the Third")
                actor:send("</>Black Legion.  You may one day find other more difficult battles with those")
                actor:send("</>tree rats that will curry more favor with our masters.'")
                return false  -- legacy return 0: the giver keeps the item
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
            actor:send(tostring(self.name) .. " tells you, 'You aren't quite good")
            actor:send("</>enough for these rewards.'")
            return false  -- legacy return 0: the giver keeps the item
        end
        if (actor:get_quest_var("black_legion:eg_faction") or 0) >= faction_required then
            local rewards = (actor:get_quest_var("black_legion:" .. tostring(id_reward) .. "_reward") or 0) + 1
            actor:set_quest_var("black_legion", tostring(id_reward) .. "_reward", rewards)
            wait(0.2)
            actor:send(tostring(self.name) .. " tells you, 'Ah yes, the Guard")
            actor:send("</>thanks you for your efforts.  Take this to aid you in your battles.'")
            wait(0.1)
            local reward_item = self:spawn_object(proto_key(id_reward))
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
            dg.give(self, reward_item, actor)
            actor:save()
        else
            actor:send(tostring(self.name) .. " tells you, 'You aren't quite allied")
            actor:send("</>enough with our cause to earn that reward.'")
            return false  -- legacy return 0: the giver keeps the item
        end
        -- end of if_gem section
    end
else
    -- Alignment not high enough or hasn't started the quest yet.
    actor:send(tostring(self.name) .. " tells you, 'You aren't quite allied")
    actor:send("</>enough with our cause to earn our rewards.  You need a higher alignment or to")
    actor:send("</>start these quests by saying <b:white>[yes]</> or <b:white>[quest]</> or <b:white>[hello]</>.'")
    return false  -- legacy return 0: the giver keeps the item
end
return _return_value$trig$, '2156673e1d42ce80f2d0bf4c07a0f6f2'),
  -- data/triggers/085/085_26_ziijhan_general_receive.lua
  (85, 26, $trig$local dg = require("dg")
if dg.gone(object) then return true end  -- an earlier receive trigger already took it
if object.zone_id == 85 and object.id == 4 then
    return true
end
if dg.quest_item(object, globals) then
    return true
end
actor:send(tostring(self.name) .. " scoffs at " .. tostring(object.shortdesc) .. ".")
actor:send(tostring(self.name) .. " says, 'What is this garbage?'")
return false  -- legacy return 0: the giver keeps the item$trig$, '403d384948f9f6c1dda6ac3e05c9ad99'),
  -- data/triggers/103/103_25_khysan_refuse.lua
  (103, 25, $trig$local dg = require("dg")
if dg.gone(object) then return true end  -- an earlier receive trigger already took it
-- The wand and mace items this crafter exports through `globals` (002_111 / 002_118) belong to
-- the receive triggers 002_108 / 002_126; everything else is turned away below.
if dg.quest_item(object, globals) then
    return true
end

local function is_obj(z, i)
    return object.zone_id == z and object.local_id == i
end

local stage = actor:get_quest_stage("ice_shards")
local response

if stage == 1 then
    -- Books: 16209 (162, 9), 18505 (185, 5), 55003 (550, 3),
    -- 58415 (584, 15)
    if is_obj(162, 9) or is_obj(185, 5) or is_obj(550, 3) or is_obj(584, 15) then
        return true
    end
    response = "This isn't one of the four books I need to consult."
elseif stage == 2 then
    -- 55004 → (550, 4)
    if is_obj(550, 4) then
        return true
    end
    response = "This isn't the Codex of War."
elseif stage == 3 then
    -- 58806 → (588, 6)
    if is_obj(588, 6) then
        return true
    end
    response = "This isn't Commander Thraja's journal..."
elseif stage == 6 then
    -- 48502 → (485, 2)
    if is_obj(485, 2) then
        return true
    end
    response = "Weird, this doesn't look like a map of Ickle."
elseif stage == 7 then
    -- 53423 → (534, 23)
    if is_obj(534, 23) then
        return true
    end
    response = "Do you think we can get new information from " .. tostring(object.shortdesc) .. "?  I doubt it..."
elseif stage == 8 then
    -- 43013 → (430, 13)
    if is_obj(430, 13) then
        return true
    end
    response = "Is this a book?"
elseif stage == 10 then
    -- 10325 → (103, 25)
    if is_obj(103, 25) then
        return true
    end
    response = "Is this all you could find?"
else
    response = "Oh, is this a gift for me?  I appreciate it, but I'm fine for now."
end

self.room:send(self.name .. " refuses " .. tostring(object.shortdesc) .. ".")
self:say(response)
return false  -- legacy return 0: the giver keeps the item$trig$, '0893eecd040f06c672505590d07e1736'),
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
if self.room == 12015 then
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

-- This tree already satisfied: refuse.
if (actor:get_quest_var("twisted_sorrow:satisfied_tree:" .. tostring(self.room)) or 0) == 1 then
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
if self.room == 12016 and object.val2 == 11 then            -- Tree of Luck: tea
    success = true
elseif self.room == 12017 and object.val2 > 0 and object.val2 < 5 then  -- Reverence: alcohol
    success = true
elseif self.room == 12018 and object.val2 == 0 then          -- Self-reliance: water
    success = true
elseif self.room == 12014 and object.val2 == 12 then         -- Nimbleness: coffee
    success = true
elseif self.room == 12046 and object.val2 == 10 then         -- Kindness: milk
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
actor:set_quest_var("twisted_sorrow", "satisfied_tree:" .. tostring(self.room), 1)
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

return false$trig$, '31c45fe4b2a222ec2fc3a380d38eb220'),
  -- data/triggers/123/123_06_megalith_quest_priestess_receive.lua
  (123, 6, $trig$-- Converted from DG Script #12306: megalith_quest_priestess_receive
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
-- This trigger serves as the basis for the returning of items to the high priestess and advancing stages 1 and 3.
-- It is heavily copied from the Hot Springs quests.
-- Several of the stages have multiple items the questor could return.
-- Some can result in the quest variables [bad1-3] being placed on the character.
-- Ideally, there will be 0 [bad]
-- If there are 2 [bad] or more at the end, the final step of the quest will fail.
-- If bad4 is on, DISASTER will occur!!
-- There is currently no option to exchange items once they have been delivered
--
-- TODO(parity): legacy obj IDs (23756, 41111, etc.) are still bare 5-digit
-- vnums. They need to be split to (zone, local_id) once the canonical
-- mapping for these objects is settled. Same for the goblet variable
-- stored in the quest var.

-- Hoisted locals (these were branch-scoped in the converter output, which
-- broke their use after the if/elseif chain).
local item
local this
local goblet
local step

-- What item is being turned in?
if actor:get_quest_stage("megalith_quest") == 1 then
    step = "replace our ritual implements"
    -- Set the potential items that could be turned in in Stage 1.
    -- The same item-slot is set by multiple object IDs because multiple
    -- objects could satisfy the requirement, but we only want to accept one.
    -- Also remember the goblet ID so we can return the cup in stage 3.
    -- salt
    if (object.zone_id == 237 and object.id == 56) then
        item = 1
        this = object.shortdesc
    -- hemlock goblet - BAD1
    elseif (object.zone_id == 411 and object.id == 11) then
        item = 2
        goblet = 41111
        this = "a drinking vessel"
    -- rowan goblet
    elseif (object.zone_id == 411 and object.id == 10) then
        this = "a drinking vessel"
        item = 2
        goblet = 41110
    -- chalice
    elseif (object.zone_id == 185 and object.id == 12) then
        item = 2
        goblet = 18512
        this = "a drinking vessel"
    -- censer
    elseif (object.zone_id == 85 and object.id == 7) then
        item = 3
        this = "an incense burner"
    -- thurible
    elseif (object.zone_id == 173 and object.id == 0) then
        item = 3
        this = "an incense burner"
    -- candle
    elseif (object.zone_id == 86 and object.id == 12) then
        item = 4
        this = "spare candles"
    -- candle
    elseif (object.zone_id == 588 and object.id == 9) then
        item = 4
        this = "spare candles"
    else
        return _return_value
    end
elseif actor:get_quest_stage("megalith_quest") == 3 then
    step = "summon " .. tostring(mobiles.template(123, 0).name)
    -- Set the potential items that could be returned in Stage 3
    -- bowl
    if (object.zone_id == 238 and object.id == 17) then
        item = 1
        this = object.shortdesc
    -- goddess skirt - BAD3
    elseif (object.zone_id == 43 and object.id == 5) then
        item = 2
        this = "something from a goddess's regalia"
    -- goddess torch - ALSO BAD3
    elseif (object.zone_id == 43 and object.id == 18) then
        item = 2
        this = "something from a goddess's regalia"
    -- goddess bracelet
    elseif (object.zone_id == 580 and object.id == 15) then
        item = 2
        this = "something from a goddess's regalia"
    -- goddess ring
    elseif (object.zone_id == 580 and object.id == 18) then
        item = 2
        this = "something from a goddess's regalia"
    -- faerie elixir - BAD4 - THE REALLY BAD ONE
    elseif (object.zone_id == 584 and object.id == 26) then
        this = "something to serve as Her icon"
        item = 3
    -- faerie wings
    elseif (object.zone_id == 584 and object.id == 18) then
        item = 3
        this = "something to serve as Her icon"
    else
        return _return_value
    end
else
    return _return_value
end

-- if you already gave us this item.
local item_key = "item" .. tostring(item)
if (actor:get_quest_var("megalith_quest:" .. item_key) or 0) == 1 then
    self.room:send(tostring(self.name) .. " says, 'Thank you, but you already brought me " .. tostring(this) .. ".'")
    return false  -- legacy return 0: the giver keeps the item
end

-- Accept the item.
wait(0.2)
self.room:send(tostring(self.name) .. " says, 'Blessed be!  Just what we need to " .. tostring(step) .. "!'")
actor:set_quest_var("megalith_quest", item_key, 1)
if (object.zone_id == 411 and object.id == 10) or (object.zone_id == 185 and object.id == 12) or (object.zone_id == 411 and object.id == 11) then
    actor:set_quest_var("megalith_quest", "goblet", goblet)
    if (object.zone_id == 411 and object.id == 11) then
        actor:set_quest_var("megalith_quest", "bad1", 1)
    end
elseif (object.zone_id == 43 and object.id == 18) or (object.zone_id == 43 and object.id == 5) then
    actor:set_quest_var("megalith_quest", "bad3", 1)
elseif (object.zone_id == 584 and object.id == 26) then
    actor:set_quest_var("megalith_quest", "bad4", 1)
end
world.destroy(object)

-- See if we've turned in everything for this step.
local item1 = (actor:get_quest_var("megalith_quest:item1") or 0) == 1 and 1 or nil
local item2 = (actor:get_quest_var("megalith_quest:item2") or 0) == 1 and 1 or nil
local item3 = (actor:get_quest_var("megalith_quest:item3") or 0) == 1 and 1 or nil
-- item4 doesn't exist for stage 3, so treat that as satisfied there.
local item4
if (actor:get_quest_stage("megalith_quest") ~= 1) or (actor:get_quest_var("megalith_quest:item4") or 0) == 1 then
    item4 = 1
end

if item1 and item2 and item3 and item4 then
    wait(0.2)
    actor:advance_quest("megalith_quest")
    -- Reset item variables (5 slots; only 4 are checked, but clear all to be safe).
    for slot = 1, 5 do
        actor:set_quest_var("megalith_quest", "item" .. tostring(slot), 0)
    end
    wait(1)
    self:say("I believe we're ready to proceed!")
    wait(1)
    -- If turning everything in starts stage 2
    if actor:get_quest_stage("megalith_quest") == 2 then
        self:emote("carefully places each tool in its proper position on the altar.")
        wait(2)
        self.room:send(tostring(self.name) .. " proclaims, 'Rejoice!  The Great Work begins!'")
        self:emote("lights the candle.")
        self.room:send(tostring(self.name) .. " lifts her arms and turns her face skyward.")
        self.room:send(tostring(self.name) .. " chants:")
        self.room:send("'O spirits of the ancient deep,")
        self.room:send("</>protect us as we undertake our magical working.'")
        wait(6)
        actor:send(tostring(self.name) .. " slowly fixes her gaze on you.")
        self.room:send_except(actor, tostring(self.name) .. " slowly fixes her gaze on " .. tostring(actor.name) .. ".")
        wait(1)
        self.room:send(tostring(self.name) .. " says, 'Next you'll work with the <b:white>Keepers</> to call the elements to protect us and awaken the sleeping land.  You can find them preparing the four enormous menhirs in the forest.  Please check in with them to see what resources they need.'")
        wait(2)
        self:say("Oh wait, I almost forgot!")
        wait(2)
        -- Return the same drinking vessel from Stage 1.
        -- TODO(parity): goblet IDs are still legacy 5-digit vnums. Once
        -- those are split into (zone, local_id), spawn from the catalog
        -- rather than this floor-divide hack.
        local saved_goblet = actor:get_quest_var("megalith_quest:goblet")
        if saved_goblet and saved_goblet ~= 0 then
            self.room:spawn_object(math.floor((saved_goblet or 0) / 100), (saved_goblet or 0) % 100)
            local goblet_name = objects.template(math.floor((saved_goblet or 0) / 100), (saved_goblet or 0) % 100)
            goblet_name = goblet_name and goblet_name.name or "the goblet"
            self.room:send("The coven high priestess takes " .. tostring(goblet_name) .. " from the altar.")
            self:command("pour goblet out")
            self:command("give goblet " .. tostring(actor.name))
            self.room:send(tostring(self.name) .. " says, 'You'll need this vessel again.  I've consecrated it for use in the Great Rite.'")
        end
        wait(3)
        self:say("Now, go seek out the Keepers!")
    -- If turning everything in starts stage 4
    elseif actor:get_quest_stage("megalith_quest") == 4 then
        actor:set_quest_var("megalith_quest", "reliquary", 1)
        self:emote("reverentially places each of the reliquaries on the altar.")
        wait(0.2)
        self:emote("whispers,")
        self.room:send("'By the power of three times three,")
        self.room:send("</>As I will it, so shall it be.'")
        wait(4)
        self:emote("breathes deeply and flexes her hands.")
        wait(3)
        self:say("It's time.")
        wait(2)
        self:emote("says in a hushed but excited tone, 'Are you ready?'")
    end
else
    -- We need more stuff.
    wait(0.2)
    self:say("If you have the other necessaries, please give them to me.")
end
return _return_value$trig$, 'bbee796255a1dc368b85739c3f6f5af0'),
  -- data/triggers/123/123_42_keeper_refuse.lua
  (123, 42, $trig$-- Converted from DG Script #12342: Keeper refuse
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
--
-- The keepers are 123:3-123:6 (legacy 12303-12306); the `need` ids (55020, 48109, 8301) are legacy
-- vnums read through dg.oname. Every refusal hands the item back, the way legacy `return 0` did.
local dg = require("dg")
if dg.gone(object) then return true end  -- an earlier receive trigger already took it
-- The wand and mace items this crafter exports through `globals` (002_111 / 002_118) belong to
-- the receive triggers 002_108 / 002_126; everything else is turned away below.
if dg.quest_item(object, globals) then
    return true
end

-- Hoisted from branch-scoped locals in the converter output.
local direction
local part
local need

if (self.zone_id == 123 and self.id == 3) then
    direction = "north"
    part = 4
    need = 55020
elseif (self.zone_id == 123 and self.id == 4) then
    direction = "south"
    part = 2
    need = 48109
elseif (self.zone_id == 123 and self.id == 5) then
    direction = "east"
    part = 1
    need = 8301
elseif (self.zone_id == 123 and self.id == 6) then
    direction = "west"
    part = 3
    need = actor:get_quest_var("megalith_quest:goblet")
end

local function need_name()
    if not need then return "the offering" end
    return dg.oname(need)
end

if actor:get_quest_stage("megalith_quest") < 2 then
    self:command("shake")
    self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
    self:say("I'm sorry, I'm quite busy right now.")
    return false  -- legacy return 0: the giver keeps the item
elseif actor:get_quest_stage("megalith_quest") > 2 or (actor:get_quest_stage("megalith_quest") == 2 and (actor:get_quest_var("megalith_quest:item" .. tostring(part)) or 0) == 1) then
    self:command("shake")
    self:say("I don't need any additional assistance at the moment, thank you.")
    if (self.zone_id == 123 and self.id == 6) then
        self:command("curtsy " .. tostring(actor.name))
    else
        self:command("bow " .. tostring(actor.name))
    end
    return false  -- legacy return 0: the giver keeps the item
elseif actor:get_quest_stage("megalith_quest") == 2 then
    if direction and ((actor:get_quest_var("megalith_quest:" .. direction) or 0) == 0) and (not actor:get_quest_var("megalith_quest:item" .. tostring(part))) then
        if (self.zone_id == 123 and self.id == 3) then
            self:command("eye " .. tostring(actor.name))
            self:say("I haven't yet told you what I need.")
        elseif (self.zone_id == 123 and self.id == 4) then
            self:command("sigh")
            self:say("You have yet to receive instructions.  A little patience, please!")
        elseif (self.zone_id == 123 and self.id == 5) then
            self:emote("yelps in surprise.")
            self:say("Did Umberto tell you what I need already?!")
        elseif (self.zone_id == 123 and self.id == 6) then
            self:emote("looks confused.")
            self:say("I have yet to tell you what I need.")
        end
        return false  -- legacy return 0: the giver keeps the item
    else
        if ((self.zone_id == 123 and self.id == 3) and (object.zone_id == 550 and object.id == 20)) or ((self.zone_id == 123 and self.id == 4) and (object.zone_id == 481 and object.id == 9)) or ((self.zone_id == 123 and self.id == 5) and (object.zone_id == 83 and object.id == 1)) or ((self.zone_id == 123 and self.id == 6) and ((object.zone_id == 411 and object.id == 10) or (object.zone_id == 411 and object.id == 11) or (object.zone_id == 185 and object.id == 12))) then
            return _return_value
        else
            self:command("shake")
            self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
            if (self.zone_id == 123 and self.id == 6) then
                self:say("Unfortunately, I need " .. need_name() .. " filled with water, not this.")
            else
                self:say("Unfortunately, I need " .. need_name() .. ", not this.")
            end
            return false  -- legacy return 0: the giver keeps the item
        end
    end
end
return _return_value$trig$, 'c7978a5864e1a0c55edfb3feb471c70a'),
  -- data/triggers/163/163_10_eleweiss_refuse.lua
  (163, 10, $trig$local dg = require("dg")
if dg.gone(object) then return true end  -- an earlier receive trigger already took it
if object.zone_id == 172 and object.id == 12 then
    return true
end
if dg.quest_item(object, globals) then
    return true
end
actor:send(tostring(self.name) .. " says, 'What is this?'")
actor:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
actor:send(tostring(self.name) .. " says, 'I have no need of " .. tostring(object.shortdesc) .. ".'")
return false  -- legacy return 0: the giver keeps the item$trig$, 'ef77824f2057b3b3000f447fb7fa293d'),
  -- data/triggers/185/185_29_sexton_refuse.lua
  (185, 29, $trig$local dg = require("dg")
if dg.gone(object) then return true end  -- an earlier receive trigger already took it
if dg.quest_item(object, globals) then
    return true
end
actor:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
actor:send(tostring(self.name) .. " says, 'I'm sorry, what is this for?'")
return false  -- legacy return 0: the giver keeps the item$trig$, 'fe2593cdaad9fd938c19895f56d4bf31'),
  -- data/triggers/185/185_31_silania_refuse.lua
  (185, 31, $trig$local dg = require("dg")
if dg.gone(object) then return true end  -- an earlier receive trigger already took it
if object.zone_id == 185 and object.id == 12 then
    return true
end
if dg.quest_item(object, globals) then
    return true
end
actor:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
actor:send(tostring(self.name) .. " says, 'What is this for?'")
return false  -- legacy return 0: the giver keeps the item$trig$, '2f1d5e66782f1e04682daeb05f4d4b9d'),
  -- data/triggers/238/238_08_mage_receive_refuse.lua
  (238, 8, $trig$local dg = require("dg")
if dg.gone(object) then return true end  -- an earlier receive trigger already took it
if object.zone_id == 238 and object.id == 22 then
    return true
end
if dg.quest_item(object, globals) then
    return true
end
self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
actor:send(tostring(self.name) .. " says, 'What is this for?'")
return false  -- legacy return 0: the giver keeps the item$trig$, '23a31cb5768366d56b5f46eb5072be94'),
  -- data/triggers/300/300_07_receive_enemy_communication.lua
  (300, 7, $trig$-- Converted from DG Script #30007: receive enemy communication
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
-- Branch on the (zone_id, local_id) of the offered item.
-- 302:12 = enemy/orc message scroll (player is acting as a spy for the orcs)
-- 302:8  = paladin message parchment (player is foolishly handing in evidence
--          against themselves; general attacks and kicks them through a door)
if object.zone_id == 302 and object.local_id == 12 then
    wait(0.4)
    self:destroy_item("scroll")
    self:say("Why thank you... good spy.  I'll have my warlocks extract this message,")
    self:say("and find out what those self-righteous paladins are up to.")
    wait(2)
    self:say("Here is something for your trouble.")
    -- Reward: two random gems from the 555:81-555:89 range
    self.room:spawn_object(555, 81 + random(1, 8))
    self.room:spawn_object(555, 81 + random(1, 8))
    self:command("give all.gem " .. tostring(actor.name))
    return false
elseif object.zone_id == 302 and object.local_id == 8 then
    wait(0.3)
    self:destroy_item("parchment")
    self:command("growl")
    wait(2)
    self:say("What are you doing with this!  You spy!  Paladin!  GUARDS!")
    wait(1)
    self:command("open door")
    wait(0.4)
    local damage = actor.level * 2 + 5
    local damage_dealt = actor:damage(damage)  -- crush
    if damage_dealt == 0 then
        self.room:send_except(actor, tostring(self.name) .. " tries to kick " .. tostring(actor.name) .. ", but is having trouble with " .. tostring(self.possessive) .. " foot!")
        actor:send(tostring(self.name) .. " tries to kick you, but is having trouble with " .. tostring(self.possessive) .. " foot!")
    else
        self.room:send_except(actor, tostring(self.name) .. " kicks " .. tostring(actor.name) .. " solidly in the head! (<red>" .. tostring(damage_dealt) .. "</>)")
        actor:send(tostring(self.name) .. " kicks you solidly in the head! (<red>" .. tostring(damage_dealt) .. "</>)")
        self.room:send_except(actor, tostring(actor.name) .. " is sent reeling through the doorway!")
        actor:send("You topple through the door into the next room!")
        wait(0.3)
        actor:teleport(get_room(300, 38))
    end
    return false
else
    self.room:send_except(actor, tostring(actor.name) .. " tries to give " .. tostring(object.shortdesc) .. " to " .. tostring(self.name) .. ".")
    actor:send("You try to give " .. tostring(object.shortdesc) .. " to " .. tostring(self.name) .. ", but " .. tostring(self.name) .. " refuses.")
    self:say("I don't need your rubbish!  Show some respect, dog!")
    return false  -- legacy return 0: the giver keeps the item
end$trig$, 'c05834c1e79e762c764e96187948a3de'),
  -- data/triggers/370/370_18_mes-rec.lua
  (370, 18, $trig$-- Quest ingredient table: object zone/id -> quest_var key.
local TROLL_INGREDIENTS = {
    [80] = "got_item:37080",
    [81] = "got_item:37081",
    [82] = "got_item:37082",
}

local function is_troll_ingredient(obj)
    return obj.zone_id == 370 and TROLL_INGREDIENTS[obj.id] ~= nil
end

local function ingredient_key(obj)
    return TROLL_INGREDIENTS[obj.id]
end

if string.find(actor.race, "troll") then
    local gooditem = false
    local gotitem = false
    if is_troll_ingredient(object) then
        gooditem = true
        local key = ingredient_key(object)
        if (actor:get_quest_var("troll_quest:" .. key) or 0) ~= 1 then
            gotitem = true
            actor:set_quest_var("troll_quest", key, 1)
        end
    end

    -- Have we collected everything?
    local have_all =
        (actor:get_quest_var("troll_quest:got_item:37080") or 0) == 1
        and (actor:get_quest_var("troll_quest:got_item:37081") or 0) == 1
        and (actor:get_quest_var("troll_quest:got_item:37082") or 0) == 1

    if have_all and not actor:get_has_completed("troll_quest") then
        self.room:send(tostring(self.name) .. " smiles broadly as he looks at the gathered ingredients.")
        self:say("Yes, these will do quite nicely indeed.  Excellent work.")
        wait(2)
        self.room:send(tostring(self.name) .. " opens the seal on the vial of dye and a sweet scent fills the  room.")
        self.room:send("Taking the vial on one hand, he slowly pours it over the mangrove branch, creating a slight hissing noise and a black, oily-smelling smoke.")
        wait(1)
        self.room:send(tostring(self.name) .. " places the hunk of malachite amidst the smoking concoction and waves his hands over it, muttering a strange mantra.")
        self.room:send("A red light erupts from the center of the branch, nearly blinding you!")
        wait(2)
        self.room:send("When the smoke clears and the light is gone, " .. tostring(self.name) .. " smiles proudly.")
        actor:complete_quest("troll_quest")
        self:say("Here you go, little one.  May your ambitions guide you and lead you to prosperity and rulership.")
        self.room:spawn_object(370, 83)
        self:command("give troll-mask " .. tostring(actor.name))
        self:command("bow " .. tostring(actor.name))
        wait(0.1)
        self:say("I am certain we shall meet again.")
    elseif actor:get_has_completed("troll_quest") then
        self:say("You have already helped me once, please let others help me now.")
        return false  -- legacy return 0: the giver keeps the item
    elseif gotitem then
        wait(3)
        self:say("Why thank you.  Run along now.")
        world.destroy(object)
    elseif gooditem then
        self:say("I'm sorry but you already gave me this item.")
        return false  -- legacy return 0: the giver keeps the item
    else
        self:say("What is this? I can not use this.")
        return false  -- legacy return 0: the giver keeps the item
    end
else
    -- Non-troll path: the fire ruby (125,26) gives an XP + gem reward.
    if object.zone_id == 125 and object.id == 26 then
        wait(3)
        self:destroy_item("gem")
        self:command("blink")
        self:say("How did you know I needed this?!")
        wait(2)
        self.room:send(tostring(self.name) .. " quickly pockets the ruby.")
        self:say("Here, my thanks.")
        for _ = 1, 10 do
            actor:award_exp(10000)
        end
        -- Three random gems from the (557, 37..47) range.
        for _ = 1, 3 do
            self.room:spawn_object(557, 36 + random(1, 11))
        end
        self:command("give all.gem " .. tostring(actor.name))
        self:say("Here is a small token of my appreciation.")
        self:say("Now move along.")
    else
        self:say("What is this? I can not use this.")
        return false  -- legacy return 0: the giver keeps the item
    end
end
return true$trig$, '1e4df801be65ed04149efda84bde0a63'),
  -- data/triggers/481/481_149_mccabe_refuse.lua
  (481, 149, $trig$local dg = require("dg")
if dg.gone(object) then return true end  -- an earlier receive trigger already took it
if (object.zone_id == 481 and object.id == 152) or (object.zone_id == 481 and object.id == 151) then
    return true
end
if dg.quest_item(object, globals) then
    return true
end
self:command("eye")
actor:send(tostring(self.name) .. " tells you, 'And what exactly am I supposed to do with this?'")
return false  -- legacy return 0: the giver keeps the item$trig$, '6caf8d6c2c5939390262de6718891ca5'),
  -- data/triggers/484/484_27_oracle_sun_refuse.lua
  (484, 27, $trig$local dg = require("dg")
if dg.gone(object) then return true end  -- an earlier receive trigger already took it
if dg.quest_item(object, globals) then
    return true
end
self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
actor:send(tostring(self.name) .. " says, 'I have no need of this.'")
return false  -- legacy return 0: the giver keeps the item$trig$, 'db44c2277c9b2927fc8d00cdeac93e5b'),
  -- data/triggers/490/490_22_seer_refuse.lua
  (490, 22, $trig$-- Converted from DG Script #49022: Seer refuse
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
-- The wand-quest items (wandgem, wandtask3, wandtask4, wand_id, exported through `globals` by
-- 002_111) fall through to 002_108. The wizard_eye ingredients (2329, 23753, 48005 = 23:29,
-- 237:53, 480:5) are accepted at stage 4. A turned-away item is handed back.
local dg = require("dg")
if dg.gone(object) then return true end  -- an earlier receive trigger already took it
if dg.quest_item(object, globals) then
    return true
end
if actor:get_quest_stage("wizard_eye") == 4 and (
        (object.zone_id == 23 and object.id == 29) or (object.zone_id == 237 and object.id == 53)
        or (object.zone_id == 480 and object.id == 5)) then
    return true
end
local _return_value = true  -- Default: allow action
local response, action
if actor:get_quest_stage("wizard_eye") == 4 then
    response = "This isn't a dress, bay, or thyme!  I don't have thyme for this!"
    action = "cackle"
else
    response = "This isn't sunscreen, what use do I have for it?"
end
if response then
    self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
    actor:send(tostring(self.name) .. " says, '" .. tostring(response) .. "'")
    if action then
        self:command(action)
    end
    return false  -- legacy return 0: the giver keeps the item
end
return _return_value$trig$, '323140c2043d179826b1365bb6781953'),
  -- data/triggers/533/533_14_sculptor_refuse.lua
  (533, 14, $trig$local dg = require("dg")
if dg.gone(object) then return true end  -- an earlier receive trigger already took it
if object.zone_id == 533 and object.id == 27 then
    return true
end
if dg.quest_item(object, globals) then
    return true
end

local wand_quest = (globals.type or "type") .. "_wand"
local on_wand = globals.wandstep ~= nil and actor:get_quest_stage(wand_quest) == globals.wandstep
local on_wall = actor:get_quest_stage("wall_ice") > 0
local response
if on_wall and on_wand then
    response = "This won't help us build this wall and I can't craft with it."
elseif on_wand then
    response = "I can't craft with this."
elseif on_wall then
    response = "This won't help us build this wall."
else
    response = "What is this for?"
end

self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
self:say(response)
return false  -- legacy return 0: the giver keeps the item$trig$, '6d10fcc5acdcdd2d87045239b3bb4d65'),
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
local dg = require("dg")
if dg.gone(object) then return true end  -- an earlier receive trigger already took it
if dg.quest_item(object, globals) then
    return true
end
local stage = actor:get_quest_stage("wizard_eye")
if (stage == 2 and object.zone_id == 586 and object.id == 9)
    or (stage == 5 and object.zone_id == 550 and object.id == 30)
    or (stage == 8 and object.zone_id == 550 and object.id == 32)
    or (stage == 11 and object.zone_id == 550 and object.id == 33) then
    return true
end
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
return false  -- legacy return 0: the giver keeps the item$trig$, 'e0b7673fae18fdca0aef68cdc5e6a77c'),
  -- data/triggers/553/553_01_cleric_phase_1.lua
  (553, 1, $trig$-- Converted from DG Script #55301: cleric_phase_1
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
--
-- Phase armor turn-in (class and phase specific). Quest vars are keyed by the legacy object
-- vnum, as DG did: phase_armor:<armor vnum>_armor_acquired (1 piece) and
-- phase_armor:<gem vnum>_gems_acquired (3 gems). The zone 556 status scripts read these keys.
-- The runtime fires RECEIVE after the item is already in the mob's hands, so a refusal hands
-- it back with a give command (DG's `return 0`).

local class_ok = false
for _, c in ipairs({"cleric", "priest", "diabolist", "druid"}) do
    if string.lower(actor.class or "") == c then
        class_ok = true
        break
    end
end

local function obj_name(vnum)
    return objects.template(math.floor(vnum / 100), vnum % 100).name
end

-- Item names carry a leading article ("a rusted helm"); give matches on the bare words.
local function bare_name(name)
    return (string.gsub(string.gsub(name, "^%s*[Tt]he%s+", ""), "^%s*[Aa]n?%s+", ""))
end

if not (class_ok and actor:get_quest_stage("phase_armor") >= 1) then
    -- not the right class / phase for this questmaster
    self:command("eye " .. tostring(actor.name))
    actor:send(tostring(self.name) .. " tells you, 'I am not interested in this from you.'")
    return false  -- legacy return 0: the giver keeps the item
end

-- Slots for this class: destroyed armor, gem, reward (legacy 5-digit vnums) and exp multiplier.
local slots = {
    {slot = "helm", armor = 55312, gem = 55578, reward = 55391, mult = 10},
    {slot = "arm", armor = 55316, gem = 55582, reward = 55392, mult = 17},
    {slot = "chest", armor = 55324, gem = 55590, reward = 55393, mult = 29},
    {slot = "legs", armor = 55320, gem = 55586, reward = 55394, mult = 24},
    {slot = "boots", armor = 55304, gem = 55570, reward = 55395, mult = 4},
    {slot = "bracer", armor = 55308, gem = 55574, reward = 55396, mult = 7},
    {slot = "gloves", armor = 55300, gem = 55566, reward = 55397, mult = 2},
}

-- DG switch: an armor case falls through into its gem case, so both vnums map to the same slot.
local object_vnum = object.zone_id * 100 + object.id
local entry, is_armor
for _, s in ipairs(slots) do
    if object_vnum == s.armor then
        entry = s
        is_armor = true
        break
    elseif object_vnum == s.gem then
        entry = s
        is_armor = false
        break
    end
end
if not entry then
    self:command("eye " .. tostring(actor.name))
    actor:send(tostring(self.name) .. " tells you, 'I am not interested in this from you.'")
    return false  -- legacy return 0: the giver keeps the item
end

local armor_key = tostring(entry.armor) .. "_armor_acquired"
local gem_key = tostring(entry.gem) .. "_gems_acquired"
local armor = tonumber(actor:get_quest_var("phase_armor:" .. armor_key)) or 0
local gems = tonumber(actor:get_quest_var("phase_armor:" .. gem_key)) or 0

if is_armor then
    if armor < 1 then
        armor = armor + 1
        actor:set_quest_var("phase_armor", armor_key, armor)
        wait(0.2)
        actor:send(tostring(self.name) .. " tells you, \"Hey now. what have we here?!  I've been looking for some of this\"")
        actor:send(tostring(self.name) .. " tells you, \"for quite some time.  You have now given me " .. obj_name(entry.armor) .. ".\"")
        world.destroy(object)
        actor:save()
    else
        self:command("eye " .. tostring(actor.name))
        actor:send(tostring(self.name) .. " tells you, \"Hey now, you have given me " .. obj_name(entry.armor) .. " already!\"")
        -- Halt here so the reward can't be given twice.
        return false  -- legacy return 0: the giver keeps the item
    end
else
    if gems < 3 then
        gems = gems + 1
        actor:set_quest_var("phase_armor", gem_key, gems)
        wait(0.2)
        actor:send(tostring(self.name) .. " tells you, \"Hey, very nice. It is good to see adventurers out conquering the\"")
        actor:send(tostring(self.name) .. " tells you, \"realm.  You have now given me " .. tostring(gems) .. " " .. obj_name(entry.gem) .. ".\"")
        world.destroy(object)
        actor:save()
    else
        self:command("eye " .. tostring(actor.name))
        actor:send(tostring(self.name) .. " tells you, \"Hey now, you have given me 3 already!\"")
        -- Halt here so the reward can't be given twice.
        return false  -- legacy return 0: the giver keeps the item
    end
end

-- Quest complete for this slot: armor piece plus all 3 gems.
if armor == 1 and gems == 3 then
    wait(0.2)
    actor:send(tostring(self.name) .. " tells you, \"Excellent intrepid adventurer, you have provided me with all\"")
    actor:send(tostring(self.name) .. " tells you, \"I need in order to reward you with " .. obj_name(entry.reward) .. "!\"")
    wait(0.1)
    local reward = self:spawn_object(math.floor(entry.reward / 100), entry.reward % 100)
    wait(0.1)
    actor:send("<b:yellow>You gain experience!</>")
    for _ = 1, entry.mult do
        actor:award_exp(2640)
    end
    if reward then
        self:command("give " .. bare_name(reward.name) .. " to " .. actor.name)
    end
end
return true$trig$, 'a71c0000da6009d84f2a3e0af31fae96'),
  -- data/triggers/553/553_20_warrior_phase_1.lua
  (553, 20, $trig$-- Converted from DG Script #55320: warrior_phase_1
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
--
-- Phase armor turn-in (class and phase specific). Quest vars are keyed by the legacy object
-- vnum, as DG did: phase_armor:<armor vnum>_armor_acquired (1 piece) and
-- phase_armor:<gem vnum>_gems_acquired (3 gems). The zone 556 status scripts read these keys.
-- The runtime fires RECEIVE after the item is already in the mob's hands, so a refusal hands
-- it back with a give command (DG's `return 0`).

local class_ok = false
for _, c in ipairs({"warrior", "paladin", "anti-paladin", "ranger", "monk"}) do
    if string.lower(actor.class or "") == c then
        class_ok = true
        break
    end
end

local function obj_name(vnum)
    return objects.template(math.floor(vnum / 100), vnum % 100).name
end

-- Item names carry a leading article ("a rusted helm"); give matches on the bare words.
local function bare_name(name)
    return (string.gsub(string.gsub(name, "^%s*[Tt]he%s+", ""), "^%s*[Aa]n?%s+", ""))
end

if not (class_ok and actor.level >= 1 and actor:get_quest_stage("phase_armor") >= 1) then
    -- not the right class / phase for this questmaster
    self:command("eye " .. tostring(actor.name))
    actor:send(tostring(self.name) .. " tells you, 'I am not interested in this from you.'")
    return false  -- legacy return 0: the giver keeps the item
end

-- Slots for this class: destroyed armor, gem, reward (legacy 5-digit vnums) and exp multiplier.
local slots = {
    {slot = "helm", armor = 55312, gem = 55581, reward = 55384, mult = 10},
    {slot = "arm", armor = 55316, gem = 55585, reward = 55385, mult = 17},
    {slot = "chest", armor = 55324, gem = 55593, reward = 55386, mult = 29},
    {slot = "legs", armor = 55320, gem = 55589, reward = 55387, mult = 24},
    {slot = "boots", armor = 55304, gem = 55573, reward = 55388, mult = 4},
    {slot = "bracer", armor = 55308, gem = 55577, reward = 55389, mult = 7},
    {slot = "gloves", armor = 55300, gem = 55569, reward = 55390, mult = 2},
}

-- DG switch: an armor case falls through into its gem case, so both vnums map to the same slot.
local object_vnum = object.zone_id * 100 + object.id
local entry, is_armor
for _, s in ipairs(slots) do
    if object_vnum == s.armor then
        entry = s
        is_armor = true
        break
    elseif object_vnum == s.gem then
        entry = s
        is_armor = false
        break
    end
end
if not entry then
    self:command("eye " .. tostring(actor.name))
    actor:send(tostring(self.name) .. " tells you, 'I am not interested in this from you.'")
    return false  -- legacy return 0: the giver keeps the item
end

local armor_key = tostring(entry.armor) .. "_armor_acquired"
local gem_key = tostring(entry.gem) .. "_gems_acquired"
local armor = tonumber(actor:get_quest_var("phase_armor:" .. armor_key)) or 0
local gems = tonumber(actor:get_quest_var("phase_armor:" .. gem_key)) or 0

if is_armor then
    if armor < 1 then
        armor = armor + 1
        actor:set_quest_var("phase_armor", armor_key, armor)
        wait(0.2)
        actor:send(tostring(self.name) .. " tells you, \"Hey now. what have we here?!  I've been looking for some of this\"")
        actor:send(tostring(self.name) .. " tells you, \"for quite some time.  You have now given me " .. obj_name(entry.armor) .. ".\"")
        world.destroy(object)
        actor:save()
    else
        self:command("eye " .. tostring(actor.name))
        actor:send(tostring(self.name) .. " tells you, \"Hey now, you have given me " .. obj_name(entry.armor) .. " already!\"")
        -- Halt here so the reward can't be given twice.
        return false  -- legacy return 0: the giver keeps the item
    end
else
    if gems < 3 then
        gems = gems + 1
        actor:set_quest_var("phase_armor", gem_key, gems)
        wait(0.2)
        actor:send(tostring(self.name) .. " tells you, \"Hey, very nice. It is good to see adventurers out conquering the\"")
        actor:send(tostring(self.name) .. " tells you, \"realm.  You have now given me " .. tostring(gems) .. " " .. obj_name(entry.gem) .. ".\"")
        world.destroy(object)
        actor:save()
    else
        self:command("eye " .. tostring(actor.name))
        actor:send(tostring(self.name) .. " tells you, \"Hey now, you have given me 3 already!\"")
        -- Halt here so the reward can't be given twice.
        return false  -- legacy return 0: the giver keeps the item
    end
end

-- Quest complete for this slot: armor piece plus all 3 gems.
if armor == 1 and gems == 3 then
    wait(0.2)
    actor:send(tostring(self.name) .. " tells you, \"Excellent intrepid adventurer, you have provided me with all\"")
    actor:send(tostring(self.name) .. " tells you, \"I need in order to reward you with " .. obj_name(entry.reward) .. "!\"")
    wait(0.1)
    local reward = self:spawn_object(math.floor(entry.reward / 100), entry.reward % 100)
    wait(0.1)
    actor:send("<b:yellow>You gain experience!</>")
    for _ = 1, entry.mult do
        actor:award_exp(2640)
    end
    if reward then
        self:command("give " .. bare_name(reward.name) .. " to " .. actor.name)
    end
end
return true$trig$, '7bf856c1af7f24e20f4d0e1d10c6ec9d'),
  -- data/triggers/553/553_30_sorcerer_phase_1.lua
  (553, 30, $trig$-- Converted from DG Script #55330: sorcerer_phase_1
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
--
-- Phase armor turn-in (class and phase specific). Quest vars are keyed by the legacy object
-- vnum, as DG did: phase_armor:<armor vnum>_armor_acquired (1 piece) and
-- phase_armor:<gem vnum>_gems_acquired (3 gems). The zone 556 status scripts read these keys.
-- The runtime fires RECEIVE after the item is already in the mob's hands, so a refusal hands
-- it back with a give command (DG's `return 0`).

local class_ok = false
for _, c in ipairs({"sorcerer", "necromancer", "conjurer", "cryomancer", "pyromancer"}) do
    if string.lower(actor.class or "") == c then
        class_ok = true
        break
    end
end

local function obj_name(vnum)
    return objects.template(math.floor(vnum / 100), vnum % 100).name
end

-- Item names carry a leading article ("a rusted helm"); give matches on the bare words.
local function bare_name(name)
    return (string.gsub(string.gsub(name, "^%s*[Tt]he%s+", ""), "^%s*[Aa]n?%s+", ""))
end

if not (class_ok and actor.level >= 1 and actor:get_quest_stage("phase_armor") >= 1) then
    -- not the right class / phase for this questmaster
    self:command("eye " .. tostring(actor.name))
    actor:send(tostring(self.name) .. " tells you, 'I am not interested in this from you.'")
    return false  -- legacy return 0: the giver keeps the item
end

-- Slots for this class: destroyed armor, gem, reward (legacy 5-digit vnums) and exp multiplier.
local slots = {
    {slot = "helm", armor = 55314, gem = 55579, reward = 55398, mult = 10},
    {slot = "arm", armor = 55318, gem = 55583, reward = 55399, mult = 17},
    {slot = "chest", armor = 55326, gem = 55591, reward = 55400, mult = 29},
    {slot = "legs", armor = 55322, gem = 55587, reward = 55401, mult = 24},
    {slot = "boots", armor = 55306, gem = 55571, reward = 55402, mult = 4},
    {slot = "bracer", armor = 55310, gem = 55575, reward = 55403, mult = 7},
    {slot = "gloves", armor = 55302, gem = 55567, reward = 55404, mult = 2},
}

-- DG switch: an armor case falls through into its gem case, so both vnums map to the same slot.
local object_vnum = object.zone_id * 100 + object.id
local entry, is_armor
for _, s in ipairs(slots) do
    if object_vnum == s.armor then
        entry = s
        is_armor = true
        break
    elseif object_vnum == s.gem then
        entry = s
        is_armor = false
        break
    end
end
if not entry then
    self:command("eye " .. tostring(actor.name))
    actor:send(tostring(self.name) .. " tells you, 'I am not interested in this from you.'")
    return false  -- legacy return 0: the giver keeps the item
end

local armor_key = tostring(entry.armor) .. "_armor_acquired"
local gem_key = tostring(entry.gem) .. "_gems_acquired"
local armor = tonumber(actor:get_quest_var("phase_armor:" .. armor_key)) or 0
local gems = tonumber(actor:get_quest_var("phase_armor:" .. gem_key)) or 0

if is_armor then
    if armor < 1 then
        armor = armor + 1
        actor:set_quest_var("phase_armor", armor_key, armor)
        wait(0.2)
        actor:send(tostring(self.name) .. " tells you, \"Hey now. what have we here?!  I've been looking for some of this\"")
        actor:send(tostring(self.name) .. " tells you, \"for quite some time.  You have now given me " .. obj_name(entry.armor) .. ".\"")
        world.destroy(object)
        actor:save()
    else
        self:command("eye " .. tostring(actor.name))
        actor:send(tostring(self.name) .. " tells you, \"Hey now, you have given me " .. obj_name(entry.armor) .. " already!\"")
        -- Halt here so the reward can't be given twice.
        return false  -- legacy return 0: the giver keeps the item
    end
else
    if gems < 3 then
        gems = gems + 1
        actor:set_quest_var("phase_armor", gem_key, gems)
        wait(0.2)
        actor:send(tostring(self.name) .. " tells you, \"Hey, very nice. It is good to see adventurers out conquering the\"")
        actor:send(tostring(self.name) .. " tells you, \"realm.  You have now given me " .. tostring(gems) .. " " .. obj_name(entry.gem) .. ".\"")
        world.destroy(object)
        actor:save()
    else
        self:command("eye " .. tostring(actor.name))
        actor:send(tostring(self.name) .. " tells you, \"Hey now, you have given me 3 already!\"")
        -- Halt here so the reward can't be given twice.
        return false  -- legacy return 0: the giver keeps the item
    end
end

-- Quest complete for this slot: armor piece plus all 3 gems.
if armor == 1 and gems == 3 then
    wait(0.2)
    actor:send(tostring(self.name) .. " tells you, \"Excellent intrepid adventurer, you have provided me with all\"")
    actor:send(tostring(self.name) .. " tells you, \"I need in order to reward you with " .. obj_name(entry.reward) .. "!\"")
    wait(0.1)
    local reward = self:spawn_object(math.floor(entry.reward / 100), entry.reward % 100)
    wait(0.1)
    actor:send("<b:yellow>You gain experience!</>")
    for _ = 1, entry.mult do
        actor:award_exp(2640)
    end
    if reward then
        self:command("give " .. bare_name(reward.name) .. " to " .. actor.name)
    end
end
return true$trig$, '211c647fd89a9073197588c9c3ff88c1'),
  -- data/triggers/553/553_40_rogue_phase_1.lua
  (553, 40, $trig$-- Converted from DG Script #55340: rogue_phase_1
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
--
-- Phase armor turn-in (class and phase specific). Quest vars are keyed by the legacy object
-- vnum, as DG did: phase_armor:<armor vnum>_armor_acquired (1 piece) and
-- phase_armor:<gem vnum>_gems_acquired (3 gems). The zone 556 status scripts read these keys.
-- The runtime fires RECEIVE after the item is already in the mob's hands, so a refusal hands
-- it back with a give command (DG's `return 0`).

local class_ok = false
for _, c in ipairs({"rogue", "assassin", "thief", "mercenary"}) do
    if string.lower(actor.class or "") == c then
        class_ok = true
        break
    end
end

local function obj_name(vnum)
    return objects.template(math.floor(vnum / 100), vnum % 100).name
end

-- Item names carry a leading article ("a rusted helm"); give matches on the bare words.
local function bare_name(name)
    return (string.gsub(string.gsub(name, "^%s*[Tt]he%s+", ""), "^%s*[Aa]n?%s+", ""))
end

if not (class_ok and actor.level >= 1 and actor:get_quest_stage("phase_armor") >= 1) then
    -- not the right class / phase for this questmaster
    self:command("eye " .. tostring(actor.name))
    actor:send(tostring(self.name) .. " tells you, 'I am not interested in this from you.'")
    return false  -- legacy return 0: the giver keeps the item
end

-- Slots for this class: destroyed armor, gem, reward (legacy 5-digit vnums) and exp multiplier.
local slots = {
    {slot = "helm", armor = 55313, gem = 55580, reward = 55405, mult = 10},
    {slot = "arm", armor = 55317, gem = 55584, reward = 55406, mult = 17},
    {slot = "chest", armor = 55325, gem = 55592, reward = 55407, mult = 29},
    {slot = "legs", armor = 55321, gem = 55588, reward = 55408, mult = 24},
    {slot = "boots", armor = 55305, gem = 55572, reward = 55409, mult = 4},
    {slot = "bracer", armor = 55309, gem = 55576, reward = 55410, mult = 7},
    {slot = "gloves", armor = 55301, gem = 55568, reward = 55411, mult = 2},
}

-- DG switch: an armor case falls through into its gem case, so both vnums map to the same slot.
local object_vnum = object.zone_id * 100 + object.id
local entry, is_armor
for _, s in ipairs(slots) do
    if object_vnum == s.armor then
        entry = s
        is_armor = true
        break
    elseif object_vnum == s.gem then
        entry = s
        is_armor = false
        break
    end
end
if not entry then
    self:command("eye " .. tostring(actor.name))
    actor:send(tostring(self.name) .. " tells you, 'I am not interested in this from you.'")
    return false  -- legacy return 0: the giver keeps the item
end

local armor_key = tostring(entry.armor) .. "_armor_acquired"
local gem_key = tostring(entry.gem) .. "_gems_acquired"
local armor = tonumber(actor:get_quest_var("phase_armor:" .. armor_key)) or 0
local gems = tonumber(actor:get_quest_var("phase_armor:" .. gem_key)) or 0

if is_armor then
    if armor < 1 then
        armor = armor + 1
        actor:set_quest_var("phase_armor", armor_key, armor)
        wait(0.2)
        actor:send(tostring(self.name) .. " tells you, \"Hey now. what have we here?!  I've been looking for some of this\"")
        actor:send(tostring(self.name) .. " tells you, \"for quite some time.  You have now given me " .. obj_name(entry.armor) .. ".\"")
        world.destroy(object)
        actor:save()
    else
        self:command("eye " .. tostring(actor.name))
        actor:send(tostring(self.name) .. " tells you, \"Hey now, you have given me " .. obj_name(entry.armor) .. " already!\"")
        -- Halt here so the reward can't be given twice.
        return false  -- legacy return 0: the giver keeps the item
    end
else
    if gems < 3 then
        gems = gems + 1
        actor:set_quest_var("phase_armor", gem_key, gems)
        wait(0.2)
        actor:send(tostring(self.name) .. " tells you, \"Hey, very nice. It is good to see adventurers out conquering the\"")
        actor:send(tostring(self.name) .. " tells you, \"realm.  You have now given me " .. tostring(gems) .. " " .. obj_name(entry.gem) .. ".\"")
        world.destroy(object)
        actor:save()
    else
        self:command("eye " .. tostring(actor.name))
        actor:send(tostring(self.name) .. " tells you, \"Hey now, you have given me 3 already!\"")
        -- Halt here so the reward can't be given twice.
        return false  -- legacy return 0: the giver keeps the item
    end
end

-- Quest complete for this slot: armor piece plus all 3 gems.
if armor == 1 and gems == 3 then
    wait(0.2)
    actor:send(tostring(self.name) .. " tells you, \"Excellent intrepid adventurer, you have provided me with all\"")
    actor:send(tostring(self.name) .. " tells you, \"I need in order to reward you with " .. obj_name(entry.reward) .. "!\"")
    wait(0.1)
    local reward = self:spawn_object(math.floor(entry.reward / 100), entry.reward % 100)
    wait(0.1)
    actor:send("<b:yellow>You gain experience!</>")
    for _ = 1, entry.mult do
        actor:award_exp(2640)
    end
    if reward then
        self:command("give " .. bare_name(reward.name) .. " to " .. actor.name)
    end
end
return true$trig$, 'e14d181da92cf0eb9dc63a348314cb21'),
  -- data/triggers/553/553_50_anti-paladin_phase_2.lua
  (553, 50, $trig$-- Converted from DG Script #55350: anti-paladin_phase_2
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
--
-- Phase armor turn-in (class and phase specific). Quest vars are keyed by the legacy object
-- vnum, as DG did: phase_armor:<armor vnum>_armor_acquired (1 piece) and
-- phase_armor:<gem vnum>_gems_acquired (3 gems). The zone 556 status scripts read these keys.
-- The runtime fires RECEIVE after the item is already in the mob's hands, so a refusal hands
-- it back with a give command (DG's `return 0`).

local class_ok = false
for _, c in ipairs({"anti-paladin"}) do
    if string.lower(actor.class or "") == c then
        class_ok = true
        break
    end
end

local function obj_name(vnum)
    return objects.template(math.floor(vnum / 100), vnum % 100).name
end

-- Item names carry a leading article ("a rusted helm"); give matches on the bare words.
local function bare_name(name)
    return (string.gsub(string.gsub(name, "^%s*[Tt]he%s+", ""), "^%s*[Aa]n?%s+", ""))
end

if not (class_ok and actor.level >= 21 and actor:get_quest_stage("phase_armor") >= 2) then
    -- not the right class / phase for this questmaster
    self:command("eye " .. tostring(actor.name))
    actor:send(tostring(self.name) .. " tells you, 'I am not interested in this from you.'")
    return false  -- legacy return 0: the giver keeps the item
end

-- Slots for this class: destroyed armor, gem, reward (legacy 5-digit vnums) and exp multiplier.
local slots = {
    {slot = "helm", armor = 55340, gem = 55627, reward = 55426, mult = 7},
    {slot = "arm", armor = 55344, gem = 55638, reward = 55427, mult = 8},
    {slot = "chest", armor = 55352, gem = 55660, reward = 55428, mult = 10},
    {slot = "legs", armor = 55348, gem = 55649, reward = 55429, mult = 9},
    {slot = "boots", armor = 55332, gem = 55605, reward = 55430, mult = 5},
    {slot = "bracer", armor = 55336, gem = 55616, reward = 55431, mult = 6},
    {slot = "gloves", armor = 55328, gem = 55594, reward = 55432, mult = 4},
}

-- DG switch: an armor case falls through into its gem case, so both vnums map to the same slot.
local object_vnum = object.zone_id * 100 + object.id
local entry, is_armor
for _, s in ipairs(slots) do
    if object_vnum == s.armor then
        entry = s
        is_armor = true
        break
    elseif object_vnum == s.gem then
        entry = s
        is_armor = false
        break
    end
end
if not entry then
    self:command("eye " .. tostring(actor.name))
    actor:send(tostring(self.name) .. " tells you, 'I am not interested in this from you.'")
    return false  -- legacy return 0: the giver keeps the item
end

local armor_key = tostring(entry.armor) .. "_armor_acquired"
local gem_key = tostring(entry.gem) .. "_gems_acquired"
local armor = tonumber(actor:get_quest_var("phase_armor:" .. armor_key)) or 0
local gems = tonumber(actor:get_quest_var("phase_armor:" .. gem_key)) or 0

if is_armor then
    if armor < 1 then
        armor = armor + 1
        actor:set_quest_var("phase_armor", armor_key, armor)
        wait(0.2)
        actor:send(tostring(self.name) .. " tells you, \"Hey now. what have we here?!  I've been looking for some of this\"")
        actor:send(tostring(self.name) .. " tells you, \"for quite some time.  You have now given me " .. obj_name(entry.armor) .. ".\"")
        world.destroy(object)
        actor:save()
    else
        self:command("eye " .. tostring(actor.name))
        actor:send(tostring(self.name) .. " tells you, \"Hey now, you have given me " .. obj_name(entry.armor) .. " already!\"")
        -- Halt here so the reward can't be given twice.
        return false  -- legacy return 0: the giver keeps the item
    end
else
    if gems < 3 then
        gems = gems + 1
        actor:set_quest_var("phase_armor", gem_key, gems)
        wait(0.2)
        actor:send(tostring(self.name) .. " tells you, \"Hey, very nice. It is good to see adventurers out conquering the\"")
        actor:send(tostring(self.name) .. " tells you, \"realm.  You have now given me " .. tostring(gems) .. " " .. obj_name(entry.gem) .. ".\"")
        world.destroy(object)
        actor:save()
    else
        self:command("eye " .. tostring(actor.name))
        actor:send(tostring(self.name) .. " tells you, \"Hey now, you have given me 3 already!\"")
        -- Halt here so the reward can't be given twice.
        return false  -- legacy return 0: the giver keeps the item
    end
end

-- Quest complete for this slot: armor piece plus all 3 gems.
if armor == 1 and gems == 3 then
    wait(0.2)
    actor:send(tostring(self.name) .. " tells you, \"Excellent intrepid adventurer, you have provided me with all\"")
    actor:send(tostring(self.name) .. " tells you, \"I need in order to reward you with " .. obj_name(entry.reward) .. "!\"")
    wait(0.1)
    local reward = self:spawn_object(math.floor(entry.reward / 100), entry.reward % 100)
    wait(0.1)
    actor:send("<b:yellow>You gain experience!</>")
    for _ = 1, entry.mult do
        actor:award_exp(29880)
    end
    if reward then
        self:command("give " .. bare_name(reward.name) .. " to " .. actor.name)
    end
end
return true$trig$, '6c91c8f41ed48231e82e1b6f1e5e4c3b'),
  -- data/triggers/553/553_60_cleric_phase_2.lua
  (553, 60, $trig$-- Converted from DG Script #55360: cleric_phase_2
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
--
-- Phase armor turn-in (class and phase specific). Quest vars are keyed by the legacy object
-- vnum, as DG did: phase_armor:<armor vnum>_armor_acquired (1 piece) and
-- phase_armor:<gem vnum>_gems_acquired (3 gems). The zone 556 status scripts read these keys.
-- The runtime fires RECEIVE after the item is already in the mob's hands, so a refusal hands
-- it back with a give command (DG's `return 0`).

local class_ok = false
for _, c in ipairs({"cleric", "priest"}) do
    if string.lower(actor.class or "") == c then
        class_ok = true
        break
    end
end

local function obj_name(vnum)
    return objects.template(math.floor(vnum / 100), vnum % 100).name
end

-- Item names carry a leading article ("a rusted helm"); give matches on the bare words.
local function bare_name(name)
    return (string.gsub(string.gsub(name, "^%s*[Tt]he%s+", ""), "^%s*[Aa]n?%s+", ""))
end

if not (class_ok and actor.level >= 21 and actor:get_quest_stage("phase_armor") >= 2) then
    -- not the right class / phase for this questmaster
    self:command("eye " .. tostring(actor.name))
    actor:send(tostring(self.name) .. " tells you, 'I am not interested in this from you.'")
    return false  -- legacy return 0: the giver keeps the item
end

-- Slots for this class: destroyed armor, gem, reward (legacy 5-digit vnums) and exp multiplier.
local slots = {
    {slot = "helm", armor = 55340, gem = 55634, reward = 55433, mult = 7},
    {slot = "arm", armor = 55344, gem = 55645, reward = 55434, mult = 8},
    {slot = "chest", armor = 55352, gem = 55667, reward = 55435, mult = 10},
    {slot = "legs", armor = 55348, gem = 55656, reward = 55436, mult = 9},
    {slot = "boots", armor = 55332, gem = 55612, reward = 55437, mult = 5},
    {slot = "bracer", armor = 55336, gem = 55623, reward = 55438, mult = 6},
    {slot = "gloves", armor = 55328, gem = 55601, reward = 55439, mult = 4},
}

-- DG switch: an armor case falls through into its gem case, so both vnums map to the same slot.
local object_vnum = object.zone_id * 100 + object.id
local entry, is_armor
for _, s in ipairs(slots) do
    if object_vnum == s.armor then
        entry = s
        is_armor = true
        break
    elseif object_vnum == s.gem then
        entry = s
        is_armor = false
        break
    end
end
if not entry then
    self:command("eye " .. tostring(actor.name))
    actor:send(tostring(self.name) .. " tells you, 'I am not interested in this from you.'")
    return false  -- legacy return 0: the giver keeps the item
end

local armor_key = tostring(entry.armor) .. "_armor_acquired"
local gem_key = tostring(entry.gem) .. "_gems_acquired"
local armor = tonumber(actor:get_quest_var("phase_armor:" .. armor_key)) or 0
local gems = tonumber(actor:get_quest_var("phase_armor:" .. gem_key)) or 0

if is_armor then
    if armor < 1 then
        armor = armor + 1
        actor:set_quest_var("phase_armor", armor_key, armor)
        wait(0.2)
        actor:send(tostring(self.name) .. " tells you, \"Hey now. what have we here?!  I've been looking for some of this\"")
        actor:send(tostring(self.name) .. " tells you, \"for quite some time.  You have now given me " .. obj_name(entry.armor) .. ".\"")
        world.destroy(object)
        actor:save()
    else
        self:command("eye " .. tostring(actor.name))
        actor:send(tostring(self.name) .. " tells you, \"Hey now, you have given me " .. obj_name(entry.armor) .. " already!\"")
        -- Halt here so the reward can't be given twice.
        return false  -- legacy return 0: the giver keeps the item
    end
else
    if gems < 3 then
        gems = gems + 1
        actor:set_quest_var("phase_armor", gem_key, gems)
        wait(0.2)
        actor:send(tostring(self.name) .. " tells you, \"Hey, very nice. It is good to see adventurers out conquering the\"")
        actor:send(tostring(self.name) .. " tells you, \"realm.  You have now given me " .. tostring(gems) .. " " .. obj_name(entry.gem) .. ".\"")
        world.destroy(object)
        actor:save()
    else
        self:command("eye " .. tostring(actor.name))
        actor:send(tostring(self.name) .. " tells you, \"Hey now, you have given me 3 already!\"")
        -- Halt here so the reward can't be given twice.
        return false  -- legacy return 0: the giver keeps the item
    end
end

-- Quest complete for this slot: armor piece plus all 3 gems.
if armor == 1 and gems == 3 then
    wait(0.2)
    actor:send(tostring(self.name) .. " tells you, \"Excellent intrepid adventurer, you have provided me with all\"")
    actor:send(tostring(self.name) .. " tells you, \"I need in order to reward you with " .. obj_name(entry.reward) .. "!\"")
    wait(0.1)
    local reward = self:spawn_object(math.floor(entry.reward / 100), entry.reward % 100)
    wait(0.1)
    actor:send("<b:yellow>You gain experience!</>")
    for _ = 1, entry.mult do
        actor:award_exp(29880)
    end
    if reward then
        self:command("give " .. bare_name(reward.name) .. " to " .. actor.name)
    end
end
return true$trig$, 'db0386e5f0f619c74f23f4334ccc1178'),
  -- data/triggers/553/553_70_diabolist_phase_2.lua
  (553, 70, $trig$-- Converted from DG Script #55370: diabolist_phase_2
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
--
-- Phase armor turn-in (class and phase specific). Quest vars are keyed by the legacy object
-- vnum, as DG did: phase_armor:<armor vnum>_armor_acquired (1 piece) and
-- phase_armor:<gem vnum>_gems_acquired (3 gems). The zone 556 status scripts read these keys.
-- The runtime fires RECEIVE after the item is already in the mob's hands, so a refusal hands
-- it back with a give command (DG's `return 0`).

local class_ok = false
for _, c in ipairs({"diabolist"}) do
    if string.lower(actor.class or "") == c then
        class_ok = true
        break
    end
end

local function obj_name(vnum)
    return objects.template(math.floor(vnum / 100), vnum % 100).name
end

-- Item names carry a leading article ("a rusted helm"); give matches on the bare words.
local function bare_name(name)
    return (string.gsub(string.gsub(name, "^%s*[Tt]he%s+", ""), "^%s*[Aa]n?%s+", ""))
end

if not (class_ok and actor.level >= 21 and actor:get_quest_stage("phase_armor") >= 2) then
    -- not the right class / phase for this questmaster
    self:command("eye " .. tostring(actor.name))
    actor:send(tostring(self.name) .. " tells you, 'I am not interested in this from you.'")
    return false  -- legacy return 0: the giver keeps the item
end

-- Slots for this class: destroyed armor, gem, reward (legacy 5-digit vnums) and exp multiplier.
local slots = {
    {slot = "helm", armor = 55340, gem = 55628, reward = 55468, mult = 7},
    {slot = "arm", armor = 55344, gem = 55639, reward = 55469, mult = 8},
    {slot = "chest", armor = 55352, gem = 55661, reward = 55470, mult = 10},
    {slot = "legs", armor = 55348, gem = 55650, reward = 55471, mult = 9},
    {slot = "boots", armor = 55332, gem = 55606, reward = 55472, mult = 5},
    {slot = "bracer", armor = 55336, gem = 55617, reward = 55473, mult = 6},
    {slot = "gloves", armor = 55328, gem = 55595, reward = 55474, mult = 4},
}

-- DG switch: an armor case falls through into its gem case, so both vnums map to the same slot.
local object_vnum = object.zone_id * 100 + object.id
local entry, is_armor
for _, s in ipairs(slots) do
    if object_vnum == s.armor then
        entry = s
        is_armor = true
        break
    elseif object_vnum == s.gem then
        entry = s
        is_armor = false
        break
    end
end
if not entry then
    self:command("eye " .. tostring(actor.name))
    actor:send(tostring(self.name) .. " tells you, 'I am not interested in this from you.'")
    return false  -- legacy return 0: the giver keeps the item
end

local armor_key = tostring(entry.armor) .. "_armor_acquired"
local gem_key = tostring(entry.gem) .. "_gems_acquired"
local armor = tonumber(actor:get_quest_var("phase_armor:" .. armor_key)) or 0
local gems = tonumber(actor:get_quest_var("phase_armor:" .. gem_key)) or 0

if is_armor then
    if armor < 1 then
        armor = armor + 1
        actor:set_quest_var("phase_armor", armor_key, armor)
        wait(0.2)
        actor:send(tostring(self.name) .. " tells you, \"Hey now. what have we here?!  I've been looking for some of this\"")
        actor:send(tostring(self.name) .. " tells you, \"for quite some time.  You have now given me " .. obj_name(entry.armor) .. ".\"")
        world.destroy(object)
        actor:save()
    else
        self:command("eye " .. tostring(actor.name))
        actor:send(tostring(self.name) .. " tells you, \"Hey now, you have given me " .. obj_name(entry.armor) .. " already!\"")
        -- Halt here so the reward can't be given twice.
        return false  -- legacy return 0: the giver keeps the item
    end
else
    if gems < 3 then
        gems = gems + 1
        actor:set_quest_var("phase_armor", gem_key, gems)
        wait(0.2)
        actor:send(tostring(self.name) .. " tells you, \"Hey, very nice. It is good to see adventurers out conquering the\"")
        actor:send(tostring(self.name) .. " tells you, \"realm.  You have now given me " .. tostring(gems) .. " " .. obj_name(entry.gem) .. ".\"")
        world.destroy(object)
        actor:save()
    else
        self:command("eye " .. tostring(actor.name))
        actor:send(tostring(self.name) .. " tells you, \"Hey now, you have given me 3 already!\"")
        -- Halt here so the reward can't be given twice.
        return false  -- legacy return 0: the giver keeps the item
    end
end

-- Quest complete for this slot: armor piece plus all 3 gems.
if armor == 1 and gems == 3 then
    wait(0.2)
    actor:send(tostring(self.name) .. " tells you, \"Excellent intrepid adventurer, you have provided me with all\"")
    actor:send(tostring(self.name) .. " tells you, \"I need in order to reward you with " .. obj_name(entry.reward) .. "!\"")
    wait(0.1)
    local reward = self:spawn_object(math.floor(entry.reward / 100), entry.reward % 100)
    wait(0.1)
    actor:send("<b:yellow>You gain experience!</>")
    for _ = 1, entry.mult do
        actor:award_exp(29880)
    end
    if reward then
        self:command("give " .. bare_name(reward.name) .. " to " .. actor.name)
    end
end
return true$trig$, '8a5b52236398dcfe921295867ef7088f'),
  -- data/triggers/553/553_80_druid_phase_2.lua
  (553, 80, $trig$-- Converted from DG Script #55380: druid_phase_2
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
--
-- Phase armor turn-in (class and phase specific). Quest vars are keyed by the legacy object
-- vnum, as DG did: phase_armor:<armor vnum>_armor_acquired (1 piece) and
-- phase_armor:<gem vnum>_gems_acquired (3 gems). The zone 556 status scripts read these keys.
-- The runtime fires RECEIVE after the item is already in the mob's hands, so a refusal hands
-- it back with a give command (DG's `return 0`).

local class_ok = false
for _, c in ipairs({"druid"}) do
    if string.lower(actor.class or "") == c then
        class_ok = true
        break
    end
end

local function obj_name(vnum)
    return objects.template(math.floor(vnum / 100), vnum % 100).name
end

-- Item names carry a leading article ("a rusted helm"); give matches on the bare words.
local function bare_name(name)
    return (string.gsub(string.gsub(name, "^%s*[Tt]he%s+", ""), "^%s*[Aa]n?%s+", ""))
end

if not (class_ok and actor.level >= 21 and actor:get_quest_stage("phase_armor") >= 2) then
    -- not the right class / phase for this questmaster
    self:command("eye " .. tostring(actor.name))
    actor:send(tostring(self.name) .. " tells you, 'I am not interested in this from you.'")
    return false  -- legacy return 0: the giver keeps the item
end

-- Slots for this class: destroyed armor, gem, reward (legacy 5-digit vnums) and exp multiplier.
local slots = {
    {slot = "helm", armor = 55342, gem = 55629, reward = 55447, mult = 7},
    {slot = "arm", armor = 55346, gem = 55640, reward = 55448, mult = 8},
    {slot = "chest", armor = 55354, gem = 55662, reward = 55449, mult = 10},
    {slot = "legs", armor = 55350, gem = 55651, reward = 55450, mult = 9},
    {slot = "boots", armor = 55334, gem = 55607, reward = 55451, mult = 5},
    {slot = "bracer", armor = 55338, gem = 55618, reward = 55452, mult = 6},
    {slot = "gloves", armor = 55330, gem = 55596, reward = 55453, mult = 4},
}

-- DG switch: an armor case falls through into its gem case, so both vnums map to the same slot.
local object_vnum = object.zone_id * 100 + object.id
local entry, is_armor
for _, s in ipairs(slots) do
    if object_vnum == s.armor then
        entry = s
        is_armor = true
        break
    elseif object_vnum == s.gem then
        entry = s
        is_armor = false
        break
    end
end
if not entry then
    self:command("eye " .. tostring(actor.name))
    actor:send(tostring(self.name) .. " tells you, 'I am not interested in this from you.'")
    return false  -- legacy return 0: the giver keeps the item
end

local armor_key = tostring(entry.armor) .. "_armor_acquired"
local gem_key = tostring(entry.gem) .. "_gems_acquired"
local armor = tonumber(actor:get_quest_var("phase_armor:" .. armor_key)) or 0
local gems = tonumber(actor:get_quest_var("phase_armor:" .. gem_key)) or 0

if is_armor then
    if armor < 1 then
        armor = armor + 1
        actor:set_quest_var("phase_armor", armor_key, armor)
        wait(0.2)
        actor:send(tostring(self.name) .. " tells you, \"Hey now. what have we here?!  I've been looking for some of this\"")
        actor:send(tostring(self.name) .. " tells you, \"for quite some time.  You have now given me " .. obj_name(entry.armor) .. ".\"")
        world.destroy(object)
        actor:save()
    else
        self:command("eye " .. tostring(actor.name))
        actor:send(tostring(self.name) .. " tells you, \"Hey now, you have given me " .. obj_name(entry.armor) .. " already!\"")
        -- Halt here so the reward can't be given twice.
        return false  -- legacy return 0: the giver keeps the item
    end
else
    if gems < 3 then
        gems = gems + 1
        actor:set_quest_var("phase_armor", gem_key, gems)
        wait(0.2)
        actor:send(tostring(self.name) .. " tells you, \"Hey, very nice. It is good to see adventurers out conquering the\"")
        actor:send(tostring(self.name) .. " tells you, \"realm.  You have now given me " .. tostring(gems) .. " " .. obj_name(entry.gem) .. ".\"")
        world.destroy(object)
        actor:save()
    else
        self:command("eye " .. tostring(actor.name))
        actor:send(tostring(self.name) .. " tells you, \"Hey now, you have given me 3 already!\"")
        -- Halt here so the reward can't be given twice.
        return false  -- legacy return 0: the giver keeps the item
    end
end

-- Quest complete for this slot: armor piece plus all 3 gems.
if armor == 1 and gems == 3 then
    wait(0.2)
    actor:send(tostring(self.name) .. " tells you, \"Excellent intrepid adventurer, you have provided me with all\"")
    actor:send(tostring(self.name) .. " tells you, \"I need in order to reward you with " .. obj_name(entry.reward) .. "!\"")
    wait(0.1)
    local reward = self:spawn_object(math.floor(entry.reward / 100), entry.reward % 100)
    wait(0.1)
    actor:send("<b:yellow>You gain experience!</>")
    for _ = 1, entry.mult do
        actor:award_exp(29880)
    end
    if reward then
        self:command("give " .. bare_name(reward.name) .. " to " .. actor.name)
    end
end
return true$trig$, '01f0f4b314d38f5a5e3b173f11a46082'),
  -- data/triggers/553/553_90_monk_phase_2.lua
  (553, 90, $trig$-- Converted from DG Script #55390: monk_phase_2
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
--
-- Phase armor turn-in (class and phase specific). Quest vars are keyed by the legacy object
-- vnum, as DG did: phase_armor:<armor vnum>_armor_acquired (1 piece) and
-- phase_armor:<gem vnum>_gems_acquired (3 gems). The zone 556 status scripts read these keys.
-- The runtime fires RECEIVE after the item is already in the mob's hands, so a refusal hands
-- it back with a give command (DG's `return 0`).

local class_ok = false
for _, c in ipairs({"monk"}) do
    if string.lower(actor.class or "") == c then
        class_ok = true
        break
    end
end

local function obj_name(vnum)
    return objects.template(math.floor(vnum / 100), vnum % 100).name
end

-- Item names carry a leading article ("a rusted helm"); give matches on the bare words.
local function bare_name(name)
    return (string.gsub(string.gsub(name, "^%s*[Tt]he%s+", ""), "^%s*[Aa]n?%s+", ""))
end

if not (class_ok and actor.level >= 21 and actor:get_quest_stage("phase_armor") >= 2) then
    -- not the right class / phase for this questmaster
    self:command("eye " .. tostring(actor.name))
    actor:send(tostring(self.name) .. " tells you, 'I am not interested in this from you.'")
    return false  -- legacy return 0: the giver keeps the item
end

-- Slots for this class: destroyed armor, gem, reward (legacy 5-digit vnums) and exp multiplier.
local slots = {
    {slot = "helm", armor = 55342, gem = 55630, reward = 55461, mult = 7},
    {slot = "arm", armor = 55346, gem = 55641, reward = 55462, mult = 8},
    {slot = "chest", armor = 55354, gem = 55663, reward = 55463, mult = 10},
    {slot = "legs", armor = 55350, gem = 55652, reward = 55464, mult = 9},
    {slot = "boots", armor = 55334, gem = 55608, reward = 55465, mult = 5},
    {slot = "bracer", armor = 55338, gem = 55619, reward = 55466, mult = 6},
    {slot = "gloves", armor = 55330, gem = 55597, reward = 55467, mult = 4},
}

-- DG switch: an armor case falls through into its gem case, so both vnums map to the same slot.
local object_vnum = object.zone_id * 100 + object.id
local entry, is_armor
for _, s in ipairs(slots) do
    if object_vnum == s.armor then
        entry = s
        is_armor = true
        break
    elseif object_vnum == s.gem then
        entry = s
        is_armor = false
        break
    end
end
if not entry then
    self:command("eye " .. tostring(actor.name))
    actor:send(tostring(self.name) .. " tells you, 'I am not interested in this from you.'")
    return false  -- legacy return 0: the giver keeps the item
end

local armor_key = tostring(entry.armor) .. "_armor_acquired"
local gem_key = tostring(entry.gem) .. "_gems_acquired"
local armor = tonumber(actor:get_quest_var("phase_armor:" .. armor_key)) or 0
local gems = tonumber(actor:get_quest_var("phase_armor:" .. gem_key)) or 0

if is_armor then
    if armor < 1 then
        armor = armor + 1
        actor:set_quest_var("phase_armor", armor_key, armor)
        wait(0.2)
        actor:send(tostring(self.name) .. " tells you, \"Hey now. what have we here?!  I've been looking for some of this\"")
        actor:send(tostring(self.name) .. " tells you, \"for quite some time.  You have now given me " .. obj_name(entry.armor) .. ".\"")
        world.destroy(object)
        actor:save()
    else
        self:command("eye " .. tostring(actor.name))
        actor:send(tostring(self.name) .. " tells you, \"Hey now, you have given me " .. obj_name(entry.armor) .. " already!\"")
        -- Halt here so the reward can't be given twice.
        return false  -- legacy return 0: the giver keeps the item
    end
else
    if gems < 3 then
        gems = gems + 1
        actor:set_quest_var("phase_armor", gem_key, gems)
        wait(0.2)
        actor:send(tostring(self.name) .. " tells you, \"Hey, very nice. It is good to see adventurers out conquering the\"")
        actor:send(tostring(self.name) .. " tells you, \"realm.  You have now given me " .. tostring(gems) .. " " .. obj_name(entry.gem) .. ".\"")
        world.destroy(object)
        actor:save()
    else
        self:command("eye " .. tostring(actor.name))
        actor:send(tostring(self.name) .. " tells you, \"Hey now, you have given me 3 already!\"")
        -- Halt here so the reward can't be given twice.
        return false  -- legacy return 0: the giver keeps the item
    end
end

-- Quest complete for this slot: armor piece plus all 3 gems.
if armor == 1 and gems == 3 then
    wait(0.2)
    actor:send(tostring(self.name) .. " tells you, \"Excellent intrepid adventurer, you have provided me with all\"")
    actor:send(tostring(self.name) .. " tells you, \"I need in order to reward you with " .. obj_name(entry.reward) .. "!\"")
    wait(0.1)
    local reward = self:spawn_object(math.floor(entry.reward / 100), entry.reward % 100)
    wait(0.1)
    actor:send("<b:yellow>You gain experience!</>")
    for _ = 1, entry.mult do
        actor:award_exp(29880)
    end
    if reward then
        self:command("give " .. bare_name(reward.name) .. " to " .. actor.name)
    end
end
return true$trig$, '3c240ac44cabec19d800da299b500b53'),
  -- data/triggers/554/554_00_necromancer_phase_2.lua
  (554, 0, $trig$-- Converted from DG Script #55400: necromancer_phase_2
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
--
-- Phase armor turn-in (class and phase specific). Quest vars are keyed by the legacy object
-- vnum, as DG did: phase_armor:<armor vnum>_armor_acquired (1 piece) and
-- phase_armor:<gem vnum>_gems_acquired (3 gems). The zone 556 status scripts read these keys.
-- The runtime fires RECEIVE after the item is already in the mob's hands, so a refusal hands
-- it back with a give command (DG's `return 0`).

local class_ok = false
for _, c in ipairs({"necromancer"}) do
    if string.lower(actor.class or "") == c then
        class_ok = true
        break
    end
end

local function obj_name(vnum)
    return objects.template(math.floor(vnum / 100), vnum % 100).name
end

-- Item names carry a leading article ("a rusted helm"); give matches on the bare words.
local function bare_name(name)
    return (string.gsub(string.gsub(name, "^%s*[Tt]he%s+", ""), "^%s*[Aa]n?%s+", ""))
end

if not (class_ok and actor.level >= 21 and actor:get_quest_stage("phase_armor") >= 2) then
    -- not the right class / phase for this questmaster
    self:command("eye " .. tostring(actor.name))
    actor:send(tostring(self.name) .. " tells you, 'I am not interested in this from you.'")
    return false  -- legacy return 0: the giver keeps the item
end

-- Slots for this class: destroyed armor, gem, reward (legacy 5-digit vnums) and exp multiplier.
local slots = {
    {slot = "helm", armor = 55343, gem = 55631, reward = 55454, mult = 7},
    {slot = "arm", armor = 55347, gem = 55642, reward = 55455, mult = 8},
    {slot = "chest", armor = 55355, gem = 55664, reward = 55456, mult = 10},
    {slot = "legs", armor = 55351, gem = 55653, reward = 55457, mult = 9},
    {slot = "boots", armor = 55335, gem = 55609, reward = 55458, mult = 5},
    {slot = "bracer", armor = 55339, gem = 55620, reward = 55459, mult = 6},
    {slot = "gloves", armor = 55331, gem = 55598, reward = 55460, mult = 4},
}

-- DG switch: an armor case falls through into its gem case, so both vnums map to the same slot.
local object_vnum = object.zone_id * 100 + object.id
local entry, is_armor
for _, s in ipairs(slots) do
    if object_vnum == s.armor then
        entry = s
        is_armor = true
        break
    elseif object_vnum == s.gem then
        entry = s
        is_armor = false
        break
    end
end
if not entry then
    self:command("eye " .. tostring(actor.name))
    actor:send(tostring(self.name) .. " tells you, 'I am not interested in this from you.'")
    return false  -- legacy return 0: the giver keeps the item
end

local armor_key = tostring(entry.armor) .. "_armor_acquired"
local gem_key = tostring(entry.gem) .. "_gems_acquired"
local armor = tonumber(actor:get_quest_var("phase_armor:" .. armor_key)) or 0
local gems = tonumber(actor:get_quest_var("phase_armor:" .. gem_key)) or 0

if is_armor then
    if armor < 1 then
        armor = armor + 1
        actor:set_quest_var("phase_armor", armor_key, armor)
        wait(0.2)
        actor:send(tostring(self.name) .. " tells you, \"Hey now. what have we here?!  I've been looking for some of this\"")
        actor:send(tostring(self.name) .. " tells you, \"for quite some time.  You have now given me " .. obj_name(entry.armor) .. ".\"")
        world.destroy(object)
        actor:save()
    else
        self:command("eye " .. tostring(actor.name))
        actor:send(tostring(self.name) .. " tells you, \"Hey now, you have given me " .. obj_name(entry.armor) .. " already!\"")
        -- Halt here so the reward can't be given twice.
        return false  -- legacy return 0: the giver keeps the item
    end
else
    if gems < 3 then
        gems = gems + 1
        actor:set_quest_var("phase_armor", gem_key, gems)
        wait(0.2)
        actor:send(tostring(self.name) .. " tells you, \"Hey, very nice. It is good to see adventurers out conquering the\"")
        actor:send(tostring(self.name) .. " tells you, \"realm.  You have now given me " .. tostring(gems) .. " " .. obj_name(entry.gem) .. ".\"")
        world.destroy(object)
        actor:save()
    else
        self:command("eye " .. tostring(actor.name))
        actor:send(tostring(self.name) .. " tells you, \"Hey now, you have given me 3 already!\"")
        -- Halt here so the reward can't be given twice.
        return false  -- legacy return 0: the giver keeps the item
    end
end

-- Quest complete for this slot: armor piece plus all 3 gems.
if armor == 1 and gems == 3 then
    wait(0.2)
    actor:send(tostring(self.name) .. " tells you, \"Excellent intrepid adventurer, you have provided me with all\"")
    actor:send(tostring(self.name) .. " tells you, \"I need in order to reward you with " .. obj_name(entry.reward) .. "!\"")
    wait(0.1)
    local reward = self:spawn_object(math.floor(entry.reward / 100), entry.reward % 100)
    wait(0.1)
    actor:send("<b:yellow>You gain experience!</>")
    for _ = 1, entry.mult do
        actor:award_exp(29880)
    end
    if reward then
        self:command("give " .. bare_name(reward.name) .. " to " .. actor.name)
    end
end
return true$trig$, '8c10e590770f9acf462bd80a35a893e9'),
  -- data/triggers/554/554_10_paladin_phase_2.lua
  (554, 10, $trig$-- Converted from DG Script #55410: paladin_phase_2
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
--
-- Phase armor turn-in (class and phase specific). Quest vars are keyed by the legacy object
-- vnum, as DG did: phase_armor:<armor vnum>_armor_acquired (1 piece) and
-- phase_armor:<gem vnum>_gems_acquired (3 gems). The zone 556 status scripts read these keys.
-- The runtime fires RECEIVE after the item is already in the mob's hands, so a refusal hands
-- it back with a give command (DG's `return 0`).

local class_ok = false
for _, c in ipairs({"paladin"}) do
    if string.lower(actor.class or "") == c then
        class_ok = true
        break
    end
end

local function obj_name(vnum)
    return objects.template(math.floor(vnum / 100), vnum % 100).name
end

-- Item names carry a leading article ("a rusted helm"); give matches on the bare words.
local function bare_name(name)
    return (string.gsub(string.gsub(name, "^%s*[Tt]he%s+", ""), "^%s*[Aa]n?%s+", ""))
end

if not (class_ok and actor.level >= 21 and actor:get_quest_stage("phase_armor") >= 2) then
    -- not the right class / phase for this questmaster
    self:command("eye " .. tostring(actor.name))
    actor:send(tostring(self.name) .. " tells you, 'I am not interested in this from you.'")
    return false  -- legacy return 0: the giver keeps the item
end

-- Slots for this class: destroyed armor, gem, reward (legacy 5-digit vnums) and exp multiplier.
local slots = {
    {slot = "helm", armor = 55340, gem = 55632, reward = 55419, mult = 7},
    {slot = "arm", armor = 55344, gem = 55643, reward = 55420, mult = 8},
    {slot = "chest", armor = 55352, gem = 55665, reward = 55421, mult = 10},
    {slot = "legs", armor = 55348, gem = 55654, reward = 55422, mult = 9},
    {slot = "boots", armor = 55332, gem = 55610, reward = 55423, mult = 5},
    {slot = "bracer", armor = 55336, gem = 55621, reward = 55424, mult = 6},
    {slot = "gloves", armor = 55328, gem = 55599, reward = 55425, mult = 4},
}

-- DG switch: an armor case falls through into its gem case, so both vnums map to the same slot.
local object_vnum = object.zone_id * 100 + object.id
local entry, is_armor
for _, s in ipairs(slots) do
    if object_vnum == s.armor then
        entry = s
        is_armor = true
        break
    elseif object_vnum == s.gem then
        entry = s
        is_armor = false
        break
    end
end
if not entry then
    self:command("eye " .. tostring(actor.name))
    actor:send(tostring(self.name) .. " tells you, 'I am not interested in this from you.'")
    return false  -- legacy return 0: the giver keeps the item
end

local armor_key = tostring(entry.armor) .. "_armor_acquired"
local gem_key = tostring(entry.gem) .. "_gems_acquired"
local armor = tonumber(actor:get_quest_var("phase_armor:" .. armor_key)) or 0
local gems = tonumber(actor:get_quest_var("phase_armor:" .. gem_key)) or 0

if is_armor then
    if armor < 1 then
        armor = armor + 1
        actor:set_quest_var("phase_armor", armor_key, armor)
        wait(0.2)
        actor:send(tostring(self.name) .. " tells you, \"Hey now. what have we here?!  I've been looking for some of this\"")
        actor:send(tostring(self.name) .. " tells you, \"for quite some time.  You have now given me " .. obj_name(entry.armor) .. ".\"")
        world.destroy(object)
        actor:save()
    else
        self:command("eye " .. tostring(actor.name))
        actor:send(tostring(self.name) .. " tells you, \"Hey now, you have given me " .. obj_name(entry.armor) .. " already!\"")
        -- Halt here so the reward can't be given twice.
        return false  -- legacy return 0: the giver keeps the item
    end
else
    if gems < 3 then
        gems = gems + 1
        actor:set_quest_var("phase_armor", gem_key, gems)
        wait(0.2)
        actor:send(tostring(self.name) .. " tells you, \"Hey, very nice. It is good to see adventurers out conquering the\"")
        actor:send(tostring(self.name) .. " tells you, \"realm.  You have now given me " .. tostring(gems) .. " " .. obj_name(entry.gem) .. ".\"")
        world.destroy(object)
        actor:save()
    else
        self:command("eye " .. tostring(actor.name))
        actor:send(tostring(self.name) .. " tells you, \"Hey now, you have given me 3 already!\"")
        -- Halt here so the reward can't be given twice.
        return false  -- legacy return 0: the giver keeps the item
    end
end

-- Quest complete for this slot: armor piece plus all 3 gems.
if armor == 1 and gems == 3 then
    wait(0.2)
    actor:send(tostring(self.name) .. " tells you, \"Excellent intrepid adventurer, you have provided me with all\"")
    actor:send(tostring(self.name) .. " tells you, \"I need in order to reward you with " .. obj_name(entry.reward) .. "!\"")
    wait(0.1)
    local reward = self:spawn_object(math.floor(entry.reward / 100), entry.reward % 100)
    wait(0.1)
    actor:send("<b:yellow>You gain experience!</>")
    for _ = 1, entry.mult do
        actor:award_exp(29880)
    end
    if reward then
        self:command("give " .. bare_name(reward.name) .. " to " .. actor.name)
    end
end
return true$trig$, '8fdd45dcde892170d215c0f7c27af5ce'),
  -- data/triggers/554/554_20_ranger_phase_2.lua
  (554, 20, $trig$-- Converted from DG Script #55420: ranger_phase_2
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
--
-- Phase armor turn-in (class and phase specific). Quest vars are keyed by the legacy object
-- vnum, as DG did: phase_armor:<armor vnum>_armor_acquired (1 piece) and
-- phase_armor:<gem vnum>_gems_acquired (3 gems). The zone 556 status scripts read these keys.
-- The runtime fires RECEIVE after the item is already in the mob's hands, so a refusal hands
-- it back with a give command (DG's `return 0`).

local class_ok = false
for _, c in ipairs({"ranger"}) do
    if string.lower(actor.class or "") == c then
        class_ok = true
        break
    end
end

local function obj_name(vnum)
    return objects.template(math.floor(vnum / 100), vnum % 100).name
end

-- Item names carry a leading article ("a rusted helm"); give matches on the bare words.
local function bare_name(name)
    return (string.gsub(string.gsub(name, "^%s*[Tt]he%s+", ""), "^%s*[Aa]n?%s+", ""))
end

if not (class_ok and actor.level >= 21 and actor:get_quest_stage("phase_armor") >= 2) then
    -- not the right class / phase for this questmaster
    self:command("eye " .. tostring(actor.name))
    actor:send(tostring(self.name) .. " tells you, 'I am not interested in this from you.'")
    return false  -- legacy return 0: the giver keeps the item
end

-- Slots for this class: destroyed armor, gem, reward (legacy 5-digit vnums) and exp multiplier.
local slots = {
    {slot = "helm", armor = 55341, gem = 55633, reward = 55440, mult = 7},
    {slot = "arm", armor = 55345, gem = 55644, reward = 55441, mult = 8},
    {slot = "chest", armor = 55353, gem = 55666, reward = 55442, mult = 10},
    {slot = "legs", armor = 55349, gem = 55655, reward = 55443, mult = 9},
    {slot = "boots", armor = 55333, gem = 55611, reward = 55444, mult = 5},
    {slot = "bracer", armor = 55337, gem = 55622, reward = 55445, mult = 6},
    {slot = "gloves", armor = 55329, gem = 55600, reward = 55446, mult = 4},
}

-- DG switch: an armor case falls through into its gem case, so both vnums map to the same slot.
local object_vnum = object.zone_id * 100 + object.id
local entry, is_armor
for _, s in ipairs(slots) do
    if object_vnum == s.armor then
        entry = s
        is_armor = true
        break
    elseif object_vnum == s.gem then
        entry = s
        is_armor = false
        break
    end
end
if not entry then
    self:command("eye " .. tostring(actor.name))
    actor:send(tostring(self.name) .. " tells you, 'I am not interested in this from you.'")
    return false  -- legacy return 0: the giver keeps the item
end

local armor_key = tostring(entry.armor) .. "_armor_acquired"
local gem_key = tostring(entry.gem) .. "_gems_acquired"
local armor = tonumber(actor:get_quest_var("phase_armor:" .. armor_key)) or 0
local gems = tonumber(actor:get_quest_var("phase_armor:" .. gem_key)) or 0

if is_armor then
    if armor < 1 then
        armor = armor + 1
        actor:set_quest_var("phase_armor", armor_key, armor)
        wait(0.2)
        actor:send(tostring(self.name) .. " tells you, \"Hey now. what have we here?!  I've been looking for some of this\"")
        actor:send(tostring(self.name) .. " tells you, \"for quite some time.  You have now given me " .. obj_name(entry.armor) .. ".\"")
        world.destroy(object)
        actor:save()
    else
        self:command("eye " .. tostring(actor.name))
        actor:send(tostring(self.name) .. " tells you, \"Hey now, you have given me " .. obj_name(entry.armor) .. " already!\"")
        -- Halt here so the reward can't be given twice.
        return false  -- legacy return 0: the giver keeps the item
    end
else
    if gems < 3 then
        gems = gems + 1
        actor:set_quest_var("phase_armor", gem_key, gems)
        wait(0.2)
        actor:send(tostring(self.name) .. " tells you, \"Hey, very nice. It is good to see adventurers out conquering the\"")
        actor:send(tostring(self.name) .. " tells you, \"realm.  You have now given me " .. tostring(gems) .. " " .. obj_name(entry.gem) .. ".\"")
        world.destroy(object)
        actor:save()
    else
        self:command("eye " .. tostring(actor.name))
        actor:send(tostring(self.name) .. " tells you, \"Hey now, you have given me 3 already!\"")
        -- Halt here so the reward can't be given twice.
        return false  -- legacy return 0: the giver keeps the item
    end
end

-- Quest complete for this slot: armor piece plus all 3 gems.
if armor == 1 and gems == 3 then
    wait(0.2)
    actor:send(tostring(self.name) .. " tells you, \"Excellent intrepid adventurer, you have provided me with all\"")
    actor:send(tostring(self.name) .. " tells you, \"I need in order to reward you with " .. obj_name(entry.reward) .. "!\"")
    wait(0.1)
    local reward = self:spawn_object(math.floor(entry.reward / 100), entry.reward % 100)
    wait(0.1)
    actor:send("<b:yellow>You gain experience!</>")
    for _ = 1, entry.mult do
        actor:award_exp(29880)
    end
    if reward then
        self:command("give " .. bare_name(reward.name) .. " to " .. actor.name)
    end
end
return true$trig$, 'acb99c77adbfe49d5d7bf559ffe3ab4d'),
  -- data/triggers/554/554_30_rogue_phase_2.lua
  (554, 30, $trig$-- Converted from DG Script #55430: rogue_phase_2
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
--
-- Phase armor turn-in (class and phase specific). Quest vars are keyed by the legacy object
-- vnum, as DG did: phase_armor:<armor vnum>_armor_acquired (1 piece) and
-- phase_armor:<gem vnum>_gems_acquired (3 gems). The zone 556 status scripts read these keys.
-- The runtime fires RECEIVE after the item is already in the mob's hands, so a refusal hands
-- it back with a give command (DG's `return 0`).

local class_ok = false
for _, c in ipairs({"rogue", "thief", "assassin", "mercenary"}) do
    if string.lower(actor.class or "") == c then
        class_ok = true
        break
    end
end

local function obj_name(vnum)
    return objects.template(math.floor(vnum / 100), vnum % 100).name
end

-- Item names carry a leading article ("a rusted helm"); give matches on the bare words.
local function bare_name(name)
    return (string.gsub(string.gsub(name, "^%s*[Tt]he%s+", ""), "^%s*[Aa]n?%s+", ""))
end

if not (class_ok and actor.level >= 21 and actor:get_quest_stage("phase_armor") >= 2) then
    -- not the right class / phase for this questmaster
    self:command("eye " .. tostring(actor.name))
    actor:send(tostring(self.name) .. " tells you, 'I am not interested in this from you.'")
    return false  -- legacy return 0: the giver keeps the item
end

-- Slots for this class: destroyed armor, gem, reward (legacy 5-digit vnums) and exp multiplier.
local slots = {
    {slot = "helm", armor = 55341, gem = 55636, reward = 55482, mult = 7},
    {slot = "arm", armor = 55345, gem = 55647, reward = 55483, mult = 8},
    {slot = "chest", armor = 55353, gem = 55669, reward = 55484, mult = 10},
    {slot = "legs", armor = 55349, gem = 55658, reward = 55485, mult = 9},
    {slot = "boots", armor = 55333, gem = 55614, reward = 55486, mult = 5},
    {slot = "bracer", armor = 55337, gem = 55625, reward = 55487, mult = 6},
    {slot = "gloves", armor = 55329, gem = 55603, reward = 55488, mult = 4},
}

-- DG switch: an armor case falls through into its gem case, so both vnums map to the same slot.
local object_vnum = object.zone_id * 100 + object.id
local entry, is_armor
for _, s in ipairs(slots) do
    if object_vnum == s.armor then
        entry = s
        is_armor = true
        break
    elseif object_vnum == s.gem then
        entry = s
        is_armor = false
        break
    end
end
if not entry then
    self:command("eye " .. tostring(actor.name))
    actor:send(tostring(self.name) .. " tells you, 'I am not interested in this from you.'")
    return false  -- legacy return 0: the giver keeps the item
end

local armor_key = tostring(entry.armor) .. "_armor_acquired"
local gem_key = tostring(entry.gem) .. "_gems_acquired"
local armor = tonumber(actor:get_quest_var("phase_armor:" .. armor_key)) or 0
local gems = tonumber(actor:get_quest_var("phase_armor:" .. gem_key)) or 0

if is_armor then
    if armor < 1 then
        armor = armor + 1
        actor:set_quest_var("phase_armor", armor_key, armor)
        wait(0.2)
        actor:send(tostring(self.name) .. " tells you, \"Hey now. what have we here?!  I've been looking for some of this\"")
        actor:send(tostring(self.name) .. " tells you, \"for quite some time.  You have now given me " .. obj_name(entry.armor) .. ".\"")
        world.destroy(object)
        actor:save()
    else
        self:command("eye " .. tostring(actor.name))
        actor:send(tostring(self.name) .. " tells you, \"Hey now, you have given me " .. obj_name(entry.armor) .. " already!\"")
        -- Halt here so the reward can't be given twice.
        return false  -- legacy return 0: the giver keeps the item
    end
else
    if gems < 3 then
        gems = gems + 1
        actor:set_quest_var("phase_armor", gem_key, gems)
        wait(0.2)
        actor:send(tostring(self.name) .. " tells you, \"Hey, very nice. It is good to see adventurers out conquering the\"")
        actor:send(tostring(self.name) .. " tells you, \"realm.  You have now given me " .. tostring(gems) .. " " .. obj_name(entry.gem) .. ".\"")
        world.destroy(object)
        actor:save()
    else
        self:command("eye " .. tostring(actor.name))
        actor:send(tostring(self.name) .. " tells you, \"Hey now, you have given me 3 already!\"")
        -- Halt here so the reward can't be given twice.
        return false  -- legacy return 0: the giver keeps the item
    end
end

-- Quest complete for this slot: armor piece plus all 3 gems.
if armor == 1 and gems == 3 then
    wait(0.2)
    actor:send(tostring(self.name) .. " tells you, \"Excellent intrepid adventurer, you have provided me with all\"")
    actor:send(tostring(self.name) .. " tells you, \"I need in order to reward you with " .. obj_name(entry.reward) .. "!\"")
    wait(0.1)
    local reward = self:spawn_object(math.floor(entry.reward / 100), entry.reward % 100)
    wait(0.1)
    actor:send("<b:yellow>You gain experience!</>")
    for _ = 1, entry.mult do
        actor:award_exp(29880)
    end
    if reward then
        self:command("give " .. bare_name(reward.name) .. " to " .. actor.name)
    end
end
return true$trig$, '8e7962f63ab0e12f4620c31764c24f94'),
  -- data/triggers/554/554_40_warrior_phase_2.lua
  (554, 40, $trig$-- Converted from DG Script #55440: warrior_phase_2
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
--
-- Phase armor turn-in (class and phase specific). Quest vars are keyed by the legacy object
-- vnum, as DG did: phase_armor:<armor vnum>_armor_acquired (1 piece) and
-- phase_armor:<gem vnum>_gems_acquired (3 gems). The zone 556 status scripts read these keys.
-- The runtime fires RECEIVE after the item is already in the mob's hands, so a refusal hands
-- it back with a give command (DG's `return 0`).

local class_ok = false
for _, c in ipairs({"warrior"}) do
    if string.lower(actor.class or "") == c then
        class_ok = true
        break
    end
end

local function obj_name(vnum)
    return objects.template(math.floor(vnum / 100), vnum % 100).name
end

-- Item names carry a leading article ("a rusted helm"); give matches on the bare words.
local function bare_name(name)
    return (string.gsub(string.gsub(name, "^%s*[Tt]he%s+", ""), "^%s*[Aa]n?%s+", ""))
end

if not (class_ok and actor.level >= 21 and actor:get_quest_stage("phase_armor") >= 2) then
    -- not the right class / phase for this questmaster
    self:command("eye " .. tostring(actor.name))
    actor:send(tostring(self.name) .. " tells you, 'I am not interested in this from you.'")
    return false  -- legacy return 0: the giver keeps the item
end

-- Slots for this class: destroyed armor, gem, reward (legacy 5-digit vnums) and exp multiplier.
local slots = {
    {slot = "helm", armor = 55340, gem = 55637, reward = 55412, mult = 7},
    {slot = "arm", armor = 55344, gem = 55648, reward = 55413, mult = 8},
    {slot = "chest", armor = 55352, gem = 55670, reward = 55414, mult = 10},
    {slot = "legs", armor = 55348, gem = 55659, reward = 55415, mult = 9},
    {slot = "boots", armor = 55332, gem = 55615, reward = 55416, mult = 5},
    {slot = "bracer", armor = 55336, gem = 55626, reward = 55417, mult = 6},
    {slot = "gloves", armor = 55328, gem = 55604, reward = 55418, mult = 4},
}

-- DG switch: an armor case falls through into its gem case, so both vnums map to the same slot.
local object_vnum = object.zone_id * 100 + object.id
local entry, is_armor
for _, s in ipairs(slots) do
    if object_vnum == s.armor then
        entry = s
        is_armor = true
        break
    elseif object_vnum == s.gem then
        entry = s
        is_armor = false
        break
    end
end
if not entry then
    self:command("eye " .. tostring(actor.name))
    actor:send(tostring(self.name) .. " tells you, 'I am not interested in this from you.'")
    return false  -- legacy return 0: the giver keeps the item
end

local armor_key = tostring(entry.armor) .. "_armor_acquired"
local gem_key = tostring(entry.gem) .. "_gems_acquired"
local armor = tonumber(actor:get_quest_var("phase_armor:" .. armor_key)) or 0
local gems = tonumber(actor:get_quest_var("phase_armor:" .. gem_key)) or 0

if is_armor then
    if armor < 1 then
        armor = armor + 1
        actor:set_quest_var("phase_armor", armor_key, armor)
        wait(0.2)
        actor:send(tostring(self.name) .. " tells you, \"Hey now. what have we here?!  I've been looking for some of this\"")
        actor:send(tostring(self.name) .. " tells you, \"for quite some time.  You have now given me " .. obj_name(entry.armor) .. ".\"")
        world.destroy(object)
        actor:save()
    else
        self:command("eye " .. tostring(actor.name))
        actor:send(tostring(self.name) .. " tells you, \"Hey now, you have given me " .. obj_name(entry.armor) .. " already!\"")
        -- Halt here so the reward can't be given twice.
        return false  -- legacy return 0: the giver keeps the item
    end
else
    if gems < 3 then
        gems = gems + 1
        actor:set_quest_var("phase_armor", gem_key, gems)
        wait(0.2)
        actor:send(tostring(self.name) .. " tells you, \"Hey, very nice. It is good to see adventurers out conquering the\"")
        actor:send(tostring(self.name) .. " tells you, \"realm.  You have now given me " .. tostring(gems) .. " " .. obj_name(entry.gem) .. ".\"")
        world.destroy(object)
        actor:save()
    else
        self:command("eye " .. tostring(actor.name))
        actor:send(tostring(self.name) .. " tells you, \"Hey now, you have given me 3 already!\"")
        -- Halt here so the reward can't be given twice.
        return false  -- legacy return 0: the giver keeps the item
    end
end

-- Quest complete for this slot: armor piece plus all 3 gems.
if armor == 1 and gems == 3 then
    wait(0.2)
    actor:send(tostring(self.name) .. " tells you, \"Excellent intrepid adventurer, you have provided me with all\"")
    actor:send(tostring(self.name) .. " tells you, \"I need in order to reward you with " .. obj_name(entry.reward) .. "!\"")
    wait(0.1)
    local reward = self:spawn_object(math.floor(entry.reward / 100), entry.reward % 100)
    wait(0.1)
    actor:send("<b:yellow>You gain experience!</>")
    for _ = 1, entry.mult do
        actor:award_exp(29880)
    end
    if reward then
        self:command("give " .. bare_name(reward.name) .. " to " .. actor.name)
    end
end
return true$trig$, 'de743345d61da1eae68edfe685efff04'),
  -- data/triggers/554/554_50_sorcerer_phase_2.lua
  (554, 50, $trig$-- Converted from DG Script #55450: sorcerer_phase_2
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
--
-- Phase armor turn-in (class and phase specific). Quest vars are keyed by the legacy object
-- vnum, as DG did: phase_armor:<armor vnum>_armor_acquired (1 piece) and
-- phase_armor:<gem vnum>_gems_acquired (3 gems). The zone 556 status scripts read these keys.
-- The runtime fires RECEIVE after the item is already in the mob's hands, so a refusal hands
-- it back with a give command (DG's `return 0`).

local class_ok = false
for _, c in ipairs({"sorcerer", "cryomancer", "pyromancer"}) do
    if string.lower(actor.class or "") == c then
        class_ok = true
        break
    end
end

local function obj_name(vnum)
    return objects.template(math.floor(vnum / 100), vnum % 100).name
end

-- Item names carry a leading article ("a rusted helm"); give matches on the bare words.
local function bare_name(name)
    return (string.gsub(string.gsub(name, "^%s*[Tt]he%s+", ""), "^%s*[Aa]n?%s+", ""))
end

if not (class_ok and actor.level >= 21 and actor:get_quest_stage("phase_armor") >= 2) then
    -- not the right class / phase for this questmaster
    self:command("eye " .. tostring(actor.name))
    actor:send(tostring(self.name) .. " tells you, 'I am not interested in this from you.'")
    return false  -- legacy return 0: the giver keeps the item
end

-- Slots for this class: destroyed armor, gem, reward (legacy 5-digit vnums) and exp multiplier.
local slots = {
    {slot = "helm", armor = 55343, gem = 55631, reward = 55475, mult = 7},
    {slot = "arm", armor = 55347, gem = 55646, reward = 55476, mult = 8},
    {slot = "chest", armor = 55355, gem = 55668, reward = 55477, mult = 10},
    {slot = "legs", armor = 55351, gem = 55657, reward = 55478, mult = 9},
    {slot = "boots", armor = 55335, gem = 55613, reward = 55479, mult = 5},
    {slot = "bracer", armor = 55339, gem = 55624, reward = 55480, mult = 6},
    {slot = "gloves", armor = 55331, gem = 55602, reward = 55481, mult = 4},
}

-- DG switch: an armor case falls through into its gem case, so both vnums map to the same slot.
local object_vnum = object.zone_id * 100 + object.id
local entry, is_armor
for _, s in ipairs(slots) do
    if object_vnum == s.armor then
        entry = s
        is_armor = true
        break
    elseif object_vnum == s.gem then
        entry = s
        is_armor = false
        break
    end
end
if not entry then
    self:command("eye " .. tostring(actor.name))
    actor:send(tostring(self.name) .. " tells you, 'I am not interested in this from you.'")
    return false  -- legacy return 0: the giver keeps the item
end

local armor_key = tostring(entry.armor) .. "_armor_acquired"
local gem_key = tostring(entry.gem) .. "_gems_acquired"
local armor = tonumber(actor:get_quest_var("phase_armor:" .. armor_key)) or 0
local gems = tonumber(actor:get_quest_var("phase_armor:" .. gem_key)) or 0

if is_armor then
    if armor < 1 then
        armor = armor + 1
        actor:set_quest_var("phase_armor", armor_key, armor)
        wait(0.2)
        actor:send(tostring(self.name) .. " tells you, \"Hey now. what have we here?!  I've been looking for some of this\"")
        actor:send(tostring(self.name) .. " tells you, \"for quite some time.  You have now given me " .. obj_name(entry.armor) .. ".\"")
        world.destroy(object)
        actor:save()
    else
        self:command("eye " .. tostring(actor.name))
        actor:send(tostring(self.name) .. " tells you, \"Hey now, you have given me " .. obj_name(entry.armor) .. " already!\"")
        -- Halt here so the reward can't be given twice.
        return false  -- legacy return 0: the giver keeps the item
    end
else
    if gems < 3 then
        gems = gems + 1
        actor:set_quest_var("phase_armor", gem_key, gems)
        wait(0.2)
        actor:send(tostring(self.name) .. " tells you, \"Hey, very nice. It is good to see adventurers out conquering the\"")
        actor:send(tostring(self.name) .. " tells you, \"realm.  You have now given me " .. tostring(gems) .. " " .. obj_name(entry.gem) .. ".\"")
        world.destroy(object)
        actor:save()
    else
        self:command("eye " .. tostring(actor.name))
        actor:send(tostring(self.name) .. " tells you, \"Hey now, you have given me 3 already!\"")
        -- Halt here so the reward can't be given twice.
        return false  -- legacy return 0: the giver keeps the item
    end
end

-- Quest complete for this slot: armor piece plus all 3 gems.
if armor == 1 and gems == 3 then
    wait(0.2)
    actor:send(tostring(self.name) .. " tells you, \"Excellent intrepid adventurer, you have provided me with all\"")
    actor:send(tostring(self.name) .. " tells you, \"I need in order to reward you with " .. obj_name(entry.reward) .. "!\"")
    wait(0.1)
    local reward = self:spawn_object(math.floor(entry.reward / 100), entry.reward % 100)
    wait(0.1)
    actor:send("<b:yellow>You gain experience!</>")
    for _ = 1, entry.mult do
        actor:award_exp(29880)
    end
    if reward then
        self:command("give " .. bare_name(reward.name) .. " to " .. actor.name)
    end
end
return true$trig$, 'e1e7e9f70d8f48e0170e87a4a8c3f211'),
  -- data/triggers/554/554_60_anti-paladin_phase_3.lua
  (554, 60, $trig$-- Converted from DG Script #55460: anti-paladin_phase_3
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
--
-- Phase armor turn-in (class and phase specific). Quest vars are keyed by the legacy object
-- vnum, as DG did: phase_armor:<armor vnum>_armor_acquired (1 piece) and
-- phase_armor:<gem vnum>_gems_acquired (3 gems). The zone 556 status scripts read these keys.
-- The runtime fires RECEIVE after the item is already in the mob's hands, so a refusal hands
-- it back with a give command (DG's `return 0`).

local class_ok = false
for _, c in ipairs({"anti-paladin"}) do
    if string.lower(actor.class or "") == c then
        class_ok = true
        break
    end
end

local function obj_name(vnum)
    return objects.template(math.floor(vnum / 100), vnum % 100).name
end

-- Item names carry a leading article ("a rusted helm"); give matches on the bare words.
local function bare_name(name)
    return (string.gsub(string.gsub(name, "^%s*[Tt]he%s+", ""), "^%s*[Aa]n?%s+", ""))
end

if not (class_ok and actor.level >= 41 and actor:get_quest_stage("phase_armor") >= 2) then
    -- not the right class / phase for this questmaster
    self:command("eye " .. tostring(actor.name))
    actor:send(tostring(self.name) .. " tells you, 'I am not interested in this from you.'")
    return false  -- legacy return 0: the giver keeps the item
end

-- Slots for this class: destroyed armor, gem, reward (legacy 5-digit vnums) and exp multiplier.
local slots = {
    {slot = "helm", armor = 55368, gem = 55704, reward = 55503, mult = 11},
    {slot = "arm", armor = 55372, gem = 55715, reward = 55504, mult = 12},
    {slot = "chest", armor = 55380, gem = 55737, reward = 55505, mult = 14},
    {slot = "legs", armor = 55376, gem = 55726, reward = 55506, mult = 13},
    {slot = "boots", armor = 55360, gem = 55682, reward = 55507, mult = 9},
    {slot = "bracer", armor = 55364, gem = 55693, reward = 55508, mult = 10},
    {slot = "gloves", armor = 55356, gem = 55671, reward = 55509, mult = 8},
}

-- DG switch: an armor case falls through into its gem case, so both vnums map to the same slot.
local object_vnum = object.zone_id * 100 + object.id
local entry, is_armor
for _, s in ipairs(slots) do
    if object_vnum == s.armor then
        entry = s
        is_armor = true
        break
    elseif object_vnum == s.gem then
        entry = s
        is_armor = false
        break
    end
end
if not entry then
    self:command("eye " .. tostring(actor.name))
    actor:send(tostring(self.name) .. " tells you, 'I am not interested in this from you.'")
    return false  -- legacy return 0: the giver keeps the item
end

local armor_key = tostring(entry.armor) .. "_armor_acquired"
local gem_key = tostring(entry.gem) .. "_gems_acquired"
local armor = tonumber(actor:get_quest_var("phase_armor:" .. armor_key)) or 0
local gems = tonumber(actor:get_quest_var("phase_armor:" .. gem_key)) or 0

if is_armor then
    if armor < 1 then
        armor = armor + 1
        actor:set_quest_var("phase_armor", armor_key, armor)
        wait(0.2)
        actor:send(tostring(self.name) .. " tells you, \"Hey now. what have we here?!  I've been looking for some of this\"")
        actor:send(tostring(self.name) .. " tells you, \"for quite some time.  You have now given me " .. obj_name(entry.armor) .. ".\"")
        world.destroy(object)
        actor:save()
    else
        self:command("eye " .. tostring(actor.name))
        actor:send(tostring(self.name) .. " tells you, \"Hey now, you have given me " .. obj_name(entry.armor) .. " already!\"")
        -- Halt here so the reward can't be given twice.
        return false  -- legacy return 0: the giver keeps the item
    end
else
    if gems < 3 then
        gems = gems + 1
        actor:set_quest_var("phase_armor", gem_key, gems)
        wait(0.2)
        actor:send(tostring(self.name) .. " tells you, \"Hey, very nice. It is good to see adventurers out conquering the\"")
        actor:send(tostring(self.name) .. " tells you, \"realm.  You have now given me " .. tostring(gems) .. " " .. obj_name(entry.gem) .. ".\"")
        world.destroy(object)
        actor:save()
    else
        self:command("eye " .. tostring(actor.name))
        actor:send(tostring(self.name) .. " tells you, \"Hey now, you have given me 3 already!\"")
        -- Halt here so the reward can't be given twice.
        return false  -- legacy return 0: the giver keeps the item
    end
end

-- Quest complete for this slot: armor piece plus all 3 gems.
if armor == 1 and gems == 3 then
    wait(0.2)
    actor:send(tostring(self.name) .. " tells you, \"Excellent intrepid adventurer, you have provided me with all\"")
    actor:send(tostring(self.name) .. " tells you, \"I need in order to reward you with " .. obj_name(entry.reward) .. "!\"")
    wait(0.1)
    local reward = self:spawn_object(math.floor(entry.reward / 100), entry.reward % 100)
    wait(0.1)
    actor:send("<b:yellow>You gain experience!</>")
    for _ = 1, entry.mult do
        actor:award_exp(42840)
    end
    if reward then
        self:command("give " .. bare_name(reward.name) .. " to " .. actor.name)
    end
end
return true$trig$, 'd143bb42f7a76655540caf37ac24ea08'),
  -- data/triggers/554/554_70_unused.lua
  (554, 70, $trig$-- Converted from DG Script #55470: **UNUSED**
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
--
-- Phase armor turn-in (class and phase specific). Quest vars are keyed by the legacy object
-- vnum, as DG did: phase_armor:<armor vnum>_armor_acquired (1 piece) and
-- phase_armor:<gem vnum>_gems_acquired (3 gems). The zone 556 status scripts read these keys.
-- The runtime fires RECEIVE after the item is already in the mob's hands, so a refusal hands
-- it back with a give command (DG's `return 0`).

local class_ok = false
for _, c in ipairs({"cleric", "priest"}) do
    if string.lower(actor.class or "") == c then
        class_ok = true
        break
    end
end

local function obj_name(vnum)
    return objects.template(math.floor(vnum / 100), vnum % 100).name
end

-- Item names carry a leading article ("a rusted helm"); give matches on the bare words.
local function bare_name(name)
    return (string.gsub(string.gsub(name, "^%s*[Tt]he%s+", ""), "^%s*[Aa]n?%s+", ""))
end

if not (class_ok and actor.level >= 41 and actor:get_quest_stage("phase_armor") >= 2) then
    -- not the right class / phase for this questmaster
    self:command("eye " .. tostring(actor.name))
    actor:send(tostring(self.name) .. " tells you, 'I am not interested in this from you.'")
    return false  -- legacy return 0: the giver keeps the item
end

-- Slots for this class: destroyed armor, gem, reward (legacy 5-digit vnums) and exp multiplier.
local slots = {
    {slot = "helm", armor = 55368, gem = 55711, reward = 55510, mult = 11},
    {slot = "arm", armor = 55372, gem = 55722, reward = 55511, mult = 12},
    {slot = "chest", armor = 55380, gem = 55744, reward = 55512, mult = 14},
    {slot = "legs", armor = 55376, gem = 55733, reward = 55513, mult = 13},
    {slot = "boots", armor = 55360, gem = 55689, reward = 55514, mult = 9},
    {slot = "bracer", armor = 55364, gem = 55700, reward = 55515, mult = 10},
    {slot = "gloves", armor = 55356, gem = 55678, reward = 55516, mult = 8},
}

-- DG switch: an armor case falls through into its gem case, so both vnums map to the same slot.
local object_vnum = object.zone_id * 100 + object.id
local entry, is_armor
for _, s in ipairs(slots) do
    if object_vnum == s.armor then
        entry = s
        is_armor = true
        break
    elseif object_vnum == s.gem then
        entry = s
        is_armor = false
        break
    end
end
if not entry then
    self:command("eye " .. tostring(actor.name))
    actor:send(tostring(self.name) .. " tells you, 'I am not interested in this from you.'")
    return false  -- legacy return 0: the giver keeps the item
end

local armor_key = tostring(entry.armor) .. "_armor_acquired"
local gem_key = tostring(entry.gem) .. "_gems_acquired"
local armor = tonumber(actor:get_quest_var("phase_armor:" .. armor_key)) or 0
local gems = tonumber(actor:get_quest_var("phase_armor:" .. gem_key)) or 0

if is_armor then
    if armor < 1 then
        armor = armor + 1
        actor:set_quest_var("phase_armor", armor_key, armor)
        wait(0.2)
        actor:send(tostring(self.name) .. " tells you, \"Hey now. what have we here?!  I've been looking for some of this\"")
        actor:send(tostring(self.name) .. " tells you, \"for quite some time.  You have now given me " .. obj_name(entry.armor) .. ".\"")
        world.destroy(object)
        actor:save()
    else
        self:command("eye " .. tostring(actor.name))
        actor:send(tostring(self.name) .. " tells you, \"Hey now, you have given me " .. obj_name(entry.armor) .. " already!\"")
        -- Halt here so the reward can't be given twice.
        return false  -- legacy return 0: the giver keeps the item
    end
else
    if gems < 3 then
        gems = gems + 1
        actor:set_quest_var("phase_armor", gem_key, gems)
        wait(0.2)
        actor:send(tostring(self.name) .. " tells you, \"Hey, very nice. It is good to see adventurers out conquering the\"")
        actor:send(tostring(self.name) .. " tells you, \"realm.  You have now given me " .. tostring(gems) .. " " .. obj_name(entry.gem) .. ".\"")
        world.destroy(object)
        actor:save()
    else
        self:command("eye " .. tostring(actor.name))
        actor:send(tostring(self.name) .. " tells you, \"Hey now, you have given me 3 already!\"")
        -- Halt here so the reward can't be given twice.
        return false  -- legacy return 0: the giver keeps the item
    end
end

-- Quest complete for this slot: armor piece plus all 3 gems.
if armor == 1 and gems == 3 then
    wait(0.2)
    actor:send(tostring(self.name) .. " tells you, \"Excellent intrepid adventurer, you have provided me with all\"")
    actor:send(tostring(self.name) .. " tells you, \"I need in order to reward you with " .. obj_name(entry.reward) .. "!\"")
    wait(0.1)
    local reward = self:spawn_object(math.floor(entry.reward / 100), entry.reward % 100)
    wait(0.1)
    actor:send("<b:yellow>You gain experience!</>")
    for _ = 1, entry.mult do
        actor:award_exp(42840)
    end
    if reward then
        self:command("give " .. bare_name(reward.name) .. " to " .. actor.name)
    end
end
return true$trig$, '81acbbc84da22a37d902eeacb64481a4'),
  -- data/triggers/554/554_80_diabolist_phase_3.lua
  (554, 80, $trig$-- Converted from DG Script #55480: diabolist_phase_3
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
--
-- Phase armor turn-in (class and phase specific). Quest vars are keyed by the legacy object
-- vnum, as DG did: phase_armor:<armor vnum>_armor_acquired (1 piece) and
-- phase_armor:<gem vnum>_gems_acquired (3 gems). The zone 556 status scripts read these keys.
-- The runtime fires RECEIVE after the item is already in the mob's hands, so a refusal hands
-- it back with a give command (DG's `return 0`).

local class_ok = false
for _, c in ipairs({"diabolist"}) do
    if string.lower(actor.class or "") == c then
        class_ok = true
        break
    end
end

local function obj_name(vnum)
    return objects.template(math.floor(vnum / 100), vnum % 100).name
end

-- Item names carry a leading article ("a rusted helm"); give matches on the bare words.
local function bare_name(name)
    return (string.gsub(string.gsub(name, "^%s*[Tt]he%s+", ""), "^%s*[Aa]n?%s+", ""))
end

if not (class_ok and actor.level >= 41 and actor:get_quest_stage("phase_armor") >= 2) then
    -- not the right class / phase for this questmaster
    self:command("eye " .. tostring(actor.name))
    actor:send(tostring(self.name) .. " tells you, 'I am not interested in this from you.'")
    return false  -- legacy return 0: the giver keeps the item
end

-- Slots for this class: destroyed armor, gem, reward (legacy 5-digit vnums) and exp multiplier.
local slots = {
    {slot = "helm", armor = 55368, gem = 55705, reward = 55545, mult = 11},
    {slot = "arm", armor = 55372, gem = 55716, reward = 55546, mult = 12},
    {slot = "chest", armor = 55380, gem = 55738, reward = 55547, mult = 14},
    {slot = "legs", armor = 55376, gem = 55727, reward = 55548, mult = 13},
    {slot = "boots", armor = 55360, gem = 55683, reward = 55549, mult = 9},
    {slot = "bracer", armor = 55364, gem = 55694, reward = 55550, mult = 10},
    {slot = "gloves", armor = 55356, gem = 55672, reward = 55551, mult = 8},
}

-- DG switch: an armor case falls through into its gem case, so both vnums map to the same slot.
local object_vnum = object.zone_id * 100 + object.id
local entry, is_armor
for _, s in ipairs(slots) do
    if object_vnum == s.armor then
        entry = s
        is_armor = true
        break
    elseif object_vnum == s.gem then
        entry = s
        is_armor = false
        break
    end
end
if not entry then
    self:command("eye " .. tostring(actor.name))
    actor:send(tostring(self.name) .. " tells you, 'I am not interested in this from you.'")
    return false  -- legacy return 0: the giver keeps the item
end

local armor_key = tostring(entry.armor) .. "_armor_acquired"
local gem_key = tostring(entry.gem) .. "_gems_acquired"
local armor = tonumber(actor:get_quest_var("phase_armor:" .. armor_key)) or 0
local gems = tonumber(actor:get_quest_var("phase_armor:" .. gem_key)) or 0

if is_armor then
    if armor < 1 then
        armor = armor + 1
        actor:set_quest_var("phase_armor", armor_key, armor)
        wait(0.2)
        actor:send(tostring(self.name) .. " tells you, \"Hey now. what have we here?!  I've been looking for some of this\"")
        actor:send(tostring(self.name) .. " tells you, \"for quite some time.  You have now given me " .. obj_name(entry.armor) .. ".\"")
        world.destroy(object)
        actor:save()
    else
        self:command("eye " .. tostring(actor.name))
        actor:send(tostring(self.name) .. " tells you, \"Hey now, you have given me " .. obj_name(entry.armor) .. " already!\"")
        -- Halt here so the reward can't be given twice.
        return false  -- legacy return 0: the giver keeps the item
    end
else
    if gems < 3 then
        gems = gems + 1
        actor:set_quest_var("phase_armor", gem_key, gems)
        wait(0.2)
        actor:send(tostring(self.name) .. " tells you, \"Hey, very nice. It is good to see adventurers out conquering the\"")
        actor:send(tostring(self.name) .. " tells you, \"realm.  You have now given me " .. tostring(gems) .. " " .. obj_name(entry.gem) .. ".\"")
        world.destroy(object)
        actor:save()
    else
        self:command("eye " .. tostring(actor.name))
        actor:send(tostring(self.name) .. " tells you, \"Hey now, you have given me 3 already!\"")
        -- Halt here so the reward can't be given twice.
        return false  -- legacy return 0: the giver keeps the item
    end
end

-- Quest complete for this slot: armor piece plus all 3 gems.
if armor == 1 and gems == 3 then
    wait(0.2)
    actor:send(tostring(self.name) .. " tells you, \"Excellent intrepid adventurer, you have provided me with all\"")
    actor:send(tostring(self.name) .. " tells you, \"I need in order to reward you with " .. obj_name(entry.reward) .. "!\"")
    wait(0.1)
    local reward = self:spawn_object(math.floor(entry.reward / 100), entry.reward % 100)
    wait(0.1)
    actor:send("<b:yellow>You gain experience!</>")
    for _ = 1, entry.mult do
        actor:award_exp(42840)
    end
    if reward then
        self:command("give " .. bare_name(reward.name) .. " to " .. actor.name)
    end
end
return true$trig$, '1940f6f0f2413a43c4f2715cd2996348'),
  -- data/triggers/554/554_90_druid_phase_3.lua
  (554, 90, $trig$-- Converted from DG Script #55490: druid_phase_3
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
--
-- Phase armor turn-in (class and phase specific). Quest vars are keyed by the legacy object
-- vnum, as DG did: phase_armor:<armor vnum>_armor_acquired (1 piece) and
-- phase_armor:<gem vnum>_gems_acquired (3 gems). The zone 556 status scripts read these keys.
-- The runtime fires RECEIVE after the item is already in the mob's hands, so a refusal hands
-- it back with a give command (DG's `return 0`).

local class_ok = false
for _, c in ipairs({"druid"}) do
    if string.lower(actor.class or "") == c then
        class_ok = true
        break
    end
end

local function obj_name(vnum)
    return objects.template(math.floor(vnum / 100), vnum % 100).name
end

-- Item names carry a leading article ("a rusted helm"); give matches on the bare words.
local function bare_name(name)
    return (string.gsub(string.gsub(name, "^%s*[Tt]he%s+", ""), "^%s*[Aa]n?%s+", ""))
end

if not (class_ok and actor.level >= 41 and actor:get_quest_stage("phase_armor") >= 2) then
    -- not the right class / phase for this questmaster
    self:command("eye " .. tostring(actor.name))
    actor:send(tostring(self.name) .. " tells you, 'I am not interested in this from you.'")
    return false  -- legacy return 0: the giver keeps the item
end

-- Slots for this class: destroyed armor, gem, reward (legacy 5-digit vnums) and exp multiplier.
local slots = {
    {slot = "helm", armor = 55370, gem = 55706, reward = 55524, mult = 11},
    {slot = "arm", armor = 55374, gem = 55717, reward = 55525, mult = 12},
    {slot = "chest", armor = 55382, gem = 55739, reward = 55526, mult = 14},
    {slot = "legs", armor = 55378, gem = 55728, reward = 55527, mult = 13},
    {slot = "boots", armor = 55362, gem = 55684, reward = 55528, mult = 9},
    {slot = "bracer", armor = 55366, gem = 55695, reward = 55529, mult = 10},
    {slot = "gloves", armor = 55358, gem = 55673, reward = 55530, mult = 8},
}

-- DG switch: an armor case falls through into its gem case, so both vnums map to the same slot.
local object_vnum = object.zone_id * 100 + object.id
local entry, is_armor
for _, s in ipairs(slots) do
    if object_vnum == s.armor then
        entry = s
        is_armor = true
        break
    elseif object_vnum == s.gem then
        entry = s
        is_armor = false
        break
    end
end
if not entry then
    self:command("eye " .. tostring(actor.name))
    actor:send(tostring(self.name) .. " tells you, 'I am not interested in this from you.'")
    return false  -- legacy return 0: the giver keeps the item
end

local armor_key = tostring(entry.armor) .. "_armor_acquired"
local gem_key = tostring(entry.gem) .. "_gems_acquired"
local armor = tonumber(actor:get_quest_var("phase_armor:" .. armor_key)) or 0
local gems = tonumber(actor:get_quest_var("phase_armor:" .. gem_key)) or 0

if is_armor then
    if armor < 1 then
        armor = armor + 1
        actor:set_quest_var("phase_armor", armor_key, armor)
        wait(0.2)
        actor:send(tostring(self.name) .. " tells you, \"Hey now. what have we here?!  I've been looking for some of this\"")
        actor:send(tostring(self.name) .. " tells you, \"for quite some time.  You have now given me " .. obj_name(entry.armor) .. ".\"")
        world.destroy(object)
        actor:save()
    else
        self:command("eye " .. tostring(actor.name))
        actor:send(tostring(self.name) .. " tells you, \"Hey now, you have given me " .. obj_name(entry.armor) .. " already!\"")
        -- Halt here so the reward can't be given twice.
        return false  -- legacy return 0: the giver keeps the item
    end
else
    if gems < 3 then
        gems = gems + 1
        actor:set_quest_var("phase_armor", gem_key, gems)
        wait(0.2)
        actor:send(tostring(self.name) .. " tells you, \"Hey, very nice. It is good to see adventurers out conquering the\"")
        actor:send(tostring(self.name) .. " tells you, \"realm.  You have now given me " .. tostring(gems) .. " " .. obj_name(entry.gem) .. ".\"")
        world.destroy(object)
        actor:save()
    else
        self:command("eye " .. tostring(actor.name))
        actor:send(tostring(self.name) .. " tells you, \"Hey now, you have given me 3 already!\"")
        -- Halt here so the reward can't be given twice.
        return false  -- legacy return 0: the giver keeps the item
    end
end

-- Quest complete for this slot: armor piece plus all 3 gems.
if armor == 1 and gems == 3 then
    wait(0.2)
    actor:send(tostring(self.name) .. " tells you, \"Excellent intrepid adventurer, you have provided me with all\"")
    actor:send(tostring(self.name) .. " tells you, \"I need in order to reward you with " .. obj_name(entry.reward) .. "!\"")
    wait(0.1)
    local reward = self:spawn_object(math.floor(entry.reward / 100), entry.reward % 100)
    wait(0.1)
    actor:send("<b:yellow>You gain experience!</>")
    for _ = 1, entry.mult do
        actor:award_exp(42840)
    end
    if reward then
        self:command("give " .. bare_name(reward.name) .. " to " .. actor.name)
    end
end
return true$trig$, '691ba6cea66af3362964f4125084240d'),
  -- data/triggers/555/555_00_sorcerer_phase_3.lua
  (555, 0, $trig$-- Converted from DG Script #55500: sorcerer_phase_3
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
--
-- Phase armor turn-in (class and phase specific). Quest vars are keyed by the legacy object
-- vnum, as DG did: phase_armor:<armor vnum>_armor_acquired (1 piece) and
-- phase_armor:<gem vnum>_gems_acquired (3 gems). The zone 556 status scripts read these keys.
-- The runtime fires RECEIVE after the item is already in the mob's hands, so a refusal hands
-- it back with a give command (DG's `return 0`).

local class_ok = false
for _, c in ipairs({"sorcerer", "cryomancer", "pyromancer"}) do
    if string.lower(actor.class or "") == c then
        class_ok = true
        break
    end
end

local function obj_name(vnum)
    return objects.template(math.floor(vnum / 100), vnum % 100).name
end

-- Item names carry a leading article ("a rusted helm"); give matches on the bare words.
local function bare_name(name)
    return (string.gsub(string.gsub(name, "^%s*[Tt]he%s+", ""), "^%s*[Aa]n?%s+", ""))
end

if not (class_ok and actor.level >= 41 and actor:get_quest_stage("phase_armor") >= 2) then
    -- not the right class / phase for this questmaster
    self:command("eye " .. tostring(actor.name))
    actor:send(tostring(self.name) .. " tells you, 'I am not interested in this from you.'")
    return false  -- legacy return 0: the giver keeps the item
end

-- Slots for this class: destroyed armor, gem, reward (legacy 5-digit vnums) and exp multiplier.
local slots = {
    {slot = "helm", armor = 55371, gem = 55712, reward = 55552, mult = 11},
    {slot = "arm", armor = 55375, gem = 55723, reward = 55553, mult = 12},
    {slot = "chest", armor = 55383, gem = 55745, reward = 55554, mult = 14},
    {slot = "legs", armor = 55379, gem = 55734, reward = 55555, mult = 13},
    {slot = "boots", armor = 55363, gem = 55690, reward = 55556, mult = 9},
    {slot = "bracer", armor = 55367, gem = 55701, reward = 55557, mult = 10},
    {slot = "gloves", armor = 55359, gem = 55679, reward = 55558, mult = 8},
}

-- DG switch: an armor case falls through into its gem case, so both vnums map to the same slot.
local object_vnum = object.zone_id * 100 + object.id
local entry, is_armor
for _, s in ipairs(slots) do
    if object_vnum == s.armor then
        entry = s
        is_armor = true
        break
    elseif object_vnum == s.gem then
        entry = s
        is_armor = false
        break
    end
end
if not entry then
    self:command("eye " .. tostring(actor.name))
    actor:send(tostring(self.name) .. " tells you, 'I am not interested in this from you.'")
    return false  -- legacy return 0: the giver keeps the item
end

local armor_key = tostring(entry.armor) .. "_armor_acquired"
local gem_key = tostring(entry.gem) .. "_gems_acquired"
local armor = tonumber(actor:get_quest_var("phase_armor:" .. armor_key)) or 0
local gems = tonumber(actor:get_quest_var("phase_armor:" .. gem_key)) or 0

if is_armor then
    if armor < 1 then
        armor = armor + 1
        actor:set_quest_var("phase_armor", armor_key, armor)
        wait(0.2)
        actor:send(tostring(self.name) .. " tells you, \"Hey now. what have we here?!  I've been looking for some of this\"")
        actor:send(tostring(self.name) .. " tells you, \"for quite some time.  You have now given me " .. obj_name(entry.armor) .. ".\"")
        world.destroy(object)
        actor:save()
    else
        self:command("eye " .. tostring(actor.name))
        actor:send(tostring(self.name) .. " tells you, \"Hey now, you have given me " .. obj_name(entry.armor) .. " already!\"")
        -- Halt here so the reward can't be given twice.
        return false  -- legacy return 0: the giver keeps the item
    end
else
    if gems < 3 then
        gems = gems + 1
        actor:set_quest_var("phase_armor", gem_key, gems)
        wait(0.2)
        actor:send(tostring(self.name) .. " tells you, \"Hey, very nice. It is good to see adventurers out conquering the\"")
        actor:send(tostring(self.name) .. " tells you, \"realm.  You have now given me " .. tostring(gems) .. " " .. obj_name(entry.gem) .. ".\"")
        world.destroy(object)
        actor:save()
    else
        self:command("eye " .. tostring(actor.name))
        actor:send(tostring(self.name) .. " tells you, \"Hey now, you have given me 3 already!\"")
        -- Halt here so the reward can't be given twice.
        return false  -- legacy return 0: the giver keeps the item
    end
end

-- Quest complete for this slot: armor piece plus all 3 gems.
if armor == 1 and gems == 3 then
    wait(0.2)
    actor:send(tostring(self.name) .. " tells you, \"Excellent intrepid adventurer, you have provided me with all\"")
    actor:send(tostring(self.name) .. " tells you, \"I need in order to reward you with " .. obj_name(entry.reward) .. "!\"")
    wait(0.1)
    local reward = self:spawn_object(math.floor(entry.reward / 100), entry.reward % 100)
    wait(0.1)
    actor:send("<b:yellow>You gain experience!</>")
    for _ = 1, entry.mult do
        actor:award_exp(42840)
    end
    if reward then
        self:command("give " .. bare_name(reward.name) .. " to " .. actor.name)
    end
end
return true$trig$, '87fd988ed036ed1bd013c0a0d270ee23'),
  -- data/triggers/555/555_10_monk_phase_3.lua
  (555, 10, $trig$-- Converted from DG Script #55510: monk_phase_3
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
--
-- Phase armor turn-in (class and phase specific). Quest vars are keyed by the legacy object
-- vnum, as DG did: phase_armor:<armor vnum>_armor_acquired (1 piece) and
-- phase_armor:<gem vnum>_gems_acquired (3 gems). The zone 556 status scripts read these keys.
-- The runtime fires RECEIVE after the item is already in the mob's hands, so a refusal hands
-- it back with a give command (DG's `return 0`).

local class_ok = false
for _, c in ipairs({"monk"}) do
    if string.lower(actor.class or "") == c then
        class_ok = true
        break
    end
end

local function obj_name(vnum)
    return objects.template(math.floor(vnum / 100), vnum % 100).name
end

-- Item names carry a leading article ("a rusted helm"); give matches on the bare words.
local function bare_name(name)
    return (string.gsub(string.gsub(name, "^%s*[Tt]he%s+", ""), "^%s*[Aa]n?%s+", ""))
end

if not (class_ok and actor.level >= 41 and actor:get_quest_stage("phase_armor") >= 2) then
    -- not the right class / phase for this questmaster
    self:command("eye " .. tostring(actor.name))
    actor:send(tostring(self.name) .. " tells you, 'I am not interested in this from you.'")
    return false  -- legacy return 0: the giver keeps the item
end

-- Slots for this class: destroyed armor, gem, reward (legacy 5-digit vnums) and exp multiplier.
local slots = {
    {slot = "helm", armor = 55370, gem = 55707, reward = 55538, mult = 11},
    {slot = "arm", armor = 55374, gem = 55718, reward = 55539, mult = 12},
    {slot = "chest", armor = 55382, gem = 55740, reward = 55540, mult = 14},
    {slot = "legs", armor = 55378, gem = 55729, reward = 55541, mult = 13},
    {slot = "boots", armor = 55362, gem = 55685, reward = 55542, mult = 9},
    {slot = "bracer", armor = 55366, gem = 55696, reward = 55543, mult = 10},
    {slot = "gloves", armor = 55358, gem = 55674, reward = 55544, mult = 8},
}

-- DG switch: an armor case falls through into its gem case, so both vnums map to the same slot.
local object_vnum = object.zone_id * 100 + object.id
local entry, is_armor
for _, s in ipairs(slots) do
    if object_vnum == s.armor then
        entry = s
        is_armor = true
        break
    elseif object_vnum == s.gem then
        entry = s
        is_armor = false
        break
    end
end
if not entry then
    self:command("eye " .. tostring(actor.name))
    actor:send(tostring(self.name) .. " tells you, 'I am not interested in this from you.'")
    return false  -- legacy return 0: the giver keeps the item
end

local armor_key = tostring(entry.armor) .. "_armor_acquired"
local gem_key = tostring(entry.gem) .. "_gems_acquired"
local armor = tonumber(actor:get_quest_var("phase_armor:" .. armor_key)) or 0
local gems = tonumber(actor:get_quest_var("phase_armor:" .. gem_key)) or 0

if is_armor then
    if armor < 1 then
        armor = armor + 1
        actor:set_quest_var("phase_armor", armor_key, armor)
        wait(0.2)
        actor:send(tostring(self.name) .. " tells you, \"Hey now. what have we here?!  I've been looking for some of this\"")
        actor:send(tostring(self.name) .. " tells you, \"for quite some time.  You have now given me " .. obj_name(entry.armor) .. ".\"")
        world.destroy(object)
        actor:save()
    else
        self:command("eye " .. tostring(actor.name))
        actor:send(tostring(self.name) .. " tells you, \"Hey now, you have given me " .. obj_name(entry.armor) .. " already!\"")
        -- Halt here so the reward can't be given twice.
        return false  -- legacy return 0: the giver keeps the item
    end
else
    if gems < 3 then
        gems = gems + 1
        actor:set_quest_var("phase_armor", gem_key, gems)
        wait(0.2)
        actor:send(tostring(self.name) .. " tells you, \"Hey, very nice. It is good to see adventurers out conquering the\"")
        actor:send(tostring(self.name) .. " tells you, \"realm.  You have now given me " .. tostring(gems) .. " " .. obj_name(entry.gem) .. ".\"")
        world.destroy(object)
        actor:save()
    else
        self:command("eye " .. tostring(actor.name))
        actor:send(tostring(self.name) .. " tells you, \"Hey now, you have given me 3 already!\"")
        -- Halt here so the reward can't be given twice.
        return false  -- legacy return 0: the giver keeps the item
    end
end

-- Quest complete for this slot: armor piece plus all 3 gems.
if armor == 1 and gems == 3 then
    wait(0.2)
    actor:send(tostring(self.name) .. " tells you, \"Excellent intrepid adventurer, you have provided me with all\"")
    actor:send(tostring(self.name) .. " tells you, \"I need in order to reward you with " .. obj_name(entry.reward) .. "!\"")
    wait(0.1)
    local reward = self:spawn_object(math.floor(entry.reward / 100), entry.reward % 100)
    wait(0.1)
    actor:send("<b:yellow>You gain experience!</>")
    for _ = 1, entry.mult do
        actor:award_exp(42840)
    end
    if reward then
        self:command("give " .. bare_name(reward.name) .. " to " .. actor.name)
    end
end
return true$trig$, '921bede621105c0b7fcba8e58cfd9d20'),
  -- data/triggers/555/555_20_necromancer_phase_3.lua
  (555, 20, $trig$-- Converted from DG Script #55520: necromancer_phase_3
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
--
-- Phase armor turn-in (class and phase specific). Quest vars are keyed by the legacy object
-- vnum, as DG did: phase_armor:<armor vnum>_armor_acquired (1 piece) and
-- phase_armor:<gem vnum>_gems_acquired (3 gems). The zone 556 status scripts read these keys.
-- The runtime fires RECEIVE after the item is already in the mob's hands, so a refusal hands
-- it back with a give command (DG's `return 0`).

local class_ok = false
for _, c in ipairs({"necromancer"}) do
    if string.lower(actor.class or "") == c then
        class_ok = true
        break
    end
end

local function obj_name(vnum)
    return objects.template(math.floor(vnum / 100), vnum % 100).name
end

-- Item names carry a leading article ("a rusted helm"); give matches on the bare words.
local function bare_name(name)
    return (string.gsub(string.gsub(name, "^%s*[Tt]he%s+", ""), "^%s*[Aa]n?%s+", ""))
end

if not (class_ok and actor.level >= 41 and actor:get_quest_stage("phase_armor") >= 2) then
    -- not the right class / phase for this questmaster
    self:command("eye " .. tostring(actor.name))
    actor:send(tostring(self.name) .. " tells you, 'I am not interested in this from you.'")
    return false  -- legacy return 0: the giver keeps the item
end

-- Slots for this class: destroyed armor, gem, reward (legacy 5-digit vnums) and exp multiplier.
local slots = {
    {slot = "helm", armor = 55371, gem = 55708, reward = 55531, mult = 11},
    {slot = "arm", armor = 55375, gem = 55719, reward = 55532, mult = 12},
    {slot = "chest", armor = 55383, gem = 55741, reward = 55533, mult = 14},
    {slot = "legs", armor = 55379, gem = 55730, reward = 55534, mult = 13},
    {slot = "boots", armor = 55363, gem = 55686, reward = 55535, mult = 9},
    {slot = "bracer", armor = 55367, gem = 55697, reward = 55536, mult = 10},
    {slot = "gloves", armor = 55359, gem = 55675, reward = 55537, mult = 8},
}

-- DG switch: an armor case falls through into its gem case, so both vnums map to the same slot.
local object_vnum = object.zone_id * 100 + object.id
local entry, is_armor
for _, s in ipairs(slots) do
    if object_vnum == s.armor then
        entry = s
        is_armor = true
        break
    elseif object_vnum == s.gem then
        entry = s
        is_armor = false
        break
    end
end
if not entry then
    self:command("eye " .. tostring(actor.name))
    actor:send(tostring(self.name) .. " tells you, 'I am not interested in this from you.'")
    return false  -- legacy return 0: the giver keeps the item
end

local armor_key = tostring(entry.armor) .. "_armor_acquired"
local gem_key = tostring(entry.gem) .. "_gems_acquired"
local armor = tonumber(actor:get_quest_var("phase_armor:" .. armor_key)) or 0
local gems = tonumber(actor:get_quest_var("phase_armor:" .. gem_key)) or 0

if is_armor then
    if armor < 1 then
        armor = armor + 1
        actor:set_quest_var("phase_armor", armor_key, armor)
        wait(0.2)
        actor:send(tostring(self.name) .. " tells you, \"Hey now. what have we here?!  I've been looking for some of this\"")
        actor:send(tostring(self.name) .. " tells you, \"for quite some time.  You have now given me " .. obj_name(entry.armor) .. ".\"")
        world.destroy(object)
        actor:save()
    else
        self:command("eye " .. tostring(actor.name))
        actor:send(tostring(self.name) .. " tells you, \"Hey now, you have given me " .. obj_name(entry.armor) .. " already!\"")
        -- Halt here so the reward can't be given twice.
        return false  -- legacy return 0: the giver keeps the item
    end
else
    if gems < 3 then
        gems = gems + 1
        actor:set_quest_var("phase_armor", gem_key, gems)
        wait(0.2)
        actor:send(tostring(self.name) .. " tells you, \"Hey, very nice. It is good to see adventurers out conquering the\"")
        actor:send(tostring(self.name) .. " tells you, \"realm.  You have now given me " .. tostring(gems) .. " " .. obj_name(entry.gem) .. ".\"")
        world.destroy(object)
        actor:save()
    else
        self:command("eye " .. tostring(actor.name))
        actor:send(tostring(self.name) .. " tells you, \"Hey now, you have given me 3 already!\"")
        -- Halt here so the reward can't be given twice.
        return false  -- legacy return 0: the giver keeps the item
    end
end

-- Quest complete for this slot: armor piece plus all 3 gems.
if armor == 1 and gems == 3 then
    wait(0.2)
    actor:send(tostring(self.name) .. " tells you, \"Excellent intrepid adventurer, you have provided me with all\"")
    actor:send(tostring(self.name) .. " tells you, \"I need in order to reward you with " .. obj_name(entry.reward) .. "!\"")
    wait(0.1)
    local reward = self:spawn_object(math.floor(entry.reward / 100), entry.reward % 100)
    wait(0.1)
    actor:send("<b:yellow>You gain experience!</>")
    for _ = 1, entry.mult do
        actor:award_exp(42840)
    end
    if reward then
        self:command("give " .. bare_name(reward.name) .. " to " .. actor.name)
    end
end
return true$trig$, '3893c713e3ee6cb845aa164fe4e56881'),
  -- data/triggers/555/555_30_paladin_phase_3.lua
  (555, 30, $trig$-- Converted from DG Script #55530: paladin_phase_3
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
--
-- Phase armor turn-in (class and phase specific). Quest vars are keyed by the legacy object
-- vnum, as DG did: phase_armor:<armor vnum>_armor_acquired (1 piece) and
-- phase_armor:<gem vnum>_gems_acquired (3 gems). The zone 556 status scripts read these keys.
-- The runtime fires RECEIVE after the item is already in the mob's hands, so a refusal hands
-- it back with a give command (DG's `return 0`).

local class_ok = false
for _, c in ipairs({"paladin"}) do
    if string.lower(actor.class or "") == c then
        class_ok = true
        break
    end
end

local function obj_name(vnum)
    return objects.template(math.floor(vnum / 100), vnum % 100).name
end

-- Item names carry a leading article ("a rusted helm"); give matches on the bare words.
local function bare_name(name)
    return (string.gsub(string.gsub(name, "^%s*[Tt]he%s+", ""), "^%s*[Aa]n?%s+", ""))
end

if not (class_ok and actor.level >= 41 and actor:get_quest_stage("phase_armor") >= 2) then
    -- not the right class / phase for this questmaster
    self:command("eye " .. tostring(actor.name))
    actor:send(tostring(self.name) .. " tells you, 'I am not interested in this from you.'")
    return false  -- legacy return 0: the giver keeps the item
end

-- Slots for this class: destroyed armor, gem, reward (legacy 5-digit vnums) and exp multiplier.
local slots = {
    {slot = "helm", armor = 55368, gem = 55709, reward = 55496, mult = 11},
    {slot = "arm", armor = 55372, gem = 55720, reward = 55497, mult = 12},
    {slot = "chest", armor = 55380, gem = 55742, reward = 55498, mult = 14},
    {slot = "legs", armor = 55376, gem = 55731, reward = 55499, mult = 13},
    {slot = "boots", armor = 55360, gem = 55687, reward = 55500, mult = 9},
    {slot = "bracer", armor = 55364, gem = 55698, reward = 55501, mult = 10},
    {slot = "gloves", armor = 55356, gem = 55676, reward = 55502, mult = 8},
}

-- DG switch: an armor case falls through into its gem case, so both vnums map to the same slot.
local object_vnum = object.zone_id * 100 + object.id
local entry, is_armor
for _, s in ipairs(slots) do
    if object_vnum == s.armor then
        entry = s
        is_armor = true
        break
    elseif object_vnum == s.gem then
        entry = s
        is_armor = false
        break
    end
end
if not entry then
    self:command("eye " .. tostring(actor.name))
    actor:send(tostring(self.name) .. " tells you, 'I am not interested in this from you.'")
    return false  -- legacy return 0: the giver keeps the item
end

local armor_key = tostring(entry.armor) .. "_armor_acquired"
local gem_key = tostring(entry.gem) .. "_gems_acquired"
local armor = tonumber(actor:get_quest_var("phase_armor:" .. armor_key)) or 0
local gems = tonumber(actor:get_quest_var("phase_armor:" .. gem_key)) or 0

if is_armor then
    if armor < 1 then
        armor = armor + 1
        actor:set_quest_var("phase_armor", armor_key, armor)
        wait(0.2)
        actor:send(tostring(self.name) .. " tells you, \"Hey now. what have we here?!  I've been looking for some of this\"")
        actor:send(tostring(self.name) .. " tells you, \"for quite some time.  You have now given me " .. obj_name(entry.armor) .. ".\"")
        world.destroy(object)
        actor:save()
    else
        self:command("eye " .. tostring(actor.name))
        actor:send(tostring(self.name) .. " tells you, \"Hey now, you have given me " .. obj_name(entry.armor) .. " already!\"")
        -- Halt here so the reward can't be given twice.
        return false  -- legacy return 0: the giver keeps the item
    end
else
    if gems < 3 then
        gems = gems + 1
        actor:set_quest_var("phase_armor", gem_key, gems)
        wait(0.2)
        actor:send(tostring(self.name) .. " tells you, \"Hey, very nice. It is good to see adventurers out conquering the\"")
        actor:send(tostring(self.name) .. " tells you, \"realm.  You have now given me " .. tostring(gems) .. " " .. obj_name(entry.gem) .. ".\"")
        world.destroy(object)
        actor:save()
    else
        self:command("eye " .. tostring(actor.name))
        actor:send(tostring(self.name) .. " tells you, \"Hey now, you have given me 3 already!\"")
        -- Halt here so the reward can't be given twice.
        return false  -- legacy return 0: the giver keeps the item
    end
end

-- Quest complete for this slot: armor piece plus all 3 gems.
if armor == 1 and gems == 3 then
    wait(0.2)
    actor:send(tostring(self.name) .. " tells you, \"Excellent intrepid adventurer, you have provided me with all\"")
    actor:send(tostring(self.name) .. " tells you, \"I need in order to reward you with " .. obj_name(entry.reward) .. "!\"")
    wait(0.1)
    local reward = self:spawn_object(math.floor(entry.reward / 100), entry.reward % 100)
    wait(0.1)
    actor:send("<b:yellow>You gain experience!</>")
    for _ = 1, entry.mult do
        actor:award_exp(42840)
    end
    if reward then
        self:command("give " .. bare_name(reward.name) .. " to " .. actor.name)
    end
end
return true$trig$, 'd347e06439c64ab29dfb89a1a7593f64'),
  -- data/triggers/555/555_40_ranger_phase_3.lua
  (555, 40, $trig$-- Converted from DG Script #55540: ranger_phase_3
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
--
-- Phase armor turn-in (class and phase specific). Quest vars are keyed by the legacy object
-- vnum, as DG did: phase_armor:<armor vnum>_armor_acquired (1 piece) and
-- phase_armor:<gem vnum>_gems_acquired (3 gems). The zone 556 status scripts read these keys.
-- The runtime fires RECEIVE after the item is already in the mob's hands, so a refusal hands
-- it back with a give command (DG's `return 0`).

local class_ok = false
for _, c in ipairs({"ranger"}) do
    if string.lower(actor.class or "") == c then
        class_ok = true
        break
    end
end

local function obj_name(vnum)
    return objects.template(math.floor(vnum / 100), vnum % 100).name
end

-- Item names carry a leading article ("a rusted helm"); give matches on the bare words.
local function bare_name(name)
    return (string.gsub(string.gsub(name, "^%s*[Tt]he%s+", ""), "^%s*[Aa]n?%s+", ""))
end

if not (class_ok and actor.level >= 41 and actor:get_quest_stage("phase_armor") >= 2) then
    -- not the right class / phase for this questmaster
    self:command("eye " .. tostring(actor.name))
    actor:send(tostring(self.name) .. " tells you, 'I am not interested in this from you.'")
    return false  -- legacy return 0: the giver keeps the item
end

-- Slots for this class: destroyed armor, gem, reward (legacy 5-digit vnums) and exp multiplier.
local slots = {
    {slot = "helm", armor = 55369, gem = 55710, reward = 55517, mult = 11},
    {slot = "arm", armor = 55373, gem = 55721, reward = 55518, mult = 12},
    {slot = "chest", armor = 55381, gem = 55743, reward = 55519, mult = 14},
    {slot = "legs", armor = 55377, gem = 55732, reward = 55520, mult = 13},
    {slot = "boots", armor = 55361, gem = 55688, reward = 55521, mult = 9},
    {slot = "bracer", armor = 55365, gem = 55699, reward = 55522, mult = 10},
    {slot = "gloves", armor = 55357, gem = 55677, reward = 55523, mult = 8},
}

-- DG switch: an armor case falls through into its gem case, so both vnums map to the same slot.
local object_vnum = object.zone_id * 100 + object.id
local entry, is_armor
for _, s in ipairs(slots) do
    if object_vnum == s.armor then
        entry = s
        is_armor = true
        break
    elseif object_vnum == s.gem then
        entry = s
        is_armor = false
        break
    end
end
if not entry then
    self:command("eye " .. tostring(actor.name))
    actor:send(tostring(self.name) .. " tells you, 'I am not interested in this from you.'")
    return false  -- legacy return 0: the giver keeps the item
end

local armor_key = tostring(entry.armor) .. "_armor_acquired"
local gem_key = tostring(entry.gem) .. "_gems_acquired"
local armor = tonumber(actor:get_quest_var("phase_armor:" .. armor_key)) or 0
local gems = tonumber(actor:get_quest_var("phase_armor:" .. gem_key)) or 0

if is_armor then
    if armor < 1 then
        armor = armor + 1
        actor:set_quest_var("phase_armor", armor_key, armor)
        wait(0.2)
        actor:send(tostring(self.name) .. " tells you, \"Hey now. what have we here?!  I've been looking for some of this\"")
        actor:send(tostring(self.name) .. " tells you, \"for quite some time.  You have now given me " .. obj_name(entry.armor) .. ".\"")
        world.destroy(object)
        actor:save()
    else
        self:command("eye " .. tostring(actor.name))
        actor:send(tostring(self.name) .. " tells you, \"Hey now, you have given me " .. obj_name(entry.armor) .. " already!\"")
        -- Halt here so the reward can't be given twice.
        return false  -- legacy return 0: the giver keeps the item
    end
else
    if gems < 3 then
        gems = gems + 1
        actor:set_quest_var("phase_armor", gem_key, gems)
        wait(0.2)
        actor:send(tostring(self.name) .. " tells you, \"Hey, very nice. It is good to see adventurers out conquering the\"")
        actor:send(tostring(self.name) .. " tells you, \"realm.  You have now given me " .. tostring(gems) .. " " .. obj_name(entry.gem) .. ".\"")
        world.destroy(object)
        actor:save()
    else
        self:command("eye " .. tostring(actor.name))
        actor:send(tostring(self.name) .. " tells you, \"Hey now, you have given me 3 already!\"")
        -- Halt here so the reward can't be given twice.
        return false  -- legacy return 0: the giver keeps the item
    end
end

-- Quest complete for this slot: armor piece plus all 3 gems.
if armor == 1 and gems == 3 then
    wait(0.2)
    actor:send(tostring(self.name) .. " tells you, \"Excellent intrepid adventurer, you have provided me with all\"")
    actor:send(tostring(self.name) .. " tells you, \"I need in order to reward you with " .. obj_name(entry.reward) .. "!\"")
    wait(0.1)
    local reward = self:spawn_object(math.floor(entry.reward / 100), entry.reward % 100)
    wait(0.1)
    actor:send("<b:yellow>You gain experience!</>")
    for _ = 1, entry.mult do
        actor:award_exp(42840)
    end
    if reward then
        self:command("give " .. bare_name(reward.name) .. " to " .. actor.name)
    end
end
return true$trig$, '18de8ab5f467951d045a50f2a7efe050'),
  -- data/triggers/555/555_50_rogue_phase_3.lua
  (555, 50, $trig$-- Converted from DG Script #55550: rogue_phase_3
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
--
-- Phase armor turn-in (class and phase specific). Quest vars are keyed by the legacy object
-- vnum, as DG did: phase_armor:<armor vnum>_armor_acquired (1 piece) and
-- phase_armor:<gem vnum>_gems_acquired (3 gems). The zone 556 status scripts read these keys.
-- The runtime fires RECEIVE after the item is already in the mob's hands, so a refusal hands
-- it back with a give command (DG's `return 0`).

local class_ok = false
for _, c in ipairs({"rogue", "thief", "assassin", "mercenary"}) do
    if string.lower(actor.class or "") == c then
        class_ok = true
        break
    end
end

local function obj_name(vnum)
    return objects.template(math.floor(vnum / 100), vnum % 100).name
end

-- Item names carry a leading article ("a rusted helm"); give matches on the bare words.
local function bare_name(name)
    return (string.gsub(string.gsub(name, "^%s*[Tt]he%s+", ""), "^%s*[Aa]n?%s+", ""))
end

if not (class_ok and actor.level >= 41 and actor:get_quest_stage("phase_armor") >= 2) then
    -- not the right class / phase for this questmaster
    self:command("eye " .. tostring(actor.name))
    actor:send(tostring(self.name) .. " tells you, 'I am not interested in this from you.'")
    return false  -- legacy return 0: the giver keeps the item
end

-- Slots for this class: destroyed armor, gem, reward (legacy 5-digit vnums) and exp multiplier.
local slots = {
    {slot = "helm", armor = 55369, gem = 55713, reward = 55559, mult = 11},
    {slot = "arm", armor = 55373, gem = 55724, reward = 55560, mult = 12},
    {slot = "chest", armor = 55381, gem = 55746, reward = 55561, mult = 14},
    {slot = "legs", armor = 55377, gem = 55735, reward = 55562, mult = 13},
    {slot = "boots", armor = 55361, gem = 55691, reward = 55563, mult = 9},
    {slot = "bracer", armor = 55365, gem = 55702, reward = 55564, mult = 10},
    {slot = "gloves", armor = 55357, gem = 55680, reward = 55565, mult = 8},
}

-- DG switch: an armor case falls through into its gem case, so both vnums map to the same slot.
local object_vnum = object.zone_id * 100 + object.id
local entry, is_armor
for _, s in ipairs(slots) do
    if object_vnum == s.armor then
        entry = s
        is_armor = true
        break
    elseif object_vnum == s.gem then
        entry = s
        is_armor = false
        break
    end
end
if not entry then
    self:command("eye " .. tostring(actor.name))
    actor:send(tostring(self.name) .. " tells you, 'I am not interested in this from you.'")
    return false  -- legacy return 0: the giver keeps the item
end

local armor_key = tostring(entry.armor) .. "_armor_acquired"
local gem_key = tostring(entry.gem) .. "_gems_acquired"
local armor = tonumber(actor:get_quest_var("phase_armor:" .. armor_key)) or 0
local gems = tonumber(actor:get_quest_var("phase_armor:" .. gem_key)) or 0

if is_armor then
    if armor < 1 then
        armor = armor + 1
        actor:set_quest_var("phase_armor", armor_key, armor)
        wait(0.2)
        actor:send(tostring(self.name) .. " tells you, \"Hey now. what have we here?!  I've been looking for some of this\"")
        actor:send(tostring(self.name) .. " tells you, \"for quite some time.  You have now given me " .. obj_name(entry.armor) .. ".\"")
        world.destroy(object)
        actor:save()
    else
        self:command("eye " .. tostring(actor.name))
        actor:send(tostring(self.name) .. " tells you, \"Hey now, you have given me " .. obj_name(entry.armor) .. " already!\"")
        -- Halt here so the reward can't be given twice.
        return false  -- legacy return 0: the giver keeps the item
    end
else
    if gems < 3 then
        gems = gems + 1
        actor:set_quest_var("phase_armor", gem_key, gems)
        wait(0.2)
        actor:send(tostring(self.name) .. " tells you, \"Hey, very nice. It is good to see adventurers out conquering the\"")
        actor:send(tostring(self.name) .. " tells you, \"realm.  You have now given me " .. tostring(gems) .. " " .. obj_name(entry.gem) .. ".\"")
        world.destroy(object)
        actor:save()
    else
        self:command("eye " .. tostring(actor.name))
        actor:send(tostring(self.name) .. " tells you, \"Hey now, you have given me 3 already!\"")
        -- Halt here so the reward can't be given twice.
        return false  -- legacy return 0: the giver keeps the item
    end
end

-- Quest complete for this slot: armor piece plus all 3 gems.
if armor == 1 and gems == 3 then
    wait(0.2)
    actor:send(tostring(self.name) .. " tells you, \"Excellent intrepid adventurer, you have provided me with all\"")
    actor:send(tostring(self.name) .. " tells you, \"I need in order to reward you with " .. obj_name(entry.reward) .. "!\"")
    wait(0.1)
    local reward = self:spawn_object(math.floor(entry.reward / 100), entry.reward % 100)
    wait(0.1)
    actor:send("<b:yellow>You gain experience!</>")
    for _ = 1, entry.mult do
        actor:award_exp(42840)
    end
    if reward then
        self:command("give " .. bare_name(reward.name) .. " to " .. actor.name)
    end
end
return true$trig$, '1eec03b3bda716e67062132aebe859d7'),
  -- data/triggers/555/555_60_warrior_phase_3.lua
  (555, 60, $trig$-- Converted from DG Script #55560: warrior_phase_3
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
--
-- Phase armor turn-in (class and phase specific). Quest vars are keyed by the legacy object
-- vnum, as DG did: phase_armor:<armor vnum>_armor_acquired (1 piece) and
-- phase_armor:<gem vnum>_gems_acquired (3 gems). The zone 556 status scripts read these keys.
-- The runtime fires RECEIVE after the item is already in the mob's hands, so a refusal hands
-- it back with a give command (DG's `return 0`).

local class_ok = false
for _, c in ipairs({"warrior"}) do
    if string.lower(actor.class or "") == c then
        class_ok = true
        break
    end
end

local function obj_name(vnum)
    return objects.template(math.floor(vnum / 100), vnum % 100).name
end

-- Item names carry a leading article ("a rusted helm"); give matches on the bare words.
local function bare_name(name)
    return (string.gsub(string.gsub(name, "^%s*[Tt]he%s+", ""), "^%s*[Aa]n?%s+", ""))
end

if not (class_ok and actor.level >= 41 and actor:get_quest_stage("phase_armor") >= 2) then
    -- not the right class / phase for this questmaster
    self:command("eye " .. tostring(actor.name))
    actor:send(tostring(self.name) .. " tells you, 'I am not interested in this from you.'")
    return false  -- legacy return 0: the giver keeps the item
end

-- Slots for this class: destroyed armor, gem, reward (legacy 5-digit vnums) and exp multiplier.
local slots = {
    {slot = "helm", armor = 55368, gem = 55714, reward = 55489, mult = 11},
    {slot = "arm", armor = 55372, gem = 55725, reward = 55490, mult = 12},
    {slot = "chest", armor = 55380, gem = 55747, reward = 55491, mult = 14},
    {slot = "legs", armor = 55376, gem = 55736, reward = 55492, mult = 13},
    {slot = "boots", armor = 55360, gem = 55692, reward = 55493, mult = 9},
    {slot = "bracer", armor = 55364, gem = 55703, reward = 55494, mult = 10},
    {slot = "gloves", armor = 55356, gem = 55681, reward = 55495, mult = 8},
}

-- DG switch: an armor case falls through into its gem case, so both vnums map to the same slot.
local object_vnum = object.zone_id * 100 + object.id
local entry, is_armor
for _, s in ipairs(slots) do
    if object_vnum == s.armor then
        entry = s
        is_armor = true
        break
    elseif object_vnum == s.gem then
        entry = s
        is_armor = false
        break
    end
end
if not entry then
    self:command("eye " .. tostring(actor.name))
    actor:send(tostring(self.name) .. " tells you, 'I am not interested in this from you.'")
    return false  -- legacy return 0: the giver keeps the item
end

local armor_key = tostring(entry.armor) .. "_armor_acquired"
local gem_key = tostring(entry.gem) .. "_gems_acquired"
local armor = tonumber(actor:get_quest_var("phase_armor:" .. armor_key)) or 0
local gems = tonumber(actor:get_quest_var("phase_armor:" .. gem_key)) or 0

if is_armor then
    if armor < 1 then
        armor = armor + 1
        actor:set_quest_var("phase_armor", armor_key, armor)
        wait(0.2)
        actor:send(tostring(self.name) .. " tells you, \"Hey now. what have we here?!  I've been looking for some of this\"")
        actor:send(tostring(self.name) .. " tells you, \"for quite some time.  You have now given me " .. obj_name(entry.armor) .. ".\"")
        world.destroy(object)
        actor:save()
    else
        self:command("eye " .. tostring(actor.name))
        actor:send(tostring(self.name) .. " tells you, \"Hey now, you have given me " .. obj_name(entry.armor) .. " already!\"")
        -- Halt here so the reward can't be given twice.
        return false  -- legacy return 0: the giver keeps the item
    end
else
    if gems < 3 then
        gems = gems + 1
        actor:set_quest_var("phase_armor", gem_key, gems)
        wait(0.2)
        actor:send(tostring(self.name) .. " tells you, \"Hey, very nice. It is good to see adventurers out conquering the\"")
        actor:send(tostring(self.name) .. " tells you, \"realm.  You have now given me " .. tostring(gems) .. " " .. obj_name(entry.gem) .. ".\"")
        world.destroy(object)
        actor:save()
    else
        self:command("eye " .. tostring(actor.name))
        actor:send(tostring(self.name) .. " tells you, \"Hey now, you have given me 3 already!\"")
        -- Halt here so the reward can't be given twice.
        return false  -- legacy return 0: the giver keeps the item
    end
end

-- Quest complete for this slot: armor piece plus all 3 gems.
if armor == 1 and gems == 3 then
    wait(0.2)
    actor:send(tostring(self.name) .. " tells you, \"Excellent intrepid adventurer, you have provided me with all\"")
    actor:send(tostring(self.name) .. " tells you, \"I need in order to reward you with " .. obj_name(entry.reward) .. "!\"")
    wait(0.1)
    local reward = self:spawn_object(math.floor(entry.reward / 100), entry.reward % 100)
    wait(0.1)
    actor:send("<b:yellow>You gain experience!</>")
    for _ = 1, entry.mult do
        actor:award_exp(42840)
    end
    if reward then
        self:command("give " .. bare_name(reward.name) .. " to " .. actor.name)
    end
end
return true$trig$, 'f670b3c8509e37170dcdccaa7f1d49a8')
) AS v(zone_id, id, commands, old_md5)
WHERE t.zone_id = v.zone_id
  AND t.id = v.id
  AND md5(t.commands) = v.old_md5
  AND t.commands IS DISTINCT FROM v.commands;

COMMIT;
