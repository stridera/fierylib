-- Quest-var nil safety: comparisons of get_quest_var (nil when unset) against a number or "" get an `or 0` / `or ""` default, so the not-started branches run (scripts/fix_quest_var_nil_compare.py).
-- APPLY AFTER 2026-10-15-r11b-trigger-fixes.sql: the md5 guards are the bodies at fierylib 1eb3a7c (post-r11b).
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
        local attack_increase = actor:get_quest_var("hell_trident:attack_counter") + 1
        actor:set_quest_var("hell_trident", "attack_counter", attack_increase)
        if (actor:get_quest_var("hell_trident:attack_counter") or 0) >= 666 then
            actor:set_quest_var("hell_trident", "helltask1", 1)
            actor:set_quest_var("hell_trident", "attack_counter", 0)
            actor:send("<b:red>You have made sufficient blood offerings with " .. tostring(self.shortdesc) .. "!</>")
        end
    end
end$trig$, '7147816b73b70162eaa681ea817bc998'),
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
            local total = boots + cloak + ring
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
return _return_value$trig$, 'f6d4a87fd4d67b555cd68a1f236e6beb'),
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
                    local total = 10 - num_spices
                    actor:send("Bring " .. tostring(total) .. " more spices to prepare the stew.")
                end
            end
        end
    end
end
return _return_value$trig$, '6e73cea953c476c2f4050707423c4d3c'),
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
        local given = got_hands + got_feet + got_wrist + got_head + got_arms + got_legs + got_body
        given = given + hands_count + feet_count + wrist_count + head_count + arms_count + legs_count + body_count
        local unrewarded = (got_hands + hands_count  ~=  4) + (got_feet + feet_count  ~=  4) + (got_wrist + wrist_count  ~=  4)
        unrewarded = unrewarded + (got_head + head_count  ~=  4) + (got_arms + arms_count  ~=  4)
        unrewarded = unrewarded + (got_legs + legs_count  ~=  4) + (got_body + body_count  ~=  4)
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
return _return_value$trig$, '967989c3b106ab950a7e951b9460b092'),
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
        local given = got_hands + got_feet + got_wrist + got_head + got_arms + got_legs + got_body
        given = given + hands_count + feet_count + wrist_count + head_count + arms_count + legs_count + body_count
        local unrewarded = (got_hands + hands_count  ~=  4) + (got_feet + feet_count  ~=  4) + (got_wrist + wrist_count  ~=  4)
        unrewarded = unrewarded + (got_head + head_count  ~=  4) + (got_arms + arms_count  ~=  4)
        unrewarded = unrewarded + (got_legs + legs_count  ~=  4) + (got_body + body_count  ~=  4)
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
return _return_value$trig$, 'ce28928a203b4cb2588265e9f6800832'),
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
        local given = got_hands + got_feet + got_wrist + got_head + got_arms + got_legs + got_body
        given = given + hands_count + feet_count + wrist_count + head_count + arms_count + legs_count + body_count
        local unrewarded = (got_hands + hands_count  ~=  4) + (got_feet + feet_count  ~=  4) + (got_wrist + wrist_count  ~=  4)
        unrewarded = unrewarded + (got_head + head_count  ~=  4) + (got_arms + arms_count  ~=  4)
        unrewarded = unrewarded + (got_legs + legs_count  ~=  4) + (got_body + body_count  ~=  4)
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
return _return_value$trig$, 'f0a1eece717598a80be7588587ff3ec5'),
  -- data/triggers/004/004_14_relocate_progress_journal.lua
  (4, 14, $trig$-- Converted from DG Script #414: Relocate progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if string.find(arg, "relocate") or string.find(arg, "relocate_spell_quest") then
    local relocateclasses = "Sorcerer Cryomancer Pyromancer"
    if (string.find(string.lower(relocateclasses), actor.class, 1, true)) and actor.level >= 60 then
        _return_value = true
        local stage = actor:get_quest_stage("relocate_spell_quest")
        actor:send("<b:u:green>Relocate</>")
        actor:send("Minimum Level: 65")
        local status
        if actor:get_has_completed("relocate_spell_quest") then
            status = "Completed!"
        elseif (stage or 0) > 0 then
            status = "In Progress"
        else
            status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
        if stage > 0 and not actor:get_has_completed("relocate_spell_quest") then
            local master1 = mobiles.template(492, 50).name .. " in the Black Ice Desert"
            local master2 = mobiles.template(492, 51).name
            -- switch on stage
            local next, place, master
            do
                local _sw1 = string.lower(tostring(stage or ""))
                if tonumber(_sw1) == 1 or tonumber(_sw1) == 2 then
                    next = "the Staff of the Mystics"
                    place = "a druid hiding out beyond Anlun Vale"
                    master = master1
                elseif tonumber(_sw1) == 3 or tonumber(_sw1) == 4 then
                    if (actor:get_quest_var("relocate_spell_quest:greet") or 0) == 0 then
                        next = "the Crystal Telescope"
                        place = "an observer of the cold village"
                        master = master1
                    else
                        next = "a glass globe"
                        place = "the Valley of the Frost Elves"
                        master = master2
                    end
                elseif tonumber(_sw1) == 5 then
                    next = "the Crystal Telescope"
                    master = master1
                elseif tonumber(_sw1) == 6 then
                    next = "a silver-trimmed spellbook"
                    place = "a tower within a destroyed land"
                    master = master1
                elseif tonumber(_sw1) == 7 then
                    next = "a map"
                    place = "from a mapper in South Caelia"
                    master = master1
                elseif tonumber(_sw1) == 8 or tonumber(_sw1) == 9 then
                    next = "the Golden Quill"
                    place = "the forest near Baba Yaga's hut"
                    master = master1
                end
            end
            actor:send("Quest Master: " .. tostring(master))
            actor:send("</>")
            if stage ~= 2 and stage ~= 4 and stage ~= 5 and stage ~= 9 then
                actor:send("You are trying to retrieve:")
                actor:send("<b:yellow>" .. tostring(next) .. "</> from <b:green>" .. tostring(place) .. ".</>")
            else
                actor:send("Return <b:yellow>" .. tostring(next) .. "</> to " .. tostring(master) .. ".")
            end
        end
    end
end
return _return_value$trig$, 'a4f3278ead2cc931a5a5b30f11b898b3'),
  -- data/triggers/004/004_18_twisted_sorrow_progress_journal.lua
  (4, 18, $trig$-- Converted from DG Script #418: Twisted Sorrow progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if string.find(arg, "twisted") or string.find(arg, "sorrow") or string.find(arg, "twisted_sorrow") or string.find(arg, "twisted forest quest") then
    _return_value = true
    actor:send("<b:u:green>Twisted Sorrow</>")
    actor:send("Recommended Level: 10")
    local status
    if actor:get_has_completed("twisted_sorrow") then
        status = "Completed!"
    elseif actor:get_quest_stage("twisted_sorrow") > 0 then
        status = "In Progress"
    else
        status = "Not Started"
    end
    actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
    local luck = actor:get_quest_var("twisted_sorrow:satisfied_tree:12016")
    local reverence = actor:get_quest_var("twisted_sorrow:satisfied_tree:12017")
    local reliance = actor:get_quest_var("twisted_sorrow:satisfied_tree:12018")
    local nimbleness = actor:get_quest_var("twisted_sorrow:satisfied_tree:12014")
    local kindness = actor:get_quest_var("twisted_sorrow:satisfied_tree:12046")
    local tree1 = get_room("12016")
    local tree2 = get_room("12017")
    local tree3 = get_room("12018")
    local tree4 = get_room("12014")
    local tree5 = get_room("12046")
    if actor:get_quest_stage("twisted_sorrow") == 1 then
        actor:send("Quest Master: " .. tostring(mobiles.template(302, 14).name))
        actor:send("</>")
        actor:send("Bring drink to awaken the trees from the corruption.")
        if (luck or 0) == 1 or (reverence or 0) == 1 or (reliance or 0) == 1 or (nimbleness or 0) == 1 or (kindness or 0) == 1 then
            actor:send("</>")
            actor:send("You have already awakened the following trees:")
            if (luck or 0) == 1 then
                actor:send("- <b:black>" .. tostring(tree1.name) .. "</>")
            end
            if (reverence or 0) == 1 then
                actor:send("- <b:black>" .. tostring(tree2.name) .. "</>")
            end
            if (reliance or 0) == 1 then
                actor:send("- <b:black>" .. tostring(tree3.name) .. "</>")
            end
            if (nimbleness or 0) == 1 then
                actor:send("- <b:black>" .. tostring(tree4.name) .. "</>")
            end
            if (kindness or 0) == 1 then
                actor:send("- <b:black>" .. tostring(tree5.name) .. "</>")
            end
        end
        actor:send("</>")
        actor:send("Offerings are still needed for:")
        if (luck or 0) == 0 then
            actor:send("- <green>" .. tostring(tree1.name) .. "</>")
        end
        if (reverence or 0) == 0 then
            actor:send("- <green>" .. tostring(tree2.name) .. "</>")
        end
        if (reliance or 0) == 0 then
            actor:send("- <green>" .. tostring(tree3.name) .. "</>")
        end
        if (nimbleness or 0) == 0 then
            actor:send("- <green>" .. tostring(tree4.name) .. "</>")
        end
        if (kindness or 0) == 0 then
            actor:send("- <green>" .. tostring(tree5.name) .. "</>")
        end
        actor:send("</>")
        actor:send("Say \"follow me\" to the hooded druid when you have an offering to present.")
    end
end
return _return_value$trig$, '1def114c30dded092fff9baa9517e977'),
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
                local wards_left = 5 - actor:get_quest_var("major_globe_spell:ward_count")
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
return _return_value$trig$, '8c820649e790f91a61e095b2f1e9e1e0'),
  -- data/triggers/004/004_21_sacred_haven_progress_journal.lua
  (4, 21, $trig$-- Converted from DG Script #421: Sacred Haven progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if string.find(arg, "infiltrate the sacred haven") or string.find(arg, "sacred_haven") or string.find(arg, "infiltrate_the_sacred_haven") or string.find(arg, "sacred haven") or string.find(arg, "haven") then
    if actor.level >= 25 then
        _return_value = true
        local stage = actor:get_quest_stage("sacred_haven")
        actor:send("<b:u:green>Infiltrate the Sacred Haven</>")
        actor:send("This quest is only available to neutral and evil-aligned characters.")
        actor:send("This quest is infinitely repeatable.")
        actor:send("Recommended Level: 35")
        local status
        if (stage or 0) > 0 then
            status = "In Progress"
        else
            status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
        if (stage or 0) > 0 then
            actor:send("Quest Master: " .. tostring(mobiles.template(590, 29).name))
            actor:send("</>")
            local light = actor:get_quest_var("sacred_haven:given_light")
            local key = actor:get_quest_var("sacred_haven:find_key")
            local blood = actor:get_quest_var("sacred_haven:given_blood")
            local trinket = actor:get_quest_var("sacred_haven:given_trinket")
            local earring = actor:get_quest_var("sacred_haven:given_earring")
            if stage == 1 and (light or 0) == 0 then
                actor:send("Prove yourself.  Bring " .. tostring(objects.template(590, 26).name) .. " from a priest on the second floor of the Haven.")
            elseif stage == 1 and (light or 0) == 1 then
                actor:send("Ask the figure about their artifacts.")
            elseif stage == 2 and (key or 0) == 0 then
                actor:send("Break the figure's ally out of jail.")
            elseif stage == 2 and (key or 0) == 1 then
                actor:send("Find the key the prisoner stashed in the Haven courtyard.")
            elseif stage == 2 and (key or 0) == 2 then
                actor:send("Bring " .. tostring(mobiles.template(590, 29).name) .. " their artifacts.")
                if blood or trinket or earring then
                    actor:send("</>")
                    actor:send("You have brought:")
                    if (blood or 0) == 1 then
                        actor:send("- " .. tostring(objects.template(590, 28).name))
                    end
                    if (trinket or 0) == 1 then
                        actor:send("- " .. tostring(objects.template(590, 29).name))
                    end
                    if (earring or 0) == 1 then
                        actor:send("- " .. tostring(objects.template(590, 30).name))
                    end
                end
                actor:send("</>")
                actor:send("You still need to find:")
                if (blood or 0) == 0 then
                    actor:send("- " .. tostring(objects.template(590, 28).name))
                end
                if (trinket or 0) == 0 then
                    actor:send("- " .. tostring(objects.template(590, 29).name))
                end
                if (earring or 0) == 0 then
                    actor:send("- " .. tostring(objects.template(590, 30).name))
                end
            end
        end
    end
end
return _return_value$trig$, '3e2d1b988dfe735e248bdb3f12bb3ef0'),
  -- data/triggers/004/004_24_rhell_forest_progress_journal.lua
  (4, 24, $trig$-- Converted from DG Script #424: Rhell Forest progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if string.find(arg, "rhell") or string.find(arg, "forest") or string.find(arg, "mystery") or string.find(arg, "ursa_quest") or string.find(arg, "mystery_of_the_rhell_forest") then
    if actor.level >= 35 then
        _return_value = true
        local stage = actor:get_quest_stage("ursa_quest")
        local path = actor:get_quest_var("ursa_quest:choice")
        actor:send("<b:u:green>Mystery of the Rhell Forest</>")
        actor:send("Find the sick merchant in the Rhell Forest and help end his distress.")
        actor:send("Recommended Level: 45")
        local status
        if actor:get_has_completed("ursa_quest") then
            status = "Completed!"
        elseif (stage or 0) > 0 then
            status = "In Progress"
        else
            status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
        if stage > 0 and not actor:get_has_completed("ursa_quest") then
            actor:send("Quest Master: " .. tostring(mobiles.template(625, 6).name))
            actor:send("</>")
            actor:send("The merchant told you:")
            -- switch on stage
            do
                local _sw1 = string.lower(tostring(stage or ""))
                local _run1 = false
                repeat
                    if _run1 or tonumber(_sw1) == 1 then
                        _run1 = true
                        if not path then
                            actor:send("Please visit one of these powerful people, and ask for a cure:")
                            actor:send("</>")
                            actor:send("- The Emperor, on a nearby island of very refined people")
                            actor:send("- Ruin Wormheart in the Red City")
                            actor:send("- The crazy hermit of the swamps")
                        else
                            actor:send("Return with the cure.")
                        end
                    end
                    if _run1 or tonumber(_sw1) == 2 then
                        _run1 = true
                        if (path or 0) == 1 then
                            actor:send("Please bring me some pepper.  Prices are always cheapest up near Anduin.")
                        elseif (path or 0) == 2 then
                            actor:send("Return to me a particular sceptre of gold that symbolized a king's undying leadership.")
                        elseif (path or 0) == 3 then
                            actor:send("A devourer has a ring with power to heal.  Please bring me this ring.")
                        end
                        break
                    end
                    if _run1 or tonumber(_sw1) == 3 then
                        _run1 = true
                        if (path or 0) == 1 then
                            actor:send("Please bring me a plant, found as \"a bit of bones and plants\" from Blue-Fog Trail.")
                        elseif (path or 0) == 2 then
                            actor:send("Please bring me an emblem of a king's power.  An emblem of the sun.  The one written of in legends of the warring gods in the far north.")
                        elseif (path or 0) == 3 then
                            actor:send("Find the Golhen DrubStatt or whatever that the hermit wrote about from the Highlands, and bring it back to me quickly.")
                        end
                        break
                    end
                    if _run1 or tonumber(_sw1) == 4 then
                        _run1 = true
                        if (path or 0) == 1 then
                            actor:send("I need a particular thorny wood.  Because of it's unpleasant nature there are some unpleasant people that make staves and walking sticks out of it.  Please find one, and bring it back here.")
                        elseif (path or 0) == 2 then
                            actor:send("Please bring be the dagger that radiates glorious light.  The priests of South Caelia know its fierce beauty.")
                        elseif (path or 0) == 3 then
                            actor:send("Bring me milk, in any container.")
                        end
                        break
                    end
                    if _run1 or tonumber(_sw1) == 5 then
                        _run1 = true
                        if (path or 0) == 1 then
                            actor:send("Bring me a pitcher from the hot springs or the Dancing Dolphin Inn.  Either will do.")
                        elseif (path or 0) == 2 then
                            actor:send("I can't do this sober!  Fetch me something to drink, and make it strong!")
                        elseif (path or 0) == 3 then
                            actor:send("Off of the great road is a lumber mill.  Their smith has an anvil that will do our work perfectly.  Please fetch it for me.")
                        end
                        break
                    end
                    if _run1 or tonumber(_sw1) == 6 then
                        _run1 = true
                        if (path or 0) == 2 then
                            actor:send("I need a large container for a sarcophagus, like a body-bag or a large chest.")
                        end
                    end
                until true
            end
        end
    end
end
return _return_value$trig$, '2f3edc52327888116c83dae4b037cb7e'),
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
                        local xeg = (2 - target2)
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
return _return_value$trig$, '2b0e7a56207c6d1f08ea05d2e5226323'),
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
                        local total = 6 - actor:get_quest_var("group_heal:total")
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
                        local total = (5 - actor:get_quest_var("group_heal:total"))
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
return _return_value$trig$, '16431f701857cf06de980e82416a3ed1'),
  -- data/triggers/004/004_28_supernova_progress_journal.lua
  (4, 28, $trig$-- Converted from DG Script #428: Supernova progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if string.find(arg, "supernova") or string.find(arg, "nova") then
    if actor.level >= 85 and string.find(actor.class, "pyromancer") then
        _return_value = true
        local stage = actor:get_quest_stage("supernova")
        actor:send("<b:u:green>Supernova</>")
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
                if (clue or 0) == 4318 then
                    actor:send("Recently, she was spotted in Anduin, taking in a show from the best seat in the house.")
                elseif (clue or 0) == 10316 then
                    actor:send("I understand she frequents the hottest spring at the popular resort up north.")
                elseif (clue or 0) == 58062 then
                    actor:send("She occasionally visits a small remote island theatre, where she enjoys meditating in their reflecting room.")
                end
                actor:send("Find further clues to Phayla's whereabouts.")
                actor:send("</>")
                -- switch on actor:get_quest_var("supernova:step4")
                local clue2
                if (actor:get_quest_var("supernova:step4") or 0) == 18577 then
                    clue2 = "I continue my journey where the sun rises amidst a sea of swirling worlds."
                    -- The Abbey, the rising sun room
                elseif (actor:get_quest_var("supernova:step4") or 0) == 17277 then
                    clue2 = "Atop a tower I visit a master who waits to give his final examination."
                    -- Citadel of Testing
                elseif (actor:get_quest_var("supernova:step4") or 0) == 8561 then
                    clue2 = "I study in a secret place above a hall of misery beyond a gallery of horrors."
                    -- Cathedral of Betrayal near Norisent
                end
                -- end clue2 switch
                actor:send("Find yet another clue to Phayla's whereabouts.")
                actor:send("</>")
                -- switch on actor:get_quest_var("supernova:step5")
                local clue3
                if (actor:get_quest_var("supernova:step5") or 0) == 53219 then
                    clue3 = "Where DID the lizard men get that throne from?  I'll see if I can find out."
                    -- Lizard King's throne room, Sunken
                elseif (actor:get_quest_var("supernova:step5") or 0) == 47343 then
                    clue3 = "They often wonder what would happen if bones could talk.  I'll ask one who can make that happen!"
                    -- Kryzanthor, Graveyard
                elseif (actor:get_quest_var("supernova:step5") or 0) == 16278 then
                    clue3 = "Waves of sand hold the remains of a child of the Sun God.  Supposedly.  I'll have to see for myself."
                    -- Imanhotep, Pyramid
                end
                -- end clue3 switch
                actor:send("Solve the riddle to deduce the location of the gateway to Phayla's realm.")
                actor:send("</>")
                local step7 = actor:get_quest_var("supernova:step7")
                -- switch on actor:get_quest_var("supernova:step6")
                if (actor:get_quest_var("supernova:step6") or 0) == 58657 then
                    -- A Hummock of Grass in the Beachhead
                    local clue4
                    if (step7 or 0) == 1 then
                        clue4 = "s pfqzqgc wq kecwk qy xug fwinlugev"
                    elseif (step7 or 0) == 2 then
                        clue4 = "d hlwzsuc rf xbnwk aq tyo oisukhvkq"
                    elseif (step7 or 0) == 3 then
                        clue4 = "s oidfgjy fy yyojl au hyx tlotazlou"
                    end
                elseif (actor:get_quest_var("supernova:step6") or 0) == 35119 then
                    -- A Pile of Stones in the Brush Lands
                    local clue4
                    if (step7 or 0) == 1 then
                        clue4 = "s xtpr qj kbzrru mf bsi otykp weafw"
                    elseif (step7 or 0) == 2 then
                        clue4 = "d pzvr sx kwoeof mf lke sbhwz ddnuc"
                    elseif (step7 or 0) == 3 then
                        clue4 = "s wwcx gm gkhflg zg los skmzv ctfkg"
                    end
                elseif (actor:get_quest_var("supernova:step6") or 0) == 55422 then
                    -- The Trail Overlooking the Falls in the dark mountains
                    local clue4
                    if (step7 or 0) == 1 then
                        clue4 = "lpp xecmd wgiensgstrt vlw nlpyu mf bsi qcvc uzyaveavd"
                    elseif (step7 or 0) == 2 then
                        clue4 = "whv deead ovvbysgclnx dui xsolj sa xzw gaiu zsmfwazxf"
                    elseif (step7 or 0) == 3 then
                        clue4 = "los kkspz fowyzfhcpbx mzl tredz we mzl rrkc tclglhwel"
                    end
                end
                -- end clue4 switch
                -- switch on step7
                local clue5
                if (step7 or 0) == 1 then
                    clue5 = "What disappears as soon as you say its name?"
                    -- Answer: Silence
                elseif (step7 or 0) == 2 then
                    clue5 = "The more there is, the less you see. What am I?"
                    -- Answer: Darkness
                elseif (step7 or 0) == 3 then
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
return _return_value$trig$, 'ed8a8b7f0e9f92a38ed3f68816603738'),
  -- data/triggers/004/004_29_meteorswarm_progress_journal.lua
  (4, 29, $trig$-- Converted from DG Script #429: Meteorswarm progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if string.find(arg, "meteor") or string.find(arg, "meteorswarm") then
    if (string.find(actor.class, "sorcerer") and actor.level >= 65) or (string.find(actor.class, "pyromancer") and actor.level >= 75) then
        _return_value = true
        local stage = actor:get_quest_stage("meteorswarm")
        actor:send("<b:u:green>Meteorswarm</>")
        if string.find(actor.class, "sorcerer") then
            actor:send("Minimum Level: 73")
        elseif string.find(actor.class, "pyromancer") then
            actor:send("Minimum Level: 81")
        end
        local status
        if actor:get_has_completed("meteorswarm") then
            status = "Completed!"
        elseif (stage or 0) > 0 then
            status = "In Progress"
        else
            status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
        if stage > 0 and not actor:get_has_completed("meteorswarm") then
            actor:send("Quest Master: " .. tostring(mobiles.template(481, 150).name))
            actor:send("</>")
            if actor:get_quest_var("meteorswarm:new") ~= yes then
                actor:send("Go find a new meteorite.")
                return _return_value
            elseif actor:get_quest_var("meteorswarm:new") ~= no then
                actor:send("Bring the new meteorite to McCabe.")
                return _return_value
            end
            -- switch on stage
            local task
            do
                local _sw1 = string.lower(tostring(stage or ""))
                if tonumber(_sw1) == 1 then
                    task = "Find Jemnon and ask about the rock demon.  McCabe said, \"He's in some tavern, no doubt, waiting for some new blunder to embark on.\""
                elseif tonumber(_sw1) == 2 then
                    task = "Find a suitable meteor focus from the rock demon in Templace."
                elseif tonumber(_sw1) == 3 then
                    if (actor:get_quest_var("meteorswarm:earth") or 0) == 0 then
                        task = "Show him the meteorite."
                    else
                        if (actor:get_quest_var("meteorswarm:fire") or 0) == 0 then
                            task = "Find and kill the high fire priest in the Lava Tunnels.  Then enter the lava bubble below his secret chambers."
                        else
                            task = "Find the lava bubble in the high fire priest's secret chambers."
                        end
                    end
                elseif tonumber(_sw1) == 4 then
                    if (actor:get_quest_var("meteorswarm:fire") or 0) == 1 then
                        task = "Return to McCabe."
                    elseif (actor:get_quest_var("meteorswarm:fire") or 0) == 2 then
                        task = "Convince the ancient dragon Dargentan to teach you the ways of air magic."
                    end
                elseif tonumber(_sw1) == 5 then
                    if (actor:get_quest_var("meteorswarm:air") or 0) == 0 then
                        task = "Show him the meteorite now that you have mastered earth, fire, and air."
                    else
                        task = "Take your finished focus and unleash its potential!"
                    end
                end
            end
            actor:send("McCabe wants you to:")
            actor:send(tostring(task))
            if actor:get_quest_var("meteorswarm:earth") then
                actor:send("</>")
                actor:send("If you somehow lost the meteorite, return to McCabe and say <b:red>\"I lost <b:red>the meteorite\"</>.")
            end
        end
    end
end
return _return_value$trig$, '8f8a04940c7fd21fa2037a4d518dbddc'),
  -- data/triggers/004/004_30_banish_progress_journal.lua
  (4, 30, $trig$-- Converted from DG Script #430: Banish progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if string.find(arg, "banish") then
    if actor.level >= 50 and (string.find(actor.class, "priest") or string.find(actor.class, "diabolist")) then
        _return_value = true
        local stage = actor:get_quest_stage("banish")
        local master = mobiles.template(302, 16).name
        actor:send("<b:u:green>Banish</>")
        actor:send("Minimum Level: 65")
        local status
        if actor:get_has_completed("banish") then
            status = "Completed!"
        elseif (stage or 0) > 0 then
            status = "In Progress"
        else
            status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
        if stage > 0 and not actor:get_has_completed("banish") then
            actor:send("Quest Master: " .. tostring(master))
            actor:send("</>")
            -- switch on stage
            local known
            do
                local _sw1 = string.lower(tostring(stage or ""))
                if tonumber(_sw1) == 1 then
                    local mob = 41119
                    local place = "her chamber under the ocean waves"
                    known = "Nothing."
                elseif tonumber(_sw1) == 2 then
                    local mob = 53313
                    local place = "the frozen tunnels of the north"
                    known = "v"
                elseif tonumber(_sw1) == 3 then
                    local mob = 37000
                    local place = "a deep and ancient mine"
                    known = "vi"
                elseif tonumber(_sw1) == 4 then
                    local mob = 48005
                    local place = "a room filled with art in an ancient barrow"
                    known = "vib"
                elseif tonumber(_sw1) == 5 then
                    local mob = 53417
                    local place = "the cold valley of the far north"
                    known = "vibu"
                elseif tonumber(_sw1) == 6 then
                    local mob = 23811
                    local place = "a nearby fortress of clouds and crystals"
                    known = "vibug"
                elseif tonumber(_sw1) == 7 then
                    actor:send("Return to " .. tostring(mobiles.template(302, 16).name) .. " and speak the prayer aloud: <b:magenta>vibugp</>")
                    return _return_value
                end
            end
            if (actor:get_quest_var("banish:greet") or 0) == 1 then
                actor:send("To learn Banish you must next kill " .. "%get.mob_shortdesc[%mob%]% in %place%.")
            else
                actor:send("Return to " .. tostring(master) .. " for further instruction.")
            end
            actor:send("</>")
            actor:send("</>Your knowledge of the prayer so far: <b:cyan>" .. tostring(known) .. "</>")
        end
    end
end
return _return_value$trig$, '4fd4ef89840cf825bd4f70329be57f95'),
  -- data/triggers/004/004_31_the_great_rite_progress_journal.lua
  (4, 31, $trig$-- Converted from DG Script #431: The Great Rite progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if string.find(arg, "great") or string.find(arg, "rite") or string.find(arg, "the great rite") or string.find(arg, "megalith") or string.find(arg, "megalith_quest") or string.find(arg, "the_great_rite") or string.find(arg, "sacred megalith quest") or string.find(arg, "sacred_megalith_quest") or string.find(arg, "sacred megalith") then
    if actor.level >= 50 then
        _return_value = true
        local stage = actor:get_quest_stage("megalith_quest")
        local job1 = actor:get_quest_var("megalith_quest:item1")
        local job2 = actor:get_quest_var("megalith_quest:item2")
        local job3 = actor:get_quest_var("megalith_quest:item3")
        local job4 = actor:get_quest_var("megalith_quest:item4")
        actor:send("<b:u:green>The Great Invocation</>")
        actor:send("A group of witches has uncovered a powerful set of massive standing stones.")
        actor:send("Help them with their mystic ritual.")
        actor:send("Recommended Level: 70")
        actor:send("- This quest can be started at any level but requires level 70 to finish.")
        local status
        if actor:get_has_completed("megalith_quest") then
            status = "Completed!"
        elseif actor:get_has_failed("megalith_quest") then
            status = "Failed"
        elseif (stage or 0) > 0 then
            status = "In Progress"
        else
            status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
        if (stage > 0 and not actor:get_has_completed("megalith_quest")) or actor:get_has_failed("megalith_quest") then
            local master = mobiles.template(123, 1).name
            -- switch on stage
            local task, item1, item2, item3, item4, receive1, receive2, receive3, receive4
            do
                local _sw1 = string.lower(tostring(stage or ""))
                if tonumber(_sw1) == 1 then
                    task = "Replace the sacred prophetic implements."
                    -- salt 23756
                    item1 = "salt"
                    -- Goblet or chalice 41110 or 41111 or 18512
                    item2 = "a goblet or chalice"
                    -- censer 8507 or 17300
                    item3 = "a censer"
                    -- candles 8612 or 58809
                    item4 = "candles"
                    -- give to the priestess
                elseif tonumber(_sw1) == 2 then
                    -- 
                    -- Must be done East South West North
                    -- 
                    -- thin sheet of cloud to Keeper of the East
                    receive1 = mobiles.template(123, 5).name
                    item1 = objects.template(83, 1).name
                    -- the fiery eye to Keeper of the South
                    receive2 = mobiles.template(123, 4).name
                    item2 = objects.template(481, 9).name
                    -- water from room 12463 to Keeper of the West
                    receive3 = mobiles.template(123, 6).name
                    item3 = "water from " .. tostring(objects.template(123, 52).name)
                    -- granite ring to Keeper of the North
                    receive4 = mobiles.template(123, 3).name
                    item4 = objects.template(550, 20).name
                    if job1 and job2 and job3 and job4 then
                        task = "Finish calling the elements!  Return to " .. tostring(mobiles.template(123, 1).name) .. " and say \"<b:white>Under the watchful eye of Earth, Air, Fire, and Water, we awaken this hallowed ground!</>\""
                    else
                        task = "Visit the Keepers and call the elements"
                        master = nil
                        master = "The Keepers of East, South, West, and North"
                    end
                elseif tonumber(_sw1) == 3 then
                    task = "Locate three holy reliquaries."
                    item1 = "a holy prayer bowl"
                    item2 = "a piece of a goddess's regalia"
                    item3 = "a faerie relic from the land of the Reverie made manifest"
                elseif tonumber(_sw1) == 4 then
                    local prayer = actor:get_quest_var("megalith_quest:prayer")
                    local summon = actor:get_quest_var("megalith_quest:summon")
                    local invoke = actor:get_quest_var("megalith_quest:invoke")
                    if (prayer or 0) == 1 then
                        task = "Return to " .. tostring(master) .. " and say, \"<b:white>Great Lady of the Stars, hear our prayer!</>\""
                    elseif (summon or 0) == 1 or (summon or 0) == 2 or (summon or 0) == 3 then
                        task = "Return to " .. tostring(master) .. " and say, \"<b:white>We summon and stir thee!</>\""
                    elseif (invoke or 0) == 1 or (invoke or 0) == 2 or (invoke or 0) == 3 then
                        task = "Return to " .. tostring(master) .. " and say, \"<b:white>We invoke thee!</>\""
                    end
                elseif tonumber(_sw1) == 5 then
                    task = "Kneel before the High Mother to receive Her blessing."
                end
            end
            actor:send("Quest Master: " .. tostring(master))
            actor:send("</>")
            if actor:get_has_failed("megalith_quest") then
                actor:send("Return to " .. tostring(master) .. " and ask to try again.")
                return _return_value
            else
                actor:send(tostring(task))
            end
            if stage < 4 then
                -- list items already given
                if job1 or job2 or job3 or job4 then
                    actor:send("</>")
                    actor:send("You have already retrieved:")
                    if job1 then
                        actor:send("- <b:white>" .. tostring(item1) .. "</>")
                    end
                    if job2 then
                        actor:send("- <b:white>" .. tostring(item2) .. "</>")
                    end
                    if job3 then
                        actor:send("- <b:white>" .. tostring(item3) .. "</>")
                    end
                    if job4 then
                        actor:send("- <b:white>" .. tostring(item4) .. "</>")
                    end
                end
                -- list items to be returned
                actor:send("</>")
                if stage == 2 then
                    if not job1 then
                        actor:send("Assist <b:white>" .. tostring(receive1) .. "</>.")
                        if actor:get_quest_var("megalith_quest:east") then
                            actor:send("She needs " .. tostring(item1) .. ".  Help her first.")
                        else
                            actor:send("Check with her to see what she needs.")
                        end
                        actor:send("</>")
                    end
                    if not job2 then
                        actor:send("Assist <b:red>" .. tostring(receive2) .. "</>.")
                        if actor:get_quest_var("megalith_quest:south") then
                            actor:send("She needs " .. tostring(item2) .. ".  Help her second.")
                        else
                            actor:send("Check with her to see what she needs.")
                        end
                        actor:send("</>")
                    end
                    if not job3 then
                        actor:send("Assist <b:cyan>" .. tostring(receive3) .. "</>.")
                        if actor:get_quest_var("megalith_quest:west") then
                            actor:send("She needs " .. tostring(item3) .. ".  Help her third.")
                        else
                            actor:send("Check with her to see what she needs.")
                        end
                        actor:send("</>")
                    end
                    if not job4 then
                        actor:send("Assist <b:green>" .. tostring(receive4) .. "</>.")
                        if actor:get_quest_var("megalith_quest:north") then
                            actor:send("She needs " .. tostring(item4) .. ".  Help her last.")
                        else
                            actor:send("Check with her to see what she needs.")
                        end
                        actor:send("</>")
                    end
                else
                    actor:send("You still need to retrieve:")
                    if not job1 then
                        actor:send("- <b:white>" .. tostring(item1) .. "</>")
                    end
                    if not job2 then
                        actor:send("- <b:white>" .. tostring(item2) .. "</>")
                    end
                    if not job3 then
                        actor:send("- <b:white>" .. tostring(item3) .. "</>")
                    end
                    if stage == 1 then
                        if not job4 then
                            actor:send("- <b:white>" .. tostring(item4) .. "</>")
                        end
                    end
                end
            end
        end
    end
end
return _return_value$trig$, 'a87324de0c844a40f9af0e0990894010'),
  -- data/triggers/004/004_37_flood_progress_journal.lua
  (4, 37, $trig$-- Converted from DG Script #437: Flood progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if string.find(arg, "flood") then
    if string.find(actor.class, "cryomancer") and actor.level >= 75 then
        _return_value = true
        local stage = actor:get_quest_stage("flood")
        actor:send("<b:u:green>Flood</>")
        actor:send("Minimum Level: 81")
        local status
        if actor:get_has_completed("flood") then
            status = "Completed!"
        elseif (stage or 0) > 0 then
            status = "In Progress"
        else
            status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
        if stage > 0 and not actor:get_has_completed("flood") then
            actor:send("Quest Master: " .. tostring(mobiles.template(390, 12).name))
            actor:send("</>")
            if stage == 1 then
                local fog = "The Blue-Fog"
                local phoenix = "Phoenix Feather Hot Springs"
                local falls = "Three-Falls River"
                local green = "The Greengreen Sea"
                local witch = "Sea's Lullaby"
                local frost = "Frost Lake"
                local black = "The Black Lake"
                local kod = "The Dreaming River"
                local water1 = actor:get_quest_var("flood:water1")
                local water2 = actor:get_quest_var("flood:water2")
                local water3 = actor:get_quest_var("flood:water3")
                local water4 = actor:get_quest_var("flood:water4")
                local water5 = actor:get_quest_var("flood:water5")
                local water6 = actor:get_quest_var("flood:water6")
                local water7 = actor:get_quest_var("flood:water7")
                local water8 = actor:get_quest_var("flood:water8")
                local item2 = actor:get_quest_var("flood:item2")
                local item3 = actor:get_quest_var("flood:item3")
                local item4 = actor:get_quest_var("flood:item4")
                local item6 = actor:get_quest_var("flood:item6")
                local item7 = actor:get_quest_var("flood:item7")
                actor:send("Rally the Great Waters of Ethilien for " .. tostring(mobiles.template(390, 12).name) .. ".")
                actor:send("</>")
                if water1 or water2 or water3 or water4 or water5 or water6 or water7 or water8 then
                    actor:send("You have rallied:")
                    if water1 then
                        actor:send("- <blue>" .. tostring(fog) .. "</>")
                    end
                    if water2 then
                        actor:send("- <blue>" .. tostring(phoenix) .. "</>")
                    end
                    if water3 then
                        actor:send("- <blue>" .. tostring(falls) .. "</>")
                    end
                    if water4 then
                        actor:send("- <blue>" .. tostring(green) .. "</>")
                    end
                    if water5 then
                        actor:send("- <blue>" .. tostring(witch) .. "</>")
                    end
                    if water6 then
                        actor:send("- <blue>" .. tostring(frost) .. "</>")
                    end
                    if water7 then
                        actor:send("- <blue>" .. tostring(black) .. "</>")
                    end
                    if water8 then
                        actor:send("- <blue>" .. tostring(kod) .. "</>")
                    end
                    actor:send("</>")
                end
                -- list items to be returned
                actor:send("You must still convince:")
                if not water1 then
                    actor:send("- <b:blue>" .. tostring(fog) .. "</>")
                    actor:send("</>")
                end
                if not water2 then
                    actor:send("- <b:blue>" .. tostring(phoenix) .. "</>")
                    if (item2 or 0) == 1 then
                        actor:send("</>    Bring it " .. tostring(objects.template(584, 1).name) .. " to heat its springs.")
                        actor:send("</>    Say <b:blue>Spirit I have returned</> when you return.")
                    end
                    actor:send("</>")
                end
                if not water3 then
                    actor:send("- <b:blue>" .. tostring(falls) .. "</>")
                    if (item3 or 0) == 1 then
                        actor:send("</>    Find a bell and dance for them.")
                        actor:send("</>    Say <b:blue>Spirit I have returned</> when you return.")
                    end
                    actor:send("</>")
                end
                if not water4 then
                    actor:send("- <b:blue>" .. tostring(green) .. "</>")
                    if (item4 or 0) == 1 then
                        actor:send("</>    Feed her as many different foods as you can until she is full.")
                        actor:send("</>    Say <b:blue>Spirit I have returned</> when you return.")
                    end
                    actor:send("</>")
                end
                if not water5 then
                    actor:send("- <b:blue>" .. tostring(witch) .. "</>")
                    actor:send("</>")
                end
                if not water6 then
                    actor:send("- <b:blue>" .. tostring(frost) .. "</>")
                    if (item6 or 0) == 1 then
                        actor:send("</>    Force her to join the cause.")
                    end
                    actor:send("</>")
                end
                if not water7 then
                    actor:send("- <b:blue>" .. tostring(black) .. "</>")
                    if (item7 or 0) == 1 then
                        actor:send("</>    Bring it an eternal light to swallow into its blackness.")
                        actor:send("</>    Say <b:blue>Spirit I have returned</> when you return.")
                    end
                    actor:send("</>")
                end
                if not water8 then
                    actor:send("- <b:blue>" .. tostring(kod) .. "</>")
                    actor:send("</>")
                end
                actor:send("Tell them: <b:blue>the Arabel Ocean calls for aid</> and longs for <b:blue>revenge</>.")
            elseif stage ==2 then
                actor:send("Return the Heart of the Ocean to " .. tostring(mobiles.template(390, 12).name) .. "!")
            end
            actor:send("</>")
            actor:send("If you lost the Heart, say <b:blue>I lost the heart</>.")
        end
    end
end
return _return_value$trig$, '41c4fa34d39cb959971d51772f6f6251'),
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
                        local minutes = (timer / 60)
                        local seconds = timer - (minutes * 60)
                        actor:send("You have " .. tostring(minutes) .. " mins " .. tostring(seconds) .. " secs remaining to race all four winds!")
                        actor:send("</>")
                        if (north or 0) == 0 then
                            actor:send("The North Wind blows near the frozen town of Ickle.")
                        elseif (north or 0) == 1 then
                            local room = get_room("30262")
                            actor:send("Beat the North Wind to " .. tostring(room.name) .. " in Bluebonnet Pass.")
                            local minutes = (ntimer / 60)
                            local seconds = ntimer - (minutes * 60)
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
                            local minutes = (stimer / 60)
                            local seconds = stimer - (minutes * 60)
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
                            local minutes = (etimer / 60)
                            local seconds = etimer - (minutes * 60)
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
                            local minutes = (wtimer / 60)
                            local seconds = wtimer - (minutes * 60)
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
return _return_value$trig$, '687356a71c484a01163cdb8339ef33aa'),
  -- data/triggers/004/004_48_the_finale_progress_journal.lua
  (4, 48, $trig$-- Converted from DG Script #448: The Finale progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if string.find(arg, "pippin") or string.find(arg, "theatre") or string.find(arg, "theater") or string.find(arg, "finale") then
    _return_value = true
    local stage = actor:get_quest_stage("theatre")
    actor:send("<b:u:green>The Finale</>")
    actor:send("Defeat wild monkeys, recover keys, and help the theatre troupe perform their fiery Finale!")
    actor:send("Recommended Level: 10")
    if (stage or 0) > 0 then
        actor:send("<cyan>Status: Repeatable</>")
        -- switch on stage
        local master
        do
            local _sw1 = string.lower(tostring(stage or ""))
            if tonumber(_sw1) == 1 then
                master = mobiles.template(43, 51).name
            elseif tonumber(_sw1) == 2 then
                master = mobiles.template(43, 45).name
            elseif tonumber(_sw1) == 3 then
                master = mobiles.template(43, 53).name
            elseif tonumber(_sw1) == 4 then
                master = mobiles.template(43, 52).name
            elseif tonumber(_sw1) == 5 then
                master = mobiles.template(43, 11).name
            elseif tonumber(_sw1) == 6 then
                master = mobiles.template(43, 12).name
            elseif tonumber(_sw1) == 7 then
                master = mobiles.template(43, 99).name
            end
        end
        actor:send("Quest Master: " .. tostring(master))
        actor:send("</>")
        -- switch on stage
        do
            local _sw2 = string.lower(tostring(stage or ""))
            if tonumber(_sw2) == 1 then
                actor:send("Get back Catherine's dressing room key from the ceiling monkeys, then bring her her eyelashes from her dressing room.")
                if (actor:get_quest_var("theatre:lashes") or 0) == 0 then
                    actor:send("Give Catherine her eyelashes.")
                elseif (actor:get_quest_var("theatre:lashes") or 0) == 1 then
                    actor:send("Give Catherine her dressing room key.")
                end
            elseif tonumber(_sw2) == 2 then
                actor:send("Give Lewis his dressing room key.")
            elseif tonumber(_sw2) == 3 then
                actor:send("Give Fastrada her dressing room key.")
            elseif tonumber(_sw2) == 4 then
                local item1 = 4320
                local item2 = 4301
                actor:send("Give Charlemagne his dressing room key and his missing sash.")
                if (actor:get_quest_var("theatre:sash") or 0) ~= 0 or (actor:get_quest_var("theatre:charles") or 0) ~= 0 then
                    actor:send("</>")
                    actor:send("You have brought him:")
                    if (actor:get_quest_var("theatre:sash") or 0) ~= 0 then
                        actor:send("%get.obj_shortdesc[%item1%]%")
                    end
                    if (actor:get_quest_var("theatre:charles") or 0) ~= 0 then
                        actor:send("%get.obj_shortdesc[%item2%]%")
                    end
                end
                actor:send("</>")
                actor:send("You still need:")
                if (actor:get_quest_var("theatre:sash") or 0) == 0 then
                    actor:send("%get.obj_shortdesc[%item1%]%")
                end
                if (actor:get_quest_var("theatre:charles") or 0) == 0 then
                    actor:send("%get.obj_shortdesc[%item2%]%")
                end
            elseif tonumber(_sw2) == 5 then
                actor:send("Give the Fire Goddess her skirt.")
            elseif tonumber(_sw2) == 6 then
                actor:send("The Fire Goddess told you:")
                actor:send("We need to find our Pippin in order to perform the grand Finale.  He's somewhere out in the world, trying to find his corner of the sky.")
                actor:send("</>")
                actor:send("I want you to bring him to us.")
                actor:send("</>")
                actor:send("Take " .. tostring(objects.template(43, 18).name) .. ".")
                actor:send("</>")
                actor:send("Hold it in your hand when you find him.  He won't be able to resist the beauty of one perfect flame.")
                actor:send("</>")
                actor:send("Now, when you get him back here, <b:cyan>[order]</> him to <b:cyan>[enter]</> the Fire Box.  We've prepared and hidden it upstage center just for him.")
                actor:send("</>")
                actor:send("<b:red>Be careful not to get inside it yourself!</>")
                actor:send("</>")
                actor:send("It's only for an extraordinary person like Pippin.")
            elseif tonumber(_sw2) == 7 then
                actor:send("Lead Pippin back to the theatre and order him to get in the Fire Box.")
            end
        end
    else
        actor:send("<cyan>Status: Not Started</>")
    end
end
return _return_value$trig$, '6c75d9ed3f716553c5e1ae9898f42dbb'),
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
            local remaining = ((attack) - actor:get_quest_var("air_wand:attack_counter"))
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
return _return_value$trig$, '1dd9e28fdbd02884be51e74fdafbc2ab'),
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
            local remaining = ((attack) - actor:get_quest_var("fire_wand:attack_counter"))
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
return _return_value$trig$, '79e825c84413b28f898e96ba61a471b0'),
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
            local remaining = ((attack) - actor:get_quest_var("ice_wand:attack_counter"))
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
return _return_value$trig$, '1af1be4c314fc2cd28919ed862009d1c'),
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
            local remaining = ((attack) - actor:get_quest_var("acid_wand:attack_counter"))
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
return _return_value$trig$, '370d409fc71f453a0c6b925600302931'),
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
            local remaining = ((attack) - actor:get_quest_var("phase_mace:attack_counter"))
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
return _return_value$trig$, 'd920fc538e68c522bc46cc866c192c72'),
  -- data/triggers/018/018_34_blur_winds_speech.lua
  (18, 34, $trig$-- Converted from DG Script #1834: blur_winds_speech
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"yes", "sure", "yep", "okay"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end

if actor:get_quest_stage("blur") ~= 4 then
    return true
end

wait(0.2)

-- Hoist all branch-scoped locals.
local direction
local home_zone
local home_id
local color

if self.zone_id == 18 and self.local_id == 19 then  -- North Wind
    direction = "north"
    home_zone, home_id = 302, 62  -- legacy 30262
    color = "<b:green>"
    local room = get_room(home_zone, home_id)
    local rname = room and room.name or "the northern peak"
    self.room:send(tostring(self.name) .. " says, 'Then you will have to beat me to: " .. tostring(color) .. tostring(rname) .. "</>")
    self.room:send("</>in Bluebonnet Pass.'")
    self:emote("laughs mightily as it vanishes!")
    actor:set_quest_var("blur", direction, 1)
elseif self.zone_id == 18 and self.local_id == 20 then  -- South Wind
    direction = "south"
    home_zone, home_id = 535, 57  -- legacy 53557
    color = "<b:red>"
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
    color = "<b:yellow>"
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
    color = "<b:cyan>"
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
if (actor:get_quest_var("blur:" .. direction) or 0) == 2 then
    world.destroy(self)
elseif arrived then
    if (actor:get_quest_var("blur:" .. direction) or 0) == 1 then
        actor:send(tostring(self.name) .. " tells you, '" .. tostring(color) .. "Wow you're fast!  Incredible!</>'")
        actor:set_quest_var("blur", direction, 2)
        if (actor:get_quest_var("blur:east") or 0) == 2 and (actor:get_quest_var("blur:west") or 0) == 2 and (actor:get_quest_var("blur:north") or 0) == 2 and (actor:get_quest_var("blur:south") or 0) == 2 then
            skills.set_level(actor, "blur", 1000)
            wait(0.2)
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
return true$trig$, 'afb5fa07b7225bc25ba9d8f7831b9621'),
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
return _return_value$trig$, 'bcc3c822f7693a4a53f6160fc19d58d8'),
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
end$trig$, '04826f004941e5b96f1bcd20a5ea89ec'),
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
    actor:send(tostring(self.name) .. " says, 'So " .. objects.template(math.floor(item / 100), item % 100).name .. " is a <b:yellow>class " .. tostring(class) .. " tier " .. tostring(tier) .. "</> piece of gear.'")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'I'll give it to you for any other armor of equal or greater rarity.'")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'Consult the chart for degrees of rarity.'")
    actor:send(tostring(self.name) .. " points to the sign.")
else
    actor:set_quest_var("gem_exchange", "gem_id", 0)
    actor:send(tostring(self.name) .. " says, 'Alright, what DO you want then?'")
end$trig$, 'e7bf3d3ab2eab8ea82ce623035ea928d'),
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
        self.room:spawn_object(math.floor(item / 100), item % 100)
        self:command("give all " .. tostring(actor))
        wait(0.2)
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
return _return_value$trig$, '659fca7a40dd8b98ad152a302f8f22b6'),
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
if actor:get_quest_var("Black_Legion:eg_ally") then
    actor:send(tostring(self.name) .. " tells you, 'You have already chosen your side!  Be")
    actor:send("</>gone, filth!'")
    return true
end
-- This is for neutrals and evils only.
if actor.alignment <= 150 and actor.level > 9 then
    wait(0.2)
    if actor:get_quest_stage("Black_Legion") == 0 then
        actor:start_quest("Black_Legion")
        actor:set_quest_var("Black_Legion", "BL_FACTION", 0)
        actor:set_quest_var("Black_Legion", "EG_FACTION", 0)
        actor:set_quest_var("Black_Legion", "bl_ally", 1)
        -- Note that it is not necessary to initialize sub-quest
        -- variables to 0 because non-existent quest variables
        -- return the same as variables set to 0 in conditionals
    end
    if actor:get_quest_stage("Black_Legion") > 0 and (actor:get_quest_var("black_legion:bl_faction") or 0) > 99 then
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
end$trig$, '2d424417a0aae592530298dab91b0eae'),
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
            local trophies = actor:get_quest_var("black_legion:id_trophy_trophies") + 1
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
                local trophies = actor:get_quest_var("black_legion:id_trophy_trophies") + 1
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
                local faction = actor:get_quest_var("black_legion:bl_faction") + 1
                actor:set_quest_var("black_legion", "bl_faction", faction)
                -- 
                -- 
                -- slight bug for now the trigger code can't seem to evaluate negative numbers?
                -- 
                -- 
                local faction2 = actor:get_quest_var("black_legion:eg_faction") - 1
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
        if actor:get_quest_var("black_legion:bl_faction") >= faction_required then
            local rewards = actor:get_quest_var("black_legion:id_reward_reward") + 1
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
                    local faction = actor:get_quest_var("black_legion:bl_faction") + 1
                    actor:set_quest_var("black_legion", "bl_faction", faction)
                    -- 
                    -- 
                    -- slight bug for now the trigger code can't seem to evaluate negative numbers?
                    -- 
                    -- 
                    local faction2 = actor:get_quest_var("black_legion:eg_faction") - 1
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
return _return_value$trig$, '2e608f90758929bdf8345befe71b5da5'),
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
if actor:get_quest_var("Black_Legion:eg_ally") then
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
if actor.alignment <= 150 and actor:get_quest_stage("Black_Legion") > 0 then
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
end$trig$, '0355e3054d00460a89d7180f13520745'),
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
if actor:get_quest_var("Black_Legion:bl_ally") then
    actor:send(tostring(self.name) .. " tells you, 'You have pledged yourself to the forces of")
    actor:send("</>darkness!  Suffer under your choice!'")
    return true
end
if actor.alignment >= -150 then
    if actor:get_quest_stage("Black_Legion") == 0 then
        actor:start_quest("Black_Legion")
        actor:set_quest_var("Black_Legion", "BL_FACTION", 0)
        actor:set_quest_var("Black_Legion", "EG_FACTION", 0)
        actor:set_quest_var("Black_Legion", "eg_ally", 1)
        -- Note that it is not necessary to initialize sub-quest
        -- variables to 0 because non-existent quest variables
        -- return the same as variables set to 0 in conditionals
    end
    if actor:get_quest_stage("Black_Legion") > 0 and (actor:get_quest_var("black_legion:eg_faction") or 0) > 99 then
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
end$trig$, 'd7465eefc77be4f1d4d5f7833105bed7'),
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
            local trophies = actor:get_quest_var("black_legion:id_trophy_trophies") + 1
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
                local trophies = actor:get_quest_var("black_legion:id_trophy_trophies") + 1
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
                local faction = actor:get_quest_var("black_legion:eg_faction") + 1
                actor:set_quest_var("black_legion", "eg_faction", faction)
                -- 
                -- slight bug for now the trigger code can't seem to evaluate negative numbers?
                -- 
                local faction2 = actor:get_quest_var("black_legion:bl_faction") - 1
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
        if actor:get_quest_var("black_legion:eg_faction") >= faction_required then
            local rewards = actor:get_quest_var("black_legion:id_reward_reward") + 1
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
                    local faction = actor:get_quest_var("black_legion:eg_faction") + 1
                    actor:set_quest_var("black_legion", "eg_faction", faction)
                    -- 
                    -- 
                    -- slight bug for now the trigger code can't seem to evaluate negative numbers?
                    -- 
                    -- 
                    local faction2 = actor:get_quest_var("black_legion:bl_faction") - 1
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
return _return_value$trig$, 'a463b167a00c8df5cb469d39220f7f8e'),
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
if actor:get_quest_var("Black_Legion:bl_ally") then
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
if actor.alignment >= -150 and actor:get_quest_stage("Black_Legion") > 0 then
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
end$trig$, '3dc8dbf0b09294338cc2e7ee639ae86b'),
  -- data/triggers/043/043_01_catherine_key.lua
  (43, 1, $trig$-- Converted from DG Script #4301: catherine_key
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
local refuse
local accept_lashes
local accept_key
self:set_flag("sentinel", true)
if actor:get_quest_stage("theatre") >= 1 then
    if (object.zone_id == 43 and object.id == 51) then
        local person = actor
        local i = person.group_size
        local a
        if i then
            a = 1
        else
            a = 0
        end
        while i >= a do
            local member = actor.group_member[a]
            if member and member.room == self.room then
                if member:get_quest_stage("theatre") >= 1 and (member:get_quest_var("theatre:lashes") or 0) == 0 then
                    member:set_quest_var("theatre", "lashes", 1)
                    if member:get_quest_stage("theatre") == 1 then
                        member:send("<b:white>You have helped return Catherine's eyelashes.</>")
                    end
                    accept_lashes = 1
                end
            elseif member then
                i = i + 1
            end
            a = a + 1
        end
        if not accept_lashes then
            refuse = "lashes"
        else
            wait(0.2)
            self:say("Thank you so much!")
            wait(1)
            self:command("sit")
            self:command("wear eyelashes")
            self:emote("flutters her eyelids a few times.")
            wait(2)
            self:command("stand")
            wait(0.2)
            self:say("Finally!  Now if I could just have my dressing room key back too please...")
        end
    elseif (object.zone_id == 43 and object.id == 3) then
        local person = actor
        local i = person.group_size
        local a
        if i then
            a = 1
        else
            a = 0
        end
        while i >= a do
            local member = actor.group_member[a]
            if member and member.room == self.room then
                if member:get_quest_stage("theatre") >= 1 and (member:get_quest_var("theatre:lashes") or 0) == 1 then
                    if member:get_quest_stage("theatre") == 1 then
                        member:advance_quest("theatre")
                        member:send("<b:white>You have advanced the quest!</>")
                    end
                    member:set_quest_var("theatre", "lashes", 0)
                    accept_key = 1
                end
            elseif member then
                i = i + 1
            end
            a = a + 1
        end
        if not accept_key then
            wait(0.2)
            self.room:send(tostring(self.name) .. " makes a weird, embarrassed face.")
            wait(1)
            self:say("Can you be a dear and bring me my eyelashes first?")
            wait(1)
            self:say("Thaaaaaaanks!")
            self:command("give key " .. tostring(actor.name))
        else
            wait(0.2)
            self:emote("looks incredibly relieved.")
            self:say("I can't believe those monkeys made off with my key but not my costumes.")
            wait(2)
            self:command("shrug")
            self:say("It's the little things I guess.")
            wait(1)
            self:say("Oh!  I think Lewis's key got locked in my dressing room...")
            get_room(43, 51):at(function()
                run_room_trigger(43, 65)
            end)
            wait(2)
            self:say("He might want that back.")
            wait(3)
            self:say("Now, if only I could find my shoes...")
            self:emote("trails off and wanders away.")
        end
    else
        refuse = "item"
    end
else
    refuse = "person"
end
if refuse then
    _return_value = true
    if refuse == "lashes" then
        self.room:send(tostring(self.name) .. " blinks in confusion.")
        wait(0.2)
        self:say("N...o?  You already gave me my eyelashes.")
        actor:send(tostring(self.name) .. " slowly pushes the eyelashes back to you.")
        wait(0.2)
        self.room:send_except(actor, tostring(self.name) .. " slowly pushes the eyelashes back to " .. tostring(actor.name) .. ".")
    elseif refuse == "item" then
        self.room:send("A confused look crosses Catherine's face as she refuses " .. tostring(object.shortdesc) .. ".")
        wait(0.2)
        self:say("This isn't what I was looking for!")
        wait(1)
        self:say("Please help me or I'll miss my cue!")
    elseif refuse == "person" then
        self.room:send(tostring(self.name) .. " looks at " .. tostring(object.shortdesc) .. " with confusion.")
        wait(0.2)
        self:say("Ummm, what is that?")
        wait(1)
        self.room:send_except(actor, tostring(self.name) .. " looks at " .. tostring(actor.name) .. " with confusion.")
        actor:send(tostring(self.name) .. " looks at you with confusion.")
        wait(2)
        self:say("I'm sorry, who are you?")
    end
end
self:set_flag("sentinel", false)
return _return_value$trig$, '3be4d409511bdf1d1405cfb0d095b3dc'),
  -- data/triggers/052/052_08_emmath_flames_receive.lua
  (52, 8, $trig$local subclass_item, right_item, flameball_item, count

if (object.zone_id == 238 and object.id == 22) then
    get_room(238, 90):at(function()
        run_room_trigger(238, 14)
    end)
    if actor:get_quest_stage("type_wand") == "wandstep" and not actor:get_quest_var("type_wand:wandtask2") then
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
return _return_value$trig$, 'dc31738071063f305009864ddb8ca119'),
  -- data/triggers/052/052_78_lava_death_trig.lua
  (52, 78, $trig$wait(0.2)
while self.actor_count > 0 do
    local dice1 = random(1, 60)
    local dice2 = random(1, 60)
    local damage = dice1 + dice2
    local victim = self.room.actors[random(1, #self.room.actors)]
    if victim then
        local damage_dealt = victim:damage(damage)  -- type: fire
        if damage_dealt == 0 then
            self.room:send_except(victim, "A large lava bubble bursts near " .. tostring(victim.name) .. ", but " .. tostring(victim.possessive) .. " body absorbs the blast!")
            victim:send("A large lava bubble bursts right next to you.  Luckily, you are well-protected.")
        else
            self.room:send_except(victim, "A large lava bubble bursts near " .. tostring(victim.name) .. ", burning " .. tostring(victim.object) .. "! (<red>" .. tostring(damage_dealt) .. "</>)")
            victim:send("A large lava bubble bursts right next to you - OUCH, that burns! (<red>" .. tostring(damage_dealt) .. "</>)")
        end
        if victim:get_quest_stage("meteorswarm") == 3 and (victim:get_quest_var("meteorswarm:fire") or 0) == 1 then
            victim:advance_quest("meteorswarm")
            wait(1)
            victim:send("<red>You feel your mastery over fire growing!</>")
        end
    else
        return true
    end
    wait(2)
end$trig$, '23288e9280749dbcd6bda94e045e6a70'),
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
        -- switch on person.class
        local expmod
        if person.class == "warrior" or person.class == "berserker" then
            expmod = (expmod + (expmod / 10))
        elseif person.class == "paladin" or person.class == "anti-paladin" or person.class == "ranger" then
            expmod = (expmod + ((expmod * 2) / 15))
        elseif person.class == "sorcerer" or person.class == "pyromancer" or person.class == "cryomancer" or person.class == "illusionist" or person.class == "bard" then
            expmod = (expmod + (expmod / 5))
        elseif person.class == "necromancer" or person.class == "monk" then
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
                -- switch on person.class
                local expmod
                if person.class == "warrior" or person.class == "berserker" then
                    expmod = (expmod + (expmod / 10))
                elseif person.class == "ranger" then
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
return _return_value$trig$, '8b1e1be8275aae1f50f26c5366fda438'),
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
            local trophies = actor:get_quest_var("black_legion:id_trophy_trophies") + 1
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
                local trophies = actor:get_quest_var("black_legion:id_trophy_trophies") + 1
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
                local faction = actor:get_quest_var("black_legion:bl_faction") + 1
                actor:set_quest_var("black_legion", "bl_faction", faction)
                -- 
                -- slight bug for now the trigger code can't seem to evaluate negative numbers?
                -- 
                local faction2 = actor:get_quest_var("black_legion:eg_faction") - 1
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
        if actor:get_quest_var("black_legion:bl_faction") >= faction_required then
            local rewards = actor:get_quest_var("black_legion:id_reward_reward") + 1
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
                    local faction = actor:get_quest_var("black_legion:bl_faction") + 1
                    actor:set_quest_var("black_legion", "bl_faction", faction)
                    -- 
                    -- slight bug for now the trigger code can't seem to evaluate negative numbers?
                    -- 
                    local faction2 = actor:get_quest_var("black_legion:eg_faction") - 1
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
return _return_value$trig$, '42ba448514e72f2d01264976e9714797'),
  -- data/triggers/055/055_04_3bl_rewards_list.lua
  (55, 4, $trig$-- Converted from DG Script #5504: 3bl_rewards_list
-- Original: MOB trigger, flags: SPEECH, SPEECH_TO, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
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
if actor:get_quest_var("Black_Legion:eg_ally") then
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
    if actor:get_quest_stage("Black_Legion") > 0 then
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
            actor:send("- <b:yellow>" .. "%get.obj_shortdesc[%id_3bl_food%]%</> for <magenta>%get.obj_shortdesc[%id_gem_3bl_food%]%</>")
            actor:send("- <b:yellow>" .. "%get.obj_shortdesc[%id_3bl_drink%]%</> for <magenta>%get.obj_shortdesc[%id_gem_3bl_drink%]%</>")
            actor:send("- <b:yellow>" .. "%get.obj_shortdesc[%id_3bl_cap%]%</> for <magenta>%get.obj_shortdesc[%id_gem_3bl_cap%]%</>")
            actor:send("- <b:yellow>" .. "%get.obj_shortdesc[%id_3bl_ssword%]%</> for <magenta>%get.obj_shortdesc[%id_gem_3bl_ssword%]%</>")
        end
        if (actor:get_quest_var("black_legion:bl_faction") or 0) >= 40 then
            actor:send("- <b:yellow>" .. "%get.obj_shortdesc[%id_3bl_neck%]%</> for <magenta>%get.obj_shortdesc[%id_gem_3bl_neck%]%</>")
            actor:send("- <b:yellow>" .. "%get.obj_shortdesc[%id_3bl_staff%]%</> for <magenta>%get.obj_shortdesc[%id_gem_3bl_staff%]%</>")
        end
        if (actor:get_quest_var("black_legion:bl_faction") or 0) >= 55 then
            actor:send("- <b:yellow>" .. "%get.obj_shortdesc[%id_3bl_arm%]%</> for <magenta>%get.obj_shortdesc[%id_gem_3bl_arm%]%</>")
            actor:send("- <b:yellow>" .. "%get.obj_shortdesc[%id_3bl_whammer%]%</> for <magenta>%get.obj_shortdesc[%id_gem_3bl_whammer%]%</>")
        end
        if (actor:get_quest_var("black_legion:bl_faction") or 0) >= 70 then
            actor:send("- <b:yellow>" .. "%get.obj_shortdesc[%id_3bl_wrist%]%</> for <magenta>%get.obj_shortdesc[%id_gem_3bl_wrist%]%</>")
            actor:send("- <b:yellow>" .. "%get.obj_shortdesc[%id_3bl_flail%]%</> for <magenta>%get.obj_shortdesc[%id_gem_3bl_flail%]%</>")
        end
        if (actor:get_quest_var("black_legion:bl_faction") or 0) >= 85 then
            actor:send("- <b:yellow>" .. "%get.obj_shortdesc[%id_3bl_gloves%]%</> for <magenta>%get.obj_shortdesc[%id_gem_3bl_gloves%]%</>")
            actor:send("- <b:yellow>" .. "%get.obj_shortdesc[%id_3bl_symbol%]%</> for <magenta>%get.obj_shortdesc[%id_gem_3bl_symbol%]%</>")
            actor:send("- <b:yellow>" .. "%get.obj_shortdesc[%id_3bl_light%]%</> for <magenta>%get.obj_shortdesc[%id_gem_3bl_light%]%</>")
        end
        if (actor:get_quest_var("black_legion:bl_faction") or 0) >= 100 then
            actor:send("- <b:yellow>" .. "%get.obj_shortdesc[%id_3bl_belt%]%</> for <magenta>%get.obj_shortdesc[%id_gem_3bl_belt%]%</>")
            actor:send("- <b:yellow>" .. "%get.obj_shortdesc[%id_3bl_shiv%]%</> for <magenta>%get.obj_shortdesc[%id_gem_3bl_shiv%]%</>")
        end
        if (actor:get_quest_var("black_legion:bl_faction") or 0) >= 115 then
            actor:send("- <b:yellow>" .. "%get.obj_shortdesc[%id_3bl_boots%]%</> for <magenta>%get.obj_shortdesc[%id_gem_3bl_boots%]%</>")
            actor:send("- <b:yellow>" .. "%get.obj_shortdesc[%id_3bl_lsword%]%</> for <magenta>%get.obj_shortdesc[%id_gem_3bl_lsword%]%</>")
        end
        if (actor:get_quest_var("black_legion:bl_faction") or 0) >= 130 then
            actor:send("- <b:yellow>" .. "%get.obj_shortdesc[%id_3bl_legs%]%</> for <magenta>%get.obj_shortdesc[%id_gem_3bl_legs%]%</>")
        end
        if (actor:get_quest_var("black_legion:bl_faction") or 0) >= 145 then
            actor:send("- <b:yellow>" .. "%get.obj_shortdesc[%id_3bl_robe%]%</> for <magenta>%get.obj_shortdesc[%id_gem_3bl_robe%]%</>")
            actor:send("- <b:yellow>" .. "%get.obj_shortdesc[%id_3bl_jerkin%]%</> for <magenta>%get.obj_shortdesc[%id_gem_3bl_jerkin%]%</>")
        end
        if (actor:get_quest_var("black_legion:bl_faction") or 0) >= 160 then
            actor:send("- <b:yellow>" .. "%get.obj_shortdesc[%id_3bl_mask%]%</> for <magenta>%get.obj_shortdesc[%id_gem_3bl_mask%]%</>")
            actor:send("- <b:yellow>" .. "%get.obj_shortdesc[%id_3bl_smace%]%</> for <magenta>%get.obj_shortdesc[%id_gem_3bl_smace%]%</>")
        end
        if (actor:get_quest_var("black_legion:bl_faction") or 0) < 160 then
            -- (empty send to actor)
            actor:send(tostring(self.name) .. " tells you, 'As your standing with the Black")
            actor:send("</>Legion improves I will show you more rewards.'")
        end
        -- (empty send to actor)
    end
end$trig$, '2905d9d459a9c2a66590d571b89f66d7'),
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
            local trophies = actor:get_quest_var("black_legion:id_trophy_trophies") + 1
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
                local trophies = actor:get_quest_var("black_legion:id_trophy_trophies") + 1
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
                local faction = actor:get_quest_var("black_legion:eg_faction") + 1
                actor:set_quest_var("black_legion", "eg_faction", faction)
                -- 
                -- slight bug for now the trigger code can't seem to evaluate negative numbers?
                -- 
                local faction2 = actor:get_quest_var("black_legion:bl_faction") - 1
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
        if actor:get_quest_var("black_legion:eg_faction") >= faction_required then
            local rewards = actor:get_quest_var("black_legion:id_reward_reward") + 1
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
                    local faction = actor:get_quest_var("black_legion:eg_faction") + 1
                    actor:set_quest_var("black_legion", "eg_faction", faction)
                    -- 
                    -- slight bug for now the trigger code can't seem to evaluate negative numbers?
                    -- 
                    local faction2 = actor:get_quest_var("black_legion:bl_faction") - 1
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
return _return_value$trig$, '65a67c081a92d1edb7d5e9bd0064e709'),
  -- data/triggers/055/055_08_3eg_rewards_list.lua
  (55, 8, $trig$-- Converted from DG Script #5508: 3eg_rewards_list
-- Original: MOB trigger, flags: SPEECH, SPEECH_TO, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
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
if actor:get_quest_var("Black_Legion:bl_ally") then
    actor:send(tostring(self.name) .. " tells you, 'You have pledged")
    actor:send("</>yourself to the forces of darkness!  Suffer under your choice!'")
    return _return_value
end
if actor.alignment >= -150 then
    if actor:get_quest_stage("Black_Legion") > 0 then
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
            actor:send("- <b:yellow>" .. "%get.obj_shortdesc[%id_3eg_food%]%</> for <magenta>%get.obj_shortdesc[%id_gem_3eg_food%]%</>")
            actor:send("- <b:yellow>" .. "%get.obj_shortdesc[%id_3eg_drink%]%</> for <magenta>%get.obj_shortdesc[%id_gem_3eg_drink%]%</>")
            actor:send("- <b:yellow>" .. "%get.obj_shortdesc[%id_3eg_cap%]%</> for <magenta>%get.obj_shortdesc[%id_gem_3eg_cap%]%</>")
            actor:send("- <b:yellow>" .. "%get.obj_shortdesc[%id_3eg_ssword%]%</> for <magenta>%get.obj_shortdesc[%id_gem_3eg_ssword%]%</>")
        end
        if (actor:get_quest_var("black_legion:eg_faction") or 0) >= 40 then
            actor:send("- <b:yellow>" .. "%get.obj_shortdesc[%id_3eg_neck%]%</> for <magenta>%get.obj_shortdesc[%id_gem_3eg_neck%]%</>")
            actor:send("- <b:yellow>" .. "%get.obj_shortdesc[%id_3eg_staff%]%</> for <magenta>%get.obj_shortdesc[%id_gem_3eg_staff%]%</>")
        end
        if (actor:get_quest_var("black_legion:eg_faction") or 0) >= 55 then
            actor:send("- <b:yellow>" .. "%get.obj_shortdesc[%id_3eg_arm%]%</> for <magenta>%get.obj_shortdesc[%id_gem_3eg_arm%]%</>")
            actor:send("- <b:yellow>" .. "%get.obj_shortdesc[%id_3eg_whammer%]%</> for <magenta>%get.obj_shortdesc[%id_gem_3eg_whammer%]%</>")
        end
        if (actor:get_quest_var("black_legion:eg_faction") or 0) >= 70 then
            actor:send("- <b:yellow>" .. "%get.obj_shortdesc[%id_3eg_wrist%]%</> for <magenta>%get.obj_shortdesc[%id_gem_3eg_wrist%]%</>")
            actor:send("- <b:yellow>" .. "%get.obj_shortdesc[%id_3eg_flail%]%</> for <magenta>%get.obj_shortdesc[%id_gem_3eg_flail%]%</>")
        end
        if (actor:get_quest_var("black_legion:eg_faction") or 0) >= 85 then
            actor:send("- <b:yellow>" .. "%get.obj_shortdesc[%id_3eg_gloves%]%</> for <magenta>%get.obj_shortdesc[%id_gem_3eg_gloves%]%</>")
            actor:send("- <b:yellow>" .. "%get.obj_shortdesc[%id_3eg_symbol%]%</> for <magenta>%get.obj_shortdesc[%id_gem_3eg_symbol%]%</>")
            actor:send("- <b:yellow>" .. "%get.obj_shortdesc[%id_3eg_light%]%</> for <magenta>%get.obj_shortdesc[%id_gem_3eg_light%]%</>")
        end
        if (actor:get_quest_var("black_legion:eg_faction") or 0) >= 100 then
            actor:send("- <b:yellow>" .. "%get.obj_shortdesc[%id_3eg_belt%]%</> for <magenta>%get.obj_shortdesc[%id_gem_3eg_belt%]%</>")
            actor:send("- <b:yellow>" .. "%get.obj_shortdesc[%id_3eg_shiv%]%</> for <magenta>%get.obj_shortdesc[%id_gem_3eg_shiv%]%</>")
        end
        if (actor:get_quest_var("black_legion:eg_faction") or 0) >= 115 then
            actor:send("- <b:yellow>" .. "%get.obj_shortdesc[%id_3eg_boots%]%</> for <magenta>%get.obj_shortdesc[%id_gem_3eg_boots%]%</>")
            actor:send("- <b:yellow>" .. "%get.obj_shortdesc[%id_3eg_lsword%]%</> for <magenta>%get.obj_shortdesc[%id_gem_3eg_lsword%]%</>")
        end
        if (actor:get_quest_var("black_legion:eg_faction") or 0) >= 130 then
            actor:send("- <b:yellow>" .. "%get.obj_shortdesc[%id_3eg_legs%]%</> for <magenta>%get.obj_shortdesc[%id_gem_3eg_legs%]%</>")
        end
        if (actor:get_quest_var("black_legion:eg_faction") or 0) >= 145 then
            actor:send("- <b:yellow>" .. "%get.obj_shortdesc[%id_3eg_robe%]%</> for <magenta>%get.obj_shortdesc[%id_gem_3eg_robe%]%</>")
            actor:send("- <b:yellow>" .. "%get.obj_shortdesc[%id_3eg_jerkin%]%</> for <magenta>%get.obj_shortdesc[%id_gem_3eg_jerkin%]%</>")
        end
        if (actor:get_quest_var("black_legion:eg_faction") or 0) >= 160 then
            actor:send("- <b:yellow>" .. "%get.obj_shortdesc[%id_3eg_mask%]%</> for <magenta>%get.obj_shortdesc[%id_gem_3eg_mask%]%</>")
            actor:send("- <b:yellow>" .. "%get.obj_shortdesc[%id_3eg_smace%]%</> for <magenta>%get.obj_shortdesc[%id_gem_3eg_smace%]%</>")
        end
        if (actor:get_quest_var("black_legion:eg_faction") or 0) < 160 then
            -- (empty send to actor)
            actor:send(tostring(self.name) .. " tells you, 'As your standing with")
            actor:send("</>the 3rd Eldorian Guard improves I will show you more rewards.'")
        end
    end
end$trig$, 'ff1854ad26e1427dc7167f471d93ab66'),
  -- data/triggers/060/060_19_quest_mayor_obj_cane_3033.lua
  (60, 19, $trig$-- Converted from DG Script #6019: quest_mayor_obj_cane(3033)
-- Original: OBJECT trigger, flags: GET, probability: 100%
if actor:get_quest_var("merc_ass_thi_subclass:subclass_name") == "assassin" then
    if actor:get_quest_stage("merc_ass_thi_subclass") == 3 then
        if (actor:get_quest_var("merc_ass_thi_subclass:mayor") or 0) == 1 then
            actor:advance_quest("merc_ass_thi_subclass")
            wait(0.1)
            actor:send("<b:red>You've got the cane!</>")
        else
            wait(0.1)
            actor:send("<b:yellow>You haven't killed the Mayor yet...</>")
        end
    end
end$trig$, '38aed9d2c23ed490dc6f2d377d616c17'),
  -- data/triggers/062/062_08_supernova_clue_1.lua
  (62, 8, $trig$local stage = actor:get_quest_stage("supernova")
local readable = stage > 0 and stage >= 4 and (actor:has_item(489, 17) or actor:has_equipped(489, 17))

if readable then
    local step4 = actor:get_quest_var("supernova:step4")
    local clue2
    if (step4 or 0) == 18577 then
        -- The Abbey, the rising sun room
        clue2 = "I continue my journey where the sun rises amidst a sea of swirling worlds."
    elseif (step4 or 0) == 17277 then
        -- Citadel of Testing
        clue2 = "Atop a tower I visit a master who waits to give his final examination."
    elseif (step4 or 0) == 8561 then
        -- Cathedral of Betrayal near Norisent
        clue2 = "I study in a secret place above a hall of misery beyond a gallery of horrors."
    end
    actor:send("Learning is a life-long process.")
    if clue2 then
        actor:send(clue2)
    end
else
    actor:send("The writings are just a bunch of indecipherable squiggles and lines.")
end
return true$trig$, '81b6400d74419964383dfdf67c3248fd'),
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
    if (actor:get_quest_var("supernova:" .. payment_key(object)) or 0) == 1 then
        self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
        self:say("You've already given me this.")
    else
        actor:set_quest_var("supernova", payment_key(object), 1)
        wait(0.2)
        self:command("nod")
        world.destroy(object)
        if (actor:get_quest_var("supernova:510_73") or 0) == 1 and (actor:get_quest_var("supernova:489_17") or 0) == 1 then
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
return true$trig$, 'a924ca93bc2a50080f19f836727d308c'),
  -- data/triggers/062/062_14_supernova_status_checker.lua
  (62, 14, $trig$-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"progress", "progress?"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
local stage = actor:get_quest_stage("supernova")
wait(0.2)
if stage == 1 then
    self:say("You are trying to find one of Phayla's lamps.")
elseif stage == 2 then
    self:say("Have you found one of Phayla's lamps?")
elseif stage == 3 then
    self.room:send(tostring(self.name) .. " says, 'Phayla likes to visit the material plane to engage")
    self.room:send("</>in her favorite leisure activities.'")
    wait(2)
    local step3 = actor:get_quest_var("supernova:step3")
    if (step3 or 0) == 4318 then
        self.room:send(tostring(self.name) .. " says, 'Recently, she was spotted in Anduin, taking in a")
        self.room:send("</>show from the best seat in the house.'")
    elseif (step3 or 0) == 10316 then
        self.room:send(tostring(self.name) .. " says, 'I understand she frequents the hottest spring at")
        self.room:send("</>the popular resort up north.'")
    elseif (step3 or 0) == 58062 then
        self.room:send(tostring(self.name) .. " says, 'She occasionally visits a small remote island")
        self.room:send("</>theatre, where she enjoys meditating in their reflecting room.'")
    end
    wait(2)
    self:say("You may be able to find a clue to her whereabouts there.")
elseif stage >= 4 then
    self.room:send(tostring(self.name) .. " says, 'Consult the clues Phayla left behind!")
    self.room:send("</>Be sure to <b:white>look</> at them by the light of your lamp!'")
end
return true$trig$, 'd7f55d733ba7c9a747735d075bf3edb9'),
  -- data/triggers/062/062_16_supernova_clue_2.lua
  (62, 16, $trig$local stage = actor:get_quest_stage("supernova")
local readable = stage > 0 and stage >= 5 and (actor:has_item(489, 17) or actor:has_equipped(489, 17))

if readable then
    local step5 = actor:get_quest_var("supernova:step5")
    local clue3
    if (step5 or 0) == 53219 then
        -- Lizard King's throne room, Sunken
        clue3 = "Where DID the lizard men get that throne from?  I'll see if I can find out."
    elseif (step5 or 0) == 47343 then
        -- Kryzanthor, Graveyard
        clue3 = "They often wonder what would happen if bones could talk.  I'll ask one who can make that happen!"
    elseif (step5 or 0) == 16278 then
        -- Imanhotep, Pyramid
        clue3 = "Waves of sand hold the remains of a child of the Sun God.  Supposedly.  I'll have to see for myself."
    end
    actor:send("History is so fascinating!")
    if clue3 then
        actor:send(clue3)
    end
else
    actor:send("The writings are just a bunch of indecipherable squiggles and lines.")
end
return true$trig$, 'b0ac42b7f2866f8b6495655199823ef5'),
  -- data/triggers/062/062_17_supernova_clue_3.lua
  (62, 17, $trig$local stage = actor:get_quest_stage("supernova")
local readable = stage > 0 and stage >= 6 and (actor:has_item(489, 17) or actor:has_equipped(489, 17))

if readable then
    local step6 = actor:get_quest_var("supernova:step6")
    local step7 = actor:get_quest_var("supernova:step7")
    local clue4
    if (step6 or 0) == 58657 then
        -- A Hummock of Grass in the Beachhead
        if (step7 or 0) == 1 then clue4 = "s pfqzqgc wq kecwk qy xug fwinlugev"
        elseif (step7 or 0) == 2 then clue4 = "d hlwzsuc rf xbnwk aq tyo oisukhvkq"
        elseif (step7 or 0) == 3 then clue4 = "s oidfgjy fy yyojl au hyx tlotazlou"
        end
    elseif (step6 or 0) == 35119 then
        -- A Pile of Stones in the Brush Lands
        if (step7 or 0) == 1 then clue4 = "s xtpr qj kbzrru mf bsi otykp weafw"
        elseif (step7 or 0) == 2 then clue4 = "d pzvr sx kwoeof mf lke sbhwz ddnuc"
        elseif (step7 or 0) == 3 then clue4 = "s wwcx gm gkhflg zg los skmzv ctfkg"
        end
    elseif (step6 or 0) == 55422 then
        -- The Trail Overlooking the Falls in the dark mountains
        if (step7 or 0) == 1 then clue4 = "lpp xecmd wgiensgstrt vlw nlpyu mf bsi qcvc uzyaveavd"
        elseif (step7 or 0) == 2 then clue4 = "whv deead ovvbysgclnx dui xsolj sa xzw gaiu zsmfwazxf"
        elseif (step7 or 0) == 3 then clue4 = "los kkspz fowyzfhcpbx mzl tredz we mzl rrkc tclglhwel"
        end
    end

    local clue5
    if (step7 or 0) == 1 then clue5 = "What disappears as soon as you say its name?"          -- Silence
    elseif (step7 or 0) == 2 then clue5 = "The more there is, the less you see. What am I?"   -- Darkness
    elseif (step7 or 0) == 3 then clue5 = "What word becomes shorter when you add two to it?" -- Short
    end

    actor:send("I know you're following me.  Answer this:")
    actor:send("\"" .. tostring(clue5) .. "\"")
    actor:send("With the answer you can find the gate to my home here:")
    actor:send(tostring(clue4))
    actor:send("</>")
    actor:send("You will need additional solar energy to power the gate.")
    actor:send("Hidden in the dimensional folds around Nordus is an appropriate source.")
else
    actor:send("The writings are just a bunch of indecipherable squiggles and lines.")
end
return true$trig$, '0557d65ed00524995950e2ec8e413917'),
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
            local item_name = tostring(objects.template(math.floor(item / 100), item % 100).name)
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
end$trig$, '1769118c33c45ad12315a989777a8bc5'),
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
    local item_name = tostring(objects.template(math.floor(item / 100), item % 100).name)
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
return true$trig$, 'f54a759fe86fda4f291e8bbdd186c714'),
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
    self.room:spawn_object(math.floor(item / 100), item % 100)
    self:command("give all " .. tostring(actor))
    wait(0.2)
    actor:send(tostring(self.name) .. " says, 'A pleasure doing business with you!'")
    actor:set_quest_var("gem_exchange", "gem_id", 0)
else
    actor:send(tostring(self.name) .. " refuses to perform the exchange.")
    wait(1)
    if in_gem_range then
        local item_name = tostring(objects.template(math.floor(item / 100), item % 100).name)
        actor:send(tostring(self.name) .. " says, 'I'm afraid " .. tostring(object.shortdesc) .. " isn't of high enough rarity")
        actor:send("</>to exchange for " .. item_name .. ".'")
    else
        actor:send(tostring(self.name) .. " says, 'Sorry, " .. tostring(object.shortdesc) .. " isn't the kind of thing")
        actor:send("</>we trade around here...'")
    end
end
return true$trig$, '7b4116f549d76ab936936f2302c8eeaa'),
  -- data/triggers/085/085_54_resurrection_death_talisman_give.lua
  (85, 54, $trig$-- Converted from DG Script #8554: Resurrection Death Talisman Give
-- Original: OBJECT trigger, flags: GIVE, probability: 100%
local _return_value = true  -- Default: allow action
-- As mobs are handed this object, they are recorded on the object itself as a global,
-- Then when it's turned in to Norisent, he checks the object for the appropriate global variables.
-- 
-- If the item has been assigned to a quester, it does its tricks, otherwise it skips to the bottom.
-- switch on victim.id
if actor:get_quest_stage("resurrection_quest") > 10 then
    if (victim.zone_id == 85 and victim.id == 50) then
        self.room:send(tostring(victim.name) .. " mutters an incantation and " .. tostring(self.shortdesc) .. " bursts into flame and is gone.")
        world.destroy(self)
        return _return_value
    end
    -- switch on actor:get_quest_stage("resurrection_quest")
    if not actor:get_quest_var("resurrection_quest:4003") then
        if actor:get_quest_stage("resurrection_quest") == 4 then
            victim:say("You have not banished Lajon's Soul.")
        elseif (actor:get_quest_var("resurrection_quest:4004") or 0) == 0 then
            victim:say("You have not destroyed Lajon's Corruption.")
        elseif (actor:get_quest_var("resurrection_quest:4016") or 0) == 0 then
            self.room:send(tostring(victim.name) .. " says, 'You must still stop the one responsible, the Tres Keeper, and return his ring of souls.'")
        else
            actor:advance_quest("resurrection_quest")
            victim:say("Well done.  Now the ring?")
        end
    elseif actor:get_quest_stage("resurrection_quest") == 5 then
        victim:say("I need to have that ring.")
        if (actor:get_quest_var("resurrection_quest:53411") or 0) < 2 then
        elseif actor:get_quest_stage("resurrection_quest") == 6 then
            victim:say("You have not yet removed enough of the Xeg-Yi from this realm.")
        elseif (actor:get_quest_var("resurrection_quest:53308") or 0) == 0 then
            self.room:send(tostring(victim.name) .. " says, 'Aelfric is still out there, with the white robes.  Go finish the job!'")
        else
            actor:advance_quest("resurrection_quest")
            victim:say("Well done.  Now the robes?")
        end
    elseif actor:get_quest_stage("resurrection_quest") == 7 then
        victim:say("Before we may continue, I must have the dragon robes.")
        if (actor:get_quest_var("resurrection_quest:53001") or 0) == 0 then
        elseif actor:get_quest_stage("resurrection_quest") == 8 then
            victim:say("The spectral man is still out there.  Why are you here?")
        elseif (actor:get_quest_var("resurrection_quest:51005") or 0) == 0 then
            victim:say("The poor man's bloody remains must be dispelled.  Go now!")
        elseif (actor:get_quest_var("resurrection_quest:51014") or 0) == 0 then
            self.room:send(tostring(victim.name) .. " says, 'Go stop Luchiaans, and bring the source of power before he finds it.'")
        else
            actor:advance_quest("resurrection_quest")
            self.room:send(tostring(victim.name) .. " says, 'Excellent.  And the object of power, do you have it?  Give it to me.'")
        end
    elseif actor:get_quest_stage("resurrection_quest") == 9 then
        victim:say("Luchiaans' object of power, do you have it?  Give it to me.")
        if (actor:get_quest_var("resurrection_quest:52015") or 0) == 0 then
        elseif actor:get_quest_stage("resurrection_quest") == 10 then
            victim:say("The weaponsmith's spirit still dwells.  Go set her free.")
        elseif (actor:get_quest_var("resurrection_quest:52003") or 0) == 0 then
            self.room:send(tostring(victim.name) .. " says, 'The crazed mage must be destroyed.  Go, end this.  Return with his ring.'")
        else
            actor:advance_quest("resurrection_quest")
            self.room:send(tostring(victim.name) .. " mutters an incantation and " .. tostring(self.shortdesc) .. " vanishes into flames, the smoke drifting into " .. tostring(victim.name) .. "'s nostrils.")
            wait(1)
            self.room:send(tostring(victim.name) .. " says, 'We are nearly finished.  Do you have the mage's artifact of longevity?'")
            world.destroy(self.room:find_object("self"))
            return _return_value
        end
    else
        victim:emote("briskly refuses.")
        victim:say("I don't want this from you.  Do not lose that talisman.")
    end
    _return_value = true
    victim:emote("returns the death talisman to you.")
    -- Dead-code chunks from converter elided here; the legacy
    -- DG had additional per-mob increment + wear logic that
    -- needs reconstruction. TODO(parity).
    return _return_value
end
return _return_value$trig$, '72e69c7bae3f0505706eb6f07427eb14'),
  -- data/triggers/085/085_99_resurrection_quest_status_checker.lua
  (85, 99, $trig$-- Converted from DG Script #8599: resurrection_quest_status_checker
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
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
wait(0.2)
if actor:get_has_completed("resurrection_quest") then
    self:say("You have already learned the secrets of the Resurrection.")
    return true
end

local stage = actor:get_quest_stage("resurrection_quest")
local hunt, item
local mob1, mob2, mob3
local mob1_name, mob2_name, mob3_name

if stage == 3 then
    self:say("Do something to interfere with Ziijhan.")
    wait(1)
    self:say("I hear he has a bishop locked up in the dungeon.")
    return true
elseif stage == 4 then
    mob1_name = mobiles.template(40, 4).name
    mob2_name = mobiles.template(40, 3).name
    mob3_name = mobiles.template(40, 16).name
    hunt = mob1_name .. ", " .. mob2_name .. ", and " .. mob3_name
    mob1 = 4004
    mob2 = 4003
    mob3 = 4016
    item = objects.template(40, 8).name
elseif stage == 5 then
    item = objects.template(40, 8).name
elseif stage == 6 then
    mob2_name = mobiles.template(533, 8).name
    mob1_name = "the Xeg-Yi"  -- displayed as a count
    hunt = "2 Xeg-Yi and " .. mob2_name
    mob2 = 53411
    mob1 = 53308
    item = objects.template(533, 7).name
elseif stage == 7 then
    item = objects.template(533, 7).name
elseif stage == 8 then
    mob1_name = mobiles.template(510, 5).name
    mob2_name = mobiles.template(530, 1).name
    mob3_name = mobiles.template(510, 14).name
    hunt = mob1_name .. ", " .. mob2_name .. ", and " .. mob3_name
    mob1 = 51005
    mob2 = 53001
    mob3 = 51014
    if string.find(actor.class, "cleric") or string.find(actor.class, "priest") then
        item = "a large book on healing from Nordus"
    elseif string.find(actor.class, "diabolist") then
        item = objects.template(510, 28).name
    end
elseif stage == 9 then
    if string.find(actor.class, "cleric") or string.find(actor.class, "priest") then
        item = "a large book on healing from Nordus"
    elseif string.find(actor.class, "diabolist") then
        item = objects.template(510, 28).name
    end
elseif stage == 10 then
    mob1_name = mobiles.template(520, 3).name
    mob2_name = mobiles.template(520, 15).name
    hunt = mob1_name .. " and " .. mob2_name
    mob1 = 52003
    mob2 = 52015
    item = objects.template(520, 1).name
elseif stage == 11 then
    item = objects.template(520, 1).name
else
    self:say("Did you want to do a quest of some kind?  Because you're not at the moment.  Get lost.")
    return true
end

if stage == 4 or stage == 6 or stage == 8 or stage == 10 then
    local target1 = actor:get_quest_var("resurrection_quest:mob1")
    local target2 = actor:get_quest_var("resurrection_quest:mob2")
    local target3
    if stage == 6 or stage == 10 then
        target3 = 1
    else
        target3 = actor:get_quest_var("resurrection_quest:mob3")
    end
    self:say("You must eliminate:")
    self.room:send(tostring(hunt))

    local done = false
    if stage == 4 or stage == 8 then
        if target1 and target2 and target3 then done = true end
    elseif stage == 6 then
        if target1 and ((target2 or 0) == 2) then done = true end
    else
        if target1 and target2 then done = true end
    end
    if done then
        self:say("You have dispatched them.  Give me the death talisman!")
        return true
    end

    if target1 or target2 or target3 then
        self.room:send("You have destroyed:")
        if target1 and mob1_name then
            self.room:send("- " .. mob1_name)
        end
        if stage == 6 then
            if (target2 or 0) == 2 and mob2_name then
                self.room:send("- " .. tostring(target2) .. " " .. mob2_name)
            end
        else
            if target2 and mob2_name then
                self.room:send("- " .. mob2_name)
            end
        end
        if (stage == 4 or stage == 8) and target3 and mob3_name then
            self.room:send("- " .. mob3_name)
        end
    end
    if (stage ~= 6 and (not target1 or not target2 or not target3)) or (stage == 6 and (not target1 or (target2 or 0) < 2)) then
        self.room:send("You still need to dispatch:")
        if not target1 and mob1_name then
            self.room:send("- " .. mob1_name)
        end
        if stage == 6 then
            local t2 = target2 or 0
            if t2 < 2 and mob2_name then
                local xeg = 2 - t2
                self.room:send("- " .. tostring(xeg) .. " " .. mob2_name)
            end
        else
            if not target2 and mob2_name then
                self.room:send("- " .. mob2_name)
            end
        end
        if not target3 and mob3_name then
            self.room:send("- " .. mob3_name)
        end
        self.room:send("Return " .. tostring(item) .. " as proof.")
    end
    self.room:send("Don't forget the banishment phrase: <b:blue>Dhewsost Konre</>")
elseif stage == 5 or stage == 7 or stage == 9 or stage == 11 then
    self:say("Bring me back " .. tostring(item) .. ".")
end
if stage >= 4 then
    self.room:send(tostring(self.name) .. " says, 'If you need a new talisman, say <b:black>\"I need a new talisman\"</>.'")
end$trig$, '5a76d1b697fa7acd4335a84dd71a071b'),
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
    if not v or (v or 0) == 0 or (v or "") == "" or v == "0" then
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
return true$trig$, '4b4673d935b5bd5d1fa2980bc3f28d93'),
  -- data/triggers/103/103_09_khysan-greet.lua
  (103, 9, $trig$local ice_stage = actor:get_quest_stage("ice_shards")
local wand_stage = actor:get_quest_stage("type_wand")

local seen_before = false
if (ice_stage or 0) > 0 and ice_stage > 0 then
    seen_before = true
end
if wandstep and wand_stage > wandstep then
    seen_before = true
end
if wandstep and wand_stage == wandstep and (actor:get_quest_var("type_wand:greet") or 0) == 1 then
    seen_before = true
end

wait(1)
actor:send(self.name .. " looks up at your approach.")

if seen_before then
    self:say("Welcome back my friend.")
    wait(0.2)
    if (ice_stage or 0) > 0 and ice_stage > 0 and not actor:get_has_completed("ice_shards") then
        self:say("Did you find any more clues?")
        if wandstep and wand_stage == wandstep then
            local minlevel = (wandstep - 1) * 10
            wait(1)
            if actor.level >= minlevel then
                if (actor:get_quest_var("type_wand:greet") or 0) == 0 then
                    self:say("Or is there something else that brings you back?")
                else
                    self:say("Or do you have what I need for a new staff?")
                end
            end
        end
    else
        if wandstep and wand_stage == wandstep then
            local minlevel = (wandstep - 1) * 10
            if actor.level >= minlevel then
                if (actor:get_quest_var("type_wand:greet") or 0) == 0 then
                    self:say("Is there something else that brings you back?")
                else
                    self:say("Do you have what I need for a new staff?")
                end
            end
        end
    end
else
    self.room:send(self.name .. " smiles warmly and says, 'Welcome to Phoenix Feather Resort.'")
    wait(1)
    self:say("We are currently offering free services to all adventurers.")
    wait(1)
    self:command("bow " .. actor.name)
    self:say("Please enjoy your stay.  You may enter the hot springs to the south.")
    if wandstep and wand_stage == wandstep then
        wait(1)
        local minlevel = (wandstep - 1) * 10
        if actor.level >= minlevel and (actor:get_quest_var("type_wand:greet") or 0) == 0 then
            self.room:send(self.name .. " says, 'I see you're crafting something.  If you want my help, we can talk about <b:cyan>[upgrades]</>.'")
        end
    end
    if not ((ice_stage or 0) > 0 and ice_stage > 0) then
        wait(0.3)
        if string.find(actor.class, "cryomancer") then
            if actor:get_has_completed("major_globe_spell")
               and actor:get_has_completed("relocate_spell_quest")
               and actor:get_has_completed("wall_ice")
               and actor:get_has_completed("waterform")
               and actor:get_has_completed("flood") then
                self:say("Oh, " .. actor.name .. " " .. tostring(actor.title) .. "!  I've heard of you!  You're quite talked about amongst our fellow cryomancers.")
                if actor.level > 88 then
                    self.room:send("</>")
                    self:say("Makes me wonder if you could have mastered the most powerful cryomantic spell ever known.")
                end
            end
        end
    end
end$trig$, 'c84ffab3338e065a0322acd94ce7b931'),
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

local num_trees = 1 + actor:get_quest_var("twisted_sorrow:num_trees")
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

return false$trig$, '00e6c229510c0ecb4227b7d397895332'),
  -- data/triggers/120/120_99_twisted_sorrow_status_tracker.lua
  (120, 99, $trig$-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"progress", "progress?"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end

-- Each entry: { tree_room_local_id, quest_var_suffix }
-- Quest var key matches the legacy 5-digit room vnum used by trigger 120-3.
local trees = {
    { 16, "12016" },  -- Tree of Luck
    { 17, "12017" },  -- Tree of Reverence
    { 18, "12018" },  -- Tree of Self-Reliance
    { 14, "12014" },  -- Tree of Nimbleness
    { 46, "12046" },  -- Tree of Kindness
}

wait(0.4)
local stage = actor:get_quest_stage("twisted_sorrow")
if stage > 1 then
    self:command("smile " .. actor.name)
    wait(1)
    self:say("The trees are satisfied, my friend.")
    return true
end

if stage ~= 1 then
    return true
end

self:say("Bring drink to awaken the trees from the corruption.")

local any_satisfied = false
for _, t in ipairs(trees) do
    if (actor:get_quest_var("twisted_sorrow:satisfied_tree:" .. t[2]) or 0) == 1 then
        any_satisfied = true
        break
    end
end

if any_satisfied then
    self.room:send("You have already awakened the following trees:")
    for _, t in ipairs(trees) do
        if (actor:get_quest_var("twisted_sorrow:satisfied_tree:" .. t[2]) or 0) == 1 then
            self.room:send("- <b:black>" .. get_room(120, t[1]).name .. "</>")
        end
    end
end

self.room:send("Offerings are still needed for:")
for _, t in ipairs(trees) do
    if (actor:get_quest_var("twisted_sorrow:satisfied_tree:" .. t[2]) or 0) ~= 1 then
        self.room:send("- <green>" .. get_room(120, t[1]).name .. "</>")
    end
end
self.room:send("</>")
self:say("Say <b:cyan>\"follow me\"</> when you have an offering to present.")$trig$, '695b68572781c86114df68f10452c6af'),
  -- data/triggers/123/123_00_megalith_quest_priestess_greet.lua
  (123, 0, $trig$-- Converted from DG Script #12300: megalith_quest_priestess_greet
-- Original: MOB trigger, flags: GREET, probability: 100%
-- This trigger is different depending on stage and where in the stage the questor is at
-- 
local item1 = ((actor:get_quest_var("megalith_quest:item1") or 0) == 1)
local item2 = ((actor:get_quest_var("megalith_quest:item2") or 0) == 1)
local item3 = ((actor:get_quest_var("megalith_quest:item3") or 0) == 1)
local item4 = ((actor:get_quest_var("megalith_quest:item4") or 0) == 1)
if (actor.is_player) and (actor:get_quest_stage("megalith_quest") < 1) and (actor.level < 100) then
    wait(0.2)
    self.room:send(tostring(self.name) .. " looks up, startled to see new faces.")
    self:say("Goddess be praised!")
    wait(2)
    self.room:send(tostring(self.name) .. " says, 'We were attacked by the Unseelie Court and their monstrosities on our journey here through the forest.  I am deeply in need of <b:cyan>assistance</>!'")
    -- 
    -- Check in during stage 1, seeing if the questor has her tools or not
    -- 
elseif actor:get_quest_stage("megalith_quest") == 1 then
    wait(0.2)
    self.room:send(tostring(self.name) .. " says, 'Have you been able to find replacements for the sacred prophetic implements?  Do you need a reminder of your <b:cyan>[progress]?</>'")
    -- 
    -- If all the Keepers have been helped in stage 2, give the incantation to start stage 3
    -- 
elseif (actor:get_quest_stage("megalith_quest") == 2) and ((actor:get_quest_var("megalith_quest:item1") or 0) == 1) and ((actor:get_quest_var("megalith_quest:item2") or 0) == 1) and ((actor:get_quest_var("megalith_quest:item3") or 0) == 1) and ((actor:get_quest_var("megalith_quest:item4") or 0) == 1) then
    wait(0.2)
    self:say("We're ready to finish calling the elements!  If you wish to proceed, repeat after me:")
    self.room:send("</>")
    self.room:send("<b:cyan>Under the watchful eye of Earth, Air, Fire, and Water, we awaken this hallowed ground!</>")
    -- 
    -- If all the Keepers have not been helped in stage 2, do a check in
    -- 
elseif actor:get_quest_stage("megalith_quest") == 2 then
    wait(0.2)
    self.room:send(tostring(self.name) .. " says, 'I hope your work with the Keepers is coming along well.  Do you need a reminder of your <b:cyan>[progress]?</>'")
    -- 
    -- If all the reliquaries have been returned and stage 4 is ready to start, ask if ready to proceed
    -- 
elseif (actor:get_quest_stage("megalith_quest") == 4) and ((actor:get_quest_var("megalith_quest:reliquary") or 0) ~= 0) then
    wait(0.2)
    self:say("It's time.  Are you ready to proceed?")
    -- 
    -- If all the reliquaries have not been returned yet in stage 3, do a check in
    -- 
elseif actor:get_quest_stage("megalith_quest") == 3 then
    wait(0.2)
    self:say("I hope you have had luck finding the reliquaries.")
    -- 
    -- If the quest was successfully completed, give a friendly welcome.
    -- 
elseif actor:get_has_completed("megalith_quest") then
    wait(0.2)
    if actor.gender == "female" then
        self:say("Hail and well met, Sister!")
    elseif actor.gender == "male" then
        self:say("Hail and well met, Brother!")
    else
        self:say("Hail and well met!")
    end
    -- 
    -- If the quest was failed,
    -- 
elseif actor:get_has_failed("megalith_quest") then
    wait(0.2)
    self:say("Welcome back.")
    wait(0.2)
    self:say("Had that we reunited under better blessings...")
    wait(3)
    self:say("Though perhaps we could try again?")
end$trig$, '591c23bd8c6a842eee45c138c7d0cf35'),
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
    wait(0.2)
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
    wait(0.2)
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
elseif actor:get_quest_stage("megalith_quest") > 0 and self.room.zone_id == 123 and self.room.local_id == 89 and (actor:get_quest_var("megalith_quest:reliquary") or 0) == 1 then
    wait(0.2)
    self:say("The Great Rite of Invocation has a great deal of call and response.  I will chant a line and you must repeat it to continue the ritual.  The coven will chant their response after you do.")
    wait(4)
    self:say("Repeat after me.")
    wait(2)
    self:emote("raises her arms to the sky.")
    self.room:send(tostring(self.name) .. " chants, '<b:cyan>Great Lady of the Stars, hear our prayer!</>'")
    actor:set_quest_var("megalith_quest", "prayer", 1)
end$trig$, 'bea2973cff6c9913379b902de104f132'),
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
            self.room:spawn_object(math.floor(saved_goblet / 100), saved_goblet % 100)
            local goblet_name = objects.template(math.floor(saved_goblet / 100), saved_goblet % 100)
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
return _return_value$trig$, '43f064d546feacc7e08851ecf6e1830c'),
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
    if (stage == 4) and (self.room.zone_id == 123 and self.room.local_id == 89) and ((actor:get_quest_var("megalith_quest:prayer") or 0) == 1) then
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
end$trig$, '36c50cb7dc5eecdf18a5a971e3579fae'),
  -- data/triggers/123/123_10_megalith_quest_priestess_speech_invocation2.lua
  (123, 10, $trig$-- Converted from DG Script #12310: megalith_quest_priestess_speech_invocation2
-- Original: MOB trigger, flags: SPEECH, SPEECH_TO, probability: 0%

-- Speech phrase: we summon and stir thee (DG num_arg 0 = the speech contains the whole phrase, on word boundaries)
local speech_padded = " " .. string.lower(speech) .. " "
if not string.find(speech_padded, "[%s%p]we summon and stir thee[%s%p]") then
    return true  -- Not the phrase
end
local speech1 = "we summon and stir thee"
local speech2 = "we summon and stir thee!"
local stage = actor:get_quest_stage("megalith_quest")
local summon = actor:get_quest_var("megalith_quest:summon")
if speech == speech1 or speech == speech2 then
    if (stage == 4) and (self.room.zone_id == 123 and self.room.local_id == 89) and ((actor:get_quest_var("megalith_quest:prayer") or 0) == 2) then
        -- switch on summon
        do
            local _sw1 = string.lower(tostring(summon or ""))
            if tonumber(_sw1) == 1 then
                run_room_trigger(123, 18)
                wait(5)
                self.room:send(tostring(self.name) .. " chants:")
                self.room:send("'By Earth, Air, Water, and Fire,")
                self.room:send("</>To bring you home is our desire.'")
                wait(4)
                run_room_trigger(123, 19)
                actor:set_quest_var("megalith_quest", "summon", 2)
            elseif tonumber(_sw1) == 2 then
                run_room_trigger(123, 20)
                wait(2)
                self.room:send(tostring(self.name) .. " chants:")
                self.room:send("'Through the plane of vaulted sky")
                self.room:send("</>On shooting stars and moonbridge high.'")
                wait(4)
                run_room_trigger(123, 21)
                actor:set_quest_var("megalith_quest", "summon", 3)
            elseif tonumber(_sw1) == 3 then
                -- 
                -- 12320 is a wecho of just the phrase 'We summon and stir thee'
                -- It is intentionally repeated at the top of this case to echo the questor
                -- 
                run_room_trigger(123, 20)
                wait(2)
                self.room:send(tostring(mobiles.template(123, 1).name) .. " says, '<b:cyan>We invoke thee</>!")
            end
        end
    end
end$trig$, '23751d1f14124e2890188b7e6462deed'),
  -- data/triggers/123/123_11_megalith_quest_priestess_speech_end.lua
  (123, 11, $trig$-- Converted from DG Script #12311: megalith_quest_priestess_speech_end
-- Original: MOB trigger, flags: SPEECH, SPEECH_TO, probability: 0%

-- Speech phrase: we invoke thee (DG num_arg 0 = the speech contains the whole phrase, on word boundaries)
local speech_padded = " " .. string.lower(speech) .. " "
if not string.find(speech_padded, "[%s%p]we invoke thee[%s%p]") then
    return true  -- Not the phrase
end
local _return_value = true
local speech1 = "we invoke thee"
local speech2 = "we invoke thee!"
local stage = actor:get_quest_stage("megalith_quest")
if (stage == 4) and (self.room.zone_id == 123 and self.room.local_id == 89) and ((actor:get_quest_var("megalith_quest:summon") or 0) == 3) and (speech == speech1 or speech == speech2) then
    local invoke = actor:get_quest_var("megalith_quest:invoke") or 0
    local chant = invoke + 1
    if chant == 1 then
        actor:set_quest_var("megalith_quest", "invoke", 1)
        wait(0.2)
        run_room_trigger(123, 22)
        wait(1)
        self:say("Again!")
        self.room:send("<b:cyan>We invoke thee!</>")
    elseif chant == 2 then
        actor:set_quest_var("megalith_quest", "invoke", 2)
        wait(0.2)
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
            self.room:send("<b:black>The harmonics shift into piercing discordant shrieks as</> <red>blood</> <b:black>begins to pour from the altar!</>")
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
                wait(0.2)
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
                self.room:send("<b:black>The harmonics of the monolith begin to shift, falling out of balance.</>")
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
return _return_value$trig$, '262bdd14a6118120270dd1d61d9cd79e'),
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
-- The mob's short description starts lowercase ("the witch priestess"); a line that begins with it
-- needs a capital.
local self_name = self.name:sub(1, 1):upper() .. self.name:sub(2)
wait(0.2)
-- Make sure you're on the quest.
if actor:get_quest_stage("megalith_quest") < 1 then
    return _return_value
end
if actor:get_has_completed("megalith_quest") then
    self:say("We give thanks for your help in completing our summoning ritual.")
    wait(0.2)
    self:say("Blessed be!")
    return _return_value
end
if actor:get_has_failed("megalith_quest") then
    self:say("Sadly we failed in our efforts to invoke " .. tostring(mobiles.template(123, 0).name) .. "...")
    wait(0.2)
    self:say("Would you like to try again?")
    return _return_value
end
-- Hoisted locals (branch-scoped in the converter output, used after the
-- if/elseif chain).
local step
local item1, item2, item3, item4
local receive1, receive2, receive3, receive4, receive5
local stage = actor:get_quest_stage("megalith_quest")
do
    local _sw1 = string.lower(tostring(stage or ""))
    local _run1 = false
    repeat
        if _run1 or tonumber(_sw1) == 1 then
            _run1 = true
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
            actor:send(self_name .. " says, 'I need your help " .. tostring(step) .. ".'")
            break
        end
        if _run1 or tonumber(_sw1) == 2 then
            _run1 = true
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
            wait(0.2)
            actor:send(self_name .. " says, 'We're trying to " .. tostring(step) .. ".'")
            if ((actor:get_quest_var("megalith_quest:item1") or 0) == 1) and ((actor:get_quest_var("megalith_quest:item2") or 0) == 1) and ((actor:get_quest_var("megalith_quest:item3") or 0) == 1) and ((actor:get_quest_var("megalith_quest:item4") or 0) == 1) then
                self.room:send(self_name .. " says, 'We're ready to finish calling the elements!")
                self.room:send("</>If you wish to proceed, repeat after me:'")
                self.room:send("<b:white>Under the watchful eye of Earth, Air, Fire, and Water, we awaken this")
                self.room:send("</>hallowed ground!</>")
                return _return_value
            end
            break
        end
        if _run1 or tonumber(_sw1) == 3 then
            _run1 = true
            step = "locate three reliquaries"
            receive5 = 12301
            item1 = "a holy prayer bowl"
            item2 = "a piece of a goddess's regalia"
            item3 = "a faerie relic from the land of the Reverie made manifest"
            actor:send(self_name .. " says, 'We need to <b:yellow>" .. tostring(step) .. "</>.'")
            break
        end
        if _run1 or tonumber(_sw1) == 4 then
            _run1 = true
            self.room:send(self_name .. " says, 'I've been awaiting your return!  Let us")
            self.room:send("</>perform the Great Rite of Invocation! Repeat after me:'")
            self.room:send("<b:white>Great Lady of the Stars, hear our prayer!</>")
            return _return_value
        end
        do  -- default
            _run1 = true
            return _return_value
        end
    until true
end
-- Quest vars item1..item4 are 1 once that item has been handed over; unset or 0 means still needed.
local function have(n)
    return (actor:get_quest_var("megalith_quest:item" .. n) or 0) == 1
end
-- list items already given
if have(1) or have(2) or have(3) or have(4) then
    actor:send("You have already retrieved:")
end
if item1 and have(1) then
    actor:send("- <b:white>" .. tostring(item1) .. "</>")
end
if item2 and have(2) then
    actor:send("- <b:white>" .. tostring(item2) .. "</>")
end
if item3 and have(3) then
    actor:send("- <b:white>" .. tostring(item3) .. "</>")
end
if item4 and have(4) then
    actor:send("- <b:white>" .. tostring(item4) .. "</>")
end
-- list items to be returned
if stage ~= 4 then
    actor:send("We still need:")
end
if stage == 2 and not have(1) then
    actor:send("to assist <b:white>" .. tostring(receive1) .. "</>.")
    if (actor:get_quest_var("megalith_quest:east") or 0) ~= 1 then
        actor:send("She needs " .. tostring(item1))
    else
        actor:send("Please check with her to see what she needs.")
    end
elseif item1 and not have(1) then
    actor:send("<b:white>" .. tostring(item1) .. "</>")
end
if stage == 2 and not have(2) then
    actor:send("to assist <b:red>" .. tostring(receive2) .. "</>.")
    if (actor:get_quest_var("megalith_quest:south") or 0) ~= 1 then
        actor:send("She needs " .. tostring(item2))
    else
        actor:send("Please check with her to see what she needs.")
    end
elseif item2 and not have(2) then
    actor:send("<b:white>" .. tostring(item2) .. "</>")
end
if stage == 2 and not have(3) then
    actor:send("to assist <b:green>" .. tostring(receive3) .. "</>.")
    if (actor:get_quest_var("megalith_quest:north") or 0) ~= 1 then
        actor:send("She needs " .. tostring(item3))
    else
        actor:send("Please check with her to see what she needs.")
    end
elseif item3 and not have(3) then
    actor:send("<b:white>" .. tostring(item3) .. "</>")
end
if stage == 2 and not have(4) then
    actor:send("to assist <b:cyan>" .. tostring(receive4) .. "</>.")
    if (actor:get_quest_var("megalith_quest:west") or 0) ~= 1 then
        actor:send("She needs " .. tostring(item4))
    else
        actor:send("Please check with her to see what she needs.")
    end
elseif stage == 1 and item4 and not have(4) then
    actor:send("<b:white>" .. tostring(item4) .. "</>")
end
if receive5 then
    actor:send(self_name .. " says, 'Please bring these to me.'")
end
return _return_value$trig$, '626bd4061113a45485a3e0cd3dc126a7'),
  -- data/triggers/123/123_13_megalith_quest_keeper_greet.lua
  (123, 13, $trig$-- Converted from DG Script #12313: megalith_quest_keeper_greet
-- Original: MOB trigger, flags: GREET, probability: 100%

-- TODO(parity): references an unrelated `type_wand` quest with an
-- undefined `wandstep` local at the top; that block needs to be either
-- restored from the original or removed if no longer relevant.

wait(0.2)
if actor:get_quest_stage("type_wand") == "wandstep" and not actor:get_has_failed("megalith_quest") then
    local minlevel = (wandstep - 1) * 10
    if actor.level >= minlevel then
        if (actor:get_quest_var("type_wand:greet") or 0) == 0 then
            self.room:send(tostring(self.name) .. " says, 'I see you're crafting something.  If you want my help, we can talk about <b:cyan>[upgrades]</>.'")
        else
            self:say("Do you have what I need for the wand?")
        end
        wait(1)
    end
end
local stage = actor:get_quest_stage("megalith_quest")
-- switch on self.id
do
    if (self.zone_id == 123 and self.id == 3) then
        if actor:get_has_completed("megalith_quest") then
            self:command("cheer")
            wait(1)
            self:say("I can feel the Earth rejoicing from here to Templace!  Surely with Her blessing we can move to cleanse the ancient home of my people.")
        elseif actor:get_has_failed("megalith_quest") then
            self:emote("drops to the ground.")
            wait(1)
            self:say("All hope is lost...  Without Her blessing, the demons will rampage forever.")
        elseif (stage == 2) and ((actor:get_quest_var("megalith_quest:item4") or 0) == 1) then
            self:command("bow " .. tostring(actor.name))
            wait(1)
            self:say("I thank you most humbly for your assistance with calling the Spirits of Earth.")
        elseif stage > 2 then
            self:say("Finally, our Mother Goddess will be able to walk our world again!")
        elseif (stage == 2) and ((actor:get_quest_var("megalith_quest:item4") or 0) ~= 0) and ((actor:get_quest_var("megalith_quest:north") or 0) ~= 0) then
            self:command("bow " .. tostring(actor.name))
            self.room:send(tostring(self.name) .. " speaks in voice like a gentle breeze across sunlit grass, 'Are you here to help me summon the Spirits of Earth to protect our coven?'")
        elseif (stage == 2) and ((actor:get_quest_var("megalith_quest:item4") or 0) ~= 0) and ((actor:get_quest_var("megalith_quest:north") or 0) ~= 1) then
            self:say("Do you have the granite ring?")
        end
    elseif (self.zone_id == 123 and self.id == 4) then
        if actor:get_has_completed("megalith_quest") then
            self:say("This land is again full with the pulse, the pull, the bloodpump of creation...")
            self:command("bow " .. tostring(actor.name))
            wait(1)
            self:say("Thanks to you.")
        elseif actor:get_has_failed("megalith_quest") then
            self.room:send(tostring(self.name) .. " begins to mutter to the standing stone, 'Destruction, greater than you or I can ever imagine...'")
            wait(1)
            self.room:send(tostring(self.name) .. " continues to mutter... 'A wave of protean fire curls around the planet and bares the world clean as bone...'")
        elseif (stage == 2) and ((actor:get_quest_var("megalith_quest:item2") or 0) == 1) then
            self:command("nod " .. tostring(actor.name))
            wait(1)
            self:say("I thank you most humbly for your assistance with calling the Spirits of Fire.")
        elseif stage > 2 then
            self.room:send(tostring(self.name) .. " whispers, 'Feel that?  That tingle in your veins?'")
            wait(1)
            self:say("That is the Lady of the Stars.  She approaches...")
            self.room:send(tostring(self.name) .. " takes a deep breath and exhales a cloud of <b:red>s</><red>p</><b:yellow>a</><red>r</><yellow>k</><b:yellow>s</>!")
        elseif (stage == 2) and ((actor:get_quest_var("megalith_quest:item2") or 0) ~= 0) and ((actor:get_quest_var("megalith_quest:south") or 0) ~= 0) then
            self:command("nod " .. tostring(actor.name))
            self:say("Hail traveler.")
            wait(0.2)
            self.room:send("In a whisper like smokey ash " .. tostring(self.name) .. " says, 'Are you here to help me summon the Spirits of Fire to protect our coven?'")
        elseif (stage == 2) and ((actor:get_quest_var("megalith_quest:item2") or 0) ~= 0) and ((actor:get_quest_var("megalith_quest:south") or 0) ~= 1) then
            self:say("I hope you brought the flaming jewel from Vulcera.")  -- typo: sat
        end
    elseif (self.zone_id == 123 and self.id == 5) then
        if actor:get_has_completed("megalith_quest") then
            self:command("dance " .. tostring(actor.name))
            wait(0.4)
            self:say("Finally we might be able to heal my poor family in Nordus!")
            wait(3)
            self:say("Can't you feel it?  The breath, the pull...")
            self:emote("exclaims in a ringing voice, 'Glory to - !!'")
            self:command("laugh")
        elseif actor:get_has_failed("megalith_quest") then
            self:emote("stands completely still, staring off into the void.")
            wait(1)
            self:say("Huh.")
        elseif (stage == 2) and ((actor:get_quest_var("megalith_quest:item3") or 0) == 1) then
            self:command("wave " .. tostring(actor.name))
            wait(0.4)
            self:say("Thanks so much for your help with the Air Spirits!")
        elseif stage > 2 then
            self.room:send(tostring(self.name) .. " proclaims, 'Rejoice, the Great Work continues!  Soon the Faerie Goddess will be with us!'")
        elseif (stage == 2) and ((actor:get_quest_var("megalith_quest:item3") or 0) ~= 0) and ((actor:get_quest_var("megalith_quest:east") or 0) ~= 0) then
            self:command("wave " .. tostring(actor.name))
            wait(0.4)
            self.room:send("In a jubilant tone, " .. tostring(self.name) .. " says, 'Hi there! Are you here to help me summon the Spirits of Air to protect our coven?'")
        elseif (stage == 2) and ((actor:get_quest_var("megalith_quest:item3") or 0) ~= 0) and ((actor:get_quest_var("megalith_quest:east") or 0) ~= 1) then
            wait(0.2)
            self:say("I hope you were able to recover that cloud bracelet!")
        end
    elseif (self.zone_id == 123 and self.id == 6) then
        if actor:get_has_completed("megalith_quest") then
            self:emote("stifles tears of joy.")
            wait(1)
            self:say("I am overjoyed to see my Mother once again!  I can hear the rivers sing across Ethilien.  Our coven may be able to bring balance where the Dreaming flooded into the mortal realm at last.")
        elseif actor:get_has_failed("megalith_quest") then
            self:say("A catastrophe...  As terrible as the night the Dream engulfed the Syric Mountains...")
            wait(2)
            self:emote("begins to slip into a fugue.")
            wait(4)
            self:say("I still remember that night...")
        elseif (stage == 2) and ((actor:get_quest_var("megalith_quest:item4") or 0) == 1) then
            self:command("curtsy " .. tostring(actor.name))
            wait(2)
            self:say("Spirits of Water overflow from the Dreaming into this realm, thanks to you!")
        elseif stage > 2 then
            self:say("Thanks to you, soon the Great Mother will be able to come from the Deep Dreaming once more!")
            self:command("hug " .. tostring(actor.name))
        elseif (stage == 2) and ((actor:get_quest_var("megalith_quest:item4") or 0) ~= 0) and ((actor:get_quest_var("megalith_quest:west") or 0) ~= 0) then
            self:command("curtsy " .. tostring(actor.name))
            wait(1)
            self:say("Merry met!")
            wait(2)
            self.room:send(tostring(self.name) .. " speaks in a silver voice, like bells reverberating over water, 'Are you here to help me summon the Spirits of Water to protect our coven?'")
        elseif (stage == 2) and ((actor:get_quest_var("megalith_quest:item4") or 0) ~= 0) and ((actor:get_quest_var("megalith_quest:west") or 0) ~= 1) then
            self:say("Have you been able to bring me some water?")
        end
    end
end$trig$, 'c319ae29da0202f79d3aceab44ddb766'),
  -- data/triggers/123/123_15_megalith_quest_keeper_receive.lua
  (123, 15, $trig$-- Converted from DG Script #12315: megalith_quest_keeper_receive
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
-- This trigger is used to collect all the items for stage 2.
--
-- TODO(parity): self.id checks use legacy 5-digit vnums (12303..12306).
-- Once split, swap to self.local_id (3..6 in zone 123). Same for the
-- vessel checks (41110, 41111, 18512) and per-Keeper "need" object IDs
-- (55020, 48109, 8301).

local item = object.id
local me = self.id

-- Hoisted from branch-scoped locals in the converter output.
local direction
local part
local nxt
local need

if (self.zone_id == 123 and self.id == 3) then
    -- North, Earth - Granite Ring from Tech
    direction = "north"
    part = 4
    nxt = 12301
    need = 55020
elseif (self.zone_id == 123 and self.id == 4) then
    -- South, Fire - Fiery Eye from Fiery Island
    direction = "south"
    part = 2
    nxt = 12306
    need = 48109
elseif (self.zone_id == 123 and self.id == 5) then
    -- East, Air - cumulus bracelet from Dargentan
    direction = "east"
    part = 1
    nxt = 12304
    need = 8301
elseif (self.zone_id == 123 and self.id == 6) then
    -- West, Water - water from the hidden spring, or not - BAD STUFF
    -- This Keeper's request is the one to watch out for.
    direction = "west"
    part = 3
    nxt = 12303
    need = actor:get_quest_var("megalith_quest:goblet")
end

if actor:get_quest_stage("megalith_quest") == 2 then
    if (item == need) or ((self.zone_id == 123 and me == 6) and ((object.zone_id == 411 and item == 10) or (object.zone_id == 411 and item == 11) or (object.zone_id == 185 and item == 12))) then
        -- Already given, right item.
        local part_key = "item" .. tostring(part)
        if (actor:get_quest_var("megalith_quest:" .. part_key) or 0) == 1 then
            self:command("shake")
            self:say("You've already given me this.")
            return _return_value
        elseif (actor:get_quest_var("megalith_quest:" .. direction) or 0) == 1 then
            -- Right item, wrong order.
            if part > 1 then
                local check = part - 1
                local check_key = "item" .. tostring(check)
                if (actor:get_quest_var("megalith_quest:" .. check_key) or 0) == 0 then
                    self:command("shake")
                    self.room:send(tostring(self.name) .. " says, 'We must cast the circle in order:")
                    self.room:send("East, South, West, North.")
                    self.room:send("Please deliver your offerings in that order.'")
                    return _return_value
                end
            end
            -- Right set, wrong specific vessel at West.
            if (self.zone_id == 123 and me == 6) and ((item ~= need) or (object.val2 ~= 0)) then
                self:command("shake")
                self:say("I need water returned in the cup " .. tostring(mobiles.template(123, 1).name) .. " has consecrated.")
                return _return_value
            else
                wait(0.2)
                actor:set_quest_var("megalith_quest", direction, 0)
                actor:set_quest_var("megalith_quest", part_key, 1)
                if direction == "north" then
                    self:say("Ah, excellent!  This will make a perfect offering.")
                    wait(0.6)
                    self.room:send(tostring(self.name) .. " places " .. tostring(object.shortdesc) .. " before the menhir and kneels.")
                    wait(2)
                    self.room:send(tostring(self.name) .. " chants:")
                    self.room:send("'Hail to the guardian Spirits of the North")
                    self.room:send("</>Spirits of Earth and Determination")
                elseif direction == "south" then
                    self:say("Marvelous!  This will make a perfect offering.")
                    wait(0.6)
                    self.room:send(tostring(self.name) .. " raises " .. tostring(object.shortdesc) .. " above her head.")
                    wait(2)
                    self.room:send(tostring(self.name) .. " chants:")
                    self.room:send("'Hail to the guardian Spirits of the South")
                    self.room:send("</>Spirits of Fire and Feeling")
                elseif direction == "east" then
                    self:say("Great!  This will make a perfect offering.")
                    wait(0.6)
                    self.room:send(tostring(self.name) .. " shakes out " .. tostring(object.shortdesc) .. " like a blanket.")
                    self.room:send("She watches with delight as it dissolves into wisps of cloudy mist.")
                    wait(4)
                    self.room:send(tostring(self.name) .. " chants:")
                    self.room:send("'Hail to the guardian Spirits of the East")
                    self.room:send("</>Spirits of Air and Intellect")
                elseif direction == "west" then
                    if (actor:get_quest_var("megalith_quest:item5") or 0) == 1 then
                        self:say("Ah, delightful!  This water will make a perfect offering.")
                        wait(0.6)
                    else
                        self:say("This will do.")
                        actor:set_quest_var("megalith_quest", "bad2", 1)
                        wait(0.6)
                    end
                    self.room:send(tostring(self.name) .. " pours the water from " .. tostring(object.shortdesc) .. " before the menhir.")
                    wait(2)
                    self.room:send(tostring(self.name) .. " chants:")
                    self.room:send("'Hail to the guardian Spirits of the West")
                    self.room:send("</>Spirits of Water and Intuition")
                end
                self.room:send("</>I present this offering to you.")
                self.room:send("</>Aid us in our magical working on this great day.'")
                wait(5)
                world.destroy(object)
                self.room:send("The menhir begins to hum and glow!")
                wait(3)
                -- Next person.
                if ((actor:get_quest_var("megalith_quest:item1") or 0) == 1) and ((actor:get_quest_var("megalith_quest:item2") or 0) == 1) and ((actor:get_quest_var("megalith_quest:item3") or 0) == 1) and ((actor:get_quest_var("megalith_quest:item4") or 0) == 1) then
                    self:say("Now, return to " .. tostring(mobiles.template(123, 1).name) .. " at the altar and help her finish the call!")
                else
                    -- TODO(parity): nxt is still a legacy 5-digit vnum.
                    -- Translate to (zone, local_id) for catalog lookup.
                    local nxt_zone = math.floor(nxt / 100)
                    local nxt_id = nxt % 100
                    local nxt_template = mobiles.template(nxt_zone, nxt_id)
                    local nxt_name = nxt_template and nxt_template.name or ("the next Keeper")
                    self:say("Now, proceed to " .. tostring(nxt_name) .. " and continue invoking the elements.")
                end
            end
        end
    end
end
return _return_value$trig$, '32dcae012debcb4a86ee18fd98fa86a1'),
  -- data/triggers/123/123_23_megalith_quest_mother_act_kneel_rewards.lua
  (123, 23, $trig$-- Converted from DG Script #12323: megalith_quest_mother_act_kneel_rewards
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: kneel
if not (cmd == "kneel") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
-- Legacy `return 0` comes first: the typed kneel always goes ahead.
_return_value = true
allow_command()
wait(0.2)
local bad1 = ((actor:get_quest_var("megalith_quest:bad1") or 0) == 1) and 1 or 0
local bad2 = ((actor:get_quest_var("megalith_quest:bad2") or 0) == 1) and 1 or 0
local bad3 = ((actor:get_quest_var("megalith_quest:bad3") or 0) == 1) and 1 or 0
if actor:get_quest_stage("megalith_quest") == 5 then
    local total = bad1 + bad2 + bad3
    if total == 0 then
        actor:send(tostring(self.name) .. " gently leans forward and kisses your brow.")
        self.room:send_except(actor, tostring(self.name) .. " gently leans forward and kisses " .. tostring(actor.name) .. "'s brow.")
        wait(2)
        self.room:send(tostring(self.name) .. " says, 'I bestow upon you the gifts of stars.  May their light")
        self.room:send("</>guide you the rest of your days.'")
        self.room:spawn_object(123, 98)
        self.room:spawn_object(123, 99)
        self:command("give belt-stars " .. tostring(actor.name))
        self:command("give starseed " .. tostring(actor.name))
        local gem = 0
        while gem < 3 do
            -- TODO(parity): the original drop pool used legacy 5-digit
            -- vnums 55736..55747. After the (zone, local_id) split, this
            -- gem set should live at zone 557 ids 36..47. Verify.
            self.room:spawn_object(557, 36 + random(1, 11))
            gem = gem + 1
        end
        self:command("give all.gem " .. tostring(actor.name))
    elseif total > 0 then
        actor:send(tostring(self.name) .. " places her hand on your shoulder.")
        self.room:send_except(actor, tostring(self.name) .. " places her hand on " .. tostring(actor.name) .. "'s shoulder.")
        wait(2)
        self.room:send(tostring(self.name) .. " says, 'I bestow upon you a gift of stars.  May its light")
        self.room:send("</>guide you the rest of your days.'")
        local pick = random(1, 2)
        if pick == 1 then
            self.room:spawn_object(123, 98)
        elseif pick == 2 then
            self.room:spawn_object(123, 99)
        end
        local gem = 0
        while gem < 3 do
            self.room:spawn_object(557, 36 + random(1, 11))
            gem = gem + 1
        end
        self:command("give all " .. tostring(actor.name))
        wait(0.4)
        self:command("bow " .. tostring(actor.name))
    end
    -- Clear all the Bads, just in case.
    for slot = 1, 5 do
        actor:set_quest_var("megalith_quest", "bad" .. tostring(slot), 0)
    end
    actor:complete_quest("megalith_quest")
    -- Set X to the level of the award.
    local expcap
    if actor.level < 70 then
        expcap = actor.level
    else
        expcap = 70
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
    -- Adjust exp award by class so all classes receive the same proportionate amount.
    if actor.class == "warrior" or actor.class == "berserker" then
        -- 110% of standard
        expmod = expmod + (expmod / 10)
    elseif actor.class == "paladin" or actor.class == "anti-paladin" or actor.class == "ranger" then
        -- 115% of standard
        expmod = expmod + ((expmod * 2) / 15)
    elseif actor.class == "sorcerer" or actor.class == "pyromancer" or actor.class == "cryomancer" or actor.class == "illusionist" or actor.class == "bard" then
        -- 120% of standard
        expmod = expmod + (expmod / 5)
    elseif actor.class == "necromancer" or actor.class == "monk" then
        -- 130% of standard
        expmod = expmod + (expmod * 2) / 5
    end
    actor:send("<b:yellow>You gain experience!</>")
    local setexp = (expmod * 10)
    local loop = 0
    while loop < 10 do
        actor:award_exp(setexp)
        loop = loop + 1
    end
end
return _return_value$trig$, 'b837ab563513ea4b2810279643057d2f'),
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
    wait(0.2)
    if (actor:get_quest_var("megalith_quest:hexpo") or 0) == 0 then
        self:say("I am the high priestess of a sacred sisterhood of witches dedicated to the worship of the faerie goddess the Great Mother, Lady of Stars.")
        wait(4)
        self:say("We strive to keep the Old Ways alive, as our foremothers did, and their foremothers before them, and their foremothers before them, back through the centuries.")
        wait(0.2)
        self.room:send(tostring(self.name) .. " says, 'Say <b:cyan>continue</> when you want to hear more.'")
        actor:set_quest_var("megalith_quest", "hexpo", 1)
    elseif (actor:get_quest_var("megalith_quest:hexpo") or 0) == 1 then
        self:say("Witchcraft has always been in my blood.")
        wait(2)
        self:say("The people of my homeland in the Green Green Sea still observe the Old Ways.  The Fair Folk still walk among us.  A bocan hobgoblin or two playing tricks on you is part of our daily routine.  Every woman in the village knows how to mix herbs and what to do when you see a ghost.")
        wait(4)
        self:say("I was, and still am, nothing special.")
        wait(0.2)
        self.room:send(tostring(self.name) .. " says, 'Say <b:cyan>continue</> when you want to hear more.'")
        actor:set_quest_var("megalith_quest", "hexpo", 2)
    elseif (actor:get_quest_var("megalith_quest:hexpo") or 0) == 2 then
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
        wait(0.2)
        self.room:send(tostring(self.name) .. " says, 'Say <b:cyan>continue</> when you want to hear more.'")
        actor:set_quest_var("megalith_quest", "hexpo", 3)
    elseif (actor:get_quest_var("megalith_quest:hexpo") or 0) == 3 then
        self:say("She charged me with seeking out this coven.  I dedicated myself to Her service and through years of loving care and gentle insight, I have become Her priestess as we push to revitalize the Old Ways.")
        wait(0.2)
        self.room:send(tostring(self.name) .. " says, 'Say <b:cyan>continue</> when you want to hear more.'")
        actor:set_quest_var("megalith_quest", "hexpo", 4)
    elseif (actor:get_quest_var("megalith_quest:hexpo") or 0) == 4 then
        self:say("Like myself, my Sisters hail from every corner of Ethilien.")
        wait(2)
        self:say("Some are just women called to our coven to provide succor to others.")
        wait(3)
        self:say("Others have more... unusual stories which have led them to the Faerie Mother.")
        wait(3)
        self.room:send(tostring(self.name) .. " says, 'Yet today, we have all come to this place to <b:cyan>perform the Great Rite of Invocation.</>'")
        actor:set_quest_var("megalith_quest", "hexpo", 0)
    end
end$trig$, '251c70331ff3e9e223b9837436261b26'),
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
        self:say("To assist in the Great Rite of Invocation, in my duty duty as defender, I am casting and reinforcing a circle of protection between these smaller menhir.")
        wait(4)
        self:say("I will maintain it throughout the rite.")
        actor:set_quest_var("megalith_quest", "vexpo", 0)
    end
end$trig$, '5ea4653f2555cd351a7d16d5212081d3'),
  -- data/triggers/123/123_37_north_exposition.lua
  (123, 37, $trig$-- Converted from DG Script #12337: north_exposition
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
    if (actor:get_quest_var("megalith_quest:nexpo") or 0) == 0 then
        self:say("After Sagece's siege on our ancestral home, my family sought refuge with our frost relatives near the land of the Great Snow Leopard.")
        wait(3)
        self:say("The Children of the Snow Leopard instilled a love of stone in me.  Not just a love of magical stone, their enchanted jades or mystic crystals, but mundane stone too, because it so often is more than meets the eye.")
        wait(0.2)
        self.room:send(tostring(self.name) .. " says, 'Say <b:cyan>continue</> when you want to hear more.'")
        actor:set_quest_var("megalith_quest", "nexpo", 1)
    elseif (actor:get_quest_var("megalith_quest:nexpo") or 0) == 1 then
        self:say("As it turns out, that love was an extension of my natural affinity for Earth and nature.")
        wait(2)
        self:say("When I was a young woman of about 140 or so, I joined an order of arctic druids.  We worshiped in the Old Ways, paying respect to the cosmos from before the New Gods.")
        wait(4)
        self:say("In the Old Ways, I heard the voices of my ancestors.")
        wait(3)
        self:say("In the Old Ways, I heard the voice of my ancient Mother.")
        wait(0.2)
        self.room:send(tostring(self.name) .. " says, 'Say <b:cyan>continue</> when you want to hear more.'")
        actor:set_quest_var("megalith_quest", "nexpo", 2)
    elseif (actor:get_quest_var("megalith_quest:nexpo") or 0) == 2 then
        self:say("She revealed to me that, just as we elves and the Fair Folk once shared a home in the Dreaming, our various traditions have common roots as well.")
        wait(5)
        self:say("Druidry and witchcraft are the same traditions, just viewed through different lenses.")
        wait(0.2)
        self.room:send(tostring(self.name) .. " says, 'Say <b:cyan>continue</> when you want to hear more.'")
        actor:set_quest_var("megalith_quest", "nexpo", 3)
    elseif (actor:get_quest_var("megalith_quest:nexpo") or 0) == 3 then
        self:say("After many years, the Great Mother called upon me to find this Sisterhood.")
        wait(2)
        self:say("I believe She is guiding me to bring peace to my elven ancestors by bringing Her back to this realm and, with the aid of my Sisters, cleansing the demonic corruption of Templace.")
        wait(4)
        self:say("By growing up in a valley of frost and snow, I learned even the coldest winter is part of the natural cycle.  Even in the coldest places, spring eventually comes and the world is reborn.")
        wait(5)
        self:say("For beneath it all, the Earth rests.  Timeless.")
        wait(1)
        self:say("Just like I am.")
        actor:set_quest_var("megalith_quest", "nexpo", 0)
    end
end$trig$, '428f3abdbb4f6436da94b6a844c5d287'),
  -- data/triggers/123/123_38_south_exposition.lua
  (123, 38, $trig$-- Converted from DG Script #12338: south_exposition
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
    if (actor:get_quest_var("megalith_quest:sexpo") or 0) == 0 then
        self:say("I am Keeper of the South, the warden of fire.  As befits my station, I hail from an island where molten fire reigns supreme.  It flows from the mountain, touches the sky, and meets the ocean.")
        wait(6)
        self:say("When murderous \"adventurers\" come from the Three Cities to loot my homeland, they see a hostile land subjugated by a petty and cruel demigoddess where the people live without stone monuments for homes.")
        wait(6)
        self:say("They, marauding lunatics that they are, call us \"savage\" and \"uncivilized\".  They think us inferior for living in the ways of the land and not claiming dominion over the volcano.")
        wait(5)
        self:say("That the volcano goddess was once beloved by the God of the Moonless Night -")
        self.room:send("</>")
        self:emote(tostring(self.name) .. " makes a face and spits on the ground and utters,")
        self:say("- may he ever suffer terrible vengeance -")
        self.room:send("</>")
        self.room:send(tostring(self.name) .. " continues, ' - does not help either.'")
        wait(0.2)
        self.room:send(tostring(self.name) .. " says, 'Say <b:cyan>continue</> when you want to hear more.'")
        actor:set_quest_var("megalith_quest", "sexpo", 1)
    elseif (actor:get_quest_var("megalith_quest:sexpo") or 0) == 1 then
        self:say("But living in the ways of the jungle does not make us \"savage\".  To my Jungle Tribe, we cannot stop Vulcera or the volcano, for it is the natural ebb and flow of creation.")
        wait(6)
        self:say("I spent several years apprenticed to the old island shaman learning not how to prevent this process, but how to shape it.")
        wait(0.2)
        self.room:send(tostring(self.name) .. " says, 'Say <b:cyan>continue</> when you want to hear more.'")
        actor:set_quest_var("megalith_quest", "sexpo", 2)
    elseif (actor:get_quest_var("megalith_quest:sexpo") or 0) == 2 then
        self:say("It was during those years I first felt the primordial churn in the stellar inferno of the cosmos.  Just like within the fires of the volcano, I could feel the pulse of creation beating in the heart of each star.")
        wait(0.2)
        self.room:send(tostring(self.name) .. " says, 'Say <b:cyan>continue</> when you want to hear more.'")
        actor:set_quest_var("megalith_quest", "sexpo", 3)
    elseif (actor:get_quest_var("megalith_quest:sexpo") or 0) == 3 then
        self:say("One summer, several Sisters of the coven stopped at my village on their way to seek guidance from the old wise woman of the Mountain Tribe.")
        wait(5)
        self:say("I expected they would bring nothing but death and belittlement like all outsiders do.")
        wait(2)
        self:say("But when they expressed great concern for the volcano and the creatures within, I was greatly surprised.")
        wait(0.2)
        self.room:send(tostring(self.name) .. " says, 'Say <b:cyan>continue</> when you want to hear more.'")
        actor:set_quest_var("megalith_quest", "sexpo", 4)
    elseif (actor:get_quest_var("megalith_quest:sexpo") or 0) == 4 then
        self:say("They became welcomed guests and gradually friends.  They returned many times, each time asking me to join them, calling me Sister in the Old Ways.  After many meetings, I finally relented and left my home for the first time.")
        wait(6)
        self:say("I was reluctant at first, but I have come to see we walk the same paths as keepers of the land.  The sacred duties we share unite us in purpose beyond blood - we are truly Sisters.")
        actor:set_quest_var("megalith_quest", "sexpo", 0)
    end
end$trig$, '026d3869c0f0589e4d2c7628b3b8752f'),
  -- data/triggers/123/123_39_east_exposition.lua
  (123, 39, $trig$-- Converted from DG Script #12339: east_exposition
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
    if (actor:get_quest_var("megalith_quest:eexpo") or 0) == 0 then
        self:say("Who am I?  Are you sure you want to know?")
        self:emote("looks around slightly confused.")
        wait(4)
        self:say("Well, okay!  I come from the \"Fourth City\", Nordus.  Ever heard of it?  We used to be known for --")
        wait(0.2)
        self.room:send(tostring(self.name) .. " suddenly lets out a blood curdling scream!")
        wait(3)
        self.room:send("She continues to scream.")
        wait(3)
        self.room:send("And scream.")
        wait(3)
        self.room:send("And scream.")
        wait(4)
        self.room:send(tostring(self.name) .. " quickly falls silent.")
        self.room:send(tostring(self.name) .. " looks around herself, blinking.")
        wait(4)
        self:say("I'm sorry, did something weird just happen?  If you've ever been to Nordus, you may have seen stuff like that before...")
        wait(0.2)
        self.room:send(tostring(self.name) .. " says, 'Say <b:cyan>continue</> when you want to hear more.'")
        actor:set_quest_var("megalith_quest", "eexpo", 1)
    elseif (actor:get_quest_var("megalith_quest:eexpo") or 0) == 1 then
        self:say("I was an acolyte under the most respected cleric in Nordus, the great Shema.")
        wait(4)
        self:say("Shema was brilliant.  She loved languages and codes, though her favorite magic password was just spelling her name backward!")
        wait(5)
        self:say("She talked about all sorts of languages, like ones called \"Gir-main\" and \"Fence\".")
        self:command("laugh")
        wait(6)
        self:say("Have you ever heard of anything that ridiculous?!  A talking fence?!  Talking front doors, sure, but a fence??  Come on!!")
        self:command("rofl")
        wait(0.2)
        self:emote("wipes a tear from her eye.")
        self.room:send(tostring(self.name) .. " says, 'Aaaahhh Shema, good times...  Say <b:cyan>continue</> when you want to hear more.'")
        actor:set_quest_var("megalith_quest", "eexpo", 2)
    elseif (actor:get_quest_var("megalith_quest:eexpo") or 0) == 2 then
        self:say("Anyway, when Luchiaans arrived in Nordus and the \"sickness\" started, Shema was the only one with enough wit to suspect him.  There was a book she --")
        wait(1)
        self:emote("suddenly focuses intently on a vacant space, as if listening to someone.")
        wait(4)
        self:say("Yes Umberto, the only one besides you.")
        wait(4)
        self.room:send(tostring(self.name) .. " whispers under her breath, 'He doesn't like to be left out...  It makes him feel invisible.'")
        wait(3)
        self:say("Point is, after he arrived, things changed.  For example, I met Umberto here!'")  -- typo: sat
        wait(3)
        self:emote("points at the empty space next to her.")
        wait(0.2)
        self.room:send(tostring(self.name) .. " says, 'Say <b:cyan>continue</> when you want to hear more.'")
        actor:set_quest_var("megalith_quest", "eexpo", 3)
    elseif (actor:get_quest_var("megalith_quest:eexpo") or 0) == 3 then
        self:say("Turns out, Luchiaans had been conducting necromantic experiments on us while looking for a powerful tome about healing the body beyond death hidden in Nordus.")
        wait(5)
        self:say("Shema caught on to his plot, so she warded the book with her favorite code, bundled up a few of us and hit the road!")
        wait(4)
        self:say("We had plenty of adventures before Shema finally kicked the bucket a few years back.")
        wait(0.2)
        self.room:send(tostring(self.name) .. " says, 'Say <b:cyan>continue</> when you want to hear more.'")
        actor:set_quest_var("megalith_quest", "eexpo", 4)
    elseif (actor:get_quest_var("megalith_quest:eexpo") or 0) == 4 then
        self:say("We eventually discovered we carried a part of Nordus within us everywhere we went.")
        wait(3)
        self:say("Luchiaans' experimentations had permanently changed us.  Our magics never really worked the same way again.")
        wait(3)
        self:say("I started... hearing things...  Whispers in the dark, voices when no one was around...")
        wait(3)
        self:say("At first I thought I was finally succumbing to the madness of Nordus, but then I was visited with a revelation from the stars.")
        wait(0.2)
        self.room:send(tostring(self.name) .. " says, 'Say <b:cyan>continue</> when you want to hear more.'")
        actor:set_quest_var("megalith_quest", "eexpo", 5)
    elseif (actor:get_quest_var("megalith_quest:eexpo") or 0) == 5 then
        self:say("Luchiaans' meddling had somehow opened my mind to a deeper consciousness.  By total accident, I connected to the Lady of the Stars on the other side of the Veil!")
        wait(5)
        self:say("She explained the voices I was hearing was the wind calling me to dance.")
        wait(5)
        self:say("Unfit for service to the New Gods anymore, I followed the guidance of our Lady until I ran right into the coven.")
        wait(5)
        self:say("Literally, I ran face-first into " .. tostring(mobiles.template(123, 3).name) .. "!")
        self:command("laugh")
        wait(4)
        self:say("Suddenly everything made sense.  I had found my purpose and a new family.  Umberto and I have been part of the coven ever since.")
        actor:set_quest_var("megalith_quest", "eexpo", 0)
    end
end$trig$, '4215bc9f817da3c6094bf9de344e0046'),
  -- data/triggers/123/123_40_west_exposition.lua
  (123, 40, $trig$-- Converted from DG Script #12340: west_exposition
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
    if (actor:get_quest_var("megalith_quest:wexpo") or 0) == 0 then
        self:say("My home realm, the Reverie, the Dreaming, is a plane of the dreams of mortals made manifest.")
        wait(3)
        self:say("Unlike most of the other fey creatures in Ethilien, I am not in this world by choice.")
        wait(3)
        wait(0.2)
        self.room:send(tostring(self.name) .. " says, 'Say <b:cyan>continue</> when you want to hear more.'")
        actor:set_quest_var("megalith_quest", "wexpo", 1)
    elseif (actor:get_quest_var("megalith_quest:wexpo") or 0) == 1 then
        self:say("I am also unique from my coven Sisters because I knew our Mother.  I was shaped by Her hand directly.  Reaching out from the deepest parts of the Dreaming, The Great Mother formed me from a river in part of the Reverie ruled by a creature known as the Goblin King.")
        wait(0.2)
        self.room:send(tostring(self.name) .. " says, 'Say <b:cyan>continue</> when you want to hear more.'")
        actor:set_quest_var("megalith_quest", "wexpo", 2)
    elseif (actor:get_quest_var("megalith_quest:wexpo") or 0) == 2 then
        self:say("Driven by an insatiable hunger for power and wealth, the Goblin King grew tired of being confined to the Dreaming.")
        wait(4)
        self:say("So, he approached the troll witch Baba Yaga.  Together they concocted a way to pierce the veil between the world and merge his court with the mortal realm.")
        wait(4)
        self:say("Not caring what the consequences might be, they tore the Goblin King's land from the Reverie and smashed it into the Syric Mountains.")
        wait(0.2)
        self.room:send(tostring(self.name) .. " says, 'Say <b:cyan>continue</> when you want to hear more.'")
        actor:set_quest_var("megalith_quest", "wexpo", 3)
    elseif (actor:get_quest_var("megalith_quest:wexpo") or 0) == 3 then
        self:say("In the chaos that ensued, I could still hear my Mother's voice.  She whispered to me that there was a new world waiting beyond the Dreaming and She would be there, with a new family if I dared to dream it.")
        wait(4)
        self:say("I chose to leave.")
        wait(0.2)
        self.room:send(tostring(self.name) .. " says, 'Say <b:cyan>continue</> when you want to hear more.'")
        actor:set_quest_var("megalith_quest", "wexpo", 4)
    elseif (actor:get_quest_var("megalith_quest:wexpo") or 0) == 4 then
        self:say("The Great Mother guided me to the coven, who welcomed me with open arms and introduced this world to me.")
        wait(3)
        self:say("Being among mortals, meeting the long-descended elven children of my ancient siblings, climbing the rocky peaks, dancing in the golden pastures of Ethilien...")
        wait(5)
        self:say("I have awakened to a splendor I feared I would lose forever, with a kind of family I never had.")
        wait(3)
        self:say("She had taken me from one Dream and set me free in another.")
        actor:set_quest_var("megalith_quest", "wexpo", 0)
    end
end$trig$, '5f7c0a6b9fde78919363fb651ed3d330'),
  -- data/triggers/123/123_42_keeper_refuse.lua
  (123, 42, $trig$-- Converted from DG Script #12342: Keeper refuse
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
--
-- TODO(parity): self.id checks use legacy 5-digit vnums (12303..12306).
-- After the (zone, local_id) split they should become self.local_id 3..6
-- in zone 123. The `need` IDs (55020, 48109, 8301) are also legacy.
-- TODO(parity): the original DG had a guard `if object.id == %wandgem%
-- or %wandtask3% or %wandtask4% or %wand_id%` that referenced globals
-- from the wand-crafting quest. Those globals are not exposed in the
-- new runtime, so the guard now skips that pass-through. Restore once
-- the wand quest's exported IDs are available, otherwise the Keepers
-- will refuse wand components when they should have ignored them.

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
    -- TODO(parity): need is still a legacy 5-digit vnum.
    if not need then return "the offering" end
    local nz = math.floor(need / 100)
    local nid = need % 100
    local tmpl = objects.template(nz, nid)
    return tmpl and tmpl.name or "the offering"
end

if actor:get_quest_stage("megalith_quest") < 2 then
    self:command("shake")
    self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
    wait(0.2)
    self:say("I'm sorry, I'm quite busy right now.")
elseif actor:get_quest_stage("megalith_quest") > 2 or (actor:get_quest_stage("megalith_quest") == 2 and (actor:get_quest_var("megalith_quest:item" .. tostring(part)) or 0) == 1) then
    self:command("shake")
    self:say("I don't need any additional assistance at the moment, thank you.")
    if (self.zone_id == 123 and self.id == 6) then
        self:command("curtsy " .. tostring(actor.name))
    else
        self:command("bow " .. tostring(actor.name))
    end
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
    else
        if ((self.zone_id == 123 and self.id == 3) and (object.zone_id == 550 and object.id == 20)) or ((self.zone_id == 123 and self.id == 4) and (object.zone_id == 481 and object.id == 9)) or ((self.zone_id == 123 and self.id == 5) and (object.zone_id == 83 and object.id == 1)) or ((self.zone_id == 123 and self.id == 6) and ((object.zone_id == 411 and object.id == 10) or (object.zone_id == 411 and object.id == 11) or (object.zone_id == 185 and object.id == 12))) then
            return _return_value
        else
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
return _return_value$trig$, '229cc3b7d7918b1f3c181f8449869369'),
  -- data/triggers/125/125_25_demonlordbow.lua
  (125, 25, $trig$-- Converted from DG Script #12525: DemonLordBow
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: bow (reject the abbreviations 'b' and 'bo')
if not (cmd == "bow") then
    return true  -- Not our command
end
if cmd == "b" or cmd == "bo" then
    return true
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
local krisenna = 0
local hell = 0
local go = nil
for _, person in ipairs(actor.group) do
    if person.room == self.room then
        if person:get_quest_stage("krisenna_quest") == 2 then
            krisenna = person:get_quest_stage("krisenna_quest")
            person:advance_quest("krisenna_quest")
            person:send("<b:white>You have advanced the quest!</>")
            go = "zone"
        end
    end
end
if actor:get_quest_stage("hell_trident") == 2 then
    hell = actor:get_quest_stage("hell_trident")
    if actor.level >= 90 then
        if not actor:get_quest_var("hell_trident:helltask5") then
            if actor:get_has_completed("resurrection_quest") then
                actor:set_quest_var("hell_trident", "helltask5", 1)
            end
        end
        if not actor:get_quest_var("hell_trident:helltask4") then
            if actor:get_has_completed("hell_gate") then
                actor:set_quest_var("hell_trident", "helltask4", 1)
            end
        end
        if (actor:get_quest_var("hell_trident:greet") or 0) == 1 then
            go = "trident"
        else
            go = "zone"
        end
    end
end
if go then
    actor:send("You bow before him.")
    self.room:send_except(actor, tostring(actor.name) .. " bows before " .. tostring(self.name) .. ".")
    wait(1)
    if go == "trident" then
        self:say("I see you still remember your manners.")
        wait(1)
        actor:send(tostring(self.name) .. " says, 'Why have you returned?  Have you brought your sacrifices?'")
        if krisenna == 2 then
            wait(1)
            actor:send(tostring(self.name) .. " says, 'Or is it something else?'")
        end
    elseif go == "zone" then
        self:say("Ah yes, the respect I deserve.")
        wait(1)
        self:command("peer " .. tostring(actor.name))
        wait(2)
        self:say("What brings you to me?")
        wait(0.2)
        if hell == 2 then
            actor:send(tostring(self.name) .. " says, 'Your quest for a new <b:cyan>[trident]</> perhaps?'")
            if krisenna == 2 then
                wait(1)
                actor:send(tostring(self.name) .. " says, 'Or is it something else?'")
            end
        end
    end
end
return _return_value$trig$, 'ff22f977bafd63b4f42bc61c9eddc222'),
  -- data/triggers/125/125_35_krisenna_greet.lua
  (125, 35, $trig$-- Converted from DG Script #12535: Krisenna greet
-- Original: MOB trigger, flags: GREET_ALL, probability: 100%
if actor:get_quest_stage("hell_trident") == 2 then
    if actor.level >= 90 then
        wait(0.2)
        if not actor:get_quest_var("hell_trident:helltask5") then
            if actor:get_has_completed("resurrection_quest") then
                actor:set_quest_var("hell_trident", "helltask4", 1)
            end
        end
        if not actor:get_quest_var("hell_trident:helltask4") then
            if actor:get_has_completed("hell_gate") then
                actor:set_quest_var("hell_trident", "helltask5", 1)
            end
        end
        if (actor:get_quest_var("hell_trident:greet") or 0) == 1 then
            local job1 = actor:get_quest_var("hell_trident:helltask1")
            local job2 = actor:get_quest_var("hell_trident:helltask2")
            local job3 = actor:get_quest_var("hell_trident:helltask3")
            local job4 = actor:get_quest_var("hell_trident:helltask4")
            local job5 = actor:get_quest_var("hell_trident:helltask5")
            local job6 = actor:get_quest_var("hell_trident:helltask6")
            if job1 and job2 and job3 and job4 and job5 and job6 then
                actor:send(tostring(self.name) .. " says, 'Your soul is ready to strike a pact.  Give me the trident to seal it.'")
            else
                actor:send(tostring(self.name) .. " says, 'Have you returned to meet my demands?'")
            end
        end
    end
end$trig$, 'daa7f0fd73cff9937e8cc9f28425dfd4'),
  -- data/triggers/163/163_01_quest_eleweiss_ranger_druid_subclass_greet.lua
  (163, 1, $trig$wait(0.2)

local wandstep = actor:get_quest_stage("type_wand")
if (wandstep or 0) > 0 then
    local minlevel = (wandstep - 1) * 10
    if actor.level >= minlevel then
        if (actor:get_quest_var("type_wand:greet") or 0) == 0 then
            actor:send(tostring(self.name) .. " says, 'I see you're crafting something.  If you want my help, we can talk about <b:cyan>[upgrades]</>.'")
        elseif actor:get_quest_var("type_wand:wandtask1")
            and actor:get_quest_var("type_wand:wandtask2")
            and actor:get_quest_var("type_wand:wandtask3") then
            actor:send(tostring(self.name) .. " says, 'Oh good, you're all set!  Let me see the staff.'")
        else
            -- TODO(parity): `weapon` was a DG global naming the in-progress weapon.
            actor:send(tostring(self.name) .. " says, 'Do you have what I need for the staff?'")
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
end$trig$, 'b68ccd320745a3e03a4789c143e1456b'),
  -- data/triggers/163/163_55_moonwell_map_1_receive.lua
  (163, 55, $trig$if actor:get_quest_stage("moonwell_spell_quest") ~= 6 then
    return true
end

if (actor:get_quest_var("moonwell_spell_quest:map") or 0) == 1 then
    actor:advance_quest("moonwell_spell_quest")
    actor:set_quest_var("moonwell_spell_quest", "map", 0)
    wait(0.2)
    self:destroy_item("map")
    self.room:spawn_object(163, 52)
    wait(1.5)
    self.room:send(tostring(self.name) .. " quickly marks something on the bark map.")
    self:command("give map " .. tostring(actor.name))
    wait(0.5)
    actor:send(tostring(self.name) .. " tells you, 'There you go!'")
else
    self:command("shake")
    self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
    wait(0.2)
    actor:send(tostring(self.name) .. " tells you, 'I need the ring first.'")
end
return true$trig$, 'd699bf911fb707a24620693d0a7dc632'),
  -- data/triggers/163/163_57_moonwell_map_2_receive.lua
  (163, 57, $trig$if actor:get_quest_stage("moonwell_spell_quest") ~= 7 then
    return true
end

if (actor:get_quest_var("moonwell_spell_quest:map") or 0) == 1 then
    actor:advance_quest("moonwell_spell_quest")
    actor:set_quest_var("moonwell_spell_quest", "map", 0)
    wait(1.5)
    self:destroy_item("map")
    self.room:spawn_object(163, 53)
    self.room:send(tostring(self.name) .. " marks something on the bark map.")
    wait(1.5)
    self:command("give map " .. tostring(actor.name))
    wait(0.5)
    actor:send(tostring(self.name) .. " tells you, 'Okay, the third element in this ritual is Water.  In\n"
        .. "</>magic, water is often represented by jade.'")
    wait(4)
    actor:send(tostring(self.name) .. " tells you, 'I know of a jade ring held by a wood nymph on an island\n"
        .. "</>where other members of our Order are beset by beasts.'")
    wait(4)
    actor:send("</>But be careful, for 'tis a dangerous place for the unprepared!'")
else
    self:command("shake")
    self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
    wait(0.2)
    actor:send(tostring(self.name) .. " tells you, 'I need the orb first.'")
end
return true$trig$, 'f712fef404cda736184804fcc8e6a995'),
  -- data/triggers/163/163_59_moonwell_map_3_receive.lua
  (163, 59, $trig$if actor:get_quest_stage("moonwell_spell_quest") ~= 9 then
    return true
end

if (actor:get_quest_var("moonwell_spell_quest:map") or 0) == 1 then
    actor:advance_quest("moonwell_spell_quest")
    actor:set_quest_var("moonwell_spell_quest", "map", 0)
    wait(0.2)
    self:destroy_item("map")
    wait(1.5)
    self.room:spawn_object(163, 54)
    self.room:send(tostring(self.name) .. " quickly marks another check on the bark map.")
    wait(1.5)
    self:command("give map " .. tostring(actor.name))
    actor:send(tostring(self.name) .. " tells you, 'Okay, there are two items left.  This next might seem\n"
        .. "</>odd, but we need a single item of evil and chaos to mislead forces that wish to\n"
        .. "</>harm us while traveling through the well.'")
    wait(5)
    actor:send(tostring(self.name) .. " tells you, 'There is an orb that will serve this function well.  But\n"
        .. "</>as with so many such powerful relics, it is guarded by a great dragon hidden in\n"
        .. "</>a hellish labyrinth.'")
    wait(5)
    actor:send(tostring(self.name) .. " tells you, 'Get this orb that we might protect ourselves!'")
else
    self:command("shake")
    self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
    wait(0.2)
    actor:send(tostring(self.name) .. " tells you, 'I need the ring first.'")
end
return true$trig$, 'dd215b3188bc16f3350fab26bcaac9b4'),
  -- data/triggers/163/163_61_moonwell_map_4_receive.lua
  (163, 61, $trig$if actor:get_quest_stage("moonwell_spell_quest") ~= 10 then
    return true
end

if (actor:get_quest_var("moonwell_spell_quest:map") or 0) == 1 then
    actor:advance_quest("moonwell_spell_quest")
    actor:set_quest_var("moonwell_spell_quest", "map", 0)
    wait(0.2)
    self:destroy_item("map")
    wait(1.5)
    self.room:spawn_object(163, 55)
    self.room:send(tostring(self.name) .. " marks something on the bark map.")
    wait(1.5)
    self:command("give map " .. tostring(actor.name))
    actor:send(tostring(self.name) .. " tells you, 'Lastly, we need the item for the Earth.  There is a ring\n"
        .. "</>made of mundane stone kept in a large temple hidden in a mountain.  Obtain this\n"
        .. "</>final ring and we can finish this ceremony.'")
else
    self:command("shake")
    self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
    wait(0.2)
    actor:send(tostring(self.name) .. " tells you, 'I need the orb first.'")
end
return true$trig$, '4ae5b76642db63de5ecaacd786f5d634'),
  -- data/triggers/163/163_63_moonwell_map_5_receive.lua
  (163, 63, $trig$if actor:get_quest_stage("moonwell_spell_quest") ~= 11 then
    return true
end

if (actor:get_quest_var("moonwell_spell_quest:map") or 0) ~= 1 then
    self:command("shake")
    self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
    wait(0.2)
    actor:send(tostring(self.name) .. " tells you, 'I need the ring first.'")
    return true
end

wait(1.5)
self:destroy_item("map")
self.room:spawn_object(163, 66)
self.room:send(tostring(self.name) .. " completes her drawing on the bark map.")
wait(1.5)
self:command("give map " .. tostring(actor.name))
if actor.gender == "female" then
    actor:send(tostring(self.name) .. " tells you, 'Keep that map Sister, that you may never forget how to\n"
        .. "</>conduct this ceremony.'")
else
    actor:send(tostring(self.name) .. " tells you, 'Keep that map Brother, that you may never forget how to\n"
        .. "</>conduct this ceremony.'")
end
wait(2)
actor:send(tostring(self.name) .. " tells you, 'Let us finish the ceremony.'")
self.room:send(tostring(self.name) .. " places " .. tostring(objects.template(550, 20).name) .. " at the edge of the circle and prays.")
wait(0.5)
self.room:send("<magenta>A </>moonwell <magenta>appears at " .. tostring(self.name) .. "'s feet!</>")
wait(2)
self.room:send("<b:cyan>The moonwell begins to <b:magenta>swirl</>!")
wait(2.5)
run_room_trigger(163, 48)
wait(3)
self.room:send("A soft yet loud voice says, 'You have done well young dryad.  Perhaps you truly\n"
    .. "</>are repentant.  For your service, I release you from your shackles.'")
wait(1)
self.room:send("The voice says, 'Remember this always.'")
wait(1.5)
self.room:send("A bright flash of light pierces the area and the dryad is transformed into a beautiful mortal woman!")
wait(1)
self.room:send("The beautiful druid says, 'Thank you my Goddess, Mielikki!  At last, I am free\n"
    .. "</>again!'")
wait(2)
self.room:send("The beautiful druid bows deeply, enters the moonwell and disappears!")
actor:complete_quest("moonwell_spell_quest")
skills.set_level(actor, "moonwell", 1000)
world.destroy(self)
return true$trig$, '3421def9314ac77ce35abff4237ea060'),
  -- data/triggers/185/185_20_group_heal_doctor_receive.lua
  (185, 20, $trig$local stage = actor:get_quest_stage("group_heal")

if stage == 2 then
    if object.zone_id == 185 and object.local_id == 13 then
        self:destroy_item("supplies")
        wait(2)
        self:say("Thank you so much!  This is an enormous relief!")
        wait(3)
        self.room:send(tostring(self.name) .. " says, 'Now I can get to working on that ritual to create a portable")
        self.room:send("</>healing spell and teach you about healing groups of people in the process,")
        self.room:send("</>" .. tostring(actor.name) .. ".'")
        wait(4)
        self.room:send(tostring(self.name) .. " says, 'Based on books I found in our library, historical records")
        self.room:send("</>indicate the last anyone heard of this spell a hearth priest was working on")
        self.room:send("</>perfecting it.  He worked out of a kitchen somewhere in the")
        self.room:send("</><green>Great Northern Swamps</>.'")
        wait(4)
        self.room:send(tostring(self.name) .. " says, 'I'm not sure how helpful that is, but maybe if you <b:white>search</>")
        self.room:send("</>through some of the abandoned kitchens out there, you'll find something useful.'")
        local roll = random(1, 3)
        local target_room
        if roll == 1 then
            target_room = 16051   -- Mystwatch (TODO: split to (zone,id))
        elseif roll == 2 then
            target_room = 51012   -- Nordus    (TODO: split to (zone,id))
        else
            target_room = 53178   -- Sunken    (TODO: split to (zone,id))
        end
        actor:set_quest_var("group_heal", "room", target_room)
        actor:advance_quest("group_heal")
    else
        wait(2)
        self.room:send(tostring(self.name) .. " says, 'These aren't our missing supplies.")
        actor:send(tostring(self.name) .. " returns " .. tostring(object.shortdesc) .. " to you.")
    end
elseif stage == 4 then
    if object.zone_id == 185 and object.local_id == 14 then
        actor:advance_quest("group_heal")
        wait(2)
        self:emote("scans through the book.")
        wait(2)
        self.room:send(tostring(self.name) .. " says, 'Strange, this doesn't look like a ritual at all, at least")
        self.room:send("</>not in the strictest sense.  It looks more like... like a meal.'")
        wait(1)
        self:say("A very BIG meal...")
        wait(2)
        self.room:send(tostring(self.name) .. " says, 'Huh... Well those sure are some unusual dishes.  I've never")
        self.room:send("</>seen anything quite like this before.  I don't even know what half these")
        self.room:send("</>ingredients are.'")
        wait(4)
        self:say("I'm a doctor, dammit, not a chef!")
        wait(2)
        self:command("ponder")
        wait(2)
        self:say("A chef!  That's it!")
        wait(3)
        self.room:send(tostring(self.name) .. " says, 'Could you go consult with different <b:white>chefs</> and <b:white>cooks</> to")
        self.room:send("</>figure out what these things are?  I'm sure I can procure the ingredients once")
        self.room:send("</>I know what I actually need.'")
        wait(5)
        self:say("It looks like there are six parts to this.")
        wait(1)
        self:command("give rite " .. tostring(actor.name))
        wait(2)
        self.room:send(tostring(self.name) .. " says, 'Seek out a professional for each part, <b:white>give them the rite</>,")
        self.room:send("</>and get some notes from them.'")
        wait(3)
        self:say("Thank you for your help!")
    else
        wait(2)
        self:say("This doesn't look like it will be of any help.")
        actor:send(tostring(self.name) .. " returns " .. tostring(object.shortdesc) .. " to you.")
    end
elseif stage == 5 then
    if object.zone_id == 185 and (object.local_id == 15 or object.local_id == 16 or object.local_id == 17 or object.local_id == 18 or object.local_id == 19 or object.local_id == 20) then
        local notes_key = tostring(object.zone_id) .. "_" .. tostring(object.local_id)
        if (actor:get_quest_var("group_heal:" .. notes_key) or 0) == 1 then
            wait(2)
            self:command("shake")
            self:say("You already brought me " .. tostring(object.shortdesc) .. ".")
            actor:send(tostring(self.name) .. " returns " .. tostring(object.shortdesc) .. " to you.")
        else
            self:destroy_item("notes")
            actor:set_quest_var("group_heal", notes_key, 1)
            local total = (actor:get_quest_var("group_heal:total") or 0) + 1
            actor:set_quest_var("group_heal", "total", total)
            wait(2)
            self:say("Thank you!")
            wait(1)
            self:emote("studies the notes.")
            wait(2)
            self:say("Ah yes, I see.")
            wait(1)
            local roll = random(1, 4)
            if roll == 1 then
                self:say("I can substitute that with that?  Interesting!")
            elseif roll == 2 then
                self:say("That looks like a very reasonable suggestion!")
            elseif roll == 3 then
                self:say("Oh so that's what that thing is called now...")
            else
                self:say("I see how this works!")
            end
            if total == 6 then
                actor:advance_quest("group_heal")
                wait(1)
                self.room:send(tostring(self.name) .. " says, 'That looks like everything!  May I have that copy of the Rite")
                self.room:send("</>please?'")
            else
                wait(1)
                self:say("Please, bring me the notes on the rest of the rite!")
            end
        end
    end
elseif stage == 6 then
    if object.zone_id == 185 and object.local_id == 14 then
        actor:set_quest_var("group_heal", "total", 0)
        wait(2)
        self:destroy_item("heroes-feast")
        wait(2)
        self.room:send(tostring(self.name) .. " says, 'I think I can put this together now!!  Wait here while I")
        self.room:send("</>prepare the feast.'")
        wait(2)
        self:emote("leaves for the kitchens.")
        self:teleport(get_room(11, 0))
        wait(8)
        get_room(185, 30):at(function()
            self.room:send("Delicious smells and the sound of chanting begin to waft in from the courtyard.")
        end)
        wait(10)
        self:teleport(get_room(185, 30))
        self:emote("returns with an incredible feast!")
        wait(4)
        self:emote("carefully divides up the feast and neatly packages it along with medical supplies.")
        for _ = 1, 5 do
            self.room:spawn_object(185, 21)
        end
        wait(1)
        self.room:send(tostring(self.name) .. " says, 'The final thing I ask is for you to go out into the world")
        self.room:send("</>and help those in need.'")
        wait(4)
        self:say("Here, take these care packages of food and medicine.")
        wait(2)
        self:command("give all.food " .. tostring(actor.name))
        wait(4)
        self.room:send(tostring(self.name) .. " says, 'Seek out five creatures who are <b:white>sick</>, <b:white>injured</>, <b:white>dying</>,")
        self.room:send("</><b:white>wounded</>, or <b:white>hobbling</>. Bring them succor with those packages.'")
        wait(4)
        self:say("Except for Lirne.")
        wait(2)
        self:command("grumble")
        wait(2)
        self:say("He needs to learn his lesson eventually.")
        wait(4)
        self:say("May St. George ever smile upon your endeavors!")
        wait(2)
        self:command("wave " .. tostring(actor.name))
    else
        self:say("I'm afraid this won't be of much use to me right now.")
        actor:send(tostring(self.name) .. " returns " .. tostring(object.shortdesc) .. " to you.")
    end
else
    self:say("I'm afraid this won't be of much use to me right now.")
    actor:send(tostring(self.name) .. " returns " .. tostring(object.shortdesc) .. " to you.")
end

return true$trig$, 'dc14cbea9accb818a0176b142bf93942'),
  -- data/triggers/185/185_22_group_heal_chefs_receive.lua
  (185, 22, $trig$local function is_mob(zone, id)
    return self.zone_id == zone and self.local_id == id
end

local function chef_already_consulted()
    return (actor:get_quest_var("group_heal:" .. tostring(self.zone_id) .. "_" .. tostring(self.local_id)) or 0) == 1
end

local function refuse_misc()
    if is_mob(502, 3) then  -- zombified pirate cook
        actor:send(tostring(self.name) .. " moans and swats your hand away.")
        self.room:send_except(actor, tostring(self.name) .. " moans and swats " .. tostring(actor.name) .. "'s hand away.")
    elseif is_mob(510, 7) then  -- crazy chef
        self:command("cackle " .. tostring(actor.name))
        actor:send(tostring(self.name) .. " inches away from you.")
        self.room:send_except(actor, tostring(self.name) .. " inches away from " .. tostring(actor.name) .. ".")
    else
        self:say("Sorry, what is this?")
        actor:send(tostring(self.name) .. " returns " .. tostring(object.shortdesc) .. " to you.")
    end
end

if object.zone_id ~= 185 or object.local_id ~= 14 or actor:get_quest_stage("group_heal") ~= 5 then
    refuse_misc()
    return true
end

if chef_already_consulted() then
    if is_mob(502, 3) then
        actor:send(tostring(self.name) .. " moans and swats your hand away.")
        self.room:send_except(actor, tostring(self.name) .. " moans and swats " .. tostring(actor.name) .. "'s hand away.")
    elseif is_mob(510, 7) then
        self:command("cackle " .. tostring(actor.name))
        actor:send(tostring(self.name) .. " inches away from you.")
        self.room:send_except(actor, tostring(self.name) .. " inches away from " .. tostring(actor.name) .. ".")
    else
        self:say("I've told you everything I can.  Good luck!")
    end
    return true
end

actor:set_quest_var("group_heal", tostring(self.zone_id) .. "_" .. tostring(self.local_id), 1)

local notes_id = nil
if is_mob(83, 7) then            -- the Frakati Chef
    self:say("So you would like some help?  Looks like quite a meal.")
    wait(2)
    self.room:send(tostring(self.name) .. " says, 'Roasting methods may be a little difficult to control.")
    self.room:send("</>I can share with you some methods the Frakati people use to prepare and roast")
    self.room:send("</>wild game.'")
    wait(4)
    self:emote("writes down several notes.")
    wait(3)
    notes_id = 15
    self.room:spawn_object(185, notes_id)
    self:command("give notes " .. tostring(actor.name))
    wait(1)
    self.room:send(tostring(self.name) .. " says, 'These small tips will make sure your meats stay tender")
    self.room:send("</>and juicy while soaking up as much flavor as possible.'")
    wait(2)
    self:say("Good luck.")
elseif is_mob(510, 7) then       -- the crazy chef
    self:emote("begins to run in a circle laughing hysterically.")
    wait(4)
    self:emote("stops running and starts writing.")
    wait(2)
    self.room:send(tostring(self.name) .. " keeps laughing and writing...")
    wait(2)
    self.room:send("... and writing...")
    wait(2)
    self.room:send("... and writing...")
    wait(2)
    self.room:send("... and writing...")
    wait(4)
    notes_id = 16
    self.room:spawn_object(185, notes_id)
    self:command("give notes " .. tostring(actor.name))
    self:command("laugh " .. tostring(actor.name))
elseif is_mob(185, 12) then      -- a scruffy cook
    self.room:send(tostring(self.name) .. " says, 'Well what is this?  I heard the doctor talking about a")
    self.room:send("</>feast of some kind...'")
    wait(2)
    self:emote("trails off while reading the ritual recipe.")
    wait(4)
    self.room:send(tostring(self.name) .. " says, 'Well I can definitely help out with some of this.")
    self.room:send("</>Desserts aren't considered a specialty of our Abbey because most bakers")
    self.room:send("</>prefer techniques and ingredients no longer suited for monastic life.'")
    wait(3)
    self.room:send(tostring(self.name) .. " says, 'But since we still see the value in what you can grow")
    self.room:send("</>and process by hand, I can easily help replicate a recipe this old.'")
    wait(4)
    notes_id = 17
    self.room:spawn_object(185, notes_id)
    self:emote("writes down a list of notes.")
    self:command("give notes " .. tostring(actor.name))
    wait(1)
    self:say("This should meet the doctor's needs.")
elseif is_mob(300, 3) then       -- Dugrik
    self.room:send(tostring(self.name) .. " says, 'Normally I'd charge for this.  But since that's \"illegal\" here")
    self.room:send("</>now, I guess you got lucky.'")
    wait(3)
    self:say("Yeah, I see something I can help with.")
    wait(3)
    self:emote("points to several spots on the paper.")
    self:say("Make this adjustment here, here, and here.")
    wait(4)
    self:emote("points to another section.")
    self.room:send(tostring(self.name) .. " says, 'This word just means \"boil.\"  It will do exactly the same thing if")
    self.room:send("</>you just boil it.'")
    wait(4)
    self.room:send(tostring(self.name) .. " says, 'Oh and be real careful with that one there.  Unless you got an")
    self.room:send("</>orcish constitution, cook it wrong and you can poison yourself.'")
    self:command("chuckle")
    wait(1)
    notes_id = 18
    self.room:spawn_object(185, notes_id)
    self:command("give notes " .. tostring(actor.name))
elseif is_mob(502, 3) then       -- the zombified pirate cook
    self.room:send(tostring(self.name) .. " moans.")
    wait(2)
    self:emote("shambles into the wall with a great THUD!")
    self.room:send("A book of barely preserved pieces of paper falls from a shelf onto what remains of " .. tostring(self.name) .. "'s head.")
    notes_id = 19
    self.room:spawn_object(185, notes_id)
    wait(1)
    self:command("drop notes")
end

return true$trig$, '33f530be6660c26b1c1a37ef886e9caa'),
  -- data/triggers/185/185_26_sexton_greet.lua
  (185, 26, $trig$wait(2)
if actor:get_quest_stage("phase_mace") == "macestep" then
    local minlevel = (macestep or 0) * 10
    if actor.level >= minlevel then
        if (actor:get_quest_var("phase_mace:greet") or 0) == 0 then
            actor:send(tostring(self.name) .. " says, 'I sense a ghostly presence about your weapons.  If you want my help, we can talk about <b:cyan>[upgrades]</>.'")
        else
            actor:send(tostring(self.name) .. " says, 'Do you have what I need?'")
        end
    end
end$trig$, '0ab68a98d00f5f3594430ec32345cb39'),
  -- data/triggers/237/237_52_receive-rewards.lua
  (237, 52, $trig$-- Converted from DG Script #23752: receive-rewards
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
-- Vilekka receives the heart (stage 1 -> 2), the drider king's head
-- (stage 3 -> 4), or the ten herbs/spices (stage 5 completion).

-- Helper: is this object one of the accepted spices for stage 5?
-- Returns the canonical spice key (string) or nil.
local function spice_key(obj)
    local z, id = obj.zone_id, obj.local_id
    if z == 125 and id == 52 then return "12552" end
    if z == 490 and id == 22 then return "49022" end
    if z == 237 and id >= 50 and id <= 60 then
        return tostring(23700 + id)
    end
    return nil
end

local accepted = false

-- Stage 1 -> 2: drow master's heart (object 237/21).
if object.zone_id == 237 and object.local_id == 21 then
    for _, person in ipairs(actor.group) do
        if person.room == self.room and person:get_quest_stage("vilekka_stew") == 1 then
            person:advance_quest("vilekka_stew")
            person:send("<b:white>You have advanced the quest!</>")
            accepted = true
        end
    end
    if accepted then
        wait(1)
        self:destroy_item("all.heart")
        self:say("Excellent!")
        wait(1)
        self.room:send("The High Priestess takes the heart and places it gently on the altar.")
        self:command("smirk")
        wait(1)
        self:say("You have done me and my city a great service!  Do you wish to continue or stop now?")
        self:command("tap")
        self.room:send("<b:white>All characters must choose individually.</>")
        return true
    end
end

-- Stage 3 -> 4: drider king's head (object 237/20).
if object.zone_id == 237 and object.local_id == 20 then
    for _, person in ipairs(actor.group) do
        if person.room == self.room and person:get_quest_stage("vilekka_stew") == 3 then
            person:advance_quest("vilekka_stew")
            person:send("<b:white>You have advanced the quest!</>")
            accepted = true
            -- Cross-quest credit for hell_trident.
            if not person:get_quest_var("hell_trident:helltask6")
                and person:get_quest_stage("hell_trident") == 1 then
                person:set_quest_var("hell_trident", "helltask6", 1)
                person:send("<magenta>You have successfully assisted " .. tostring(self.name) .. " in service of Lolth!</>")
            end
        end
    end
    if accepted then
        wait(1)
        self:destroy_item("all.head")
        actor:send(tostring(self.name) .. " says, 'You are quite resourceful!  This is a great benefit to the entire city.'")
        self:emote("places the severed head on the altar, where it lolls around.")
        wait(1)
        actor:send(tostring(self.name) .. " says, 'But your work may not yet be finished...  Do you wish to continue, or stop here?'")
        self.room:send("<b:white>All characters must choose individually.</>")
        return true
    end
end

-- Stage 5: spices and herbs.
if actor:get_quest_stage("vilekka_stew") == 5 then
    local key = spice_key(object)
    local is_spice = key ~= nil
    -- Reject duplicates.
    local already_given = key
        and (actor:get_quest_var("vilekka_stew:got_spice:" .. key) or 0) == 1
    if (not is_spice) or already_given then
        self:emote("refuses to accept " .. tostring(object.shortdesc) .. ".")
        wait(1)
        if is_spice then
            actor:send(tostring(self.name) .. " says, 'You have already given me " .. tostring(object.shortdesc) .. ".'")
        else
            actor:send(tostring(self.name) .. " says, 'What is this?  I need the spices!'")
        end
        return true
    end
    wait(1)
    local num_spices = 1 + (actor:get_quest_var("vilekka_stew:num_spices") or 0)
    actor:set_quest_var("vilekka_stew", "num_spices", num_spices)
    actor:set_quest_var("vilekka_stew", "got_spice:" .. key, 1)
    accepted = true
    if num_spices < 10 then
        self:destroy_item("herb")
        -- Per-spice progress acknowledgement.
        if num_spices == 1 then
            actor:send(tostring(self.name) .. " says, 'Very good!  But I still need nine more.'")
        elseif num_spices == 2 then
            self:command("lick")
            actor:send(tostring(self.name) .. " says, 'Eight more....'")
        elseif num_spices == 3 then
            actor:send(tostring(self.name) .. " says, 'Seven more spices, and my stew will be perfect!'")
        elseif num_spices == 4 then
            self:emote("is starting to look excited.")
            actor:send(tostring(self.name) .. " says, 'Six more!'")
        elseif num_spices == 5 then
            self:command("grin")
            actor:send(tostring(self.name) .. " says, 'You're halfway there!  Five more!'")
        elseif num_spices == 6 then
            self:emote("sniffs the spices carefully.")
            actor:send(tostring(self.name) .. " says, 'Yes!  Only four more!'")
        elseif num_spices == 7 then
            actor:send(tostring(self.name) .. " says, 'Three more!  Give them to me!'")
        elseif num_spices == 8 then
            self:emote("looks very excited now.")
            actor:send(tostring(self.name) .. " says, 'Two more spices!'")
        elseif num_spices == 9 then
            actor:send(tostring(self.name) .. " says, 'One more!  Give it to me!'")
        end
        return true
    end

    -- num_spices >= 10: complete the quest.
    self:command("cackle")
    actor:send(tostring(self.name) .. " says, 'Most excellent!  Now I may complete the will of my Queen!'")
    wait(1)
    self:emote("puts all the ingredients for the nasty stew into a small bag.")
    self.room:send("A servant silently enters and bows.")
    self:emote("gives a small bag to the servant.")
    self.room:send("The servant leaves.")
    wait(1)
    actor:send(tostring(self.name) .. " says, 'Oh yes, your reward....'")
    -- Reward boots depend on whether saffron (23760) and salt (23756) were
    -- among the ten spices delivered.
    local has_saffron = (actor:get_quest_var("vilekka_stew:got_spice:23760") or 0) == 1
    local has_salt = (actor:get_quest_var("vilekka_stew:got_spice:23756") or 0) == 1
    local expcap
    if has_saffron and has_salt then
        self.room:spawn_object(237, 98)
        expcap = math.min(actor.level, 60)
    elseif has_saffron then
        self.room:spawn_object(237, 99)
        expcap = math.min(actor.level, 85)
    elseif has_salt then
        self.room:spawn_object(237, 96)
        expcap = math.min(actor.level, 50)
    else
        self.room:spawn_object(237, 97)
        expcap = math.min(actor.level, 55)
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

    -- Class proportional adjustment.
    if actor.class == "warrior" or actor.class == "berserker" then
        -- 110% of standard
        expmod = expmod + (expmod / 10)
    elseif actor.class == "paladin" or actor.class == "anti-paladin" or actor.class == "ranger" then
        -- 115% of standard
        expmod = expmod + ((expmod * 2) / 15)
    elseif actor.class == "sorcerer" or actor.class == "pyromancer" or actor.class == "cryomancer" or actor.class == "illusionist" or actor.class == "bard" then
        -- 120% of standard
        expmod = expmod + (expmod / 5)
    elseif actor.class == "necromancer" or actor.class == "monk" then
        -- 130% of standard
        expmod = expmod + ((expmod * 2) / 5)
    end

    actor:send("<b:yellow>You gain experience!</>")
    local setexp = expmod * 10
    for _ = 1, 10 do
        actor:award_exp(setexp)
    end
    self:command("give boots " .. tostring(actor.name))
    wait(1)
    self:command("smile")
    actor:send(tostring(self.name) .. " says, 'Wear them proudly!'")
    actor:complete_quest("vilekka_stew")
    return true
end

if not accepted then
    actor:send(tostring(self.name) .. " haughtily refuses your gift.")
    self.room:send_except(actor, tostring(self.name) .. " refuses to accept " .. tostring(object.shortdesc) .. " from " .. tostring(actor.name) .. ".")
    wait(1)
    self:say("No thank you.")
end
return true$trig$, 'feda831927d040160289b305d1b75233'),
  -- data/triggers/237/237_99_vilekka_stew_status_check.lua
  (237, 99, $trig$-- Converted from DG Script #23799: vilekka_stew_status_check
-- Original: MOB trigger, flags: SPEECH, probability: 100%
-- "progress" report for the vilekka_stew quest. Lists current stage hint
-- and, on stage 5, which of the ten herbs/spices have been delivered.

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"progress", "progress?"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
wait(0.2)
if actor:get_has_completed("vilekka_stew") then
    self:say("You have already done me a great service.")
    return true
end
local stage = actor:get_quest_stage("vilekka_stew")
do
    local _sw1 = string.lower(tostring(stage or ""))
    if tonumber(_sw1) == 1 then
        self.room:send(tostring(self.name) .. " says, 'Bring me the heart of the drow living in the")
        self.room:send("</>surface city!'")
    elseif tonumber(_sw1) == 2 then
        self:say("Well, do you want to continue or stop?")
    elseif tonumber(_sw1) == 3 then
        self:say("You must bring me the head of the drider king.")
    elseif tonumber(_sw1) == 4 then
        self:say("Well, do you want to continue or stop?")
    elseif tonumber(_sw1) == 5 then
        self.room:send(tostring(self.name) .. " says, 'Bring me some spices so that I can make this head")
        self.room:send("</>and heart palatable.'")
        local num_spices = actor:get_quest_var("vilekka_stew:num_spices") or 0
        -- (key, zone, local_id) for each accepted spice.
        local spices = {
            { "12552", 125, 52 },
            { "49022", 490, 22 },
            { "23750", 237, 50 },
            { "23751", 237, 51 },
            { "23752", 237, 52 },
            { "23753", 237, 53 },
            { "23754", 237, 54 },
            { "23755", 237, 55 },
            { "23756", 237, 56 },
            { "23757", 237, 57 },
            { "23758", 237, 58 },
            { "23759", 237, 59 },
            { "23760", 237, 60 },
        }
        if num_spices > 0 then
            self.room:send("So far you have brought me:")
            for _, s in ipairs(spices) do
                if (actor:get_quest_var("vilekka_stew:got_spice:" .. s[1]) or 0) == 1 then
                    self.room:send("- " .. tostring(objects.template(s[2], s[3]).name))
            end
        end
        end
        local remaining = 10 - num_spices
        self.room:send("Bring me " .. tostring(remaining) .. " more spices to prepare this stew.")
    else
        self:say("You are not performing a service for me.")
    end
end$trig$, '94a0174bbb20c320dee7b59affd0f811'),
  -- data/triggers/364/364_04_illusory_wall_lyara_receive.lua
  (364, 4, $trig$local function obj_id_matches(obj, z, lid)
    return obj.zone_id == z and obj.local_id == lid
end
local lens_a_z, lens_a_id = 103, 7
local lens_b_z, lens_b_id = 185, 11
local spur_z,   spur_id   = 410, 5
local magic_z,  magic_id  = 510, 17
local obj_short = object.short_description or object.name
if actor:get_quest_stage("illusory_wall") == 1 then
    local key = tostring(object.zone_id) .. "_" .. tostring(object.local_id)
    local lens_a = actor:get_quest_var("illusory_wall:" .. lens_a_z .. "_" .. lens_a_id)
    local lens_b = actor:get_quest_var("illusory_wall:" .. lens_b_z .. "_" .. lens_b_id)
    local spur   = actor:get_quest_var("illusory_wall:" .. spur_z   .. "_" .. spur_id)
    local magic  = actor:get_quest_var("illusory_wall:" .. magic_z  .. "_" .. magic_id)
    if (actor:get_quest_var("illusory_wall:" .. key) or 0) == 1 then
        wait(1)
        self.room:send(tostring(self.name) .. " refuses " .. tostring(obj_short) .. ".")
        self:command("shake")
        self:say("You have already given me this.")
        return true
    elseif (lens_a == 1 and obj_id_matches(object, lens_b_z, lens_b_id))
        or (lens_b == 1 and obj_id_matches(object, lens_a_z, lens_a_id)) then
        wait(1)
        self.room:send(tostring(self.name) .. " refuses " .. tostring(obj_short) .. ".")
        self:command("shake")
        self.room:send(tostring(self.name) .. " says, 'You have already given me something suitable for")
        self.room:send("</>magic lenses.'")
        return true
    else
        if obj_id_matches(object, lens_a_z, lens_a_id) or obj_id_matches(object, lens_b_z, lens_b_id) then
            actor:set_quest_var("illusory_wall", key, 1)
            wait(0.2)
            world.destroy(object)
            wait(1)
            self:say("These are excellent lenses.")
        elseif obj_id_matches(object, spur_z, spur_id) then
            actor:set_quest_var("illusory_wall", key, 1)
            wait(0.2)
            world.destroy(object)
            wait(1)
            self.room:send(tostring(self.name) .. " says, 'Yes, this will do nicely.  Hopefully you gained a")
            self.room:send("</>few insights on bending light from the prisms in the Hive as well.'")
        elseif obj_id_matches(object, magic_z, magic_id) then
            actor:set_quest_var("illusory_wall", key, 1)
            wait(0.2)
            world.destroy(object)
            wait(1)
            self.room:send(tostring(self.name) .. " looks at the odd glowing lump.")
            self:say("Ah yes, plenty of extra juice in here.")
        else
            wait(1)
            self.room:send(tostring(self.name) .. " refuses " .. tostring(obj_short) .. ".")
            self:command("shake")
            self:say("This won't help you see through illusions any better.")
            return true
        end
        lens_a = actor:get_quest_var("illusory_wall:" .. lens_a_z .. "_" .. lens_a_id)
        lens_b = actor:get_quest_var("illusory_wall:" .. lens_b_z .. "_" .. lens_b_id)
        spur   = actor:get_quest_var("illusory_wall:" .. spur_z   .. "_" .. spur_id)
        magic  = actor:get_quest_var("illusory_wall:" .. magic_z  .. "_" .. magic_id)
        if (lens_a or lens_b) and spur and magic then
            actor:advance_quest("illusory_wall")
            actor:set_quest_var("illusory_wall", "total", 0)
            wait(2)
            self:say("Wonderful, looks like this is everything.")
            wait(2)
            self.room:send(tostring(self.name) .. " holds the prismatic leg spur and the lenses next to each other and utters a few words.")
            self.room:send("<b:yellow>The lenses fuse with the leg spur, taking on a prismatic quality!</>")
            wait(4)
            self.room:send(tostring(self.name) .. " holds the lump of magic over the prismatic lenses and whispers an incantation.")
            self.room:send("<b:yellow>The magic melds with the lenses!</>")
            wait(3)
            self.room:spawn_object(364, 0)
            self.room:send(tostring(self.name) .. " says, 'These lenses will show you little hidden details")
            self.room:send("</>about doors and exits.'")
            self:command("give lenses " .. tostring(actor.name))
            wait(3)
            self.room:send(tostring(self.name) .. " says, '<b:white>[Examine]</> 20 different closeable exits in 20")
            self.room:send("</>different parts of the world.'")
            wait(2)
            self.room:send(tostring(self.name) .. " says, 'Once you have, you should know enough to replicate")
            self.room:send("</>such barriers on your own.'")
            wait(4)
            self:say("Good luck!")
        else
            wait(2)
            self:say("Do you have the other necessities?")
        end
    end
elseif actor:get_quest_stage("illusory_wall") > 1 then
    wait(1)
    self.room:send(tostring(self.name) .. " refuses " .. tostring(obj_short) .. ".")
    self:say("There's nothing else you need to bring me.")
else
    wait(1)
    self.room:send(tostring(self.name) .. " refuses " .. tostring(obj_short) .. ".")
    self:say("No need for supplies, soldier.")
    self:command("salute " .. tostring(actor.name))
end
return true$trig$, '1087a4b7bd8158282d5f0cb795b5ffc4'),
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
        wait(3)
        self:say("You have already helped me once, please let others help me now.")
        self:command("give " .. tostring(object.name) .. " " .. tostring(actor.name))
    elseif gotitem then
        wait(3)
        self:say("Why thank you.  Run along now.")
        world.destroy(object)
    elseif gooditem then
        wait(3)
        self:say("I'm sorry but you already gave me this item.")
        self:command("give " .. tostring(object.name) .. " " .. tostring(actor.name))
    else
        wait(3)
        self:say("What is this? I can not use this.")
        self:command("give " .. tostring(object.name) .. " " .. tostring(actor.name))
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
        wait(1)
        self:say("What is this? I can not use this.")
        self:command("give " .. tostring(object.name) .. " " .. tostring(actor.name))
    end
end
return true$trig$, '1767a390bc4ea32522a432b927e3b4dc'),
  -- data/triggers/390/390_10_flood_lady_status_checker.lua
  (390, 10, $trig$-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
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

wait(0.2)
if actor:get_quest_stage("flood") == 1 then
    local fog = "The Blue-Fog"
    local phoenix = "Phoenix Feather Hot Springs"
    local falls = "Three-Falls River"
    local green = "The Greengreen Sea"
    local witch = "Sea's Lullaby"
    local frost = "Frost Lake"
    local black = "The Black Lake"
    local kod = "The Dreaming River"
    local water1 = actor:get_quest_var("flood:water1")
    local water2 = actor:get_quest_var("flood:water2")
    local water3 = actor:get_quest_var("flood:water3")
    local water4 = actor:get_quest_var("flood:water4")
    local water5 = actor:get_quest_var("flood:water5")
    local water6 = actor:get_quest_var("flood:water6")
    local water7 = actor:get_quest_var("flood:water7")
    local water8 = actor:get_quest_var("flood:water8")
    local item2 = actor:get_quest_var("flood:item2")
    local item3 = actor:get_quest_var("flood:item3")
    local item4 = actor:get_quest_var("flood:item4")
    local item6 = actor:get_quest_var("flood:item6")
    local item7 = actor:get_quest_var("flood:item7")
    self:say("As my Envoy, rally the Great Waters of Ethilien.")
    if water1 or water2 or water3 or water4 or water5 or water6 or water7 or water8 then
        self.room:send("You have rallied:")
        if water1 then self.room:send("- <blue>" .. fog .. "</>") end
        if water2 then self.room:send("- <blue>" .. phoenix .. "</>") end
        if water3 then self.room:send("- <blue>" .. falls .. "</>") end
        if water4 then self.room:send("- <blue>" .. green .. "</>") end
        if water5 then self.room:send("- <blue>" .. witch .. "</>") end
        if water6 then self.room:send("- <blue>" .. frost .. "</>") end
        if water7 then self.room:send("- <blue>" .. black .. "</>") end
        if water8 then self.room:send("- <blue>" .. kod .. "</>") end
    end
    self.room:send("You must still convince:")
    if not water1 then
        self.room:send("- <b:blue>" .. fog .. "</>")
    end
    if not water2 then
        self.room:send("- <b:blue>" .. phoenix .. "</>")
        if (item2 or 0) == 1 then
            self.room:send("</>    Bring it " .. objects.template(584, 1).name .. " to heat its springs.")
        end
    end
    if not water3 then
        self.room:send("- <b:blue>" .. falls .. "</>")
        if (item3 or 0) == 1 then
            self.room:send("</>    Find a bell and dance for them.")
        end
    end
    if not water4 then
        self.room:send("- <b:blue>" .. green .. "</>")
        if (item4 or 0) == 1 then
            self.room:send("</>    Feed her as many different foods as you can until she is full.")
        end
    end
    if not water5 then
        self.room:send("- <b:blue>" .. witch .. "</>")
    end
    if not water6 then
        self.room:send("- <b:blue>" .. frost .. "</>")
        if (item6 or 0) == 1 then
            self.room:send("</>    Force her to join the cause.")
        end
    end
    if not water7 then
        self.room:send("- <b:blue>" .. black .. "</>")
        if (item7 or 0) == 1 then
            self.room:send("</>    Bring it an eternal light to swallow into its blackness.")
        end
    end
    if not water8 then
        self.room:send("- <b:blue>" .. kod .. "</>")
    end
    self.room:send(self.name .. " says, 'Tell them: <b:blue>the Arabel Ocean calls for aid</>.'")
    self.room:send(self.name .. " says, 'If you lost the Heart, say <b:blue>I lost the heart</>.'")
elseif actor:get_quest_stage("flood") == 2 then
    self:say("Return my heart to me!")
    self.room:send(self.name .. " says, 'If you lost the Heart, say <b:blue>I lost the heart</>.'")
elseif actor:get_has_completed("flood") then
    self:say("I have already enacted my revenge, Envoy.")
else
    self:say("You are not yet my Envoy.")
end$trig$, '8a5035d6b2618389f6147951fae086c0'),
  -- data/triggers/462/462_13_nukreth_spire_human_help_speech.lua
  (462, 13, $trig$-- Converted from DG Script #46213: Nukreth Spire human help speech
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"husband", "help", "yes", "okay", "who", "where"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
wait(0.2)
if actor:get_quest_stage("nukreth_spire") > 0 then
    if (actor:get_quest_var("nukreth_spire:path1") or 0) == 0 then
        self.room:send(tostring(self.name) .. " says, 'They took us both captive.  But just a moment ago three")
        self.room:send("</>of their cultists took him as a sacrifice to their Demon Lord...'")
        wait(0.2)
        self.room:send("Her voice trails off.")
        wait(2)
        self:command("shake")
        self:say("No, he's still alive, I know it.  Please, save him!")
        wait(1)
        self.room:send(tostring(self.name) .. " says, 'They took him deeper into the den.  Find him and bring")
        self.room:send("</>him back here.  I'll keep this area safe.'")
        if (actor:get_quest_var("nukreth_spire:rescue") or 0) == 0 then
            actor:set_quest_var("nukreth_spire", "rescue", 1)
        end
        if not globals.running then
            globals.running = true
            if world.count_mobiles(462, 6) == 0 then
                get_room(462, 62):at(function()
                    self.room:spawn_mobile(462, 6)
                end)
            end
            if world.count_mobiles(462, 7) == 0 then
                get_room(462, 62):at(function()
                    self.room:spawn_mobile(462, 7)
                end)
            end
            if world.count_mobiles(462, 8) == 0 then
                get_room(462, 62):at(function()
                    self.room:spawn_mobile(462, 8)
                end)
            end
        end
    else
        actor:send("<b:red>You have already completed this option.</>")
    end
else
    actor:send("<b:red>You must first start this quest before you can earn rewards.</>")
end$trig$, '917f466d8a317471f6e61e6cd3136a6e'),
  -- data/triggers/462/462_14_nukreth_spire_kobold_help_speech.lua
  (462, 14, $trig$-- Converted from DG Script #46214: Nukreth Spire kobold help speech
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"baby", "help", "yes", "okay", "what", "where"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
wait(0.2)
if actor:get_quest_stage("nukreth_spire") > 0 then
    if (actor:get_quest_var("nukreth_spire:path2") or 0) == 0 then
        self.room:send(tostring(self.name) .. " says, 'I hid an egg in the corner animal pen.  It should still")
        self.room:send("</>be there.'")
        wait(1)
        self.room:send(tostring(self.name) .. " says, 'Please find it and bring it back to me!  I'll hide here")
        self.room:send("</>while you go look.'")
        wait(0.2)
        self.room:send(tostring(self.name) .. " hides herself out of sight.")
        self:command("hide")
        if (actor:get_quest_var("nukreth_spire:baby") or 0) == 0 then
            actor:set_quest_var("nukreth_spire", "baby", 1)
        end
    else
        actor:send("<b:red>You have already completed this quest path.</>")
    end
else
    actor:send("<b:red>You must first start this quest before you can earn rewards.</>")
end$trig$, '33c7809dcc778c6923605bc648ea5d2c'),
  -- data/triggers/462/462_15_nukreth_spire_orc_help_speech.lua
  (462, 15, $trig$-- Converted from DG Script #46215: Nukreth Spire orc help speech
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"axe", "help", "yes", "okay", "where"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
wait(0.2)
if actor:get_quest_stage("nukreth_spire") > 0 then
    if (actor:get_quest_var("nukreth_spire:path3") or 0) == 0 then
        self:command("nod")
        self.room:send(tostring(self.name) .. " says, 'They took my axe when they captured me.  Gave it to")
        self.room:send("</>one of the chieftain's favorite mates.'")
        wait(0.2)
        self:command("snarl")
        wait(1)
        self.room:send(tostring(self.name) .. " says, 'Was a gift from an order of dark monks.  Sure would")
        self.room:send("</>love it back.'")
        wait(0.2)
        self:say("For some revenge...")
        wait(1)
        self:say("Go find it and bring it to me.  I'll hold this area.")
        if not globals.running then
            globals.running = true
            get_room(11, 0):at(function()
                self.room:spawn_mobile(462, 5)
            end)
            get_room(11, 0):at(function()
                self.room:find_actor("mate"):spawn_object(462, 13)
            end)
            get_room(11, 0):at(function()
                self.room:find_actor("mate"):command("wield axe")
            end)
            get_room(11, 0):at(function()
                self.room:find_actor("mate"):teleport(get_room(462, 40))
            end)
        end
    else
        actor:send("<b:red>You have already completed this quest path.</>")
    end
else
    actor:send("<b:red>You must first start this quest before you can earn rewards.</>")
end$trig$, '88e8e9211f1a29ad01c2a1025f2d8062'),
  -- data/triggers/462/462_16_nukreth_spire_goblin_help_speech.lua
  (462, 16, $trig$-- Converted from DG Script #46216: Nukreth Spire goblin help speech
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"treasure", "help", "yes", "okay", "what", "where"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
wait(0.2)
if actor:get_quest_stage("nukreth_spire") > 0 then
    if (actor:get_quest_var("nukreth_spire:path4") or 0) == 0 then
        self.room:send(tostring(self.name) .. " says, 'Yessss, had me a shiny treasure I did.  Hid it on some")
        self.room:send("</>bodies before they could eats 'em.  Or me.'")
        wait(1)
        self:say("Should still be up there in the larder.")
        wait(1)
        self.room:send(tostring(self.name) .. " says, 'Please find it and bring it back to me!  I'll hide here")
        self.room:send("</>while you go look.'")
        wait(0.2)
        self.room:send(tostring(self.name) .. " hides himself out of sight.")
        self:command("hide")
        if (actor:get_quest_var("nukreth_spire:treasure") or 0) == 0 then
            actor:set_quest_var("nukreth_spire", "treasure", 1)
        end
    else
        actor:send("<b:red>You have already completed this quest path.</>")
    end
else
    actor:send("<b:red>You must first start this quest before you can earn rewards.</>")
end$trig$, '704bc22082980ceb5225a85ff8dbb396'),
  -- data/triggers/462/462_21_nukreth_spire_egg_search.lua
  (462, 21, $trig$-- Converted from DG Script #46221: Nukreth Spire egg search
-- Original: WORLD trigger, flags: COMMAND, probability: 100%

-- Command filter: search
if not (cmd == "search") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
-- switch on cmd
do
    local _sw1 = string.lower(tostring(cmd or ""))
    if _sw1 == "s" then
        _return_value = true
        return _return_value
    end
end
if actor:get_quest_stage("nukreth_spire") > 0 then
    if (actor:get_quest_var("nukreth_spire:path2") or 0) == 0 then
        if (actor:get_quest_var("nukreth_spire:baby") or 0) == 1 then
            actor:set_quest_var("nukreth_spire", "baby", 2)
            actor:send("You begin searching...")
            wait(1)
            self.room:send("A sudden yip comes from outside the pen!")
            self.room:send("A gnoll beastmaster says, 'What's going on in there??'")
            wait(1)
            self.room:send("The beastmaster and a dire hyena enter the pen and attack!")
            actor:send("<b:yellow>You better kill these things and search again!</>")
            self.room:spawn_mobile(462, 26)
            self.room:find_actor("beastmaster"):command("kill " .. tostring(actor.name))
            self.room:spawn_mobile(462, 27)
            self.room:find_actor("dire-hyena"):command("kill " .. tostring(actor.name))
        elseif (actor:get_quest_var("nukreth_spire:baby") or 0) == 4 then
            actor:set_quest_var("nukreth_spire", "baby", 0)
            actor:send("You find a speckled kobold egg hidden amongst the straw!")
            self.room:send_except(actor, tostring(actor.name) .. " finds a speckled kobold egg hidden amongst the straw!")
            self.room:spawn_object(462, 14)
        else
            _return_value = true
        end
    else
        _return_value = true
    end
else
    _return_value = true
end
return _return_value$trig$, 'bad2c2b2034f4b7e4a7c7541fdbf36f4'),
  -- data/triggers/462/462_22_nukreth_spire_beastmaster_death.lua
  (462, 22, $trig$-- Converted from DG Script #46222: Nukreth Spire beastmaster death
-- Original: MOB trigger, flags: DEATH, probability: 100%
local i = actor.group_size
if i then
    local a = 1
    while i >= a do
        local person = actor.group_member[a]
        if person.room == self.room then
            if (person:get_quest_var("nukreth_spire:baby") or 0) == 2 then
                person:set_quest_var("nukreth_spire", "baby", 3)
            elseif (person:get_quest_var("nukreth_spire:baby") or 0) == 3 then
                person:set_quest_var("nukreth_spire", "baby", 4)
            end
        elseif person then
            i = i + 1
        end
        a = a + 1
    end
else
    if (actor:get_quest_var("nukreth_spire:baby") or 0) == 2 then
        actor:set_quest_var("nukreth_spire", "baby", 3)
    elseif (actor:get_quest_var("nukreth_spire:baby") or 0) == 3 then
        actor:set_quest_var("nukreth_spire", "baby", 4)
    end
end$trig$, '8b075f65cebbce7bb886da919f1c58ca'),
  -- data/triggers/462/462_23_nukreth_spire_larder_search.lua
  (462, 23, $trig$-- Converted from DG Script #46223: Nukreth Spire larder search
-- Original: WORLD trigger, flags: COMMAND, probability: 100%

-- Command filter: search
if not (cmd == "search") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
-- switch on cmd
do
    local _sw1 = string.lower(tostring(cmd or ""))
    if _sw1 == "s" then
        _return_value = true
        return _return_value
    end
end
if actor:get_quest_stage("nukreth_spire") > 0 then
    if (actor:get_quest_var("nukreth_spire:path4") or 0) == 0 then
        if (actor:get_quest_var("nukreth_spire:treasure") or 0) == 1 then
            actor:send("You begin searching...")
            actor:set_quest_var("nukreth_spire", "treasure", 2)
            wait(1)
            self.room:send("A sudden bark comes from")
            self.room:send("A gnoll spiritbreaker says, 'What's going on in there??'")
            wait(1)
            self.room:send("The spiritbreaker roars and attacks!")
            actor:send("<b:yellow>You better kill this thing and search again!</>")
            self.room:spawn_mobile(462, 24)
            self.room:find_actor("spiritbreaker"):command("kill " .. tostring(actor.name))
        elseif (actor:get_quest_var("nukreth_spire:treasure") or 0) == 3 then
            actor:set_quest_var("nukreth_spire", "treasure", 0)
            actor:send("You find a strange stone hidden amongst the bodies!")
            self.room:send_except(actor, tostring(actor.name) .. " finds a strange stone hidden amongst the bodies!")
            self.room:spawn_object(462, 15)
        else
            _return_value = true
        end
    else
        _return_value = true
    end
else
    _return_value = true
end
return _return_value$trig$, '3ab23bd3eac73f6f5beef832b38e8d5d'),
  -- data/triggers/462/462_24_nukreth_spire_spiritbreaker_special_death2.lua
  (462, 24, $trig$-- Converted from DG Script #46224: Nukreth Spire spiritbreaker special death2
-- Original: MOB trigger, flags: DEATH, probability: 100%
local i = actor.group_size
if i then
    local a = 1
    while i >= a do
        local person = actor.group_member[a]
        if person.room == self.room then
            if (person:get_quest_var("nukreth_spire:treasure") or 0) == 2 then
                person:set_quest_var("nukreth_spire", "treasure", 3)
            end
        elseif person then
            i = i + 1
        end
        a = a + 1
    end
else
    if (actor:get_quest_var("nukreth_spire:treasure") or 0) == 2 then
        actor:set_quest_var("nukreth_spire", "treasure", 3)
    end
end$trig$, '8bbb84abf80fc864d8191c86e28e6f57'),
  -- data/triggers/462/462_25_nukreth_spire_kobold_receive.lua
  (462, 25, $trig$-- Converted from DG Script #46225: Nukreth Spire kobold receive
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
if actor:get_quest_stage("nukreth_spire") > 0 then
    if (actor:get_quest_var("nukreth_spire:path2") or 0) == 0 then
        if globals.task ~= "done" then
            if object.zone_id == 462 and object.local_id == 14 then
                wait(0.2)
                world.destroy(object)
                self.room:send(tostring(self.name) .. " trills excitedly!")
                wait(1)
                self:say("It's okay, momma's got you now.")
                self.room:send(tostring(self.name) .. " coos at the egg as she cradles it in her arms.")
                wait(2)
                self:say("Thank you!!  Now let's get out of here.")
                self:follow(actor)
                globals.task = "done"
                globals.leader = actor.name
            else
                _return_value = true
                self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
                self:command("shake")
                self:say("I only need my egg.")
            end
        else
            _return_value = true
            self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
            self:command("shake")
            self:say("I already have my egg.")
        end
    else
        _return_value = true
        actor:send("<b:red>You have already completed this quest path.</>")
    end
else
    _return_value = true
    actor:send("<b:red>You must first start this quest before you can earn rewards.</>")
end
return _return_value$trig$, '527d4b515b91706b8159f58eefa1a055'),
  -- data/triggers/462/462_26_nukreth_spire_orc_receive.lua
  (462, 26, $trig$-- Converted from DG Script #46226: Nukreth Spire orc receive
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
if actor:get_quest_stage("nukreth_spire") > 0 then
    if (actor:get_quest_var("nukreth_spire:path3") or 0) == 0 then
        if globals.task ~= "done" then
            if object.zone_id == 462 and object.local_id == 13 then
                wait(0.2)
                self.room:send(tostring(self.name) .. " grins wickedly as he wraps his fingers around the axe.")
                self:command("wie axe")
                wait(1)
                self:say("Revenge will be sweet...")
                wait(2)
                self:say("Now move out!")
                self:follow(actor)
                globals.task = "done"
                globals.leader = actor.name
            else
                _return_value = true
                self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
                self:command("shake")
                self:say("I only need my axe.")
            end
        else
            _return_value = true
            self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
            self:command("shake")
            self:say("I already have my axe.")
        end
    else
        _return_value = true
        actor:send("<b:red>You have already completed this quest path.</>")
    end
else
    _return_value = true
    actor:send("<b:red>You must first start this quest before you can earn rewards.</>")
end
return _return_value$trig$, 'b2d8c671d9d5bd5408eb9a0c712ec840'),
  -- data/triggers/462/462_27_nukreth_spire_goblin_receive.lua
  (462, 27, $trig$-- Converted from DG Script #46227: Nukreth Spire goblin receive
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
if actor:get_quest_stage("nukreth_spire") > 0 then
    if (actor:get_quest_var("nukreth_spire:path4") or 0) == 0 then
        if globals.task ~= "done" then
            if object.zone_id == 462 and object.local_id == 15 then
                wait(0.2)
                world.destroy(object)
                self:command("cheer")
                self:say("Come to papa!")
                self.room:send(tostring(self.name) .. " grins like a fool at the stone.")
                wait(2)
                self:say("Thanks matey.  Now get me outta 'ere.")
                self:follow(actor)
                globals.task = "done"
                globals.leader = actor.name
            else
                _return_value = true
                self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
                self:command("shake")
                self:say("I only want me stone.")
            end
        else
            _return_value = true
            self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
            self:command("shake")
            self:say("I already have me stone.")
        end
    else
        _return_value = true
        actor:send("<b:red>You have already completed this quest path.</>")
    end
else
    _return_value = true
    actor:send("<b:red>You must first start this quest before you can earn rewards.</>")
end
return _return_value$trig$, '095afd4664a666188c47be30c2e85cfd'),
  -- data/triggers/481/481_153_mccabe_greet.lua
  (481, 153, $trig$-- Converted from DG Script #48253: mccabe greet
-- Original: MOB trigger, flags: GREET, probability: 100%
local stage = actor:get_quest_stage("meteorswarm")
wait(1)
-- No one should be here but sorcs and pyros, so let's throw the rest back out
if actor.class ~= "sorcerer" and actor.class ~= "pyromancer" and actor:get_quest_stage("type_wand") < (wandstep or 999) then
    self:command("con " .. tostring(actor))
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
elseif (string.find(actor.class, "sorcerer") and actor.level > 72) or (string.find(actor.class, "pyromancer") and actor.level > 80) or actor:get_quest_stage("type_wand") == "wandstep" then
    local minlevel = ((wandstep or 1) - 1) * 10
    if (string.find(actor.class, "sorcerer") and actor.level > 72) or (string.find(actor.class, "pyromancer") and actor.level > 80) then
        if actor:get_quest_var("meteorswarm:new") ~= "no" then
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
        if actor:get_quest_stage("type_wand") == "wandstep" then
            if actor.level >= minlevel then
                if (actor:get_quest_var("type_wand:greet") or 0) == 0 then
                    actor:send(tostring(self.name) .. " tells you, 'Or is there even MORE you want from me?  You seem to be in need of a crafting <b:cyan>[upgrade]</>.'")
                else
                    actor:send(tostring(self.name) .. " says, 'Do you have what I need for the " .. tostring(weapon) .. "?'")
                end
            end
        end
    else
        if actor.level >= minlevel then
            if (actor:get_quest_var("type_wand:greet") or 0) == 0 then
                actor:send(tostring(self.name) .. " tells you, 'I see you're crafting something.  If you want my help, we can talk about <b:cyan>[upgrades]</>.'")
            else
                actor:send(tostring(self.name) .. " tells you, 'Do you have what I need for the " .. tostring(weapon) .. "?'")
            end
        end
    end
end$trig$, '1a28ecb5387ae7fa3c6c867e94a264fa'),
  -- data/triggers/481/481_158_mccabe_receive.lua
  (481, 158, $trig$-- Converted from DG Script #48258: mccabe_receive
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
local stage = actor:get_quest_stage("meteorswarm")
local earth = actor:get_quest_var("meteorswarm:earth")
local air = actor:get_quest_var("meteorswarm:air")
if object.zone_id == 481 and object.local_id == 151 then
    _return_value = true
    self:command("shake")
    wait(0.2)
    actor:send(tostring(self.name) .. " tells you, 'Go <b:cyan>use</> this new treasure; don't give it back to me!'")
elseif actor:get_quest_var("meteorswarm:new") ~= "no" then
    _return_value = true
    self.room:send(tostring(self.name) .. " accepts the meteorite.")
    wait(0.2)
    actor:send(tostring(self.name) .. " tells you, 'Good, this will work.'")
    self.room:send(tostring(self.name) .. " returns " .. tostring(object.shortdesc) .. ".")
    wait(2)
    actor:send(tostring(self.name) .. " tells you, 'Go, resume your studies.'")
    actor:set_quest_var("meteorswarm", "new", 0)
else
    -- switch on stage
    do
        local _sw1 = string.lower(tostring(stage or ""))
        if tonumber(_sw1) == 1 then
            _return_value = true
            self:command("eye")
            wait(1)
            actor:send(tostring(self.name) .. " tells you, 'No, go find Jemnon first.'")
        elseif tonumber(_sw1) == 2 then
            _return_value = true
            self:command("eye")
            wait(1)
            actor:send(tostring(self.name) .. " tells you, 'No, go find the rock demon first.'")
        elseif tonumber(_sw1) == 3 then
            if (earth or 0) == 0 then
                _return_value = true
                actor:send("You give " .. tostring(object.shortdesc) .. " to " .. tostring(self.name) .. ".")
                actor:send(tostring(self.name) .. " tells you, 'Such wonderfully powerful stone.  This will do perfectly.'")
                wait(3)
                actor:send(tostring(self.name) .. " tells you, 'Next, you need to demonstrate mastery over fire.'")
                wait(2)
                actor:send(tostring(self.name) .. " tells you, 'The northern cult of fire provides an excellent opportunity to do so.'")
                wait(1)
                actor:send(tostring(self.name) .. " tells you, 'Take the meteor, <b:cyan>slay the high priest, and find the secret lava well</>.'")
                wait(3)
                actor:send(tostring(self.name) .. " tells you, 'The charge from such energy will be ideal for conjuring.'")
                wait(0.2)
                actor:send(tostring(self.name) .. " returns " .. tostring(object.shortdesc) .. " to you.")
                actor:set_quest_var("meteorswarm", "earth", 1)
            else
                _return_value = true
                actor:send(tostring(self.name) .. " tells you, 'Yes yes, you have already proven it's a lovely focus.'")
            end
        elseif tonumber(_sw1) == 4 then
            _return_value = true
            self:command("eye")
            wait(1)
            actor:send(tostring(self.name) .. " tells you, 'No, go find Dargentan first.'")
        elseif tonumber(_sw1) == 5 then
            if (air or 0) == 0 then
                self:destroy_item("meteorite")
                wait(1)
                actor:send(tostring(self.name) .. " tells you, 'This meteorite, representing the force of earth, has been imbued with the spirits of fire and air.  It will serve as the perfect focus for casting meteorswarm.'")
                wait(4)
                actor:send(tostring(self.name) .. " tells you, 'You are ready.'")
                wait(3)
                self.room:spawn_object(481, 151)
                self:command("give meteorite " .. tostring(actor.name))
                wait(1)
                actor:send(tostring(self.name) .. " tells you, 'Go somewhere safe, and <b:cyan>use it</> to unlock its potential.'")
                actor:set_quest_var("meteorswarm", "air", 1)
            else
                _return_value = true
                actor:send(tostring(self.name) .. " tells you, 'Where did you find a second one of these?  You don't need it.'")
            end
        else
            _return_value = true
            wait(1)
            self:command("eye")
            actor:send(tostring(self.name) .. " tells you, 'And what exactly am I supposed to do with this?'")
        end
    end
end
return _return_value$trig$, '27bda523b0ac2c3ae6b6dbfa77560bd4'),
  -- data/triggers/481/481_199_meteorswarm_status_checker.lua
  (481, 199, $trig$-- Converted from DG Script #48299: meteorswarm_status_checker
-- Original: MOB trigger, flags: SPEECH, probability: 0%

-- Speech phrase: spell progress (DG num_arg 0 = the speech contains the whole phrase, on word boundaries)
local speech_padded = " " .. string.lower(speech) .. " "
if not string.find(speech_padded, "[%s%p]spell progress[%s%p]") then
    return true  -- Not the phrase
end
local stage = actor:get_quest_stage("meteorswarm")
wait(0.2)
if actor:get_quest_var("meteorswarm:new") ~= "yes" then
    actor:send(tostring(self.name) .. " says, 'Go find a new meteorite.'")
    return true
elseif actor:get_quest_var("meteorswarm:new") ~= "no" then
    actor:send(tostring(self.name) .. " says, 'Show me the meteorite again.'")
    return true
end
-- switch on stage
do
    local _sw1 = string.lower(tostring(stage or ""))
    if tonumber(_sw1) == 1 then
        actor:send(tostring(self.name) .. " tells you, 'You need to find Jemnon and <b:cyan>ask about the rock demon</>.  He's in some <b:cyan>tavern</>, no doubt, waiting for some new blunder to embark on.'")
    elseif tonumber(_sw1) == 2 then
        actor:send(tostring(self.name) .. " tells you, 'Find a suitable focus by defeating the rock demon in Templace.'")
    elseif tonumber(_sw1) == 3 then
        if (actor:get_quest_var("meteorswarm:earth") or 0) == 0 then
            actor:send(tostring(self.name) .. " tells you, 'Show me the meteorite.'")
        else
            if (actor:get_quest_var("meteorswarm:fire") or 0) == 0 then
                actor:send(tostring(self.name) .. " tells you, 'Find and kill the high fire priest in the Lava Tunnels.  Then enter the lava bubble below his secret chambers.'")
            else
                actor:send(tostring(self.name) .. " tells you, 'Find the lava bubble in the high fire priest's secret chambers.'")
            end
        end
        wait(1)
        actor:send(tostring(self.name) .. " says, 'If you somehow lost the meteorite, say <b:red>\"I lost the meteorite\"</>.'")
    elseif tonumber(_sw1) == 4 then
        actor:send(tostring(self.name) .. " tells you, 'Convince the ancient dragon Dargentan to teach you the ways of air magic.'")
        wait(1)
        actor:send(tostring(self.name) .. " says, 'If you somehow lost the meteorite, say <b:red>\"I lost the meteorite\"</>.'")
    elseif tonumber(_sw1) == 5 then
        if (actor:get_quest_var("meteorswarm:air") or 0) == 0 then
            actor:send(tostring(self.name) .. " tells you, 'Show me the meteorite now that you have mastered earth, fire, and air.'")
            wait(1)
            actor:send(tostring(self.name) .. " says, 'If you somehow lost the meteorite, say <b:red>\"I lost the meteorite\"</>.'")
        else
            actor:send(tostring(self.name) .. " tells you, 'Take your finished focus and unleash its potential!'")
        end
    end
end$trig$, 'b6768028f44c38e3b0b375e7a236b119'),
  -- data/triggers/481/481_24_vulcera_greet1.lua
  (481, 24, $trig$-- Converted from DG Script #48124: vulcera_greet1
-- Original: MOB trigger, flags: GREET, GREET_ALL, probability: 100%
wait(0.6)
self:command("peer " .. tostring(actor.name))
self:say("So puny one, you dare to disturb me?")
local stage = 7
local person = actor
local i = person.group_size
local a
if i then
    a = 1
else
    a = 0
end
while i >= a do
    person = actor.group_member[a]
    if person.room == self.room then
        if person:get_quest_stage("type_wand") == "wandstep" then
            if person.level >= 60 then
                if (person:get_quest_var("type_wand:greet") or 0) == 0 then
                    wait(0.2)
                    self:say("What do you want pathetic mortal?")
                else
                    self:say("Do you have what I require for the " .. tostring(weapon) .. "?")
                end
            end
        end
        if person:get_quest_stage("fieryisle_quest") == stage then
            person:advance_quest("fieryisle_quest")
            person:send("<b:white>You have advanced your quest!</>")
            if person:has_item(481, 16) then
                wait(0.2)
                self:emote("does a double take at " .. tostring(person.name) .. ".")
                self:say("Are you the one who has the key to the ivory chest?!")
                wait(1)
                self:command("bow " .. tostring(person.name))
                self:say("If so you could end my punishment, I would make it worth your while.")
                wait(2)
                self:emote("mutters a brief incantation and a cloak of flames appears.")
                person:send("<b:white>Group credit will not be awarded for the next step.</>")
            end
        end
    elseif person and person.is_player then
        i = i + 1
    end
    a = a + 1
end$trig$, 'a002c0aa3a3fe18b4b516f7d1515a5ab'),
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
    minlevel = (wandstep - 1) * 10
elseif macestep and macestep ~= 0 then
    minlevel = macestep * 10
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
        local minlevel = (wandstep - 1) * 10
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
        local minlevel = (wandstep - 1) * 10
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
end$trig$, '784663d3f028f72b3fc624f7f455cad9'),
  -- data/triggers/484/484_19_wild-hunt_deer_flee.lua
  (484, 19, $trig$-- Converted from DG Script #48419: wild-hunt deer flee
-- Original: MOB trigger, flags: GLOBAL, COMMAND, probability: 100%

-- Command filter: drop
if not (cmd == "drop") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
-- If drop the player is using the secret keyword to drop
-- the rag, flee!  Unfortunately, players can force the
-- deer to flee any time, so don't tell any of them this
-- keyword.
_return_value = true
allow_command()  -- legacy `return 0` ahead of the wait: the drop goes ahead
if actor:get_quest_stage("doom_entrance") > 0 and (actor:get_quest_var("doom_entrance:wild_hunt") or 0) == 1 and arg == "ragtoscarewhitetaileddeer" then
    wait(0.1)
    local room = self.room
    while room == self.room do
        self:command("flee")
    end
end
return _return_value$trig$, '1cd690b0827b83a143961b4d5c969d5f'),
  -- data/triggers/519/519_02_academy_instructor_hello_class.lua
  (519, 2, $trig$-- Converted from DG Script #51902: academy_instructor_hello_class
-- Original: MOB trigger, flags: SPEECH_TO, probability: 0%

-- Speech phrase: hello class (DG num_arg 0 = the speech contains the whole phrase, on word boundaries)
local speech_padded = " " .. string.lower(speech) .. " "
if not string.find(speech_padded, "[%s%p]hello class[%s%p]") then
    return true  -- Not the phrase
end
if (actor:get_quest_var("school:speech") or 0) == 1 then
    actor:set_quest_var("school", "speech", 2)
    wait(0.2)
    actor:send(tostring(self.name) .. " tells you, 'Exactly!'")
    wait(1)
    actor:send(tostring(self.name) .. " tells you, 'You can talk to one person at a time by using the <b:cyan>(T)ELL</> command.")
    actor:send("Only the person you TELL to will hear what you say.")
    actor:send("You can talk to anyone, anywhere in the world.")
    actor:send("You do it by typing <b:cyan>tell [person] [message]</>'")
    wait(3)
    actor:send(tostring(self.name) .. " tells you, 'Try typing <b:green>tell instructor hello teacher</>.'")
end$trig$, 'b5840fc6f4e1cd3fe2bc628d09693562'),
  -- data/triggers/519/519_03_academy_instructor_speech2.lua
  (519, 3, $trig$-- Converted from DG Script #51903: academy_instructor_speech2
-- Original: MOB trigger, flags: SPEECH, probability: 0%

-- Speech phrase: hello teacher (DG num_arg 0 = the speech contains the whole phrase, on word boundaries)
local speech_padded = " " .. string.lower(speech) .. " "
if not string.find(speech_padded, "[%s%p]hello teacher[%s%p]") then
    return true  -- Not the phrase
end
if (actor:get_quest_var("school:speech") or 0) == 2 then
    actor:set_quest_var("school", "speech", 3)
    wait(0.2)
    actor:send(tostring(self.name) .. " tells you, 'Well hello yourself!  You're learning well!'")
    wait(1)
    actor:send(tostring(self.name) .. " tells you, 'Mass communication channels include:'")
    -- (empty send to actor)
    actor:send("</><b:cyan>(GOS)SIP</> which talks to everyone in the game at once.")
    actor:send("</>   It's definitely the most popular communication channel.")
    actor:send("</>   It's a great way to ask questions or get help.")
    -- (empty send to actor)
    actor:send("</><b:cyan>(SH)OUT</> which talks to everyone in your zone.")
    -- (empty send to actor)
    actor:send("</><b:cyan>(PETI)TION</> which talks to all the Gods currently online.")
    actor:send("</>   It's best for asking semi-private or admin questions.")
    -- (empty send to actor)
    actor:send("</><b:cyan>GROUPSAY</> or <b:cyan>GSAY</> talks to everyone you're grouped with.")
    actor:send("</>   Check <b:cyan>HELP GROUP</> for more information on grouping.")
    -- (empty send to actor)
    actor:send("You can also use <b:cyan>LASTGOS</> and <b:cyan>LASTTEL</> to see what the last messages you received were.")
    -- (empty send to actor)
    actor:send("To see who's logged on, use the <b:cyan>WHO</> command.")
    wait(3)
    actor:send(tostring(self.name) .. " tells you, 'Do you have any questions about communication?")
    actor:send("You can <b:green>say yes</> or <b:green>say no</>.'")
end$trig$, 'a60bda9545055b826193c21695a3e152'),
  -- data/triggers/519/519_04_academy_instructor_speech_yes_no_continue.lua
  (519, 4, $trig$-- Converted from DG Script #51904: academy_instructor_speech_yes_no_continue
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"yes", "no", "continue"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
wait(0.2)
if actor:get_quest_stage("school") == 1 then
    if speech == "yes" then
        if (actor:get_quest_var("school:speech") or 0) == 3 then
            actor:send(tostring(self.name) .. " tells you, 'What would you like to review?  You can say:")
            actor:send("<b:yellow>Say</>")
            actor:send("<b:yellow>Tell</>")
            actor:send("<b:yellow>Gossip</>_")
            actor:send("I'll know you're ready to move on if you <b:green>say continue</>.'")
        elseif (actor:get_quest_var("school:gear") or 0) == 16 then
            actor:send(tostring(self.name) .. " tells you, 'What would you like to review?  You can say:")
            actor:send("<b:yellow>Inventory</>")
            actor:send("<b:yellow>Wear</>")
            actor:send("<b:yellow>Equipment</>")
            actor:send("<b:yellow>Light</>")
            actor:send("<b:yellow>Remove</>")
            actor:send("<b:yellow>Get</>")
            actor:send("<b:yellow>Drop</>")
            actor:send("<b:yellow>Junk</>")
            actor:send("<b:yellow>Give</>")
            actor:send("<b:yellow>Put</>_")
            actor:send("I'll know you're ready to move on if you <b:green>say continue</>.'")
        elseif (actor:get_quest_var("school:explore") or 0) == 6 then
            actor:send(tostring(self.name) .. " tells you, 'What would you like to review?  You can say:")
            actor:send("<b:yellow>Look</>")
            actor:send("<b:yellow>Search</>")
            actor:send("<b:yellow>Doors</>")
            actor:send("<b:yellow>Scan</>")
            actor:send("<b:yellow>Movement</>_")
            actor:send("I'll know you're ready to move on if you <b:green>say continue</>.'")
        end
    else
        if (actor:get_quest_var("school:speech") or 0) == 3 then
            actor:set_quest_var("school", "speech", "complete")
        elseif (actor:get_quest_var("school:gear") or 0) == 16 then
            actor:set_quest_var("school", "gear", "complete")
        elseif (actor:get_quest_var("school:explore") or 0) == 6 then
            actor:set_quest_var("school", "explore", "complete")
        end
        local advance
        if actor:get_quest_var("school:speech") == "complete" and actor:get_quest_var("school:gear") == "complete" and actor:get_quest_var("school:explore") == "complete" then
            advance = "yes"
        else
            advance = "no"
        end
        if advance == "yes" then
            actor:advance_quest("school")
            actor:send(tostring(self.name) .. " tells you, 'Then you're ready to move on!")
            actor:send("Proceed <b:green>east</>.")
            actor:send("In the next room you'll prepare for combat training!'")
        elseif advance == "no" then
            actor:send(tostring(self.name) .. " tells you, 'It looks like you still need to complete lessons on:")
            if actor:get_quest_var("school:speech") ~= "complete" then
                actor:send("<b:yellow>COMMUNICATION</>")
            end
            if actor:get_quest_var("school:gear") ~= "complete" then
                actor:send("<b:yellow>GEAR</>")
            end
            if actor:get_quest_var("school:explore") ~= "complete" then
                actor:send("<b:yellow>EXPLORATION</>")
            end
            actor:send("</>")
            actor:send("You can <b:green>say</> any of these to start a lesson on it or say <magenta>SKIP</> to move on to the next teacher.'")
        end
    end
end$trig$, 'f2855f64a5589c827c18bd3b2ad1904b'),
  -- data/triggers/519/519_05_academy_instructor_speech_say_tell_gossip.lua
  (519, 5, $trig$-- Converted from DG Script #51905: academy_instructor_speech_say_tell_gossip
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"say", "tell", "gossip"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
wait(0.2)
if (actor:get_quest_var("school:speech") or 0) == 3 then
    if speech == "say" then
        actor:send(tostring(self.name) .. " tells you, 'The most basic command is <b:cyan>(SA)Y</>.")
        actor:send("It sends your message to everything in the room, even NPCs and monsters.'")
    elseif speech == "tell" or speech == "whisper" then
        actor:send(tostring(self.name) .. " tells you, 'You can talk to one person by using <b:cyan>(T)ELL</>.")
        actor:send("Only the person you talk to will hear what you say, just like how I'm talking to you right now.")
        actor:send("You use it by typing <b:cyan>TELL [person] [message]</>.'")
    elseif speech == "gossip" then
        actor:send(tostring(self.name) .. " tells you, '<b:cyan>(GOS)SIP</> talks to everyone in the game.")
        actor:send("It's definitely the most popular communication channel.")
        actor:send("It's a great way to ask questions or get help.'")
    end
    actor:send("</>")
    actor:send(tostring(self.name) .. " tells you, 'Do you have any other questions about communication?")
    actor:send(tostring(self.name) .. " tells you, 'You can <b:green>say yes</> or <b:green>say no</>.'")
end$trig$, '964a6b582e02e814a2c4f2772ccf5788'),
  -- data/triggers/519/519_06_academy_instructor_command_inventory.lua
  (519, 6, $trig$-- Converted from DG Script #51906: academy_instructor_command_inventory
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: inventory
if not (cmd == "inventory") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
if (actor:get_quest_var("school:gear") or 0) == 1 then
    actor:command("inventory")
    actor:set_quest_var("school", "gear", 2)
    wait(0.2)
    actor:send(tostring(self.name) .. " tells you, 'Good!  Now you can see everything you have.")
    actor:send("In order to gain benefits from items, you have to equip them.'")
    wait(3)
    actor:send(tostring(self.name) .. " tells you, 'There are three commands to equip items:")
    actor:send("<b:cyan>(WEA)R</>, <b:cyan>(WI)ELD</>, and <b:cyan>(HO)LD</>.'</>")
    -- (empty send to actor)
    actor:send("<b:cyan>WEAR</> will equip something from your inventory.")
    actor:send("You can equip most objects by typing <b:cyan>WEAR [object]</>.")
    actor:send("Weapons can be equipped with either <b:cyan>WEAR</> or <b:cyan>WIELD</>.")
    actor:send("<b:cyan>WEAR ALL</> will equip everything in your inventory at once.")
    -- (empty send to actor)
    actor:send("Some items can only be equipped with the <b:cyan>HOLD</> command.")
    actor:send("That includes instruments, wands, staves, magic orbs, etc.")
    actor:send("They will not be equipped with the <b:cyan>wear all</> command.")
    actor:send("Once you are holding them they can be activated with the <b:cyan>USE</> command.")
    wait(7)
    actor:send(tostring(self.name) .. " tells you, 'Go ahead and type <b:green>wear all</> and see what happens.'")
end
_return_value = true
return _return_value$trig$, '5e1a8cc38a08a6ac943fcb4f90a94aa8'),
  -- data/triggers/519/519_07_academy_instructor_command_wear.lua
  (519, 7, $trig$-- Converted from DG Script #51907: academy_instructor_command_wear
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: wear
if not (cmd == "wear") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
-- switch on cmd
do
    local _sw1 = string.lower(tostring(cmd or ""))
    if _sw1 == "w" or _sw1 == "we" then
        _return_value = true
        return _return_value
    end
end
if (actor:get_quest_var("school:gear") or 0) == 2 and arg == "all" then
    actor:command("wear all")
    actor:set_quest_var("school", "gear", 3)
    wait(0.2)
    actor:send(tostring(self.name) .. " tells you, 'That's how you do it!'")
    wait(2)
    actor:send(tostring(self.name) .. " tells you, 'The <b:cyan>(EQ)UIPMENT</> command shows what gear you're using.")
    actor:send("You are gaining active benefits from these items.")
    actor:send("They will not show up in your inventory.'")
    wait(2)
    actor:send(tostring(self.name) .. " tells you, 'Type <b:green>equipment</> or just <b:green>eq</> to try it out.'")
end
_return_value = true
return _return_value$trig$, 'ac084cff086756552d74f8a715f91d50'),
  -- data/triggers/519/519_08_academy_instructor_command_equipment.lua
  (519, 8, $trig$-- Converted from DG Script #51908: academy_instructor_command_equipment
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: equipment
if not (cmd == "equipment") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
-- switch on cmd
do
    local _sw1 = string.lower(tostring(cmd or ""))
    if _sw1 == "e" then
        _return_value = true
        return _return_value
    end
end
if (actor:get_quest_var("school:gear") or 0) == 3 then
    actor:set_quest_var("school", "gear", 4)
    actor:command("eq")
    wait(0.2)
    self:command("l " .. tostring(actor))
    actor:send(tostring(self.name) .. " tells you, 'You look well equipped to me!'")
    wait(2)
    actor:send(tostring(self.name) .. " tells you, 'Another way to equip things is with the <b:cyan>(HO)LD</> command.")
    if actor:has_item(0, 23) or actor:has_equipped(0, 23) then
        actor:send("You started play with a torch.'")
    else
        actor:send("Here, take this torch for example.'")
        self.room:spawn_object(0, 23)
        self:command("give torch " .. tostring(actor))
    end
    wait(3)
    actor:send(tostring(self.name) .. " tells you, 'Type <b:green>hold torch</> to equip it.'")
end
_return_value = true
return _return_value$trig$, '49d9da46dbacec93a96f0da99aaabc31'),
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
do
    local _sw1 = string.lower(tostring(cmd or ""))
    if _sw1 == "l" then
        _return_value = true
        return _return_value
    end
end
-- `arg` is the typed argument ("torch"), not an object: this trigger sits on the academy torch
-- (0:23), so the lesson step applies when the argument names this object.
local names_this_torch = arg ~= "" and string.find(string.lower(tostring(self.name)), string.lower(arg), 1, true)
if (actor:get_quest_var("school:gear") or 0) == 5 and names_this_torch then
    -- The queued command below does the lighting, so the typed one is blocked (it would otherwise
    -- run first and the queued `light` would toggle the torch straight back off).
    _return_value = false
    actor:command("light " .. tostring(arg))
    actor:set_quest_var("school", "gear", 6)
    wait(0.2)
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
return _return_value$trig$, 'e7d8ad530ca3ecf6fa5acaa5606cd870'),
  -- data/triggers/519/519_10_academy_torch_remove.lua
  (519, 10, $trig$-- Converted from DG Script #51910: academy_torch_remove
-- Original: OBJECT trigger, flags: REMOVE, probability: 100%
if (actor:get_quest_var("school:gear") or 0) == 6 then
    actor:set_quest_var("school", "gear", 7)
    wait(0.2)
    actor:send(tostring(mobiles.template(519, 2).name) .. " tells you, 'Good, save that light!'")
    wait(2)
    actor:send(tostring(mobiles.template(519, 2).name) .. " tells you, 'During your adventures, you can pick up stuff using the <b:cyan>(G)ET</> command.'")
    wait(2)
    self.room:find_actor("instructor"):spawn_object(519, 2)
    self.room:find_actor("instructor"):spawn_object(519, 2)
    self.room:find_actor("instructor"):spawn_object(519, 2)
    self.room:find_actor("instructor"):spawn_object(519, 2)
    self.room:find_actor("instructor"):spawn_object(519, 2)
    self.room:find_actor("instructor"):command("drop all.stick")
    actor:send(tostring(mobiles.template(519, 2).name) .. " tells you, 'Pick up one of those sticks by typing <b:green>get stick</>.'")
end$trig$, '7df2731990008d3ac4f55c34bbb1e815'),
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
if (actor:get_quest_var("school:gear") or 0) == 7 then
    if names_stick then
        actor:set_quest_var("school", "gear", 8)
        actor:command("get " .. tostring(arg))
        wait(0.2)
        actor:send(tostring(self.name) .. " tells you, 'Well done!  It's as simple as that!'")
        wait(2)
        actor:send(tostring(self.name) .. " tells you, 'If you don't want to pick up the first one, you can target a different one by adding a number and a \".\" before the name.'")
        wait(2)
        actor:send(tostring(self.name) .. " tells you, 'Try typing <b:green>get 2.stick</> and see what happens.'")
    end
elseif (actor:get_quest_var("school:gear") or 0) == 8 then
    if names_stick and string.find(arg, "2.", 1, true) then
        actor:set_quest_var("school", "gear", 9)
        actor:command("get " .. tostring(arg))
        wait(0.2)
        actor:send(tostring(self.name) .. " tells you, 'Yes, like that.'")
        actor:send("</>")
        actor:send("You can also pick up all of one thing by typing <b:cyan>GET all.[object]</>.")
        actor:send("Or you can be extra greedy by typing <b:cyan>GET ALL</>.")
        actor:send("That will pick up everything in the room.'")
        wait(2)
        actor:send(tostring(self.name) .. " tells you, 'Type <b:green>get all</> with nothing after it.'")
    end
elseif (actor:get_quest_var("school:gear") or 0) == 9 and arg == "all" then
    actor:set_quest_var("school", "gear", 10)
    actor:command("get all")
    wait(0.2)
    actor:send(tostring(self.name) .. " tells you, 'Those are some sticky fingers!'")
    self:command("laugh")
    wait(2)
    actor:send(tostring(self.name) .. " tells you, 'Now it's possible your inventory might get full.")
    actor:send("You can only carry so many items in your inventory at once but there are a few ways to deal with that.'")
    wait(2)
    actor:send(tostring(self.name) .. " tells you, 'First, you can <b:cyan>(DRO)P</> items with the command <b:cyan>DROP [object]</>.'")
    actor:send("</>")
    actor:send(tostring(self.name) .. " tells you, 'Drop one of those sticks by typing <b:green>drop stick</>.'")
elseif (actor:get_quest_var("school:gear") or 0) == 15 and string.find(arg, "stick bag") then
    actor:set_quest_var("school", "gear", 16)
    actor:command("get stick bag")
    wait(0.2)
    self:command("cheer")
    actor:send(tostring(mobiles.template(519, 2).name) .. " tells you, 'Congratulations, you mastered equipment management!")
    actor:send("Would you like to review?")
    actor:send("You can <b:green>say yes</> or <b:green>say no</>.'")
end
_return_value = true
return _return_value$trig$, 'd07e8fe310f3d56928762e9b2b1d9ad9'),
  -- data/triggers/519/519_12_academy_stick_drop.lua
  (519, 12, $trig$-- Converted from DG Script #51912: academy_stick_drop
-- Original: OBJECT trigger, flags: DROP, probability: 100%
if (actor:get_quest_var("school:gear") or 0) == 10 then
    actor:set_quest_var("school", "gear", 11)
    wait(0.2)
    actor:send(tostring(mobiles.template(519, 2).name) .. " tells you, 'Exactly.  Dropping objects leaves them for anyone else to pick up.")
    actor:send("Be careful!  Sometimes monsters can pick up things too!")
    actor:send("</>")
    actor:send("You can permanently destroy objects with the <b:cyan>(J)UNK</> command.'</>")
    wait(2)
    actor:send(tostring(mobiles.template(519, 2).name) .. " tells you, 'Try junking a stick by typing <b:green>junk stick</>.'</>")
elseif (actor:get_quest_var("school:gear") or 0) == 13 and target and target.id == 18 then
    actor:set_quest_var("school", "gear", 14)
    wait(0.2)
    actor:send(tostring(mobiles.template(519, 2).name) .. " tells you, 'That's how it's done.'")
    wait(2)
    actor:send(tostring(mobiles.template(519, 2).name) .. " tells you, 'To see what's inside something, use <b:cyan>(EXA)MINE [target]</>.")
    actor:send("<b:cyan>EXAMINE</> will also show if something is open or closed.'")
    wait(2)
    actor:send(tostring(mobiles.template(519, 2).name) .. " tells you, 'Go ahead and <b:green>examine bag</> and see what you find.'")
end$trig$, '62d2c8da0d179f247ffe1b60338eb63f'),
  -- data/triggers/519/519_13_academy_instructor_command_junk.lua
  (519, 13, $trig$-- Converted from DG Script #51913: academy_instructor_command_junk
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: junk
if not (cmd == "junk") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
-- `arg` is the typed argument, not an object: the lesson stick (519:2) is the object with keyword "stick".
if (actor:get_quest_var("school:gear") or 0) == 11 and string.find(string.lower(arg), "stick", 1, true) then
    actor:set_quest_var("school", "gear", 12)
    actor:command("junk " .. tostring(arg))
    wait(0.2)
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
return _return_value$trig$, '3cd0691493d1d2de04381847d6b68390'),
  -- data/triggers/519/519_14_academy_instructor_command_give.lua
  (519, 14, $trig$-- Converted from DG Script #51914: academy_instructor_command_give
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
if (actor:get_quest_var("school:gear") or 0) == 12 then
    actor:set_quest_var("school", "gear", 13)
    wait(0.2)
    world.destroy(object)
    actor:send(tostring(self.name) .. " tells you, 'Why thank you, what a lovely gift.'")
    self:command("grin")
    wait(2)
    actor:send(tostring(self.name) .. " tells you, 'Lastly, you can <b:cyan>(P)UT</> objects in containers.")
    actor:send("The command is <b:cyan>PUT [object] [container]</>.'")
    wait(2)
    actor:send(tostring(self.name) .. " tells you, 'You started with a bag, but just in case here's another.'")
    self.room:spawn_object(0, 18)
    self:command("give bag " .. tostring(actor))
    wait(3)
    actor:send(tostring(self.name) .. " tells you, 'Put a stick in it by typing <b:green>put stick bag</>.'")
end$trig$, '82b5624c018c4e418d315de9a2497a03'),
  -- data/triggers/519/519_15_academy_instructor_speech_expl_commands.lua
  (519, 15, $trig$-- Converted from DG Script #51915: academy_instructor_speech_expl_commands
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"look", "search", "doors", "scan", "movement"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
if (actor:get_quest_var("school:explore") or 0) == 6 then
    -- switch on speech
    do
        local _sw1 = string.lower(tostring(speech or ""))
        if _sw1 == "look" then
            actor:send(tostring(self.name) .. " tells you, 'As you look around the room, you'll get four big pieces of information:'")
            actor:send("</>")
            actor:send("</><b:magenta>1. The description of the room.</>")
            actor:send("</>   Tiny but crucial hints can appear in room descriptions - keep your eyes open!")
            actor:send("</>")
            actor:send("</><b:magenta>2. The visible exits from the room.</>")
            actor:send("</>   FieryMUD uses six directions: north, south, east, west, up, down.")
            actor:send("</>   If an exit is visible, it will appear after a hyphen.")
            actor:send("</>   Closed exits like doors and trapdoors will have a # sign after them.")
            actor:send("</>")
            actor:send("<b:magenta>3. Any visible objects.</>")
            actor:send("</>   By default, all identical objects will appear on one line with a number on the left showing how many there are.")
            actor:send("</>")
            actor:send("</><b:magenta>4. All visible creatures.</>")
            actor:send("</>   All identical creatures will appear as one line.")
            actor:send("</>")
            actor:send("You can <b:cyan>LOOK</> at anything to gain more information about it.")
            actor:send("That can be objects, creatures, even the directions!")
        elseif _sw1 == "search" then
            actor:send(tostring(self.name) .. " tells you, 'Throughout the world there are hundreds of hidden doors.")
            actor:send("There can be hints in the room description, or you can try to find them by typing <b:cyan>LOOK [direction]</>.")
            actor:send("</>")
            actor:send("To interact with the door, you have to <b:cyan>(SEA)RCH</> for it first.")
            actor:send("</>")
            actor:send("If you do know what you're looking for, you can type <b:cyan>SEARCH [keyword]</> to find it automatically.")
            actor:send("You might be able to guess the keywords from what you see when you look at things or in directions!")
            actor:send("</>")
            actor:send("If you don't know the keyword, you can just enter <b:cyan>SEARCH</>.")
            actor:send("You'll have a random chance to find any hidden doors.")
            actor:send("</>")
            actor:send("Be aware!  There is a small stun time after you <b:cyan>SEARCH</>!")
            actor:send("It can be very risky to use it in dangerous areas!'")
        elseif _sw1 == "door" then
            actor:send(tostring(self.name) .. " tells you, 'Once you've uncovered a secret door you can interact with it like a normal door.")
            actor:send("You can use the <b:cyan>(O)PEN</> and <b:cyan>(CL)OSE</> commands to open doors or containers.")
            actor:send("Sometimes they might be locked though, and you'll need a key to unlock them.")
            actor:send("</>")
            actor:send("If you <b:cyan>LOOK EAST</>, you can see the curtain from this room is closed.")
            actor:send("To open it just use the <b:cyan>(O)PEN</> command.'</>")
        elseif _sw1 == "scan" then
            actor:send(tostring(self.name) .. " tells you, 'You can <b:cyan>(SCA)N</> to see what's in the areas around you.")
            actor:send("It's free to use and very helpful for anticipating threats.")
            actor:send("Some classes are even able to see more than one room away.")
            actor:send("There is a slight delay after giving the <b:cyan>SCAN</> command, so be careful.'")
        elseif _sw1 == "movement" then
            actor:send(tostring(self.name) .. " tells you, 'You can move in any direction there's an open exit.")
            actor:send("Just type <b:cyan>(N)ORTH (S)OUTH (E)AST (W)EST (U)P</> or <b:cyan>(D)OWN</>.")
            actor:send("</>")
            actor:send("In the lower-left corner of your screen you'll see a display that looks like this:")
            actor:send("<b:yellow>10h(10H) 100v(100V)</>")
            actor:send("The two numbers on the right are your <b:magenta>Movement Points</>.")
            actor:send("The first number is your <b:magenta>Current Movement Points</>.")
            actor:send("The second number is your <b:magenta>Maximum Movement Points</>.")
            actor:send("Your <b:magenta>Maximum</> will increase until level 50.")
            actor:send("</>")
            actor:send("When you move from room to room, your Movement Points go down.")
            actor:send("The amount of Movement Points needed to move around varies by terrain.")
            actor:send("If your Movement Points reach 0 you can't move until you rest.'")
        end
    end
    actor:send("</>")
    actor:send(tostring(self.name) .. " tells you, 'Would you like to review something else?")
    actor:send("You can <b:green>say yes</> or <b:green>say no</>.'")
end$trig$, '202ca054af63195905912246d0147ff7'),
  -- data/triggers/519/519_16_academy_instructor_speech_inv_commands.lua
  (519, 16, $trig$-- Converted from DG Script #51916: academy_instructor_speech_inv_commands
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"inventory", "wear", "equipment", "light", "remove", "get", "drop", "junk", "give", "put", "examine"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
wait(0.2)
if (actor:get_quest_var("school:gear") or 0) == 16 then
    -- switch on speech
    do
        local _sw1 = string.lower(tostring(speech or ""))
        if _sw1 == "inventory" then
            actor:send(tostring(self.name) .. " tells you, 'You have two places you keep items:")
            actor:send("Your <b:cyan>(I)NVENTORY</> and your <b:cyan>(EQ)UIPMENT</>.")
            actor:send("</>")
            actor:send("Your <b:cyan>(I)NVENTORY</> is all the items you're currently carrying but not actively wearing or using.")
            actor:send("You must equip an item to receive benefits from it.'")
        elseif _sw1 == "wear" then
            actor:send(tostring(self.name) .. " tells you, 'There are three commands to equip items:")
            actor:send("</><b:cyan>(WEA)R</>, <b:cyan>(WI)ELD</>, and <b:cyan>(HO)LD</>.")
            actor:send("</>")
            actor:send("<b:cyan>WEAR</> will equip something from your inventory.")
            actor:send("You can equip most objects by typing <b:cyan>WEAR [object]</>.")
            actor:send("Weapons can be equipped with either <b:cyan>WEAR</> or <b:cyan>WIELD</>.")
            actor:send("</><b:cyan>WEAR ALL</> will equip everything in your inventory at once.")
            actor:send("</>")
            actor:send("Some items can only be equipped with the <b:cyan>HOLD</> command.")
            actor:send("That includes instruments, wands, staves, magic orbs, etc.")
            actor:send("They will not be equipped with the <b:cyan>wear all</> command.")
            actor:send("Once you are holding them they can be activated with the <b:cyan>USE</> command.'")
        elseif _sw1 == "equipment" then
            actor:send(tostring(self.name) .. " tells you, 'The <b:cyan>(EQ)UIPMENT</> command shows what gear you're using.")
            actor:send("You are gaining active benefits from these items.")
            actor:send("They will not show up in your inventory.'")
        elseif _sw1 == "light" then
            actor:send(tostring(self.name) .. " tells you, 'Lights are necessary to see in dark spaces or outside at night.")
            actor:send("The <b:cyan>(LI)GHT</> command turns lights on and off.")
            actor:send("You can just type <b:cyan>light torch</> to light it up.")
            actor:send("If it's already lit, you can type <b:cyan>light torch</> again to extinguish it.")
            actor:send("</>")
            actor:send("Remember, most lights have a limited duration.")
            actor:send("It's best to turn them off when not using them.")
            actor:send("</>")
            actor:send("Lights don't have to be equipped for you to see.")
            actor:send("They work just fine from your inventory.'")
        elseif _sw1 == "remove" then
            actor:send(tostring(self.name) .. " tells you, 'You can stop using items with <b:cyan>(REM)OVE [object]</>.'")
        elseif _sw1 == "get" then
            actor:send(tostring(self.name) .. " tells you, 'During your adventures, you can pick up stuff using the <b:cyan>(G)ET</> command.'")
            actor:send("</>")
            actor:send(tostring(self.name) .. " tells you, 'If there's more than one thing with the same keyword in the room, you can target a specific one by adding a number and a \".\" before the keyword like \"2.stick\" or \"4.bread\".")
            actor:send("</>")
            actor:send("You can also pick up all of one thing by typing <b:cyan>GET all.[object]</>.")
            actor:send("Or you can be extra greedy by typing <b:cyan>GET ALL</>.")
            actor:send("</>")
            actor:send("<b:cyan>GET</> is the command to take things out of containers.")
            actor:send("You can type <b:cyan>GET [object] [container]</> for one thing, or <b:cyan>GET ALL [container]</> to get everything out.'")
        elseif _sw1 == "drop" then
            actor:send(tostring(self.name) .. " tells you, 'You can <b:cyan>(DRO)P</> items in your inventory to get rid of them.")
            actor:send("Type <b:cyan>DROP [object]</> to drop them.")
            actor:send("You can also also drop everything with the same keywords by typing <b:cyan>DROP all.[object]</> or you can drop your whole inventory with <b:cyan>DROP ALL</>.")
            actor:send("</>")
            actor:send("Dropping items leaves them for others to pick up.'")
        elseif _sw1 == "give" then
            actor:send(tostring(self.name) .. " tells you, 'Another way to deal with items is to <b:cyan>(GI)VE</> them away.")
            actor:send("You can do that by typing <b:cyan>GIVE [object] [person]</>.'")
        elseif _sw1 == "junk" then
            actor:send(tostring(self.name) .. " tells you, 'The <b:cyan>(J)UNK</> command permanently destroys items in your inventory.")
            actor:send("You can drop and junk everything with the same keywords by typing <b:cyan>all.[object]</> as well.")
            actor:send("But <b:yellow>be careful</>!")
            actor:send("You might end up junking something with a surprising keyword by accident!'")
        elseif _sw1 == "examine" then
            actor:send(tostring(self.name) .. " tells you, 'To see what's inside something, use the <b:cyan>(EXA)MINE</>.")
            actor:send("<b:cyan>EXAMINE [target]</> will also show if something is open or closed.")
            actor:send("You can check different bags by typing 2.bag, 3.bag, etc.'")
        elseif _sw1 == "put" then
            actor:send(tostring(self.name) .. " tells you, 'You can <b:cyan>(P)UT</> objects in containers to get them out of your inventory.")
            actor:send("The command is <b:cyan>PUT [object] [container]</>.")
            actor:send("After that use <b:cyan>(G)ET</> to take the item back out.")
            actor:send("You can type <b:cyan>GET [object] [container]</> to get a specific thing, or you can type <b:cyan>GET ALL [container]</> to get everything out of the container.'")
        end
    end
    actor:send("</>")
    actor:send(tostring(self.name) .. " tells you, 'Would you like to review anything else?")
    actor:send("You can <b:green>say yes</> or <b:green>say no</>.'")
end$trig$, '37caca4edce6efdcd5a43ed57237fa7d'),
  -- data/triggers/519/519_17_academy_instructor_command_look.lua
  (519, 17, $trig$-- Converted from DG Script #51917: academy_instructor_command_look
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: look
if not (cmd == "look") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
if (actor:get_quest_var("school:explore") or 0) == 1 and (arg == nil or arg == "") then
    actor:set_quest_var("school", "explore", 2)
    -- actor looks around
    wait(0.2)
    actor:send(tostring(self.name) .. " tells you, 'As you look around the room, you'll get four big pieces of information:'")
    actor:send("</>")
    actor:send("</><b:magenta>1. The description of the room.</>")
    actor:send("</>   Tiny but crucial hints can appear in room descriptions - keep your eyes open!")
    actor:send("</>")
    actor:send("</><b:magenta>2. The visible exits from the room.</>")
    actor:send("</>   FieryMUD uses six directions: north, south, east, west, up, down.")
    actor:send("</>   If an exit is visible, it will appear after a hyphen.")
    actor:send("</>   Closed exits like doors and trapdoors will have a # sign after them.")
    actor:send("</>")
    actor:send("<b:magenta>3. Any visible objects.</>")
    actor:send("</>   By default, all identical objects will appear on one line with a number on the left showing how many there are.")
    actor:send("</>")
    actor:send("</><b:magenta>4. All visible creatures.</>")
    actor:send("</>   All identical creatures will appear as one line.")
    actor:send("</>")
    actor:send("You can <b:cyan>LOOK</> at anything to gain more information about it.")
    actor:send("That can be objects, creatures, even the directions!")
    wait(2)
    actor:send(tostring(self.name) .. " tells you, 'For example, type <b:green>look curtain</> to find more clues.'")
elseif (actor:get_quest_var("school:explore") or 0) == 2 and arg == "curtain" then
    actor:set_quest_var("school", "explore", 3)
    actor:command("look curtain")
    wait(0.2)
    actor:send(tostring(self.name) .. " tells you, 'And THAT is a hidden door!'")
    actor:send("</>")
    actor:send(tostring(self.name) .. " tells you, 'Throughout the world there are hundreds of hidden doors.")
    actor:send("There can be hints in the room description, or you can try to find them by typing <b:cyan>LOOK [direction]</>.")
    actor:send("</>")
    actor:send("To interact with the door, you have to <b:cyan>(SEA)RCH</> for it first.")
    actor:send("</>")
    actor:send("If you do know what you're looking for, you can type <b:cyan>SEARCH [keyword]</> to find it automatically.")
    actor:send("You might be able to guess the keywords from what you see when you look at things or in directions!")
    actor:send("</>")
    actor:send("If you don't know the keyword, you can just enter <b:cyan>SEARCH</>.")
    actor:send("You'll have a random chance to find any hidden doors.")
    actor:send("</>")
    actor:send("Be aware!  There is a small stun time after you <b:cyan>SEARCH</>!")
    actor:send("It can be very risky to use it in dangerous areas!'")
    wait(2)
    actor:send(tostring(self.name) .. " tells you, 'But for now, type <b:green>search curtain</> and take a look!'")
end
_return_value = true
return _return_value$trig$, 'a6bfa913ee162957143801cb83fc344e'),
  -- data/triggers/519/519_18_academy_instructor_command_search.lua
  (519, 18, $trig$-- Converted from DG Script #51918: academy_instructor_command_search
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: search
if not (cmd == "search") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
-- switch on cmd
do
    local _sw1 = string.lower(tostring(cmd or ""))
    if _sw1 == "s" then
        _return_value = true
        return _return_value
    end
end
-- switch on arg
do
    local _sw2 = string.lower(tostring(arg or ""))
    if _sw2 == "c" or _sw2 == "cu" or _sw2 == "cur" or _sw2 == "curt" or _sw2 == "curta" or _sw2 == "curtai" or _sw2 == "curtain" then
        if (actor:get_quest_var("school:explore") or 0) == 3 then
            actor:set_quest_var("school", "explore", 4)
            actor:command("search curtain")
            wait(0.2)
            actor:send(tostring(self.name) .. " tells you, 'Exactly, just like that!")
            actor:send("<b:cyan>SEARCH</> can also find hidden objects or creatures.")
            actor:send("</>")
            actor:send("Once you've uncovered the door you can interact with it like a normal door.")
            actor:send("You can use the <b:cyan>(O)PEN</> and <b:cyan>(CL)OSE</> commands to open doors or containers.")
            actor:send("Sometimes they might be locked though, and you'll need a key to unlock them.")
            actor:send("</>")
            actor:send("If you <b:cyan>LOOK EAST</>, you can see the curtain is closed.")
            actor:send("To open it just use the <b:cyan>(O)PEN</> command.'</>")
            wait(2)
            actor:send(tostring(self.name) .. " tells you, 'Type <b:green>open curtain</> to see how it works.'")
        end
        _return_value = true
    else
        if (actor:get_quest_var("school:explore") or 0) == 3 then
            actor:send(tostring(self.name) .. " tells you, 'No no, you have to <b:green>search curtain</>.'")
        else
            _return_value = true
        end
    end
end
return _return_value$trig$, '1117ed67bf5d5619c7c3f9084ee5276b'),
  -- data/triggers/519/519_19_academy_bag_examine.lua
  (519, 19, $trig$-- Converted from DG Script #51919: academy_bag_examine
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
wait(0.2)
if (actor:get_quest_var("school:gear") or 0) == 14 then
    actor:set_quest_var("school", "gear", 15)
    actor:send(tostring(mobiles.template(519, 2).name) .. " tells you, 'Now you can see everything inside the bag.")
    actor:send("You can check different bags by typing 2.bag, 3.bag, etc.")
    actor:send("</>")
    actor:send("The last step is to <b:cyan>(G)ET</> the item back out.")
    actor:send("You can type <b:cyan>GET [object] [container]</> for one thing, or <b:cyan>GET ALL [container]</> to get everything out.'")
    wait(2)
    actor:send(tostring(mobiles.template(519, 2).name) .. " tells you, 'Take that stick back out by typing <b:green>get stick bag</>.'")
end$trig$, 'c85da56ccb7a96da3ec6961fe0bd59f4'),
  -- data/triggers/519/519_20_academy_instructor_command_open.lua
  (519, 20, $trig$-- Converted from DG Script #51920: academy_instructor_command_open
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: open
if not (cmd == "open") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
-- switch on cmd
do
    local _sw1 = string.lower(tostring(cmd or ""))
    if _sw1 == "o" then
        _return_value = true
        return _return_value
    end
end
-- switch on arg
do
    local _sw2 = string.lower(tostring(arg or ""))
    if _sw2 == "c" or _sw2 == "cu" or _sw2 == "cur" or _sw2 == "curt" or _sw2 == "curta" or _sw2 == "curtai" or _sw2 == "curtain" then
        if (actor:get_quest_var("school:explore") or 0) == 4 then
            actor:set_quest_var("school", "explore", 5)
            actor:command("open curtain")
            wait(0.2)
            actor:send(tostring(self.name) .. " tells you, 'Perfect!'")
            wait(2)
            actor:send(tostring(self.name) .. " tells you, 'Now that the door is open, you can <b:cyan>(SCA)N</> to see what's in the areas around you.")
            actor:send("It's free to use and very helpful for anticipating threats.")
            actor:send("Some classes are even able to see more than one room away.")
            actor:send("There is a slight delay after giving the <b:cyan>SCAN</> command, so be careful.'")
            wait(2)
            actor:send(tostring(self.name) .. " tells you, 'Give it a go!  Type <b:green>scan</>.'")
        end
    end
end
_return_value = true
return _return_value$trig$, 'ed1f9c8cc601b5890543951698a1723f'),
  -- data/triggers/519/519_21_academy_instructor_command_scan.lua
  (519, 21, $trig$-- Converted from DG Script #51921: academy_instructor_command_scan
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: scan
if not (cmd == "scan") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
-- switch on cmd
do
    local _sw1 = string.lower(tostring(cmd or ""))
    if _sw1 == "s" or _sw1 == "sc" then
        _return_value = true
        return _return_value
    end
end
if (actor:get_quest_var("school:explore") or 0) == 5 then
    actor:set_quest_var("school", "explore", 6)
    actor:command("scan")
    wait(0.2)
    actor:send(tostring(self.name) .. " tells you, 'You can move in any direction there's an open exit.")
    actor:send("Just type <b:cyan>(N)ORTH (S)OUTH (E)AST (W)EST (U)P</> or <b:cyan>(D)OWN</>.")
    actor:send("</>")
    actor:send("In the lower-left corner of your screen you'll see a display that looks like this:")
    actor:send("<b:yellow>10h(10H) 100v(100V)</>")
    actor:send("The two numbers on the right are your <b:magenta>Movement Points</>.")
    actor:send("The first number is your <b:magenta>Current Movement Points</>.")
    actor:send("The second number is your <b:magenta>Maximum Movement Points</>.")
    actor:send("Your <b:magenta>Maximum</> will increase until level 50.")
    actor:send("</>")
    actor:send("When you move from room to room, your Movement Points go down.")
    actor:send("The amount of Movement Points needed to move around varies by terrain.")
    actor:send("If your Movement Points reach 0 you can't move until you rest.'")
    wait(2)
    actor:send(tostring(self.name) .. " tells you, 'Would you like to review exploration?")
    actor:send("You can <b:green>say yes</> or <b:green>say no</>.'")
end
_return_value = true
return _return_value$trig$, '048b9fc78da52e05bf41e5c64d64848e'),
  -- data/triggers/519/519_23_academy_clerk_greet.lua
  (519, 23, $trig$-- Converted from DG Script #51923: academy_clerk_greet
-- Original: MOB trigger, flags: GREET_ALL, probability: 100%
wait(0.2)
if actor:get_quest_stage("school") == 2 then
    if (actor:get_quest_var("school:prep") or 0) == 1 then
        actor:set_quest_var("school", "prep", "complete")
        actor:send(tostring(self.name) .. " tells you, 'Aww, a fresh-faced adventurer, how sweet.'")
        self:command("chuckle")
        wait(2)
        actor:send(tostring(self.name) .. " tells you, 'Well kid, let's get ya ready to fight!")
        actor:send("I have two quick things to introduce you to:")
        actor:send("<b:yellow>HIT POINTS</>, and <b:yellow>(SC)ORE</>.")
        actor:send("</>")
        actor:send("<b:green>Say</> one or the other to learn about it.")
        actor:send("You can also say <magenta>SKIP</> to move to the next lesson.'")
    elseif (actor:get_quest_var("school:score") or 0) == 1 then
        actor:send(tostring(self.name) .. " tells you, 'Let's pick up where we left off.'")
        wait(0.2)
        actor:send(tostring(self.name) .. " tells you, '<b:cyan>SCORE</> is how you see all the numeric stuff about yourself:")
        actor:send("Experience, Hit and Movement Points, Stats, Saves, blah blah blah.'")
        wait(8)
        actor:send(tostring(self.name) .. " tells you, 'Check it out by typing <b:green>score</> now.'")
    end
elseif actor:get_quest_stage("school") == 3 then
    -- switch on actor.class
    do
        local _sw1 = string.lower(tostring(actor.class or ""))
        if _sw1 == "rogue" or _sw1 == "thief" or _sw1 == "assassin" or _sw1 == "mercenary" or _sw1 == "bard" then
            actor:send(tostring(self.name) .. " tells you, 'I see you're a stealthy type.  You'll do best in lessons with Doctor Mischief.  Proceed <b:green>down</> to their classroom.'")
        elseif _sw1 == "sorcerer" or _sw1 == "cryomancer" or _sw1 == "pyromancer" or _sw1 == "necromancer" or _sw1 == "illusionist" then
            actor:send(tostring(self.name) .. " tells you, 'I see you're an arcane spell caster.  You would definitely benefit from the Chair of Arcane Studies' seminar on spellcasting.  Proceed <b:green>south</> to his laboratory.'")
        elseif _sw1 == "cleric" or _sw1 == "priest" or _sw1 == "diabolist" or _sw1 == "druid" then
            actor:send(tostring(self.name) .. " tells you, 'I see you're a divine spell caster.  You would definitely benefit from private classes with the Professor of Divinity.  Proceed <b:green>east</> to his chapel.'")
        elseif _sw1 == "warrior" or _sw1 == "paladin" or _sw1 == "anti-paladin" or _sw1 == "ranger" or _sw1 == "monk" or _sw1 == "berserker" then
            actor:send(tostring(self.name) .. " tells you, 'I see you're a fighter type.  You'll do best learning from the Academy's Warmaster.  Proceed <b:green>north</> to her arena.'")
        else
            actor:send(tostring(self.name) .. " tells you, 'I have no idea where to send you.  Ask a god for help!'")
        end
    end
end$trig$, '1bece77ec77ceee685203ac16c66ba43'),
  -- data/triggers/519/519_24_academy_clerk_command_score.lua
  (519, 24, $trig$-- Converted from DG Script #51924: academy_clerk_command_score
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: score
if not (cmd == "score") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
-- switch on cmd
do
    local _sw1 = string.lower(tostring(cmd or ""))
    if _sw1 == "s" then
        _return_value = true
        return _return_value
    end
end
if actor:get_quest_stage("school") == 2 then
    if (actor:get_quest_var("school:score") or 0) == 1 then
        actor:set_quest_var("school", "score", "complete")
        actor:command("score")
        wait(0.2)
        actor:send(tostring(self.name) .. " tells you, 'Yep, just like that.  That great big bar at the")
        actor:send("</>bottom is your experience bar.  That will fill as you kill stuff.  When it")
        actor:send("</>reaches full, you'll be ready to level!'")
        wait(2)
        actor:send(tostring(self.name) .. " tells you, 'Are you ready to continue?")
        actor:send("You can <b:green>say yes</> or <b:green>say no</>.'")
    end
end
_return_value = true
return _return_value$trig$, '2e77cbcdd69c79369832115831a3ede2'),
  -- data/triggers/519/519_25_academy_clerk_command_toggle.lua
  (519, 25, $trig$-- Converted from DG Script #51925: academy_clerk_command_toggle
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: toggle
if not (cmd == "toggle") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
if (actor:get_quest_var("school:fight") or 0) == 3 and string.find(arg, "autosplit") then
    actor:set_quest_var("school", "fight", 4)
    actor:command("toggle autosplit")
    wait(0.2)
    actor:send(self.name .. " tells you, '" .. "Grand." .. "'")
    actor:send(self.name .. " tells you, '" .. "You're ready to continue." .. "'")
    wait(1)
    self:command("eye " .. tostring(actor))
    wait(1)
    actor:send(tostring(self.name) .. " considers your capabilities...")
    wait(3)
    actor:send(self.name .. " tells you, '" .. "Hmmmm..." .. "'")
    wait(2)
    -- switch on actor.class
    do
        local _sw1 = string.lower(tostring(actor.class or ""))
        if _sw1 == "rogue" or _sw1 == "thief" or _sw1 == "assassin" or _sw1 == "mercenary" or _sw1 == "bard" then
            actor:send(self.name .. " tells you, '" .. "I see you're a stealthy type." .. "'")
            actor:send(self.name .. " tells you, '" .. "You'll do best in lessons with Doctor Mischief." .. "'")
            actor:send(self.name .. " tells you, '" .. "Proceed down to her classroom." .. "'")
        elseif _sw1 == "sorcerer" or _sw1 == "cryomancer" or _sw1 == "pyromancer" or _sw1 == "necromancer" or _sw1 == "illusionist" then
            actor:send(self.name .. " tells you, '" .. "I see you're an arcane spell caster." .. "'")
            actor:send(self.name .. " tells you, '" .. "You would definitely benefit from" .. "'")
            actor:send(self.name .. " tells you, '" .. "The Chair of Arcane Studies' seminar on spellcasting." .. "'")
            actor:send(self.name .. " tells you, '" .. "Proceed south to his laboratory." .. "'")
        elseif _sw1 == "cleric" or _sw1 == "priest" or _sw1 == "diabolist" or _sw1 == "druid" then
            actor:send(self.name .. " tells you, '" .. "I see you're a divine spell caster." .. "'")
            actor:send(self.name .. " tells you, '" .. "You would definitely benefit from" .. "'")
            actor:send(self.name .. " tells you, '" .. "Private classes with the Professor of Divinity." .. "'")
            actor:send(self.name .. " tells you, '" .. "Proceed east to his chapel." .. "'")
        else
            actor:send(self.name .. " tells you, '" .. "I see you're a fighter type." .. "'")
            actor:send(self.name .. " tells you, '" .. "You'll do best learning from the Academy's Warmaster." .. "'")
            actor:send(self.name .. " tells you, '" .. "Proceed north to her arena." .. "'")
        end
    end
else
    _return_value = true
end
return _return_value$trig$, '13277e464e3e73d5d7d829f5d148969c'),
  -- data/triggers/519/519_28_academy_rogue_command_hide.lua
  (519, 28, $trig$-- Converted from DG Script #51928: academy_rogue_command_hide
-- Original: MOB trigger, flags: COMMAND, probability: 100%

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
if (actor:get_quest_var("school:fight") or 0) == 1 then
    actor:set_quest_var("school", "fight", 2)
    actor:command("hide")
    wait(0.2)
    actor:send(tostring(self.name) .. " tells you, 'Excellent job!'")
    wait(2)
    self.room:spawn_mobile(519, 0)
    self.room:send(tostring(self.name) .. " summons a horrible little monster!")
    wait(2)
    actor:send(tostring(self.name) .. " tells you, 'Killing creatures is how you gain experience.")
    actor:send("Gaining experience is how you advance in level.")
    actor:send("Player killing is generally not allowed in FieryMUD.'")
    actor:send("</>")
    actor:send(tostring(self.name) .. " tells you, 'Before you leap out of the shadows, take a moment to size up this creature.")
    actor:send("Use the <b:cyan>(CO)NSIDER</> command to see what your chances are against it.")
    actor:send("Bare in mind FieryMUD is made for groups of 4-8, so the results of <b:cyan>CONSIDER</> aren't perfect.'")
    wait(3)
    actor:send(tostring(self.name) .. " tells you, 'Type <b:green>consider monster</> and see what happens.'")
end
_return_value = true
return _return_value$trig$, 'a4a254bac02947bf4fc69b0371e0e482'),
  -- data/triggers/519/519_29_academy_rogue_command_consider.lua
  (519, 29, $trig$-- Converted from DG Script #51929: academy_rogue_command_consider
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: consider
if not (cmd == "consider") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
-- switch on cmd
do
    local _sw1 = string.lower(tostring(cmd or ""))
    if _sw1 == "c" then
        _return_value = true
        return _return_value
    end
end
if (actor:get_quest_var("school:fight") or 0) == 2 then
    actor:set_quest_var("school", "fight", "last")
    actor:command("consider " .. tostring(arg))
    wait(0.2)
    actor:send(tostring(self.name) .. " tells you, 'To attack a creature use the <b:cyan>(KIL)L</> command.")
    actor:send("But as a rogue, you have a special opening attack!'")
    wait(3)
    actor:send(tostring(self.name) .. " tells you, 'The <b:cyan>(B)ACKSTAB</> command has a chance to do extreme damage.'")
    -- (empty send to actor)
    actor:send(tostring(self.name) .. " tells you, 'Type <b:green>backstab monster</> to start fighting.")
    -- (empty send to actor)
    actor:send("You can always use the <b:cyan>(FL)EE</> command to try to run away.")
    actor:send("It's a good idea to <b:cyan>FLEE</> if you start to run low on hit points.")
    actor:send("But if you try to flee and fail, you'll be stunned for a little bit.")
    actor:send("So don't wait until the last second to run!'</>")
    wait(3)
    actor:send(tostring(self.name) .. " tells you, 'When you've killed the monster, I'll teach you about <b:yellow>LOOT</> and <b:yellow>TOGGLES</>.'")
    actor:send("<b:green>Say loot</> when you're ready to continue.'")
end
_return_value = true
return _return_value$trig$, '8d9673aaaccf3c6ef01f941531cee96f'),
  -- data/triggers/519/519_32_academy_warrior_command_skill.lua
  (519, 32, $trig$-- Converted from DG Script #51932: academy_warrior_command_skill
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: skills
if not (cmd == "skills") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
-- switch on cmd
do
    local _sw1 = string.lower(tostring(cmd or ""))
    if _sw1 == "s" then
        _return_value = true
        return _return_value
    end
end
if (actor:get_quest_var("school:fight") or 0) == 1 then
    actor:set_quest_var("school", "fight", 2)
    actor:command("skill")
    wait(0.2)
    actor:send(tostring(self.name) .. " tells you, 'Unlike many MUDs you will not need to train or practice your skills with a trainer or Guild Master.")
    actor:send("Skills will improve gradually as you use them.")
    actor:send("The meter next to the skill name shows you two things:")
    actor:send("<b:cyan>1. How close you are to maximum skill for your level, indicated by the \"=\" sign</>")
    actor:send("<b:cyan>2. How close you are to overall maximum skill for your class and race, indicated by the \"*\" sign.</>")
    actor:send("</>")
    actor:send("One of your most basic skills is <b:cyan>KICK</>.")
    actor:send("It's an extra attack that delivers some bonus damage.")
    actor:send("There is a short stun after you <b:cyan>KICK</>.")
    actor:send("So be very, very careful about spamming the skill.")
    actor:send("</>")
    actor:send("You probably won't land a kick for many levels, but keep trying.")
    actor:send("Practice makes perfect.'")
    wait(3)
    actor:send(tostring(self.name) .. " tells you, 'Give it a try!")
    actor:send("Type <b:green>kick monster</>.'")
end
_return_value = true
return _return_value$trig$, 'f57ea64e7737d9bd617116f1707d1a4e'),
  -- data/triggers/519/519_33_academy_warrior_command_kick.lua
  (519, 33, $trig$-- Converted from DG Script #51933: academy_warrior_command_kick
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: kick
if not (cmd == "kick") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
if (actor:get_quest_var("school:fight") or 0) == 2 then
    actor:set_quest_var("school", "fight", 3)
    actor:command("kick " .. tostring(arg))
    wait(0.2)
    world.destroy(self.room:find_actor("monster"))
    self.room:send(tostring(self.name) .. " rushes in to break up the fight!")
    wait(0.1)
    self.room:spawn_mobile(519, 0)
    wait(0.3)
    actor:send(tostring(self.name) .. " tells you, 'Excellent job!")
    actor:send("You're ready to try out your other important skill, <b:cyan>BASH</>.'")
    wait(2)
    actor:send(tostring(self.name) .. " takes a wooden shield off a rack.")
    self.room:spawn_object(11, 50)
    self:command("give shield " .. tostring(actor))
    wait(2)
    actor:send(tostring(self.name) .. " tells you, 'Equip that with <b:green>wear shield</>.'")
end
_return_value = true
return _return_value$trig$, '1e593dec58d6d71e945d116c039e6537'),
  -- data/triggers/519/519_34_academy_shield_wear.lua
  (519, 34, $trig$-- Converted from DG Script #51934: academy_shield_wear
-- Original: OBJECT trigger, flags: WEAR, probability: 100%
if (actor:get_quest_var("school:fight") or 0) == 3 then
    actor:set_quest_var("school", "fight", 4)
    wait(0.2)
    actor:send(tostring(mobiles.template(519, 4).name) .. " tells you, '<b:cyan>(BAS)H</> deals some damage, but more importantly it <b:red>knocks your opponent down</>.")
    actor:send("That <b:red>prevents your opponent from attacking you</> and <b:red>stops spellcasters from casting spells</>.")
    actor:send("</>")
    actor:send("Bashing is a complex maneuver.")
    actor:send("First, you must be wearing a shield.")
    actor:send("Second, you have to be similar sizes.")
    actor:send("Anything too big and you'll bounce off.")
    actor:send("Anything too small and you'll miss.")
    actor:send("</>")
    actor:send("There's another big risk to using <b:cyan>BASH</>.")
    actor:send("If you miss, which is very likely when you're starting out, <b:red>you will be unable to fight back until you stand up.</>")
    actor:send("</>")
    actor:send("Like most combat skills, there is a brief stun after using it.")
    actor:send("So spamming it can trap you in a very deadly situation.'")
    wait(2)
    if world.count_mobiles(519, 0) == 0 then
        self.room:spawn_mobile(519, 0)
        self.room:send(tostring(mobiles.template(519, 4).name) .. " summons a horrible little monster!")
        wait(1)
    end
    actor:send(tostring(mobiles.template(519, 4).name) .. " tells you, 'I want you to practice bashing now.")
    actor:send("Type <b:green>bash monster</>.  Don't worry, I'm here to protect you.'</>")
end$trig$, 'cdb30c4975ced69a387f3f100690708b'),
  -- data/triggers/519/519_35_academy_warrior_command_bash.lua
  (519, 35, $trig$-- Converted from DG Script #51935: academy_warrior_command_bash
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: bash
if not (cmd == "bash") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
-- switch on cmd
do
    local _sw1 = string.lower(tostring(cmd or ""))
    if _sw1 == "b" or _sw1 == "ba" then
        _return_value = true
        return _return_value
    end
end
if (actor:get_quest_var("school:fight") or 0) == 4 then
    actor:set_quest_var("school", "fight", "last")
    actor:command("bash " .. tostring(arg))
    wait(0.2)
    world.destroy(self.room:find_actor("monster"))
    wait(0.2)
    self.room:send(tostring(self.name) .. " breaks up the fight.")
    actor:send(tostring(self.name) .. " tells you, 'Good attempt!'")
    self.room:spawn_mobile(519, 0)
    wait(2)
    actor:send(tostring(self.name) .. " tells you, 'To attack a creature use the <b:cyan>(KIL)L</> command.")
    actor:send("</>")
    actor:send("You have to be standing to fight though and you probably fell down after trying to bash.")
    actor:send("Type <b:cyan>(ST)AND</> to get back up.")
    actor:send("Then type <b:green>kill monster</> to start fighting.")
    self:command("point monster")
    actor:send("</>")
    actor:send("You can always use the <b:cyan>(FL)EE</> command to try to run away.")
    actor:send("It's a good idea to <b:cyan>FLEE</> if you start to run low on hit points.")
    actor:send("If you try to flee and fail, you'll be stunned for a little bit.")
    actor:send("So don't wait until the last second to run!")
    actor:send("</>")
    actor:send("Feel free to use any of the skills you've learned to kill this monster.")
    actor:send("Be careful not to get locked by skill stun though!'")
    wait(2)
    actor:send(tostring(self.name) .. " tells you, 'When you've killed the monster, I'll teach you about <b:yellow>LOOT</> and <b:yellow>TOGGLES</>.'")
    actor:send("<b:green>Say loot</> when you're ready to continue.'")
end
_return_value = true
return _return_value$trig$, 'eba2e54cf022b438098111b7f74db7b7'),
  -- data/triggers/519/519_38_academy_cleric_command_spell.lua
  (519, 38, $trig$-- Converted from DG Script #51938: academy_cleric_command_spell
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: spells
if not (cmd == "spells") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
-- switch on cmd
do
    local _sw1 = string.lower(tostring(cmd or ""))
    if _sw1 == "s" or _sw1 == "sp" then
        _return_value = true
        return _return_value
    end
end
if (actor:get_quest_var("school:fight") or 0) == 1 then
    actor:set_quest_var("school", "fight", 2)
    actor:command("spell")
    wait(0.2)
    actor:send(tostring(self.name) .. " tells you, 'Spells are divided up by Circle.")
    actor:send("For now, you only have access to Circle 1 spells.")
    actor:send("You gain access to a new Circle every 8 levels.")
    actor:send("You can find out what a spell does by checking the <b:cyan>HELP</> file.")
    actor:send("</>")
    actor:send("Unlike many other MUDs, FieryMUD does not use a mana system.")
    actor:send("You can cast any spell from your list as long as you have available <b:cyan>SPELL SLOTS</> of the same level or higher.")
    actor:send("</>")
    actor:send("At level 1, you have only one Circle 1 spell slot.")
    actor:send("You can use that spell slot to <b:cyan>CAST</> any Circle 1 spell.")
    actor:send("You gain more spells slots as you increase in level.")
    actor:send("</>")
    actor:send("When you <b:cyan>CAST</> a spell, if you don't have any spell slots of the spell's Circle, you will automatically use a spell slot of the next highest Circle, if any.")
    actor:send("When you run out of higher Circle spell slots, the spell will fail to cast.")
    actor:send("If you use a higher Circle spell slot, there is no additional benefit or bonus to the spell cast.")
    actor:send("You cannot stop spells from using higher Circle slots or specify what Circle slot to consume.")
    actor:send("So be careful with your spell management!")
    actor:send("</>")
    actor:send("The syntax to cast is <b:cyan>(c)ast '[spell]' [target]</>.")
    actor:send("</>")
    actor:send("FieryMUD will try to match <b:cyan>abbreviations of spell names and targets.</>")
    actor:send("If a spell name has more than one word, you <b:cyan>must</> put single quotation marks <b:cyan>' '</> around the spell name.")
    actor:send("</>")
    actor:send("Spellcasting is not instaneous either.")
    actor:send("Each spell has a base length to cast.")
    actor:send("The <b:cyan>QUICK CHANT</> skill will help reduce casting time.'")
    wait(3)
    actor:send(tostring(self.name) .. " tells you, '<b:cyan>CAST</> the Cure Light spell, your most basic healing spell, on me.")
    actor:send("</>Type <b:green>cast 'cure light' professor</>.'")
end
_return_value = true
return _return_value$trig$, '3628265ea30e35af8f1bef0a2b7ea2ea'),
  -- data/triggers/519/519_39_academy_cleric_cast_cure_light.lua
  (519, 39, $trig$-- Converted from DG Script #51939: academy_cleric_cast_cure_light
-- Original: MOB trigger, flags: CAST, probability: 100%
local _return_value = true  -- Default: allow action
if (actor:get_quest_var("school:fight") or 0) == 2 and spell == "cure light" then
    actor:set_quest_var("school", "fight", 3)
    wait(0.2)
    actor:send(tostring(self.name) .. " tells you, 'You're a natural healer!'")
    wait(2)
    actor:send(tostring(self.name) .. " tells you, 'Once you cast a spell, the spell slot it used will automatically begin to <b:cyan>RECOVER</>.")
    actor:send("The amount of time a spell slot takes to recover depends on the Circle of spell slot, your <b:cyan>FOCUS</> score, and whether or not you <b:cyan>MEDITATE</>.")
    actor:send("Spell slots recover <b:yellow>in the order they were used</>.")
    actor:send("</>")
    actor:send("<b:cyan>FOCUS</> is a bonus gained from equipment and your Intelligence and Wisdom stats.")
    actor:send("You can see your <b:cyan>FOCUS</> score using the <b:cyan>SCORE</> command.")
    actor:send("</>")
    actor:send("You can use the <b:cyan>(STU)DY</> command to see all the information about your spell slots, including:")
    actor:send("<b:magenta>1. How many spell slots you have")
    actor:send("2. Which spell slots you've used")
    actor:send("3. How long each slot will take to recover</>")
    actor:send("</>")
    actor:send("Check your current recovery status by typing <b:green>study</> now.'")
end
_return_value = true
return _return_value$trig$, '8256df56efef43a393f89f5ea163e7bd'),
  -- data/triggers/519/519_40_academy_cleric_command_study.lua
  (519, 40, $trig$-- Converted from DG Script #51940: academy_cleric_command_study
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: study
if not (cmd == "study") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
-- switch on cmd
do
    local _sw1 = string.lower(tostring(cmd or ""))
    if _sw1 == "s" or _sw1 == "st" then
        _return_value = true
        return _return_value
    end
end
if (actor:get_quest_var("school:fight") or 0) == 3 then
    actor:set_quest_var("school", "fight", 4)
    actor:command("study")
    wait(0.2)
    actor:send(tostring(self.name) .. " tells you, 'Spell slots will recover significantly faster if you <b:cyan>(MED)ITATE</>.")
    actor:send("I'll walk you through that process now.")
    actor:send("First, get comfortable.")
    actor:send("Type <b:green>rest</> to take a seat and settle down.'")
end
_return_value = true
return _return_value$trig$, '3513fc7547c4e459cb82d52c775c6989'),
  -- data/triggers/519/519_41_academy_cleric_command_rest.lua
  (519, 41, $trig$-- Converted from DG Script #51941: academy_cleric_command_rest
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: rest
if not (cmd == "rest") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
if (actor:get_quest_var("school:fight") or 0) == 4 then
    actor:set_quest_var("school", "fight", 5)
    actor:command("rest")
    wait(0.2)
    actor:send(tostring(self.name) .. " tells you, 'Next, you should <b:cyan>(MED)ITATE</> to get into the proper state of mind.")
    actor:send("As it goes up, the <b:cyan>MEDITATE</> skill increases your <b:cyan>FOCUS</> score when you <b:cyan>MEDITATE</>.")
    actor:send("You can <b:cyan>MEDITATE</> as long as you're not in combat.'")
    wait(2)
    actor:send(tostring(self.name) .. " tells you, 'Type <b:green>meditate</> to start.'")
end
_return_value = true
return _return_value$trig$, 'ae4b7a8c609b898a4c88d8e4378ea527'),
  -- data/triggers/519/519_42_academy_cleric_command_meditate.lua
  (519, 42, $trig$-- Converted from DG Script #51942: academy_cleric_command_meditate
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: meditate
if not (cmd == "meditate") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
-- switch on cmd
do
    local _sw1 = string.lower(tostring(cmd or ""))
    if _sw1 == "m" or _sw1 == "me" then
        _return_value = true
        return _return_value
    end
end
if (actor:get_quest_var("school:fight") or 0) == 5 then
    actor:set_quest_var("school", "fight", 6)
    actor:command("meditate")
    wait(0.2)
    actor:send(tostring(self.name) .. " tells you, 'It will take a while to finish recovering your spell slots.")
    actor:send("You will receive a notification each time you recover a spell slot and when you recover them all.'")
    wait(2)
    actor:send(tostring(self.name) .. " tells you, 'You do not gain a bonus to <b:cyan>FOCUS</> when sleeping or just resting.")
    actor:send("If you <b:cyan>(ST)AND</> or <b:cyan>(SL)EEP</> you'll immediately stop meditating.")
    actor:send("Don't worry, your spell slots will still recover at their normal rate.'")
    wait(3)
    actor:send(tostring(self.name) .. " tells you, 'When you're done, type <b:green>stand</> so I know you're ready to continue.'")
end
_return_value = true
return _return_value$trig$, '44d657ba789c5aa3beb2e28879a11667'),
  -- data/triggers/519/519_43_academy_cleric_command_stand.lua
  (519, 43, $trig$-- Converted from DG Script #51943: academy_cleric_command_stand
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: stand
if not (cmd == "stand") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
-- switch on cmd
do
    local _sw1 = string.lower(tostring(cmd or ""))
    if _sw1 == "s" then
        _return_value = true
        return _return_value
    end
end
if (actor:get_quest_var("school:fight") or 0) == 6 then
    actor:set_quest_var("school", "fight", 7)
    actor:command("stand")
    wait(0.2)
    self.room:spawn_mobile(519, 0)
    self.room:send(tostring(self.name) .. " summons a horrible little monster!")
    wait(2)
    actor:send(tostring(self.name) .. " tells you, 'Killing creatures like this is how you gain experience.")
    actor:send("Gaining experience is how you go up in level.")
    actor:send("Player killing is generally not allowed in FieryMUD.")
    actor:send("This includes casting offensive spells at other players.")
    actor:send("</>")
    actor:send("</>Before you strike, take a moment to size up your opponent.")
    actor:send("Use the <b:cyan>(CO)NSIDER</> command to see what your chances are.")
    actor:send("Keep in mind FieryMUD is made for groups of 4-8, so the results of <b:cyan>CONSIDER</> aren't perfect")
    actor:send("Also keep in mind most of a cleric's strength is support.")
    actor:send("It will be harder for you to kill creatures alone.'")
    wait(2)
    actor:send(tostring(self.name) .. " tells you, 'Type <b:green>consider monster</> for see chances.'")
end
_return_value = true
return _return_value$trig$, '01e692597963f15041b8dad7b58ad3d9'),
  -- data/triggers/519/519_44_academy_cleric_command_consider.lua
  (519, 44, $trig$-- Converted from DG Script #51944: academy_cleric_command_consider
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: consider
if not (cmd == "consider") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
local thing = "horrible-little-monster"
-- switch on cmd
do
    local _sw1 = string.lower(tostring(cmd or ""))
    if _sw1 == "c" then
        _return_value = true
        return _return_value
    end
end
if (actor:get_quest_var("school:fight") or 0) == 7 then
    actor:set_quest_var("school", "fight", "last")
    actor:command("con " .. tostring(arg))
    wait(0.2)
    actor:send(tostring(self.name) .. " tells you, 'Very good.'")
    wait(2)
    actor:send(tostring(self.name) .. " tells you, 'To attack a creature, use the <b:cyan>(KIL)L</> command. Type <b:green>kill monster</> to start fighting.")
    actor:send("</>")
    actor:send("Feel free to use any of the skills you've learned.")
    actor:send("</>")
    actor:send("You can always use the <b:cyan>(FL)EE</> command to try to run away.")
    actor:send("It's a good idea if you start to run low on hit points.")
    actor:send("If you try to flee and fail, you'll be stunned for a little bit.")
    actor:send("You cannot flee while casting a spell either!")
    actor:send("So don't wait until the last second to run!'")
    wait(2)
    actor:send(tostring(self.name) .. " tells you, 'When you've killed the monster, I'll teach you about <b:yellow>LOOT</> and <b:yellow>TOGGLES</>.'")
    actor:send("<b:green>Say loot</> when you're ready to continue.'")
end
_return_value = true
return _return_value$trig$, 'a0431f76c1abe7363fcf0ffbf836308e'),
  -- data/triggers/519/519_47_academy_sorcerer_command_rest.lua
  (519, 47, $trig$-- Converted from DG Script #51947: academy_sorcerer_command_rest
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: rest
if not (cmd == "rest") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
if (actor:get_quest_var("school:fight") or 0) == 1 then
    actor:set_quest_var("school", "fight", 2)
    actor:command("rest")
    wait(0.2)
    actor:send(tostring(self.name) .. " tells you, 'As a sorcerer, you need to <b:cyan>SCRIBE</> spells in your spellbook.")
    actor:send("<b:cyan>(SPE)LL</> will show you all the spells you can <b:cyan>SCRIBE</>.")
    actor:send("You must <b:cyan>HOLD</> a <b:yellow>SPELLBOOK</> with blank pages and a <b:yellow>PEN</> of some kind to scribe.")
    if not actor:has_equipped(10, 29) and not actor:has_item(10, 29) and not actor:has_equipped(11, 54) and not actor:has_item(11, 54) then
        actor:send("Looks like you need a book and pen!")
        self.room:spawn_object(11, 54)
        self.room:spawn_object(10, 29)
        self:command("give book " .. tostring(actor))
        self:command("give pen " .. tostring(actor))
    else
        actor:send("All new sorcerers start with an empty book and quill.")
    end
    actor:send("</>")
    actor:send("Once you leave the Academy, you many only <b:cyan>SCRIBE</> spells in the presence of your <b:yellow>Guild Master</>.'")
    wait(2)
    actor:send(tostring(self.name) .. " tells you, 'Check your spell list by typing <b:green>spell</>.'")
elseif (actor:get_quest_var("school:fight") or 0) == 10 then
    actor:set_quest_var("school", "fight", 11)
    actor:command("rest")
    wait(0.2)
    actor:send(tostring(self.name) .. " tells you, 'Next, you should <b:cyan>(MED)ITATE</> to get into the proper state of mind.")
    actor:send("As it goes up, the <b:cyan>MEDITATE</> skill increases your <b:cyan>FOCUS</> score when you <b:cyan>MEDITATE</>.")
    actor:send("You can <b:cyan>MEDITATE</> as long as you're not in combat.'")
    wait(2)
    actor:send(tostring(self.name) .. " tells you, 'Type <b:green>meditate</> to start.'")
end
_return_value = true
return _return_value$trig$, '66bb8d406ff702c8296661d14621c1fc'),
  -- data/triggers/519/519_48_academy_sorcerer_command_spell.lua
  (519, 48, $trig$-- Converted from DG Script #51948: academy_sorcerer_command_spell
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: spells
if not (cmd == "spells") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
-- switch on cmd
do
    local _sw1 = string.lower(tostring(cmd or ""))
    if _sw1 == "s" or _sw1 == "sp" then
        _return_value = true
        return _return_value
    end
end
if (actor:get_quest_var("school:fight") or 0) == 2 then
    actor:set_quest_var("school", "fight", 3)
    actor:command("spells")
    wait(0.2)
    actor:send(tostring(self.name) .. " tells you, 'Spells are divided up by Circle.")
    actor:send("For now you only have access to Circle 1 spells.")
    actor:send("You gain access to a new Circle every 8 levels.")
    actor:send("You can find out what any spell does by consulting the <b:cyan>HELP</> file.")
    actor:send("</>")
    actor:send("For now, you're going to learn <b:yellow>magic missile</>.")
    actor:send("</>")
    actor:send("<b:cyan>(REM)OVE</> anything in your hands.")
    actor:send("Then <b:cyan>(H)OLD</> your spellbook.'")
    wait(2)
    if actor:get_worn("wield") then
        actor:send(tostring(self.name) .. " tells you, 'You need to <b:green>remove</> the weapon in your hands.'")
    end
    if actor:get_worn("hold") then
        actor:send(tostring(self.name) .. " tells you, 'You need to <b:green>remove</> the item in your hands.'")
    end
    if actor:get_worn("hold2") then
        actor:send(tostring(self.name) .. " tells you, 'You need to <b:green>remove</> the item in your hands.'")
    end
    if actor:get_worn("2hwield") then
        actor:send(tostring(self.name) .. " tells you, 'You need to <b:green>remove</> the item in your hands.'")
    end
    actor:send("</>")
    if not actor:has_equipped(10, 29) and not actor:has_item(10, 29) then
        actor:send(tostring(self.name) .. " tells you, 'Looks like you need a new book too.'")
        self.room:spawn_object(10, 29)
        self:command("give book " .. tostring(actor))
        actor:send("</>")
    end
    actor:send(tostring(self.name) .. " tells you, 'Type <b:green>hold spellbook</> to grab your book.'")
end
_return_value = true
return _return_value$trig$, 'c7b1723236b4213cf58bda8dad12cb33'),
  -- data/triggers/519/519_49_academy_wear_spellbook.lua
  (519, 49, $trig$-- Converted from DG Script #51949: academy_wear_spellbook
-- Original: OBJECT trigger, flags: WEAR, probability: 100%
if (actor:get_quest_var("school:fight") or 0) == 3 then
    actor:set_quest_var("school", "fight", 4)
    wait(0.2)
    actor:send(tostring(mobiles.template(519, 6).name) .. " tells you, 'Next, <b:cyan>(H)OLD</> your quill.")
    if not actor:has_equipped(11, 54) and not actor:has_item(11, 54) then
        actor:send("Looks like you need a new one.'")
        self.room:find_actor("chair"):spawn_object(11, 54)
        self.room:find_actor("chair"):command("give pen " .. tostring(actor))
    else
        actor:send("You started with one.'")
    end
    wait(1)
    actor:send("</>Type <b:cyan>hold quill</> to grab your quill.'")
end$trig$, '8df03ea0c9062648098fb4f9c123d593'),
  -- data/triggers/519/519_50_academy_sorcerer_command_scribe.lua
  (519, 50, $trig$-- Converted from DG Script #51950: academy_sorcerer_command_scribe
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: scribe
if not (cmd == "scribe") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
-- switch on cmd
do
    local _sw1 = string.lower(tostring(cmd or ""))
    if _sw1 == "s" or _sw1 == "sc" then
        _return_value = true
        return _return_value
    end
end
-- switch on arg
do
    local _sw2 = string.lower(tostring(arg or ""))
    if _sw2 == "magic m" or _sw2 == "magic mi" or _sw2 == "magic mis" or _sw2 == "magic miss" or _sw2 == "magic missi" or _sw2 == "magic missil" or _sw2 == "magic missile" then
        if (actor:get_quest_var("school:fight") or 0) == 5 then
            actor:set_quest_var("school", "fight", 6)
            actor:command("scribe magic missile")
            wait(0.2)
            actor:send(tostring(self.name) .. " tells you, 'This will take some time.")
            actor:send("When you're done writing, <b:green>stand</> so I know you're ready to continue.'")
        end
    end
end
_return_value = true
return _return_value$trig$, '84dcd6c3749fcb3652f30201a3eacf81'),
  -- data/triggers/519/519_51_academy_sorcerer_command_stand.lua
  (519, 51, $trig$-- Converted from DG Script #51951: academy_sorcerer_command_stand
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: stand
if not (cmd == "stand") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
-- switch on cmd
do
    local _sw1 = string.lower(tostring(cmd or ""))
    if _sw1 == "s" then
        _return_value = true
        return _return_value
    end
end
if (actor:get_quest_var("school:fight") or 0) == 6 then
    actor:set_quest_var("school", "fight", 7)
    actor:command("stand")
    wait(0.2)
    actor:send(tostring(self.name) .. " tells you, 'With the spell scribed you can <b:cyan>CAST</> it.")
    actor:send("Unlike many other MUDs, <red>FieryMUD does not use mana.</>")
    actor:send("You can cast any spell from your list as long as you have available <b:cyan>SPELL SLOTS</> of the same level or higher.")
    actor:send("</>")
    actor:send("At level 1, you have only one Circle 1 spell slot.")
    actor:send("You can use that spell slot to <b:cyan>CAST</> any Circle 1 spell.")
    actor:send("You gain more spells slots as you increase in level.'")
    wait(2)
    self.room:spawn_mobile(519, 0)
    self.room:send(tostring(self.name) .. " summons a horrible little monster!")
    wait(1)
    actor:send(tostring(self.name) .. " tells you, 'Killing creatures like this is how you gain experience.")
    actor:send("Gaining experience is how you go up in level.")
    actor:send("Player killing is generally not allowed in FieryMUD.")
    actor:send("This includes casting offensive spells at other players.")
    actor:send("</>")
    actor:send("</>Before you strike, take a moment to size up your opponent.")
    actor:send("Use the <b:cyan>(CO)NSIDER</> command to see what your chances are.")
    actor:send("Keep in mind FieryMUD is made for groups of 4-8, so the results of <b:cyan>CONSIDER</> aren't perfect")
    actor:send("</>")
    actor:send(tostring(self.name) .. " tells you, 'Type <b:green>consider monster</> for see chances.'")
elseif (actor:get_quest_var("school:fight") or 0) == 12 then
    actor:set_quest_var("school", "fight", "complete")
    actor:advance_quest("school")
    actor:command("stand")
    wait(0.2)
    actor:send(tostring(self.name) .. " tells you, 'Next I'll teach you about <b:yellow>LOOT</> and <b:yellow>TOGGLES</>.'")
    actor:send("<b:green>Say loot</> when you're ready to continue.'")
end
_return_value = true
return _return_value$trig$, '413f191854c247a844daad11e168ab27'),
  -- data/triggers/519/519_52_academy_sorcerer_command_consider.lua
  (519, 52, $trig$-- Converted from DG Script #51952: academy_sorcerer_command_consider
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: consider
if not (cmd == "consider") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
-- switch on cmd
do
    local _sw1 = string.lower(tostring(cmd or ""))
    if _sw1 == "c" then
        _return_value = true
        return _return_value
    end
end
local thing = "horrible-little-monster"
if (actor:get_quest_var("school:fight") or 0) == 7 then
    actor:set_quest_var("school", "fight", 8)
    actor:command("consider " .. tostring(arg))
    wait(0.2)
    actor:send(tostring(self.name) .. " tells you, 'Very good.'")
    wait(2)
    actor:send(tostring(self.name) .. " tells you, 'Typically combat starts with the command:")
    actor:send("<b:cyan>(KIL)L [target]</>'")
    wait(1)
    actor:send(tostring(self.name) .. " tells you, 'As a sorcerer however, your strength comes from your magic.")
    actor:send("It's often best to start combat with an offensive spell.")
    actor:send("If you're lucky, you'll kill your opponent out-right.'")
    wait(2)
    actor:send(tostring(self.name) .. " tells you, 'To <b:cyan>CAST</> type <b:cyan>(c)ast '[spell]' [target]</>.")
    actor:send("</>")
    actor:send("</>FieryMUD will try to match <b:cyan>abbreviations of spell names and targets.</>")
    actor:send("If a spell name has more than one word you <b:cyan>must</> put single quotation marks <b:cyan>' '</> around it.")
    actor:send("</>")
    actor:send("</>Spellcasting is not instaneous either.")
    actor:send("Each spell has a base length to cast.")
    actor:send("Your proficiency in <b:cyan>QUICK CHANT</> will reduce casting time.'")
    wait(2)
    self:command("point monster")
    actor:send("</>")
    actor:send(tostring(self.name) .. " tells you, '<b:cyan>CAST</> your spell at that monster.")
    actor:send("Type <b:green>cast 'magic missile' monster</>.'")
    actor:send("</>")
    actor:send(tostring(self.name) .. " tells you, 'You can always use the <b:cyan>(FL)EE</> command to try to run away.")
    actor:send("It's a good idea to <b:cyan>FLEE</> if you start to run low on hit points.")
    actor:send("If you try to flee and fail, you'll be stunned for a little bit.")
    actor:send("You also cannot flee while casting a spell! Don't wait until the last second to run!'")
    wait(3)
    actor:send(tostring(self.name) .. " tells you, 'When you've killed the monster, <b:green>say recovery</> I'll teach you about <b:yellow>SPELL RECOVERY</>.'")
end
_return_value = true
return _return_value$trig$, '33613a1e77d023dee99b67535f5ea388'),
  -- data/triggers/519/519_53_academy_sorcerer_speech_recovery.lua
  (519, 53, $trig$-- Converted from DG Script #51953: academy_sorcerer_speech_recovery
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"recovery"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
local _return_value = true  -- Default: allow action
wait(0.2)
if (actor:get_quest_var("school:fight") or 0) == 8 then
    actor:set_quest_var("school", "fight", 9)
    actor:send(tostring(self.name) .. " tells you, 'Once you cast a spell, the spell slot it used will automatically begin to <b:cyan>RECOVER</>.")
    actor:send("The amount of time a spell slot takes to recover depends on the Circle of spell slot, your <b:cyan>FOCUS</> score, and whether or not you <b:cyan>MEDITATE</>.")
    actor:send("Spell slots recover <b:yellow>in the order they were used</>.")
    actor:send("</>")
    actor:send("<b:cyan>FOCUS</> is a bonus gained from equipment and your Intelligence and Wisdom stats.")
    actor:send("You can see your <b:cyan>FOCUS</> score using the <b:cyan>SCORE</> command.")
    actor:send("</>")
    actor:send("You can use the <b:cyan>(STU)DY</> command to see all the information about your spell slots, including:")
    actor:send("<b:magenta>1. How many spell slots you have")
    actor:send("2. Which spell slots you've used")
    actor:send("3. How long each slot will take to recover</>")
    actor:send("</>")
    actor:send("Check your current recovery status by typing <b:green>study</> now.'")
end
_return_value = true
return _return_value$trig$, 'b1cdd08c9c660e2673a85f8a818423e8'),
  -- data/triggers/519/519_54_academy_sorcerer_command_study.lua
  (519, 54, $trig$-- Converted from DG Script #51954: academy_sorcerer_command_study
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: study
if not (cmd == "study") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
-- switch on cmd
do
    local _sw1 = string.lower(tostring(cmd or ""))
    if _sw1 == "s" or _sw1 == "st" then
        _return_value = true
        return _return_value
    end
end
if (actor:get_quest_var("school:fight") or 0) == 9 then
    actor:set_quest_var("school", "fight", 10)
    actor:command("study")
    wait(0.2)
    actor:send(tostring(self.name) .. " tells you, 'Spell slots will recover significantly faster if you <b:cyan>(MED)ITATE</>.")
    actor:send("I'll walk you through that process now.")
    actor:send("First, get comfortable.")
    actor:send("Type <b:green>rest</> to take a seat and settle down.'")
end
_return_value = true
return _return_value$trig$, '90a9ab7ba32293210efc39bcdd94ab73'),
  -- data/triggers/519/519_56_academy_classes_command_get.lua
  (519, 56, $trig$-- Converted from DG Script #51956: academy_classes_command_get
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: get
if not (cmd == "get") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
-- switch on arg
do
    local _sw1 = string.lower(tostring(arg or ""))
    if _sw1 == "all c" or _sw1 == "all co" or _sw1 == "all cor" or _sw1 == "all corp" or _sw1 == "all corps" or _sw1 == "all corpse" then
        if (actor:get_quest_var("school:loot") or 0) == 1 then
            actor:set_quest_var("school", "loot", 2)
            actor:command("get all corpse")
            wait(0.2)
            actor:send(tostring(self.name) .. " tells you, 'And now you have some money!")
            actor:send("Remember, use <b:cyan>SCORE</> to check your money.")
            actor:send("</>")
            actor:send("The other thing I need to show you is the <b:cyan>TOGGLE</> command.")
            actor:send("Typing <b:cyan>TOGGLE</> alone will show you everything you can set.")
            actor:send("<b:cyan>AUTOLOOT</> picks up everything from a corpse instantly.")
            actor:send("<b:cyan>AUTOTREAS</> picks up only \"treasure\" like coins and gems.")
            actor:send("Each toggle has a <b:cyan>HELP</> file with more information.'")
            wait(2)
            actor:send(tostring(self.name) .. " tells you, 'For now, let's get you ready to gather and share loot.")
            actor:send("Type <b:green>toggle autoloot</> to loot future kills!'")
        end
    end
end
_return_value = true
return _return_value$trig$, '3bdb58c340f25b36cd1353322d27e723'),
  -- data/triggers/519/519_57_academy_classes_command_trophy.lua
  (519, 57, $trig$-- Converted from DG Script #51957: academy_classes_command_trophy
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: trophy
if not (cmd == "trophy") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
-- switch on cmd
do
    local _sw1 = string.lower(tostring(cmd or ""))
    if _sw1 == "t" or _sw1 == "tr" then
        _return_value = true
        return _return_value
    end
end
if (actor:get_quest_var("school:loot") or 0) == 4 then
    actor:set_quest_var("school", "loot", "complete")
    actor:advance_quest("school")
    actor:command("trophy")
    wait(0.2)
    actor:send(tostring(self.name) .. " tells you, 'Your most recent kills appear at the top.")
    actor:send("</>")
    actor:send("You earn 1.00 share of each monster you kill solo.")
    actor:send("If you're in a group, that share is evenly divided among all group members present for the kill.")
    actor:send("</>")
    actor:send("At <b:yellow>5.00</>, you earn less experience per kill.")
    actor:send("At <b:red>10.00</>, you earn far less experience per kill.")
    actor:send("</>")
    actor:send("You can clear out your trophy list by killing creatures in a different area.")
    actor:send("Creatures move down the list as you kill new monsters.")
    actor:send("After 24 new monsters, they disappear completely.")
    actor:send("Your trophy list is also cleared when you die.'")
    wait(2)
    actor:send(tostring(self.name) .. " tells you, 'Looks like you're ready for some rest!")
    actor:send("Head <b:green>east</> to the banquet hall.'")
end
_return_value = true
return _return_value$trig$, 'f99336068678b9db35120215a99fffd4'),
  -- data/triggers/519/519_60_academy_revel_command_sleep.lua
  (519, 60, $trig$-- Converted from DG Script #51960: academy_revel_command_sleep
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: sleep
if not (cmd == "sleep") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
-- switch on cmd
do
    local _sw1 = string.lower(tostring(cmd or ""))
    if _sw1 == "s" then
        _return_value = true
        return _return_value
    end
end
if (actor:get_quest_var("school:rest") or 0) == 1 then
    actor:set_quest_var("school", "rest", 2)
    actor:command("sleep")
    wait(0.2)
    actor:send(tostring(self.name) .. " tells you, 'Sweet dreams!'")
    wait(1)
    actor:send(tostring(self.name) .. " tells you, 'Remember, you may want to enter commands every now then to update your display and see how close you are to full health and movement.")
    actor:send("The display won't update on its own.'")
    wait(2)
    actor:send(tostring(self.name) .. " tells you, 'The <b:cyan>WAKE</> command makes you stop sleeping and sit up.")
    actor:send("When you wake up, you'll automatically go to a sitting <b:cyan>REST</> position.'")
    wait(2)
    actor:send(tostring(self.name) .. " tells you, 'So type <b:green>wake</> and get up!'</>")
end
_return_value = true
return _return_value$trig$, 'd3ccde699a729a8386fadef6e990d8c8'),
  -- data/triggers/519/519_61_academy_revel_command_wake.lua
  (519, 61, $trig$-- Converted from DG Script #51961: academy_revel_command_wake
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: wake
if not (cmd == "wake") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
-- switch on cmd
do
    local _sw1 = string.lower(tostring(cmd or ""))
    if _sw1 == "w" then
        _return_value = true
        return _return_value
    end
end
if (actor:get_quest_var("school:rest") or 0) == 2 then
    actor:set_quest_var("school", "rest", 3)
    actor:command("wake")
    wait(0.2)
    actor:send(tostring(self.name) .. " tells you, 'Good morning sunshine!'")
    wait(2)
    actor:send(tostring(self.name) .. " tells you, 'You'll frequently notice yourself getting hungry or thirsty.")
    actor:send("You can speed up your recovery if you <b:cyan>EAT</> and <b:cyan>(DRI)NK</>.")
    actor:send("</>")
    actor:send("When you get thirsty it's time to <b:cyan>DRINK</>!")
    actor:send("Ethilien has a huge variety of drinkable liquids.")
    actor:send("Any of them will slake your thirst.")
    actor:send("The command is <b:cyan>DRINK [container]</>.")
    actor:send("</>")
    actor:send("When you <b:cyan>DRINK</>, you'll also regain some Movement Points, so make sure you carry a full waterskin so you can keep moving when you explore!")
    actor:send("</>")
    actor:send("And remember, magic potions are <red>not</> drinks.")
    actor:send("If you want to consume a potion, the commmand is <b:cyan>(Q)UAFF</>, not <b:cyan>(DRI)NK</>.'")
    wait(2)
    if not actor:has_item(0, 20) and not actor:has_equipped(0, 20) then
        actor:send(tostring(self.name) .. " tells you, 'Here's a new waterskin for you.")
        self.room:spawn_object(0, 20)
        self:command("give waterskin " .. tostring(actor))
    else
        actor:send(tostring(self.name) .. " tells you, 'You started play with a full waterskin.")
    end
    actor:send("Type <b:green>drink waterskin</> now to drink out of it.'")
end
_return_value = true
return _return_value$trig$, '93ff87fe5a8627dba4193c68b5e054f1'),
  -- data/triggers/519/519_62_academy_revel_command_drink.lua
  (519, 62, $trig$-- Converted from DG Script #51962: academy_revel_command_drink
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: drink
if not (cmd == "drink") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
-- switch on cmd
do
    local _sw1 = string.lower(tostring(cmd or ""))
    if _sw1 == "d" or _sw1 == "dr" then
        _return_value = true
        return _return_value
    end
end
if (actor:get_quest_var("school:rest") or 0) == 3 and (arg == "waterskin" or arg == "leather" or arg == "skin") then
    actor:set_quest_var("school", "rest", 4)
    actor:command("drink " .. tostring(arg))
    wait(0.2)
    actor:send(tostring(self.name) .. " tells you, 'Cheers!'")
    wait(1)
    actor:send(tostring(self.name) .. " tells you, 'Every now then you'll have to <b:cyan>FILL</> your drinking vessel.'")
    wait(1)
    actor:send(tostring(self.name) .. " tells you, 'Throughout the world you'll find many springs and fountains.'")
    wait(1)
    actor:send(tostring(self.name) .. " tells you, 'Like this one!'")
    self:command("point fountain")
    wait(4)
    actor:send(tostring(self.name) .. " tells you, 'You can <b:cyan>FILL</> a drink container from a source like this by typing <b:cyan>FILL [container] [source]</>.'")
    actor:send("</>")
    actor:send(tostring(self.name) .. " tells you, 'But first you have to <b:green>stand</> up.'")
end
_return_value = true
return _return_value$trig$, 'aba9a23e14795085cc98583e67242248'),
  -- data/triggers/519/519_63_academy_revel_command_fill.lua
  (519, 63, $trig$-- Converted from DG Script #51963: academy_revel_command_fill
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: fill
if not (cmd == "fill") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
-- switch on cmd
do
    local _sw1 = string.lower(tostring(cmd or ""))
    if _sw1 == "f" or _sw1 == "fi" then
        _return_value = true
        return _return_value
    end
end
if (actor:get_quest_var("school:rest") or 0) == 5 then
    actor:set_quest_var("school", "rest", 6)
    actor:command("fill " .. tostring(arg))
    wait(0.2)
    actor:send(tostring(self.name) .. " tells you, 'Just like that, perfect!'")
    wait(2)
    actor:send(tostring(self.name) .. " tells you, 'Now we feast!'")
    wait(2)
    self.room:spawn_object(203, 5)
    self:command("give meat " .. tostring(actor.name))
    wait(2)
    actor:send(tostring(self.name) .. " tells you, 'Ethilien is filled with edible foods.")
    actor:send("</>You can <b:cyan>EAT</> your way across the world!")
    actor:send("Being full increases your regeneration rate.")
    actor:send("Every time you <b:cyan>EAT</> you also immediately regain some Hit Points!")
    actor:send("Food has no other effects though.'")
    wait(3)
    actor:send(tostring(self.name) .. " tells you, 'Come, feast with me!  Type <b:green>eat meat</>!'")
    self.room:spawn_object(203, 5)
end
_return_value = true
return _return_value$trig$, '606c9bd0da0eaec1f2b7ff78f07a4b41'),
  -- data/triggers/519/519_64_academy_revel_command_eat.lua
  (519, 64, $trig$-- Converted from DG Script #51964: academy_revel_command_eat
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: eat
if not (cmd == "eat") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
-- switch on cmd
do
    local _sw1 = string.lower(tostring(cmd or ""))
    if _sw1 == "e" or _sw1 == "ea" then
        _return_value = true
        return _return_value
    end
end
if (actor:get_quest_var("school:rest") or 0) == 6 and (arg == "meat" or arg == "food") and actor:has_item(203, 5) then
    actor:set_quest_var("school", "rest", 7)
    actor:command("eat " .. tostring(arg))
    wait(0.2)
    self:command("eat meat")
    self:command("lick")
    actor:send(tostring(self.name) .. " tells you, 'Mmmmm, delicious!'")
    wait(1)
    actor:send(tostring(self.name) .. " tells you, 'When you're all rested up you can head back out into the world.'")
    wait(2)
    actor:send(tostring(self.name) .. " tells you, 'The best place to start your adventures is the <b:yellow>FARMLAND</> immediately west of the town of Mielikki, the starting town above us.'")
    wait(2)
    actor:send(tostring(self.name) .. " tells you, 'The <b:cyan>HELP ZONE</> file will show you lots of places to explore.")
    actor:send("Type <b:green>help zone</> and check it out.'")
end
_return_value = true
return _return_value$trig$, 'bcb57b6f163295c1cced0e9f75e4bf2b'),
  -- data/triggers/519/519_65_academy_revel_command_deposit.lua
  (519, 65, $trig$-- Converted from DG Script #51965: academy_revel_command_deposit
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: deposit
if not (cmd == "deposit") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
-- switch on arg
do
    local _sw1 = string.lower(tostring(arg or ""))
    if _sw1 == "d" then
        _return_value = true
        return _return_value
    end
end
if (actor:get_quest_var("school:money") or 0) == 1 and string.find(arg, "1 gold 1 silver 1 copper") then
    actor:set_quest_var("school", "money", "complete")
    actor:command("deposit 1 gold 1 silver 1 copper")
    wait(0.2)
    actor:send(tostring(self.name) .. " tells you, 'Thank you for using Academy Bank.")
    actor:send("You can <b:cyan>WITHDRAW</> your funds at any time.'")
    wait(1)
end
if actor:get_quest_stage("school") == 5 then
    if actor:get_quest_var("school:money") == "complete" and actor:get_quest_var("school:rest") == "complete" then
        actor:advance_quest("school")
        actor:send(tostring(self.name) .. " tells you, 'You're ready to graduate from Ethilien Academy!")
        actor:send(tostring(self.name) .. " says, '<b:green>Say finish</> to end the school.'")
    else
        actor:send(tostring(self.name) .. " tells you, '<b:green>Say resting</> to finish your last lesson, or say <magenta>SKIP</> to jump to the end of the Academy.'")
    end
end
_return_value = true
return _return_value$trig$, '6c88bb465aa816f29f2a4c20297cbee7'),
  -- data/triggers/519/519_66_academy_revel_command_help.lua
  (519, 66, $trig$-- Converted from DG Script #51966: academy_revel_command_help
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: help
if not (cmd == "help") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
if (actor:get_quest_var("school:rest") or 0) == 7 then
    -- switch on arg
    do
        local _sw1 = string.lower(tostring(arg or ""))
        if _sw1 == "zo" or _sw1 == "zon" or _sw1 == "zone" then
            actor:set_quest_var("school", "rest", "complete")
            actor:command("help zone")
            wait(0.2)
            actor:send(tostring(self.name) .. " tells you, 'When you're ready to stop playing, to safely log out, you have to find an inn.")
            actor:send("Talk to the inn's receptionist and <b:cyan>RENT</> a room.")
            actor:send("Think of inns like save points.")
            actor:send("Renting stores all your items for free.")
            actor:send("When you log back in, you'll be at the inn.'")
            wait(1)
        end
    end
end
if actor:get_quest_stage("school") == 5 then
    if actor:get_quest_var("school:money") == "complete" and actor:get_quest_var("school:rest") == "complete" then
        actor:advance_quest("school")
        actor:send(tostring(self.name) .. " tells you, 'You're ready to graduate from Ethilien Academy!")
        actor:send("<b:green>Say finish</> to end the school.'")
    else
        actor:send(tostring(self.name) .. " tells you, '<b:green>Say money</> to finish your last lesson, or say <magenta>SKIP</> to jump to the end of the Academy.'")
    end
end
_return_value = true
return _return_value$trig$, 'eb1f4c1674bf62f7a6e839bbc21762d7'),
  -- data/triggers/519/519_72_academy_sorcerer_command_meditate.lua
  (519, 72, $trig$-- Converted from DG Script #51972: academy_sorcerer_command_meditate
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: meditate
if not (cmd == "meditate") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
-- switch on cmd
do
    local _sw1 = string.lower(tostring(cmd or ""))
    if _sw1 == "m" or _sw1 == "me" then
        _return_value = true
        return _return_value
    end
end
if (actor:get_quest_var("school:fight") or 0) == 11 then
    actor:set_quest_var("school", "fight", 12)
    actor:command("meditate")
    wait(0.2)
    actor:send(tostring(self.name) .. " tells you, 'It will take a while to finish recovering your spell slots.")
    actor:send("You will receive a notification each time you recover a spell slot and when you recover them all.'")
    wait(2)
    actor:send(tostring(self.name) .. " tells you, 'You do not gain a bonus to <b:cyan>FOCUS</> when sleeping or just resting.")
    actor:send("If you <b:cyan>(ST)AND</> or <b:cyan>(SL)EEP</> you'll immediately stop meditating.")
    actor:send("Don't worry, your spell slots will still recover at their normal rate.'")
    wait(3)
    actor:send(tostring(self.name) .. " tells you, 'When you're done, type <b:green>stand</> so I know you're ready to continue.'")
end
_return_value = true
return _return_value$trig$, '85cf74715ebce84dc09c14fc401deace'),
  -- data/triggers/519/519_74_academy_classes_command_toggle_split.lua
  (519, 74, $trig$-- Converted from DG Script #51974: academy_classes_command_toggle_split
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: toggle
if not (cmd == "toggle") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
-- switch on cmd
do
    local _sw1 = string.lower(tostring(cmd or ""))
    if _sw1 == "t" then
        _return_value = true
        return _return_value
    end
end
if (actor:get_quest_var("school:loot") or 0) == 2 then
    -- switch on arg
    do
        local _sw2 = string.lower(tostring(arg or ""))
        if _sw2 == "autol" or _sw2 == "autolo" or _sw2 == "autoloo" or _sw2 == "autoloot" then
            actor:set_quest_var("school", "loot", 3)
            actor:command("toggle autoloot")
            wait(0.2)
            actor:send(tostring(self.name) .. " tells you, 'Grand.'")
            wait(1)
            actor:send(tostring(self.name) .. " tells you, 'When playing with others it's considered polite to share the wealth.")
            actor:send("You can share money with the <b:cyan>SPLIT</> command.")
            actor:send("With <b:cyan>TOGGLE AUTOSPLIT</> on the game will automatically do that when you pick up money.'")
            wait(2)
            actor:send(tostring(self.name) .. " tells you, 'Type <b:green>toggle autosplit</> to set that.'")
        end
    end
elseif (actor:get_quest_var("school:loot") or 0) == 3 then
    -- switch on arg
    do
        local _sw3 = string.lower(tostring(arg or ""))
        if _sw3 == "autos" or _sw3 == "autosp" or _sw3 == "autospl" or _sw3 == "autospli" or _sw3 == "autosplit" then
            actor:set_quest_var("school", "loot", 4)
            actor:command("toggle autosplit")
            wait(0.2)
            actor:send(tostring(self.name) .. " tells you, 'Now you'll play nice with other people!'")
            wait(1)
            actor:send(tostring(self.name) .. " tells you, 'The last combat tip is checking your <b:cyan>(TRO)PHY</> list.")
            actor:send("<b:cyan>TROPHY</> shows a record of the last 24 creatures you've killed and how many times you've killed them.'")
            wait(2)
            actor:send(tostring(self.name) .. " tells you, 'Type <b:green>trophy</> and see your record.'")
        end
    end
end
_return_value = true
return _return_value$trig$, '771fb4f08941256ab39a34109037d21f'),
  -- data/triggers/519/519_76_academy_revel_command_stand.lua
  (519, 76, $trig$-- Converted from DG Script #51976: academy_revel_command_stand
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: stand
if not (cmd == "stand") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
-- switch on cmd
do
    local _sw1 = string.lower(tostring(cmd or ""))
    if _sw1 == "s" then
        _return_value = true
        return _return_value
    end
end
if (actor:get_quest_var("school:rest") or 0) == 4 then
    actor:set_quest_var("school", "rest", 5)
    actor:command("stand")
    wait(0.2)
    actor:send(tostring(self.name) .. " tells you, 'Now you can <b:green>fill waterskin fountain</>.'")
end
_return_value = true
return _return_value$trig$, '6b3be2b7bb73878d742669a602af5c47'),
  -- data/triggers/519/519_84_academy_torch_wear.lua
  (519, 84, $trig$-- Converted from DG Script #51984: academy_torch_wear
-- Original: OBJECT trigger, flags: WEAR, probability: 100%
if (actor:get_quest_var("school:gear") or 0) == 4 then
    actor:set_quest_var("school", "gear", 5)
    wait(0.2)
    actor:send(tostring(mobiles.template(519, 2).name) .. " tells you, 'Notice you have a torch equipped now.")
    actor:send("However, you need to turn it on before it provides you any light.")
    actor:send("The <b:cyan>(LI)GHT</> command turns lights on and off.")
    actor:send("You can just type <b:cyan>light torch</> to light it up.")
    actor:send("If it's already lit, you can type <b:cyan>light torch</> again to extinguish it.'")
    wait(3)
    actor:send(tostring(mobiles.template(519, 2).name) .. " tells you, 'Give it a try and type <b:green>light torch</>.'")
end$trig$, 'e249d075da848049c19248762e4e093c'),
  -- data/triggers/519/519_90_academy_wear_pen.lua
  (519, 90, $trig$-- Converted from DG Script #51990: academy_wear_pen
-- Original: OBJECT trigger, flags: WEAR, probability: 100%
if (actor:get_quest_var("school:fight") or 0) == 4 then
    actor:set_quest_var("school", "fight", 5)
    wait(0.2)
    actor:send(tostring(mobiles.template(519, 6).name) .. " tells you, 'Wonderful, you're all set!")
    actor:send("Now you can <b:cyan>SCRIBE</> any spell on your spell list.")
    actor:send("Each spell takes up pages in your spellbook.")
    actor:send("The number of pages is affected by your <b:cyan>SCRIBE</> skill.'")
    wait(1)
    actor:send(tostring(mobiles.template(519, 6).name) .. " tells you, 'You can write any spell you know in your spellbook as long as you're with your Guild Master and your spellbook enough blank pages left in it.'")
    wait(2)
    actor:send(tostring(mobiles.template(519, 6).name) .. " tells you, 'For now, just type <b:green>scribe magic missile</>.'")
end$trig$, '99d302cb3de1ce282cce114abb6b08ba'),
  -- data/triggers/519/519_94_academy_bag_command_get.lua
  (519, 94, $trig$-- Converted from DG Script #51994: academy_bag_command_get
-- Original: OBJECT trigger, flags: COMMAND, probability: 7%

-- Command filter: get
if not (cmd == "get") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
if (actor:get_quest_var("school:gear") or 0) == 15 and string.find(arg, "stick") then
    -- switch on arg
    do
        local _sw1 = string.lower(tostring(arg or ""))
        if _sw1 == "b" or _sw1 == "ba" or _sw1 == "bag" then
            actor:set_quest_var("school", "gear", 16)
            actor:command("get stick bag")
            wait(0.2)
            self:command("cheer")
            actor:send(tostring(mobiles.template(519, 2).name) .. " tells you, 'Congratulations, you mastered equipment management!")
            actor:send("Would you like to review?")
            actor:send("You can <b:green>say yes</> or <b:green>say no</>.'")
        end
    end
end
_return_value = true
return _return_value$trig$, 'df392589efabf57e52b44badfa42b32b'),
  -- data/triggers/533/533_08_wall_ice_sculptor_greet.lua
  (533, 8, $trig$wait(1)
if actor:get_quest_stage("type_wand") == "wandstep" then
    local wandstep = tonumber(actor:get_quest_var("type_wand:wandstep")) or 0
    local minlevel = (wandstep - 1) * 10
    if actor.level >= minlevel then
        if (actor:get_quest_var("type_wand:greet") or 0) == 0 then
            self.room:send(tostring(self.name) .. " says, 'I see you're crafting something.  If you want my help, we can talk about <b:cyan>[upgrades]</>.'")
            actor:set_quest_var("type_wand", "greet", 1)
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
end$trig$, '60d59d63af10fcc61132e8ab309165cc'),
  -- data/triggers/534/534_106_frost_elf_quest_death.lua
  (534, 106, $trig$-- Converted from DG Script #53506: Frost elf quest death
-- Original: MOB trigger, flags: DEATH, probability: 100%
-- Mark all group members in the room who shook the snow globe as having
-- killed a frost elf, so the quest can advance.
local i = actor.group_size
local a
if i then
    a = 1
else
    a = 0
end
while i >= a do
    local person = actor.group_member[a]
    if person.room == self.room then
        if (person:get_quest_var("frost_valley_quest:shake") or 0) == 1 then
            person:set_quest_var("frost_valley_quest", "elf", 1)
        end
    elseif person then
        i = i + 1
    end
    a = a + 1
end$trig$, 'b47612fd4663b77465d83604852105fd'),
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
        local wards = actor:get_quest_var("major_globe_spell:ward_count") + 1
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
        local wards_left = 5 - actor:get_quest_var("major_globe_spell:ward_count")
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
return true$trig$, '703532a3e8a308b37c180d2bd8a56aeb'),
  -- data/triggers/534/534_99_major_globe_quest_status_checker.lua
  (534, 99, $trig$-- Converted from DG Script #53499: major_globe_quest_status_checker
-- Original: MOB trigger, flags: SPEECH, probability: 0%
-- NOTE: legacy probability 0% on SPEECH means "always run on keyword match";
-- the converter's percent_chance(0) gate has been removed.

-- Speech phrase: spell progress (DG num_arg 0 = the speech contains the whole phrase, on word boundaries)
local speech_padded = " " .. string.lower(speech) .. " "
if not string.find(speech_padded, "[%s%p]spell progress[%s%p]") then
    return true  -- Not the phrase
end
wait(0.2)
local stage = actor:get_quest_stage("major_globe_spell")
-- switch on stage
if stage == 1 then
    actor:send(tostring(self.name) .. " says, 'Find Earle and tell him <b:cyan>\"Lirne sends me.\"</>'")
elseif stage == 2 then
    actor:send(tostring(self.name) .. " says, 'Find <b:yellow>shale</> on Fiery Island.  Bring it to Earle on Griffin Island.'")
elseif stage == 3 then
    actor:send(tostring(self.name) .. " says, 'Find <b:yellow>sake</> in Odaishyozen.  Bring it to Earle on Griffin Island.'")
elseif stage == 4 then
    actor:send(tostring(self.name) .. " says, 'Find a <b:yellow>marigold poultice</> on a healer in South Caelia.  Bring it to Earle on Griffin Island.'")
elseif stage == 5 then
    actor:send(tostring(self.name) .. " says, 'Bring me the <b:yellow>salve</> Earle prepared.'")
elseif stage == 6 then
    actor:send(tostring(self.name) .. " says, 'Find the <b:yellow>lost spellbook</> in a <b:cyan>library</> or <b:cyan>stack</>.'")
elseif stage == 7 then
    actor:send(tostring(self.name) .. " says, 'Bring <b:yellow>" .. tostring(objects.template(534, 52).name) .. "</> to me.'")
elseif stage == 8 then
    -- TODO(parity): trigger 53457 stores ward keys as "ward_<local_id>" with
    -- ids 53-57 (zone 534). Legacy DG used 5-digit vnums 53453-53457; keep the
    -- new local-id convention here.
    local plant = actor:get_quest_var("major_globe_spell:ward_53")
    local mist = actor:get_quest_var("major_globe_spell:ward_54")
    local water = actor:get_quest_var("major_globe_spell:ward_55")
    local flame = actor:get_quest_var("major_globe_spell:ward_56")
    local ice = actor:get_quest_var("major_globe_spell:ward_57")
    actor:send(tostring(self.name) .. " says, 'Bring <b:yellow>5 elemental wards</>, one each from a mist, a water, an ice, a flame, and a plant elemental.'")
    local wards = actor:get_quest_var("major_globe_spell:ward_count")
    if wards then
        actor:send("You have found: <b:yellow>" .. tostring(wards) .. " wards</>")
    else
        actor:send("You have found: <b:yellow>0 wards</>")
    end
    if (plant or 0) == 2 then
        actor:send(tostring(objects.template(534, 53).name))
    end
    if (mist or 0) == 2 then
        actor:send(tostring(objects.template(534, 54).name))
    end
    if (water or 0) == 2 then
        actor:send(tostring(objects.template(534, 55).name))
    end
    if (flame or 0) == 2 then
        actor:send(tostring(objects.template(534, 56).name))
    end
    if (ice or 0) == 2 then
        actor:send(tostring(objects.template(534, 57).name))
    end
elseif stage == 9 then
    -- final_item now stores the chosen object's local id within zone 534
    -- (ids 58-61) — see trigger 53467.
    local final_item = actor:get_quest_var("major_globe_spell:final_item")
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
    local item_name = objects.template(534, final_item).name
    actor:send(tostring(self.name) .. " says, 'Find <b:yellow>" .. tostring(item_name) .. "</> " .. tostring(place) .. ".'")
    actor:send(tostring(self.name) .. " says, 'Bring me <b:cyan>" .. tostring(item_name) .. "</>.'")
end  -- auto-close block$trig$, '67677a92ec45266fa578e3669c972357'),
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
local actor_class_lower = string.lower(actor.class)
if ((string.find(actor_class_lower, "sorcerer") or string.find(actor_class_lower, "illusionist")) and actor.level > 80) or actor:get_quest_stage("type_wand") == 5 then
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
        if actor:get_quest_stage("type_wand") == 5 then
            if (actor:get_quest_var("type_wand:greet") or 0) == 0 then
                self:command("peer " .. tostring(actor))
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
    if actor:get_quest_stage("type_wand") == 5 then
        local job1 = actor:get_quest_var("type_wand:wandtask1")
        local job2 = actor:get_quest_var("type_wand:wandtask2")
        local job3 = actor:get_quest_var("type_wand:wandtask3")
        local job4 = actor:get_quest_var("type_wand:wandtask4")
        if actor.level >= 40 then
            if (actor:get_quest_var("type_wand:greet") or 0) == 0 then
                actor:send(tostring(self.name) .. " tells you, 'I see you're crafting something.  If you come for the Great Snow Leopard's help, let's discuss an <b:cyan>[upgrade]</>.'")
            elseif actor:get_quest_stage("type_wand") == 5 and job1 and job2 and job3 and job4 then
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
end$trig$, 'd497a846c5a346e639eddceb857e5b55'),
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
        local given = gloves_armor + boots_armor + bracer_armor + helm_armor + arm_armor + legs_armor + chest_armor
        given = given + gloves_gems + boots_gems + bracer_gems + helm_gems + arm_gems + legs_gems + chest_gems
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
end$trig$, 'b1e95b45ff67364eb0a89e3c24de4cf9'),
  -- data/triggers/557/557_00_phase_armor_-_greet.lua
  (557, 0, $trig$-- Converted from DG Script #55700: Phase Armor - Greet
-- Original: MOB trigger, flags: GREET_ALL, probability: 100%
-- DG globals set on this mob by its init (LOAD) trigger, 557:10-39
local classes = self:getvar("classes")
local phase = self:getvar("phase")
if classes == nil or phase == nil then
    return true  -- the init trigger has not run for this mob
end
local _return_value = true  -- Default: allow action
wait(0.2)
local anti = "Anti-Paladin"
if not actor or not actor.can_be_seen then
    _return_value = true
else
    if actor.level <= (20 * (phase - 1)) then
        _return_value = true
    elseif not string.find(string.lower(classes), actor.class, 1, true) or (classes == anti and actor.class == "paladin") then
        _return_value = true
    elseif actor:get_quest_stage("phase_armor") == (phase - 1) then
        wait(0.2)
        actor:send(tostring(self.name) .. " tells you, 'Welcome, would you like to do some armor quests?  If so, just ask me about them.'")
    end
end
if string.find(self.class, "necromancer") then
    if actor:get_quest_stage("shift_corpse") > 0 then
        wait(0.2)
        actor:send(tostring(self.name) .. " says, 'May Death guide your hunt for Lokari.'")
        wait(1)
        actor:send(tostring(self.name) .. " says, 'If you need a new crystal, msend " .. tostring(actor) .. " " .. tostring(self.name) .. " says, <b:black>\"I need a new crystal\"</>.'")
    end
elseif string.find(self.class, "pyromancer") then
    if actor:get_quest_stage("supernova") == 2 and (actor:has_item(489, 17) or actor:has_equipped(489, 17)) then
        actor:advance_quest("supernova")
        local step3, step4, step5, step6
        local rnd1 = random(1, 3)
        do
            local _sw1 = string.lower(tostring(rnd1 or ""))
            if tonumber(_sw1) == 1 then
                step3 = 4318
            elseif tonumber(_sw1) == 2 then
                step3 = 10316
            elseif tonumber(_sw1) == 3 then
                step3 = 58062
            end
        end
        actor:set_quest_var("supernova", "step3", step3)
        local rnd2 = random(1, 3)
        do
            local _sw2 = string.lower(tostring(rnd2 or ""))
            if tonumber(_sw2) == 1 then
                step4 = 18577
            elseif tonumber(_sw2) == 2 then
                step4 = 17277
            elseif tonumber(_sw2) == 3 then
                step4 = 8561
            end
        end
        actor:set_quest_var("supernova", "step4", step4)
        local rnd3 = random(1, 3)
        do
            local _sw3 = string.lower(tostring(rnd3 or ""))
            if tonumber(_sw3) == 1 then
                step5 = 53219
            elseif tonumber(_sw3) == 2 then
                step5 = 47343
            elseif tonumber(_sw3) == 3 then
                step5 = 16278
            end
        end
        actor:set_quest_var("supernova", "step5", step5)
        local rnd4 = random(1, 3)
        do
            local _sw4 = string.lower(tostring(rnd4 or ""))
            if tonumber(_sw4) == 1 then
                step6 = 58657
            elseif tonumber(_sw4) == 2 then
                step6 = 35119
            elseif tonumber(_sw4) == 3 then
                step6 = 55422
            end
        end
        actor:set_quest_var("supernova", "step6", step6)
        local step7 = random(1, 3)
        actor:set_quest_var("supernova", "step7", step7)
        wait(0.2)
        actor:send(tostring(self.name) .. " says, 'Ah I see you found one of Phayla's lamps!'")
        wait(3)
        actor:send(tostring(self.name) .. " says, 'Phayla likes to visit the material plane to engage in her favorite leisure activities.'")
        wait(2)
        local clue = actor:get_quest_var("supernova:step3")
        -- switch on clue
        do
            local _sw5 = string.lower(tostring(clue or ""))
            if tonumber(_sw5) == 4318 then
                actor:send(tostring(self.name) .. " says, 'Recently, she was spotted in Anduin, taking in a show from the best seat in the house.'")
            elseif tonumber(_sw5) == 10316 then
                actor:send(tostring(self.name) .. " says, 'I understand she frequents the hottest spring at the popular resort up north.'")
            elseif tonumber(_sw5) == 58062 then
                actor:send(tostring(self.name) .. " says, 'She occasionally visits a small remote island theatre, where she enjoys meditating in their reflecting room.'")
            end
        end
        wait(2)
        actor:send(tostring(self.name) .. " says, 'You may be able to find a clue to her whereabouts there.'")
    end
elseif (self.class == "cleric" or self.class == "priest" or self.class == "diabolist") and macestep then
    if actor:get_quest_stage("phase_mace") == "macestep" then
        local minlevel = macestep * 10
        if actor.level >= minlevel then
            wait(0.2)
            if (actor:get_quest_var("phase_mace:greet") or 0) == 0 then
                actor:send(tostring(self.name) .. " says, 'I sense a ghostly presence about your weapons.  If you want my help, we can talk about <b:cyan>[upgrades]</>.'")
            else
                actor:send(tostring(self.name) .. " says, 'Do you have what I need for the mace?'")
            end
        end
    end
end
-- TODO(parity): converter mashed two conditions together. Original
-- DG gated an info dump on the ursa_quest stage AND the speaker
-- being mob (60, 7). Restored that conservative reading via
-- self.zone_id / self.local_id; verify against legacy.
if actor:get_quest_stage("ursa_quest") > 0 and self.zone_id == 60 and self.local_id == 7 then
    wait(1)
    actor:send(tostring(self.name) .. " notices the concerned look on your face.")
    wait(1)
    actor:send(tostring(self.name) .. " tells you, 'So, the merchant has gotten himself in quite a bit of trouble.'")
    wait(1)
    actor:send(tostring(self.name) .. " tells you, 'I know what he must do, but he won't like it.'")
    self:command("chuckle")
    wait(1)
    actor:send(tostring(self.name) .. " dips his quill in a well of blood and scratches out a sinister letter.")
    wait(2)
    actor:send(tostring(self.name) .. " tells you, 'Quickly, take this to him!  Perhaps the Darkness still finds him...  amusing.'")
    -- TODO(parity): verify (625, 10) is the intended (zone, local_id) for the
    -- ursa-quest letter; converter may have left a 5-digit legacy vnum.
    self.room:spawn_object(625, 10)
    self:command("give letter " .. tostring(actor))
end
if actor:get_quest_stage("hell_trident") == 1 and self.zone_id == 60 and self.local_id == 32 then
    if actor.level >= 65 then
        wait(0.2)
        if not actor:get_quest_var("hell_trident:helltask5") then
            if actor:get_has_completed("banish") then
                actor:set_quest_var("hell_trident", "helltask5", 1)
            end
        end
        if not actor:get_quest_var("hell_trident:helltask4") then
            if actor:get_has_completed("hellfire_brimstone") then
                actor:set_quest_var("hell_trident", "helltask4", 1)
            end
        end
        if not actor:get_quest_var("hell_trident:helltask6") then
            if actor:get_quest_stage("vilekka_stew") > 3 then
                actor:set_quest_var("hell_trident", "helltask6", 1)
            end
        end
        if (actor:get_quest_var("hell_trident:greet") or 0) == 0 then
            actor:send(tostring(self.name) .. " says, 'Hmmm, is that a demon's trident I sense on you?  Perhaps you would like some help with <b:cyan>[upgrades]</>.'")
        else
            local job1 = actor:get_quest_var("hell_trident:helltask1")
            local job2 = actor:get_quest_var("hell_trident:helltask2")
            local job3 = actor:get_quest_var("hell_trident:helltask3")
            local job4 = actor:get_quest_var("hell_trident:helltask4")
            local job5 = actor:get_quest_var("hell_trident:helltask5")
            local job6 = actor:get_quest_var("hell_trident:helltask6")
            if job1 and job2 and job3 and job4 and job5 and job6 then
                actor:send(tostring(self.name) .. " says, 'You return with victory in your eyes.  Hand me your trident.'")
            else
                actor:send(tostring(self.name) .. " says, 'Have you met Hell's demands?'")
            end
        end
    end
end
return _return_value$trig$, '5b2873de9358c970ccaa9f00a6af3f69'),
  -- data/triggers/557/557_03_phase_armor_-_receive.lua
  (557, 3, $trig$-- Converted from DG Script #55703: Phase Armor - Receive
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
-- DG `%get.obj_shortdesc/noadesc/pldesc[VNUM]%` (legacy dg_scripts.cpp): VNUM = zone * 100 + id.
local function proto_short(vnum)
    vnum = tonumber(vnum)
    if not vnum then return "[no description for object ?]" end
    local name = objects.template(math.floor(vnum / 100), vnum % 100).name
    if name == nil or name == "" then return "[no description for object " .. vnum .. "]" end
    return name
end
local function without_article(s)
    for _, a in ipairs({"a pair ", "a ", "an ", "some ", "the "}) do
        if string.lower(string.sub(s, 1, #a)) == a then return string.sub(s, #a + 1) end
    end
    return s
end
local function proto_noa(vnum)
    return without_article(proto_short(vnum))
end
local function proto_plural(vnum)
    local s = proto_short(vnum)
    if string.lower(string.sub(s, 1, 5)) == "some " then
        return "quantities of " .. string.sub(s, 6)
    end
    local u = without_article(s)
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
-- DG globals set on this mob by its init (LOAD) trigger, 557:10-39
local classes = self:getvar("classes")
local phase = self:getvar("phase")
local feet_gem = self:getvar("feet_gem")
local head_gem = self:getvar("head_gem")
local hands_gem = self:getvar("hands_gem")
local arms_gem = self:getvar("arms_gem")
local legs_gem = self:getvar("legs_gem")
local body_gem = self:getvar("body_gem")
local wrist_gem = self:getvar("wrist_gem")
local feet_armor = self:getvar("feet_armor")
local head_armor = self:getvar("head_armor")
local hands_armor = self:getvar("hands_armor")
local arms_armor = self:getvar("arms_armor")
local legs_armor = self:getvar("legs_armor")
local body_armor = self:getvar("body_armor")
local wrist_armor = self:getvar("wrist_armor")
local feet_reward = self:getvar("feet_reward")
local head_reward = self:getvar("head_reward")
local hands_reward = self:getvar("hands_reward")
local arms_reward = self:getvar("arms_reward")
local legs_reward = self:getvar("legs_reward")
local body_reward = self:getvar("body_reward")
local wrist_reward = self:getvar("wrist_reward")
if classes == nil or phase == nil then
    return true  -- the init trigger has not run for this mob
end
local _return_value = true  -- Default: allow action
-- The init trigger stores legacy vnums (zone * 100 + id); compare the
-- turned-in object the same way.
local object_id = (tonumber(object.zone_id) or 0) * 100 + (tonumber(object.local_id) or 0)
if object_id == hands_armor or object_id == hands_gem or object_id == feet_armor or object_id == feet_gem or object_id == wrist_armor or object_id == wrist_gem or object_id == head_armor or object_id == head_gem or object_id == arms_armor or object_id == arms_gem or object_id == legs_armor or object_id == legs_gem or object_id == body_armor or object_id == body_gem then
    local anti = "Anti-Paladin"
    if not actor or not actor.can_be_seen then
        _return_value = true
        self:command("peer")
        actor:send(tostring(self.name) .. " says, 'I can't help you if I can't see you.'")
        return _return_value
    end
    if not string.find(string.lower(classes), actor.class, 1, true) or (classes == anti and actor.class == "paladin") then
        _return_value = true
        if string.find(classes, "and") then
            actor:send(tostring(self.name) .. " tells you, 'Sorry, this quest is for the " .. tostring(classes) .. " classes only.'")
        else
            actor:send(tostring(self.name) .. " tells you, 'Sorry, this quest is for the " .. tostring(classes) .. " class only.'")
        end
        return _return_value
    elseif actor.level <= 20 * (phase - 1) then
        _return_value = true
        actor:send(tostring(self.name) .. " tells you, 'Sorry, why don't you come back when you've gained more experience?'")
        actor:send(tostring(self.name) .. " refuses your item.")
        return _return_value
    elseif actor:get_quest_stage("phase_armor") < phase then
        _return_value = true
        actor:send(tostring(self.name) .. " tells you, 'I don't think you're ready for my armor quests yet.'")
        actor:send(tostring(self.name) .. " refuses your item.")
        return _return_value
    end
    -- DG `case <armor>` falls through into `case <gem>`: both set the slot's
    -- multiplier and reward, only the armor sets `is_armor`.
    local is_armor, exp_x, reward_id
    local slot_table = {
        {hands_armor, hands_gem, 1, hands_reward},
        {feet_armor, feet_gem, 2, feet_reward},
        {wrist_armor, wrist_gem, 3, wrist_reward},
        {head_armor, head_gem, 4, head_reward},
        {arms_armor, arms_gem, 6, arms_reward},
        {legs_armor, legs_gem, 8, legs_reward},
        {body_armor, body_gem, 10, body_reward},
    }
    for _, sl in ipairs(slot_table) do
        if object_id == sl[1] then
            is_armor = 1
        end
        if object_id == sl[1] or object_id == sl[2] then
            exp_x = sl[3]
            reward_id = sl[4]
            break
        end
    end
    if is_armor then
        local armor_key = tostring(object_id) .. "_armor_acquired"
        local armor_count = actor:get_quest_var("phase_armor:" .. armor_key) or 0
        if armor_count < 1 then
            _return_value = false
            wait(0.1)
            world.destroy(object)
            armor_count = armor_count + 1
            actor:set_quest_var("phase_armor", armor_key, armor_count)
            actor:send(tostring(self.name) .. " tells you, 'Hey now, what have we here!?")
            actor:send("</>I've been looking for this for some time.")
            actor:send("</>You have now given me " .. proto_short(object_id) .. ".'")
        else
            _return_value = true
            wait(0.2)
            self:command("eye " .. tostring(actor.name))
            actor:send(tostring(self.name) .. " tells you, 'Hey now, you've already given me one of these!'")
            actor:send(tostring(self.name) .. " refuses your item.")
            return _return_value
        end
    else
        local gem_key = tostring(object_id) .. "_gems_acquired"
        local gem_count = actor:get_quest_var("phase_armor:" .. gem_key) or 0
        if gem_count < 3 then
            _return_value = false
            wait(0.1)
            world.destroy(object)
            gem_count = gem_count + 1
            actor:set_quest_var("phase_armor", gem_key, gem_count)
            actor:send(tostring(self.name) .. " tells you, 'Hey, very nice.'")
            wait(0.2)
            actor:send(tostring(self.name) .. " tells you, 'It is good to see that adventurers are out conquering the realm.'")
            wait(0.2)
            if gem_count == 1 then
                actor:send(tostring(self.name) .. " tells you, 'You have given me 1 " .. proto_noa(object_id) .. ".'")
            else
                actor:send(tostring(self.name) .. " tells you, 'You have given me " .. tostring(gem_count) .. " " .. proto_plural(object_id) .. ".'")
            end
        else
            _return_value = true
            wait(0.1)
            self:command("eye " .. tostring(actor.name))
            actor:send(tostring(self.name) .. " tells you, 'Hey now, you've already given me " .. tostring(gem_count) .. " of these!'")
            actor:send(tostring(self.name) .. " refuses your item.")
            return _return_value
        end
    end
    --
    -- Check to see if the quest is complete and if the reward can be given.
    -- The original DG looked up `<gem_id>_gems_acquired` and
    -- `<armor_id>_armor_acquired`; we mirror that using the same
    -- `<id>_..._acquired` keying pattern used above. Per-slot pairing
    -- is derived from whichever gem/armor slot matches `object_id`.
    --
    local function _slot_for(oid)
        if oid == hands_armor or oid == hands_gem then return hands_armor, hands_gem end
        if oid == feet_armor  or oid == feet_gem  then return feet_armor,  feet_gem  end
        if oid == wrist_armor or oid == wrist_gem then return wrist_armor, wrist_gem end
        if oid == head_armor  or oid == head_gem  then return head_armor,  head_gem  end
        if oid == arms_armor  or oid == arms_gem  then return arms_armor,  arms_gem  end
        if oid == legs_armor  or oid == legs_gem  then return legs_armor,  legs_gem  end
        if oid == body_armor  or oid == body_gem  then return body_armor,  body_gem  end
    end
    local slot_armor_id, slot_gem_id = _slot_for(object_id)
    if slot_armor_id
       and ((actor:get_quest_var("phase_armor:" .. tostring(slot_gem_id) .. "_gems_acquired") or 0) == 3)
       and ((actor:get_quest_var("phase_armor:" .. tostring(slot_armor_id) .. "_armor_acquired") or 0) == 1) then
        wait(0.2)
        actor:send(tostring(self.name) .. " tells you, 'Excellent work, intrepid adventurer!")
        actor:send("</>You have provided me with all I need to reward you with:")
        actor:send("</>" .. proto_short(reward_id) .. "!'")
        wait(0.2)
        actor:send("<b:white>You gain experience!</>")
        local exp
        if actor.class == "warrior" or actor.class == "berserker" then
            exp = 7590
        elseif actor.class == "paladin" or actor.class == "anti-paladin" or actor.class == "ranger" then
            exp = 7935
        elseif actor.class == "sorcerer" or actor.class == "pyromancer" or actor.class == "cryomancer" or actor.class == "illusionist" or actor.class == "bard" then
            exp = 8280
        elseif actor.class == "necromancer" or actor.class == "monk" then
            exp = 8970
        else
            exp = 6900
        end
        if phase == 2 then
            exp = math.floor(exp * 608 / 100)
        elseif phase == 3 then
            exp = math.floor(exp * 1340 / 100)
        end
        local lap = 1
        while lap <= exp_x do
            actor:award_exp(exp)
            lap = lap + 1
        end
        self.room:spawn_object(math.floor(reward_id / 100), reward_id % 100)
        self:command("give all " .. tostring(actor.name))
        self:command("drop all")
        actor:save()
    end
end  -- auto-close block
return _return_value$trig$, '0219fe29289d676f56c88d9daa3e5038'),
  -- data/triggers/590/590_05_dark_robed_greet1.lua
  (590, 5, $trig$-- Converted from DG Script #59005: dark_robed_greet1
-- Original: MOB trigger, flags: GREET, probability: 60%

-- 60% chance to trigger
if not percent_chance(60) then
    return true
end
if not (actor.is_player and actor.level < 100) then
    return true
end
local stage = actor:get_quest_stage("sacred_haven")
if stage == 1 and (actor:get_quest_var("sacred_haven:given_light") or 0) ~= 1 then
    wait(0.6)
    actor:send(tostring(self.name) .. " whispers to you, 'Have you located the adornment of light")
    actor:send("</>for me?'")
elseif stage > 1 and (actor:get_quest_var("sacred_haven:given_blood") or 0) ~= 1 and (actor:get_quest_var("sacred_haven:given_earring") or 0) ~= 1 then
    wait(0.4)
    self:whisper(actor.name, "Have you brought me my artifacts?")
elseif stage < 1 then
    wait(0.4)
    local found_evil = false
    for _, target in ipairs(self.room.actors) do
        if target.alignment <= -350 and target.is_player and target.level < 100 then
            self:whisper(target.name, "Ah, I sense a wicked aura around your soul.")
            wait(0.5)
            target:send(tostring(self.name) .. " slowly walks up and leans in close towards you.")
            self.room:send_except(target, tostring(self.name) .. " slowly walks up and leans close towards " .. tostring(target.name) .. ".")
            wait(0.7)
            target:send(tostring(self.name) .. " whispers to you, 'I am willing to offer you a reward,")
            target:send("</>if only you can help me.'")
            found_evil = true
            break
        end
    end
    if not found_evil and actor.alignment > -350 then
        self:emote("slowly turns away from you, pulling his hood farther down to cover his face.")
    end
end$trig$, 'af69b8cf6cd79ffcdedb7a2c6260343b'),
  -- data/triggers/590/590_08_dark_robed_recieve1.lua
  (590, 8, $trig$-- Converted from DG Script #59008: dark_robed_recieve1
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
-- check to see what is being given!
local obj = object.id
local reward = "no"
-- switch on obj
-- adornment of light
if (object.zone_id == 590 and obj == 26) then
    -- check to see if quest is started and PC hasent given light already
    if (actor.is_player) and (actor:get_quest_stage("sacred_haven") == 1) and ((actor:get_quest_var("sacred_haven:given_light") or 0) ~= 1) then
        wait(0.5)
        self:emote("slowly rubs its hands together and cackles with a wicked sounding glee.")
        world.destroy(object.name)
        self.room:spawn_object(590, 31)
        wait(0.6)
        self:command("give dingy-key " .. tostring(actor.name))
        actor:send(tostring(self.name) .. " whispers to you, 'Here is a key that will help you finish")
        actor:send("</>my task.  Don't waste my efforts acquiring it.'")
        wait(0.3)
        actor:send(tostring(self.name) .. " whispers to you, 'I have lost a few of my dark artifacts to the")
        actor:send("</>clutches of the brothers from the Sacred Haven.'")
        wait(0.2)
        self:emote("grumbles loudly.")
        actor:set_quest_var("sacred_haven", "given_light", 1)
        -- last line just set var to let code know light has been given
    elseif (actor:get_quest_var("sacred_haven:given_light") or 0) == 1 then
        -- return light if already given
        wait(0.2)
        self:command("give adornment " .. tostring(actor.name))
        wait(0.3)
        self:say("You already gave me this!")
        self.room:send(tostring(self.name) .. " mumbles something about " .. tostring(actor.name) .. ".")
    else
        -- junk it if quest hasn't started
        wait(0.6)
        self:say("I don't want this.")
        self.room:send(tostring(self.name) .. " throws " .. tostring(object.shortdesc) .. " into the woods.")
        world.destroy(object.name)
    end
    -- UNCONVERTED: &3&b* vial of blood&0
    if (actor:get_quest_var("sacred_haven:given_blood") or 0) == 1 then
    elseif (object.zone_id == 590 and obj == 28) then
        wait(0.2)
        self:say("You have already given me this.")
        self:command("give vial-dragons-blood " .. tostring(actor.name))
    elseif actor:get_quest_stage("sacred_haven") < 2 then
        -- junk it if quest isn't at stage 2 yet
        wait(0.6)
        self:say("I don't want this.")
        self.room:send(tostring(self.name) .. " throws " .. tostring(object.shortdesc) .. " into the woods.")
        world.destroy(object.name)
    else
        wait(0.5)
        self:command("grin")
        wait(0.2)
        self:say("Good, now I have the vial of dragon's blood.")
        self:destroy_item("vial-dragons-blood")
        actor:set_quest_var("sacred_haven", "given_blood", 1)
        -- check to see if all 3 items have been returned
        if ((actor:get_quest_var("sacred_haven:given_blood") or 0) == 1) and ((actor:get_quest_var("sacred_haven:given_trinket") or 0) == 1) and ((actor:get_quest_var("sacred_haven:given_earring") or 0) == 1) then
            reward = "yes"
        else
            reward = "no"
        end
    end
    -- UNCONVERTED: &3&b*trinket of tattered leather&0
    if (actor:get_quest_var("sacred_haven:given_trinket") or 0) == 1 then
    elseif (object.zone_id == 590 and obj == 29) then
        wait(0.2)
        self:say("You have already given me this.")
        self:command("give trinket-tattered-leather " .. tostring(actor.name))
    elseif actor:get_quest_stage("sacred_haven") < 2 then
        -- junk it if quest isn't at stage 2 yet
        wait(0.6)
        self:say("I don't want this.")
        self.room:send(tostring(self.name) .. " throws " .. tostring(object.shortdesc) .. " into the woods.")
        world.destroy(object.name)
    else
        wait(0.5)
        self:command("grin")
        wait(0.3)
        actor:send(tostring(self.name) .. " says, 'Ahhh, I savor the feel of my skin against my trinket")
        self.room:send("</>of tattered leather.'")
        world.destroy(object.name)
        actor:set_quest_var("sacred_haven", "given_trinket", 1)
        -- check to see if all 3 items have been returned
        if ((actor:get_quest_var("sacred_haven:given_blood") or 0) == 1) and ((actor:get_quest_var("sacred_haven:given_trinket") or 0) == 1) and ((actor:get_quest_var("sacred_haven:given_earring") or 0) == 1) then
            reward = "yes"
        else
            reward = "no"
        end
    end
    -- UNCONVERTED: &3&b*earring&0
    if (actor:get_quest_var("sacred_haven:given_earring") or 0) == 1 then
    elseif (object.zone_id == 590 and obj == 30) then
        wait(0.2)
        self:say("You have already given me this.")
        self:command("give shadow-forged-earring " .. tostring(actor.name))
    elseif actor:get_quest_stage("sacred_haven") < 2 then
        -- junk it if quest isn't at stage 2 yet
        wait(0.6)
        self:say("I don't want this.")
        self.room:send(tostring(self.name) .. " throws " .. tostring(object.shortdesc) .. " into the woods.")
        world.destroy(object.name)
    else
        wait(0.9)
        world.destroy(object.name)
        self:command("cackle")
        wait(0.5)
        actor:send(tostring(self.name) .. " says, 'Yes... I have not seen the shadow forged earring in")
        self.room:send("</>quite some time.'")
        actor:set_quest_var("sacred_haven", "given_earring", 1)
        -- check to see if all 3 items have been returned
        if ((actor:get_quest_var("sacred_haven:given_blood") or 0) == 1) and ((actor:get_quest_var("sacred_haven:given_trinket") or 0) == 1) and ((actor:get_quest_var("sacred_haven:given_earring") or 0) == 1) then
            reward = "yes"
        else
            reward = "no"
        end
    end
else
    -- junk all other obj's
    wait(0.6)
    self:say("I don't want this.")
    self.room:send(tostring(self.name) .. " throws " .. tostring(object.shortdesc) .. " into the woods.")
    world.destroy(object.name)
end
if reward == "yes" then
    -- reward
    wait(3)
    self:command("look " .. tostring(actor.name))
    self:emote("nods their head and slowly pulls down their hood revealing a grey face.")
    wait(2)
    self.room:send(tostring(self.name) .. " says, 'Now that I have both the earring and vial of blood,")
    self.room:send("</>I will create a great reward with them.'")
    wait(3)
    self.room:send_except(self, tostring(self.name) .. " rubs the earring with their wrinkly fingers and uncaps the vial of dragon's <red>blood</>.")
    wait(5)
    self.room:send_except(self, tostring(self.name) .. " pours the vial onto the earring, which begins to release a thick black <b:black>smoke</>.")
    wait(4)
    self.room:send_except(self, "The smoke clears and the blood has been dried and baked onto the earring, giving it a <b:red>red shine</>.")
    wait(4)
    local rnd = random(1, 10)
    -- switch on rnd
    if rnd == 1 or rnd == 2 or rnd == 3 or rnd == 4 or rnd == 5 or rnd == 6 or rnd == 7 then
        self:command("cackle " .. tostring(actor.name))
        self:say("And now my prize!")
        wait(1)
        self.room:spawn_object(590, 2)
        self:command("wear dragons-blood-earring")
        wait(3)
        self.room:send(tostring(self.name) .. " says, 'Ahhh, you've been such a foolish one to complete")
        self.room:send("</>my deeds for me.'")
        wait(0.2)
        actor:complete_quest("sacred_haven")
        actor:erase_quest("sacred_haven")
        spells.cast(self, "cause crit", actor.name)
    elseif rnd == 8 or rnd == 9 or rnd == 10 then
    else
        self:emote("sighs.")
        wait(2)
        self:say("At least I have the remainder of the vial of")
        self.room:send("'dragon's blood.'")
        wait(5)
        self.room:spawn_object(590, 2)
        self:command("give dragons-blood-earring " .. tostring(actor.name))
        wait(0.6)
        self.room:send(tostring(self.name) .. " says, 'And it is rumored that there are two more shadow")
        self.room:send("</>forged earrings still within the realms.'")
        wait(3)
        actor:send(tostring(self.name) .. " turns away from you.")
        self.room:send_except(actor.name, tostring(self.name) .. " turns away from " .. tostring(actor.name) .. ".")
        actor:complete_quest("sacred_haven")
        actor:erase_quest("sacred_haven")
    end
elseif reward == "no" then
    -- ask for more stuff
    wait(0.4)
    self:whisper(actor.name, "Ok, now bring me the rest of my artifacts.")
end$trig$, 'ccc7eaac812fe502689d89770c4efdb8'),
  -- data/triggers/590/590_09_dark_robed_artifacts.lua
  (590, 9, $trig$-- Converted from DG Script #59009: dark_robed_artifacts
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"artifacts?", "artifacts"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
wait(0.4)
-- Walk the speaker's group; for any evil-aligned member that already gave the
-- adornment of light, mark them as searching for blood and advance the quest
-- if they're still on stage 1.
local continue = false
for _, person in ipairs(actor.group or { actor }) do
    if person.room == self.room and (person:get_quest_var("sacred_haven:given_light") or 0) == 1 and person.alignment <= -350 then
        continue = true
        person:set_quest_var("sacred_haven", "find_blood", 1)
        if person:get_quest_stage("sacred_haven") == 1 then
            person:advance_quest("sacred_haven")
            person:send("<b:white>You have advanced the quest!</>")
        end
    end
end
if continue then
    actor:send(tostring(self.name) .. " whispers to you, 'I had a vial of dragon's blood, a trinket of tattered leather, and a small shadow forged earring stolen from me.  They are held somewhere inside the Sacred Haven.'")
    wait(0.6)
    actor:send(tostring(self.name) .. " whispers to you, 'Once you find them all, I can meld two of them together to form a reward for you.'")
    wait(0.2)
    actor:send(tostring(self.name) .. " whispers to you, 'You will find a prisoner who is an ally of mine, and he might be able to help you.'")
    wait(0.6)
    actor:send(tostring(self.name) .. " tells you, 'Ask me <b:white>[what am I doing?]</> if you forget.'")
    wait(0.1)
    self:whisper(actor, "Now hurry, I need the items I have lost.")
end$trig$, '346b9cc382c7855497b45b23002b5fef'),
  -- data/triggers/590/590_13_find_key.lua
  (590, 13, $trig$-- Converted from DG Script #59013: find_key
-- Original: WORLD trigger, flags: COMMAND, probability: 4%

-- Command filter: move
if not (cmd == "move") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
if arg == "stones" then
    _return_value = false
    actor:send("You move the stone from the wall, and a bent key falls to the ground.")
    self.room:send_except(actor, tostring(actor.name) .. " moves a stone from the wall, and a bent key falls to the ground.")
    self.room:spawn_object(590, 27)
    if (actor:get_quest_var("sacred_haven:find_key") or 0) == 1 then
        actor:set_quest_var("sacred_haven", "find_key", 2)
    end
else
    _return_value = true
end
return _return_value$trig$, 'f4395e1129a0485fc5cafd5541bac63a'),
  -- data/triggers/590/590_14_find_blood.lua
  (590, 14, $trig$-- Converted from DG Script #59014: find_blood
-- Original: WORLD trigger, flags: COMMAND, probability: 100%

-- Command filter: search
if not (cmd == "search") then
    return true  -- Not our command
end
local now = timestamp()
local blood_time = actor:get_quest_var("sacred_haven:blood_time") or 0
local last
if blood_time == 0 then
    last = now - 1
else
    last = blood_time + 20
end
-- If quest hasn't been started, force the search to fail (now == last).
if actor:get_quest_stage("sacred_haven") == 0 then
    now = 0
    last = 0
end
if now > last then
    actor:send("You find a vial of dark red dragons blood setting on top of the table.")
    self.room:send_except(actor, tostring(actor.name) .. " finds a vial of dark red dragons blood setting on top of the table.")
    self.room:spawn_object(590, 28)
    actor:set_quest_var("sacred_haven", "blood_time", now)
    if (actor:get_quest_var("sacred_haven:find_blood") or 0) == 1 then
        actor:set_quest_var("sacred_haven", "find_blood", 2)
    end
else
    actor:send("You don't see anything you didn't see before.")
end$trig$, '46c203c23deac8d71dd41422c82e4ffe'),
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
                    local total = (item1 + item2 + item3 + item4)
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
return _return_value$trig$, 'c2c0f4178c1059908e0b5389c06eda8a'),
  -- data/triggers/590/590_99_sacred_haven_status_check.lua
  (590, 99, $trig$-- Converted from DG Script #59099: sacred_haven_status_check
-- Original: MOB trigger, flags: SPEECH, probability: 0% (DG marker for speech-only)
-- The 0% probability gate was DG's way of saying "speech-only"; we drop it
-- here so the SPEECH match can fire normally. Keyword set is the original
-- "what am I doing?" prompt - require all four word fragments to appear.

-- Speech phrase: what am I doing? (DG num_arg 0 = the speech contains the whole phrase, on word boundaries)
local speech_padded = " " .. string.lower(speech) .. " "
if not string.find(speech_padded, "[%s%p]what am i doing[%s%p]") then
    return true  -- Not the phrase
end
local stage = actor:get_quest_stage("sacred_haven")
local light = actor:get_quest_var("sacred_haven:given_light")
local key = actor:get_quest_var("sacred_haven:find_key")
local blood = actor:get_quest_var("sacred_haven:given_blood")
local trinket = actor:get_quest_var("sacred_haven:given_trinket")
local earring = actor:get_quest_var("sacred_haven:given_earring")
wait(0.2)
if stage == 1 and (light or 0) == 0 then
    self.room:send(tostring(self.name) .. " says, 'Prove yourself.  Bring me " .. tostring(objects.template(590, 26).name))
    self.room:send("</>from a priest on the second floor.'")
elseif stage == 1 and (light or 0) == 1 then
    self:say("Ask me about my artifacts.")
elseif stage == 2 and (key or 0) == 0 then
    self:say("Break my ally out of jail.")
    -- (empty room echo)
    self.room:send("Then bring me:")
    self.room:send("- " .. tostring(objects.template(590, 28).name))
    self.room:send("- " .. tostring(objects.template(590, 29).name))
    self.room:send("- " .. tostring(objects.template(590, 30).name))
elseif stage == 2 and (key or 0) == 1 then
    self:say("Find the key my ally stashed in the courtyard.")
    -- (empty room echo)
    self.room:send("Then bring me:")
    self.room:send("- " .. tostring(objects.template(590, 28).name))
    self.room:send("- " .. tostring(objects.template(590, 29).name))
    self.room:send("- " .. tostring(objects.template(590, 30).name))
elseif stage == 2 and (key or 0) == 2 then
    self:say("Bring me my artifacts.")
    if blood or trinket or earring then
        -- (empty room echo)
        self.room:send("You have brought me:")
        if (blood or 0) == 1 then
            self.room:send("- " .. tostring(objects.template(590, 28).name))
        end
        if (trinket or 0) == 1 then
            self.room:send("- " .. tostring(objects.template(590, 29).name))
        end
        if (earring or 0) == 1 then
            self.room:send("- " .. tostring(objects.template(590, 30).name))
        end
    end
    -- (empty room echo)
    self.room:send("You still need to find:")
    if (blood or 0) == 0 then
        self.room:send("- " .. tostring(objects.template(590, 28).name))
    end
    if (trinket or 0) == 0 then
        self.room:send("- " .. tostring(objects.template(590, 29).name))
    end
    if (earring or 0) == 0 then
        self.room:send("- " .. tostring(objects.template(590, 30).name))
    end
    wait(0.2)
    self:say("Bring me my artifacts! Chop chop!")
end$trig$, 'b24bc6a0dba77ee648c3de0c0089d44e'),
  -- data/triggers/615/615_24_wise_leprechaun_receiving_goodies.lua
  (615, 24, $trig$-- Converted from DG Script #61524: Wise leprechaun receiving goodies
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
local function obj_is(z, l)
    return object.zone_id == z and object.local_id == l
end
-- switch on object id
if obj_is(615, 1) or obj_is(120, 1) or obj_is(0, 146) or obj_is(0, 147) then
    wait(0.4)
    self:emote("sniffs " .. tostring(object.shortdesc) .. " carefully.")
    wait(1)
    self:emote("munches heartily on " .. tostring(object.shortdesc) .. ", juice running down his cheeks.")
    world.destroy(object.name)
    if actor.gender == "male" then
        self:say("Why thank you, good sir!")
    else
        self:say("Why thank you, my dear!")
    end
    wait(1)
    self:say("But that's not my favorite fruit is it, oh no.")
elseif obj_is(615, 2) then
    -- spotted apple
    wait(0.8)
    self:emote("turns " .. tostring(object.shortdesc) .. " over and peers at it thoughtfully.")
    wait(1)
    self:emote("swiftly eats " .. tostring(object.shortdesc) .. " with loud chewing noises.")
    world.destroy(object.name)
    if actor.gender == "female" then
        self:say("Well that was nice, wasn't it my darling?")
    else
        self:say("Well that was nice, wasn't it my boy?")
    end
    wait(1)
    self:say("But it just isn't what I'm looking for.")
    wait(0.4)
    self:command("sigh")
elseif obj_is(615, 3) then
    -- This is the wizened apple.
    wait(0.8)
    self:emote("stares daggers at " .. tostring(object.shortdesc) .. ", as if he'd been handed a spider.")
    wait(1)
    self:emote("angrily hurls " .. tostring(object.shortdesc) .. " off into the bushes!")
    world.destroy(object.name)
    wait(0.4)
    if actor.gender == "female" then
        self:say("Well now what's the big idea, lassie?")
    elseif actor.gender == "male" then
        self:say("Well now what's the big idea, laddie?")
    else
        self:say("Well now what's the big idea?")
    end
    wait(0.4)
    self.room:send(tostring(self.name) .. " says, 'That was an insult of a fruit, if ever there was one!'")
elseif obj_is(615, 51) then
    -- Purple cherry: leprechaun's favourite. Eats it, marks the giver
    -- (and any group-mates in the room) as ready for the knife
    -- enchantment, then waits for a flint knife.
    wait(0.8)
    self:emote("gazes lovingly at " .. tostring(object.shortdesc) .. ".")
    wait(1)
    if globals.got_cherry == 1 then
        self.room:send(tostring(self.name) .. " says, 'I've already had one of these... but I can't turn them down!'")
    end
    wait(0.4)
    globals.got_cherry = 1
    self:emote("happily pops " .. tostring(object.shortdesc) .. " into his mouth and chews gleefully!")
    wait(0.8)
    world.destroy(object.name)
    self.room:send(tostring(self.name) .. " says, '" .. tostring(actor.name) .. ", I thank you from the bottom of my heart.'")
    wait(1)
    self:say("That was a rare treat.")
    wait(2)
    self.room:send(tostring(self.name) .. " says, 'Alright then, hand me a knife and I'll enchant it for ye.'")
    -- Mark all group-mates in the room as eligible for the enchantment.
    local size = (actor.group_size or 0)
    local a = (actor.group_size and 1) or 0
    while a <= size do
        local person = actor.group_member and actor.group_member[a]
        if person and person.room == self.room then
            if person:get_quest_stage("enchanted_hollow_quest") == 0 then
                person:start_quest("enchanted_hollow_quest")
            end
            person:set_quest_var("enchanted_hollow_quest", "got_cherry", 1)
        end
        a = a + 1
    end
elseif obj_is(615, 4) then
    _return_value = false
    wait(0.8)
    self:emote("quickly shields his eyes from " .. tostring(object.shortdesc) .. "'s intense glow.")
    self:say("Ach!  Are you trying to blind me?")
    wait(0.8)
    self:command("drop " .. tostring(object.name))
elseif obj_is(615, 5) or obj_is(615, 6) then
    -- Flint knife (615,6) or already-enchanted (615,5).
    -- If the giver has fed a cherry, enchant it. Otherwise return it.
    if (actor:get_quest_var("enchanted_hollow_quest:got_cherry") or 0) == 1 then
        wait(0.8)
        -- Clear the per-group eligibility flag now that we've earned the knife.
        local size = (actor.group_size or 0)
        local a = (actor.group_size and 1) or 0
        while a <= size do
            local person = actor.group_member and actor.group_member[a]
            if person and person.room == self.room then
                if person:get_quest_stage("enchanted_hollow_quest") == 0 then
                    person:start_quest("enchanted_hollow_quest")
                end
                person:set_quest_var("enchanted_hollow_quest", "got_cherry", 0)
            end
            a = a + 1
        end
        self:say("Well now!  I suppose I owe you an enchantment!")
        wait(4)
        self:emote("turns and thrusts " .. tostring(object.shortdesc) .. " into the earth.")
        wait(2)
        self:emote("says a few magical words, then touches " .. tostring(object.shortdesc) .. " on the hilt.")
        wait(4)
        world.destroy(object.name)
        self:emote("pulls an emblazoned flint knife out of the ground.")
        self.room:spawn_object(615, 5)
        wait(2)
        self:command("give emblazoned-flint-knife " .. tostring(actor.name))
        wait(1)
        self.room:send(tostring(self.name) .. " says, 'If you see a web, just drop this nearby it.  I've given it an innate hatred of webs, you'll see!'")
    else
        _return_value = true
        self.room:send_except(actor, tostring(actor.name) .. " gives " .. tostring(object.shortdesc) .. " to " .. tostring(self.name) .. ".")
        actor:send("You give " .. tostring(object.shortdesc) .. " to " .. tostring(self.name) .. ".")
        wait(0.8)
        self:say("Eh?  What have you done for me lately?")
        wait(2)
        self.room:send(tostring(self.name) .. " gives " .. tostring(object.shortdesc) .. " back.")
    end
elseif obj_is(557, 55) then
    -- dried fruit
    _return_value = true
    self.room:send_except(actor, tostring(actor.name) .. " gives " .. tostring(object.shortdesc) .. " to " .. tostring(self.name) .. ".")
    actor:send("You give " .. tostring(object.shortdesc) .. " to " .. tostring(self.name) .. ".")
    wait(1)
    self:emote("looks wistfully at " .. tostring(object.shortdesc) .. ".")
    self.room:send(tostring(self.name) .. " says, 'Ach, what a waste.  Sorry, it's no use trying to eat this now!'")
    wait(2)
    actor:send(tostring(self.name) .. " returns " .. tostring(object.shortdesc) .. " to you.")
    self.room:send_except(actor, tostring(self.name) .. " returns " .. tostring(object.shortdesc) .. " to " .. tostring(actor.name) .. ".")
elseif obj_is(620, 76) then
    -- banana
    _return_value = true
    self.room:send_except(actor, tostring(actor.name) .. " gives " .. tostring(object.shortdesc) .. " to " .. tostring(self.name) .. ".")
    actor:send("You give " .. tostring(object.shortdesc) .. " to " .. tostring(self.name) .. ".")
    wait(0.4)
    self:emote("seems a bit perplexed.")
    self:emote("sniffs " .. tostring(object.shortdesc) .. ".")
    wait(2)
    self:say("Well now... it smells nice, doesn't it?")
    self:command("peer " .. tostring(actor.name))
    self:emote("licks " .. tostring(object.shortdesc) .. " carefully.")
    wait(3)
    self:say("I'm not sure I want to bite this, though, do I?")
    actor:send(tostring(self.name) .. " returns " .. tostring(object.shortdesc) .. " to you.")
    self.room:send_except(actor, tostring(self.name) .. " returns " .. tostring(object.shortdesc) .. " to " .. tostring(actor.name) .. ".")
else
    _return_value = true
    self.room:send_except(actor, tostring(actor.name) .. " gives " .. tostring(object.shortdesc) .. " to " .. tostring(self.name) .. ".")
    actor:send("You give " .. tostring(object.shortdesc) .. " to " .. tostring(self.name) .. ".")
    wait(0.8)
    self.room:send(tostring(self.name) .. " says, 'Now I wouldn't know what to do with this, now would I?'")
    actor:send(tostring(self.name) .. " returns " .. tostring(object.shortdesc) .. " to you.")
    self.room:send_except(actor, tostring(self.name) .. " returns " .. tostring(object.shortdesc) .. " to " .. tostring(actor.name) .. ".")
end
return _return_value$trig$, 'eb4bb5d09c59e6503b6fe59c03fe0ad0'),
  -- data/triggers/615/615_53_creeping_doom_pixie_receive.lua
  (615, 53, $trig$-- Converted from DG Script #61553: creeping_doom_pixie_receive
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
local stage = actor:get_quest_stage("creeping_doom")
local function obj_is(z, l)
    return object.zone_id == z and object.local_id == l
end
if stage == 1 then
    if obj_is(118, 12) or obj_is(162, 13) or obj_is(480, 29) then
        if (actor:get_quest_var("creeping_doom:" .. tostring(object.zone_id) .. "_" .. tostring(object.local_id)) or 0) == 1 then
            _return_value = true
            self:say("You already brought me " .. tostring(object.shortdesc) .. ".")
            actor:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
        else
            actor:set_quest_var("creeping_doom", (tostring(object.zone_id) .. "_" .. tostring(object.local_id)), 1)
            wait(0.2)
            world.destroy(object)
            self:say("Just what we need.")
            if actor:get_quest_var("creeping_doom:118_12") and actor:get_quest_var("creeping_doom:162_13") and actor:get_quest_var("creeping_doom:480_29") then
                actor:advance_quest("creeping_doom")
                wait(1)
                self:say("Yesssss... Raaaaaaage...")
                wait(2)
                self:say("Now we need all the doom!  Swarms of DOOM!!")
                wait(2)
                self.room:send(tostring(self.name) .. " says, 'Ethilien is chock-full of creepy-crawlies:")
                self.room:send("</>Flies, bugs, spiders, scorpions, giant ant creatures...")
                wait(2)
                self:say("The list goes on.")
                wait(2)
                self.room:send(tostring(self.name) .. " says, 'Creeping Doom is just swarms of these things.  You'll")
                self.room:send("</>need to gather <b:green>11 essence of swarms</> from these creatures, one for every circle")
                self.room:send("</>of magic the spell requires.'")
                wait(4)
                self.room:send(tostring(self.name) .. " says, 'Harvesting these essences'll take time and patience.")
                self.room:send("</>The more powerful the insect you kill, the more likely you'll find acceptable")
                self.room:send("</>essences.  Bring those essences to me.'")
            else
                wait(0.2)
                self:say("Where's the rest?")
            end
        end
    else
        _return_value = true
        wait(0.2)
        self:say("This isn't going to help.")
        actor:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
    end
elseif stage == 2 then
    if obj_is(615, 17) then
        wait(0.2)
        self:say("Yesssss...  More essences!")
        local spiders = (actor:get_quest_var("creeping_doom:spiders") or 0) + 1
        actor:set_quest_var("creeping_doom", "spiders", spiders)
        self:destroy_item("essence-of-swarms")
        wait(0.2)
        if spiders == 11 then
            actor:advance_quest("creeping_doom")
            self.room:send(tostring(self.name) .. " says, 'The Rage and Doom are hyped, but we need to keep 'em")
            self.room:send("</>from going too aggro.  Trophies from ending Nature's suffering'll temper them")
            self.room:send("</>into a focused, deadly weapon.  The scythe to cut down Nature's enemies...'")
            wait(3)
            self.room:send(tostring(self.name) .. " says, 'There are three particular trees that suffer in")
            self.room:send("</>unnatural agony.  Help them and bring a trophy of the experience.'")
            wait(3)
            self.room:send(tostring(self.name) .. " says, 'One is a treant plagued by invasive dogs in the")
            self.room:send("</>forest of the oldest Rhell.  Ease the tree's suffering and bring back a limb")
            self.room:send("</>as a relic of peace.'")
            wait(4)
            self.room:send(tostring(self.name) .. " says, 'Another is an eternally burning tree in the ruined")
            self.room:send("</>city Templace.  End the tree's suffering and bring back one of its burning")
            self.room:send("</>branches as a relic of succor.'")
            wait(3)
            self.room:send(tostring(self.name) .. " says, 'The final is an elder tremaen in an ancient forest")
            self.room:send("</>beset by the elemental Plane of Fire.  The tremaen carries the holy Seed of")
            self.room:send("</>the Silveroak.  Return with the Seed as a relic of the promise of new life")
            self.room:send("</>even in the face of extreme burnination.'")
        else
            local remaining = 11 - spiders
            self.room:send(tostring(self.name) .. " says, 'You have brought me " .. tostring(spiders) .. " <b:green>essence of swarms</>.")
            self.room:send(tostring(remaining) .. " more to go.'")
        end
    else
        _return_value = true
        self:say("This isn't a swarm!!")
        actor:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
    end
elseif stage == 3 then
    if obj_is(484, 16) or obj_is(520, 34) or obj_is(625, 3) then
        if (actor:get_quest_var("creeping_doom:" .. tostring(object.zone_id) .. "_" .. tostring(object.local_id)) or 0) == 1 then
            _return_value = true
            self:say("You already found this.")
            actor:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
        else
            actor:set_quest_var("creeping_doom", (tostring(object.zone_id) .. "_" .. tostring(object.local_id)), 1)
            wait(1)
            self:say("This is it!")
            world.destroy(object)
            if actor:get_quest_var("creeping_doom:484_16") and actor:get_quest_var("creeping_doom:520_34") and actor:get_quest_var("creeping_doom:625_3") then
                self:say("These are all the parts we need!")
                actor:advance_quest("creeping_doom")
                wait(1)
                self.room:send(tostring(self.name) .. " ties the bit of vine to the treant limb.")
                wait(2)
                self.room:send("Using the burning branch, she lights the vine on fire and crushes the scarab and spider.")
                wait(3)
                self.room:send(tostring(self.name) .. " sprinkles the Seed of the Silveroak with the ash mixture.")
                wait(1)
                self.room:send("One by one " .. tostring(self.name) .. " blows the essences of swarms onto the Seed of the Silveroak.")
                wait(2)
                self.room:send("The Seed of the Silveroak glows <green>green</> and <red>red</>!")
                wait(1)
                self.room:spawn_object(615, 18)
                self:command("give essence-natures-vengeance " .. tostring(actor.name))
                wait(2)
                -- (empty say)
                self.room:send(tostring(self.name) .. " says, 'Now to rain doom on the doomed heads of our doomed")
                self.room:send("</>enemies!'")
                wait(2)
                self:say("In the Black Woods is a logging camp clearcutting the forest.")
                wait(2)
                self.room:send(tostring(self.name) .. " says, 'Take this new seed and drop it at the")
                self.room:send("</><b:white>entrance to the logging camp</>.'")
                wait(3)
                self.room:send(tostring(self.name) .. " says, 'Death will wash over the camp and annihilate")
                self.room:send("</>everything there.  Stay and watch.  Hear every last scream.  Feel")
                self.room:send("</>every last death.  Then you'll understand Creeping Doom.'")
                wait(4)
                self:say("That is the strength of Nature's vengeance.")
                wait(4)
                self:say("Once you've done the deed, come back.")
            else
                wait(1)
                self:say("Help the other trees and bring the trophies to me.")
            end
        end
    else
        _return_value = true
        self:say("The heck is this??")
        actor:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
    end
else
    _return_value = true
    self:say("The heck is this??")
    actor:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
end
return _return_value$trig$, 'e7831f6a311faa4e19ebc722a55e0f95'),
  -- data/triggers/625/625_25_rhell_merchant_receive_2-1.lua
  (625, 25, $trig$-- Converted from DG Script #62525: Rhell Merchant receive 2-1
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
-- for path 1, after pepper, the merchant needs a plant, found in the form of 'a bit of bones and plants' from blue fog trail.
if actor:get_quest_stage("ursa_quest") == 2 then
    if (actor:get_quest_var("ursa_quest:choice") or 0) == 1 then
        if object.zone_id == 237 and object.local_id == 55 then
            wait(0.2)
            actor:advance_quest("ursa_quest")
            world.destroy(object)
            wait(1)
            self:say("Good!  You managed to find some pepper.")
            wait(1)
            self:say("I've been looking over this next item, and it should be a lot less hassle.")
            wait(2)
            self:say("Just west of here, there is a plant that roots to sticks and rocks, and even beings if they hold still long enough.  I need some of that plant.  It shouldn't be too hard.")
            wait(1)
            self:say("... I think.")
        else
            _return_value = true
            self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
            wait(1)
            self:say("This isn't what I need right now.  Please bring me some pepper.")
        end
    end
end
return _return_value$trig$, '2de684485a158d042e2f7a6a222d4dcc'),
  -- data/triggers/625/625_26_rhell_merchant_receive_2-2.lua
  (625, 26, $trig$-- Converted from DG Script #62526: Rhell Merchant receive 2-2
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
-- Path 2: if the golden sceptre is returned, the merchant asks for the sunstone diadem from tech.
if actor:get_quest_stage("ursa_quest") == 2 then
    if (actor:get_quest_var("ursa_quest:choice") or 0) == 2 then
        if object.zone_id == 162 and object.local_id == 1 then
            wait(0.2)
            world.destroy(object)
            actor:advance_quest("ursa_quest")
            wait(0.1)
            self:emote("runs his hand down the shaft of the golden sceptre.")
            wait(2)
            self:say("What power!")
            wait(2)
            self:say("The king also wore an emblem of the sun.")
            wait(1)
            self:say("Ruin believes this emblem to be the very one written of in the legends of the warring gods in the far north.")
            wait(2)
            self:say("I feel the sceptre longing for it.  Find the sunstone and bring it to me.")
        else
            _return_value = true
            self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
            wait(1)
            self:say("This isn't the king's golden sceptre.")
        end
    end
end
return _return_value$trig$, 'b757f449808e00d8e15fc484812ef1f5'),
  -- data/triggers/625/625_27_rhell_merchant_receive_2-3.lua
  (625, 27, $trig$-- Converted from DG Script #62527: Rhell Merchant receive 2-3
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
-- Path 3: ring of stolen life is returned, merchant asks for the golden druidstaff
if actor:get_quest_stage("ursa_quest") == 2 then
    if (actor:get_quest_var("ursa_quest:choice") or 0) == 3 then
        if object.zone_id == 125 and object.local_id == 38 then
            wait(0.2)
            world.destroy(object)
            actor:advance_quest("ursa_quest")
            wait(1)
            self:emote("looks at the ring.")
            self:say("Incredible!  I can feel it's magic working!")
            wait(2)
            self:say("Now I need the... gothen droolstall?  I can't read his chicken scratch!  But he says it's in the Highlands, with \"their\" leader.")
            wait(1)
            self:command("blink")
            wait(2)
            -- Orphaned text: Who's leader?!
            wait(1)
            self:command("grumble")
            self:say("I guess you'll just have to search the Highlands.  Let me know when you figure out what the hermit meant.")
        else
            _return_value = true
            self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
            wait(1)
            self:say("I don't think this is the ring...")
        end
    end
end
return _return_value$trig$, 'fc46c5c5fe64b3449c655c136757e9c0'),
  -- data/triggers/625/625_28_rhell_merchant_receive_3-1.lua
  (625, 28, $trig$-- Converted from DG Script #62528: Rhell Merchant receive 3-1
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
-- for path 1, after the plant, comes the thorny staff, from The Citadel of Betrayal.
if actor:get_quest_stage("ursa_quest") == 3 then
    if (actor:get_quest_var("ursa_quest:choice") or 0) == 1 then
        if object.zone_id == 118 and object.local_id == 10 then
            wait(0.2)
            actor:advance_quest("ursa_quest")
            wait(1)
            self:emote("looks at " .. tostring(object.shortdesc) .. ".")
            world.destroy(object)
            wait(1)
            self:say("What an odd item to have rooted itself to.")
            self:command("chuckle")
            wait(1)
            self:say("Now, I need a particular thorny wood.  Because of it's unpleasant nature there are some unpleasant people that make staves and walking sticks out of it.")
            wait(1)
            self:say("Please find one, and bring it back here.  I have almost everything called for on these instructions.")
        else
            _return_value = true
            self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
            wait(1)
            self:say("This isn't it.  What I'm after right now is a plant from the Blue-Fog Trail that binds itself to just about anything.")
        end
    end
end
return _return_value$trig$, 'caa7f017076770384ebda8f94f5a49dc'),
  -- data/triggers/625/625_29_rhell_merchant_receive_3-2.lua
  (625, 29, $trig$-- Converted from DG Script #62529: Rhell Merchant receive 3-2
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
-- Path 2: after bringing the sunstone diadem, merchant asks for the radiant dagger, an mload in sacred haven
if actor:get_quest_stage("ursa_quest") == 3 then
    if (actor:get_quest_var("ursa_quest:choice") or 0) == 2 then
        if object.zone_id == 550 and object.local_id == 14 then
            wait(0.2)
            actor:advance_quest("ursa_quest")
            world.destroy(object)
            wait(1)
            self:emote("inspects the stone.")
            wait(2)
            self:say("You are quite resourceful.  This was the ancient king's pendant.")
            wait(2)
            self:say("It is said the sunstone captured the sun's light over 2 ages.  Now it shines with that stolen light.")
            wait(3)
            self:say("There is a dagger that the king used that does quite the opposite.")
            wait(3)
            self:say("It absorbs no light, it seems, but is made of such fine gold and gems that it radiates light.  The priests of South Caelia recognize its fierce beauty.  You will find it there still.")
        else
            _return_value = true
            self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
            wait(1)
            self:say("This isn't the sunstone.  Find and return it.")
        end
    end
end
return _return_value$trig$, '80de5c54b9f300d9bbed2021b8988ab2'),
  -- data/triggers/625/625_30_rhell_merchant_receive_3-3.lua
  (625, 30, $trig$-- Converted from DG Script #62530: Rhell Merchant receive 3-3
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
-- Path 3: after the druidstaff, the merchant asks for milk
if actor:get_quest_stage("ursa_quest") == 3 then
    if (actor:get_quest_var("ursa_quest:choice") or 0) == 3 then
        if object.zone_id == 163 and object.local_id == 5 then
            wait(0.2)
            actor:advance_quest("ursa_quest")
            world.destroy(object)
            wait(1)
            self:say("Oh, Golden Druidstaff!  Well, now that makes a lot of sense.")
            wait(1)
            self:say("Now we are to crush up this ring, and put the powder in milk.  Please, bring me some milk.")
        else
            _return_value = true
            self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
            wait(1)
            self:say("I don't think this is the Golhen DrubStatt the hermit had in mind.")
        end
    end
end
return _return_value$trig$, '449b2ccaf6e382578b89a3dea4b3cb10'),
  -- data/triggers/625/625_31_rhell_merchant_receive_4-1.lua
  (625, 31, $trig$-- Converted from DG Script #62531: Rhell Merchant receive 4-1
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
-- for path 1, the merchant thinks he's done, but realizes he needs a pitcher to pour water over the other items.
if actor:get_quest_stage("ursa_quest") == 4 then
    if (actor:get_quest_var("ursa_quest:choice") or 0) == 1 then
        if object.zone_id == 85 and object.local_id == 16 then
            wait(0.2)
            actor:advance_quest("ursa_quest")
            world.destroy(object)
            wait(1)
            self:say("Excellent!  Now I have everything I need: the pepper, the plant, the staff, this spring's water...")
            wait(2)
            self:emote("stares blankly at the spring.")
            wait(3)
            self:say("So...")
            wait(1)
            self:say("I need to get the water in something functional.  Can you go get a pitcher?  That would do the job wonderfully.")
            self:command("smile " .. tostring(actor))
        else
            _return_value = true
            self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
            wait(1)
            self:say("This isn't the thorny wood I need.")
        end
    end
end
return _return_value$trig$, '4261a0e6db8e7cf64139ce5d7c5c42e4'),
  -- data/triggers/625/625_32_rhell_merchant_receive_4-2.lua
  (625, 32, $trig$-- Converted from DG Script #62532: Rhell Merchant receive 4-2
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
-- for path 2, the merchant asks for hard liquor - firebreather is best.
if actor:get_quest_stage("ursa_quest") == 4 then
    if (actor:get_quest_var("ursa_quest:choice") or 0) == 2 then
        if object.zone_id == 590 and object.local_id == 12 then
            wait(0.2)
            world.destroy(object)
            actor:advance_quest("ursa_quest")
            wait(1)
            self:say("Fantastic.  Rylee knew it had too much power to be wielded by just anyone.  Only this dagger can end the curse inside me.")
            wait(1)
            self:say("Now, it says here that the king was placed in his sarcophagus and slew the beast inside himself.")
            wait(2)
            self:say("I'm willing to do that... but not sober.  Fetch me something to drink, and make it strong!")
        else
            _return_value = true
            self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
            wait(1)
            self:say("What is this garbage?  I need the king's jeweled dagger.  Only it has the radiant power to kill the beast.")
        end
    end
end
return _return_value$trig$, '7907c6b8ba5ea0ff63a04a0314198132'),
  -- data/triggers/625/625_33_rhell_merchant_receive_4-3.lua
  (625, 33, $trig$-- Converted from DG Script #62533: Rhell Merchant receive 4-3
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
if actor:get_quest_stage("ursa_quest") == 4 then
    if (actor:get_quest_var("ursa_quest:choice") or 0) == 3 then
        -- for path 3, the merchant asks for an anvil
        -- note - the anvil is extremely heavy but must be picked up and given to the merchant to complete the quest; it cannot just be dragged to him.
        if object.type == "DRINKCONTAINER" then
            if object.val2 == 10 then
                wait(0.2)
                world.destroy(object)
                actor:advance_quest("ursa_quest")
                wait(1)
                self:say("Excellent.  Now to crush this ring...")
                self:emote("drops the ring of stolen life.")
                self:emote("wields the Golden Druidstaff.")
                wait(3)
                self.room:send("<b:green>" .. tostring(self.name) .. " </><green>SMACKS<b:green> the ring, which </><green>bounces<b:green> and lands lightly back on the dirt.</>")
                wait(3)
                self:command("blink")
                wait(3)
                self.room:send("<b:green>" .. tostring(self.name) .. " </><green>SMACKS<b:green> the ring, which </><green>bounces<b:green> and lands lightly back on the dirt.</>")
                wait(3)
                self:command("grumble")
                self.room:send(tostring(self.name) .. " says, This isn't going to work.  Off the Great Road is a lumber mill.  Their smith has an anvil that will do perfectly.")
            else
                wait(0.2)
                self.room:send(tostring(self.name) .. " examines " .. tostring(object.shortdesc) .. ".")
                wait(1)
                self:say("Good, now put some milk in this, and bring it to me again.")
                self:command("give " .. tostring(object) .. " " .. tostring(actor) .. ".")
            end
        else
            _return_value = true
            self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
            wait(1)
            self:say("I'm not sure how one gets milk out of this.")
        end
    end
end
return _return_value$trig$, '84e437b95dc4c7e7954f307a4ab2f96d'),
  -- data/triggers/625/625_34_rhell_merchant_receive_5-1.lua
  (625, 34, $trig$-- Converted from DG Script #62534: Rhell Merchant receive 5-1
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
-- final step on good quest: either the pitcher from dancing dolphin or hot springs will work; merchant is healed and the thorny staff transforms into the redeeming staff.
if actor:get_quest_stage("ursa_quest") == 5 then
    if (actor:get_quest_var("ursa_quest:choice") or 0) == 1 then
        if (object.zone_id == 103 and object.local_id == 9) or (object.zone_id == 587 and object.local_id == 6) then
            wait(1)
            world.destroy(object)
            actor:advance_quest("ursa_quest")
            wait(1)
            run_room_trigger(625, 50)
        else
            _return_value = true
            self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
            wait(1)
            self:say("This just won't work.  Really, what I need is a pitcher, so I can quickly and accurately pour a large amount of water.")
        end
    end
end
return _return_value$trig$, 'd0010fc4bab4b04be0dab4aea996c215'),
  -- data/triggers/625/625_35_rhell_merchant_receive_5-2.lua
  (625, 35, $trig$-- Converted from DG Script #62535: Rhell Merchant receive 5-2
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
if actor:get_quest_stage("ursa_quest") == 5 then
    if (actor:get_quest_var("ursa_quest:choice") or 0) == 2 then
        -- extra step for evil path: merchant drinks and asks for a big bag - either a saddle or the tattered bag will work
        if object.type == "DRINKCONTAINER" then
            wait(1)
            self:command("drink " .. tostring(object))
            wait(1)
            if object.val2 == 7 then
                self:say("This is the good stuff!")
                actor:advance_quest("ursa_quest")
                wait(1)
                self:command("drink " .. tostring(object))
                wait(1)
                self:say("Okay...  Now I'm ready.  All I need now is something to kill myself in.")
                wait(1)
                self:emote("looks around for a makeshift sarcophagus.")
                wait(2)
                self:say("Do you have something big enough for me to fit in?  Like a big box or a bag or something?")
            else
                self:command("spit " .. tostring(actor.name))
                wait(1)
                self:say("This isn't going to cut it, kid.")
                wait(2)
                self:say("Got anything stronger?")
                self:command("give " .. tostring(object) .. " " .. tostring(actor.name))
            end
        else
            _return_value = true
            self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
            wait(1)
            self:say("I'm looking for a drink.  A strong one!")
        end
    end
end
return _return_value$trig$, 'ac3c10e1c341d9303c65d1e844672f7b'),
  -- data/triggers/625/625_36_rhell_merchant_receive_5-3.lua
  (625, 36, $trig$-- Converted from DG Script #62536: Rhell Merchant receive 5-3
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
-- final step on neutral quest: merchant turns into Ursa and fights!
-- note - the anvil is extremely heavy but must be picked up and given to the merchant to complete the quest; it cannot just be dragged to him.
if actor:get_quest_stage("ursa_quest") == 5 then
    if (actor:get_quest_var("ursa_quest:choice") or 0) == 3 then
        if object.zone_id == 87 and object.local_id == 2 then
            wait(0.2)
            world.destroy(object)
            actor:advance_quest("ursa_quest")
            wait(1)
            run_room_trigger(625, 50)
        else
            _return_value = true
            self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
            wait(1)
            self:say("This won't do the job.  I need the anvil.")
        end
    end
end
return _return_value$trig$, 'ab9808f51875d9e35a62b67fbe31e3a7'),
  -- data/triggers/625/625_37_rhell_merchant_receive_6.lua
  (625, 37, $trig$-- Converted from DG Script #62537: Rhell Merchant receive 6
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
if actor:get_quest_stage("ursa_quest") == 6 then
    if (actor:get_quest_var("ursa_quest:choice") or 0) == 2 then
        if object.type == "CONTAINER" then
            wait(0.2)
            self.room:send(tostring(self.name) .. " examines " .. tostring(object.shortdesc) .. ".")
            if object.val0 > 120 then
                -- The following regular items can be picked up and have large enough values: 3147, 16102, 55029
                wait(0.2)
                world.destroy(object)
                run_room_trigger(625, 50)
            else
                wait(1)
                self:command("shake")
                self:say("I don't think I can fit in here.")
                self:command("give " .. tostring(object) .. " " .. tostring(actor))
            end
        else
            _return_value = true
            self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
            wait(1)
            self:say("I need a body-bag or a large chest...")
        end
    end
end
return _return_value$trig$, 'b3ca38b12762a84c77a7d24da335e06d'),
  -- data/triggers/625/625_50_quest_room.lua
  (625, 50, $trig$-- Converted from DG Script #62550: quest room
-- Original: WORLD trigger, flags: GLOBAL, probability: 100%
--
-- Called from 625_34/35/36/37 once the player has handed in the
-- final quest item. `self` is the room. Locate the player who
-- is at stage 6 of ursa_quest and run the matching cinematic.
local quester
for _, person in ipairs(self.actors) do
    if person.is_player and person:get_quest_stage("ursa_quest") == 6 then
        quester = person
        break
    end
end
if not quester then
    self.room:find_actor("mild"):say("Where did you go?")
    return true
end
if quester:get_quest_stage("ursa_quest") == 6 then
    -- now find the right script to run, based on that players questvar: choice
    if (quester:get_quest_var("ursa_quest:choice") or 0) == 1 then
        wait(0.5)
        self.room:send("The mild mannered merchant says, 'Fantastic.  Now let's see what miracle the Emperor has found.'")
        self.room:find_actor("mild"):emote("digs a slight divot into the ground with the end of the thorny staff.")
        self.room:find_actor("mild"):emote("places the pepper and plant into the divot.")
        self.room:find_actor("mild"):emote("leaves the thorny staff standing erect out of the ground.")
        wait(2)
        self.room:find_actor("mild"):command("hold pitcher")
        self.room:find_actor("mild"):command("pour pitcher out")
        self.room:find_actor("mild"):emote("gently fills the pitcher from the Sacred Spring.")
        wait(1)
        self.room:find_actor("mild"):emote("pours sacred water over the thorny staff.")
        self.room:send("The ground at the base of the staff quickly soaks up the water as it trickles down.")
        wait(3)
        self.room:send("At the base of the <white>thorny staff</> <b:green>life</> breaks forth!")
        self.room:send("A <green>vine</> crawls up the <white>staff</>, weaving between the <white>thorns</>.")
        wait(1)
        self.room:send("The <green>vine completely covers the </><white>thorny</> <green>staff.</>")
        wait(2)
        self.room:send("The mild mannered merchant reaches out his hand and grasps the <white>thorny</> <green>staff</>.")
        self.room:send("The <green>vine</> soaks up the <red>blood</> as the <white>thorns</> pierce the merchant's hand.")
        wait(2)
        self.room:send("<yellow>The merchant contorts wildly, shifting unevenly between man and beast, but retains his grasp on the <green>staff.</>")
        wait(2)
        self.room:send("The mild mannered merchant removes his wounded hand, and the <green>vine</> recedes back into the earth, taking with it the blood and the thorns.")
        self.room:find_actor("mild"):emote("takes a moment to catch his breath.")
        wait(3)
        self.room:find_actor("merchant"):emote("pulls <green>The Redeeming Staff</> from the ground.")
        -- load staff and give it to the player
        wait(2)
        self.room:spawn_object(625, 9)
        self.room:find_actor("mild"):command("get staff")
        self.room:find_actor("mild"):emote("runs his hand down the smooth staff.")
        wait(2)
        self.room:send("The mild mannered merchant says, 'I can not thank you enough!  I have myself back!'")
        wait(1)
        self.room:find_actor("mild"):command("give staff " .. tostring(quester))
        self.room:send("The mild mannered merchant says, 'I feel a lot of power in this staff.  I hope it can serve you well.'")
        wait(2)
        self.room:find_actor("mild"):say("And have these as a show of my gratitude.")
        for _ = 1, 3 do
            self.room:find_actor("mild"):spawn_object(557, 36 + random(1, 11))
        end
        self.room:find_actor("mild"):command("give all.gem " .. tostring(quester))
        self.room:find_actor("mild"):command("tip " .. tostring(quester))
        self.room:find_actor("mild"):emote("leaves north toward Blue Fog Trail.")
        world.destroy(self.room:find_actor("merchant"))
    elseif (quester:get_quest_var("ursa_quest:choice") or 0) == 2 then
        wait(1)
        self.room:find_actor("mild"):say("Good enough.")
        self.room:find_actor("mild"):command("wear " .. tostring(object))
        self.room:find_actor("mild"):command("drink firebreather")
        wait(2)
        self.room:find_actor("mild"):emote("suddenly falls face-down on the ground, holding the dagger in place.")
        self.room:send("The dagger drives home!")
        wait(1)
        self.room:send("The mild mannered merchant contorts wildly, flashing, his form unclear.")
        wait(1)
        self.room:send("More beast than man, <yellow>Ursa roars in pain,</> the dagger gleaming in his heart.")
        wait(2)
        self.room:find_actor("mild"):emote("slumps silently to the ground, and the dagger clatters to the ground beside him.")
        wait(5)
        self.room:find_actor("mild"):command("groan")
        wait(3)
        self.room:find_actor("mild"):emote("looks himself up down.")
        wait(1)
        self.room:find_actor("mild"):say("It worked!  I did it!")
        wait(1)
        self.room:find_actor("mild"):emote("removes each of the king's items, many of them having undergone radical changes in the ordeal.")
        self.room:find_actor("mild"):emote("tosses them one by one into the pool, letting them sink to the bottom.")
        wait(1)
        self.room:find_actor("mild"):say("Thanks, pal!")
        self.room:find_actor("mild"):emote("disappears up the trail toward Blue-Fog Trail.")
        world.destroy(self.room:find_actor("mild"))
        wait(2)
        self.room:send("on the banks of the pool, something catches your eye.")
        wait(1)
        self.room:send("The diadem, having formed into hollow but hard glass, washes to the shore.")
        self.room:send("Upon second inspection you can see the form of the enraged Ursa, as if it were trying to escape its new glass home.")
        self.room:send("Several glittering gems wash up along with it.")
        for _ = 1, 3 do
            self.room:spawn_object(557, 36 + random(1, 11))
        end
        self.room:spawn_object(625, 8)
    elseif (quester:get_quest_var("ursa_quest:choice") or 0) == 3 then
        wait(1)
        self.room:find_actor("mild"):emote("tosses the anvil to the ground with a grunt.")
        wait(3)
        self.room:find_actor("mild"):emote("places the ring of stolen life on the anvil.")
        wait(1)
        self.room:find_actor("mild"):emote("wields the Golden Druidstaff.")
        wait(3)
        self.room:send("<b:green>The mild mannered merchant </><b:red>CRUSHES</><b:green> the ring of stolen life with a swift blow.</>")
        wait(2)
        self.room:find_actor("mild"):emote("gathers the powdered ring into the milk, gives it a swirl, and drinks the milk to the last drop.")
        wait(2)
        self.room:send("The mild mannered merchant says, 'That should do the job.  I'm feeling better already!'")
        wait(4)
        self.room:send("You hear a deep grumbling, from the direction of the merchant.")
        wait(4)
        self.room:find_actor("merchant"):emote("frantically pulls a misty blue sword from his things.")
        self.room:send("The mild mannered merchant says, 'It's coming back!  I don't think I'll be able to regain control!'")
        self.room:send("A mild mannered merchant falls on his own sword! (<b:red>564</>)")
        wait(2)
        self.room:send("<yellow>A mild mannered merchant lets out a disturbing <blue>ROAR</><yellow> as the last of his humanity slips away.</>")
        world.destroy(self.room:find_actor("mild"))
        self.room:spawn_mobile(625, 50)
        self.room:spawn_object(625, 7)
        self.room:find_actor("ursa"):command("get sword")
        self.room:find_actor("ursa"):command("wi sword")
        for _ = 1, 3 do
            self.room:find_actor("ursa"):spawn_object(557, 36 + random(1, 11))
        end
    end
    --
    -- Compute experience reward, capped at level 50, scaled by class.
    --
    local expcap
    if quester.level < 50 then
        expcap = quester.level
    else
        expcap = 50
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
    --
    -- Adjust exp award by class so all classes receive the same proportionate amount.
    --
    if quester.class == "warrior" or quester.class == "berserker" then
        -- 110% of standard
        expmod = expmod + (expmod / 10)
    elseif quester.class == "paladin" or quester.class == "anti-paladin" or quester.class == "ranger" then
        -- 115% of standard
        expmod = expmod + ((expmod * 2) / 15)
    elseif quester.class == "sorcerer" or quester.class == "pyromancer" or quester.class == "cryomancer" or quester.class == "illusionist" or quester.class == "bard" then
        -- 120% of standard
        expmod = expmod + (expmod / 5)
    elseif quester.class == "necromancer" or quester.class == "monk" then
        -- 130% of standard
        expmod = expmod + ((expmod * 2) / 5)
    end
    quester:send("<b:yellow>You gain experience!</>")
    local setexp = expmod * 10
    for _ = 1, 10 do
        quester:award_exp(setexp)
    end
    quester:complete_quest("ursa_quest")
end$trig$, '9309947536a3e9d1833ec9ebe6636e7a'),
  -- data/triggers/625/625_99_progress_trigger.lua
  (625, 99, $trig$-- Converted from DG Script #62599: Progress trigger
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"progress", "progress?"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
local stage = actor:get_quest_stage("ursa_quest")
local path = actor:get_quest_var("ursa_quest:choice")
wait(0.2)
if actor:get_has_completed("ursa_quest") then
    self.room:send(tostring(self.name) .. " says, 'You have brought me the remedy, and I thank you")
    self.room:send("</>for that.'")
    wait(1)
    if (path or 0) == 1 then
        self:say("I hope the Redeeming Staff was a good reward.")
    elseif (path or 0) == 2 then
        self:say("I hope the glass bear was a good reward.")
    elseif (path or 0) == 3 then
        self:say("I hope the misty blue sword was a good reward.")
    end
    return true
end
if stage == 0 then
    self:say("Will you help me?!  Please!")
elseif stage == 1 then
    if (path or 0) == 0 then
        self.room:send(tostring(self.name) .. " says, 'Please visit one of these powerful people, and")
        self.room:send("</>ask for a cure:'")
        self.room:send("The Emperor, on a nearby island of very refined people")
        self.room:send("Ruin Wormheart in the Red City")
        self.room:send("The crazy hermit of the swamps")
    end
    -- Stage 2 checks
elseif stage == 2 then
    if (path or 0) == 1 then
        self:say("Please bring me some pepper.")
    elseif (path or 0) == 2 then
        self.room:send(tostring(self.name) .. " says, 'You need to return to me a particular sceptre")
        self.room:send("</>of gold that symbolized a king's undying leadership.'")
    elseif (path or 0) == 3 then
        self.room:send(tostring(self.name) .. " says, 'A devourer has a ring with power to heal.")
        self.room:send("</>Please bring me this ring.'")
    end
    -- stage 3 checks
elseif stage == 3 then
    if (path or 0) == 1 then
        self.room:send(tostring(self.name) .. " says, 'Please bring me a plant, found as \"a bit of")
        self.room:send("</>bones and plants\" from Blue-Fog Trail.'")
    elseif (path or 0) == 2 then
        self.room:send(tostring(self.name) .. " says, 'Please bring me an emblem of a king's power.")
        self.room:send("</>An emblem of the sun.  The one written of in legends of the warring gods in the")
        self.room:send("</>far north.'")
    elseif (path or 0) == 3 then
        self.room:send(tostring(self.name) .. " says, 'Find the Golhen DrubStatt the hermit wrote")
        self.room:send("</>about from the Highlands, and bring it back to me quickly.'")
    end
    -- stage 4 checks
elseif stage == 4 then
    if (path or 0) == 1 then
        self.room:send(tostring(self.name) .. " says, 'I need a particular thorny wood.  Because of")
        self.room:send("</>it's unpleasant nature there are some unpleasant people that make staffs and")
        self.room:send("</>walking sticks out of it.  Please find one, and bring it back here.'")
    elseif (path or 0) == 2 then
        self.room:send(tostring(self.name) .. " says, 'Please bring be the dagger that radiates")
        self.room:send("</>glorious light.  The priests of South Caelia know its fierce beauty.'")
    elseif (path or 0) == 3 then
        self:say("Bring me milk, in any container.")
    end
    -- stage 5 checks
elseif stage == 5 then
    if (path or 0) == 1 then
        self.room:send(tostring(self.name) .. " says, 'Bring me a pitcher from the hot springs or the")
        self.room:send("</>Dancing Dolphin Inn.  Either will do.'")
    elseif (path or 0) == 2 then
        self.room:send(tostring(self.name) .. " says, 'I can't do this sober!  Fetch me something to")
        self.room:send("</>drink, and make it strong!'")
    elseif (path or 0) == 3 then
        self.room:send(tostring(self.name) .. " says, 'Off of the great road is a lumber mill.  Their")
        self.room:send("</>smith has an anvil that will do our work perfectly.  Please fetch it for me.'")
    end
    -- stage 6 checks
elseif stage == 6 then
    if (path or 0) == 2 then
        self.room:send(tostring(self.name) .. " says, 'I need a large container for a sarcophagus,")
        self.room:send("</>like a body-bag or a large chest.'")
    end
end$trig$, 'f684c3da24eb9828b0979f54dca9bc17')
) AS v(zone_id, id, commands, old_md5)
WHERE t.zone_id = v.zone_id
  AND t.id = v.id
  AND md5(t.commands) = v.old_md5
  AND t.commands IS DISTINCT FROM v.commands;

COMMIT;
