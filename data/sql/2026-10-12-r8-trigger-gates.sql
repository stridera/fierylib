-- Playtest r8: percent_chance gates that were DG word lists / bribe minimums / no-roll types, Academy lesson arg checks, Betsy Boo name lookup, corpse retrieval fee
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
  -- data/triggers/012/012_01_long_live_the_king.lua
  (12, 1, $trig$-- Converted from DG Script #1201: Long live the king
-- Original: MOB trigger, flags: SPEECH, num_arg: 1 (DG word-list mode, not a probability)

-- DG word list (num_arg 1): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"chinok"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
self:say("Long live his fame and long live his glory.")
self:emote("bows their head briefly.")$trig$, '40b97ac87cef4ade466efa73b41214ba'),
  -- data/triggers/012/012_65_lylaith.lua
  (12, 65, $trig$-- Converted from DG Script #1265: lylaith
-- Original: OBJECT trigger, flags: RANDOM, COMMAND, WEAR, num_arg: 15 (no chance roll in legacy)


-- Command filter: lylaith
if not (cmd == "lylaith") then
    return true  -- Not our command
end
self.room:send("The blade of " .. tostring(self.shortdesc) .. " flares a <b:white>bright white</>.")$trig$, 'a003197e5fc6e54e9d6d980328f612e4'),
  -- data/triggers/022/022_65_lylaith.lua
  (22, 65, $trig$-- Converted from DG Script #2265: lylaith
-- Original: OBJECT trigger, flags: WEAR, num_arg: 5 (no chance roll in legacy)

wait(2)
actor:send("As you wield " .. tostring(self.shortdesc) .. ", the blade glows a <b:white>bright white</>!")
self.room:send_except(actor, "As " .. tostring(actor.name) .. " wields " .. tostring(self.shortdesc) .. ", the blade glows a <b:white>bright white</>!")$trig$, '052ab0d615125a1b8141c45c3d6e7357'),
  -- data/triggers/022/022_74_sysmaith.lua
  (22, 74, $trig$-- Converted from DG Script #2274: sysmaith
-- Original: OBJECT trigger, flags: WEAR, num_arg: 5 (no chance roll in legacy)

wait(2)
actor:send("As you wield " .. tostring(self.shortdesc) .. ", a <b:blue>bright blue</> flame burns along the blade!")
self.room:send_except(actor, "As " .. tostring(actor.name) .. " wields " .. tostring(self.shortdesc) .. ", a <b:blue>bright blue</> flame burns along the blade!")$trig$, '838ecdeb1a8db2dabe6a76378d7819db'),
  -- data/triggers/028/028_01_waterform_wave_speech1.lua
  (28, 1, $trig$-- Speech keywords: yes / protection / how / okay
-- DG word list (num_arg 1): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"yes", "protection?", "how?", "okay"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
local speech_lower = string.lower(speech)
local speech_lower = string.lower(speech or "")
if not (string.find(speech_lower, "yes") or string.find(speech_lower, "protection")
        or string.find(speech_lower, "how") or string.find(speech_lower, "okay")) then
    return true
end
wait(2)
local stage = actor:get_quest_stage("waterform")
if stage == 0 and actor.is_player and actor.class
        and string.find(actor.class, "Cryomancer") and actor.level > 72 then
    actor:start_quest("waterform")
    self.room:send(tostring(self.name) .. " says, 'I can teach you to transform you into a raging torrent,")
    self.room:send("</>giving you the strength of the water itself!  All you need is a single piece of")
    self.room:send("</>armor made from water to wrap about you.'")
    -- 
    -- THIS. IS. A. LIE.  Yes, the quest master, a talking wave, gets the material components of its own spell wrong.
    -- 
    wait(4)
    self:say("Bring it to me and I will teach you the transformation!")
    wait(2)
    self.room:send(tostring(self.name) .. " says, 'If you forget, you can ask me for a reminder of your")
    self.room:send("</><b:white>[progress]</>.'")
elseif stage == 1 then
    self:say("Then please give it to me.")
elseif stage == 2 or stage == 3 then
    self:say("Then please give it to me.")
elseif stage == 4 then
    self:say("Splendid!  Please, keep at it!")
elseif stage == 5 then
    self:say("Splendid!  Give me the bone cup if you're done.")
elseif stage == 6 then
    self.room:send(tostring(self.name) .. " says, 'If you need, you may ask for a reminder of your")
    self.room:send("</><b:white>[progress]</>.'")
end$trig$, 'c3082a8bf10a79bb5527722ad590bd19'),
  -- data/triggers/030/030_140_freddy_random_load_doll.lua
  (30, 140, $trig$-- Converted from DG Script #3140: Freddy random load doll
-- Original: MOB trigger, flags: RANDOM, SPEECH, num_arg: 1 (word list and random chance)

-- RANDOM + SPEECH trigger (num_arg 1): a spoken word list when someone speaks (speech is the
-- text), a 1% roll on the random pulse (speech is empty).
if speech ~= "" then
    -- DG word list (num_arg 1): the speech must contain one of these as a whole word or phrase.
    local speech_padded = " " .. string.lower(speech) .. " "
    local speech_hit = false
    for _, w in ipairs({"refresh"}) do
        if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
            speech_hit = true
            break
        end
    end
    if not speech_hit then
        return true  -- None of the listed words
    end
elseif not percent_chance(1) then
    return true
end
-- Generate a random number
local p = random(1, 15)
-- If this is being triggered by an imm as a speech trig, ensure something loads
if actor and actor.level > 100 then
    p = 15
end
if p ~= 15 then
    return true
end
-- Figure out which object to load.  Better chance for lower IDs.
p = random(1, 100)
if p < 31 then
    p = 139 + random(1, 7)
elseif p < 82 then
    p = 146 + random(1, 35)
elseif p < 93 then
    p = 181 + random(1, 10)
else
    p = 191 + random(1, 7)
end
-- In case one of the randoms returned 0 somehow
if p == 139 then
    p = 140 + random(1, 58)
end
self.room:spawn_object(30, p)
-- Special handling for certain dolls:
-- Imanhotep's sarcophagus
if p == 182 then
    self.room:spawn_object(30, 199)
    get_room(11, 0):at(function()
        self:command("open sarcophagus")
    end)
    get_room(11, 0):at(function()
        self:command("put imanhotep sarcophagus")
    end)
    get_room(11, 0):at(function()
        self:command("close sarcophagus")
    end)
    -- The Chosen boxed set
elseif p == 198 then
    self.room:spawn_object(30, 175)
    self.room:spawn_object(30, 176)
    self.room:spawn_object(30, 177)
    self.room:spawn_object(30, 178)
    self.room:spawn_object(30, 179)
    get_room(11, 0):at(function()
        self:command("open boxed-set")
    end)
    get_room(11, 0):at(function()
        self:command("put chosen boxed-set")
    end)
    get_room(11, 0):at(function()
        self:command("put chosen boxed-set")
    end)
    get_room(11, 0):at(function()
        self:command("put chosen boxed-set")
    end)
    get_room(11, 0):at(function()
        self:command("put chosen boxed-set")
    end)
    get_room(11, 0):at(function()
        self:command("put chosen boxed-set")
    end)
    get_room(11, 0):at(function()
        self:command("close boxed-set")
    end)
end$trig$, 'b7f8bf7c3065de17dc9cdcca0666a1e1'),
  -- data/triggers/030/030_161_pay_for_training.lua
  (30, 161, $trig$-- Converted from DG Script #3161: pay for training
-- Original: MOB trigger, flags: BRIBE, num_arg: 1 (minimum bribe in copper)

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
return _return_value$trig$, '59b508633b5934daf35940c1a926d990'),
  -- data/triggers/030/030_166_pay_for_training.lua
  (30, 166, $trig$-- Converted from DG Script #3166: pay for training
-- Original: MOB trigger, flags: BRIBE, num_arg: 1 (minimum bribe in copper)

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
return _return_value$trig$, '43a0876c72792bdfa552eeaf0ea59d95'),
  -- data/triggers/030/030_171_shaman_pay_for_training.lua
  (30, 171, $trig$-- Converted from DG Script #3171: shaman pay for training
-- Original: MOB trigger, flags: BRIBE, num_arg: 1 (minimum bribe in copper)

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
return _return_value$trig$, 'e9f5f62931c5f0f1818455b7e62b2caf'),
  -- data/triggers/030/030_182_corpse_retrieval_price_set.lua
  (30, 182, $trig$-- Converted from DG Script #3182: corpse retrieval price set
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: corpse retrieval services yes help
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "corpse") or string.find(string.lower(speech), "retrieval") or string.find(string.lower(speech), "services") or string.find(string.lower(speech), "yes") or string.find(string.lower(speech), "help")) then
    return true  -- No matching keywords
end
if actor.is_player then
    wait(2)
    local cha = actor.real_cha
    -- make sure they have a quest record for saving variables
    if actor:get_quest_stage("corpse_retrieval") < 1 then
        actor:start_quest("corpse_retrieval")
    end
    self:say("We can certainly help you with that...")
    wait(1)
    self:say("For a price.")
    wait(1)
    self.room:send(tostring(self.name) .. " says, 'But understand, if you don't have a corpse out there, this spell")
    self.room:send("</>will fail and you won't get your money back.'")
    wait(2)
    self:command("eye " .. tostring(actor))
    -- This portion is for smooth speech indicating the effects of a player's cha and level.
    if actor.level < 10 then
        self:say("You're still a fresh-faced adventurer...")
        -- (empty room echo)
        if cha > 80 then
            self.room:send(tostring(self.name) .. " says, '... and you're a sweet kid.")
            self.room:send("</>I'll give you a good rate.'")
        elseif cha < 50 then
            self:say("... but your face is just so punchable.")
            self.room:send("</>So, this is really gonna cost ya.'")
        else
            self:say("... and we all need a little help from time to time.")
        end
    elseif actor.level < 30 then
        self:say("Be careful, things are tougher out there for you now...")
        -- (empty room echo)
        if cha > 80 then
            self.room:send(tostring(self.name) .. " says, '... but you are pretty charming.")
            self.room:send("</>I'll give you a good rate.'")
        elseif cha < 50 then
            self.room:send(tostring(self.name) .. " says, '... and you probably had it coming.")
            self.room:send("</>So, this is really gonna cost ya.'")
        else
            self:say("... but we all get into tight scrapes now then.")
        end
    elseif actor.level < 50 then
        self:say("You've seen your fair share of action...")
        if cha > 80 then
            self.room:send(tostring(self.name) .. " says, '... but you're still pretty likable.")
            self.room:send("</>I'll give you a good rate.'")
        elseif cha < 50 then
            self.room:send(tostring(self.name) .. " says, '... and you probably asked for most of it.")
            self.room:send("</>So, this is really gonna cost ya.'")
        else
            self:say("... so take more precautions.")
        end
    elseif actor.level < 70 then
        self:say("You really should know how to survive better by now...")
        -- (empty room echo)
        if cha > 80 then
            self.room:send(tostring(self.name) .. " says, '... but you're pretty likable.")
            self.room:send("</>I'll give you a good rate.'")
        elseif cha < 50 then
            self.room:send(tostring(self.name) .. " says, '... and it must be hard when people dislike you so much.")
            self.room:send("</>So, this is really gonna cost ya.'")
        else
            self:say("... so try harder in the future.")
        end
    elseif actor.level < 90 then
        self:say("Seasoned heroes like you are hard to help...")
        -- (empty room echo)
        if cha > 80 then
            self.room:send(tostring(self.name) .. " says, '... but you're very friendly.")
            self.room:send("</>I'll give you a good rate.'")
        elseif cha < 50 then
            self.room:send(tostring(self.name) .. " says, '... and plenty of people hate you.")
            self.room:send("</>So, this is really gonna cost ya.'")
        else
            self:say("... so don't rely on me too much.")
        end
    else
        self:say("Helping a legend like you is extremely difficult...")
        -- (empty room echo)
        if cha > 80 then
            self.room:send(tostring(self.name) .. " says, '... but you have a way with people.'")
            self.room:send("</>I'll give you a good rate.'")
        elseif cha < 50 then
            self.room:send(tostring(self.name) .. " says, '... and every creature in the world wants you dead.")
            self.room:send("</>So, this is really gonna cost ya.'")
        else
            self:say("... so you won't get much sympathy from me.")
        end
    end
    -- (empty room echo)
    -- Now a price is calculated
    -- DG `eval` math is integer math: every division truncates.
    local price = math.floor(actor.level * actor.level * math.floor(actor.level * 2 / 3) * (100 - math.floor(cha / 10)) / 100)
    -- now the price in copper has to be divided into coinage.
    local plat = math.floor(price / 1000)
    local gold = math.floor(price / 100) - plat * 10
    local silv = math.floor(price / 10) - plat * 100 - gold * 10
    local copp = price - plat * 1000 - gold * 100 - silv * 10
    -- now the price can be reported (legacy also printed the typed keyword here: "My fee is corpse for ...")
    self:say("My fee is " .. tostring(plat) .. " platinum, " .. tostring(gold) .. " gold, " .. tostring(silv) .. " silver, " .. tostring(copp) .. " copper.")
    -- (empty room echo)
    self:say("Just get me the money and I'll cast the appropriate spells.")
    actor:set_quest_var("corpse_retrieval", "price", price)
    actor:set_quest_var("corpse_retrieval", "actor_level", actor.level)
end$trig$, '1f28294feeb179c4e1bb5c1ec83c356a'),
  -- data/triggers/030/030_183_corpse_retrieval_payment.lua
  (30, 183, $trig$-- Converted from DG Script #3183: corpse retrieval payment
-- Original: MOB trigger, flags: BRIBE, num_arg: 1 (minimum bribe in copper)

local _return_value = true  -- Default: allow action
if actor:get_quest_var("corpse_retrieval:actor_level") == actor.level then
    if value >= actor:get_quest_var("corpse_retrieval:price") then
        actor:command("consent " .. tostring(self))
        wait(1)
        self:command("nod " .. tostring(actor.name))
        wait(1)
        self:say("That looks right.  Let's get started...")
        wait(1)
        spells.cast(self, "shift corpse", actor.name)
        self.room:send(tostring(self.name) .. " looks exhausted after casting.")
        actor:erase_quest("corpse_retrieval")
        actor:command("consent off")
    else
        self.room:send(tostring(self.name) .. " says, 'Thank you for your donation to the Bloody Red Cross, but I'm")
        self.room:send("</>afraid that's all it was.'")
        self:command("snicker " .. tostring(actor))
        -- (empty room echo)
        self:say("I don't accept installments.  It's got to be all up front.")
    end
else
    _return_value = true
    wait(1)
    self:command("consider " .. tostring(actor))
    wait(2)
    self:command("ponder")
    wait(2)
    self.room:send(tostring(self.name) .. " says, 'Something is different about you.  We have to adjust the spell")
    self.room:send("</>for your new strength.  Do you still want a corpse retrieval?'")
    actor:erase_quest("corpse_retrieval")
end
return _return_value$trig$, 'aa9f2088400bc3f6c6134d99fc227800'),
  -- data/triggers/030/030_27_quest_banter_magistrate1.lua
  (30, 27, $trig$-- Converted from DG Script #3027: quest_banter_magistrate1
-- Original: MOB trigger, flags: SPEECH, num_arg: 1 (DG word-list mode, not a probability)

-- DG word list (num_arg 1): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"quests", "quest", "assist", "help"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
wait(2)
if actor.level < 30 then
    actor:send(tostring(self.name) .. " tells you, 'There is a temple just outside the West Gate")
    actor:send("</>of town, dedicated to the Kaaz clan, the great heroes of the Rift Wars.")
    actor:send("Mystics from all around Caelia go there hoping to find some kind of special")
    actor:send("</>power.'")
    wait(1)
    actor:send(tostring(self.name) .. " tells you, 'It seems they found something.'")
else
    actor:send(tostring(self.name) .. " tells you, 'I fear that I have little time to banter, for")
    actor:send("</>as you can see, I must prepare our defenses for yet another attack.'")
end$trig$, 'e3787623c7b1736db88dc9ab453f35c1'),
  -- data/triggers/030/030_40_blob-to-pawnbroker.lua
  (30, 40, $trig$-- Converted from DG Script #3040: blob-to-pawnbroker
-- Original: MOB trigger, flags: RANDOM, SPEECH, num_arg: 1 (word list and random chance)

-- RANDOM + SPEECH trigger (num_arg 1): a spoken word list when someone speaks (speech is the
-- text), a 1% roll on the random pulse (speech is empty).
if speech ~= "" then
    -- DG word list (num_arg 1): the speech must contain one of these as a whole word or phrase.
    local speech_padded = " " .. string.lower(speech) .. " "
    local speech_hit = false
    for _, w in ipairs({"drop", "off", "the", "junk"}) do
        if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
            speech_hit = true
            break
        end
    end
    if not speech_hit then
        return true  -- None of the listed words
    end
elseif not percent_chance(1) then
    return true
end
self:teleport(get_room(61, 72))
self:destroy_item("all.key")
self.room:find_actor("anduin_pawnbroker"):teleport(get_room(61, 72))
self:command("remove all")
self:command("drop all")
self.room:find_actor("pawnbroker"):command("get all")
self.room:find_actor("anduin_pawnbroker"):teleport(get_room(60, 34))
local randmielrm = random(1, 18)
self:teleport(get_room(30, 51 + randmielrm))$trig$, '37d727b7d11689957560eef03e6be61c'),
  -- data/triggers/030/030_50_armor_exchange_greeting.lua
  (30, 50, $trig$-- Converted from DG Script #3050: Armor Exchange greeting
-- Original: MOB trigger, flags: GREET_ALL, probability: 100%
wait(2)
if actor.is_player then
    local item = actor:get_quest_var("armor_exchange:gem_id")
    if actor:get_quest_stage("armor_exchange") == 1 then
        actor:send(tostring(self.name) .. " shouts to you, 'Well howdy-hoo!  Welcome back!'")
        self:command("grin " .. tostring(actor))
        wait(2)
        if item == 0 then
            actor:send(tostring(self.name) .. " says, 'Tell me dearie, what can I help ya find today?'")
        else
            actor:send(tostring(self.name) .. " says, 'Are you still looking for " .. objects.template(math.floor(item / 100), item % 100).name .. "?'")
        end
    else
        actor:send(tostring(self.name) .. " hollers, 'Well hello there dearie!  Welcome to a land of rare and valuable treasures!'")
        actor:send(tostring(self.name) .. " indicates the massive piles of junk.")
        wait(1)
        actor:send(tostring(self.name) .. " says to you, 'We can trade all manner of precious old goodies here.  People leave behind armor they don't want anymore for stuff they do.'")
        wait(4)
        actor:send(tostring(self.name) .. " says, 'So what can I help you find today?'")
    end
end$trig$, '1a4565a2ed3b1e98d2b8258bd7ee6cd7'),
  -- data/triggers/030/030_51_armor_exchange_set_type.lua
  (30, 51, $trig$-- Converted from DG Script #3051: Armor Exchange set type
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: tarnished worn creased crushed burned corroded decayed rusted flimsy
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "tarnished") or string.find(string.lower(speech), "worn") or string.find(string.lower(speech), "creased") or string.find(string.lower(speech), "crushed") or string.find(string.lower(speech), "burned") or string.find(string.lower(speech), "corroded") or string.find(string.lower(speech), "decayed") or string.find(string.lower(speech), "rusted") or string.find(string.lower(speech), "flimsy")) then
    return true  -- No matching keywords
end
wait(2)
if not actor:get_quest_stage("armor_exchange") then
    actor:start_quest("armor_exchange")
end
local armor_id
if string.find(speech, "rusted") then
    if string.find(speech, "plate") then
        if string.find(speech, "boots") then
            armor_id = 55304
        elseif string.find(speech, "bracer") then
            armor_id = 55308
        else
            armor_id = 55324
        end
    elseif string.find(speech, "boots") then
        armor_id = 55304
    elseif string.find(speech, "bracer") then
        armor_id = 55308
    elseif string.find(speech, "gauntlets") then
        armor_id = 55300
    elseif string.find(speech, "helm") then
        armor_id = 55312
    elseif string.find(speech, "vambraces") then
        armor_id = 55316
    elseif string.find(speech, "greaves") then
        armor_id = 55320
    end
elseif string.find(speech, "flimsy") then
    if string.find(speech, "gloves") then
        armor_id = 55301
    elseif string.find(speech, "boots") then
        armor_id = 55305
    elseif string.find(speech, "bracer") then
        armor_id = 55309
    elseif string.find(speech, "cap") then
        armor_id = 55313
    elseif string.find(speech, "sleeves") then
        armor_id = 55317
    elseif string.find(speech, "leggings") then
        armor_id = 55321
    elseif string.find(speech, "tunic") then
        armor_id = 55325
    end
elseif string.find(speech, "decayed") then
    if string.find(speech, "mittens") then
        armor_id = 55302
    elseif string.find(speech, "slippers") then
        armor_id = 55306
    elseif string.find(speech, "bracelet") then
        armor_id = 55310
    elseif string.find(speech, "turban") then
        armor_id = 55314
    elseif string.find(speech, "sleeves") then
        armor_id = 55318
    elseif string.find(speech, "leggings") then
        armor_id = 55322
    elseif string.find(speech, "robe") then
        armor_id = 55326
    end
elseif string.find(speech, "crushed") then
    if string.find(speech, "leather") then
        if string.find(speech, "gloves") then
            armor_id = 55329
        elseif string.find(speech, "boots") then
            armor_id = 55333
        elseif string.find(speech, "bracer") then
            armor_id = 55337
        elseif string.find(speech, "sleeves") then
            armor_id = 55345
        elseif string.find(speech, "leggings") then
            armor_id = 55349
        elseif string.find(speech, "tunic") then
            armor_id = 55353
        end
    elseif string.find(speech, "hood") then
        armor_id = 55341
    elseif string.find(speech, "plate") then
        if string.find(speech, "boots") then
            armor_id = 55332
        elseif string.find(speech, "bracer") then
            armor_id = 55336
        else
            armor_id = 55352
        end
    elseif string.find(speech, "gauntlets") then
        armor_id = 55328
    elseif string.find(speech, "helm") then
        armor_id = 55340
    elseif string.find(speech, "vambraces") then
        armor_id = 55344
    elseif string.find(speech, "greaves") then
        armor_id = 55348
    end
elseif string.find(speech, "burned") then
    if string.find(speech, "gloves") then
        armor_id = 55330
    elseif string.find(speech, "mittens") then
        armor_id = 55331
    elseif string.find(speech, "boots") then
        armor_id = 55334
    elseif string.find(speech, "slippers") then
        armor_id = 55335
    elseif string.find(speech, "wristband") then
        armor_id = 55338
    elseif string.find(speech, "bracelet") then
        armor_id = 55339
    elseif string.find(speech, "cap") then
        armor_id = 55342
    elseif string.find(speech, "turban") then
        armor_id = 55343
    elseif string.find(speech, "vambraces") then
        armor_id = 55346
    elseif string.find(speech, "sleeves") then
        armor_id = 55347
    elseif string.find(speech, "pants") then
        armor_id = 55350
    elseif string.find(speech, "leggings") then
        armor_id = 55351
    elseif string.find(speech, "jerkin") then
        armor_id = 55354
    elseif string.find(speech, "robe") then
        armor_id = 55355
    end
elseif string.find(speech, "tarnished") then
    if string.find(speech, "plate") then
        if string.find(speech, "boots") then
            armor_id = 55360
        elseif string.find(speech, "bracer") then
            armor_id = 55364
        else
            armor_id = 55380
        end
    elseif string.find(speech, "boots") then
        armor_id = 55360
    elseif string.find(speech, "bracer") then
        armor_id = 55364
    elseif string.find(speech, "gauntlets") then
        armor_id = 55356
    elseif string.find(speech, "helm") then
        armor_id = 55368
    elseif string.find(speech, "vambraces") then
        armor_id = 55372
    elseif string.find(speech, "greaves") then
        armor_id = 55376
    end
elseif string.find(speech, "worn") then
    if string.find(speech, "mittens") then
        armor_id = 55359
    elseif string.find(speech, "slippers") then
        armor_id = 55363
    elseif string.find(speech, "bracelet") then
        armor_id = 55367
    elseif string.find(speech, "turban") then
        armor_id = 55371
    elseif string.find(speech, "sleeves") then
        armor_id = 55375
    elseif string.find(speech, "leggings") then
        armor_id = 55379
    elseif string.find(speech, "robe") then
        armor_id = 55383
    end
elseif string.find(speech, "corroded") then
    if string.find(speech, "gloves") then
        armor_id = 55358
    elseif string.find(speech, "boots") then
        armor_id = 55362
    elseif string.find(speech, "wristband") then
        armor_id = 55366
    elseif string.find(speech, "cap") then
        armor_id = 55370
    elseif string.find(speech, "vambraces") then
        armor_id = 55374
    elseif string.find(speech, "pants") then
        armor_id = 55378
    elseif string.find(speech, "jerkin") then
        armor_id = 55382
    end
elseif string.find(speech, "creased") then
    if string.find(speech, "gloves") then
        armor_id = 55357
    elseif string.find(speech, "boots") then
        armor_id = 55361
    elseif string.find(speech, "bracer") then
        armor_id = 55365
    elseif string.find(speech, "hood") then
        armor_id = 55369
    elseif string.find(speech, "sleeves") then
        armor_id = 55373
    elseif string.find(speech, "leggings") then
        armor_id = 55377
    elseif string.find(speech, "tunic") then
        armor_id = 55381
    end
end
if not armor_id then
    actor:send(tostring(self.name) .. " tells you, 'I'm sorry, I don't know what that is.'")
else
    actor:send(tostring(self.name) .. " asks you, 'You want " .. objects.template(math.floor(armor_id / 100), armor_id % 100).name .. "?'")
    actor:set_quest_var("armor_exchange", "armor_id", armor_id)
end$trig$, '62a6d0e8e20ac3098f720ea8f914a65e'),
  -- data/triggers/030/030_52_armor_exchange_confirm_order.lua
  (30, 52, $trig$-- Converted from DG Script #3052: Armor Exchange confirm order
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: yes no
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "yes") or string.find(string.lower(speech), "no")) then
    return true  -- No matching keywords
end
wait(2)
local item = actor:get_quest_var("armor_exchange:armor_id")
if string.find(speech, "yes") then
    if item == 0 then
        actor:send(tostring(self.name) .. " says, 'I don't think you asked me for anything, no sir.'")
        return _return_value
    end
    actor:send(tostring(self.name) .. " tells you, 'Oh my, yes dearie, of course.'")
    local class, tier
    if item <= 55303 then
        class = 1
        tier = 1
    elseif item <= 55307 then
        class = 1
        tier = 2
    elseif item <= 55311 then
        class = 1
        tier = 3
    elseif item <= 55315 then
        class = 1
        tier = 4
    elseif item <= 55319 then
        class = 1
        tier = 5
    elseif item <= 55323 then
        class = 1
        tier = 6
    elseif item <= 55327 then
        class = 1
        tier = 7
    elseif item <= 55331 then
        class = 2
        tier = 1
    elseif item <= 55335 then
        class = 2
        tier = 2
    elseif item <= 55339 then
        class = 2
        tier = 3
    elseif item <= 55343 then
        class = 2
        tier = 4
    elseif item <= 55347 then
        class = 2
        tier = 5
    elseif item <= 55351 then
        class = 2
        tier = 6
    elseif item <= 55355 then
        class = 2
        tier = 7
    elseif item <= 55359 then
        class = 3
        tier = 1
    elseif item <= 55363 then
        class = 3
        tier = 2
    elseif item <= 55367 then
        class = 3
        tier = 3
    elseif item <= 55371 then
        class = 3
        tier = 4
    elseif item <= 55375 then
        class = 3
        tier = 5
    elseif item <= 55379 then
        class = 3
        tier = 6
    elseif item <= 55383 then
        class = 3
        tier = 7
    end
    actor:send(tostring(self.name) .. " says, 'So " .. objects.template(math.floor(item / 100), item % 100).name .. " is a <b:yellow>class " .. tostring(class) .. " tier " .. tostring(tier) .. "</> piece of gear.'")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'I'll give it to you for any other armor of equal or greater rarity.'")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'Consult the chart for degrees of rarity.'")
    actor:send(tostring(self.name) .. " points to the sign.")
else
    actor:set_quest_var("gem_exchange", "gem_id", 0)
    actor:send(tostring(self.name) .. " says, 'Alright, what DO you want then?'")
end$trig$, '576afa6fb7e104ba70bd6edd5663d5b5'),
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
            actor:send(tostring(self.name) .. " says, 'That's not rare enough!  I won't take " .. tostring(object.shortdesc) .. " for " .. objects.template(math.floor(item / 100), item % 100).name .. "!'")
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
return _return_value$trig$, 'fccc082953bfb0d1eee651de91f7b176'),
  -- data/triggers/030/030_76_test_quest_banter1.lua
  (30, 76, $trig$-- Converted from DG Script #3076: test_quest_banter1
-- Original: MOB trigger, flags: SPEECH_TO, num_arg: 1 (DG word-list mode, not a probability)

-- DG word list (num_arg 1): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"hi", "hello", "howdy", "quest"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
if not actor:get_has_completed("zzurs_funky_quest") then
    self:say("I wonder if my brother the Northern road ranger is still alive?")
    self:command("sigh")
    self:say("If only I had some proof of his doings.")
    self:say("Will you help me?")
else
end$trig$, 'ce71191f55b66e06c93a9b7c05095f79'),
  -- data/triggers/030/030_78_test_quest_speech_north.lua
  (30, 78, $trig$-- Converted from DG Script #3078: test_quest_speech_north
-- Original: MOB trigger, flags: SPEECH_TO, num_arg: 1 (DG word-list mode, not a probability)

-- DG word list (num_arg 1): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"brother"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
if actor.is_player then
    if actor:get_quest_stage("zzurs_funky_quest") == 1 then
        actor:send(tostring(self.name) .. " says to you, 'My brother is looking for me?'")
        actor:advance_quest("zzurs_funky_quest")
    else
    end
else
end$trig$, 'cd8323149e43692aa6639cb91b074b3c'),
  -- data/triggers/030/030_79_test_quest_speech2_north.lua
  (30, 79, $trig$-- Converted from DG Script #3079: test_quest_speech2_north
-- Original: MOB trigger, flags: SPEECH_TO, num_arg: 1 (DG word-list mode, not a probability)

-- DG word list (num_arg 1): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"yes"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
if actor.is_player then
    if actor:get_quest_stage("zzurs_funky_quest") == 2 then
        actor:send(tostring(self.name) .. " says to you, 'I would love to send him proof of my doings but I am so busy.'")
        self:command("sigh")
        actor:send(tostring(self.name) .. " says to you, 'I need a diadem of bone.'")
        actor:advance_quest("zzurs_funky_quest")
    else
    end
else
end$trig$, 'a1361705d33ce7d8a3d07e129b4d30f7'),
  -- data/triggers/030/030_81_dragon_slayers_isilynor_speech.lua
  (30, 81, $trig$-- Converted from DG Script #3081: Dragon Slayers Isilynor Speech
-- Original: MOB trigger, flags: SPEECH, num_arg: 1 (DG word-list mode, not a probability)

-- DG word list (num_arg 1): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"hunt", "dragon", "dragons"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
wait(2)
if actor:get_has_completed("dragon_slayer") then
    actor:send(tostring(self.name) .. " says, 'The only dragons remaining are beasts of legend!'")
elseif actor.level < 5 then
    actor:send(tostring(self.name) .. " says, 'You're not quite ready to start taking on dragons.  Come back when you've seen a little more.'")
elseif (not actor:get_quest_stage("dragon_slayer") and actor.level >= 5) or (actor:get_quest_stage("dragon_slayer") == 1 and not actor:get_quest_var("dragon_slayer:hunt")) then
    actor:send(tostring(self.name) .. " says, 'Before you go slaying any real dragons, let's start with a test kill.'")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'The hedges in the topiary have been brought to life somehow.  We don't know exactly what's causing it, but that's also not our concern at the moment.'")
    wait(4)
    actor:send(tostring(self.name) .. " says, 'Some of the dragon hedges have become a real problem!  They're big, nasty, and put up one hell of a fight.  They might only be shrubbery, but they'll be a great way to prove you're ready for the real thing.'")
    wait(4)
    actor:send(tostring(self.name) .. " says, 'Are you up to the challenge?'")
elseif actor:get_quest_var("dragon_slayer:hunt") == "dead" then
    actor:send(tostring(self.name) .. " says, 'Give me your current notice first.'")
    return _return_value
else
    if actor.level >= (actor:get_quest_stage("dragon_slayer") - 1) * 10 then
        -- switch on actor:get_quest_stage("dragon_slayer")
        if actor:get_quest_var("dragon_slayer:hunt") == "running" then
            if actor:get_quest_stage("dragon_slayer") == 1 then
                actor:send(tostring(self.name) .. " says, 'You still have a dragon to slay.  If you can't even take out a dragon hedge, you'll never be ready for the real thing.'")
            end
            if actor:get_quest_var("dragon_slayer:hunt") == "running" then
            elseif actor:get_quest_stage("dragon_slayer") == 2 then
                actor:send(tostring(self.name) .. " says, 'You still have a dragon to slay.  Hunt down the green wyrmling in Morgan Hill.'")
            else
                actor:send(tostring(self.name) .. " says, 'We've heard there's a green dragon who's taken up residence below the old house on Morgan Hill.  Our scouts say it's still just a wyrmling, so now is the best time to take it out.  Big dragons come from little dragons afterall.'")
                wait(4)
                actor:send(tostring(self.name) .. " says, 'But don't let your guard down!  A baby dragon is still a dragon!'")
                wait(4)
                actor:send(tostring(self.name) .. " says, 'Are you ready for your first real kill?'")
            end
            if actor:get_quest_var("dragon_slayer:hunt") == "running" then
            elseif actor:get_quest_stage("dragon_slayer") == 3 then
                actor:send(tostring(self.name) .. " says, 'You still have a dragon to slay.  Hunt down Wug the Fiery Drakling.'")
            else
                actor:send(tostring(self.name) .. " says, 'I've been interested in the stories around Wug the Fiery Drakling, a fierce and fearsome beast who used to terrorize Mielikki with a brood of other lesser drakes in ages past.  But they all suddenly and mysteriously disappeared.'")
                wait(4)
                actor:send(tostring(self.name) .. " says, 'I hear the Templar Magistrate has uncovered some new information around the Wug legend.  Ask him about Wug and see what he knows.  You can become a legend by slaying a legend!'")
                wait(4)
                actor:send(tostring(self.name) .. " says, 'Are you up for a little legendary discovery?'")
            end
            if actor:get_quest_var("dragon_slayer:hunt") == "running" then
            elseif actor:get_quest_stage("dragon_slayer") == 4 then
                actor:send(tostring(self.name) .. " says, 'You still have a dragon to slay.  Hunt down the young blue dragon near the Tower in the Wastes.'")
            else
                actor:send(tostring(self.name) .. " says, 'Another juvenile dragon has been spotted out near the old abandoned tower off the Black Rock Trail.  This one seems to be a lot more powerful than the little wyrmling under Morgan Hill though.'")
                wait(4)
                actor:send(tostring(self.name) .. " says, 'This one is a blue dragon with considerable spellcasting power.  So be ready for lightning!'")
                wait(4)
                actor:send(tostring(self.name) .. " says, 'So what do you think?  You ready to bring the thunder?'")
            end
            if actor:get_quest_var("dragon_slayer:hunt") == "running" then
            elseif actor:get_quest_stage("dragon_slayer") == 5 then
                actor:send(tostring(self.name) .. " says, 'You still have a dragon to slay.  Search the forests in South Caelia for a faerie dragon.'")
            else
                actor:send(tostring(self.name) .. " says, 'I just got news of something wild!  Apparently there's a section of forest in South Caelia that's just packed with magical beasts!  Incredibly rare faerie dragons can be found there in great numbers!'")
                wait(4)
                actor:send(tostring(self.name) .. " says, 'While faerie dragons themselves aren't terribly strong, the other creatures that fill the forest are incredibly deadly.  Plus faerie dragons breathe a special kind of euphoric gas that confuses and disables anyone who breathes it.  It'll be a very nasty combo.'")
                wait(4)
                actor:send(tostring(self.name) .. " says, 'Think you can hold your own against all manner of beasts?'")
            end
            if actor:get_quest_var("dragon_slayer:hunt") == "running" then
            elseif actor:get_quest_stage("dragon_slayer") == 6 then
                actor:send(tostring(self.name) .. " says, 'You still have a dragon to slay.  Kill that damn wyvern in the Highlands.'")
            else
                actor:send(tostring(self.name) .. " says, 'Since you've been able to hold out against the great beasts of the southern forest, I've got something closer to home to deal with.'")
                wait(4)
                actor:send(tostring(self.name) .. " says, 'Out past the Gothra Desert is a stretch of highlands.  A very nasty wyvern has long haunted that region.  So many innocent travelers have met their end and this creature's claws.  Other knights have tried and failed to slay it but none have succeeded.'")
                wait(4)
                actor:send(tostring(self.name) .. " says, 'Do you think you can finally fell the beast?'")
            end
            if actor:get_quest_var("dragon_slayer:hunt") == "running" then
            elseif actor:get_quest_stage("dragon_slayer") == 7 then
                actor:send(tostring(self.name) .. " says, 'You still have a dragon to slay.  Take down one of those ice lizards in Frost Valley.'")
            else
                actor:send(tostring(self.name) .. " says, 'A whole brood of giant ice reptiles slither through Frost Valley.  They seem to be somewhere between true dragons and just really huge lizards.")
                wait(4)
                actor:send(tostring(self.name) .. " says, 'That said, they seem like a great challenge for a well-experienced dragon slayer like yourself.'")
                wait(4)
                actor:send(tostring(self.name) .. " says, 'You ready to brave the cold?'")
            end
            if actor:get_quest_var("dragon_slayer:hunt") == "running" then
            elseif actor:get_quest_stage("dragon_slayer") == 8 then
                actor:send(tostring(self.name) .. " says, 'You still have a dragon to slay.  Find and vanquish the Beast of Borgan.'")
            else
                actor:send(tostring(self.name) .. " says, 'I have a great mission for you.'")
                wait(4)
                actor:send(tostring(self.name) .. " says, 'The ancient kingdom of Layveran fell to unholy forces in ages long past.  Its exact location is actually unknown.  But a strange planar rift out west takes you to the blasted ice desert surrounding the fallen castle.'")
                wait(4)
                actor:send(tostring(self.name) .. " says, 'Rumors say some kind of unholy two-headed draconic abomination dwells in the depths of the ruins.  Reaching it, let alone slaying it, will be a mighty challenge fit for a true champion!'")
                wait(4)
                actor:send(tostring(self.name) .. " says, 'You in?'")
            end
            if actor:get_quest_var("dragon_slayer:hunt") == "running" then
            elseif actor:get_quest_stage("dragon_slayer") == 9 then
                actor:send(tostring(self.name) .. " says, 'You still have a dragon to slay.  Eliminate the dragon the Ice Cult up north worships.'")
            else
                actor:send(tostring(self.name) .. " says, 'You're ready for a very high profile, high risk kill.  Up north is a cult dedicated to worshipping the white dragon Tri-Aszp.  Ending this cult is a high priority item and the only way to do that is the slay Tri-Aszp.'")
                wait(4)
                actor:send(tostring(self.name) .. " says, 'But that's easier said than done.  Not only is Tri-Aszp a fully grown dragon with full command of ice and frost, the cult is heavily militarized and heavily armed, with powerful priests and magicians to boot.'")
                wait(4)
                actor:send(tostring(self.name) .. " says, 'And to make matters worse, they're buried deep in the ice, surrounded by all manner of absolutely unstoppable monsters.'")
                wait(4)
                self:command("grin")
                wait(4)
                actor:send(tostring(self.name) .. " says, 'It's going to be a thrill a minute!  Are you up to the challenge?'")
            end
            if actor:get_quest_var("dragon_slayer:hunt") == "running" then
            elseif actor:get_quest_stage("dragon_slayer") == 10 then
                actor:send(tostring(self.name) .. " says, 'You still have a dragon to slay.  Destroy the mighty Hydra - and watch out for all its heads!'")
            else
                actor:send(tostring(self.name) .. " says, 'I have one last great dragon for you to hunt down.'")
                wait(4)
                actor:send(tostring(self.name) .. " says, 'The demon dragon Sagece has called to her several other deadly threats.  Among them is a massive Hydra - a many-headed monstrosity which Sagece entrusted with one of the keys to her lair.  Before one can even think about driving Sagece from Templace, the Hydra must fall.'")
                wait(4)
                actor:send(tostring(self.name) .. " says, 'I want you to be the one to fell the Hydra.  Do so and you'll be welcomed to the echelons of the Grand Master Dragon Slayers!'")
                wait(4)
                actor:send(tostring(self.name) .. " says, 'Ready for the fight of your life?'")
            end
        end
    else
        actor:send(tostring(self.name) .. " says, 'More dragons exist, but they're too dangerous without more experience.  Come back when you've seen a little more.'")
    end
end$trig$, 'f4d935e654e2ae0b9c01454085c05fc7'),
  -- data/triggers/030/030_82_dragon_slayer_isilynor_speech_yes.lua
  (30, 82, $trig$-- Converted from DG Script #3082: Dragon Slayer Isilynor Speech yes
-- Original: MOB trigger, flags: SPEECH, num_arg: 1 (DG word-list mode, not a probability)

-- DG word list (num_arg 1): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"yes"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
wait(2)
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
    if person and person.room == self.room then
        if not person:get_quest_stage("dragon_slayer") and person.level > 4 then
            person:start_quest("dragon_slayer")
        end
        if person:get_has_completed("dragon_slayer") then
            person:send(tostring(self.name) .. " says, 'The only dragons remaining are beasts of legend!'")
        elseif person.level < 5 then
            person:send(tostring(self.name) .. " says, 'You're not quite ready to start taking on dragons.  Come back when you've seen a little more.'")
        elseif person:get_quest_var("dragon_slayer:hunt") == "dead" then
            person:send(tostring(self.name) .. " says, 'Give me your current notice first.'")
        else
            if person.level >= (person:get_quest_stage("dragon_slayer") - 1) * 10 then
                if person:get_quest_var("dragon_slayer:hunt") ~= "running" then
                    person:send(tostring(self.name) .. " says, 'Excellent!'")
                    local notice
                    -- switch on person:get_quest_stage("dragon_slayer")
                    if person:get_quest_stage("dragon_slayer") == 1 then
                        notice = 80
                    elseif person:get_quest_stage("dragon_slayer") == 2 then
                        notice = 81
                    elseif person:get_quest_stage("dragon_slayer") == 3 then
                        notice = 82
                    elseif person:get_quest_stage("dragon_slayer") == 4 then
                        notice = 83
                    elseif person:get_quest_stage("dragon_slayer") == 5 then
                        notice = 84
                    elseif person:get_quest_stage("dragon_slayer") == 6 then
                        notice = 85
                    elseif person:get_quest_stage("dragon_slayer") == 7 then
                        notice = 86
                    elseif person:get_quest_stage("dragon_slayer") == 8 then
                        notice = 87
                    elseif person:get_quest_stage("dragon_slayer") == 9 then
                        notice = 88
                    elseif person:get_quest_stage("dragon_slayer") == 10 then
                        notice = 89
                    end
                    self.room:spawn_object(30, notice)
                    self:command("give notice " .. tostring(person))
                    person:send("</>")
                    person:send(tostring(self.name) .. " says, 'When you've slayed the beast, bring that notice back to me.  I'll reward you then.'")
                    person:send("</>")
                    person:send(tostring(self.name) .. " says, 'Be brave, be strong, and good luck!'")
                    person:set_quest_var("dragon_slayer", "hunt", "running")
                else
                    -- switch on person:get_quest_stage("dragon_slayer")
                    if person:get_quest_stage("dragon_slayer") == 1 then
                        person:send(tostring(self.name) .. " says, 'You still have a dragon to slay.  If you can't even take out a dragon hedge, you'll never be ready for the real thing.'")
                    elseif person:get_quest_stage("dragon_slayer") == 2 then
                        person:send(tostring(self.name) .. " says, 'You still have a dragon to slay.  Hunt down the green wyrmling in Morgan Hill.'")
                    elseif person:get_quest_stage("dragon_slayer") == 3 then
                        person:send(tostring(self.name) .. " says, 'You still have a dragon to slay.  Hunt down Wug the Fiery Drakling.'")
                    elseif person:get_quest_stage("dragon_slayer") == 4 then
                        person:send(tostring(self.name) .. " says, 'You still have a dragon to slay.  Hunt down the young blue dragon near the Tower in the Wastes.'")
                    elseif person:get_quest_stage("dragon_slayer") == 5 then
                        person:send(tostring(self.name) .. " says, 'You still have a dragon to slay.  Search the forests in South Caelia for a faerie dragon.'")
                    elseif person:get_quest_stage("dragon_slayer") == 6 then
                        person:send(tostring(self.name) .. " says, 'You still have a dragon to slay.  Kill that damn wyvern in the Highlands.'")
                    elseif person:get_quest_stage("dragon_slayer") == 7 then
                        person:send(tostring(self.name) .. " says, 'You still have a dragon to slay.  Take down one of those ice lizards in Frost Valley.'")
                    elseif person:get_quest_stage("dragon_slayer") == 8 then
                        person:send(tostring(self.name) .. " says, 'You still have a dragon to slay.  Find and vanquish the Beast of Borgan.'")
                    elseif person:get_quest_stage("dragon_slayer") == 9 then
                        person:send(tostring(self.name) .. " says, 'You still have a dragon to slay.  Eliminate the dragon the Ice Cult up north worships.'")
                    elseif person:get_quest_stage("dragon_slayer") == 10 then
                        person:send(tostring(self.name) .. " says, 'You still have a dragon to slay.  Destroy the mighty Hydra - and watch out for all its heads!'")
                    end
                end
            else
                person:send(tostring(self.name) .. " says, 'More dragons exist, but they're too dangerous without more experience.  Come back when you've seen a little more.'")
            end
        end
    elseif person and person.is_player then
        i = i + 1
    end
    a = a + 1
end  -- auto-close block$trig$, '2a6620921dffa75cdaa06fbfa6c1324f'),
  -- data/triggers/030/030_89_paladin_pendant_progress_tracker.lua
  (30, 89, $trig$-- Converted from DG Script #3089: Paladin Pendant progress tracker
-- Original: MOB trigger, flags: SPEECH, num_arg: 1 (DG word-list mode, not a probability)

-- DG word list (num_arg 1): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"status", "progress"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
wait(2)
actor:send("<b:green>Dragon Slayer</>")
if actor:get_has_completed("dragon_slayer") then
    actor:send(tostring(self.name) .. " says, 'The only dragons remaining are beasts of legend!'")
elseif not actor:get_quest_stage("dragon_slayer") and actor.level > 4 then
    actor:send(tostring(self.name) .. " says, 'You aren't on a hunt at the moment.'")
elseif actor.level < 5 then
    actor:send(tostring(self.name) .. " says, 'You're not quite ready to start taking on dragons.  Come back when you've seen a little more.'")
elseif actor:get_quest_var("dragon_slayer:hunt") == "dead" then
    actor:send(tostring(self.name) .. " says, 'Give me your current notice first.'")
elseif actor.level >= (actor:get_quest_stage("dragon_slayer") - 1) * 10 then
    if actor:get_quest_var("dragon_slayer:hunt") ~= "running" then
        actor:send(tostring(self.name) .. " says, 'You aren't on a hunt at the moment.'")
    else
        -- switch on actor:get_quest_stage("dragon_slayer")
        if actor:get_quest_stage("dragon_slayer") == 1 then
            actor:send(tostring(self.name) .. " says, 'You still have a dragon to slay.  If you can't even take out a dragon hedge, you'll never be ready for the real thing.'")
        elseif actor:get_quest_stage("dragon_slayer") == 2 then
            actor:send(tostring(self.name) .. " says, 'You still have a dragon to slay.  Hunt down the green wyrmling in Morgan Hill.'")
        elseif actor:get_quest_stage("dragon_slayer") == 3 then
            actor:send(tostring(self.name) .. " says, 'You still have a dragon to slay.  Hunt down Wug the Fiery Drakling.'")
        elseif actor:get_quest_stage("dragon_slayer") == 4 then
            actor:send(tostring(self.name) .. " says, 'You still have a dragon to slay.  Hunt down the young blue dragon near the Tower in the Wastes.'")
        elseif actor:get_quest_stage("dragon_slayer") == 5 then
            actor:send(tostring(self.name) .. " says, 'You still have a dragon to slay.  Search the forests in South Caelia for a faerie dragon.'")
        elseif actor:get_quest_stage("dragon_slayer") == 6 then
            actor:send(tostring(self.name) .. " says, 'You still have a dragon to slay.  Kill that damn wyvern in the Highlands.'")
        elseif actor:get_quest_stage("dragon_slayer") == 7 then
            actor:send(tostring(self.name) .. " says, 'You still have a dragon to slay.  Take down one of those ice lizards in Frost Valley.'")
        elseif actor:get_quest_stage("dragon_slayer") == 8 then
            actor:send(tostring(self.name) .. " says, 'You still have a dragon to slay.  Find and vanquish the Beast of Borgan.'")
        elseif actor:get_quest_stage("dragon_slayer") == 9 then
            actor:send(tostring(self.name) .. " says, 'You still have a dragon to slay.  Eliminate the dragon the Ice Cult up north worships.'")
        elseif actor:get_quest_stage("dragon_slayer") == 10 then
            actor:send(tostring(self.name) .. " says, 'You still have a dragon to slay.  Destroy the mighty Hydra - and watch out for all its heads!'")
        end
    end
else
    actor:send(tostring(self.name) .. " says, 'More dragons exist, but they're too dangerous without more experience.  Come back when you've seen a little more.'")
end
local anti = "Anti-Paladin"
if actor.class == "paladin" or actor.class == "anti" then
    actor:send("</>")
    actor:send("<b:green>Divine Devotion</>")
    local huntstage = actor:get_quest_stage("dragon_slayer")
    local pendantstage = actor:get_quest_stage("paladin_pendant")
    local job1 = actor:get_quest_var("paladin_pendant:necklacetask1")
    local job2 = actor:get_quest_var("paladin_pendant:necklacetask2")
    local job3 = actor:get_quest_var("paladin_pendant:necklacetask3")
    local job4 = actor:get_quest_var("paladin_pendant:necklacetask4")
    if actor.level < 10 then
        actor:send(tostring(self.name) .. " says, 'You aren't ready for such an act yet.  Come back when you've grown a bit.'")
        return _return_value
    elseif actor.level < (pendantstage * 10) then
        actor:send(tostring(self.name) .. " says, 'You aren't ready for another devotional act yet.  Come back when you've gained some more experience.'")
        return _return_value
    elseif actor:get_has_completed("paladin_pendant") then
        actor:send(tostring(self.name) .. " says, 'You've already proven your devotion as much as possible!'")
        return _return_value
    end
    if pendantstage == 0 then
        actor:send(tostring(self.name) .. " says, 'Your first act of devotion should be to <b:cyan>[hunt]</> a dragon.'")
        return _return_value
    elseif (pendantstage >= huntstage) and not actor:get_has_completed("dragon_slayer") then
        actor:send(tostring(self.name) .. " says, 'Slay a few more dragons then we can talk.'")
        return _return_value
    end
    -- switch on pendantstage
    local place, hint
    if pendantstage == 1 then
        local necklace = 12003
        local gem = 55582
        place = "The Mist Temple Altar"
        hint = "in the Misty Caverns."
    elseif pendantstage == 2 then
        local necklace = 23708
        local gem = 55590
        place = "Chamber of Chaos"
        hint = "in the Temple of Chaos."
    elseif pendantstage == 3 then
        local necklace = 58005
        local gem = 55622
        place = "Altar of Borgan"
        hint = "in the lost city of Nymrill."
    elseif pendantstage == 4 then
        local necklace = 48123
        local gem = 55654
        place = "A Hidden Altar Room"
        hint = "in a cave in South Caelia's Wailing Mountains."
    elseif pendantstage == 5 then
        local necklace = 12336
        local gem = 55662
        place = "The Altar of the Snow Leopard Order"
        hint = "buried deep in Mt. Frostbite"
    elseif pendantstage == 6 then
        local necklace = 43019
        local gem = 55677
        place = "Chapel Altar"
        hint = "deep underground in a lost castle."
    elseif pendantstage == 7 then
        local necklace = 37015
        local gem = 55709
        place = "A Cliffside Altar"
        hint = "tucked away in the land of Dreams."
    elseif pendantstage == 8 then
        local necklace = 58429
        local gem = 55738
        place = "Dark Altar"
        hint = "entombed with an ancient evil king."
    elseif pendantstage == 9 then
        local necklace = 52010
        local gem = 55739
        place = "An Altar"
        hint = "far away in the Plane of Air."
    end
    local attack = pendantstage * 100
    if job1 or job2 or job3 or job4 then
        actor:send(tostring(self.name) .. " says, 'You've done the following:'")
        if job1 then
            actor:send("- attacked " .. tostring(attack) .. " times")
        end
        if job2 then
            actor:send("- found " .. "%get.obj_shortdesc[%necklace%]%")
        end
        if job3 then
            actor:send("- found " .. "%get.obj_shortdesc[%gem%]%")
        end
        if job4 then
            actor:send("- prayed in " .. tostring(place))
        end
    end
    -- (empty send to actor)
    actor:send("You need to:")
    if job1 and job2 and job3 and job4 then
        actor:send("Just give me your old necklace.")
        return _return_value
    end
    if not job1 then
        local remaining = attack - actor:get_quest_var("paladin_pendant:attack_counter")
        actor:send("- attack <b:yellow>" .. tostring(remaining) .. "</> more times while wearing your necklace.")
    end
    if not job2 then
        actor:send("- find <b:yellow>" .. "%get.obj_shortdesc[%necklace%]%</>")
    end
    if not job3 then
        actor:send("- find <b:yellow>" .. "%get.obj_shortdesc[%gem%]%</>")
    end
    if not job4 then
        actor:send("- <b:yellow>pray</> in a place called \"<b:yellow>" .. tostring(place) .. "</>\".")
        actor:send("</>   It's <b:yellow>" .. tostring(hint) .. "</>")
    end
end$trig$, '37bde64bd2fb17fb6c48e4a578c4718c'),
  -- data/triggers/043/043_62_lp2_bard_subclass_speech3.lua
  (43, 62, $trig$-- Converted from DG Script #4362: LP2_bard_subclass_speech3
-- Original: MOB trigger, flags: SPEECH, num_arg: 1 (DG word-list mode, not a probability)

-- DG word list (num_arg 1): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"i"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
if string.find(speech, "I believe if I refuse to grow old I can stay young til I die") or string.find(speech, "I believe if I refuse to grow old, I can stay young til I die") then
    if actor:get_quest_stage("bard_subclass") == 5 then
        wait(1)
        self.room:send(tostring(self.name) .. " wipes a tear from his eye.")
        actor:send(tostring(self.name) .. " says, 'Yeah, that's a great one.'")
        wait(2)
        self:command("applaud " .. tostring(actor))
        actor:send(tostring(self.name) .. " says, 'You did great kid, congratulations.  If you want a spot in the Guild, it's yours.  Here's your first spellbook and pen to commemorate the occassion.'")
        wait(1)
        self.room:spawn_object(10, 29)
        self:command("give spellbook " .. tostring(actor))
        self.room:spawn_object(10, 30)
        self:command("give quill " .. tostring(actor))
        actor:complete_quest("bard_subclass")
        actor:send("Type '<b:magenta>subclass</>' to proceed.")
    end
end$trig$, '2eb5224842e3bbeb21fc7027a9340d00'),
  -- data/triggers/052/052_03_pyromancer_subclass_quest_emmath_speech1.lua
  (52, 3, $trig$-- DG word list (num_arg 1): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"flame?", "flames?", "life?", "flame", "flames", "life"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end

if string.find(actor.class, "Pyromancer") then
    wait(2)
    self:command("chuckle")
    actor:send(tostring(self.name) .. " says, 'I have nothing more to teach you, young one.'")
elseif not actor:get_quest_stage("pyromancer_subclass") then
    if string.find(actor.class, "Sorcerer") then
        if actor.race == "dragonborn_frost" or actor.race == "arborean" then
            actor:send("<red>Your race may not subclass to pyromancer.</>")
            return true
        end
        wait(2)
        if actor.level >= 10 and actor.level <= 45 then
            self:command("nod " .. tostring(actor.name))
            actor:send(tostring(self.name) .. " says, 'Do you wish to become one with the flame, becoming a mage of fire?'")
        elseif actor.level < 10 then
            actor:send(tostring(self.name) .. " says, 'Not yet, for you are still an initiate.  Come back when you have gained more experience.'")
        else
            actor:send(tostring(self.name) .. " says, 'Unfortunately you are too dedicated to your universalist ways for me to teach you now.'")
        end
    else
        wait(2)
        actor:send(tostring(self.name) .. " says, 'Sorry, I cannot help you learn the ways of the flame.'")
    end
end$trig$, '0166f31a697df5165a48cd45427cf2c6'),
  -- data/triggers/052/052_04_pyromancer_subclass_quest_emmath_speech2.lua
  (52, 4, $trig$-- DG word list (num_arg 1): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"yes", "no"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
local speech_lower = string.lower(speech)

if not actor:get_quest_stage("pyromancer_subclass") and string.find(actor.class, "Sorcerer") then
    if string.find(speech_lower, "yes") then
        if actor.level >= 10 and actor.level <= 45 then
            if actor.race == "dragonborn_frost" or actor.race == "arborean" then
                actor:send("<red>Your race may not subclass to Pyromancer.</>")
                return true
            else
                wait(2)
                actor:start_quest("pyromancer_subclass", "Pyr")
                self:command("nod")
                actor:send(tostring(self.name) .. " says, 'Only the best and most motivated of mages will complete the <b:red>quest</> I lay before you.'")
                self:command("smile")
                wait(2)
                actor:send(tostring(self.name) .. " says, 'However, I am sure it is in you, if it is truly your desire, to complete this quest and become a pyromancer.'")
                wait(4)
                actor:send(tostring(self.name) .. " says, 'You may ask about your quest <b:red>[subclass progress]</> at any time.'")
                wait(2)
                actor:send(tostring(self.name) .. " says, 'Don't ask me to repeat myself though.'")
                wait(1)
                actor:send(tostring(self.name) .. " says, 'I hate that.'")
            end
        elseif actor.level < 10 then
            actor:send(tostring(self.name) .. " says, 'Come back to me once you've gained more experience.'")
        elseif actor.level > 45 then
            actor:send(tostring(self.name) .. " says, 'Unfortunately you are too dedicated to your universalist ways for me to teach you now.'")
        end
    else
        wait(2)
        actor:send(tostring(self.name) .. " says, 'Very well, then begone from here.  I suppose you do not have it in you to be a mage of fire anyway.'")
        actor:send("Emmath places his fiery palm in the air, making the room glow brightly.")
        self.room:send_except(actor, "Emmath raises his palm into the air, making the room very bright.")
        actor:send("The air around you wavers.")
        self.room:send_except(actor, tostring(actor.name) .. " suddenly disappears at Emmath's command.")
        actor:teleport(get_room(51, 91))
        actor:command("look")
    end
end$trig$, '2b324934943148ed0436ad96130e7767'),
  -- data/triggers/052/052_05_pyromancer_subclass_quest_emmath_speech3.lua
  (52, 5, $trig$-- DG word list (num_arg 1): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"quest", "quest?"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end

wait(2)
if actor:get_quest_stage("pyromancer_subclass") == 1 then
    actor:advance_quest("pyromancer_subclass")
    local part
    if actor.alignment >= 350 then
        part = "white"
    elseif actor.alignment <= -350 then
        part = "black"
    else
        part = "gray"
    end
    actor:set_quest_var("pyromancer_subclass", "part", part)
    actor:send(tostring(self.name) .. " says, 'I seem to have a problem now, because some time ago...'")
    self:emote("sighs, looking troubled.")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'It is just...'")
    wait(1)
    actor:send(tostring(self.name) .. " says, 'Well, part of the essence of fire is no longer under my power.'")
    self:emote("shakes his head sadly.")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'I once controlled all three parts of the flame: <b:white>White</>, <blue>Gray</>, and &9<blue>Black</>.'")
    wait(2)
    self:command("frown")
    actor:send(tostring(self.name) .. " says, 'But one of them was taken from my <b:red>control</>.'")
    wait(1)
    self:command("sigh")
elseif actor:get_quest_stage("pyromancer_subclass") > 1 then
    self:command("grumble")
    wait(1)
    actor:send(tostring(self.name) .. " says, 'I already told you about the quest.'")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'Part of the flame is no longer under my <b:red>control</>.  You should remember that much.'")
end$trig$, '2dae0537295ba8be09225b91b4139a00'),
  -- data/triggers/052/052_06_pyromancer_subclass_quest_emmath_speech4.lua
  (52, 6, $trig$-- DG word list (num_arg 1): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"control", "controlled", "control?", "controlled?", "taken", "taken?"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
wait(2)
if actor:get_quest_stage("pyromancer_subclass") == 2 then
    actor:advance_quest("pyromancer_subclass")
    self:command("nod " .. tostring(actor.name))
elseif actor:get_quest_stage("pyromancer_subclass") > 2 then
    self:command("roll")
    actor:send(tostring(self.name) .. " says, 'I already told you once.'")
    wait(2)
    self:command("sigh")
end
if actor:get_quest_stage("pyromancer_subclass") >= 2 then
    actor:send(tostring(self.name) .. " says, 'Yes, I once had control over all three fire elements.'")
    self:emote("again shakes his head sadly.")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'But the " .. tostring(actor:get_quest_var("pyromancer_subclass:part")) .. " flame was taken from me.'")
    self:command("look " .. tostring(actor.name))
    wait(2)
    actor:send(tostring(self.name) .. " says, 'To truly help, I suggest you stop loitering and go recover it.'")
    self:command("ponder")
    wait(2)
    local part = actor:get_quest_var("pyromancer_subclass:part")
    local place
    if part == "white" then
        place = "&bin some kind of mine&0"
    elseif part == "black" then
        place = "&bin some kind of temple&0"
    elseif part == "gray" then
        place = "&bnear some kind of hill&0"
    else
        place = "&bsomewhere out there&0"
    end
    actor:send(tostring(self.name) .. " says, 'Last I heard, it was <b:cyan>" .. tostring(place) .. "</>, or something of the like.'")
    self:emote("mutters something about the villainy of it all.")
    wait(3)
    self:command("eye " .. tostring(actor.name))
    actor:send(tostring(self.name) .. " says, 'Are you still here?  You should leave now.'")
end$trig$, 'ae65bea5495a3e1c25c97b4784813342'),
  -- data/triggers/052/052_09_flameball_speech_ball.lua
  (52, 9, $trig$-- DG word list (num_arg 1): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"ball", "ball?", "flameball", "flameball?"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end

wait(2)
if actor.is_player then
    if actor:get_quest_stage("emmath_flameball") == 1 then
        self:command("sigh")
        self:say("You've already inquired about the ball of flame.")
        wait(2)
        self:command("peer " .. tostring(actor.name))
        self:say("I'm not sure you're prepared for such power.")
    elseif actor:get_quest_stage("emmath_flameball") == 2 then
        self:command("sigh")
        self:say("You've already inquired about the ball of flame.")
        wait(3)
        self:say("I told you to bring me the three parts of fire and we would see about it.")
    elseif actor:get_quest_stage("emmath_flameball") == 3 then
        self:command("growl")
        self:say("Stop bothering me.  You know what I want already.")
        wait(2)
        self:command("sigh")
        self:say("The renegade flame--bring it to me.")
    else
        actor:start_quest("emmath_flameball")
        self:say("You seek this ball of flame, do you?")
        self:command("ponder")
        wait(2)
        self:say("Ah, to hold it in your palm...  You would need to prove your worth for such power.")
        self:emote("looks thoughtful for a moment.")
    end
end$trig$, '48fee43e6688699e915bee9300ba9694'),
  -- data/triggers/052/052_10_flameball_speech_power.lua
  (52, 10, $trig$-- DG word list (num_arg 1): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"power", "power?", "worth", "worth?", "prove", "prove?", "how", "how?"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end

wait(2)
if actor:get_quest_stage("emmath_flameball") == 1 then
    actor:advance_quest("emmath_flameball")
    actor:send(tostring(self.name) .. " says, 'Yes, you would need to show mastery over the fire.'")
    self:emote("pulls out his well-used thinking cap, and begins to think.")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'Bring me the three parts of flame: <b:white>White</>, <blue>Gray</>, and &9<blue>Black</>.  I think we can talk again then.'")
    wait(3)
    actor:send(tostring(self.name) .. " says, 'Ask about your <b:red>[quest progress]</> if you need.'")
    wait(7)
    actor:send(tostring(self.name) .. " says, 'Well? Go on, then!'")
elseif actor:get_quest_stage("emmath_flameball") == 2 then
    self:command("mutter " .. tostring(actor.name))
    actor:send(tostring(self.name) .. " says, 'I told you, not until you bring me all three flames!'")
elseif actor:get_quest_stage("emmath_flameball") == 3 then
    self:command("peer " .. tostring(actor.name))
    actor:send(tostring(self.name) .. " says, 'Didn't we talk about this already?'")
    wait(1)
    actor:send(tostring(self.name) .. " says, 'Bring me the renegade flame!'")
end$trig$, 'a12a9a7e6a98c2b6190c1c20884d9fc3'),
  -- data/triggers/053/053_19_ranger_trophy_pumahl_progress.lua
  (53, 19, $trig$-- Converted from DG Script #5319: Ranger Trophy Pumahl progress
-- Original: MOB trigger, flags: SPEECH, num_arg: 1 (DG word-list mode, not a probability)

-- DG word list (num_arg 1): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"status", "progress"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
wait(2)
actor:send("<b:green>Beast Masters</>")
if actor:get_has_completed("beast_master") then
    actor:send(tostring(self.name) .. " says, 'You've already proven your dominion over the beasts of Ethilien!'")
elseif actor.level >= (actor:get_quest_stage("beast_master") - 1) * 10 then
    if actor:get_quest_var("beast_master:hunt") ~= "running" then
        actor:send(tostring(self.name) .. " says, 'You aren't on a hunt at the moment.'")
    else
        -- switch on actor:get_quest_stage("beast_master")
        if actor:get_quest_stage("beast_master") == 1 then
            actor:send(tostring(self.name) .. " says, 'You're still on the hunt.  Slay an abominable slime creature in the sewers beneath Mielikki.'")
        elseif actor:get_quest_stage("beast_master") == 2 then
            actor:send(tostring(self.name) .. " says, 'You're still on the hunt.  Hunt down a large buck in the forests just outside of Mielikki.'")
        elseif actor:get_quest_stage("beast_master") == 3 then
            actor:send(tostring(self.name) .. " says, 'You're still on the hunt.  Track down the giant scorpion of Gothra.'")
        elseif actor:get_quest_stage("beast_master") == 4 then
            actor:send(tostring(self.name) .. " says, 'You're still on the hunt.  Head far to the south and kill a monstrous canopy spider.'")
        elseif actor:get_quest_stage("beast_master") == 5 then
            actor:send(tostring(self.name) .. " says, 'You're still on the hunt.  Behead the famed chimera of Fiery Island.'")
        elseif actor:get_quest_stage("beast_master") == 6 then
            actor:send(tostring(self.name) .. " says, 'You're still on the hunt.  Slay the \"king\" of the abominations known as driders.'")
        elseif actor:get_quest_stage("beast_master") == 7 then
            actor:send(tostring(self.name) .. " says, 'You're still on the hunt.  Close the eyes of a beholder from under Mt. Frostbite.'")
        elseif actor:get_quest_stage("beast_master") == 8 then
            actor:send(tostring(self.name) .. " says, 'You're still on the hunt.  Lay the Banshee to eternal rest.'")
        elseif actor:get_quest_stage("beast_master") == 9 then
            actor:send(tostring(self.name) .. " says, 'You're still on the hunt.  Put an end to Baba Yaga's dreamy witchcraft.'")
        elseif actor:get_quest_stage("beast_master") == 10 then
            actor:send(tostring(self.name) .. " says, 'You're still on the hunt.  Defeat the medusa below the city of Templace.'")
        end
    end
else
    actor:send(tostring(self.name) .. " says, 'Unfortunately I don't have any beasts for you to pursue at the moment.  Check back later!'")
end
if actor.class == "Warrior" or actor.class == "Ranger" or actor.class == "Berserker" or actor.class == "Mercenary" then
    actor:send("</>")
    actor:send("<b:green>Eye of the Tiger</>")
    local huntstage = actor:get_quest_stage("beast_master")
    local trophystage = actor:get_quest_stage("ranger_trophy")
    local job1 = actor:get_quest_var("ranger_trophy:trophytask1")
    local job2 = actor:get_quest_var("ranger_trophy:trophytask2")
    local job3 = actor:get_quest_var("ranger_trophy:trophytask3")
    local job4 = actor:get_quest_var("ranger_trophy:trophytask4")
    if actor.level < 10 then
        actor:send(tostring(self.name) .. " says, 'You aren't ready for this test yet.  Come back when you've grown a bit.'")
        return _return_value
    elseif actor.level < (trophystage * 10) then
        actor:send(tostring(self.name) .. " says, 'You aren't ready for another test yet.  Come back when you've gained some more experience.'")
        return _return_value
    elseif actor:get_has_completed("ranger_trophy") then
        actor:send(tostring(self.name) .. " says, 'You've already proven your skills as much as possible!'")
        return _return_value
    end
    if trophystage == 0 then
        actor:send(tostring(self.name) .. " says, 'You must <b:cyan>[hunt]</> a great beast to demonstrate your skills first.'")
        return _return_value
    elseif (trophystage >= huntstage) and not actor:get_has_completed("beast_master") then
        actor:send(tostring(self.name) .. " says, 'Prove your dominion over some more great beasts first then we can talk.'")
        return _return_value
    end
    -- switch on trophystage
    local place, hint
    if trophystage == 1 then
        local trophy = 1607
        local gem = 55579
        place = "A Coyote's Den"
        hint = "near the Kingdom of the Meer Cats."
    elseif trophystage == 2 then
        local trophy = 17806
        local gem = 55591
        place = "In the Lions' Den"
        hint = "in the western reaches of Gothra."
    elseif trophystage == 3 then
        local trophy = 1805
        local gem = 55628
        place = "either of the two Gigantic Roc Nests"
        hint = "in the Wailing Mountains."
    elseif trophystage == 4 then
        local trophy = 62513
        local gem = 55652
        place = "Chieftain's Lair"
        hint = "in Nukreth Spire in South Caelia."
    elseif trophystage == 5 then
        local trophy = 23803
        local gem = 55664
        place = "The Heart of the Den"
        hint = "where the oldest unicorn in South Caelia makes its home."
    elseif trophystage == 6 then
        local trophy = 43009
        local gem = 55685
        place = "Giant Lynx's Lair"
        hint = "far to the north beyond Mt. Frostbite."
    elseif trophystage == 7 then
        local trophy = 47008
        local gem = 55705
        place = "Giant Griffin's Nest"
        hint = "tucked away in a secluded and well guarded corner of Griffin Island."
    elseif trophystage == 8 then
        local trophy = 53323
        local gem = 55729
        place = "Witch's Den"
        hint = "entombed with an ancient evil king."
    elseif trophystage == 9 then
        local trophy = 52014
        local gem = 55741
        place = "Dargentan's Lair"
        hint = "at the pinnacle of his flying fortress."
    end
    local attack = trophystage * 100
    if job1 or job2 or job3 or job4 then
        actor:send(tostring(self.name) .. " says, 'You've done the following:'")
        if job1 then
            actor:send("- attacked " .. tostring(attack) .. " times")
        end
        if job2 then
            actor:send("- found " .. "%get.obj_shortdesc[%trophy%]%")
        end
        if job3 then
            actor:send("- found " .. "%get.obj_shortdesc[%gem%]%")
        end
        if job4 then
            actor:send("- foraged in " .. tostring(place))
        end
    end
    -- (empty send to actor)
    actor:send("You need to:")
    if job1 and job2 and job3 and job4 then
        actor:send("Just give me your old trophy.")
        return _return_value
    end
    if not job1 then
        local remaining = attack - actor:get_quest_var("ranger_trophy:attack_counter")
        actor:send("- attack <b:green>" .. tostring(remaining) .. "</> more times while wearing your trophy.")
    end
    if not job2 then
        actor:send("- find <b:green>" .. "%get.obj_shortdesc[%trophy%]%</>")
    end
    if not job3 then
        actor:send("- find <b:green>" .. "%get.obj_shortdesc[%gem%]%</>")
    end
    if not job4 then
        actor:send("- <b:green>forage</> in a place called \"<b:green>" .. tostring(place) .. "</>\".")
        actor:send("</>   It's <b:green>" .. tostring(hint) .. "</>")
    end
end$trig$, '810ff9c9286aa5404b9080741595d314'),
  -- data/triggers/060/060_59_assassin_mask_progress_checker.lua
  (60, 59, $trig$-- Converted from DG Script #6059: Assassin mask progress checker
-- Original: MOB trigger, flags: SPEECH, num_arg: 1 (DG word-list mode, not a probability)

-- DG word list (num_arg 1): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"status", "progress"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
wait(2)
actor:send("<b:green>Contract Killers</>")
if actor:get_has_completed("bounty_hunt") then
    actor:send(tostring(self.name) .. " says, 'You know, I'm fresh out of work for you.  Good luck!'")
elseif not actor:get_quest_stage("bounty_hunt") then
    actor:send(tostring(self.name) .. " says, 'You aren't doing a job for me.'")
elseif actor:get_quest_var("bounty_hunt:bounty") == "dead" then
    actor:send(tostring(self.name) .. " says, 'Give me your current contract.'")
elseif actor.level >= (actor:get_quest_stage("bounty_hunt") - 1) * 10 then
    if actor:get_quest_var("bounty_hunt:bounty") ~= "running" then
        actor:send(tostring(self.name) .. " says, 'You aren't doing a job for me.'")
    else
        -- switch on actor:get_quest_stage("bounty_hunt")
        if actor:get_quest_stage("bounty_hunt") == 1 then
            actor:send(tostring(self.name) .. " says, 'You still have a job to do.  Best get on killing that cat-king or whatever first.'")
        elseif actor:get_quest_stage("bounty_hunt") == 2 then
            actor:send(tostring(self.name) .. " says, 'You still have a job to do.  Take out the Noble and the Abbot  sheltering him at the Abbey of St. George.'")
        elseif actor:get_quest_stage("bounty_hunt") == 3 then
            actor:send(tostring(self.name) .. " says, 'You still have a job to do.  Take out the three Chieftains in the southwestern Highlands.'")
        elseif actor:get_quest_stage("bounty_hunt") == 4 then
            actor:send(tostring(self.name) .. " says, 'You still have a job to do.  Find the Frakati Leader and kill him.'")
        elseif actor:get_quest_stage("bounty_hunt") == 5 then
            actor:send(tostring(self.name) .. " says, 'You still have a job to do.  Infiltrate the Sacred Haven and take out the number two in command, Cyrus.'")
        elseif actor:get_quest_stage("bounty_hunt") == 6 then
            actor:send(tostring(self.name) .. " says, 'You still have a job to do.  Disappear Lord Venth down south.'")
        elseif actor:get_quest_stage("bounty_hunt") == 7 then
            actor:send(tostring(self.name) .. " says, 'You still have a job to do.  Send the high druid on a permanent pilgrimage.'")
        elseif actor:get_quest_stage("bounty_hunt") == 8 then
            actor:send(tostring(self.name) .. " says, 'You still have a job to do.  Kill the Lizard King.  If you can even find him...'")
        elseif actor:get_quest_stage("bounty_hunt") == 9 then
            actor:send(tostring(self.name) .. " says, 'You still have a job to do.  Take out the leader of the Ice Cult up north before they get wind of it.'")
        elseif actor:get_quest_stage("bounty_hunt") == 10 then
            actor:send(tostring(self.name) .. " says, 'You still have a job to do.  End the reign of the Goblin King.  We'll all probably dream a little more soundly then.'")
        end
    end
else
    actor:send(tostring(self.name) .. " says, 'All my other jobs are too risky for someone without moreexperience.  Come back when you've seen a little more.'")
end
if actor.class == "Assassin" then
    actor:send("</>")
    actor:send("<b:green>Deadly Promotion</>")
    local bountystage = actor:get_quest_stage("bounty_hunt")
    local maskstage = actor:get_quest_stage("assassin_mask")
    local job1 = actor:get_quest_var("assassin_mask:masktask1")
    local job2 = actor:get_quest_var("assassin_mask:masktask2")
    local job3 = actor:get_quest_var("assassin_mask:masktask3")
    local job4 = actor:get_quest_var("assassin_mask:masktask4")
    wait(2)
    if actor.class ~= "Assassin" then
        self.room:send(tostring(self.name) .. " scoffs in disgust.")
        actor:send(tostring(self.name) .. " says, 'You ain't part of the Guild.  Get lost.'")
        return _return_value
    elseif actor.level < 10 then
        actor:send(tostring(self.name) .. " says, 'You ain't ready for a promotion yet.  Come back when you've grown a bit.'")
        return _return_value
    elseif actor.level < (maskstage * 10) then
        actor:send(tostring(self.name) .. " says, 'You ain't ready for another promotion yet.  Come back when you've gained some more experience.'")
        return _return_value
    elseif actor:get_has_completed("assassin_mask") then
        actor:send(tostring(self.name) .. " says, 'You've already gone as high as you can go!'")
        return _return_value
    end
    if maskstage == 0 then
        actor:send(tostring(self.name) .. " says, 'Sure.  You gotta do a <b:cyan>[job]</> for me first though.'")
        return _return_value
    elseif (maskstage >= bountystage) and not actor:get_has_completed("bounty_hunt") then
        actor:send(tostring(self.name) .. " says, 'Complete some more contract jobs then we can talk.'")
        return _return_value
    end
    -- switch on maskstage
    -- Hoisted: branch-scoped `local` here would not be visible to the
    -- code below that uses mask/gem/place/hint.
    local mask, gem, place, hint
    if maskstage == 1 then
        mask = 4500
        gem = 55592
        place = "The Shadowy Lair"
        hint = "in the Misty Caverns."
    elseif maskstage == 2 then
        mask = 17809
        gem = 55594
        place = "The Dark Chamber"
        hint = "behind a desert door."
    elseif maskstage == 3 then
        mask = 59023
        gem = 55620
        place = "A Dark Tunnel"
        hint = "on the way to a dark, hidden city."
    elseif maskstage == 4 then
        mask = 10304
        gem = 55638
        place = "Dark Chamber"
        hint = "hidden below a ghostly fortress."
    elseif maskstage == 5 then
        mask = 16200
        gem = 55666
        place = "Darkness......"
        hint = "inside an enchanted closet."
    elseif maskstage == 6 then
        mask = 43017
        gem = 55675
        place = "Surrounded by Darkness"
        hint = "in a volcanic shaft."
    elseif maskstage == 7 then
        mask = 51075
        gem = 55693
        place = "Dark Indecision"
        hint = "before an altar in a fallen maze."
    elseif maskstage == 8 then
        mask = 49062
        gem = 55719
        place = "Heart of Darkness"
        hint = "buried deep in an ancient tomb."
    elseif maskstage == 9 then
        mask = 48427
        gem = 55743
        place = "A Dark Room"
        hint = "under the ruins of a shop in an ancient city."
    end
    local attack = maskstage * 100
    if job1 or job2 or job3 or job4 then
        actor:send(tostring(self.name) .. " says, You've done the following:'")
        if job1 then
            actor:send("- attacked " .. tostring(attack) .. " times")
        end
        if job2 then
            -- TODO(parity): DG %get.obj_shortdesc[%mask%]% — needs (zone, local) split.
            actor:send("- found object id " .. tostring(mask))
        end
        if job3 then
            -- TODO(parity): DG %get.obj_shortdesc[%gem%]% — needs (zone, local) split.
            actor:send("- found object id " .. tostring(gem))
        end
        if job4 then
            actor:send("- hidden in " .. tostring(place))
        end
    end
    -- (empty send to actor)
    actor:send("You need to:")
    if job1 and job2 and job3 and job4 then
        actor:send("Just give me your old mask.")
        return _return_value
    end
    if not job1 then
        local remaining = attack - actor:get_quest_var("assassin_mask:attack_counter")
        actor:send("- attack &9<blue>" .. tostring(remaining) .. "</> more times while wearing your mask.")
    end
    if not job2 then
        -- TODO(parity): DG %get.obj_shortdesc[%mask%]% — needs (zone, local) split.
        actor:send("- find &9<blue>object id " .. tostring(mask) .. "</>")
    end
    if not job3 then
        -- TODO(parity): DG %get.obj_shortdesc[%gem%]% — needs (zone, local) split.
        actor:send("- find &9<blue>object id " .. tostring(gem) .. "</>")
    end
    if not job4 then
        actor:send("- &9<blue>hide in a place called \"&9<blue>" .. tostring(place) .. "</>\".")
        actor:send("</>   It's &9<blue>" .. tostring(hint) .. "</>")
    end
end$trig$, 'e88eea27f2ca6e1497237c723fdfea36'),
  -- data/triggers/061/061_20_lame_beggar_bribe.lua
  (61, 20, $trig$-- Converted from DG Script #6120: lame_beggar_bribe
-- Original: MOB trigger, flags: BRIBE, num_arg: 1 (minimum bribe in copper)

wait(1)
self.room:send(tostring(self.name) .. "'s eyes light up.")
if actor.gender == "Female" then
    self:say("Thank you so much, madam!")
else
    self:say("Thank you so much, sir!")
end$trig$, '23752ab4966a6a8be711f0710299ae5f'),
  -- data/triggers/085/085_51_norisent_speech.lua
  (85, 51, $trig$-- Converted from DG Script #8551: norisent speech
-- Original: MOB trigger, flags: SPEECH, SPEECH_TO, num_arg: 1 (DG word-list mode, not a probability)

-- DG word list (num_arg 1): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"resurrection", "teach", "resurrect", "yes", "payment", "how", "how?", "please", "useful", "command", "souls"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
local speech_lower = string.lower(speech)
if not actor.is_player then
    return true
end
if actor.class ~= "cleric" and actor.class ~= "priest" and actor.class ~= "diabolist" then
    return true
end

local stage = actor:get_quest_stage("resurrection_quest")
if (stage <= 1 or actor.level >= 81) and string.find(speech_lower, "resurrection") then
    actor:start_quest("resurrection_quest")
    wait(1)
    self:emote("smirks ever so slightly, with a creepy glint of foreboding.")
    self:say("So it's happened.  I knew someday your order would forget how.  Though, it's happened much sooner than I would have thought.  It only took a thousand years.")
    self:emote("furrows his brow.")
    wait(1)
    self:say("Is this true?  Have you come hoping that I will teach you how to resurrect your allies?")
    return true
end
if stage ~= 1 then
    if string.find(speech_lower, "teach") or string.find(speech_lower, "resurrect") or string.find(speech_lower, "yes") then
        wait(1)
        self:say("And what could you possibly offer me as payment?  I require nothing of food or drink.  Riches and knowledge are mine.  Glory and honor are lost on me.  I owe no living man my loyalty.")
        wait(3)
        self:say("'I know of only one thing that would please me more than your death that I might consider payment.")
        return true
    elseif string.find(speech_lower, "payment") or string.find(speech_lower, "please") then
        wait(1)
        self:say("There is an emissary from the Abbey of St. George, a bishop, being held in the dungeon.  Ziijhan would have her tortured and killed.  He's always trying to settle an old score with his brother, Barak.")
        wait(3)
        self:say("The old knight is being a petty child, but what could you possibly do to upset him?  Be gone, and trouble me no more.")
        actor:advance_quest("resurrection_quest")
        return true
    end
elseif stage ~= 3 then
    if string.find(speech_lower, "useful") or string.find(speech_lower, "how") then
        actor:advance_quest("resurrection_quest")
        wait(1)
        self:say("Yes, there is something more you could do for me.")
        wait(1)
        self:say("A beastly dark mage left an experiment... unresolved.  Very unprofessional of him.")
        wait(3)
        self:say("In his attempts to reunite a body and soul, he left them each alive, severed from one another.")
        wait(3)
        self.room:send(tostring(self.name) .. " says, 'You must go and find Lajon's two severed halves, loose them of their undead states, then destroy them both.  The soul must be rebuked with the words of power <b:blue>Dhewsost Konre</>, before purging him.'")
        wait(5)
        self:say("To purge the rogue body, however, you'll need to give him this to help you finalize his death.")
        wait(4)
        self.room:spawn_object(85, 50)
        self:command("give death " .. tostring(actor.name))
        wait(3)
        self:say("And as for the old mage...")
        self:command("chuckle")
        wait(2)
        self:say("That talisman should aid his passing as well.  The ring of souls is the source of his power.  Bring it to me when you're finished.")
        wait(2)
        self.room:send(tostring(self.name) .. " says, 'And if you forget, you can ask about your <b:white>[progress]</>.  Maybe I'll consider reminding you.'")
    end
end$trig$, '535178e0ed7c7397297bfadacb2aadcb'),
  -- data/triggers/1000/1000_11_kerristone_royal_stables.lua
  (0, 11, $trig$-- Converted from DG Script #11: Kerristone (Royal Stables)
-- Original: MOB trigger, flags: BRIBE, num_arg: 25 (minimum bribe in copper)

-- DG BRIBE num_arg 25: fires only when the coins are worth at least 25 copper.
if (value or 0) < 25 then
    return true
end
self.room:send("</><b:yellow>Licub</> nods to " .. tostring(actor.name) .. " and goes to fetch a horse.")
wait(5)
self.room:send("</><b:yellow>Licub</> returns with a </><yellow>well-bred warhorse</>.")$trig$, 'dadd6cc727fe0982734778efc081e44d'),
  -- data/triggers/123/123_01_priestess_speech1.lua
  (123, 1, $trig$-- Converted from DG Script #12301: priestess_speech1
-- Original: MOB trigger, flags: SPEECH, num_arg: 1 (DG word-list mode, not a probability)

-- DG word list (num_arg 1): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"assist", "assistance", "assist?", "assistance?", "how", "what"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
if string.find(speech, "assist") or string.find(speech, "assistance") or string.find(speech, "assist?") or string.find(speech, "assistance?") or string.find(speech, "how can I help?") or string.find(speech, "how can I assist?") or string.find(speech, "what can I do?") or string.find(speech, "what can I do to assist?") then
    wait(2)
    self.room:send(tostring(self.name) .. " says, 'Our coven came to this megalith to perform the <b:white>Great Rite of Invocation</> and summon our faerie goddess The Great Mother, the Lady of the Stars.'")
end$trig$, '8320027e79324f30c9e4e806f56f5f4b'),
  -- data/triggers/123/123_03_priestess_speech3.lua
  (123, 3, $trig$-- Converted from DG Script #12303: priestess_speech3
-- Original: MOB trigger, flags: SPEECH, SPEECH_TO, num_arg: 1 (DG word-list mode, not a probability)

-- DG word list (num_arg 1): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"old", "why?"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
if string.find(speech, "old gods") or string.find(speech, "old gods?") or string.find(speech, "why?") then
    wait(2)
    self:say("You see, when the Nine Hells cracked open to vomit forth Sagece on Templace, the putrid rift she crawled through so corrupted the world around it, many of the Old Gods found their holy sites defiled and their physical access to Ethilien severed.")
    wait(6)
    self:say("The Great Mother was one such unfortunate victim.")
    wait(3)
    self:say("She is cast adrift in the Deep Dreaming, lost in that birthplace and graveyard of primordial stars.  The near-total annihilation of the elven race, constant assault on our world by demons, gods turning on each other in bloody slaughter...")
    self.room:send("</>")
    self.room:send(tostring(self.name) .. " says, 'All these calamities along with centuries of unearned exile are weakening Her bond with our world.  Our Mother is still capable of gifting us her divine magic, but She is <b:cyan>slipping away</> from us.'")
end$trig$, '190193f8433f16e06b1c416fb68c0490'),
  -- data/triggers/123/123_04_priestess_speech4.lua
  (123, 4, $trig$-- Converted from DG Script #12304: priestess_speech4
-- Original: MOB trigger, flags: SPEECH, SPEECH_TO, num_arg: 1 (DG word-list mode, not a probability)

-- DG word list (num_arg 1): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"slipping", "how", "what"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
if string.find(speech, "slipping away") or string.find(speech, "slipping away?") or string.find(speech, "how terrible") or string.find(speech, "how sad") or string.find(speech, "what can be done?") then
    wait(2)
    self:say("We began to lose hope until we found this ancient circle of standing stones.  But I believe this place is powerful enough for us to perform the Great Invocation Rite.")
    wait(4)
    self:say("Several of our sacred prophetic implements were damaged navigating the maze.  My Sisters are too busy tending to their duties preparing this site for the Great Rite to find suitable replacements.")
    wait(5)
    self.room:send(tostring(self.name) .. " says, 'But perhaps you would be willing to <b:cyan>help us?</>'")
end$trig$, '4d2ecbc05494f4406c5bba8ebec0c4f7'),
  -- data/triggers/123/123_05_megalith_quest_priestess_speech_start.lua
  (123, 5, $trig$-- Converted from DG Script #12305: megalith_quest_priestess_speech_start
-- Original: MOB trigger, flags: SPEECH, SPEECH_TO, num_arg: 1 (DG word-list mode, not a probability)

-- DG word list (num_arg 1): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"yes", "yes?"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
-- This trigger serves as both the starting, restarting, and advancing from stage 3 to stage 4 trigger
-- If starting for the first time
-- 
if actor:get_quest_stage("megalith_quest") < 1 then
    actor:start_quest("megalith_quest")
    wait(2)
    self:say("May the Goddess smile upon you!")
    wait(1)
    self.room:send(tostring(self.name) .. " says, 'First, I'll need your help replacing the <b:cyan>implements</> destroyed in the maze getting here.'")
    -- 
    -- If restarting
    -- 
elseif actor:get_has_failed("megalith_quest") then
    actor:restart_quest("megalith_quest")
    self.room:send("</>")
    self:command("smile")
    self:say("Then let us give it another go!")
    -- (empty room echo)
    self.room:send(tostring(self.name) .. " says, 'Some of our <b:cyan>implements</> were destroyed in our previous attempt.'")
end
-- 
-- List tools for stage 1
-- 
if actor:get_quest_stage("megalith_quest") == 1 then
    wait(2)
    self.room:send(tostring(self.name) .. " says, 'We need the following:")
    self.room:send("- <b:white>Salt</>.")
    -- (empty room echo)
    self.room:send("- A <b:cyan>goblet or chalice</> to hold water.")
    self.room:send("</>    My home island in the Green Green Sea has several goblets, though do be")
    self.room:send("</>    careful which one you pick.  Some of them tend to be poisoned.")
    -- (empty room echo)
    self.room:send("</>    I understand there is a beautiful chalice recently lost from the Abbey of")
    self.room:send("</>    St. George that might work as well.")
    -- (empty room echo)
    self.room:send("- Some kind of <yellow>censer</> to burn incense in.")
    self.room:send("</>    There are a few other more nefarious religions which use incense burners in")
    self.room:send("</>    their rituals.  You may be able to steal one from them.")
    -- (empty room echo)
    self.room:send("- A <b:red>candle</>.")
    self.room:send("</>    Candles are common to light the dark in the far north, and in some")
    self.room:send("</>    underground communities.'")
    wait(6)
    self:say("Bring these to me to begin the Great Rite!")
    wait(1)
    self.room:send(tostring(self.name) .. " says, 'If you want to know more about what my Sisters and I are doing, you can ask any of us <b:cyan>who are you?</>'")
    wait(1)
    self.room:send(tostring(self.name) .. " says, 'If you need a reminder of your <b:cyan>[progress]</>, you may ask me at any time.'")
    self:command("bow " .. tostring(actor.name))
    -- 
    -- If ready to continue stage 4
    -- 
elseif actor:get_quest_stage("megalith_quest") and self.room.zone_id == 123 and self.room.local_id == 89 and actor:get_quest_var("megalith_quest:reliquary") == 1 then
    wait(2)
    self:say("The Great Rite of Invocation has a great deal of call and response.  I will chant a line and you must repeat it to continue the ritual.  The coven will chant their response after you do.")
    wait(4)
    self:say("Repeat after me.")
    wait(2)
    self:emote("raises her arms to the sky.")
    self.room:send(tostring(self.name) .. " chants, '<b:cyan>Great Lady of the Stars, hear our prayer!</>'")
    actor:set_quest_var("megalith_quest", "prayer", 1)
end$trig$, 'ff09b3cd185103cb57b392e54f3d16fc'),
  -- data/triggers/123/123_07_megalith_quest_priestess_speech_stage2.lua
  (123, 7, $trig$-- Converted from DG Script #12307: megalith_quest_priestess_speech_stage2
-- Original: MOB trigger, flags: SPEECH, SPEECH_TO, num_arg: 1 (DG word-list mode, not a probability)

-- DG word list (num_arg 1): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"under"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
-- Preset item vars
local item = 0
local speech1 = "Under the watchful eye of Earth, Air, Fire, and Water, we awaken this hallowed ground!"
local speech2 = "Under the watchful eye of Earth Air Fire and Water we awaken this hallowed ground"
local speech3 = "Under the watchful eye of Earth Air Fire and Water we awaken this hallowed ground!"
local speech4 = "Under the watchful eye of Earth, Air, Fire, and Water, we awaken this hallowed ground"
local item1 = actor:get_quest_var("megalith_quest:item1")
local item2 = actor:get_quest_var("megalith_quest:item2")
local item3 = actor:get_quest_var("megalith_quest:item3")
local item4 = actor:get_quest_var("megalith_quest:item4")
if speech == speech1 or speech == speech2 or speech == speech3 or speech == speech4 then
    if actor:get_quest_stage("megalith_quest") == 2 then
        if item1 and item2 and item3 and item4 then
            actor:advance_quest("megalith_quest")
            -- Reset quest 'item' variables
            for slot = 1, 5 do
                actor:set_quest_var("megalith_quest", "item" .. tostring(slot), 0)
            end
            wait(1)
            self.room:send("<b:white>The menhir begin to hum with deep chthonic harmonics.</>")
            wait(3)
            self:say("It's working!  I can feel the energies of the stones returning to life.")
            wait(1)
            self:emote("closes her eyes and basks in the chthonic resonance.")
            wait(3)
            self:emote("opens her eyes, invigorated.")
            self:say("We're so close to success!")
            wait(3)
            self.room:send(tostring(self.name) .. " says, 'With the circle cast and the land prepared, I require three holy <b:cyan>reliquaries</> to summon our Goddess.'")
        end
    end
end$trig$, 'c5a06bdf13b065f46efd69861237098f'),
  -- data/triggers/123/123_08_megalith_quest_priestess_speech_stage3.lua
  (123, 8, $trig$-- Converted from DG Script #12308: megalith_quest_priestess_speech_stage3
-- Original: MOB trigger, flags: SPEECH, SPEECH_TO, num_arg: 1 (DG word-list mode, not a probability)

-- DG word list (num_arg 1): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"reliquaries", "reliquaries?"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
if actor:get_quest_stage("megalith_quest") == 3 then
    wait(2)
    self:say("Indeed.  Sources of divine power to guide the Invocation:")
    self.room:send("</>")
    self.room:send("- A <b:yellow>prayer bowl</> to scry upon and pierce through the veil between the worlds.")
    self.room:send("</>    I believe greater Celestials bring such things from the Outer Planes.")
    self.room:send("</>")
    self.room:send("- An <b:yellow>icon to represent the divine feminine</>.")
    self.room:send("</>    Any piece of the sacred regalia of another Goddess would be an appropriate")
    self.room:send("</>    icon.")
    self.room:send("</>")
    self.room:send("- Something to represent Her fey nature.")
    self.room:send("</>    There are several <b:yellow>faerie relics</> where the King of Dreams' realm has fused")
    self.room:send("</>    with ours.  I believe any of them will do.")
    -- (empty room echo)
    self:say("Bring me these and we shall perform the Invocation!")
end$trig$, 'a87789dc782289c688ef1adcaf8c5de4'),
  -- data/triggers/123/123_09_megalith_quest_priestess_speech_invocation1.lua
  (123, 9, $trig$-- Converted from DG Script #12309: megalith_quest_priestess_speech_invocation1
-- Original: MOB trigger, flags: SPEECH, SPEECH_TO, num_arg: 1 (DG word-list mode, not a probability)

-- DG word list (num_arg 1): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"great"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
local speech1 = "great lady of the stars hear our prayer"
local speech2 = "great lady of the stars, hear our prayer"
local speech3 = "great lady of the stars, hear our prayer!"
local stage = actor:get_quest_stage("megalith_quest")
if speech == speech1 or speech == speech2 or speech == speech3 then
    if (stage == 4) and (self.room.zone_id == 123 and self.room.local_id == 89) and (actor:get_quest_var("megalith_quest:prayer") == 1) then
        run_room_trigger(123, 17)
        wait(5)
        self.room:send(tostring(self.name) .. " chants:")
        self.room:send("</>'We call you from the realm behind")
        self.room:send("</>One adrift beyond space and time.")
        -- (empty room echo)
        self.room:send("</>Ringing now the bell in three")
        self.room:send("</>Hear our prayer")
        self.room:send("</><b:cyan>We summon and stir thee</>!'")
        actor:set_quest_var("megalith_quest", "prayer", 2)
        actor:set_quest_var("megalith_quest", "summon", 1)
    end
end$trig$, '8809d742ab4b0ed73f4f289d19945514'),
  -- data/triggers/123/123_12_megalith_quest_priestess_speech_progress.lua
  (123, 12, $trig$-- Converted from DG Script #12312: megalith_quest_priestess_speech_progress
-- Original: MOB trigger, flags: SPEECH, num_arg: 1 (DG word-list mode, not a probability)

-- DG word list (num_arg 1): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"status", "status?", "progress", "progress?"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
local _return_value = true  -- Default: allow action
wait(2)
-- Make sure you're on the quest.
if actor:get_quest_stage("megalith_quest") < 1 then
    return _return_value
end
if actor:get_has_completed("megalith_quest") then
    self:say("We give thanks for your help in completing our summoning ritual.")
    wait(2)
    self:say("Blessed be!")
    return _return_value
end
if actor:get_has_failed("megalith_quest") then
    self:say("Sadly we failed in our efforts to invoke " .. tostring(mobiles.template(123, 0).name) .. "...")
    wait(2)
    self:say("Would you like to try again?")
    return _return_value
end
-- Hoisted locals (branch-scoped in the converter output, used after the
-- if/elseif chain).
local step
local item1, item2, item3, item4
local receive1, receive2, receive3, receive4, receive5
local stage = actor:get_quest_stage("megalith_quest")
if stage == 1 then
    step = "replacing the sacred prophetic implements"
    -- salt 23756
    item1 = "salt"
    -- Goblet or chalice 41110 or 41111 or 18512
    item2 = "a goblet or chalice"
    -- censer 8507 or 17300
    item3 = "a censer"
    -- candles 8612 or 58809
    item4 = "candles"
    -- give to the priestess
    receive5 = 12301
    actor:send(tostring(self.name) .. " says, 'I need your help " .. tostring(step) .. ".'")
elseif stage == 2 then
    -- Must be done East South West North.
    step = "call the elements"
    -- thin sheet of cloud to Keeper of the East
    receive1 = mobiles.template(123, 5).name
    item1 = objects.template(83, 1).name
    -- the fiery eye to Keeper of the South
    receive2 = mobiles.template(123, 4).name
    item2 = objects.template(481, 9).name
    -- granite ring to Keeper of the North
    receive3 = mobiles.template(123, 3).name
    item3 = objects.template(550, 20).name
    -- water from room 12463 to Keeper of the West
    receive4 = mobiles.template(123, 6).name
    item4 = "water from " .. tostring(objects.template(123, 52).name)
    wait(2)
    actor:send(tostring(self.name) .. " says, 'We're trying to " .. tostring(step) .. ".'")
    if (actor:get_quest_var("megalith_quest:item1")) and (actor:get_quest_var("megalith_quest:item2")) and (actor:get_quest_var("megalith_quest:item3")) and (actor:get_quest_var("megalith_quest:item4")) then
        self.room:send(tostring(self.name) .. " says, 'We're ready to finish calling the elements!")
        self.room:send("</>If you wish to proceed, repeat after me:'")
        self.room:send("<b:white>Under the watchful eye of Earth, Air, Fire, and Water, we awaken this")
        self.room:send("</>hallowed ground!</>")
        return _return_value
    end
elseif stage == 3 then
    step = "locate three reliquaries"
    receive5 = 12301
    item1 = "a holy prayer bowl"
    item2 = "a piece of a goddess's regalia"
    item3 = "a faerie relic from the land of the Reverie made manifest"
    actor:send(tostring(self.name) .. " says, 'We need to <b:yellow>" .. tostring(step) .. "</>.'")
elseif stage == 4 then
    self.room:send(tostring(self.name) .. " says, 'I've been awaiting your return!  Let us")
    self.room:send("</>perform the Great Rite of Invocation! Repeat after me:'")
    self.room:send("<b:white>Great Lady of the Stars, hear our prayer!</>")
    return _return_value
else
    return _return_value
end
-- list items already given
if actor:get_quest_var("megalith_quest:item1") ~= 1 or actor:get_quest_var("megalith_quest:item2") ~= 1 or actor:get_quest_var("megalith_quest:item3") ~= 1 or actor:get_quest_var("megalith_quest:item4") ~= 1 then
    actor:send("You have already retrieved:")
end
if item1 and actor:get_quest_var("megalith_quest:item1") ~= 1 then
    actor:send("- <b:white>" .. tostring(item1) .. "</>")
end
if item2 and actor:get_quest_var("megalith_quest:item2") ~= 1 then
    actor:send("- <b:white>" .. tostring(item2) .. "</>")
end
if item3 and actor:get_quest_var("megalith_quest:item3") ~= 1 then
    actor:send("- <b:white>" .. tostring(item3) .. "</>")
end
if item4 and actor:get_quest_var("megalith_quest:item4") ~= 0 then
    actor:send("- <b:white>" .. tostring(item4) .. "</>")
end
-- list items to be returned
if stage ~= 4 then
    actor:send("We still need:")
end
if stage == 2 and actor:get_quest_var("megalith_quest:item1") ~= 0 then
    actor:send("to assist <b:white>" .. tostring(receive1) .. "</>.")
    if actor:get_quest_var("megalith_quest:east") ~= 1 then
        actor:send("She needs " .. tostring(item1))
    else
        actor:send("Please check with her to see what she needs.")
    end
elseif item1 and actor:get_quest_var("megalith_quest:item1") ~= 0 then
    actor:send("<b:white>" .. tostring(item1) .. "</>")
end
if stage == 2 and actor:get_quest_var("megalith_quest:item2") ~= 0 then
    actor:send("to assist <b:red>" .. tostring(receive2) .. "</>.")
    if actor:get_quest_var("megalith_quest:south") ~= 1 then
        actor:send("She needs " .. tostring(item2))
    else
        actor:send("Please check with her to see what she needs.")
    end
elseif item2 and actor:get_quest_var("megalith_quest:item2") ~= 0 then
    actor:send("<b:white>" .. tostring(item2) .. "</>")
end
if stage == 2 and actor:get_quest_var("megalith_quest:item3") ~= 0 then
    actor:send("to assist <b:green>" .. tostring(receive3) .. "</>.")
    if actor:get_quest_var("megalith_quest:north") ~= 1 then
        actor:send("She needs " .. tostring(item3))
    else
        actor:send("Please check with her to see what she needs.")
    end
elseif item3 and actor:get_quest_var("megalith_quest:item3") ~= 0 then
    actor:send("<b:white>" .. tostring(item3) .. "</>")
end
if stage == 2 and actor:get_quest_var("megalith_quest:item4") ~= 0 then
    actor:send("to assist <b:cyan>" .. tostring(receive4) .. "</>.")
    if actor:get_quest_var("megalith_quest:west") ~= 1 then
        actor:send("She needs " .. tostring(item4))
    else
        actor:send("Please check with her to see what she needs.")
    end
elseif stage == 1 and item4 and actor:get_quest_var("megalith_quest:item4") == 0 then
    actor:send("<b:white>" .. tostring(item4) .. "</>")
end
if receive5 then
    actor:send(tostring(self.name) .. " says, 'Please bring these to me.'")
end
return _return_value$trig$, '7ac9c80ef0f7d19f5bf771ede28c96df'),
  -- data/triggers/123/123_14_megalith_quest_keeper_speech.lua
  (123, 14, $trig$-- Converted from DG Script #12314: megalith_quest_keeper_speech
-- Original: MOB trigger, flags: SPEECH, SPEECH_TO, num_arg: 1 (DG word-list mode, not a probability)

-- DG word list (num_arg 1): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"yes", "sure", "no", "i"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
wait(2)
if actor:get_quest_stage("megalith_quest") == 2 then
    if speech == "yes" or speech == "sure" or string.find(speech, "I will") or string.find(speech, "I can") then
        -- switch on self.id
        -- 
        -- North - get ring from Tech
        -- 
        if actor:get_quest_var("megalith_quest:north") == 0 then
            if (self.zone_id == 123 and self.id == 3) then
                self:say("Thank you very kindly.")
                wait(5)
                self.room:send(tostring(self.name) .. " says, 'Far to the north, there is a civilization dedicated to the Great Snow Leopard.  There, they make <green>rings of simple granite</> which grant their constructs powerful mystic protection.  Such energies should make an ideal offering to the Earth Spirits.  Please retrieve one for me.'")
                wait(6)
                self.room:send(tostring(self.name) .. " says, 'Remember, we must call the elements in order:")
                self.room:send("</><b:yellow>East</>, <red>South</>, <b:cyan>West</>, <b:green>North</>")
                self.room:send("</>so please start with <b:yellow>" .. tostring(mobiles.template(123, 5).name) .. "</>.'")
                self:command("bow " .. tostring(actor.name))
                actor:set_quest_var("megalith_quest", "north", 1)
                return _return_value
            end
            -- 
            -- South - Fiery Eye from Vulcera
            -- 
            if actor:get_quest_var("megalith_quest:south") == 0 then
            elseif (self.zone_id == 123 and self.id == 4) then
                self:say("Excellent.")
                wait(4)
                self.room:send(tostring(self.name) .. " says, 'There is an island in the sea where fires of the deep meet the outer world, ruled by a demigoddess.  My people know her magic to be the ultimate blending of divine spark and protean fire.  She carries <b:red>a jewel that burns with that same fire</>.  If you can retrieve it, I believe that would be the perfect offering to the Spirits of Fire.'")
                actor:set_quest_var("megalith_quest", "south", 1)
                wait(4)
                self.room:send(tostring(self.name) .. " says, 'Remember, we must call the elements in order:")
                self.room:send("</><b:yellow>East</>, <red>South</>, <b:cyan>West</>, <b:green>North</>")
                self.room:send("</>So please start with <b:yellow>" .. tostring(mobiles.template(123, 5).name) .. "</>.'")
                wait(2)
                self:command("nod " .. tostring(actor.name))
                self:say("Good hunting.")
                return _return_value
            end
            -- 
            -- East - cumulus bracelet
            -- 
            if actor:get_quest_var("megalith_quest:east") == 0 then
            elseif (self.zone_id == 123 and self.id == 5) then
                self:say("Hurray!")
                self:command("clap")
                wait(1)
                self:say("There are a handful of places in the world where the clouds reach from the ground to the heavens.  One such place is the home to an ancient silver dragon.")
                wait(1)
                self:command("laugh")
                self:say("Don't worry, you don't need to mess with him on my behalf.")
                wait(2)
                self:say("His guardians on the other hand...")
                self:command("grin")
                wait(4)
                self.room:send(tostring(self.name) .. " says, 'Some carry <b:white>cumulus cloud bracelets</>.  If you can get your hands on one, it'll boost my call to the Air Spirits right through the stratosphere!'")
                wait(6)
                self.room:send(tostring(self.name) .. " says, 'Remember, we have to cast in order:")
                self.room:send("</></><b:yellow>East</>, <red>South</>, <b:cyan>West</>, <b:green>North</>")
                self.room:send("</>So when you return the offerings, please start with <b:yellow>me</>!'")
                actor:set_quest_var("megalith_quest", "east", 1)
                wait(5)
                self:say("Why are you still standing here?!")
                wait(2)
                self:say("Go!  Go!")
                return _return_value
            end
            -- 
            -- West - Spring Water
            -- 
            if actor:get_quest_var("megalith_quest:west") == 0 then
            elseif (self.zone_id == 123 and self.id == 6) then
                self:say("Wonderful!")
                wait(2)
                self:say("As a creature of the Dreaming, my magic is especially fueled by energies that thin the veil between the worlds.")
                wait(3)
                self.room:send(tostring(self.name) .. " says, 'My faerie sisters have told me there is a <b:cyan>hidden spring in the surrounding forest</>.  Over the ages, it has absorbed the gentle radiance of the moon, making it ideally sympathetic with the power of the Reverie.  Even the waters from my home in the Kingdom of Dreams would pale in comparison!'")
                wait(6)
                self.room:send(tostring(self.name) .. " says, 'Please, take the cup you gave to the priestess, <b:cyan>fill it with water from that spring</>, and bring it back with water for me to offer the Spirits of the West.'")
                wait(6)
                self:command("ponder")
                self:say("Although this spring sounds ideal, I suppose any water will do.")
                actor:set_quest_var("megalith_quest", "west", 1)
                wait(3)
                self.room:send(tostring(self.name) .. " says, 'Remember, we must call the elements in order:")
                self.room:send("</><b:yellow>East</>, <red>South</>, <b:cyan>West</>, <b:green>North</>")
                self.room:send("</>So please start with <b:yellow>" .. tostring(mobiles.template(123, 5).name) .. "</>.'")
                self:command("curtsy " .. tostring(actor.name))
                return _return_value
            end
        end
    elseif speech == "no" then
        wait(2)
        self:command("shrug")
        self:say("Alright then.")
    end
end$trig$, '1c0752759cc5c774066e60fb5afa34f3'),
  -- data/triggers/123/123_26_witch_priestess_exposition.lua
  (123, 26, $trig$-- Converted from DG Script #12326: witch_priestess_exposition
-- Original: MOB trigger, flags: SPEECH, SPEECH_TO, num_arg: 1 (DG word-list mode, not a probability)

-- DG word list (num_arg 1): the speech must contain one of these as a whole word or phrase.
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
    wait(2)
    if actor:get_quest_var("megalith_quest:hexpo") == 0 then
        self:say("I am the high priestess of a sacred sisterhood of witches dedicated to the worship of the faerie goddess the Great Mother, Lady of Stars.")
        wait(4)
        self:say("We strive to keep the Old Ways alive, as our foremothers did, and their foremothers before them, and their foremothers before them, back through the centuries.")
        wait(2)
        self.room:send(tostring(self.name) .. " says, 'Say <b:cyan>continue</> when you want to hear more.'")
        actor:set_quest_var("megalith_quest", "hexpo", 1)
    elseif actor:get_quest_var("megalith_quest:hexpo") == 1 then
        self:say("Witchcraft has always been in my blood.")
        wait(2)
        self:say("The people of my homeland in the Green Green Sea still observe the Old Ways.  The Fair Folk still walk among us.  A bocan hobgoblin or two playing tricks on you is part of our daily routine.  Every woman in the village knows how to mix herbs and what to do when you see a ghost.")
        wait(4)
        self:say("I was, and still am, nothing special.")
        wait(2)
        self.room:send(tostring(self.name) .. " says, 'Say <b:cyan>continue</> when you want to hear more.'")
        actor:set_quest_var("megalith_quest", "hexpo", 2)
    elseif actor:get_quest_var("megalith_quest:hexpo") == 2 then
        self:say("Then I heard the call.")
        wait(2)
        self:say("Nightly dreams led me on a global pilgrimage.  I found myself seeking out clandestine lore and lost secrets from a myriad of other traditions.")
        wait(4)
        self:say("I trained under the Priests of Mielikki.")
        wait(3)
        self:say("I was honored with a meeting for tea with the Hierophant of the Highlands.")
        wait(3)
        self:say("I've read the texts of Seblan, and the Enchiridion.")
        wait(3)
        self:say("I even learned a thing or two from the lizard shamans in the Northern Swamps.")
        wait(3)
        self:say("And after many years, I returned home where the Great Mother revealed herself to me.")
        wait(2)
        self.room:send(tostring(self.name) .. " says, 'Say <b:cyan>continue</> when you want to hear more.'")
        actor:set_quest_var("megalith_quest", "hexpo", 3)
    elseif actor:get_quest_var("megalith_quest:hexpo") == 3 then
        self:say("She charged me with seeking out this coven.  I dedicated myself to Her service and through years of loving care and gentle insight, I have become Her priestess as we push to revitalize the Old Ways.")
        wait(2)
        self.room:send(tostring(self.name) .. " says, 'Say <b:cyan>continue</> when you want to hear more.'")
        actor:set_quest_var("megalith_quest", "hexpo", 4)
    elseif actor:get_quest_var("megalith_quest:hexpo") == 4 then
        self:say("Like myself, my Sisters hail from every corner of Ethilien.")
        wait(2)
        self:say("Some are just women called to our coven to provide succor to others.")
        wait(3)
        self:say("Others have more... unusual stories which have led them to the Faerie Mother.")
        wait(3)
        self.room:send(tostring(self.name) .. " says, 'Yet today, we have all come to this place to <b:cyan>perform the Great Rite of Invocation.</>'")
        actor:set_quest_var("megalith_quest", "hexpo", 0)
    end
end$trig$, '92a35de8cc570c426d9521af1c87de90'),
  -- data/triggers/125/125_10_unused_trigger.lua
  (125, 10, $trig$-- Converted from DG Script #12510: Unused trigger?
-- Original: OBJECT trigger, flags: WEAR, num_arg: 63 (no chance roll in legacy)

actor:award_exp(-100000)
actor:send("As you grab the fist, you feel a slight jolt, and feel your life force being drained.")$trig$, '5b80c7047190c8b80dab5b6372135361'),
  -- data/triggers/185/185_02_quest_preamble_silania.lua
  (185, 2, $trig$-- DG word list (num_arg 1): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"destiny", "destiny?", "destinies", "destinies?", "i"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
local s = string.lower(speech)
if not (string.find(s, "destiny") or string.find(s, "destinies") or string.find(s, "i know")) then
    return true
end

if actor:get_quest_stage("pri_pal_subclass") then
    return true
end

-- Level/race gating per class.
local classquest = false
if string.find(actor.class, "Cleric") then
    if actor.level >= 10 and actor.level <= 35 then
        if actor.race == "drow" or actor.race == "faerie_unseelie" then
            actor:send("<red>Your race may not subclass to priest.</>")
            return true
        end
        classquest = true
    end
elseif string.find(actor.class, "Warrior") then
    if actor.level >= 10 and actor.level <= 25 then
        if actor.race == "drow" or actor.race == "faerie_unseelie" then
            actor:send("<red>Your race may not subclass to paladin.</>")
            return true
        end
        classquest = true
    end
else
    if actor.level >= 10 and actor.level <= 25 then
        actor:send(tostring(self.name) .. " says, 'Sorry, I cannot help you achieve your destiny.'")
    end
    return true
end

wait(2)

if not classquest then
    return true
end

if globals.use_subclass then
    actor:send(tostring(self.name) .. " says, 'I am currently helping another supplicant, one moment my child.'")
    return true
end

if actor.alignment <= 349 then
    actor:send(tostring(self.name) .. " says, 'I cannot help you if you are not good, little one.'")
    return true
end

if string.find(actor.class, "Warrior") and actor.level >= 10 and actor.level <= 25 then
    self:command("nod " .. tostring(actor.name))
    actor:send(tostring(self.name) .. " says, 'Do ye wish to join the ranks of the holy warriors?'")
    globals.use_subclass = "Pal"
elseif string.find(actor.class, "Cleric") and actor.level >= 10 and actor.level <= 35 then
    self:command("nod " .. tostring(actor.name))
    actor:send(tostring(self.name) .. " says, 'Do ye wish to join the ranks of the priests and help drive darkness from our world?'")
    globals.use_subclass = "Pri"
elseif actor.level < 10 then
    actor:send(tostring(self.name) .. " says, 'I appreciate your aspiring virtue.  Come and see me once you've gained more experience.'")
else
    actor:send(tostring(self.name) .. " says, 'You are already following your destiny.  I cannot help you any further.'")
end$trig$, '54204fe8cd1cc6120d395500fc18bc51'),
  -- data/triggers/185/185_17_group_heal_doctor_speech1.lua
  (185, 17, $trig$-- DG word list (num_arg 1): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"healing", "healing?", "group", "assist?"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
local s = string.lower(speech)
if not (string.find(s, "healing") or string.find(s, "group") or string.find(s, "assist")) then
    return true
end
wait(2)
self:command("nod")
self.room:send(tostring(self.name) .. " says, 'I specialize in group healing.  It's a powerful spell")
self.room:send("</>involving complex prayers.  Not easy to learn.'")
if ((string.find(actor.class, "Cleric") or string.find(actor.class, "Priest") or string.find(actor.class, "Diabolist")) and actor.level > 56) and actor:get_quest_stage("group_heal") == 0 then
    wait(3)
    self.room:send(tostring(self.name) .. " says, 'But you look like a very capable healer!  Perhaps you can")
    self.room:send("</>help me out.'")
    wait(3)
    self.room:send(tostring(self.name) .. " says, 'I've heard there once was a way to create a portable")
    self.room:send("</>version of the spell.  I've been trying to figure it out, but most of my time")
    self.room:send("</>is spent tending to the abbey's injured.'")
    wait(4)
    self.room:send(tostring(self.name) .. " says, 'Raiders from Split Skull and bandits from the Gothra Desert")
    self.room:send("</>have made it very difficult to get anything done around here!'")
    wait(3)
    self.room:send(tostring(self.name) .. " says, 'If you can help me work on it, I can teach you the proper")
    self.room:send("</>prayers in exchange.'")
    wait(3)
    self:say("What do you say, are you interested in working with me?")
end$trig$, 'f4e2e4aafc267d066e19d7d66ece9ebd'),
  -- data/triggers/185/185_18_group_heal_doctor_speech2.lua
  (185, 18, $trig$-- DG word list (num_arg 1): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"yes", "yes!", "yep", "yep!", "okay", "sure"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
wait(2)
if ((string.find(actor.class, "Cleric") or string.find(actor.class, "Priest") or string.find(actor.class, "Diabolist")) and actor.level > 56) and actor:get_quest_stage("group_heal") == 0 then
    actor:start_quest("group_heal")
    self:say("Thank you so much!")
    wait(1)
    self:say("There is an immediate problem I need your help with.")
    wait(2)
    self.room:send(tostring(self.name) .. " says, 'A shipment of medical supplies was coming to us from Anduin")
    self.room:send("</>via the Black Rock Trail.  Unfortunately the transport was robbed and the")
    self.room:send("</>entire shipment was stolen by bandits.'")
    wait(4)
    self.room:send(tostring(self.name) .. " says, 'The few who survived said a fierce bandit raider attacked")
    self.room:send("</>their wagon and headed off into the desert with their belongings.  They said")
    self.room:send("</>he fought like nothing they had ever seen before.  Some kind of frenzy of")
    self.room:send("</>swords and daggers.'")
    wait(6)
    self.room:send(tostring(self.name) .. " says, 'Please, do whatever you need to recover those supplies and")
    self.room:send("</>bring them to me.'")
    if world.count_mobiles(185, 22) == 0 then
        get_room(11, 0):at(function()
            self.room:spawn_mobile(185, 22)
        end)
        get_room(11, 0):at(function()
            self.room:spawn_object(161, 6)
        end)
        get_room(11, 0):at(function()
            self.room:spawn_object(161, 6)
        end)
        get_room(11, 0):at(function()
            self:command("give scimitar bandit")
        end)
        get_room(11, 0):at(function()
            self:command("give scimitar bandit")
        end)
        get_room(11, 0):at(function()
            self.room:find_actor("bandit"):command("wear all")
        end)
        get_room(11, 0):at(function()
            self.room:find_actor("bandit"):teleport(get_room(161, 86))
        end)
    elseif actor:get_quest_stage("group_heal") == 3 or actor:get_quest_stage("group_heal") == 4 then
        self:say("May I see them please?")
    elseif actor:get_quest_stage("group_heal") == 5 then
        self:say("May I see what they have to say?")
    end
end$trig$, 'c33bb56b616176b8a63e9a2d9cb24a0a'),
  -- data/triggers/188/188_83_test.lua
  (188, 83, $trig$-- DG word list (num_arg 1): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"eval"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
self.room:send("(debug) speech received: " .. tostring(speech))$trig$, '93b8b231633e10125d750881782b5108'),
  -- data/triggers/324/324_02_north_road_bribe1.lua
  (324, 2, $trig$-- Converted from DG Script #32402: North_Road_bribe1
-- Original: MOB trigger, flags: BRIBE, num_arg: 1 (minimum bribe in copper)

self:say("My trigger commandlist is not complete!")$trig$, '1dcf18602f2e18cd0248449c57ccfcfa'),
  -- data/triggers/324/324_13_kerristone_north_trainer_bribemg.lua
  (324, 13, $trig$-- Converted from DG Script #32413: Kerristone_north_trainer_bribeMG
-- Original: MOB trigger, flags: BRIBE, num_arg: 42 (minimum bribe in copper)

-- DG BRIBE num_arg 42: fires only when the coins are worth at least 42 copper.
if (value or 0) < 42 then
    return true
end
-- This is one of the bribe progs that will
-- let players buy a horse to bolt to Mugnork
-- The horse trigs have been altered in concept
-- on how they deliver the players to the destination
-- but there's no reason why this trig can't exist
-- as is to kick it off
if actor.is_player then
    wait(1)
    self.room:send(tostring(self.name) .. " says, '</>Ahh Thankyou! You will not be disappointed.</>'")
    self.room:send(tostring(self.name) .. " says, '</>I have one of the fastest </><blue>&9stallions</> in the land for you!'")
    wait(2)
    self.room:send("</>A <yellow>horse</> trainer leads a fine looking <blue>&9stallion</> into the room.")
    self.room:spawn_mobile(324, 23)
    wait(2)
    self.room:send("</>A horse trainer gets under you and pushes you up into the saddle.</>")
    self.room:spawn_object(324, 25)
    self.room:send(tostring(self.name) .. " says, 'Feed him this <red>strawberry</> and he will know that you want to go to <b:cyan>Mugnork</>.'")
    self:command("give strawberry " .. tostring(actor.name))
    wait(2)
    self.room:send("</>A <yellow>horse</> trainer forces your hand towards the mouth of the horse.")
    actor:command("give strawberry stallion")
    self.room:send(tostring(self.name) .. " says, 'Good journey!'")
end$trig$, '897743079ea2b84fb835e118141df385'),
  -- data/triggers/324/324_14_kerristone_north_trainer_bribe_mh.lua
  (324, 14, $trig$-- Converted from DG Script #32414: Kerristone_north_trainer_bribe_mh
-- Original: MOB trigger, flags: BRIBE, num_arg: 30 (minimum bribe in copper)

-- DG BRIBE num_arg 30: fires only when the coins are worth at least 30 copper.
if (value or 0) < 30 then
    return true
end
-- This is one of the bribe trigs that will
-- let a player buy a horse to take them to
-- morgan hill.  The horse portion will change
-- radically from the prog format but will
-- achieve the same goals.
if actor.is_player then
    wait(1)
    self.room:send(tostring(self.name) .. " says, 'Ahh Thankyou! You will not be disappointed.'")
    self.room:send(tostring(self.name) .. " says, 'I have one of the fastest horses in the land for you!'")
    wait(2)
    self.room:send("</>The <yellow>horse</> trainer leads a fine looking horse into the room.</>")  -- from MPROG
    self.room:spawn_mobile(324, 21)
    self.room:send("</>The <yellow>horse</> trainer gets under you and pushes you up into the saddle.</>")
    wait(2)
    self.room:spawn_object(324, 21)
    self.room:send(tostring(self.name) .. " says, '</>Feed him this </><yellow>carrot</> and he will know that you want to go to Morgan Hill.</>'")
    self:command("give carrot " .. tostring(actor.name))
    self.room:send("</>The <yellow>horse</> trainer forces your hand towards the mouth of the <yellow>horse</>.")
    wait(2)
    self.room:send(tostring(self.name) .. " says, 'Good journey!'")
end$trig$, '3a3e8ebe2ea6e174bb7610fae65372c4'),
  -- data/triggers/370/370_05_cirion_speech1.lua
  (370, 5, $trig$-- Converted from DG Script #37005: Cirion_speech1
-- Original: MOB trigger, flags: SPEECH, num_arg: 1 (DG word-list mode, not a probability)

-- DG word list (num_arg 1): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"slaves", "slaves?"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
self.room:send_except(actor, tostring(self.name) .. " speaks to " .. tostring(actor.name) .. " in a low voice.")
actor:send(tostring(self.name) .. " says to you, 'Our bodies are getting old, and are starting to decay, but'")
actor:send(tostring(self.name) .. " says to you, 'our minds and souls are still strong. Now he can kill us,'")
actor:send(tostring(self.name) .. " says to you, 'and set our spirits free. Freedom here I come!'")
self:command("thank " .. tostring(actor.name))$trig$, '743a28213ba1183a467e51de8bbef5ae'),
  -- data/triggers/370/370_06_cirion_speech2.lua
  (370, 6, $trig$-- Converted from DG Script #37006: Cirion_speech2
-- Original: MOB trigger, flags: SPEECH, num_arg: 1 (DG word-list mode, not a probability)

-- DG word list (num_arg 1): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"summon", "summoned"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
self.room:send_except(actor, tostring(self.name) .. " speaks to " .. tostring(actor.name) .. " in a low voice.")
actor:send(tostring(self.name) .. " says to you, 'Don't think you came here on your own free will.'")
actor:send(tostring(self.name) .. " says to you, 'If you do then you are only deceiving yourself even more.'")
actor:send(tostring(self.name) .. " says to you, 'Mesmeriz brought you here.'")$trig$, '4a5e09935c8f0253508a559067f62a43'),
  -- data/triggers/370/370_08_minithawk_messenger_speech1.lua
  (370, 8, $trig$-- Converted from DG Script #37008: Minithawk_messenger_speech1
-- Original: MOB trigger, flags: SPEECH, num_arg: 1 (DG word-list mode, not a probability)

-- DG word list (num_arg 1): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"killed", "killed?"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
self.room:send_except(actor, tostring(self.name) .. " speaks to " .. tostring(actor.name) .. " in a low voice.")
actor:send(tostring(self.name) .. " says to you, 'Yes, killed...as in dead.  Mesmeriz would have my head if he'")
actor:send(tostring(self.name) .. " says to you, 'knew I were talking to you.  His direct orders were for me to'")
actor:send(tostring(self.name) .. " says to you, 'go to Templace, and deliver this rock.'")$trig$, '28b14799fb4fc17c4cadd6ef6d79c9b8'),
  -- data/triggers/370/370_10_minithawk_messenger_speech2.lua
  (370, 10, $trig$-- Converted from DG Script #37010: Minithawk_messenger_speech2
-- Original: MOB trigger, flags: SPEECH, num_arg: 1 (DG word-list mode, not a probability)

-- DG word list (num_arg 1): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"north", "east", "south", "west"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
self.room:send_except(actor, tostring(self.name) .. " speaks to " .. tostring(actor.name) .. " in a low voice.")
actor:send(tostring(self.name) .. " says to you 'Thank you very much!  Now if I could just find a way out of this mine!'")$trig$, '266b109017e350775708f0b9eab7f587'),
  -- data/triggers/370/370_11_minithawk_messenger_speech3.lua
  (370, 11, $trig$-- Converted from DG Script #37011: Minithawk_messenger_speech3
-- Original: MOB trigger, flags: SPEECH, num_arg: 1 (DG word-list mode, not a probability)

-- DG word list (num_arg 1): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"town", "town?"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
self.room:send_except(actor, tostring(self.name) .. " speaks to " .. tostring(actor.name) .. " in a low voice.")
actor:send(tostring(self.name) .. " says to you, 'Yes, I must go to Templace. Which way?'")$trig$, 'af27b1b7ef02346226857e233e004cb4'),
  -- data/triggers/430/430_02_demise_dying_knight_speech1.lua
  (430, 2, $trig$-- Converted from DG Script #43002: Demise_dying_knight_speech1
-- Original: MOB trigger, flags: SPEECH, num_arg: 1 (DG word-list mode, not a probability)

-- DG word list (num_arg 1): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"them"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
self:say("monsters....everywhere...too many.")
self:command("cough")$trig$, '0c3558cf5762643a5e9adcc85537a1f9'),
  -- data/triggers/430/430_03_demise_dying_knight_speech2.lua
  (430, 3, $trig$-- Converted from DG Script #43003: Demise_dying_knight_speech2
-- Original: MOB trigger, flags: SPEECH, num_arg: 1 (DG word-list mode, not a probability)

-- DG word list (num_arg 1): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"monster", "monsters"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
self:say("i am too weak")
self:say("its...look to the one who cannot...")
self:emote("spits up blood.")$trig$, 'a6cb3e2c0bc84a7bc21566dd59fae3aa'),
  -- data/triggers/430/430_04_demise_dying_knight_speech3.lua
  (430, 4, $trig$-- Converted from DG Script #43004: Demise_dying_knight_speech3
-- Original: MOB trigger, flags: SPEECH, num_arg: 1 (DG word-list mode, not a probability)

-- DG word list (num_arg 1): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"awful"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
self:emote("says, 'the blood....all the blood, the monsters.'")
self:command("cough")$trig$, '082a40d01016104cd85a8972e4fa3adb'),
  -- data/triggers/430/430_05_demise_dying_knight_speech4.lua
  (430, 5, $trig$-- Converted from DG Script #43005: Demise_dying_knight_speech4
-- Original: MOB trigger, flags: SPEECH, num_arg: 1 (DG word-list mode, not a probability)

-- DG word list (num_arg 1): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"help"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
self:command("wince")
self.room:send(tostring(self.name) .. " says, 'kill me, don't let them get me!'")
self:command("beg " .. tostring(actor.name))$trig$, '175ec4f7a479f2f278c77f90c5f52249'),
  -- data/triggers/464/464_05_angry-gardener_speech1.lua
  (464, 5, $trig$-- Converted from DG Script #46405: angry-gardener_speech1
-- Original: MOB trigger, flags: SPEECH, num_arg: 1 (DG word-list mode, not a probability)

-- DG word list (num_arg 1): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"friends"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
self:say("My friends... in the topiary.  Even took their scissors.")$trig$, '55cb9375fe7bc2f30e4a2cd04fdf1ece'),
  -- data/triggers/464/464_06_angry-gardener_speech2.lua
  (464, 6, $trig$-- Converted from DG Script #46406: angry-gardener_speech2
-- Original: MOB trigger, flags: SPEECH, num_arg: 1 (DG word-list mode, not a probability)

-- DG word list (num_arg 1): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"scissors"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
self:say("I know it was them that did it... they took his scissors and left him for dead.")$trig$, '60d66b06b83f48d3319e98a603e44e1b'),
  -- data/triggers/464/464_07_angry-gardener_speech.lua
  (464, 7, $trig$-- Converted from DG Script #46407: angry-gardener_speech
-- Original: MOB trigger, flags: SPEECH, num_arg: 1 (DG word-list mode, not a probability)

-- DG word list (num_arg 1): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"gardener"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
wait(1)
self:say("Those bastards kill them all...")
self:command("grumble")
wait(1)
self:say("One day they'll all pay for what they did to my friends.")$trig$, '59e6abcd90d44151d4f1a78237a8ad61'),
  -- data/triggers/480/480_10_prince_speak1.lua
  (480, 10, $trig$-- Converted from DG Script #48010: prince_speak1
-- Original: MOB trigger, flags: SPEECH, num_arg: 1 (DG word-list mode, not a probability)

-- DG word list (num_arg 1): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"trade?"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
if actor.alignment > 350 and actor.level > 80 then
    wait(2)
    self:say("If you bring me the head of the king's dark champion, then I will give you an item that may help you in your battle with the king.")
    wait(1)
    self:say("According to our rules of dueling, you must say 'the prince wishes to challenge you by proxy', before starting the fight.")
    wait(1)
    self:command("smile")
    self:say("That way, I can claim the victory as my own.")
end$trig$, 'c905d1e832ee8523014f2d9b963d4429'),
  -- data/triggers/480/480_11_prince_speak2.lua
  (480, 11, $trig$-- Converted from DG Script #48011: prince_speak2
-- Original: MOB trigger, flags: SPEECH, num_arg: 1 (DG word-list mode, not a probability)

-- DG word list (num_arg 1): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"destroy?"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
if actor.alignment > 350 then
    if actor.level > 80 then
        wait(2)
        self:say("Yes.  He is still alive due to his magic arts, and so he can still be killed.")
        wait(1)
        self:say("He is a coward, however, and I have heard that when the tides of battle turn against him, he is quick to disappear.")
        self:say("I may have something to help you with that if you are willing to... trade.")
    else
        wait(2)
        self:say("Sadly yes, you have come too soon.  If you are able to return once you are stronger, perhaps you can be of great assistance then.")
    end
end$trig$, 'f82ada33adca043ad4970e06d009f179'),
  -- data/triggers/480/480_12_prince_speak3.lua
  (480, 12, $trig$-- Converted from DG Script #48012: prince_speak3
-- Original: MOB trigger, flags: SPEECH, num_arg: 1 (DG word-list mode, not a probability)

-- DG word list (num_arg 1): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"failed?"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
if actor.alignment > 350 then
    wait(2)
    self:say("Yes.  I was too confident and his dark infidel champion overcame me.")
    self:command("grumble")
    wait(1)
    self:say("As a punishment, the King brought me back to life, and now I am compelled to do his bidding.")
    self:command("frown")
    if actor.level >80 then
        self:say("But you might be powerful enough to destroy him.")
    else
        self:say("It is a shame you will not be powerful enough to destroy him.")
    end
end$trig$, '068137354cfbce6692f97737db693c07'),
  -- data/triggers/480/480_13_prince_speak4.lua
  (480, 13, $trig$-- Converted from DG Script #48013: prince_speak4
-- Original: MOB trigger, flags: SPEECH, num_arg: 1 (DG word-list mode, not a probability)

-- DG word list (num_arg 1): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"help?"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
if actor.alignment > 349 then
    wait(2)
    self:command("sigh")
    self:say("Many years ago when King Ureal threatened the land, I swore that I would try to stop him.")
    wait(1)
    self:say("I was the paladin champion, and it was my duty to bring an end to his evil.")
    wait(1)
    self:emote("sighs again loudly.")
    self:say("But I failed.")
end$trig$, 'b9fe6cc9fad30d1cbe3985bc05bd6080'),
  -- data/triggers/481/481_104_jemnon_speak3.lua
  (481, 104, $trig$-- Converted from DG Script #48204: jemnon_speak3
-- Original: MOB trigger, flags: SPEECH, num_arg: 1 (DG word-list mode, not a probability)

-- DG word list (num_arg 1): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"where?", "place?", "where", "place"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
wait(2)
if actor:get_quest_stage("meteorswarm") == 1 then
    actor:advance_quest("meteorswarm")
    actor:send(tostring(self.name) .. " says, 'Ooohhhhh you wann kno wheeeeere itis?!'")
    actor:send(tostring(self.name) .. " angrily shouts, 'You outta jus' say so!!'")
    wait(2)
    self:emote("blinks drunkenly.")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'Wat wuz I sayin'?'")
    wait(1)
    actor:send(tostring(self.name) .. " says, 'Oh yeah, the ROOK MONSTER.'")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'Itz in a hole.'")
    wait(1)
    actor:send(tostring(self.name) .. " says, 'Yep.  Great big hole.'")
    wait(2)
    self:emote("becomes deathly still.")
    wait(6)
    actor:send("In a suddenly clear voice, " .. tostring(self.name) .. " speaks.  'I remember the smoke and ruins of the city. A fountain of blood gushed up from the town square.  I avoided the demons as best I could, but by accident I stumbled into a collapsed house at the end of a road...'")
    wait(2)
    self:command("shiver")
    wait(4)
    actor:send(tostring(self.name) .. " says, 'That's where I saw it, in a cave under the rubble...'")
    wait(4)
    actor:send(tostring(self.name) .. " says, 'I wish I could forget...'")
    self:command("cry")
    wait(3)
    actor:send(tostring(self.name) .. " says, 'Please, let me forget...'")
    self:emote("quickly downs another drink.")
    wait(4)
    self:command("sleep")
    wait(20)
    self:command("wake")
    self:emote("looks around very confused.")
end$trig$, 'f691fda0b42af0964c287542c1774191'),
  -- data/triggers/481/481_41_elder_woman_speak1.lua
  (481, 41, $trig$-- Converted from DG Script #48141: elder_woman_speak1
-- Original: MOB trigger, flags: SPEECH, num_arg: 1 (DG word-list mode, not a probability)

-- DG word list (num_arg 1): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"spell", "spell?", "help", "help?"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
wait(2)
local stage = 2
local person = actor
local i = person.group_size
local a
local ash
if i then
    a = 1
else
    a = 0
end
while i >= a do
    person = actor.group_member[a]
    if person.room == self.room then
        if person:get_quest_stage("fieryisle_quest") == stage then
            person:advance_quest("fieryisle_quest")
            person:send("<b:white>You have advanced your quest!</>")
            ash = 1
        elseif person:get_quest_stage("fieryisle_quest") == 3 or person:get_quest_stage("fieryisle_quest") == 4 then
            ash = 2
        end
    elseif person and person.is_player then
        i = i + 1
    end
    a = a + 1
end
if ash == 1 then
    self.room:send(tostring(self.name) .. " says, 'If you want me to help you, then you must do me a favor.  Kill the ash lord and bring me his crown.'")
    if world.count_mobiles(481, 7) < 1 then
        get_room(11, 0):at(function()
            self.room:spawn_mobile(481, 7)
        end)
        get_room(11, 0):at(function()
            self.room:find_actor("ash-lord"):spawn_object(481, 24)
        end)
        get_room(11, 0):at(function()
            self.room:find_actor("ash-lord"):command("wear crown")
        end)
        get_room(11, 0):at(function()
            self.room:find_actor("ash-lord"):teleport(get_room(481, 57))
        end)
    end
elseif ash == 2 then
    self:say("Bring me the ash lord's crown first.")
else
    self:say("I have no idea what you are talking about.")
    self:command("eye " .. tostring(actor.name))
end$trig$, '3e9cc39c58e01ba3ae5b2d5bf15d7b31'),
  -- data/triggers/490/490_31_eldest_speak1.lua
  (490, 31, $trig$-- Converted from DG Script #49031: eldest_speak1
-- Original: MOB trigger, flags: SPEECH, num_arg: 1 (DG word-list mode, not a probability)

-- DG word list (num_arg 1): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"cult?", "cult", "cult", "?"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
self.room:send(tostring(self.name) .. " says, 'You don't know about the cult?  You need to read some")
self.room:send("</>history.'")
self.room:spawn_object(490, 38)
self:command("give book " .. tostring(actor.name))
self:say("Come back when you can help us.")$trig$, 'aa2f14b453369cd8112f836e39706dfc'),
  -- data/triggers/490/490_32_eldest_speak2.lua
  (490, 32, $trig$-- Converted from DG Script #49032: eldest_speak2
-- Original: MOB trigger, flags: SPEECH, num_arg: 1 (DG word-list mode, not a probability)

-- DG word list (num_arg 1): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"griffin?", "griffins?", "griffins", "griffin", "griffins", "?", "griffin", "?"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
self:command("peer " .. tostring(actor.name))
if actor.level < 45 then
    self.room:send(tostring(self.name) .. " says, 'Hehe, thanks for asking, but I really don't think you")
    self.room:send("</>can help " .. tostring(actor.name) .. ".")
    self:command("ruffle " .. tostring(actor.name))
    wait(1)
    self.room:send(tostring(self.name) .. " says, 'But find me a powerful hero and maybe the cult can be")
    self.room:send("</>stopped.'")
else
    self.room:send(tostring(self.name) .. " says, 'Yes, you may have noticed a lot of griffins around this")
    self.room:send("</>island, well their nature has brought an imbalance to this place, and our holy")
    self.room:send("</>mistletoe is dying.'")
    wait(1)
    self.room:send(tostring(self.name) .. " says, 'They distract my druids from tending to their trees")
    self.room:send("</>too.  We must stop the cult of griffin worshippers before it is too late.")
end$trig$, 'd5201a0a36bf0cbcbcfc04ce29643325'),
  -- data/triggers/490/490_48_eldest_speak3.lua
  (490, 48, $trig$-- Converted from DG Script #49048: eldest_speak3
-- Original: MOB trigger, flags: SPEECH, num_arg: 1 (DG word-list mode, not a probability)

-- DG word list (num_arg 1): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"weapon", "weapon?", "oak", "oak?", "items", "items?", "dagon", "dagon?"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
wait(2)
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
        if not person:get_quest_stage("griffin_quest") then
            person:start_quest("griffin_quest")
            person:send("<b:white>You have begun the Griffin Isle quest!</>")
        end
    elseif person and person.is_player then
        i = i + 1
    end
    a = a + 1
end
self:say("Yes, a branch was taken from the holy oak with a mystic sword.  It was bound for the island aboard the St. Marvin, but the ship was lost in a storm.")
wait(2)
self:say("If only those sacred implements could be recovered, we may be able to finally move against the cult...  The island hermit may know more.")$trig$, '8887a48a80359e6fa6d4c25be76871dc'),
  -- data/triggers/490/490_49_hermit_speak4.lua
  (490, 49, $trig$-- Converted from DG Script #49049: hermit_speak4
-- Original: MOB trigger, flags: SPEECH, num_arg: 1 (DG word-list mode, not a probability)

-- DG word list (num_arg 1): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"where", "where?"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
wait(2)
self:say("I believe the St. Marvin wrecked near the cliffs on the western shores.")$trig$, '4fadd6f0cf62eaed96b13bad2ce470b0'),
  -- data/triggers/519/519_09_academy_torch_command_light.lua
  (519, 9, $trig$-- Converted from DG Script #51909: academy_torch_command_light
-- Original: OBJECT trigger, flags: COMMAND, probability: 3%

-- Command location mask 3: legacy OCMD_EQUIP=1 (worn), OCMD_INVEN=2 (carried), OCMD_ROOM=4 (floor)
if not (location == "equip" or location == "inventory") then
    return true  -- Not in a location this trigger watches
end

-- Command filter: light
if not (cmd == "light") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
-- switch on cmd
if cmd == "l" then
    _return_value = true
    return _return_value
end
-- `arg` is the typed argument ("torch"), not an object: this trigger sits on the academy torch
-- (0:23), so the lesson step applies when the argument names this object.
local names_this_torch = arg ~= "" and string.find(string.lower(tostring(self.name)), string.lower(arg), 1, true)
if actor:get_quest_var("school:gear") == 5 and names_this_torch then
    -- The queued command below does the lighting, so the typed one is blocked (it would otherwise
    -- run first and the queued `light` would toggle the torch straight back off).
    _return_value = false
    actor:command("light " .. tostring(arg))
    actor:set_quest_var("school", "gear", 6)
    wait(2)
    actor:send(tostring(mobiles.template(519, 2).name) .. " tells you, 'Now you can see in dark spaces or outside at night!")
    actor:send("Remember, most lights have a limited duration.")
    actor:send("It's best to turn them off when not using them.")
    actor:send("</>")
    actor:send("Lights don't have to be equipped for you to see.")
    actor:send("They work just fine from your inventory.'")
    wait(3)
    actor:send(tostring(mobiles.template(519, 2).name) .. " tells you, 'You can stop using items by typing <b:cyan>REMOVE [object]</>.'")
    actor:send("</>")
    actor:send(tostring(mobiles.template(519, 2).name) .. " tells you, 'Stop wearing that torch by typing <b:green>remove torch</>.'")
    return _return_value
end
_return_value = true
return _return_value$trig$, '9bc5b6c9d797a4c0c6ed32e7a2a67f5e'),
  -- data/triggers/519/519_11_academy_instructor_command_get.lua
  (519, 11, $trig$-- Converted from DG Script #51911: academy_instructor_command_get
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: get
if not (cmd == "get") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
-- `arg` is the typed argument, not an object: the lesson stick (519:2) is the object with keyword "stick".
local names_stick = string.find(string.lower(arg), "stick", 1, true) ~= nil
if actor:get_quest_var("school:gear") == 7 then
    if names_stick then
        actor:set_quest_var("school", "gear", 8)
        actor:command("get " .. tostring(arg))
        wait(2)
        actor:send(tostring(self.name) .. " tells you, 'Well done!  It's as simple as that!'")
        wait(2)
        actor:send(tostring(self.name) .. " tells you, 'If you don't want to pick up the first one, you can target a different one by adding a number and a \".\" before the name.'")
        wait(2)
        actor:send(tostring(self.name) .. " tells you, 'Try typing <b:green>get 2.stick</> and see what happens.'")
    end
elseif actor:get_quest_var("school:gear") == 8 then
    if names_stick and string.find(arg, "2.", 1, true) then
        actor:set_quest_var("school", "gear", 9)
        actor:command("get " .. tostring(arg))
        wait(2)
        actor:send(tostring(self.name) .. " tells you, 'Yes, like that.'")
        actor:send("</>")
        actor:send("You can also pick up all of one thing by typing <b:cyan>GET all.[object]</>.")
        actor:send("Or you can be extra greedy by typing <b:cyan>GET ALL</>.")
        actor:send("That will pick up everything in the room.'")
        wait(2)
        actor:send(tostring(self.name) .. " tells you, 'Type <b:green>get all</> with nothing after it.'")
    end
elseif actor:get_quest_var("school:gear") == 9 and arg == "all" then
    actor:set_quest_var("school", "gear", 10)
    actor:command("get all")
    wait(2)
    actor:send(tostring(self.name) .. " tells you, 'Those are some sticky fingers!'")
    self:command("laugh")
    wait(2)
    actor:send(tostring(self.name) .. " tells you, 'Now it's possible your inventory might get full.")
    actor:send("You can only carry so many items in your inventory at once but there are a few ways to deal with that.'")
    wait(2)
    actor:send(tostring(self.name) .. " tells you, 'First, you can <b:cyan>(DRO)P</> items with the command <b:cyan>DROP [object]</>.'")
    actor:send("</>")
    actor:send(tostring(self.name) .. " tells you, 'Drop one of those sticks by typing <b:green>drop stick</>.'")
elseif actor:get_quest_var("school:gear") == 15 and string.find(arg, "stick bag") then
    actor:set_quest_var("school", "gear", 16)
    actor:command("get stick bag")
    wait(2)
    self:command("cheer")
    actor:send(tostring(mobiles.template(519, 2).name) .. " tells you, 'Congratulations, you mastered equipment management!")
    actor:send("Would you like to review?")
    actor:send("You can <b:green>say yes</> or <b:green>say no</>.'")
end
_return_value = true
return _return_value$trig$, 'e833fc2c3c49f06db076bc0d5afea22b'),
  -- data/triggers/519/519_13_academy_instructor_command_junk.lua
  (519, 13, $trig$-- Converted from DG Script #51913: academy_instructor_command_junk
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: junk
if not (cmd == "junk") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
-- `arg` is the typed argument, not an object: the lesson stick (519:2) is the object with keyword "stick".
if actor:get_quest_var("school:gear") == 11 and string.find(string.lower(arg), "stick", 1, true) then
    actor:set_quest_var("school", "gear", 12)
    actor:command("junk " .. tostring(arg))
    wait(2)
    actor:send(tostring(self.name) .. " tells you, 'Very good.'")
    wait(2)
    actor:send(tostring(self.name) .. " tells you, 'You can drop and junk everything with the same keyword by typing in <b:cyan>all.[object]</> as well.")
    actor:send("But <b:red>be careful</>!  You might end up junking something with a surprising keyword by accident!'</>")
    wait(2)
    actor:send(tostring(self.name) .. " tells you, 'Another way to deal with items is to <b:cyan>(GI)VE</> them away.")
    actor:send("You can do that by typing <b:cyan>GIVE [object] [person]</>.'")
    wait(2)
    actor:send(tostring(self.name) .. " tells you, 'Give me a stick by typing <b:green>give stick instructor</>.'")
end
_return_value = true
return _return_value$trig$, 'e29dc8c583c1dd4b4c582019b695bb77'),
  -- data/triggers/533/533_10_wall_ice_crystalize_speech.lua
  (533, 10, $trig$-- DG word list (num_arg 1): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"crystalize", "crystalize!"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end

if actor:get_quest_stage("wall_ice") == 1 and actor:has_item(533, 26) and (self.zone_id ~= 533 or self.id ~= 16) then
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
elseif (self.zone_id == 533 and self.id == 16) and actor:get_quest_stage("wall_ice") == 2 and actor:has_item(533, 26) then
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
end$trig$, '6d8ec5c30a78b8f814e6eb8728a0f4cf'),
  -- data/triggers/534/534_60_major_globe_hint_speech.lua
  (534, 60, $trig$-- Converted from DG Script #53460: major_globe_hint_speech
-- Original: MOB trigger, flags: GLOBAL, SPEECH, num_arg: 1 (DG word-list mode, not a probability)

-- DG word list (num_arg 1): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"gone?", "gone", "while?", "while", "rascal?", "rascal", "lirne?", "lirne"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
wait(2)
actor:send(tostring(self.name) .. " says, 'Yeah, Lirne.  He disappeared a little while ago on a job in Frost Valley.'")
self:command("frown")
wait(2)
actor:send(tostring(self.name) .. " says, 'None of us have heard from him since.  I hope that ol' warmage hasn't gotten himself into more trouble than he can handle.'")$trig$, '1302fc99f40d94471bca1d51d43b6337'),
  -- data/triggers/550/550_02_tech_master_shaman_2.lua
  (550, 2, $trig$-- Converted from DG Script #55002: Tech_Master_Shaman_2
-- Original: MOB trigger, flags: SPEECH, num_arg: 1 (DG word-list mode, not a probability)

-- DG word list (num_arg 1): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"missing"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
-- This is the initial conversation to get quest data
self.room:send("The <b:yellow>Master Shaman</> rolls her eyes in disgust.")
actor:send("The <b:yellow>Master Shaman</> whispers to you, 'Yes, my predecessors and ancestors lost many")
actor:send("</>battles with demons and a cult of the followers of Lokari and in the process")
actor:send("</>lost the keys.'")
self.room:send_except(actor, "The <b:yellow>Master Shaman</> speaks in a low voice to " .. tostring(actor.name) .. ".")
self.room:send("The <b:yellow>Master Shaman</> pulls out her unused thinking cap, and begins to think.")$trig$, '9475d64eba6b1f416bdb2e2253139188'),
  -- data/triggers/550/550_03_tech_master_shaman_3.lua
  (550, 3, $trig$-- Converted from DG Script #55003: Tech_Master_Shaman_3
-- Original: MOB trigger, flags: SPEECH, num_arg: 1 (DG word-list mode, not a probability)

-- DG word list (num_arg 1): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"evils"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
-- Yet more quest information
self.room:send_except(actor, "The <b:yellow>Master Shaman</> raises an eyebrow at " .. tostring(actor.name) .. ".")
actor:send("The <b:yellow>Master Shaman</> raises an eyebrow at you.")
self.room:send_except(actor, "The <b:yellow>Master Shaman</> speaks to " .. tostring(actor.name) .. " in a low voice.")
actor:send("The <b:yellow>Master Shaman</> whispers to you, 'Yes, Huitzipa the war god and that cursed")
actor:send("</>death god, I can't even say his name.'")
self.room:send("The <b:yellow>Master Shaman</> spits over her shoulder.")
self.room:send_except(actor, "The <b:yellow>Master Shaman</> speaks to " .. tostring(actor.name) .. " in a low voice.")
actor:send("The <b:yellow>Master Shaman</> whispers to you, 'If it weren't for the great Snow Leopard of")
actor:send("</>the ancient age, our kingdom would have perished long long ago.'")
self.room:send("The <b:yellow>Master Shaman</> nods to herself.")$trig$, '6fd5e7d106d5373cbcf1d673e03e18d8'),
  -- data/triggers/550/550_04_tech_master_shaman_4.lua
  (550, 4, $trig$-- Converted from DG Script #55004: Tech_Master_Shaman_4
-- Original: MOB trigger, flags: SPEECH, num_arg: 1 (DG word-list mode, not a probability)

-- DG word list (num_arg 1): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"keys"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
-- Still more quest banter
self.room:send("The <b:yellow>Master Shaman</> nods.")
self.room:send_except(actor, "The <b:yellow>Master Shaman</> speaks to " .. tostring(actor.name) .. " in a low voice.")
actor:send("The <b:yellow>Master Shaman</> whispers to you, 'Whatever they are, no one even remembers")
actor:send("</>anymore.  They are just the means by which the greatest evils my kingdom has")
actor:send("</>ever known can be set free again.'")
self.room:send("The <b:yellow>Master Shaman</> frowns.")$trig$, '309a7fe11776c270330def7f1194b5aa'),
  -- data/triggers/550/550_05_tech_master_shaman_5.lua
  (550, 5, $trig$-- Converted from DG Script #55005: Tech_Master_Shaman_5
-- Original: MOB trigger, flags: SPEECH, num_arg: 1 (DG word-list mode, not a probability)

-- DG word list (num_arg 1): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"huitzipa"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
-- More quest conversation
self.room:send("The <b:yellow>Master Shaman</> blinks.")
self.room:send_except(actor, "The <b:yellow>Master Shaman</> speaks to " .. tostring(actor.name) .. " in a low voice.")
actor:send("The <b:yellow>Master Shaman</> whispers to you, 'How dare you repeat that vile name in my")
actor:send("</>presence!  If it were not for the Great Leopard we would be lost.  The")
actor:send("</>injustice and recklessness of them, I wish him destroyed!'")
self.room:send("The <b:yellow>Master Shaman</> growls.")$trig$, '2017711dd3dad1b334a752f29cf63624'),
  -- data/triggers/550/550_32_wizard_eye_gypsy_speech.lua
  (550, 32, $trig$-- Converted from DG Script #55032: wizard_eye_gypsy_speech
-- Original: MOB trigger, flags: SPEECH, num_arg: 1 (DG word-list mode, not a probability)

-- DG word list (num_arg 1): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"wizard", "eye", "wizard?", "eye?"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
wait(2)
if actor:get_quest_stage("wizard_eye") == 1 then
    actor:send(tostring(self.name) .. " says, 'Why yes, I can help with that!  So you want your own crystal ball, ya say?'")
    wait(2)
    actor:send(tostring(self.name) .. " says, '<b:cyan>Show</> me your <b:cyan>palm</>.'")
end$trig$, '99acec88a953993ca9c28bffdce54214'),
  -- data/triggers/564/564_05_hell_gate_mob_death.lua
  (564, 5, $trig$if actor:get_quest_stage("hell_gate") ~= 3 then
    return true
end
if not actor:has_equipped(564, 7) then
    return true
end

-- Map killer mob (legacy vnum) -> blood vial local id within zone 564.
local blood
local vnum = self.zone_id * 100 + self.id
if vnum == 12010 then
    blood = 0
elseif vnum == 30054 then
    blood = 1
elseif vnum == 32408 then
    blood = 2
elseif vnum == 48125 then
    blood = 3
elseif vnum == 48126 then
    blood = 4
elseif vnum == 51003 or vnum == 51018 or vnum == 51023 then
    blood = 5
elseif vnum == 55238 then
    blood = 6
else
    return true
end

local key = "blood" .. tostring(blood)
if not actor:get_quest_var("hell_gate:" .. key) then
    actor:set_quest_var("hell_gate", key, 1)
    self.room:spawn_object(564, blood)
end$trig$, 'd1224f60a1bae7eeecd8b39cbc6a07cd'),
  -- data/triggers/580/580_03_charm_person_hinazuru_speech1.lua
  (580, 3, $trig$-- DG word list (num_arg 1): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"specialty", "services", "yes", "like", "what?", "services?", "speciality?"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
if string.find(actor.class, "Sorcerer") or string.find(actor.class, "Illusionist") or string.find(actor.class, "Bard") then
    if actor.level > 88 then
        if actor:get_quest_stage("charm_person") == 0 then
            wait(2)
            self:say("I am not only a master of conversational and social arts, I am also highly trained in the mystic arts. Sorcerers and illusionists come from all across the world to learn my signature spell for charming others.")
            wait(2)
            self:say("If you are interested, I could teach you.  For a price.  100 platinum, at once, in advance, is my fee.")
        elseif actor:get_quest_stage("charm_person") == 1 then
            self:say("Marvelous!")
            wait(1)
            self:say("If you would be so kind as to give it to me, I can demonstrate its power.")
        end
    else
        self:say("Your determination is admirable, but I fear you still have some learning to do before I can teach you.")
    end
end$trig$, 'abfc50b6225a36e7d0bdb81d585abca7'),
  -- data/triggers/584/584_02_unicorn_girl_speech.lua
  (584, 2, $trig$-- Converted from DG Script #58402: Unicorn girl speech
-- Original: MOB trigger, flags: SPEECH, num_arg: 1 (DG word-list mode, not a probability)


-- Speech keyword: "wrong"
-- DG word list (num_arg 1): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"wrong"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end

wait(1)
self.room:send_except(actor, tostring(self.name) .. " speaks to " .. tostring(actor.name) .. " in a low voice.")
actor:send(tostring(self.name) .. " says to you, 'The King will not free me, even though my obligation of service to him is done.  He shall never have my hand in marriage, thus I shall remain his slave forever.'")$trig$, 'd1458ab83914c05acc9cfe1f23ce4c18'),
  -- data/triggers/584/584_12_dancer_quest_ask.lua
  (584, 12, $trig$-- DG word list (num_arg 1): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"hi", "help", "hello", "howdy", "quest"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
if not actor.is_player then
    return true
end
if actor.level < 65 then
    return true
end
-- Already past stage 0 means they've already started or finished it.
if (actor:get_quest_stage("major_spell_quest") or 0) >= 1 then
    return true
end
if actor:get_has_completed("major_spell_quest") then
    return true
end

local class = tostring(actor.class)
local eligible = string.find(class, "Sorcerer")
        or string.find(class, "Cryomancer")
        or string.find(class, "Pyromancer")

if eligible then
    wait(1)
    self:command("think")
    wait(1)
    actor:send(tostring(self.name) .. " says to you, 'I've been trapped here for so long.'")
    self:command("sigh")
    wait(1)
    actor:send(tostring(self.name) .. " says to you, 'The Prince has me enslaved against my will, will you help set me free?'")
    self:say("Yer a " .. class)
    actor:start_quest("major_spell_quest")
else
    self:command("grumble")
    self:say("Ok, I can talk, I swear " .. tostring(actor.name) .. " is a doofus.")
end$trig$, '83165fd56b780db802d34439401a8809'),
  -- data/triggers/584/584_13_dancer_quest_ask2.lua
  (584, 13, $trig$-- DG word list (num_arg 1): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"yes"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
if not actor.is_player then
    return true
end
if actor:get_quest_stage("major_spell_quest") ~= 1 then
    return true
end

wait(1)
actor:send(tostring(self.name) .. " says to you, 'Oh thank you!'")
actor:send(tostring(self.name) .. " says to you, 'You must gain the princes favor..'")
actor:send(tostring(self.name) .. " says to you, 'then maybe he will give me to you so you can set me free.'")
self.room:send_except(actor, tostring(self.name) .. " whispers something to " .. tostring(actor.name))
actor:advance_quest("major_spell_quest")  -- advances to stage 2
wait(5)

local prince = self.room:find_actor("prince")
if prince then
    prince:say("Hey, what are you talking to them about?!")
    prince:command("sigh")
    wait(2)
    prince:say("You can't get good help now days...")
end$trig$, '72bf9b201685ffb93d6b8e67bb6100f3'),
  -- data/triggers/584/584_14_gypsy_prince_ask1.lua
  (584, 14, $trig$-- Converted from DG Script #58414: Gypsy_Prince_ask1
-- Original: MOB trigger, flags: SPEECH_TO, num_arg: 1 (DG word-list mode, not a probability)

-- DG word list (num_arg 1): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"greeting", "hi", "hello", "quest"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
if actor:get_quest_stage("major_spell_quest") ~= 2 then
    return true
end

wait(1)
self:command("eye " .. tostring(actor.name))
wait(1)
actor:send(tostring(self.name) .. " says to you, 'Greetings, traveler what brings you to my camp?'")
self.room:send_except(actor, tostring(self.name) .. " speaks to " .. tostring(actor.name) .. " in a low voice.")$trig$, '7324b1134e4312fccf3c88e723223e63'),
  -- data/triggers/584/584_15_gypsy_prince_ask2.lua
  (584, 15, $trig$-- Converted from DG Script #58415: Gypsy_prince_ask2
-- Original: MOB trigger, flags: SPEECH_TO, num_arg: 1 (DG word-list mode, not a probability)

-- DG word list (num_arg 1): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"favor"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
if actor:get_quest_stage("major_spell_quest") ~= 2 then
    return true
end

wait(1)
actor:send(tostring(self.name) .. " says to you, 'Ah, you are looking for my favor?'")
self.room:send_except(actor, tostring(self.name) .. " speaks to " .. tostring(actor.name) .. " in a low voice.")
wait(1)
self:command("smile me")
actor:send(tostring(self.name) .. " says to you, 'I get that quite a bit, actually... The last adventurer to'")
actor:send(tostring(self.name) .. " says to you, 'seek my favor left our contract imcomplete... If you could'")
actor:send(tostring(self.name) .. " says to you, 'track down that scoundrel and get my prize he is keeping..'")
actor:send(tostring(self.name) .. " says to you, 'I would consider myself in your debt..'")
wait(1)
self:command("bow " .. tostring(actor.name))
wait(1)
self:command("ask " .. tostring(actor.name) .. " Will you gon on this quest for me?")
actor:advance_quest("major_spell_quest")  -- advances to stage 3$trig$, '4b720d93abb4980ccd522118756c0a22'),
  -- data/triggers/584/584_16_gypsy_prince_ask3.lua
  (584, 16, $trig$-- Converted from DG Script #58416: gypsy_prince_ask3
-- Original: MOB trigger, flags: SPEECH_TO, num_arg: 1 (DG word-list mode, not a probability)

-- DG word list (num_arg 1): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"yes"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
if actor:get_quest_stage("major_spell_quest") ~= 3 then
    return true
end

wait(2)
self.room:send_except(actor, tostring(self.name) .. " speaks to " .. tostring(actor.name) .. " in a low voice.")
actor:send(tostring(self.name) .. " says to you, 'Excellent!  That rogue of a guard, a monstrous bronze statue'")
actor:send(tostring(self.name) .. " says to you, 'that now guards the entrance of that accursed village was to'")
actor:send(tostring(self.name) .. " says to you, 'search the Underdark for an item for me.  Go to him and demand'")
actor:send(tostring(self.name) .. " says to you, 'it in the name of the Gypsy Prince of Calia and I shall reward you.'")
actor:advance_quest("major_spell_quest")  -- advances to stage 4$trig$, '11ed527f08400521eb93970a440e7c51'),
  -- data/triggers/584/584_17_bronze_statue_ask.lua
  (584, 17, $trig$-- Converted from DG Script #58417: Bronze_statue_ask
-- Original: MOB trigger, flags: SPEECH_TO, num_arg: 1 (DG word-list mode, not a probability)

-- DG word list (num_arg 1): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"gypsy", "prince", "task", "prize"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
if actor:get_quest_stage("major_spell_quest") ~= 4 then
    return true
end

wait(1)
self:emote("snorts flames from his nostrils!")
self:command("growl")
wait(2)
self:shout("What?! That backstabbing rogue wants his prize?!")
self:command("think")
wait(2)
self:say("Well that's just to bad, I guess I'll just dispatch you myself.")
actor:advance_quest("major_spell_quest")  -- advances to stage 5
wait(2)
combat.engage(actor)
self.room:spawn_object(520, 50)$trig$, 'cd33393cb58dbe461c5232ea306bd148'),
  -- data/triggers/586/586_03_dragons_health_myorrhed_bribe.lua
  (586, 3, $trig$if actor:get_quest_stage("dragons_health") == 5 then
    wait(2)
    self.room:send(tostring(self.name) .. " says, 'Ah, coin itself!  I count:'")
    if platinum and platinum > 0 then
        self.room:send(tostring(platinum) .. " platinum")
    end
    if gold and gold > 0 then
        self.room:send(tostring(gold) .. " gold")
    end
    if silver and silver > 0 then
        self.room:send(tostring(silver) .. " silver")
    end
    if copper and copper > 0 then
        self.room:send(tostring(copper) .. " copper")
    end
    wait(2)
    self:say("This shall be included in the offerings.")
    self:emote("places the money next to the egg.")
    local hoard = actor:get_quest_var("dragons_health:hoard") or 0
    local wealth = hoard + ((platinum or 0) * 1000) + ((gold or 0) * 100) + ((silver or 0) * 10) + (copper or 0)
    actor:set_quest_var("dragons_health", "hoard", wealth)
    if wealth >= 10000000 then
        actor:advance_quest("dragons_health")
        run_room_trigger(586, 4)
    else
        local total = 10000000 - wealth
        local plat = total // 1000
        local rem_gold = (total // 100) - (plat * 10)
        local silv = (total // 10) - (plat * 100) - (rem_gold * 10)
        local copp = total - (plat * 1000) - (rem_gold * 100) - (silv * 10)
        self.room:send(tostring(self.name) .. " says, 'We need " .. tostring(plat) .. " platinum, " .. tostring(rem_gold) .. " gold, " .. tostring(silv) .. " silver, " .. tostring(copp) .. " copper")
        self.room:send("</>more in treasure and coins.'")
    end
else
    self:say("I appreciate the gesture, but I am in no need of money.")
    self:command("give " .. tostring(platinum or 0) .. " platinum " .. tostring(gold or 0) .. " gold " .. tostring(silver or 0) .. " silver " .. tostring(copper or 0) .. " copper " .. tostring(actor.name))
end$trig$, 'f7ff990905981447a612074c52a7329f'),
  -- data/triggers/625/625_15_treeant_dialog.lua
  (625, 15, $trig$-- Converted from DG Script #62515: treeant dialog
-- Original: MOB trigger, flags: SPEECH, num_arg: 1 (DG word-list mode, not a probability)

-- DG word list (num_arg 1): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"pests", "pest", "trees"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
self:command("growl")
self.room:send(tostring(self.name) .. " says, 'In the Month of the Stranger I first started seeing the feral")
self.room:send("</>dogs.  They make tunnels under the trees to eat their roots.'")
wait(1)
self:command("mutter")
self.room:send(tostring(self.name) .. " says, 'I'd like to tear them out of there and...  But I can't get to")
self.room:send("</>them.  If you kill them all, and bring me their pelts...  I'll make it worth")
self.room:send("</>your time.'")
self:command("wink")$trig$, 'f4e4b38e8d5c35d13f9e34d21fd7d94d'),
  -- data/triggers/625/625_18_merchant_dialogue.lua
  (625, 18, $trig$-- Converted from DG Script #62518: merchant dialogue
-- Original: MOB trigger, flags: SPEECH, SPEECH_TO, num_arg: 1 (DG word-list mode, not a probability)

-- DG word list (num_arg 1): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"help", "yes", "sacred", "spring", "power", "permanent", "solution", "powerful", "people", "hi", "hello", "hurt", "ok", "okay"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
wait(1)
if actor.is_player then
    if actor:get_quest_stage("ursa_quest") < 1 then
        if string.find(speech, "help") or string.find(speech, "help?") or string.find(speech, "ok") or string.find(speech, "yes") then
            actor:start_quest("ursa_quest")
            self:emote("looks at you.")
            wait(1)
            actor:send(tostring(self.name) .. " says, 'You'll help me?!'")
            return true
        elseif string.find(speech, "hi") or string.find(speech, "hello") then
            wait(1)
            actor:send(tostring(self.name) .. " says, 'Please, I'm very ill.  Can you <b:cyan>help</> me?'")
            return true
        elseif string.find(speech, "hurt") or string.find(speech, "hurt?") then
            wait(1)
            actor:send(tostring(self.name) .. " says, 'I'm very sick.  The disease makes me lose control.'")
            wait(2)
            actor:send(tostring(self.name) .. " says, 'When I do, I... hurt people.'")
            self:command("shudder")
            wait(2)
            actor:send(tostring(self.name) .. " says, 'Please <b:cyan>help</> me!")
        end
    end
    if actor:get_quest_stage("ursa_quest") == 1 then
        if string.find(speech, "yes") then
            actor:send(tostring(self.name) .. " says, 'I am suffering from werebear lycanthropy in its early stages.'")
            wait(1)
            actor:send(tostring(self.name) .. " says, 'The <b:cyan>power of this sacred spring</> is halting the disease's progression.'")
            return true
        elseif string.find(speech, "sacred") or string.find(speech, "spring") or string.find(speech, "power") then
            actor:send(tostring(self.name) .. " says, 'As long as I am near this spring, and no one gives fuel to the disease's rage...'")
            wait(1)
            actor:send(tostring(self.name) .. " says, 'I can retain my true form.'")
            wait(2)
            actor:send(tostring(self.name) .. " says, '...for now.'")
            wait(2)
            actor:send(tostring(self.name) .. " says, 'But, I must find a more <b:cyan>permanent solution</>.'")
            return true
        elseif string.find(speech, "permanent") or string.find(speech, "solution") then
            self:command("sigh")
            wait(1)
            actor:send(tostring(self.name) .. " says, 'Many say there is no cure for lycanthropy.'")
            wait(1)
            actor:send(tostring(self.name) .. " says, '...aside from death.'")
            wait(1)
            self:command("shudder")
            wait(2)
            actor:send(tostring(self.name) .. " says, 'But in my travels I've met many <b:cyan>powerful people</>.  At least one of them has to know more...'")
            wait(1)
            self:emote("hesitates for a moment, grasping for words.")
            wait(1)
            actor:send(tostring(self.name) .. " says, '...more favorable remedy.'")
            return true
        elseif string.find(speech, "powerful") or string.find(speech, "people") then
            actor:send(tostring(self.name) .. " says, 'On a nearby island are a very refined people.  They've found cures for many things, and are in good favor with powerful gods.  Perhaps the Lord of their island will know how to help me.'")
            wait(6)
            actor:send(tostring(self.name) .. " says, 'I also know that Blackmourne has always shown a lot of interest and ability in diseases of the mind.  I've traveled to the Red City many times to bring the cultists fresh...'")
            wait(4)
            self:emote("hesitates.")
            wait(2)
            actor:send(tostring(self.name) .. " says, '...supplies.  Perhaps one of them might help.'")
            wait(6)
            actor:send(tostring(self.name) .. " says, 'Then there's the old nut in the swamp.  If all else fails, maybe he's got some sort of remedy.'")
            wait(1)
            actor:send(tostring(self.name) .. " says, 'Whichever one you manage to contact, they will know who I am.  Just bring me back news of what can be done to help me.  I'm sure one of them will know what to do.'")
            return true
        end
    end
    if actor:get_quest_stage("ursa_quest") > 1 then
        actor:send(tostring(self.name) .. " says, 'Please, what do you have for me?'")
        return true
    end
end$trig$, '6c3d2a202dbb37c94107bda7ded76255'),
  -- data/triggers/625/625_72_countdown_62569.lua
  (625, 72, $trig$-- Converted from DG Script #62572: countdown 62569
-- Original: OBJECT trigger, flags: WEAR, num_arg: 1 (no chance roll in legacy)

return true$trig$, 'e5de1ff23a158e4495cc12833db19ce2')
) AS v(zone_id, id, commands, old_md5)
WHERE t.zone_id = v.zone_id
  AND t.id = v.id
  AND md5(t.commands) = v.old_md5
  AND t.commands IS DISTINCT FROM v.commands;

COMMIT;
