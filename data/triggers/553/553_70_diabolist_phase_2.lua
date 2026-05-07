-- Trigger: diabolist_phase_2
-- Zone: 553, ID: 70
-- Type: MOB, Flags: RECEIVE
--
-- Original DG Script: #55370

-- Converted from DG Script #55370: diabolist_phase_2
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
--
-- TODO(parity): Gem/armor turn-in dispatch is broken end-to-end (same pattern
-- as 553_01): elseif branches compare object.id to literal "%...%" strings,
-- locals declared inside branches go out of scope, quest var keys are stored
-- as literal placeholders, %get.obj_shortdesc% remnants remain, and
-- `world.destroy(object.name)` should be `world.destroy(object)`. Needs a full
-- rewrite (e.g. table dispatch keyed by object.id). Left as-is to preserve the
-- original DG intent for that rewrite.
local _return_value = true  -- Default: allow action
-- 
-- This is the main receive trigger for the phased
-- armor quests installed on the mud. This trigger
-- is class and phase specific as defined below.
-- 
local class = "diabolist"
if actor.class == "class" and actor.level >= 21 and actor:get_quest_stage("phase_armor") >= 2 then
    -- 
    -- pertinient object definitions for this class
    -- destroyed armor
    local id_destroyed_gloves = 55328
    local id_destroyed_boots = 55332
    local id_destroyed_bracer = 55336
    local id_destroyed_helm = 55340
    local id_destroyed_arm = 55344
    local id_destroyed_legs = 55348
    local id_destroyed_chest = 55352
    -- gems for this class
    local id_gem_gloves = 55595
    local id_gem_boots = 55606
    local id_gem_bracer = 55617
    local id_gem_helm = 55628
    local id_gem_arm = 55639
    local id_gem_legs = 55650
    local id_gem_chest = 55661
    -- rewards for this class
    local id_reward_helm = 68
    local id_reward_arms = 69
    local id_reward_chest = 70
    local id_reward_legs = 71
    local id_reward_boots = 72
    local id_reward_bracer = 73
    local id_reward_gloves = 74
    -- 
    -- attempt to reinitialize slutty dg variables to "" (nothing)
    -- so this switch will work.
    -- 
    team_a_idrmor = nil
    id_gem = nil
    id_reward = nil
    -- 
    -- 
    -- These cases set varialbes for the
    -- quest.
    -- 
    -- switch on object.id
    if object.id == "%id_destroyed_helm%" then
        local is_armor = 1
    elseif object.id == "%id_gem_helm%" then
        local exp_multiplier = 7
        local team_a_idrmor = id_destroyed_helm
        local id_gem = id_gem_helm
        local id_reward = id_reward_helm
    elseif object.id == "%id_destroyed_arm%" then
        local is_armor = 1
    elseif object.id == "%id_gem_arm%" then
        local exp_multiplier = 8
        local team_a_idrmor = id_destroyed_arm
        local id_gem = id_gem_arm
        local id_reward = id_reward_arms
    elseif object.id == "%id_destroyed_chest%" then
        local is_armor = 1
    elseif object.id == "%id_gem_chest%" then
        local exp_multiplier = 10
        local team_a_idrmor = id_destroyed_chest
        local id_gem = id_gem_chest
        local id_reward = id_reward_chest
    elseif object.id == "%id_destroyed_legs%" then
        local is_armor = 1
    elseif object.id == "%id_gem_legs%" then
        local exp_multiplier = 9
        local team_a_idrmor = id_destroyed_legs
        local id_gem = id_gem_legs
        local id_reward = id_reward_legs
    elseif object.id == "%id_destroyed_boots%" then
        local is_armor = 1
    elseif object.id == "%id_gem_boots%" then
        local exp_multiplier = 5
        local team_a_idrmor = id_destroyed_boots
        local id_gem = id_gem_boots
        local id_reward = id_reward_boots
    elseif object.id == "%id_destroyed_bracer%" then
        local is_armor = 1
    elseif object.id == "%id_gem_bracer%" then
        local exp_multiplier = 6
        local team_a_idrmor = id_destroyed_bracer
        local id_gem = id_gem_bracer
        local id_reward = id_reward_bracer
    elseif object.id == "%id_destroyed_gloves%" then
        local is_armor = 1
    elseif object.id == "%id_gem_gloves%" then
        local exp_multiplier = 4
        local team_a_idrmor = id_destroyed_gloves
        local id_gem = id_gem_gloves
        local id_reward = id_reward_gloves
    else
        _return_value = true
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
        if actor:get_quest_var("phase_armor:id_gem_gems_acquired") then
        else
            actor:set_quest_var("phase_armor", "%id_gem%_gems_acquired", 0)
        end
        local gems = actor:get_quest_var("phase_armor:id_gem_gems_acquired")
        actor:set_quest_var("phase_armor", "%id_gem%_gems_acquired", gems)
        if gems < 3 then
            local gems = actor:get_quest_var("phase_armor:id_gem_gems_acquired") + 1
            actor:set_quest_var("phase_armor", "%id_gem%_gems_acquired", gems)
            wait(2)
            actor:send(tostring(self.name) .. " tells you, \"Hey, very nice. It is good to see adventurers out conquering the\"")
            actor:send(tostring(self.name) .. " tells you, \"realm.  You have now given me " .. tostring(gems) .. " " .. "%get.obj_shortdesc[%id_gem%]%.\"")
            world.destroy(object.name)
            actor:save()
        else
            _return_value = true
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
        if gems == 3 and actor:get_quest_var("phase_armor:team_a_idrmor_armor_acquired") == 1 then
            wait(2)
            actor:send(tostring(self.name) .. " tells you, \"Excellent intrepid adventurer, you have provided me with all\"")
            actor:send(tostring(self.name) .. " tells you, \"I need in order to reward you with " .. "%get.obj_shortdesc[%id_reward%]%!\"")
            wait(1)
            self.room:spawn_object(554, id_reward)
            wait(1)
            -- 
            -- loop for exp award.
            -- 
            actor:send("<b:yellow>You gain experience!</>")
            local lap = 1
            while lap <= exp_multiplier do
                actor:award_exp(29880)
                lap = lap + 1
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
        if actor:get_quest_var("phase_armor:team_a_idrmor_armor_acquired") then
        else
            actor:set_quest_var("phase_armor", "%team_a_idrmor%_armor_acquired", 0)
        end
        local armor = actor:get_quest_var("phase_armor:team_a_idrmor_armor_acquired")
        actor:set_quest_var("phase_armor", "%team_a_idrmor%_armor_acquired", armor)
        if armor < 1 then
            local armor = actor:get_quest_var("phase_armor:team_a_idrmor_armor_acquired") + 1
            actor:set_quest_var("phase_armor", "%team_a_idrmor%_armor_acquired", armor)
            wait(2)
            actor:send(tostring(self.name) .. " tells you, \"Hey now. what have we here?!  I've been looking for some of this\"")
            actor:send(tostring(self.name) .. " tells you, \"for quite some time.  You have now given me " .. "%get.obj_shortdesc[%team_a_idrmor%]%.\"")
            world.destroy(object.name)
            actor:save()
        else
            _return_value = true
            wait(2)
            self:command("eye " .. tostring(actor.name))
            wait(1)
            actor:send(tostring(self.name) .. " tells you, \"Hey now, you have given me " .. "%get.obj_shortdesc[%team_a_idrmor%]% already!\"")
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
        if armor == 1 and actor:get_quest_var("phase_armor:id_gem_gems_acquired") == 3 then
            wait(2)
            actor:send(tostring(self.name) .. " tells you, \"Excellent intrepid adventurer, you have provided me with all\"")
            actor:send(tostring(self.name) .. " tells you, \"I need in order to reward you with " .. "%get.obj_shortdesc[%id_reward%]%!\"")
            wait(1)
            self.room:spawn_object(554, id_reward)
            wait(1)
            -- 
            -- loop for exp award.
            -- 
            actor:send("<b:yellow>You gain experience!</>")
            local lap = 1
            while lap <= exp_multiplier do
                actor:award_exp(29880)
                lap = lap + 1
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
    _return_value = true
    wait(1)
    self:command("eye " .. tostring(actor.name))
    actor:send(tostring(self.name) .. " tells you, 'I am not interested in this from you.'")
    actor:send(tostring(self.name) .. " returns your item to you.")
end
return _return_value