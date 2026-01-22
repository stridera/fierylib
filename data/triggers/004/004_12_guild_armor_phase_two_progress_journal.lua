-- Trigger: Guild Armor Phase Two progress journal
-- Zone: 4, ID: 12
-- Type: OBJECT, Flags: LOOK
-- Status: NEEDS_REVIEW
--   Complex nesting: 28 if statements
--   Large script: 19700 chars
--
-- Original DG Script: #412

-- Converted from DG Script #412: Guild Armor Phase Two progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if ((string.find(arg, "guild") or string.find(arg, "phase") or string.find(arg, "armor")) and (string.find(arg, "two") or string.find(arg, "2"))) or string.find(arg, "guild_armor_phase_two") or string.find(arg, "guild_armor_phase_2") or string.find(arg, "phase_armor_two") or string.find(arg, "phase_armor_2") then
    _return_value = false
    actor:send("<b:green>&uGuild Armor Phase Two</>")
    actor:send("Mininum Level: 21")
    actor:send("Items for this quest drop from mobs between level 21 and 40.")
    if actor:get_quest_stage("phase_armor") > 1 then
        local sorcererclasses = "Sorcerer Cryomancer Pyromancer Illusionist"
        local clericclasses = "Cleric Priest"
        local rogueclasses = "Rogue Mercenary Assassin Thief"
        local anti = "Anti-Paladin"
        if string.find(sorcererclasses, "actor.class") then
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
            if string.find(actor.class, "Sorcerer") then
                local master = "the Archmage of Ickle"
            elseif string.find(actor.class, "Cryomancer") then
                local master = "the Archmage of Ickle, the High Cryomancer, and the master cryomancer"
            elseif string.find(actor.class, "Pyromancer") then
                local master = "the Archmage of Ickle, the High Pyromancer, and the master pyromancer"
            elseif string.find(actor.class, "Illusionist") then
                local master = "the Archmage of Ickle, Erasmus, and Esh"
            end
        elseif string.find(actor.class, "Necromancer") then
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
            local master = "Asiri'Qaxt and Schkerra"
        elseif string.find(clericclasses, "actor.class") then
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
            local master = "the High Priestess of Anduin and Zeno the Priest"
        elseif string.find(actor.class, "Diabolist") then
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
            local master = "the Black Priestess"
        elseif string.find(actor.class, "Druid") then
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
            local master = "the Black Priestess and the diabolist"
        elseif string.find(actor.class, "Warrior") then
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
            local master = "the high druid and a serene druidess"
        elseif actor.class == "anti" then
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
            local master = "the warrior coach of Anduin"
        elseif string.find(actor.class, "Ranger") then
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
            local master = "Galithel Silverwing"
        elseif actor.class == "Paladin" then
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
            local master = "the Grey Knight"
        elseif string.find(actor.class, "Monk") then
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
            local master = "the Head Monk"
        elseif string.find(actor.class, "Berserker") then
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
            local master = "Tozug, Khargol, Jora Granitearm"
        elseif string.find(rogueclasses, "actor.class") then
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
            local master = "Princess Signess, Haren, and Blackhaven"
        elseif string.find(actor.class, "Bard") then
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
            local master = "the Master Herald and the Bard Union Master"
        end
        local got_hands = actor.quest_variable[phase_armor:hands_armor_armor_acquired]
        local got_feet = actor.quest_variable[phase_armor:feet_armor_armor_acquired]
        local got_wrist = actor.quest_variable[phase_armor:wrist_armor_armor_acquired]
        local got_head = actor.quest_variable[phase_armor:head_armor_armor_acquired]
        local got_arms = actor.quest_variable[phase_armor:arms_armor_armor_acquired]
        local got_legs = actor.quest_variable[phase_armor:legs_armor_armor_acquired]
        local got_body = actor.quest_variable[phase_armor:body_armor_armor_acquired]
        local hands_count = actor.quest_variable[phase_armor:hands_gem_gems_acquired]
        local feet_count = actor.quest_variable[phase_armor:feet_gem_gems_acquired]
        local wrist_count = actor.quest_variable[phase_armor:wrist_gem_gems_acquired]
        local head_count = actor.quest_variable[phase_armor:head_gem_gems_acquired]
        local arms_count = actor.quest_variable[phase_armor:arms_gem_gems_acquired]
        local legs_count = actor.quest_variable[phase_armor:legs_gem_gems_acquired]
        local body_count = actor.quest_variable[phase_armor:body_gem_gems_acquired]
        local done_hands = got_hands == 1  and  hands_count == 3
        local done_feet = got_feet == 1  and  feet_count == 3
        local done_wrist = got_wrist == 1  and  wrist_count == 3
        local done_head = got_head == 1  and  head_count == 3
        local done_arms = got_arms == 1  and  arms_count == 3
        local done_legs = got_legs == 1  and  legs_count == 3
        local done_body = got_body == 1  and  body_count == 3
        local given = got_hands + got_feet + got_wrist + got_head + got_arms + got_legs + got_body
        local given = given + hands_count + feet_count + wrist_count + head_count + arms_count + legs_count + body_count
        local unrewarded = (got_hands + hands_count  ~=  4) + (got_feet + feet_count  ~=  4) + (got_wrist + wrist_count  ~=  4)
        local unrewarded = unrewarded + (got_head + head_count  ~=  4) + (got_arms + arms_count  ~=  4)
        local unrewarded = unrewarded + (got_legs + legs_count  ~=  4) + (got_body + body_count  ~=  4)
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
        if done_hands or done_feet or done_wrist or done_head or done_arms or done_legs or done_body then
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
return _return_value