-- Trigger: phase_1_warrior_status
-- Zone: 556, ID: 6
-- Type: MOB, Flags: SPEECH_TO
-- Status: NEEDS_REVIEW
--   Complex nesting: 26 if statements
--   Large script: 7848 chars
--
-- Original DG Script: #55606

-- Converted from DG Script #55606: phase_1_warrior_status
-- Original: MOB trigger, flags: SPEECH_TO, probability: 0%

-- 0% chance to trigger
if not percent_chance(0) then
    return true
end
local anti = "Anti-Paladin"
local right_class = (actor.class == Warrior)  or  (actor.class == anti)  or  (actor.class == Paladin)  or  (actor.class == Ranger)  or  (actor.class == Monk)
local min_level = 1
local quest_stage = 1
if right_class then
    if actor.level < min_level then
        actor:send(tostring(self.name) .. " tells you, 'You need to gain more experience first.'")
    elseif actor:get_quest_stage("phase_armor") >= quest_stage then
        -- armors for this class
        local vnum_destroyed_gloves = 55300
        local vnum_destroyed_boots = 55304
        local vnum_destroyed_bracer = 55308
        local vnum_destroyed_helm = 55312
        local vnum_destroyed_arm = 55316
        local vnum_destroyed_legs = 55320
        local vnum_destroyed_chest = 55324
        -- gems for this class
        local vnum_gem_gloves = 55569
        local vnum_gem_boots = 55573
        local vnum_gem_bracer = 55577
        local vnum_gem_helm = 55581
        local vnum_gem_arm = 55585
        local vnum_gem_legs = 55589
        local vnum_gem_chest = 55593
        -- rewards for this class
        local vnum_reward_helm = 55384
        local vnum_reward_arms = 55385
        local vnum_reward_chest = 55386
        local vnum_reward_legs = 55387
        local vnum_reward_boots = 55388
        local vnum_reward_bracer = 55389
        local vnum_reward_gloves = 55390
        local gloves_armor = actor.quest_variable[phase_armor:vnum_destroyed_gloves_armor_acquired]
        local boots_armor = actor.quest_variable[phase_armor:vnum_destroyed_boots_armor_acquired]
        local bracer_armor = actor.quest_variable[phase_armor:vnum_destroyed_bracer_armor_acquired]
        local helm_armor = actor.quest_variable[phase_armor:vnum_destroyed_helm_armor_acquired]
        local arm_armor = actor.quest_variable[phase_armor:vnum_destroyed_arm_armor_acquired]
        local legs_armor = actor.quest_variable[phase_armor:vnum_destroyed_legs_armor_acquired]
        local chest_armor = actor.quest_variable[phase_armor:vnum_destroyed_chest_armor_acquired]
        local gloves_gems = actor.quest_variable[phase_armor:vnum_gem_gloves_gems_acquired]
        local boots_gems = actor.quest_variable[phase_armor:vnum_gem_boots_gems_acquired]
        local bracer_gems = actor.quest_variable[phase_armor:vnum_gem_bracer_gems_acquired]
        local helm_gems = actor.quest_variable[phase_armor:vnum_gem_helm_gems_acquired]
        local arm_gems = actor.quest_variable[phase_armor:vnum_gem_arm_gems_acquired]
        local legs_gems = actor.quest_variable[phase_armor:vnum_gem_legs_gems_acquired]
        local chest_gems = actor.quest_variable[phase_armor:vnum_gem_chest_gems_acquired]
        local done_gloves = gloves_armor == 1  and  gloves_gems == 3
        local done_boots = boots_armor == 1  and  boots_gems == 3
        local done_bracer = bracer_armor == 1  and  bracer_gems == 3
        local done_helm = helm_armor == 1  and  helm_gems == 3
        local done_arm = arm_armor == 1  and  arm_gems == 3
        local done_legs = legs_armor == 1  and  legs_gems == 3
        local done_chest = chest_armor == 1  and  chest_gems == 3
        local given = gloves_armor + boots_armor + bracer_armor + helm_armor + arm_armor + legs_armor + chest_armor
        local given = given + gloves_gems + boots_gems + bracer_gems + helm_gems + arm_gems + legs_gems + chest_gems
        if given then
            actor:send(tostring(self.name) .. " tells you, 'You have given me:'")
        else
            actor:send(tostring(self.name) .. " tells you, 'You haven't given me anything yet.'")
            return _return_value
        end
        if gloves_armor and not done_gloves then
            actor:send(tostring(self.name) .. " tells you, '  " .. "%get.obj_shortdesc[%vnum_destroyed_gloves%]%'")
        end
        if gloves_gems and not done_gloves then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(gloves_gems) .. " of " .. "%get.obj_shortdesc[%vnum_gem_gloves%]%'")
        end
        if boots_armor and not done_boots then
            actor:send(tostring(self.name) .. " tells you, '  " .. "%get.obj_shortdesc[%vnum_destroyed_boots%]%'")
        end
        if boots_gems and not done_boots then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(boots_gems) .. " of " .. "%get.obj_shortdesc[%vnum_gem_boots%]%'")
        end
        if bracer_armor and not done_bracer then
            actor:send(tostring(self.name) .. " tells you, '  " .. "%get.obj_shortdesc[%vnum_destroyed_bracer%]%'")
        end
        if bracer_gems and not done_bracer then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(bracer_gems) .. " of " .. "%get.obj_shortdesc[%vnum_gem_bracer%]%'")
        end
        if helm_armor and not done_helm then
            actor:send(tostring(self.name) .. " tells you, '  " .. "%get.obj_shortdesc[%vnum_destroyed_helm%]%'")
        end
        if helm_gems and not done_helm then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(helm_gems) .. " of " .. "%get.obj_shortdesc[%vnum_gem_helm%]%'")
        end
        if arm_armor and not done_arm then
            actor:send(tostring(self.name) .. " tells you, '  " .. "%get.obj_shortdesc[%vnum_destroyed_arm%]%'")
        end
        if arm_gems and not done_arm then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(arm_gems) .. " of " .. "%get.obj_shortdesc[%vnum_gem_arm%]%'")
        end
        if legs_armor and not done_legs then
            actor:send(tostring(self.name) .. " tells you, '  " .. "%get.obj_shortdesc[%vnum_destroyed_legs%]%'")
        end
        if legs_gems and not done_legs then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(legs_gems) .. " of " .. "%get.obj_shortdesc[%vnum_gem_legs%]%'")
        end
        if chest_armor and not done_chest then
            actor:send(tostring(self.name) .. " tells you, '  " .. "%get.obj_shortdesc[%vnum_destroyed_chest%]%'")
        end
        if chest_gems and not done_chest then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(chest_gems) .. " of " .. "%get.obj_shortdesc[%vnum_gem_chest%]%'")
        end
        if done_gloves or done_boots or done_bracer or done_helm or done_arm or done_legs or done_chest then
            actor:send(tostring(self.name) .. " tells you, 'You have completed quests for:'")
        end
        if done_gloves then
            actor:send(tostring(self.name) .. " tells you, '  " .. "%get.obj_shortdesc[%vnum_reward_gloves%]%'")
        end
        if done_boots then
            actor:send(tostring(self.name) .. " tells you, '  " .. "%get.obj_shortdesc[%vnum_reward_boots%]%'")
        end
        if done_bracer then
            actor:send(tostring(self.name) .. " tells you, '  " .. "%get.obj_shortdesc[%vnum_reward_bracer%]%'")
        end
        if done_helm then
            actor:send(tostring(self.name) .. " tells you, '  " .. "%get.obj_shortdesc[%vnum_reward_helm%]%'")
        end
        if done_arm then
            actor:send(tostring(self.name) .. " tells you, '  " .. "%get.obj_shortdesc[%vnum_reward_arms%]%'")
        end
        if done_legs then
            actor:send(tostring(self.name) .. " tells you, '  " .. "%get.obj_shortdesc[%vnum_reward_legs%]%'")
        end
        if done_chest then
            actor:send(tostring(self.name) .. " tells you, '  " .. "%get.obj_shortdesc[%vnum_reward_chest%]%'")
        end
    else
        actor:send(tostring(self.name) .. " tells you, 'You haven't even talked to me about armor quests yet!'")
    end
end