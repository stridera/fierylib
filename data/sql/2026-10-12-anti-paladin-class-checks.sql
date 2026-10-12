-- Anti-Paladin class checks: actor.class is the lowercase class name 'anti-paladin' (the converter's 'anti' never matched)
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
  -- data/triggers/004/004_02_equipment_quests.lua
  (4, 2, $trig$-- Converted from DG Script #402: Equipment quests
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if string.find(arg, "equipment") then
    _return_value = true
    local anti = "Anti-Paladin"
    local hunterclasses = "Warrior Ranger Berserker Mercenary"
    local sorcererclasses = "Sorcerer Illusionist Cryomancer Pyromancer Necromancer"
    actor:send("<yellow>=========== EQUIPMENT QUESTS ========<==/>")
    actor:send("These quests often take a large amount of time to complete, spanning dozens of levels.")
    actor:send("Characters should expect to need large numbers of unique and hard-to-find items.")
    actor:send("They are generally not intended to be completed quickly.")
    actor:send("<b:yellow>[Look]</> at the key words in a quest title for your current status.")
    actor:send("<yellow>=====================================<==/>_")
    actor:send("<b:green>AVAILABLE QUESTS:</>_")
    actor:send("<b:green>&uGuild Armor Phase One</>")
    actor:send("Crafters across Ethilien will ask you to bring them gems and junked up armor so they can fix it up and present you with something new.")
    actor:send("Your home guild master is always the best place to start.")
    actor:send("Min Level: 1")
    local status
    if actor:get_quest_stage("phase_armor") then
        status = "In Progress"
    else
        status = "Not Started"
    end
    actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
    actor:send("<b:green>&uGuild Armor Phase Two</>")
    actor:send("Crafters across Ethilien will ask you to bring them gems and junked up armor so they can fix it up and present you with something new.")
    actor:send("Min Level: 21")
    local status
    if actor:get_quest_stage("phase_armor") >= 2 then
        status = "In Progress"
    else
        status = "Not Started"
    end
    actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
    actor:send("<b:green>&uGuild Armor Phase Three</>")
    actor:send("Crafters across Ethilien will ask you to bring them gems and junked up armor so they can fix it up and present you with something new.")
    actor:send("Min Level: 41")
    local status
    if actor:get_quest_stage("phase_armor") >= 3 then
        status = "In Progress"
    else
        status = "Not Started"
    end
    actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
    if string.find(sorcererclasses, actor.class) then
        actor:send("<b:green>&uAcid Wand</>")
        actor:send("Masters of earth will help you create and upgrade a new mystic weapon.")
        local status
        if actor:get_has_completed("acid_wand") then
            status = "Completed!"
        elseif actor:get_quest_stage("acid_wand") then
            status = "In Progress"
        else
            status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
        actor:send("<b:green>&uAir Wand</>")
        actor:send("Masters of air will help you create and upgrade a new mystic weapon.")
        local status
        if actor:get_has_completed("air_wand") then
            status = "Completed!"
        elseif actor:get_quest_stage("air_wand") then
            status = "In Progress"
        else
            status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
        actor:send("<b:green>&uFire Wand</>")
        actor:send("Masters of fire will help you create and upgrade a new mystic weapon.")
        local status
        if actor:get_has_completed("fire_wand") then
            status = "Completed!"
        elseif actor:get_quest_stage("fire_wand") then
            status = "In Progress"
        else
            status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
        actor:send("<b:green>&uIce Wand</>")
        actor:send("Masters of ice and water will help you create and upgrade a new mystic weapon.")
        local status
        if actor:get_has_completed("ice_wand") then
            status = "Completed!"
        elseif actor:get_quest_stage("ice_wand") then
            status = "In Progress"
        else
            status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
    end
    if string.find(actor.class, "Assassin") then
        actor:send("<b:green>&uDeadly Promotion</>")
        actor:send("Assassins who have proven to be efficient bounty hunters can work their way up in the Guild to earn special masks.")
        local status
        if actor:get_has_completed("assassin_mask") then
            status = "Completed!"
        elseif actor:get_quest_stage("assassin_mask") then
            status = "In Progress"
        else
            status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
    end
    if string.find(actor.class, "Priest") or string.find(actor.class, "Cleric") then
        actor:send("Clerics and priests can make pilgrimages to various spiritual masters to craft weapons to smite the undead.")
        actor:send("<b:green>&uSpirit Maces</>")
        local status
        if actor:get_has_completed("phase_mace") then
            status = "Completed!"
        elseif actor:get_quest_stage("phase_mace") then
            status = "In Progress"
        else
            status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
    end
    if string.find(actor.class, "Paladin") or actor.class == "anti-paladin" then
        actor:send("<b:green>&uDivine Devotion</>")
        actor:send("Prove your devotion to your cause after slaying a dragon, be it justtice or destruction, and receive a divine reward.")
        local status
        if actor:get_has_completed("paladin_pendant") then
            status = "Completed!"
        elseif actor:get_quest_stage("paladin_pendant") then
            status = "In Progress"
        else
            status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
    end
    if string.find(hunterclasses, actor.class) then
        actor:send("<b:green>&uEye of the Tiger</>")
        actor:send("Mighty warriors who have bested the biggest beasts can further prove their skills to earn special trophies.")
        local status
        if actor:get_has_completed("ranger_trophy") then
            status = "Completed!"
        elseif actor:get_quest_stage("ranger_trophy") then
            status = "In Progress"
        else
            status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
    end
    if string.find(actor.class, "thief") or string.find(actor.class, "rogue") or string.find(actor.class, "bard") then
        actor:send("<b:green>&uCloak and Shadow</>")
        actor:send("Work your way up the ranks of the cloak and dagger guilds.")
        local status
        if actor:get_has_completed("ranger_trophy") then
            status = "Completed!"
        elseif actor:get_quest_stage("ranger_trophy") then
            status = "In Progress"
        else
            status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
    end
    if actor.level >= 25 then
        actor:send("<b:green>&uIn Service of Lolth</>")
        actor:send("Carry out the bidding of the hideous Spider Queen and her malevolent servants.")
        actor:send("This quest is only available to neutral and evil-aligned characters.")
        actor:send("Recommended Level: 90")
        actor:send("- This quest starts at level 25 and continues through level 90.")
        local status
        if actor:get_has_completed("vilekka_stew") then
            status = "Completed!"
        elseif actor:get_quest_stage("vilekka_stew") then
            status = "In Progress"
        else
            status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
        actor:send("<b:green>&uInfiltrate the Sacred Haven</>")
        actor:send("A shadowy figure lurks outside a holy fortress, intent on getting back what belongs to them.")
        actor:send("This quest is only available to neutral and evil-aligned characters.")
        actor:send("Recommended Level: 35")
        local status
        if actor:get_quest_stage("sacred_haven") then
            status = "Repeatable"
        else
            status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
    end
    if actor.level >= 35 then
        actor:send("<b:green>&uMystery of the Rhell Forest</>")
        actor:send("Find the sick merchant in the Rhell Forest and help end his distress.")
        actor:send("Recommended Level: 45")
        local status
        if actor:get_has_completed("ursa_quest") then
            status = "Completed!"
        elseif actor:get_quest_stage("ursa_quest") then
            status = "In Progress"
        else
            status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
    end
    if actor.level >= 45 then
        if string.find(actor.race, "Troll") then
            actor:send("<b:green>&uTribal Trouble</>")
            actor:send("Trolls need to stick together!")
            actor:send("Return lost symbols of station and be greatly rewarded.")
            actor:send("Minimum Level: 55")
            local status
            if actor:get_has_completed("troll_quest") then
                status = "Completed!"
            elseif actor:get_quest_stage("troll_mask") then
                status = "In Progress"
            else
                status = "Not Started"
            end
            actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
        end
    end
    if actor.level >= 50 then
        actor:send("<b:green>&uThe Great Rite</>")
        actor:send("A group of witches has uncovered a powerful set of massive standing stones.")
        actor:send("Help them with their mystic ritual.")
        actor:send("Recommended Level: 70")
        actor:send("- This quest can be started at any level but requires level 70 to finish.")
        local status
        if actor:get_has_completed("megalith_quest") then
            status = "Completed!"
        elseif actor:get_has_failed("megalith_quest") then
            status = "Failed"
        elseif actor:get_quest_stage("megalith_quest") then
            status = "In Progress"
        else
            status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
        actor:send("<b:green>&uPhoenix Sous Chef</>")
        actor:send("Create the meal of a lifetime!")
        actor:send("Recommended Level: 90")
        actor:send("- This quest can be started at any level but level 90+ is the intended finishing point.")
        local status
        if actor:get_has_completed("resort_cooking") then
            status = "Completed!"
        elseif actor:get_quest_stage("resort_cooking") then
            status = "In Progress"
        else
            status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
    end
    if actor.level >= 75 then
        actor:send("<b:green>&uPower of Flame</>")
        actor:send("Reunite the flame to hold its power in your hand.")
        actor:send("Recommended Level: 85")
        actor:send("- This quest can be started at any level but requires level 85 to finish.")
        actor:send("- This quest is repeatable.")
        local status
        if actor:get_has_completed("emmath_flameball") then
            status = "Completed!"
        elseif actor:get_quest_stage("emmath_flameball") then
            status = "In Progress"
        else
            status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
    end
    if actor.level >= 80 then
        actor:send("<b:green>&uSunfire Rescue</>")
        actor:send("Recover ancient relics and rescue a long-lost prisoner.")
        actor:send("This quest is only available to good-aligned characters.")
        actor:send("Recommended Level: 85")
        actor:send("- This quest can be started at any level but requires level 85 to finish.")
        local status
        if actor:get_has_completed("sunfire_rescue") then
            status = "Completed!"
        elseif actor:get_quest_stage("sunfire_rescue") then
            status = "In Progress"
        else
            status = "Not Started"
        end
        actor:send("<cyan>Status: " .. tostring(status) .. "</>_")
    end
end
return _return_value$trig$, '2a430ee28457c3a94089347c00fc9e0c'),
  -- data/triggers/004/004_12_guild_armor_phase_two_progress_journal.lua
  (4, 12, $trig$-- Converted from DG Script #412: Guild Armor Phase Two progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if ((string.find(arg, "guild") or string.find(arg, "phase") or string.find(arg, "armor")) and (string.find(arg, "two") or string.find(arg, "2"))) or string.find(arg, "guild_armor_phase_two") or string.find(arg, "guild_armor_phase_2") or string.find(arg, "phase_armor_two") or string.find(arg, "phase_armor_2") then
    _return_value = true
    actor:send("<b:green>&uGuild Armor Phase Two</>")
    actor:send("Mininum Level: 21")
    actor:send("Items for this quest drop from mobs between level 21 and 40.")
    if actor:get_quest_stage("phase_armor") > 1 then
        local sorcererclasses = "Sorcerer Cryomancer Pyromancer Illusionist"
        local clericclasses = "Cleric Priest"
        local rogueclasses = "Rogue Mercenary Assassin Thief"
        local anti = "Anti-Paladin"
        local master
        if string.find(sorcererclasses, actor.class) then
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
                master = "the Archmage of Ickle"
            elseif string.find(actor.class, "Cryomancer") then
                master = "the Archmage of Ickle, the High Cryomancer, and the master cryomancer"
            elseif string.find(actor.class, "Pyromancer") then
                master = "the Archmage of Ickle, the High Pyromancer, and the master pyromancer"
            elseif string.find(actor.class, "Illusionist") then
                master = "the Archmage of Ickle, Erasmus, and Esh"
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
            master = "Asiri'Qaxt and Schkerra"
        elseif string.find(clericclasses, actor.class) then
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
            master = "the Black Priestess"
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
            master = "the Black Priestess and the diabolist"
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
            master = "Galithel Silverwing"
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
            master = "the Grey Knight"
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
            master = "the Head Monk"
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
            master = "Tozug, Khargol, Jora Granitearm"
        elseif string.find(rogueclasses, actor.class) then
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
        local done_hands = got_hands == 1  and  hands_count == 3
        local done_feet = got_feet == 1  and  feet_count == 3
        local done_wrist = got_wrist == 1  and  wrist_count == 3
        local done_head = got_head == 1  and  head_count == 3
        local done_arms = got_arms == 1  and  arms_count == 3
        local done_legs = got_legs == 1  and  legs_count == 3
        local done_body = got_body == 1  and  body_count == 3
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
return _return_value$trig$, '149f769936fba74a3139f544f776d2f8'),
  -- data/triggers/004/004_13_guild_armor_phase_three_progress_journal.lua
  (4, 13, $trig$-- Converted from DG Script #413: Guild Armor Phase Three progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if ((string.find(arg, "guild") or string.find(arg, "phase") or string.find(arg, "armor")) and (string.find(arg, "three") or string.find(arg, "3"))) or string.find(arg, "guild_armor_phase_three") or string.find(arg, "guild_armor_phase_3") or string.find(arg, "phase_armor_three") or string.find(arg, "phase_armor_3") then
    _return_value = true
    actor:send("<b:green>&uGuild Armor Phase Three</>")
    actor:send("Mininum Level: 41")
    actor:send("Items for this quest drop from mobs above level 41.")
    if actor:get_quest_stage("phase_armor") > 2 then
        local sorcererclasses = "Sorcerer Cryomancer Pyromancer Illusionist"
        local clericclasses = "Cleric Priest"
        local rogueclasses = "Rogue Mercenary Assassin Thief"
        local anti = "Anti-Paladin"
        local master
        if string.find(sorcererclasses, actor.class) then
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
            if string.find(actor.class, "Sorcerer") then
                master = "the Archmage of Anduin"
            elseif string.find(actor.class, "Cryomancer") then
                master = "a cryomancer in Anduin"
            elseif string.find(actor.class, "Pyromancer") then
                master = "a pyromancer in Anduin"
            elseif string.find(actor.class, "Illusionist") then
                master = "Aylana in Anduin"
            end
        elseif string.find(actor.class, "Necromancer") then
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
        elseif string.find(clericclasses, actor.class) then
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
        elseif string.find(actor.class, "Diabolist") then
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
        elseif string.find(actor.class, "Druid") then
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
        elseif string.find(actor.class, "Warrior") then
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
        elseif string.find(actor.class, "Ranger") then
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
        elseif actor.class == "Paladin" then
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
        elseif string.find(actor.class, "Monk") then
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
        elseif string.find(actor.class, "Berserker") then
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
        elseif string.find(rogueclasses, actor.class) then
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
        elseif string.find(actor.class, "Bard") then
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
        local done_hands = got_hands == 1  and  hands_count == 3
        local done_feet = got_feet == 1  and  feet_count == 3
        local done_wrist = got_wrist == 1  and  wrist_count == 3
        local done_head = got_head == 1  and  head_count == 3
        local done_arms = got_arms == 1  and  arms_count == 3
        local done_legs = got_legs == 1  and  legs_count == 3
        local done_body = got_body == 1  and  body_count == 3
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
return _return_value$trig$, 'e10dd1635269e1414ef2a89c4989cbc3'),
  -- data/triggers/004/004_58_divine_devotion_progress_journal.lua
  (4, 58, $trig$-- Converted from DG Script #458: Divine Devotion progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if string.find(arg, "divine") or string.find(arg, "devotion") or string.find(arg, "divine_devotion") or string.find(arg, "paladin_pendant") or string.find(arg, "paladin pendant") then
    local anti = "Anti-Paladin"
    if string.find(actor.class, "Paladin") or actor.class == "anti-paladin" then
        _return_value = true
        local huntstage = actor:get_quest_stage("dragon_slayer")
        local pendantstage = actor:get_quest_stage("paladin_pendant")
        local master = mobiles.template(30, 80).name
        local job1 = actor:get_quest_var("paladin_pendant:necklacetask1")
        local job2 = actor:get_quest_var("paladin_pendant:necklacetask2")
        local job3 = actor:get_quest_var("paladin_pendant:necklacetask3")
        local job4 = actor:get_quest_var("paladin_pendant:necklacetask4")
        actor:send("<b:green>&uDivine Devotion</>")
        local level
        if not pendantstage then
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
        elseif pendantstage then
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
            if pendantstage == 1 then
                necklace = 12003
                gem = 55582
                place = "The Mist Temple Altar"
                hint = "in the Misty Caverns."
            elseif pendantstage == 2 then
                necklace = 23708
                gem = 55590
                place = "Chamber of Chaos"
                hint = "in the Temple of Chaos."
            elseif pendantstage == 3 then
                necklace = 58005
                gem = 55622
                place = "Altar of Borgan"
                hint = "in the lost city of Nymrill."
            elseif pendantstage == 4 then
                necklace = 48123
                gem = 55654
                place = "A Hidden Altar Room"
                hint = "in a cave in South Caelia's Wailing Mountains."
            elseif pendantstage == 5 then
                necklace = 12336
                gem = 55662
                place = "The Altar of the Snow Leopard Order"
                hint = "buried deep in Mt. Frostbite"
            elseif pendantstage == 6 then
                necklace = 43019
                gem = 55677
                place = "Chapel Altar"
                hint = "deep underground in a lost castle."
            elseif pendantstage == 7 then
                necklace = 37015
                gem = 55709
                place = "A Cliffside Altar"
                hint = "tucked away in the land of Dreams."
            elseif pendantstage == 8 then
                necklace = 58429
                gem = 55738
                place = "Dark Altar"
                hint = "entombed with an ancient evil king."
            elseif pendantstage == 9 then
                necklace = 52010
                gem = 55739
                place = "An Altar"
                hint = "far away in the Plane of Air."
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
        end
    end
end
return _return_value$trig$, '3e0dc637f3dc26cbfbec7f3298bc8581'),
  -- data/triggers/030/030_80_dragon_slayer_isilynor_greet.lua
  (30, 80, $trig$-- Converted from DG Script #3080: Dragon Slayer Isilynor Greet
-- Original: MOB trigger, flags: GREET_ALL, probability: 100%
wait(2)
local anti = "Anti-Paladin"
if not actor:get_has_completed("dragon_slayer") then
    if not actor:get_quest_stage("dragon_slayer") then
        if actor.level > 4 then
            actor:send(tostring(self.name) .. " says, 'Hail!  I am Isilynor, Grand Master of the Knights of Dragonfire, a guild of professional dragon slayers.  We're always seeking bold recruits to <b:cyan>[hunt]</> the great dragons of the world.  I reward those who put their mettle to the test.'")
        end
    elseif actor:get_quest_var("dragon_slayer:hunt") == "running" then
        actor:send(tostring(self.name) .. " says, 'You're still on the hunt.  What are you doing here?  If you lost your notice say <b:cyan>\"I need a new notice\"</>.'")
    elseif actor:get_quest_var("dragon_slayer:hunt") == "dead" then
        actor:send(tostring(self.name) .. " says, 'Welcome back!  If your hunt was successful give me your notice.  If you lost your notice say <b:cyan>\"I need a new notice\"</>.'")
    elseif actor:get_quest_stage("dragon_slayer") >= 1 and not actor:get_has_completed("dragon_slayer") then
        actor:send(tostring(self.name) .. " says, 'Ah, back for another dragon to <b:cyan>[hunt]</> I see.'")
    end
    if not actor:get_has_completed("paladin_pendant") and actor.level > 9 and (string.find(actor.class, "Paladin") or string.find(actor.class, "anti")) then
        wait(1)
        actor:send(tostring(self.name) .. " says, 'Or maybe you're here to discuss your <b:cyan>[devotion]</> to the cause.'")
    end
else
    if (string.find(actor.class, "Paladin") or actor.class == "anti-paladin") and not actor:get_quest_stage("paladin_pendant") and actor.level > 9 then
        actor:send(tostring(self.name) .. " says, 'A new recruit looking to prove your <b:cyan>[devotion]</> to the cause.'")
    elseif actor:get_quest_stage("paladin_pendant") and not actor:get_has_completed("paladin_pendant") then
        actor:send(tostring(self.name) .. " says, 'Ah, you must be looking to prove your <b:cyan>[devotion]</> again.'")
    end
end$trig$, 'd3d44eb12632b626c2f5b5a542faad7f'),
  -- data/triggers/030/030_87_paladin_pendant_isilynor_speech.lua
  (30, 87, $trig$-- Converted from DG Script #3087: Paladin pendant Isilynor speech
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: devotion
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "devotion")) then
    return true  -- No matching keywords
end
local anti = "Anti-Paladin"
local pendantstage = actor:get_quest_stage("paladin_pendant")
local huntstage = actor:get_quest_stage("dragon_slayer")
local job1 = actor:get_quest_var("paladin_pendant:necklacetask1")
local job2 = actor:get_quest_var("paladin_pendant:necklacetask2")
local job3 = actor:get_quest_var("paladin_pendant:necklacetask3")
local job4 = actor:get_quest_var("paladin_pendant:necklacetask4")
wait(2)
if actor.class ~= "Paladin" and actor.class ~= "anti-paladin" then
    self:command("shake")
    actor:send(tostring(self.name) .. " says, 'Such acts are only for warriors of Justice or Destruction.'")
    return _return_value
elseif actor.level < 10 then
    actor:send(tostring(self.name) .. " says, 'You aren't ready for such an act yet.  Come back when you've grown a bit.'")
    return _return_value
elseif actor.level < (pendantstage * 10) then
    self:say("You aren't ready for another devotional act yet.  Come back when you've gained some more experience.")
    return _return_value
elseif actor:get_has_completed("paladin_pendant") then
    actor:send(tostring(self.name) .. " says, 'You've already proven your devotion as much as possible!'")
    return _return_value
end
if pendantstage == 0 then
    self.room:send(tostring(self.name) .. " says, 'Sure.  You must <b:cyan>[hunt]</> a dragon first though.'")
    return _return_value
elseif (pendantstage >= huntstage) and not actor:get_has_completed("dragon_slayer") then
    actor:send(tostring(self.name) .. " says, 'Slay a few more dragons then we can talk.'")
    return _return_value
elseif job1 and job2 and job3 and job4 then
    actor:send(tostring(self.name) .. " says, 'You're all ready, just give me your old necklace.'")
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
local attacks = pendantstage * 100
self:command("nod")
actor:send(tostring(self.name) .. " says, 'With each act of devotion you'll earn a new necklace.  Undertake the following:")
actor:send("- Attack <b:yellow>" .. tostring(attacks) .. "</> times while wearing your current necklace.")
actor:send("- Find <b:yellow>" .. "%get.obj_shortdesc[%necklace%]%</> as the base for the new necklace.")
actor:send("- Find <b:yellow>" .. "%get.obj_shortdesc[%gem%]%</> for decoration.")
actor:send("</>")
actor:send("You also need to take your necklace and <b:yellow>[pray]</> in a sanctified space.")
actor:send("Find \"<b:yellow>" .. tostring(place) .. "</>\".  It's " .. tostring(hint))
actor:send("</>")
actor:send("You can ask about your <b:cyan>[progress]</> at any time.'")$trig$, '8f143484436d8a10d6d5b52c0347d715'),
  -- data/triggers/030/030_88_paladin_pendant_command_pray.lua
  (30, 88, $trig$-- Converted from DG Script #3088: Paladin pendant command pray
-- Original: OBJECT trigger, flags: COMMAND, probability: 3%

-- Command location mask 3: legacy OCMD_EQUIP=1 (worn), OCMD_INVEN=2 (carried), OCMD_ROOM=4 (floor)
if not (location == "equip" or location == "inventory") then
    return true  -- Not in a location this trigger watches
end

-- Command filter: pray
if not (cmd == "pray") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
-- switch on cmd
if cmd == "p" then
    _return_value = true
    return _return_value
end
local anti = "Anti-Paladin"
local pendantstage = actor:get_quest_stage("paladin_pendant")
-- switch on self.id
local continue
if actor.room == 5479 and pendantstage == 1 then
    if self.id == 360 then
        continue = "yes"
    end
    if (actor.room == 17345 or actor.room == 17346 or actor.room == 17351 or actor.room == 17352) and pendantstage == 2 then
    elseif self.id == 361 then
        continue = "yes"
    end
    if actor.room == 49516 and pendantstage == 3 then
    elseif self.id == 362 then
        continue = "yes"
    end
    if actor.room == 2408 and pendantstage == 4 then
    elseif self.id == 363 then
        continue = "yes"
    end
    if actor.room == 55105 and pendantstage == 5 then
    elseif self.id == 364 then
        continue = "yes"
    end
    if actor.room == 53159 and pendantstage == 6 then
    elseif self.id == 365 then
        continue = "yes"
    end
    if actor.room == 58424 and pendantstage == 7 then
    elseif self.id == 366 then
        continue = "yes"
    end
    if actor.room == 48032 and pendantstage == 8 then
    elseif self.id == 367 then
        continue = "yes"
    end
    if actor.room == 48880 and pendantstage == 9 then
    elseif self.id == 368 then
        continue = "yes"
    end
end
if continue == "yes" then
    actor:command("pray")
    wait(2)
    if actor.class == "Paladin" then
        actor:send("<b:yellow>You have gained new insights on your righteous cause!</>")
    elseif actor.class == "anti-paladin" then
        actor:send("<b:red>You have gained new insights on your ruinouse cause!</>")
    end
    actor:set_quest_var("paladin_pendant", "necklacetask4", 1)
else
    _return_value = true
end
return _return_value$trig$, '3941051b68074f12af66bc84f7e20934'),
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
end$trig$, '0790d6619b0309fd9e2b38a47ff97e94'),
  -- data/triggers/553/553_11_phase_1_warrior_greet.lua
  (553, 11, $trig$-- Converted from DG Script #55311: phase_1_warrior_greet
-- Original: MOB trigger, flags: GREET, probability: 100%
wait(2)
local WARRIOR_SUB = (actor.class == "warrior" or actor.class == "paladin" or actor.class == "anti-paladin" or actor.class == "ranger" or actor.class == "monk")
if WARRIOR_SUB then
    if actor:get_quest_stage("phase_armor") == 0 then
        wait(2)
        actor:send(tostring(self.name) .. " tells you, \"Welcome, would you like to do some [<b:white>armor quests</>]?\"")
        actor:send(tostring(self.name) .. " tells you, \"If so, just ask me, <b:white>Yes</> I would like to do some <b:white>armor quests</>\"")
    end
else
end$trig$, '29da307e32b669caceac948c1f509f21'),
  -- data/triggers/553/553_12_phase_1_warrior_accept.lua
  (553, 12, $trig$-- Converted from DG Script #55312: Phase_1_warrior_accept
-- Original: MOB trigger, flags: SPEECH_TO, probability: 100%
-- 
-- This will recognize the acceptance of the phase armor quest
-- by a player and set the quest variable for later interaction.
-- 
local WARRIOR_SUB = (actor.class == "warrior" or actor.class == "paladin" or actor.class == "anti-paladin" or actor.class == "ranger" or actor.class == "monk")
if WARRIOR_SUB then
    wait(2)
    if actor:get_quest_stage("phase_armor") == 0 then
        actor:start_quest("phase_armor")
    end
    actor:send(tostring(self.name) .. " tells you, \"Excellent, I can make nice [<b:white>boots</>], a [<b:white>helm</>], [<b:white>gauntlets</>],\"")
    actor:send(tostring(self.name) .. " tells you, \"[<b:white>vambraces</>], [<b:white>greaves</>], [<b:white>plate</>], and a [<b:white>bracer</>].\"")
    wait(2)
    actor:send(tostring(self.name) .. " tells you, \"If you want to know about how to quest for one, ask me about\"")
    actor:send(tostring(self.name) .. " tells you, \"it and I will tell you the components you need to get for me\"")
    actor:send(tostring(self.name) .. " tells you, \"in order to receive your reward.\"")
    wait(2)
    actor:send(tostring(self.name) .. " tells you, \"Also, you can ask me <b:white>status</> at any time,\"")
    actor:send(tostring(self.name) .. " tells you, \"and I'll tell you what you have given me so far.\"")
else
    actor:send(tostring(self.name) .. " tells you, \"Sorry, this quest is for warriors only.\"")
end$trig$, '608ccbb895a7b37ebe326cccbdca08d5'),
  -- data/triggers/553/553_13_phase_1_warrior_boots.lua
  (553, 13, $trig$-- Converted from DG Script #55313: phase_1_warrior_boots
-- Original: MOB trigger, flags: SPEECH_TO, probability: 100%
-- 
-- Boots ya ask?
-- 
-- This is for warriors only
local anti = "Anti-Paladin"
local WARRIOR_SUB = (actor.class == "warrior"  or  actor.class == "paladin"  or  actor.class == "anti-paladin"  or  actor.class == "ranger"  or  actor.class == "monk")
if WARRIOR_SUB then
    if actor.level >= 1 and actor:get_quest_stage("phase_armor") >= 1 then
        wait(2)
        actor:send(tostring(self.name) .. " tells you, \"Boots ya ask? Well now I can make a fine pair of boots for the\"")
        actor:send(tostring(self.name) .. " tells you, \"warrior types but I'll need 3 crushed topazes, and a set of\"")
        actor:send(tostring(self.name) .. " tells you, \"Rusted Plate Boots. Return these things to me in any order at\"")
        actor:send(tostring(self.name) .. " tells you, \"any time and I will reward you.\"")
    else
        actor:send("Sorry this quest is for warriors only.")
    end
end  -- auto-close block$trig$, 'eab27e659576423dd76e525cf91743d9'),
  -- data/triggers/553/553_14_phase_1_warrior_helm.lua
  (553, 14, $trig$-- Converted from DG Script #55314: phase_1_warrior_helm
-- Original: MOB trigger, flags: SPEECH_TO, probability: 100%
-- 
-- helm ya ask?
-- 
-- This is for warriors only
local anti = "Anti-Paladin"
local WARRIOR_SUB = (actor.class == "warrior"  or  actor.class == "paladin"  or  actor.class == "anti-paladin"  or  actor.class == "ranger"  or  actor.class == "monk")
if WARRIOR_SUB then
    if actor.level >= 1 and actor:get_quest_stage("phase_armor") >= 1 then
        wait(2)
        actor:send(tostring(self.name) .. " tells you, \"Helm ya ask? Well now I can make a nice helm for the warrior types\"")
        actor:send(tostring(self.name) .. " tells you, \"but I'll need 3 quantities of some jade dust, and a Rusted\"")
        actor:send(tostring(self.name) .. " tells you, \"Helm. Return these things to me in any order at any time and I\"")
        actor:send(tostring(self.name) .. " tells you, \"will reward you.\"")
    else
        actor:send("Sorry this quest is for warriors only.")
    end
end  -- auto-close block$trig$, '9becf8ef8eb3f2d282e26cc926fd9616'),
  -- data/triggers/553/553_15_phase_1_warrior_gauntlets.lua
  (553, 15, $trig$-- Converted from DG Script #55315: phase_1_warrior_gauntlets
-- Original: MOB trigger, flags: SPEECH_TO, probability: 100%
-- 
-- Gauntlets ya ask?
-- 
-- This is for warriors only
local anti = "Anti-Paladin"
local WARRIOR_SUB = (actor.class == "warrior"  or  actor.class == "paladin"  or  actor.class == "anti-paladin"  or  actor.class == "ranger"  or  actor.class == "monk")
if WARRIOR_SUB then
    if actor.level >= 1 and actor:get_quest_stage("phase_armor") >= 1 then
        wait(2)
        actor:send(tostring(self.name) .. " tells you, \"Gauntlets? Well now I can make a fine pair of gauntlets for the\"")
        actor:send(tostring(self.name) .. " tells you, \"warrior types but I'll need 3 crushed amethysts, and a set of\"")
        actor:send(tostring(self.name) .. " tells you, \"Rusted Gauntlets. Return these things to me in any order at\"")
        actor:send(tostring(self.name) .. " tells you, \"any time and I will reward you.\"")
    else
        actor:send("Sorry this quest is for warriors only.")
    end
end  -- auto-close block$trig$, 'ce4da581ef38ce391cf46ad989dbc67a'),
  -- data/triggers/553/553_16_phase_1_warrior_vambraces.lua
  (553, 16, $trig$-- Converted from DG Script #55316: phase_1_warrior_vambraces
-- Original: MOB trigger, flags: SPEECH_TO, probability: 100%
-- 
-- Vambraces ya ask?
-- 
-- This is for warriors only
local anti = "Anti-Paladin"
local WARRIOR_SUB = (actor.class == "warrior"  or  actor.class == "paladin"  or  actor.class == "anti-paladin"  or  actor.class == "ranger"  or  actor.class == "monk")
if WARRIOR_SUB then
    if actor.level >= 1 and actor:get_quest_stage("phase_armor") >= 1 then
        wait(2)
        actor:send(tostring(self.name) .. " tells you, \"Vambraces ya ask? Well now I can make a fine set of vambraces for\"")
        actor:send(tostring(self.name) .. " tells you, \"the warrior types but I'll need 3 quantities of some amber dust,\"")
        actor:send(tostring(self.name) .. " tells you, \"and a set of Rusted Vambraces. Return these things to me in\"")
        actor:send(tostring(self.name) .. " tells you, \"any order at any time and I will reward you.\"")
    else
        actor:send("Sorry this quest is for warriors only.")
    end
end  -- auto-close block$trig$, 'd0b638d27c5907d5b56b68bfaa9cd4df'),
  -- data/triggers/553/553_17_phase_1_warrior_greaves.lua
  (553, 17, $trig$-- Converted from DG Script #55317: phase_1_warrior_greaves
-- Original: MOB trigger, flags: SPEECH_TO, probability: 100%
-- 
-- Greaves ya ask?
-- 
-- This is for warriors only
local anti = "Anti-Paladin"
local WARRIOR_SUB = (actor.class == "warrior"  or  actor.class == "paladin"  or  actor.class == "anti-paladin"  or  actor.class == "ranger"  or  actor.class == "monk")
if WARRIOR_SUB then
    if actor.level >= 1 and actor:get_quest_stage("phase_armor") >= 1 then
        wait(2)
        actor:send(tostring(self.name) .. " tells you, \"Ah, protection for yer legs? Well now I can make a fine set of\"")
        actor:send(tostring(self.name) .. " tells you, \"greaves for the warrior types but I'll need 3 quantities of some\"")
        actor:send(tostring(self.name) .. " tells you, \"aquamarine dust, and a set of Rusted Greaves. Return these things\"")
        actor:send(tostring(self.name) .. " tells you, \"to me in any order at any time and I will reward you.\"")
    else
        actor:send("Sorry this quest is for warriors only.")
    end
end  -- auto-close block$trig$, '29ea31a5b8f83b913fbda9f5e9e4189d'),
  -- data/triggers/553/553_18_phase_1_warrior_plate.lua
  (553, 18, $trig$-- Converted from DG Script #55318: phase_1_warrior_plate
-- Original: MOB trigger, flags: SPEECH_TO, probability: 100%
-- 
-- Plate ya ask?
-- 
-- This is for warriors only
local anti = "Anti-Paladin"
local WARRIOR_SUB = (actor.class == "warrior"  or  actor.class == "paladin"  or  actor.class == "anti-paladin"  or  actor.class == "ranger"  or  actor.class == "monk")
if WARRIOR_SUB then
    if actor.level >= 1 and actor:get_quest_stage("phase_armor") >= 1 then
        wait(2)
        actor:send(tostring(self.name) .. " tells you, \"Body armor? Well now I can make a fine plate for the warriors but\"")
        actor:send(tostring(self.name) .. " tells you, \"I'll need 3 crushed emeralds, and a Rusted Plate. Return these\"")
        actor:send(tostring(self.name) .. " tells you, \"things to me in any order at any time and I will reward you.\"")
    else
        actor:send("Sorry this quest is for warriors only.")
    end
end  -- auto-close block$trig$, '1393244e405eb28b894e149b1374bc15'),
  -- data/triggers/553/553_19_phase_1_warrior_bracer.lua
  (553, 19, $trig$-- Converted from DG Script #55319: phase_1_warrior_bracer
-- Original: MOB trigger, flags: SPEECH_TO, probability: 100%
-- 
-- Bracer ya ask?
-- 
-- This is for warriors only
local anti = "Anti-Paladin"
local WARRIOR_SUB = (actor.class == "warrior"  or  actor.class == "paladin"  or  actor.class == "anti-paladin"  or  actor.class == "ranger"  or  actor.class == "monk")
if WARRIOR_SUB then
    if actor.level >= 1 and actor:get_quest_stage("phase_armor") >= 1 then
        wait(2)
        actor:send(tostring(self.name) .. " tells you, \"Bracer ya ask? Well now I can make a protective bracer for the\"")
        actor:send(tostring(self.name) .. " tells you, \"warrior types but I'll need 3 crushed citrines, and a Rusted Plate\"")
        actor:send(tostring(self.name) .. " tells you, \"Bracer. Return these things to me in any order at any time and\"")
        actor:send(tostring(self.name) .. " tells you, \"I will reward you.\"")
    else
        actor:send("Sorry this quest is for warriors only.")
    end
end  -- auto-close block$trig$, '9d740cf89d0b0771c2664e8a6390e76e')
) AS v(zone_id, id, commands, old_md5)
WHERE t.zone_id = v.zone_id
  AND t.id = v.id
  AND md5(t.commands) = v.old_md5
  AND t.commands IS DISTINCT FROM v.commands;

COMMIT;
