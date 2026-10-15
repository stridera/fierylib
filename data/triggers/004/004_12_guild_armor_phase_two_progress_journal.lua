-- Trigger: Guild Armor Phase Two progress journal
-- Zone: 4, ID: 12
-- Type: OBJECT, Flags: LOOK
-- Status: CLEAN
--
-- Original DG Script: #412

-- Converted from DG Script #412: Guild Armor Phase Two progress journal
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
        local hands_armor, hands_gem, feet_armor, feet_gem, wrist_armor, wrist_gem, head_armor, head_gem, arms_armor, arms_gem, legs_armor, legs_gem, body_armor, body_gem, hands_reward, feet_reward, wrist_reward, head_reward, arms_reward, legs_reward, body_reward
        if string.find(string.lower(sorcererclasses), actor.class, 1, true) then
            feet_gem = 55613
            head_gem = 55635
            hands_gem = 55602
            arms_gem = 55646
            legs_gem = 55657
            body_gem = 55668
            wrist_gem = 55624
            feet_armor = 55335
            head_armor = 55343
            hands_armor = 55331
            arms_armor = 55347
            legs_armor = 55351
            body_armor = 55355
            wrist_armor = 55339
            feet_reward = 55479
            head_reward = 55475
            hands_reward = 55481
            arms_reward = 55476
            legs_reward = 55478
            body_reward = 55477
            wrist_reward = 55480
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
            feet_gem = 55609
            head_gem = 55631
            hands_gem = 55598
            arms_gem = 55642
            legs_gem = 55653
            body_gem = 55664
            wrist_gem = 55620
            feet_armor = 55335
            head_armor = 55343
            hands_armor = 55331
            arms_armor = 55347
            legs_armor = 55351
            body_armor = 55355
            wrist_armor = 55339
            feet_reward = 55458
            head_reward = 55454
            hands_reward = 55460
            arms_reward = 55455
            legs_reward = 55457
            body_reward = 55456
            wrist_reward = 55459
            master = "Asiri'Qaxt and Schkerra"
        elseif string.find(string.lower(clericclasses), actor.class, 1, true) then
            feet_gem = 55612
            head_gem = 55634
            hands_gem = 55601
            arms_gem = 55645
            legs_gem = 55656
            body_gem = 55667
            wrist_gem = 55623
            feet_armor = 55332
            head_armor = 55340
            hands_armor = 55328
            arms_armor = 55344
            legs_armor = 55348
            body_armor = 55352
            wrist_armor = 55336
            feet_reward = 55437
            head_reward = 55433
            hands_reward = 55439
            arms_reward = 55434
            legs_reward = 55436
            body_reward = 55435
            wrist_reward = 55438
            master = "the High Priestess of Anduin and Zeno the Priest"
        elseif string.find(actor.class, "diabolist") then
            feet_gem = 55606
            head_gem = 55628
            hands_gem = 55595
            arms_gem = 55639
            legs_gem = 55650
            body_gem = 55661
            wrist_gem = 55617
            feet_armor = 55332
            head_armor = 55340
            hands_armor = 55328
            arms_armor = 55344
            legs_armor = 55348
            body_armor = 55352
            wrist_armor = 55336
            feet_reward = 55472
            head_reward = 55468
            hands_reward = 55474
            arms_reward = 55469
            legs_reward = 55471
            body_reward = 55470
            wrist_reward = 55473
            master = "the Black Priestess"
        elseif string.find(actor.class, "druid") then
            feet_gem = 55607
            head_gem = 55629
            hands_gem = 55596
            arms_gem = 55640
            legs_gem = 55651
            body_gem = 55662
            wrist_gem = 55618
            feet_armor = 55334
            head_armor = 55342
            hands_armor = 55330
            arms_armor = 55346
            legs_armor = 55350
            body_armor = 55354
            wrist_armor = 55338
            feet_reward = 55451
            head_reward = 55447
            hands_reward = 55453
            arms_reward = 55448
            legs_reward = 55450
            body_reward = 55449
            wrist_reward = 55452
            master = "the Black Priestess and the diabolist"
        elseif string.find(actor.class, "warrior") then
            feet_gem = 55615
            head_gem = 55637
            hands_gem = 55604
            arms_gem = 55648
            legs_gem = 55659
            body_gem = 55670
            wrist_gem = 55626
            feet_armor = 55332
            head_armor = 55340
            hands_armor = 55328
            arms_armor = 55344
            legs_armor = 55348
            body_armor = 55352
            wrist_armor = 55336
            feet_reward = 55416
            head_reward = 55412
            hands_reward = 55418
            arms_reward = 55413
            legs_reward = 55415
            body_reward = 55414
            wrist_reward = 55417
            master = "the high druid and a serene druidess"
        elseif actor.class == "anti-paladin" then
            feet_gem = 55605
            head_gem = 55627
            hands_gem = 55594
            arms_gem = 55638
            legs_gem = 55649
            body_gem = 55660
            wrist_gem = 55616
            feet_armor = 55332
            head_armor = 55340
            hands_armor = 55328
            arms_armor = 55344
            legs_armor = 55348
            body_armor = 55352
            wrist_armor = 55336
            feet_reward = 55430
            head_reward = 55426
            hands_reward = 55432
            arms_reward = 55427
            legs_reward = 55429
            body_reward = 55428
            wrist_reward = 55431
            master = "the warrior coach of Anduin"
        elseif string.find(actor.class, "ranger") then
            feet_gem = 55611
            head_gem = 55633
            hands_gem = 55600
            arms_gem = 55644
            legs_gem = 55655
            body_gem = 55666
            wrist_gem = 55622
            feet_armor = 55333
            head_armor = 55341
            hands_armor = 55329
            arms_armor = 55345
            legs_armor = 55349
            body_armor = 55353
            wrist_armor = 55337
            feet_reward = 55444
            head_reward = 55440
            hands_reward = 55446
            arms_reward = 55441
            legs_reward = 55443
            body_reward = 55442
            wrist_reward = 55445
            master = "Galithel Silverwing"
        elseif actor.class == "paladin" then
            feet_gem = 55610
            head_gem = 55632
            hands_gem = 55599
            arms_gem = 55643
            legs_gem = 55654
            body_gem = 55665
            wrist_gem = 55621
            feet_armor = 55332
            head_armor = 55340
            hands_armor = 55328
            arms_armor = 55344
            legs_armor = 55348
            body_armor = 55352
            wrist_armor = 55336
            feet_reward = 55423
            head_reward = 55419
            hands_reward = 55425
            arms_reward = 55420
            legs_reward = 55422
            body_reward = 55421
            wrist_reward = 55424
            master = "the Grey Knight"
        elseif string.find(actor.class, "monk") then
            feet_gem = 55608
            head_gem = 55630
            hands_gem = 55597
            arms_gem = 55641
            legs_gem = 55652
            body_gem = 55663
            wrist_gem = 55619
            feet_armor = 55334
            head_armor = 55342
            hands_armor = 55330
            arms_armor = 55346
            legs_armor = 55350
            body_armor = 55354
            wrist_armor = 55338
            feet_reward = 55465
            head_reward = 55461
            hands_reward = 55467
            arms_reward = 55462
            legs_reward = 55464
            body_reward = 55463
            wrist_reward = 55466
            master = "the Head Monk"
        elseif string.find(actor.class, "berserker") then
            feet_gem = 55607
            head_gem = 55631
            hands_gem = 55595
            arms_gem = 55638
            legs_gem = 55655
            body_gem = 55665
            wrist_gem = 55619
            feet_armor = 55334
            head_armor = 55342
            hands_armor = 55330
            arms_armor = 55346
            legs_armor = 55350
            body_armor = 55354
            wrist_armor = 55338
            feet_reward = 55771
            head_reward = 55767
            hands_reward = 55773
            arms_reward = 55768
            legs_reward = 55770
            body_reward = 55769
            wrist_reward = 55772
            master = "Tozug, Khargol, Jora Granitearm"
        elseif string.find(string.lower(rogueclasses), actor.class, 1, true) then
            feet_gem = 55614
            head_gem = 55636
            hands_gem = 55603
            arms_gem = 55647
            legs_gem = 55658
            body_gem = 55669
            wrist_gem = 55625
            feet_armor = 55333
            head_armor = 55341
            hands_armor = 55329
            arms_armor = 55345
            legs_armor = 55349
            body_armor = 55353
            wrist_armor = 55337
            feet_reward = 55486
            head_reward = 55482
            hands_reward = 55488
            arms_reward = 55483
            legs_reward = 55485
            body_reward = 55484
            wrist_reward = 55487
            master = "Princess Signess, Haren, and Blackhaven"
        elseif string.find(actor.class, "bard") then
            feet_gem = 55606
            head_gem = 55630
            hands_gem = 55600
            arms_gem = 55640
            legs_gem = 55649
            body_gem = 55664
            wrist_gem = 55621
            feet_armor = 55334
            head_armor = 55342
            hands_armor = 55330
            arms_armor = 55346
            legs_armor = 55350
            body_armor = 55354
            wrist_armor = 55338
            feet_reward = 55785
            head_reward = 55781
            hands_reward = 55787
            arms_reward = 55782
            legs_reward = 55784
            body_reward = 55783
            wrist_reward = 55786
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
        actor:send("</>  " .. proto_short(hands_armor) .. " and 3 of " .. proto_short(hands_gem))
        actor:send("</>  " .. proto_short(feet_armor) .. " and 3 of " .. proto_short(feet_gem))
        actor:send("</>  " .. proto_short(wrist_armor) .. " and 3 of " .. proto_short(wrist_gem))
        actor:send("</>  " .. proto_short(head_armor) .. " and 3 of " .. proto_short(head_gem))
        actor:send("</>  " .. proto_short(arms_armor) .. " and 3 of " .. proto_short(arms_gem))
        actor:send("</>  " .. proto_short(legs_armor) .. " and 3 of " .. proto_short(legs_gem))
        actor:send("</>  " .. proto_short(body_armor) .. " and 3 of " .. proto_short(body_gem))
        if given == 0 then
            actor:send("You haven't retrieved anything yet.")
            return _return_value
        elseif unrewarded > 0 then
            actor:send("You have found:")
        end
        if got_hands and not done_hands then
            actor:send("</>  " .. proto_short(hands_armor))
        end
        if hands_count and not done_hands then
            actor:send("</>  " .. tostring(hands_count) .. " of " .. proto_short(hands_gem))
        end
        if got_feet and not done_feet then
            actor:send("</>  " .. proto_short(feet_armor))
        end
        if feet_count and not done_feet then
            actor:send("</>  " .. tostring(feet_count) .. " of " .. proto_short(feet_gem))
        end
        if got_wrist and not done_wrist then
            actor:send("</>  " .. proto_short(wrist_armor))
        end
        if wrist_count and not done_wrist then
            actor:send("</>  " .. tostring(wrist_count) .. " of " .. proto_short(wrist_gem))
        end
        if got_head and not done_head then
            actor:send("</>  " .. proto_short(head_armor))
        end
        if head_count and not done_head then
            actor:send("</>  " .. tostring(head_count) .. " of " .. proto_short(head_gem))
        end
        if got_arms and not done_arms then
            actor:send("</>  " .. proto_short(arms_armor))
        end
        if arms_count and not done_arms then
            actor:send("</>  " .. tostring(arms_count) .. " of " .. proto_short(arms_gem))
        end
        if got_legs and not done_legs then
            actor:send("</>  " .. proto_short(legs_armor))
        end
        if legs_count and not done_legs then
            actor:send("</>  " .. tostring(legs_count) .. " of " .. proto_short(legs_gem))
        end
        if got_body and not done_body then
            actor:send("</>  " .. proto_short(body_armor))
        end
        if body_count and not done_body then
            actor:send("</>  " .. tostring(body_count) .. " of " .. proto_short(body_gem))
        end
        if done_hands and done_feet and done_wrist and done_head and done_arms and done_legs and done_body then
            actor:send("</>")
            actor:send("You have completed quests for:")
        end
        if done_hands then
            actor:send("</>  " .. proto_short(hands_reward))
        end
        if done_feet then
            actor:send("</>  " .. proto_short(feet_reward))
        end
        if done_wrist then
            actor:send("</>  " .. proto_short(wrist_reward))
        end
        if done_head then
            actor:send("</>  " .. proto_short(head_reward))
        end
        if done_arms then
            actor:send("</>  " .. proto_short(arms_reward))
        end
        if done_legs then
            actor:send("</>  " .. proto_short(legs_reward))
        end
        if done_body then
            actor:send("</>  " .. proto_short(body_reward))
        end
    else
        actor:send("<cyan>Status: Not Started</>")
    end
end
return _return_value