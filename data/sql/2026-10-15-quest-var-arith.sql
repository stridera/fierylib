-- Quest-var nil safety, part 2: arithmetic and relational uses of get_quest_var (nil when unset) get an (x or 0) default; numeric-string comparisons become numeric (scripts/fix_quest_var_nil_compare.py). APPLY AFTER 2026-10-15-quest-var-nil.sql: the md5 guards are the bodies at fierylib d50b1dd.
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
  -- data/triggers/002/002_110_hell_trident_attack_manager.lua
  (2, 110, $trig$if victim.hit >= -10 then
    -- 5% alignment damage against neutral targets, 10% against good
    if damage >= 1 then
        local bonus = 0
        if victim.alignment < 350 and victim.alignment > -350 then
            bonus = damage / 2
        elseif victim.alignment > 350 then
            bonus = damage
        end
        if bonus > 0 then
            self.room:send("<b:black>" .. tostring(self.shortdesc) .. " smites " .. tostring(victim.name) .. " with unholy might!</> (<yellow>" .. tostring(bonus) .. "</>)")
            victim:damage(bonus)  -- type: align
        end
    end
    if random(1, 10) == 1 then
        if (self.zone_id == 23 and self.id == 39) then
            spells.cast(self, "hell bolt", victim, self.level)
        elseif (self.zone_id == 23 and self.id == 40) then
            spells.cast(self, "stygian eruption", victim, self.level)
        end
    end
end
if actor:get_quest_stage("hell_trident") == 1 or actor:get_quest_stage("hell_trident") == 2 then
    if not actor:get_quest_var("hell_trident:helltask1") then
        local attack_increase = (actor:get_quest_var("hell_trident:attack_counter") or 0) + 1
        actor:set_quest_var("hell_trident", "attack_counter", attack_increase)
        if (actor:get_quest_var("hell_trident:attack_counter") or 0) >= 666 then
            actor:set_quest_var("hell_trident", "helltask1", 1)
            actor:set_quest_var("hell_trident", "attack_counter", 0)
            actor:send("<b:red>You have made sufficient blood offerings with " .. tostring(self.shortdesc) .. "!</>")
        end
    end
end$trig$, 'b7bb18a0217e9eaeac3ec3b1c89b6910'),
  -- data/triggers/002/002_113_phase_wand_bigby_research_assistant_progress_check.lua
  (2, 113, $trig$-- DG word list (num_arg 1): the speech must contain one of these as a whole word or phrase.
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
        if actor:get_quest_var("air_wand:wandtask1") and actor:get_quest_var("air_wand:wandtask2") then
            -- (empty room echo)
            self.room:send("Simply give me your " .. tostring(objects.template(2, 100).name) .. ".")
        else
            if actor:get_quest_var("air_wand:wandtask1") or actor:get_quest_var("air_wand:wandtask2") then
                -- (empty room echo)
                self.room:send("You have done the following:")
                if actor:get_quest_var("air_wand:wandtask1") then
                    self.room:send("- used your wand " .. tostring(times) .. " times")
                end
                if actor:get_quest_var("air_wand:wandtask2") then
                    self.room:send("- brought " .. tostring(objects.template(555, 77).name))
                end
            end
            -- (empty room echo)
            self.room:send("You still need to:")
            if not actor:get_quest_var("air_wand:wandtask1") then
                local remaining = times - (actor:get_quest_var("air_wand:attack_counter") or 0)
                self.room:send("- <b:yellow>attack " .. tostring(remaining) .. " more times with your " .. tostring(weapon) .. "</>")
            end
            if not actor:get_quest_var("air_wand:wandtask2") then
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
        if actor:get_quest_var("fire_wand:wandtask1") and actor:get_quest_var("fire_wand:wandtask2") then
            -- (empty room echo)
            self.room:send("Simply give me your " .. tostring(objects.template(2, 110).name) .. ".")
        else
            if actor:get_quest_var("fire_wand:wandtask1") or actor:get_quest_var("fire_wand:wandtask2") then
                -- (empty room echo)
                self.room:send("You have done the following:")
                if actor:get_quest_var("fire_wand:wandtask1") then
                    self.room:send("- used your wand " .. tostring(times) .. " times")
                end
                if actor:get_quest_var("fire_wand:wandtask2") then
                    self.room:send("- brought " .. tostring(objects.template(555, 75).name))
                end
            end
            -- (empty room echo)
            self.room:send("You still need to:")
            if not actor:get_quest_var("fire_wand:wandtask1") then
                local remaining = times - (actor:get_quest_var("fire_wand:attack_counter") or 0)
                self.room:send("- <b:yellow>attack " .. tostring(remaining) .. " more times with your " .. tostring(weapon) .. "</>")
            end
            if not actor:get_quest_var("fire_wand:wandtask2") then
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
        if actor:get_quest_var("ice_wand:wandtask1") and actor:get_quest_var("ice_wand:wandtask2") then
            -- (empty room echo)
            self.room:send("Simply give me your " .. tostring(objects.template(2, 120).name) .. ".")
        else
            if actor:get_quest_var("ice_wand:wandtask1") or actor:get_quest_var("ice_wand:wandtask2") then
                -- (empty room echo)
                self.room:send("You have done the following:")
                if actor:get_quest_var("ice_wand:wandtask1") then
                    self.room:send("- used your wand " .. tostring(times) .. " times")
                end
                if actor:get_quest_var("ice_wand:wandtask2") then
                    self.room:send("- brought " .. tostring(objects.template(555, 74).name))
                end
            end
            -- (empty room echo)
            self.room:send("You still need to:")
            if not actor:get_quest_var("ice_wand:wandtask1") then
                local remaining = times - (actor:get_quest_var("ice_wand:attack_counter") or 0)
                self.room:send("- <b:yellow>attack " .. tostring(remaining) .. " more times with your " .. tostring(weapon) .. "</>")
            end
            if not actor:get_quest_var("ice_wand:wandtask2") then
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
        if actor:get_quest_var("acid_wand:wandtask1") and actor:get_quest_var("acid_wand:wandtask2") then
            -- (empty room echo)
            self.room:send("Simply give me your " .. tostring(objects.template(2, 130).name) .. ".")
        else
            if actor:get_quest_var("acid_wand:wandtask1") or actor:get_quest_var("acid_wand:wandtask2") then
                -- (empty room echo)
                self.room:send("You have done the following:")
                if actor:get_quest_var("acid_wand:wandtask1") then
                    self.room:send("- used your wand " .. tostring(times) .. " times")
                end
                if actor:get_quest_var("acid_wand:wandtask2") then
                    self.room:send("- brought " .. tostring(objects.template(555, 76).name))
                end
            end
            -- (empty room echo)
            self.room:send("You still need to:")
            if not actor:get_quest_var("acid_wand:wandtask1") then
                local remaining = times - (actor:get_quest_var("acid_wand:attack_counter") or 0)
                self.room:send("- <b:yellow>attack " .. tostring(remaining) .. " more times with your " .. tostring(weapon) .. "</>")
            end
            if not actor:get_quest_var("acid_wand:wandtask2") then
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
end$trig$, '5afb85e381abbd56eb943f1967259a56'),
  -- data/triggers/002/002_119_phase_mace_attack_counter_and_damage.lua
  (2, 119, $trig$if actor:get_quest_stage("phase_mace") >= 1 then
    if not actor:get_quest_var("phase_mace:macetask1") then
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
        if self.id == 340 or self.id == 341 then
            return true
        elseif self.id == 342 or self.id == 343 or self.id == 344 or self.id == 345 then
            spell = "divine bolt"
        elseif self.id == 346 or self.id == 347 or self.id == 348 or self.id == 349 then
            spell = "divine ray"
        end
        if spell then
            spells.cast(self, spell, victim, skill)
        end
    elseif victim.lifeforce == "undead" or victim.lifeforce == "demonic" or victim.race == "demon" then
        skill = skill / 2
        if self.id == 340 or self.id == 341 or self.id == 342 then
            return true
        elseif self.id >= 343 and self.id <= 349 then
            spell = "divine bolt"
        end
        if spell then
            spells.cast(self, spell, victim, skill)
        end
    end
end$trig$, '6fd1f2af692f55200dac5785b4e290ef'),
  -- data/triggers/002/002_121_monk_vision_attack_counter.lua
  (2, 121, $trig$if actor:get_quest_stage("monk_vision") >= 1 then
    if not actor:get_quest_var("monk_vision:visiontask1") then
        local attack_increase = (actor:get_quest_var("monk_vision:attack_counter") or 0) + 1
        actor:set_quest_var("monk_vision", "attack_counter", attack_increase)
        if (actor:get_quest_var("monk_vision:attack_counter") or 0) >= actor:get_quest_stage("monk_vision") * 100 then
            actor:set_quest_var("monk_vision", "visiontask1", 1)
            actor:set_quest_var("monk_vision", "attack_counter", 0)
            actor:send("<b:yellow>You have perfected your bond with " .. tostring(self.shortdesc) .. "!</>")
        end
    end
end$trig$, 'e08438406f39c6a93f39981c072b71ad'),
  -- data/triggers/002/002_122_assassin_mask_attack_counter.lua
  (2, 122, $trig$if actor:get_quest_stage("assassin_mask") >= 1 then
    if not actor:get_quest_var("assassin_mask:masktask1") then
        local attack_increase = (actor:get_quest_var("assassin_mask:attack_counter") or 0) + 1
        actor:set_quest_var("assassin_mask", "attack_counter", attack_increase)
        if (actor:get_quest_var("assassin_mask:attack_counter") or 0) >= actor:get_quest_stage("assassin_mask") * 100 then
            actor:set_quest_var("assassin_mask", "masktask1", 1)
            actor:set_quest_var("assassin_mask", "attack_counter", 0)
            actor:send("<b:yellow>You have perfected your bond with " .. tostring(self.shortdesc) .. "!</>")
        end
    end
end$trig$, '3cf1b284c866e0da27d29d6cc48f1092'),
  -- data/triggers/002/002_123_paladin_pendant_attack_counter.lua
  (2, 123, $trig$if actor:get_quest_stage("paladin_pendant") >= 1 then
    if not actor:get_quest_var("paladin_pendant:necklacetask1") then
        local attack_increase = (actor:get_quest_var("paladin_pendant:attack_counter") or 0) + 1
        actor:set_quest_var("paladin_pendant", "attack_counter", attack_increase)
        if (actor:get_quest_var("paladin_pendant:attack_counter") or 0) >= actor:get_quest_stage("paladin_pendant") * 100 then
            actor:set_quest_var("paladin_pendant", "necklacetask1", 1)
            actor:set_quest_var("paladin_pendant", "attack_counter", 0)
            actor:send("<b:yellow>You have perfected your bond with " .. tostring(self.shortdesc) .. "!</>")
        end
    end
end$trig$, 'db9b5994727d62da60f49a2f4f8f07ee'),
  -- data/triggers/002/002_124_ranger_trophy_attack_counter.lua
  (2, 124, $trig$if actor:get_quest_stage("ranger_trophy") >= 1 then
    if not actor:get_quest_var("ranger_trophy:trophytask1") then
        local attack_increase = (actor:get_quest_var("ranger_trophy:attack_counter") or 0) + 1
        actor:set_quest_var("ranger_trophy", "attack_counter", attack_increase)
        if (actor:get_quest_var("ranger_trophy:attack_counter") or 0) >= actor:get_quest_stage("ranger_trophy") * 100 then
            actor:set_quest_var("ranger_trophy", "trophytask1", 1)
            actor:set_quest_var("ranger_trophy", "attack_counter", 0)
            actor:send("<b:green>You have perfected your bond with " .. tostring(self.shortdesc) .. "!</>")
        end
    end
end$trig$, '79ccfb5e5d395cd25bbc905e1db59069'),
  -- data/triggers/002/002_125_rogue_cloak_attack_counter.lua
  (2, 125, $trig$if actor:get_quest_stage("rogue_cloak") >= 1 then
    if not actor:get_quest_var("rogue_cloak:cloaktask1") then
        local attack_increase = (actor:get_quest_var("rogue_cloak:attack_counter") or 0) + 1
        actor:set_quest_var("rogue_cloak", "attack_counter", attack_increase)
        if (actor:get_quest_var("rogue_cloak:attack_counter") or 0) >= actor:get_quest_stage("rogue_cloak") * 100 then
            actor:set_quest_var("rogue_cloak", "cloaktask1", 1)
            actor:set_quest_var("rogue_cloak", "attack_counter", 0)
            actor:send("<b:yellow>You have perfected your bond with " .. tostring(self.shortdesc) .. "!</>")
        end
    end
end$trig$, '525f7f7fe0ab7a1b24d681f12b9eb830'),
  -- data/triggers/004/004_09_sunfire_rescue_progress_journal.lua
  (4, 9, $trig$-- Converted from DG Script #409: Sunfire Rescue progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if string.find(arg, "sunfire") or string.find(arg, "serin") or string.find(arg, "rescue") or string.find(arg, "sunfire_rescue") or string.find(arg, "sunfire_crest") or string.find(arg, "serin_sunfire_rescue") or string.find(arg, "sunfire crest") then
    local stage = actor:get_quest_stage("sunfire_rescue")
    if actor.level >= 80 or (stage or 0) > 0 then
        _return_value = true
        actor:send("<b:u:green>Sunfire Rescue</>")
        actor:send("This quest is only available to good-aligned characters.")
        actor:send("Minimum Level: 85")
        actor:send("- This quest can be started at any level but requires level 85 to finish.")
        local status
        if actor:get_has_completed("sunfire_rescue") then
            status = "Completed!"
        elseif (stage or 0) > 0 then
            status = "In Progress"
        else
            status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
        if stage == 1 then
            actor:send("Quest Master: " .. tostring(mobiles.template(237, 19).name))
            actor:send("</>")
            actor:send("You must bring the elven cloak, ring, and boots from Templace to Serin Sunfire to help him escape!")
            actor:send("</>")
            local boots = actor:get_quest_var("sunfire_rescue:boots")
            local cloak = actor:get_quest_var("sunfire_rescue:cloak")
            local ring = actor:get_quest_var("sunfire_rescue:ring")
            local total = (boots or 0) + (cloak or 0) + (ring or 0)
            if total > 0 then
                actor:send("You have retrieved the following treasures:")
                if boots then
                    actor:send(tostring(objects.template(520, 8).name) .. ".")
                end
                if cloak then
                    actor:send(tostring(objects.template(520, 9).name) .. ".")
                end
                if ring then
                    actor:send(tostring(objects.template(520, 1).name) .. ".")
                end
                actor:send("</>")
            end
            actor:send("You still need to find:")
            if (boots or 0) == 0 then
                actor:send(tostring(objects.template(520, 8).name) .. ".")
            end
            if (cloak or 0) == 0 then
                actor:send(tostring(objects.template(520, 9).name) .. ".")
            end
            if (ring or 0) == 0 then
                actor:send(tostring(objects.template(520, 1).name) .. ".")
            end
        end
    end
end
return _return_value$trig$, 'cd9e4bffce061d54345381661c5a9db6'),
  -- data/triggers/004/004_101_enlightenment_progress_journal.lua
  (4, 101, $trig$-- Converted from DG Script #501: Enlightenment progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if string.find(arg, "enlightenment") or string.find(arg, "monk vision") or string.find(arg, "monk_vision") then
    if string.find(actor.class, "monk") then
        _return_value = true
        local missionstage = actor:get_quest_stage("elemental_chaos")
        local visionstage = actor:get_quest_stage("monk_vision")
        local master = mobiles.template(53, 8).name
        local job1 = actor:get_quest_var("monk_vision:visiontask1")
        local job2 = actor:get_quest_var("monk_vision:visiontask2")
        local job3 = actor:get_quest_var("monk_vision:visiontask3")
        local job4 = actor:get_quest_var("monk_vision:visiontask4")
        actor:send("<b:u:green>Enlightenment</>")
        local level
        if (visionstage or 0) == 0 then
            level = 10
        else
            level = visionstage * 10
        end
        if not actor:get_has_completed("monk_vision") then
            actor:send("Minimum Level: " .. tostring(level))
        end
        local status
        if actor:get_has_completed("monk_vision") then
            status = "Completed!"
        elseif (visionstage or 0) > 0 then
            status = "In Progress"
        else
            status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
        if actor.level >= level then
            if visionstage == 0 then
                actor:send("You must undertake a <b:cyan>[mission]</> in service of Balance first.")
                return _return_value
            elseif (visionstage >= missionstage) and not actor:get_has_completed("elemental_chaos") then
                actor:send("You must walk further along the Way in service of Balance first.")
                return _return_value
            end
            -- switch on visionstage
            local book
            local gem
            local room
            local place
            local hint
            do
                local _sw1 = string.lower(tostring(visionstage or ""))
                if tonumber(_sw1) == 1 then
                    book = 59006
                    gem = 55582
                    room = get_room("4328")
                    place = room.name
                    hint = "in a place to perform."
                elseif tonumber(_sw1) == 2 then
                    book = 18505
                    gem = 55591
                    room = get_room("58707")
                    place = room.name
                    hint = "near a sandy beach."
                elseif tonumber(_sw1) == 3 then
                    book = 8501
                    gem = 55623
                    room = get_room("18597")
                    place = room.name
                    hint = "in a cloistered library."
                elseif tonumber(_sw1) == 4 then
                    book = 12532
                    gem = 55655
                    room = get_room("58102")
                    place = room.name
                    hint = "on Hakujo's home island."
                elseif tonumber(_sw1) == 5 then
                    book = 16209
                    gem = 55665
                    room = get_room("16057")
                    place = room.name
                    hint = "in the ghostly fortress."
                elseif tonumber(_sw1) == 6 then
                    book = 43013
                    gem = 55678
                    room = get_room("59054")
                    place = room.name
                    hint = "in the fortress of the zealous."
                elseif tonumber(_sw1) == 7 then
                    book = 53009
                    gem = 55710
                    room = get_room("49079")
                    place = room.name
                    hint = "off-shore of the island of great beasts."
                elseif tonumber(_sw1) == 8 then
                    book = 58415
                    gem = 55722
                    room = get_room("11820")
                    place = room.name
                    hint = "beyond the Blue-Fog Trail."
                elseif tonumber(_sw1) == 9 then
                    book = 58412
                    gem = 55741
                    room = get_room("52075")
                    place = room.name
                    hint = "in the shattered citadel of Templace."
                end
            end
            local attack = visionstage * 100
            if job1 or job2 or job3 or job4 then
                actor:send("You've done the following:")
                if job1 then
                    actor:send("- attacked " .. tostring(attack) .. " times")
                end
                if job2 then
                    actor:send("- found " .. "%get.obj_shortdesc[%gem%]%")
                end
                if job3 then
                    actor:send("- found " .. "%get.obj_shortdesc[%book%]%")
                end
                if job4 then
                    actor:send("- read in " .. tostring(place))
                end
            end
            actor:send("</>")
            actor:send("You need to:")
            if job1 and job2 and job3 and job4 then
                actor:send("Give " .. tostring(master) .. " your current vision mark.")
                return _return_value
            end
            if not job1 then
                local remaining = attack - (actor:get_quest_var("monk_vision:attack_counter") or 0)
                actor:send("- attack <b:black>" .. tostring(remaining) .. "</> more times while wearing your vision mark.")
            end
            if not job4 then
                actor:send("- find <b:yellow>" .. "%get.obj_shortdesc[%gem%]%</> and <b:yellow>%get.obj_shortdesc[%book%]%</> and <b:yellow>read</> in a place called \"<b:yellow>%place%</>\".")
                actor:send("</>   It's <b:green>" .. tostring(hint) .. "</>")
            else
                if not job2 then
                    actor:send("- bring " .. tostring(master) .. " <b:yellow>" .. "%get.obj_shortdesc[%gem%]%</>")
                end
                if not job3 then
                    actor:send("- bring " .. tostring(master) .. " <b:yellow>" .. "%get.obj_shortdesc[%book%]%</>")
                end
            end
        end
    end
end
return _return_value$trig$, 'dc0b269676e3b55c9f89436f94323544'),
  -- data/triggers/004/004_10_vilekka_stew_progress_journal.lua
  (4, 10, $trig$-- Converted from DG Script #410: Vilekka Stew progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if string.find(arg, "service") or string.find(arg, "lolth") or string.find(arg, "vilekka_stew") or string.find(arg, "vilekka") or string.find(arg, "stew") or string.find(arg, "drow boots") or string.find(arg, "in_service_of_lolth") or string.find(arg, "drow_boots") or string.find(arg, "drow") then
    if actor.level >= 25 then
        _return_value = true
        local stage = actor:get_quest_stage("vilekka_stew")
        actor:send("<b:u:green>In Service of Lolth</>")
        actor:send("This quest is only available to neutral and evil-aligned characters.")
        actor:send("Recommended Level: 90")
        actor:send("- This quest starts at level 25 and continues through level 90.")
        local status
        if actor:get_has_completed("vilekka_stew") then
            status = "Completed!"
        elseif (stage or 0) > 0 then
            status = "In Progress"
        else
            status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
        if stage > 0 and not actor:get_has_completed("vilekka_stew") then
            actor:send("Quest Master: " .. tostring(mobiles.template(237, 28).name))
            actor:send("</>")
            -- switch on stage
            do
                local _sw1 = string.lower(tostring(stage or ""))
                if tonumber(_sw1) == 1 then
                    actor:send("Bring Vilekka the heart of the drow living in the surface city!")
                elseif tonumber(_sw1) == 2 then
                    actor:send("Tell Vilekka if you wish to stop or continue.")
                elseif tonumber(_sw1) == 3 then
                    actor:send("You must bring Vilekka the head of the drider king.")
                elseif tonumber(_sw1) == 4 then
                    actor:send("Tell Vilekka if you wish to stop or continue.")
                elseif tonumber(_sw1) == 5 then
                    local num_spices = actor:get_quest_var("vilekka_stew:num_spices")
                    local spice1 = actor:get_quest_var("vilekka_stew:got_spice:12552")
                    local spice2 = actor:get_quest_var("vilekka_stew:got_spice:49022")
                    local spice3 = actor:get_quest_var("vilekka_stew:got_spice:23750")
                    local spice4 = actor:get_quest_var("vilekka_stew:got_spice:23751")
                    local spice5 = actor:get_quest_var("vilekka_stew:got_spice:23752")
                    local spice6 = actor:get_quest_var("vilekka_stew:got_spice:23753")
                    local spice7 = actor:get_quest_var("vilekka_stew:got_spice:23754")
                    local spice8 = actor:get_quest_var("vilekka_stew:got_spice:23755")
                    local spice9 = actor:get_quest_var("vilekka_stew:got_spice:23756")
                    local spice10 = actor:get_quest_var("vilekka_stew:got_spice:23757")
                    local spice11 = actor:get_quest_var("vilekka_stew:got_spice:23758")
                    local spice12 = actor:get_quest_var("vilekka_stew:got_spice:23759")
                    local spice13 = actor:get_quest_var("vilekka_stew:got_spice:23760")
                    actor:send("Bring Vilekka 10 herbs and spices so that she can make a stew out of the head and heart.")
                    if (num_spices or 0) > 0 then
                        actor:send("</>")
                        actor:send("So far you have brought:")
                        if spice1 then
                            actor:send("- " .. tostring(objects.template(125, 52).name))
                        end
                        if spice2 then
                            actor:send("- " .. tostring(objects.template(490, 22).name))
                        end
                        if spice3 then
                            actor:send("- " .. tostring(objects.template(237, 50).name))
                        end
                        if spice4 then
                            actor:send("- " .. tostring(objects.template(237, 51).name))
                        end
                        if spice5 then
                            actor:send("- " .. tostring(objects.template(237, 52).name))
                        end
                        if spice6 then
                            actor:send("- " .. tostring(objects.template(237, 53).name))
                        end
                        if spice7 then
                            actor:send("- " .. tostring(objects.template(237, 54).name))
                        end
                        if spice8 then
                            actor:send("- " .. tostring(objects.template(237, 55).name))
                        end
                        if spice9 then
                            actor:send("- " .. tostring(objects.template(237, 56).name))
                        end
                        if spice10 then
                            actor:send("- " .. tostring(objects.template(237, 57).name))
                        end
                        if spice11 then
                            actor:send("- " .. tostring(objects.template(237, 58).name))
                        end
                        if spice12 then
                            actor:send("- " .. tostring(objects.template(237, 59).name))
                        end
                        if spice13 then
                            actor:send("- " .. tostring(objects.template(237, 60).name))
                        end
                    end
                    actor:send("</>")
                    local total = 10 - (num_spices or 0)
                    actor:send("Bring " .. tostring(total) .. " more spices to prepare the stew.")
                end
            end
        end
    end
end
return _return_value$trig$, '3942c6542312245eb81c96d05dd868fc'),
  -- data/triggers/004/004_11_guild_armor_phase_one_progress_journal.lua
  (4, 11, $trig$-- Converted from DG Script #411: Guild Armor Phase One progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if ((string.find(arg, "guild") or string.find(arg, "phase") or string.find(arg, "armor")) and (string.find(arg, "one") or string.find(arg, "1"))) or string.find(arg, "guild_armor_phase_one") or string.find(arg, "guild_armor_phase_1") or string.find(arg, "phase_armor_one") or string.find(arg, "phase_armor_1") then
    _return_value = true
    actor:send("<b:u:green>Guild Armor Phase One</>")
    actor:send("Mininum Level: 1")
    actor:send("Items for this quest drop from mobs between level 1 and 20.")
    if actor:get_quest_stage("phase_armor") > 0 then
        local sorcererclasses = "Sorcerer Cryomancer Pyromancer Illusionist Necromancer"
        local clericclasses = "Cleric Priest Druid Diabolist"
        local warriorclasses = "Warrior Anti-Paladin Ranger Paladin Monk Berserker"
        local rogueclasses = "Rogue Mercenary Assassin Thief Bard"
        local feet_gem
        local head_gem
        local hands_gem
        local arms_gem
        local legs_gem
        local body_gem
        local wrist_gem
        local feet_armor
        local head_armor
        local hands_armor
        local arms_armor
        local legs_armor
        local body_armor
        local wrist_armor
        local feet_reward
        local head_reward
        local hands_reward
        local arms_reward
        local legs_reward
        local body_reward
        local wrist_reward
        local master
        if string.find(string.lower(sorcererclasses), actor.class, 1, true) then
            feet_gem = 55571
            head_gem = 55579
            hands_gem = 55567
            arms_gem = 55583
            legs_gem = 55587
            body_gem = 55591
            wrist_gem = 55575
            feet_armor = 55306
            head_armor = 55314
            hands_armor = 55302
            arms_armor = 55318
            legs_armor = 55322
            body_armor = 55326
            wrist_armor = 55310
            feet_reward = 55402
            head_reward = 55398
            hands_reward = 55404
            arms_reward = 55399
            legs_reward = 55401
            body_reward = 55400
            wrist_reward = 55403
            master = "the Archmage of Mielikki and Gagar"
        elseif string.find(string.lower(clericclasses), actor.class, 1, true) then
            feet_gem = 55570
            head_gem = 55578
            hands_gem = 55566
            arms_gem = 55582
            legs_gem = 55586
            body_gem = 55590
            wrist_gem = 55574
            feet_armor = 55304
            head_armor = 55312
            hands_armor = 55300
            arms_armor = 55316
            legs_armor = 55320
            body_armor = 55324
            wrist_armor = 55308
            feet_reward = 55395
            head_reward = 55391
            hands_reward = 55397
            arms_reward = 55392
            legs_reward = 55394
            body_reward = 55393
            wrist_reward = 55396
            master = "the High Priestess of Mielikki and Rorgdush"
        elseif string.find(string.lower(warriorclasses), actor.class, 1, true) then
            feet_gem = 55573
            head_gem = 55581
            hands_gem = 55569
            arms_gem = 55585
            legs_gem = 55589
            body_gem = 55593
            wrist_gem = 55577
            feet_armor = 55304
            head_armor = 55312
            hands_armor = 55300
            arms_armor = 55316
            legs_armor = 55320
            body_armor = 55324
            wrist_armor = 55308
            feet_reward = 55388
            head_reward = 55384
            hands_reward = 55390
            arms_reward = 55385
            legs_reward = 55387
            body_reward = 55386
            wrist_reward = 55389
            master = "the Warrior Coach of Mielikki and Grort"
        elseif string.find(string.lower(rogueclasses), actor.class, 1, true) then
            feet_gem = 55572
            head_gem = 55580
            hands_gem = 55568
            arms_gem = 55584
            legs_gem = 55588
            body_gem = 55592
            wrist_gem = 55576
            feet_armor = 55305
            head_armor = 55313
            hands_armor = 55301
            arms_armor = 55317
            legs_armor = 55321
            body_armor = 55325
            wrist_armor = 55309
            feet_reward = 55409
            head_reward = 55405
            hands_reward = 55411
            arms_reward = 55406
            legs_reward = 55408
            body_reward = 55407
            wrist_reward = 55410
            master = "the Master Rogue of Mielikki and Tinilas"
        end
        local got_hands = actor:get_quest_var("phase_armor:hands_armor_armor_acquired")
        local got_feet = actor:get_quest_var("phase_armor:feet_armor_armor_acquired")
        local got_wrist = actor:get_quest_var("phase_armor:wrist_armor_armor_acquired")
        local got_head = actor:get_quest_var("phase_armor:head_armor_armor_acquired")
        local got_arms = actor:get_quest_var("phase_armor:arms_armor_armor_acquired")
        local got_legs = actor:get_quest_var("phase_armor:legs_armor_armor_acquired")
        local got_body = actor:get_quest_var("phase_armor:body_armor_armor_acquired")
        local hands_count = actor:get_quest_var("phase_armor:hands_gem_gems_acquired")
        local feet_count = actor:get_quest_var("phase_armor:feet_gem_gems_acquired")
        local wrist_count = actor:get_quest_var("phase_armor:wrist_gem_gems_acquired")
        local head_count = actor:get_quest_var("phase_armor:head_gem_gems_acquired")
        local arms_count = actor:get_quest_var("phase_armor:arms_gem_gems_acquired")
        local legs_count = actor:get_quest_var("phase_armor:legs_gem_gems_acquired")
        local body_count = actor:get_quest_var("phase_armor:body_gem_gems_acquired")
        local done_hands = (got_hands or 0) == 1  and  (hands_count or 0) == 3
        local done_feet = (got_feet or 0) == 1  and  (feet_count or 0) == 3
        local done_wrist = (got_wrist or 0) == 1  and  (wrist_count or 0) == 3
        local done_head = (got_head or 0) == 1  and  (head_count or 0) == 3
        local done_arms = (got_arms or 0) == 1  and  (arms_count or 0) == 3
        local done_legs = (got_legs or 0) == 1  and  (legs_count or 0) == 3
        local done_body = (got_body or 0) == 1  and  (body_count or 0) == 3
        local given = (got_hands or 0) + (got_feet or 0) + (got_wrist or 0) + (got_head or 0) + (got_arms or 0) + (got_legs or 0) + (got_body or 0)
        given = given + (hands_count or 0) + (feet_count or 0) + (wrist_count or 0) + (head_count or 0) + (arms_count or 0) + (legs_count or 0) + (body_count or 0)
        local unrewarded = ((got_hands or 0) + (hands_count or 0)  ~=  4) + ((got_feet or 0) + (feet_count or 0)  ~=  4) + ((got_wrist or 0) + (wrist_count or 0)  ~=  4)
        unrewarded = unrewarded + ((got_head or 0) + (head_count or 0)  ~=  4) + ((got_arms or 0) + (arms_count or 0)  ~=  4)
        unrewarded = unrewarded + ((got_legs or 0) + (legs_count or 0)  ~=  4) + ((got_body or 0) + (body_count or 0)  ~=  4)
        if done_hands and done_feet and done_wrist and done_head and done_arms and done_legs and done_body then
            actor:send("<cyan>Status: Completed!</>")
            return _return_value
        end
        actor:send("<cyan>Status: In Progress</>")
        actor:send("Quest Master is: " .. tostring(master))
        actor:send("You need to retrieve:")
        actor:send("</>  " .. "%get.obj_shortdesc[%hands_armor%]% and 3 of %get.obj_shortdesc[%hands_gem%]%")
        actor:send("</>  " .. "%get.obj_shortdesc[%feet_armor%]% and 3 of %get.obj_shortdesc[%feet_gem%]%")
        actor:send("</>  " .. "%get.obj_shortdesc[%wrist_armor%]% and 3 of %get.obj_shortdesc[%wrist_gem%]%")
        actor:send("</>  " .. "%get.obj_shortdesc[%head_armor%]% and 3 of %get.obj_shortdesc[%head_gem%]%")
        actor:send("</>  " .. "%get.obj_shortdesc[%arms_armor%]% and 3 of %get.obj_shortdesc[%arms_gem%]%")
        actor:send("</>  " .. "%get.obj_shortdesc[%legs_armor%]% and 3 of %get.obj_shortdesc[%legs_gem%]%")
        actor:send("</>  " .. "%get.obj_shortdesc[%body_armor%]% and 3 of %get.obj_shortdesc[%body_gem%]%")
        if not given then
            actor:send("You haven't retrieved anything yet.")
            return _return_value
        elseif unrewarded then
            actor:send("You have found:")
        end
        if got_hands and not done_hands then
            actor:send("</>  " .. "%get.obj_shortdesc[%hands_armor%]%")
        end
        if hands_count and not done_hands then
            actor:send("</>  " .. tostring(hands_count) .. " of " .. "%get.obj_shortdesc[%hands_gem%]%")
        end
        if got_feet and not done_feet then
            actor:send("</>  " .. "%get.obj_shortdesc[%feet_armor%]%")
        end
        if feet_count and not done_feet then
            actor:send("</>  " .. tostring(feet_count) .. " of " .. "%get.obj_shortdesc[%feet_gem%]%")
        end
        if got_wrist and not done_wrist then
            actor:send("</>  " .. "%get.obj_shortdesc[%wrist_armor%]%")
        end
        if wrist_count and not done_wrist then
            actor:send("</>  " .. tostring(wrist_count) .. " of " .. "%get.obj_shortdesc[%wrist_gem%]%")
        end
        if got_head and not done_head then
            actor:send("</>  " .. "%get.obj_shortdesc[%head_armor%]%")
        end
        if head_count and not done_head then
            actor:send("</>  " .. tostring(head_count) .. " of " .. "%get.obj_shortdesc[%head_gem%]%")
        end
        if got_arms and not done_arms then
            actor:send("</>  " .. "%get.obj_shortdesc[%arms_armor%]%")
        end
        if arms_count and not done_arms then
            actor:send("</>  " .. tostring(arms_count) .. " of " .. "%get.obj_shortdesc[%arms_gem%]%")
        end
        if got_legs and not done_legs then
            actor:send("</>  " .. "%get.obj_shortdesc[%legs_armor%]%")
        end
        if legs_count and not done_legs then
            actor:send("</>  " .. tostring(legs_count) .. " of " .. "%get.obj_shortdesc[%legs_gem%]%")
        end
        if got_body and not done_body then
            actor:send("</>  " .. "%get.obj_shortdesc[%body_armor%]%")
        end
        if body_count and not done_body then
            actor:send("</>  " .. tostring(body_count) .. " of " .. "%get.obj_shortdesc[%body_gem%]%")
        end
        if done_hands and done_feet and done_wrist and done_head and done_arms and done_legs and done_body then
            actor:send("</>")
            actor:send("You have completed quests for:")
        end
        if done_hands then
            actor:send("</>  " .. "%get.obj_shortdesc[%hands_reward%]%")
        end
        if done_feet then
            actor:send("</>  " .. "%get.obj_shortdesc[%feet_reward%]%")
        end
        if done_wrist then
            actor:send("</>  " .. "%get.obj_shortdesc[%wrist_reward%]%")
        end
        if done_head then
            actor:send("</>  " .. "%get.obj_shortdesc[%head_reward%]%")
        end
        if done_arms then
            actor:send("</>  " .. "%get.obj_shortdesc[%arms_reward%]%")
        end
        if done_legs then
            actor:send("</>  " .. "%get.obj_shortdesc[%legs_reward%]%")
        end
        if done_body then
            actor:send("</>  " .. "%get.obj_shortdesc[%body_reward%]%")
        end
    else
        actor:send("<cyan>Status: Not Started</>")
    end
end
return _return_value$trig$, '84ee4f855df31734e0761f5cae0a0f51'),
  -- data/triggers/004/004_12_guild_armor_phase_two_progress_journal.lua
  (4, 12, $trig$-- Converted from DG Script #412: Guild Armor Phase Two progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if ((string.find(arg, "guild") or string.find(arg, "phase") or string.find(arg, "armor")) and (string.find(arg, "two") or string.find(arg, "2"))) or string.find(arg, "guild_armor_phase_two") or string.find(arg, "guild_armor_phase_2") or string.find(arg, "phase_armor_two") or string.find(arg, "phase_armor_2") then
    _return_value = true
    actor:send("<b:u:green>Guild Armor Phase Two</>")
    actor:send("Mininum Level: 21")
    actor:send("Items for this quest drop from mobs between level 21 and 40.")
    if actor:get_quest_stage("phase_armor") > 1 then
        local sorcererclasses = "Sorcerer Cryomancer Pyromancer Illusionist"
        local clericclasses = "Cleric Priest"
        local rogueclasses = "Rogue Mercenary Assassin Thief"
        local anti = "Anti-Paladin"
        local master
        if string.find(string.lower(sorcererclasses), actor.class, 1, true) then
            local feet_gem = 55613
            local head_gem = 55635
            local hands_gem = 55602
            local arms_gem = 55646
            local legs_gem = 55657
            local body_gem = 55668
            local wrist_gem = 55624
            local feet_armor = 55335
            local head_armor = 55343
            local hands_armor = 55331
            local arms_armor = 55347
            local legs_armor = 55351
            local body_armor = 55355
            local wrist_armor = 55339
            local feet_reward = 55479
            local head_reward = 55475
            local hands_reward = 55481
            local arms_reward = 55476
            local legs_reward = 55478
            local body_reward = 55477
            local wrist_reward = 55480
            if string.find(actor.class, "sorcerer") then
                master = "the Archmage of Ickle"
            elseif string.find(actor.class, "cryomancer") then
                master = "the Archmage of Ickle, the High Cryomancer, and the master cryomancer"
            elseif string.find(actor.class, "pyromancer") then
                master = "the Archmage of Ickle, the High Pyromancer, and the master pyromancer"
            elseif string.find(actor.class, "illusionist") then
                master = "the Archmage of Ickle, Erasmus, and Esh"
            end
        elseif string.find(actor.class, "necromancer") then
            local feet_gem = 55609
            local head_gem = 55631
            local hands_gem = 55598
            local arms_gem = 55642
            local legs_gem = 55653
            local body_gem = 55664
            local wrist_gem = 55620
            local feet_armor = 55335
            local head_armor = 55343
            local hands_armor = 55331
            local arms_armor = 55347
            local legs_armor = 55351
            local body_armor = 55355
            local wrist_armor = 55339
            local feet_reward = 55458
            local head_reward = 55454
            local hands_reward = 55460
            local arms_reward = 55455
            local legs_reward = 55457
            local body_reward = 55456
            local wrist_reward = 55459
            master = "Asiri'Qaxt and Schkerra"
        elseif string.find(string.lower(clericclasses), actor.class, 1, true) then
            local feet_gem = 55612
            local head_gem = 55634
            local hands_gem = 55601
            local arms_gem = 55645
            local legs_gem = 55656
            local body_gem = 55667
            local wrist_gem = 55623
            local feet_armor = 55332
            local head_armor = 55340
            local hands_armor = 55328
            local arms_armor = 55344
            local legs_armor = 55348
            local body_armor = 55352
            local wrist_armor = 55336
            local feet_reward = 55437
            local head_reward = 55433
            local hands_reward = 55439
            local arms_reward = 55434
            local legs_reward = 55436
            local body_reward = 55435
            local wrist_reward = 55438
            master = "the High Priestess of Anduin and Zeno the Priest"
        elseif string.find(actor.class, "diabolist") then
            local feet_gem = 55606
            local head_gem = 55628
            local hands_gem = 55595
            local arms_gem = 55639
            local legs_gem = 55650
            local body_gem = 55661
            local wrist_gem = 55617
            local feet_armor = 55332
            local head_armor = 55340
            local hands_armor = 55328
            local arms_armor = 55344
            local legs_armor = 55348
            local body_armor = 55352
            local wrist_armor = 55336
            local feet_reward = 55472
            local head_reward = 55468
            local hands_reward = 55474
            local arms_reward = 55469
            local legs_reward = 55471
            local body_reward = 55470
            local wrist_reward = 55473
            master = "the Black Priestess"
        elseif string.find(actor.class, "druid") then
            local feet_gem = 55607
            local head_gem = 55629
            local hands_gem = 55596
            local arms_gem = 55640
            local legs_gem = 55651
            local body_gem = 55662
            local wrist_gem = 55618
            local feet_armor = 55334
            local head_armor = 55342
            local hands_armor = 55330
            local arms_armor = 55346
            local legs_armor = 55350
            local body_armor = 55354
            local wrist_armor = 55338
            local feet_reward = 55451
            local head_reward = 55447
            local hands_reward = 55453
            local arms_reward = 55448
            local legs_reward = 55450
            local body_reward = 55449
            local wrist_reward = 55452
            master = "the Black Priestess and the diabolist"
        elseif string.find(actor.class, "warrior") then
            local feet_gem = 55615
            local head_gem = 55637
            local hands_gem = 55604
            local arms_gem = 55648
            local legs_gem = 55659
            local body_gem = 55670
            local wrist_gem = 55626
            local feet_armor = 55332
            local head_armor = 55340
            local hands_armor = 55328
            local arms_armor = 55344
            local legs_armor = 55348
            local body_armor = 55352
            local wrist_armor = 55336
            local feet_reward = 55416
            local head_reward = 55412
            local hands_reward = 55418
            local arms_reward = 55413
            local legs_reward = 55415
            local body_reward = 55414
            local wrist_reward = 55417
            master = "the high druid and a serene druidess"
        elseif actor.class == "anti-paladin" then
            local feet_gem = 55605
            local head_gem = 55627
            local hands_gem = 55594
            local arms_gem = 55638
            local legs_gem = 55649
            local body_gem = 55660
            local wrist_gem = 55616
            local feet_armor = 55332
            local head_armor = 55340
            local hands_armor = 55328
            local arms_armor = 55344
            local legs_armor = 55348
            local body_armor = 55352
            local wrist_armor = 55336
            local feet_reward = 55430
            local head_reward = 55426
            local hands_reward = 55432
            local arms_reward = 55427
            local legs_reward = 55429
            local body_reward = 55428
            local wrist_reward = 55431
            master = "the warrior coach of Anduin"
        elseif string.find(actor.class, "ranger") then
            local feet_gem = 55611
            local head_gem = 55633
            local hands_gem = 55600
            local arms_gem = 55644
            local legs_gem = 55655
            local body_gem = 55666
            local wrist_gem = 55622
            local feet_armor = 55333
            local head_armor = 55341
            local hands_armor = 55329
            local arms_armor = 55345
            local legs_armor = 55349
            local body_armor = 55353
            local wrist_armor = 55337
            local feet_reward = 55444
            local head_reward = 55440
            local hands_reward = 55446
            local arms_reward = 55441
            local legs_reward = 55443
            local body_reward = 55442
            local wrist_reward = 55445
            master = "Galithel Silverwing"
        elseif actor.class == "paladin" then
            local feet_gem = 55610
            local head_gem = 55632
            local hands_gem = 55599
            local arms_gem = 55643
            local legs_gem = 55654
            local body_gem = 55665
            local wrist_gem = 55621
            local feet_armor = 55332
            local head_armor = 55340
            local hands_armor = 55328
            local arms_armor = 55344
            local legs_armor = 55348
            local body_armor = 55352
            local wrist_armor = 55336
            local feet_reward = 55423
            local head_reward = 55419
            local hands_reward = 55425
            local arms_reward = 55420
            local legs_reward = 55422
            local body_reward = 55421
            local wrist_reward = 55424
            master = "the Grey Knight"
        elseif string.find(actor.class, "monk") then
            local feet_gem = 55608
            local head_gem = 55630
            local hands_gem = 55597
            local arms_gem = 55641
            local legs_gem = 55652
            local body_gem = 55663
            local wrist_gem = 55619
            local feet_armor = 55334
            local head_armor = 55342
            local hands_armor = 55330
            local arms_armor = 55346
            local legs_armor = 55350
            local body_armor = 55354
            local wrist_armor = 55338
            local feet_reward = 55465
            local head_reward = 55461
            local hands_reward = 55467
            local arms_reward = 55462
            local legs_reward = 55464
            local body_reward = 55463
            local wrist_reward = 55466
            master = "the Head Monk"
        elseif string.find(actor.class, "berserker") then
            local feet_gem = 55607
            local head_gem = 55631
            local hands_gem = 55595
            local arms_gem = 55638
            local legs_gem = 55655
            local body_gem = 55665
            local wrist_gem = 55619
            local feet_armor = 55334
            local head_armor = 55342
            local hands_armor = 55330
            local arms_armor = 55346
            local legs_armor = 55350
            local body_armor = 55354
            local wrist_armor = 55338
            local feet_reward = 55771
            local head_reward = 55767
            local hands_reward = 55773
            local arms_reward = 55768
            local legs_reward = 55770
            local body_reward = 55769
            local wrist_reward = 55772
            master = "Tozug, Khargol, Jora Granitearm"
        elseif string.find(string.lower(rogueclasses), actor.class, 1, true) then
            local feet_gem = 55614
            local head_gem = 55636
            local hands_gem = 55603
            local arms_gem = 55647
            local legs_gem = 55658
            local body_gem = 55669
            local wrist_gem = 55625
            local feet_armor = 55333
            local head_armor = 55341
            local hands_armor = 55329
            local arms_armor = 55345
            local legs_armor = 55349
            local body_armor = 55353
            local wrist_armor = 55337
            local feet_reward = 55486
            local head_reward = 55482
            local hands_reward = 55488
            local arms_reward = 55483
            local legs_reward = 55485
            local body_reward = 55484
            local wrist_reward = 55487
            master = "Princess Signess, Haren, and Blackhaven"
        elseif string.find(actor.class, "bard") then
            local feet_gem = 55606
            local head_gem = 55630
            local hands_gem = 55600
            local arms_gem = 55640
            local legs_gem = 55649
            local body_gem = 55664
            local wrist_gem = 55621
            local feet_armor = 55334
            local head_armor = 55342
            local hands_armor = 55330
            local arms_armor = 55346
            local legs_armor = 55350
            local body_armor = 55354
            local wrist_armor = 55338
            local feet_reward = 55785
            local head_reward = 55781
            local hands_reward = 55787
            local arms_reward = 55782
            local legs_reward = 55784
            local body_reward = 55783
            local wrist_reward = 55786
            master = "the Master Herald and the Bard Union Master"
        end
        local got_hands = actor:get_quest_var("phase_armor:hands_armor_armor_acquired")
        local got_feet = actor:get_quest_var("phase_armor:feet_armor_armor_acquired")
        local got_wrist = actor:get_quest_var("phase_armor:wrist_armor_armor_acquired")
        local got_head = actor:get_quest_var("phase_armor:head_armor_armor_acquired")
        local got_arms = actor:get_quest_var("phase_armor:arms_armor_armor_acquired")
        local got_legs = actor:get_quest_var("phase_armor:legs_armor_armor_acquired")
        local got_body = actor:get_quest_var("phase_armor:body_armor_armor_acquired")
        local hands_count = actor:get_quest_var("phase_armor:hands_gem_gems_acquired")
        local feet_count = actor:get_quest_var("phase_armor:feet_gem_gems_acquired")
        local wrist_count = actor:get_quest_var("phase_armor:wrist_gem_gems_acquired")
        local head_count = actor:get_quest_var("phase_armor:head_gem_gems_acquired")
        local arms_count = actor:get_quest_var("phase_armor:arms_gem_gems_acquired")
        local legs_count = actor:get_quest_var("phase_armor:legs_gem_gems_acquired")
        local body_count = actor:get_quest_var("phase_armor:body_gem_gems_acquired")
        local done_hands = (got_hands or 0) == 1  and  (hands_count or 0) == 3
        local done_feet = (got_feet or 0) == 1  and  (feet_count or 0) == 3
        local done_wrist = (got_wrist or 0) == 1  and  (wrist_count or 0) == 3
        local done_head = (got_head or 0) == 1  and  (head_count or 0) == 3
        local done_arms = (got_arms or 0) == 1  and  (arms_count or 0) == 3
        local done_legs = (got_legs or 0) == 1  and  (legs_count or 0) == 3
        local done_body = (got_body or 0) == 1  and  (body_count or 0) == 3
        local given = (got_hands or 0) + (got_feet or 0) + (got_wrist or 0) + (got_head or 0) + (got_arms or 0) + (got_legs or 0) + (got_body or 0)
        given = given + (hands_count or 0) + (feet_count or 0) + (wrist_count or 0) + (head_count or 0) + (arms_count or 0) + (legs_count or 0) + (body_count or 0)
        local unrewarded = ((got_hands or 0) + (hands_count or 0)  ~=  4) + ((got_feet or 0) + (feet_count or 0)  ~=  4) + ((got_wrist or 0) + (wrist_count or 0)  ~=  4)
        unrewarded = unrewarded + ((got_head or 0) + (head_count or 0)  ~=  4) + ((got_arms or 0) + (arms_count or 0)  ~=  4)
        unrewarded = unrewarded + ((got_legs or 0) + (legs_count or 0)  ~=  4) + ((got_body or 0) + (body_count or 0)  ~=  4)
        if done_hands and done_feet and done_wrist and done_head and done_arms and done_legs and done_body then
            actor:send("<cyan>Status: Completed!</>")
            return _return_value
        end
        actor:send("<cyan>Status: In Progress</>")
        actor:send("Quest Master is: " .. tostring(master))
        actor:send("You need to retrieve:")
        actor:send("</>  " .. "%get.obj_shortdesc[%hands_armor%]% and 3 of %get.obj_shortdesc[%hands_gem%]%")
        actor:send("</>  " .. "%get.obj_shortdesc[%feet_armor%]% and 3 of %get.obj_shortdesc[%feet_gem%]%")
        actor:send("</>  " .. "%get.obj_shortdesc[%wrist_armor%]% and 3 of %get.obj_shortdesc[%wrist_gem%]%")
        actor:send("</>  " .. "%get.obj_shortdesc[%head_armor%]% and 3 of %get.obj_shortdesc[%head_gem%]%")
        actor:send("</>  " .. "%get.obj_shortdesc[%arms_armor%]% and 3 of %get.obj_shortdesc[%arms_gem%]%")
        actor:send("</>  " .. "%get.obj_shortdesc[%legs_armor%]% and 3 of %get.obj_shortdesc[%legs_gem%]%")
        actor:send("</>  " .. "%get.obj_shortdesc[%body_armor%]% and 3 of %get.obj_shortdesc[%body_gem%]%")
        if not given then
            actor:send("You haven't retrieved anything yet.")
            return _return_value
        elseif unrewarded then
            actor:send("You have found:")
        end
        if got_hands and not done_hands then
            actor:send("</>  " .. "%get.obj_shortdesc[%hands_armor%]%")
        end
        if hands_count and not done_hands then
            actor:send("</>  " .. tostring(hands_count) .. " of " .. "%get.obj_shortdesc[%hands_gem%]%")
        end
        if got_feet and not done_feet then
            actor:send("</>  " .. "%get.obj_shortdesc[%feet_armor%]%")
        end
        if feet_count and not done_feet then
            actor:send("</>  " .. tostring(feet_count) .. " of " .. "%get.obj_shortdesc[%feet_gem%]%")
        end
        if got_wrist and not done_wrist then
            actor:send("</>  " .. "%get.obj_shortdesc[%wrist_armor%]%")
        end
        if wrist_count and not done_wrist then
            actor:send("</>  " .. tostring(wrist_count) .. " of " .. "%get.obj_shortdesc[%wrist_gem%]%")
        end
        if got_head and not done_head then
            actor:send("</>  " .. "%get.obj_shortdesc[%head_armor%]%")
        end
        if head_count and not done_head then
            actor:send("</>  " .. tostring(head_count) .. " of " .. "%get.obj_shortdesc[%head_gem%]%")
        end
        if got_arms and not done_arms then
            actor:send("</>  " .. "%get.obj_shortdesc[%arms_armor%]%")
        end
        if arms_count and not done_arms then
            actor:send("</>  " .. tostring(arms_count) .. " of " .. "%get.obj_shortdesc[%arms_gem%]%")
        end
        if got_legs and not done_legs then
            actor:send("</>  " .. "%get.obj_shortdesc[%legs_armor%]%")
        end
        if legs_count and not done_legs then
            actor:send("</>  " .. tostring(legs_count) .. " of " .. "%get.obj_shortdesc[%legs_gem%]%")
        end
        if got_body and not done_body then
            actor:send("</>  " .. "%get.obj_shortdesc[%body_armor%]%")
        end
        if body_count and not done_body then
            actor:send("</>  " .. tostring(body_count) .. " of " .. "%get.obj_shortdesc[%body_gem%]%")
        end
        if done_hands and done_feet and done_wrist and done_head and done_arms and done_legs and done_body then
            actor:send("</>")
            actor:send("You have completed quests for:")
        end
        if done_hands then
            actor:send("</>  " .. "%get.obj_shortdesc[%hands_reward%]%")
        end
        if done_feet then
            actor:send("</>  " .. "%get.obj_shortdesc[%feet_reward%]%")
        end
        if done_wrist then
            actor:send("</>  " .. "%get.obj_shortdesc[%wrist_reward%]%")
        end
        if done_head then
            actor:send("</>  " .. "%get.obj_shortdesc[%head_reward%]%")
        end
        if done_arms then
            actor:send("</>  " .. "%get.obj_shortdesc[%arms_reward%]%")
        end
        if done_legs then
            actor:send("</>  " .. "%get.obj_shortdesc[%legs_reward%]%")
        end
        if done_body then
            actor:send("</>  " .. "%get.obj_shortdesc[%body_reward%]%")
        end
    else
        actor:send("<cyan>Status: Not Started</>")
    end
end
return _return_value$trig$, '488b21e724c1190a64c5076153871d5b'),
  -- data/triggers/004/004_13_guild_armor_phase_three_progress_journal.lua
  (4, 13, $trig$-- Converted from DG Script #413: Guild Armor Phase Three progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if ((string.find(arg, "guild") or string.find(arg, "phase") or string.find(arg, "armor")) and (string.find(arg, "three") or string.find(arg, "3"))) or string.find(arg, "guild_armor_phase_three") or string.find(arg, "guild_armor_phase_3") or string.find(arg, "phase_armor_three") or string.find(arg, "phase_armor_3") then
    _return_value = true
    actor:send("<b:u:green>Guild Armor Phase Three</>")
    actor:send("Mininum Level: 41")
    actor:send("Items for this quest drop from mobs above level 41.")
    if actor:get_quest_stage("phase_armor") > 2 then
        local sorcererclasses = "Sorcerer Cryomancer Pyromancer Illusionist"
        local clericclasses = "Cleric Priest"
        local rogueclasses = "Rogue Mercenary Assassin Thief"
        local anti = "Anti-Paladin"
        local master
        if string.find(string.lower(sorcererclasses), actor.class, 1, true) then
            local feet_gem = 55690
            local head_gem = 55712
            local hands_gem = 55679
            local arms_gem = 55723
            local legs_gem = 55734
            local body_gem = 55745
            local wrist_gem = 55701
            local feet_armor = 55363
            local head_armor = 55371
            local hands_armor = 55359
            local arms_armor = 55375
            local legs_armor = 55379
            local body_armor = 55383
            local wrist_armor = 55367
            local feet_reward = 55556
            local head_reward = 55552
            local hands_reward = 55558
            local arms_reward = 55553
            local legs_reward = 55555
            local body_reward = 55554
            local wrist_reward = 55557
            if string.find(actor.class, "sorcerer") then
                master = "the Archmage of Anduin"
            elseif string.find(actor.class, "cryomancer") then
                master = "a cryomancer in Anduin"
            elseif string.find(actor.class, "pyromancer") then
                master = "a pyromancer in Anduin"
            elseif string.find(actor.class, "illusionist") then
                master = "Aylana in Anduin"
            end
        elseif string.find(actor.class, "necromancer") then
            local feet_gem = 55686
            local head_gem = 55708
            local hands_gem = 55675
            local arms_gem = 55719
            local legs_gem = 55730
            local body_gem = 55741
            local wrist_gem = 55697
            local feet_armor = 55363
            local head_armor = 55371
            local hands_armor = 55359
            local arms_armor = 55375
            local legs_armor = 55379
            local body_armor = 55383
            local wrist_armor = 55367
            local feet_reward = 55535
            local head_reward = 55531
            local hands_reward = 55537
            local arms_reward = 55532
            local legs_reward = 55534
            local body_reward = 55533
            local wrist_reward = 55536
            master = "a necromancer in Anduin"
        elseif string.find(string.lower(clericclasses), actor.class, 1, true) then
            local feet_gem = 55689
            local head_gem = 55711
            local hands_gem = 55678
            local arms_gem = 55722
            local legs_gem = 55733
            local body_gem = 55744
            local wrist_gem = 55700
            local feet_armor = 55360
            local head_armor = 55368
            local hands_armor = 55356
            local arms_armor = 55372
            local legs_armor = 55376
            local body_armor = 55380
            local wrist_armor = 55364
            local feet_reward = 55514
            local head_reward = 55510
            local hands_reward = 55516
            local arms_reward = 55511
            local legs_reward = 55513
            local body_reward = 55512
            local wrist_reward = 55515
            master = "the High Priest Zalish"
        elseif string.find(actor.class, "diabolist") then
            local feet_gem = 55683
            local head_gem = 55705
            local hands_gem = 55672
            local arms_gem = 55716
            local legs_gem = 55727
            local body_gem = 55738
            local wrist_gem = 55694
            local feet_armor = 55360
            local head_armor = 55368
            local hands_armor = 55356
            local arms_armor = 55372
            local legs_armor = 55376
            local body_armor = 55380
            local wrist_armor = 55364
            local feet_reward = 55549
            local head_reward = 55545
            local hands_reward = 55551
            local arms_reward = 55546
            local legs_reward = 55548
            local body_reward = 55547
            local wrist_reward = 55550
            master = "Ruin Wormheart"
        elseif string.find(actor.class, "druid") then
            local feet_gem = 55684
            local head_gem = 55706
            local hands_gem = 55673
            local arms_gem = 55717
            local legs_gem = 55728
            local body_gem = 55739
            local wrist_gem = 55695
            local feet_armor = 55362
            local head_armor = 55370
            local hands_armor = 55358
            local arms_armor = 55374
            local legs_armor = 55378
            local body_armor = 55382
            local wrist_armor = 55366
            local feet_reward = 55528
            local head_reward = 55524
            local hands_reward = 55530
            local arms_reward = 55525
            local legs_reward = 55527
            local body_reward = 55526
            local wrist_reward = 55529
            master = "the Heirophant"
        elseif string.find(actor.class, "warrior") then
            local feet_gem = 55692
            local head_gem = 55714
            local hands_gem = 55681
            local arms_gem = 55725
            local legs_gem = 55736
            local body_gem = 55747
            local wrist_gem = 55703
            local feet_armor = 55360
            local head_armor = 55368
            local hands_armor = 55356
            local arms_armor = 55372
            local legs_armor = 55376
            local body_armor = 55380
            local wrist_armor = 55364
            local feet_reward = 55493
            local head_reward = 55489
            local hands_reward = 55495
            local arms_reward = 55490
            local legs_reward = 55492
            local body_reward = 55491
            local wrist_reward = 55494
            master = "the Warrior Coach in Ickle"
        elseif actor.class == "anti-paladin" then
            local feet_gem = 55682
            local head_gem = 55704
            local hands_gem = 55671
            local arms_gem = 55715
            local legs_gem = 55726
            local body_gem = 55737
            local wrist_gem = 55693
            local feet_armor = 55360
            local head_armor = 55368
            local hands_armor = 55356
            local arms_armor = 55372
            local legs_armor = 55376
            local body_armor = 55380
            local wrist_armor = 55364
            local feet_reward = 55507
            local head_reward = 55503
            local hands_reward = 55509
            local arms_reward = 55504
            local legs_reward = 55506
            local body_reward = 55505
            local wrist_reward = 55508
            master = "the Avatar of Zzur"
        elseif string.find(actor.class, "ranger") then
            local feet_gem = 55688
            local head_gem = 55710
            local hands_gem = 55677
            local arms_gem = 55721
            local legs_gem = 55732
            local body_gem = 55743
            local wrist_gem = 55699
            local feet_armor = 55361
            local head_armor = 55369
            local hands_armor = 55357
            local arms_armor = 55373
            local legs_armor = 55377
            local body_armor = 55381
            local wrist_armor = 55365
            local feet_reward = 55521
            local head_reward = 55517
            local hands_reward = 55523
            local arms_reward = 55518
            local legs_reward = 55520
            local body_reward = 55519
            local wrist_reward = 55522
            master = "the Avatar of Haddixx"
        elseif actor.class == "paladin" then
            local feet_gem = 55687
            local head_gem = 55709
            local hands_gem = 55676
            local arms_gem = 55720
            local legs_gem = 55731
            local body_gem = 55742
            local wrist_gem = 55698
            local feet_armor = 55360
            local head_armor = 55368
            local hands_armor = 55356
            local arms_armor = 55372
            local legs_armor = 55376
            local body_armor = 55380
            local wrist_armor = 55364
            local feet_reward = 55500
            local head_reward = 55496
            local hands_reward = 55502
            local arms_reward = 55497
            local legs_reward = 55499
            local body_reward = 55498
            local wrist_reward = 55501
            master = "Belward"
        elseif string.find(actor.class, "monk") then
            local feet_gem = 55685
            local head_gem = 55707
            local hands_gem = 55674
            local arms_gem = 55718
            local legs_gem = 55729
            local body_gem = 55740
            local wrist_gem = 55696
            local feet_armor = 55362
            local head_armor = 55370
            local hands_armor = 55358
            local arms_armor = 55374
            local legs_armor = 55378
            local body_armor = 55382
            local wrist_armor = 55366
            local feet_reward = 55542
            local head_reward = 55538
            local hands_reward = 55544
            local arms_reward = 55539
            local legs_reward = 55541
            local body_reward = 55540
            local wrist_reward = 55543
            master = "the Almoner"
        elseif string.find(actor.class, "berserker") then
            local feet_gem = 55686
            local head_gem = 55710
            local hands_gem = 55672
            local arms_gem = 55717
            local legs_gem = 55726
            local body_gem = 55742
            local wrist_gem = 55696
            local feet_armor = 55362
            local head_armor = 55370
            local hands_armor = 55358
            local arms_armor = 55374
            local legs_armor = 55378
            local body_armor = 55382
            local wrist_armor = 55366
            local feet_reward = 55778
            local head_reward = 55774
            local hands_reward = 55780
            local arms_reward = 55775
            local legs_reward = 55777
            local body_reward = 55776
            local wrist_reward = 55779
            master = "Avaldr Mountainhelm"
        elseif string.find(string.lower(rogueclasses), actor.class, 1, true) then
            local feet_gem = 55691
            local head_gem = 55713
            local hands_gem = 55680
            local arms_gem = 55724
            local legs_gem = 55735
            local body_gem = 55746
            local wrist_gem = 55702
            local feet_armor = 55361
            local head_armor = 55369
            local hands_armor = 55357
            local arms_armor = 55373
            local legs_armor = 55377
            local body_armor = 55381
            local wrist_armor = 55365
            local feet_reward = 55563
            local head_reward = 55559
            local hands_reward = 55565
            local arms_reward = 55560
            local legs_reward = 55562
            local body_reward = 55561
            local wrist_reward = 55564
            master = "an Elite Mercenary in Ickle"
        elseif string.find(actor.class, "bard") then
            local feet_gem = 55685
            local head_gem = 55708
            local hands_gem = 55671
            local arms_gem = 55720
            local legs_gem = 55728
            local body_gem = 55743
            local wrist_gem = 55694
            local feet_armor = 55362
            local head_armor = 55370
            local hands_armor = 55358
            local arms_armor = 55374
            local legs_armor = 55378
            local body_armor = 55382
            local wrist_armor = 55366
            local feet_reward = 55792
            local head_reward = 55788
            local hands_reward = 55794
            local arms_reward = 55789
            local legs_reward = 55791
            local body_reward = 55790
            local wrist_reward = 55793
            master = "Grand Diva Belissica"
        end
        local got_hands = actor:get_quest_var("phase_armor:hands_armor_armor_acquired")
        local got_feet = actor:get_quest_var("phase_armor:feet_armor_armor_acquired")
        local got_wrist = actor:get_quest_var("phase_armor:wrist_armor_armor_acquired")
        local got_head = actor:get_quest_var("phase_armor:head_armor_armor_acquired")
        local got_arms = actor:get_quest_var("phase_armor:arms_armor_armor_acquired")
        local got_legs = actor:get_quest_var("phase_armor:legs_armor_armor_acquired")
        local got_body = actor:get_quest_var("phase_armor:body_armor_armor_acquired")
        local hands_count = actor:get_quest_var("phase_armor:hands_gem_gems_acquired")
        local feet_count = actor:get_quest_var("phase_armor:feet_gem_gems_acquired")
        local wrist_count = actor:get_quest_var("phase_armor:wrist_gem_gems_acquired")
        local head_count = actor:get_quest_var("phase_armor:head_gem_gems_acquired")
        local arms_count = actor:get_quest_var("phase_armor:arms_gem_gems_acquired")
        local legs_count = actor:get_quest_var("phase_armor:legs_gem_gems_acquired")
        local body_count = actor:get_quest_var("phase_armor:body_gem_gems_acquired")
        local done_hands = (got_hands or 0) == 1  and  (hands_count or 0) == 3
        local done_feet = (got_feet or 0) == 1  and  (feet_count or 0) == 3
        local done_wrist = (got_wrist or 0) == 1  and  (wrist_count or 0) == 3
        local done_head = (got_head or 0) == 1  and  (head_count or 0) == 3
        local done_arms = (got_arms or 0) == 1  and  (arms_count or 0) == 3
        local done_legs = (got_legs or 0) == 1  and  (legs_count or 0) == 3
        local done_body = (got_body or 0) == 1  and  (body_count or 0) == 3
        local given = (got_hands or 0) + (got_feet or 0) + (got_wrist or 0) + (got_head or 0) + (got_arms or 0) + (got_legs or 0) + (got_body or 0)
        given = given + (hands_count or 0) + (feet_count or 0) + (wrist_count or 0) + (head_count or 0) + (arms_count or 0) + (legs_count or 0) + (body_count or 0)
        local unrewarded = ((got_hands or 0) + (hands_count or 0)  ~=  4) + ((got_feet or 0) + (feet_count or 0)  ~=  4) + ((got_wrist or 0) + (wrist_count or 0)  ~=  4)
        unrewarded = unrewarded + ((got_head or 0) + (head_count or 0)  ~=  4) + ((got_arms or 0) + (arms_count or 0)  ~=  4)
        unrewarded = unrewarded + ((got_legs or 0) + (legs_count or 0)  ~=  4) + ((got_body or 0) + (body_count or 0)  ~=  4)
        if done_hands and done_feet and done_wrist and done_head and done_arms and done_legs and done_body then
            actor:send("<cyan>Status: Completed</>")
            return _return_value
        end
        actor:send("<cyan>Status: In Progress</>")
        actor:send("Quest Master is: " .. tostring(master))
        actor:send("You need to retrieve:")
        actor:send("</>  " .. "%get.obj_shortdesc[%hands_armor%]% and 3 of %get.obj_shortdesc[%hands_gem%]%")
        actor:send("</>  " .. "%get.obj_shortdesc[%feet_armor%]% and 3 of %get.obj_shortdesc[%feet_gem%]%")
        actor:send("</>  " .. "%get.obj_shortdesc[%wrist_armor%]% and 3 of %get.obj_shortdesc[%wrist_gem%]%")
        actor:send("</>  " .. "%get.obj_shortdesc[%head_armor%]% and 3 of %get.obj_shortdesc[%head_gem%]%")
        actor:send("</>  " .. "%get.obj_shortdesc[%arms_armor%]% and 3 of %get.obj_shortdesc[%arms_gem%]%")
        actor:send("</>  " .. "%get.obj_shortdesc[%legs_armor%]% and 3 of %get.obj_shortdesc[%legs_gem%]%")
        actor:send("</>  " .. "%get.obj_shortdesc[%body_armor%]% and 3 of %get.obj_shortdesc[%body_gem%]%")
        if not given then
            actor:send("You haven't retrieved anything yet.")
            return _return_value
        elseif unrewarded then
            actor:send("You have found:")
        end
        if got_hands and not done_hands then
            actor:send("</>  " .. "%get.obj_shortdesc[%hands_armor%]%")
        end
        if hands_count and not done_hands then
            actor:send("</>  " .. tostring(hands_count) .. " of " .. "%get.obj_shortdesc[%hands_gem%]%")
        end
        if got_feet and not done_feet then
            actor:send("</>  " .. "%get.obj_shortdesc[%feet_armor%]%")
        end
        if feet_count and not done_feet then
            actor:send("</>  " .. tostring(feet_count) .. " of " .. "%get.obj_shortdesc[%feet_gem%]%")
        end
        if got_wrist and not done_wrist then
            actor:send("</>  " .. "%get.obj_shortdesc[%wrist_armor%]%")
        end
        if wrist_count and not done_wrist then
            actor:send("</>  " .. tostring(wrist_count) .. " of " .. "%get.obj_shortdesc[%wrist_gem%]%")
        end
        if got_head and not done_head then
            actor:send("</>  " .. "%get.obj_shortdesc[%head_armor%]%")
        end
        if head_count and not done_head then
            actor:send("</>  " .. tostring(head_count) .. " of " .. "%get.obj_shortdesc[%head_gem%]%")
        end
        if got_arms and not done_arms then
            actor:send("</>  " .. "%get.obj_shortdesc[%arms_armor%]%")
        end
        if arms_count and not done_arms then
            actor:send("</>  " .. tostring(arms_count) .. " of " .. "%get.obj_shortdesc[%arms_gem%]%")
        end
        if got_legs and not done_legs then
            actor:send("</>  " .. "%get.obj_shortdesc[%legs_armor%]%")
        end
        if legs_count and not done_legs then
            actor:send("</>  " .. tostring(legs_count) .. " of " .. "%get.obj_shortdesc[%legs_gem%]%")
        end
        if got_body and not done_body then
            actor:send("</>  " .. "%get.obj_shortdesc[%body_armor%]%")
        end
        if body_count and not done_body then
            actor:send("</>  " .. tostring(body_count) .. " of " .. "%get.obj_shortdesc[%body_gem%]%")
        end
        if done_hands and done_feet and done_wrist and done_head and done_arms and done_legs and done_body then
            actor:send("</>")
            actor:send("You have completed quests for:")
        end
        if done_hands then
            actor:send("</>  " .. "%get.obj_shortdesc[%hands_reward%]%")
        end
        if done_feet then
            actor:send("</>  " .. "%get.obj_shortdesc[%feet_reward%]%")
        end
        if done_wrist then
            actor:send("</>  " .. "%get.obj_shortdesc[%wrist_reward%]%")
        end
        if done_head then
            actor:send("</>  " .. "%get.obj_shortdesc[%head_reward%]%")
        end
        if done_arms then
            actor:send("</>  " .. "%get.obj_shortdesc[%arms_reward%]%")
        end
        if done_legs then
            actor:send("</>  " .. "%get.obj_shortdesc[%legs_reward%]%")
        end
        if done_body then
            actor:send("</>  " .. "%get.obj_shortdesc[%body_reward%]%")
        end
    else
        actor:send("<cyan>Status: Not Started</>")
    end
end
return _return_value$trig$, '7f7eac507e389d05dcf597adf7cd533d'),
  -- data/triggers/004/004_19_major_globe_progress_journal.lua
  (4, 19, $trig$-- Converted from DG Script #419: Major Globe progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
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
            if stage == 1 then
                local master = mobiles.template(534, 50).name
                local task = "Find Earle and tell him \"Lirne sends me.\""
            elseif stage == 2 then
                local master = mobiles.template(490, 8).name
                local task = "Find shale on Fiery Island."
            elseif stage == 3 then
                local master = mobiles.template(490, 8).name
                local task = "Find sake in Odaishyozen."
            elseif stage == 4 then
                local master = mobiles.template(490, 8).name
                local task = "Find a marigold poultice on a healer in South Caelia."
            elseif stage == 5 then
                local master = mobiles.template(534, 50).name
                local task = "Bring " .. tostring(master) .. " the salve Earle prepared."
            elseif stage == 6 then
                local master = mobiles.template(534, 50).name
                local task = "<b:cyan>Search</> in each <b:green>library</> or <b:green>stack</> to find the lost spellbook."
            elseif stage == 7 then
                local master = mobiles.template(534, 50).name
                local task = "Bring " .. tostring(objects.template(534, 52).name) .. " to " .. tostring(master) .. "."
            elseif stage == 8 then
                local master = mobiles.template(534, 50).name
                local plant = actor:get_quest_var("major_globe_spell:ward_53453")
                local mist = actor:get_quest_var("major_globe_spell:ward_53454")
                local water = actor:get_quest_var("major_globe_spell:ward_53455")
                local flame = actor:get_quest_var("major_globe_spell:ward_53456")
                local ice = actor:get_quest_var("major_globe_spell:ward_53457")
                local wards_left = 5 - (actor:get_quest_var("major_globe_spell:ward_count") or 0)
                local task = "Bring " .. tostring(master) .. " <b:yellow>wards_left more elemental wards</>, one each from a mist, a water, an ice, a flame, and a plant elemental."
            elseif stage == 9 then
                local master = mobiles.template(534, 50).name
                local final_item = actor:get_quest_var("major_globe_spell:final_item")
                -- switch on final_item
                local place
                if (final_item or 0) == 53458 then
                    place = "in a border keep"
                elseif (final_item or 0) == 53459 then
                    place = "on an emerald isle"
                elseif (final_item or 0) == 53460 then
                    place = "within a misty fortress"
                else
                    place = "in an underground city"
                end
                local task = "Find get.obj_shortdesc[final_item] in place."
                local master = mobiles.template(534, 50).name
                local final_item = actor:get_quest_var("major_globe_spell:final_item")
                local task = "Deliver get.obj_shortdesc[final_item] to " .. tostring(master) .. "."
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
    end
end  -- auto-close block
return _return_value$trig$, '98de56400becb944877dbb04c60cc1aa'),
  -- data/triggers/004/004_25_resurrection_progress_journal.lua
  (4, 25, $trig$-- Converted from DG Script #425: Resurrection progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if string.find(arg, "resurrection") or string.find(arg, "resurrect") or string.find(arg, "resurrection_quest") or string.find(arg, "res") then
    if string.find(actor.class, "cleric") or string.find(actor.class, "priest") or string.find(actor.class, "diabolist") and actor.level >= 75 then
        _return_value = true
        local stage = actor:get_quest_stage("resurrection_quest")
        actor:send("<b:u:green>Resurrection</>")
        actor:send("Minimum Level: 81")
        local status
        if actor:get_has_completed("resurrection_quest") then
            status = "Completed!"
        elseif (stage or 0) > 0 then
            status = "In Progress"
        else
            status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
        local hunt, item
        if stage > 0 and not actor:get_has_completed("resurrection_quest") then
            actor:send("Quest Master: " .. tostring(mobiles.template(85, 50).name))
            actor:send("</>")
            -- switch on stage
            do
                local _sw1 = string.lower(tostring(stage or ""))
                if tonumber(_sw1) == 1 then
                    actor:send("Ask Norisent about payment.")
                    return _return_value
                elseif tonumber(_sw1) == 2 then
                    actor:send("Norisent told you:")
                    actor:send("Do something to interfere with Ziijhan.  I hear he has a bishop locked up in the Cathedral dungeon.")
                    return _return_value
                elseif tonumber(_sw1) == 3 then
                    actor:send("Return to Norisent.")
                    return _return_value
                elseif tonumber(_sw1) == 4 then
                    hunt = tostring(mobiles.template(40, 4).name) .. ", " .. tostring(mobiles.template(40, 3).name) .. ", and " .. tostring(mobiles.template(40, 16).name)
                    local mob1 = 4004
                    local mob2 = 4003
                    local mob3 = 4016
                    item = objects.template(40, 8).name
                elseif tonumber(_sw1) == 5 then
                    item = objects.template(40, 8).name
                elseif tonumber(_sw1) == 6 then
                    hunt = "2 Xeg-Yi and " .. tostring(mobiles.template(533, 8).name)
                    local mob2 = 53411
                    local mob1 = 53308
                    item = objects.template(533, 7).name
                elseif tonumber(_sw1) == 7 then
                    item = objects.template(533, 7).name
                elseif tonumber(_sw1) == 8 or tonumber(_sw1) == 9 then
                    hunt = tostring(mobiles.template(510, 5).name) .. ", " .. tostring(mobiles.template(530, 1).name) .. ", and " .. tostring(mobiles.template(510, 14).name)
                    local mob1 = 51005
                    local mob2 = 53001
                    local mob3 = 51014
                    if string.find(actor.class, "cleric") or string.find(actor.class, "priest") then
                        item = "a large book on healing from Nordus"
                    elseif string.find(actor.class, "diabolist") then
                        item = objects.template(510, 28).name
                    end
                elseif tonumber(_sw1) == 10 then
                    hunt = tostring(mobiles.template(520, 3).name) .. " and " .. tostring(mobiles.template(520, 15).name)
                    local mob1 = 52003
                    local mob2 = 52015
                    item = objects.template(520, 1).name
                elseif tonumber(_sw1) == 11 then
                    item = objects.template(520, 1).name
                elseif tonumber(_sw1) == 12 then
                    actor:send("Destroy Norisent!")
                    return _return_value
                end
            end
        end
        if stage == 4 or stage == 6 or stage == 8 or stage == 10 then
            local target1 = actor:get_quest_var("resurrection_quest:mob1")
            local target2 = actor:get_quest_var("resurrection_quest:mob2")
            local target3
            if stage ~= 6 and stage ~= 10 then
                target3 = actor:get_quest_var("resurrection_quest:mob3")
            end
            actor:send("You must eliminate:")
            actor:send(tostring(hunt))
            if stage == 4 or stage == 8 then
                if target1 and target2 and target3 then
                    actor:send("</>")
                    actor:send("Show Norisent the death talisman.")
                    return _return_value
                end
            elseif stage == 6 then
                if target1 and ((target2 or 0) == 2) then
                    actor:send("</>")
                    actor:send("Show Norisent the death talisman.")
                    return _return_value
                end
            else
                if target1 and target2 then
                    actor:send("</>")
                    actor:send("Show Norisent the death talisman.")
                    return _return_value
                end
            end
            if target1 or target2 or target3 then
                actor:send("</>")
                actor:send("You have destroyed:")
                if target1 then
                    actor:send("- " .. "%get.mob_shortdesc[%mob1%]%")
                end
                if stage == 6 then
                    actor:send("- " .. tostring(target2) .. " " .. "%get.mob_shortdesc[%mob2%]%")
                else
                    if target2 then
                        actor:send("- " .. "%get.mob_shortdesc[%mob2%]%")
                    end
                end
                if stage == 4 or stage == 8 then
                    if target3 then
                        actor:send("- " .. "%get.mob_shortdesc[%mob3%]%")
                    end
                end
            end
            if (stage ~= 6 and (not target1 or not target2 or not target3)) or (stage == 6 and (not target1 or (target2 or 0) < 2)) then
                actor:send("</>")
                actor:send("You still need to dispatch:")
                if not target1 then
                    actor:send("- " .. "%get.mob_shortdesc[%mob1%]%")
                end
                if stage == 6 then
                    if (target2 or 0) < 2 then
                        local xeg = (2 - (target2 or 0))
                        actor:send("- " .. tostring(xeg) .. " " .. "%get.mob_shortdesc[%mob2%]%")
                    end
                else
                    if not target2 then
                        actor:send("- " .. "%get.mob_shortdesc[%mob2%]%")
                    end
                end
                if stage ~= 6 and stage ~= 10 then
                    if not target3 then
                        actor:send("- " .. "%get.mob_shortdesc[%mob3%]%")
                    end
                end
                actor:send("</>")
                actor:send("Return " .. tostring(item) .. " as proof.")
            end
            actor:send("</>")
            actor:send("Don't forget the banishment phrase: <b:blue>Dhewsost Konre</>")
        elseif stage == 5 or stage == 7 or stage == 9 or stage == 11 then
            actor:send("Bring Norisent back " .. tostring(item) .. ".")
        end
        if stage >= 4 and not actor:get_has_completed("resurrection_quest") then
            actor:send("</>")
            actor:send("If you need a new talisman, return to Norisent and say <b:black>\"I need a new talisman\"</>.")
        end
    end
end
return _return_value$trig$, 'e139472d3079d515d44e7396dd8effc7'),
  -- data/triggers/004/004_26_group_heal_progress_journal.lua
  (4, 26, $trig$-- Converted from DG Script #426: Group Heal progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if string.find(arg, "group heal") or string.find(arg, "heal") or string.find(arg, "group_heal") then
    if actor.level >= 50 then
        if string.find(actor.class, "priest") or string.find(actor.class, "cleric") or string.find(actor.class, "diabolist") then
            _return_value = true
            local stage = actor:get_quest_stage("group_heal")
            actor:send("<b:u:green>Group Heal</>")
            actor:send("Minimum Level: 57")
            local status
            if actor:get_has_completed("group_heal") then
                status = "Completed!"
            elseif (stage or 0) > 0 then
                status = "In Progress"
            else
                status = "Not Started"
            end
            actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
            if stage > 0 and not actor:get_has_completed("group_heal") then
                actor:send("Quest Master: " .. tostring(mobiles.template(185, 21).name))
                actor:send("</>")
                -- switch on stage
                do
                    local _sw1 = string.lower(tostring(stage or ""))
                    if tonumber(_sw1) == 1 then
                        actor:send("Track down the bandit raider in the Gothra desert and recover the stolen medical supplies.")
                    elseif tonumber(_sw1) == 2 then
                        actor:send("Return the medical supplies stolen by the bandit raider.")
                    elseif tonumber(_sw1) == 3 or tonumber(_sw1) == 4 then
                        actor:send("Locate the records of a group healing ritual in a lost kitchen in the Great Northern Swamp.")
                    elseif tonumber(_sw1) == 5 then
                        actor:send("Visit every <b:white>chef</> and <b:white>cook</> to get their notes on the healing ritual.")
                        actor:send("</>")
                        local recipe1 = actor:get_quest_var("group_heal:18515")
                        local recipe2 = actor:get_quest_var("group_heal:18516")
                        local recipe3 = actor:get_quest_var("group_heal:18517")
                        local recipe4 = actor:get_quest_var("group_heal:18518")
                        local recipe5 = actor:get_quest_var("group_heal:18519")
                        local recipe6 = actor:get_quest_var("group_heal:18520")
                        if recipe1 or recipe2 or recipe3 or recipe4 or recipe5 or recipe6 then
                            actor:send("You have already brought notes from:")
                            if recipe1 then
                                actor:send("- " .. tostring(mobiles.template(83, 7).name))
                            end
                            if recipe2 then
                                actor:send("- " .. tostring(mobiles.template(510, 7).name))
                            end
                            if recipe3 then
                                actor:send("- " .. tostring(mobiles.template(185, 12).name))
                            end
                            if recipe4 then
                                actor:send("- " .. tostring(mobiles.template(300, 3).name))
                            end
                            if recipe5 then
                                actor:send("- " .. tostring(mobiles.template(502, 3).name))
                            end
                            if recipe6 then
                                actor:send("- " .. tostring(mobiles.template(103, 8).name))
                            end
                            actor:send("</>")
                        end
                        local total = 6 - (actor:get_quest_var("group_heal:total") or 0)
                        if total == 1 then
                            actor:send("Bring notes from " .. tostring(total) .. " more chef.")
                        else
                            actor:send("Bring notes from " .. tostring(total) .. " more chefs.")
                        end
                        actor:send("</>")
                        actor :send("If you need a new copy of the Rite, go to the doctor and say: <b:yellow>\"I lost the Rite\"</>.")
                    elseif tonumber(_sw1) == 6 then
                        if (actor:get_quest_var("group_heal:total") or 0) == 6 then
                            actor:send("Give " .. tostring(objects.template(185, 14).name) .. " to the doctor.")
                            return _return_value
                        end
                        actor:send("You are delivering the medical packages to <b:white>injured</>, <b:white>wounded</>, <b:white>sick</>, or <b:white>hobbling</> creatures.")
                        local total = (5 - (actor:get_quest_var("group_heal:total") or 0))
                        local person1 = actor:get_quest_var("group_heal:18506")
                        local person2 = actor:get_quest_var("group_heal:46414")
                        local person3 = actor:get_quest_var("group_heal:43020")
                        local person4 = actor:get_quest_var("group_heal:12513")
                        local person5 = actor:get_quest_var("group_heal:36103")
                        local person6 = actor:get_quest_var("group_heal:58803")
                        local person7 = actor:get_quest_var("group_heal:30054")
                        actor:send("</>")
                        if person1 or person2 or person3 or person4 or person5 or person6 or person7 then
                            actor:send("You have aided:")
                            if person1 then
                                actor:send("- " .. tostring(mobiles.template(185, 6).name))
                            end
                            if person2 then
                                actor:send("- " .. tostring(mobiles.template(464, 14).name))
                            end
                            if person3 then
                                actor:send("- " .. tostring(mobiles.template(430, 20).name))
                            end
                            if person4 then
                                actor:send("- " .. tostring(mobiles.template(125, 13).name))
                            end
                            if person5 then
                                actor:send("- " .. tostring(mobiles.template(361, 3).name))
                            end
                            if person6 then
                                actor:send("- " .. tostring(mobiles.template(588, 3).name))
                            end
                            if person7 then
                                actor:send("- " .. tostring(mobiles.template(300, 54).name))
                            end
                            actor:send("</>")
                        end
                        if total == 1 then
                            actor:send("You need to deliver " .. tostring(total) .. " more packet.")
                        else
                            actor:send("You need to deliver " .. tostring(total) .. " more packets.")
                        end
                    end
                end
            end
        end
    end
end
return _return_value$trig$, '23fa45636fe435dcdba2eaa576d79e96'),
  -- data/triggers/004/004_34_dragons_health_progress_journal.lua
  (4, 34, $trig$-- Converted from DG Script #434: Dragons Health Progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if string.find(arg, "dragons") or string.find(arg, "dragon's") or string.find(arg, "health") or string.find(arg, "dragons_health") or string.find(arg, "dragon's_health") then
    if actor.level >= 85 and string.find(actor.class, "cleric") or string.find(actor.class, "priest") then
        _return_value = true
        local stage = actor:get_quest_stage("dragons_health")
        actor:send("<b:u:green>Dragons Health</>")
        actor:send("Minimum Level: 89")
        local status
        if actor:get_has_completed("dragons_health") then
            status = "Completed!"
        elseif (stage or 0) > 0 then
            status = "In Progress"
        else
            status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
        if stage > 0 and not actor:get_has_completed("dragons_health") then
            actor:send("Quest Master: " .. tostring(mobiles.template(586, 10).name))
            actor:send("</>")
            -- switch on stage
            local dragon, treasure
            do
                local _sw1 = string.lower(tostring(stage or ""))
                if tonumber(_sw1) == 1 then
                    dragon = "the blue dragon in the Tower in the Wastes"
                    treasure = "its crystal"
                elseif tonumber(_sw1) == 2 then
                    dragon = "Tri-Aszp"
                    treasure = "one of her scales"
                elseif tonumber(_sw1) == 3 then
                    dragon = "Thelriki and Jerajai"
                    treasure = "the jewel in their hoard"
                elseif tonumber(_sw1) == 4 then
                    dragon = "Sagece"
                    treasure = "her skins and shields"
                elseif tonumber(_sw1) == 5 then
                    local total = 10000000 - (actor:get_quest_var("dragons_health:hoard") or 0)
                    local plat = total / 1000
                    local gold = total / 100 - plat * 10
                    local silv = total / 10 - plat * 100 - gold * 10
                    local copp = total  - plat * 1000 - gold * 100 - silv * 10
                    -- now the price can be reported
                    actor:send("The new hatchling's hoard needs enriching._")
                    actor:send("</><b:yellow>" .. tostring(plat) .. " platinum, " .. tostring(gold) .. " gold, " .. tostring(silv) .. " silver, " .. tostring(copp) .. " copper</>_")
                    actor:send("</>more in treasure or coins ought to do it.")
                    return _return_value
                end
            end
            actor:send("You are trying to:")
            actor:send("- kill " .. tostring(dragon) .. " and return with " .. tostring(treasure) .. ".")
            if stage == 3 then
                local thelriki = actor:get_quest_var("dragons_health:thelriki")
                local jerajai = actor:get_quest_var("dragons_health:jerajai")
                if thelriki or jerajai then
                    actor:send("</>")
                    actor:send("You have slain:")
                    if thelriki then
                        actor:send("- Thelriki")
                    end
                    if jerajai then
                        actor:send("- Jerajai")
                    end
                end
                actor:send("</>")
                actor:send("You must still:")
                if not thelriki then
                    actor:send("- kill Thelriki")
                end
                if not jerajai then
                    actor:send("- kill Jerajai")
                end
                actor:send("- bring the jewel in their hoard")
            elseif stage == 4 then
                local item1 = actor:get_quest_var("dragons_health:52016")
                local item2 = actor:get_quest_var("dragons_health:52017")
                local item3 = actor:get_quest_var("dragons_health:52022")
                local item4 = actor:get_quest_var("dragons_health:52023")
                local sagece = actor:get_quest_var("dragons_health:sagece")
                if item1 or item2 or item3 or item4 or sagece then
                    actor:send("</>")
                    actor:send("You have already:")
                    if sagece then
                        actor:send("- slain Sagece of Raymif")
                    end
                    if item1 then
                        actor:send("- brought Sagece's skin")
                    end
                    if item2 then
                        actor:send("- brought Sagece's shield")
                    end
                    if item3 then
                        actor:send("- brought the skin from Sagece's hoard")
                    end
                    if item4 then
                        actor:send("- brought the shield from Sagece's hoard")
                    end
                end
                actor:send("</>")
                actor:send("You must still:")
                if not sagece then
                    actor:send("- kill Sagece of Raymif")
                end
                if not item1 then
                    actor:send("- bring Sagece's skin")
                end
                if not item2 then
                    actor:send("- bring Sagece's shield")
                end
                if not item3 then
                    actor:send("- find the skin in Sagece's hoard")
                end
                if not item4 then
                    actor:send("- find the shield in Sagece's hoard")
                end
            end
        end
    end
end
return _return_value$trig$, 'ea40f0c70ebbc9449903472a7e3161fc'),
  -- data/triggers/004/004_35_creeping_doom_progress_journal.lua
  (4, 35, $trig$-- Converted from DG Script #435: Creeping Doom progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if string.find(arg, "creeping") or string.find(arg, "creeping doom") or string.find(arg, "creeping_doom") then
    if actor.level >= 75 and string.find(actor.class, "druid") then
        _return_value = true
        local stage = actor:get_quest_stage("creeping_doom")
        actor:send("<b:u:green>Creeping Doom</>")
        actor:send("Minimum Level: 81")
        local status
        if actor:get_has_completed("creeping_doom") then
            status = "Completed!"
        elseif (stage or 0) > 0 then
            status = "In Progress"
        else
            status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
        if stage > 0 and not actor:get_has_completed("creeping_doom") then
            actor:send("Quest Master: " .. tostring(mobiles.template(615, 27).name))
            actor:send("</>")
            -- switch on stage
            local step
            do
                local _sw1 = string.lower(tostring(stage or ""))
                if tonumber(_sw1) == 1 then
                    local item1 = 11812
                    local place1 = "an assassin vine on Mist Mountain"
                    local item2 = 16213
                    local place2 = "the great pyramid"
                    local item3 = 48029
                    local place3 = "Rhalean's evil sister in the northern barrow"
                    step = "gathering Nature's Rage"
                elseif tonumber(_sw1) == 2 then
                    local essence = actor:get_quest_var("creeping_doom:spiders")
                    local total = 11 - (actor:get_quest_var("creeping_doom:spiders") or 0)
                    actor:send("You are collecting essences of swarms from flies, insects, spiders, bugs, scorpions, giant ant people, etc.")
                    actor:send("</>")
                    actor:send("You have found " .. tostring(essence) .. " essences.")
                    actor:send("You need to find " .. tostring(total) .. " more.")
                    actor:send("</>")
                    actor:send("Remember, the tougher the bug, the better your chances of finding essences.")
                    return _return_value
                elseif tonumber(_sw1) == 3 then
                    step = "locate three sources of Nature's Vengeance."
                    local item1 = 48416
                    local place1 = "the elder tremaen in the elemental Plane of Fire"
                    local item2 = 52034
                    local place2 = "the burning tree in Templace"
                    local item3 = 62503
                    local place3 = "the Treant in the eldest Rhell's forest"
                elseif tonumber(_sw1) == 4 then
                    actor:send("Take the Essence of Nature's Vengeance and drop it at the entrance to the logging camp, then return to the angry pixie.")
                    return _return_value
                elseif tonumber(_sw1) == 5 then
                    actor:send("return to the very angry pixie.")
                    return _return_value
                end
            end
            local job1 = actor:get_quest_var("creeping_doom:item1")
            local job2 = actor:get_quest_var("creeping_doom:item2")
            local job3 = actor:get_quest_var("creeping_doom:item3")
            actor:send("You are trying to " .. tostring(step) .. ".")
            actor:send("</>")
            if job1 or job2 or job3 then
                actor:send("You have brought me:")
                if job1 then
                    actor:send("- " .. "%get.obj_shortdesc[%item1%]%")
                end
                if job2 then
                    actor:send("- " .. "%get.obj_shortdesc[%item2%]%")
                end
                if job3 then
                    actor:send("- " .. "%get.obj_shortdesc[%item3%]%")
                end
            end
            actor:send("</>")
            actor:send("You still need:")
            if not job1 then
                actor:send("- " .. "%get.obj_shortdesc[%item1%]% from %place1%.")
            end
            if not job2 then
                actor:send("- " .. "%get.obj_shortdesc[%item2%]% from %place2%.")
            end
            if not job3 then
                actor:send("- " .. "%get.obj_shortdesc[%item3%]% from %place3%.")
            end
        end
    end
end
return _return_value$trig$, 'bce06fbc9aa041dda7b8144232d1442c'),
  -- data/triggers/004/004_36_wall_of_ice_progress_journal.lua
  (4, 36, $trig$-- Converted from DG Script #436: Wall of Ice progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if (string.find(arg, "wall") and string.find(arg, "ice")) or string.find(arg, "wall of ice") or string.find(arg, "wall_ice") or string.find(arg, "wall_of_ice") then
    if string.find(actor.class, "cryomancer") and actor.level >= 50 then
        _return_value = true
        actor:send("<b:u:green>Wall of Ice</>")
        actor:send("Minimum Level: 57")
        local status
        if actor:get_has_completed("wall_ice") then
            status = "Completed!"
        elseif actor:get_quest_stage("wall_ice") > 0 then
            status = "In Progress"
        else
            status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
        if actor:get_quest_stage("wall_ice") == 1 then
            actor:send("Quest Master: " .. tostring(mobiles.template(533, 16).name))
            actor:send("</>")
            actor:send("Collect 20 blocks of living ice from ice creatures.")
            actor:send("Say \"Crystalize\" in their presence to cast the spell of living ice.")
            local have = actor:get_quest_var("wall_ice:blocks")
            local need = (20 - (have or 0))
            actor:send("</>")
            actor:send("You have brought <b:cyan>" .. tostring(have) .. " blocks of living ice.</>")
            actor:send("</>")
            actor:send("You still need <b:cyan>" .. tostring(need) .. "</> more.")
            actor:send("</>")
            actor:send("If you need a new copy of the spell of living ice, return to the sculptor and say, \"<b:cyan>please replace the spell</>\".")
        end
    end
end
return _return_value$trig$, '2dbb893ae939ef34acfbe4677336f328'),
  -- data/triggers/004/004_39_waterform_progress_journal.lua
  (4, 39, $trig$-- Converted from DG Script #439: Waterform progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if string.find(arg, "waterform") then
    if string.find(actor.class, "cryomancer") and actor.level >= 65 then
        _return_value = true
        local stage = actor:get_quest_stage("waterform")
        actor:send("<b:u:green>Waterform</>")
        actor:send("Minimum Level: 73")
        local status
        if actor:get_has_completed("waterform") then
            status = "Completed!"
        elseif (stage or 0) > 0 then
            status = "In Progress"
        else
            status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
        if stage > 0 and not actor:get_has_completed("waterform") then
            local master = mobiles.template(28, 10).name
            actor:send("Quest Master: " .. tostring(master))
            actor:send("</>")
            -- switch on stage
            do
                local _sw1 = string.lower(tostring(stage or ""))
                if tonumber(_sw1) == 1 then
                    actor:send("Find a piece of armor made of water to serve as the basis of your new form.")
                elseif tonumber(_sw1) == 2 then
                    actor:send("You need a special vessel to gather water in.  Kill Tri-Aszp and get a large bone from her.")
                elseif tonumber(_sw1) == 3 then
                    actor:send("You need a special vessel to gather water in.  Give " .. tostring(master) .. " the large bone from a grown white dragon so it can make you one.")
                elseif tonumber(_sw1) == 4 then
                    local region1 = actor:get_quest_var("waterform:region1")
                    local region2 = actor:get_quest_var("waterform:region2")
                    local region3 = actor:get_quest_var("waterform:region3")
                    local region4 = actor:get_quest_var("waterform:region4")
                    local region5 = actor:get_quest_var("waterform:region5")
                    actor:send("Collect samples of living water from four different regions.")
                    if region1 or region2 or region3 or region4 or region5 then
                        actor:send("</>")
                        actor:send("You already have samples from:")
                        if region1 then
                            actor:send("- <blue>The Blue Fog trails and waters</>")
                        end
                        if region2 then
                            actor:send("- <blue>Nordus</>")
                        end
                        if region3 then
                            actor:send("- <blue>Layveran Labyrinth</>")
                        end
                        if region4 then
                            actor:send("- <blue>The Elemental Plane of Water</>")
                        end
                        if region5 then
                            actor:send("- <blue>The sunken castle</>")
                        end
                    end
                    actor:send("</>")
                    local samples = 4 - ((region1 or 0) + (region2 or 0) + (region3 or 0) + (region4 or 0) + (region5 or 0))
                    actor:send("You need <b:blue>" .. tostring(samples) .. "</> more.")
                elseif tonumber(_sw1) == 5 then
                    actor:send("Give " .. tostring(master) .. " the cup so it can see the samples.")
                elseif tonumber(_sw1) == 6 then
                    local water1 = actor:get_quest_var("waterform:3296")
                    local water2 = actor:get_quest_var("waterform:58405")
                    local water3 = actor:get_quest_var("waterform:53319")
                    local water4 = actor:get_quest_var("waterform:55804")
                    local water5 = actor:get_quest_var("waterform:58701")
                    local water6 = actor:get_quest_var("waterform:37014")
                    actor:send("You are looking for six unique sources of water.")
                    if water1 or water2 or water3 or water4 or water5 or water6 then
                        actor:send("</>")
                        actor:send("You have already analyzed water from:")
                        if water1 then
                            actor:send("- <blue>a granite pool in the village of Mielikki</>")
                        end
                        if water2 then
                            actor:send("- <blue>a sparkling artesian well in the Realm of the King of Dreams</>")
                        end
                        if water3 then
                            actor:send("- <blue>a crystal clear fountain in the caverns of the Ice Cult</>")
                        end
                        if water4 then
                            actor:send("- <blue>the creek in the Eldorian Foothills</>")
                        end
                        if water5 then
                            actor:send("- <blue>the wishing well at the Dancing Dolphin in South Caelia</>")
                        end
                        if water6 then
                            actor:send("- <blue>an underground brook in the Minithawkin Mines</>")
                        end
                    end
                    actor:send("</>")
                    actor:send("You still need to analyze water from:")
                    if not water1 then
                        actor:send("- <b:cyan>a granite pool in the village of Mielikki</>")
                    end
                    if not water2 then
                        actor:send("- <b:cyan>a sparkling artesian well in the Realm of the King of Dreams</>")
                    end
                    if not water3 then
                        actor:send("- <b:cyan>a crystal clear fountain in the caverns of the Ice Cult</>")
                    end
                    if not water4 then
                        actor:send("- <b:cyan>the creek in the Eldorian Foothills</>")
                    end
                    if not water5 then
                        actor:send("- <b:cyan>the wishing well at the Dancing Dolphin in South Caelia</>")
                    end
                    if not water6 then
                        actor:send("- <b:cyan>an underground brook in the Minithawkin Mines</>")
                    end
                elseif tonumber(_sw1) == 7 then
                    actor:send("Just return the cup to " .. tostring(master) .. " and you're done!")
                end
            end
            if stage > 3 then
                actor:send("</>")
                actor:send("If you need a new cup, return to " .. tostring(master) .. " and say \"<b:yellow>I need a new cup</>\".")
            end
        end
    end
end
return _return_value$trig$, '6fd81836e3080f61ab08335116646400'),
  -- data/triggers/004/004_43_blur_progress_journal.lua
  (4, 43, $trig$-- Converted from DG Script #443: Blur progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if string.find(arg, "blur") then
    if string.find(actor.class, "ranger") and actor.level >= 75 then
        _return_value = true
        local east = actor:get_quest_var("blur:east")
        local etimer = actor:get_quest_var("blur:east_timer")
        local west = actor:get_quest_var("blur:west")
        local wtimer = actor:get_quest_var("blur:west_timer")
        local north = actor:get_quest_var("blur:north")
        local ntimer = actor:get_quest_var("blur:north_timer")
        local south = actor:get_quest_var("blur:south")
        local stimer = actor:get_quest_var("blur:south_timer")
        local timer = actor:get_quest_var("blur:timer")
        local stage = actor:get_quest_stage("blur")
        local master = mobiles.template(18, 18).name
        actor:send("<b:u:green>Blur</>")
        actor:send("Minimum Level: 81")
        local status
        if actor:get_has_completed("blur") then
            status = "Completed!"
        elseif actor:get_has_failed("blur") then
            status = "Failed"
        elseif (stage or 0) > 0 then
            status = "In Progress"
        else
            status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
        if (stage or 0) == 0 then
            actor:send("Heal the spirits in the Forest of Shadows.")
        elseif actor:get_has_failed("blur") then
            actor:send("Find " .. tostring(master) .. " to restart the races.")
        elseif not actor:get_has_completed("blur") then
            actor:send("Quest Master: " .. tostring(master))
            actor:send("</>")
            -- switch on stage
            do
                local _sw1 = string.lower(tostring(stage or ""))
                if tonumber(_sw1) == 1 then
                    actor:send("Seek out the ranger of the Forest of Shadows.")
                elseif tonumber(_sw1) == 2 then
                    actor:send("Seek out and kill the Syric Warder and bring me his sword.")
                elseif tonumber(_sw1) == 3 then
                    actor:send("Give " .. tostring(master) .. " the Blade of the Forgotten Kings.")
                elseif tonumber(_sw1) == 4 then
                    actor:send("It's time to race the four winds!")
                    if actor:get_quest_var("blur:race") ~= "go" then
                        actor:send("Return to " .. tostring(master) .. " and say \"Let's begin\" to start the race.")
                    else
                        local minutes = ((timer or 0) / 60)
                        local seconds = (timer or 0) - (minutes * 60)
                        actor:send("You have " .. tostring(minutes) .. " mins " .. tostring(seconds) .. " secs remaining to race all four winds!")
                        actor:send("</>")
                        if (north or 0) == 0 then
                            actor:send("The North Wind blows near the frozen town of Ickle.")
                        elseif (north or 0) == 1 then
                            local room = get_room("30262")
                            actor:send("Beat the North Wind to " .. tostring(room.name) .. " in Bluebonnet Pass.")
                            local minutes = ((ntimer or 0) / 60)
                            local seconds = (ntimer or 0) - (minutes * 60)
                            actor:send("You have " .. tostring(minutes) .. " mins " .. tostring(seconds) .. " secs remaining to race the North Wind!")
                        elseif (north or 0) == 2 then
                            actor:send("You have won the race against the North Wind!")
                        end
                        actor:send("</>")
                        if (south or 0) == 0 then
                            actor:send("The South Wind blows around the hidden standing stones in South Caelia.")
                        elseif (south or 0) == 1 then
                            local room = get_room("53557")
                            actor:send("Beat the South Wind to " .. tostring(room.name) .. ".")
                            local minutes = ((stimer or 0) / 60)
                            local seconds = (stimer or 0) - (minutes * 60)
                            actor:send("You have " .. tostring(minutes) .. " mins " .. tostring(seconds) .. " secs remaining to race the South Wind!")
                        elseif (south or 0) == 2 then
                            actor:send("You have won the race against the South Wind!")
                        end
                        actor:send("</>")
                        if (east or 0) == 0 then
                            actor:send("The East Wind blows through an enormous volcano in the sea.")
                        elseif (east or 0) == 1 then
                            local room = get_room("12597")
                            actor:send("Beat the East Wind to " .. tostring(room.name) .. ".")
                            local minutes = ((etimer or 0) / 60)
                            local seconds = (etimer or 0) - (minutes * 60)
                            actor:send("You have " .. tostring(minutes) .. " mins " .. tostring(seconds) .. " secs remaining to race the East Wind!")
                        elseif (east or 0) == 2 then
                            actor:send("You have won the race against the East Wind!")
                        end
                        actor:send("</>")
                        if (west or 0) == 0 then
                            actor:send("The West Wind blows through ruins across the vast Gothra plains.")
                        elseif (west or 0) == 1 then
                            local room = get_room("4236")
                            actor:send("Beat the West Wind to " .. tostring(room.name) .. ".")
                            local minutes = ((wtimer or 0) / 60)
                            local seconds = (wtimer or 0) - (minutes * 60)
                            actor:send("You have " .. tostring(minutes) .. " mins " .. tostring(seconds) .. " secs remaining to race the West Wind!")
                        elseif (west or 0) == 2 then
                            actor:send("You have won the race against the West Wind!")
                        end
                    end
                end
            end
        end
    end
end
return _return_value$trig$, '97baf80c3a1902e7412f864e2f62b328'),
  -- data/triggers/004/004_45_hell_gate_progress_journal.lua
  (4, 45, $trig$-- Converted from DG Script #445: Hell Gate progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if string.find(arg, "hell gate") or string.find(arg, "hell_gate") then
    if string.find(actor.class, "diabolist") and actor.level >= 75 then
        _return_value = true
        local stage = actor:get_quest_stage("hell_gate")
        local master = mobiles.template(564, 0).name
        actor:send("<b:u:green>Hell Gate</>")
        actor:send("Minimum Level: 81")
        local status
        if actor:get_has_completed("hell_gate") then
            status = "Completed!"
        elseif (stage or 0) > 0 then
            status = "In Progress"
        else
            status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
        if stage > 0 and not actor:get_has_completed("hell_gate") then
            actor:send("Quest Master: " .. tostring(master))
            actor:send("</>")
            -- switch on stage
            do
                local _sw1 = string.lower(tostring(stage or ""))
                if tonumber(_sw1) == 1 then
                    actor:send("You are preparing to open a door to Garl'lixxil and release one of the demon lords.  Find " .. tostring(objects.template(30, 213).name) .. ".")
                elseif tonumber(_sw1) == 2 then
                    local key1 = actor:get_quest_var("hell_gate:8303")
                    local key2 = actor:get_quest_var("hell_gate:23709")
                    local key3 = actor:get_quest_var("hell_gate:49008")
                    local key4 = actor:get_quest_var("hell_gate:52012")
                    local key5 = actor:get_quest_var("hell_gate:52013")
                    local key6 = actor:get_quest_var("hell_gate:53402")
                    local key7 = actor:get_quest_var("hell_gate:58109")
                    actor:send("Find seven keys to seven gates.")
                    if key1 or key2 or key3 or key4 or key5 or key6 or key7 then
                        actor:send("</>")
                        actor:send("You have already found:")
                        if key1 then
                            actor:send("<red>" .. tostring(objects.template(83, 3).name) .. "</>")
                        end
                        if key2 then
                            actor:send("<red>" .. tostring(objects.template(237, 9).name) .. "</>")
                        end
                        if key3 then
                            actor:send("<red>" .. tostring(objects.template(490, 8).name) .. "</>")
                        end
                        if key4 then
                            actor:send("<red>" .. tostring(objects.template(520, 12).name) .. "</>")
                        end
                        if key5 then
                            actor:send("<red>" .. tostring(objects.template(520, 13).name) .. "</>")
                        end
                        if key6 then
                            actor:send("<red>" .. tostring(objects.template(534, 2).name) .. "</>")
                        end
                        if key7 then
                            actor:send("<red>" .. tostring(objects.template(580, 109).name) .. "</>")
                        end
                    end
                    actor:send("</>")
                    actor:send("You must still find:")
                    if not key1 then
                        actor:send("<b:red>A small, well-crafted key made of wood with the smell of rich sap</>")
                        actor:send("<b:red>Kept at the gate of a tribe's home.</>")
                        actor:send("</>")
                    end
                    if not key6 then
                        actor:send("<b:red>A key made of light silvery metal which only elves can work</>")
                        actor:send("<b:red>Deep in a frozen valley.</>")
                        actor:send("</>")
                    end
                    if not key2 then
                        actor:send("<b:red>A large, black key humming with magical energy</>")
                        actor:send("<b:red>From a twisted cruel city in a huge underground cavern.</>")
                        actor:send("</>")
                    end
                    if not key7 then
                        actor:send("<b:red>A simple lacquered iron key</>")
                        actor:send("<b:red>In the care of a radiant bird on an emerald island.</>")
                        actor:send("</>")
                    end
                    if not key3 then
                        actor:send("<b:red>A rusted but well cared for key</>")
                        actor:send("<b:red>Held by a winged captain on an island of magical beasts.</>")
                        actor:send("</>")
                    end
                    if not key5 then
                        actor:send("<b:red>A golden plated, wrought-iron key</>")
                        actor:send("<b:red>held at the gates to a desacrated city.</>")
                        actor:send("</>")
                    end
                    if not key4 then
                        actor:send("<b:red>One nearly impossible to see</>")
                        actor:send("<b:red>guarded by a fiery beast with many heads.</>")
                    end
                elseif tonumber(_sw1) == 3 then
                    local blood1 = actor:get_quest_var("hell_gate:56400")
                    local blood2 = actor:get_quest_var("hell_gate:56401")
                    local blood3 = actor:get_quest_var("hell_gate:56402")
                    local blood4 = actor:get_quest_var("hell_gate:56403")
                    local blood5 = actor:get_quest_var("hell_gate:56404")
                    local blood6 = actor:get_quest_var("hell_gate:56405")
                    local blood7 = actor:get_quest_var("hell_gate:56406")
                    actor:send("Sacrifice seven different <b:red>children</>.")
                    actor:send("</><b:white>[Drop]</> their <b:red>blood</> before " .. tostring(master) .. " to defile the keys.")
                    if blood1 or blood2 or blood3 or blood4 or blood5 or blood6 or blood7 then
                        actor:send("</>")
                        actor:send("You have already found:")
                        if blood1 then
                            actor:send("<red>" .. tostring(objects.template(564, 0).name) .. "</>")
                        end
                        if blood2 then
                            actor:send("<red>" .. tostring(objects.template(564, 1).name) .. "</>")
                        end
                        if blood3 then
                            actor:send("<red>" .. tostring(objects.template(564, 2).name) .. "</>")
                        end
                        if blood4 then
                            actor:send("<red>" .. tostring(objects.template(564, 3).name) .. "</>")
                        end
                        if blood5 then
                            actor:send("<red>" .. tostring(objects.template(564, 4).name) .. "</>")
                        end
                        if blood6 then
                            actor:send("<red>" .. tostring(objects.template(564, 5).name) .. "</>")
                        end
                        if blood7 then
                            actor:send("<red>" .. tostring(objects.template(564, 6).name) .. "</>")
                        end
                    end
                    actor:send("</>")
                    local total = (7 - ((blood1 or 0) + (blood2 or 0) + (blood3 or 0) + (blood4 or 0) + (blood5 or 0) + (blood6 or 0) + (blood7 or 0)))
                    if total == 1 then
                        actor:send("Sacrifice the last child!")
                    else
                        actor:send("Bring the blood of <red>" .. tostring(total) .. "</> more children.")
                    end
                    actor:send("</>")
                    actor:send("If you need a new dagger, return to " .. tostring(master) .. " and say, <b:red>\"I need a new dagger\"</>.")
                elseif tonumber(_sw1) == 4 then
                    actor:send("Give the spider-shaped dagger back to " .. tostring(master) .. ".")
                elseif tonumber(_sw1) == 5 then
                    actor:send("Slay Larathiel and release the demon lord!")
                end
            end
        end
    end
end
return _return_value$trig$, 'd78abf97ae2c4e9bc983008826ef8b6e'),
  -- data/triggers/004/004_46_hellfire_and_brimstone_progress_journal.lua
  (4, 46, $trig$-- Converted from DG Script #446: Hellfire and Brimstone progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if string.find(arg, "hellfire") or string.find(arg, "brimstone") or string.find(arg, "hellfire_and_brimstone") or string.find(arg, "hellfire_brimstone") then
    if string.find(actor.class, "diabolist") and actor.level >= 50 then
        _return_value = true
        local master = mobiles.template(23, 11).name
        local stage = actor:get_quest_stage("hellfire_brimstone")
        actor:send("<b:u:green>Hellfire and Brimstone</>")
        actor:send("Minimum Level: 57")
        local status
        if actor:get_has_completed("hellfire_brimstone") then
            status = "Completed!"
        elseif (stage or 0) > 0 then
            status = "In Progress"
        else
            status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
        if stage > 0 and not actor:get_has_completed("hellfire_brimstone") then
            actor:send("Quest Master: " .. tostring(master))
            actor:send("</>")
            -- switch on stage
            do
                local _sw1 = string.lower(tostring(stage or ""))
                if tonumber(_sw1) == 1 then
                    local meat = actor:get_quest_var("hellfire_brimstone:meat")
                    actor:send(tostring(master) .. " needs <b:red>meat</> for the fire.")
                    local total = (6 - (meat or 0))
                    if total == 1 then
                        actor:send("Drop <b:red>" .. tostring(total) .. "</> more pound of flesh from the paladins at the Sacred Haven into the bonfire.")
                    else
                        actor:send("Drop <b:red>" .. tostring(total) .. "</> pounds of flesh from the paladins at the Sacred Haven into the bonfire.")
                    end
                elseif tonumber(_sw1) == 2 then
                    local brimstone = actor:get_quest_var("hellfire_brimstone:brimstone")
                    actor:send(tostring(master) .. " needs <b:yellow>brimstone</> to trace out the sigils.")
                    -- (empty send to actor)
                    local total = (6 - (brimstone or 0))
                    if total == 1 then
                        actor:send("Bring <b:yellow>" .. tostring(total) .. "</> more quantity of brimstone from fiery spirits on the volcanic island to the north and drop them into the bonfire.")
                    else
                        actor:send("Bring <b:yellow>" .. tostring(total) .. "</> quantities of brimstone from fiery spirits on the volcanic island to the north and drop it into the bonfire.")
                    end
                elseif tonumber(_sw1) == 3 then
                    local item1 = actor:get_quest_var("hellfire_brimstone:4318")
                    local item2 = actor:get_quest_var("hellfire_brimstone:5211")
                    local item3 = actor:get_quest_var("hellfire_brimstone:5212")
                    local item4 = actor:get_quest_var("hellfire_brimstone:17308")
                    local item5 = actor:get_quest_var("hellfire_brimstone:48110")
                    local item6 = actor:get_quest_var("hellfire_brimstone:53000")
                    actor:send("You are to bring " .. tostring(master) .. " fiery tributes to the Dark One.")
                    actor:send("</>")
                    if item1 or item2 or item3 or item4 or item5 or item6 then
                        actor:send("You have already given him:")
                        if item1 then
                            actor:send("- " .. tostring(objects.template(43, 18).name))
                        end
                        if item2 then
                            actor:send("- " .. tostring(objects.template(52, 11).name))
                        end
                        if item3 then
                            actor:send("- " .. tostring(objects.template(52, 12).name))
                        end
                        if item4 then
                            actor:send("- " .. tostring(objects.template(173, 8).name))
                        end
                        if item5 then
                            actor:send("- " .. tostring(objects.template(481, 10).name))
                        end
                        if item6 then
                            actor:send("- " .. tostring(objects.template(530, 0).name))
                        end
                    end
                    actor:send("</>")
                    actor:send("Now bring him:")
                    if not item1 then
                        actor:send("- " .. tostring(objects.template(43, 18).name) .. "</> from an actress in Anduin.</>")
                    end
                    if not item2 then
                        actor:send("- <b:white>" .. tostring(objects.template(52, 11).name) .. "</> from a beam of starlight deep in mine.</>")
                    end
                    if not item3 then
                        actor:send("- <blue>" .. tostring(objects.template(52, 12).name) .. "</> from a devotee of neutrality on a hill.</>")
                    end
                    if not item4 then
                        actor:send("- <b:black>" .. tostring(objects.template(173, 8).name) .. " from Chaos incarnate.</>")
                    end
                    if not item5 then
                        actor:send("- <b:red>" .. tostring(objects.template(481, 10).name) .. "</> from the volcano goddess.</>")
                    end
                    if not item6 then
                        actor:send("- " .. tostring(objects.template(530, 0).name) .. "</> from a king in a throne room crypt.</>")
                    end
                end
            end
        end
    end
end
return _return_value$trig$, 'dd05d2dbaa63d32f6709f36a32f076c6'),
  -- data/triggers/004/004_47_illusory_wall_progress_journal.lua
  (4, 47, $trig$-- Converted from DG Script #447: Illusory Wall progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if string.find(arg, "illusory") or string.find(arg, "illusory wall") or string.find(arg, "illusory_wall") then
    if (string.find(actor.class, "illusionist") or string.find(actor.class, "bard")) and actor.level >= 50 then
        _return_value = true
        local stage = actor:get_quest_stage("illusory_wall")
        local master = mobiles.template(364, 2).name
        actor:send("<b:u:green>Illusory Wall</>")
        actor:send("Minimum Level: 57")
        local status
        if actor:get_has_completed("illusory_wall") then
            status = "Completed!"
        elseif (stage or 0) > 0 then
            status = "In Progress"
        else
            status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
        if stage > 0 and not actor:get_has_completed("illusory_wall") then
            actor:send("Quest Master: " .. tostring(master))
            -- switch on stage
            do
                local _sw1 = string.lower(tostring(stage or ""))
                if tonumber(_sw1) == 1 then
                    local item1 = actor:get_quest_var("illusory_wall:10307")
                    local item2 = actor:get_quest_var("illusory_wall:18511")
                    local item3 = actor:get_quest_var("illusory_wall:41005")
                    local item4 = actor:get_quest_var("illusory_wall:51017")
                    actor:send("You're looking for things to make magical spectacles.")
                    if item1 or item2 or item3 or item4 then
                        actor:send("</>")
                        actor:send("</>You have already brought me:")
                        if item1 then
                            actor:send("- <b:white>" .. tostring(objects.template(103, 7).name) .. "</>")
                        end
                        if item2 then
                            actor:send("- <b:white>" .. tostring(objects.template(185, 11).name) .. "</>")
                        end
                        if item3 then
                            actor:send("- <b:white>" .. tostring(objects.template(410, 5).name) .. "</>")
                        end
                        if item4 then
                            actor:send("- <b:white>" .. tostring(objects.template(510, 17).name) .. "</>")
                        end
                    end
                    actor:send("</>")
                    actor:send("You still need to find:")
                    if not item1 and not item2 then
                        actor:send("- <b:yellow>" .. "%get.obj_shortdesc[10307]%</> or <b:yellow>%get.obj_shortdesc[18511]%</>")
                    end
                    if not item3 then
                        actor:send("- <b:yellow>" .. tostring(objects.template(410, 5).name) .. "</>")
                    end
                    if not item4 then
                        actor:send("- <b:yellow>" .. tostring(objects.template(510, 17).name) .. "</>")
                    end
                elseif tonumber(_sw1) == 2 then
                    actor:send("Complete your study of doors in 20 regions.")
                    actor:send("</>")
                    local doors = actor:get_quest_var("illusory_wall:total")
                    actor:send("You have examined doors in <b:magenta>" .. tostring(doors) .. "</> regions:")
                    if actor:get_quest_var("illusory_wall:Outback") then
                        actor:send("- <blue>Rocky Outback</>")
                    end
                    if actor:get_quest_var("illusory_wall:Shadows") then
                        actor:send("- <blue>Forest of Shadows</>")
                    end
                    if actor:get_quest_var("illusory_wall:Merchant") then
                        actor:send("- <blue>Old Merchant Trail</>")
                    end
                    if actor:get_quest_var("illusory_wall:Caelia_West") then
                        actor:send("- <blue>South Caelia West</>")
                    end
                    if actor:get_quest_var("illusory_wall:River") then
                        actor:send("- <blue>Blue-Fog River</>")
                    end
                    if actor:get_quest_var("illusory_wall:Mielikki") then
                        actor:send("- <blue>The Village of Mielikki</>")
                    end
                    if actor:get_quest_var("illusory_wall:Mielikki_Forest") then
                        actor:send("- <blue>Mielikki's Forests</>")
                    end
                    if actor:get_quest_var("illusory_wall:Labyrinth") then
                        actor:send("- <blue>Laveryn Labyrinth</>")
                    end
                    if actor:get_quest_var("illusory_wall:Split") then
                        actor:send("- <blue>Split Skull</>")
                    end
                    if actor:get_quest_var("illusory_wall:Theatre") then
                        actor:send("- <blue>The Theatre in Anduin</>")
                    end
                    if actor:get_quest_var("illusory_wall:Rocky_Tunnels") then
                        actor:send("- <blue>Rocky Tunnels</>")
                    end
                    if actor:get_quest_var("illusory_wall:Lava") then
                        actor:send("- <blue>Lava Tunnels</>")
                    end
                    if actor:get_quest_var("illusory_wall:Misty") then
                        actor:send("- <blue>Misty Caverns</>")
                    end
                    if actor:get_quest_var("illusory_wall:Combat") then
                        actor:send("- <blue>Combat in Eldoria</>")
                    end
                    if actor:get_quest_var("illusory_wall:Anduin") then
                        actor:send("- <blue>The City of Anduin</>")
                    end
                    if actor:get_quest_var("illusory_wall:Pastures") then
                        actor:send("- <blue>Anduin Pastures</>")
                    end
                    if actor:get_quest_var("illusory_wall:Great_Road") then
                        actor:send("- <blue>The Great Road</>")
                    end
                    if actor:get_quest_var("illusory_wall:Nswamps") then
                        actor:send("- <blue>The Northern Swamps</>")
                    end
                    if actor:get_quest_var("illusory_wall:Farmlands") then
                        actor:send("- <blue>Mielikki Farmlands</>")
                    end
                    if actor:get_quest_var("illusory_wall:Frakati") then
                        actor:send("- <blue>Frakati Reservation</>")
                    end
                    if actor:get_quest_var("illusory_wall:Cathedral") then
                        actor:send("- <blue>Cathedral of Betrayal</>")
                    end
                    if actor:get_quest_var("illusory_wall:Meercats") then
                        actor:send("- <blue>Kingdom of the Meer Cats</>")
                    end
                    if actor:get_quest_var("illusory_wall:Logging") then
                        actor:send("- <blue>The Logging Camp</>")
                    end
                    if actor:get_quest_var("illusory_wall:Dairy") then
                        actor:send("- <blue>The Dairy Farm</>")
                    end
                    if actor:get_quest_var("illusory_wall:Ickle") then
                        actor:send("- <blue>Ickle</>")
                    end
                    if actor:get_quest_var("illusory_wall:Frostbite") then
                        actor:send("- <blue>Mount Frostbite</>")
                    end
                    if actor:get_quest_var("illusory_wall:Phoenix") then
                        actor:send("- <blue>Phoenix Feather Hot Spring</>")
                    end
                    if actor:get_quest_var("illusory_wall:Blue_Fog_Trail") then
                        actor:send("- <blue>Blue-Fog Trail</>")
                    end
                    if actor:get_quest_var("illusory_wall:Twisted") then
                        actor:send("- <blue>Twisted Forest</>")
                    end
                    if actor:get_quest_var("illusory_wall:Megalith") then
                        actor:send("- <blue>The Sacred Megalith</>")
                    end
                    if actor:get_quest_var("illusory_wall:Tower") then
                        actor:send("- <blue>The Tower in the Wasted</>")
                    end
                    if actor:get_quest_var("illusory_wall:Miner") then
                        actor:send("- <blue>The Miner's Cavern</>")
                    end
                    if actor:get_quest_var("illusory_wall:Morgan") then
                        actor:send("- <blue>Morgan Hill</>")
                    end
                    if actor:get_quest_var("illusory_wall:Mystwatch") then
                        actor:send("- <blue>The Fortress of Mystwatch</>")
                    end
                    if actor:get_quest_var("illusory_wall:Desert") then
                        actor:send("- <blue>Gothra Desert</>")
                    end
                    if actor:get_quest_var("illusory_wall:Pyramid") then
                        actor:send("- <blue>Gothra Pyramid</>")
                    end
                    if actor:get_quest_var("illusory_wall:Highlands") then
                        actor:send("- <blue>Highlands</>")
                    end
                    if actor:get_quest_var("illusory_wall:Haunted") then
                        actor:send("- <blue>The Haunted House</>")
                    end
                    if actor:get_quest_var("illusory_wall:Citadel") then
                        actor:send("- <blue>The Citadel of Testing</>")
                    end
                    if actor:get_quest_var("illusory_wall:Chaos") then
                        actor:send("- <blue>Temple of Chaos</>")
                    end
                    if actor:get_quest_var("illusory_wall:Canyon") then
                        actor:send("- <blue>Canyon</>")
                    end
                    if actor:get_quest_var("illusory_wall:Topiary") then
                        actor:send("- <blue>Mielikki's Topiary</>")
                    end
                    if actor:get_quest_var("illusory_wall:Abbey") then
                        actor:send("- <blue>The Abbey</>")
                    end
                    if actor:get_quest_var("illusory_wall:Plains") then
                        actor:send("- <blue>Gothra Plains</>")
                    end
                    if actor:get_quest_var("illusory_wall:Dheduu") then
                        actor:send("- <blue>Dheduu</>")
                    end
                    if actor:get_quest_var("illusory_wall:Dargentan") then
                        actor:send("- <blue>Dargentan's Lair</>")
                    end
                    if actor:get_quest_var("illusory_wall:Ogakh") then
                        actor:send("- <blue>Ogakh</>")
                    end
                    if actor:get_quest_var("illusory_wall:Bluebonnet") then
                        actor:send("- <blue>Bluebonnet Pass</>")
                    end
                    if actor:get_quest_var("illusory_wall:Caelia_East") then
                        actor:send("- <blue>South Caelia East</>")
                    end
                    if actor:get_quest_var("illusory_wall:Brush") then
                        actor:send("- <blue>Brush Lands</>")
                    end
                    if actor:get_quest_var("illusory_wall:Kaaz") then
                        actor:send("- <blue>Temple of the Kaaz</>")
                    end
                    if actor:get_quest_var("illusory_wall:SeaWitch") then
                        actor:send("- <blue>Sea's Lullaby</>")
                    end
                    if actor:get_quest_var("illusory_wall:Smuggler") then
                        actor:send("- <blue>Smuggler's Hideout</>")
                    end
                    if actor:get_quest_var("illusory_wall:Sirestis") then
                        actor:send("- <blue>Sirestis' Folly</>")
                    end
                    if actor:get_quest_var("illusory_wall:Ancient_Ruins") then
                        actor:send("- <blue>Ancient Ruins</>")
                    end
                    if actor:get_quest_var("illusory_wall:Minithawkin") then
                        actor:send("- <blue>Minithawkin Mines</>")
                    end
                    if actor:get_quest_var("illusory_wall:Arabel") then
                        actor:send("- <blue>Arabel Ocean</>")
                    end
                    if actor:get_quest_var("illusory_wall:Hive") then
                        actor:send("- <blue>Hive</>")
                    end
                    if actor:get_quest_var("illusory_wall:Demise") then
                        actor:send("- <blue>Demise Keep</>")
                    end
                    if actor:get_quest_var("illusory_wall:Aviary") then
                        actor:send("- <blue>Ickle's Aviary</>")
                    end
                    if actor:get_quest_var("illusory_wall:Graveyard") then
                        actor:send("- <blue>The Graveyard</>")
                    end
                    if actor:get_quest_var("illusory_wall:Earth") then
                        actor:send("- <blue>The Plane of Earth</>")
                    end
                    if actor:get_quest_var("illusory_wall:Water") then
                        actor:send("- <blue>The Plane of Water</>")
                    end
                    if actor:get_quest_var("illusory_wall:Fire") then
                        actor:send("- <blue>The Plane of Fire</>")
                    end
                    if actor:get_quest_var("illusory_wall:Barrow") then
                        actor:send("- <blue>The Barrow</>")
                    end
                    if actor:get_quest_var("illusory_wall:Fiery") then
                        actor:send("- <blue>Fiery Island</>")
                    end
                    if actor:get_quest_var("illusory_wall:Nukreth") then
                        actor:send("- <blue>Nukreth Spire</>")
                    end
                    if actor:get_quest_var("illusory_wall:Doom") then
                        actor:send("- <blue>An Ancient Forest and Pyramid</>")
                    end
                    if actor:get_quest_var("illusory_wall:Air") then
                        actor:send("- <blue>The Plane of Air</>")
                    end
                    if actor:get_quest_var("illusory_wall:Lokari") then
                        actor:send("- <blue>Lokari's Keep</>")
                    end
                    if actor:get_quest_var("illusory_wall:Griffin") then
                        actor:send("- <blue>Griffin Island</>")
                    end
                    if actor:get_quest_var("illusory_wall:BlackIce") then
                        actor:send("- <blue>Black-Ice Desert</>")
                    end
                    if actor:get_quest_var("illusory_wall:Nymrill") then
                        actor:send("- <blue>The Lost City of Nymrill</>")
                    end
                    if actor:get_quest_var("illusory_wall:Bayou") then
                        actor:send("- <blue>The Bayou</>")
                    end
                    if actor:get_quest_var("illusory_wall:Nordus") then
                        actor:send("- <blue>The Enchanted Village of Nordus</>")
                    end
                    if actor:get_quest_var("illusory_wall:Templace") then
                        actor:send("- <blue>Templace</>")
                    end
                    if actor:get_quest_var("illusory_wall:Sunken") then
                        actor:send("- <blue>Sunken Castle</>")
                    end
                    if actor:get_quest_var("illusory_wall:Cult") then
                        actor:send("- <blue>Ice Cult</>")
                    end
                    if actor:get_quest_var("illusory_wall:Frost") then
                        actor:send("- <blue>Frost Valley</>")
                    end
                    if actor:get_quest_var("illusory_wall:Technitzitlan") then
                        actor:send("- <blue>Technitzitlan</>")
                    end
                    if actor:get_quest_var("illusory_wall:Black_Woods") then
                        actor:send("- <blue>Black Woods</>")
                    end
                    if actor:get_quest_var("illusory_wall:Kaas_Plains") then
                        actor:send("- <blue>Kaas Plains</>")
                    end
                    if actor:get_quest_var("illusory_wall:Dark_Mountains") then
                        actor:send("- <blue>Dark Mountains</>")
                    end
                    if actor:get_quest_var("illusory_wall:Cold_Fields") then
                        actor:send("- <blue>Cold Fields</>")
                    end
                    if actor:get_quest_var("illusory_wall:Iron") then
                        actor:send("- <blue>Iron Hills</>")
                    end
                    if actor:get_quest_var("illusory_wall:Blackrock") then
                        actor:send("- <blue>Black Rock Trail</>")
                    end
                    if actor:get_quest_var("illusory_wall:Eldorian") then
                        actor:send("- <blue>Eldorian Foothills</>")
                    end
                    if actor:get_quest_var("illusory_wall:Blacklake") then
                        actor:send("- <blue>Black Lake</>")
                    end
                    if actor:get_quest_var("illusory_wall:Odz") then
                        actor:send("- <blue>Odaishyozen</>")
                    end
                    if actor:get_quest_var("illusory_wall:Syric") then
                        actor:send("- <blue>Syric Mountain Trail</>")
                    end
                    if actor:get_quest_var("illusory_wall:KoD") then
                        actor:send("- <blue>Kingdom of Dreams</>")
                    end
                    if actor:get_quest_var("illusory_wall:Beachhead") then
                        actor:send("- <blue>Beachhead</>")
                    end
                    if actor:get_quest_var("illusory_wall:Ice_Warrior") then
                        actor:send("- <blue>The Ice Warrior's Compound</>")
                    end
                    if actor:get_quest_var("illusory_wall:Haven") then
                        actor:send("- <blue>Sacred Haven</>")
                    end
                    if actor:get_quest_var("illusory_wall:Hollow") then
                        actor:send("- <blue>Enchanted Hollow</>")
                    end
                    if actor:get_quest_var("illusory_wall:Rhell") then
                        actor:send("- <blue>The Rhell Forest</>")
                    end
                    actor:send("</>")
                    local remaining = (20 - (doors or 0))
                    actor:send("Locate doors in <b:magenta>" .. tostring(remaining) .. "</> more regions.")
                    actor:send("</>")
                    actor:send("If you need new lenses return to " .. tostring(master) .. " and say, <b:magenta>\"I need new glasses\"</>.")
                end
            end
        end
    end
end
return _return_value$trig$, '47a311b6e5f072d7c005717fcd051300'),
  -- data/triggers/004/004_49_air_wand_progress_journal.lua
  (4, 49, $trig$-- Converted from DG Script #449: Air Wand progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
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
            local job1 = actor:get_quest_var("air_wand:wandtask1")
            local job2 = actor:get_quest_var("air_wand:wandtask2")
            local job3 = actor:get_quest_var("air_wand:wandtask3")
            local job4 = actor:get_quest_var("air_wand:wandtask4")
            local job5 = actor:get_quest_var("air_wand:wandtask5")
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
                                actor:send("- found " .. "%get.obj_shortdesc[%wandgem%]%")
                            end
                            if job3 then
                                if stage ~= 10 then
                                    actor:send("- found " .. "%get.obj_shortdesc[%wandtask3%]%")
                                else
                                    actor:send("- slayed " .. "%get.mob_shortdesc[%wandtask3%]%")
                                end
                            end
                            if job4 then
                                if stage ~= 5 and stage ~= 9 and stage ~= 10 then
                                    actor:send("- found " .. "%get.obj_shortdesc[%wandtask4%]%")
                                elseif stage == 5 then
                                    actor:send("- communed in " .. tostring(wandtask4))
                                elseif stage == 9 then
                                    actor:send("- slayed " .. "%get.mob_shortdesc[%wandtask4%]%")
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
                                                    actor:send("- <b:cyan>play</> " .. "%get.obj_shortdesc[%wandtask4%]%")
                                                end
                                            elseif stage == 8 then
                                                if not job5 then
                                                    actor:send("Bring " .. tostring(master) .. " your " .. tostring(weapon) .. ".")
                                                else
                                                    local room = get.room[place]
                                                    actor:send("- imbue your " .. tostring(weapon) .. " at " .. tostring(room.name) .. ".")
                                                end
                                            elseif stage == 10 then
                                                local room = get.room[wandtask4]
                                                actor:send("- imbue your " .. tostring(weapon) .. " at " .. tostring(room.name) .. ".")
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
                            actor:send("- <b:yellow>find " .. "%get.obj_shortdesc[%wandgem%]%</>")
                        end
                        if stage > 2 then
                            if not job3 then
                                if stage ~= 10 then
                                    actor:send("- <b:yellow>find " .. "%get.obj_shortdesc[%wandtask3%]%</>")
                                    if stage == 4 then
                                        actor:send("</>    Blessings can be called at the smaller groups of standing stones in South Caelia.")
                                        actor:send("</>    Search the far eastern edge of the continent.")
                                        actor:send("</>    The phrase to call the blessing is:")
                                        actor:send("</>    <b:white>I pray for a blessing from mother earth, creator of life and bringer of death</>")
                                    end
                                else
                                    actor:send("- <b:yellow>slay " .. "%get.mob_shortdesc[%wandtask3%]%</>")
                                end
                            end
                            if not job4 then
                                if stage ~= 3 and stage ~= 5 and stage ~= 9 and stage ~= 10 then
                                    actor:send("- <b:yellow>find " .. "%get.obj_shortdesc[%wandtask4%]%</>")
                                elseif stage == 5 then
                                    actor:send("- <b:yellow>imbue your " .. tostring(weapon) .. " on " .. tostring(wandtask4) .. "</>")
                                elseif stage == 9 then
                                    actor:send("- <b:yellow>slay " .. "%get.mob_shortdesc[%wandtask4%]%</>")
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
return _return_value$trig$, '297889403217d3f22ec01c2d8789b477'),
  -- data/triggers/004/004_50_fire_wand_progress_journal.lua
  (4, 50, $trig$-- Converted from DG Script #450: Fire Wand progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
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
            local job1 = actor:get_quest_var("fire_wand:wandtask1")
            local job2 = actor:get_quest_var("fire_wand:wandtask2")
            local job3 = actor:get_quest_var("fire_wand:wandtask3")
            local job4 = actor:get_quest_var("fire_wand:wandtask4")
            local job5 = actor:get_quest_var("fire_wand:wandtask5")
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
                                actor:send("- found " .. "%get.obj_shortdesc[%wandgem%]%")
                            end
                            if job3 then
                                if stage ~= 10 then
                                    actor:send("- found " .. "%get.obj_shortdesc[%wandtask3%]%")
                                else
                                    actor:send("- slayed " .. "%get.mob_shortdesc[%wandtask3%]%")
                                end
                            end
                            if job4 then
                                if stage ~= 5 and stage ~= 9 and stage ~= 10 then
                                    actor:send("- found " .. "%get.obj_shortdesc[%wandtask4%]%")
                                elseif stage == 5 then
                                    actor:send("- communed in " .. tostring(wandtask4))
                                elseif stage == 9 then
                                    actor:send("- slayed " .. "%get.mob_shortdesc[%wandtask4%]%")
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
                                                    actor:send("- <b:cyan>play</> " .. "%get.obj_shortdesc[%wandtask4%]%")
                                                end
                                            elseif stage == 8 then
                                                if not job5 then
                                                    actor:send("Bring " .. tostring(master) .. " your " .. tostring(weapon) .. ".")
                                                else
                                                    local room = get.room[place]
                                                    actor:send("- imbue your " .. tostring(weapon) .. " at " .. tostring(room.name) .. ".")
                                                end
                                            elseif stage == 10 then
                                                local room = get.room[wandtask4]
                                                actor:send("- imbue your " .. tostring(weapon) .. " at " .. tostring(room.name) .. ".")
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
                            actor:send("- <b:yellow>find " .. "%get.obj_shortdesc[%wandgem%]%</>")
                        end
                        if stage > 2 then
                            if not job3 then
                                if stage ~= 10 then
                                    actor:send("- <b:yellow>find " .. "%get.obj_shortdesc[%wandtask3%]%</>")
                                    if stage == 4 then
                                        actor:send("</>    Blessings can be called at the smaller groups of standing stones in South Caelia.")
                                        actor:send("</>    Search the south point beyond Anlun Vale.")
                                        actor:send("</>    The phrase to call the blessing is:")
                                        actor:send("</>    <b:white>I pray for a blessing from mother earth, creator of life and bringer of death</>")
                                    end
                                else
                                    actor:send("- <b:yellow>slay " .. "%get.mob_shortdesc[%wandtask3%]%</>")
                                end
                            end
                            if not job4 then
                                if stage ~= 3 and stage ~= 5 and stage ~= 9 and stage ~= 10 then
                                    actor:send("- <b:yellow>find " .. "%get.obj_shortdesc[%wandtask4%]%</>")
                                elseif stage == 5 then
                                    actor:send("- <b:yellow>imbue your " .. tostring(weapon) .. " in " .. tostring(wandtask4) .. "</>")
                                elseif stage == 9 then
                                    actor:send("- <b:yellow>slay " .. "%get.mob_shortdesc[%wandtask4%]%</>")
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
return _return_value$trig$, '90a8cc5d1fc1c9bbf888495eb17a50ba'),
  -- data/triggers/004/004_51_ice_wand_progress_journal.lua
  (4, 51, $trig$-- Converted from DG Script #451: Ice Wand progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
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
            local job1 = actor:get_quest_var("ice_wand:wandtask1")
            local job2 = actor:get_quest_var("ice_wand:wandtask2")
            local job3 = actor:get_quest_var("ice_wand:wandtask3")
            local job4 = actor:get_quest_var("ice_wand:wandtask4")
            local job5 = actor:get_quest_var("ice_wand:wandtask5")
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
                                actor:send("- found " .. "%get.obj_shortdesc[%wandgem%]%")
                            end
                            if job3 then
                                if stage ~= 10 then
                                    actor:send("- found " .. "%get.obj_shortdesc[%wandtask3%]%")
                                else
                                    actor:send("- slayed " .. "%get.mob_shortdesc[%wandtask3%]%")
                                end
                            end
                            if job4 then
                                if stage ~= 5 and stage ~= 9 and stage ~= 10 then
                                    actor:send("- found " .. "%get.obj_shortdesc[%wandtask4%]%")
                                elseif stage == 5 then
                                    actor:send("- communed in " .. tostring(wandtask4))
                                elseif stage == 9 then
                                    actor:send("- slayed " .. "%get.mob_shortdesc[%wandtask4%]%")
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
                                                    actor:send("- <b:cyan>play</> " .. "%get.obj_shortdesc[%wandtask4%]%")
                                                end
                                            elseif stage == 8 then
                                                if not job5 then
                                                    actor:send("Bring " .. tostring(master) .. " your " .. tostring(weapon) .. ".")
                                                else
                                                    local room = get.room[place]
                                                    actor:send("- imbue your " .. tostring(weapon) .. " at " .. tostring(room.name) .. ".")
                                                end
                                            elseif stage == 10 then
                                                local room = get.room[wandtask4]
                                                actor:send("- imbue your " .. tostring(weapon) .. " at " .. tostring(room.name) .. ".")
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
                            actor:send("- <b:yellow>find " .. "%get.obj_shortdesc[%wandgem%]%</>")
                        end
                        if stage > 2 then
                            if not job3 then
                                if stage ~= 10 then
                                    actor:send("- <b:yellow>find " .. "%get.obj_shortdesc[%wandtask3%]%</>")
                                    if stage == 4 then
                                        actor:send("</>    Blessings can be called at the smaller groups of standing stones in South Caelia.")
                                        actor:send("</>    Search near the crystalline pool in Anlun Vale.")
                                        actor:send("</>    The phrase to call the blessing is:")
                                        actor:send("</>    <b:white>I pray for a blessing from mother earth, creator of life and bringer of death</>")
                                    end
                                else
                                    actor:send("- <b:yellow>slay " .. "%get.mob_shortdesc[%wandtask3%]%</>")
                                end
                            end
                            if not job4 then
                                if stage ~= 3 and stage ~= 5 and stage ~= 9 and stage ~= 10 then
                                    actor:send("- <b:yellow>find " .. "%get.obj_shortdesc[%wandtask4%]%</>")
                                elseif stage == 5 then
                                    actor:send("- <b:yellow>imbue your " .. tostring(weapon) .. " in " .. tostring(wandtask4) .. "</>")
                                elseif stage == 9 then
                                    actor:send("- <b:yellow>slay " .. "%get.mob_shortdesc[%wandtask4%]%</>")
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
return _return_value$trig$, '7a431c4dbec6251758cef0e483f3e3a8'),
  -- data/triggers/004/004_52_acid_wand_progress_journal.lua
  (4, 52, $trig$-- Converted from DG Script #452: Acid Wand progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
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
            local job1 = actor:get_quest_var("acid_wand:wandtask1")
            local job2 = actor:get_quest_var("acid_wand:wandtask2")
            local job3 = actor:get_quest_var("acid_wand:wandtask3")
            local job4 = actor:get_quest_var("acid_wand:wandtask4")
            local job5 = actor:get_quest_var("acid_wand:wandtask5")
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
                                actor:send("- found " .. "%get.obj_shortdesc[%wandgem%]%")
                            end
                            if job3 then
                                if stage ~= 10 then
                                    actor:send("- found " .. "%get.obj_shortdesc[%wandtask3%]%")
                                else
                                    actor:send("- slayed " .. "%get.mob_shortdesc[%wandtask3%]%")
                                end
                            end
                            if job4 then
                                if stage ~= 5 and stage ~= 9 and stage ~= 10 then
                                    actor:send("- found " .. "%get.obj_shortdesc[%wandtask4%]%")
                                elseif stage == 5 then
                                    actor:send("- communed in " .. tostring(wandtask4))
                                elseif stage == 9 then
                                    actor:send("- slayed " .. "%get.mob_shortdesc[%wandtask4%]%")
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
                                                    actor:send("- <b:cyan>play</> " .. "%get.obj_shortdesc[%wandtask4%]%")
                                                end
                                            elseif stage == 8 then
                                                if not job5 then
                                                    actor:send("Bring " .. tostring(master) .. " your " .. tostring(weapon) .. ".")
                                                else
                                                    local room = get.room[place]
                                                    actor:send("- imbue your " .. tostring(weapon) .. " at " .. tostring(room.name) .. ".")
                                                end
                                            elseif stage == 10 then
                                                local room = get.room[wandtask4]
                                                actor:send("- imbue your " .. tostring(weapon) .. " at " .. tostring(room.name) .. ".")
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
                            actor:send("- <b:yellow>find " .. "%get.obj_shortdesc[%wandgem%]%</>")
                        end
                        if stage > 2 then
                            if not job3 then
                                if stage ~= 10 then
                                    actor:send("- <b:yellow>find " .. "%get.obj_shortdesc[%wandtask3%]%</>")
                                    if stage == 4 then
                                        actor:send("</>    Blessings can be called at the smaller groups of standing stones in South Caelia.")
                                        actor:send("</>    Search in the heart of the heart of the thorns.")
                                        actor:send("</>    The phrase to call the blessing is:")
                                        actor:send("</>    <b:white>I pray for a blessing from mother earth, creator of life and bringer of death</>")
                                    end
                                else
                                    actor:send("- <b:yellow>slay " .. "%get.mob_shortdesc[%wandtask3%]%</>")
                                end
                            end
                            if not job4 then
                                if stage ~= 3 and stage ~= 5 and stage ~= 9 and stage ~= 10 then
                                    actor:send("- <b:yellow>find " .. "%get.obj_shortdesc[%wandtask4%]%</>")
                                elseif stage == 5 then
                                    actor:send("- <b:yellow>imbue your " .. tostring(weapon) .. " in " .. tostring(wandtask4) .. "</>")
                                elseif stage == 9 then
                                    actor:send("- <b:yellow>slay " .. "%get.mob_shortdesc[%wandtask4%]%</>")
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
return _return_value$trig$, '20bad08f79ddc0229728b6d93fb21bd9'),
  -- data/triggers/004/004_53_spirit_maces_progress_journal.lua
  (4, 53, $trig$-- Converted from DG Script #453: Spirit Maces progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
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
            local job1 = actor:get_quest_var("phase_mace:macetask1")
            local job2 = actor:get_quest_var("phase_mace:macetask2")
            local job3 = actor:get_quest_var("phase_mace:macetask3")
            local job4 = actor:get_quest_var("phase_mace:macetask4")
            local job5 = actor:get_quest_var("phase_mace:macetask5")
            local job6 = actor:get_quest_var("phase_mace:macetask6")
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
                            actor:send("- found " .. "%get.obj_shortdesc[%maceitem2%]%")
                        end
                        if job3 then
                            actor:send("- found " .. "%get.obj_shortdesc[%maceitem3%]%")
                        end
                        if job4 then
                            actor:send("- found " .. "%get.obj_shortdesc[%maceitem4%]%")
                        end
                        if job5 then
                            actor:send("- found " .. "%get.obj_shortdesc[%maceitem5%]%")
                        end
                        if job6 then
                            actor:send("- found " .. "%get.obj_shortdesc[%maceitem6%]%")
                        end
                    end
                    actor:send("</>")
                    actor:send("You need to:")
                    if job1 and job2 and job3 and job4 and job5 then
                        if macestep ~= 2 then
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
                        actor:send("- <b:yellow>find " .. "%get.obj_shortdesc[%maceitem2%]%</>")
                    end
                    if not job3 then
                        actor:send("- <b:yellow>find " .. "%get.obj_shortdesc[%maceitem3%]%</>")
                    end
                    if not job4 then
                        actor:send("- <b:yellow>find " .. "%get.obj_shortdesc[%maceitem4%]%</>")
                    end
                    if not job5 then
                        actor:send("- <b:yellow>find " .. "%get.obj_shortdesc[%maceitem5%]%</>")
                    end
                    if stage == 2 then
                        if not job6 then
                            actor:send("- <b:yellow>find " .. "%get.obj_shortdesc[%maceitem6%]%</>")
                        end
                    end
                end
            end
        end
    end
end
return _return_value$trig$, '555f34e48c03cce5410daceb02d02848'),
  -- data/triggers/004/004_56_assassin_mask_progress_journal.lua
  (4, 56, $trig$-- Converted from DG Script #456: Assassin Mask progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if string.find(arg, "deadly") or string.find(arg, "promotion") or string.find(arg, "deadly_promotion or arg ~=assassin_mask") then
    if string.find(actor.class, "assassin") then
        _return_value = true
        local bountystage = actor:get_quest_stage("bounty_hunt")
        local maskstage = actor:get_quest_stage("assassin_mask")
        local master = mobiles.template(60, 51).name
        local job1 = actor:get_quest_var("assassin_mask:masktask1")
        local job2 = actor:get_quest_var("assassin_mask:masktask2")
        local job3 = actor:get_quest_var("assassin_mask:masktask3")
        local job4 = actor:get_quest_var("assassin_mask:masktask4")
        actor:send("<b:u:green>Deadly Promotion</>")
        local level
        if (maskstage or 0) == 0 then
            level = 10
        else
            level = maskstage * 10
        end
        if not actor:get_has_completed("assassin_mask") then
            actor:send("Minimum Level: " .. tostring(level))
        end
        local status
        if actor:get_has_completed("assassin_mask") then
            status = "Completed!"
        elseif (maskstage or 0) > 0 then
            status = "In Progress"
        else
            status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
        if actor.level >= level then
            if maskstage == 0 then
                actor:send("You have to do a <b:cyan>[job]</> for " .. tostring(master) .. " first though.")
                return _return_value
            elseif (maskstage >= bountystage) and not actor:get_has_completed("bounty_hunt") then
                actor:send("You need to complete some more Contract Killer jobs before you can receive another promotion.")
                return _return_value
            end
            -- switch on maskstage
            local mask
            local gem
            local place
            local hint
            do
                local _sw1 = string.lower(tostring(maskstage or ""))
                if tonumber(_sw1) == 1 then
                    mask = 4500
                    gem = 55592
                    place = "The Shadowy Lair"
                    hint = "in the Misty Caverns."
                elseif tonumber(_sw1) == 2 then
                    mask = 17809
                    gem = 55594
                    place = "The Dark Chamber"
                    hint = "behind a desert door."
                elseif tonumber(_sw1) == 3 then
                    mask = 59023
                    gem = 55620
                    place = "A Dark Tunnel"
                    hint = "on the way to a dark, hidden city."
                elseif tonumber(_sw1) == 4 then
                    mask = 10304
                    gem = 55638
                    place = "Dark Chamber"
                    hint = "hidden below a ghostly fortress."
                elseif tonumber(_sw1) == 5 then
                    mask = 16200
                    gem = 55666
                    place = "Darkness......"
                    hint = "inside an enchanted closet."
                elseif tonumber(_sw1) == 6 then
                    mask = 43017
                    gem = 55675
                    place = "Surrounded by Darkness"
                    hint = "in a volcanic shaft."
                elseif tonumber(_sw1) == 7 then
                    mask = 51075
                    gem = 55693
                    place = "Dark Indecision"
                    hint = "before an altar in a fallen maze."
                elseif tonumber(_sw1) == 8 then
                    mask = 49062
                    gem = 55719
                    place = "Heart of Darkness"
                    hint = "buried deep in an ancient tomb."
                elseif tonumber(_sw1) == 9 then
                    mask = 48427
                    gem = 55743
                    place = "A Dark Room"
                    hint = "under the ruins of a shop in an ancient city."
                end
            end
            local attack = maskstage * 100
            actor:send("Quest Master: " .. tostring(master))
            if job1 or job2 or job3 or job4 then
                actor:send("</>")
                actor:send("You've done the following:")
                if job1 then
                    actor:send("- attacked " .. tostring(attack) .. " times")
                end
                if job2 then
                    actor:send("- found " .. "%get.obj_shortdesc[%mask%]%")
                end
                if job3 then
                    actor:send("- found " .. "%get.obj_shortdesc[%gem%]%")
                end
                if job4 then
                    actor:send("- hidden in " .. tostring(place))
                end
            end
            actor:send("</>")
            actor:send("You need to:")
            if job1 and job2 and job3 and job4 then
                actor:send("Give " .. tostring(master) .. " your old mask.")
                return _return_value
            end
            if not job1 then
                local remaining = attack - (actor:get_quest_var("assassin_mask:attack_counter") or 0)
                actor:send("- attack <b:black>" .. tostring(remaining) .. "</> more times while wearing your mask.")
            end
            if not job2 then
                actor:send("- find <b:black>" .. "%get.obj_shortdesc[%mask%]%</>")
            end
            if not job3 then
                actor:send("- find <b:black>" .. "%get.obj_shortdesc[%gem%]%</>")
            end
            if not job4 then
                actor:send("- <b:black>hide in a place called \"<b:black>" .. tostring(place) .. "</>\".")
                actor:send("</>   It's <b:black>" .. tostring(hint) .. "</>")
            end
        end
    end
end
return _return_value$trig$, 'a3764d1715975c85a00dc71868c8ebb8'),
  -- data/triggers/004/004_58_divine_devotion_progress_journal.lua
  (4, 58, $trig$-- Converted from DG Script #458: Divine Devotion progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if string.find(arg, "divine") or string.find(arg, "devotion") or string.find(arg, "divine_devotion") or string.find(arg, "paladin_pendant") or string.find(arg, "paladin pendant") then
    local anti = "Anti-Paladin"
    if string.find(actor.class, "paladin") or actor.class == "anti-paladin" then
        _return_value = true
        local huntstage = actor:get_quest_stage("dragon_slayer")
        local pendantstage = actor:get_quest_stage("paladin_pendant")
        local master = mobiles.template(30, 80).name
        local job1 = actor:get_quest_var("paladin_pendant:necklacetask1")
        local job2 = actor:get_quest_var("paladin_pendant:necklacetask2")
        local job3 = actor:get_quest_var("paladin_pendant:necklacetask3")
        local job4 = actor:get_quest_var("paladin_pendant:necklacetask4")
        actor:send("<b:u:green>Divine Devotion</>")
        local level
        if (pendantstage or 0) == 0 then
            level = 10
        else
            level = pendantstage * 10
        end
        if not actor:get_has_completed("paladin_pendant") then
            actor:send("Minimum Level: " .. tostring(level))
        end
        local status
        if actor:get_has_completed("paladin_pendant") then
            status = "Completed!"
        elseif (pendantstage or 0) > 0 then
            status = "In Progress"
        else
            status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
        if actor.level >= level then
            if pendantstage == 0 then
                actor:send("Your first act of devotion should be to <b:cyan>[hunt]</> a dragon.")
                return _return_value
            elseif (pendantstage >= huntstage) and not actor:get_has_completed("dragon_slayer") then
                actor:send("Slay a few more dragons before you can receive another promotion.")
                return _return_value
            end
            -- switch on pendantstage
            local necklace
            local gem
            local place
            local hint
            do
                local _sw1 = string.lower(tostring(pendantstage or ""))
                if tonumber(_sw1) == 1 then
                    necklace = 12003
                    gem = 55582
                    place = "The Mist Temple Altar"
                    hint = "in the Misty Caverns."
                elseif tonumber(_sw1) == 2 then
                    necklace = 23708
                    gem = 55590
                    place = "Chamber of Chaos"
                    hint = "in the Temple of Chaos."
                elseif tonumber(_sw1) == 3 then
                    necklace = 58005
                    gem = 55622
                    place = "Altar of Borgan"
                    hint = "in the lost city of Nymrill."
                elseif tonumber(_sw1) == 4 then
                    necklace = 48123
                    gem = 55654
                    place = "A Hidden Altar Room"
                    hint = "in a cave in South Caelia's Wailing Mountains."
                elseif tonumber(_sw1) == 5 then
                    necklace = 12336
                    gem = 55662
                    place = "The Altar of the Snow Leopard Order"
                    hint = "buried deep in Mt. Frostbite"
                elseif tonumber(_sw1) == 6 then
                    necklace = 43019
                    gem = 55677
                    place = "Chapel Altar"
                    hint = "deep underground in a lost castle."
                elseif tonumber(_sw1) == 7 then
                    necklace = 37015
                    gem = 55709
                    place = "A Cliffside Altar"
                    hint = "tucked away in the land of Dreams."
                elseif tonumber(_sw1) == 8 then
                    necklace = 58429
                    gem = 55738
                    place = "Dark Altar"
                    hint = "entombed with an ancient evil king."
                elseif tonumber(_sw1) == 9 then
                    necklace = 52010
                    gem = 55739
                    place = "An Altar"
                    hint = "far away in the Plane of Air."
                end
            end
            local attack = pendantstage * 100
            actor:send("Quest Master: " .. tostring(master))
            if job1 or job2 or job3 or job4 then
                actor:send("</>")
                actor:send("You've done the following:")
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
            actor:send("</>")
            actor:send("You need to:")
            if job1 and job2 and job3 and job4 then
                actor:send("Give " .. tostring(master) .. " your old necklace.")
                return _return_value
            end
            if not job1 then
                local remaining = attack - (actor:get_quest_var("paladin_pendant:attack_counter") or 0)
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
        end
    end
end
return _return_value$trig$, '834106a300f508f7b66544b5cec8d14d'),
  -- data/triggers/004/004_60_eye_of_the_tiger_progress_journal.lua
  (4, 60, $trig$-- Converted from DG Script #460: Eye of the Tiger progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
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
                    actor:send("- found " .. "%get.obj_shortdesc[%trophy%]%")
                end
                if job3 then
                    actor:send("- found " .. "%get.obj_shortdesc[%gem%]%")
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
                actor:send("- find <b:green>" .. "%get.obj_shortdesc[%trophy%]%</>")
            end
            if not job3 then
                actor:send("- find <b:green>" .. "%get.obj_shortdesc[%gem%]%</>")
            end
            if not job4 then
                actor:send("- <b:green>forage</> in a place called \"<b:green>" .. tostring(place) .. "</>\".")
                actor:send("</>   It's <b:green>" .. tostring(hint) .. "</>")
            end
        end
    end
end
return _return_value$trig$, '6e3559b6c7a24ab478945ae3d0808a8e'),
  -- data/triggers/004/004_86_infernal_weaponry_progress_journal.lua
  (4, 86, $trig$-- Converted from DG Script #486: Infernal Weaponry progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if string.find(arg, "trident") or string.find(arg, "hell trident") or string.find(arg, "hell_trident") or string.find(arg, "Infernal Weaponry") or string.find(arg, "infernal") or string.find(arg, "weaponry") or string.find(arg, "infernal_weaponry") then
    if string.find(actor.class, "diabolist") then
        _return_value = true
        actor:send("<b:u:green>Infernal Weaponry</>")
        actor:send("Weapons of the lower realms await a diabolist dedicated enough to claim them.")
        local hellstage = actor:get_quest_stage("hell_trident")
        local minlevel
        if (hellstage or 0) == 0 then
            minlevel = 35
        elseif hellstage == 1 then
            minlevel = 65
        elseif hellstage == 2 then
            minlevel = 90
        end
        if not actor:get_has_completed("hell_trident") then
            actor:send("Minimum Level: " .. tostring(minlevel))
        end
        local status
        if actor:get_has_completed("hell_trident") then
            status = "Completed!"
        elseif (hellstage or 0) > 0 then
            status = "In Progress"
        else
            status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
        if actor:get_quest_stage("hell_trident") > 0 then
            local job1 = actor:get_quest_var("hell_trident:helltask1")
            local job2 = actor:get_quest_var("hell_trident:helltask2")
            local job3 = actor:get_quest_var("hell_trident:helltask3")
            local job4 = actor:get_quest_var("hell_trident:helltask4")
            local job5 = actor:get_quest_var("hell_trident:helltask5")
            local job6 = actor:get_quest_var("hell_trident:helltask6")
            -- switch on hellstage
            local master, pl_word, word, spell2, spell1, task6, task6do
            do
                local _sw1 = string.lower(tostring(hellstage or ""))
                if tonumber(_sw1) == 1 then
                    master = mobiles.template(60, 32).name
                    local gem = 55662
                    pl_word = "angels"
                    word = "angel"
                    spell2 = "Banish"
                    spell1 = "Hellfire and Brimstone"
                    task6 = "assisted Vilekka Kar'Shezden"
                    task6do = "<b:yellow>Assist the High Priestess of Lolth in hunting down and destroying the heretics of her Goddess.</>"
                elseif tonumber(_sw1) == 2 then
                    master = mobiles.template(125, 26).name
                    local gem = 55739
                    pl_word = "ghaeles, solars, or seraphs"
                    word = "ghaele, solar, or seraph"
                    spell1 = "Resurrect"
                    spell2 = "Hell Gate"
                    task6 = "Defeated the Undead Prince"
                    task6do = "find one long-buried and branded an infidel.  <b:yellow>Finish his undying duel for him</> as a sacrifice of honor."
                else
                    if not actor:get_has_completed("hell_trident") then
                        actor:send("Only someone mighty enough to claim the ancient truthstone and present it unto the leader of chaos may be given the dark powers of hell.  These diabolists will be rewarded for their unquenchable devotion by the dark gods themselves!")
                        return _return_value
                    end
                end
            end
            if actor.level >= minlevel then
                actor:send("Quest Master: " .. tostring(master))
                if (actor:get_quest_var("hell_trident:greet") or 0) == 0 then
                    actor:send("Speak with " .. tostring(master) .. ".")
                    return _return_value
                else
                    if job1 or job2 or job3 or job4 or job5 or job6 then
                        actor:send("You have done the following:")
                        if job1 then
                            actor:send("- attacked 666 times")
                        end
                        if job2 then
                            actor:send("- slayed 6 " .. tostring(pl_word))
                        end
                        if job3 then
                            actor:send("- found 6 " .. "%get.obj_shortdesc[%gem%]%")
                        end
                        if job5 then
                            actor:send("- learned " .. tostring(spell2))
                        end
                        if job4 then
                            actor:send("- learned " .. tostring(spell1))
                        end
                        if job6 then
                            actor:send("- " .. tostring(task6))
                        end
                        actor:send("</>")
                    end
                    if job1 and job2 and job3 and job4 and job5 and job6 then
                        actor:send("Give " .. tostring(master) .. " your trident to finalize the pact.")
                    else
                        actor:send("You must still:")
                        if not job1 then
                            local remaining = 666 - (actor:get_quest_var("hell_trident:attack_counter") or 0)
                            if remaining > 1 then
                                actor:send("- <b:yellow>attack " .. tostring(remaining) .. " more times with your trident</>")
                            else
                                actor:send("- <b:yellow>attack " .. tostring(remaining) .. " more time with your trident</>")
                            end
                        end
                        if not job2 then
                            local kills = 6 - (actor:get_quest_var("hell_trident:celestials") or 0)
                            if kills > 1 then
                                actor:send("- <b:yellow>slay " .. tostring(kills) .. " more " .. tostring(pl_word) .. "</>")
                            else
                                actor:send("- <b:yellow>slay " .. tostring(kills) .. " more " .. tostring(word) .. "</>")
                            end
                        end
                        if not job3 then
                            local gems = 6 - (actor:get_quest_var("hell_trident:gems") or 0)
                            if gems > 1 then
                                actor:send("- <b:yellow>find " .. tostring(gems) .. " more " .. "%get.obj_pldesc[%gem%]%</>")
                            else
                                actor:send("- <b:yellow>find " .. tostring(gems) .. " more " .. "%get.obj_noadesc[%gem%]%</>")
                            end
                        end
                        if not job5 then
                            actor:send("- <b:yellow>learn " .. tostring(spell2) .. "</>")
                        end
                        if not job4 then
                            actor:send("- <b:yellow>learn " .. tostring(spell1) .. "</>")
                        end
                        if not job6 then
                            actor:send("- " .. tostring(task6do))
                        end
                    end
                end
            end
        end
    end
end
return _return_value$trig$, 'd287a1a9d040b878548b202b28125d29'),
  -- data/triggers/004/004_97_rogue_cloak_progress_journal.lua
  (4, 97, $trig$-- Converted from DG Script #497: Rogue Cloak progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if string.find(arg, "cloak") or string.find(arg, "dagger") or string.find(arg, "cloak and dagger") or string.find(arg, "rogue_cloak") then
    if string.find(actor.class, "rogue") or string.find(actor.class, "bard") or actor.class ~= "thief" then
        _return_value = true
        local huntstage = actor:get_quest_stage("treasure_hunter")
        local cloakstage = actor:get_quest_stage("rogue_cloak")
        local job1 = actor:get_quest_var("rogue_cloak:cloaktask1")
        local job2 = actor:get_quest_var("rogue_cloak:cloaktask2")
        local job3 = actor:get_quest_var("rogue_cloak:cloaktask3")
        local job4 = actor:get_quest_var("rogue_cloak:cloaktask4")
        actor:send("<b:u:green>Cloak and Dagger</>")
        local level
        if (cloakstage or 0) == 0 then
            level = 10
        else
            level = cloakstage * 10
        end
        if not actor:get_has_completed("rogue_cloak") then
            actor:send("Minimum Level: " .. tostring(level))
        end
        local status
        if actor:get_has_completed("rogue_cloak") then
            status = "Completed!"
        elseif (cloakstage or 0) > 0 then
            status = "In Progress"
        else
            status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
        if actor.level >= level then
            if cloakstage == 0 then
                actor:send("You must <b:cyan>[hunt]</> down more treasure first.")
                return _return_value
            elseif (cloakstage >= huntstage) and not actor:get_has_completed("treasure_hunter") then
                actor:send("Find some more treasures before you seek another promotion.")
                return _return_value
            end
            -- switch on cloakstage
            local cloak
            local gem
            local place
            local hint
            do
                local _sw1 = string.lower(tostring(cloakstage or ""))
                if tonumber(_sw1) == 1 then
                    cloak = 58801
                    gem = 55585
                    place = "A Storage Room"
                    hint = "in the house on the hill."
                elseif tonumber(_sw1) == 2 then
                    cloak = 17307
                    gem = 55593
                    place = "A Small Alcove"
                    hint = "in the holy library."
                elseif tonumber(_sw1) == 3 then
                    cloak = 10308
                    gem = 55619
                    place = "either Treasure Room"
                    hint = "in the paladin fortress."
                elseif tonumber(_sw1) == 4 then
                    cloak = 12325
                    gem = 55659
                    place = "The Treasure Room"
                    hint = "beyond the Tower in the Wastes."
                elseif tonumber(_sw1) == 5 then
                    cloak = 43022
                    gem = 55663
                    place = "Treasury"
                    hint = "in the ghostly fortress."
                elseif tonumber(_sw1) == 6 then
                    cloak = 23810
                    gem = 55674
                    place = "either Treasure Room with a chest"
                    hint = "lost in the sands."
                elseif tonumber(_sw1) == 7 then
                    cloak = 51013
                    gem = 55714
                    place = "Mesmeriz's Secret Treasure Room"
                    hint = "hidden deep underground."
                elseif tonumber(_sw1) == 8 then
                    cloak = 58410
                    gem = 55740
                    place = "Treasure Room"
                    hint = "sunk in the swamp."
                elseif tonumber(_sw1) == 9 then
                    cloak = 52009
                    gem = 55741
                    place = "Treasure Room"
                    hint = "buried with an ancient king."
                end
            end
            local attack = cloakstage * 100
            if job1 or job2 or job3 or job4 then
                actor:send("You've done the following:")
                if job1 then
                    actor:send("- attacked " .. tostring(attack) .. " times")
                end
                if job2 then
                    actor:send("- found " .. "%get.obj_shortdesc[%cloak%]%")
                end
                if job3 then
                    actor:send("- found " .. "%get.obj_shortdesc[%gem%]%")
                end
                if job4 then
                    actor:send("- searched in " .. tostring(place))
                end
            end
            actor:send("</>")
            actor:send("You need to:")
            if job1 and job2 and job3 and job4 then
                actor:send("Give Honus your old cloak.")
                return _return_value
            end
            if not job1 then
                local remaining = attack - (actor:get_quest_var("rogue_cloak:attack_counter") or 0)
                actor:send("- attack <b:yellow>" .. tostring(remaining) .. "</> more times while wearing your cloak.")
            end
            if not job2 then
                actor:send("- find <b:yellow>" .. "%get.obj_shortdesc[%cloak%]%</>")
            end
            if not job3 then
                actor:send("- find <b:yellow>" .. "%get.obj_shortdesc[%gem%]%</>")
            end
            if not job4 then
                actor:send("- <b:yellow>search</> in a place called \"<b:yellow>" .. tostring(place) .. "</>\".")
                actor:send("</>   It's <b:yellow>" .. tostring(hint) .. "</>")
            end
        end
    end
end
return _return_value$trig$, 'b95138d9f45b7d715a3569efb0b3e45f'),
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
                if (person:get_quest_var("waterform:regionnumber") or 0) == 0 then
                    person:set_quest_var("waterform", "region%number%", 1)
                    person:send("<b:blue>You gather part of " .. tostring(self.name) .. " in " .. tostring(objects.template(28, 8).name) .. ".</>")
                    self.room:send_except(person, "<b:blue>" .. tostring(person.name) .. " gathers part of " .. tostring(self.name) .. " in " .. tostring(objects.template(28, 8).name) .. ".</>")
                end
                local region1 = person:get_quest_var("waterform:region1")
                local region2 = person:get_quest_var("waterform:region2")
                local region3 = person:get_quest_var("waterform:region3")
                local region4 = person:get_quest_var("waterform:region4")
                local region5 = person:get_quest_var("waterform:region5")
                if (region1 or 0) + (region2 or 0) + (region3 or 0) + (region4 or 0) + (region5 or 0) > 3 then
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
    if (actor:get_quest_var("waterform:regionnumber") or 0) == 0 then
        actor:set_quest_var("waterform", "region%number%", 1)
        actor:send("<b:blue>You gather part of " .. tostring(self.name) .. " in " .. tostring(objects.template(28, 8).name) .. ".</>")
        self.room:send_except(actor, "<b:blue>" .. tostring(actor.name) .. " gathers part of " .. tostring(self.name) .. " in " .. tostring(objects.template(28, 8).name) .. ".</>")
    end
    local region1 = actor:get_quest_var("waterform:region1")
    local region2 = actor:get_quest_var("waterform:region2")
    local region3 = actor:get_quest_var("waterform:region3")
    local region4 = actor:get_quest_var("waterform:region4")
    local region5 = actor:get_quest_var("waterform:region5")
    if (region1 or 0) + (region2 or 0) + (region3 or 0) + (region4 or 0) + (region5 or 0) > 3 then
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
return _return_value$trig$, '31dd00c5558bd3fe54453f21cd34bc57'),
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
    if value >= (actor:get_quest_var("trainer_3160:price") or 0) then
        self:command("grin " .. tostring(actor.name))
        wait(1)
        actor:send(tostring(self.name) .. " says, 'Fantastic. Let's get started...'")
        wait(5)
        actor:send("Some time passes...")
        wait(3)
        actor:send("You feel you are getting the hang of things.")
        wait(3)
        actor:send("You feel your skill in " .. tostring(full_skill) .. " improving dramatically!")
        -- Legacy mskillset: the maximum proficiency the trainer quoted (level and class capped).
        skills.set_level(actor, full_skill, actor:get_quest_var("trainer_3160:max_skill") or 1000)
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
return _return_value$trig$, 'bd4d27cbb78bb6b480f06f54fb57a586'),
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
    if value >= (actor:get_quest_var("trainer_3165:price") or 0) then
        self:command("grin " .. tostring(actor.name))
        wait(1)
        actor:send(tostring(self.name) .. " says, 'Fantastic. Let's get started...'")
        wait(5)
        actor:send("Some time passes...")
        wait(3)
        actor:send("You feel you are getting the hang of things.")
        wait(3)
        actor:send("You feel your skill in " .. tostring(full_skill) .. " improving dramatically!")
        -- Legacy mskillset: the maximum proficiency the trainer quoted (level and class capped).
        skills.set_level(actor, full_skill, actor:get_quest_var("trainer_3165:max_skill") or 1000)
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
return _return_value$trig$, '32946a473366410c03b5871fff84ed13'),
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
    if value >= (actor:get_quest_var("trainer_3170:price") or 0) then
        self:command("grin " .. tostring(actor.name))
        wait(1)
        actor:send(tostring(self.name) .. " says, 'Fantastic.  Let's get started...'")
        wait(5)
        actor:send("Some time passes...")
        wait(3)
        actor:send("You feel you are getting the hang of things.")
        wait(3)
        actor:send("You feel your skill in " .. tostring(full_skill) .. " improving dramatically!")
        -- Legacy mskillset: the maximum proficiency the trainer quoted (level and class capped).
        skills.set_level(actor, full_skill, actor:get_quest_var("trainer_3170:max_skill") or 1000)
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
return _return_value$trig$, 'c869e293754cec6a5e0a0e7ff4ab31f6'),
  -- data/triggers/030/030_183_corpse_retrieval_payment.lua
  (30, 183, $trig$-- Converted from DG Script #3183: corpse retrieval payment
-- Original: MOB trigger, flags: BRIBE, num_arg: 1 (minimum bribe in copper)

local _return_value = true  -- Default: allow action
if actor:get_quest_var("corpse_retrieval:actor_level") == actor.level then
    if value >= (actor:get_quest_var("corpse_retrieval:price") or 0) then
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
return _return_value$trig$, '20b1ae268365902b80e0f7e33febb1e1'),
  -- data/triggers/030/030_50_armor_exchange_greeting.lua
  (30, 50, $trig$-- Converted from DG Script #3050: Armor Exchange greeting
-- Original: MOB trigger, flags: GREET_ALL, probability: 100%
wait(0.2)
if actor.is_player then
    local item = actor:get_quest_var("armor_exchange:gem_id")
    if actor:get_quest_stage("armor_exchange") == 1 then
        actor:send(tostring(self.name) .. " shouts to you, 'Well howdy-hoo!  Welcome back!'")
        self:command("grin " .. tostring(actor))
        wait(2)
        if (item or 0) == 0 then
            actor:send(tostring(self.name) .. " says, 'Tell me dearie, what can I help ya find today?'")
        else
            actor:send(tostring(self.name) .. " says, 'Are you still looking for " .. objects.template(math.floor((item or 0) / 100), (item or 0) % 100).name .. "?'")
        end
    else
        actor:send(tostring(self.name) .. " hollers, 'Well hello there dearie!  Welcome to a land of rare and valuable treasures!'")
        actor:send(tostring(self.name) .. " indicates the massive piles of junk.")
        wait(1)
        actor:send(tostring(self.name) .. " says to you, 'We can trade all manner of precious old goodies here.  People leave behind armor they don't want anymore for stuff they do.'")
        wait(4)
        actor:send(tostring(self.name) .. " says, 'So what can I help you find today?'")
    end
end$trig$, '9ece90714275e8a40e14f9f4643b9c6d'),
  -- data/triggers/030/030_52_armor_exchange_confirm_order.lua
  (30, 52, $trig$-- Converted from DG Script #3052: Armor Exchange confirm order
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
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
wait(0.2)
local item = actor:get_quest_var("armor_exchange:armor_id")
if string.find(speech, "yes") then
    if (item or 0) == 0 then
        actor:send(tostring(self.name) .. " says, 'I don't think you asked me for anything, no sir.'")
        return _return_value
    end
    actor:send(tostring(self.name) .. " tells you, 'Oh my, yes dearie, of course.'")
    local class, tier
    if (item or 0) <= 55303 then
        class = 1
        tier = 1
    elseif (item or 0) <= 55307 then
        class = 1
        tier = 2
    elseif (item or 0) <= 55311 then
        class = 1
        tier = 3
    elseif (item or 0) <= 55315 then
        class = 1
        tier = 4
    elseif (item or 0) <= 55319 then
        class = 1
        tier = 5
    elseif (item or 0) <= 55323 then
        class = 1
        tier = 6
    elseif (item or 0) <= 55327 then
        class = 1
        tier = 7
    elseif (item or 0) <= 55331 then
        class = 2
        tier = 1
    elseif (item or 0) <= 55335 then
        class = 2
        tier = 2
    elseif (item or 0) <= 55339 then
        class = 2
        tier = 3
    elseif (item or 0) <= 55343 then
        class = 2
        tier = 4
    elseif (item or 0) <= 55347 then
        class = 2
        tier = 5
    elseif (item or 0) <= 55351 then
        class = 2
        tier = 6
    elseif (item or 0) <= 55355 then
        class = 2
        tier = 7
    elseif (item or 0) <= 55359 then
        class = 3
        tier = 1
    elseif (item or 0) <= 55363 then
        class = 3
        tier = 2
    elseif (item or 0) <= 55367 then
        class = 3
        tier = 3
    elseif (item or 0) <= 55371 then
        class = 3
        tier = 4
    elseif (item or 0) <= 55375 then
        class = 3
        tier = 5
    elseif (item or 0) <= 55379 then
        class = 3
        tier = 6
    elseif (item or 0) <= 55383 then
        class = 3
        tier = 7
    end
    actor:send(tostring(self.name) .. " says, 'So " .. objects.template(math.floor((item or 0) / 100), (item or 0) % 100).name .. " is a <b:yellow>class " .. tostring(class) .. " tier " .. tostring(tier) .. "</> piece of gear.'")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'I'll give it to you for any other armor of equal or greater rarity.'")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'Consult the chart for degrees of rarity.'")
    actor:send(tostring(self.name) .. " points to the sign.")
else
    actor:set_quest_var("gem_exchange", "gem_id", 0)
    actor:send(tostring(self.name) .. " says, 'Alright, what DO you want then?'")
end$trig$, '74b6cef906221ff5d4c1888f5287e07c'),
  -- data/triggers/030/030_53_armor_exchange_receive_exchange.lua
  (30, 53, $trig$-- Converted from DG Script #3053: Armor Exchange receive exchange
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
local item = actor:get_quest_var("armor_exchange:armor_id")
if (item or 0) ~= 0 then
    local found
    if (item or 0) <= 55303 then
        if (object.zone_id == 553 and object.id <= 83) then
            found = 1
        end
    elseif (item or 0) <= 55307 then
        if (object.zone_id == 553 and object.id >= 4 and object.id <= 83) then
            found = 1
        end
    elseif (item or 0) <= 55311 then
        if (object.zone_id == 553 and object.id >= 8 and object.id <= 83) then
            found = 1
        end
    elseif (item or 0) <= 55315 then
        if (object.zone_id == 553 and object.id >= 12 and object.id <= 83) then
            found = 1
        end
    elseif (item or 0) <= 55319 then
        if (object.zone_id == 553 and object.id >= 16 and object.id <= 83) then
            found = 1
        end
    elseif (item or 0) <= 55323 then
        if (object.zone_id == 553 and object.id >= 20 and object.id <= 83) then
            found = 1
        end
    elseif (item or 0) <= 55327 then
        if (object.zone_id == 553 and object.id >= 24 and object.id <= 83) then
            found = 1
        end
    elseif (item or 0) <= 55331 then
        if (object.zone_id == 553 and object.id >= 28 and object.id <= 83) then
            found = 1
        end
    elseif (item or 0) <= 55335 then
        if (object.zone_id == 553 and object.id >= 32 and object.id <= 83) then
            found = 1
        end
    elseif (item or 0) <= 55339 then
        if (object.zone_id == 553 and object.id >= 36 and object.id <= 83) then
            found = 1
        end
    elseif (item or 0) <= 55343 then
        if (object.zone_id == 553 and object.id >= 40 and object.id <= 83) then
            found = 1
        end
    elseif (item or 0) <= 55347 then
        if (object.zone_id == 553 and object.id >= 44 and object.id <= 83) then
            found = 1
        end
    elseif (item or 0) <= 55351 then
        if (object.zone_id == 553 and object.id >= 48 and object.id <= 83) then
            found = 1
        end
    elseif (item or 0) <= 55355 then
        if (object.zone_id == 553 and object.id >= 52 and object.id <= 83) then
            found = 1
        end
    elseif (item or 0) <= 55359 then
        if (object.zone_id == 553 and object.id >= 56 and object.id <= 83) then
            found = 1
        end
    elseif (item or 0) <= 55363 then
        if (object.zone_id == 553 and object.id >= 60 and object.id <= 83) then
            found = 1
        end
    elseif (item or 0) <= 55367 then
        if (object.zone_id == 553 and object.id >= 64 and object.id <= 83) then
            found = 1
        end
    elseif (item or 0) <= 55371 then
        if (object.zone_id == 553 and object.id >= 68 and object.id <= 83) then
            found = 1
        end
    elseif (item or 0) <= 55375 then
        if (object.zone_id == 553 and object.id >= 72 and object.id <= 83) then
            found = 1
        end
    elseif (item or 0) <= 55379 then
        if (object.zone_id == 553 and object.id >= 76 and object.id <= 83) then
            found = 1
        end
    elseif (item or 0) <= 55783 then
        if (object.zone_id == 553 and object.id >= 80 and object.id <= 83) then
            found = 1
        end
    end
    if found == 1 then
        wait(0.2)
        actor:send(tostring(self.name) .. " says, 'Here you are my dear!'")
        world.destroy(object)
        self.room:spawn_object(math.floor((item or 0) / 100), (item or 0) % 100)
        self:command("give all " .. tostring(actor))
        wait(0.2)
        actor:send(tostring(self.name) .. " says, 'A pleasure connecting lost things to their owners!'")
        actor:set_quest_var("armor_exchange", "armor_id", 0)
    else
        _return_value = true
        actor:send(tostring(self.name) .. " refuses to perform the exchange.")
        wait(1)
        if (object.zone_id == 553 and object.id <= 83) then
            actor:send(tostring(self.name) .. " says, 'That's not rare enough!  I won't take " .. tostring(object.shortdesc) .. " for " .. objects.template(math.floor((item or 0) / 100), (item or 0) % 100).name .. "!'")
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
return _return_value$trig$, '46b35bc83c9d7e1036a2474c03107882'),
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
wait(0.2)
actor:send("<b:green>Dragon Slayer</>")
if actor:get_has_completed("dragon_slayer") then
    actor:send(tostring(self.name) .. " says, 'The only dragons remaining are beasts of legend!'")
elseif actor:get_quest_stage("dragon_slayer") == 0 and actor.level > 4 then
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
        do
            local _sw1 = string.lower(tostring(actor:get_quest_stage("dragon_slayer") or ""))
            if tonumber(_sw1) == 1 then
                actor:send(tostring(self.name) .. " says, 'You still have a dragon to slay.  If you can't even take out a dragon hedge, you'll never be ready for the real thing.'")
            elseif tonumber(_sw1) == 2 then
                actor:send(tostring(self.name) .. " says, 'You still have a dragon to slay.  Hunt down the green wyrmling in Morgan Hill.'")
            elseif tonumber(_sw1) == 3 then
                actor:send(tostring(self.name) .. " says, 'You still have a dragon to slay.  Hunt down Wug the Fiery Drakling.'")
            elseif tonumber(_sw1) == 4 then
                actor:send(tostring(self.name) .. " says, 'You still have a dragon to slay.  Hunt down the young blue dragon near the Tower in the Wastes.'")
            elseif tonumber(_sw1) == 5 then
                actor:send(tostring(self.name) .. " says, 'You still have a dragon to slay.  Search the forests in South Caelia for a faerie dragon.'")
            elseif tonumber(_sw1) == 6 then
                actor:send(tostring(self.name) .. " says, 'You still have a dragon to slay.  Kill that damn wyvern in the Highlands.'")
            elseif tonumber(_sw1) == 7 then
                actor:send(tostring(self.name) .. " says, 'You still have a dragon to slay.  Take down one of those ice lizards in Frost Valley.'")
            elseif tonumber(_sw1) == 8 then
                actor:send(tostring(self.name) .. " says, 'You still have a dragon to slay.  Find and vanquish the Beast of Borgan.'")
            elseif tonumber(_sw1) == 9 then
                actor:send(tostring(self.name) .. " says, 'You still have a dragon to slay.  Eliminate the dragon the Ice Cult up north worships.'")
            elseif tonumber(_sw1) == 10 then
                actor:send(tostring(self.name) .. " says, 'You still have a dragon to slay.  Destroy the mighty Hydra - and watch out for all its heads!'")
            end
        end
    end
else
    actor:send(tostring(self.name) .. " says, 'More dragons exist, but they're too dangerous without more experience.  Come back when you've seen a little more.'")
end
local anti = "Anti-Paladin"
if actor.class == "paladin" or actor.class == "anti-paladin" then
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
    do
        local _sw2 = string.lower(tostring(pendantstage or ""))
        if tonumber(_sw2) == 1 then
            local necklace = 12003
            local gem = 55582
            place = "The Mist Temple Altar"
            hint = "in the Misty Caverns."
        elseif tonumber(_sw2) == 2 then
            local necklace = 23708
            local gem = 55590
            place = "Chamber of Chaos"
            hint = "in the Temple of Chaos."
        elseif tonumber(_sw2) == 3 then
            local necklace = 58005
            local gem = 55622
            place = "Altar of Borgan"
            hint = "in the lost city of Nymrill."
        elseif tonumber(_sw2) == 4 then
            local necklace = 48123
            local gem = 55654
            place = "A Hidden Altar Room"
            hint = "in a cave in South Caelia's Wailing Mountains."
        elseif tonumber(_sw2) == 5 then
            local necklace = 12336
            local gem = 55662
            place = "The Altar of the Snow Leopard Order"
            hint = "buried deep in Mt. Frostbite"
        elseif tonumber(_sw2) == 6 then
            local necklace = 43019
            local gem = 55677
            place = "Chapel Altar"
            hint = "deep underground in a lost castle."
        elseif tonumber(_sw2) == 7 then
            local necklace = 37015
            local gem = 55709
            place = "A Cliffside Altar"
            hint = "tucked away in the land of Dreams."
        elseif tonumber(_sw2) == 8 then
            local necklace = 58429
            local gem = 55738
            place = "Dark Altar"
            hint = "entombed with an ancient evil king."
        elseif tonumber(_sw2) == 9 then
            local necklace = 52010
            local gem = 55739
            place = "An Altar"
            hint = "far away in the Plane of Air."
        end
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
        local remaining = attack - (actor:get_quest_var("paladin_pendant:attack_counter") or 0)
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
end$trig$, 'f01778746150e0a812a3562303595496'),
  -- data/triggers/041/041_03_3bl_turn_in.lua
  (41, 3, $trig$local _return_value = true  -- Default: allow action
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
    -- pertinent object definitions for this faction
    -- trophies
    -- 
    local id_3el_skull = 5504
    local id_3el_ring = 5506
    local id_3el_badge = 5508
    local id_3el_token = 5510
    local id_3el_insignia = 5512
    local id_3el_wand = 5514
    local id_3el_symbol = 5516
    -- gems for this faction
    local id_gem_3bl_cap = 55570
    local id_gem_3bl_neck = 55571
    local id_gem_3bl_arm = 55572
    local id_gem_3bl_wrist = 55573
    local id_gem_3bl_staff = 55581
    local id_gem_3bl_ssword = 55582
    local id_gem_3bl_whammer = 55583
    local id_gem_3bl_flail = 55584
    local id_gem_3bl_food = 55566
    local id_gem_3bl_drink = 55567
    -- rewards
    local id_3bl_cap = 17
    local id_3bl_neck = 19
    local id_3bl_arm = 21
    local id_3bl_wrist = 23
    local id_3bl_staff = 39
    local id_3bl_ssword = 40
    local id_3bl_whammer = 41
    local id_3bl_flail = 42
    local id_3bl_food = 55
    local id_3bl_drink = 57
    -- 
    -- attempt to reinitialize slutty dg variables to '' (nothing)
    -- so this switch will work.
    -- 
    is_gem = nil
    exp_multiplier = nil
    id_trophy = nil
    faction_multiplier = nil
    id_reward = nil
    faction_required = nil
    -- 
    -- These cases set the variables for the quests.
    -- The cases below switch on object.id (the local id of the
    -- proto handed to the NPC by the player).
    -- 
    -- These cases will only have the objects rewarded by this
    -- questmaster though the full set of objects will be defined
    -- by the script.
    -- 
    -- switch on object.id
    local is_gem, exp_multiplier, id_reward, faction_required, faction_multiplier
    if object.id == "%id_gem_3bl_cap%" then
        is_gem = 1
        exp_multiplier = 10
        id_reward = id_3bl_cap
        faction_required = 20
        faction_multiplier = 1
    elseif object.id == "%id_gem_3bl_food%" then
        is_gem = 1
        exp_multiplier = 10
        id_reward = id_3bl_food
        faction_required = 20
        faction_multiplier = 1
    elseif object.id == "%id_gem_3bl_drink%" then
        is_gem = 1
        exp_multiplier = 10
        id_reward = id_3bl_drink
        faction_required = 20
        faction_multiplier = 1
    elseif object.id == "%id_gem_3bl_ssword%" then
        is_gem = 1
        exp_multiplier = 10
        id_reward = id_3bl_ssword
        faction_required = 20
        faction_multiplier = 1
    elseif object.id == "%id_gem_3bl_neck%" then
        is_gem = 1
        exp_multiplier = 12
        id_reward = id_3bl_neck
        faction_required = 40
        faction_multiplier = 1
    elseif object.id == "%id_gem_3bl_staff%" then
        is_gem = 1
        exp_multiplier = 12
        id_reward = id_3bl_staff
        faction_required = 40
        faction_multiplier = 1
    elseif object.id == "%id_gem_3bl_arm%" then
        is_gem = 1
        exp_multiplier = 14
        id_reward = id_3bl_arm
        faction_required = 55
        faction_multiplier = 1
    elseif object.id == "%id_gem_3bl_whammer%" then
        is_gem = 1
        exp_multiplier = 14
        id_reward = id_3bl_whammer
        faction_required = 55
        faction_multiplier = 1
    elseif object.id == "%id_gem_3bl_wrist%" then
        is_gem = 1
        exp_multiplier = 16
        id_reward = id_3bl_wrist
        faction_required = 70
        faction_multiplier = 1
    elseif object.id == "%id_gem_3bl_flail%" then
        is_gem = 1
        exp_multiplier = 16
        id_reward = id_3bl_flail
        faction_required = 70
        faction_multiplier = 1
    elseif object.id == "%id_3el_skull%" then
        exp_multiplier = 2
        local id_trophy = id_3el_skull
        faction_multiplier = 1
    elseif object.id == "%id_3el_ring%" then
        exp_multiplier = 2
        local id_trophy = id_3el_ring
        faction_multiplier = 1
    elseif object.id == "%id_3el_badge%" then
        exp_multiplier = 2
        local id_trophy = id_3el_badge
        faction_multiplier = 1
    elseif object.id == "%id_3el_token%" then
        exp_multiplier = 2
        local id_trophy = id_3el_token
        faction_multiplier = 2
    elseif object.id == "%id_3el_insignia%" then
        exp_multiplier = 2
        local id_trophy = id_3el_insignia
        faction_multiplier = 2
    elseif object.id == "%id_3el_wand%" then
        exp_multiplier = 2
        local id_trophy = id_3el_wand
        faction_multiplier = 2
    elseif object.id == "%id_3el_symbol%" then
        exp_multiplier = 2
        local id_trophy = id_3el_symbol
        faction_multiplier = 3
    else
        _return_value = true
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
        if actor:get_quest_var("black_legion:id_trophy_trophies") then
        else
            actor:set_quest_var("black_legion", "%id_trophy%_trophies", 0)
        end
        local trophies = actor:get_quest_var("black_legion:id_trophy_trophies")
        actor:set_quest_var("black_legion", "%id_trophy%_trophies", trophies)
        -- The highest faction a player can gain from interacting with the 3rd front creatures will
        -- be 200.  For this section the trophy turn in will reply on this and other checks.
        if (actor:get_quest_var("black_legion:bl_faction") or 0) < 100 then
            local trophies = (actor:get_quest_var("black_legion:id_trophy_trophies") or 0) + 1
            actor:set_quest_var("black_legion", "%id_trophy%_trophies", trophies)
            wait(0.2)
            actor:send(tostring(self.name) .. " tells you, 'Hrm, I see you have been out raiding the")
            actor:send("</>monks assisting the Eldorians.  According to my records you have now turned in")
            actor:send("</>have now turned in <b:yellow>" .. tostring(trophies) .. "</> <b:white>" .. "%get.obj_shortdesc[%id_trophy%]%</>.'")
            world.destroy(object)  -- TODO(parity): legacy converter wrote `object.name`
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
                local trophies = (actor:get_quest_var("black_legion:id_trophy_trophies") or 0) + 1
                actor:set_quest_var("black_legion", "%id_trophy%_trophies", trophies)
            else
                _return_value = true
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
        actor:save()  -- TODO(parity): legacy converter wrote `actor.name:save()`
    end
    if is_gem then
        -- hrmm Jelos' magical variable declaration
        if actor:get_quest_var("black_legion:id_reward_reward") then
        else
            actor:set_quest_var("black_legion", "%id_reward%_reward", 0)
        end
        local rewards = actor:get_quest_var("black_legion:id_reward_reward")
        actor:set_quest_var("black_legion", "%id_reward%_reward", rewards)
        if actor.alignment >= 151 then
            _return_value = true
            wait(0.2)
            actor:send(tostring(self.name) .. " tells you, 'You aren't quite evil enough for these")
            actor:send("</>rewards.'")
            return _return_value
        end
        if (actor:get_quest_var("black_legion:bl_faction") or 0) >= faction_required then
            local rewards = (actor:get_quest_var("black_legion:id_reward_reward") or 0) + 1
            actor:set_quest_var("black_legion", "%id_reward%_reward", rewards)
            wait(0.2)
            actor:send(tostring(self.name) .. " tells you, 'Ah yes, the Legion thanks you for your")
            actor:send("</>efforts.  Take this to aid you in your battles.'")
            wait(0.1)
            self.room:spawn_object(55, id_reward)
            wait(0.1)
            if (actor:get_quest_var("black_legion:id_reward_reward") or 0) == 1 then
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
            world.destroy(object)  -- TODO(parity): legacy converter wrote `object.name`
            self:destroy_item("all.eldoria-trophy")
            self:command("give all " .. tostring(actor.name))
            actor:save()  -- TODO(parity): legacy converter wrote `actor.name:save()`
        else
            _return_value = true
            wait(0.2)
            actor:send(tostring(self.name) .. " tells you, 'You aren't quite allied enough with our")
            actor:send("</>cause to earn that reward.'")
            return _return_value
        end
        -- end of if_gem section
    end
else
    -- Alignment not low enough or hasn't started the quest yet.
    _return_value = true
    wait(0.2)
    actor:send(tostring(self.name) .. " tells you, 'You aren't quite allied enough with our")
    actor:send("</>cause to earn our rewards.  You need a lower alignement, or to start these")
    actor:send("</>quests by saying <b:white>[yes]</>, <b:white>[quest]</>, or <b:white>[hello]</>.'")
end
return _return_value$trig$, 'fa387397d66c99b8e5719482e019b773'),
  -- data/triggers/041/041_07_3eg_turn_in.lua
  (41, 7, $trig$local _return_value = true  -- Default: allow action
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
    -- pertinent object definitions for this faction
    -- trophies
    local id_3bl_skull = 5503
    local id_3bl_ring = 5505
    local id_3bl_badge = 5507
    local id_3bl_token = 5509
    local id_3bl_insignia = 5511
    local id_3bl_wand = 5513
    local id_3bl_symbol = 5515
    -- gems for this faction
    local id_gem_3eg_cap = 55570
    local id_gem_3eg_neck = 55571
    local id_gem_3eg_arm = 55572
    local id_gem_3eg_wrist = 55573
    local id_gem_3eg_staff = 55581
    local id_gem_3eg_ssword = 55582
    local id_gem_3eg_whammer = 55583
    local id_gem_3eg_flail = 55584
    local id_gem_3eg_food = 55566
    local id_gem_3eg_drink = 55567
    -- rewards
    local id_3eg_cap = 18
    local id_3eg_neck = 20
    local id_3eg_arm = 22
    local id_3eg_wrist = 24
    local id_3eg_staff = 46
    local id_3eg_ssword = 47
    local id_3eg_whammer = 48
    local id_3eg_flail = 49
    local id_3eg_food = 56
    local id_3eg_drink = 58
    -- 
    -- attempt to reinitialize slutty dg variables to '' (nothing)
    -- so this switch will work.
    -- 
    is_gem = nil
    exp_multiplier = nil
    id_trophy = nil
    faction_multiplier = nil
    id_reward = nil
    faction_required = nil
    -- 
    -- These cases set the variables for the quests.
    -- The cases below switch on object.id (the local id of the
    -- proto handed to the NPC by the player).
    -- 
    -- switch on object.id
    local is_gem, exp_multiplier, id_reward, faction_required, faction_multiplier
    if object.id == "%id_gem_3eg_cap%" then
        is_gem = 1
        exp_multiplier = 10
        id_reward = id_3eg_cap
        faction_required = 20
        faction_multiplier = 1
    elseif object.id == "%id_gem_3eg_food%" then
        is_gem = 1
        exp_multiplier = 10
        id_reward = id_3eg_food
        faction_required = 20
        faction_multiplier = 1
    elseif object.id == "%id_gem_3eg_drink%" then
        is_gem = 1
        exp_multiplier = 10
        id_reward = id_3eg_drink
        faction_required = 20
        faction_multiplier = 1
    elseif object.id == "%id_gem_3eg_ssword%" then
        is_gem = 1
        exp_multiplier = 10
        id_reward = id_3eg_ssword
        faction_required = 20
        faction_multiplier = 1
    elseif object.id == "%id_gem_3eg_neck%" then
        is_gem = 1
        exp_multiplier = 12
        id_reward = id_3eg_neck
        faction_required = 40
        faction_multiplier = 1
    elseif object.id == "%id_gem_3eg_staff%" then
        is_gem = 1
        exp_multiplier = 12
        id_reward = id_3eg_staff
        faction_required = 40
        faction_multiplier = 1
    elseif object.id == "%id_gem_3eg_arm%" then
        is_gem = 1
        exp_multiplier = 14
        id_reward = id_3eg_arm
        faction_required = 55
        faction_multiplier = 1
    elseif object.id == "%id_gem_3eg_whammer%" then
        is_gem = 1
        exp_multiplier = 14
        id_reward = id_3eg_whammer
        faction_required = 55
        faction_multiplier = 1
    elseif object.id == "%id_gem_3eg_wrist%" then
        is_gem = 1
        exp_multiplier = 16
        id_reward = id_3eg_wrist
        faction_required = 70
        faction_multiplier = 1
    elseif object.id == "%id_gem_3eg_flail%" then
        is_gem = 1
        exp_multiplier = 16
        id_reward = id_3eg_flail
        faction_required = 70
        faction_multiplier = 1
    elseif object.id == "%id_3bl_skull%" then
        exp_multiplier = 2
        local id_trophy = id_3bl_skull
        faction_multiplier = 1
    elseif object.id == "%id_3bl_ring%" then
        exp_multiplier = 2
        local id_trophy = id_3bl_ring
        faction_multiplier = 1
    elseif object.id == "%id_3bl_badge%" then
        exp_multiplier = 2
        local id_trophy = id_3bl_badge
        faction_multiplier = 1
    elseif object.id == "%id_3bl_token%" then
        exp_multiplier = 2
        local id_trophy = id_3bl_token
        faction_multiplier = 2
    elseif object.id == "%id_3bl_insignia%" then
        exp_multiplier = 2
        local id_trophy = id_3bl_insignia
        faction_multiplier = 2
    elseif object.id == "%id_3bl_wand%" then
        exp_multiplier = 2
        local id_trophy = id_3bl_wand
        faction_multiplier = 2
    elseif object.id == "%id_3bl_symbol%" then
        exp_multiplier = 2
        local id_trophy = id_3bl_symbol
        faction_multiplier = 3
    else
        _return_value = true
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
        if actor:get_quest_var("black_legion:id_trophy_trophies") then
        else
            actor:set_quest_var("black_legion", "%id_trophy%_trophies", 0)
        end
        local trophies = actor:get_quest_var("black_legion:id_trophy_trophies")
        actor:set_quest_var("black_legion", "%id_trophy%_trophies", trophies)
        -- The highest faction a player can gain from interacting with the 3rd front creatures will
        -- be 200.  For this section the trophy turn in will reply on this and other checks.
        if (actor:get_quest_var("black_legion:eg_faction") or 0) < 100 then
            local trophies = (actor:get_quest_var("black_legion:id_trophy_trophies") or 0) + 1
            actor:set_quest_var("black_legion", "%id_trophy%_trophies", trophies)
            wait(0.2)
            actor:send(tostring(self.name) .. " tells you, 'Hrm, yes... you have been out fighting the")
            actor:send("</>influence of the Black Legion.  I see from my records you have now turned in")
            actor:send("</><b:yellow>" .. tostring(trophies) .. "</> <b:white>" .. "%get.obj_shortdesc[%id_trophy%]%</>.'")
            world.destroy(object)  -- TODO(parity): legacy converter wrote `object.name`
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
                local trophies = (actor:get_quest_var("black_legion:id_trophy_trophies") or 0) + 1
                actor:set_quest_var("black_legion", "%id_trophy%_trophies", trophies)
            else
                _return_value = true
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
        actor:save()  -- TODO(parity): legacy converter wrote `actor.name:save()`
        -- end of !if_gem section or trophy endif
    end
    if is_gem then
        -- hrmm Jelos' magical variable declaration
        if actor:get_quest_var("black_legion:id_reward_reward") then
        else
            actor:set_quest_var("black_legion", "%id_reward%_reward", 0)
        end
        local rewards = actor:get_quest_var("black_legion:id_reward_reward")
        actor:set_quest_var("black_legion", "%id_reward%_reward", rewards)
        if actor.alignment <= -151 then
            _return_value = true
            wait(0.2)
            actor:send(tostring(self.name) .. " tells you, 'You aren't quite good enough for these")
            actor:send("</>rewards.'")
            return _return_value
        end
        if (actor:get_quest_var("black_legion:eg_faction") or 0) >= faction_required then
            local rewards = (actor:get_quest_var("black_legion:id_reward_reward") or 0) + 1
            actor:set_quest_var("black_legion", "%id_reward%_reward", rewards)
            wait(0.2)
            actor:send(tostring(self.name) .. " tells you, 'Ah yes, the Guard thanks you for your")
            actor:send("</>efforts.  Take this to aid you in your battles.'")
            wait(0.1)
            self.room:spawn_object(55, id_reward)
            wait(0.1)
            if (actor:get_quest_var("black_legion:id_reward_reward") or 0) == 1 then
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
            world.destroy(object)  -- TODO(parity): legacy converter wrote `object.name`
            self:destroy_item("all.eldoria-trophy")
            self:command("give all " .. tostring(actor.name))
            actor:save()  -- TODO(parity): legacy converter wrote `actor.name:save()`
        else
            _return_value = true
            wait(0.2)
            actor:send(tostring(self.name) .. " tells you, 'You aren't quite allied enough with our cause")
            actor:send("</>to earn that reward.'")
            return _return_value
        end
        -- end of if_gem section
    end
else
    -- Alignment not high enough or hasn't started the quest yet.
    _return_value = true
    wait(0.2)
    actor:send(tostring(self.name) .. " tells you, 'You aren't quite allied enough with our cause")
    actor:send("</>to earn our rewards.  You need a higher alignment or to start these quests by")
    actor:send("</>saying <b:white>[yes]</> or <b:white>[quest]</> or <b:white>[hello]</>.'")
end
return _return_value$trig$, '04026d48f5cb474a684941b24547f45b'),
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
wait(0.2)
actor:send("<b:green>Beast Masters</>")
if actor:get_has_completed("beast_master") then
    actor:send(tostring(self.name) .. " says, 'You've already proven your dominion over the beasts of Ethilien!'")
elseif actor.level >= (actor:get_quest_stage("beast_master") - 1) * 10 then
    if actor:get_quest_var("beast_master:hunt") ~= "running" then
        actor:send(tostring(self.name) .. " says, 'You aren't on a hunt at the moment.'")
    else
        -- switch on actor:get_quest_stage("beast_master")
        do
            local _sw1 = string.lower(tostring(actor:get_quest_stage("beast_master") or ""))
            if tonumber(_sw1) == 1 then
                actor:send(tostring(self.name) .. " says, 'You're still on the hunt.  Slay an abominable slime creature in the sewers beneath Mielikki.'")
            elseif tonumber(_sw1) == 2 then
                actor:send(tostring(self.name) .. " says, 'You're still on the hunt.  Hunt down a large buck in the forests just outside of Mielikki.'")
            elseif tonumber(_sw1) == 3 then
                actor:send(tostring(self.name) .. " says, 'You're still on the hunt.  Track down the giant scorpion of Gothra.'")
            elseif tonumber(_sw1) == 4 then
                actor:send(tostring(self.name) .. " says, 'You're still on the hunt.  Head far to the south and kill a monstrous canopy spider.'")
            elseif tonumber(_sw1) == 5 then
                actor:send(tostring(self.name) .. " says, 'You're still on the hunt.  Behead the famed chimera of Fiery Island.'")
            elseif tonumber(_sw1) == 6 then
                actor:send(tostring(self.name) .. " says, 'You're still on the hunt.  Slay the \"king\" of the abominations known as driders.'")
            elseif tonumber(_sw1) == 7 then
                actor:send(tostring(self.name) .. " says, 'You're still on the hunt.  Close the eyes of a beholder from under Mt. Frostbite.'")
            elseif tonumber(_sw1) == 8 then
                actor:send(tostring(self.name) .. " says, 'You're still on the hunt.  Lay the Banshee to eternal rest.'")
            elseif tonumber(_sw1) == 9 then
                actor:send(tostring(self.name) .. " says, 'You're still on the hunt.  Put an end to Baba Yaga's dreamy witchcraft.'")
            elseif tonumber(_sw1) == 10 then
                actor:send(tostring(self.name) .. " says, 'You're still on the hunt.  Defeat the medusa below the city of Templace.'")
            end
        end
    end
else
    actor:send(tostring(self.name) .. " says, 'Unfortunately I don't have any beasts for you to pursue at the moment.  Check back later!'")
end
if actor.class == "warrior" or actor.class == "ranger" or actor.class == "berserker" or actor.class == "mercenary" then
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
    do
        local _sw2 = string.lower(tostring(trophystage or ""))
        if tonumber(_sw2) == 1 then
            local trophy = 1607
            local gem = 55579
            place = "A Coyote's Den"
            hint = "near the Kingdom of the Meer Cats."
        elseif tonumber(_sw2) == 2 then
            local trophy = 17806
            local gem = 55591
            place = "In the Lions' Den"
            hint = "in the western reaches of Gothra."
        elseif tonumber(_sw2) == 3 then
            local trophy = 1805
            local gem = 55628
            place = "either of the two Gigantic Roc Nests"
            hint = "in the Wailing Mountains."
        elseif tonumber(_sw2) == 4 then
            local trophy = 62513
            local gem = 55652
            place = "Chieftain's Lair"
            hint = "in Nukreth Spire in South Caelia."
        elseif tonumber(_sw2) == 5 then
            local trophy = 23803
            local gem = 55664
            place = "The Heart of the Den"
            hint = "where the oldest unicorn in South Caelia makes its home."
        elseif tonumber(_sw2) == 6 then
            local trophy = 43009
            local gem = 55685
            place = "Giant Lynx's Lair"
            hint = "far to the north beyond Mt. Frostbite."
        elseif tonumber(_sw2) == 7 then
            local trophy = 47008
            local gem = 55705
            place = "Giant Griffin's Nest"
            hint = "tucked away in a secluded and well guarded corner of Griffin Island."
        elseif tonumber(_sw2) == 8 then
            local trophy = 53323
            local gem = 55729
            place = "Witch's Den"
            hint = "entombed with an ancient evil king."
        elseif tonumber(_sw2) == 9 then
            local trophy = 52014
            local gem = 55741
            place = "Dargentan's Lair"
            hint = "at the pinnacle of his flying fortress."
        end
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
        local remaining = attack - (actor:get_quest_var("ranger_trophy:attack_counter") or 0)
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
end$trig$, 'ace07790365717091c12cad71af639ca'),
  -- data/triggers/053/053_30_rogue_cloak_progress.lua
  (53, 30, $trig$-- Converted from DG Script #5330: Rogue Cloak Progress
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
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
wait(0.2)
actor:send("<b:green>Treasure Hunters</>")
if actor:get_has_completed("treasure_hunter") then
    actor:send(tostring(self.name) .. " says, 'Only great treasures, the stuff of legend, still wait out there!'")
elseif actor:get_quest_stage("treasure_hunter") == 0 then
    actor:send(tostring(self.name) .. " says, 'You aren't doing anything for me right now.'")
elseif actor:get_quest_var("treasure_hunter:hunt") == "found" then
    actor:send(tostring(self.name) .. " says, 'Give me your current order first.'")
elseif actor.level >= (actor:get_quest_stage("treasure_hunter") - 1) * 10 then
    if actor:get_quest_var("treasure_hunter:hunt") ~= "running" then
        actor:send(tostring(self.name) .. " says, 'You aren't doing anything for me right now.'")
    else
        -- switch on actor:get_quest_stage("treasure_hunter")
        do
            local _sw1 = string.lower(tostring(actor:get_quest_stage("treasure_hunter") or ""))
            if tonumber(_sw1) == 1 then
                actor:send(tostring(self.name) .. " says, 'You still have a treasure to find.  Find that singing chain and I'll pay you for your time.'")
            elseif tonumber(_sw1) == 2 then
                actor:send(tostring(self.name) .. " says, 'You still have a treasure to find.  Find one of the true fire rings the theatre in Anduin gives out.  Not the fake prop ones most of the performers carry around, but the real ones they give out at their grand finale.'")
            elseif tonumber(_sw1) == 3 then
                actor:send(tostring(self.name) .. " says, 'You still have a treasure to find.  Find a sandstone ring in the caves to the west.'")
            elseif tonumber(_sw1) == 4 then
                actor:send(tostring(self.name) .. " says, 'You still have a treasure to find.  Recover the electrum hoop lost in the bayou shipwreck.'")
            elseif tonumber(_sw1) == 5 then
                actor:send(tostring(self.name) .. " says, 'You still have a treasure to find.  Bring me back a Rainbow Shell from the volcanic islands.'")
            elseif tonumber(_sw1) == 6 then
                actor:send(tostring(self.name) .. " says, 'You still have a treasure to find.  Raid Mystwatch and bring back the legendary Stormshield.'")
            elseif tonumber(_sw1) == 7 then
                actor:send(tostring(self.name) .. " says, 'You still have a treasure to find.  Get your hands on a Snow Leopard Cloak.'")
            elseif tonumber(_sw1) == 8 then
                actor:send(tostring(self.name) .. " says, 'You still have a treasure to find.  Find a magic ladder that uncoils itself.'")
            elseif tonumber(_sw1) == 9 then
                actor:send(tostring(self.name) .. " says, 'You still have a treasure to find.  Seek out a glowing phoenix feather.'")
            elseif tonumber(_sw1) == 10 then
                actor:send(tostring(self.name) .. " says, 'You still have a treasure to find.  Secure a piece of sleet armor.'")
            end
        end
    end
else
    actor:send(tostring(self.name) .. " says, 'There's still plenty of treasure out there, but it's too dangerous without more experience.  Come back when you've grown a little more.'")
end
if actor.class == "rogue" or actor.class == "bard" or actor.class == "thief" then
    actor:send("</>")
    actor:send("<b:green>Cloak and Shadow</>")
    local huntstage = actor:get_quest_stage("treasure_hunter")
    local cloakstage = actor:get_quest_stage("rogue_cloak")
    local job1 = actor:get_quest_var("rogue_cloak:cloaktask1")
    local job2 = actor:get_quest_var("rogue_cloak:cloaktask2")
    local job3 = actor:get_quest_var("rogue_cloak:cloaktask3")
    local job4 = actor:get_quest_var("rogue_cloak:cloaktask4")
    if actor.level < 10 then
        actor:send(tostring(self.name) .. " says, 'You aren't ready for an promotion yet.  Come back when you've grown a bit.'")
        return _return_value
    elseif actor.level < (cloakstage * 10) then
        actor:send(tostring(self.name) .. " says, 'You aren't ready for another promotion yet.  Come back when you've gained some more experience.'")
        return _return_value
    elseif actor:get_has_completed("rogue_cloak") then
        actor:send(tostring(self.name) .. " says, 'You've already been promoted as high as you can go!'")
        return _return_value
    end
    if cloakstage == 0 then
        self.room:send(tostring(self.name) .. " says, 'Sure.  You gotta <b:cyan>[hunt]</> down more treasure first though.'")
        return _return_value
    elseif (cloakstage >= huntstage) and not actor:get_has_completed("treasure_hunter") then
        actor:send(tostring(self.name) .. " says, 'Find some more treasures then we can talk.'")
        return _return_value
    end
    -- switch on cloakstage
    local place, hint
    do
        local _sw2 = string.lower(tostring(cloakstage or ""))
        if tonumber(_sw2) == 1 then
            local cloak = 58801
            local gem = 55585
            place = "A Storage Room"
            hint = "in the house on the hill."
        elseif tonumber(_sw2) == 2 then
            local cloak = 17307
            local gem = 55593
            place = "A Small Alcove"
            hint = "in the holy library."
        elseif tonumber(_sw2) == 3 then
            local cloak = 10308
            local gem = 55619
            place = "either Treasure Room"
            hint = "in the paladin fortress."
        elseif tonumber(_sw2) == 4 then
            local cloak = 12325
            local gem = 55659
            place = "The Treasure Room"
            hint = "beyond the Tower in the Wastes."
        elseif tonumber(_sw2) == 5 then
            local cloak = 43022
            local gem = 55663
            place = "Treasury"
            hint = "in the ghostly fortress."
        elseif tonumber(_sw2) == 6 then
            local cloak = 23810
            local gem = 55674
            place = "either Treasure Room with a chest"
            hint = "lost in the sands."
        elseif tonumber(_sw2) == 7 then
            local cloak = 51013
            local gem = 55714
            place = "Mesmeriz's Secret Treasure Room"
            hint = "hidden deep underground."
        elseif tonumber(_sw2) == 8 then
            local cloak = 58410
            local gem = 55740
            place = "Treasure Room"
            hint = "sunken in the swamp."
        elseif tonumber(_sw2) == 9 then
            local cloak = 52009
            local gem = 55741
            place = "Treasure Room"
            hint = "buried with an ancient king."
        end
    end
    local attack = cloakstage * 100
    if job1 or job2 or job3 or job4 then
        actor:send(tostring(self.name) .. " says, 'You've done the following:'")
        if job1 then
            actor:send("- attacked " .. tostring(attack) .. " times")
        end
        if job2 then
            actor:send("- found " .. "%get.obj_shortdesc[%cloak%]%")
        end
        if job3 then
            actor:send("- found " .. "%get.obj_shortdesc[%gem%]%")
        end
        if job4 then
            actor:send("- searched in " .. tostring(place))
        end
    end
    -- (empty send to actor)
    actor:send("You need to:")
    if job1 and job2 and job3 and job4 then
        actor:send("Just give me your old cloak.")
        return _return_value
    end
    if not job1 then
        local remaining = attack - (actor:get_quest_var("rogue_cloak:attack_counter") or 0)
        actor:send("- attack <b:yellow>" .. tostring(remaining) .. "</> more times while wearing your cloak.")
    end
    if not job2 then
        actor:send("- find <b:yellow>" .. "%get.obj_shortdesc[%cloak%]%</>")
    end
    if not job3 then
        actor:send("- find <b:yellow>" .. "%get.obj_shortdesc[%gem%]%</>")
    end
    if not job4 then
        actor:send("- <b:yellow>search</> in a place called \"<b:yellow>" .. tostring(place) .. "</>\".")
        actor:send("</>   It's <b:yellow>" .. tostring(hint) .. "</>")
    end
end$trig$, 'f84e2d369bfd56d339438c7887e433e6'),
  -- data/triggers/053/053_43_elemental_chaos_hakujo_progress_checker.lua
  (53, 43, $trig$-- Converted from DG Script #5343: Elemental Chaos Hakujo progress checker
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"progress"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
wait(0.2)
actor:send("<b:green>Elemental Chaos</>")
if actor:get_has_completed("elemental_chaos") then
    actor:send(tostring(self.name) .. " says, 'Chaos can never be truly destroyed, but you have helped restore Balance.'")
elseif actor:get_quest_stage("elemental_chaos") == 0 then
    actor:send(tostring(self.name) .. " says, 'You aren't walking the Way with me.'")
elseif actor:get_quest_var("elemental_chaos:bounty") == "dead" then
    actor:send(tostring(self.name) .. " says, 'Give me your current mission first.'")
elseif actor.level >= (actor:get_quest_stage("elemental_chaos") - 1) * 10 then
    if actor:get_quest_var("elemental_chaos:bounty") ~= "running" then
        actor:send(tostring(self.name) .. " says, 'You aren't doing anything for me right now.'")
    else
        -- switch on actor:get_quest_stage("elemental_chaos")
        do
            local _sw1 = string.lower(tostring(actor:get_quest_stage("elemental_chaos") or ""))
            if tonumber(_sw1) == 1 then
                actor:send(tostring(self.name) .. " says, 'You still have a mission to accomplish.  Investigate the news of an imp and dispatch it if you find one.'")
            elseif tonumber(_sw1) == 2 then
                actor:send(tostring(self.name) .. " says, 'You still have a mission to accomplish.  Silence the seductive song of the Leading Player.'")
            elseif tonumber(_sw1) == 3 then
                actor:send(tostring(self.name) .. " says, 'You still have a mission to accomplish.  Destroy the Chaos and the cult worshiping it!'")
            elseif tonumber(_sw1) == 4 then
                actor:send(tostring(self.name) .. " says, 'You still have a mission to accomplish.  Undertake the vision quest from the shaman in Three-Falls Canyon and defeat whatever awaits at the end.'")
            elseif tonumber(_sw1) == 5 then
                actor:send(tostring(self.name) .. " says, 'You still have a mission to accomplish.  Dispatch the Fangs of Yeenoghu.  Be sure to destroy all of them.'")
            elseif tonumber(_sw1) == 6 then
                actor:send(tostring(self.name) .. " says, 'You still have a mission to accomplish.  Extinguish the fire elemental lord who serves Krisenna.'")
            elseif tonumber(_sw1) == 7 then
                actor:send(tostring(self.name) .. " says, 'You still have a mission to accomplish.  Stop the acolytes in the Cathedral of Betrayal.'")
            elseif tonumber(_sw1) == 8 then
                actor:send(tostring(self.name) .. " says, 'You still have a mission to accomplish.  Destroy Cyprianum the Reaper in the heart of his maze.'")
            elseif tonumber(_sw1) == 9 then
                actor:send(tostring(self.name) .. " says, 'You still have a mission to accomplish.  Banish the Chaos Demon in Frost Valley.'")
            elseif tonumber(_sw1) == 10 then
                actor:send(tostring(self.name) .. " says, 'You still have a mission to accomplish.  Slay one of the Norhamen.'")
            end
        end
    end
else
    actor:send(tostring(self.name) .. " says, 'Give me more time to strategize how to bring Balance to Chaos.  Come back after you've gained some more experience.'")
end
if string.find(actor.class, "monk") then
    actor:send("</>")
    actor:send("</>")
    actor:send("<b:green>Enlightenment</>")
    local missionstage = actor:get_quest_stage("elemental_chaos")
    local visionstage = actor:get_quest_stage("monk_vision")
    local job1 = actor:get_quest_var("monk_vision:visiontask1")
    local job2 = actor:get_quest_var("monk_vision:visiontask2")
    local job3 = actor:get_quest_var("monk_vision:visiontask3")
    local job4 = actor:get_quest_var("monk_vision:visiontask4")
    local place
    if actor.level < 10 then
        actor:send(tostring(self.name) .. " says, 'You aren't ready for a vision yet.  Come back when you've grown a bit.'")
    elseif actor:get_has_completed("monk_vision") then
        actor:send(tostring(self.name) .. " says, 'You are already awakened to the Illusion of Reality!'")
    elseif actor.level < (visionstage * 10) then
        actor:send(tostring(self.name) .. " says, 'You aren't ready to start a journey to Enlightenment yet.  Come back when you've grown a bit.'")
    elseif visionstage == 0 then
        actor:send(tostring(self.name) .. " says, 'You must undertake a <b:cyan>[mission]</> in service of Balance first.'")
    elseif (visionstage >= missionstage) and not actor:get_has_completed("elemental_chaos") then
        actor:send(tostring(self.name) .. " says, 'You must walk further along the Way in service of Balance first.'")
    else
        -- switch on visionstage
        local hint
        do
            local _sw2 = string.lower(tostring(visionstage or ""))
            if tonumber(_sw2) == 1 then
                local book = 59006
                local gem = 55582
                local room = get_room("4328")
                place = room.name
                hint = "in a place to perform."
            elseif tonumber(_sw2) == 2 then
                local book = 18505
                local gem = 55591
                local room = get_room("58707")
                place = room.name
                hint = "near a sandy beach."
            elseif tonumber(_sw2) == 3 then
                local book = 8501
                local gem = 55623
                local room = get_room("18597")
                place = room.name
                hint = "in a cloistered library."
            elseif tonumber(_sw2) == 4 then
                local book = 12532
                local gem = 55655
                local room = get_room("58102")
                place = room.name
                hint = "on my home island."
            elseif tonumber(_sw2) == 5 then
                local book = 16209
                local gem = 55665
                local room = get_room("16057")
                place = room.name
                hint = "in the ghostly fortress."
            elseif tonumber(_sw2) == 6 then
                local book = 43013
                local gem = 55678
                local room = get_room("59054")
                place = room.name
                hint = "in the fortress of the zealous."
            elseif tonumber(_sw2) == 7 then
                local book = 53009
                local gem = 55710
                local room = get_room("49079")
                place = room.name
                hint = "off-shore of the island of great beasts."
            elseif tonumber(_sw2) == 8 then
                local book = 58415
                local gem = 55722
                local room = get_room("11820")
                place = room.name
                hint = "beyond the Blue-Fog Trail."
            elseif tonumber(_sw2) == 9 then
                local book = 58412
                local gem = 55741
                local room = get_room("52075")
                place = room.name
                hint = "in the shattered citadel of Templace."
            end
        end
        local attack = visionstage * 100
        if job1 or job2 or job3 or job4 then
            actor:send("You've done the following:")
            if job1 then
                actor:send("- attacked " .. tostring(attack) .. " times")
            end
            if job2 then
                actor:send("- found " .. "%get.obj_shortdesc[%gem%]%")
            end
            if job3 then
                actor:send("- found " .. "%get.obj_shortdesc[%book%]%")
            end
            if job4 then
                actor:send("- read in " .. tostring(place))
            end
            actor:send("</>")
        end
        actor:send("You need to:")
        if job1 and job2 and job3 and job4 then
            actor:send("Just give me your current vision mark.")
        else
            if not job1 then
                local remaining = attack - (actor:get_quest_var("monk_vision:attack_counter") or 0)
                actor:send("- attack <b:black>" .. tostring(remaining) .. "</> more times while wearing your vision mark.")
            end
            if not job4 then
                actor:send("- take <b:yellow>" .. "%get.obj_shortdesc[%gem%]%</> and <b:yellow>%get.obj_shortdesc[%book%]%</> and <b:yellow>read</> in a place called \"<b:yellow>%place%</>\".")
                actor:send("</>   It's <b:green>" .. tostring(hint) .. "</>")
            else
                if not job2 then
                    actor:send("- give me <b:yellow>" .. "%get.obj_shortdesc[%gem%]%</>")
                end
                if not job3 then
                    actor:send("- give me <b:yellow>" .. "%get.obj_shortdesc[%book%]%</>")
                end
            end
        end
    end
    if actor:get_quest_stage("monk_chants") > 0 then
        local chantstage = actor:get_quest_stage("monk_chants")
        -- switch on chantstage
        local chant, level, item, place
        do
            local _sw3 = string.lower(tostring(chantstage or ""))
            if tonumber(_sw3) == 1 then
                chant = "Tremors of Saint Augustine"
                level = 30
                item = "a book surrounded by trees and shadows"
                place = "in a place that is both natural and urban, serenely peaceful and profoundly sorrowful"
            elseif tonumber(_sw3) == 2 then
                chant = "Tempest of Saint Augustine"
                level = 40
                item = "a scroll, dedicated to this particular chant, guarded by a creature of the same elemental affinity"
                place = "at the marker on a southern mountain range."
            elseif tonumber(_sw3) == 3 then
                chant = "Blizzards of Saint Augustine"
                level = 50
                item = "a book held by a master who in turn is a servant of a beast of winter"
                place = "in a temple shrouded in mists"
            elseif tonumber(_sw3) == 4 then
                chant = "Aria of Dissonance"
                level = 60
                item = "a book on war, held by a banished war god"
                place = "in a dark cave before a blasphemous book, near an unholy fire"
            elseif tonumber(_sw3) == 5 then
                chant = "Apocalyptic Anthem"
                level = 75
                item = "a scroll where illusion is inscribed over and over held by a brother who thirsts for escape"
                place = "in a chapel of the walking dead"
            elseif tonumber(_sw3) == 6 then
                chant = "Fires of Saint Augustine"
                level = 80
                item = "a scroll of curses, carried by children of air in a floating fortress"
                place = "at an altar dedicated to fire's destructive forces"
            elseif tonumber(_sw3) == 7 then
                chant = "Seed of Destruction"
                level = 99
                item = "the eye of one caught in an eternal feud"
                place = "at an altar deep in the outer realms surrounded by those who's vengeance was never satisfied"
            end
        end
        actor:send("</>")
        actor:send("</>")
        actor:send("<b:green>Esoteric Chants</>")
        if actor.level >= level then
            if chantstage < (visionstage - 2) then
                actor:send(tostring(self.name) .. " says, 'You are seeking the chant " .. tostring(chant) .. ".'")
                actor:send("</>")
                actor:send(tostring(self.name) .. " says, 'You are looking for " .. tostring(item) .. ".")
                actor:send("Take it and <b:cyan>[meditate]</> " .. tostring(place) .. ".'")
            else
                actor:send(tostring(self.name) .. " says, 'You must first take another step towards <b:cyan>[enlightenment]</> before you can grasp more esoteric knowledge.'")
            end
        else
            actor:send(tostring(self.name) .. " says, 'You aren't ready to learn the next chant yet.'")
        end
    end
end$trig$, 'd84c4ee1c863e53890a1a3694add3c25'),
  -- data/triggers/053/053_55_hell_trident_receive.lua
  (53, 55, $trig$-- Converted from DG Script #5355: Hell Trident receive
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
local hellstage = actor:get_quest_stage("hell_trident")
-- switch on self.id
-- Black Priestess p2
local reward, phase, level, spell1, spell2, go
if (self.zone_id == 60 and self.id == 32) then
    reward = 39
    phase = 1
    level = 65
    spell1 = actor:get_has_completed("banish")
    spell2 = actor:get_has_completed("hellfire_brimstone")
    if not actor:get_quest_var("hell_trident:helltask6") then
        if actor:get_quest_stage("vilekka_stew") > 3 then
            actor:set_quest_var("hell_trident", "helltask6", 1)
        end
    end
    if (object.zone_id == 556 and object.id == 62) then
        go = "gem"
    elseif (object.zone_id == 23 and object.id == 34) then
        go = "trident"
    end
elseif (self.zone_id == 125 and self.id == 26) then
    reward = 40
    phase = 2
    level = 90
    spell1 = actor:get_has_completed("resurrection_quest")
    spell2 = actor:get_has_completed("hell_gate")
    if (object.zone_id == 557 and object.id == 39) then
        go = "gem"
    elseif (object.zone_id == 23 and object.id == 39) then
        go = "trident"
    end
end
-- adding in case it's not caught somewhere else
if hellstage == "phase" then
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
end
local refuse, reason
if actor:get_has_completed("hell_trident") then
    go = nil
    refuse = 1
    reason = "You already command the greatest power imaginable!"
elseif actor.level < level then
    go = nil
    refuse = 1
    reason = "You are not yet strong enough to handle more power."
elseif hellstage < phase then
    go = nil
    refuse = 1
    reason = "Your trident is not ready to upgrade yet."
elseif hellstage > phase then
    go = nil
    refuse = 1
    reason = "I've already done everything I can to help."
end
local refuse, reason
if go == "gem" then
    local gem_id = object.id
    local gem_count = actor:get_quest_var("hell_trident:gems") or 0
    if gem_count < 6 then
        wait(0.2)
        world.destroy(object.name)
        gem_count = gem_count + 1
        actor:set_quest_var("hell_trident", "gems", gem_count)
        actor:send(tostring(self.name) .. " says, 'Yes, this is perfect.'")
        wait(0.2)
        if gem_count == 1 then
            actor:send(tostring(self.name) .. " says, 'You have given me 1 of 6 " .. "%get.obj_pldesc[%gem_id%]%.'")
        else
            actor:send(tostring(self.name) .. " says, 'You have given me " .. tostring(gem_count) .. " of 6 " .. "%get.obj_pldesc[%gem_id%]%.'")
        end
        wait(0.2)
        if gem_count >= 6 then
            actor:set_quest_var("hell_trident", "helltask3", 1)
            local job1 = actor:get_quest_var("hell_trident:helltask1")
            local job2 = actor:get_quest_var("hell_trident:helltask2")
            local job3 = actor:get_quest_var("hell_trident:helltask3")
            local job4 = actor:get_quest_var("hell_trident:helltask4")
            local job5 = actor:get_quest_var("hell_trident:helltask5")
            local job6 = actor:get_quest_var("hell_trident:helltask6")
            if job1 and job2 and job3 and job4 and job5 and job6 then
                actor:send(tostring(self.name) .. " says, 'Now present the trident.'")
            else
                actor:send(tostring(self.name) .. " says, 'Complete your other sacrifices then return to me.'")
            end
        end
    else
        _return_value = true
        actor:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
        wait(0.2)
        actor:send(tostring(self.name) .. " says, 'You have already given me 6 " .. "%get.obj_pldesc[%gem_id%]%.'")
    end
elseif go == "trident" then
    local job1 = actor:get_quest_var("hell_trident:helltask1")
    local job2 = actor:get_quest_var("hell_trident:helltask2")
    local job3 = actor:get_quest_var("hell_trident:helltask3")
    local job4 = actor:get_quest_var("hell_trident:helltask4")
    local job5 = actor:get_quest_var("hell_trident:helltask5")
    local job6 = actor:get_quest_var("hell_trident:helltask6")
    if job1 and job2 and job3 and job4 and job5 and job6 then
        wait(0.2)
        world.destroy(object)
        if (self.zone_id == 125 and self.id == 26) then
            actor:send(tostring(self.name) .. " says, 'We are pleased.'")
            self:command("grin")
            wait(1)
            self.room:send(tostring(self.name) .. " turns and faces out into the endless void of his vast realm.")
            wait(1)
            self.room:send(tostring(self.name) .. " growls, 'Ir ya roza aem ya iz ednuyt...'")
            wait(2)
            self.room:send("The inner <b:blue>ire</> of the " .. get_obj_noadesc(23, 39) .. " ignites and <red>b<blue>urn</><red>s</>!")
            wait(2)
            self.room:send(tostring(self.name) .. " roars, 'Liy ya gaoh yaezk'aqa, ir ya aehg mol'tiaer I kiwa yiz laodaer zes mina...'")
            wait(2)
            self.room:send(tostring(self.name) .. " erupts in glorious <red>f<blue>l<yellow>a<red>m</><red>e</>!")
            wait(2)
            self.room:send("The <red>f<b:yellow>i<red>r</><red>es<blue>t<yellow>o<red>r</><red>m</> forms a vortex about the " .. get_obj_noadesc(23, 39) .. ", like an explosion in reverse.")
            wait(1)
            self.room:send("The trident <b:magenta>t</><magenta>w<b:black>i</><magenta>s<blue>ts</> and contorts in the wild <red>f<b:yellow>i<red>r</><red>e</>!")
            wait(3)
            self.room:send("The fire subsides, leaving a <b:black>midnight-black</> weapon pulsing with dark radiance.")
            wait(2)
            actor:send(tostring(self.name) .. " says, 'Our bond is forged.'")
        else
            actor:send(tostring(self.name) .. " says, 'The infernal ones are pleased.'")
            wait(1)
            self.room:send(tostring(self.name) .. "'s neck goes limp as her eyes roll back into her head.")
            wait(2)
            self.room:send(tostring(self.name) .. " begins to murmur... 'Hin tel'quiet nehel -nal rillis fis...'")
            wait(3)
            self.room:send("Brilliant <blue>b<b:black>lac</><blue>k fire seeps out of " .. get_obj_noadesc(23, 34) .. " and spreads across its surface.")
            wait(2)
            self.room:send(tostring(self.name) .. " babbles in an alien voice, 'Aul adoe shunti mor ik mor...'")
            wait(2)
            self.room:send("<red>Scarlet</> <blue>fl<blue>ames</> ignite in " .. tostring(self.name) .. "'s hands, pulsing in rhythm with her speech.")
            wait(2)
            self.room:send(tostring(self.name) .. " utters, 'Slidc ya qnoes oynaezz ya khozz qaed...' as she holds her hand over the " .. get_obj_noadesc(23, 34) .. ".")
            wait(2)
            self.room:send("The flames burn away the trident, leaving only a blazing tendril.")
            wait(2)
            self.room:send(tostring(self.name) .. " grabs the burning spire and commands, 'Le yaezzoth esaeu qae qota maenz!'")
            self.room:send("The wild flames contort as they cool into a new three-pointed form.")
            wait(2)
            if actor.level >= 90 then
                actor:send(tostring(self.name) .. " says, 'The Demon Lord Krisenna is known to traffic with mortals from time to time.  Impress him and perhaps he will grant you a boon.'")
            else
                actor:send(tostring(self.name) .. " says, 'Continue to prove your value to Hell and perhaps a Demon Lord might be willing to grant your their patronage.'")
                actor:send("<red>You must be level " .. tostring(level) .. " or greater to continue this quest.</>")
            end
        end
        self.room:spawn_object(23, reward)
        self:command("give trident " .. tostring(actor))
        local expcap = level
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
        actor:send("<b:yellow>You gain experience!</>")
        local setexp = (expmod * 10)
        local loop = 0
        while loop < 10 do
            actor:award_exp(setexp)
            loop = loop + 1
        end
        local number = 1
        while number < 7 do
            actor:set_quest_var("hell_trident", "helltask%number%", 0)
            number = number + 1
        end
        actor:set_quest_var("hell_trident", "gems", 0)
        actor:set_quest_var("hell_trident", "greet", 0)
        if actor:get_quest_stage("hell_trident") == 1 then
            actor:advance_quest("hell_trident")
        else
            actor:complete_quest("hell_trident")
        end
    else
        refuse = 1
        reason = "You have to complete all your other offerings before you give me your trident."
    end
end
if refuse then
    _return_value = true
    actor:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
    wait(0.2)
    actor:send(tostring(self.name) .. " says, '" .. tostring(reason) .. "'")
end
return _return_value$trig$, '099fdb8d63df93ce6b4041c004c6e0d3'),
  -- data/triggers/053/053_56_hell_trident_death.lua
  (53, 56, $trig$-- Converted from DG Script #5356: Hell Trident death
-- Original: MOB trigger, flags: DEATH, probability: 100%
-- switch on self.id
local word
if (self.zone_id == 40 and self.id == 1) or (self.zone_id == 40 and self.id == 5) or (self.zone_id == 40 and self.id == 10) or (self.zone_id == 40 and self.id == 15) or (self.zone_id == 123 and self.id == 7) then
    local phase = 1
    word = "angels"
elseif (self.zone_id == 238 and self.id == 10) or (self.zone_id == 238 and self.id == 11) or (self.zone_id == 238 and self.id == 12) then
    local phase = 2
    word = "celestials"
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
        if person:get_quest_stage("hell_trident") == "phase" then
            local kills = (person:get_quest_var("hell_trident:celestials") or 0) + 1
            person:set_quest_var("hell_trident", "celestials", kills)
            if kills >= 6 then
                person:set_quest_var("hell_trident", "helltask2", 1)
                person:set_quest_var("hell_trident", "celestials", 0)
                person:send("<b:red>You have sufficiently bathed in the blood of the " .. tostring(word) .. "!</>")
            end
        end
    elseif person and person.is_player then
        i = i + 1
    end
    a = a + 1
end$trig$, 'c3dd790dc1ab6babb0d13fe534ba9de6'),
  -- data/triggers/053/053_57_hell_trident_progress_tracker.lua
  (53, 57, $trig$-- Converted from DG Script #5357: Hell Trident progress tracker
-- Original: MOB trigger, flags: SPEECH, probability: 0%

-- Speech phrase: weapon progress (DG num_arg 0 = the speech contains the whole phrase, on word boundaries)
local speech_padded = " " .. string.lower(speech) .. " "
if not string.find(speech_padded, "[%s%p]weapon progress[%s%p]") then
    return true  -- Not the phrase
end
wait(0.2)
if string.find(actor.class, "diabolist") then
    local level, response
    if actor:get_quest_stage("hell_trident") > 0 then
        local hellstage = actor:get_quest_stage("hell_trident")
        if hellstage == 1 then
            level = 65
        elseif hellstage == 2 then
            level = 90
        end
        -- switch on self.id
        do
            if (self.zone_id == 23 and self.id == 11) then
                -- switch on hellstage
                do
                    local _sw2 = string.lower(tostring(hellstage or ""))
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
                local task6do = "<b:yellow>Assist the High Priestess of Lolth in hunting down and destroying the heretics of her Goddess.</>"
            elseif (self.zone_id == 125 and self.id == 26) then
                local step = 2
                local gem = 55739
                local pl_word = "ghaeles, solars, or seraphs"
                local word = "ghaele, solar, or seraph"
                local spell1 = "Resurrect"
                local quest1 = actor:get_has_completed("resurrection_quest")
                local spell2 = "Hell Gate"
                local quest2 = actor:get_has_completed("hell_gate")
                local task6 = "Defeated the Undead Prince"
                local task6do = "find one long-buried and branded an infidel.  <b:yellow>Finish his undying duel for him</> as a sacrifice of honor."
            end
        end
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
                if (actor:get_quest_var("hell_trident:greet") or 0) == 0 then
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
                            local remaining = 666 - (actor:get_quest_var("hell_trident:attack_counter") or 0)
                            if remaining > 1 then
                                actor:send("- <b:yellow>attack " .. tostring(remaining) .. " more times with your trident</>")
                            else
                                actor:send("- <b:yellow>attack " .. tostring(remaining) .. " more time with your trident</>")
                            end
                        end
                        if not job2 then
                            local kills = 6 - (actor:get_quest_var("hell_trident:celestials") or 0)
                            if kills > 1 then
                                actor:send("- <b:yellow>slay " .. tostring(kills) .. " more " .. tostring(pl_word) .. "</>")
                            else
                                actor:send("- <b:yellow>slay " .. tostring(kills) .. " more " .. tostring(word) .. "</>")
                            end
                        end
                        if not job3 then
                            local gems = 6 - (actor:get_quest_var("hell_trident:gems") or 0)
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
end$trig$, '937083aa86aee7be43d700e9e7daf97b'),
  -- data/triggers/055/055_03_3bl_turn_in.lua
  (55, 3, $trig$-- Converted from DG Script #5503: 3bl_turn_in
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
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
    -- pertinent object definitions for this faction
    -- trophies
    local id_3el_skull = 5504
    local id_3el_ring = 5506
    local id_3el_badge = 5508
    local id_3el_token = 5510
    local id_3el_insignia = 5512
    local id_3el_wand = 5514
    local id_3el_symbol = 5516
    -- gems for this faction
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
    local id_3bl_cap = 17
    local id_3bl_neck = 19
    local id_3bl_arm = 21
    local id_3bl_wrist = 23
    local id_3bl_gloves = 25
    local id_3bl_jerkin = 27
    local id_3bl_belt = 29
    local id_3bl_legs = 31
    local id_3bl_boots = 33
    local id_3bl_mask = 35
    local id_3bl_robe = 37
    local id_3bl_symbol = 15
    local id_3bl_staff = 39
    local id_3bl_ssword = 40
    local id_3bl_whammer = 41
    local id_3bl_flail = 42
    local id_3bl_shiv = 43
    local id_3bl_lsword = 44
    local id_3bl_smace = 45
    local id_3bl_light = 53
    local id_3bl_food = 55
    local id_3bl_drink = 57
    -- 
    -- attempt to reinitialize slutty dg variables to '' (nothing)
    -- so this switch will work.
    -- 
    is_gem = nil
    exp_multiplier = nil
    id_trophy = nil
    faction_multiplier = nil
    id_reward = nil
    faction_required = nil
    -- 
    -- These case set the variables for the quests.
    -- The cases below switch on object.id (the local id of the
    -- proto handed to the NPC by the player).
    -- 
    -- switch on object.id
    local is_gem, exp_multiplier, id_reward, faction_required, faction_multiplier
    if object.id == "%id_gem_3bl_cap%" then
        is_gem = 1
        exp_multiplier = 10
        id_reward = id_3bl_cap
        faction_required = 20
        faction_multiplier = 1
    elseif object.id == "%id_gem_3bl_food%" then
        is_gem = 1
        exp_multiplier = 10
        id_reward = id_3bl_food
        faction_required = 20
        faction_multiplier = 1
    elseif object.id == "%id_gem_3bl_drink%" then
        is_gem = 1
        exp_multiplier = 10
        id_reward = id_3bl_drink
        faction_required = 20
        faction_multiplier = 1
    elseif object.id == "%id_gem_3bl_ssword%" then
        is_gem = 1
        exp_multiplier = 10
        id_reward = id_3bl_ssword
        faction_required = 20
        faction_multiplier = 1
    elseif object.id == "%id_gem_3bl_neck%" then
        is_gem = 1
        exp_multiplier = 12
        id_reward = id_3bl_neck
        faction_required = 40
        faction_multiplier = 1
    elseif object.id == "%id_gem_3bl_staff%" then
        is_gem = 1
        exp_multiplier = 12
        id_reward = id_3bl_staff
        faction_required = 40
        faction_multiplier = 1
    elseif object.id == "%id_gem_3bl_arm%" then
        is_gem = 1
        exp_multiplier = 14
        id_reward = id_3bl_arm
        faction_required = 55
        faction_multiplier = 1
    elseif object.id == "%id_gem_3bl_whammer%" then
        is_gem = 1
        exp_multiplier = 14
        id_reward = id_3bl_whammer
        faction_required = 55
        faction_multiplier = 1
    elseif object.id == "%id_gem_3bl_wrist%" then
        is_gem = 1
        exp_multiplier = 16
        id_reward = id_3bl_wrist
        faction_required = 70
        faction_multiplier = 1
    elseif object.id == "%id_gem_3bl_flail%" then
        is_gem = 1
        exp_multiplier = 16
        id_reward = id_3bl_flail
        faction_required = 70
        faction_multiplier = 1
    elseif object.id == "%id_gem_3bl_gloves%" then
        is_gem = 1
        exp_multiplier = 18
        id_reward = id_3bl_gloves
        faction_required = 85
        faction_multiplier = 1
    elseif object.id == "%id_gem_3bl_symbol%" then
        is_gem = 1
        exp_multiplier = 18
        id_reward = id_3bl_symbol
        faction_required = 85
        faction_multiplier = 1
    elseif object.id == "%id_gem_3bl_belt%" then
        is_gem = 1
        exp_multiplier = 20
        id_reward = id_3bl_belt
        faction_required = 100
        faction_multiplier = 1
    elseif object.id == "%id_gem_3bl_shiv%" then
        is_gem = 1
        exp_multiplier = 20
        id_reward = id_3bl_shiv
        faction_required = 100
        faction_multiplier = 1
    elseif object.id == "%id_gem_3bl_boots%" then
        is_gem = 1
        exp_multiplier = 22
        id_reward = id_3bl_boots
        faction_required = 115
        faction_multiplier = 2
    elseif object.id == "%id_gem_3bl_lsword%" then
        is_gem = 1
        exp_multiplier = 22
        id_reward = id_3bl_lsword
        faction_required = 115
        faction_multiplier = 2
    elseif object.id == "%id_gem_3bl_legs%" then
        is_gem = 1
        exp_multiplier = 24
        id_reward = id_3bl_legs
        faction_required = 130
        faction_multiplier = 2
    elseif object.id == "%id_gem_3bl_robe%" then
        is_gem = 1
        exp_multiplier = 26
        id_reward = id_3bl_robe
        faction_required = 145
        faction_multiplier = 2
    elseif object.id == "%id_gem_3bl_jerkin%" then
        is_gem = 1
        exp_multiplier = 26
        id_reward = id_3bl_jerkin
        faction_required = 145
        faction_multiplier = 2
    elseif object.id == "%id_gem_3bl_light%" then
        is_gem = 1
        exp_multiplier = 26
        id_reward = id_3bl_light
        faction_required = 85
        faction_multiplier = 2
    elseif object.id == "%id_gem_3bl_mask%" then
        is_gem = 1
        exp_multiplier = 28
        id_reward = id_3bl_mask
        faction_required = 160
        faction_multiplier = 3
    elseif object.id == "%id_gem_3bl_smace%" then
        is_gem = 1
        exp_multiplier = 28
        id_reward = id_3bl_smace
        faction_required = 160
        faction_multiplier = 3
    elseif object.id == "%id_3el_skull%" then
        exp_multiplier = 2
        local id_trophy = id_3el_skull
        faction_multiplier = 1
    elseif object.id == "%id_3el_ring%" then
        exp_multiplier = 2
        local id_trophy = id_3el_ring
        faction_multiplier = 1
    elseif object.id == "%id_3el_badge%" then
        exp_multiplier = 2
        local id_trophy = id_3el_badge
        faction_multiplier = 1
    elseif object.id == "%id_3el_token%" then
        exp_multiplier = 2
        local id_trophy = id_3el_token
        faction_multiplier = 2
    elseif object.id == "%id_3el_insignia%" then
        exp_multiplier = 2
        local id_trophy = id_3el_insignia
        faction_multiplier = 2
    elseif object.id == "%id_3el_wand%" then
        exp_multiplier = 2
        local id_trophy = id_3el_wand
        faction_multiplier = 2
    elseif object.id == "%id_3el_symbol%" then
        exp_multiplier = 2
        local id_trophy = id_3el_symbol
        faction_multiplier = 3
    else
        _return_value = true
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
        if actor:get_quest_var("black_legion:id_trophy_trophies") then
        else
            actor:set_quest_var("black_legion", "%id_trophy%_trophies", 0)
        end
        local trophies = actor:get_quest_var("black_legion:id_trophy_trophies")
        actor:set_quest_var("black_legion", "%id_trophy%_trophies", trophies)
        -- The highest faction a player can gain from interacting with the 3rd front creatures will
        -- be 200.  For this section the trophy turn in will reply on this and other checks.
        if (actor:get_quest_var("black_legion:bl_faction") or 0) < 200 then
            local trophies = (actor:get_quest_var("black_legion:id_trophy_trophies") or 0) + 1
            actor:set_quest_var("black_legion", "%id_trophy%_trophies", trophies)
            wait(0.2)
            actor:send(tostring(self.name) .. " tells you, 'Hrm, yes.. you have been out")
            actor:send("</>fighting the Eldorian Guard.  I see from my records you have now given me")
            actor:send("</><b:yellow>" .. tostring(trophies) .. "</> <b:white>" .. "%get.obj_shortdesc[%id_trophy%]%</>.'")
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
                local trophies = (actor:get_quest_var("black_legion:id_trophy_trophies") or 0) + 1
                actor:set_quest_var("black_legion", "%id_trophy%_trophies", trophies)
            else
                _return_value = true
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
        if actor:get_quest_var("black_legion:id_reward_reward") then
        else
            actor:set_quest_var("black_legion", "%id_reward%_reward", 0)
        end
        local rewards = actor:get_quest_var("black_legion:id_reward_reward")
        actor:set_quest_var("black_legion", "%id_reward%_reward", rewards)
        if actor.alignment >= 151 then
            _return_value = true
            wait(0.2)
            actor:send(tostring(self.name) .. " tells you, 'You aren't quite evil enough for")
            actor:send("</>these rewards.'")
            return _return_value
        end
        if (actor:get_quest_var("black_legion:bl_faction") or 0) >= faction_required then
            local rewards = (actor:get_quest_var("black_legion:id_reward_reward") or 0) + 1
            actor:set_quest_var("black_legion", "%id_reward%_reward", rewards)
            wait(0.2)
            actor:send(tostring(self.name) .. " tells you, 'Ah yes, the Legion thanks you for")
            actor:send("</>your efforts.  Take this to aid you in your battles.'")
            wait(0.1)
            self.room:spawn_object(55, id_reward)
            wait(0.1)
            if (actor:get_quest_var("black_legion:id_reward_reward") or 0) == 1 then
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
            _return_value = true
            wait(0.2)
            actor:send(tostring(self.name) .. " tells you, 'You aren't quite allied enough")
            actor:send("</>with our cause to earn that reward.'")
            return _return_value
        end
        -- end of if_gem section
    end
else
    -- Alignment not low enough or hasn't started the quest yet.
    _return_value = true
    wait(0.2)
    actor:send(tostring(self.name) .. " tells you, 'You aren't quite allied enough with")
    actor:send("</>our cause to earn our rewards.  You need a lower alignment or to start these")
    actor:send("</>quests by saying <b:white>[yes]</> or <b:white>[quest]</> or <b:white>[hello]</>.'")
end
return _return_value$trig$, 'd8b5c608f98bbccf2ebb9ea034dbde06'),
  -- data/triggers/055/055_07_3eg_turn_in.lua
  (55, 7, $trig$-- Converted from DG Script #5507: 3eg_turn_in
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
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
    -- pertinent object definitions for this faction
    -- trophies
    local id_3bl_skull = 5503
    local id_3bl_ring = 5505
    local id_3bl_badge = 5507
    local id_3bl_token = 5509
    local id_3bl_insignia = 5511
    local id_3bl_wand = 5513
    local id_3bl_symbol = 5515
    -- gems for this faction
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
    local id_3eg_cap = 18
    local id_3eg_neck = 20
    local id_3eg_arm = 22
    local id_3eg_wrist = 24
    local id_3eg_gloves = 26
    local id_3eg_jerkin = 28
    local id_3eg_belt = 30
    local id_3eg_legs = 32
    local id_3eg_boots = 34
    local id_3eg_mask = 36
    local id_3eg_robe = 38
    local id_3eg_symbol = 16
    local id_3eg_staff = 46
    local id_3eg_ssword = 47
    local id_3eg_whammer = 48
    local id_3eg_flail = 49
    local id_3eg_shiv = 50
    local id_3eg_lsword = 51
    local id_3eg_smace = 52
    local id_3eg_light = 54
    local id_3eg_food = 56
    local id_3eg_drink = 58
    -- 
    -- attempt to reinitialize slutty dg variables to '' (nothing)
    -- so this switch will work.
    -- 
    is_gem = nil
    exp_multiplier = nil
    id_trophy = nil
    faction_multiplier = nil
    id_reward = nil
    faction_required = nil
    -- 
    -- These cases set the variables for the quests.
    -- The cases below switch on object.id (the local id of the
    -- proto handed to the NPC by the player).
    -- 
    -- switch on object.id
    local is_gem, exp_multiplier, id_reward, faction_required, faction_multiplier
    if object.id == "%id_gem_3eg_cap%" then
        is_gem = 1
        exp_multiplier = 10
        id_reward = id_3eg_cap
        faction_required = 20
        faction_multiplier = 1
    elseif object.id == "%id_gem_3eg_food%" then
        is_gem = 1
        exp_multiplier = 10
        id_reward = id_3eg_food
        faction_required = 20
        faction_multiplier = 1
    elseif object.id == "%id_gem_3eg_drink%" then
        is_gem = 1
        exp_multiplier = 10
        id_reward = id_3eg_drink
        faction_required = 20
        faction_multiplier = 1
    elseif object.id == "%id_gem_3eg_ssword%" then
        is_gem = 1
        exp_multiplier = 10
        id_reward = id_3eg_ssword
        faction_required = 20
        faction_multiplier = 1
    elseif object.id == "%id_gem_3eg_neck%" then
        is_gem = 1
        exp_multiplier = 12
        id_reward = id_3eg_neck
        faction_required = 40
        faction_multiplier = 1
    elseif object.id == "%id_gem_3eg_staff%" then
        is_gem = 1
        exp_multiplier = 12
        id_reward = id_3eg_staff
        faction_required = 40
        faction_multiplier = 1
    elseif object.id == "%id_gem_3eg_arm%" then
        is_gem = 1
        exp_multiplier = 14
        id_reward = id_3eg_arm
        faction_required = 55
        faction_multiplier = 1
    elseif object.id == "%id_gem_3eg_whammer%" then
        is_gem = 1
        exp_multiplier = 14
        id_reward = id_3eg_whammer
        faction_required = 55
        faction_multiplier = 1
    elseif object.id == "%id_gem_3eg_wrist%" then
        is_gem = 1
        exp_multiplier = 16
        id_reward = id_3eg_wrist
        faction_required = 70
        faction_multiplier = 1
    elseif object.id == "%id_gem_3eg_flail%" then
        is_gem = 1
        exp_multiplier = 16
        id_reward = id_3eg_flail
        faction_required = 70
        faction_multiplier = 1
    elseif object.id == "%id_gem_3eg_gloves%" then
        is_gem = 1
        exp_multiplier = 18
        id_reward = id_3eg_gloves
        faction_required = 85
        faction_multiplier = 1
    elseif object.id == "%id_gem_3eg_symbol%" then
        is_gem = 1
        exp_multiplier = 18
        id_reward = id_3eg_symbol
        faction_required = 85
        faction_multiplier = 1
    elseif object.id == "%id_gem_3eg_belt%" then
        is_gem = 1
        exp_multiplier = 20
        id_reward = id_3eg_belt
        faction_required = 100
        faction_multiplier = 1
    elseif object.id == "%id_gem_3eg_shiv%" then
        is_gem = 1
        exp_multiplier = 20
        id_reward = id_3eg_shiv
        faction_required = 100
        faction_multiplier = 1
    elseif object.id == "%id_gem_3eg_boots%" then
        is_gem = 1
        exp_multiplier = 22
        id_reward = id_3eg_boots
        faction_required = 115
        faction_multiplier = 2
    elseif object.id == "%id_gem_3eg_lsword%" then
        is_gem = 1
        exp_multiplier = 22
        id_reward = id_3eg_lsword
        faction_required = 115
        faction_multiplier = 2
    elseif object.id == "%id_gem_3eg_legs%" then
        is_gem = 1
        exp_multiplier = 24
        id_reward = id_3eg_legs
        faction_required = 130
        faction_multiplier = 2
    elseif object.id == "%id_gem_3eg_robe%" then
        is_gem = 1
        exp_multiplier = 26
        id_reward = id_3eg_robe
        faction_required = 145
        faction_multiplier = 2
    elseif object.id == "%id_gem_3eg_jerkin%" then
        is_gem = 1
        exp_multiplier = 26
        id_reward = id_3eg_jerkin
        faction_required = 145
        faction_multiplier = 2
    elseif object.id == "%id_gem_3eg_light%" then
        is_gem = 1
        exp_multiplier = 26
        id_reward = id_3eg_light
        faction_required = 85
        faction_multiplier = 2
    elseif object.id == "%id_gem_3eg_mask%" then
        is_gem = 1
        exp_multiplier = 28
        id_reward = id_3eg_mask
        faction_required = 160
        faction_multiplier = 3
    elseif object.id == "%id_gem_3eg_smace%" then
        is_gem = 1
        exp_multiplier = 28
        id_reward = id_3eg_smace
        faction_required = 160
        faction_multiplier = 3
    elseif object.id == "%id_3bl_skull%" then
        exp_multiplier = 2
        local id_trophy = id_3bl_skull
        faction_multiplier = 1
    elseif object.id == "%id_3bl_ring%" then
        exp_multiplier = 2
        local id_trophy = id_3bl_ring
        faction_multiplier = 1
    elseif object.id == "%id_3bl_badge%" then
        exp_multiplier = 2
        local id_trophy = id_3bl_badge
        faction_multiplier = 1
    elseif object.id == "%id_3bl_token%" then
        exp_multiplier = 2
        local id_trophy = id_3bl_token
        faction_multiplier = 2
    elseif object.id == "%id_3bl_insignia%" then
        exp_multiplier = 2
        local id_trophy = id_3bl_insignia
        faction_multiplier = 2
    elseif object.id == "%id_3bl_wand%" then
        exp_multiplier = 2
        local id_trophy = id_3bl_wand
        faction_multiplier = 2
    elseif object.id == "%id_3bl_symbol%" then
        exp_multiplier = 2
        local id_trophy = id_3bl_symbol
        faction_multiplier = 3
    else
        _return_value = true
        wait(0.1)
        self:command("eye " .. tostring(actor.name))
        actor:send(tostring(self.name) .. " tells you, 'I am not interested in")
        actor:send("</>this from you.'")
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
        if actor:get_quest_var("black_legion:id_trophy_trophies") then
        else
            actor:set_quest_var("black_legion", "%id_trophy%_trophies", 0)
        end
        local trophies = actor:get_quest_var("black_legion:id_trophy_trophies")
        actor:set_quest_var("black_legion", "%id_trophy%_trophies", trophies)
        -- The highest faction a player can gain from interacting with the 3rd front creatures will
        -- be 200.  For this section the trophy turn in will reply on this and other checks.
        if (actor:get_quest_var("black_legion:eg_faction") or 0) < 200 then
            local trophies = (actor:get_quest_var("black_legion:id_trophy_trophies") or 0) + 1
            actor:set_quest_var("black_legion", "%id_trophy%_trophies", trophies)
            wait(0.2)
            actor:send(tostring(self.name) .. " tells you, 'Hrm, yes... you have")
            actor:send("</>been out fighting the Black Legion.  I see from my records you have now given")
            actor:send("</>me <b:yellow>" .. tostring(trophies) .. " <white>" .. "%get.obj_shortdesc[%id_trophy%]%</>.'")
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
                local trophies = (actor:get_quest_var("black_legion:id_trophy_trophies") or 0) + 1
                actor:set_quest_var("black_legion", "%id_trophy%_trophies", trophies)
            else
                _return_value = true
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
        if actor:get_quest_var("black_legion:id_reward_reward") then
        else
            actor:set_quest_var("black_legion", "%id_reward%_reward", 0)
        end
        local rewards = actor:get_quest_var("black_legion:id_reward_reward")
        actor:set_quest_var("black_legion", "%id_reward%_reward", rewards)
        if actor.alignment <= -151 then
            _return_value = true
            wait(0.2)
            actor:send(tostring(self.name) .. " tells you, 'You aren't quite good")
            actor:send("</>enough for these rewards.'")
            return _return_value
        end
        if (actor:get_quest_var("black_legion:eg_faction") or 0) >= faction_required then
            local rewards = (actor:get_quest_var("black_legion:id_reward_reward") or 0) + 1
            actor:set_quest_var("black_legion", "%id_reward%_reward", rewards)
            wait(0.2)
            actor:send(tostring(self.name) .. " tells you, 'Ah yes, the Guard")
            actor:send("</>thanks you for your efforts.  Take this to aid you in your battles.'")
            wait(0.1)
            self.room:spawn_object(55, id_reward)
            wait(0.1)
            if (actor:get_quest_var("black_legion:id_reward_reward") or 0) == 1 then
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
            _return_value = true
            wait(0.2)
            actor:send(tostring(self.name) .. " tells you, 'You aren't quite allied")
            actor:send("</>enough with our cause to earn that reward.'")
            return _return_value
        end
        -- end of if_gem section
    end
else
    -- Alignment not high enough or hasn't started the quest yet.
    _return_value = true
    wait(0.2)
    actor:send(tostring(self.name) .. " tells you, 'You aren't quite allied")
    actor:send("</>enough with our cause to earn our rewards.  You need a higher alignment or to")
    actor:send("</>start these quests by saying <b:white>[yes]</> or <b:white>[quest]</> or <b:white>[hello]</>.'")
end
return _return_value$trig$, '7b52fa1546d458f4a8f197f48362dd1a'),
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
wait(0.2)
actor:send("<b:green>Contract Killers</>")
if actor:get_has_completed("bounty_hunt") then
    actor:send(tostring(self.name) .. " says, 'You know, I'm fresh out of work for you.  Good luck!'")
elseif actor:get_quest_stage("bounty_hunt") == 0 then
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
if actor.class == "assassin" then
    actor:send("</>")
    actor:send("<b:green>Deadly Promotion</>")
    local bountystage = actor:get_quest_stage("bounty_hunt")
    local maskstage = actor:get_quest_stage("assassin_mask")
    local job1 = actor:get_quest_var("assassin_mask:masktask1")
    local job2 = actor:get_quest_var("assassin_mask:masktask2")
    local job3 = actor:get_quest_var("assassin_mask:masktask3")
    local job4 = actor:get_quest_var("assassin_mask:masktask4")
    wait(0.2)
    if actor.class ~= "assassin" then
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
        local remaining = attack - (actor:get_quest_var("assassin_mask:attack_counter") or 0)
        actor:send("- attack <b:black>" .. tostring(remaining) .. "</> more times while wearing your mask.")
    end
    if not job2 then
        -- TODO(parity): DG %get.obj_shortdesc[%mask%]% — needs (zone, local) split.
        actor:send("- find <b:black>object id " .. tostring(mask) .. "</>")
    end
    if not job3 then
        -- TODO(parity): DG %get.obj_shortdesc[%gem%]% — needs (zone, local) split.
        actor:send("- find <b:black>object id " .. tostring(gem) .. "</>")
    end
    if not job4 then
        actor:send("- <b:black>hide in a place called \"<b:black>" .. tostring(place) .. "</>\".")
        actor:send("</>   It's <b:black>" .. tostring(hint) .. "</>")
    end
end$trig$, 'a4b0d12fc12d6a4647770f1230e8ac94'),
  -- data/triggers/062/062_07_supernova_clue_rooms.lua
  (62, 7, $trig$-- TODO(parity): The original DG had `supernova:stepstage` as a string-valued
-- key (i.e. literal "stepstage"); we read step3/step4/step5 explicitly here
-- since each stage uses its own step var. Verify against DG #6207 source if
-- the legacy semantics differ.

for _, person in ipairs(self.room.people) do
    local stage = person:get_quest_stage("supernova")
    if not (person:has_item(489, 17) or person:has_equipped(489, 17)) then
        -- nothing
    elseif stage == 3 and person.room == get_room(math.floor((person:get_quest_var("supernova:step3") or 0) / 100), (person:get_quest_var("supernova:step3") or 0) % 100) then
        self.room:spawn_object(62, 29)
        self.room:send("<magenta>" .. tostring(objects.template(489, 17).name) .. " begins emitting an eerie purple light!</>")
        self.room:send_except(person, tostring(person.name) .. " has found a clue to Phayla's whereabouts!")
        person:send("You have found a clue to Phayla's whereabouts!")
        person:advance_quest("supernova")
    elseif stage == 4 and person.room == get_room(math.floor((person:get_quest_var("supernova:step4") or 0) / 100), (person:get_quest_var("supernova:step4") or 0) % 100) then
        self.room:spawn_object(62, 32)
        self.room:send("<magenta>" .. tostring(objects.template(489, 17).name) .. " begins emitting an eerie purple light!</>")
        self.room:send_except(person, tostring(person.name) .. " has found a clue to Phayla's whereabouts!")
        person:send("You have found a clue to Phayla's whereabouts!")
        person:advance_quest("supernova")
    elseif stage == 5 and person.room == get_room(math.floor((person:get_quest_var("supernova:step5") or 0) / 100), (person:get_quest_var("supernova:step5") or 0) % 100) then
        self.room:spawn_object(62, 33)
        self.room:send("<magenta>" .. tostring(objects.template(489, 17).name) .. " begins emitting an eerie purple light!</>")
        self.room:send_except(person, tostring(person.name) .. " has found a clue to Phayla's whereabouts!")
        person:send("You have found a clue to Phayla's whereabouts!")
        person:advance_quest("supernova")
    elseif stage == 6 and person.room == get_room(math.floor((person:get_quest_var("supernova:step6") or 0) / 100), (person:get_quest_var("supernova:step6") or 0) % 100) then
        self.room:spawn_object(62, 30)
        self.room:send("<magenta>Eerie purple light from " .. tostring(objects.template(489, 17).name) .. " reveals a gateway to another dimension!</>")
        person:advance_quest("supernova")
    end
end$trig$, '4f74bd523283545552330320e160f3c9'),
  -- data/triggers/062/062_92_gem_exchange_greet.lua
  (62, 92, $trig$wait(0.2)
if actor.is_player then
    local item = actor:get_quest_var("gem_exchange:gem_id")
    if actor:get_quest_stage("gem_exchange") == 1 then
        self:say("Welcome back!")
        self:command("bow " .. tostring(actor))
        wait(2)
        if (item or 0) == 0 or item == nil then
            actor:send(tostring(self.name) .. " says, 'Tell me, what gemstone are you interested in trading for")
            actor:send("</>today?'")
        else
            -- item is the legacy 5-digit vnum (zone*100 + id) of the requested gem
            local item_name = tostring(objects.template(math.floor((item or 0) / 100), (item or 0) % 100).name)
            actor:send(tostring(self.name) .. " says, 'Are you still looking for " .. item_name .. "?'")
        end
    else
        self:say("Greetings!  Welcome to the Soltan Gem Exchange!")
        wait(1)
        self.room:send(tostring(self.name) .. " says, 'We specialize in exchanging your less useful gemstones")
        self.room:send("</>for ones you might need.  Our reserves are fully stocked.  All you have to do")
        self.room:send("</>is tell us what kind of gem you're looking for.'")
        wait(4)
        self:say("So what can I help you find today?")
    end
end$trig$, '0241662157489ab656583eca0569756d'),
  -- data/triggers/062/062_94_gem_exchange_confirm_order.lua
  (62, 94, $trig$-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
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
wait(0.2)
local item = actor:get_quest_var("gem_exchange:gem_id")
if string.find(speech, "yes") then
    if (item or 0) == 0 or item == nil then
        actor:send(tostring(self.name) .. " says, 'Forgive me, I don't have an order under your name.'")
        return true
    end
    actor:send(tostring(self.name) .. " writes your exchange order down.")
    local class, tier
    if (item or 0) <= 55569 then class, tier = 1, 1
    elseif (item or 0) <= 55573 then class, tier = 1, 2
    elseif (item or 0) <= 55577 then class, tier = 1, 3
    elseif (item or 0) <= 55581 then class, tier = 1, 4
    elseif (item or 0) <= 55585 then class, tier = 1, 5
    elseif (item or 0) <= 55589 then class, tier = 1, 6
    elseif (item or 0) <= 55593 then class, tier = 1, 7
    elseif (item or 0) <= 55604 then class, tier = 2, 1
    elseif (item or 0) <= 55615 then class, tier = 2, 2
    elseif (item or 0) <= 55626 then class, tier = 2, 3
    elseif (item or 0) <= 55637 then class, tier = 2, 4
    elseif (item or 0) <= 55648 then class, tier = 2, 5
    elseif (item or 0) <= 55659 then class, tier = 2, 6
    elseif (item or 0) <= 55670 then class, tier = 2, 7
    elseif (item or 0) <= 55681 then class, tier = 3, 1
    elseif (item or 0) <= 55692 then class, tier = 3, 2
    elseif (item or 0) <= 55703 then class, tier = 3, 3
    elseif (item or 0) <= 55714 then class, tier = 3, 4
    elseif (item or 0) <= 55725 then class, tier = 3, 5
    elseif (item or 0) <= 55736 then class, tier = 3, 6
    elseif (item or 0) <= 55747 then class, tier = 3, 7
    end
    local item_name = tostring(objects.template(math.floor((item or 0) / 100), (item or 0) % 100).name)
    actor:send(tostring(self.name) .. " says, 'So " .. item_name .. " is a <b:yellow>class " .. tostring(class) .. " tier " .. tostring(tier) .. "</> gemstone.'")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'We can exchange any gemstone of equal or greater rarity for it.'")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'Consult the chart for degrees of rarity.'")
    actor:send(tostring(self.name) .. " points to the sign.")
else
    actor:set_quest_var("gem_exchange", "gem_id", 0)
    actor:send(tostring(self.name) .. " says, 'Alright, what DO you want then?'")
end
return true$trig$, '5bc825fbf11a07762d67624a120792d2'),
  -- data/triggers/062/062_95_gem_exchange_receive_exchange.lua
  (62, 95, $trig$-- TODO(parity): the legacy script gates `object.id` on the 5-digit vnum.
-- Here `object.id` is the local id within the gem's zone -- we reconstruct
-- the 5-digit form (zone*100 + local_id) before comparing. Verify that all
-- gems being handed in really live in zone 555.

local item = actor:get_quest_var("gem_exchange:gem_id")
if (item or 0) == 0 or item == nil then
    actor:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
    wait(1)
    actor:send(tostring(self.name) .. " says, 'I don't have any exchange orders listed for you at the")
    actor:send("</>moment...'")
    return true
end

local obj_vnum = object.zone_id * 100 + object.local_id

-- Decode the minimum-acceptable vnum cutoff for the requested item.
local function cutoff_for(it)
    if it <= 55569 then return 55566
    elseif it <= 55573 then return 55570
    elseif it <= 55577 then return 55574
    elseif it <= 55581 then return 55578
    elseif it <= 55585 then return 55582
    elseif it <= 55589 then return 55586
    elseif it <= 55593 then return 55590
    elseif it <= 55604 then return 55594
    elseif it <= 55615 then return 55605
    elseif it <= 55626 then return 55616
    elseif it <= 55637 then return 55627
    elseif it <= 55648 then return 55638
    elseif it <= 55659 then return 55649
    elseif it <= 55670 then return 55660
    elseif it <= 55681 then return 55671
    elseif it <= 55692 then return 55682
    elseif it <= 55703 then return 55693
    elseif it <= 55714 then return 55704
    elseif it <= 55725 then return 55715
    elseif it <= 55736 then return 55726
    elseif it <= 55747 then return 55737
    end
    return nil
end

-- Upper bound: highest-tier consumables stop at 55747 (top tier 3 set);
-- lower-class tiers are valid up through 55751 in the original.
local function upper_for(it)
    if it <= 55703 then return 55751 end
    return 55747
end

local lo = cutoff_for(item)
local hi = upper_for(item)
local in_gem_range = obj_vnum >= 55566 and obj_vnum <= 55751
local found = lo and hi and obj_vnum >= lo and obj_vnum <= hi

if found then
    wait(0.2)
    actor:send(tostring(self.name) .. " says, 'Here you are, as requested!'")
    world.destroy(object)
    self.room:spawn_object(math.floor((item or 0) / 100), (item or 0) % 100)
    self:command("give all " .. tostring(actor))
    wait(0.2)
    actor:send(tostring(self.name) .. " says, 'A pleasure doing business with you!'")
    actor:set_quest_var("gem_exchange", "gem_id", 0)
else
    actor:send(tostring(self.name) .. " refuses to perform the exchange.")
    wait(1)
    if in_gem_range then
        local item_name = tostring(objects.template(math.floor((item or 0) / 100), (item or 0) % 100).name)
        actor:send(tostring(self.name) .. " says, 'I'm afraid " .. tostring(object.shortdesc) .. " isn't of high enough rarity")
        actor:send("</>to exchange for " .. item_name .. ".'")
    else
        actor:send(tostring(self.name) .. " says, 'Sorry, " .. tostring(object.shortdesc) .. " isn't the kind of thing")
        actor:send("</>we trade around here...'")
    end
end
return true$trig$, '8f9573b4041761e82d92940aaf81ef15'),
  -- data/triggers/103/103_04_rianne-quest-receive.lua
  (103, 4, $trig$local function obj_key(o)
    return tostring(o.zone_id) .. "_" .. tostring(o.local_id)
end

-- ---------------------------------------------------------------
-- Daedela group_heal sub-branch (added 3-9-2021)
-- ---------------------------------------------------------------
if actor:get_quest_stage("group_heal") == 5 then
    local self_key = "group_heal:" .. tostring(self.zone_id) .. "_" .. tostring(self.local_id)
    local already = actor:get_quest_var(self_key)
    -- 18514 is a book — naive vnum mapping is (185, 14)
    if object.zone_id == 185 and object.local_id == 14 then
        if already and already ~= 0 and already ~= "" and already ~= "0" then
            self:say("I've told you everything I can.  Good luck!")
            return true
        end
        actor:set_quest_var("group_heal", tostring(self.zone_id) .. "_" .. tostring(self.local_id), 1)
        self:say("Well you've definitely come to the right place!")
        wait(0.4)
        self:emote("reads over the ritual recipe.")
        wait(4)
        self.room:send(self.name .. " says, 'Oh my, what a challenge.  No wonder someone would need help with this.'")
        wait(3)
        self.room:send(self.name .. " says, 'The names for many of these ingredients have changed since...  How old is this recipe anyway??'")
        wait(1)
        self:command("beam")
        self:say("I love it.")
        wait(3)
        self:emote("begins writing down a list of notes.")
        wait(1)
        self:say("... and this is called this...")
        wait(1)
        self:say("... this can be substituted with this...")
        wait(2)
        self.room:send(self.name .. " says, '... that's been extinct for over a century, so perhaps this will do...?'")
        wait(4)
        self:emote("finishes her list.")
        self.room:spawn_object(185, 20)
        self:command("give notes " .. actor.name)
        wait(2)
        self:say("That should help you.  I can't wait to hear how it goes!")
        self:command("wave " .. actor.name)
        return true
    end
end

-- ---------------------------------------------------------------
-- resort_cooking
-- ---------------------------------------------------------------
local stage = actor:get_quest_stage("resort_cooking")
local recipe, next_recipe
local ingredients  -- list of {zone, id} for the seven slots
local slot_count

-- Per-stage ingredient tables. Each row is {zone, id}; rows 1..N
-- must match the original item1..itemN vnums. nil-tail rows are
-- absent slots for that stage.
if stage == 1 then
    recipe, next_recipe = "Peach Cobbler", "Seafood Salad"
    ingredients = {{615, 1}, {237, 54}, {30, 114}, {350, 1}}
    slot_count = 4
elseif stage == 2 then
    recipe, next_recipe = "Seafood Salad", "Fish Stew"
    ingredients = {{490, 24}, {237, 50}, {237, 22}, {80, 3}, {125, 15}, {16, 6}}
    slot_count = 6
elseif stage == 3 then
    recipe, next_recipe = "Fish Stew", "Honey-Glazed Ham"
    ingredients = {{552, 13}, {300, 2}, {100, 30}, {125, 52}, {237, 57}, {185, 9}, {103, 11}}
    slot_count = 7
elseif stage == 4 then
    recipe, next_recipe = "Honey-Glazed Ham", "Saffroned Jasmine Rice"
    ingredients = {{410, 11}, {83, 50}, {20, 1}, {502, 7}, {61, 6}}
    slot_count = 5
elseif stage == 5 then
    recipe = "Saffroned Jasmine Rice"
    ingredients = {{580, 19}, {370, 13}, {237, 60}}
    slot_count = 3
else
    self:say("I don't have time for that right now.")
    self:emote("refuses your item.")
    return false
end

-- Which slot does the offered object match?
local matched_slot
for i = 1, slot_count do
    local row = ingredients[i]
    if row and object.zone_id == row[1] and object.local_id == row[2] then
        matched_slot = i
        break
    end
end
if not matched_slot then
    self.room:send(self.name .. " says, 'The recipe doesn't call for this!  Perhaps you should consult the recipe on the wall to refresh your memory.'")
    return false
end

-- Already turned this one in?
local slot_key = "item" .. tostring(matched_slot)
local already = actor:get_quest_var("resort_cooking:" .. slot_key)
if already and already ~= 0 and already ~= "" and already ~= "0" then
    self.room:send(self.name .. " says, 'You already brought in " .. tostring(object.shortdesc) .. ", so we don't need more.'")
    self:emote("hands your item back to you.")
    return false
end

wait(0.1)
world.destroy(object)
wait(0.4)
self.room:send(self.name .. " says, 'Just what we need for <b:white>" .. recipe .. "</>!'")
actor:set_quest_var("resort_cooking", slot_key, 1)

-- All per-stage slots collected?
local complete = true
for i = 1, slot_count do
    local v = actor:get_quest_var("resort_cooking:item" .. tostring(i))
    if not v or (v or 0) == 0 or (v or "") == "" or (v or 0) == 0 then
        complete = false
        break
    end
end

if complete then
    actor:advance_quest("resort_cooking")
    -- Reset the per-stage slot vars
    for i = 1, slot_count do
        actor:set_quest_var("resort_cooking", "item" .. tostring(i), 0)
    end
    self:say("I think I can start preparing it now.")
    wait(1)
    self:emote("gets the other ingredients from the icebox.")
    self:emote("begins mixing them together.")
    wait(2)

    if stage == 5 then
        -- Final reward
        self.room:send(self.name .. " says, 'You've been such a great help, " .. actor.name .. "!  Now I'm almost prepared for this huge dinner party, thanks!'")
        wait(3)
        self:say("I'd like you to have this.")
        wait(0.5)
        self.room:send(self.name .. " says, 'It was enchanted by a good friend of mine, so I hope it will help you as much as you've helped me.'")
        self.room:spawn_object(103, 15)
        for _ = 1, 3 do
            -- TODO(parity): original spawned random.gem from a 55736+1..11
            -- contiguous range; runtime has no slot range helper, so we
            -- approximate with the same numeric range mapped to (557, 36..46).
            self.room:spawn_object(557, 36 + random(1, 11))
        end
        self:command("give all.gem " .. actor.name)

        -- Class-adjusted experience curve, preserved verbatim
        local expcap = actor.level
        if expcap > 65 then expcap = 65 end
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

        local cls = actor.class
        if cls == "warrior" or cls == "berserker" then
            expmod = expmod + (expmod / 10)
        elseif cls == "paladin" or cls == "anti-paladin" or cls == "ranger" then
            expmod = expmod + ((expmod * 2) / 15)
        elseif cls == "sorcerer" or cls == "pyromancer" or cls == "cryomancer"
            or cls == "illusionist" or cls == "bard" then
            expmod = expmod + (expmod / 5)
        elseif cls == "necromancer" or cls == "monk" then
            expmod = expmod + (expmod * 2) / 5
        end

        actor:send("<b:yellow>You gain experience!</>")
        local setexp = expmod * 10
        for _ = 1, 10 do
            actor:award_exp(setexp)
        end
        actor:complete_quest("resort_cooking")
    else
        self.room:send(self.name .. " says, 'I'll keep preparing this while you collect items for the next recipe.'")
        self:command("ponder")
        wait(1)
        self:say("The next dish is " .. tostring(next_recipe) .. ".")
        wait(0.2)
        self:say("Here's the recipe.  Please take a look at it.")
        self:emote("points out a slip of paper hanging on the wall.")
    end
else
    self:emote("puts the item into the icebox.")
    wait(1)
    self:say("Thanks!  Quickly, bring the rest!")
end

self:command("drop all")
return true$trig$, 'd1d25ba625c14db44be7cd97588053f3'),
  -- data/triggers/120/120_03_druid_receive.lua
  (120, 3, $trig$local stage = actor:get_quest_stage("twisted_sorrow")

-- Quest already complete: politely refuse.
if stage > 1 then
    self.room:send_except(actor, actor.name .. " gives " .. object.shortdesc .. " to " .. self.name .. ".")
    actor:send("You give " .. object.shortdesc .. " to " .. self.name .. ".")
    wait(0.8)
    self:say("No further offerings are necessary.")
    actor:send(self.name .. " returns " .. object.shortdesc .. " to you.")
    self.room:send_except(actor, self.name .. " returns " .. object.shortdesc .. " to " .. actor.name .. ".")
    return true
end

-- Quest not yet started: refuse with confusion.
if stage ~= 1 then
    self.room:send_except(actor, actor.name .. " gives " .. object.shortdesc .. " to " .. self.name .. ".")
    actor:send("You give " .. object.shortdesc .. " to " .. self.name .. ".")
    wait(0.8)
    self:say("Why do you give me this?")
    actor:send(self.name .. " returns " .. object.shortdesc .. " to you.")
    self.room:send_except(actor, self.name .. " returns " .. object.shortdesc .. " to " .. actor.name .. ".")
    return true
end

-- Stage 1: must be a liquid container.
if object.type ~= "DRINKCONTAINER" then
    self.room:send_except(actor, actor.name .. " gives " .. object.shortdesc .. " to " .. self.name .. ".")
    actor:send("You give " .. object.shortdesc .. " to " .. self.name .. ".")
    wait(0.4)
    self:say("This is not a liquid container.")
    wait(0.4)
    actor:send(self.name .. " returns " .. object.shortdesc .. " to you.")
    self.room:send_except(actor, self.name .. " returns " .. object.shortdesc .. " to " .. actor.name .. ".")
    return true
end

-- Druid's home grove (no tree): redirect player.
if self.room == 12015 then
    self.room:send_except(actor, actor.name .. " gives " .. object.shortdesc .. " to " .. self.name .. ".")
    actor:send("You give " .. object.shortdesc .. " to " .. self.name .. ".")
    wait(0.4)
    self:say("Let us move to one of the mighty Rhells first, friend.")
    wait(0.4)
    actor:send(self.name .. " returns " .. object.shortdesc .. " to you.")
    self.room:send_except(actor, self.name .. " returns " .. object.shortdesc .. " to " .. actor.name .. ".")
    return true
end

-- Empty container: refuse.
if object.val1 == 0 then
    self.room:send_except(actor, actor.name .. " gives " .. object.shortdesc .. " to " .. self.name .. ".")
    actor:send("You give " .. object.shortdesc .. " to " .. self.name .. ".")
    wait(0.4)
    self:emote("peers into " .. object.shortdesc .. ".")
    wait(0.4)
    self:say("This won't do at all!  It's empty.")
    wait(0.4)
    actor:send(self.name .. " returns " .. object.shortdesc .. " to you.")
    self.room:send_except(actor, self.name .. " returns " .. object.shortdesc .. " to " .. actor.name .. ".")
    return true
end

-- This tree already satisfied: refuse.
if (actor:get_quest_var("twisted_sorrow:satisfied_tree:" .. tostring(self.room)) or 0) == 1 then
    self.room:send_except(actor, actor.name .. " gives " .. object.shortdesc .. " to " .. self.name .. ".")
    actor:send("You give " .. object.shortdesc .. " to " .. self.name .. ".")
    wait(0.4)
    self:say("This tree is already satisfied, my friend.")
    wait(0.4)
    actor:send(self.name .. " returns " .. object.shortdesc .. " to you.")
    self.room:send_except(actor, self.name .. " returns " .. object.shortdesc .. " to " .. actor.name .. ".")
    return true
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

return false$trig$, '6b8fbbd2555cef5fd11830d8268e8c9d'),
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
    self:command("give " .. tostring(object.name) .. " " .. tostring(actor.name))
    return _return_value
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
return _return_value$trig$, '9b91be0bdcff76fb4f2a7a3f64ed253e'),
  -- data/triggers/185/185_16_group_heal_doctor_greet.lua
  (185, 16, $trig$wait(2)
local stage = actor:get_quest_stage("group_heal")
if actor.is_player and stage == 0 then
    self:say("Greetings!")
    wait(2)
    self:say("What kind of healing I can assist you with today?")
elseif stage == 1 then
    self:say("Welcome back!")
    wait(2)
    self:say("Have you been able to track down the bandit raiders yet?")
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
    end
elseif stage == 2 then
    self:say("Welcome back!")
    wait(2)
    self:say("Do you have the stolen supplies?")
elseif stage == 3 or stage == 4 then
    self:say("Welcome back!")
    wait(2)
    self:say("Do you have the records of the ritual?")
elseif stage == 5 then
    local total = 6 - (actor:get_quest_var("group_heal:total") or 0)
    if total == 6 then
        self:say("Ah you've returned!")
        wait(2)
        self:say("Have you been able to consult with any of the chefs?")
    elseif total == 1 then
        self:say("Ah you've returned!")
        wait(2)
        self:say("Have you been able to consult with the last chef yet?")
    else
        self:say("Ah you've returned!")
        wait(2)
        self:say("Have you been able to consult with any of the " .. tostring(total) .. " remaining chefs?")
    end
    self.room:send(tostring(self.name) .. " says, 'And if you need a new copy of the Rite, just say:")
    self.room:send("</><b:yellow>\"I lost the Rite\"</> and I will give you a new one.'")
elseif stage == 6 then
    self:say("Good to see you again!")
    wait(2)
    self:say("I hope the distribution of those medical packets is going well.")
end$trig$, '67e89f63f0354fdef116cd528f1bad65'),
  -- data/triggers/188/188_44_globe_get.lua
  (188, 44, $trig$local _return_value = true  -- Default: allow action
local globe_key = "globe_" .. tostring(self.zone_id) .. "_" .. tostring(self.local_id) .. "_time"
if actor:get_quest_var("quest_items:" .. tostring(self.zone_id) .. "_" .. tostring(self.local_id)) then
    if globals.owner then
        if globals.owner == actor.name then
            if not (actor:get_worn("held")) and not (actor:get_worn("wield")) and not (actor:get_worn("2hwield")) then
                local last_use = actor:get_quest_var("quest_items:" .. globe_key)
                local now = timestamp()
                local can_use = false
                if last_use then
                    if now - (last_use or 0) >= 1 then
                        can_use = true
                    else
                        _return_value = false
                        self.room:send(tostring(self.shortdesc) .. " flares brightly, but then fades.")
                    end
                else
                    can_use = true
                end
                if can_use then
                    _return_value = true
                    self.room:spawn_object(self.zone_id, self.id)
                    actor:command("get globe")
                    actor:command("hold globe")
                    actor:command("use globe")
                    actor:set_quest_var("quest_items", globe_key, now)
                    world.destroy(self)
                end
            else
                _return_value = false
                actor:send("You must have your primary hand free to activate " .. tostring(self.shortdesc) .. ".")
            end
        else
            _return_value = true
            actor:send(tostring(self.shortdesc) .. ": you can't take that!")
        end
    else
        _return_value = false
    end
else
    _return_value = true
    actor:send(tostring(self.shortdesc) .. ": you can't take that!")
end
return _return_value$trig$, 'eaddfefc6dc1f4365b86ca1976980fd1'),
  -- data/triggers/188/188_91_summon_dragon.lua
  (188, 91, $trig$-- Command location mask 3: legacy OCMD_EQUIP=1 (worn), OCMD_INVEN=2 (carried), OCMD_ROOM=4 (floor)
if not (location == "equip" or location == "inventory") then
    return true  -- Not in a location this trigger watches
end

-- Command filter: summon
if not (cmd == "summon") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
-- switch on cmd
do
    local _sw1 = string.lower(tostring(cmd or ""))
    if _sw1 == "s" or _sw1 == "su" then
        _return_value = true
        return _return_value
    end
end
local last_summon = actor:get_quest_var("quest_items:dragonhelm_time")
-- timestamp() counts game hours (legacy time.stamp); 168 game hours == one MUD week.
local now = timestamp()
local can_summon = false
if last_summon then
    if now - (last_summon or 0) >= 168 then
        can_summon = true
    else
        actor:send("You may only summon one mount per week!")
    end
else
    can_summon = true
end
if can_summon then
    local summoned
    -- The knight doesn't have a mount yet, allow them to get one
    if actor.class == "paladin" then
        -- Knight is a paladin, give him/her a golden dragon
        self.room:spawn_mobile(188, 90)
        self.room:send_except(actor, "A brilliant golden dragon flies in from nowhere, and nuzzles " .. tostring(actor.name) .. "'s side.")
        actor:send("You begin calling for a mount..")
        actor:send("A brilliant golden dragon answers your summons.")
        summoned = "yes"
    elseif string.find(actor.class, "anti") then
        -- Knight is an anti-paladin, give him/her a black dragon
        self.room:spawn_mobile(188, 91)
        self.room:send_except(actor, "A dusky black dragon flies in, seemingly from nowhere, and sits by " .. tostring(actor.name) .. "'s side.")
        actor:send("You begin calling for a mount..")
        actor:send("A dusky black dragon answers your summons.")
        summoned = "yes"
    else
        actor:send("You begin calling for a mount...but nothing happens.")
        self.room:send_except(actor, tostring(actor.name) .. " whistles loudly.")
    end
    -- Saddle up the dragon mount
    if summoned then
        local mount = self.room:find_actor("dragon-mount")
        if mount then mount:follow(actor.name) end
        self.room:spawn_mobile(188, 92)
        local squire = self.room:find_actor("dragonsquire")
        if squire then
            squire:spawn_object(188, 92)
            squire:command("give dragonsaddle dragon-mount")
            world.destroy(squire)
        end
        if mount then mount:command("wear dragonsaddle") end
        -- Timestamp the per-week cooldown
        actor:set_quest_var("quest_items", "dragonhelm_time", now)
    end
end
return _return_value$trig$, 'acb3be6cd1162c679f99a119eef31006'),
  -- data/triggers/364/364_20_berserker_subclass_progress_checker.lua
  (364, 20, $trig$-- Speech phrase: subclass progress (DG num_arg 0 = the speech contains the whole phrase, on word boundaries)
local speech_padded = " " .. string.lower(speech) .. " "
if not string.find(speech_padded, "[%s%p]subclass progress[%s%p]") then
    return true  -- Not the phrase
end

wait(0.2)
local stage = actor:get_quest_stage("berserker_subclass")

if stage == 1 then
    actor:send(tostring(self.name) .. " says, 'There are a few shared rites that bind us together.  None is more revered than the <b:cyan>Wild Hunt</>.'")
    return true
end

if stage == 2 then
    actor:send(tostring(self.name) .. " says, 'Let us challenge the Spirits for the right to prove ourselves!  If they deem you worthy, the Spirits send you a vision of a mighty <b:cyan>beast</>.'")
    return true
end

if stage == 3 then
    actor:send(tostring(self.name) .. " says, '<b:red>Howl</> to the spirits and make your song known!'")
    return true
end

if stage == 4 then
    -- Re-reveal the assigned quarry. Lookup mirrors 364_13's QUARRIES table.
    local QUARRIES = {
        [16105] = "a desert cave",
        [16310] = "some forested highlands",
        [20311] = "a vast plain",
        [55220] = "the frozen tundra",
    }
    local target = actor:get_quest_var("berserker_subclass:target")
    local place = QUARRIES[target]
    if target and place then
        local quarry_name = mobiles.template(math.floor((target or 0) / 100), (target or 0) % 100).name
        actor:send("The Spirits reveal to you a vision of " .. tostring(quarry_name) .. "!")
        actor:send("You see it is in " .. tostring(place) .. "!")
    end
    -- TODO(parity): legacy script also fell through to a race-restriction
    -- "you won't be able to become a berserker" branch with placeholder
    -- "ADD RESTRICTED RACES HERE". Restricted-race list still TBD.
    if not string.find(actor.class, "warrior") then
        actor:send(tostring(self.name) .. " says, 'You won't be able to become a berserker, I'm afraid.'")
    end
    return true
end

-- stage 0 (or unset): not started yet.
if string.find(actor.class, "warrior") then
    if actor.level >= 10 and actor.level <= 25 then
        actor:send(tostring(self.name) .. " says, 'You aren't trying to join us yet!'")
    elseif actor.level < 10 then
        actor:send(tostring(self.name) .. " says, 'You aren't ready to join us yet!'")
    else
        actor:send(tostring(self.name) .. " says, 'You won't be able to become a berserker, I'm afraid.'")
    end
else
    actor:send(tostring(self.name) .. " says, 'You won't be able to become a berserker, I'm afraid.'")
end
return true$trig$, '767522801a081536e7ce7200fb76d561'),
  -- data/triggers/390/390_07_flood_spirits_receive.lua
  (390, 7, $trig$local _return_value = true  -- Default: allow action
local stage = actor:get_quest_stage("flood")
-- switch on self.id
do
    if (self.zone_id == 390 and self.id == 12) then
        if stage == 2 then
            if (object.zone_id == 390 and object.id == 0) then
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
    elseif (self.zone_id == 390 and self.id == 14) then
        local color = "<cyan>"
        if stage == 1 then
            if (object.zone_id == 584 and object.id == 1) then
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
    elseif (self.zone_id == 390 and self.id == 16) then
        local color = "<green>"
        if stage == 1 then
            if object.type == "FOOD" then
                if actor:get_quest_var("flood:" .. tostring(object.zone_id) .. "_" .. tostring(object.local_id)) then
                    wait(0.2)
                    self.room:send(tostring(self.name) .. " wails in anger as she thrashes about!")
                    self.room:send(tostring(self.name) .. " throws " .. tostring(object.shortdesc) .. " into the sea!")
                    self.room:send(tostring(self.name) .. " says, " .. tostring(color) .. "'I have already eaten that!  I refuse to eat it again!'</>")
                else
                    actor:set_quest_var("flood", (tostring(object.zone_id) .. "_" .. tostring(object.local_id)), 1)
                    local full = actor:get_quest_var("flood:hunger")
                    local hunger = ((full or 0) + object.val0)
                    actor:set_quest_var("flood", "hunger", hunger)
                    self:destroy_item("food")
                    self.room:send(tostring(self.name) .. " greedily devours " .. tostring(object.shortdesc) .. ".")
                    if hunger >= 200 then
                        wait(0.2)
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
                        wait(0.2)
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
    elseif (self.zone_id == 390 and self.id == 19) then
        local color = "<b:black>"
        if stage == 1 then
            if object.type == "LIGHT" then
                if object.val1 == -1 then
                    actor:set_quest_var("flood", "water7", 1)
                    wait(0.2)
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
return _return_value$trig$, 'f9057448512bdd974ee88f58fe61304a'),
  -- data/triggers/484/484_01_oracle-sun-greet.lua
  (484, 1, $trig$-- Converted from DG Script #48401: oracle-sun-greet
-- Original: MOB trigger, flags: GREET_ALL, probability: 100%
-- TODO(parity): the original references DG globals `wandstep`/`macestep`
--   to compute minlevel; the converter emitted branch-scoped `local
--   minlevel` declarations and references undefined globals. The
--   `actor.group_member[a]` walk also relies on a branch-scoped `local a`
--   that escapes to the loop. Ported as best-effort: minlevel is hoisted
--   and clamped to the actor's level so the gate is permissive, and the
--   group walk's `a` is hoisted. Real values for wandstep/macestep need
--   to come from quest-var lookups once that API is wired up.
wait(0.2)
local wandstep = actor:get_quest_var("type_wand:step")
local macestep = actor:get_quest_var("phase_mace:step")
local minlevel
if wandstep and wandstep ~= 0 then
    minlevel = ((wandstep or 0) - 1) * 10
elseif macestep and macestep ~= 0 then
    minlevel = (macestep or 0) * 10
else
    minlevel = 0
end
if actor:get_quest_stage("type_wand") == "wandstep" and actor:get_quest_stage("doom_entrance") ~= 5 and actor:get_quest_stage("doom_entrance") ~= 6 and not actor:get_has_completed("doom_entrance") then
    if actor.level >= minlevel then
        if (actor:get_quest_var("type_wand:greet") or 0) == 0 then
            actor:send(tostring(self.name) .. " says, 'Timun, God of the Sun, sees you are progressing toward divine fire.  Tell us what you are working on.'")
        else
            actor:send(tostring(self.name) .. " says, 'Do you have what I require to craft your staff?'")
        end
    end
elseif actor:get_quest_stage("phase_mace") == "macestep" and actor:get_quest_stage("doom_entrance") ~= 5 and actor:get_quest_stage("doom_entrance") ~= 6 and not actor:get_has_completed("doom_entrance") then
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
    if actor:get_quest_stage("type_wand") == "wandstep" then
        if actor.level >= minlevel then
            if (actor:get_quest_var("type_wand:greet") or 0) == 0 then
                actor:send(tostring(self.name) .. " says, 'Additionally Timun, God of the Sun, sees you are progressing toward divine fire.  Tell us what you are working on.'")
                wait(1)
            else
                actor:send(tostring(self.name) .. " says, 'Do you have what I require to craft your staff?'")
                wait(1)
            end
        end
    elseif actor:get_quest_stage("phase_mace") == "macestep" then
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
    if actor:get_quest_stage("type_wand") == "wandstep" then
        local minlevel = ((wandstep or 0) - 1) * 10
        if actor.level >= minlevel then
            wait(3)
            if (actor:get_quest_var("type_wand:greet") or 0) == 0 then
                actor:send(tostring(self.name) .. " says, 'Additionally Timun, God of the Sun, sees you are progressing toward divine fire.  Tell us what you are working on.'")
                wait(1)
            else
                actor:send(tostring(self.name) .. " says, 'Do you have what I require to craft your staff?'")
                wait(1)
            end
        end
    elseif actor:get_quest_stage("phase_mace") == "macestep" then
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
    if actor:get_quest_stage("type_wand") == "wandstep" then
        local minlevel = ((wandstep or 0) - 1) * 10
        if actor.level >= minlevel then
            if (actor:get_quest_var("type_wand:greet") or 0) == 0 then
                actor:send(tostring(self.name) .. " says, 'Additionally Timun, God of the Sun, sees you are progressing toward divine fire.  Tell us what you are working on.'")
                wait(1)
            else
                actor:send(tostring(self.name) .. " says, 'Do you have what I require to craft your staff?'")
                wait(1)
            end
        elseif actor:get_quest_stage("phase_mace") == "macestep" then
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
end$trig$, '4d5bbad9063add5dbf3b3aac125678f8'),
  -- data/triggers/534/534_50_major_globe_greet.lua
  (534, 50, $trig$-- Converted from DG Script #53450: major_globe_greet
-- Original: MOB trigger, flags: GREET, probability: 100%
if (actor.class == "sorcerer" or actor.class == "cryomancer" or actor.class == "pyromancer") and (actor.level >= 57) then
    if actor:get_has_completed("major_globe_spell") then
        return true
    end
    wait(1)
    -- switch on actor:get_quest_stage("major_globe_spell")
    do
        local _sw1 = string.lower(tostring(actor:get_quest_stage("major_globe_spell") or ""))
        if tonumber(_sw1) == 1 or tonumber(_sw1) == 2 or tonumber(_sw1) == 3 or tonumber(_sw1) == 4 or tonumber(_sw1) == 5 then
            self:emote("coughs fitfully.")
            wait(1)
            actor:send(tostring(self.name) .. " says, 'Have you brought me the salve from Earle?'")
            actor:send(tostring(self.name) .. " looks at you pleadingly.")
            self.room:send_except(actor, tostring(self.name) .. " looks at " .. tostring(actor.name) .. " pleadingly.")
        elseif tonumber(_sw1) == 6 or tonumber(_sw1) == 7 then
            actor:send(tostring(self.name) .. " turns to look at you.")
            self.room:send_except(actor, tostring(self.name) .. " turns to look at " .. tostring(actor.name) .. ".")
            wait(1)
            actor:send(tostring(self.name) .. " says, 'Welcome back, were you able to find the spellbook?'")
        elseif tonumber(_sw1) == 8 then
            actor:send(tostring(self.name) .. " hops up from his chair as you enter.")
            self.room:send_except(actor, tostring(self.name) .. " hops up from his chair as " .. tostring(actor.name) .. " enters.")
            wait(1)
            actor:send(tostring(self.name) .. " comes limping over to you.")
            self.room:send_except(actor, tostring(self.name) .. " limps over to " .. tostring(actor.name) .. ".")
            local wards_left = 5 - (actor:get_quest_var("major_globe_spell:ward_count") or 0)
            if wards_left > 1 then
                actor:send(tostring(self.name) .. " says, 'The wards!  The wards!  Do you have them?  We still need " .. tostring(wards_left) .. " of them!")
            else
                actor:send(tostring(self.name) .. " says, 'Just one ward left!  Do you have it?'")
            end
        elseif tonumber(_sw1) == 9 or tonumber(_sw1) == 10 then
            actor:send(tostring(self.name) .. " bounds over to you.")
            self.room:send_except(actor, tostring(self.name) .. " runs over to " .. tostring(actor.name) .. ".")
            wait(1)
            local final_item = actor:get_quest_var("major_globe_spell:final_item")
            -- final_item is a quest var holding an object's local id within zone 534
            local item_name = objects.template(534, final_item).name
            actor:send(tostring(self.name) .. " says, 'Do you have " .. tostring(item_name) .. " to channel the power?  Please say you do!'")
        else
            actor:send(tostring(self.name) .. " turns his head to look at you.")
            self.room:send_except(actor, tostring(self.name) .. " turns his head to look at " .. tostring(actor.name) .. ".")
            self:command("cough")
            wait(2)
            actor:send(tostring(self.name) .. " says, 'You're a " .. tostring(actor.class) .. "!  Perhaps you can <b:cyan>assist</> me.'")
        end
    end
end$trig$, '3a19899849f10807691367391997ed15'),
  -- data/triggers/534/534_67_major_globe_lirne_receive_3.lua
  (534, 67, $trig$-- Converted from DG Script #53467: Major Globe Lirne receive 3
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local stage = actor:get_quest_stage("major_globe_spell")
if stage == 8 then
    wait(0.1)
    -- TODO(parity): original DG keyed the quest var by global vnum
    -- of the handed-in ward. With composite ids, key by the object's
    -- local id within zone 534 (wards are objects 53-57 in zone 534 —
    -- see trigger 53457).
    local number = object.local_id
    local ward = actor:get_quest_var("major_globe_spell:ward_" .. tostring(number))
    self:destroy_item("majorglobe-ward")
    if (ward or 0) == 0 then
        self:command("frown")
        actor:send(tostring(self.name) .. " says, 'How could you have gotten this?  Do the quest yourself!'")
    elseif (ward or 0) == 1 then
        -- mark this specific ward as turned in (2 = consumed)
        actor:set_quest_var("major_globe_spell", "ward_" .. tostring(number), 2)
        local wards = (actor:get_quest_var("major_globe_spell:ward_count") or 0) + 1
        actor:set_quest_var("major_globe_spell", "ward_count", wards)
        local wards_left = 5 - wards
        self:command("smile")
        if wards_left > 0 then
            actor:send(tostring(self.name) .. " says, 'Excellent, only " .. tostring(wards_left) .. " more, and we'll be almost ready.'")
        else
            actor:advance_quest("major_globe_spell")
            actor:send(tostring(self.name) .. " says, 'Okay!  That's enough elemental wards to power the spell.  We only need one more item to channel the power...'")
            self:command("think")
            self:emote("quickly studies the spellbook again.")
            -- final_item: pick one of the four legendary items (objects in
            -- zone 534 ids 58-61); store its local id in the quest var.
            local roll = random(1, 4)
            local final_local
            local place
            if roll == 1 then
                final_local = 58
                place = "in a border keep"
            elseif roll == 2 then
                final_local = 59
                place = "on an emerald isle"
            elseif roll == 3 then
                final_local = 60
                place = "within a misty fortress"
            else
                final_local = 61
                place = "in an underground city"
            end
            actor:set_quest_var("major_globe_spell", "final_item", final_local)
            wait(3)
            local final_name = objects.template(534, final_local).name
            actor:send(tostring(self.name) .. " says, 'Yes, the last item for the spell is here.  It is <b:yellow>" .. tostring(final_name) .. "</>.'")
            self:emote("thinks hard for a moment.")
            wait(2)
            actor:send(tostring(self.name) .. " says, 'It is rumored that it can be found <b:cyan>" .. tostring(place) .. "</>.'")
            wait(4)
            actor:send(tostring(self.name) .. " says, 'Quickly, go now and retrieve it so that we might defeat the demon!'")
        end
    elseif (ward or 0) == 2 then
        local wards_left = 5 - (actor:get_quest_var("major_globe_spell:ward_count") or 0)
        self:command("eyebrow")
        if wards_left > 1 then
            actor:send(tostring(self.name) .. " says, 'You've already given me this ward.  We still need " .. tostring(wards_left) .. " different ones!")
        else
            actor:send(tostring(self.name) .. " says, 'You've already given me this ward.  We still need " .. tostring(wards_left) .. " different one!")
        end
    end
elseif stage < 8 then
    self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
    wait(0.2)
    actor:send(tostring(self.name) .. " says, 'I'm not quite ready to deal with those yet.  Do the quest in order.'")
elseif stage > 8 then
    wait(0.1)
    self:destroy_item("majorglobe-ward")
    actor:send(tostring(self.name) .. " says, 'You already gave me all the elemental wards!'")
end
return true$trig$, 'db89b6a8aa7c4c0f092e0b8e142b227c'),
  -- data/triggers/556/556_27_unused.lua
  (556, 27, $trig$-- Converted from DG Script #55627: **UNUSED**
-- Original: MOB trigger, flags: SPEECH_TO, probability: 0%

-- Speech phrase: status (DG num_arg 0 = the speech contains the whole phrase, on word boundaries)
local speech_padded = " " .. string.lower(speech) .. " "
if not string.find(speech_padded, "[%s%p]status[%s%p]") then
    return true  -- Not the phrase
end


-- TODO(parity): Status report relies on broken DG-Script remnants from auto-conversion.
-- Issues to fix in a future rewrite of the phase_armor quest dispatch:
--   * Quest-var keys are literal strings ("phase_armor:id_destroyed_gloves_armor_acquired")
--     instead of being interpolated with the per-class id_destroyed_* values, so every
--     class shares the same key namespace and the per-class id_* tables below are dead
--     code.
--   * Output uses raw "%get.obj_shortdesc[%X%]%" placeholders (DG syntax) instead of
--     looking up object names via objects.template(zone, id).name.
--   * 5-digit legacy vnums (55300+) need to be split into composite (zone, id) pairs
--     and resolved through the object catalog.
--   * The "given" truthiness check (line: "if given then") sums numeric quest vars,
--     so it reports "You have given me:" even when the player has given nothing
--     (0 is truthy in Lua).
--   * "_return_value" is referenced but never defined.
--   * Class identifiers (Warrior/Cleric/etc.) are bare globals instead of strings.
-- The trigger is currently gated by "if not percent_chance(0) then return true end",
-- so it never actually fires in production. Leaving the body intact for later rewrite.


-- 0% chance to trigger
if not percent_chance(0) then
    return true
end
local right_class = actor.class == Cleric  or  actor.class == Priest
local min_level = 41
local quest_stage = 2
if right_class then
    if actor.level < min_level then
        actor:send(tostring(self.name) .. " tells you, 'You need to gain more experience first.'")
    elseif actor:get_quest_stage("phase_armor") >= quest_stage then
        -- destroyed armor
        local id_destroyed_gloves = 55356
        local id_destroyed_boots = 55360
        local id_destroyed_bracer = 55364
        local id_destroyed_helm = 55368
        local id_destroyed_arm = 55372
        local id_destroyed_legs = 55376
        local id_destroyed_chest = 55380
        -- gems for this class
        local id_gem_gloves = 55678
        local id_gem_boots = 55689
        local id_gem_bracer = 55700
        local id_gem_helm = 55711
        local id_gem_arm = 55722
        local id_gem_legs = 55733
        local id_gem_chest = 55744
        -- rewards for this class
        local id_reward_helm = 55510
        local id_reward_arms = 55511
        local id_reward_chest = 55512
        local id_reward_legs = 55513
        local id_reward_boots = 55514
        local id_reward_bracer = 55515
        local id_reward_gloves = 55516
        local gloves_armor = actor:get_quest_var("phase_armor:id_destroyed_gloves_armor_acquired")
        local boots_armor = actor:get_quest_var("phase_armor:id_destroyed_boots_armor_acquired")
        local bracer_armor = actor:get_quest_var("phase_armor:id_destroyed_bracer_armor_acquired")
        local helm_armor = actor:get_quest_var("phase_armor:id_destroyed_helm_armor_acquired")
        local arm_armor = actor:get_quest_var("phase_armor:id_destroyed_arm_armor_acquired")
        local legs_armor = actor:get_quest_var("phase_armor:id_destroyed_legs_armor_acquired")
        local chest_armor = actor:get_quest_var("phase_armor:id_destroyed_chest_armor_acquired")
        local gloves_gems = actor:get_quest_var("phase_armor:id_gem_gloves_gems_acquired")
        local boots_gems = actor:get_quest_var("phase_armor:id_gem_boots_gems_acquired")
        local bracer_gems = actor:get_quest_var("phase_armor:id_gem_bracer_gems_acquired")
        local helm_gems = actor:get_quest_var("phase_armor:id_gem_helm_gems_acquired")
        local arm_gems = actor:get_quest_var("phase_armor:id_gem_arm_gems_acquired")
        local legs_gems = actor:get_quest_var("phase_armor:id_gem_legs_gems_acquired")
        local chest_gems = actor:get_quest_var("phase_armor:id_gem_chest_gems_acquired")
        local done_gloves = (gloves_armor or 0) == 1  and  (gloves_gems or 0) == 3
        local done_boots = (boots_armor or 0) == 1  and  (boots_gems or 0) == 3
        local done_bracer = (bracer_armor or 0) == 1  and  (bracer_gems or 0) == 3
        local done_helm = (helm_armor or 0) == 1  and  (helm_gems or 0) == 3
        local done_arm = (arm_armor or 0) == 1  and  (arm_gems or 0) == 3
        local done_legs = (legs_armor or 0) == 1  and  (legs_gems or 0) == 3
        local done_chest = (chest_armor or 0) == 1  and  (chest_gems or 0) == 3
        local given = (gloves_armor or 0) + (boots_armor or 0) + (bracer_armor or 0) + (helm_armor or 0) + (arm_armor or 0) + (legs_armor or 0) + (chest_armor or 0)
        given = given + (gloves_gems or 0) + (boots_gems or 0) + (bracer_gems or 0) + (helm_gems or 0) + (arm_gems or 0) + (legs_gems or 0) + (chest_gems or 0)
        if given then
            actor:send(tostring(self.name) .. " tells you, 'You have given me:'")
        else
            actor:send(tostring(self.name) .. " tells you, 'You haven't given me anything yet.'")
            return _return_value
        end
        if gloves_armor and not done_gloves then
            actor:send(tostring(self.name) .. " tells you, '  " .. "%get.obj_shortdesc[%id_destroyed_gloves%]%'")
        end
        if gloves_gems and not done_gloves then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(gloves_gems) .. " of " .. "%get.obj_shortdesc[%id_gem_gloves%]%'")
        end
        if boots_armor and not done_boots then
            actor:send(tostring(self.name) .. " tells you, '  " .. "%get.obj_shortdesc[%id_destroyed_boots%]%'")
        end
        if boots_gems and not done_boots then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(boots_gems) .. " of " .. "%get.obj_shortdesc[%id_gem_boots%]%'")
        end
        if bracer_armor and not done_bracer then
            actor:send(tostring(self.name) .. " tells you, '  " .. "%get.obj_shortdesc[%id_destroyed_bracer%]%'")
        end
        if bracer_gems and not done_bracer then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(bracer_gems) .. " of " .. "%get.obj_shortdesc[%id_gem_bracer%]%'")
        end
        if helm_armor and not done_helm then
            actor:send(tostring(self.name) .. " tells you, '  " .. "%get.obj_shortdesc[%id_destroyed_helm%]%'")
        end
        if helm_gems and not done_helm then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(helm_gems) .. " of " .. "%get.obj_shortdesc[%id_gem_helm%]%'")
        end
        if arm_armor and not done_arm then
            actor:send(tostring(self.name) .. " tells you, '  " .. "%get.obj_shortdesc[%id_destroyed_arm%]%'")
        end
        if arm_gems and not done_arm then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(arm_gems) .. " of " .. "%get.obj_shortdesc[%id_gem_arm%]%'")
        end
        if legs_armor and not done_legs then
            actor:send(tostring(self.name) .. " tells you, '  " .. "%get.obj_shortdesc[%id_destroyed_legs%]%'")
        end
        if legs_gems and not done_legs then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(legs_gems) .. " of " .. "%get.obj_shortdesc[%id_gem_legs%]%'")
        end
        if chest_armor and not done_chest then
            actor:send(tostring(self.name) .. " tells you, '  " .. "%get.obj_shortdesc[%id_destroyed_chest%]%'")
        end
        if chest_gems and not done_chest then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(chest_gems) .. " of " .. "%get.obj_shortdesc[%id_gem_chest%]%'")
        end
        if done_gloves and done_boots and done_bracer and done_helm and done_arm and done_legs and done_chest then
            actor:send(tostring(self.name) .. " tells you, 'You have completed quests for:'")
        end
        if done_gloves then
            actor:send(tostring(self.name) .. " tells you, '  " .. "%get.obj_shortdesc[%id_reward_gloves%]%'")
        end
        if done_boots then
            actor:send(tostring(self.name) .. " tells you, '  " .. "%get.obj_shortdesc[%id_reward_boots%]%'")
        end
        if done_bracer then
            actor:send(tostring(self.name) .. " tells you, '  " .. "%get.obj_shortdesc[%id_reward_bracer%]%'")
        end
        if done_helm then
            actor:send(tostring(self.name) .. " tells you, '  " .. "%get.obj_shortdesc[%id_reward_helm%]%'")
        end
        if done_arm then
            actor:send(tostring(self.name) .. " tells you, '  " .. "%get.obj_shortdesc[%id_reward_arms%]%'")
        end
        if done_legs then
            actor:send(tostring(self.name) .. " tells you, '  " .. "%get.obj_shortdesc[%id_reward_legs%]%'")
        end
        if done_chest then
            actor:send(tostring(self.name) .. " tells you, '  " .. "%get.obj_shortdesc[%id_reward_chest%]%'")
        end
    else
        actor:send(tostring(self.name) .. " tells you, 'You haven't even talked to me about armor quests yet!'")
    end
end$trig$, '321830e5c1b4f2dcb99f40b32acaa7c1'),
  -- data/triggers/590/590_46_group_armor_forgemaster_receive.lua
  (590, 46, $trig$-- Converted from DG Script #59046: group_armor_forgemaster_receive
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
local stage = actor:get_quest_stage("group_armor")
-- switch on stage
do
    local _sw1 = string.lower(tostring(stage or ""))
    if tonumber(_sw1) == 1 then
        if (object.zone_id == 61 and object.id == 18) or (object.zone_id == 117 and object.id == 4) or (object.zone_id == 117 and object.id == 7) or (object.zone_id == 169 and object.id == 6) then
            if (actor:get_quest_var("group_armor:" .. tostring(object.zone_id) .. "_" .. tostring(object.local_id)) or 0) == 1 then
                _return_value = true
                self:say("You already brought me " .. tostring(object.shortdesc) .. "!")
            else
                actor:set_quest_var("group_armor", (tostring(object.zone_id) .. "_" .. tostring(object.local_id)), 1)
                wait(0.2)
                world.destroy(object.name)
                wait(0.2)
                self:say("Aye, this'll do.")
                local item1 = actor:get_quest_var("group_armor:6118")
                local item2 = actor:get_quest_var("group_armor:11704")
                local item3 = actor:get_quest_var("group_armor:11707")
                local item4 = actor:get_quest_var("group_armor:16906")
                if item1 and item2 and item3 and item4 then
                    actor:advance_quest("group_armor")
                    wait(0.2)
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
                    local total = ((item1 or 0) + (item2 or 0) + (item3 or 0) + (item4 or 0))
                    wait(0.2)
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
    elseif tonumber(_sw1) == 2 then
        if (object.zone_id == 87 and object.id == 1) then
            wait(0.2)
            self:emote("examines the hammer.")
            self:say("This will do!")
            wait(1)
            self.room:send(tostring(self.name) .. " says, 'To consecrate the hammer again you'll need to")
            self.room:send("</>find a place where the light of the sun reaches deep into the bowels of")
            self.room:send("</>Ethilien and <b:white>[commune]</> with the spirits there.'")
            wait(0.2)
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
    elseif tonumber(_sw1) == 3 then
        _return_value = true
        if (object.zone_id == 590 and object.id == 39) then
            self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
            self:say("Where did you find this?")
            wait(1)
            self:say("This can't be the same hammer you brought me before.")
        elseif (object.zone_id == 87 and object.id == 1) then
            self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
            self.room:send(tostring(self.name) .. " says, 'You need to bring me the consecrated hammer.")
            self.room:send("</>Another mundane forging hammer is useless.'")
        end
    elseif tonumber(_sw1) == 4 then
        if (object.zone_id == 590 and object.id == 39) then
            actor:advance_quest("group_armor")
            wait(0.2)
            world.destroy(object.name)
            wait(0.2)
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
    elseif tonumber(_sw1) == 5 then
        if (object.zone_id == 125 and object.id == 0) then
            wait(0.2)
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
    elseif tonumber(_sw1) == 6 then
        if (object.zone_id == 470 and object.id == 4) or (object.zone_id == 470 and object.id == 18) or (object.zone_id == 530 and object.id == 3) then
            if (actor:get_quest_var("group_armor:" .. tostring(object.zone_id) .. "_" .. tostring(object.local_id)) or 0) == 1 then
                _return_value = true
                self:say("You already brought me " .. tostring(object.shortdesc) .. "!")
            else
                wait(0.2)
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
end
return _return_value$trig$, '7f85fc9d968ececd6a74e68003a27361')
) AS v(zone_id, id, commands, old_md5)
WHERE t.zone_id = v.zone_id
  AND t.id = v.id
  AND md5(t.commands) = v.old_md5
  AND t.commands IS DISTINCT FROM v.commands;

COMMIT;
