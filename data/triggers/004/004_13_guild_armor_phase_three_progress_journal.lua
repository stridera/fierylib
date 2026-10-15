-- Trigger: Guild Armor Phase Three progress journal
-- Zone: 4, ID: 13
-- Type: OBJECT, Flags: LOOK
-- Status: CLEAN
--
-- Original DG Script: #413

-- Converted from DG Script #413: Guild Armor Phase Three progress journal
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
        local hands_armor, hands_gem, feet_armor, feet_gem, wrist_armor, wrist_gem, head_armor, head_gem, arms_armor, arms_gem, legs_armor, legs_gem, body_armor, body_gem, hands_reward, feet_reward, wrist_reward, head_reward, arms_reward, legs_reward, body_reward
        if string.find(string.lower(sorcererclasses), actor.class, 1, true) then
            feet_gem = 55690
            head_gem = 55712
            hands_gem = 55679
            arms_gem = 55723
            legs_gem = 55734
            body_gem = 55745
            wrist_gem = 55701
            feet_armor = 55363
            head_armor = 55371
            hands_armor = 55359
            arms_armor = 55375
            legs_armor = 55379
            body_armor = 55383
            wrist_armor = 55367
            feet_reward = 55556
            head_reward = 55552
            hands_reward = 55558
            arms_reward = 55553
            legs_reward = 55555
            body_reward = 55554
            wrist_reward = 55557
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
            feet_gem = 55686
            head_gem = 55708
            hands_gem = 55675
            arms_gem = 55719
            legs_gem = 55730
            body_gem = 55741
            wrist_gem = 55697
            feet_armor = 55363
            head_armor = 55371
            hands_armor = 55359
            arms_armor = 55375
            legs_armor = 55379
            body_armor = 55383
            wrist_armor = 55367
            feet_reward = 55535
            head_reward = 55531
            hands_reward = 55537
            arms_reward = 55532
            legs_reward = 55534
            body_reward = 55533
            wrist_reward = 55536
            master = "a necromancer in Anduin"
        elseif string.find(string.lower(clericclasses), actor.class, 1, true) then
            feet_gem = 55689
            head_gem = 55711
            hands_gem = 55678
            arms_gem = 55722
            legs_gem = 55733
            body_gem = 55744
            wrist_gem = 55700
            feet_armor = 55360
            head_armor = 55368
            hands_armor = 55356
            arms_armor = 55372
            legs_armor = 55376
            body_armor = 55380
            wrist_armor = 55364
            feet_reward = 55514
            head_reward = 55510
            hands_reward = 55516
            arms_reward = 55511
            legs_reward = 55513
            body_reward = 55512
            wrist_reward = 55515
            master = "the High Priest Zalish"
        elseif string.find(actor.class, "diabolist") then
            feet_gem = 55683
            head_gem = 55705
            hands_gem = 55672
            arms_gem = 55716
            legs_gem = 55727
            body_gem = 55738
            wrist_gem = 55694
            feet_armor = 55360
            head_armor = 55368
            hands_armor = 55356
            arms_armor = 55372
            legs_armor = 55376
            body_armor = 55380
            wrist_armor = 55364
            feet_reward = 55549
            head_reward = 55545
            hands_reward = 55551
            arms_reward = 55546
            legs_reward = 55548
            body_reward = 55547
            wrist_reward = 55550
            master = "Ruin Wormheart"
        elseif string.find(actor.class, "druid") then
            feet_gem = 55684
            head_gem = 55706
            hands_gem = 55673
            arms_gem = 55717
            legs_gem = 55728
            body_gem = 55739
            wrist_gem = 55695
            feet_armor = 55362
            head_armor = 55370
            hands_armor = 55358
            arms_armor = 55374
            legs_armor = 55378
            body_armor = 55382
            wrist_armor = 55366
            feet_reward = 55528
            head_reward = 55524
            hands_reward = 55530
            arms_reward = 55525
            legs_reward = 55527
            body_reward = 55526
            wrist_reward = 55529
            master = "the Heirophant"
        elseif string.find(actor.class, "warrior") then
            feet_gem = 55692
            head_gem = 55714
            hands_gem = 55681
            arms_gem = 55725
            legs_gem = 55736
            body_gem = 55747
            wrist_gem = 55703
            feet_armor = 55360
            head_armor = 55368
            hands_armor = 55356
            arms_armor = 55372
            legs_armor = 55376
            body_armor = 55380
            wrist_armor = 55364
            feet_reward = 55493
            head_reward = 55489
            hands_reward = 55495
            arms_reward = 55490
            legs_reward = 55492
            body_reward = 55491
            wrist_reward = 55494
            master = "the Warrior Coach in Ickle"
        elseif actor.class == "anti-paladin" then
            feet_gem = 55682
            head_gem = 55704
            hands_gem = 55671
            arms_gem = 55715
            legs_gem = 55726
            body_gem = 55737
            wrist_gem = 55693
            feet_armor = 55360
            head_armor = 55368
            hands_armor = 55356
            arms_armor = 55372
            legs_armor = 55376
            body_armor = 55380
            wrist_armor = 55364
            feet_reward = 55507
            head_reward = 55503
            hands_reward = 55509
            arms_reward = 55504
            legs_reward = 55506
            body_reward = 55505
            wrist_reward = 55508
            master = "the Avatar of Zzur"
        elseif string.find(actor.class, "ranger") then
            feet_gem = 55688
            head_gem = 55710
            hands_gem = 55677
            arms_gem = 55721
            legs_gem = 55732
            body_gem = 55743
            wrist_gem = 55699
            feet_armor = 55361
            head_armor = 55369
            hands_armor = 55357
            arms_armor = 55373
            legs_armor = 55377
            body_armor = 55381
            wrist_armor = 55365
            feet_reward = 55521
            head_reward = 55517
            hands_reward = 55523
            arms_reward = 55518
            legs_reward = 55520
            body_reward = 55519
            wrist_reward = 55522
            master = "the Avatar of Haddixx"
        elseif actor.class == "paladin" then
            feet_gem = 55687
            head_gem = 55709
            hands_gem = 55676
            arms_gem = 55720
            legs_gem = 55731
            body_gem = 55742
            wrist_gem = 55698
            feet_armor = 55360
            head_armor = 55368
            hands_armor = 55356
            arms_armor = 55372
            legs_armor = 55376
            body_armor = 55380
            wrist_armor = 55364
            feet_reward = 55500
            head_reward = 55496
            hands_reward = 55502
            arms_reward = 55497
            legs_reward = 55499
            body_reward = 55498
            wrist_reward = 55501
            master = "Belward"
        elseif string.find(actor.class, "monk") then
            feet_gem = 55685
            head_gem = 55707
            hands_gem = 55674
            arms_gem = 55718
            legs_gem = 55729
            body_gem = 55740
            wrist_gem = 55696
            feet_armor = 55362
            head_armor = 55370
            hands_armor = 55358
            arms_armor = 55374
            legs_armor = 55378
            body_armor = 55382
            wrist_armor = 55366
            feet_reward = 55542
            head_reward = 55538
            hands_reward = 55544
            arms_reward = 55539
            legs_reward = 55541
            body_reward = 55540
            wrist_reward = 55543
            master = "the Almoner"
        elseif string.find(actor.class, "berserker") then
            feet_gem = 55686
            head_gem = 55710
            hands_gem = 55672
            arms_gem = 55717
            legs_gem = 55726
            body_gem = 55742
            wrist_gem = 55696
            feet_armor = 55362
            head_armor = 55370
            hands_armor = 55358
            arms_armor = 55374
            legs_armor = 55378
            body_armor = 55382
            wrist_armor = 55366
            feet_reward = 55778
            head_reward = 55774
            hands_reward = 55780
            arms_reward = 55775
            legs_reward = 55777
            body_reward = 55776
            wrist_reward = 55779
            master = "Avaldr Mountainhelm"
        elseif string.find(string.lower(rogueclasses), actor.class, 1, true) then
            feet_gem = 55691
            head_gem = 55713
            hands_gem = 55680
            arms_gem = 55724
            legs_gem = 55735
            body_gem = 55746
            wrist_gem = 55702
            feet_armor = 55361
            head_armor = 55369
            hands_armor = 55357
            arms_armor = 55373
            legs_armor = 55377
            body_armor = 55381
            wrist_armor = 55365
            feet_reward = 55563
            head_reward = 55559
            hands_reward = 55565
            arms_reward = 55560
            legs_reward = 55562
            body_reward = 55561
            wrist_reward = 55564
            master = "an Elite Mercenary in Ickle"
        elseif string.find(actor.class, "bard") then
            feet_gem = 55685
            head_gem = 55708
            hands_gem = 55671
            arms_gem = 55720
            legs_gem = 55728
            body_gem = 55743
            wrist_gem = 55694
            feet_armor = 55362
            head_armor = 55370
            hands_armor = 55358
            arms_armor = 55374
            legs_armor = 55378
            body_armor = 55382
            wrist_armor = 55366
            feet_reward = 55792
            head_reward = 55788
            hands_reward = 55794
            arms_reward = 55789
            legs_reward = 55791
            body_reward = 55790
            wrist_reward = 55793
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