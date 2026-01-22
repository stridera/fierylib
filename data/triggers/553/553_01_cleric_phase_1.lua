-- Trigger: cleric_phase_1
-- Zone: 553, ID: 1
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN (syntax fixed, needs runtime testing)
--   Complex nesting: 15 if statements
--   Large script: 10355 chars
--   NOTE: Quest variable access patterns were fixed from DG Script syntax
--
-- Original DG Script: #55301

-- Converted from DG Script #55301: cleric_phase_1
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
--
-- This is the main receive trigger for the phased
-- armor quests installed on the mud. This trigger
-- is class and phase specific as defined below.
--
local CLERIC_SUB = (actor.class == "cleric" or actor.class == "priest" or actor.class == "diabolist" or actor.class == "druid")
if CLERIC_SUB and actor:get_quest_stage("phase_armor") >= 1 then
    --
    -- pertinient object definitions for this class
    -- destroyed armor
    local vnum_destroyed_gloves = 55300
    local vnum_destroyed_boots = 55304
    local vnum_destroyed_bracer = 55308
    local vnum_destroyed_helm = 55312
    local vnum_destroyed_arm = 55316
    local vnum_destroyed_legs = 55320
    local vnum_destroyed_chest = 55324
    -- gems for this class
    local vnum_gem_gloves = 55566
    local vnum_gem_boots = 55570
    local vnum_gem_bracer = 55574
    local vnum_gem_helm = 55578
    local vnum_gem_arm = 55582
    local vnum_gem_legs = 55586
    local vnum_gem_chest = 55590
    -- rewards for this class
    local vnum_reward_helm = 55391
    local vnum_reward_arms = 55392
    local vnum_reward_chest = 55393
    local vnum_reward_legs = 55394
    local vnum_reward_boots = 55395
    local vnum_reward_bracer = 55396
    local vnum_reward_gloves = 55397
    --
    -- Variables for quest tracking
    --
    local vnum_armor = nil
    local vnum_gem = nil
    local vnum_reward = nil
    local is_armor = nil
    local exp_multiplier = nil
    --
    -- These cases set variables for the quest.
    --
    -- switch on object.id
    if object.id == vnum_destroyed_helm then
        is_armor = 1
        vnum_armor = vnum_destroyed_helm
    elseif object.id == vnum_gem_helm then
        exp_multiplier = 10
        vnum_armor = vnum_destroyed_helm
        vnum_gem = vnum_gem_helm
        vnum_reward = vnum_reward_helm
    elseif object.id == vnum_destroyed_arm then
        is_armor = 1
        vnum_armor = vnum_destroyed_arm
    elseif object.id == vnum_gem_arm then
        exp_multiplier = 17
        vnum_armor = vnum_destroyed_arm
        vnum_gem = vnum_gem_arm
        vnum_reward = vnum_reward_arms
    elseif object.id == vnum_destroyed_chest then
        is_armor = 1
        vnum_armor = vnum_destroyed_chest
    elseif object.id == vnum_gem_chest then
        exp_multiplier = 29
        vnum_armor = vnum_destroyed_chest
        vnum_gem = vnum_gem_chest
        vnum_reward = vnum_reward_chest
    elseif object.id == vnum_destroyed_legs then
        is_armor = 1
        vnum_armor = vnum_destroyed_legs
    elseif object.id == vnum_gem_legs then
        exp_multiplier = 24
        vnum_armor = vnum_destroyed_legs
        vnum_gem = vnum_gem_legs
        vnum_reward = vnum_reward_legs
    elseif object.id == vnum_destroyed_boots then
        is_armor = 1
        vnum_armor = vnum_destroyed_boots
    elseif object.id == vnum_gem_boots then
        exp_multiplier = 4
        vnum_armor = vnum_destroyed_boots
        vnum_gem = vnum_gem_boots
        vnum_reward = vnum_reward_boots
    elseif object.id == vnum_destroyed_bracer then
        is_armor = 1
        vnum_armor = vnum_destroyed_bracer
    elseif object.id == vnum_gem_bracer then
        exp_multiplier = 7
        vnum_armor = vnum_destroyed_bracer
        vnum_gem = vnum_gem_bracer
        vnum_reward = vnum_reward_bracer
    elseif object.id == vnum_destroyed_gloves then
        is_armor = 1
        vnum_armor = vnum_destroyed_gloves
    elseif object.id == vnum_gem_gloves then
        exp_multiplier = 2
        vnum_armor = vnum_destroyed_gloves
        vnum_gem = vnum_gem_gloves
        vnum_reward = vnum_reward_gloves
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
        -- Quest variable key for gems
        local gem_key = tostring(vnum_gem) .. "_gems_acquired"
        if not actor:get_quest_var("phase_armor", gem_key) then
            actor:set_quest_var("phase_armor", gem_key, 0)
        end
        local gems = actor:get_quest_var("phase_armor", gem_key) or 0
        if gems < 3 then
            gems = gems + 1
            actor:set_quest_var("phase_armor", gem_key, gems)
            wait(2)
            actor:send(tostring(self.name) .. " tells you, \"Hey, very nice. It is good to see adventurers out conquering the\"")
            actor:send(tostring(self.name) .. " tells you, \"realm.  You have now given me " .. tostring(gems) .. " gems.\"")
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
        local armor_key = tostring(vnum_armor) .. "_armor_acquired"
        if gems == 3 and actor:get_quest_var("phase_armor", armor_key) == 1 then
            wait(2)
            actor:send(tostring(self.name) .. " tells you, \"Excellent intrepid adventurer, you have provided me with all\"")
            actor:send(tostring(self.name) .. " tells you, \"I need in order to reward you!\"")
            wait(1)
            self.room:spawn_object(vnum_to_zone(vnum_reward), vnum_to_local(vnum_reward))
            wait(1)
            --
            -- loop for exp award.
            --
            actor:send("<b:yellow>You gain experience!</>")
            local lap = 1
            while lap <= exp_multiplier do
                actor:award_exp(2640)
                lap = lap + 1
            end
            --
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
        local armor_key = tostring(vnum_armor) .. "_armor_acquired"
        if not actor:get_quest_var("phase_armor", armor_key) then
            actor:set_quest_var("phase_armor", armor_key, 0)
        end
        local armor = actor:get_quest_var("phase_armor", armor_key) or 0
        if armor < 1 then
            armor = armor + 1
            actor:set_quest_var("phase_armor", armor_key, armor)
            wait(2)
            actor:send(tostring(self.name) .. " tells you, \"Hey now. what have we here?!  I've been looking for some of this\"")
            actor:send(tostring(self.name) .. " tells you, \"for quite some time.  You have now given me the armor piece.\"")
            world.destroy(object.name)
            actor:save()
        else
            _return_value = false
            wait(2)
            self:command("eye " .. tostring(actor.name))
            wait(1)
            actor:send(tostring(self.name) .. " tells you, \"Hey now, you have given me this armor already!\"")
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
        local gem_key = tostring(vnum_gem) .. "_gems_acquired"
        if armor == 1 and actor:get_quest_var("phase_armor", gem_key) == 3 then
            wait(2)
            actor:send(tostring(self.name) .. " tells you, \"Excellent intrepid adventurer, you have provided me with all\"")
            actor:send(tostring(self.name) .. " tells you, \"I need in order to reward you!\"")
            wait(1)
            self.room:spawn_object(vnum_to_zone(vnum_reward), vnum_to_local(vnum_reward))
            wait(1)
            --
            -- loop for exp award.
            --
            actor:send("<b:yellow>You gain experience!</>")
            local lap = 1
            while lap <= exp_multiplier do
                actor:award_exp(2640)
                lap = lap + 1
            end
            --
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
