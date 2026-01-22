-- Trigger: 3bl_rewards_list
-- Zone: 41, ID: 4
-- Type: MOB, Flags: SPEECH, SPEECH_TO
-- Status: NEEDS_REVIEW
--   Complex nesting: 10 if statements
--
-- Original DG Script: #4104

-- Converted from DG Script #4104: 3bl_rewards_list
-- Original: MOB trigger, flags: SPEECH, SPEECH_TO, probability: 100%

-- Speech keywords: reward rewards
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "reward") or string.find(string.lower(speech), "rewards")) then
    return true  -- No matching keywords
end
local vnum_gem_3bl_cap = 55570
local vnum_gem_3bl_neck = 55571
local vnum_gem_3bl_arm = 55572
local vnum_gem_3bl_wrist = 55573
local vnum_gem_3bl_gloves = 55574
local vnum_gem_3bl_jerkin = 55575
local vnum_gem_3bl_robe = 55589
local vnum_gem_3bl_belt = 55576
local vnum_gem_3bl_legs = 55577
local vnum_gem_3bl_boots = 55578
local vnum_gem_3bl_mask = 55579
local vnum_gem_3bl_symbol = 55580
local vnum_gem_3bl_staff = 55581
local vnum_gem_3bl_ssword = 55582
local vnum_gem_3bl_whammer = 55583
local vnum_gem_3bl_flail = 55584
local vnum_gem_3bl_shiv = 55585
local vnum_gem_3bl_lsword = 55586
local vnum_gem_3bl_smace = 55587
local vnum_gem_3bl_light = 55588
local vnum_gem_3bl_food = 55566
local vnum_gem_3bl_drink = 55567
-- rewards
local vnum_3bl_cap = 5517
local vnum_3bl_neck = 5519
local vnum_3bl_arm = 5521
local vnum_3bl_wrist = 5523
local vnum_3bl_gloves = 5525
local vnum_3bl_jerkin = 5527
local vnum_3bl_belt = 5529
local vnum_3bl_legs = 5531
local vnum_3bl_boots = 5533
local vnum_3bl_mask = 5535
local vnum_3bl_robe = 5537
local vnum_3bl_symbol = 5515
local vnum_3bl_staff = 5539
local vnum_3bl_ssword = 5540
local vnum_3bl_whammer = 5541
local vnum_3bl_flail = 5542
local vnum_3bl_shiv = 5543
local vnum_3bl_lsword = 5544
local vnum_3bl_smace = 5545
local vnum_3bl_light = 5553
local vnum_3bl_food = 5555
local vnum_3bl_drink = 5557
-- 
-- Check faction and react accordingly
-- 
if actor:get_quest_var("Black_Legion:eg_ally") then
    actor:send(tostring(self.name) .. " tells you, 'You have already chosen your side!  Be")
    actor:send("</>gone, filth!'")
    return _return_value
end
if actor.alignment <= 150 then
    if actor:get_quest_stage("Black_Legion") > 0 then
        if actor:get_quest_var("black_legion:bl_faction") < 20 then
            -- (empty send to actor)
            actor:send(tostring(self.name) .. " tells you, 'You are a bit raw for a recruit, come back")
            actor:send("</>when you have defeated more of the Eldorian villainy.'")
        end
        if actor:get_quest_var("black_legion:bl_faction") >= 20 then
            -- (empty send to actor)
            -- msend %actor% %self.name% tells you,'Your bl faction is %actor.quest_variable[black_legion:bl_faction]%.
            actor:send(tostring(self.name) .. " tells you, 'Though you are a bit wet behind the ears I")
            actor:send("</>suppose we can trust you with some of our goods.'")
            -- (empty send to actor)
            actor:send("</>You have access to:")
            actor:send("- <b:yellow>" .. "%get.obj_shortdesc[%vnum_3bl_food%]%</> for <magenta>%get.obj_shortdesc[%vnum_gem_3bl_food%]%</>")
            actor:send("- <b:yellow>" .. "%get.obj_shortdesc[%vnum_3bl_drink%]%</> for <magenta>%get.obj_shortdesc[%vnum_gem_3bl_drink%]%</>")
            actor:send("- <b:yellow>" .. "%get.obj_shortdesc[%vnum_3bl_cap%]%</> for <magenta>%get.obj_shortdesc[%vnum_gem_3bl_cap%]%</>")
            actor:send("- <b:yellow>" .. "%get.obj_shortdesc[%vnum_3bl_ssword%]%</> for <magenta>%get.obj_shortdesc[%vnum_gem_3bl_ssword%]%</>")
        end
        if actor:get_quest_var("black_legion:bl_faction") >= 40 then
            actor:send("- <b:yellow>" .. "%get.obj_shortdesc[%vnum_3bl_neck%]%</> for <magenta>%get.obj_shortdesc[%vnum_gem_3bl_neck%]%</>")
            actor:send("- <b:yellow>" .. "%get.obj_shortdesc[%vnum_3bl_staff%]%</> for <magenta>%get.obj_shortdesc[%vnum_gem_3bl_staff%]%</>")
        end
        if actor:get_quest_var("black_legion:bl_faction") >= 55 then
            actor:send("- <b:yellow>" .. "%get.obj_shortdesc[%vnum_3bl_arm%]%</> for <magenta>%get.obj_shortdesc[%vnum_gem_3bl_arm%]%</>")
            actor:send("- <b:yellow>" .. "%get.obj_shortdesc[%vnum_3bl_whammer%]%</> for <magenta>%get.obj_shortdesc[%vnum_gem_3bl_whammer%]%</>")
        end
        if actor:get_quest_var("black_legion:bl_faction") >= 70 then
            actor:send("- <b:yellow>" .. "%get.obj_shortdesc[%vnum_3bl_wrist%]%</> for <magenta>%get.obj_shortdesc[%vnum_gem_3bl_wrist%]%</>")
            actor:send("- <b:yellow>" .. "%get.obj_shortdesc[%vnum_3bl_flail%]%</> for <magenta>%get.obj_shortdesc[%vnum_gem_3bl_flail%]%</>")
        end
        if actor:get_quest_var("black_legion:bl_faction") < 70 then
            -- (empty send to actor)
            actor:send(tostring(self.name) .. " tells you, 'As your standing with the Black Legion")
            actor:send("</>improves I will show you more rewards.'")
        end
    end
end