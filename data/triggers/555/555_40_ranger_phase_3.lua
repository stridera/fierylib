-- Trigger: ranger_phase_3
-- Zone: 555, ID: 40
-- Type: MOB, Flags: RECEIVE
-- Status: NEEDS_REVIEW
--   Complex nesting: 15 if statements
--   Large script: 10435 chars
--
-- Original DG Script: #55540

-- Converted from DG Script #55540: ranger_phase_3
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
-- 
-- This is the main receive trigger for the phased
-- armor quests installed on the mud. This trigger
-- is class and phase specific as defined below.
-- 
local class = "ranger"
if actor.class == "class" and actor.level >= 41 and actor:get_quest_stage("phase_armor") >= 2 then
    -- 
    -- pertinient object definitions for this class
    -- destroyed armor
    local vnum_destroyed_gloves = 55357
    local vnum_destroyed_boots = 55361
    local vnum_destroyed_bracer = 55365
    local vnum_destroyed_helm = 55369
    local vnum_destroyed_arm = 55373
    local vnum_destroyed_legs = 55377
    local vnum_destroyed_chest = 55381
    -- gems for this class
    local vnum_gem_gloves = 55677
    local vnum_gem_boots = 55688
    local vnum_gem_bracer = 55699
    local vnum_gem_helm = 55710
    local vnum_gem_arm = 55721
    local vnum_gem_legs = 55732
    local vnum_gem_chest = 55743
    -- rewards for this class
    local vnum_reward_helm = 55517
    local vnum_reward_arms = 55518
    local vnum_reward_chest = 55519
    local vnum_reward_legs = 55520
    local vnum_reward_boots = 55521
    local vnum_reward_bracer = 55522
    local vnum_reward_gloves = 55523
    -- 
    -- attempt to reinitialize slutty dg variables to "" (nothing)
    -- so this switch will work.
    -- 
    vnum_armor = nil
    vnum_gem = nil
    vnum_reward = nil
    -- 
    -- 
    -- These cases set varialbes for the
    -- quest.
    -- 
    -- switch on object.id
    if object.id == "%vnum_destroyed_helm%" then
        local is_armor = 1
    elseif object.id == "%vnum_gem_helm%" then
        local exp_multiplier = 11
        local vnum_armor = vnum_destroyed_helm
        local vnum_gem = vnum_gem_helm
        local vnum_reward = vnum_reward_helm
    elseif object.id == "%vnum_destroyed_arm%" then
        local is_armor = 1
    elseif object.id == "%vnum_gem_arm%" then
        local exp_multiplier = 12
        local vnum_armor = vnum_destroyed_arm
        local vnum_gem = vnum_gem_arm
        local vnum_reward = vnum_reward_arms
    elseif object.id == "%vnum_destroyed_chest%" then
        local is_armor = 1
    elseif object.id == "%vnum_gem_chest%" then
        local exp_multiplier = 14
        local vnum_armor = vnum_destroyed_chest
        local vnum_gem = vnum_gem_chest
        local vnum_reward = vnum_reward_chest
    elseif object.id == "%vnum_destroyed_legs%" then
        local is_armor = 1
    elseif object.id == "%vnum_gem_legs%" then
        local exp_multiplier = 13
        local vnum_armor = vnum_destroyed_legs
        local vnum_gem = vnum_gem_legs
        local vnum_reward = vnum_reward_legs
    elseif object.id == "%vnum_destroyed_boots%" then
        local is_armor = 1
    elseif object.id == "%vnum_gem_boots%" then
        local exp_multiplier = 9
        local vnum_armor = vnum_destroyed_boots
        local vnum_gem = vnum_gem_boots
        local vnum_reward = vnum_reward_boots
    elseif object.id == "%vnum_destroyed_bracer%" then
        local is_armor = 1
    elseif object.id == "%vnum_gem_bracer%" then
        local exp_multiplier = 10
        local vnum_armor = vnum_destroyed_bracer
        local vnum_gem = vnum_gem_bracer
        local vnum_reward = vnum_reward_bracer
    elseif object.id == "%vnum_destroyed_gloves%" then
        local is_armor = 1
    elseif object.id == "%vnum_gem_gloves%" then
        local exp_multiplier = 8
        local vnum_armor = vnum_destroyed_gloves
        local vnum_gem = vnum_gem_gloves
        local vnum_reward = vnum_reward_gloves
    else
        _return_value = false
        wait(1)
        self:command("eye " .. tostring(actor.name))
        actor:send(tostring(self.name) .. " tells you, 'I am not interested in this from you.'")
        actor:send(tostring(self.name) .. " returns your item to you.")
        return _return_value
    end
    -- 
    -- need to force character saving after each turnin.
    -- 
    if not is_armor then
        -- hrmm Jelos' magical variable declaration
        if actor:get_quest_var("phase_armor:" .. vnum_gem .. "_gems_acquired") then
        else
            actor:set_quest_var("phase_armor", vnum_gem .. "_gems_acquired", 0)
        end
        local gems = actor:get_quest_var("phase_armor:" .. vnum_gem .. "_gems_acquired")
        actor:set_quest_var("phase_armor", vnum_gem .. "_gems_acquired", gems)
        if gems < 3 then
            local gems = actor:get_quest_var("phase_armor:" .. vnum_gem .. "_gems_acquired") + 1
            actor:set_quest_var("phase_armor", vnum_gem .. "_gems_acquired", gems)
            wait(2)
            actor:send(tostring(self.name) .. " tells you, \"Hey, very nice. It is good to see adventurers out conquering the\"")
            actor:send(tostring(self.name) .. " tells you, \"realm.  You have now given me " .. tostring(gems) .. " " .. "%get.obj_shortdesc[%vnum_gem%]%.\"")
            world.destroy(object.name)
            actor:save()
        else
            _return_value = false
            wait(2)
            self:command("eye " .. tostring(actor.name))
            wait(1)
            actor:send(tostring(self.name) .. " tells you, \"Hey now, you have given me 3 already!\"")
            actor:send(tostring(self.name) .. " returns your item to you.")
            -- 
            -- Halt here so that the reward section isn't checked if the max
            -- number of armor pieces has already been turned in so the reward
            -- can't be given multiple times.
            -- 
            return _return_value
        end
        -- 
        -- check to see if the quest is complete and the reward can be given..
        -- 
        if gems == 3 and actor:get_quest_var("phase_armor:" .. vnum_armor .. "_armor_acquired") == 1 then
            wait(2)
            actor:send(tostring(self.name) .. " tells you, \"Excellent intrepid adventurer, you have provided me with all\"")
            actor:send(tostring(self.name) .. " tells you, \"I need in order to reward you with " .. "%get.obj_shortdesc[%vnum_reward%]%!\"")
            wait(1)
            -- vnum_reward values are 553xx-555xx => zone = vnum_reward // 100, local_id = vnum_reward % 100
            self.room:spawn_object(vnum_reward // 100, vnum_reward % 100)
            wait(1)
            -- 
            -- loop for exp award.
            -- 
            actor:send("<b:yellow>You gain experience!</>")
            local lap = 1
            while lap <= exp_multiplier do
                actor:award_exp(42840)
                local lap = lap + 1
            end
            -- Note while loops can't be indented, due to dumbass
            -- coders.
            -- end exp loop
            -- 
            -- all other items should be mpjunked or whatever by now
            self:command("give all " .. tostring(actor.name))
        end
        -- 
        -- other if's for the armor turn-ins should go between here and the last object
        -- 
    else
        -- here is where the armor section goes
        -- that is true for is_armor == 1
        -- hrmm Jelos' magical variable declaration
        if actor:get_quest_var("phase_armor:" .. vnum_armor .. "_armor_acquired") then
        else
            actor:set_quest_var("phase_armor", vnum_armor .. "_armor_acquired", 0)
        end
        local armor = actor:get_quest_var("phase_armor:" .. vnum_armor .. "_armor_acquired")
        actor:set_quest_var("phase_armor", vnum_armor .. "_armor_acquired", armor)
        if armor < 1 then
            local armor = actor:get_quest_var("phase_armor:" .. vnum_armor .. "_armor_acquired") + 1
            actor:set_quest_var("phase_armor", vnum_armor .. "_armor_acquired", armor)
            wait(2)
            actor:send(tostring(self.name) .. " tells you, \"Hey now. what have we here?!  I've been looking for some of this\"")
            actor:send(tostring(self.name) .. " tells you, \"for quite some time.  You have now given me " .. "%get.obj_shortdesc[%vnum_armor%]%.\"")
            world.destroy(object.name)
            actor:save()
        else
            _return_value = false
            wait(2)
            self:command("eye " .. tostring(actor.name))
            wait(1)
            actor:send(tostring(self.name) .. " tells you, \"Hey now, you have given me " .. "%get.obj_shortdesc[%vnum_armor%]% already!\"")
            actor:send(tostring(self.name) .. " returns your item to you.")
            -- 
            -- Halt here so that the reward section isn't checked if the max
            -- number of armor pieces has already been turned in so the reward
            -- can't be given multiple times.
            -- 
            return _return_value
        end
        -- 
        -- check to see if the quest is complete and the reward can be given..
        -- 
        if armor == 1 and actor:get_quest_var("phase_armor:" .. vnum_gem .. "_gems_acquired") == 3 then
            wait(2)
            actor:send(tostring(self.name) .. " tells you, \"Excellent intrepid adventurer, you have provided me with all\"")
            actor:send(tostring(self.name) .. " tells you, \"I need in order to reward you with " .. "%get.obj_shortdesc[%vnum_reward%]%!\"")
            wait(1)
            -- vnum_reward values are 553xx-555xx => zone = vnum_reward // 100, local_id = vnum_reward % 100
            self.room:spawn_object(vnum_reward // 100, vnum_reward % 100)
            wait(1)
            -- 
            -- loop for exp award.
            -- 
            actor:send("<b:yellow>You gain experience!</>")
            local lap = 1
            while lap <= exp_multiplier do
                actor:award_exp(42840)
                local lap = lap + 1
            end
            -- Note while loops can't be indented, due to dumbass
            -- coders.
            -- end exp loop
            -- 
            -- all other items should be mpjunked or whatever by now
            self:command("give all " .. tostring(actor.name))
        end
    end
    -- last object if before else that returns unwated objects to the player
else
    -- not the correct class for this particular quest?
    -- 
    -- This return will prevent the actual give from
    -- the player in the first place and make it look
    -- like homeslice is giving the object back.
    -- 
    _return_value = false
    wait(1)
    self:command("eye " .. tostring(actor.name))
    actor:send(tostring(self.name) .. " tells you, 'I am not interested in this from you.'")
    actor:send(tostring(self.name) .. " returns your item to you.")
end
return _return_value