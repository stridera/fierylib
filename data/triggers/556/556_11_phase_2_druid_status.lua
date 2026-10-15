-- Trigger: phase_2_druid_status
-- Zone: 556, ID: 11
-- Type: MOB, Flags: SPEECH_TO
--
-- Original DG Script: #55611

-- Converted from DG Script #55611: phase_2_druid_status
-- Original: MOB trigger, flags: SPEECH_TO, num_arg: 0 (DG phrase mode, not a probability)

-- Status report. Quest vars are keyed by the legacy object vnum, as DG did:
-- phase_armor:<vnum>_armor_acquired and phase_armor:<vnum>_gems_acquired. The turn-in
-- scripts (zones 553-555) still write placeholder keys, so progress only shows here once
-- those are fixed.

-- Speech phrase: status (DG num_arg 0 = the speech contains the whole phrase, on word boundaries)
local speech_padded = " " .. string.lower(speech) .. " "
if not string.find(speech_padded, "[%s%p]status[%s%p]") then
    return true  -- Not the phrase
end
local actor_class = string.lower(actor.class or "")
local right_class = false
for _, c in ipairs({"druid"}) do
    if string.find(actor_class, c, 1, true) then
        right_class = true
        break
    end
end
local function obj_name(vnum)
    return objects.template(math.floor(vnum / 100), vnum % 100).name
end
local min_level = 21
local quest_stage = 2
if right_class then
    if actor.level < min_level then
        actor:send(tostring(self.name) .. " tells you, 'You need to gain more experience first.'")
    elseif actor:get_quest_stage("phase_armor") >= quest_stage then
        -- destroyed armor
        local id_destroyed_gloves = 55330
        local id_destroyed_boots = 55334
        local id_destroyed_bracer = 55338
        local id_destroyed_helm = 55342
        local id_destroyed_arm = 55346
        local id_destroyed_legs = 55350
        local id_destroyed_chest = 55354
        -- gems for this class
        local id_gem_gloves = 55596
        local id_gem_boots = 55607
        local id_gem_bracer = 55618
        local id_gem_helm = 55629
        local id_gem_arm = 55640
        local id_gem_legs = 55651
        local id_gem_chest = 55662
        -- rewards for this class
        local id_reward_helm = 55447
        local id_reward_arms = 55448
        local id_reward_chest = 55449
        local id_reward_legs = 55450
        local id_reward_boots = 55451
        local id_reward_bracer = 55452
        local id_reward_gloves = 55453
        local gloves_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_gloves .. "_armor_acquired")) or 0
        local boots_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_boots .. "_armor_acquired")) or 0
        local bracer_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_bracer .. "_armor_acquired")) or 0
        local helm_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_helm .. "_armor_acquired")) or 0
        local arm_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_arm .. "_armor_acquired")) or 0
        local legs_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_legs .. "_armor_acquired")) or 0
        local chest_armor = tonumber(actor:get_quest_var("phase_armor:" .. id_destroyed_chest .. "_armor_acquired")) or 0
        local gloves_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_gloves .. "_gems_acquired")) or 0
        local boots_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_boots .. "_gems_acquired")) or 0
        local bracer_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_bracer .. "_gems_acquired")) or 0
        local helm_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_helm .. "_gems_acquired")) or 0
        local arm_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_arm .. "_gems_acquired")) or 0
        local legs_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_legs .. "_gems_acquired")) or 0
        local chest_gems = tonumber(actor:get_quest_var("phase_armor:" .. id_gem_chest .. "_gems_acquired")) or 0
        local done_gloves = gloves_armor == 1  and  gloves_gems == 3
        local done_boots = boots_armor == 1  and  boots_gems == 3
        local done_bracer = bracer_armor == 1  and  bracer_gems == 3
        local done_helm = helm_armor == 1  and  helm_gems == 3
        local done_arm = arm_armor == 1  and  arm_gems == 3
        local done_legs = legs_armor == 1  and  legs_gems == 3
        local done_chest = chest_armor == 1  and  chest_gems == 3
        local given = gloves_armor + boots_armor + bracer_armor + helm_armor + arm_armor + legs_armor + chest_armor
        given = given + gloves_gems + boots_gems + bracer_gems + helm_gems + arm_gems + legs_gems + chest_gems
        if given > 0 then
            actor:send(tostring(self.name) .. " tells you, 'You have given me:'")
        else
            actor:send(tostring(self.name) .. " tells you, 'You haven't given me anything yet.'")
            return true
        end
        if gloves_armor > 0 and not done_gloves then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_gloves) .. "'")
        end
        if gloves_gems > 0 and not done_gloves then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(gloves_gems) .. " of " .. obj_name(id_gem_gloves) .. "'")
        end
        if boots_armor > 0 and not done_boots then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_boots) .. "'")
        end
        if boots_gems > 0 and not done_boots then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(boots_gems) .. " of " .. obj_name(id_gem_boots) .. "'")
        end
        if bracer_armor > 0 and not done_bracer then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_bracer) .. "'")
        end
        if bracer_gems > 0 and not done_bracer then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(bracer_gems) .. " of " .. obj_name(id_gem_bracer) .. "'")
        end
        if helm_armor > 0 and not done_helm then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_helm) .. "'")
        end
        if helm_gems > 0 and not done_helm then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(helm_gems) .. " of " .. obj_name(id_gem_helm) .. "'")
        end
        if arm_armor > 0 and not done_arm then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_arm) .. "'")
        end
        if arm_gems > 0 and not done_arm then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(arm_gems) .. " of " .. obj_name(id_gem_arm) .. "'")
        end
        if legs_armor > 0 and not done_legs then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_legs) .. "'")
        end
        if legs_gems > 0 and not done_legs then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(legs_gems) .. " of " .. obj_name(id_gem_legs) .. "'")
        end
        if chest_armor > 0 and not done_chest then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_destroyed_chest) .. "'")
        end
        if chest_gems > 0 and not done_chest then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(chest_gems) .. " of " .. obj_name(id_gem_chest) .. "'")
        end
        if done_gloves or done_boots or done_bracer or done_helm or done_arm or done_legs or done_chest then
            actor:send(tostring(self.name) .. " tells you, 'You have completed quests for:'")
        end
        if done_gloves then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_gloves) .. "'")
        end
        if done_boots then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_boots) .. "'")
        end
        if done_bracer then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_bracer) .. "'")
        end
        if done_helm then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_helm) .. "'")
        end
        if done_arm then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_arms) .. "'")
        end
        if done_legs then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_legs) .. "'")
        end
        if done_chest then
            actor:send(tostring(self.name) .. " tells you, '  " .. obj_name(id_reward_chest) .. "'")
        end
    else
        actor:send(tostring(self.name) .. " tells you, 'You haven't even talked to me about armor quests yet!'")
    end
end