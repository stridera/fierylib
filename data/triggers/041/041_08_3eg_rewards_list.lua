-- Trigger: 3eg_rewards_list
-- Zone: 41, ID: 8
-- Type: MOB, Flags: SPEECH, SPEECH_TO
-- Status: NEEDS_REVIEW
--   Complex nesting: 10 if statements
--
-- Original DG Script: #4108

-- Converted from DG Script #4108: 3eg_rewards_list
-- Original: MOB trigger, flags: SPEECH, SPEECH_TO, probability: 100%

-- Speech keywords: reward rewards
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "reward") or string.find(string.lower(speech), "rewards")) then
    return true  -- No matching keywords
end
if actor:get_quest_var("Black_Legion:bl_ally") then
    actor:send(tostring(self.name) .. " tells you, 'You have pledged yourself to the forces of")
    actor:send("</>darkness!  Suffer under your choice!'")
    return _return_value
end
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
local id_3eg_cap = 5518
local id_3eg_neck = 5520
local id_3eg_arm = 5522
local id_3eg_wrist = 5524
local id_3eg_staff = 5546
local id_3eg_ssword = 5547
local id_3eg_whammer = 5548
local id_3eg_flail = 5549
local id_3eg_food = 5556
local id_3eg_drink = 5558
-- 
-- Check faction and react accordingly
-- 
if actor.alignment >= -150 then
    if actor:get_quest_stage("Black_Legion") > 0 then
        if actor:get_quest_var("black_legion:eg_faction") < 20 then
            -- (empty send to actor)
            actor:send(tostring(self.name) .. " tells you, 'You are a bit raw for a recruit, come back")
            actor:send("</>when you have defeated more of the Black Legion hordes.'")
        end
        if actor:get_quest_var("black_legion:eg_faction") >= 20 then
            -- (empty send to actor)
            -- msend %actor% %self.name% tells you,'Your bl faction is %actor.quest_variable[black_legion:eg_faction]%.
            actor:send(tostring(self.name) .. " tells you, 'Though you are a bit wet behind the ears I")
            actor:send("suppose we can trust you with some of our goods.'")
            -- (empty send to actor)
            actor:send("You have access to:")
            actor:send("- <b:yellow>" .. "%get.obj_shortdesc[%id_3eg_food%]%</> for <magenta>%get.obj_shortdesc[%id_gem_3eg_food%]%.</>")
            actor:send("- <b:yellow>" .. "%get.obj_shortdesc[%id_3eg_drink%]%</> for <magenta>%get.obj_shortdesc[%id_gem_3eg_drink%]%.</>")
            actor:send("- <b:yellow>" .. "%get.obj_shortdesc[%id_3eg_cap%]%</> for <magenta>%get.obj_shortdesc[%id_gem_3eg_cap%]%.</>")
            actor:send("- <b:yellow>" .. "%get.obj_shortdesc[%id_3eg_ssword%]%</> for <magenta>%get.obj_shortdesc[%id_gem_3eg_ssword%]%.</>")
        end
        if actor:get_quest_var("black_legion:eg_faction") >= 40 then
            actor:send("- <b:yellow>" .. "%get.obj_shortdesc[%id_3eg_neck%]%</> for <magenta>%get.obj_shortdesc[%id_gem_3eg_neck%]%.</>")
            actor:send("- <b:yellow>" .. "%get.obj_shortdesc[%id_3eg_staff%]%</> for <magenta>%get.obj_shortdesc[%id_gem_3eg_staff%]%.</>")
        end
        if actor:get_quest_var("black_legion:eg_faction") >= 55 then
            actor:send("- <b:yellow>" .. "%get.obj_shortdesc[%id_3eg_arm%]%</> for <magenta>%get.obj_shortdesc[%id_gem_3eg_arm%]%.</>")
            actor:send("- <b:yellow>" .. "%get.obj_shortdesc[%id_3eg_whammer%]%</> for <magenta>%get.obj_shortdesc[%id_gem_3eg_whammer%]%.</>")
        end
        if actor:get_quest_var("black_legion:eg_faction") >= 70 then
            actor:send("- <b:yellow>" .. "%get.obj_shortdesc[%id_3eg_wrist%]%</> for <magenta>%get.obj_shortdesc[%id_gem_3eg_wrist%]%.</>")
            actor:send("- <b:yellow>" .. "%get.obj_shortdesc[%id_3eg_flail%]%</> for <magenta>%get.obj_shortdesc[%id_gem_3eg_flail%]%.</>")
        end
        if actor:get_quest_var("black_legion:eg_faction") < 70 then
            -- (empty send to actor)
            actor:send(tostring(self.name) .. " tells you, 'As your standing with the Eldorian Guard")
            actor:send("</>improves I will show you more rewards.'")
        end
        -- (empty send to actor)
    end
end