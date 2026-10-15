-- Wand and mace quest chains, end to end (DG #300-#327 and the crafters' greet/refuse scripts): vnum to (zone, id) through the new dg script library (zone 2 holds vnums 200-399), DG truthiness for task flags reset to 0, explicit gives (the give command has no give all), the imbue/play/dig/attack-counter/death links, the Black Legion quest name and variables in lower case. Guarded on the md5 of the bodies at 70a1339 (= prod post-70a1339), so rows edited in Muditor since are left alone. The dg library is inserted first (ON CONFLICT DO NOTHING).
--
-- Idempotent: a row already holding the new body is left alone, so rerunning
-- updates nothing. Keyed by the composite primary key (zone_id, id).
-- Guarded: a row is only touched while it still holds the previous committed
-- body (md5), so rows edited in Muditor since then are left alone.

BEGIN;

-- The "dg" script library (data/script_libraries/dg.lua, the body `fierylib seed script-libraries`
-- would write): require("dg") in the scripts below. ON CONFLICT DO NOTHING keeps a library of that
-- name that is already there, so rerunning changes nothing.
INSERT INTO "ScriptLibrary" ("name", "zone_id", "description", "code", "updated_at")
VALUES ('dg', NULL, 'DG-script helpers for converted triggers: legacy vnum to (zone, id) keys, DG truthiness, wand/mace quest items.', $lib$--
-- Usage from a trigger:
--   local dg = require("dg")
--   local name = dg.oname(55577)              -- name of legacy object 55577
--   if dg.is_obj(object, wandgem) then ... end -- the received object is that vnum
--   if dg.flag(actor:get_quest_var("air_wand:wandtask1")) then ... end
--   dg.give(self, self:spawn_object(2, 101), actor)   -- hand a spawned item to the player
--
-- Legacy vnums were zone * 100 + id, but the importer keys every entity by the zone FILE it came
-- from (id = vnum - zone * 100), and some files hold more than 100 entries: zone 2 holds object
-- vnums 200-399 (the phase wands and maces, 301 = (2, 101)), zone 4 holds 400-599, zone 117 holds
-- 11700-11840, and so on. Splitting such a vnum as zone = vnum / 100 lands in the wrong zone. The
-- tables below list the files that run past 99 entries (the range is the span of the file's
-- vnums); any other vnum splits the old way. Zone 0 is stored as zone 1000.
-- Kinds are separate because a zone's mob file can be shorter or longer than its object file.

local M = {}

-- {first vnum, last vnum, zone}
local OBJ = {
    {200, 399, 2}, {400, 599, 4}, {2300, 2408, 23}, {3000, 3306, 30}, {11700, 11812, 117},
    {12000, 12158, 120}, {12300, 12499, 123}, {30000, 30128, 300}, {32400, 32573, 324},
    {48100, 48252, 481}, {48400, 48503, 484}, {50000, 50106, 500}, {53400, 53506, 534},
    {58000, 58299, 580},
}
local MOB = {
    {3000, 3499, 30}, {7300, 7475, 73}, {11700, 11813, 117}, {48100, 48251, 481},
    {48400, 48636, 484}, {53400, 53508, 534}, {58000, 58150, 580},
}
local ROOM = {
    {2300, 2786, 23}, {2800, 2910, 28}, {3000, 3499, 30}, {3500, 3601, 35}, {4100, 4238, 41},
    {4500, 4685, 45}, {7300, 7457, 73}, {8000, 8227, 80}, {8300, 8423, 83}, {11700, 11840, 117},
    {12000, 12220, 120}, {12300, 12482, 123}, {12700, 12850, 127}, {30000, 30123, 300},
    {32400, 32589, 324}, {35000, 35199, 350}, {39000, 39189, 390}, {41100, 41243, 411},
    {43000, 43252, 430}, {47000, 47128, 470}, {47200, 47404, 472}, {48100, 48256, 481},
    {48400, 48612, 484}, {49000, 49190, 490}, {53000, 53219, 530}, {53400, 53578, 534},
    {58000, 58215, 580}, {58400, 58543, 584}, {58800, 58918, 588},
}

local function split(ranges, vnum)
    vnum = tonumber(vnum)
    if not vnum then return nil end
    vnum = math.floor(vnum)
    for _, r in ipairs(ranges) do
        if vnum >= r[1] and vnum <= r[2] then
            return r[3], vnum - r[3] * 100
        end
    end
    local zone = vnum // 100
    if zone == 0 then zone = 1000 end
    return zone, vnum % 100
end

-- Legacy object vnum -> zone, id.
function M.obj(vnum) return split(OBJ, vnum) end
-- Legacy mob vnum -> zone, id.
function M.mob(vnum) return split(MOB, vnum) end
-- Legacy room vnum -> zone, id.
function M.room(vnum) return split(ROOM, vnum) end

-- (zone, id) -> legacy vnum (the same for objects, mobs and rooms).
function M.to_vnum(zone, id)
    if zone == 1000 then return id end
    return zone * 100 + id
end

local function named(proto, kind, vnum, zone, id)
    local name = zone and proto.template(zone, id).name
    if not name or name == "" then
        return "[no description for " .. kind .. " " .. tostring(vnum) .. "]"
    end
    return name
end

-- Name of the legacy object / mob / room vnum (DG %get.obj_shortdesc[N]% and friends).
function M.oname(vnum)
    local zone, id = M.obj(vnum)
    return named(objects, "object", vnum, zone, id)
end
function M.mname(vnum)
    local zone, id = M.mob(vnum)
    return named(mobiles, "mobile", vnum, zone, id)
end
function M.rname(vnum)
    local zone, id = M.room(vnum)
    local room = zone and get_room(zone, id)
    return room and room.name or ""
end

-- True when `obj` (a handle or template with zone_id / id) is the legacy object `vnum`.
function M.is_obj(obj, vnum)
    if type(vnum) ~= "number" or not obj then return false end
    local zone, id = M.obj(vnum)
    return obj.zone_id == zone and obj.id == id
end

-- DG truthiness of a quest variable: unset, "", and 0 are false (0 is truthy in Lua).
function M.flag(v)
    return v ~= nil and v ~= 0 and v ~= "" and v ~= false
end

-- True when the received `obj` is no longer there: an earlier RECEIVE trigger on the same mob
-- (002_108, 002_126, ...) took it, and a handle to a despawned item reads as nothing.
function M.gone(obj)
    return obj == nil or obj.name == nil or obj.name == ""
end

-- True when `obj` is one of the items a wand or mace crafter exports through `globals`:
-- wandgem, wandtask3, wandtask4, wand_id (002_111) and maceitem2..6, mace_id (002_118). The DG
-- refuse triggers let those through to the receive trigger and turned everything else away.
local KEYS = {
    "wandgem", "wandtask3", "wandtask4", "wand_id",
    "maceitem2", "maceitem3", "maceitem4", "maceitem5", "maceitem6", "mace_id",
}
function M.quest_item(obj, g)
    if not obj or not g then return false end
    for _, key in ipairs(KEYS) do
        if M.is_obj(obj, g[key]) then return true end
    end
    return false
end

-- Hand `item` (the handle spawn_object returned, or a received `object`) from the mob `giver` to
-- the player `to`. The give command takes a single word for the item (more words need "to") and
-- has no "give all", so the item goes by its first keyword; the newest matching item leaves first.
function M.give(giver, item, to)
    if not giver or not item or not to then return end
    giver:command("give " .. item.alias .. " " .. to.name)
end

return M
$lib$, now())
ON CONFLICT ("name") DO NOTHING;

UPDATE "Triggers" AS t
SET commands = v.commands,
    updated_at = now()
FROM (VALUES
  -- data/triggers/002/002_100_phase_wand_bigby_research_assistant_greet.lua
  (2, 100, $trig$local dg = require("dg")
if self:has_effect(Effect.Invisible) then
    self:command("vis")
end
wait(2)
local air = actor:get_quest_stage("air_wand") or 0
local fire = actor:get_quest_stage("fire_wand") or 0
local ice = actor:get_quest_stage("ice_wand") or 0
local acid = actor:get_quest_stage("acid_wand") or 0
local airgreet = dg.flag(actor:get_quest_var("air_wand:greet"))
local firegreet = dg.flag(actor:get_quest_var("fire_wand:greet"))
local icegreet = dg.flag(actor:get_quest_var("ice_wand:greet"))
local acidgreet = dg.flag(actor:get_quest_var("acid_wand:greet"))
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
end$trig$, 'e42835771e28e18f41b1b5c2d11b7e0d'),
  -- data/triggers/002/002_101_phase_wand_bigby_research_assistant_speech.lua
  (2, 101, $trig$local dg = require("dg")

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech or "") .. " "
local speech_hit = false
for _, w in ipairs({"wand", "earth", "air", "fire", "water", "upgrade", "lightning", "wind", "shock", "electricity", "smoldering", "burning", "cold", "ice", "frost", "acid", "tremors", "corrosion", "powerful", "yes"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
wait(2)
local class = actor.class or ""
if not (string.find(class, "sorcerer") or string.find(class, "pyromancer")
        or string.find(class, "cryomancer") or string.find(class, "illusionist")
        or string.find(class, "necromancer")) then
    self:say("I'm sorry, only true wizards can use these weapons.")
    return true
end
if actor.level < 10 then
    self:say("Come back after you've gained some more experience.  I can help you then.")
    return true
end

local quest_type, wandgem
if speech == "air" or speech == "lightning" or speech == "wind" or speech == "shock" or speech == "electricity" then
    quest_type, wandgem = "air", 55577
elseif speech == "fire" or speech == "smoldering" or speech == "burning" then
    quest_type, wandgem = "fire", 55575
elseif speech == "water" or speech == "cold" or speech == "ice" or speech == "frost" then
    quest_type, wandgem = "ice", 55574
elseif speech == "earth" or speech == "acid" or speech == "tremors" or speech == "corrosion" then
    quest_type, wandgem = "acid", 55576
end

if not quest_type then
    -- Any other listed word ("wand", "upgrade", "yes"): DG read %type% here before it was set, so
    -- the stage was always 0 and the prompt below is what every player got.
    self:say("Yeah, I can help you upgrade any basic wand!")
    wait(1)
    self.room:send(tostring(self.name) .. " says, 'Tell me what element you would like to improve.  You can say <green>acid</>, <b:yellow>air</>, <red>fire</>, or <b:blue>ice</>.'")
    return true
end

local quest = quest_type .. "_wand"
local stage = actor:get_quest_stage(quest)
wait(2)
if actor:get_has_completed(quest) then
    self.room:send(tostring(self.name) .. " says, 'It looks like you already have the most powerful weapon of " .. quest_type .. " in existence!'")
elseif (stage or 0) == 0 or stage == 1 then
    if (stage or 0) == 0 then
        actor:start_quest(quest)
    end
    self.room:send(tostring(self.name) .. " says, 'I can upgrade your " .. quest_type .. " wand!  But what I will do is just the first step in a life-long journey.'")
    wait(3)
    self.room:send(tostring(self.name) .. " says, 'This step is relatively simple.  You can check your <b:cyan>[wand progress]</> with me as well.'")
    wait(2)
    self:say("First, let me see your wand.")
elseif stage == 2 then
    self.room:send(tostring(self.name) .. " says, 'If you have the practice, give me " .. dg.oname(wandgem) .. " and your current wand.'")
elseif stage > 2 then
    if quest_type == "air" then
        self.room:send(tostring(self.name) .. " says, 'You'll be studying with a plethora of seers, mystics, and wisemen.  You can check your <b:cyan>[wand progress]</> as you go.'")
        wait(1)
        if stage == 3 then     self:say("Speak with the old Abbot in the Abbey of St. George.")
        elseif stage == 4 then self:say("The keeper of a southern coastal tower will have advice for you.")
        elseif stage == 5 then self:say("A master of air near the megalith in South Caelia will be able to help next.")
        elseif stage == 6 then self:say("Seek out the warrior-witch at the center of the southern megalith.")
        elseif stage == 7 then self:say("She's hard to deal with, but the Seer of Griffin Isle should have some additional guidance for you.")
        elseif stage == 8 then self:say("In the diabolist's church is a seer who cannot see.  He's a good resource for this kind of work.")
        elseif stage == 9 then self:say("The guardian ranger of the Druid Guild in the Red City has some helpful crafting tips.")
        elseif stage == 10 then self:say("Silania will help you craft the finest of air weapons.")
        end
    elseif quest_type == "fire" then
        self.room:send(tostring(self.name) .. " says, 'You should seek out the most renowned pyromancers in the world.  You can check your <b:cyan>[wand progress]</> as you go.'")
        wait(1)
        if stage == 3 then     self:say("The keeper of the temple to the dark flame out east will know what to do.")
        elseif stage == 4 then self:say("There's a fire master in the frozen north who likes to spend his time at the hot springs.")
        elseif stage == 5 then self:say("A master of fire near the megalith in South Caelia will be able to help next.")
        elseif stage == 6 then self:say("A seraph crafts with the power of the sun and sky.  It can be found in the floating fortress in South Caelia.")
        elseif stage == 7 then self:say("I hate to admit it, but Vulcera is your next crafter.  Good luck appeasing her though...")
        elseif stage == 8 then self:say("You're headed back to Fiery Island.  Crazy old McCabe can help you improve your staff further.")
        elseif stage == 9 then self:say("Seek out the one who speaks for the Sun near Anduin.  He can upgrade your staff.")
        elseif stage == 10 then self:say("Surely you've heard of Emmath Firehand.  He's the supreme artisan of fiery goods.  He can help you make the final improvements to your staff.")
        end
    elseif quest_type == "ice" then
        self.room:send(tostring(self.name) .. " says, 'Masters of ice and water are highly varied in their professions.  You can check your <b:cyan>[wand progress]</> as you go.'")
        wait(1)
        if stage == 3 then     self:say("The shaman near Three-Falls River has developed a powerful affinity for water from his life in the canyons.  Seek his advice.")
        elseif stage == 4 then self:say("Many of the best craftspeople aren't even mortal.  There is a water sprite of some renown deep in Anlun Vale.")
        elseif stage == 5 then self:say("A master of spirits in the far north will be able to help next.")
        elseif stage == 6 then self:say("Your next crafter is a distant relative of the Sunfire clan.  He's been squatting in a flying fortress for many months, trying to unlock its secrets.")
        elseif stage == 7 then self:say("You'll need the advice of a master ice sculptor.  One works regularly up in Mt. Frostbite.")
        elseif stage == 8 then self:say("There's another distant relative of the Sunfire clan who runs the hot springs near Ickle.  He's book smart and knows a thing or two about jewel crafting.")
        elseif stage == 9 then self:say("The guild guard for the Sorcerer Guild in Ickle has learned plenty of secrets from the inner sanctum.  Talk to him.")
        elseif stage == 10 then self:say("You must know Suralla Iceeye by now.  She's the master artisan of cold and ice.  She'll know how to make the final improvements to your staff.")
        end
    elseif quest_type == "acid" then
        self.room:send(tostring(self.name) .. " says, 'Acid is the energy of earth.  The master earth crafters all belong to the ranger network that safeguards places around Caelia.  You can check your <b:cyan>[wand progress]</> as you go.'")
        wait(1)
        if stage == 3 then     self:say("First, seek the one who guards the eastern gates of Ickle.")
        elseif stage == 4 then self:say("The next two artisans dwell in the Rhell Forest south-east of Mielikki.")
        elseif stage == 5 then self:say("Your next crafter isn't exactly part of the ranger network...  It's not actually a person at all.  Find the treant in the Rhell forest and ask it for guidance.")
        elseif stage == 6 then self:say("The ranger who guards the massive necropolis near Anduin has wonderful insights on crafting with decay.")
        elseif stage == 7 then self:say("Your next guide may be hard to locate...  I believe they guard the entrance to a long-lost kingdom beyond a frozen desert.")
        elseif stage == 8 then self:say("Next, consult with another ranger who guards a place crawling with the dead.  The dwarf ranger in the iron hills will know how to help you.")
        elseif stage == 9 then self:say("The guard of the only known Ranger Guild in the world is also an excellent craftswoman.  Consult with her.")
        elseif stage == 10 then self:say("Your last guide is the head of the ranger network himself, Eleweiss.  He can help make the final improvements to your staff.")
        end
    end
end
return true$trig$, '6b581ed4a9787f257521c39a0a91c5eb'),
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
            give_back()
            self.room:send(tostring(self.name) .. " scrutinizes " .. tostring(object.shortdesc) .. " with suspicion.")
            wait(1)
            self.room:send(tostring(self.name) .. " returns " .. tostring(object.shortdesc) .. ".")
            self:say("You haven't finished all the tasks to prime the wand yet.")
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
        give_back()
        self.room:send(tostring(self.name) .. " declines " .. tostring(object.shortdesc) .. ".")
        wait(1)
        self:say("Before you give me anything else, give me the wand you wish to improve.")
    end
else
    give_back()
    self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
    wait(2)
    self:say("I've already upgraded your wand as much as I know how.")
end
return true$trig$, '3ade52d9455c1c6dcfad426a0f1d3a41'),
  -- data/triggers/002/002_103_phase_wands_attack_counter.lua
  (2, 103, $trig$local dg = require("dg")

local vnum = dg.to_vnum(self.zone_id, self.id)
local element, spell, bonus, level
if vnum >= 300 and vnum <= 309 then
    element = "air"
    if vnum >= 301 and vnum <= 305 then
        spell = "shocking grasp"
        bonus = vnum - 301
        level = self.level
    else
        spell = "lightning bolt"
        bonus = vnum - 306
        level = self.level - 50
    end
elseif vnum >= 310 and vnum <= 319 then
    element = "fire"
    if vnum >= 311 and vnum <= 315 then
        spell = "burning hands"
        bonus = vnum - 311
        level = self.level
    else
        spell = "fireball"
        bonus = vnum - 316
        level = self.level - 50
    end
elseif vnum >= 320 and vnum <= 329 then
    element = "ice"
    if vnum >= 321 and vnum <= 325 then
        spell = "chill touch"
        bonus = vnum - 321
        level = self.level
    else
        spell = "cone of cold"
        bonus = vnum - 326
        level = self.level - 50
    end
elseif vnum >= 330 and vnum <= 339 then
    element = "acid"
    if vnum >= 331 and vnum <= 335 then
        spell = "writhing weeds"
        bonus = vnum - 331
        level = self.level
    else
        spell = "acid burst"
        bonus = vnum - 336
        level = self.level - 50
    end
end
if not element then return end

local quest = element .. "_wand"
local stage = actor:get_quest_stage(quest)
if stage > 1 then
    if not dg.flag(actor:get_quest_var(quest .. ":wandtask1")) then
        local attack_increase = (actor:get_quest_var(quest .. ":attack_counter") or 0) + 1
        actor:set_quest_var(quest, "attack_counter", attack_increase)
        if attack_increase >= (stage - 1) * 50 then
            actor:set_quest_var(quest, "wandtask1", 1)
            actor:send("<b:yellow>You have perfected your bond with " .. tostring(self.shortdesc) .. "!</>")
        end
    end
end
if spell then
    local chance = 1 + bonus
    if random(1, 20) <= chance then
        spells.cast(self, spell, victim, level)
    end
end$trig$, '351447e98d1c62519f6b926d8809d5e3'),
  -- data/triggers/002/002_104_phase_wands_give_owner_check.lua
  (2, 104, $trig$local dg = require("dg")
local _return_value = true  -- Default: allow action

local vnum = dg.to_vnum(self.zone_id, self.id)
local energy
if vnum >= 300 and vnum <= 309 then
    energy = "air"
elseif vnum >= 310 and vnum <= 319 then
    energy = "fire"
elseif vnum >= 320 and vnum <= 329 then
    energy = "ice"
elseif vnum >= 330 and vnum <= 339 then
    energy = "acid"
end

-- Bigby's assistant: only the four basic wands go there, and handing one over starts the quest.
if victim.zone_id == 30 and victim.id == 13 then
    if energy and (vnum == 300 or vnum == 310 or vnum == 320 or vnum == 330) then
        if actor.is_player and actor:get_quest_stage(energy .. "_wand") == 0 then
            actor:start_quest(energy .. "_wand")
        end
        return _return_value
    end
    if energy and actor.is_player then
        actor:send("You shouldn't give away something so precious!")
    end
    return _return_value
end

local crafter_type, wandstep
if (victim.zone_id == 185 and victim.id == 0) then crafter_type, wandstep = "air", 3
elseif (victim.zone_id == 41 and victim.id == 26)  then crafter_type, wandstep = "fire", 3
elseif (victim.zone_id == 178 and victim.id == 6) then crafter_type, wandstep = "ice", 3
elseif (victim.zone_id == 100 and victim.id == 56) then crafter_type, wandstep = "acid", 3
elseif (victim.zone_id == 586 and victim.id == 1) then crafter_type, wandstep = "air", 4
elseif (victim.zone_id == 103 and victim.id == 6) then crafter_type, wandstep = "fire", 4
elseif (victim.zone_id == 23 and victim.id == 37)  then crafter_type, wandstep = "ice", 4
elseif (victim.zone_id == 625 and victim.id == 4) then crafter_type, wandstep = "acid", 4
elseif (victim.zone_id == 123 and victim.id == 5) then crafter_type, wandstep = "air", 5
elseif (victim.zone_id == 123 and victim.id == 4) then crafter_type, wandstep = "fire", 5
elseif (victim.zone_id == 550 and victim.id == 13) then crafter_type, wandstep = "ice", 5
elseif (victim.zone_id == 625 and victim.id == 3) then crafter_type, wandstep = "acid", 5
elseif (victim.zone_id == 123 and victim.id == 2) then crafter_type, wandstep = "air", 6
elseif (victim.zone_id == 238 and victim.id == 11) then crafter_type, wandstep = "fire", 6
elseif (victim.zone_id == 238 and victim.id == 2) then crafter_type, wandstep = "ice", 6
elseif (victim.zone_id == 470 and victim.id == 75) then crafter_type, wandstep = "acid", 6
elseif (victim.zone_id == 490 and victim.id == 3) then crafter_type, wandstep = "air", 7
elseif (victim.zone_id == 481 and victim.id == 5) then crafter_type, wandstep = "fire", 7
elseif (victim.zone_id == 533 and victim.id == 16) then crafter_type, wandstep = "ice", 7
elseif (victim.zone_id == 40 and victim.id == 17)  then crafter_type, wandstep = "acid", 7
elseif (victim.zone_id == 85 and victim.id == 15)  then crafter_type, wandstep = "air", 8
elseif (victim.zone_id == 481 and victim.id == 150) then crafter_type, wandstep = "fire", 8
elseif (victim.zone_id == 103 and victim.id == 0) then crafter_type, wandstep = "ice", 8
elseif (victim.zone_id == 480 and victim.id == 29) then crafter_type, wandstep = "acid", 8
elseif (victim.zone_id == 62 and victim.id == 16)  then crafter_type, wandstep = "air", 9
elseif (victim.zone_id == 484 and victim.id == 12) then crafter_type, wandstep = "fire", 9
elseif (victim.zone_id == 100 and victim.id == 12) then crafter_type, wandstep = "ice", 9
elseif (victim.zone_id == 35 and victim.id == 49)  then crafter_type, wandstep = "acid", 9
elseif (victim.zone_id == 185 and victim.id == 81) then crafter_type, wandstep = "air", 10
elseif (victim.zone_id == 52 and victim.id == 30)  then crafter_type, wandstep = "fire", 10
elseif (victim.zone_id == 550 and victim.id == 20) then crafter_type, wandstep = "ice", 10
elseif (victim.zone_id == 163 and victim.id == 15) then crafter_type, wandstep = "acid", 10
end

if not actor.is_player or not crafter_type or not energy then
    return _return_value
end

local quest = energy .. "_wand"
local refuse
if crafter_type ~= energy then
    refuse = 1
elseif (actor:get_quest_stage(quest) or 0) < wandstep then
    refuse = 2
end

local weapon = (wandstep >= 8) and "staff" or "wand"
if refuse == 1 then
    actor:send("You shouldn't give away something so precious!")
elseif refuse == 2 then
    self.room:send(tostring(victim.name) .. " refuses " .. tostring(self.shortdesc) .. ".")
    wait(2)
    actor:send(tostring(victim.name) .. " tells you, 'This isn't yours!  I can't help you properly improve with a " .. weapon .. " that doesn't belong to you.'")
end
return _return_value$trig$, 'c7dc01cbd4c9081db47363baae4f1795'),
  -- data/triggers/002/002_105_phase_weapon_owner_wield_check.lua
  (2, 105, $trig$local dg = require("dg")
local _return_value = true  -- Default: allow action

local vnum = dg.to_vnum(self.zone_id, self.id)
if vnum >= 300 and vnum <= 339 then
    local energy
    if vnum <= 309 then
        energy = "air"
    elseif vnum <= 319 then
        energy = "fire"
    elseif vnum <= 329 then
        energy = "ice"
    else
        energy = "acid"
    end
    local quest = energy .. "_wand"
    local stage = actor:get_quest_stage(quest)
    if vnum == 300 or vnum == 310 or vnum == 320 or vnum == 330 then
        if stage == 0 then
            actor:start_quest(quest)
        end
    elseif stage < (self.level // 10) + 2 then
        actor:send("This weapon is bound to someone else!")
    end
elseif vnum >= 340 and vnum <= 349 then
    local stage = actor:get_quest_stage("phase_mace")
    if vnum == 340 then
        if stage == 0 then
            actor:start_quest("phase_mace")
        end
    elseif stage < (self.level // 10) + 1 then
        actor:send("This weapon is bound to someone else!")
    end
end
return _return_value$trig$, '891d292fe0a5c2b97b821fa9ef1220b8'),
  -- data/triggers/002/002_107_phase_wand_and_phase_mace_upgrade_general_speech.lua
  (2, 107, $trig$local dg = require("dg")
local function proto_short(vnum) return dg.oname(vnum) end
local function mob_short(vnum) return dg.mname(vnum) end
local lower = string.lower(speech or "")

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech or "") .. " "
local speech_hit = false
for _, w in ipairs({"upgrade", "upgrading", "craft", "crafting", "improve", "improving", "improvements", "upgrades"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
wait(2)

-- Silania (185:81) and the Oracle of the Sun (484:12) craft for both quests: the mace block is
-- for clerics, the wand block below for the sorcerer classes.
if ((self.zone_id == 185 and self.id == 81) or (self.zone_id == 484 and self.id == 12))
        and (actor.class == "cleric" or actor.class == "priest") then
    local macestep = globals.macestep
    if not macestep then return true end
    local minlevel = macestep * 10
    local maceattack = globals.maceattack
    local stage = actor:get_quest_stage("phase_mace")
    if stage == macestep then
        if actor.level >= minlevel then
            actor:set_quest_var("phase_mace", "greet", 1)
            actor:send(tostring(self.name) .. " says, 'I can add benedictions to your mace, yes.'")
            actor:send(tostring(self.name) .. " says, 'You'll need to use your mace <b:yellow>" .. tostring(maceattack) .. "</> times.'")
            actor:send(tostring(self.name) .. " says, 'I'll also need the following:'")
            actor:send("- <b:yellow>" .. proto_short(globals.maceitem2) .. "</>, for its spiritual protection.")
            actor:send("- <b:yellow>" .. proto_short(globals.maceitem3) .. "</>, as a model for the new mace.")
            actor:send("- <b:yellow>" .. proto_short(globals.maceitem4) .. "</>, for its power in fighting the undead.")
            actor:send("- <b:yellow>" .. proto_short(globals.maceitem5) .. "</>, for its guiding light.")
            actor:send(tostring(self.name) .. " says, 'You can check your <b:cyan>[mace progress]</> at any time.'")
        else
            actor:send(tostring(self.name) .. " says, 'You'll need to be at least level " .. tostring(minlevel) .. " before I can improve the blessings on your mace.'")
        end
    elseif actor:get_has_completed("phase_mace") then
        actor:send(tostring(self.name) .. " says, 'There is no weapon greater than the mace of disruption!'")
    elseif (stage or 0) < macestep then
        actor:send(tostring(self.name) .. " says, 'Your mace isn't ready for improvement yet.'")
    elseif stage > macestep then
        actor:send(tostring(self.name) .. " says, 'I've done all I can already.'")
    end
    return true
end

if actor.class == "sorcerer" or actor.class == "cryomancer" or actor.class == "pyromancer"
        or actor.class == "illusionist" or actor.class == "necromancer" then
    local wandstep = globals.wandstep
    if not wandstep then return true end
    local wandattack = globals.wandattack
    local quest_type = globals.type or "type"
    local quest = quest_type .. "_wand"
    local minlevel = (wandstep - 1) * 10
    local stage = actor:get_quest_stage(quest)
    if stage == wandstep then
        if actor.level >= minlevel then
            actor:set_quest_var(quest, "greet", 1)
            if stage < 7 then
                if string.find(lower, "staff") then
                    actor:send(tostring(self.name) .. " says, 'I can't help you create a staff but I can help improve your wand's powers.'")
                else
                    actor:send(tostring(self.name) .. " says, 'I can definitely increase your wand's strength.'")
                end
                wait(2)
                actor:send(tostring(self.name) .. " says, 'You'll need to use your wand <b:yellow>" .. tostring(wandattack) .. "</> times.'")
            elseif stage == 7 then
                actor:send(tostring(self.name) .. " says, 'Your wand has reached its maximum potential.  You're ready for a staff instead.'")
                wait(2)
                actor:send(tostring(self.name) .. " says, 'You'll need to use your current wand <b:yellow>" .. tostring(wandattack) .. "</> times.'")
            else
                if string.find(lower, "wand") then
                    actor:send(tostring(self.name) .. " says, 'I can't help you create a wand but I can help improve your staff's powers.'")
                else
                    actor:send(tostring(self.name) .. " says, 'I can definitely increase your staff's power.'")
                end
                wait(2)
                actor:send(tostring(self.name) .. " says, 'You'll need to use your staff <b:yellow>" .. tostring(wandattack) .. "</> times.'")
            end
            actor:send(tostring(self.name) .. " says, 'I'll also need the following:'")
            actor:send("- <b:yellow>" .. proto_short(globals.wandgem) .. "</>")
            if wandstep ~= 7 and wandstep ~= 10 then
                actor:send("- <b:yellow>" .. proto_short(globals.wandtask3) .. "</>, for its resonance with " .. quest_type .. " energies.")
                if wandstep == 4 then
                    actor:send("</>    Blessings can be called at the smaller groups of standing stones in South Caelia.")
                    if (self.zone_id == 586 and self.id == 1) then
                        actor:send("</>    Search the far eastern edge of the continent.")
                    elseif (self.zone_id == 103 and self.id == 6) then
                        actor:send("</>    Search the south point beyond Anlun Vale.")
                    elseif (self.zone_id == 23 and self.id == 37) then
                        actor:send("</>    Search the surrounding forest.")
                    elseif (self.zone_id == 625 and self.id == 4) then
                        actor:send("</>    Search in the heart of the heart of the thorns.")
                    end
                    actor:send("</>    The phrase to call the blessing is:")
                    actor:send("</>    <b:cyan>I pray for a blessing from mother earth, creator of life and bringer of death</>")
                end
            end
            if wandstep == 4 then
                actor:send("- <b:yellow>" .. proto_short(globals.wandtask4) .. "</> for its sheer magical potential.")
                actor:send("</>    Be careful, thawkinixa is extremely dangerous!")
            elseif wandstep == 5 then
                actor:send("Plus you'll need to imbue your wand in " .. tostring(globals.wandtask4) .. ".")
            elseif wandstep == 6 then
                actor:send("This next step also requires balancing harmonic frequencies.")
                actor:send("Go find <b:yellow>" .. proto_short(globals.wandtask4) .. "</>.")
            elseif wandstep == 7 then
                actor:send("- <b:yellow>" .. proto_short(globals.wandtask3) .. "</>, which will form the body of your new staff.")
                actor:send("- <b:yellow>" .. proto_short(globals.wandtask4) .. "</>, as a fine head for your new staff.")
            elseif wandstep == 8 then
                actor:send("- <b:yellow>" .. proto_short(globals.wandtask4) .. "</>, which can be harvested from those kinds of elementals.")
            elseif wandstep == 9 then
                actor:send("- proof of your mastery over " .. quest_type .. " by slaying <b:cyan>" .. mob_short(globals.wandtask4) .. "</>.")
            elseif wandstep == 10 then
                actor:send(tostring(self.name) .. " says, 'Energize your staff by slaying <b:cyan>" .. mob_short(globals.wandtask3) .. "</> in Templace, then return to me.'")
            end
            actor:send(tostring(self.name) .. " says, 'You can check your <b:cyan>[wand progress]</> at any time.'")
        else
            actor:send(tostring(self.name) .. " says, 'You'll need to be at least level " .. tostring(minlevel) .. " before I can improve your bond with your weapon.'")
        end
    elseif (stage or 0) < wandstep then
        actor:send(tostring(self.name) .. " says, 'Your " .. (globals.weapon or "wand") .. " isn't ready for improvement yet.'")
    elseif stage > wandstep then
        actor:send(tostring(self.name) .. " says, 'I've done all I can already.'")
    end
end
return true$trig$, '46523ccc3061b46656acdba930da0ac2'),
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
return true$trig$, 'dff7f343a1001663612be01f4f89eaf2'),
  -- data/triggers/002/002_109_phase_wand_command_imbue.lua
  (2, 109, $trig$-- Command location mask 3: legacy OCMD_EQUIP=1 (worn), OCMD_INVEN=2 (carried), OCMD_ROOM=4 (floor)
if not (location == "equip" or location == "inventory") then
    return true  -- Not in a location this trigger watches
end
local dg = require("dg")

-- `imbue`, abbreviated to at least "imb" (the DG script let "i" and "im" through).
local typed = string.lower(cmd or "")
if #typed < 3 or string.sub("imbue", 1, #typed) ~= typed then
    return true
end

local vnum = dg.to_vnum(self.zone_id, self.id)

local element, area, place, ward_vnum, ward_name, crafter, color
if vnum == 303 then
    element, area = "air", "howling winds"
elseif vnum == 313 then
    element, area = "fire", "sweltering tunnels"
elseif vnum == 323 then
    element, area = "ice", "vast ocean"
elseif vnum == 333 then
    element, area = "acid", "murky swamp"
elseif vnum == 306 then
    element, place, ward_vnum, ward_name, crafter = "air", 49007, 53454, "ward-mist", 8515
elseif vnum == 316 then
    element, place, ward_vnum, ward_name, crafter = "fire", 5272, 53456, "ward-flames", 48250
elseif vnum == 326 then
    element, place, ward_vnum, ward_name, crafter = "ice", 55105, 53457, "ward-ice", 10300
elseif vnum == 336 then
    element, place, ward_vnum, ward_name, crafter = "acid", 16355, 53453, "ward-plants", 48029
elseif vnum == 308 then
    element, place, color = "air", 48862, "<b:yellow>"
elseif vnum == 318 then
    element, place, color = "fire", 47800, "<b:red>"
elseif vnum == 328 then
    element, place, color = "ice", 47708, "<b:cyan>"
elseif vnum == 338 then
    element, place, color = "acid", 47672, "<b:green>"
else
    return true
end

local is_staff = (vnum == 306 or vnum == 308 or vnum == 316 or vnum == 318
    or vnum == 326 or vnum == 328 or vnum == 336 or vnum == 338)
local weapon = is_staff and "staff" or "wand"
local quest = element .. "_wand"
local room = actor.room
local here = room and dg.to_vnum(room.zone_id, room.id)

local imbued, reward
if place and here == place then
    if not dg.flag(actor:get_quest_var(quest .. ":wandtask1")) then
        local remaining = ((actor:get_quest_stage(quest) - 1) * 50) - (actor:get_quest_var(quest .. ":attack_counter") or 0)
        actor:send("You need to attack " .. tostring(remaining) .. " more times to fully bond with your " .. weapon .. "!")
        return false
    end
    if ward_vnum then
        if not dg.flag(actor:get_quest_var(quest .. ":wandtask5")) then
            actor:send("<b:blue>" .. tostring(self.shortdesc) .. " must be primed by " .. dg.mname(crafter) .. " before you can imbue it!</>")
            return false
        end
        local ward_zone, ward_id = dg.obj(ward_vnum)
        if not actor:has_item(ward_zone, ward_id) then
            actor:send("You don't have " .. dg.oname(ward_vnum) .. " with you!")
            return false
        end
        actor:send("You raise " .. tostring(self.shortdesc) .. " and " .. dg.oname(ward_vnum) .. " above your head.")
        wait(1)
        actor:send("The energies of this place start to flow through you!")
        wait(3)
        actor:destroy_item(ward_name)
        actor:send(dg.oname(ward_vnum) .. " floats into the air and unravels into wispy tendrils of elemental energy!")
        wait(2)
        actor:send("The energies wrap around " .. tostring(self.shortdesc) .. ".")
        wait(3)
        actor:send(tostring(self.shortdesc) .. " is transformed!")
        reward = true
        actor:advance_quest(quest)
        actor:set_quest_var(quest, "greet", 0)
        actor:set_quest_var(quest, "attack_counter", 0)
        for number = 1, 5 do
            actor:set_quest_var(quest, "wandtask" .. number, 0)
        end
    else
        if not dg.flag(actor:get_quest_var(quest .. ":wandtask4")) then
            return true  -- not primed yet: DG let the command fall through
        end
        actor:send("You close your eyes and hold " .. tostring(self.shortdesc) .. " before you.")
        wait(2)
        actor:send("You feel the wheel of the cosmos rotating around you here in this place.")
        wait(3)
        actor:send("You begin to draw from the vast elemental energies of the plane...")
        wait(3)
        actor:send("Drawing all the raw primordial power you can muster, you suffuse the very essence of the realm into your staff!")
        actor:send(color .. "You have perfected your staff!</>")
        actor:complete_quest(quest)
        reward = true
    end
elseif area then
    -- The wands: only in the element's area, and only for a player a crafter has put on the step.
    local ranges = {
        [303] = {55001, 55003}, [313] = {5200, 5299}, [323] = {39001, 39189}, [333] = {7300, 7457},
    }
    local r = ranges[vnum]
    if here and here >= r[1] and here <= r[2] and (actor:get_quest_var(quest .. ":greet") or 0) == 1 then
        imbued = true
    else
        return true
    end
else
    return true
end

if imbued then
    actor:send("You imbue your wand with the energy of the " .. area .. "!")
    actor:set_quest_var(quest, "wandtask4", 1)
elseif reward then
    local next_zone, next_id = dg.obj(vnum + 1)
    actor:spawn_object(next_zone, next_id)

    -- Experience: a level-band curve on the staff's level, scaled by class so every class
    -- receives the same proportion of a level.
    local expcap = self.level
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
    world.destroy(self)
end
return false$trig$, 'a5345273f160eb01a14303e812b03759'),
  -- data/triggers/002/002_112_phase_wand_general_death.lua
  (2, 112, $trig$local dg = require("dg")
local quest_type, color, wand_id, stage_target, task_key
if (self.zone_id == 238 and self.id == 3) then
    quest_type, color, wand_id, stage_target, task_key = "air", "<b:white>", 307, 9, "wandtask4"
elseif (self.zone_id == 520 and self.id == 1) then
    quest_type, color, wand_id, stage_target, task_key = "air", "<b:white>", 308, 10, "wandtask3"
elseif (self.zone_id == 40 and self.id == 13) then
    quest_type, color, wand_id, stage_target, task_key = "fire", "<red>", 317, 9, "wandtask4"
elseif (self.zone_id == 520 and self.id == 2) then
    quest_type, color, wand_id, stage_target, task_key = "fire", "<red>", 318, 10, "wandtask3"
elseif (self.zone_id == 533 and self.id == 0) then
    quest_type, color, wand_id, stage_target, task_key = "ice", "<b:cyan>", 327, 9, "wandtask4"
elseif (self.zone_id == 520 and self.id == 5) then
    quest_type, color, wand_id, stage_target, task_key = "ice", "<b:cyan>", 328, 10, "wandtask3"
elseif (self.zone_id == 520 and self.id == 18) then
    quest_type, color, wand_id, stage_target, task_key = "acid", "<b:green>", 337, 9, "wandtask4"
elseif (self.zone_id == 520 and self.id == 7) then
    quest_type, color, wand_id, stage_target, task_key = "acid", "<b:green>", 338, 10, "wandtask3"
end
if not quest_type then return end

local quest = quest_type .. "_wand"

local function credit(person)
    if not person.is_player then return end
    if person.room ~= self.room then return end
    if person:get_quest_stage(quest) ~= stage_target then return end
    if dg.flag(person:get_quest_var(quest .. ":" .. task_key)) then return end
    person:set_quest_var(quest, task_key, 1)
    person:send(color .. dg.oname(wand_id) .. " crackles with vibrant energy!</>")
    person:send(color .. "It is primed for reforging!</>")
end

local members = actor.group_member
if members and #members > 0 then
    for _, person in ipairs(members) do
        credit(person)
    end
else
    credit(actor)
end$trig$, 'fe9e160c95f0a1e10cea3067497fa5d9'),
  -- data/triggers/002/002_113_phase_wand_bigby_research_assistant_progress_check.lua
  (2, 113, $trig$local dg = require("dg")

-- DG word list (num_arg 1): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech or "") .. " "
local speech_hit = false
for _, w in ipairs({"progress", "status"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
wait(2)
local weapon = "wand"
local times = 50
if actor:get_quest_stage("air_wand") > 0 then
    self.room:send("<b:yellow>AIR</>")
    if actor:get_has_completed("air_wand") then
        self:say("It looks like you already have the most powerful staff of air in existence!")
    elseif actor:get_quest_stage("air_wand") == 1 then
        self:say("Let me see " .. tostring(objects.template(2, 100).name) .. ".")
    elseif actor:get_quest_stage("air_wand") == 2 then
        self:say("I am crafting a new air wand for you.")
        if dg.flag(actor:get_quest_var("air_wand:wandtask1")) and dg.flag(actor:get_quest_var("air_wand:wandtask2")) then
            -- (empty room echo)
            self.room:send("Simply give me your " .. tostring(objects.template(2, 100).name) .. ".")
        else
            if dg.flag(actor:get_quest_var("air_wand:wandtask1")) or dg.flag(actor:get_quest_var("air_wand:wandtask2")) then
                -- (empty room echo)
                self.room:send("You have done the following:")
                if dg.flag(actor:get_quest_var("air_wand:wandtask1")) then
                    self.room:send("- used your wand " .. tostring(times) .. " times")
                end
                if dg.flag(actor:get_quest_var("air_wand:wandtask2")) then
                    self.room:send("- brought " .. tostring(objects.template(555, 77).name))
                end
            end
            -- (empty room echo)
            self.room:send("You still need to:")
            if not dg.flag(actor:get_quest_var("air_wand:wandtask1")) then
                local remaining = times - (actor:get_quest_var("air_wand:attack_counter") or 0)
                self.room:send("- <b:yellow>attack " .. tostring(remaining) .. " more times with your " .. tostring(weapon) .. "</>")
            end
            if not dg.flag(actor:get_quest_var("air_wand:wandtask2")) then
                self.room:send("- <b:yellow>bring me " .. tostring(objects.template(555, 77).name) .. "</>")
            end
        end
    else
        if actor:get_quest_stage("air_wand") > 2 then
            self:say("I can't help you with air anymore, but I know who can.")
            -- (empty room echo)
            local stage = actor:get_quest_stage("air_wand")
            if stage == 3 then
                self:say("Speak with the old Abbot in the Abbey of St. George.")
            elseif stage == 4 then
                self:say("The keeper of a southern coastal tower will have advice for you.")
            elseif stage == 5 then
                self:say("A master of air near the megalith in South Caelia will be able to help next.")
            elseif stage == 6 then
                self:say("Seek out the warrior-witch at the center of the southern megalith.")
            elseif stage == 7 then
                self:say("She's hard to deal with, but the Seer of Griffin Isle should have some additional guidance for you.")
            elseif stage == 8 then
                self:say("In the diabolist's church is a seer who cannot see.  He's a good resource for this kind of work.")
            elseif stage == 9 then
                self:say("The guardian ranger of the Druid Guild in the Red City has some helpful crafting tips.")
            elseif stage == 10 then
                self:say("Silania will help you craft the finest of air weapons.")
            end
        end
    end
    -- (empty send to actor)
end
if actor:get_quest_stage("fire_wand") > 0 then
    self.room:send("<red>FIRE</>")
    if actor:get_has_completed("fire_wand") then
        self:say("It looks like you already have the most powerful staff of fire in existence!")
    elseif actor:get_quest_stage("fire_wand") == 1 then
        self:say("Let me see " .. tostring(objects.template(2, 110).name) .. ".")
    elseif actor:get_quest_stage("fire_wand") == 2 then
        self:say("I am crafting a new fire wand for you.")
        if dg.flag(actor:get_quest_var("fire_wand:wandtask1")) and dg.flag(actor:get_quest_var("fire_wand:wandtask2")) then
            -- (empty room echo)
            self.room:send("Simply give me your " .. tostring(objects.template(2, 110).name) .. ".")
        else
            if dg.flag(actor:get_quest_var("fire_wand:wandtask1")) or dg.flag(actor:get_quest_var("fire_wand:wandtask2")) then
                -- (empty room echo)
                self.room:send("You have done the following:")
                if dg.flag(actor:get_quest_var("fire_wand:wandtask1")) then
                    self.room:send("- used your wand " .. tostring(times) .. " times")
                end
                if dg.flag(actor:get_quest_var("fire_wand:wandtask2")) then
                    self.room:send("- brought " .. tostring(objects.template(555, 75).name))
                end
            end
            -- (empty room echo)
            self.room:send("You still need to:")
            if not dg.flag(actor:get_quest_var("fire_wand:wandtask1")) then
                local remaining = times - (actor:get_quest_var("fire_wand:attack_counter") or 0)
                self.room:send("- <b:yellow>attack " .. tostring(remaining) .. " more times with your " .. tostring(weapon) .. "</>")
            end
            if not dg.flag(actor:get_quest_var("fire_wand:wandtask2")) then
                self.room:send("- <b:yellow>bring me " .. tostring(objects.template(555, 75).name) .. "</>")
            end
        end
    else
        if actor:get_quest_stage("fire_wand") > 2 then
            self:say("I can't help you with fire anymore, but I know who can.")
            -- (empty room echo)
            local stage = actor:get_quest_stage("fire_wand")
            if stage == 3 then
                self:say("A minion of the dark flame out east will know what to do.")
            elseif stage == 4 then
                self:say("There's a fire master in the frozen north who likes to spend his time at the hot springs.")
            elseif stage == 5 then
                self:say("A master of fire near the megalith in South Caelia will be able to help next.")
            elseif stage == 6 then
                self:say("A seraph crafts with the power of the sun and sky.  It can be found in the floating fortress in South Caelia.")
            elseif stage == 7 then
                self:say("I hate to admit it, but Vulcera is your next crafter.  Good luck appeasing her though...")
            elseif stage == 8 then
                self:say("You're headed back to Fiery Island.  Crazy old McCabe can help you improve your staff further.")
            elseif stage == 9 then
                self:say("Seek out the one who speaks for the Sun near Anduin.  He can upgrade your staff.")
            elseif stage == 10 then
                self:say("Surely you've heard of Emmath Firehand.  He's the supreme artisan of fiery goods.  He can help you make the final improvements to your staff.")
            end
        end
    end
    -- (empty send to actor)
end
if actor:get_quest_stage("ice_wand") > 0 then
    self.room:send("<b:cyan>ICE</>")
    if actor:get_has_completed("ice_wand") then
        self:say("It looks like you already have the most powerful staff of ice in existence!")
    elseif actor:get_quest_stage("ice_wand") == 1 then
        self:say("Let me see " .. tostring(objects.template(2, 120).name) .. ".")
    elseif actor:get_quest_stage("ice_wand") == 2 then
        self:say("I am crafting a new ice wand for you.")
        if dg.flag(actor:get_quest_var("ice_wand:wandtask1")) and dg.flag(actor:get_quest_var("ice_wand:wandtask2")) then
            -- (empty room echo)
            self.room:send("Simply give me your " .. tostring(objects.template(2, 120).name) .. ".")
        else
            if dg.flag(actor:get_quest_var("ice_wand:wandtask1")) or dg.flag(actor:get_quest_var("ice_wand:wandtask2")) then
                -- (empty room echo)
                self.room:send("You have done the following:")
                if dg.flag(actor:get_quest_var("ice_wand:wandtask1")) then
                    self.room:send("- used your wand " .. tostring(times) .. " times")
                end
                if dg.flag(actor:get_quest_var("ice_wand:wandtask2")) then
                    self.room:send("- brought " .. tostring(objects.template(555, 74).name))
                end
            end
            -- (empty room echo)
            self.room:send("You still need to:")
            if not dg.flag(actor:get_quest_var("ice_wand:wandtask1")) then
                local remaining = times - (actor:get_quest_var("ice_wand:attack_counter") or 0)
                self.room:send("- <b:yellow>attack " .. tostring(remaining) .. " more times with your " .. tostring(weapon) .. "</>")
            end
            if not dg.flag(actor:get_quest_var("ice_wand:wandtask2")) then
                self.room:send("- <b:yellow>bring me " .. tostring(objects.template(555, 74).name) .. "</>")
            end
        end
    else
        if actor:get_quest_stage("ice_wand") > 2 then
            self:say("I can't help you with ice anymore, but I know who can.")
            -- (empty room echo)
            local stage = actor:get_quest_stage("ice_wand")
            if stage == 3 then
                self:say("The shaman near Three-Falls River has developed a powerful affinity for water from his life in the canyons.  Seek his advice.")
            elseif stage == 4 then
                self:say("Many of the best craftspeople aren't even mortal.  There is a water sprite of some renown deep in Anlun Vale.")
            elseif stage == 5 then
                self:say("A master of spirits in the far north will be able to help next.")
            elseif stage == 6 then
                self:say("Your next crafter is a distant relative of the Sunfire clan.  He's been squatting in a flying fortress for many months, trying to unlock its secrets.")
            elseif stage == 7 then
                self:say("You'll need the advice of a master ice sculptor.  One works regularly up in Mt. Frostbite.")
            elseif stage == 8 then
                self:say("There's another distant relative of the Sunfire clan who runs the hot springs near Ickle.  He's book smart and knows a thing or two about jewel crafting.")
            elseif stage == 9 then
                self:say("The guild guard for the Sorcerer Guild in Ickle has learned plenty of secrets from the inner sanctum.  Talk to him.")
            elseif stage == 10 then
                self:say("You must know Suralla Iceeye by now.  She's the master artisan of cold and ice.  She'll know how to make the final improvements to your staff.")
            end
        end
    end
    -- (empty send to actor)
end
if actor:get_quest_stage("acid_wand") > 0 then
    self.room:send("<b:green>ACID</>")
    if actor:get_has_completed("acid_wand") then
        self:say("It looks like you already have the most powerful staff of acid in existence!")
    elseif actor:get_quest_stage("acid_wand") == 1 then
        self:say("Let me see " .. tostring(objects.template(2, 130).name) .. ".")
    elseif actor:get_quest_stage("acid_wand") == 2 then
        self:say("I am crafting a new acid wand for you.")
        if dg.flag(actor:get_quest_var("acid_wand:wandtask1")) and dg.flag(actor:get_quest_var("acid_wand:wandtask2")) then
            -- (empty room echo)
            self.room:send("Simply give me your " .. tostring(objects.template(2, 130).name) .. ".")
        else
            if dg.flag(actor:get_quest_var("acid_wand:wandtask1")) or dg.flag(actor:get_quest_var("acid_wand:wandtask2")) then
                -- (empty room echo)
                self.room:send("You have done the following:")
                if dg.flag(actor:get_quest_var("acid_wand:wandtask1")) then
                    self.room:send("- used your wand " .. tostring(times) .. " times")
                end
                if dg.flag(actor:get_quest_var("acid_wand:wandtask2")) then
                    self.room:send("- brought " .. tostring(objects.template(555, 76).name))
                end
            end
            -- (empty room echo)
            self.room:send("You still need to:")
            if not dg.flag(actor:get_quest_var("acid_wand:wandtask1")) then
                local remaining = times - (actor:get_quest_var("acid_wand:attack_counter") or 0)
                self.room:send("- <b:yellow>attack " .. tostring(remaining) .. " more times with your " .. tostring(weapon) .. "</>")
            end
            if not dg.flag(actor:get_quest_var("acid_wand:wandtask2")) then
                self.room:send("- <b:yellow>bring me " .. tostring(objects.template(555, 76).name) .. "</>")
            end
        end
    else
        if actor:get_quest_stage("acid_wand") > 2 then
            self:say("I can't help you with acid anymore, but I know who can.")
            -- (empty room echo)
            local stage = actor:get_quest_stage("acid_wand")
            if stage == 3 then
                self:say("First, seek the one who guards the eastern gates of Ickle.")
            elseif stage == 4 then
                self:say("The next two artisans dwell in the Rhell Forest south-east of Mielikki.")
            elseif stage == 5 then
                self:say("Your next crafter isn't exactly part of the ranger network...  It's not actually a person at all.  Find the treant in the Rhell forest and ask it for guidance.")
            elseif stage == 6 then
                self:say("The ranger who guards the massive necropolis near Anduin has wonderful insights on crafting with decay.")
            elseif stage == 7 then
                self:say("Your next guide may be hard to locate...  I believe they guard the entrance to a long-lost kingdom beyond a frozen desert.")
            elseif stage == 8 then
                self:say("Next, consult with another ranger who guards a place crawling with the dead.  The dwarf ranger in the iron hills will know how to help you.")
            elseif stage == 9 then
                self:say("The guard of the only known Ranger Guild in the world is also an excellent craftswoman.  Consult with her.")
            elseif stage == 10 then
                self:say("Your last guide is the head of the ranger network himself, Eleweiss.  He can help make the final improvements to your staff.")
            end
        end
    end
end$trig$, '09cd1d5d0e6b9ae5ea1746c00debcd9d'),
  -- data/triggers/002/002_114_phase_wand_status_checker_questmasters.lua
  (2, 114, $trig$local dg = require("dg")

local function oname(vnum) return dg.oname(vnum) end
local function mname(vnum) return dg.mname(vnum) end
-- A quest flag is set when it holds a non-zero value (0 is truthy in Lua).
local set_ = dg.flag

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
                    local imbue = get_room(dg.room(IMBUE_ROOM[quest_type]))
                    room:send("- imbue your " .. weapon .. " at " .. tostring(imbue and imbue.name) .. ".")
                end
            elseif wandstep == 10 then
                local imbue = get_room(dg.room(wandtask4))
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
return true$trig$, '6559c9fa94cdf48aaede334ae43cf950'),
  -- data/triggers/002/002_115_phase_mace_speech_upgrade.lua
  (2, 115, $trig$-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local dg = require("dg")
local function proto_short(vnum) return dg.oname(vnum) end
local speech_padded = " " .. string.lower(speech or "") .. " "
local speech_hit = false
for _, w in ipairs({"upgrade", "upgrades", "upgrading", "improvement", "improvements", "improving"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
if (self.zone_id == 185 and self.id == 2) then
    self:set_flag("sentinel", true)
end
wait(2)
if actor.class == "cleric" or actor.class == "priest" then
    local macestep = globals.macestep
    if macestep then
        local minlevel = macestep * 10
        local stage = actor:get_quest_stage("phase_mace")
        local maceattack = globals.maceattack
        if stage == macestep then
            if actor.level >= minlevel then
                actor:set_quest_var("phase_mace", "greet", 1)
                actor:send(tostring(self.name) .. " says, 'I can add benedictions to your mace, yes.'")
                actor:send(tostring(self.name) .. " says, 'You'll need to use your mace <b:yellow>" .. tostring(maceattack) .. "</> times.'")
                actor:send(tostring(self.name) .. " says, 'I'll also need the following:'")
                actor:send("- <b:yellow>" .. proto_short(globals.maceitem2) .. "</>, for its spiritual protection.")
                if macestep ~= 2 then
                    actor:send("- <b:yellow>" .. proto_short(globals.maceitem3) .. "</>, as a model for the new mace.")
                    actor:send("- <b:yellow>" .. proto_short(globals.maceitem4) .. "</>, for its power in fighting the undead.")
                    actor:send("- <b:yellow>" .. proto_short(globals.maceitem5) .. "</>, for its guiding light.")
                else
                    actor:send(tostring(self.name) .. " says, 'And you'll need to make a pilgrimage to four burial grounds to see what lies ahead on your journey:'")
                    actor:send("- <b:yellow>the necropolis near Anduin</>")
                    actor:send("- <b:yellow>the pyramid in the Gothra desert</>")
                    actor:send("- <b:yellow>the ancient barrow in the Iron Hills</>")
                    actor:send("- <b:yellow>the cemetary outside the Cathedral of Betrayal</>")
                    actor:send(tostring(self.name) .. " says, 'Be warned, these places are <red>exceedingly dangerous!</>'")
                    wait(2)
                    dg.give(self, self:spawn_object(185, 26), actor)
                    actor:send(tostring(self.name) .. " says, 'Holding this spade, <b:cyan>[dig]</> up a handful of dirt from each of these places and bring it back to me as a token of your journey.'")
                end
                actor:send(tostring(self.name) .. " says, 'You can check your <b:cyan>[mace progress]</> at any time.'")
            else
                actor:send(tostring(self.name) .. " says, 'You'll need to be at least level " .. tostring(minlevel) .. " before I can improve your bond with your weapon.'")
            end
        elseif actor:get_has_completed("phase_mace") then
            actor:send(tostring(self.name) .. " says, 'There is no weapon greater than the mace of disruption!'")
        elseif (stage or 0) < macestep then
            actor:send(tostring(self.name) .. " says, 'Your mace isn't ready for improvement yet.'")
        elseif stage > macestep then
            actor:send(tostring(self.name) .. " says, 'I've done all I can already.'")
            wait(1)
            if stage == 3 then     actor:send(tostring(self.name) .. " says, 'The Cleric Guild is capable of some miraculous crafting.  Visit the Cleric Guild Master in the Arctic Village of Ickle and talk to High Priest Zalish.  He should be able to help you.'")
            elseif stage == 4 then actor:send(tostring(self.name) .. " says, 'Continue with the Cleric Guild Masters.  Check in with the High Priestess in the City of Anduin.'")
            elseif stage == 5 then actor:send(tostring(self.name) .. " says, 'Sometimes to battle the dead, we need to use their own dark natures against them.  Few are as knowledgeable about the dark arts as Ziijhan, the Defiler, in the Cathedral of Betrayal.'")
            elseif stage == 6 then actor:send(tostring(self.name) .. " says, 'Return again to the Abbey of St. George and seek out Silania.  Her mastery of spiritual matters will be necessary to improve this mace any further.'")
            elseif stage == 7 then actor:send(tostring(self.name) .. " says, 'Of the few remaining who are capable of improving your mace, one is a priest of a god most foul.  Find Ruin Wormheart, that most heinous of Blackmourne's servators.'")
            elseif stage == 8 then actor:send(tostring(self.name) .. " says, 'The most powerful force in the war against the dead is the sun itself.  Consult with the sun's Oracle in the ancient pyramid near Anduin.'")
            elseif stage == 9 then actor:send(tostring(self.name) .. " says, 'With everything prepared, return to the very beginning of your journey.  The High Priestess of Mielikki, the very center of the Cleric Guild, will know what to do.'")
            end
        end
    end
end
if (self.zone_id == 185 and self.id == 2) then
    self:set_flag("sentinel", false)
end
return true$trig$, 'e8f5b5a227860d3e6aab8752376f365b'),
  -- data/triggers/002/002_116_phase_mace_progress.lua
  (2, 116, $trig$-- Speech phrase: mace progress (DG num_arg 0 = the speech contains the whole phrase, on word boundaries)
local dg = require("dg")
local function proto_short(vnum) return dg.oname(vnum) end
local speech_padded = " " .. string.lower(speech or "") .. " "
if not string.find(speech_padded, "[%s%p]mace progress[%s%p]") then
    return true  -- Not the phrase
end
wait(2)
if actor.class ~= "cleric" and actor.class ~= "priest" then
    actor:send(tostring(self.name) .. " says, 'This weapon is only for servants of the gods.'")
    return true
end
local macestep = globals.macestep
if not macestep then return true end
local maceattack = globals.maceattack
local stage = actor:get_quest_stage("phase_mace")
local job1 = dg.flag(actor:get_quest_var("phase_mace:macetask1"))
local job2 = dg.flag(actor:get_quest_var("phase_mace:macetask2"))
local job3 = dg.flag(actor:get_quest_var("phase_mace:macetask3"))
local job4 = dg.flag(actor:get_quest_var("phase_mace:macetask4"))
local job5 = dg.flag(actor:get_quest_var("phase_mace:macetask5"))
local job6 = dg.flag(actor:get_quest_var("phase_mace:macetask6"))
if actor:get_has_completed("phase_mace") then
    actor:send(tostring(self.name) .. " says, 'There is no weapon greater than the mace of disruption!'")
elseif stage == macestep and actor.level >= macestep * 10 then
    if (actor:get_quest_var("phase_mace:greet") or 0) == 0 then
        actor:send(tostring(self.name) .. " says, 'Tell me why you're here first.'")
    else
        actor:send(tostring(self.name) .. " says, 'I'm improving your mace.'")
        if job1 or job2 or job3 or job4 or job5 then
            actor:send(tostring(self.name) .. " says, 'You've done the following:'")
            if job1 then actor:send("- attacked " .. tostring(maceattack) .. " times") end
            if job2 then actor:send("- found " .. proto_short(globals.maceitem2)) end
            if job3 then actor:send("- found " .. proto_short(globals.maceitem3)) end
            if job4 then actor:send("- found " .. proto_short(globals.maceitem4)) end
            if job5 then actor:send("- found " .. proto_short(globals.maceitem5)) end
        end
        actor:send("You need to:")
        if job1 and job2 and job3 and job4 and job5 then
            if macestep ~= 2 then
                actor:send("Just give me your mace.")
                return true
            else
                if job6 then
                    actor:send("Just give me your mace.")
                    return true
                end
            end
        end
        if not job1 then
            local remaining = (stage * 50) - (actor:get_quest_var("phase_mace:attack_counter") or 0)
            if remaining > 1 then
                actor:send("- <b:yellow>attack " .. tostring(remaining) .. " more times with your mace</>")
            else
                actor:send("- <b:yellow>attack " .. tostring(remaining) .. " more time with your mace</>")
            end
        end
        if not job2 then actor:send("- <b:yellow>find " .. proto_short(globals.maceitem2) .. "</>") end
        if not job3 then actor:send("- <b:yellow>find " .. proto_short(globals.maceitem3) .. "</>") end
        if not job4 then actor:send("- <b:yellow>find " .. proto_short(globals.maceitem4) .. "</>") end
        if not job5 then actor:send("- <b:yellow>find " .. proto_short(globals.maceitem5) .. "</>") end
        if macestep == 2 and not job6 then
            actor:send("- <b:yellow>find " .. proto_short(globals.maceitem6) .. "</>")
        end
    end
elseif (stage or 0) > 0 and stage > macestep then
    if stage == 2 then     actor:send(tostring(self.name) .. " says, 'Someone familiar with the grave will be able to work on this mace.  Seek out the Sexton in the Abbey west of the Village of Mielikki.'")
    elseif stage == 3 then actor:send(tostring(self.name) .. " says, 'The Cleric Guild is capable of some miraculous crafting.  Visit the Cleric Guild Master in the Arctic Village of Ickle and talk to High Priest Zalish.  He should be able to help you.'")
    elseif stage == 4 then actor:send(tostring(self.name) .. " says, 'Continue with the Cleric Guild Masters.  Check in with the High Priestess in the City of Anduin.'")
    elseif stage == 5 then actor:send(tostring(self.name) .. " says, 'Sometimes to battle the dead, we need to use their own dark natures against them.  Few are as knowledgeable about the dark arts as Ziijhan, the Defiler, in the Cathedral of Betrayal.'")
    elseif stage == 6 then actor:send(tostring(self.name) .. " says, 'Return again to the Abbey of St. George and seek out Silania.  Her mastery of spiritual matters will be necessary to improve this mace any further.'")
    elseif stage == 7 then actor:send(tostring(self.name) .. " says, 'Of the few remaining who are capable of improving your mace, one is a priest of a god most foul.  Find Ruin Wormheart, that most heinous of Blackmourne's servators.'")
    elseif stage == 8 then actor:send(tostring(self.name) .. " says, 'The most powerful force in the war against the dead is the sun itself.  Consult with the sun's Oracle in the ancient pyramid near Anduin.'")
    elseif stage == 9 then actor:send(tostring(self.name) .. " says, 'With everything prepared, return to the very beginning of your journey.  The High Priestess of Mielikki, the very center of the Cleric Guild, will know what to do.'")
    end
elseif (stage or 0) < macestep then
    actor:send(tostring(self.name) .. " says, 'You need to make more improvements to your mace before I can work with it.'")
elseif actor.level < macestep * 10 then
    actor:send(tostring(self.name) .. " says, 'Come back after you've gained some more experience.  I can help you then.'")
end
return true$trig$, 'dbb1028f6c03b4921f71903cc87a54a3'),
  -- data/triggers/002/002_119_phase_mace_attack_counter_and_damage.lua
  (2, 119, $trig$local dg = require("dg")
local vnum = dg.to_vnum(self.zone_id, self.id)
if actor:get_quest_stage("phase_mace") >= 1 then
    if not dg.flag(actor:get_quest_var("phase_mace:macetask1")) then
        local attack_increase = (actor:get_quest_var("phase_mace:attack_counter") or 0) + 1
        actor:set_quest_var("phase_mace", "attack_counter", attack_increase)
        if (actor:get_quest_var("phase_mace:attack_counter") or 0) >= actor:get_quest_stage("phase_mace") * 50 then
            actor:set_quest_var("phase_mace", "macetask1", 1)
            actor:send("<b:white>You have perfected your bond with " .. tostring(self.shortdesc) .. "!</>")
        end
    end
end
if random(1, 4) > 1 then
    local skill = self.level
    local spell
    if victim.composition == "ether" and victim.lifeforce == "undead" then
        if vnum == 340 or vnum == 341 then
            return true
        elseif vnum == 342 or vnum == 343 or vnum == 344 or vnum == 345 then
            spell = "divine bolt"
        elseif vnum == 346 or vnum == 347 or vnum == 348 or vnum == 349 then
            spell = "divine ray"
        end
        if spell then
            spells.cast(self, spell, victim, skill)
        end
    elseif victim.lifeforce == "undead" or victim.lifeforce == "demonic" or victim.race == "demon" then
        skill = skill // 2
        if vnum == 340 or vnum == 341 or vnum == 342 then
            return true
        elseif vnum >= 343 and vnum <= 349 then
            spell = "divine bolt"
        end
        if spell then
            spells.cast(self, spell, victim, skill)
        end
    end
end$trig$, '6d2a23c31bed8ad93f35523fd7faf121'),
  -- data/triggers/002/002_120_phase_mace_dig_trigger.lua
  (2, 120, $trig$-- Command location mask 1: legacy OCMD_EQUIP=1 (worn), OCMD_INVEN=2 (carried), OCMD_ROOM=4 (floor)
if not (location == "equip") then
    return true  -- Not in a location this trigger watches
end
local dg = require("dg")

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
end
local room = actor.room
local here = room and dg.to_vnum(room.zone_id, room.id) or 0
local dig, item, num
if here >= 47000 and here <= 47404 then
    -- Graveyard
    dig, item, num = "yes", 22, 3
elseif here >= 8504 and here <= 8509 then
    -- Cathedral
    dig, item, num = "yes", 23, 4
elseif here >= 16200 and here <= 16299 then
    -- Pyramid
    dig, item, num = "yes", 24, 5
elseif here >= 48000 and here <= 48099 then
    -- Barrow
    dig, item, num = "yes", 25, 6
end
if dig == "yes" then
    actor:send("You dig up a handful of dirt.")
    actor:spawn_object(185, item)
    actor:set_quest_var("phase_mace", "dirt" .. tostring(num), 1)
    if dg.flag(actor:get_quest_var("phase_mace:dirt3")) and dg.flag(actor:get_quest_var("phase_mace:dirt4"))
            and dg.flag(actor:get_quest_var("phase_mace:dirt5")) and dg.flag(actor:get_quest_var("phase_mace:dirt6")) then
        if not actor:get_quest_var("phase_mace:graves") then
            actor:send("<b:yellow>You have completed your pilgrimage.</>")
            actor:set_quest_var("phase_mace", "graves", "done")
        end
    end
else
    actor:send("This isn't the proper place to dig for grave dirt.")
end
return false$trig$, 'd7c1d8135a53a8fe69a378f8973a0c9f'),
  -- data/triggers/002/002_126_phase_mace_receive.lua
  (2, 126, $trig$local dg = require("dg")

local function vkey(vnum) return dg.obj(vnum) end
local function oname(vnum) return dg.oname(vnum) end
local function is_obj(vnum) return dg.is_obj(object, vnum) end
-- A quest flag is set when it holds a non-zero value (0 is truthy in Lua).
local set_ = dg.flag

local function give_back()
    dg.give(self, object, actor)
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
    give_back()
    actor:send(self.name .. " refuses " .. object.shortdesc .. ".")
    wait(0.2)
    says(response)
end

if priest then
    self:set_flag("sentinel", false)
end
return true$trig$, '2682fd0d23fe27548f8c56c9beda48a6'),
  -- data/triggers/002/002_127_phase_wand_play.lua
  (2, 127, $trig$local dg = require("dg")

local quest_type, wand_key, wand_name, reward
if (self.zone_id == 590 and self.id == 40) then
    quest_type, wand_key, wand_name, reward = "air", 104, "wand-sky", 105
elseif (self.zone_id == 161 and self.id == 7) then
    quest_type, wand_key, wand_name, reward = "acid", 134, "wand-tomb", 135
elseif (self.zone_id == 324 and self.id == 12) then
    quest_type, wand_key, wand_name, reward = "fire", 114, "wand-blazes", 115
elseif (self.zone_id == 173 and self.id == 9) then
    quest_type, wand_key, wand_name, reward = "ice", 124, "wand-snow", 125
end
if not quest_type then
    return true
end

local quest = quest_type .. "_wand"
if actor:get_quest_stage(quest) ~= 6 then return true end
if not dg.flag(actor:get_quest_var(quest .. ":wandtask5")) then return true end
if not (actor:has_equipped(2, wand_key) or actor:has_item(2, wand_key)) then
    return true
end

actor:advance_quest(quest)
local old_name = objects.template(2, wand_key).name
local new_name = objects.template(2, reward).name
self.room:send(old_name .. " begins to resonate in harmony with " .. tostring(self.shortdesc) .. "!")
wait(4)
self.room:send(old_name .. " vibrates right out of your hands!")
actor:destroy_item(wand_name)
self.room:send("In a brilliant <b:white>FLASH</> " .. old_name .. " transforms into " .. new_name .. "!")
actor:spawn_object(2, reward)

local expmod = 9240
if actor.class == "warrior" or actor.class == "berserker" then
    expmod = expmod + math.floor(expmod / 10)
elseif actor.class == "paladin" or actor.class == "anti-paladin" or actor.class == "ranger" then
    expmod = expmod + math.floor((expmod * 2) / 15)
elseif actor.class == "sorcerer" or actor.class == "pyromancer" or actor.class == "cryomancer" or actor.class == "illusionist" or actor.class == "bard" then
    expmod = expmod + math.floor(expmod / 5)
elseif actor.class == "necromancer" or actor.class == "monk" then
    expmod = expmod + math.floor((expmod * 2) / 5)
end
actor:send("<b:yellow>You gain experience!</>")
local setexp = expmod * 10
for _ = 1, 5 do
    actor:award_exp(setexp)
end
actor:set_quest_var(quest, "greet", 0)
actor:set_quest_var(quest, "attack_counter", 0)
for n = 1, 5 do
    actor:set_quest_var(quest, "wandtask" .. tostring(n), 0)
end
return true$trig$, '023a324200e2a28b1dfcbe09b74d2bfa'),
  -- data/triggers/004/004_22_combat_in_eldoria_progress_journal.lua
  (4, 22, $trig$-- Converted from DG Script #422: Combat in Eldoria progress journal
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
local function proto_noa(vnum)
    local zone, id = proto_key(vnum)
    if not zone then return "[no description for object " .. tostring(vnum) .. "]" end
    return get_obj_noadesc(zone, id)
end
local function proto_plural(vnum)
    local s = proto_short(vnum)
    if string.lower(string.sub(s, 1, 5)) == "some " then
        return "quantities of " .. string.sub(s, 6)
    end
    local u = proto_noa(vnum)
    local last2, last1 = string.sub(u, -2, -2), string.sub(u, -1)
    local function consonant(c) return c:match("%a") ~= nil and not c:match("[aeiouAEIOU]") end
    if #u < 2 then return u .. "'s" end
    if last1 == "s" and last2 ~= "s" then return u end  -- already plural ("mittens")
    if (last2 == "e" or last2 == "i") and last1 == "z" then return u .. "zes" end
    if last1 == "x" or last1 == "z" or u:sub(-2) == "sh" or u:sub(-2) == "ss" or u:sub(-2) == "ch"
       or (consonant(last2) and last1 == "o") then
        return u .. "es"
    end
    if consonant(last2) and last1 == "y" then return u:sub(1, -2) .. "ies" end
    return u .. "s"
end
local _return_value = true  -- Default: allow action
if string.find(arg, "combat in eldoria") or string.find(arg, "combat_in_eldoria") or string.find(arg, "third eldorian guard") or string.find(arg, "third black legion") or string.find(arg, "black_legion") or string.find(arg, "eldorian_guard") or string.find(arg, "third_black_legion") or string.find(arg, "third_eldorian_guard") or string.find(arg, "combat") or string.find(arg, "eldoria") then
    _return_value = true
    actor:send("<b:u:green>Combat in Eldoria</>")
    actor:send("The Third Black Legion and the Eldorian Guard, along with their allies in Split Skull and the Abbey, are locked in eternal warfare.")
    actor:send("Characters may align themselves with the forces of good or the forces of evil.")
    actor:send("But beware, once made that decision cannot be changed!")
    actor:send("Minimum Level: 10")
    if actor:get_quest_stage("black_legion") > 0 then
        actor:send("<cyan>Status: Continuous</>_")
        local id_trophy1
        local id_trophy2
        local id_trophy3
        local id_trophy4
        local id_trophy5
        local id_trophy6
        local id_trophy7
        local id_gem_cap
        local id_gem_neck
        local id_gem_arm
        local id_gem_wrist
        local id_gem_gloves
        local id_gem_jerkin
        local id_gem_robe
        local id_gem_belt
        local id_gem_legs
        local id_gem_boots
        local id_gem_mask
        local id_gem_symbol
        local id_gem_staff
        local id_gem_ssword
        local id_gem_whammer
        local id_gem_flail
        local id_gem_shiv
        local id_gem_lsword
        local id_gem_smace
        local id_gem_light
        local id_gem_food
        local id_gem_drink
        local id_cap
        local id_neck
        local team_a_idrm
        local id_wrist
        local id_gloves
        local id_jerkin
        local team_b_idelt
        local id_legs
        local team_b_idoots
        local id_mask
        local id_robe
        local id_symbol
        local id_staff
        local id_ssword
        local id_whammer
        local id_flail
        local id_shiv
        local id_lsword
        local id_smace
        local id_light
        local id_food
        local id_drink
        local legion
        local master
        local status
        if actor:get_quest_var("black_legion:bl_ally") then
            id_trophy1 = 5504
            id_trophy2 = 5506
            id_trophy3 = 5508
            id_trophy4 = 5510
            id_trophy5 = 5512
            id_trophy6 = 5514
            id_trophy7 = 5516
            id_gem_cap = 55570
            id_gem_neck = 55571
            id_gem_arm = 55572
            id_gem_wrist = 55573
            id_gem_gloves = 55574
            id_gem_jerkin = 55575
            id_gem_robe = 55589
            id_gem_belt = 55576
            id_gem_legs = 55577
            id_gem_boots = 55578
            id_gem_mask = 55579
            id_gem_symbol = 55580
            id_gem_staff = 55581
            id_gem_ssword = 55582
            id_gem_whammer = 55583
            id_gem_flail = 55584
            id_gem_shiv = 55585
            id_gem_lsword = 55586
            id_gem_smace = 55587
            id_gem_light = 55588
            id_gem_food = 55566
            id_gem_drink = 55567
            id_cap = 5517
            id_neck = 5519
            team_a_idrm = 5521
            id_wrist = 5523
            id_gloves = 5525
            id_jerkin = 5527
            team_b_idelt = 5529
            id_legs = 5531
            team_b_idoots = 5533
            id_mask = 5535
            id_robe = 5537
            id_symbol = 5515
            id_staff = 5539
            id_ssword = 5540
            id_whammer = 5541
            id_flail = 5542
            id_shiv = 5543
            id_lsword = 5544
            id_smace = 5545
            id_light = 5553
            id_food = 5555
            id_drink = 5557
            legion = "Black Legion"
            master = mobiles.template(41, 27).name .. " and " .. mobiles.template(55, 12).name
            status = actor:get_quest_var("black_legion:bl_faction")
        elseif actor:get_quest_var("black_legion:eg_ally") then
            id_trophy1 = 5503
            id_trophy2 = 5505
            id_trophy3 = 5507
            id_trophy4 = 5509
            id_trophy5 = 5511
            id_trophy6 = 5513
            id_trophy7 = 5515
            id_gem_cap = 55570
            id_gem_neck = 55571
            id_gem_arm = 55572
            id_gem_wrist = 55573
            id_gem_gloves = 55574
            id_gem_jerkin = 55575
            id_gem_robe = 55589
            id_gem_belt = 55576
            id_gem_legs = 55577
            id_gem_boots = 55578
            id_gem_mask = 55579
            id_gem_symbol = 55580
            id_gem_staff = 55581
            id_gem_ssword = 55582
            id_gem_whammer = 55583
            id_gem_flail = 55584
            id_gem_shiv = 55585
            id_gem_lsword = 55586
            id_gem_smace = 55587
            id_gem_light = 55588
            id_gem_food = 55566
            id_gem_drink = 55567
            id_cap = 5518
            id_neck = 5520
            team_a_idrm = 5522
            id_wrist = 5524
            id_gloves = 5526
            id_jerkin = 5528
            team_b_idelt = 5530
            id_legs = 5532
            team_b_idoots = 5534
            id_mask = 5536
            id_robe = 5538
            id_symbol = 5516
            id_staff = 5546
            id_ssword = 5547
            id_whammer = 5548
            id_flail = 5549
            id_shiv = 5550
            id_lsword = 5551
            id_smace = 5552
            id_light = 5554
            id_food = 5556
            id_drink = 5558
            legion = "Eldorian Guard"
            master = mobiles.template(186, 99).name .. " and " .. mobiles.template(55, 24).name
            status = actor:get_quest_var("black_legion:eg_faction")
        end
        actor:send("You are pledged to the " .. tostring(legion) .. ".")
        actor:send("Quest Master: " .. tostring(master))
        -- osend %actor% &0
        -- osend %actor% The %legion% is interested in:
        -- osend %actor% - %get.obj_shortdesc[%id_trophy1%]%
        -- osend %actor% - %get.obj_shortdesc[%id_trophy2%]%
        -- osend %actor% - %get.obj_shortdesc[%id_trophy3%]%
        -- osend %actor% - %get.obj_shortdesc[%id_trophy4%]%
        -- osend %actor% - %get.obj_shortdesc[%id_trophy5%]%
        -- osend %actor% - %get.obj_shortdesc[%id_trophy6%]%
        -- osend %actor% - %get.obj_shortdesc[%id_trophy7%]%
        actor:send("</>")
        actor:send("You have turned in:")
        actor:send(tostring(actor:get_quest_var("black_legion:" .. tostring(id_trophy1) .. "_trophies")) .. " " .. proto_plural(id_trophy1))
        actor:send(tostring(actor:get_quest_var("black_legion:" .. tostring(id_trophy2) .. "_trophies")) .. " " .. proto_plural(id_trophy2))
        actor:send(tostring(actor:get_quest_var("black_legion:" .. tostring(id_trophy3) .. "_trophies")) .. " " .. proto_plural(id_trophy3))
        actor:send(tostring(actor:get_quest_var("black_legion:" .. tostring(id_trophy4) .. "_trophies")) .. " " .. proto_plural(id_trophy4))
        actor:send(tostring(actor:get_quest_var("black_legion:" .. tostring(id_trophy5) .. "_trophies")) .. " " .. proto_plural(id_trophy5))
        actor:send(tostring(actor:get_quest_var("black_legion:" .. tostring(id_trophy6) .. "_trophies")) .. " " .. proto_plural(id_trophy6))
        actor:send(tostring(actor:get_quest_var("black_legion:" .. tostring(id_trophy7) .. "_trophies")) .. " " .. proto_plural(id_trophy7))
        actor:send("</>")
        actor:send("Your current " .. tostring(legion) .. " faction status is " .. tostring(status) .. ".")
        if status >= 200 then
            actor:send("You have reached the maximum faction status.")
        end
        actor:send("</>")
        if status >= 20 then
            actor:send("You have access to:")
            actor:send("<b:yellow>" .. proto_short(id_food) .. "</> for <magenta>" .. proto_short(id_gem_food) .. "</>")
            actor:send("- times claimed: (" .. tostring(actor:get_quest_var("black_legion:" .. tostring(id_food) .. "_reward")) .. ")_")
            actor:send("<b:yellow>" .. proto_short(id_drink) .. "</> for <magenta>" .. proto_short(id_gem_drink) .. "</>")
            actor:send("- times claimed: (" .. tostring(actor:get_quest_var("black_legion:" .. tostring(id_drink) .. "_reward")) .. ")_")
            actor:send("<b:yellow>" .. proto_short(id_cap) .. "</> for <magenta>" .. proto_short(id_gem_cap) .. "</>")
            actor:send("- times claimed: (" .. tostring(actor:get_quest_var("black_legion:" .. tostring(id_cap) .. "_reward")) .. ")_")
            actor:send("<b:yellow>" .. proto_short(id_ssword) .. "</> for <magenta>" .. proto_short(id_gem_ssword) .. "</>")
            actor:send("- times claimed: (" .. tostring(actor:get_quest_var("black_legion:" .. tostring(id_ssword) .. "_reward")) .. ")_")
        end
        if status >= 40 then
            actor:send("<b:yellow>" .. proto_short(id_neck) .. "</> for <magenta>" .. proto_short(id_gem_neck) .. "</>")
            actor:send("- times claimed: (" .. tostring(actor:get_quest_var("black_legion:" .. tostring(id_neck) .. "_reward")) .. ")_")
            actor:send("<b:yellow>" .. proto_short(id_staff) .. "</> for <magenta>" .. proto_short(id_gem_staff) .. "</>")
            actor:send("- times claimed: (" .. tostring(actor:get_quest_var("black_legion:" .. tostring(id_staff) .. "_reward")) .. ")_")
        end
        if status >= 55 then
            actor:send("<b:yellow>" .. proto_short(team_a_idrm) .. "</> for <magenta>" .. proto_short(id_gem_arm) .. "</>")
            actor:send("- times claimed: (" .. tostring(actor:get_quest_var("black_legion:" .. tostring(team_a_idrm) .. "_reward")) .. ")_")
            actor:send("<b:yellow>" .. proto_short(id_whammer) .. "</> for <magenta>" .. proto_short(id_gem_whammer) .. "</>")
            actor:send("- times claimed: (" .. tostring(actor:get_quest_var("black_legion:" .. tostring(id_whammer) .. "_reward")) .. ")_")
        end
        if status >= 70 then
            actor:send("<b:yellow>" .. proto_short(id_wrist) .. "</> for <magenta>" .. proto_short(id_gem_wrist) .. "</>")
            actor:send("- times claimed: (" .. tostring(actor:get_quest_var("black_legion:" .. tostring(id_wrist) .. "_reward")) .. ")_")
            actor:send("<b:yellow>" .. proto_short(id_flail) .. "</> for <magenta>" .. proto_short(id_gem_flail) .. "</>")
            actor:send("- times claimed: (" .. tostring(actor:get_quest_var("black_legion:" .. tostring(id_flail) .. "_reward")) .. ")_")
        end
        if status >= 85 then
            actor:send("<b:yellow>" .. proto_short(id_gloves) .. "</> for <magenta>" .. proto_short(id_gem_gloves) .. "</>")
            actor:send("- times claimed: (" .. tostring(actor:get_quest_var("black_legion:" .. tostring(id_gloves) .. "_reward")) .. ")_")
            actor:send("<b:yellow>" .. proto_short(id_symbol) .. "</> for <magenta>" .. proto_short(id_gem_symbol) .. "</>")
            actor:send("- times claimed: (" .. tostring(actor:get_quest_var("black_legion:" .. tostring(id_symbol) .. "_reward")) .. ")_")
            actor:send("<b:yellow>" .. proto_short(id_light) .. "</> for <magenta>" .. proto_short(id_gem_light) .. "</>")
            actor:send("- times claimed: (" .. tostring(actor:get_quest_var("black_legion:" .. tostring(id_light) .. "_reward")) .. ")_")
        end
        if status >= 100 then
            actor:send("<b:yellow>" .. proto_short(team_b_idelt) .. "</> for <magenta>" .. proto_short(id_gem_belt) .. "</>")
            actor:send("- times claimed: (" .. tostring(actor:get_quest_var("black_legion:" .. tostring(team_b_idelt) .. "_reward")) .. ")_")
            actor:send("<b:yellow>" .. proto_short(id_shiv) .. "</> for <magenta>" .. proto_short(id_gem_shiv) .. "</>")
            actor:send("- times claimed: (" .. tostring(actor:get_quest_var("black_legion:" .. tostring(id_shiv) .. "_reward")) .. ")_")
        end
        if status >= 115 then
            actor:send("<b:yellow>" .. proto_short(team_b_idoots) .. "</> for <magenta>" .. proto_short(id_gem_boots) .. "</>")
            actor:send("- times claimed: (" .. tostring(actor:get_quest_var("black_legion:" .. tostring(team_b_idoots) .. "_reward")) .. ")_")
            actor:send("<b:yellow>" .. proto_short(id_lsword) .. "</> for <magenta>" .. proto_short(id_gem_lsword) .. "</>")
            actor:send("- times claimed: (" .. tostring(actor:get_quest_var("black_legion:" .. tostring(id_lsword) .. "_reward")) .. ")_")
        end
        if status >= 130 then
            actor:send("<b:yellow>" .. proto_short(id_legs) .. "</> for <magenta>" .. proto_short(id_gem_legs) .. "</>")
            actor:send("- times claimed: (" .. tostring(actor:get_quest_var("black_legion:" .. tostring(id_legs) .. "_reward")) .. ")_")
        end
        if status >= 145 then
            actor:send("<b:yellow>" .. proto_short(id_robe) .. "</> for <magenta>" .. proto_short(id_gem_robe) .. "</>")
            actor:send("- times claimed: (" .. tostring(actor:get_quest_var("black_legion:" .. tostring(id_robe) .. "_reward")) .. ")_")
            actor:send("<b:yellow>" .. proto_short(id_jerkin) .. "</> for <magenta>" .. proto_short(id_gem_jerkin) .. "</>")
            actor:send("- times claimed: (" .. tostring(actor:get_quest_var("black_legion:" .. tostring(id_jerkin) .. "_reward")) .. ")_")
        end
        if status >= 160 then
            actor:send("<b:yellow>" .. proto_short(id_mask) .. "</> for <magenta>" .. proto_short(id_gem_mask) .. "</>")
            actor:send("- times claimed: (" .. tostring(actor:get_quest_var("black_legion:" .. tostring(id_mask) .. "_reward")) .. ")_")
            actor:send("<b:yellow>" .. proto_short(id_smace) .. "</> for <magenta>" .. proto_short(id_gem_smace) .. "</>")
            actor:send("- times claimed: (" .. tostring(actor:get_quest_var("black_legion:" .. tostring(id_smace) .. "_reward")) .. ")_")
        end
        if (status or 0) < 160 then
            actor:send("As your standing with the " .. tostring(legion) .. " improves you will have access to more rewards.")
        end
    else
        actor:send("<cyan>Status: Not Started</>")
    end
end
return _return_value$trig$, '053ac4bb5ab45bd2ede360f6fc2dc744'),
  -- data/triggers/004/004_49_air_wand_progress_journal.lua
  (4, 49, $trig$-- Converted from DG Script #449: Air Wand progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
-- Item, mob and room names go through the dg library: the legacy vnums are not zone * 100 + id
-- everywhere (zone 117 holds 11811, zone 30 holds 3218, ...), and a task flag that was reset to 0
-- counts as unset (dg.flag).
local dg = require("dg")
local function proto_short(vnum) return dg.oname(vnum) end
local function mob_short(vnum) return dg.mname(vnum) end
local function room_name(vnum) return dg.rname(vnum) end
local _return_value = true  -- Default: allow action
if (string.find(arg, "air") and (string.find(arg, "wand") or string.find(arg, "wands") or string.find(arg, "staff") or string.find(arg, "staves"))) or string.find(arg, "air_wand") or string.find(arg, "air_wands") or string.find(arg, "air_staff") then
    local sorcererclasses = "Sorcerer Illusionist Cryomancer Pyromancer Necromancer"
    if string.find(string.lower(sorcererclasses), actor.class, 1, true) then
        _return_value = true
        local stage = actor:get_quest_stage("air_wand")
        local minlevel = (stage - 1) * 10
        if minlevel < 1 then
            minlevel = 1
        end
        actor:send("<b:u:green>Air Wand</>")
        actor:send("Masters of air will help you create and upgrade a new mystic weapon.")
        if not actor:get_has_completed("air_wand") then
            actor:send("Minimum Level: " .. tostring(minlevel))
        end
        local status
        if actor:get_has_completed("air_wand") then
            status = "Completed!"
        elseif (stage or 0) > 0 then
            status = "In Progress"
        else
            status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
        if stage > 0 and not actor:get_has_completed("air_wand") then
            local job1 = dg.flag(actor:get_quest_var("air_wand:wandtask1"))
            local job2 = dg.flag(actor:get_quest_var("air_wand:wandtask2"))
            local job3 = dg.flag(actor:get_quest_var("air_wand:wandtask3"))
            local job4 = dg.flag(actor:get_quest_var("air_wand:wandtask4"))
            local job5 = dg.flag(actor:get_quest_var("air_wand:wandtask5"))
            local attack = (stage - 1) * 50
            local weapon
            if stage < 8 then
                weapon = "wand"
            else
                weapon = "staff"
            end
            local remaining = ((attack) - (actor:get_quest_var("air_wand:attack_counter") or 0))
            -- switch on stage
            local master
            local wandgem
            local hint
            local wandtask3
            local wandtask4
            local place
            do
                local _sw1 = string.lower(tostring(stage or ""))
                if tonumber(_sw1) == 2 then
                    master = mobiles.template(30, 13).name
                    wandgem = 55577
                elseif tonumber(_sw1) == 3 then
                    master = mobiles.template(185, 0).name
                    hint = "Speak with the old Abbot in the Abbey of St. George."
                    wandgem = 55591
                    wandtask3 = 23750
                elseif tonumber(_sw1) == 4 then
                    master = mobiles.template(586, 1).name
                    hint = "The keeper of a southern coastal tower will have advice for you."
                    wandgem = 55605
                    wandtask3 = 2330
                    wandtask4 = 37006
                elseif tonumber(_sw1) == 5 then
                    master = mobiles.template(123, 5).name
                    hint = "A master of air near the megalith in South Caelia will be able to help next."
                    wandgem = 55644
                    wandtask3 = 12509
                    wandtask4 = "<b:white>the icy ledge outside Technitzitlan</>"
                elseif tonumber(_sw1) == 6 then
                    master = mobiles.template(123, 2).name
                    wandgem = 55665
                    hint = "Seek out the warrior-witch at the center of the southern megalith."
                    wandtask3 = 23800
                    wandtask4 = 59040
                elseif tonumber(_sw1) == 7 then
                    master = mobiles.template(490, 3).name
                    wandgem = 55682
                    hint = "She's hard to deal with, but the Seer of Griffin Isle should have some additional guidance for you."
                    wandtask3 = 51014
                    wandtask4 = 23710
                elseif tonumber(_sw1) == 8 then
                    master = mobiles.template(85, 15).name
                    hint = "In the diabolist's church is a seer who cannot see.  He's a good resource for this kind of work."
                    wandgem = 55721
                    wandtask3 = 11799
                    wandtask4 = 53454
                elseif tonumber(_sw1) == 9 then
                    master = mobiles.template(62, 16).name
                    hint = "The guardian ranger of the Druid Guild in the Red City has some helpful crafting tips."
                    wandgem = 55742
                    wandtask3 = 49019
                    wandtask4 = 23803
                elseif tonumber(_sw1) == 10 then
                    master = mobiles.template(185, 81).name
                    hint = "Silania will help you craft the finest of air weapons."
                    wandgem = 11811
                    wandtask3 = 52001
                    wandtask4 = 48862
                end
            end
            if stage == 8 then
                place = 49007
            end
            if stage == 1 then
                actor:send("Find " .. tostring(mobiles.template(30, 13).name) .. " and show him your wand.")
                return _return_value
            else
                if actor.level >= minlevel then
                    if (actor:get_quest_var("air_wand:greet") or 0) == 0 and stage ~= 2 then
                        actor:send("Find the next master crafter and tell them why you have come.")
                        actor:send(tostring(hint))
                        return _return_value
                    else
                        actor:send("Quest Master: " .. tostring(master))
                        actor:send("</>")
                        if job1 or job2 or job3 or job4 then
                            actor:send("You've done the following:")
                            if job1 then
                                actor:send("- used your " .. tostring(weapon) .. " " .. tostring(attack) .. " times")
                            end
                            if job2 then
                                actor:send("- found " .. proto_short(wandgem))
                            end
                            if job3 then
                                if stage ~= 10 then
                                    actor:send("- found " .. proto_short(wandtask3))
                                else
                                    actor:send("- slayed " .. mob_short(wandtask3))
                                end
                            end
                            if job4 then
                                if stage ~= 5 and stage ~= 9 and stage ~= 10 then
                                    actor:send("- found " .. proto_short(wandtask4))
                                elseif stage == 5 then
                                    actor:send("- communed in " .. tostring(wandtask4))
                                elseif stage == 9 then
                                    actor:send("- slayed " .. mob_short(wandtask4))
                                end
                            end
                            actor:send("</>")
                        end
                        actor:send("You need to:")
                        if job1 and job2 then
                            if stage == 2 then
                                actor:send("bring " .. tostring(master) .. " your " .. tostring(weapon) .. ".")
                            else
                                if job3 then
                                    if stage == 3 then
                                        actor:send("bring " .. tostring(master) .. " your " .. tostring(weapon) .. ".")
                                    else
                                        if job4 then
                                            if stage ~= 6 and stage ~= 8 and stage ~= 10 then
                                                actor:send("Bring " .. tostring(master) .. " your " .. tostring(weapon) .. ".")
                                            elseif stage == 6 then
                                                if not job5 then
                                                    actor:send("bring " .. tostring(master) .. " your " .. tostring(weapon) .. ".")
                                                else
                                                    actor:send("- <b:cyan>play</> " .. proto_short(wandtask4))
                                                end
                                            elseif stage == 8 then
                                                if not job5 then
                                                    actor:send("Bring " .. tostring(master) .. " your " .. tostring(weapon) .. ".")
                                                else
                                                    local room_label = room_name(place)
                                                    actor:send("- imbue your " .. tostring(weapon) .. " at " .. room_label .. ".")
                                                end
                                            elseif stage == 10 then
                                                local room_label = room_name(wandtask4)
                                                actor:send("- imbue your " .. tostring(weapon) .. " at " .. room_label .. ".")
                                            end
                                        end
                                    end
                                end
                            end
                        end
                        if not job1 then
                            if remaining > 1 then
                                actor:send("- <b:yellow>attack " .. tostring(remaining) .. " more times with your " .. tostring(weapon) .. "</>")
                            else
                                actor:send("- <b:yellow>attack " .. tostring(remaining) .. " more time with your " .. tostring(weapon) .. "</>")
                            end
                        end
                        if not job2 then
                            actor:send("- <b:yellow>find " .. proto_short(wandgem) .. "</>")
                        end
                        if stage > 2 then
                            if not job3 then
                                if stage ~= 10 then
                                    actor:send("- <b:yellow>find " .. proto_short(wandtask3) .. "</>")
                                    if stage == 4 then
                                        actor:send("</>    Blessings can be called at the smaller groups of standing stones in South Caelia.")
                                        actor:send("</>    Search the far eastern edge of the continent.")
                                        actor:send("</>    The phrase to call the blessing is:")
                                        actor:send("</>    <b:white>I pray for a blessing from mother earth, creator of life and bringer of death</>")
                                    end
                                else
                                    actor:send("- <b:yellow>slay " .. mob_short(wandtask3) .. "</>")
                                end
                            end
                            if not job4 then
                                if stage ~= 3 and stage ~= 5 and stage ~= 9 and stage ~= 10 then
                                    actor:send("- <b:yellow>find " .. proto_short(wandtask4) .. "</>")
                                elseif stage == 5 then
                                    actor:send("- <b:yellow>imbue your " .. tostring(weapon) .. " on " .. tostring(wandtask4) .. "</>")
                                elseif stage == 9 then
                                    actor:send("- <b:yellow>slay " .. mob_short(wandtask4) .. "</>")
                                elseif stage == 10 then
                                    if job1 and job2 and job3 then
                                        actor:send("Bring " .. tostring(master) .. " your " .. tostring(weapon) .. ".")
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end
return _return_value$trig$, '569b408c815c77183b44913fafc0defe'),
  -- data/triggers/004/004_50_fire_wand_progress_journal.lua
  (4, 50, $trig$-- Converted from DG Script #450: Fire Wand progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
-- Item, mob and room names go through the dg library: the legacy vnums are not zone * 100 + id
-- everywhere (zone 117 holds 11811, zone 30 holds 3218, ...), and a task flag that was reset to 0
-- counts as unset (dg.flag).
local dg = require("dg")
local function proto_short(vnum) return dg.oname(vnum) end
local function mob_short(vnum) return dg.mname(vnum) end
local function room_name(vnum) return dg.rname(vnum) end
local _return_value = true  -- Default: allow action
if (string.find(arg, "fire") and (string.find(arg, "wand") or string.find(arg, "wands") or string.find(arg, "staff") or string.find(arg, "staves"))) or string.find(arg, "fire_wand") or string.find(arg, "fire_wands") or string.find(arg, "fire_staff") then
    local sorcererclasses = "Sorcerer Illusionist Cryomancer Pyromancer Necromancer"
    if string.find(string.lower(sorcererclasses), actor.class, 1, true) then
        _return_value = true
        local stage = actor:get_quest_stage("fire_wand")
        local minlevel = (stage - 1) * 10
        if minlevel < 1 then
            minlevel = 1
        end
        actor:send("<b:u:green>Fire Wand</>")
        actor:send("Masters of fire will help you create and upgrade a new mystic weapon.")
        if not actor:get_has_completed("fire_wand") then
            actor:send("Minimum Level: " .. tostring(minlevel))
        end
        local status
        if actor:get_has_completed("fire_wand") then
            status = "Completed!"
        elseif (stage or 0) > 0 then
            status = "In Progress"
        else
            status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
        if stage > 0 and not actor:get_has_completed("fire_wand") then
            local job1 = dg.flag(actor:get_quest_var("fire_wand:wandtask1"))
            local job2 = dg.flag(actor:get_quest_var("fire_wand:wandtask2"))
            local job3 = dg.flag(actor:get_quest_var("fire_wand:wandtask3"))
            local job4 = dg.flag(actor:get_quest_var("fire_wand:wandtask4"))
            local job5 = dg.flag(actor:get_quest_var("fire_wand:wandtask5"))
            local attack = (stage - 1) * 50
            local weapon
            if stage < 8 then
                weapon = "wand"
            else
                weapon = "staff"
            end
            local remaining = ((attack) - (actor:get_quest_var("fire_wand:attack_counter") or 0))
            -- switch on stage
            local master
            local wandgem
            local hint
            local wandtask3
            local wandtask4
            local place
            do
                local _sw1 = string.lower(tostring(stage or ""))
                if tonumber(_sw1) == 2 then
                    master = mobiles.template(30, 13).name
                    wandgem = 55575
                elseif tonumber(_sw1) == 3 then
                    master = mobiles.template(41, 26).name
                    hint = "A minion of the dark flame out east will know what to do."
                    wandgem = 55590
                    wandtask3 = 23752
                elseif tonumber(_sw1) == 4 then
                    master = mobiles.template(103, 6).name
                    hint = "There's a fire master in the frozen north who likes to spend his time at the hot springs."
                    wandgem = 55612
                    wandtask3 = 2331
                    wandtask4 = 37006
                elseif tonumber(_sw1) == 5 then
                    master = mobiles.template(123, 4).name
                    hint = "A master of fire near the megalith in South Caelia will be able to help next."
                    wandgem = 55639
                    wandtask3 = 12526
                    wandtask4 = "<b:red>the Lava Tunnels</>"
                elseif tonumber(_sw1) == 6 then
                    master = mobiles.template(238, 11).name
                    hint = "A seraph crafts with the power of the sun and sky.  It can be found in the floating fortress in South Caelia."
                    wandgem = 55662
                    wandtask3 = 5201
                    wandtask4 = 32412
                elseif tonumber(_sw1) == 7 then
                    master = mobiles.template(481, 5).name
                    hint = "I hate to admit it, but Vulcera is your next crafter.  Good luck appeasing her though..."
                    wandgem = 55689
                    wandtask3 = 43018
                    wandtask4 = 11705
                elseif tonumber(_sw1) == 8 then
                    master = mobiles.template(481, 150).name
                    hint = "You're headed back to Fiery Island.  Crazy old McCabe can help you improve your staff further."
                    wandgem = 55716
                    wandtask3 = 53000
                    wandtask4 = 53456
                    place = 5272
                elseif tonumber(_sw1) == 9 then
                    master = mobiles.template(484, 12).name
                    hint = "Seek out the one who speaks for the Sun near Anduin.  He can upgrade your wand."
                    wandgem = 55739
                    wandtask3 = 48126
                    wandtask4 = 4013
                elseif tonumber(_sw1) == 10 then
                    master = mobiles.template(52, 30).name
                    hint = "Surely you've heard of Emmath Firehand.  He's the supreme artisan of fiery goods.  He can help you make the final improvements to your staff."
                    wandgem = 23822
                    wandtask3 = 52002
                    wandtask4 = 47800
                end
            end
            if stage == 8 then
                place = 5272
            end
            if stage == 1 then
                actor:send("Find " .. tostring(mobiles.template(30, 13).name) .. " and show him your wand.")
                return _return_value
            else
                if actor.level >= minlevel then
                    if (actor:get_quest_var("fire_wand:greet") or 0) == 0 and stage ~= 2 then
                        actor:send("Find the next master crafter and tell them why you have come.")
                        actor:send(tostring(hint))
                        return _return_value
                    else
                        actor:send("Quest Master: " .. tostring(master))
                        actor:send("</>")
                        if job1 or job2 or job3 or job4 then
                            actor:send("You've done the following:")
                            if job1 then
                                actor:send("- used your " .. tostring(weapon) .. " " .. tostring(attack) .. " times")
                            end
                            if job2 then
                                actor:send("- found " .. proto_short(wandgem))
                            end
                            if job3 then
                                if stage ~= 10 then
                                    actor:send("- found " .. proto_short(wandtask3))
                                else
                                    actor:send("- slayed " .. mob_short(wandtask3))
                                end
                            end
                            if job4 then
                                if stage ~= 5 and stage ~= 9 and stage ~= 10 then
                                    actor:send("- found " .. proto_short(wandtask4))
                                elseif stage == 5 then
                                    actor:send("- communed in " .. tostring(wandtask4))
                                elseif stage == 9 then
                                    actor:send("- slayed " .. mob_short(wandtask4))
                                end
                            end
                            actor:send("</>")
                        end
                        actor:send("You need to:")
                        if job1 and job2 then
                            if stage == 2 then
                                actor:send("bring " .. tostring(master) .. " your " .. tostring(weapon) .. ".")
                            else
                                if job3 then
                                    if stage == 3 then
                                        actor:send("bring " .. tostring(master) .. " your " .. tostring(weapon) .. ".")
                                    else
                                        if job4 then
                                            if stage ~= 6 and stage ~= 8 and stage ~= 10 then
                                                actor:send("Bring " .. tostring(master) .. " your " .. tostring(weapon) .. ".")
                                            elseif stage == 6 then
                                                if not job5 then
                                                    actor:send("bring " .. tostring(master) .. " your " .. tostring(weapon) .. ".")
                                                else
                                                    actor:send("- <b:cyan>play</> " .. proto_short(wandtask4))
                                                end
                                            elseif stage == 8 then
                                                if not job5 then
                                                    actor:send("Bring " .. tostring(master) .. " your " .. tostring(weapon) .. ".")
                                                else
                                                    local room_label = room_name(place)
                                                    actor:send("- imbue your " .. tostring(weapon) .. " at " .. room_label .. ".")
                                                end
                                            elseif stage == 10 then
                                                local room_label = room_name(wandtask4)
                                                actor:send("- imbue your " .. tostring(weapon) .. " at " .. room_label .. ".")
                                            end
                                        end
                                    end
                                end
                            end
                        end
                        if not job1 then
                            if remaining > 1 then
                                actor:send("- <b:yellow>attack " .. tostring(remaining) .. " more times with your " .. tostring(weapon) .. "</>")
                            else
                                actor:send("- <b:yellow>attack " .. tostring(remaining) .. " more time with your " .. tostring(weapon) .. "</>")
                            end
                        end
                        if not job2 then
                            actor:send("- <b:yellow>find " .. proto_short(wandgem) .. "</>")
                        end
                        if stage > 2 then
                            if not job3 then
                                if stage ~= 10 then
                                    actor:send("- <b:yellow>find " .. proto_short(wandtask3) .. "</>")
                                    if stage == 4 then
                                        actor:send("</>    Blessings can be called at the smaller groups of standing stones in South Caelia.")
                                        actor:send("</>    Search the south point beyond Anlun Vale.")
                                        actor:send("</>    The phrase to call the blessing is:")
                                        actor:send("</>    <b:white>I pray for a blessing from mother earth, creator of life and bringer of death</>")
                                    end
                                else
                                    actor:send("- <b:yellow>slay " .. mob_short(wandtask3) .. "</>")
                                end
                            end
                            if not job4 then
                                if stage ~= 3 and stage ~= 5 and stage ~= 9 and stage ~= 10 then
                                    actor:send("- <b:yellow>find " .. proto_short(wandtask4) .. "</>")
                                elseif stage == 5 then
                                    actor:send("- <b:yellow>imbue your " .. tostring(weapon) .. " in " .. tostring(wandtask4) .. "</>")
                                elseif stage == 9 then
                                    actor:send("- <b:yellow>slay " .. mob_short(wandtask4) .. "</>")
                                elseif stage == 10 then
                                    if job1 and job2 and job3 then
                                        actor:send("Bring " .. tostring(master) .. " your " .. tostring(weapon) .. ".")
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end
return _return_value$trig$, 'be876df584de25fb9ab0718d13764898'),
  -- data/triggers/004/004_51_ice_wand_progress_journal.lua
  (4, 51, $trig$-- Converted from DG Script #451: Ice Wand progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
-- Item, mob and room names go through the dg library: the legacy vnums are not zone * 100 + id
-- everywhere (zone 117 holds 11811, zone 30 holds 3218, ...), and a task flag that was reset to 0
-- counts as unset (dg.flag).
local dg = require("dg")
local function proto_short(vnum) return dg.oname(vnum) end
local function mob_short(vnum) return dg.mname(vnum) end
local function room_name(vnum) return dg.rname(vnum) end
local _return_value = true  -- Default: allow action
if ((string.find(arg, "ice") or string.find(arg, "water") or string.find(arg, "cold") or string.find(arg, "frost")) and (string.find(arg, "wand") or string.find(arg, "wands") or string.find(arg, "staff") or string.find(arg, "staves"))) or string.find(arg, "ice_wand") or string.find(arg, "ice_wands") or string.find(arg, "ice_staff") or string.find(arg, "water_wand") or string.find(arg, "water_wands") or string.find(arg, "water_staff") then
    local sorcererclasses = "Sorcerer Illusionist Cryomancer Pyromancer Necromancer"
    if string.find(string.lower(sorcererclasses), actor.class, 1, true) then
        _return_value = true
        local stage = actor:get_quest_stage("ice_wand")
        local minlevel = (stage - 1) * 10
        if minlevel < 1 then
            minlevel = 1
        end
        actor:send("<b:u:green>Ice Wand</>")
        actor:send("Masters of ice and water will help you create and upgrade a new mystic weapon.")
        if not actor:get_has_completed("ice_wand") then
            actor:send("Minimum Level: " .. tostring(minlevel))
        end
        local status
        if actor:get_has_completed("ice_wand") then
            status = "Completed!"
        elseif (stage or 0) > 0 then
            status = "In Progress"
        else
            status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
        if stage > 0 and not actor:get_has_completed("ice_wand") then
            local job1 = dg.flag(actor:get_quest_var("ice_wand:wandtask1"))
            local job2 = dg.flag(actor:get_quest_var("ice_wand:wandtask2"))
            local job3 = dg.flag(actor:get_quest_var("ice_wand:wandtask3"))
            local job4 = dg.flag(actor:get_quest_var("ice_wand:wandtask4"))
            local job5 = dg.flag(actor:get_quest_var("ice_wand:wandtask5"))
            local attack = (stage - 1) * 50
            local weapon
            if stage < 8 then
                weapon = "wand"
            else
                weapon = "staff"
            end
            local remaining = ((attack) - (actor:get_quest_var("ice_wand:attack_counter") or 0))
            -- switch on stage
            local master
            local wandgem
            local hint
            local wandtask3
            local wandtask4
            local place
            do
                local _sw1 = string.lower(tostring(stage or ""))
                if tonumber(_sw1) == 2 then
                    master = mobiles.template(30, 13).name
                    wandgem = 55574
                elseif tonumber(_sw1) == 3 then
                    master = mobiles.template(178, 6).name
                    hint = "The shaman near Three-Falls River has developed a powerful affinity for water from his life in the canyons.  Seek his advice."
                    wandgem = 55592
                    wandtask3 = 23753
                elseif tonumber(_sw1) == 4 then
                    master = mobiles.template(23, 37).name
                    hint = "Many of the best craftspeople aren't even mortal.  There is a water sprite of some renown deep in Anlun Vale."
                    wandgem = 55607
                    wandtask3 = 2333
                    wandtask4 = 37006
                elseif tonumber(_sw1) == 5 then
                    master = mobiles.template(550, 13).name
                    hint = "A master of spirits in the far north will be able to help next."
                    wandgem = 55640
                    wandtask3 = 58018
                    wandtask4 = "<b:cyan>the Arabel Ocean</>"
                elseif tonumber(_sw1) == 6 then
                    master = mobiles.template(238, 2).name
                    hint = "Your next crafter is a distant relative of the Sunfire clan.  He's been squatting in a flying fortress for many months, trying to unlock its secrets."
                    wandgem = 55666
                    wandtask3 = 49011
                    wandtask4 = 17309
                elseif tonumber(_sw1) == 7 then
                    master = mobiles.template(533, 16).name
                    hint = "You'll need the advice of a master ice sculptor.  One works regularly up in Mt. Frostbite."
                    wandgem = 55684
                    wandtask3 = 55016
                    wandtask4 = 23815
                elseif tonumber(_sw1) == 8 then
                    master = mobiles.template(103, 0).name
                    hint = "There's another distant relative of the Sunfire clan who runs the hot springs near Ickle.  He's book smart and knows a thing or two about jewel crafting."
                    wandgem = 55717
                    wandtask3 = 23847
                    wandtask4 = 53457
                    place = 55105
                elseif tonumber(_sw1) == 9 then
                    master = mobiles.template(100, 12).name
                    hint = "The guild guard for the Sorcerer Guild in Ickle has learned plenty of secrets from the inner sanctum.  Talk to him."
                    wandgem = 55743
                    wandtask3 = 48018
                    wandtask4 = 53300
                elseif tonumber(_sw1) == 10 then
                    master = mobiles.template(550, 20).name
                    hint = "You must know Suralla Iceeye by now.  She's the master artisan of cold and ice.  She'll know how to make the final improvements to your staff."
                    wandgem = 53314
                    wandtask3 = 52005
                    wandtask4 = 47708
                end
            end
            if stage == 8 then
                place = 55105
            end
            if stage == 1 then
                actor:send("Find " .. tostring(mobiles.template(30, 13).name) .. " and show him your wand.")
                return _return_value
            else
                if actor.level >= minlevel then
                    if (actor:get_quest_var("ice_wand:greet") or 0) == 0 and stage ~= 2 then
                        actor:send("Find the next master crafter and tell them why you have come.")
                        actor:send(tostring(hint))
                        return _return_value
                    else
                        actor:send("Quest Master: " .. tostring(master))
                        actor:send("</>")
                        if job1 or job2 or job3 or job4 then
                            actor:send("You've done the following:")
                            if job1 then
                                actor:send("- used your " .. tostring(weapon) .. " " .. tostring(attack) .. " times")
                            end
                            if job2 then
                                actor:send("- found " .. proto_short(wandgem))
                            end
                            if job3 then
                                if stage ~= 10 then
                                    actor:send("- found " .. proto_short(wandtask3))
                                else
                                    actor:send("- slayed " .. mob_short(wandtask3))
                                end
                            end
                            if job4 then
                                if stage ~= 5 and stage ~= 9 and stage ~= 10 then
                                    actor:send("- found " .. proto_short(wandtask4))
                                elseif stage == 5 then
                                    actor:send("- communed in " .. tostring(wandtask4))
                                elseif stage == 9 then
                                    actor:send("- slayed " .. mob_short(wandtask4))
                                end
                            end
                            actor:send("</>")
                        end
                        actor:send("You need to:")
                        if job1 and job2 then
                            if stage == 2 then
                                actor:send("bring " .. tostring(master) .. " your " .. tostring(weapon) .. ".")
                            else
                                if job3 then
                                    if stage == 3 then
                                        actor:send("bring " .. tostring(master) .. " your " .. tostring(weapon) .. ".")
                                    else
                                        if job4 then
                                            if stage ~= 6 and stage ~= 8 and stage ~= 10 then
                                                actor:send("Bring " .. tostring(master) .. " your " .. tostring(weapon) .. ".")
                                            elseif stage == 6 then
                                                if not job5 then
                                                    actor:send("bring " .. tostring(master) .. " your " .. tostring(weapon) .. ".")
                                                else
                                                    actor:send("- <b:cyan>play</> " .. proto_short(wandtask4))
                                                end
                                            elseif stage == 8 then
                                                if not job5 then
                                                    actor:send("Bring " .. tostring(master) .. " your " .. tostring(weapon) .. ".")
                                                else
                                                    local room_label = room_name(place)
                                                    actor:send("- imbue your " .. tostring(weapon) .. " at " .. room_label .. ".")
                                                end
                                            elseif stage == 10 then
                                                local room_label = room_name(wandtask4)
                                                actor:send("- imbue your " .. tostring(weapon) .. " at " .. room_label .. ".")
                                            end
                                        end
                                    end
                                end
                            end
                        end
                        if not job1 then
                            if remaining > 1 then
                                actor:send("- <b:yellow>attack " .. tostring(remaining) .. " more times with your " .. tostring(weapon) .. "</>")
                            else
                                actor:send("- <b:yellow>attack " .. tostring(remaining) .. " more time with your " .. tostring(weapon) .. "</>")
                            end
                        end
                        if not job2 then
                            actor:send("- <b:yellow>find " .. proto_short(wandgem) .. "</>")
                        end
                        if stage > 2 then
                            if not job3 then
                                if stage ~= 10 then
                                    actor:send("- <b:yellow>find " .. proto_short(wandtask3) .. "</>")
                                    if stage == 4 then
                                        actor:send("</>    Blessings can be called at the smaller groups of standing stones in South Caelia.")
                                        actor:send("</>    Search near the crystalline pool in Anlun Vale.")
                                        actor:send("</>    The phrase to call the blessing is:")
                                        actor:send("</>    <b:white>I pray for a blessing from mother earth, creator of life and bringer of death</>")
                                    end
                                else
                                    actor:send("- <b:yellow>slay " .. mob_short(wandtask3) .. "</>")
                                end
                            end
                            if not job4 then
                                if stage ~= 3 and stage ~= 5 and stage ~= 9 and stage ~= 10 then
                                    actor:send("- <b:yellow>find " .. proto_short(wandtask4) .. "</>")
                                elseif stage == 5 then
                                    actor:send("- <b:yellow>imbue your " .. tostring(weapon) .. " in " .. tostring(wandtask4) .. "</>")
                                elseif stage == 9 then
                                    actor:send("- <b:yellow>slay " .. mob_short(wandtask4) .. "</>")
                                elseif stage == 10 then
                                    if job1 and job2 and job3 then
                                        actor:send("Bring " .. tostring(master) .. " your " .. tostring(weapon) .. ".")
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end
return _return_value$trig$, 'c5f79f7898547abce171e8b5c2c388b4'),
  -- data/triggers/004/004_52_acid_wand_progress_journal.lua
  (4, 52, $trig$-- Converted from DG Script #452: Acid Wand progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
-- Item, mob and room names go through the dg library: the legacy vnums are not zone * 100 + id
-- everywhere (zone 117 holds 11811, zone 30 holds 3218, ...), and a task flag that was reset to 0
-- counts as unset (dg.flag).
local dg = require("dg")
local function proto_short(vnum) return dg.oname(vnum) end
local function mob_short(vnum) return dg.mname(vnum) end
local function room_name(vnum) return dg.rname(vnum) end
local _return_value = true  -- Default: allow action
if ((string.find(arg, "acid") or string.find(arg, "earth")) and (string.find(arg, "wand") or string.find(arg, "wands") or string.find(arg, "staff") or string.find(arg, "staves"))) or string.find(arg, "acid_wand") or string.find(arg, "acid_wands") or string.find(arg, "acid_staff") or string.find(arg, "earth_wand") or string.find(arg, "earth_wands") or string.find(arg, "earth_staff") then
    local sorcererclasses = "Sorcerer Illusionist Cryomancer Pyromancer Necromancer"
    if string.find(string.lower(sorcererclasses), actor.class, 1, true) then
        _return_value = true
        local stage = actor:get_quest_stage("acid_wand")
        local minlevel = (stage - 1) * 10
        if minlevel < 1 then
            minlevel = 1
        end
        actor:send("<b:u:green>Acid Wand</>")
        actor:send("Masters of earth will help you create and upgrade a new mystic weapon.")
        if not actor:get_has_completed("acid_wand") then
            actor:send("Minimum Level: " .. tostring(minlevel))
        end
        local status
        if actor:get_has_completed("acid_wand") then
            status = "Completed!"
        elseif (stage or 0) > 0 then
            status = "In Progress"
        else
            status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
        if stage > 0 and not actor:get_has_completed("acid_wand") then
            local job1 = dg.flag(actor:get_quest_var("acid_wand:wandtask1"))
            local job2 = dg.flag(actor:get_quest_var("acid_wand:wandtask2"))
            local job3 = dg.flag(actor:get_quest_var("acid_wand:wandtask3"))
            local job4 = dg.flag(actor:get_quest_var("acid_wand:wandtask4"))
            local job5 = dg.flag(actor:get_quest_var("acid_wand:wandtask5"))
            local attack = (stage - 1) * 50
            local weapon
            if stage < 8 then
                weapon = "wand"
            else
                weapon = "staff"
            end
            local remaining = ((attack) - (actor:get_quest_var("acid_wand:attack_counter") or 0))
            -- switch on stage
            local master
            local wandgem
            local hint
            local wandtask3
            local wandtask4
            local place
            do
                local _sw1 = string.lower(tostring(stage or ""))
                if tonumber(_sw1) == 2 then
                    master = mobiles.template(30, 13).name
                    wandgem = 55576
                elseif tonumber(_sw1) == 3 then
                    master = mobiles.template(100, 56).name .. " in Ickle"
                    hint = "First, seek the one who guards the eastern gates of Ickle."
                    wandgem = 55593
                    wandtask3 = 23751
                elseif tonumber(_sw1) == 4 then
                    master = mobiles.template(625, 4).name .. " in the Rhell Forest"
                    hint = "The next two artisans dwell in the Rhell Forest south-east of Mielikki."
                    wandgem = 55606
                    wandtask3 = 2332
                    wandtask4 = 37006
                elseif tonumber(_sw1) == 5 then
                    master = mobiles.template(625, 3).name
                    hint = "Your next crafter isn't exactly part of the ranger network...  It's not actually a person at all.  Find the treant in the Rhell forest and ask it for guidance."
                    wandgem = 55647
                    wandtask3 = 16303
                    wandtask4 = "<b:black>the Northern Swamps</>"
                elseif tonumber(_sw1) == 6 then
                    master = mobiles.template(470, 75).name .. " in the Graveyard"
                    hint = "The ranger who guards the massive necropolis near Anduin has wonderful insights on crafting with decay."
                    wandgem = 55663
                    wandtask3 = 55020
                    wandtask4 = 16107
                elseif tonumber(_sw1) == 7 then
                    master = mobiles.template(40, 17).name .. " in the Black-Ice Desert"
                    hint = "Your next guide may be hard to locate...  I believe they guard the entrance to a long-lost kingdom beyond a frozen desert."
                    wandgem = 55683
                    wandtask3 = 16305
                    wandtask4 = 37082
                elseif tonumber(_sw1) == 8 then
                    master = mobiles.template(480, 29).name .. " in the Barrow"
                    hint = "Next, consult with another ranger who guards a place crawling with the dead.  The dwarf ranger in the iron hills will know how to help you."
                    wandgem = 55724
                    wandtask3 = 58414
                    wandtask4 = 53453
                    place = 16355
                elseif tonumber(_sw1) == 9 then
                    master = mobiles.template(35, 49).name .. " at the Ranger Guild"
                    hint = "The guard of the only known Ranger Guild in the world is also an excellent craftswoman.  Consult with her."
                    wandgem = 55740
                    wandtask3 = 47006
                    wandtask4 = 52018
                elseif tonumber(_sw1) == 10 then
                    master = mobiles.template(163, 15).name
                    hint = "Your last guide is the head of the ranger network himself, Eleweiss.  He can help make the final improvements to your staff."
                    wandgem = 52031
                    wandtask3 = 52007
                    wandtask4 = 47672
                end
            end
            if stage == 8 then
                place = 16355
            end
            if stage == 1 then
                actor:send("Find " .. tostring(mobiles.template(30, 13).name) .. " and show him your wand.")
                return _return_value
            else
                if actor.level >= minlevel then
                    if (actor:get_quest_var("acid_wand:greet") or 0) == 0 and stage ~= 2 then
                        actor:send("Find the next master crafter and tell them why you have come.")
                        actor:send(tostring(hint))
                        return _return_value
                    else
                        actor:send("Quest Master: " .. tostring(master))
                        actor:send("</>")
                        if job1 or job2 or job3 or job4 then
                            actor:send("You've done the following:")
                            if job1 then
                                actor:send("- used your " .. tostring(weapon) .. " " .. tostring(attack) .. " times")
                            end
                            if job2 then
                                actor:send("- found " .. proto_short(wandgem))
                            end
                            if job3 then
                                if stage ~= 10 then
                                    actor:send("- found " .. proto_short(wandtask3))
                                else
                                    actor:send("- slayed " .. mob_short(wandtask3))
                                end
                            end
                            if job4 then
                                if stage ~= 5 and stage ~= 9 and stage ~= 10 then
                                    actor:send("- found " .. proto_short(wandtask4))
                                elseif stage == 5 then
                                    actor:send("- communed in " .. tostring(wandtask4))
                                elseif stage == 9 then
                                    actor:send("- slayed " .. mob_short(wandtask4))
                                end
                            end
                            actor:send("</>")
                        end
                        actor:send("You need to:")
                        if job1 and job2 then
                            if stage == 2 then
                                actor:send("bring " .. tostring(master) .. " your " .. tostring(weapon) .. ".")
                            else
                                if job3 then
                                    if stage == 3 then
                                        actor:send("bring " .. tostring(master) .. " your " .. tostring(weapon) .. ".")
                                    else
                                        if job4 then
                                            if stage ~= 6 and stage ~= 8 and stage ~= 10 then
                                                actor:send("Bring " .. tostring(master) .. " your " .. tostring(weapon) .. ".")
                                            elseif stage == 6 then
                                                if not job5 then
                                                    actor:send("bring " .. tostring(master) .. " your " .. tostring(weapon) .. ".")
                                                else
                                                    actor:send("- <b:cyan>play</> " .. proto_short(wandtask4))
                                                end
                                            elseif stage == 8 then
                                                if not job5 then
                                                    actor:send("Bring " .. tostring(master) .. " your " .. tostring(weapon) .. ".")
                                                else
                                                    local room_label = room_name(place)
                                                    actor:send("- imbue your " .. tostring(weapon) .. " at " .. room_label .. ".")
                                                end
                                            elseif stage == 10 then
                                                local room_label = room_name(wandtask4)
                                                actor:send("- imbue your " .. tostring(weapon) .. " at " .. room_label .. ".")
                                            end
                                        end
                                    end
                                end
                            end
                        end
                        if not job1 then
                            if remaining > 1 then
                                actor:send("- <b:yellow>attack " .. tostring(remaining) .. " more times with your " .. tostring(weapon) .. "</>")
                            else
                                actor:send("- <b:yellow>attack " .. tostring(remaining) .. " more time with your " .. tostring(weapon) .. "</>")
                            end
                        end
                        if not job2 then
                            actor:send("- <b:yellow>find " .. proto_short(wandgem) .. "</>")
                        end
                        if stage > 2 then
                            if not job3 then
                                if stage ~= 10 then
                                    actor:send("- <b:yellow>find " .. proto_short(wandtask3) .. "</>")
                                    if stage == 4 then
                                        actor:send("</>    Blessings can be called at the smaller groups of standing stones in South Caelia.")
                                        actor:send("</>    Search in the heart of the heart of the thorns.")
                                        actor:send("</>    The phrase to call the blessing is:")
                                        actor:send("</>    <b:white>I pray for a blessing from mother earth, creator of life and bringer of death</>")
                                    end
                                else
                                    actor:send("- <b:yellow>slay " .. mob_short(wandtask3) .. "</>")
                                end
                            end
                            if not job4 then
                                if stage ~= 3 and stage ~= 5 and stage ~= 9 and stage ~= 10 then
                                    actor:send("- <b:yellow>find " .. proto_short(wandtask4) .. "</>")
                                elseif stage == 5 then
                                    actor:send("- <b:yellow>imbue your " .. tostring(weapon) .. " in " .. tostring(wandtask4) .. "</>")
                                elseif stage == 9 then
                                    actor:send("- <b:yellow>slay " .. mob_short(wandtask4) .. "</>")
                                elseif stage == 10 then
                                    if job1 and job2 and job3 then
                                        actor:send("Bring " .. tostring(master) .. " your " .. tostring(weapon) .. ".")
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end
return _return_value$trig$, '25278b18f3db9a47c94c1745c35831bb'),
  -- data/triggers/004/004_53_spirit_maces_progress_journal.lua
  (4, 53, $trig$-- Converted from DG Script #453: Spirit Maces progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
-- Item, mob and room names go through the dg library: the legacy vnums are not zone * 100 + id
-- everywhere (zone 117 holds 11811, zone 30 holds 3218, ...), and a task flag that was reset to 0
-- counts as unset (dg.flag).
local dg = require("dg")
local function proto_short(vnum) return dg.oname(vnum) end
local _return_value = true  -- Default: allow action
if (string.find(arg, "spirit") and (string.find(arg, "mace") or string.find(arg, "maces"))) or string.find(arg, "phase_mace") or string.find(arg, "spirit_mace") then
    if string.find(actor.class, "priest") or string.find(actor.class, "cleric") then
        _return_value = true
        local stage = actor:get_quest_stage("phase_mace")
        local minlevel = stage * 10
        actor:send("Clerics and priests can make pilgrimages to various spiritual masters to craft weapons to smite the undead.")
        actor:send("<b:u:green>Spirit Maces</>")
        if not actor:get_has_completed("phase_mace") then
            actor:send("Minimum Level: " .. tostring(minlevel))
        end
        local status
        if actor:get_has_completed("phase_mace") then
            status = "Completed!"
        elseif (stage or 0) > 0 then
            status = "In Progress"
        else
            status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
        if stage > 0 and not actor:get_has_completed("phase_mace") then
            local job1 = dg.flag(actor:get_quest_var("phase_mace:macetask1"))
            local job2 = dg.flag(actor:get_quest_var("phase_mace:macetask2"))
            local job3 = dg.flag(actor:get_quest_var("phase_mace:macetask3"))
            local job4 = dg.flag(actor:get_quest_var("phase_mace:macetask4"))
            local job5 = dg.flag(actor:get_quest_var("phase_mace:macetask5"))
            local job6 = dg.flag(actor:get_quest_var("phase_mace:macetask6"))
            local attack = stage * 50
            local remaining = ((attack) - (actor:get_quest_var("phase_mace:attack_counter") or 0))
            -- switch on stage
            local master
            local maceitem2
            local maceitem3
            local maceitem4
            local maceitem5
            local hint
            local maceitem6
            do
                local _sw1 = string.lower(tostring(stage or ""))
                if tonumber(_sw1) == 1 then
                    master = mobiles.template(30, 25).name
                    maceitem2 = 55577
                    maceitem3 = 55211
                    maceitem4 = 13614
                    maceitem5 = 58809
                    hint = "The Holy Templar Magistrate is a master of spiritual combat.  Perhaps he knows more."
                elseif tonumber(_sw1) == 2 then
                    master = mobiles.template(185, 2).name
                    maceitem2 = 55593
                    maceitem3 = 18522
                    maceitem4 = 18523
                    maceitem5 = 18524
                    maceitem6 = 18525
                    hint = "Someone familiar with the grave will be able to work on this mace.  Seek out the Sexton in the Abbey west of the Village of Mielikki."
                elseif tonumber(_sw1) == 3 then
                    master = mobiles.template(100, 0).name
                    maceitem2 = 55604
                    maceitem3 = 32409
                    maceitem4 = 59022
                    maceitem5 = 2327
                    hint = "The Cleric Guild is capable of some miraculous crafting.  Visit the Cleric Guild Master in the Arctic Village of Ickle and talk to High Priest Zalish.  He should be able to help you."
                elseif tonumber(_sw1) == 4 then
                    master = mobiles.template(62, 18).name
                    maceitem2 = 55631
                    maceitem3 = 16030
                    maceitem4 = 47002
                    maceitem5 = 5211
                    hint = "Continue with the Cleric Guild Masters.  Check in with the High Priestess in the City of Anduin."
                elseif tonumber(_sw1) == 5 then
                    master = mobiles.template(85, 1).name
                    maceitem2 = 55660
                    maceitem3 = 43007
                    maceitem4 = 59012
                    maceitem5 = 17308
                    hint = "Sometimes to battle the dead, we need to use their own dark natures against them.  Few are as knowledgeable about the dark arts as Ziijhan, the Defiler, in the Cathedral of Betrayal."
                elseif tonumber(_sw1) == 6 then
                    master = mobiles.template(185, 81).name
                    maceitem2 = 55681
                    maceitem3 = 23824
                    maceitem4 = 53016
                    maceitem5 = 16201
                    hint = "Return again to the Abbey of St. George and seek out Silania.  Her mastry of spiritual matters will be necessary to improve this mace any further."
                elseif tonumber(_sw1) == 7 then
                    master = mobiles.template(60, 7).name
                    maceitem2 = 55708
                    maceitem3 = 49502
                    maceitem4 = 4008
                    maceitem5 = 47017
                    hint = "Of the few remaining who are capable of improving your mace, one is a priest of a god most foul.  Find Ruin Wormheart, that most heinous of Blackmourne's servators."
                elseif tonumber(_sw1) == 8 then
                    master = mobiles.template(484, 12).name
                    maceitem2 = 55737
                    maceitem3 = 53305
                    maceitem4 = 12307
                    maceitem5 = 51073
                    hint = "The most powerful force in the war against the dead is the sun itself.  Consult with the sun's Oracle in the ancient pyramid near Anduin."
                elseif tonumber(_sw1) == 9 then
                    master = mobiles.template(30, 21).name
                    maceitem2 = 55738
                    maceitem3 = 48002
                    maceitem4 = 52010
                    maceitem5 = 3218
                    hint = "With everything prepared, return to the very beginning of your journey.  The High Priestess of Mielikki, the very center of the Cleric Guild, will know what to do."
                end
            end
            if actor.level >= minlevel then
                if (actor:get_quest_var("phase_mace:greet") or 0) == 0 then
                    actor:send("Find the next master crafter and tell them why you have come.")
                    actor:send(tostring(hint))
                    return _return_value
                else
                    actor:send("Quest Master: " .. tostring(master))
                    actor:send("</>")
                    if job1 or job2 or job3 or job4 or job5 or job6 then
                        actor:send("</>")
                        actor:send("You've done the following:")
                        if job1 then
                            actor:send("- attacked " .. tostring(attack) .. " times")
                        end
                        if job2 then
                            actor:send("- found " .. proto_short(maceitem2))
                        end
                        if job3 then
                            actor:send("- found " .. proto_short(maceitem3))
                        end
                        if job4 then
                            actor:send("- found " .. proto_short(maceitem4))
                        end
                        if job5 then
                            actor:send("- found " .. proto_short(maceitem5))
                        end
                        if job6 then
                            actor:send("- found " .. proto_short(maceitem6))
                        end
                    end
                    actor:send("</>")
                    actor:send("You need to:")
                    if job1 and job2 and job3 and job4 and job5 then
                        if stage ~= 2 then
                            actor:send("Bring " .. tostring(master) .. " your mace.")
                            return _return_value
                        else
                            if job6 then
                                actor:send("Bring " .. tostring(master) .. " your mace.")
                                return _return_value
                            end
                        end
                    end
                    if not job1 then
                        if remaining > 1 then
                            actor:send("- <b:yellow>attack " .. tostring(remaining) .. " more times with your mace</>")
                        else
                            actor:send("- <b:yellow>attack " .. tostring(remaining) .. " more time with your mace</>")
                        end
                    end
                    if not job2 then
                        actor:send("- <b:yellow>find " .. proto_short(maceitem2) .. "</>")
                    end
                    if not job3 then
                        actor:send("- <b:yellow>find " .. proto_short(maceitem3) .. "</>")
                    end
                    if not job4 then
                        actor:send("- <b:yellow>find " .. proto_short(maceitem4) .. "</>")
                    end
                    if not job5 then
                        actor:send("- <b:yellow>find " .. proto_short(maceitem5) .. "</>")
                    end
                    if stage == 2 then
                        if not job6 then
                            actor:send("- <b:yellow>find " .. proto_short(maceitem6) .. "</>")
                        end
                    end
                end
            end
        end
    end
end
return _return_value$trig$, 'f7e65e0b3b1ba50d6391bbe1fc4d6cd5'),
  -- data/triggers/030/030_25_magistrate_intro.lua
  (30, 25, $trig$-- Converted from DG Script #3025: Magistrate_intro
-- Original: MOB trigger, flags: GREET, probability: 100%
local dg = require("dg")
if actor.is_player then
    wait(0.5)
    actor:send(tostring(self.name) .. " says to you, 'Greetings, " .. tostring(actor.name) .. ".  It is good to see you.  If you would like, I have some <b:cyan>[quests]</> you could give me a hand with.'")
    wait(1)
    if (actor:get_quest_stage("phase_mace") == 1 or (actor:get_quest_stage("phase_mace") == 0 and (actor:has_equipped(2, 140) or actor:has_item(2, 140)))) and not dg.flag(actor:get_quest_var("phase_mace:greet")) then
        actor:send(tostring(self.name) .. " says, 'Oh and you've found quite an unusual mace!  I could probably help you <b:cyan>[upgrade]</> it.'")
    elseif actor:get_quest_stage("phase_mace") == 1 and dg.flag(actor:get_quest_var("phase_mace:greet")) then
        actor:send(tostring(self.name) .. " says, 'Have you found what I require?'")
    end
end$trig$, '157501b4a4a128e1dd9415740458b1b0'),
  -- data/triggers/041/041_01_3bl_qm_greet.lua
  (41, 1, $trig$wait(0.2)
if actor.alignment <= 150 and actor:get_quest_stage("black_legion") == 0 then
    actor:send(tostring(self.name) .. " tells you, 'Hrm, fresh meat to fight the reach of the")
    actor:send("</>elven scum?'")
end$trig$, '6b25c94758edb42c1459c422f2a6dd0c'),
  -- data/triggers/041/041_02_3bl_qm_initiate.lua
  (41, 2, $trig$-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"quest", "emissary", "elven", "scum", "hi", "hello", "yes"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
-- This will recognize the acceptance of the Eldorian combat quests
-- and set the quest variable for later interaction.
if actor:get_quest_var("black_legion:eg_ally") then
    actor:send(tostring(self.name) .. " tells you, 'You have already chosen your side!  Be")
    actor:send("</>gone, filth!'")
    return true
end
-- This is for neutrals and evils only.
if actor.alignment <= 150 and actor.level > 9 then
    wait(0.2)
    if actor:get_quest_stage("black_legion") == 0 then
        actor:start_quest("black_legion")
        actor:set_quest_var("black_legion", "bl_faction", 0)
        actor:set_quest_var("black_legion", "eg_faction", 0)
        actor:set_quest_var("black_legion", "bl_ally", 1)
        -- Note that it is not necessary to initialize sub-quest
        -- variables to 0 because non-existent quest variables
        -- return the same as variables set to 0 in conditionals
    end
    if actor:get_quest_stage("black_legion") > 0 and (actor:get_quest_var("black_legion:bl_faction") or 0) > 99 then
        actor:send(tostring(self.name) .. " tells you, 'Yes, your service to the Legion has been")
        actor:send("</>acceptable.  Perhaps you can help on the front lines in our assault in Eldoria.")
        actor:send(tostring(self.name) .. " tells you, 'Go at once to Tarelithis!  Seek out the")
        actor:send("</>Third Black Legion Recruiter for further instructions!'")
        return true
    end
    actor:send(tostring(self.name) .. " tells you, 'Yes, You will need to assist us in order to")
    actor:send("</>curry our favor.'")
    actor:send(tostring(self.name) .. " tells you, 'We have word the monks of the western vales")
    actor:send("</>are harboring agents of the Eldorian guard.  Go, raid the Abbey and lay waste")
    actor:send("</>to them and their ilk!'")
    actor:send(tostring(self.name) .. " tells you, 'If you bring me back <b:white>[trophies]</> of your")
    actor:send("</>victories, I will <b:white>[reward]</> you!'")
    actor:send(tostring(self.name) .. " tells you, 'If you like you can ask your <b:white>[faction")
    actor:send("</><b:white>status]</>.'")
end$trig$, '770f49850dbb44593320e8da343a8f58'),
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
local function give_back()
    dg.give(self, object, actor)
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
return _return_value$trig$, 'b93deeaede8f1241dee056e08aaa2e9e'),
  -- data/triggers/041/041_04_3bl_rewards_list.lua
  (41, 4, $trig$-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"reward", "rewards"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
if actor:get_quest_var("black_legion:eg_ally") then
    actor:send(tostring(self.name) .. " tells you, 'You have already chosen your side!  Be")
    actor:send("</>gone, filth!'")
    return true
end
-- Resolve a (zone, id) prototype's short name, falling back to the id.
local function shortdesc(zone, id)
    local proto = objects.template(zone, id)
    if proto and proto.name then
        return tostring(proto.name)
    end
    return "item " .. tostring(id)
end
local function reward_line(reward_id, gem_id)
    return "- <b:yellow>" .. shortdesc(55, reward_id) .. "</> for <magenta>" .. shortdesc(55, gem_id) .. "</>"
end
-- gems for this faction (zone 55)
local id_gem_3bl_cap     = 55570
local id_gem_3bl_neck    = 55571
local id_gem_3bl_arm     = 55572
local id_gem_3bl_wrist   = 55573
local id_gem_3bl_staff   = 55581
local id_gem_3bl_ssword  = 55582
local id_gem_3bl_whammer = 55583
local id_gem_3bl_flail   = 55584
local id_gem_3bl_food    = 55566
local id_gem_3bl_drink   = 55567
-- rewards (zone 55)
local id_3bl_cap     = 5517
local id_3bl_neck    = 5519
local id_3bl_arm     = 5521
local id_3bl_wrist   = 5523
local id_3bl_staff   = 5539
local id_3bl_ssword  = 5540
local id_3bl_whammer = 5541
local id_3bl_flail   = 5542
local id_3bl_food    = 5555
local id_3bl_drink   = 5557
-- Check faction and react accordingly.
if actor.alignment <= 150 and actor:get_quest_stage("black_legion") > 0 then
    local bl_faction = actor:get_quest_var("black_legion:bl_faction")
    if (bl_faction or 0) < 20 then
        actor:send(tostring(self.name) .. " tells you, 'You are a bit raw for a recruit, come back")
        actor:send("</>when you have defeated more of the Eldorian villainy.'")
    end
    if (bl_faction or 0) >= 20 then
        actor:send(tostring(self.name) .. " tells you, 'Though you are a bit wet behind the ears I")
        actor:send("</>suppose we can trust you with some of our goods.'")
        actor:send("</>You have access to:")
        actor:send(reward_line(id_3bl_food,   id_gem_3bl_food))
        actor:send(reward_line(id_3bl_drink,  id_gem_3bl_drink))
        actor:send(reward_line(id_3bl_cap,    id_gem_3bl_cap))
        actor:send(reward_line(id_3bl_ssword, id_gem_3bl_ssword))
    end
    if (bl_faction or 0) >= 40 then
        actor:send(reward_line(id_3bl_neck,  id_gem_3bl_neck))
        actor:send(reward_line(id_3bl_staff, id_gem_3bl_staff))
    end
    if (bl_faction or 0) >= 55 then
        actor:send(reward_line(id_3bl_arm,     id_gem_3bl_arm))
        actor:send(reward_line(id_3bl_whammer, id_gem_3bl_whammer))
    end
    if (bl_faction or 0) >= 70 then
        actor:send(reward_line(id_3bl_wrist, id_gem_3bl_wrist))
        actor:send(reward_line(id_3bl_flail, id_gem_3bl_flail))
    end
    if (bl_faction or 0) < 70 then
        actor:send(tostring(self.name) .. " tells you, 'As your standing with the Black Legion")
        actor:send("</>improves I will show you more rewards.'")
    end
end$trig$, '98d9e42756b66f7b0a7434955ca95dc1'),
  -- data/triggers/041/041_05_3eg_qm_greet.lua
  (41, 5, $trig$wait(0.2)
if actor.alignment >= -150 and actor:get_quest_stage("black_legion") == 0 then
    actor:send(tostring(self.name) .. " tells you, 'Hrm, a poor sod to fight the undead masses?'")
end$trig$, '2f65fd6bd63e593d8b8118a6c0d646ea'),
  -- data/triggers/041/041_06_3eg_qm_initiate.lua
  (41, 6, $trig$-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"quest", "sod", "undead", "masses", "hi", "hello", "yes"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
-- This is for neutrals and goods only.
wait(0.2)
if actor:get_quest_var("black_legion:bl_ally") then
    actor:send(tostring(self.name) .. " tells you, 'You have pledged yourself to the forces of")
    actor:send("</>darkness!  Suffer under your choice!'")
    return true
end
if actor.alignment >= -150 then
    if actor:get_quest_stage("black_legion") == 0 then
        actor:start_quest("black_legion")
        actor:set_quest_var("black_legion", "bl_faction", 0)
        actor:set_quest_var("black_legion", "eg_faction", 0)
        actor:set_quest_var("black_legion", "eg_ally", 1)
        -- Note that it is not necessary to initialize sub-quest
        -- variables to 0 because non-existent quest variables
        -- return the same as variables set to 0 in conditionals
    end
    if actor:get_quest_stage("black_legion") > 0 and (actor:get_quest_var("black_legion:eg_faction") or 0) > 99 then
        actor:send(tostring(self.name) .. " tells you, 'Your help to us has not gone unnoticed.  I")
        actor:send("</>wonder...  Perhaps you can help on the front lines in our assault in Eldoria.'")
        actor:send(tostring(self.name) .. " tells you, 'Go at once to Tarelithis!  Seek out the Third")
        actor:send("</>Eldorian Guard Recruiter for further instructions!")
        return true
    end
    actor:send(tostring(self.name) .. " tells you, 'Hrm, you will need to go assist us in our")
    actor:send("efforts in thwarting the Black Legion's influence.'")
    actor:send(tostring(self.name) .. " tells you, 'We understand that the Legion is in cahoots")
    actor:send("</>with the trolls of Split Skull.  If you wish to gain favor with the Eldorian")
    actor:send("</>Court then raid Split Skull.  Lay waste to their ranks!'")
    actor:send(tostring(self.name) .. " tells you, 'If you bring me back <b:white>[trophies]</> of your")
    actor:send("</>victories, I will <b:white>[reward]</> you!'")
    actor:send(tostring(self.name) .. " tells you, 'If you like you can ask your <b:white>[faction")
    actor:send("</><b:white>status]</>.'")
end$trig$, 'db204be3d3f471a960ecc67832a7732c'),
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
local function give_back()
    dg.give(self, object, actor)
end
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
return _return_value$trig$, 'b2ebc6d5f5ab05bf64029d178e70dd6a'),
  -- data/triggers/041/041_08_3eg_rewards_list.lua
  (41, 8, $trig$-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"reward", "rewards"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
if actor:get_quest_var("black_legion:bl_ally") then
    actor:send(tostring(self.name) .. " tells you, 'You have pledged yourself to the forces of")
    actor:send("</>darkness!  Suffer under your choice!'")
    return true
end
-- Resolve a (zone, id) prototype's short name, falling back to the id.
local function shortdesc(zone, id)
    local proto = objects.template(zone, id)
    if proto and proto.name then
        return tostring(proto.name)
    end
    return "item " .. tostring(id)
end
local function reward_line(reward_id, gem_id)
    return "- <b:yellow>" .. shortdesc(55, reward_id) .. "</> for <magenta>" .. shortdesc(55, gem_id) .. ".</>"
end
-- gems for this faction (zone 55)
local id_gem_3eg_cap     = 55570
local id_gem_3eg_neck    = 55571
local id_gem_3eg_arm     = 55572
local id_gem_3eg_wrist   = 55573
local id_gem_3eg_staff   = 55581
local id_gem_3eg_ssword  = 55582
local id_gem_3eg_whammer = 55583
local id_gem_3eg_flail   = 55584
local id_gem_3eg_food    = 55566
local id_gem_3eg_drink   = 55567
-- rewards (zone 55)
local id_3eg_cap     = 5518
local id_3eg_neck    = 5520
local id_3eg_arm     = 5522
local id_3eg_wrist   = 5524
local id_3eg_staff   = 5546
local id_3eg_ssword  = 5547
local id_3eg_whammer = 5548
local id_3eg_flail   = 5549
local id_3eg_food    = 5556
local id_3eg_drink   = 5558
-- Check faction and react accordingly.
if actor.alignment >= -150 and actor:get_quest_stage("black_legion") > 0 then
    local eg_faction = actor:get_quest_var("black_legion:eg_faction")
    if (eg_faction or 0) < 20 then
        actor:send(tostring(self.name) .. " tells you, 'You are a bit raw for a recruit, come back")
        actor:send("</>when you have defeated more of the Black Legion hordes.'")
    end
    if (eg_faction or 0) >= 20 then
        actor:send(tostring(self.name) .. " tells you, 'Though you are a bit wet behind the ears I")
        actor:send("suppose we can trust you with some of our goods.'")
        actor:send("You have access to:")
        actor:send(reward_line(id_3eg_food,   id_gem_3eg_food))
        actor:send(reward_line(id_3eg_drink,  id_gem_3eg_drink))
        actor:send(reward_line(id_3eg_cap,    id_gem_3eg_cap))
        actor:send(reward_line(id_3eg_ssword, id_gem_3eg_ssword))
    end
    if (eg_faction or 0) >= 40 then
        actor:send(reward_line(id_3eg_neck,  id_gem_3eg_neck))
        actor:send(reward_line(id_3eg_staff, id_gem_3eg_staff))
    end
    if (eg_faction or 0) >= 55 then
        actor:send(reward_line(id_3eg_arm,     id_gem_3eg_arm))
        actor:send(reward_line(id_3eg_whammer, id_gem_3eg_whammer))
    end
    if (eg_faction or 0) >= 70 then
        actor:send(reward_line(id_3eg_wrist, id_gem_3eg_wrist))
        actor:send(reward_line(id_3eg_flail, id_gem_3eg_flail))
    end
    if (eg_faction or 0) < 70 then
        actor:send(tostring(self.name) .. " tells you, 'As your standing with the Eldorian Guard")
        actor:send("</>improves I will show you more rewards.'")
    end
end$trig$, '9f42d71e872f961e317824dbc8b78d6c'),
  -- data/triggers/041/041_09_3eg_trophy.lua
  (41, 9, $trig$-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"trophy", "trophies"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
if actor:get_quest_var("black_legion:bl_ally") then
    actor:send(tostring(self.name) .. " tells you, 'You have pledged yourself to the forces of")
    actor:send("</>darkness!  Suffer under your choice!'")
    return true
end
-- Trophy item IDs (zone 55). Names resolved from objects.template at runtime.
local trophy_ids = { 5503, 5505, 5507, 5509, 5511, 5513, 5515 }
if actor.alignment >= -150 and actor:get_quest_stage("black_legion") == 1 then
    actor:send(tostring(self.name) .. " tells you, 'As you fight the allies of the Black Legion")
    actor:send("</>you will periodically find goods on their bodies that we will want in order to")
    actor:send("</>prove that you are working with us.'")
    actor:send("</>Items we're interested in are:")
    for _, id in ipairs(trophy_ids) do
        local proto = objects.template(55, id)
        local label = proto and proto.name or ("trophy " .. tostring(id))
        actor:send("- " .. tostring(label))
    end
end$trig$, 'd7a2fc8bef8353f9ad7ec8933000c525'),
  -- data/triggers/041/041_10_3bl_trophy.lua
  (41, 10, $trig$-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"trophy", "trophies"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
if actor:get_quest_var("black_legion:eg_ally") then
    actor:send(tostring(self.name) .. " tells you, 'You have already chosen your side!  Be")
    actor:send("</>gone, filth!'")
    return true
end
-- Trophy item IDs (zone 55). Names resolved from objects.template at runtime.
local trophy_ids = { 5504, 5506, 5508, 5510, 5512, 5514, 5516 }
if actor.alignment <= 150 and actor:get_quest_stage("black_legion") == 1 then
    actor:send(tostring(self.name) .. " tells you, 'As you fight the allies of Eldorian Guard")
    actor:send("</>you will periodically find goods on their bodies that we will want in order to")
    actor:send("</>prove that you are working with us.'")
    actor:send("</>Items we're interested in are:")
    for _, id in ipairs(trophy_ids) do
        local proto = objects.template(55, id)
        local label = proto and proto.name or ("trophy " .. tostring(id))
        actor:send("- " .. tostring(label))
    end
end$trig$, '126fbc76b61d0e2790ef0e09e4c838d6'),
  -- data/triggers/041/041_17_bl_status.lua
  (41, 17, $trig$-- Speech phrase: faction status (DG num_arg 0 = the speech contains the whole phrase, on word boundaries)
local speech_padded = " " .. string.lower(speech) .. " "
if not string.find(speech_padded, "[%s%p]faction status[%s%p]") then
    return true  -- Not the phrase
end
if actor:get_quest_var("black_legion:bl_ally") then
    actor:send(tostring(self.name) .. " tells you, 'You are pledged to the Black Legion.'")
end
if actor:get_quest_var("black_legion:eg_ally") then
    actor:send(tostring(self.name) .. " tells you, 'You are pledged to the Eldorian Guard.'")
end
actor:send("</>Your progress with our cause is as follows:")
actor:send("</>Faction with The Black Legion: " .. tostring(actor:get_quest_var("black_legion:bl_faction") or 0))
actor:send("</>Faction with The Eldorian Guard: " .. tostring(actor:get_quest_var("black_legion:eg_faction") or 0))$trig$, 'fcca0084e9127f901b9e1e97dbb93198'),
  -- data/triggers/052/052_02_pyromancer_subclass_quest_emmath_greet.lua
  (52, 2, $trig$wait(0.2)
local dg = require("dg")
local wand_quest = (globals.type or "type") .. "_wand"
if globals.wandstep and actor:get_quest_stage(wand_quest) == globals.wandstep then
    local minlevel = (globals.wandstep - 1) * 10
    if actor.level >= minlevel then
        if (actor:get_quest_var(wand_quest .. ":greet") or 0) == 0 then
            actor:send(tostring(self.name) .. " says, 'I see you're crafting something.  If you want my help, we can talk about <b:cyan>[upgrades]</>.'")
        elseif dg.flag(actor:get_quest_var(wand_quest .. ":wandtask1"))
            and dg.flag(actor:get_quest_var(wand_quest .. ":wandtask2"))
            and dg.flag(actor:get_quest_var(wand_quest .. ":wandtask3")) then
            actor:send(tostring(self.name) .. " says, 'I sense you're ready!  Let me see the staff.'")
        else
            actor:send(tostring(self.name) .. " says, 'Do you have what I need for the " .. tostring(globals.weapon) .. "?'")
        end
    end
end
local stage = actor:get_quest_stage("pyromancer_subclass")
-- switch on stage
if stage == 1 then
    actor:send(tostring(self.name) .. " says, 'Come back to try again have you?  Only the best and most motivated of mages will complete the quest I lay before you.'")
    self:command("smile")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'However, I am sure it is in you, if it is truly your desire, to complete this <b:red>quest</> and become a pyromancer.'")
elseif stage == 2 then
    actor:send(tostring(self.name) .. " says, 'Are you ready to finish listening now?  I once controlled all three parts of the flame: <b:white>White</>, <blue>Gray</>, and <b:black>Black</>.'")
    wait(2)
    self:command("frown")
    actor:send(tostring(self.name) .. " says, 'But one of them was taken from my <b:red>control</>.'")
    wait(1)
    self:command("sigh")
elseif stage == 3 or stage == 4 then
    actor:send(tostring(self.name) .. " says, 'Do you have the " .. tostring(actor:get_quest_var("pyromancer_subclass:part")) .. " flame?  Give it here!'")
else
    if string.find(actor.class, "sorcerer") then
        if actor.race == "dragonborn_frost" or actor.race == "arborean" then
            return true
        else
            if actor.level >= 10 and actor.level <= 45 then
                self.room:send("Emmath Firehand's glowing eyes flash brightly for a moment.")
                actor:send(tostring(self.name) .. " says, 'Some love the life of <b:red>flame</>.  Do you?'")
                self:emote("flicks a grin around the room.")
            elseif string.find(actor.class, "sorcerer") and actor.level < 10 then
                self:emote("stares in amazement at " .. tostring(actor.name) .. ".")
                actor:send(tostring(self.name) .. " says, 'I have no idea how you found me but you are far too inexperienced to be in these tunnels in the first place, and even less to ask for my guidance.'")
            end
        end
    end
end$trig$, 'd471b7d9d12fb0b68a27bd42000f55f4'),
  -- data/triggers/052/052_08_emmath_flames_receive.lua
  (52, 8, $trig$local dg = require("dg")
local wand_quest = (globals.type or "type") .. "_wand"
local subclass_item, right_item, flameball_item, count

if (object.zone_id == 238 and object.id == 22) then
    get_room(238, 90):at(function()
        run_room_trigger(238, 14)
    end)
    if globals.wandstep and actor:get_quest_stage(wand_quest) == globals.wandstep and not dg.flag(actor:get_quest_var(wand_quest .. ":wandtask2")) then
        return true
    elseif actor:get_quest_stage("emmath_flameball") > 0 and actor:get_quest_stage("emmath_flameball") <= 3 then
        flameball_item = "yes"
    end
elseif (object.zone_id == 173 and object.id == 8) then
    if actor:get_quest_stage("pyromancer_subclass") > 0 and actor:get_quest_stage("pyromancer_subclass") <= 4 then
        subclass_item = "yes"
        if actor:get_quest_var("pyromancer_subclass:part") == "black" then
            right_item = "yes"
        end
    elseif actor:get_quest_stage("emmath_flameball") >= 0 and actor:get_quest_stage("emmath_flameball") <= 3 then
        flameball_item = "yes"
    end
elseif (object.zone_id == 52 and object.id == 11) then
    if actor:get_quest_stage("pyromancer_subclass") > 0 and actor:get_quest_stage("pyromancer_subclass") <= 4 then
        subclass_item = "yes"
        if actor:get_quest_var("pyromancer_subclass:part") == "white" then
            right_item = "yes"
        end
    elseif actor:get_quest_stage("emmath_flameball") >= 0 and actor:get_quest_stage("emmath_flameball") <= 3 then
        flameball_item = "yes"
    end
elseif (object.zone_id == 52 and object.id == 12) then
    if actor:get_quest_stage("pyromancer_subclass") > 0 and actor:get_quest_stage("pyromancer_subclass") <= 4 then
        subclass_item = "yes"
        if actor:get_quest_var("pyromancer_subclass:part") == "gray" then
            right_item = "yes"
        end
    elseif actor:get_quest_stage("emmath_flameball") >= 0 and actor:get_quest_stage("emmath_flameball") <= 3 then
        flameball_item = "yes"
    end
end
if subclass_item then
    wait(0.2)
    self:destroy_item("questobject")
    -- switch on actor:get_quest_stage("pyromancer_subclass")
    do
        local _sw1 = string.lower(tostring(actor:get_quest_stage("pyromancer_subclass") or ""))
        if tonumber(_sw1) == 4 then
            if right_item == "yes" then
                self:emote("hops up down rapidly.")
                wait(1)
                actor:send(tostring(self.name) .. " says, 'Goodness the spirit of the flame is complete once again!'")
                self:command("shake " .. tostring(actor.name))
                self:command("grin")
                wait(2)
                actor:complete_quest("pyromancer_subclass")
                actor:command("subclass")
            else
                self:command("eyebrow")
                actor:send(tostring(self.name) .. " says, 'No, I already control this part of the flame.'")
                wait(2)
                actor:send(tostring(self.name) .. " says, 'I asked you to bring me the " .. tostring(actor:get_quest_var("pyromancer_subclass:part")) .. " one.'")
            end
        elseif tonumber(_sw1) == 3 then
            self:command("frown " .. tostring(actor.name))
            if right_item == "yes" then
                actor:send(tostring(self.name) .. " says, 'A shame you didn't retrieve the flame yourself.'")
                wait(2)
                actor:send(tostring(self.name) .. " says, 'Maybe you should do it yourself this time.'")
            else
                actor:send(tostring(self.name) .. " says, 'No, no.  You brought me the wrong flame!'")
                wait(2)
                actor:send(tostring(self.name) .. " says, 'I asked you to bring me the " .. tostring(actor:get_quest_var("pyromancer_subclass:part")) .. " one.'")
            end
        elseif tonumber(_sw1) == 2 or tonumber(_sw1) == 1 then
            actor:send(tostring(self.name) .. " says, 'Curious...  I have not even told you what the quest is yet...'")
        else
            actor:send(tostring(self.name) .. " says, 'What a lovely gift, it will fit nicely on my shelf.'")
            self:command("thank " .. tostring(actor.name))
            wait(2)
            actor:send(tostring(self.name) .. " says, 'Shame you were not performing a quest, you seem like a friend of fire.'")
        end
    end
elseif flameball_item then
    if actor:get_quest_stage("emmath_flameball") == 1 then
        _return_value = true
        wait(0.2)
        self:command("frown")
        actor:send(tostring(self.name) .. " says, 'But I didn't even tell you what I wanted yet!'")
        self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
        wait(2)
        actor:send(tostring(self.name) .. " says, 'How do you expect to gain power like this?'")
    elseif actor:get_quest_stage("emmath_flameball") == 2 then
        if (object.zone_id == 52 and object.id == 11) or (object.zone_id == 52 and object.id == 12) or (object.zone_id == 173 and object.id == 8) then
            if (actor:get_quest_var("emmath_flameball:" .. tostring(object.zone_id) .. "_" .. tostring(object.local_id)) or 0) ~= 1 then
                count = 1 + (actor:get_quest_var("emmath_flameball:count") or 0)
                actor:set_quest_var("emmath_flameball", "count", count)
                actor:set_quest_var("emmath_flameball", (tostring(object.zone_id) .. "_" .. tostring(object.local_id)), 1)
            else
                wait(0.2)
                actor:send(tostring(self.name) .. " says, 'You have already brought me " .. tostring(object.shortdesc) .. "!'")
                self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
            end
            if count then
                wait(0.2)
                self:destroy_item("questobject")
                -- switch on count
                do
                    local _sw2 = string.lower(tostring(count or ""))
                    if tonumber(_sw2) == 1 then
                        actor:send(tostring(self.name) .. " says, 'Excellent.  That's one.  Two to go.'")
                    elseif tonumber(_sw2) == 2 then
                        actor:send(tostring(self.name) .. " says, 'Good, good.  That's two.  One more!'")
                    elseif tonumber(_sw2) == 3 then
                        actor:advance_quest("emmath_flameball")
                        self:command("smile")
                        actor:send(tostring(self.name) .. " says, 'I'm glad you were able to tame the three flames.'")
                        wait(2)
                        self:command("scratch")
                        actor:send(tostring(self.name) .. " says, 'There is one more, though, a renegade flame.'")
                        wait(1)
                        self:command("sigh")
                        wait(2)
                        actor:send(tostring(self.name) .. " says, 'Some time ago, I battled my counterpart, the illustrious Suralla Iceeye.'")
                        self:emote("looks thoughtful, reminiscing in his mind.")
                        wait(2)
                        actor:send(tostring(self.name) .. " says, 'Nothing terrible came of it, but she succeeded in...'")
                        wait(1)
                        actor:send(tostring(self.name) .. " says, '... changing one of my flames.'")
                        self:emote("looks around himself.")
                        wait(3)
                        actor:send(tostring(self.name) .. " says, 'She was able to meld flame and ice, and form one neither cold nor warm.'")
                        wait(2)
                        self:command("lick")
                        actor:send(tostring(self.name) .. " says, 'I'm sure you understand when I say I cannot allow this flame to exist.'")
                        wait(3)
                        self:command("ponder")
                        actor:send(tostring(self.name) .. " says, 'Return it to me so that I might destroy it.'")
                        wait(7)
                        actor:send(tostring(self.name) .. " says, 'Well, don't wait around all day.'")
                    end
                end
            end
        elseif (object.zone_id == 238 and object.id == 22) then
            self:destroy_item("blue-flame")
            self:command("eye")
            actor:send(tostring(self.name) .. " says, 'I didn't ask you to bring me this yet.")
            self.room:send(tostring(self.name) .. " extinguishes " .. tostring(objects.template(238, 22).name) .. ".")
        end
    elseif actor:get_quest_stage("emmath_flameball") == 3 then
        if (object.zone_id == 238 and object.id == 22) then
            wait(0.2)
            self:destroy_item("blue-flame")
            actor:send(tostring(self.name) .. " says, 'Ah yes... the blue flame.'")
            self:command("smile self")
            wait(2)
            actor:send(tostring(self.name) .. " says, 'Such a pity to destroy such an artifact as this.'")
            self:emote("pauses momentarily.")
            wait(3)
            actor:send(tostring(self.name) .. " says, 'But it must be done.'")
            wait(1)
            self:emote("crushes the blue flame in his hand, its essence evaporating into the air.")
            wait(2)
            self:command("lick")
            wait(2)
            self:command("look " .. tostring(actor.name))
            actor:send(tostring(self.name) .. " says, 'Well now I suppose I owe you something, don't I?  You seem ready for the power.'")
            actor:erase_quest("emmath_flameball")
            wait(2)
            actor:send(tostring(self.name) .. " says, 'But remember!  With great power, comes great responsibility.'")
            self.room:spawn_object(52, 10)
            self:command("give ball " .. tostring(actor.name))
        end
    end
end
return _return_value$trig$, '614e5f0f3b7e5eb2e4af489b3a44c5c0'),
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

dg.give(self, object, actor)
self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
wait(0.2)
actor:send(tostring(self.name) .. " says, '" .. tostring(response) .. "'")
return true$trig$, '5012df6da4a2d6e051522129e02e05a9'),
  -- data/triggers/055/055_01_3bl_qm_greet.lua
  (55, 1, $trig$-- Converted from DG Script #5501: 3bl_qm_greet
-- Original: MOB trigger, flags: GREET, probability: 100%
wait(0.2)
if actor.alignment <= 150 and actor:get_quest_stage("black_legion") == 0 then
    -- (empty send to actor)
    actor:send(tostring(self.name) .. " tells you, 'Hrm, a new recruit to fight the")
    actor:send("</>elven scum?'")
    -- (empty send to actor)
end$trig$, 'ca14c5ba98eaa492ff247994c1643fca'),
  -- data/triggers/055/055_02_3bl_qm_initiate.lua
  (55, 2, $trig$-- Converted from DG Script #5502: 3bl_qm_initiate
-- Original: MOB trigger, flags: SPEECH, SPEECH_TO, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"quest", "recruit", "elven", "scum", "hi", "hello", "yes"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
-- 
-- This will recognize the acceptance of the Eldorian combat quests
-- and set the quest variable for later interaction.
-- 
-- This is for neutrals and evils only.
if actor:get_quest_var("black_legion:eg_ally") then
    actor:send(tostring(self.name) .. " tells you, 'You have already chosen your side!")
    actor:send("</>Be gone, filth!'")
    return _return_value
end
if actor.alignment <= 150 then
    wait(0.2)
    if actor:get_quest_stage("black_legion") == 0 then
        actor:start_quest("black_legion")
        actor:set_quest_var("black_legion", "bl_faction", 0)
        actor:set_quest_var("black_legion", "eg_faction", 0)
        -- Note that it is not necessary to initialize sub-quest
        -- variables to 0 because non-existent quest variables
        -- return the same as variables set to 0 in conditionals
        actor:set_quest_var("black_legion", "bl_ally", 1)
        -- being added 2-18-2021 to prevent team switching
    end
    actor:send(tostring(self.name) .. " tells you, 'Yes, You need to go assist our")
    actor:send("</>fighters.  Go, invade the 3rd Eldorian Guard and lay waste to their ranks!'")
    -- (empty send to actor)
    actor:send(tostring(self.name) .. " tells you, 'If you bring me back <b:white>[trophies]</> of")
    actor:send("your victories, I will <b:white>[reward]</> you!'")
    -- (empty send to actor)
    actor:send(tostring(self.name) .. " tells you, 'If you like you can ask your")
    actor:send("</><b:white>[faction status]</>.'")
    -- (empty send to actor)
end$trig$, '74d2aff214c7c99d7981e649084ad12f'),
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
local function give_back()
    dg.give(self, object, actor)
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
return _return_value$trig$, 'e941baed4688706391f55b9231a11683'),
  -- data/triggers/055/055_04_3bl_rewards_list.lua
  (55, 4, $trig$-- Converted from DG Script #5504: 3bl_rewards_list
-- Original: MOB trigger, flags: SPEECH, SPEECH_TO, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
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
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"reward", "rewards"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
if actor:get_quest_var("black_legion:eg_ally") then
    actor:send(tostring(self.name) .. " tells you, 'You have already chosen your side!")
    actor:send("</>Be gone, filth!'")
    return _return_value
end
local id_gem_3bl_cap = 55570
local id_gem_3bl_neck = 55571
local id_gem_3bl_arm = 55572
local id_gem_3bl_wrist = 55573
local id_gem_3bl_gloves = 55574
local id_gem_3bl_jerkin = 55575
local id_gem_3bl_robe = 55589
local id_gem_3bl_belt = 55576
local id_gem_3bl_legs = 55577
local id_gem_3bl_boots = 55578
local id_gem_3bl_mask = 55579
local id_gem_3bl_symbol = 55580
local id_gem_3bl_staff = 55581
local id_gem_3bl_ssword = 55582
local id_gem_3bl_whammer = 55583
local id_gem_3bl_flail = 55584
local id_gem_3bl_shiv = 55585
local id_gem_3bl_lsword = 55586
local id_gem_3bl_smace = 55587
local id_gem_3bl_light = 55588
local id_gem_3bl_food = 55566
local id_gem_3bl_drink = 55567
-- rewards
local id_3bl_cap = 5517
local id_3bl_neck = 5519
local id_3bl_arm = 5521
local id_3bl_wrist = 5523
local id_3bl_gloves = 5525
local id_3bl_jerkin = 5527
local id_3bl_belt = 5529
local id_3bl_legs = 5531
local id_3bl_boots = 5533
local id_3bl_mask = 5535
local id_3bl_robe = 5537
local id_3bl_symbol = 5515
local id_3bl_staff = 5539
local id_3bl_ssword = 5540
local id_3bl_whammer = 5541
local id_3bl_flail = 5542
local id_3bl_shiv = 5543
local id_3bl_lsword = 5544
local id_3bl_smace = 5545
local id_3bl_light = 5553
local id_3bl_food = 5555
local id_3bl_drink = 5557
-- 
-- Check faction and react accordingly
-- 
if actor.alignment <= 150 then
    if actor:get_quest_stage("black_legion") > 0 then
        if (actor:get_quest_var("black_legion:bl_faction") or 0) < 20 then
            -- (empty send to actor)
            actor:send(tostring(self.name) .. " tells you, 'You are a bit raw for a recruit,")
            actor:send("</>come back when you have defeated more of the Eldorian villainy.'")
        end
        if (actor:get_quest_var("black_legion:bl_faction") or 0) >= 20 then
            -- (empty send to actor)
            -- msend %actor% %self.name% tells you,'Your bl faction is %actor:get_quest_var("black_legion:bl_faction")%.
            actor:send(tostring(self.name) .. " tells you, 'Though you are a bit wet behind the")
            actor:send("</>ears I suppose we can trust you with some of our goods.'")
            -- (empty send to actor)
            actor:send("</>You have access to:")
            actor:send("- <b:yellow>" .. proto_short(id_3bl_food) .. "</> for <magenta>" .. proto_short(id_gem_3bl_food) .. "</>")
            actor:send("- <b:yellow>" .. proto_short(id_3bl_drink) .. "</> for <magenta>" .. proto_short(id_gem_3bl_drink) .. "</>")
            actor:send("- <b:yellow>" .. proto_short(id_3bl_cap) .. "</> for <magenta>" .. proto_short(id_gem_3bl_cap) .. "</>")
            actor:send("- <b:yellow>" .. proto_short(id_3bl_ssword) .. "</> for <magenta>" .. proto_short(id_gem_3bl_ssword) .. "</>")
        end
        if (actor:get_quest_var("black_legion:bl_faction") or 0) >= 40 then
            actor:send("- <b:yellow>" .. proto_short(id_3bl_neck) .. "</> for <magenta>" .. proto_short(id_gem_3bl_neck) .. "</>")
            actor:send("- <b:yellow>" .. proto_short(id_3bl_staff) .. "</> for <magenta>" .. proto_short(id_gem_3bl_staff) .. "</>")
        end
        if (actor:get_quest_var("black_legion:bl_faction") or 0) >= 55 then
            actor:send("- <b:yellow>" .. proto_short(id_3bl_arm) .. "</> for <magenta>" .. proto_short(id_gem_3bl_arm) .. "</>")
            actor:send("- <b:yellow>" .. proto_short(id_3bl_whammer) .. "</> for <magenta>" .. proto_short(id_gem_3bl_whammer) .. "</>")
        end
        if (actor:get_quest_var("black_legion:bl_faction") or 0) >= 70 then
            actor:send("- <b:yellow>" .. proto_short(id_3bl_wrist) .. "</> for <magenta>" .. proto_short(id_gem_3bl_wrist) .. "</>")
            actor:send("- <b:yellow>" .. proto_short(id_3bl_flail) .. "</> for <magenta>" .. proto_short(id_gem_3bl_flail) .. "</>")
        end
        if (actor:get_quest_var("black_legion:bl_faction") or 0) >= 85 then
            actor:send("- <b:yellow>" .. proto_short(id_3bl_gloves) .. "</> for <magenta>" .. proto_short(id_gem_3bl_gloves) .. "</>")
            actor:send("- <b:yellow>" .. proto_short(id_3bl_symbol) .. "</> for <magenta>" .. proto_short(id_gem_3bl_symbol) .. "</>")
            actor:send("- <b:yellow>" .. proto_short(id_3bl_light) .. "</> for <magenta>" .. proto_short(id_gem_3bl_light) .. "</>")
        end
        if (actor:get_quest_var("black_legion:bl_faction") or 0) >= 100 then
            actor:send("- <b:yellow>" .. proto_short(id_3bl_belt) .. "</> for <magenta>" .. proto_short(id_gem_3bl_belt) .. "</>")
            actor:send("- <b:yellow>" .. proto_short(id_3bl_shiv) .. "</> for <magenta>" .. proto_short(id_gem_3bl_shiv) .. "</>")
        end
        if (actor:get_quest_var("black_legion:bl_faction") or 0) >= 115 then
            actor:send("- <b:yellow>" .. proto_short(id_3bl_boots) .. "</> for <magenta>" .. proto_short(id_gem_3bl_boots) .. "</>")
            actor:send("- <b:yellow>" .. proto_short(id_3bl_lsword) .. "</> for <magenta>" .. proto_short(id_gem_3bl_lsword) .. "</>")
        end
        if (actor:get_quest_var("black_legion:bl_faction") or 0) >= 130 then
            actor:send("- <b:yellow>" .. proto_short(id_3bl_legs) .. "</> for <magenta>" .. proto_short(id_gem_3bl_legs) .. "</>")
        end
        if (actor:get_quest_var("black_legion:bl_faction") or 0) >= 145 then
            actor:send("- <b:yellow>" .. proto_short(id_3bl_robe) .. "</> for <magenta>" .. proto_short(id_gem_3bl_robe) .. "</>")
            actor:send("- <b:yellow>" .. proto_short(id_3bl_jerkin) .. "</> for <magenta>" .. proto_short(id_gem_3bl_jerkin) .. "</>")
        end
        if (actor:get_quest_var("black_legion:bl_faction") or 0) >= 160 then
            actor:send("- <b:yellow>" .. proto_short(id_3bl_mask) .. "</> for <magenta>" .. proto_short(id_gem_3bl_mask) .. "</>")
            actor:send("- <b:yellow>" .. proto_short(id_3bl_smace) .. "</> for <magenta>" .. proto_short(id_gem_3bl_smace) .. "</>")
        end
        if (actor:get_quest_var("black_legion:bl_faction") or 0) < 160 then
            -- (empty send to actor)
            actor:send(tostring(self.name) .. " tells you, 'As your standing with the Black")
            actor:send("</>Legion improves I will show you more rewards.'")
        end
        -- (empty send to actor)
    end
end$trig$, '44d16446e312a93b2459c597b29b3dbb'),
  -- data/triggers/055/055_05_3eg_qm_greet.lua
  (55, 5, $trig$-- Converted from DG Script #5505: 3eg_qm_greet
-- Original: MOB trigger, flags: GREET, probability: 100%
wait(0.2)
if actor.alignment >= -150 and actor:get_quest_stage("black_legion") == 0 then
    actor:send(tostring(self.name) .. " tells you, 'Hrm, a new recruit")
    actor:send("</>to fight the undead masses?'")
end$trig$, '971d6075a2a07928dfa7db48d2c3e56d'),
  -- data/triggers/055/055_06_3eg_qm_initiate.lua
  (55, 6, $trig$-- Converted from DG Script #5506: 3eg_qm_initiate
-- Original: MOB trigger, flags: SPEECH, SPEECH_TO, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"quest", "recruit", "undead", "masses", "hi", "hello", "yes"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
-- 
-- This will recognize the acceptance of the Eldorian combat quests
-- and set the quest variable for later interaction.
-- 
-- This is for neutrals and good only.
if actor:get_quest_var("black_legion:bl_ally") then
    actor:send(tostring(self.name) .. " tells you, 'You have pledged")
    actor:send("</>yourself to the forces of darkness!  Suffer under your choice!'")
    return _return_value
end
if actor.alignment >= -150 then
    wait(0.2)
    if actor:get_quest_stage("black_legion") == 0 then
        actor:start_quest("black_legion")
        actor:set_quest_var("black_legion", "bl_faction", 0)
        actor:set_quest_var("black_legion", "eg_faction", 0)
        -- Note that it is not necessary to initialize sub-quest
        -- variables to 0 because non-existent quest variables
        -- return the same as variables set to 0 in conditionals
        actor:set_quest_var("black_legion", "eg_ally", 1)
    end
    actor:send(tostring(self.name) .. " tells you, 'Yes, You need to go")
    actor:send("</>assist our fighters.  Go, invade the 3rd Black Legion and lay waste to their")
    actor:send("</>ranks!'")
    -- (empty send to actor)
    actor:send(tostring(self.name) .. " tells you, 'If you bring me back")
    actor:send("</><b:white>[trophies]</> of your victories, I will <b:white>[reward]</> you!'")
    -- (empty send to actor)
    actor:send(tostring(self.name) .. " tells you, 'If you like you can ask")
    actor:send("</>your <b:white>[faction status]</>.'")
    -- (empty send to actor)
end$trig$, '0b63ff3db62cf95d2cee996e058b9b6f'),
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
local function give_back()
    dg.give(self, object, actor)
end
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
return _return_value$trig$, 'c8bd3bbcefde6512bb517e8b9ad18381'),
  -- data/triggers/055/055_08_3eg_rewards_list.lua
  (55, 8, $trig$-- Converted from DG Script #5508: 3eg_rewards_list
-- Original: MOB trigger, flags: SPEECH, SPEECH_TO, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
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
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"reward", "rewards"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
local id_gem_3eg_cap = 55570
local id_gem_3eg_neck = 55571
local id_gem_3eg_arm = 55572
local id_gem_3eg_wrist = 55573
local id_gem_3eg_gloves = 55574
local id_gem_3eg_jerkin = 55575
local id_gem_3eg_robe = 55589
local id_gem_3eg_belt = 55576
local id_gem_3eg_legs = 55577
local id_gem_3eg_boots = 55578
local id_gem_3eg_mask = 55579
local id_gem_3eg_symbol = 55580
local id_gem_3eg_staff = 55581
local id_gem_3eg_ssword = 55582
local id_gem_3eg_whammer = 55583
local id_gem_3eg_flail = 55584
local id_gem_3eg_shiv = 55585
local id_gem_3eg_lsword = 55586
local id_gem_3eg_smace = 55587
local id_gem_3eg_light = 55588
local id_gem_3eg_food = 55566
local id_gem_3eg_drink = 55567
-- rewards
local id_3eg_cap = 5518
local id_3eg_neck = 5520
local id_3eg_arm = 5522
local id_3eg_wrist = 5524
local id_3eg_gloves = 5526
local id_3eg_jerkin = 5528
local id_3eg_belt = 5530
local id_3eg_legs = 5532
local id_3eg_boots = 5534
local id_3eg_mask = 5536
local id_3eg_robe = 5538
local id_3eg_symbol = 5516
local id_3eg_staff = 5546
local id_3eg_ssword = 5547
local id_3eg_whammer = 5548
local id_3eg_flail = 5549
local id_3eg_shiv = 5550
local id_3eg_lsword = 5551
local id_3eg_smace = 5552
local id_3eg_light = 5554
local id_3eg_food = 5556
local id_3eg_drink = 5558
-- 
-- Check faction and react accordingly
-- 
if actor:get_quest_var("black_legion:bl_ally") then
    actor:send(tostring(self.name) .. " tells you, 'You have pledged")
    actor:send("</>yourself to the forces of darkness!  Suffer under your choice!'")
    return _return_value
end
if actor.alignment >= -150 then
    if actor:get_quest_stage("black_legion") > 0 then
        if (actor:get_quest_var("black_legion:eg_faction") or 0) < 20 then
            -- (empty send to actor)
            actor:send(tostring(self.name) .. " tells you, 'You are a bit raw for a")
            actor:send("</>recruit, come back when you have defeated more of the Black Legion hordes.'")
        end
        if (actor:get_quest_var("black_legion:eg_faction") or 0) >= 20 then
            -- (empty send to actor)
            -- msend %actor% %self.name% tells you,'Your bl faction is %actor:get_quest_var("black_legion:eg_faction")%.
            actor:send(tostring(self.name) .. " tells you, 'Though you are a bit")
            actor:send("</>wet behind the ears I suppose we can trust you with some of our goods.'")
            -- (empty send to actor)
            actor:send("</>You have access to:")
            actor:send("- <b:yellow>" .. proto_short(id_3eg_food) .. "</> for <magenta>" .. proto_short(id_gem_3eg_food) .. "</>")
            actor:send("- <b:yellow>" .. proto_short(id_3eg_drink) .. "</> for <magenta>" .. proto_short(id_gem_3eg_drink) .. "</>")
            actor:send("- <b:yellow>" .. proto_short(id_3eg_cap) .. "</> for <magenta>" .. proto_short(id_gem_3eg_cap) .. "</>")
            actor:send("- <b:yellow>" .. proto_short(id_3eg_ssword) .. "</> for <magenta>" .. proto_short(id_gem_3eg_ssword) .. "</>")
        end
        if (actor:get_quest_var("black_legion:eg_faction") or 0) >= 40 then
            actor:send("- <b:yellow>" .. proto_short(id_3eg_neck) .. "</> for <magenta>" .. proto_short(id_gem_3eg_neck) .. "</>")
            actor:send("- <b:yellow>" .. proto_short(id_3eg_staff) .. "</> for <magenta>" .. proto_short(id_gem_3eg_staff) .. "</>")
        end
        if (actor:get_quest_var("black_legion:eg_faction") or 0) >= 55 then
            actor:send("- <b:yellow>" .. proto_short(id_3eg_arm) .. "</> for <magenta>" .. proto_short(id_gem_3eg_arm) .. "</>")
            actor:send("- <b:yellow>" .. proto_short(id_3eg_whammer) .. "</> for <magenta>" .. proto_short(id_gem_3eg_whammer) .. "</>")
        end
        if (actor:get_quest_var("black_legion:eg_faction") or 0) >= 70 then
            actor:send("- <b:yellow>" .. proto_short(id_3eg_wrist) .. "</> for <magenta>" .. proto_short(id_gem_3eg_wrist) .. "</>")
            actor:send("- <b:yellow>" .. proto_short(id_3eg_flail) .. "</> for <magenta>" .. proto_short(id_gem_3eg_flail) .. "</>")
        end
        if (actor:get_quest_var("black_legion:eg_faction") or 0) >= 85 then
            actor:send("- <b:yellow>" .. proto_short(id_3eg_gloves) .. "</> for <magenta>" .. proto_short(id_gem_3eg_gloves) .. "</>")
            actor:send("- <b:yellow>" .. proto_short(id_3eg_symbol) .. "</> for <magenta>" .. proto_short(id_gem_3eg_symbol) .. "</>")
            actor:send("- <b:yellow>" .. proto_short(id_3eg_light) .. "</> for <magenta>" .. proto_short(id_gem_3eg_light) .. "</>")
        end
        if (actor:get_quest_var("black_legion:eg_faction") or 0) >= 100 then
            actor:send("- <b:yellow>" .. proto_short(id_3eg_belt) .. "</> for <magenta>" .. proto_short(id_gem_3eg_belt) .. "</>")
            actor:send("- <b:yellow>" .. proto_short(id_3eg_shiv) .. "</> for <magenta>" .. proto_short(id_gem_3eg_shiv) .. "</>")
        end
        if (actor:get_quest_var("black_legion:eg_faction") or 0) >= 115 then
            actor:send("- <b:yellow>" .. proto_short(id_3eg_boots) .. "</> for <magenta>" .. proto_short(id_gem_3eg_boots) .. "</>")
            actor:send("- <b:yellow>" .. proto_short(id_3eg_lsword) .. "</> for <magenta>" .. proto_short(id_gem_3eg_lsword) .. "</>")
        end
        if (actor:get_quest_var("black_legion:eg_faction") or 0) >= 130 then
            actor:send("- <b:yellow>" .. proto_short(id_3eg_legs) .. "</> for <magenta>" .. proto_short(id_gem_3eg_legs) .. "</>")
        end
        if (actor:get_quest_var("black_legion:eg_faction") or 0) >= 145 then
            actor:send("- <b:yellow>" .. proto_short(id_3eg_robe) .. "</> for <magenta>" .. proto_short(id_gem_3eg_robe) .. "</>")
            actor:send("- <b:yellow>" .. proto_short(id_3eg_jerkin) .. "</> for <magenta>" .. proto_short(id_gem_3eg_jerkin) .. "</>")
        end
        if (actor:get_quest_var("black_legion:eg_faction") or 0) >= 160 then
            actor:send("- <b:yellow>" .. proto_short(id_3eg_mask) .. "</> for <magenta>" .. proto_short(id_gem_3eg_mask) .. "</>")
            actor:send("- <b:yellow>" .. proto_short(id_3eg_smace) .. "</> for <magenta>" .. proto_short(id_gem_3eg_smace) .. "</>")
        end
        if (actor:get_quest_var("black_legion:eg_faction") or 0) < 160 then
            -- (empty send to actor)
            actor:send(tostring(self.name) .. " tells you, 'As your standing with")
            actor:send("</>the 3rd Eldorian Guard improves I will show you more rewards.'")
        end
    end
end$trig$, '9247279a39a3c309befa9dcdad94beab'),
  -- data/triggers/055/055_09_3eg_trophy.lua
  (55, 9, $trig$-- Converted from DG Script #5509: 3eg_trophy
-- Original: MOB trigger, flags: SPEECH, SPEECH_TO, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
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
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"trophy", "trophies"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
if actor:get_quest_var("black_legion:bl_ally") then
    actor:send(tostring(self.name) .. " tells you, 'You have pledged")
    actor:send("</>yourself to the forces of darkness!  Suffer under your choice!'")
    return _return_value
end
local id_trophy1 = 5503
local id_trophy2 = 5505
local id_trophy3 = 5507
local id_trophy4 = 5509
local id_trophy5 = 5511
local id_trophy6 = 5513
local id_trophy7 = 5515
if actor.alignment >= -150 and actor:get_quest_stage("black_legion") == 1 then
    -- (empty send to actor)
    actor:send(tostring(self.name) .. " tells you, 'As you fight the Black")
    actor:send("</>Legion you will periodically find goods on their bodies that we will want in")
    actor:send("</>order to prove that you are working with us.'")
    -- (empty send to actor)
    actor:send("</>Items we're interested in are:")
    actor:send("- " .. proto_short(id_trophy1))
    actor:send("- " .. proto_short(id_trophy2))
    actor:send("- " .. proto_short(id_trophy3))
    actor:send("- " .. proto_short(id_trophy4))
    actor:send("- " .. proto_short(id_trophy5))
    actor:send("- " .. proto_short(id_trophy6))
    actor:send("- " .. proto_short(id_trophy7))
end$trig$, '7982bcf98acdc20fd1d55bfa73c9f072'),
  -- data/triggers/055/055_10_3bl_trophy.lua
  (55, 10, $trig$-- Converted from DG Script #5510: 3bl_trophy
-- Original: MOB trigger, flags: SPEECH, SPEECH_TO, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
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
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"trophy", "trophies"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
if actor:get_quest_var("black_legion:eg_ally") then
    actor:send(tostring(self.name) .. " tells you, 'You have already chosen your side!")
    actor:send("</>Be gone, filth!'")
    return _return_value
end
local id_trophy1 = 5504
local id_trophy2 = 5506
local id_trophy3 = 5508
local id_trophy4 = 5510
local id_trophy5 = 5512
local id_trophy6 = 5514
local id_trophy7 = 5516
if actor.alignment <= 150 and actor:get_quest_stage("black_legion") == 1 then
    -- (empty send to actor)
    actor:send(tostring(self.name) .. " tells you, 'As you fight the Eldorian Guard you")
    actor:send("</>will periodically find goods on their bodies that we will want in order to")
    actor:send("</>prove that you are working with us.'")
    -- (empty send to actor)
    actor:send("</>Items we're interested in are:")
    actor:send("- " .. proto_short(id_trophy1))
    actor:send("- " .. proto_short(id_trophy2))
    actor:send("- " .. proto_short(id_trophy3))
    actor:send("- " .. proto_short(id_trophy4))
    actor:send("- " .. proto_short(id_trophy5))
    actor:send("- " .. proto_short(id_trophy6))
    actor:send("- " .. proto_short(id_trophy7))
end$trig$, '98ed3ee35f689c9585477769a0dd7d92'),
  -- data/triggers/055/055_17_bl_status.lua
  (55, 17, $trig$-- Speech phrase: faction status (DG num_arg 0 = the speech contains the whole phrase, on word boundaries)
local speech_padded = " " .. string.lower(speech) .. " "
if not string.find(speech_padded, "[%s%p]faction status[%s%p]") then
    return true  -- Not the phrase
end
wait(0.2)
if actor:get_quest_var("black_legion:bl_ally") then
    actor:send(tostring(self.name) .. " tells you, 'You are pledged to the Black")
    actor:send("</>Legion.'")
end
if actor:get_quest_var("black_legion:eg_ally") then
    actor:send(tostring(self.name) .. " tells you, 'You are pledged to the")
    actor:send("</>Eldorian Guard.'")
end
-- (empty send to actor)
actor:send("Your progress with our cause is as follows:</>")
actor:send("Faction with The Black Legion: " .. tostring(actor:get_quest_var("black_legion:bl_faction") or 0) .. "</>")
actor:send("Faction with The Eldorian Guard: " .. tostring(actor:get_quest_var("black_legion:eg_faction") or 0) .. "</>")$trig$, '95c72e7b89b1366f4f3b74942bdd987b'),
  -- data/triggers/085/085_00_ziijhan_welcome.lua
  (85, 0, $trig$-- Converted from DG Script #8500: ziijhan_welcome
-- Original: MOB trigger, flags: GREET, probability: 100%
wait(0.2)
-- switch on actor:get_quest_stage("nec_dia_ant_subclass")
if actor:get_quest_stage("nec_dia_ant_subclass") == 1 then
    actor:send(tostring(self.name) .. " says, 'So you come crawling back.'")
    wait(0.2)
    actor:send(tostring(self.name) .. " says, 'Only the most cunning and strong will complete the <magenta>quest</> I set before you.  I shall take great pleasure in your demise, but I will offer great rewards for your success.'")
elseif actor:get_quest_stage("nec_dia_ant_subclass") == 2 then
    actor:send(tostring(self.name) .. " says, 'It is time to hunt!'")
    wait(0.2)
    actor:send(tostring(self.name) .. " says, 'My pitiful waste of a <magenta>brother</> escaped my minions.'")
elseif actor:get_quest_stage("nec_dia_ant_subclass") == 3 or actor:get_quest_stage("nec_dia_ant_subclass") == 4 then
    actor:send(tostring(self.name) .. " says, 'Have you brought proof that my brother is not beyond my reach?'")
else
    local classgreet = "no"
    local maxlevel = 0
    if string.find(actor.class, "warrior") then
        if actor.race ~= "elf" and actor.race ~= "faerie_seelie" then
            classgreet = "yes"
            maxlevel = 25
        end
    elseif string.find(actor.class, "cleric") then
        if actor.race ~= "elf" and actor.race ~= "faerie_seelie" then
            classgreet = "yes"
            maxlevel = 35
        end
    elseif string.find(actor.class, "sorcerer") then
        if actor.race ~= "elf" and actor.race ~= "faerie_seelie" then
            classgreet = "yes"
            maxlevel = 45
        end
    end
    if classgreet == "yes" then
        if actor.level >= 10 and actor.level <= maxlevel then
            self:command("peer " .. tostring(actor.name))
            self:emote("places a most vile half-smile on his face.")
            actor:send(tostring(self.name) .. " says, 'Some know not of their <magenta>destinies</>, while others simply choose to ignore them.'")
            wait(2)
            actor:send(tostring(self.name) .. " says, 'Which of the two are you?'")
            self:command("glare " .. tostring(actor.name))
        end
    end
end
-- Ziijhan is the macestep 5 priest: `macestep` comes from the LOAD trigger 002_118 through `globals`.
if globals.macestep and actor:get_quest_stage("phase_mace") == globals.macestep then
    local minlevel = globals.macestep * 10
    if actor.level >= minlevel then
        if (actor:get_quest_var("phase_mace:greet") or 0) == 0 then
            actor:send(tostring(self.name) .. " says, 'I sense a ghostly presence about your weapons.  If you want my help, we can talk about <b:cyan>[upgrades]</>.'")
        else
            actor:send(tostring(self.name) .. " says, 'Do you have what I need?'")
        end
    end
end$trig$, '38ddeed35c53666c041470533540d1a7'),
  -- data/triggers/085/085_26_ziijhan_general_receive.lua
  (85, 26, $trig$local dg = require("dg")
if dg.gone(object) then return true end  -- an earlier receive trigger already took it
if object.zone_id == 85 and object.id == 4 then
    return true
end
if dg.quest_item(object, globals) then
    return true
end
dg.give(self, object, actor)
actor:send(tostring(self.name) .. " scoffs at " .. tostring(object.shortdesc) .. ".")
wait(0.2)
actor:send(tostring(self.name) .. " says, 'What is this garbage?'")
return true$trig$, 'd03d43174fb501b17f64d1752bcaae13'),
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

dg.give(self, object, actor)
self.room:send(self.name .. " refuses " .. tostring(object.shortdesc) .. ".")
wait(0.2)
self:say(response)
return false$trig$, '02b8830a8e97ca9f6bd637ac6eb4291e'),
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
    dg.give(self, object, actor)
    self:command("shake")
    self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
    wait(0.2)
    self:say("I'm sorry, I'm quite busy right now.")
elseif actor:get_quest_stage("megalith_quest") > 2 or (actor:get_quest_stage("megalith_quest") == 2 and (actor:get_quest_var("megalith_quest:item" .. tostring(part)) or 0) == 1) then
    dg.give(self, object, actor)
    self:command("shake")
    self:say("I don't need any additional assistance at the moment, thank you.")
    if (self.zone_id == 123 and self.id == 6) then
        self:command("curtsy " .. tostring(actor.name))
    else
        self:command("bow " .. tostring(actor.name))
    end
elseif actor:get_quest_stage("megalith_quest") == 2 then
    if direction and ((actor:get_quest_var("megalith_quest:" .. direction) or 0) == 0) and (not actor:get_quest_var("megalith_quest:item" .. tostring(part))) then
        dg.give(self, object, actor)
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
    else
        if ((self.zone_id == 123 and self.id == 3) and (object.zone_id == 550 and object.id == 20)) or ((self.zone_id == 123 and self.id == 4) and (object.zone_id == 481 and object.id == 9)) or ((self.zone_id == 123 and self.id == 5) and (object.zone_id == 83 and object.id == 1)) or ((self.zone_id == 123 and self.id == 6) and ((object.zone_id == 411 and object.id == 10) or (object.zone_id == 411 and object.id == 11) or (object.zone_id == 185 and object.id == 12))) then
            return _return_value
        else
            dg.give(self, object, actor)
            self:command("shake")
            self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
            wait(0.2)
            if (self.zone_id == 123 and self.id == 6) then
                self:say("Unfortunately, I need " .. need_name() .. " filled with water, not this.")
            else
                self:say("Unfortunately, I need " .. need_name() .. ", not this.")
            end
        end
    end
end
return _return_value$trig$, '5259ea4cc6372212cb3e7afc7a6df9c0'),
  -- data/triggers/163/163_01_quest_eleweiss_ranger_druid_subclass_greet.lua
  (163, 1, $trig$local dg = require("dg")
wait(0.2)

local wand_quest = (globals.type or "type") .. "_wand"
local wandstep = globals.wandstep
if wandstep and actor:get_quest_stage(wand_quest) == wandstep then
    local minlevel = (wandstep - 1) * 10
    if actor.level >= minlevel then
        if (actor:get_quest_var(wand_quest .. ":greet") or 0) == 0 then
            actor:send(tostring(self.name) .. " says, 'I see you're crafting something.  If you want my help, we can talk about <b:cyan>[upgrades]</>.'")
        elseif dg.flag(actor:get_quest_var(wand_quest .. ":wandtask1"))
            and dg.flag(actor:get_quest_var(wand_quest .. ":wandtask2"))
            and dg.flag(actor:get_quest_var(wand_quest .. ":wandtask3")) then
            actor:send(tostring(self.name) .. " says, 'Oh good, you're all set!  Let me see the staff.'")
        else
            actor:send(tostring(self.name) .. " says, 'Do you have what I need for the " .. tostring(globals.weapon) .. "?'")
        end
    end
end

-- TODO(parity): legacy DG had a race switch ("ADD NEW RESTRICTED RACES HERE")
-- that halted on disallowed races before the class check below.

if (string.find(actor.class, "warrior") and (actor.level >= 10 and actor.level <= 25))
    or (string.find(actor.class, "cleric") and (actor.level >= 10 and actor.level <= 35)) then
    if actor:get_quest_stage("ran_dru_subclass") == 0 then
        self:emote("grins casually.")
        actor:send(tostring(self.name) .. " says, 'Some know the ways of the woods, others are ignorant.  Do you know the <b:cyan>ways</> or not?'")
        self:emote("puts a more serious look on his face.")
    elseif actor:get_quest_stage("ran_dru_subclass") == 4 and not actor:get_has_completed("ran_dru_subclass") then
        actor:send(tostring(self.name) .. " says, 'Have you the jewel of the heart?'")
    end
end$trig$, 'e80b86169f791bc69923ec70a70e714e'),
  -- data/triggers/163/163_10_eleweiss_refuse.lua
  (163, 10, $trig$local dg = require("dg")
if dg.gone(object) then return true end  -- an earlier receive trigger already took it
if object.zone_id == 172 and object.id == 12 then
    return true
end
if dg.quest_item(object, globals) then
    return true
end
dg.give(self, object, actor)
wait(0.2)
actor:send(tostring(self.name) .. " says, 'What is this?'")
wait(0.3)
actor:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
wait(0.2)
actor:send(tostring(self.name) .. " says, 'I have no need of " .. tostring(object.shortdesc) .. ".'")
return true$trig$, 'bdf9726f6fd898f0c12590ed1a0f52f1'),
  -- data/triggers/178/178_03_shaman_greet1.lua
  (178, 3, $trig$if string.find(actor.race, "troll") then
    self:destroy_item("red-dye")
    self.room:spawn_object(370, 81)
end
local wand_quest = (globals.type or "type") .. "_wand"
local wandstep = globals.wandstep or 0
local minlevel = (wandstep - 1) * 10
wait(0.2)
if globals.wandstep and actor:get_quest_stage(wand_quest) == wandstep and actor.level >= minlevel then
    if (actor:get_quest_var(wand_quest .. ":greet") or 0) == 0 then
        self.room:send(tostring(self.name) .. " says, 'I see you're crafting something.  If you want my help, we can talk about <b:cyan>[upgrades]</>.'")
    else
        self:say("Do you have what I need?")
    end
else
    self:say("Have you come to face your greatest fear?")
end$trig$, 'f3a5bf4dee7f808500a37c99c1bd6aa1'),
  -- data/triggers/185/185_01_silania_welcome.lua
  (185, 1, $trig$local dg = require("dg")

wait(2)

local pp_stage = actor:get_quest_stage("pri_pal_subclass")
if pp_stage == 1 then
    actor:send(tostring(self.name) .. " says, 'You've returned!  Let's talk about your <b:cyan>quest</>.'")
elseif pp_stage == 2 or pp_stage == 3 then
    actor:send(tostring(self.name) .. " says, 'Have you returned with the bronze chalice the diabolists stole?'")
end

local classgreet = "no"
local maxlevel = 0
if pp_stage >= 1 and pp_stage <= 3 then
    -- already on the subclass quest: no recruiting patter
elseif string.find(actor.class, "warrior") then
    if actor.race ~= "drow" and actor.race ~= "faerie_unseelie" then
        classgreet = "yes"
        maxlevel = 25
    end
elseif string.find(actor.class, "cleric") then
    if actor.race ~= "drow" and actor.race ~= "faerie_unseelie" then
        classgreet = "yes"
        maxlevel = 35
    end
end

if classgreet == "yes" and actor.level >= 10 and actor.level <= maxlevel then
    actor:send(tostring(self.name) .. " says, 'Some know not of their <b:cyan>destinies</>, others simply choose to ignore them.  Which of the two are you?'")
    wait(2)
    self:command("ponder " .. tostring(actor.name))
end

local wand_quest = (globals.type or "type") .. "_wand"
if globals.wandstep and actor:get_quest_stage(wand_quest) == globals.wandstep then
    local minlevel = (globals.wandstep - 1) * 10
    if actor.level >= minlevel then
        if (actor:get_quest_var(wand_quest .. ":greet") or 0) == 0 then
            actor:send(tostring(self.name) .. " says, 'I see you're crafting something.  If you want my help, we can talk about <b:cyan>[upgrades]</>.'")
        elseif dg.flag(actor:get_quest_var(wand_quest .. ":wandtask1"))
            and dg.flag(actor:get_quest_var(wand_quest .. ":wandtask2"))
            and dg.flag(actor:get_quest_var(wand_quest .. ":wandtask3")) then
            actor:send(tostring(self.name) .. " says, 'Oh good, you're all set!  Let me see the staff.'")
        else
            actor:send(tostring(self.name) .. " says, 'Do you have what I need for the " .. tostring(globals.weapon) .. "?'")
        end
    end
end
if globals.macestep and actor:get_quest_stage("phase_mace") == globals.macestep then
    local minlevel = globals.macestep * 10
    if actor.level >= minlevel then
        if (actor:get_quest_var("phase_mace:greet") or 0) == 0 then
            actor:send(tostring(self.name) .. " says, 'I sense a ghostly presence about your weapons.  If you want my help, we can talk about <b:cyan>[upgrades]</>.'")
        else
            actor:send(tostring(self.name) .. " says, 'Do you have what I need?'")
        end
    end
end$trig$, 'e5ef54532483f81672131a23ad6d2f1b'),
  -- data/triggers/185/185_29_sexton_refuse.lua
  (185, 29, $trig$local dg = require("dg")
if dg.gone(object) then return true end  -- an earlier receive trigger already took it
if dg.quest_item(object, globals) then
    return true
end
dg.give(self, object, actor)
actor:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
wait(0.2)
actor:send(tostring(self.name) .. " says, 'I'm sorry, what is this for?'")
return true$trig$, '83d14e6ebf8cb086048fa6f166bbc5ef'),
  -- data/triggers/185/185_31_silania_refuse.lua
  (185, 31, $trig$local dg = require("dg")
if dg.gone(object) then return true end  -- an earlier receive trigger already took it
if object.zone_id == 185 and object.id == 12 then
    return true
end
if dg.quest_item(object, globals) then
    return true
end
dg.give(self, object, actor)
actor:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
wait(0.2)
actor:send(tostring(self.name) .. " says, 'What is this for?'")
return true$trig$, '407b0eb4060653d1836049822f440a1d'),
  -- data/triggers/238/238_08_mage_receive_refuse.lua
  (238, 8, $trig$local dg = require("dg")
if dg.gone(object) then return true end  -- an earlier receive trigger already took it
if object.zone_id == 238 and object.id == 22 then
    return true
end
if dg.quest_item(object, globals) then
    return true
end
dg.give(self, object, actor)
self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
wait(0.2)
actor:send(tostring(self.name) .. " says, 'What is this for?'")
return true$trig$, '8e23e3607b205cb55a629000c2037b70'),
  -- data/triggers/238/238_10_mage_greet.lua
  (238, 10, $trig$wait(0.2)
local wand_quest = (globals.type or "type") .. "_wand"
if globals.wandstep and actor:get_quest_stage(wand_quest) == globals.wandstep then
    local minlevel = (globals.wandstep - 1) * 10
    if actor.level >= minlevel then
        if (actor:get_quest_var(wand_quest .. ":greet") or 0) == 0 then
            self.room:send(tostring(self.name) .. " says, 'I see you're crafting something.  If you want my help, we can talk about <b:cyan>[upgrades]</>.'")
        else
            self:say("Do you have what I need for the " .. tostring(globals.weapon) .. "?")
        end
    end
end

-- Only greet people wearing the Sunfire crest (object 237:16)
if actor:has_equipped(237, 16) then
    wait(2)
    self:command("blink")
    wait(2)
    self:command("bow " .. tostring(actor.name))
    wait(1)
    self:say("Far be it from me to ask how you got that crest...  But it appears you have done a service for one of my kin.")
    wait(2)
    self:say("Perhaps you can help me also in solving a riddle.")
end$trig$, 'bbd4eeca22f84649de9dafaf93d29f1f'),
  -- data/triggers/481/481_149_mccabe_refuse.lua
  (481, 149, $trig$local dg = require("dg")
if dg.gone(object) then return true end  -- an earlier receive trigger already took it
if (object.zone_id == 481 and object.id == 152) or (object.zone_id == 481 and object.id == 151) then
    return true
end
if dg.quest_item(object, globals) then
    return true
end
dg.give(self, object, actor)
self:command("eye")
wait(1)
actor:send(tostring(self.name) .. " tells you, 'And what exactly am I supposed to do with this?'")
return true$trig$, '63a67fca3e8d51e4dd3474a2267e8eba'),
  -- data/triggers/481/481_153_mccabe_greet.lua
  (481, 153, $trig$-- Converted from DG Script #48253: mccabe greet
-- Original: MOB trigger, flags: GREET, probability: 100%
local stage = actor:get_quest_stage("meteorswarm")
wait(1)
-- No one should be here but sorcs and pyros, so let's throw the rest back out
-- DG %type%_wand: the questmaster's LOAD trigger (002_111) stores the element in globals.type
local wand_quest = (globals.type or "type") .. "_wand"
if actor.class ~= "sorcerer" and actor.class ~= "pyromancer" and actor:get_quest_stage(wand_quest) < (globals.wandstep or 999) then
    self:command("con " .. tostring(actor.name))
    wait(2)
    self:say("What are you doing here?! Get out!")
    wait(1)
    self.room:send_except(actor, "<b:blue>" .. tostring(self.name) .. " </><cyan> sends a blast of air at <b:black>" .. tostring(actor.name) .. "<cyan> sending them<blue> tumbling!</>")
    actor:send("<b:blue>" .. tostring(self.name) .. " </><cyan> sends a blast of air at <b:red>YOU<cyan> sending you<blue> tumbling!</>")
    actor:teleport(get_room(481, 154))
    actor:send("<b:blue>" .. tostring(self.name) .. "'s </><cyan>blast of air sends you<blue> tumbling!</>")
    actor:teleport(get_room(481, 153))
    actor:send("<b:blue>" .. tostring(self.name) .. "'s </><cyan>blast of air sends you<blue> tumbling!</>")
    actor:teleport(get_room(481, 152))
    actor:send("<b:blue>" .. tostring(self.name) .. "'s </><cyan>blast of air comes at you from a new angle, sending you<blue> tumbling!</>")
    actor:teleport(get_room(481, 151))
    local damage = (actor.level * 2) + random(1, 30)
    local damage_dealt = actor:damage(damage)  -- type: fire
    actor:send("<b:red>You sustain </><red>severe burns<blue> as you plunge head first through drizzling </><red>lava.</> (<b:red>" .. tostring(damage_dealt) .. "</>)")
elseif (string.find(actor.class, "sorcerer") and actor.level > 72) or (string.find(actor.class, "pyromancer") and actor.level > 80) or actor:get_quest_stage(wand_quest) == globals.wandstep then
    local minlevel = ((globals.wandstep or 1) - 1) * 10
    if (string.find(actor.class, "sorcerer") and actor.level > 72) or (string.find(actor.class, "pyromancer") and actor.level > 80) then
        if string.find(tostring(actor:get_quest_var("meteorswarm:new") or ""), "no", 1, true) then
            actor:send(tostring(self.name) .. " tells you, 'Do you have the new meteorite?'")
        elseif (stage or 0) == 0 then
            self.room:spawn_mobile(481, 151)
            self:command("peer seagull")
            self:emote("focuses closely on the seagull flying overhead.")
            self.room:send(tostring(self.name) .. " starts casting '<b:yellow>meteorswarm</>' at an unsuspecting seagull.")
            wait(1)
            run_room_trigger(481, 157)
            self.room:find_actor("seagull"):command("panic")
            self.room:find_actor("seagull"):emote("panics and flees to the north.")
            world.destroy(self.room:find_actor("seagull"))
            wait(2)
            self:command("giggle")
            wait(5)
            actor:send(tostring(self.name) .. " tells you, 'I see you admire my conjuring.  Perhaps you've never seen anyone calling <b:cyan>meteors</>?'")
        elseif stage == 1 then
            actor:send(tostring(self.name) .. " tells you, 'Have you spoken to Jemnon?  He's in some tavern, no doubt, waiting for some new blunder to embark on.'")
        elseif stage == 2 then
            actor:send(tostring(self.name) .. " tells you, 'Well, did Jemnon tell you where the rock demon is?'")
        elseif stage == 3 then
            actor:send(tostring(self.name) .. " tells you, 'Have you found a suitable focus?'")
        elseif stage == 4 then
            actor:send(tostring(self.name) .. " tells you, 'I can see from the singe marks you accomplished your task!  Are you ready to press on?'")
        elseif stage == 5 then
            actor:send(tostring(self.name) .. " tells you, 'Were you able to glean something from Dargentan's teachings?'")
        end
        if actor:get_quest_stage(wand_quest) == globals.wandstep then
            if actor.level >= minlevel then
                if (actor:get_quest_var(wand_quest .. ":greet") or 0) == 0 then
                    actor:send(tostring(self.name) .. " tells you, 'Or is there even MORE you want from me?  You seem to be in need of a crafting <b:cyan>[upgrade]</>.'")
                else
                    actor:send(tostring(self.name) .. " says, 'Do you have what I need for the " .. tostring(globals.weapon) .. "?'")
                end
            end
        end
    else
        if actor.level >= minlevel then
            if (actor:get_quest_var(wand_quest .. ":greet") or 0) == 0 then
                actor:send(tostring(self.name) .. " tells you, 'I see you're crafting something.  If you want my help, we can talk about <b:cyan>[upgrades]</>.'")
            else
                actor:send(tostring(self.name) .. " tells you, 'Do you have what I need for the " .. tostring(globals.weapon) .. "?'")
            end
        end
    end
end$trig$, 'c3f7e5b6a04679aae30c49ad5da07d81'),
  -- data/triggers/484/484_01_oracle-sun-greet.lua
  (484, 1, $trig$-- Converted from DG Script #48401: oracle-sun-greet
-- Original: MOB trigger, flags: GREET_ALL, probability: 100%
-- The Oracle is the fire wand's step 9 crafter and the mace's step 8 priest: `wandstep`, `type`,
-- `macestep` come from the LOAD triggers 002_111 / 002_118 through `globals`.
wait(0.2)
local wand_quest = (globals.type or "type") .. "_wand"
local wandstep = globals.wandstep
local macestep = globals.macestep
local minlevel = 0
if wandstep then
    minlevel = (wandstep - 1) * 10
elseif macestep then
    minlevel = macestep * 10
end
local on_wand = wandstep ~= nil and actor:get_quest_stage(wand_quest) == wandstep
local on_mace = macestep ~= nil and actor:get_quest_stage("phase_mace") == macestep
if on_wand and actor:get_quest_stage("doom_entrance") ~= 5 and actor:get_quest_stage("doom_entrance") ~= 6 and not actor:get_has_completed("doom_entrance") then
    if actor.level >= minlevel then
        if (actor:get_quest_var(wand_quest .. ":greet") or 0) == 0 then
            actor:send(tostring(self.name) .. " says, 'Timun, God of the Sun, sees you are progressing toward divine fire.  Tell us what you are working on.'")
        else
            actor:send(tostring(self.name) .. " says, 'Do you have what I require to craft your staff?'")
        end
    end
elseif on_mace and actor:get_quest_stage("doom_entrance") ~= 5 and actor:get_quest_stage("doom_entrance") ~= 6 and not actor:get_has_completed("doom_entrance") then
    if actor.level >= minlevel then
        if (actor:get_quest_var("phase_mace:greet") or 0) == 0 then
            actor:send(tostring(self.name) .. " says, 'I sense a ghostly presence about your weapons.  If you want my help, we can talk about <b:cyan>[upgrades]</>.'")
        else
            actor:send(tostring(self.name) .. " says, 'Do you have what I need?'")
        end
    end
elseif actor:get_quest_stage("doom_entrance") == 5 then
    self:command("bow " .. tostring(actor.name))
    wait(1)
    actor:send(tostring(self.name) .. " says, 'At last, one has come to challenge the wrath of the God of the Moonless Night.'")
    wait(1)
    actor:send(tostring(self.name) .. " says, 'You shall need Timun's Light if you are to defeat Lokari, " .. tostring(actor.name) .. ".'")
    self.room:spawn_object(484, 31)
    self:command("give vial " .. tostring(actor.name))
    wait(1)
    actor:send(tostring(self.name) .. " says, 'You must take this vial to a place steeped in darkness.  You shall know it by the false light shed there and the mockery of the sun it proclaims.'")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'Then drop it on the ground and fill the place with holy light!  Once you have completed this task, return to me and I shall inform the Keeper of the Keys that you are indeed worthy.'")
    wait(4)
    if on_wand then
        if actor.level >= minlevel then
            if (actor:get_quest_var(wand_quest .. ":greet") or 0) == 0 then
                actor:send(tostring(self.name) .. " says, 'Additionally Timun, God of the Sun, sees you are progressing toward divine fire.  Tell us what you are working on.'")
                wait(1)
            else
                actor:send(tostring(self.name) .. " says, 'Do you have what I require to craft your staff?'")
                wait(1)
            end
        end
    elseif on_mace then
        if actor.level >= minlevel then
            if (actor:get_quest_var("phase_mace:greet") or 0) == 0 then
                actor:send(tostring(self.name) .. " says, 'Timun sees you also seek His lambent blessing to repel the forces of the dead.  Tell us what you are working on.'")
                wait(1)
            else
                actor:send(tostring(self.name) .. " says, 'Do you have what I require to bless your mace?'")
                wait(1)
            end
        end
    end
    actor:send("With those words, the Oracle bows his head and refuses to utter another word.")
elseif actor:get_quest_stage("doom_entrance") == 6 then
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
            if person:get_quest_stage("doom_entrance") == 6 then
                person:send(tostring(self.name) .. " says, 'You have done well, " .. tostring(person.name) .. ". Your task is completed.'")
                wait(1)
                person:send(tostring(self.name) .. " says, 'May the light of the Sun find you even in the depths of Severan's Doom.'")
                person:complete_quest("doom_entrance")
                wait(1)
                person:send(tostring(self.name) .. " says, 'Do not forget to show the Keeper of the Keys that you have finished!'")
            end
        elseif person then
            i = i + 1
        end
        a = a + 1
    end
    self.room:spawn_object(484, 21)
    self:command("give key " .. tostring(actor.name))
    if on_wand then
        if actor.level >= minlevel then
            wait(3)
            if (actor:get_quest_var(wand_quest .. ":greet") or 0) == 0 then
                actor:send(tostring(self.name) .. " says, 'Additionally Timun, God of the Sun, sees you are progressing toward divine fire.  Tell us what you are working on.'")
                wait(1)
            else
                actor:send(tostring(self.name) .. " says, 'Do you have what I require to craft your staff?'")
                wait(1)
            end
        end
    elseif on_mace then
        if actor.level >= minlevel then
            if (actor:get_quest_var("phase_mace:greet") or 0) == 0 then
                actor:send(tostring(self.name) .. " says, 'Timun sees you also seek His lambent blessing to repel the forces of the dead.  Tell us what you are working on.'")
                wait(1)
            else
                actor:send(tostring(self.name) .. " says, 'Do you have what I require to bless your mace?'")
                wait(1)
            end
        end
    end
elseif actor:get_has_completed("doom_entrance") then
    actor:send("As you enter the chamber " .. tostring(self.name) .. " greets you warmly.")
    self.room:send_except(actor, tostring(self.name) .. " greets " .. tostring(actor.name) .. " warmly.")
    wait(1)
    actor:send(tostring(self.name) .. " says, 'Heroes, the day of Prophecy has arrived.  Know that in a nearby chamber is a Gateway to another Realm.  From that Realm, you will have access to others; and it is in one of these other Realms that you will find the way to Lokari's Domain.'")
    wait(1)
    actor:send(tostring(self.name) .. " says, 'Collect the three godly keys to the Domain, which were scattered by the gods upon the Champion's death, and slay the mad god for his crimes.'")
    wait(1)
    actor:send(tostring(self.name) .. " says, 'Go now, the Universe awaits!'")
    wait(1)
    if on_wand then
        if actor.level >= minlevel then
            if (actor:get_quest_var(wand_quest .. ":greet") or 0) == 0 then
                actor:send(tostring(self.name) .. " says, 'Additionally Timun, God of the Sun, sees you are progressing toward divine fire.  Tell us what you are working on.'")
                wait(1)
            else
                actor:send(tostring(self.name) .. " says, 'Do you have what I require to craft your staff?'")
                wait(1)
            end
        elseif on_mace then
            if actor.level >= minlevel then
                if (actor:get_quest_var("phase_mace:greet") or 0) == 0 then
                    actor:send(tostring(self.name) .. " says, 'Timun sees you also seek His lambent blessing to repel the forces of the dead.  Tell us what you are working on.'")
                    wait(1)
                else
                    actor:send(tostring(self.name) .. " says, 'Do you have what I require to bless your mace?'")
                    wait(1)
                end
            end
        end
    end
    actor:send("With those words, the Oracle bows his head and refuses to utter another word.")
end$trig$, '8163855fac13de61fe10c756f62faf3f'),
  -- data/triggers/484/484_27_oracle_sun_refuse.lua
  (484, 27, $trig$local dg = require("dg")
if dg.gone(object) then return true end  -- an earlier receive trigger already took it
if dg.quest_item(object, globals) then
    return true
end
dg.give(self, object, actor)
self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
wait(0.2)
actor:send(tostring(self.name) .. " says, 'I have no need of this.'")
return true$trig$, '92e55889d11a8d3424bac8618d7a7241'),
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
    dg.give(self, object, actor)
    self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
    wait(0.2)
    actor:send(tostring(self.name) .. " says, '" .. tostring(response) .. "'")
    if action then
        self:command(action)
    end
end
return _return_value$trig$, '5c30674e93eb2faf4d994a3884f486cf'),
  -- data/triggers/533/533_08_wall_ice_sculptor_greet.lua
  (533, 8, $trig$wait(1)
local wand_quest = (globals.type or "type") .. "_wand"
if globals.wandstep and actor:get_quest_stage(wand_quest) == globals.wandstep then
    local minlevel = (globals.wandstep - 1) * 10
    if actor.level >= minlevel then
        if (actor:get_quest_var(wand_quest .. ":greet") or 0) == 0 then
            self.room:send(tostring(self.name) .. " says, 'I see you're crafting something.  If you want my help, we can talk about <b:cyan>[upgrades]</>.'")
            actor:set_quest_var(wand_quest, "greet", 1)
        else
            self:say("Do you have what I need for the wand?")
        end
        wait(1)
    end
end
local stage = actor:get_quest_stage("wall_ice")
if stage == 0 then
    if actor.class and string.find(actor.class, "cryomancer") and actor.level > 56 then
        self:command("wave")
        self:say("Hey, you there, you look like a capable cryomancer!  Lend me a hand with this wall, will ya?")
        wait(2)
        self:say("We had a few nasty surprises with creatures slipping out from Frost Valley.  So Suralla sent me over to reinforce the wall blocking off the tunnel.")
        wait(2)
        self:say("I ran out of supplies and my spells can't make permanent walls.  Can you help me get more ice for the wall?")
    end
elseif stage == 1 then
    local ice = 20 - (tonumber(actor:get_quest_var("wall_ice:blocks")) or 0)
    if ice > 1 then
        self:say("Do you have the " .. tostring(ice) .. " remaining blocks of ice?")
    elseif ice == 1 then
        self:say("Do you have the last remaining block of ice?")
    end
end$trig$, 'f3aab21ccf313a6fa62af400aca17b0d'),
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

dg.give(self, object, actor)
self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
wait(0.2)
self:say(response)
return true$trig$, '08af9705b55758311f947eb5159129e7'),
  -- data/triggers/550/550_00_quest_cryo_greet.lua
  (550, 0, $trig$-- Converted from DG Script #55000: quest_cryo_greet
-- Original: MOB trigger, flags: SPEECH, GREET, probability: 100%

-- DG word list (num_arg 100): a SPEECH must contain one of these as a whole word or phrase; the
-- greet part of the trigger (GREET, no speech) is not gated.
if event == "SPEECH" or event == "SPEECH_TO" then
    local speech_padded = " " .. string.lower(speech) .. " "
    local speech_hit = false
    for _, w in ipairs({"hi", "hello"}) do
        if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
            speech_hit = true
            break
        end
    end
    if not speech_hit then
        return true  -- None of the listed words
    end
end
wait(0.2)
local dg = require("dg")
local wand_quest = (globals.type or "type") .. "_wand"
if globals.wandstep and actor:get_quest_stage(wand_quest) == globals.wandstep then
    local minlevel = (globals.wandstep - 1) * 10
    if actor.level >= minlevel then
        if (actor:get_quest_var(wand_quest .. ":greet") or 0) == 0 then
            actor:send(tostring(self.name) .. " says, 'I see you're crafting something.  If you want my help, we can talk about <b:cyan>[upgrades]</>.'")
        elseif dg.flag(actor:get_quest_var(wand_quest .. ":wandtask1"))
            and dg.flag(actor:get_quest_var(wand_quest .. ":wandtask2"))
            and dg.flag(actor:get_quest_var(wand_quest .. ":wandtask3")) then
            actor:send(tostring(self.name) .. " says, 'I sense you're ready!  Let me see the staff.'")
        else
            actor:send(tostring(self.name) .. " says, 'Do you have what I need for the " .. tostring(globals.weapon) .. "?'")
        end
    end
end
-- switch on actor:get_quest_stage("subclass")
if actor:get_quest_stage("subclass") == 1 then
    actor:send(tostring(self.name) .. " says, 'Welcome back.'")
    wait(0.2)
    actor:send(tostring(self.name) .. " says, 'It will take a great mage with a dedication to the cold arts to complete the <b:cyan>quest</> I lay before you.  Your reward is simple if you succeed, and I am sure you will enjoy a life of the cold.'")
elseif actor:get_quest_stage("subclass") == 2 then
    actor:send(tostring(self.name) .. " says, 'I see you return.'")
    wait(0.2)
    actor:send(tostring(self.name) .. " says, 'Recall, what Emmath and I battled over may still be <b:cyan>suffering</>.'")
elseif actor:get_quest_stage("subclass") == 3 then
    actor:send(tostring(self.name) .. " says, 'Why have you returned already?  The shrub still suffers!'")
elseif actor:get_quest_stage("subclass") == 4 then
    actor:send(tostring(self.name) .. " says, 'Does the shrub still suffer?'")
else
    if string.find(string.lower(actor.class), "sorcerer") then
        if actor.race == "dragonborn_fire" or actor.race == "arborean" then
            return true
        end
        if actor.level >= 10 and actor.level <= 45 then
            self:command("grin " .. tostring(actor.name))
            actor:send(tostring(self.name) .. " says, 'Greetings " .. tostring(actor.name) .. ", have you come to me for a specific <b:cyan>reason</>?'")
            self:command("eye " .. tostring(actor.name))
        elseif actor.level < 10 then
            self:command("grin " .. tostring(actor.name))
            actor:send(tostring(self.name) .. " says, 'Greetings " .. tostring(actor.name) .. ".  I fear we are meeting before you are ready.  Gain some more experience, then seek me out again.'")
            wait(2)
            actor:send(tostring(self.name) .. " says, 'I look forward to our next encounter.'")
        end
    end
end$trig$, '49201f319c1dd9dd06bf72f986c23e8c'),
  -- data/triggers/550/550_01_tech_master_shaman_1.lua
  (550, 1, $trig$-- Converted from DG Script #55001: Tech_Master_Shaman_1
-- Original: MOB trigger, flags: GREET_ALL, probability: 100%
-- Add Kourrya 6-06, loading for the Minithawkin troll mask quest
if string.find(string.lower(actor.race), "troll") then
    self:destroy_item("mangrove-branch")
    self.room:spawn_object(370, 80)
end
wait(0.2)
-- 
-- for Wizard Eye
-- 
local dg = require("dg")
local wand_quest = (globals.type or "type") .. "_wand"
local actor_class_lower = string.lower(actor.class)
if ((string.find(actor_class_lower, "sorcerer") or string.find(actor_class_lower, "illusionist")) and actor.level > 80) or actor:get_quest_stage(wand_quest) == 5 then
    if (string.find(actor_class_lower, "sorcerer") or string.find(actor_class_lower, "illusionist")) and actor.level > 80 then
        local stage = actor:get_quest_stage("wizard_eye")
        do
            local _sw1 = string.lower(tostring(stage or ""))
            if tonumber(_sw1) == 1 then
                actor:send(tostring(self.name) .. " tells you, 'You best seek out the gypsy witch.  Without her advice, I cannot help you further.'")
            elseif tonumber(_sw1) == 2 then
                actor:send(tostring(self.name) .. " tells you, 'Have you brought what the witch suggested?'")
            elseif tonumber(_sw1) == 3 or tonumber(_sw1) == 4 then
                actor:send(tostring(self.name) .. " tells you, 'How is the Seer in her cave on Griffin Isle?  I have not seen her for many years!'")
            elseif tonumber(_sw1) == 5 then
                actor:send(tostring(self.name) .. " tells you, 'Have you brought what the Seer suggested?'")
            elseif tonumber(_sw1) == 6 or tonumber(_sw1) == 7 then
                actor:send(tostring(self.name) .. " tells you, 'Before you return to me, speak with the Green Woman in Anduin.  She has learned a great many things from her post behind the counter.'")
            elseif tonumber(_sw1) == 8 then
                actor:send(tostring(self.name) .. " tells you, 'Have you brought what the Green Woman suggested?'")
            elseif tonumber(_sw1) == 9 or tonumber(_sw1) == 10 then
                actor:send(tostring(self.name) .. " tells you, 'The orbs are far too dangerous to bring back here without consulting the Oracle of Justice!'")
                if actor:has_item(30, 218) or actor:has_item(534, 24) or actor:has_item(430, 21) or actor:has_item(40, 3)
                   or actor:has_equipped(30, 218) or actor:has_equipped(534, 24) or actor:has_equipped(430, 21) or actor:has_equipped(40, 3) then
                    actor:send(tostring(self.name) .. " tells you, 'Leave my chamber before these orbs corrupt it!'")
                    actor:send(tostring(self.name) .. " shoves you back out into the hallway!")
                    self.room:send_except(actor, tostring(self.name) .. " shoves " .. tostring(actor.name) .. " back out into the hallway!")
                    actor:teleport(get_room(550, 73))
                    actor:command("look")
                end
            elseif tonumber(_sw1) == 11 then
                actor:send(tostring(self.name) .. " tells you, 'I see you have returned enlightened!  Let me see the crystal ball and I shall make the preparations.'")
            elseif tonumber(_sw1) == 12 then
                actor:send(tostring(self.name) .. " tells you, 'Come, <b:cyan>sleep</>, let your dreams impart mastery of divination to you.'")
            else
                if not actor:get_has_completed("wizard_eye") then
                    actor:send(tostring(self.name) .. " tells you, 'You are more powerful than most visitors.  Have you come to see as the Great Snow Leopard does?'")
                end
            end
        end
        if actor:get_quest_stage(wand_quest) == 5 then
            if (actor:get_quest_var(wand_quest .. ":greet") or 0) == 0 then
                self:command("peer " .. tostring(actor.name))
                wait(1)
                actor:send(tostring(self.name) .. " tells you, 'Or perhaps you come about a crafting <b:cyan>[upgrade]</>...'")
            else
                actor:send(tostring(self.name) .. " tells you, 'Or have you brought the necessary components for the wand?'")
            end
        end
    end
    -- 
    -- for phase wands
    -- 
    if actor:get_quest_stage(wand_quest) == 5 then
        local job1 = dg.flag(actor:get_quest_var(wand_quest .. ":wandtask1"))
        local job2 = dg.flag(actor:get_quest_var(wand_quest .. ":wandtask2"))
        local job3 = dg.flag(actor:get_quest_var(wand_quest .. ":wandtask3"))
        local job4 = dg.flag(actor:get_quest_var(wand_quest .. ":wandtask4"))
        if actor.level >= 40 then
            if (actor:get_quest_var(wand_quest .. ":greet") or 0) == 0 then
                actor:send(tostring(self.name) .. " tells you, 'I see you're crafting something.  If you come for the Great Snow Leopard's help, let's discuss an <b:cyan>[upgrade]</>.'")
            elseif actor:get_quest_stage(wand_quest) == 5 and job1 and job2 and job3 and job4 then
                actor:send(tostring(self.name) .. " tells you, 'It looks like the wand is ready for upgrading!  Please give it to me.'")
            else
                actor:send(tostring(self.name) .. " tells you, 'Do you have what I need for the wand?'")
            end
        end
    end
    -- 
    -- This is the original greet trig for the shaman quest
    -- 
else
    actor:send(tostring(self.name) .. " raises an eyebrow.")
    actor:send(tostring(self.name) .. " mutters something about people disturbing her while she considers what to do about what's missing.")
    actor:send(tostring(self.name) .. " grumbles incoherently about something or other.")
end$trig$, 'fa516620f48a73777987893d19558a3f'),
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
dg.give(self, object, actor)
self:command("eye " .. tostring(actor.name))
actor:send(tostring(self.name) .. " says, '" .. response .. "'")
self.room:send(tostring(self.name) .. " refuses " .. desc .. ".")
return true$trig$, '39f6268c1b7541fb5ccae519b03611dc'),
  -- data/triggers/550/550_34_wizard_eye_seer_greet.lua
  (550, 34, $trig$-- Converted from DG Script #55034: wizard_eye_seer_greet
-- Original: MOB trigger, flags: GREET, probability: 100%
wait(0.2)
local wand_quest = (globals.type or "type") .. "_wand"
local wandstep = globals.wandstep
local minlevel = ((wandstep or 1) - 1) * 10
local on_wand = wandstep ~= nil and actor:get_quest_stage(wand_quest) == wandstep and actor.level >= minlevel
local greeted = (actor:get_quest_var(wand_quest .. ":greet") or 0) ~= 0
if actor:get_quest_stage("wizard_eye") == 3 then
    actor:send(tostring(self.name) .. " says, 'I had a feeling you would show up soon.  The shaman from Technitzitlan has sent you to me, yes?'")
    if on_wand then
        wait(1)
        if not greeted then
            actor:send(tostring(self.name) .. " says, 'Or is there some other reason you're here?'")
        else
            actor:send(tostring(self.name) .. " says, 'Do you have what I need for the staff?'")
        end
    end
elseif actor:get_quest_stage("wizard_eye") == 4 then
    actor:send(tostring(self.name) .. " says, 'Do you have the herbs?'")
    if on_wand then
        wait(1)
        if not greeted then
            actor:send(tostring(self.name) .. " says, 'Or is there some other reason you're here?'")
        else
            actor:send(tostring(self.name) .. " says, 'And do you have what I need for the staff?'")
        end
    end
elseif on_wand then
    if not greeted then
        actor:send(tostring(self.name) .. " says, 'I've been expecting you!  Tell me, what brings you to me?'")
    else
        actor:send(tostring(self.name) .. " says, 'Do you have what I need for the staff?'")
    end
end$trig$, 'c690dadf4ba8fa1e733149ac606f5c22'),
  -- data/triggers/625/625_05_treant_refuse.lua
  (625, 5, $trig$-- Converted from DG Script #62505: Treant refuse
-- Original: MOB trigger, flags: RECEIVE, probability: 0%
--
-- The wand-quest items (wandgem, wand_id, wandtask3, exported through `globals` by 002_111) fall
-- through to 002_108.
-- DG receive trigger, num_arg 0: the arg list (62504) holds the items
-- other triggers handle; this one runs for every other item. The runtime does not filter on
-- arg_list, so the exclusion lives here. (The converter's percent_chance(0) guard blocked it all.)
local dg = require("dg")
if dg.gone(object) then return true end  -- an earlier receive trigger already took it
if (object.zone_id == 625 and object.id == 4) then
    return true
end
if dg.quest_item(object, globals) then
    return true
end
wait(1)
self:command("grumble")
self:command("drop " .. tostring(object.alias))$trig$, '1c03caa361c582e682ef2ba2c71ae84d')
) AS v(zone_id, id, commands, old_md5)
WHERE t.zone_id = v.zone_id
  AND t.id = v.id
  AND md5(t.commands) = v.old_md5
  AND t.commands IS DISTINCT FROM v.commands;

COMMIT;
