-- Trigger: Combat in Eldoria progress journal
-- Zone: 4, ID: 22
-- Type: OBJECT, Flags: LOOK
-- Status: NEEDS_REVIEW
--   Complex nesting: 15 if statements
--   Large script: 13405 chars
--
-- Original DG Script: #422

-- Converted from DG Script #422: Combat in Eldoria progress journal
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
if string.find(arg, "combat") in eldoria or string.find(arg, "combat_in_eldoria") or string.find(arg, "third") eldorian guard or string.find(arg, "third") black legion or string.find(arg, "black_legion") or string.find(arg, "eldorian_guard") or string.find(arg, "third_black_legion") or string.find(arg, "third_eldorian_guard") or string.find(arg, "combat") or string.find(arg, "eldoria") then
    _return_value = false
    actor:send("<b:green>&uCombat in Eldoria</>")
    actor:send("The Third Black Legion and the Eldorian Guard, along with their allies in Split Skull and the Abbey, are locked in eternal warfare.")
    actor:send("Characters may align themselves with the forces of good or the forces of evil.")
    actor:send("But beware, once made that decision cannot be changed!")
    actor:send("Minimum Level: 10")
    if actor:get_quest_stage("black_legion") then
        actor:send("<cyan>Status: Continuous</>_")
        if actor:get_quest_var("Black_Legion:bl_ally") then
            local vnum_trophy1 = 5504
            local vnum_trophy2 = 5506
            local vnum_trophy3 = 5508
            local vnum_trophy4 = 5510
            local vnum_trophy5 = 5512
            local vnum_trophy6 = 5514
            local vnum_trophy7 = 5516
            local vnum_gem_cap = 55570
            local vnum_gem_neck = 55571
            local vnum_gem_arm = 55572
            local vnum_gem_wrist = 55573
            local vnum_gem_gloves = 55574
            local vnum_gem_jerkin = 55575
            local vnum_gem_robe = 55589
            local vnum_gem_belt = 55576
            local vnum_gem_legs = 55577
            local vnum_gem_boots = 55578
            local vnum_gem_mask = 55579
            local vnum_gem_symbol = 55580
            local vnum_gem_staff = 55581
            local vnum_gem_ssword = 55582
            local vnum_gem_whammer = 55583
            local vnum_gem_flail = 55584
            local vnum_gem_shiv = 55585
            local vnum_gem_lsword = 55586
            local vnum_gem_smace = 55587
            local vnum_gem_light = 55588
            local vnum_gem_food = 55566
            local vnum_gem_drink = 55567
            local vnum_cap = 5517
            local vnum_neck = 5519
            local vnum_arm = 5521
            local vnum_wrist = 5523
            local vnum_gloves = 5525
            local vnum_jerkin = 5527
            local vnum_belt = 5529
            local vnum_legs = 5531
            local vnum_boots = 5533
            local vnum_mask = 5535
            local vnum_robe = 5537
            local vnum_symbol = 5515
            local vnum_staff = 5539
            local vnum_ssword = 5540
            local vnum_whammer = 5541
            local vnum_flail = 5542
            local vnum_shiv = 5543
            local vnum_lsword = 5544
            local vnum_smace = 5545
            local vnum_light = 5553
            local vnum_food = 5555
            local vnum_drink = 5557
            local legion = "Black Legion"
            local master = mobiles.template(41, 27).name and mobiles.template(55, 12).name
            local status = actor:get_quest_var("black_legion:bl_faction")
        elseif actor:get_quest_var("Black_Legion:eg_ally") then
            local vnum_trophy1 = 5503
            local vnum_trophy2 = 5505
            local vnum_trophy3 = 5507
            local vnum_trophy4 = 5509
            local vnum_trophy5 = 5511
            local vnum_trophy6 = 5513
            local vnum_trophy7 = 5515
            local vnum_gem_cap = 55570
            local vnum_gem_neck = 55571
            local vnum_gem_arm = 55572
            local vnum_gem_wrist = 55573
            local vnum_gem_gloves = 55574
            local vnum_gem_jerkin = 55575
            local vnum_gem_robe = 55589
            local vnum_gem_belt = 55576
            local vnum_gem_legs = 55577
            local vnum_gem_boots = 55578
            local vnum_gem_mask = 55579
            local vnum_gem_symbol = 55580
            local vnum_gem_staff = 55581
            local vnum_gem_ssword = 55582
            local vnum_gem_whammer = 55583
            local vnum_gem_flail = 55584
            local vnum_gem_shiv = 55585
            local vnum_gem_lsword = 55586
            local vnum_gem_smace = 55587
            local vnum_gem_light = 55588
            local vnum_gem_food = 55566
            local vnum_gem_drink = 55567
            local vnum_cap = 5518
            local vnum_neck = 5520
            local vnum_arm = 5522
            local vnum_wrist = 5524
            local vnum_gloves = 5526
            local vnum_jerkin = 5528
            local vnum_belt = 5530
            local vnum_legs = 5532
            local vnum_boots = 5534
            local vnum_mask = 5536
            local vnum_robe = 5538
            local vnum_symbol = 5516
            local vnum_staff = 5546
            local vnum_ssword = 5547
            local vnum_whammer = 5548
            local vnum_flail = 5549
            local vnum_shiv = 5550
            local vnum_lsword = 5551
            local vnum_smace = 5552
            local vnum_light = 5554
            local vnum_food = 5556
            local vnum_drink = 5558
            local legion = "Eldorian Guard"
            local master = mobiles.template(186, 99).name and mobiles.template(55, 24).name
            local status = actor:get_quest_var("black_legion:eg_faction")
        end
        actor:send("You are pledged to the " .. tostring(legion) .. ".")
        actor:send("Quest Master: " .. tostring(master))
        -- osend %actor% &0
        -- osend %actor% The %legion% is interested in:
        -- osend %actor% - %get.obj_shortdesc[%vnum_trophy1%]%
        -- osend %actor% - %get.obj_shortdesc[%vnum_trophy2%]%
        -- osend %actor% - %get.obj_shortdesc[%vnum_trophy3%]%
        -- osend %actor% - %get.obj_shortdesc[%vnum_trophy4%]%
        -- osend %actor% - %get.obj_shortdesc[%vnum_trophy5%]%
        -- osend %actor% - %get.obj_shortdesc[%vnum_trophy6%]%
        -- osend %actor% - %get.obj_shortdesc[%vnum_trophy7%]%
        actor:send("</>")
        actor:send("You have turned in:")
        actor:send("%actor.quest_variable[black_legion:%vnum_trophy1%_trophies]% %get.obj_pldesc[%vnum_trophy1%]%")
        actor:send("%actor.quest_variable[black_legion:%vnum_trophy2%_trophies]% %get.obj_pldesc[%vnum_trophy2%]%")
        actor:send("%actor.quest_variable[black_legion:%vnum_trophy3%_trophies]% %get.obj_pldesc[%vnum_trophy3%]%")
        actor:send("%actor.quest_variable[black_legion:%vnum_trophy4%_trophies]% %get.obj_pldesc[%vnum_trophy4%]%")
        actor:send("%actor.quest_variable[black_legion:%vnum_trophy5%_trophies]% %get.obj_pldesc[%vnum_trophy5%]%")
        actor:send("%actor.quest_variable[black_legion:%vnum_trophy6%_trophies]% %get.obj_pldesc[%vnum_trophy6%]%")
        actor:send("%actor.quest_variable[black_legion:%vnum_trophy7%_trophies]% %get.obj_pldesc[%vnum_trophy7%]%")
        actor:send("</>")
        actor:send("Your current " .. tostring(legion) .. " faction status is " .. tostring(status) .. ".")
        if status >= 200 then
            actor:send("You have reached the maximum faction status.")
        end
        actor:send("</>")
        if status >= 20 then
            actor:send("You have access to:")
            actor:send("<b:yellow>" .. "%get.obj_shortdesc[%vnum_food%]%</> for <magenta>%get.obj_shortdesc[%vnum_gem_food%]%</>")
            actor:send("- times claimed: (" .. "%actor.quest_variable[black_legion:%vnum_food%_reward]%)_")
            actor:send("<b:yellow>" .. "%get.obj_shortdesc[%vnum_drink%]%</> for <magenta>%get.obj_shortdesc[%vnum_gem_drink%]%</>")
            actor:send("- times claimed: (" .. "%actor.quest_variable[black_legion:%vnum_drink%_reward]%)_")
            actor:send("<b:yellow>" .. "%get.obj_shortdesc[%vnum_cap%]%</> for <magenta>%get.obj_shortdesc[%vnum_gem_cap%]%</>")
            actor:send("- times claimed: (" .. "%actor.quest_variable[black_legion:%vnum_cap%_reward]%)_")
            actor:send("<b:yellow>" .. "%get.obj_shortdesc[%vnum_ssword%]%</> for <magenta>%get.obj_shortdesc[%vnum_gem_ssword%]%</>")
            actor:send("- times claimed: (" .. "%actor.quest_variable[black_legion:%vnum_ssword%_reward]%)_")
        end
        if status >= 40 then
            actor:send("<b:yellow>" .. "%get.obj_shortdesc[%vnum_neck%]%</> for <magenta>%get.obj_shortdesc[%vnum_gem_neck%]%</>")
            actor:send("- times claimed: (" .. "%actor.quest_variable[black_legion:%vnum_neck%_reward]%)_")
            actor:send("<b:yellow>" .. "%get.obj_shortdesc[%vnum_staff%]%</> for <magenta>%get.obj_shortdesc[%vnum_gem_staff%]%</>")
            actor:send("- times claimed: (" .. "%actor.quest_variable[black_legion:%vnum_staff%_reward]%)_")
        end
        if status >= 55 then
            actor:send("<b:yellow>" .. "%get.obj_shortdesc[%vnum_arm%]%</> for <magenta>%get.obj_shortdesc[%vnum_gem_arm%]%</>")
            actor:send("- times claimed: (" .. "%actor.quest_variable[black_legion:%vnum_arm%_reward]%)_")
            actor:send("<b:yellow>" .. "%get.obj_shortdesc[%vnum_whammer%]%</> for <magenta>%get.obj_shortdesc[%vnum_gem_whammer%]%</>")
            actor:send("- times claimed: (" .. "%actor.quest_variable[black_legion:%vnum_whammer%_reward]%)_")
        end
        if status >= 70 then
            actor:send("<b:yellow>" .. "%get.obj_shortdesc[%vnum_wrist%]%</> for <magenta>%get.obj_shortdesc[%vnum_gem_wrist%]%</>")
            actor:send("- times claimed: (" .. "%actor.quest_variable[black_legion:%vnum_wrist%_reward]%)_")
            actor:send("<b:yellow>" .. "%get.obj_shortdesc[%vnum_flail%]%</> for <magenta>%get.obj_shortdesc[%vnum_gem_flail%]%</>")
            actor:send("- times claimed: (" .. "%actor.quest_variable[black_legion:%vnum_flail%_reward]%)_")
        end
        if status >= 85 then
            actor:send("<b:yellow>" .. "%get.obj_shortdesc[%vnum_gloves%]%</> for <magenta>%get.obj_shortdesc[%vnum_gem_gloves%]%</>")
            actor:send("- times claimed: (" .. "%actor.quest_variable[black_legion:%vnum_gloves%_reward]%)_")
            actor:send("<b:yellow>" .. "%get.obj_shortdesc[%vnum_symbol%]%</> for <magenta>%get.obj_shortdesc[%vnum_gem_symbol%]%</>")
            actor:send("- times claimed: (" .. "%actor.quest_variable[black_legion:%vnum_symbol%_reward]%)_")
            actor:send("<b:yellow>" .. "%get.obj_shortdesc[%vnum_light%]%</> for <magenta>%get.obj_shortdesc[%vnum_gem_light%]%</>")
            actor:send("- times claimed: (" .. "%actor.quest_variable[black_legion:%vnum_light%_reward]%)_")
        end
        if status >= 100 then
            actor:send("<b:yellow>" .. "%get.obj_shortdesc[%vnum_belt%]%</> for <magenta>%get.obj_shortdesc[%vnum_gem_belt%]%</>")
            actor:send("- times claimed: (" .. "%actor.quest_variable[black_legion:%vnum_belt%_reward]%)_")
            actor:send("<b:yellow>" .. "%get.obj_shortdesc[%vnum_shiv%]%</> for <magenta>%get.obj_shortdesc[%vnum_gem_shiv%]%</>")
            actor:send("- times claimed: (" .. "%actor.quest_variable[black_legion:%vnum_shiv%_reward]%)_")
        end
        if status >= 115 then
            actor:send("<b:yellow>" .. "%get.obj_shortdesc[%vnum_boots%]%</> for <magenta>%get.obj_shortdesc[%vnum_gem_boots%]%</>")
            actor:send("- times claimed: (" .. "%actor.quest_variable[black_legion:%vnum_boots%_reward]%)_")
            actor:send("<b:yellow>" .. "%get.obj_shortdesc[%vnum_lsword%]%</> for <magenta>%get.obj_shortdesc[%vnum_gem_lsword%]%</>")
            actor:send("- times claimed: (" .. "%actor.quest_variable[black_legion:%vnum_lsword%_reward]%)_")
        end
        if status >= 130 then
            actor:send("<b:yellow>" .. "%get.obj_shortdesc[%vnum_legs%]%</> for <magenta>%get.obj_shortdesc[%vnum_gem_legs%]%</>")
            actor:send("- times claimed: (" .. "%actor.quest_variable[black_legion:%vnum_legs%_reward]%)_")
        end
        if status >= 145 then
            actor:send("<b:yellow>" .. "%get.obj_shortdesc[%vnum_robe%]%</> for <magenta>%get.obj_shortdesc[%vnum_gem_robe%]%</>")
            actor:send("- times claimed: (" .. "%actor.quest_variable[black_legion:%vnum_robe%_reward]%)_")
            actor:send("<b:yellow>" .. "%get.obj_shortdesc[%vnum_jerkin%]%</> for <magenta>%get.obj_shortdesc[%vnum_gem_jerkin%]%</>")
            actor:send("- times claimed: (" .. "%actor.quest_variable[black_legion:%vnum_jerkin%_reward]%)_")
        end
        if status >= 160 then
            actor:send("<b:yellow>" .. "%get.obj_shortdesc[%vnum_mask%]%</> for <magenta>%get.obj_shortdesc[%vnum_gem_mask%]%</>")
            actor:send("- times claimed: (" .. "%actor.quest_variable[black_legion:%vnum_mask%_reward]%)_")
            actor:send("<b:yellow>" .. "%get.obj_shortdesc[%vnum_smace%]%</> for <magenta>%get.obj_shortdesc[%vnum_gem_smace%]%</>")
            actor:send("- times claimed: (" .. "%actor.quest_variable[black_legion:%vnum_smace%_reward]%)_")
        end
        if statu < 160 then
            actor:send("As your standing with the " .. tostring(legion) .. " improves you will have access to more rewards.")
        end
    else
        actor:send("<cyan>Status: Not Started</>")
    end
end
return _return_value