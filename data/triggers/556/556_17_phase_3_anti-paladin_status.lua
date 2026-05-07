-- Trigger: phase_3_anti-paladin_status
-- Zone: 556, ID: 17
-- Type: MOB, Flags: SPEECH_TO
--
-- Original DG Script: #55617

-- Converted from DG Script #55617: phase_3_anti-paladin_status
-- Original: MOB trigger, flags: SPEECH_TO, probability: 0%

-- TODO(parity): Status report relies on broken DG-Script remnants from auto-conversion.
-- Issues to fix in a future rewrite of the phase_armor quest dispatch:
--   * Quest-var keys are literal strings ("phase_armor:id_destroyed_gloves_armor_acquired")
--     instead of being interpolated with the per-class id_destroyed_* values, so every
--     class shares the same key namespace and the per-class id_* tables below are dead
--     code.
--   * Output uses raw "%get.obj_shortdesc[%X%]%" placeholders (DG syntax) instead of
--     looking up object names via objects.template(zone, id).name.
--   * 5-digit legacy vnums (55300+) need to be split into composite (zone, id) pairs
--     and resolved through the object catalog.
--   * The "given" truthiness check (line: "if given then") sums numeric quest vars,
--     so it reports "You have given me:" even when the player has given nothing
--     (0 is truthy in Lua).
--   * "_return_value" is referenced but never defined.
--   * Class identifiers (Warrior/Cleric/etc.) are bare globals instead of strings.
-- The trigger is currently gated by "if not percent_chance(0) then return true end",
-- so it never actually fires in production. Leaving the body intact for later rewrite.


-- 0% chance to trigger
if not percent_chance(0) then
    return true
end
-- For some stoooopid reason, the ~= operator doesn't want to work in evals
local min_level = 41
local quest_stage = 2
if string.find(actor.class, "Anti") then
    if actor.level < min_level then
        actor:send(tostring(self.name) .. " tells you, 'You need to gain more experience first.'")
    elseif actor:get_quest_stage("phase_armor") >= quest_stage then
        -- destroyed armor
        local id_destroyed_gloves = 55356
        local id_destroyed_boots = 55360
        local id_destroyed_bracer = 55364
        local id_destroyed_helm = 55368
        local id_destroyed_arm = 55372
        local id_destroyed_legs = 55376
        local id_destroyed_chest = 55380
        -- gems for this class
        local id_gem_gloves = 55671
        local id_gem_boots = 55682
        local id_gem_bracer = 55693
        local id_gem_helm = 55704
        local id_gem_arm = 55715
        local id_gem_legs = 55726
        local id_gem_chest = 55737
        -- rewards for this class
        local id_reward_helm = 55503
        local id_reward_arms = 55504
        local id_reward_chest = 55505
        local id_reward_legs = 55506
        local id_reward_boots = 55507
        local id_reward_bracer = 55508
        local id_reward_gloves = 55509
        local gloves_armor = actor:get_quest_var("phase_armor:id_destroyed_gloves_armor_acquired")
        local boots_armor = actor:get_quest_var("phase_armor:id_destroyed_boots_armor_acquired")
        local bracer_armor = actor:get_quest_var("phase_armor:id_destroyed_bracer_armor_acquired")
        local helm_armor = actor:get_quest_var("phase_armor:id_destroyed_helm_armor_acquired")
        local arm_armor = actor:get_quest_var("phase_armor:id_destroyed_arm_armor_acquired")
        local legs_armor = actor:get_quest_var("phase_armor:id_destroyed_legs_armor_acquired")
        local chest_armor = actor:get_quest_var("phase_armor:id_destroyed_chest_armor_acquired")
        local gloves_gems = actor:get_quest_var("phase_armor:id_gem_gloves_gems_acquired")
        local boots_gems = actor:get_quest_var("phase_armor:id_gem_boots_gems_acquired")
        local bracer_gems = actor:get_quest_var("phase_armor:id_gem_bracer_gems_acquired")
        local helm_gems = actor:get_quest_var("phase_armor:id_gem_helm_gems_acquired")
        local arm_gems = actor:get_quest_var("phase_armor:id_gem_arm_gems_acquired")
        local legs_gems = actor:get_quest_var("phase_armor:id_gem_legs_gems_acquired")
        local chest_gems = actor:get_quest_var("phase_armor:id_gem_chest_gems_acquired")
        local done_gloves = gloves_armor == 1  and  gloves_gems == 3
        local done_boots = boots_armor == 1  and  boots_gems == 3
        local done_bracer = bracer_armor == 1  and  bracer_gems == 3
        local done_helm = helm_armor == 1  and  helm_gems == 3
        local done_arm = arm_armor == 1  and  arm_gems == 3
        local done_legs = legs_armor == 1  and  legs_gems == 3
        local done_chest = chest_armor == 1  and  chest_gems == 3
        local given = gloves_armor + boots_armor + bracer_armor + helm_armor + arm_armor + legs_armor + chest_armor
        given = given + gloves_gems + boots_gems + bracer_gems + helm_gems + arm_gems + legs_gems + chest_gems
        if given then
            actor:send(tostring(self.name) .. " tells you, 'You have given me:'")
        else
            actor:send(tostring(self.name) .. " tells you, 'You haven't given me anything yet.'")
            return _return_value
        end
        if gloves_armor and not done_gloves then
            actor:send(tostring(self.name) .. " tells you, '  " .. "%get.obj_shortdesc[%id_destroyed_gloves%]%'")
        end
        if gloves_gems and not done_gloves then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(gloves_gems) .. " of " .. "%get.obj_shortdesc[%id_gem_gloves%]%'")
        end
        if boots_armor and not done_boots then
            actor:send(tostring(self.name) .. " tells you, '  " .. "%get.obj_shortdesc[%id_destroyed_boots%]%'")
        end
        if boots_gems and not done_boots then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(boots_gems) .. " of " .. "%get.obj_shortdesc[%id_gem_boots%]%'")
        end
        if bracer_armor and not done_bracer then
            actor:send(tostring(self.name) .. " tells you, '  " .. "%get.obj_shortdesc[%id_destroyed_bracer%]%'")
        end
        if bracer_gems and not done_bracer then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(bracer_gems) .. " of " .. "%get.obj_shortdesc[%id_gem_bracer%]%'")
        end
        if helm_armor and not done_helm then
            actor:send(tostring(self.name) .. " tells you, '  " .. "%get.obj_shortdesc[%id_destroyed_helm%]%'")
        end
        if helm_gems and not done_helm then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(helm_gems) .. " of " .. "%get.obj_shortdesc[%id_gem_helm%]%'")
        end
        if arm_armor and not done_arm then
            actor:send(tostring(self.name) .. " tells you, '  " .. "%get.obj_shortdesc[%id_destroyed_arm%]%'")
        end
        if arm_gems and not done_arm then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(arm_gems) .. " of " .. "%get.obj_shortdesc[%id_gem_arm%]%'")
        end
        if legs_armor and not done_legs then
            actor:send(tostring(self.name) .. " tells you, '  " .. "%get.obj_shortdesc[%id_destroyed_legs%]%'")
        end
        if legs_gems and not done_legs then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(legs_gems) .. " of " .. "%get.obj_shortdesc[%id_gem_legs%]%'")
        end
        if chest_armor and not done_chest then
            actor:send(tostring(self.name) .. " tells you, '  " .. "%get.obj_shortdesc[%id_destroyed_chest%]%'")
        end
        if chest_gems and not done_chest then
            actor:send(tostring(self.name) .. " tells you, '  " .. tostring(chest_gems) .. " of " .. "%get.obj_shortdesc[%id_gem_chest%]%'")
        end
        if done_gloves and done_boots and done_bracer and done_helm and done_arm and done_legs and done_chest then
            actor:send(tostring(self.name) .. " tells you, 'You have completed quests for:'")
        end
        if done_gloves then
            actor:send(tostring(self.name) .. " tells you, '  " .. "%get.obj_shortdesc[%id_reward_gloves%]%'")
        end
        if done_boots then
            actor:send(tostring(self.name) .. " tells you, '  " .. "%get.obj_shortdesc[%id_reward_boots%]%'")
        end
        if done_bracer then
            actor:send(tostring(self.name) .. " tells you, '  " .. "%get.obj_shortdesc[%id_reward_bracer%]%'")
        end
        if done_helm then
            actor:send(tostring(self.name) .. " tells you, '  " .. "%get.obj_shortdesc[%id_reward_helm%]%'")
        end
        if done_arm then
            actor:send(tostring(self.name) .. " tells you, '  " .. "%get.obj_shortdesc[%id_reward_arms%]%'")
        end
        if done_legs then
            actor:send(tostring(self.name) .. " tells you, '  " .. "%get.obj_shortdesc[%id_reward_legs%]%'")
        end
        if done_chest then
            actor:send(tostring(self.name) .. " tells you, '  " .. "%get.obj_shortdesc[%id_reward_chest%]%'")
        end
    else
        actor:send(tostring(self.name) .. " tells you, 'You haven't even talked to me about armor quests yet!'")
    end
end