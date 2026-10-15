-- Script hygiene: undefined-global reads (heshe/hisher pronouns, damdone, yes/no literals, branch-scoped locals hoisted, room guard, questname typo, class literals) and boolean arithmetic in the guild-armor journals (scripts/gen_trigger_patch_sql.py HEAD=f06e2ef). The md5 guards are the bodies at fierylib f06e2ef.
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
  -- data/triggers/001/001_19_vampiric_weapon_effect.lua
  (1, 19, $trig$-- Converted from DG Script #119: vampiric weapon effect
-- Original: OBJECT trigger, flags: ATTACK, probability: 3%

-- 3% chance to trigger
if not percent_chance(3) then
    return true
end
actor:send("A <b:black>black haze</> forms around your sword as you strike " .. tostring(victim.name) .. "!")
victim:send("A <b:black>black haze</> forms around " .. tostring(actor.name) .. "'s sword as " .. tostring(actor.heshe) .. " strikes you!")
spells.cast(self, "vampiric breath", victim, actor.level)$trig$, '06a5b881ca8274a13a07b4060876b8b6'),
  -- data/triggers/004/004_08_griffin_quest_progress_journal.lua
  (4, 8, $trig$-- Converted from DG Script #408: Griffin quest progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local status
local _return_value = true  -- Default: allow action
if string.find(arg, "griffin") or string.find(arg, "destroy") or string.find(arg, "cult") or string.find(arg, "destroy_the_cult_of_the_griffin") or string.find(arg, "griffin_quest") or string.find(arg, "griffin_island_quest") or string.find(arg, "griffin_island") or string.find(arg, "griffin island quest") then
    if actor.level >= 45 then
        _return_value = true
        local stage = actor:get_quest_stage("griffin_quest")
        actor:send("<b:u:green>Destroy the Cult of the Griffin</>")
        actor:send("Recommended Level: 60")
        status = nil
        if actor:get_has_completed("griffin_quest") then
            status = "Completed!"
        elseif (stage or 0) > 0 then
            status = "In Progress"
        else
            status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
        if stage > 0 and not actor:get_has_completed("griffin_quest") then
            actor:send("Quest Master: " .. tostring(mobiles.template(490, 8).name))
            actor:send("</>")
            actor:send(tostring(mobiles.template(490, 8).name) .. " has told you:")
            -- switch on stage
            do
                local _sw1 = string.lower(tostring(stage or ""))
                if tonumber(_sw1) == 1 then
                    actor:send("The sword used to cut the oak is also critical.  Bring the eldest druid the mystic sword from the wreck of the St. Marvin.")
                elseif tonumber(_sw1) == 2 then
                    actor:send("You'll need oracular guidance.  Go to the Seer and say <b:white>\"Earle sends me\"</>.")
                elseif tonumber(_sw1) == 3 then
                    actor:send("Get assistance from the strongest person on the island.  Find Derceta and return her crystal earring to her.")
                elseif tonumber(_sw1) == 4 then
                    actor:send("The entrance to the cult's lair is hidden under a massive boulder.  Find Derceta again and ask her to move the boulder.")
                elseif tonumber(_sw1) == 5 then
                    actor:send("Find the cult's altar and destroy it.  Go into the cave Derceta unearthed and drop the sapling at the cult's altar.")
                elseif tonumber(_sw1) == 6 then
                    actor:send("It is time to destroy the cult!  Slay Dagon!")
                elseif tonumber(_sw1) == 7 then
                    actor:send("Now you can strike the final blow and destroy the essence of the god of the cult itself.  Give the griffin skin to Awura, then seek out the hidden entrance to the other realms and destroy Adramalech.")
                end
            end
        elseif (stage or 0) == 0 then
            actor:send("Find the wreck of the St. Marvin and bring the cutting of the sacred oak to the eldest druid.")
        end
    end
end
return _return_value$trig$, 'adc0b1cc4aff3f6f0c9a57954e7af56c'),
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
        local unrewarded = ((((got_hands or 0) + (hands_count or 0)) ~= 4) and 1 or 0) + ((((got_feet or 0) + (feet_count or 0)) ~= 4) and 1 or 0) + ((((got_wrist or 0) + (wrist_count or 0)) ~= 4) and 1 or 0)
        unrewarded = unrewarded + ((((got_head or 0) + (head_count or 0)) ~= 4) and 1 or 0) + ((((got_arms or 0) + (arms_count or 0)) ~= 4) and 1 or 0)
        unrewarded = unrewarded + ((((got_legs or 0) + (legs_count or 0)) ~= 4) and 1 or 0) + ((((got_body or 0) + (body_count or 0)) ~= 4) and 1 or 0)
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
        if given == 0 then
            actor:send("You haven't retrieved anything yet.")
            return _return_value
        elseif unrewarded > 0 then
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
return _return_value$trig$, '1a1aaad258dc94422f808d7c942f1f27'),
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
        local unrewarded = ((((got_hands or 0) + (hands_count or 0)) ~= 4) and 1 or 0) + ((((got_feet or 0) + (feet_count or 0)) ~= 4) and 1 or 0) + ((((got_wrist or 0) + (wrist_count or 0)) ~= 4) and 1 or 0)
        unrewarded = unrewarded + ((((got_head or 0) + (head_count or 0)) ~= 4) and 1 or 0) + ((((got_arms or 0) + (arms_count or 0)) ~= 4) and 1 or 0)
        unrewarded = unrewarded + ((((got_legs or 0) + (legs_count or 0)) ~= 4) and 1 or 0) + ((((got_body or 0) + (body_count or 0)) ~= 4) and 1 or 0)
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
        if given == 0 then
            actor:send("You haven't retrieved anything yet.")
            return _return_value
        elseif unrewarded > 0 then
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
return _return_value$trig$, '05ccbd938bc25e41d8e356cd72558e68'),
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
        local unrewarded = ((((got_hands or 0) + (hands_count or 0)) ~= 4) and 1 or 0) + ((((got_feet or 0) + (feet_count or 0)) ~= 4) and 1 or 0) + ((((got_wrist or 0) + (wrist_count or 0)) ~= 4) and 1 or 0)
        unrewarded = unrewarded + ((((got_head or 0) + (head_count or 0)) ~= 4) and 1 or 0) + ((((got_arms or 0) + (arms_count or 0)) ~= 4) and 1 or 0)
        unrewarded = unrewarded + ((((got_legs or 0) + (legs_count or 0)) ~= 4) and 1 or 0) + ((((got_body or 0) + (body_count or 0)) ~= 4) and 1 or 0)
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
        if given == 0 then
            actor:send("You haven't retrieved anything yet.")
            return _return_value
        elseif unrewarded > 0 then
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
return _return_value$trig$, 'e76b25072047013bf00599014c3abf58'),
  -- data/triggers/004/004_19_major_globe_progress_journal.lua
  (4, 19, $trig$-- Converted from DG Script #419: Major Globe progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
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
                plant = actor:get_quest_var("major_globe_spell:ward_53453")
                mist = actor:get_quest_var("major_globe_spell:ward_53454")
                water = actor:get_quest_var("major_globe_spell:ward_53455")
                flame = actor:get_quest_var("major_globe_spell:ward_53456")
                ice = actor:get_quest_var("major_globe_spell:ward_53457")
                wards_left = 5 - (actor:get_quest_var("major_globe_spell:ward_count") or 0)
                local task = "Bring " .. tostring(master) .. " <b:yellow>" .. tostring(wards_left) .. " more elemental wards</>, one each from a mist, a water, an ice, a flame, and a plant elemental."
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
return _return_value$trig$, '68b1936898bf4dfa0eb845f25f950bb3'),
  -- data/triggers/004/004_22_combat_in_eldoria_progress_journal.lua
  (4, 22, $trig$-- Converted from DG Script #422: Combat in Eldoria progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
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
        if actor:get_quest_var("Black_Legion:bl_ally") then
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
        elseif actor:get_quest_var("Black_Legion:eg_ally") then
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
        actor:send(tostring(actor:get_quest_var("black_legion:" .. tostring(id_trophy1) .. "_trophies")) .. " %get.obj_pldesc[%id_trophy1%]%")
        actor:send(tostring(actor:get_quest_var("black_legion:" .. tostring(id_trophy2) .. "_trophies")) .. " %get.obj_pldesc[%id_trophy2%]%")
        actor:send(tostring(actor:get_quest_var("black_legion:" .. tostring(id_trophy3) .. "_trophies")) .. " %get.obj_pldesc[%id_trophy3%]%")
        actor:send(tostring(actor:get_quest_var("black_legion:" .. tostring(id_trophy4) .. "_trophies")) .. " %get.obj_pldesc[%id_trophy4%]%")
        actor:send(tostring(actor:get_quest_var("black_legion:" .. tostring(id_trophy5) .. "_trophies")) .. " %get.obj_pldesc[%id_trophy5%]%")
        actor:send(tostring(actor:get_quest_var("black_legion:" .. tostring(id_trophy6) .. "_trophies")) .. " %get.obj_pldesc[%id_trophy6%]%")
        actor:send(tostring(actor:get_quest_var("black_legion:" .. tostring(id_trophy7) .. "_trophies")) .. " %get.obj_pldesc[%id_trophy7%]%")
        actor:send("</>")
        actor:send("Your current " .. tostring(legion) .. " faction status is " .. tostring(status) .. ".")
        if status >= 200 then
            actor:send("You have reached the maximum faction status.")
        end
        actor:send("</>")
        if status >= 20 then
            actor:send("You have access to:")
            actor:send("<b:yellow>" .. "%get.obj_shortdesc[%id_food%]%</> for <magenta>%get.obj_shortdesc[%id_gem_food%]%</>")
            actor:send("- times claimed: (" .. tostring(actor:get_quest_var("black_legion:" .. tostring(id_food) .. "_reward")) .. ")_")
            actor:send("<b:yellow>" .. "%get.obj_shortdesc[%id_drink%]%</> for <magenta>%get.obj_shortdesc[%id_gem_drink%]%</>")
            actor:send("- times claimed: (" .. tostring(actor:get_quest_var("black_legion:" .. tostring(id_drink) .. "_reward")) .. ")_")
            actor:send("<b:yellow>" .. "%get.obj_shortdesc[%id_cap%]%</> for <magenta>%get.obj_shortdesc[%id_gem_cap%]%</>")
            actor:send("- times claimed: (" .. tostring(actor:get_quest_var("black_legion:" .. tostring(id_cap) .. "_reward")) .. ")_")
            actor:send("<b:yellow>" .. "%get.obj_shortdesc[%id_ssword%]%</> for <magenta>%get.obj_shortdesc[%id_gem_ssword%]%</>")
            actor:send("- times claimed: (" .. tostring(actor:get_quest_var("black_legion:" .. tostring(id_ssword) .. "_reward")) .. ")_")
        end
        if status >= 40 then
            actor:send("<b:yellow>" .. "%get.obj_shortdesc[%id_neck%]%</> for <magenta>%get.obj_shortdesc[%id_gem_neck%]%</>")
            actor:send("- times claimed: (" .. tostring(actor:get_quest_var("black_legion:" .. tostring(id_neck) .. "_reward")) .. ")_")
            actor:send("<b:yellow>" .. "%get.obj_shortdesc[%id_staff%]%</> for <magenta>%get.obj_shortdesc[%id_gem_staff%]%</>")
            actor:send("- times claimed: (" .. tostring(actor:get_quest_var("black_legion:" .. tostring(id_staff) .. "_reward")) .. ")_")
        end
        if status >= 55 then
            actor:send("<b:yellow>" .. "%get.obj_shortdesc[%team_a_idrm%]%</> for <magenta>%get.obj_shortdesc[%id_gem_arm%]%</>")
            actor:send("- times claimed: (" .. tostring(actor:get_quest_var("black_legion:" .. tostring(team_a_idrm) .. "_reward")) .. ")_")
            actor:send("<b:yellow>" .. "%get.obj_shortdesc[%id_whammer%]%</> for <magenta>%get.obj_shortdesc[%id_gem_whammer%]%</>")
            actor:send("- times claimed: (" .. tostring(actor:get_quest_var("black_legion:" .. tostring(id_whammer) .. "_reward")) .. ")_")
        end
        if status >= 70 then
            actor:send("<b:yellow>" .. "%get.obj_shortdesc[%id_wrist%]%</> for <magenta>%get.obj_shortdesc[%id_gem_wrist%]%</>")
            actor:send("- times claimed: (" .. tostring(actor:get_quest_var("black_legion:" .. tostring(id_wrist) .. "_reward")) .. ")_")
            actor:send("<b:yellow>" .. "%get.obj_shortdesc[%id_flail%]%</> for <magenta>%get.obj_shortdesc[%id_gem_flail%]%</>")
            actor:send("- times claimed: (" .. tostring(actor:get_quest_var("black_legion:" .. tostring(id_flail) .. "_reward")) .. ")_")
        end
        if status >= 85 then
            actor:send("<b:yellow>" .. "%get.obj_shortdesc[%id_gloves%]%</> for <magenta>%get.obj_shortdesc[%id_gem_gloves%]%</>")
            actor:send("- times claimed: (" .. tostring(actor:get_quest_var("black_legion:" .. tostring(id_gloves) .. "_reward")) .. ")_")
            actor:send("<b:yellow>" .. "%get.obj_shortdesc[%id_symbol%]%</> for <magenta>%get.obj_shortdesc[%id_gem_symbol%]%</>")
            actor:send("- times claimed: (" .. tostring(actor:get_quest_var("black_legion:" .. tostring(id_symbol) .. "_reward")) .. ")_")
            actor:send("<b:yellow>" .. "%get.obj_shortdesc[%id_light%]%</> for <magenta>%get.obj_shortdesc[%id_gem_light%]%</>")
            actor:send("- times claimed: (" .. tostring(actor:get_quest_var("black_legion:" .. tostring(id_light) .. "_reward")) .. ")_")
        end
        if status >= 100 then
            actor:send("<b:yellow>" .. "%get.obj_shortdesc[%team_b_idelt%]%</> for <magenta>%get.obj_shortdesc[%id_gem_belt%]%</>")
            actor:send("- times claimed: (" .. tostring(actor:get_quest_var("black_legion:" .. tostring(team_b_idelt) .. "_reward")) .. ")_")
            actor:send("<b:yellow>" .. "%get.obj_shortdesc[%id_shiv%]%</> for <magenta>%get.obj_shortdesc[%id_gem_shiv%]%</>")
            actor:send("- times claimed: (" .. tostring(actor:get_quest_var("black_legion:" .. tostring(id_shiv) .. "_reward")) .. ")_")
        end
        if status >= 115 then
            actor:send("<b:yellow>" .. "%get.obj_shortdesc[%team_b_idoots%]%</> for <magenta>%get.obj_shortdesc[%id_gem_boots%]%</>")
            actor:send("- times claimed: (" .. tostring(actor:get_quest_var("black_legion:" .. tostring(team_b_idoots) .. "_reward")) .. ")_")
            actor:send("<b:yellow>" .. "%get.obj_shortdesc[%id_lsword%]%</> for <magenta>%get.obj_shortdesc[%id_gem_lsword%]%</>")
            actor:send("- times claimed: (" .. tostring(actor:get_quest_var("black_legion:" .. tostring(id_lsword) .. "_reward")) .. ")_")
        end
        if status >= 130 then
            actor:send("<b:yellow>" .. "%get.obj_shortdesc[%id_legs%]%</> for <magenta>%get.obj_shortdesc[%id_gem_legs%]%</>")
            actor:send("- times claimed: (" .. tostring(actor:get_quest_var("black_legion:" .. tostring(id_legs) .. "_reward")) .. ")_")
        end
        if status >= 145 then
            actor:send("<b:yellow>" .. "%get.obj_shortdesc[%id_robe%]%</> for <magenta>%get.obj_shortdesc[%id_gem_robe%]%</>")
            actor:send("- times claimed: (" .. tostring(actor:get_quest_var("black_legion:" .. tostring(id_robe) .. "_reward")) .. ")_")
            actor:send("<b:yellow>" .. "%get.obj_shortdesc[%id_jerkin%]%</> for <magenta>%get.obj_shortdesc[%id_gem_jerkin%]%</>")
            actor:send("- times claimed: (" .. tostring(actor:get_quest_var("black_legion:" .. tostring(id_jerkin) .. "_reward")) .. ")_")
        end
        if status >= 160 then
            actor:send("<b:yellow>" .. "%get.obj_shortdesc[%id_mask%]%</> for <magenta>%get.obj_shortdesc[%id_gem_mask%]%</>")
            actor:send("- times claimed: (" .. tostring(actor:get_quest_var("black_legion:" .. tostring(id_mask) .. "_reward")) .. ")_")
            actor:send("<b:yellow>" .. "%get.obj_shortdesc[%id_smace%]%</> for <magenta>%get.obj_shortdesc[%id_gem_smace%]%</>")
            actor:send("- times claimed: (" .. tostring(actor:get_quest_var("black_legion:" .. tostring(id_smace) .. "_reward")) .. ")_")
        end
        if (status or 0) < 160 then
            actor:send("As your standing with the " .. tostring(legion) .. " improves you will have access to more rewards.")
        end
    else
        actor:send("<cyan>Status: Not Started</>")
    end
end
return _return_value$trig$, 'b849d0f90da81b2aa8764d92f1225482'),
  -- data/triggers/004/004_28_supernova_progress_journal.lua
  (4, 28, $trig$-- Converted from DG Script #428: Supernova progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local clue2, clue3, clue5, clue4
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
                clue2 = nil
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
                clue3 = nil
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
                    clue4 = nil
                    if (step7 or 0) == 1 then
                        clue4 = "s pfqzqgc wq kecwk qy xug fwinlugev"
                    elseif (step7 or 0) == 2 then
                        clue4 = "d hlwzsuc rf xbnwk aq tyo oisukhvkq"
                    elseif (step7 or 0) == 3 then
                        clue4 = "s oidfgjy fy yyojl au hyx tlotazlou"
                    end
                elseif (actor:get_quest_var("supernova:step6") or 0) == 35119 then
                    -- A Pile of Stones in the Brush Lands
                    clue4 = nil
                    if (step7 or 0) == 1 then
                        clue4 = "s xtpr qj kbzrru mf bsi otykp weafw"
                    elseif (step7 or 0) == 2 then
                        clue4 = "d pzvr sx kwoeof mf lke sbhwz ddnuc"
                    elseif (step7 or 0) == 3 then
                        clue4 = "s wwcx gm gkhflg zg los skmzv ctfkg"
                    end
                elseif (actor:get_quest_var("supernova:step6") or 0) == 55422 then
                    -- The Trail Overlooking the Falls in the dark mountains
                    clue4 = nil
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
                clue5 = nil
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
return _return_value$trig$, 'f5a68de599c85f34f7fc2a2479f9373e'),
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
            if actor:get_quest_var("meteorswarm:new") == "yes" then
                actor:send("Go find a new meteorite.")
                return _return_value
            elseif actor:get_quest_var("meteorswarm:new") == "no" then
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
return _return_value$trig$, '6d318f16979f555672b20de3a87edd36'),
  -- data/triggers/004/004_65_mercenary_assassin_thief_subclass_progress_journal.lua
  (4, 65, $trig$-- Converted from DG Script #465: Mercenary Assassin Thief Subclass progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if actor.level > 10 then
    local assassinraces = "none"
    local mercenaryraces = "none"
    local thiefraces = "none"
    local check
    local questname
    if string.find(actor.class, "rogue") and actor.level <= 25 then
        if string.find(arg, "Mercenary") and not (string.find(mercenaryraces, actor.race)) then
            actor:send("<b:black>Mercenary</>")
            questname = "mercenary"
            check = "yes"
        elseif string.find(arg, "Assassin") and not (string.find(assassinraces, actor.race)) then
            actor:send("<red>Assassin</>")
            questname = "assassin"
            check = "yes"
        elseif string.find(arg, "Thief") and not (string.find(thiefraces, actor.race)) then
            actor:send("<b:red>Thief</>")
            questname = "thief"
            check = "yes"
        end
    end
    if check == "yes" then
        _return_value = true
        actor:send("Quest Master: " .. tostring(mobiles.template(60, 50).name))
        actor:send("</>")
        actor:send("Minimum Level: 10")
        if questname == "assassin" then
            actor:send("This class is for evil characters only.")
        end
        if actor:get_quest_stage("merc_ass_thi_subclass") > 0 then
            actor:send(tostring(mobiles.template(60, 50).name) .. " said to you:")
            -- switch on actor:get_quest_stage("merc_ass_thi_subclass")
            do
                local _sw1 = string.lower(tostring(actor:get_quest_stage("merc_ass_thi_subclass") or ""))
                if tonumber(_sw1) == 1 then
                    if questname == "mercenary" then
                        actor:send("He would pay well.  Yes, that Lord would pay well indeed.")
                    elseif questname == "assassin" then
                        actor:send("Yes, that would bring a good price.")
                    elseif questname == "thief" then
                        actor:send("There is a package that someone could get back.")
                    end
                elseif tonumber(_sw1) == 2 then
                    if questname == "mercenary" then
                        actor:send("Well, a great Lord, who shall remain unnamed, has lost a cloak.")
                        actor:send("He has come to me for its return.")
                        actor:send("If you went and procured it, he would be grateful.")
                        actor:send("And if he is grateful, I would be as well, and your training would be finished._")
                        actor:send("It would be quite a payday for a cloak.")
                    elseif questname == "thief" then
                        actor:send("Some time ago it was sent and picked up by someone who should not have it._")
                        actor:send("Bloody farmers.")
                    elseif questname == "assassin" then
                        actor:send("I have some rich men unhappy with the politics of the region in question.")
                        actor:send("You could help with those politics if you wish.")
                    end
                elseif tonumber(_sw1) == 3 or tonumber(_sw1) == 4 then
                    if questname == "mercenary" then
                        actor:send("It was made off with in a raid on his castle by some bothersome insect warriors.")
                        actor:send("All the Lord was able to tell me is they said something about wanting it for their queen._")
                        actor:send("I think you should go find it now._")
                        actor:send("Come back when you ave the cloak, do not come back at all.")
                    elseif questname == "assassin" then
                        actor:send("Ah yes, the politics of it all.")
                        actor:send("Personally I am not one for them, but some people get all mixed up in those._")
                        actor:send("Go kill the Mayor of Mielikki._")
                        actor:send("He's probably holed up in his office in City Hall.")
                        actor:send("You'll have to break in, sneak past the guards, and kill him._")
                        actor:send("Get his cane as proof and come back and give it to me.")
                    elseif questname == "thief" then
                        actor:send("That is right, a package was taken by a farmer who hould not have it._")
                        actor:send("I know this: he got it from the post office in Mielikki and he lives near there.")
                        actor:send("Go get it back and I will make it worth it to you._")
                        actor:send("Do not let anyone see you do not leave a trail of bodies behind you.")
                        actor:send("And be careful!  If you jostle the package too much it just might explode.")
                    end
                end
            end
        end
    end
end
return _return_value$trig$, '55a3b8c814e36bc394dba975c32f7d5c'),
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
            -- switch on hellstage
            local response
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
    local response
    if actor:get_quest_stage("hell_trident") == "step" then
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
end$trig$, 'ea1a82b2240833c4bf74807d982490d0'),
  -- data/triggers/030/030_123_squeeze_ehlissa.lua
  (30, 123, $trig$-- Converted from DG Script #3123: squeeze_ehlissa
-- Original: OBJECT trigger, flags: COMMAND, probability: 1%

-- Command location mask 1: legacy OCMD_EQUIP=1 (worn), OCMD_INVEN=2 (carried), OCMD_ROOM=4 (floor)
if not (location == "equip") then
    return true  -- Not in a location this trigger watches
end

-- Command filter: squeeze
if not (cmd == "squeeze") then
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
if (arg ~= "doll") and (arg ~= "ehlissa") and (arg ~= "miniature-ehlissa-doll") and (arg ~= "miniature") and (arg ~= "little") and (arg ~= "little-ehlissa-doll") and (arg ~= "ehlissa-doll") then
    _return_value = true
    return _return_value
end
_return_value = false
self.room:send(tostring(actor.name) .. " squeezes " .. tostring(actor.hisher) .. " doll.")
local i = 99
while i > 0 do
    self.room:send(tostring(self.shortdesc) .. " sings, '" .. tostring(i) .. " bottles of beer on the wall...'")
    wait(3)
    self.room:send(tostring(self.shortdesc) .. " sings, '" .. tostring(i) .. " bottles of beer...'")
    wait(3)
    self.room:send(tostring(self.shortdesc) .. " sings, 'Take one down, pass it around...'")
    wait(3)
    i = i - 1
    self.room:send(tostring(self.shortdesc) .. " sings, '" .. tostring(i) .. " bottles of beer on the wall!'")
    wait(7)
end
return _return_value$trig$, '12420b82dfc658a12b7f13f03f1e41d0'),
  -- data/triggers/053/053_25_honus_treasure_receive.lua
  (53, 25, $trig$-- Converted from DG Script #5325: Honus treasure receive
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local accept, refuse
local _return_value = true  -- Default: allow action
-- switch on object.id
local stage
if (object.zone_id == 615 and object.id == 14) then
    -- singing chain
    stage = 1
elseif (object.zone_id == 43 and object.id == 19) then
    -- fire ring
    stage = 2
elseif (object.zone_id == 161 and object.id == 3) then
    -- sandstone ring
    stage = 3
elseif (object.zone_id == 502 and object.id == 15) then
    -- electrum hoop
    stage = 4
elseif (object.zone_id == 481 and object.id == 1) then
    -- rainbow shell
    stage = 5
elseif (object.zone_id == 160 and object.id == 9) then
    -- stormshield
    stage = 6
elseif (object.zone_id == 550 and object.id == 8) then
    -- snow leopard cloak
    stage = 7
elseif (object.zone_id == 490 and object.id == 41) then
    -- rope ladder
    stage = 8
elseif (object.zone_id == 584 and object.id == 1) then
    -- phoenix feather
    stage = 9
elseif (object.zone_id == 534 and object.id == 100) or (object.zone_id == 534 and object.id == 101) or (object.zone_id == 534 and object.id == 105) or (object.zone_id == 534 and object.id == 106) then
    -- sleet armor
    stage = 10
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
        if person:get_quest_stage("treasure_hunter") == "stage" then
            if person:get_quest_var("treasure_hunter:hunt") == "found" then
                person:set_quest_var("treasure_hunter", "hunt", "returned")
                accept = 1
                refuse = 0
            elseif actor:get_quest_var("treasure_hunter:hunt") == "running" then
                if accept then
                    refuse = 0
                else
                    refuse = 1
                end
            elseif actor:get_quest_var("treasure_hunter:hunt") == "returned" then
                if accept then
                    refuse = 0
                else
                    refuse = 2
                end
            elseif actor:get_quest_stage("treasure_hunter") > stage then
                if accept then
                    refuse = 0
                else
                    refuse = 2
                end
            elseif actor:get_quest_stage("treasure_hunter") < stage then
                if accept then
                    refuse = 0
                else
                    refuse = 3
                end
            end
        end
    elseif person and person.is_player then
        i = i + 1
    end
    a = a + 1
end
if accept == 1 then
    wait(0.2)
    world.destroy(object)
    self:command("grin")
    self.room:send(tostring(self.name) .. " says, 'Excellent!  Now just give me the order paperwork and I can pay you.'")
elseif refuse then
    _return_value = true
    self:command("shake")
    self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
    if refuse == 1 then
        wait(0.2)
        self.room:send(tostring(self.name) .. " says, 'Nah nah nah, you gotta put in at least a little effort toward finding this yourself, come on.'")
    elseif refuse == 2 then
        wait(0.2)
        self.room:send(tostring(self.name) .. " says, 'You already stole - er, recovered this treasure!'")
    elseif refuse == 3 then
        wait(0.2)
        self.room:send(tostring(self.name) .. " says, 'I'm not looking for that...  Yet.'")
    end
end
return _return_value$trig$, 'ad2009ff327ab0ed25b1faa6ddab593b'),
  -- data/triggers/053/053_57_hell_trident_progress_tracker.lua
  (53, 57, $trig$-- Converted from DG Script #5357: Hell Trident progress tracker
-- Original: MOB trigger, flags: SPEECH, probability: 0%

-- Speech phrase: weapon progress (DG num_arg 0 = the speech contains the whole phrase, on word boundaries)
local quest1, quest2, pl_word, spell1, spell2, task6, word, task6do, step
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
                step = 1
                local gem = 55662
                pl_word = "angels"
                word = "angel"
                spell1 = "Hellfire and Brimstone"
                quest1 = actor:get_has_completed("hellfire_brimstone")
                spell2 = "Banish"
                quest2 = actor:get_has_completed("banish")
                if not actor:get_quest_var("hell_trident:helltask6") and actor.level >= level and hellstage == 1 then
                    if actor:get_quest_stage("vilekka_stew") > 3 then
                        actor:set_quest_var("hell_trident", "helltask6", 1)
                    end
                end
                task6 = "assisted Vilekka Kar'Shezden"
                task6do = "<b:yellow>Assist the High Priestess of Lolth in hunting down and destroying the heretics of her Goddess.</>"
            elseif (self.zone_id == 125 and self.id == 26) then
                step = 2
                local gem = 55739
                pl_word = "ghaeles, solars, or seraphs"
                word = "ghaele, solar, or seraph"
                spell1 = "Resurrect"
                quest1 = actor:get_has_completed("resurrection_quest")
                spell2 = "Hell Gate"
                quest2 = actor:get_has_completed("hell_gate")
                task6 = "Defeated the Undead Prince"
                task6do = "find one long-buried and branded an infidel.  <b:yellow>Finish his undying duel for him</> as a sacrifice of honor."
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
end$trig$, '2f86c3be58b5995c406fdca44526526f'),
  -- data/triggers/087/087_11_anti-get_trigger.lua
  (87, 11, $trig$-- Converted from DG Script #8711: anti-get trigger
-- Original: OBJECT trigger, flags: GET, probability: 100%
local _return_value = true  -- Default: allow action
if actor.size == "tiny" or actor.size == "small" or actor.size == "medium" or actor.size == "large" or actor.size == "huge" then
    local damage_dealt = actor:damage(50)  -- type: crush
    if damage_dealt ~= 0 then
        actor:send("Your back buckles and pain shoots though you joints! (<b:red>" .. tostring(damage_dealt) .. "</>)")
        actor:send("You just can't hold that much weight!")
        self.room:send_except(actor, tostring(actor.name) .. " shouts in pain. (<blue>" .. tostring(damage_dealt) .. "</>)")
        actor:send("You drop " .. tostring(self.shortdesc) .. ".")
        self.room:send_except(actor, tostring(actor.name) .. " drops " .. tostring(self.shortdesc) .. ".")
    else
        actor:send("You can't seem to get a grip on " .. tostring(self.shortdesc) .. ".")
    end
end
return _return_value$trig$, 'c34f01f1c37bf363682c223de1b64d74'),
  -- data/triggers/103/103_08_hot-spring.lua
  (103, 8, $trig$local who = actor
if not who then
    if self.room and self.room.actors and #self.room.actors > 0 then
        who = self.room.actors[random(1, #self.room.actors)]
    end
end
if not who or not who.is_player then
    return true
end

local heat_resistant = who:has_effect(Effect.HeatResistance)
if who.class == "pyromancer" or heat_resistant then
    return true
end

local damage = random(1, 10) + random(1, 10)
self.room:send_except(who, who.name .. " starts to look a bit woozy from the extreme heat.")
who:send("The water is too hot for you....")
who:damage(damage)  -- physical heat damage
return true$trig$, 'c6e43273da85d79f1adceb88b69cac77'),
  -- data/triggers/125/125_06_get_book.lua
  (125, 6, $trig$-- Converted from DG Script #12506: Get_Book
-- Original: OBJECT trigger, flags: GET, probability: 100%
local _return_value = true  -- Default: allow action
local damage_dealt = actor:damage(100)  -- type: slash
if damage_dealt == 0 then
    _return_value = false
else
    _return_value = true
    actor:send("As you grab the book, blades rip through your hand - it must have been trapped! (<b:yellow>" .. tostring(damage_dealt) .. "</>)")
    self.room:send_except(actor, tostring(actor.name) .. " grabs the green book, and screams in pain as blades rip through " .. tostring(actor.possessive) .. " hand. (<b:yellow>" .. tostring(damage_dealt) .. "</>)")
end
return _return_value$trig$, '1ebb3073a789f7d8933dc0aef3ae6bed'),
  -- data/triggers/125/125_13_red_wall.lua
  (125, 13, $trig$-- Converted from DG Script #12513: Red_wall
-- Original: OBJECT trigger, flags: COMMAND, probability: 100%

-- Command location mask 100: legacy OCMD_EQUIP=1 (worn), OCMD_INVEN=2 (carried), OCMD_ROOM=4 (floor)
if not (location == "room") then
    return true  -- Not in a location this trigger watches
end

-- Command filter: west
if not (cmd == "west") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
_return_value = false
local which = random(1, 10)
if which == 4 then
    actor:send("You feel a burning sensation, but push through!")
    self.room:send_except(actor, tostring(actor.name) .. " pushes through the red field!")
    actor:teleport(get_room(126, 8))
    actor:command("look")
else
    local damage_dealt = actor:damage(75)  -- type: fire
    if damage_dealt == 0 then
        _return_value = false
    else
        -- TODO(parity): on damage hit, original sets _return_value=true (allow default west).
        -- That contradicts the flavor message ("forced back"). Confirm legacy intent.
        _return_value = true
        actor:send("The red field burns you, and you are forced back! (<red>" .. tostring(damage_dealt) .. "</>)")
        self.room:send_except(actor, tostring(actor.name) .. " is forced back by the red field. (<red>" .. tostring(damage_dealt) .. "</>)")
    end
end
return _return_value$trig$, 'dd1f7daab419be55da077c2c9f79160a'),
  -- data/triggers/125/125_14_blue_field.lua
  (125, 14, $trig$-- Converted from DG Script #12514: Blue_field
-- Original: OBJECT trigger, flags: COMMAND, probability: 100%

-- Command location mask 100: legacy OCMD_EQUIP=1 (worn), OCMD_INVEN=2 (carried), OCMD_ROOM=4 (floor)
if not (location == "room") then
    return true  -- Not in a location this trigger watches
end

-- Command filter: east
if not (cmd == "east") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
local damage_dealt = actor:damage(115)  -- type: shock
if damage_dealt == 0 then
    _return_value = true
else
    _return_value = false
    actor:send("The blue field shocks you, flinging you back into the room! (<b:blue>" .. tostring(damage_dealt) .. "</>)")
    self.room:send_except(actor, tostring(actor.name) .. " is forced back by the blue field. (<b:blue>" .. tostring(damage_dealt) .. "</>)")
end
return _return_value$trig$, 'a1adf7b79386402783e094d98aec143f'),
  -- data/triggers/125/125_44_flaminkey.lua
  (125, 44, $trig$-- Converted from DG Script #12544: FlaminKey
-- Original: OBJECT trigger, flags: GET, probability: 100%
local burn = 1
wait(0.1)
if string.find(actor.class, "cry") then
    actor:send("Your cool touch makes the fiery key's heat bearable.")
    burn = 0
end
if string.find(actor.class, "pyr") then
    burn = 0
    actor:send("Your hands are accustomed to the heat, making the key easy to handle.")
end
if burn == 1 then
    local damage_dealt = actor:damage(50)  -- type: fire
    if damage_dealt ~= 0 then
        actor:send("OUCH!  You grab the key, but it's burning your hand! (<red>" .. tostring(damage_dealt) .. "</>)")
        self.room:send_except(actor, tostring(actor.name) .. " yelps as the key burns " .. tostring(actor.possessive) .. " hand! (<red>" .. tostring(damage_dealt) .. "</>)")
    end
end$trig$, '4f6b55b649e53754721bf332ba0101fa'),
  -- data/triggers/200/200_08_reach_oven.lua
  (200, 8, $trig$-- Converted from DG Script #20008: reach_oven
-- Original: OBJECT trigger, flags: GET, probability: 100%
local damage_dealt = actor:damage(15)  -- type: fire
if damage_dealt ~= 0 then
    actor:send("As you reach into the oven your hand is suddenly burnt by the searing heat of the oven! (<red>" .. tostring(damage_dealt) .. "</>)")
    actor:send("But you still manage to retreive the bread.")
    self.room:send_except(actor, tostring(actor.name) .. " screams in pain as he reaches " .. tostring(actor.possessive) .. " hand into the oven.")
    self.room:send_except(actor, tostring(actor.name) .. " screams in pain as he reaches " .. tostring(actor.possessive) .. " hand into the oven. (<red>" .. tostring(damage_dealt) .. "</>)")
end$trig$, '012e40d3d7120526053f04ae863f82be'),
  -- data/triggers/200/200_38_drink_fountain.lua
  (200, 38, $trig$-- Converted from DG Script #20038: drink_fountain
-- Original: OBJECT trigger, flags: COMMAND, probability: 100%

-- Command location mask 100: legacy OCMD_EQUIP=1 (worn), OCMD_INVEN=2 (carried), OCMD_ROOM=4 (floor)
if not (location == "room") then
    return true  -- Not in a location this trigger watches
end

-- Command filter: drink
if not (cmd == "drink") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
_return_value = true
allow_command()  -- the drink goes ahead; the choking below follows the wait
wait(0.1)
if actor.level < 99 then
    local damage_dealt = actor:damage(50)  -- type: physical
    self.room:send_except(actor, tostring(actor.name) .. " is caught in a fit of choking. (<red>" .. tostring(damage_dealt) .. "</>)")
    actor:send("You are caught in a fit of choking. (<red>" .. tostring(damage_dealt) .. "</>)")
end
return _return_value$trig$, 'a8bb6cc2d91462d0ce79d964080f7ef6'),
  -- data/triggers/238/238_04_icicle-get.lua
  (238, 4, $trig$if not (actor.zone_id == 238 and (actor.local_id == 14 or actor.local_id == 15)) then
    wait(1)
    local damage_dealt = actor:damage(50)  -- type: cold
    if damage_dealt > 0 then
        actor:send("The icicle freezes your fingers. (<blue>" .. tostring(damage_dealt) .. "</>)")
    end
end$trig$, 'f482400356d5e229dffb7b43469ba631'),
  -- data/triggers/364/364_13_berserker_hjordis_command_howl.lua
  (364, 13, $trig$if cmd ~= "howl" then
    return true
end
if actor:get_quest_stage("berserker_subclass") ~= 3 then
    return true
end

actor:advance_quest("berserker_subclass")
actor:send("You raise your voice in a mighty howl to the Spirits!")
self.room:send_except(actor, tostring(actor.name) .. " raises " .. tostring(actor.hisher) .. " voice in a mighty howl to the Spirits!")
wait(0.2)

-- TODO(parity): targets are stored as legacy 5-digit ids (zone*100 + local).
-- This matches the comparisons in 364_14/15/20 which do `self.id`. When the
-- runtime exposes `self.legacy_id` consistently this can stay; otherwise it
-- needs to switch to (zone, local) tuples.
local QUARRIES = {
    { id = 16105, place = "a desert cave"           },
    { id = 16310, place = "some forested highlands" },
    { id = 20311, place = "a vast plain"            },
    { id = 55220, place = "the frozen tundra"       },
}
local pick = QUARRIES[random(1, #QUARRIES)]
local target = pick.id
local place = pick.place

actor:send(tostring(self.name) .. " throws her head back and howls along with you!")
self.room:send_except(actor, tostring(self.name) .. " throws her head back and howls along with " .. tostring(actor.name) .. "!")
wait(2)
actor:set_quest_var("berserker_subclass", "target", target)
local quarry_zone = math.floor(target / 100)
local quarry_local = target % 100
local quarry_name = mobiles.template(quarry_zone, quarry_local).name
actor:send("The Spirits reveal to you a vision of <b:yellow>" .. tostring(quarry_name) .. "</>!")
actor:send("You see it is in <b:yellow>" .. tostring(place) .. "</>!")
wait(6)
actor:send(tostring(self.name) .. " says, 'The Spirits have spoken!'")
wait(2)
actor:send(tostring(self.name) .. " says, 'Find the beast of your Wild Hunt and join our ranks.  Remember, this quest must be undertaken <b:red>ALONE</>.  If you are grouped when you fight your prey, there will be consequences!'")
return true$trig$, '8de3d59aff2353c3c62f6dc4f1dd969c'),
  -- data/triggers/390/390_07_flood_spirits_receive.lua
  (390, 7, $trig$local color
local _return_value = true  -- Default: allow action
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
        color = "<cyan>"
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
        color = "<green>"
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
        color = "<b:black>"
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
return _return_value$trig$, '6efa43378fd50a209df5963a1ed5f309'),
  -- data/triggers/390/390_08_flood_totem_dance.lua
  (390, 8, $trig$if cmd ~= "dance" then
    return true
end
if actor:get_quest_stage("flood") ~= 1 then
    return true
end

local has_bell =
    actor:has_item(69, 3) or actor:has_equipped(69, 3)
    or actor:has_item(123, 11) or actor:has_equipped(123, 11)
    or actor:has_item(123, 16) or actor:has_equipped(123, 16)
    or actor:has_item(173, 9)  or actor:has_equipped(173, 9)

if not has_bell then
    actor:send("You begin to dance but " .. self.name .. " is unresponsive.")
    self.room:send_except(actor, actor.name .. " begins to dance but " .. self.name .. " is unresponsive.")
    actor:send("Something seems to be off about your preparations.")
    return true
end

local color = "<b:blue>"
local hisher_pron = (actor.hisher or "their")
self.room:send_except(actor, actor.name .. " dances an ancient circle dance, calling to the great Spirits of the Canyon.")
actor:send("You dance an ancient circle dance, calling to the great Spirits of the canyon.")
wait(1)
actor:send(color .. self.name .. " begins to dance with you, complementing and accentuating your movement and rhythms.</>")
self.room:send_except(actor, color .. self.name .. " begins to dance with " .. actor.name .. ", complementing and accentuating " .. hisher_pron .. " movement and rhythms.</>")
wait(3)
self.room:send(self.name .. " speaks in three voices:")
self.room:send(color .. "'You show proper respect for the Spirits of the Canyon and their children.  In turn, we will respect your position as Envoy and heed the call of the Ocean.'</>")
actor:set_quest_var("flood", "water3", 1)
wait(2)
self.room:send(color .. self.name .. " continues to dance, gradually uniting with the river.</>")

if actor:get_quest_var("flood:water1")
        and actor:get_quest_var("flood:water2")
        and actor:get_quest_var("flood:water3")
        and actor:get_quest_var("flood:water4")
        and actor:get_quest_var("flood:water5")
        and actor:get_quest_var("flood:water6")
        and actor:get_quest_var("flood:water7")
        and actor:get_quest_var("flood:water8") then
    actor:advance_quest("flood")
    wait(1)
    actor:send("<b:blue>You have garnered the support of all the great waters!</>")
end
world.destroy(self)
return true$trig$, '68f9d462649e9b6885a67e70c4893b21'),
  -- data/triggers/481/481_11_bad_wedding_ring.lua
  (481, 11, $trig$-- Converted from DG Script #48111: bad_wedding_ring
-- Original: OBJECT trigger, flags: GET, probability: 100%
if not (actor.zone_id == 481 and actor.local_id == 5) then
    wait(0.2)
    self.room:send("The ivory ring flares brightly!")
    local damage_dealt = actor:damage(100)  -- type: fire
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
end$trig$, '7741be15daac51a025f1f67b286eb786'),
  -- data/triggers/484/484_04_lord-realm-spawn.lua
  (484, 4, $trig$-- Converted from DG Script #48404: lord-realm-spawn
-- Original: WORLD trigger, flags: PREENTRY, probability: 100%
-- This is for room 47658: The Heart of the Realm.
local lord_loaded
if not lord_loaded then
    lord_loaded = 1
    globals.lord_loaded = globals.lord_loaded or true
    wait(1)
    self.room:send("Before your eyes, a nondescript boulder molds itself into the image of a man of gigantic proportions.")
    self.room:spawn_mobile(484, 6)
    wait(1)
    self.room:send("When the transformation is complete, the elemental flexes his thick stone fingers fluidly.")
    self.room:find_actor("lord-realm"):spawn_object(484, 2)
    self.room:find_actor("lord-realm"):command("mat 1100 hold staff-justice")
    self.room:find_actor("lord-realm"):shout("It has been long since I have taken this form! Beware--this time I will be the victorious one!")
end$trig$, '3355a6eaa72ea0f0d1e50a80870040f9'),
  -- data/triggers/484/484_08_lord-realm_fight.lua
  (484, 8, $trig$-- Converted from DG Script #48408: lord-realm fight
-- Original: MOB trigger, flags: FIGHT, probability: 100%
local has_blur
if has_blur then
    if not (self:has_effect(Effect.Blur)) then
        self:emote("slows as " .. tostring(self.name) .. " returns to normal speed.")
        has_blur = 0
        globals.has_blur = globals.has_blur or true
    end
end
local victim = self.room.actors[random(1, #self.room.actors)]
if victim then
    local action = random(1, 10)
    if action > 8 then
        wait(2)
        self.room:send_except(victim, tostring(self.name) .. " swings a rocky fist at " .. tostring(victim.name) .. ", toppling " .. tostring(victim.object) .. "!")
        victim:send(tostring(self.name) .. " swings a rocky fist at you, knocking you over!")
        self:send("You swing a rocky fist at " .. tostring(victim.name) .. ", knocking " .. tostring(victim.object) .. " over!")
        victim:teleport(get_room(11, 0))
        victim:command("recline")
        victim:teleport(self.room)
    elseif action > 7 then
        if victim.is_player then
            combat.engage(self, victim.name)
        end
    end
end$trig$, '1934055122645b97a6482ea72380c89b'),
  -- data/triggers/484/484_105_mighty_druid_entanglement.lua
  (484, 105, $trig$-- Converted from DG Script #48505: mighty_druid entanglement
-- Original: MOB trigger, flags: FIGHT, probability: 100%
-- TODO(parity): the converter emitted branch-scoped `local chance`,
--   `local victim`, `local secondary_victim`, `local paralysis_victim_N`,
--   and `local paralysis_expire_N` declarations inside if/elseif blocks,
--   so the outer `if chance > 3 then` and `if victim.is_player then`
--   tests reference undefined names and the per-victim slot bookkeeping
--   never escapes its branch. The body also still contains a
--   `bash %victim.name%` DG token. The whole entanglement state machine
--   needs a rewrite once we have a stable globals API for per-mob
--   paralysis tracking.
local paralysis_expire_1, paralysis_expire_2, paralysis_expire_3, paralysis_expire_4, secondary_victim
local now = time.stamp
if paralysis_victim_1 and ((paralysis_victim_1.room ~= self.room) or (paralysis_expire_1 <= now)) then
    -- Clear paralysis on expired victim
    if paralysis_victim_1.room == self.room then
        self.room:send_except(paralysis_victim_1, "<green>The crop of roots recedes, releasing " .. tostring(paralysis_victim_1.name) .. " from its grasp.</>")
        paralysis_victim_1:send("<green>The crop of roots recedes, releasing you from its grasp.</>")
    else
        self.room:send("<green>The crop of roots recedes, releasing " .. tostring(paralysis_victim_1.name) .. " from its grasp.</>")
    end
    paralysis_victim_1 = nil
end
if paralysis_victim_2 and ((paralysis_victim_2.room ~= self.room) or (paralysis_expire_2 <= now)) then
    -- Clear paralysis on expired victim
    if paralysis_victim_2.room == self.room then
        self.room:send_except(paralysis_victim_2, "<green>The crop of roots recedes, releasing " .. tostring(paralysis_victim_2.name) .. " from its grasp.</>")
        paralysis_victim_2:send("<green>The crop of roots recedes, releasing you from its grasp.</>")
    else
        self.room:send("<green>The crop of roots recedes, releasing " .. tostring(paralysis_victim_2.name) .. " from its grasp.</>")
    end
    paralysis_victim_2 = nil
end
if paralysis_victim_3 and ((paralysis_victim_3.room ~= self.room) or (paralysis_expire_3 <= now)) then
    -- Clear paralysis on expired victim
    if paralysis_victim_3.room == self.room then
        self.room:send_except(paralysis_victim_3, "<green>The crop of roots recedes, releasing " .. tostring(paralysis_victim_3.name) .. " from its grasp.</>")
        paralysis_victim_3:send("<green>The crop of roots recedes, releasing you from its grasp.</>")
    else
        self.room:send("<green>The crop of roots recedes, releasing " .. tostring(paralysis_victim_3.name) .. " from its grasp.</>")
    end
    paralysis_victim_3 = nil
end
if paralysis_victim_4 and ((paralysis_victim_4.room ~= self.room) or (paralysis_expire_4 <= now)) then
    -- Clear paralysis on expired victim
    if paralysis_victim_4.room == self.room then
        self.room:send_except(paralysis_victim_4, "<green>The crop of roots recedes, releasing " .. tostring(paralysis_victim_4.name) .. " from its grasp.</>")
        paralysis_victim_4:send("<green>The crop of roots recedes, releasing you from its grasp.</>")
    else
        self.room:send("<green>The crop of roots recedes, releasing " .. tostring(paralysis_victim_4.name) .. " from its grasp.</>")
    end
    paralysis_victim_4 = nil
end
-- 25% chance to do creeping doom proc
local mode = random(1, 4)
if mode == 1 then
    wait(2)
    run_room_trigger(484, 103)
    return _return_value
end
-- 75% chance to attempt to entangle
if (not paralysis_victim_1) or (not paralysis_victim_2) or (not paralysis_victim_3) or (not paralysis_victim_4) then
    local chance
    if paralysis_victim_1 then
        if paralysis_victim_2 then
            if paralysis_victim_3 then
                if paralysis_victim_4 then
                    -- quit if four people already entangled
                    return _return_value
                else
                    -- 20% chance if three people are entangled
                    chance = random(1, 10)
                end
            else
                -- 25% chance if two people are entangled
                chance = random(1, 8)
            end
        else
            -- 33% chance if one person is already entangled
            chance = random(1, 6)
        end
    else
        -- 50% chance if no one is already entangled
        chance = random(1, 4)
    end
    if chance > 3 then
        return _return_value
    end
    local max_tries = 10
    while max_tries >= 0 do
        -- find a victim, preferably an assassin
        -- but will settle for any player if no assassin found
        local victim = self.room.actors[random(1, #self.room.actors)]
        if victim.is_player then
            if (paralysis_victim_1 and (paralysis_victim_1.name == victim.name)) or (paralysis_victim_2 and (paralysis_victim_2.name == victim.name)) or (paralysis_victim_3 and (paralysis_victim_3.name == victim.name)) then
                local victim = self
            elseif victim.class == "assassin" then
                max_tries = 0
            else
                secondary_victim = victim
            end
        end
        max_tries = max_tries - 1
    end
    -- quit if no players
    local victim
    if victim.is_player then
    elseif secondary_victim then
        victim = secondary_victim
    else
        return _return_value
    end
    wait(2)
    self.room:send_except(victim, tostring(self.name) .. " snarls and waves a hand at the ground at " .. tostring(victim.name) .. "'s feet.")
    victim:send(tostring(self.name) .. " snarls at you and waves a hand at the ground around your feet!")
    self.room:send_except(victim, "<green>A crop of wriggling roots bursts from the ground, entangling " .. tostring(victim.name) .. "!</>")
    victim:send("<green>A crop of wriggling roots bursts from the ground, entangling you!</>")
    -- declare paralysis message
    local message = "<green>The roots lock you in place, preventing movement!</>"
    globals.message = globals.message or true
    -- create a basher to force the player into a bashed stance
    if (victim.size == "Small") or (victim.size == "Tiny") then
        -- Basher is medium
        self.room:spawn_mobile(484, 115)
    elseif (victim.size == "Large") or (victim.size == "Huge") or (victim.size == "Giant") then
        -- Basher is huge
        self.room:spawn_mobile(484, 113)
    else
        -- Basher is large
        self.room:spawn_mobile(484, 114)
    end
    self.room:find_actor("bashing-roots"):spawn_object(10, 16)
    self.room:find_actor("bashing-roots"):command("mat 1100 wear shield")
    victim:command("stand")
    self.room:find_actor("bashing-roots"):command("bash %victim.name%")
    self.room:find_actor("bashing-roots"):destroy_item("shield")
    world.destroy(self.room:find_actor("bashing-roots"))
    -- reinitiate combat if victim was tanking
    if actor.name == victim.name then
        wait(2)
        combat.engage(self, victim.name)
    end
    -- save victim variable
    if paralysis_victim_1 then
        if paralysis_victim_2 then
            if paralysis_victim_3 then
                local paralysis_victim_4 = victim
                globals.paralysis_victim_4 = globals.paralysis_victim_4 or true
                paralysis_expire_4 = now + 1
                globals.paralysis_expire_4 = globals.paralysis_expire_4 or true
            else
                local paralysis_victim_3 = victim
                globals.paralysis_victim_3 = globals.paralysis_victim_3 or true
                paralysis_expire_3 = now + 1
                globals.paralysis_expire_3 = globals.paralysis_expire_3 or true
            end
        else
            local paralysis_victim_2 = victim
            globals.paralysis_victim_2 = globals.paralysis_victim_2 or true
            paralysis_expire_2 = now + 1
            globals.paralysis_expire_2 = globals.paralysis_expire_2 or true
        end
    else
        local paralysis_victim_1 = victim
        globals.paralysis_victim_1 = globals.paralysis_victim_1 or true
        paralysis_expire_1 = now + 1
        globals.paralysis_expire_1 = globals.paralysis_expire_1 or true
    end
end$trig$, 'afd55be6845bb59eddcc9cdb4d7eafb7'),
  -- data/triggers/484/484_29_hunt_refuse.lua
  (484, 29, $trig$-- Converted from DG Script #48429: Hunt refuse
-- Original: MOB trigger, flags: RECEIVE, probability: 0%

-- DG receive trigger, num_arg 0: the arg list (48429) holds the items
-- other triggers handle; this one runs for every other item. The runtime does not filter on
-- arg_list, so the exclusion lives here. (The converter's percent_chance(0) guard blocked it all.)
local response
if (object.zone_id == 484 and object.id == 29) then
    return true
end
local _return_value = true  -- Default: allow action
-- switch on object.id
do
    response = "Why do you bother the Goddess of the Hunt?"
end
if response then
    _return_value = true
    self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
    wait(0.2)
    actor:send(tostring(self.name) .. " says, '" .. tostring(response) .. "'")
end
return _return_value$trig$, 'e9edb44af0712de39a033cdfd90f1812'),
  -- data/triggers/521/521_12_random_wind_damage.lua
  (521, 12, $trig$-- 25% chance to trigger
if not percent_chance(25) then
    return true
end
-- WORLD/RANDOM triggers fire without an `actor` — pick a random occupant.
if not self.room or not self.room.actors or #self.room.actors == 0 then
    return true
end
wait(0.1)
local rndm = self.room.actors[random(1, #self.room.actors)]
if not rndm then
    return true
end
local dmg = 65
rndm:damage(dmg)  -- type: cold
rndm:send("A strong gust blows in from the north, giving you an awful chill. (<red>" .. tostring(dmg) .. "</>)")
self.room:send_except(rndm, "A strong gust blows in from the north, which seems to chill " .. rndm.name .. ". (<blue>" .. tostring(dmg) .. "</>)")$trig$, '70cc110797a4c8852e97b0ef5632924c'),
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
local right_class = actor.class == "cleric" or actor.class == "priest"
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
end$trig$, '895a7690933f9a887fd8a4de6eb7f808'),
  -- data/triggers/590/590_02_glasscase_break.lua
  (590, 2, $trig$-- Converted from DG Script #59002: glasscase_break
-- Original: OBJECT trigger, flags: COMMAND, probability: 100%

-- Command location mask 100: legacy OCMD_EQUIP=1 (worn), OCMD_INVEN=2 (carried), OCMD_ROOM=4 (floor)
if not (location == "room") then
    return true  -- Not in a location this trigger watches
end

-- Command filter: break
if not (cmd == "break") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
-- you must break glass to get reset sword out
if arg == "glass" or arg == "case" then
    _return_value = false
    -- check to see what PC can break case with
    local item = nil
    if actor:get_worn("shield") then
        item = actor:get_worn("shield")
    elseif actor:get_worn("wield2h") then
        item = actor:get_worn("wield2h")
    elseif actor:get_worn("wield") then
        item = actor:get_worn("wield")
    elseif actor:get_worn("wield2") then
        item = actor:get_worn("wield2")
    elseif actor:get_worn("held") then
        item = actor:get_worn("held")
    elseif actor:get_worn("held2") then
        item = actor:get_worn("held2")
    end
    -- break case with item or hands
    if item then
        actor:send("You smash the glass with " .. tostring(item.shortdesc) .. " and the dusty case shatters into small pieces on the ground.")
        self.room:send_except(actor, tostring(actor.name) .. " smashes the glass with " .. tostring(item.shortdesc) .. " and the dusty case shatters into small pieces on the ground.")
    else
        local damage_dealt = actor:damage(150)  -- type: slash
        if damage_dealt ~= 0 then
            actor:send("You smash the glass with your bare hands, shattering the glass and slicing your hands. (<b:yellow>" .. tostring(damage_dealt) .. "</>)")
            self.room:send_except(actor, tostring(actor.name) .. " smashes the glass with " .. tostring(actor.possessive) .. " bare hands, shattering the glass and slicing deep grooves into " .. tostring(actor.possessive) .. " hands. (<b:yellow>" .. tostring(damage_dealt) .. "</>)")
        else
            actor:send("You smash the glass with your bare hands.")
            self.room:send_except(actor, tostring(actor.name) .. " smashes the glass with " .. tostring(actor.possessive) .. " bare hands.")
        end
    end
    wait(0.1)
    self.room:send("A pristine iridescent sword falls out of the broken case, landing on the ground.")
    -- destroy case and load it in rm 59091 to prevent it from loading here again, as it is a reset item
    -- TODO(parity): both spawn calls reference (590, 24); original DG comment says one should
    -- spawn the iridescent sword in this room while the other respawns the glass case into 590/91.
    -- Verify the correct object IDs and target rooms before using in production.
    self.room:spawn_object(590, 24)
    world.destroy(self.room:find_object("dusty-glass-case"))
    self.room:spawn_object(590, 24)
else
    _return_value = true
end
return _return_value$trig$, '2ee38c356d301834db9b6bbc4335518c')
) AS v(zone_id, id, commands, old_md5)
WHERE t.zone_id = v.zone_id
  AND t.id = v.id
  AND md5(t.commands) = v.old_md5
  AND t.commands IS DISTINCT FROM v.commands;

COMMIT;
