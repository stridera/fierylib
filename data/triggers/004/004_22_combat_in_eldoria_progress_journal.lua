-- Trigger: Combat in Eldoria progress journal
-- Zone: 4, ID: 22
-- Type: OBJECT, Flags: LOOK
-- Status: NEEDS_REVIEW
--   Syntax error: luac: <Combat in Eldoria progress journal>:4: 'then' expected near 'in'
--   Complex nesting: 15 if statements
--   Large script: 13405 chars
--
-- Original DG Script: #422

-- Converted from DG Script #422: Combat in Eldoria progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if string.find(arg, "combat in eldoria") or string.find(arg, "combat_in_eldoria") or string.find(arg, "third eldorian guard") or string.find(arg, "third black legion") or string.find(arg, "black_legion") or string.find(arg, "eldorian_guard") or string.find(arg, "third_black_legion") or string.find(arg, "third_eldorian_guard") or string.find(arg, "combat") or string.find(arg, "eldoria") then
    _return_value = true
    actor:send("<b:green>&uCombat in Eldoria</>")
    actor:send("The Third Black Legion and the Eldorian Guard, along with their allies in Split Skull and the Abbey, are locked in eternal warfare.")
    actor:send("Characters may align themselves with the forces of good or the forces of evil.")
    actor:send("But beware, once made that decision cannot be changed!")
    actor:send("Minimum Level: 10")
    if actor:get_quest_stage("black_legion") then
        actor:send("<cyan>Status: Continuous</>_")
        if actor:get_quest_var("Black_Legion:bl_ally") then
            local id_trophy1 = 5504
            local id_trophy2 = 5506
            local id_trophy3 = 5508
            local id_trophy4 = 5510
            local id_trophy5 = 5512
            local id_trophy6 = 5514
            local id_trophy7 = 5516
            local id_gem_cap = 55570
            local id_gem_neck = 55571
            local id_gem_arm = 55572
            local id_gem_wrist = 55573
            local id_gem_gloves = 55574
            local id_gem_jerkin = 55575
            local id_gem_robe = 55589
            local id_gem_belt = 55576
            local id_gem_legs = 55577
            local id_gem_boots = 55578
            local id_gem_mask = 55579
            local id_gem_symbol = 55580
            local id_gem_staff = 55581
            local id_gem_ssword = 55582
            local id_gem_whammer = 55583
            local id_gem_flail = 55584
            local id_gem_shiv = 55585
            local id_gem_lsword = 55586
            local id_gem_smace = 55587
            local id_gem_light = 55588
            local id_gem_food = 55566
            local id_gem_drink = 55567
            local id_cap = 5517
            local id_neck = 5519
            local team_a_idrm = 5521
            local id_wrist = 5523
            local id_gloves = 5525
            local id_jerkin = 5527
            local team_b_idelt = 5529
            local id_legs = 5531
            local team_b_idoots = 5533
            local id_mask = 5535
            local id_robe = 5537
            local id_symbol = 5515
            local id_staff = 5539
            local id_ssword = 5540
            local id_whammer = 5541
            local id_flail = 5542
            local id_shiv = 5543
            local id_lsword = 5544
            local id_smace = 5545
            local id_light = 5553
            local id_food = 5555
            local id_drink = 5557
            local legion = "Black Legion"
            local master = mobiles.template(41, 27).name .. " and mobiles.template(55, 12).name"
            local status = actor:get_quest_var("black_legion:bl_faction")
        elseif actor:get_quest_var("Black_Legion:eg_ally") then
            local id_trophy1 = 5503
            local id_trophy2 = 5505
            local id_trophy3 = 5507
            local id_trophy4 = 5509
            local id_trophy5 = 5511
            local id_trophy6 = 5513
            local id_trophy7 = 5515
            local id_gem_cap = 55570
            local id_gem_neck = 55571
            local id_gem_arm = 55572
            local id_gem_wrist = 55573
            local id_gem_gloves = 55574
            local id_gem_jerkin = 55575
            local id_gem_robe = 55589
            local id_gem_belt = 55576
            local id_gem_legs = 55577
            local id_gem_boots = 55578
            local id_gem_mask = 55579
            local id_gem_symbol = 55580
            local id_gem_staff = 55581
            local id_gem_ssword = 55582
            local id_gem_whammer = 55583
            local id_gem_flail = 55584
            local id_gem_shiv = 55585
            local id_gem_lsword = 55586
            local id_gem_smace = 55587
            local id_gem_light = 55588
            local id_gem_food = 55566
            local id_gem_drink = 55567
            local id_cap = 5518
            local id_neck = 5520
            local team_a_idrm = 5522
            local id_wrist = 5524
            local id_gloves = 5526
            local id_jerkin = 5528
            local team_b_idelt = 5530
            local id_legs = 5532
            local team_b_idoots = 5534
            local id_mask = 5536
            local id_robe = 5538
            local id_symbol = 5516
            local id_staff = 5546
            local id_ssword = 5547
            local id_whammer = 5548
            local id_flail = 5549
            local id_shiv = 5550
            local id_lsword = 5551
            local id_smace = 5552
            local id_light = 5554
            local id_food = 5556
            local id_drink = 5558
            local legion = "Eldorian Guard"
            local master = mobiles.template(186, 99).name .. " and mobiles.template(55, 24).name"
            local status = actor:get_quest_var("black_legion:eg_faction")
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
        actor:send("%actor.quest_variable[black_legion:%id_trophy1%_trophies]% %get.obj_pldesc[%id_trophy1%]%")
        actor:send("%actor.quest_variable[black_legion:%id_trophy2%_trophies]% %get.obj_pldesc[%id_trophy2%]%")
        actor:send("%actor.quest_variable[black_legion:%id_trophy3%_trophies]% %get.obj_pldesc[%id_trophy3%]%")
        actor:send("%actor.quest_variable[black_legion:%id_trophy4%_trophies]% %get.obj_pldesc[%id_trophy4%]%")
        actor:send("%actor.quest_variable[black_legion:%id_trophy5%_trophies]% %get.obj_pldesc[%id_trophy5%]%")
        actor:send("%actor.quest_variable[black_legion:%id_trophy6%_trophies]% %get.obj_pldesc[%id_trophy6%]%")
        actor:send("%actor.quest_variable[black_legion:%id_trophy7%_trophies]% %get.obj_pldesc[%id_trophy7%]%")
        actor:send("</>")
        actor:send("Your current " .. tostring(legion) .. " faction status is " .. tostring(status) .. ".")
        if status >= 200 then
            actor:send("You have reached the maximum faction status.")
        end
        actor:send("</>")
        if status >= 20 then
            actor:send("You have access to:")
            actor:send("<b:yellow>" .. "%get.obj_shortdesc[%id_food%]%</> for <magenta>%get.obj_shortdesc[%id_gem_food%]%</>")
            actor:send("- times claimed: (" .. "%actor.quest_variable[black_legion:%id_food%_reward])_")
            actor:send("<b:yellow>" .. "%get.obj_shortdesc[%id_drink%]%</> for <magenta>%get.obj_shortdesc[%id_gem_drink%]%</>")
            actor:send("- times claimed: (" .. "%actor.quest_variable[black_legion:%id_drink%_reward])_")
            actor:send("<b:yellow>" .. "%get.obj_shortdesc[%id_cap%]%</> for <magenta>%get.obj_shortdesc[%id_gem_cap%]%</>")
            actor:send("- times claimed: (" .. "%actor.quest_variable[black_legion:%id_cap%_reward])_")
            actor:send("<b:yellow>" .. "%get.obj_shortdesc[%id_ssword%]%</> for <magenta>%get.obj_shortdesc[%id_gem_ssword%]%</>")
            actor:send("- times claimed: (" .. "%actor.quest_variable[black_legion:%id_ssword%_reward])_")
        end
        if status >= 40 then
            actor:send("<b:yellow>" .. "%get.obj_shortdesc[%id_neck%]%</> for <magenta>%get.obj_shortdesc[%id_gem_neck%]%</>")
            actor:send("- times claimed: (" .. "%actor.quest_variable[black_legion:%id_neck%_reward])_")
            actor:send("<b:yellow>" .. "%get.obj_shortdesc[%id_staff%]%</> for <magenta>%get.obj_shortdesc[%id_gem_staff%]%</>")
            actor:send("- times claimed: (" .. "%actor.quest_variable[black_legion:%id_staff%_reward])_")
        end
        if status >= 55 then
            actor:send("<b:yellow>" .. "%get.obj_shortdesc[%team_a_idrm%]%</> for <magenta>%get.obj_shortdesc[%id_gem_arm%]%</>")
            actor:send("- times claimed: (" .. "%actor.quest_variable[black_legion:%team_a_idrm%_reward])_")
            actor:send("<b:yellow>" .. "%get.obj_shortdesc[%id_whammer%]%</> for <magenta>%get.obj_shortdesc[%id_gem_whammer%]%</>")
            actor:send("- times claimed: (" .. "%actor.quest_variable[black_legion:%id_whammer%_reward])_")
        end
        if status >= 70 then
            actor:send("<b:yellow>" .. "%get.obj_shortdesc[%id_wrist%]%</> for <magenta>%get.obj_shortdesc[%id_gem_wrist%]%</>")
            actor:send("- times claimed: (" .. "%actor.quest_variable[black_legion:%id_wrist%_reward])_")
            actor:send("<b:yellow>" .. "%get.obj_shortdesc[%id_flail%]%</> for <magenta>%get.obj_shortdesc[%id_gem_flail%]%</>")
            actor:send("- times claimed: (" .. "%actor.quest_variable[black_legion:%id_flail%_reward])_")
        end
        if status >= 85 then
            actor:send("<b:yellow>" .. "%get.obj_shortdesc[%id_gloves%]%</> for <magenta>%get.obj_shortdesc[%id_gem_gloves%]%</>")
            actor:send("- times claimed: (" .. "%actor.quest_variable[black_legion:%id_gloves%_reward])_")
            actor:send("<b:yellow>" .. "%get.obj_shortdesc[%id_symbol%]%</> for <magenta>%get.obj_shortdesc[%id_gem_symbol%]%</>")
            actor:send("- times claimed: (" .. "%actor.quest_variable[black_legion:%id_symbol%_reward])_")
            actor:send("<b:yellow>" .. "%get.obj_shortdesc[%id_light%]%</> for <magenta>%get.obj_shortdesc[%id_gem_light%]%</>")
            actor:send("- times claimed: (" .. "%actor.quest_variable[black_legion:%id_light%_reward])_")
        end
        if status >= 100 then
            actor:send("<b:yellow>" .. "%get.obj_shortdesc[%team_b_idelt%]%</> for <magenta>%get.obj_shortdesc[%id_gem_belt%]%</>")
            actor:send("- times claimed: (" .. "%actor.quest_variable[black_legion:%team_b_idelt%_reward])_")
            actor:send("<b:yellow>" .. "%get.obj_shortdesc[%id_shiv%]%</> for <magenta>%get.obj_shortdesc[%id_gem_shiv%]%</>")
            actor:send("- times claimed: (" .. "%actor.quest_variable[black_legion:%id_shiv%_reward])_")
        end
        if status >= 115 then
            actor:send("<b:yellow>" .. "%get.obj_shortdesc[%team_b_idoots%]%</> for <magenta>%get.obj_shortdesc[%id_gem_boots%]%</>")
            actor:send("- times claimed: (" .. "%actor.quest_variable[black_legion:%team_b_idoots%_reward])_")
            actor:send("<b:yellow>" .. "%get.obj_shortdesc[%id_lsword%]%</> for <magenta>%get.obj_shortdesc[%id_gem_lsword%]%</>")
            actor:send("- times claimed: (" .. "%actor.quest_variable[black_legion:%id_lsword%_reward])_")
        end
        if status >= 130 then
            actor:send("<b:yellow>" .. "%get.obj_shortdesc[%id_legs%]%</> for <magenta>%get.obj_shortdesc[%id_gem_legs%]%</>")
            actor:send("- times claimed: (" .. "%actor.quest_variable[black_legion:%id_legs%_reward])_")
        end
        if status >= 145 then
            actor:send("<b:yellow>" .. "%get.obj_shortdesc[%id_robe%]%</> for <magenta>%get.obj_shortdesc[%id_gem_robe%]%</>")
            actor:send("- times claimed: (" .. "%actor.quest_variable[black_legion:%id_robe%_reward])_")
            actor:send("<b:yellow>" .. "%get.obj_shortdesc[%id_jerkin%]%</> for <magenta>%get.obj_shortdesc[%id_gem_jerkin%]%</>")
            actor:send("- times claimed: (" .. "%actor.quest_variable[black_legion:%id_jerkin%_reward])_")
        end
        if status >= 160 then
            actor:send("<b:yellow>" .. "%get.obj_shortdesc[%id_mask%]%</> for <magenta>%get.obj_shortdesc[%id_gem_mask%]%</>")
            actor:send("- times claimed: (" .. "%actor.quest_variable[black_legion:%id_mask%_reward])_")
            actor:send("<b:yellow>" .. "%get.obj_shortdesc[%id_smace%]%</> for <magenta>%get.obj_shortdesc[%id_gem_smace%]%</>")
            actor:send("- times claimed: (" .. "%actor.quest_variable[black_legion:%id_smace%_reward])_")
        end
        if statu < 160 then
            actor:send("As your standing with the " .. tostring(legion) .. " improves you will have access to more rewards.")
        end
    else
        actor:send("<cyan>Status: Not Started</>")
    end
end
return _return_value