-- Trigger: 3bl_turn_in
-- Zone: 55, ID: 3
-- Type: MOB, Flags: RECEIVE
-- Status: NEEDS_REVIEW
--   Complex nesting: 16 if statements
--   Large script: 17576 chars
--
-- Original DG Script: #5503

-- Converted from DG Script #5503: 3bl_turn_in
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
-- 
-- This is the main receive trigger for the Edorian
-- combat quests installed on the mud. This trigger
-- will be generic and the vnums and variables set
-- to reflect which faction it applies to.
-- 
-- 3bl is Third Black Legion - The player MUST be
-- on the quest already in order to turn in because
-- the variables are not set yet!
if actor:get_quest_var("Black_Legion:eg_ally") then
    actor:send(tostring(self.name) .. " tells you, 'You have already chosen your side!")
    actor:send("</>Be gone, filth!'")
    return _return_value
end
if actor.alignment <= 150 and actor:get_quest_stage("Black_Legion") > 0 then
    actor.name:set_quest_var("Black_Legion", "bl_ally", 1)
    -- 
    -- pertinent object definitions for this faction
    -- trophies
    local vnum_3el_skull = 5504
    local vnum_3el_ring = 5506
    local vnum_3el_badge = 5508
    local vnum_3el_token = 5510
    local vnum_3el_insignia = 5512
    local vnum_3el_wand = 5514
    local vnum_3el_symbol = 5516
    -- gems for this faction
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
    -- rewards (zone, local_id pairs for spawn_object)
    local reward_3bl_cap_zone, reward_3bl_cap_local = 55, 17
    local reward_3bl_neck_zone, reward_3bl_neck_local = 55, 19
    local reward_3bl_arm_zone, reward_3bl_arm_local = 55, 21
    local reward_3bl_wrist_zone, reward_3bl_wrist_local = 55, 23
    local reward_3bl_gloves_zone, reward_3bl_gloves_local = 55, 25
    local reward_3bl_jerkin_zone, reward_3bl_jerkin_local = 55, 27
    local reward_3bl_belt_zone, reward_3bl_belt_local = 55, 29
    local reward_3bl_legs_zone, reward_3bl_legs_local = 55, 31
    local reward_3bl_boots_zone, reward_3bl_boots_local = 55, 33
    local reward_3bl_mask_zone, reward_3bl_mask_local = 55, 35
    local reward_3bl_robe_zone, reward_3bl_robe_local = 55, 37
    local reward_3bl_symbol_zone, reward_3bl_symbol_local = 55, 15
    local reward_3bl_staff_zone, reward_3bl_staff_local = 55, 39
    local reward_3bl_ssword_zone, reward_3bl_ssword_local = 55, 40
    local reward_3bl_whammer_zone, reward_3bl_whammer_local = 55, 41
    local reward_3bl_flail_zone, reward_3bl_flail_local = 55, 42
    local reward_3bl_shiv_zone, reward_3bl_shiv_local = 55, 43
    local reward_3bl_lsword_zone, reward_3bl_lsword_local = 55, 44
    local reward_3bl_smace_zone, reward_3bl_smace_local = 55, 45
    local reward_3bl_light_zone, reward_3bl_light_local = 55, 53
    local reward_3bl_food_zone, reward_3bl_food_local = 55, 55
    local reward_3bl_drink_zone, reward_3bl_drink_local = 55, 57
    -- 
    -- attempt to reinitialize slutty dg variables to '' (nothing)
    -- so this switch will work.
    -- 
    is_gem = nil
    exp_multiplier = nil
    vnum_trophy = nil
    faction_multiplier = nil
    vnum_reward = nil
    faction_required = nil
    -- 
    -- These case set the variables for the quests.
    -- Note the object.vnum is the vnum of the object handed to
    -- the NPC by the player.
    -- 
    -- switch on object.id
    if object.id == vnum_gem_3bl_cap then
        local is_gem = 1
        local exp_multiplier = 10
        local vnum_reward = 5517
        local reward_zone, reward_local = reward_3bl_cap_zone, reward_3bl_cap_local
        local faction_required = 20
        local faction_multiplier = 1
    elseif object.id == vnum_gem_3bl_food then
        local is_gem = 1
        local exp_multiplier = 10
        local vnum_reward = 5555
        local reward_zone, reward_local = reward_3bl_food_zone, reward_3bl_food_local
        local faction_required = 20
        local faction_multiplier = 1
    elseif object.id == vnum_gem_3bl_drink then
        local is_gem = 1
        local exp_multiplier = 10
        local vnum_reward = 5557
        local reward_zone, reward_local = reward_3bl_drink_zone, reward_3bl_drink_local
        local faction_required = 20
        local faction_multiplier = 1
    elseif object.id == vnum_gem_3bl_ssword then
        local is_gem = 1
        local exp_multiplier = 10
        local vnum_reward = 5540
        local reward_zone, reward_local = reward_3bl_ssword_zone, reward_3bl_ssword_local
        local faction_required = 20
        local faction_multiplier = 1
    elseif object.id == vnum_gem_3bl_neck then
        local is_gem = 1
        local exp_multiplier = 12
        local vnum_reward = 5519
        local reward_zone, reward_local = reward_3bl_neck_zone, reward_3bl_neck_local
        local faction_required = 40
        local faction_multiplier = 1
    elseif object.id == vnum_gem_3bl_staff then
        local is_gem = 1
        local exp_multiplier = 12
        local vnum_reward = 5539
        local reward_zone, reward_local = reward_3bl_staff_zone, reward_3bl_staff_local
        local faction_required = 40
        local faction_multiplier = 1
    elseif object.id == vnum_gem_3bl_arm then
        local is_gem = 1
        local exp_multiplier = 14
        local vnum_reward = 5521
        local reward_zone, reward_local = reward_3bl_arm_zone, reward_3bl_arm_local
        local faction_required = 55
        local faction_multiplier = 1
    elseif object.id == vnum_gem_3bl_whammer then
        local is_gem = 1
        local exp_multiplier = 14
        local vnum_reward = 5541
        local reward_zone, reward_local = reward_3bl_whammer_zone, reward_3bl_whammer_local
        local faction_required = 55
        local faction_multiplier = 1
    elseif object.id == vnum_gem_3bl_wrist then
        local is_gem = 1
        local exp_multiplier = 16
        local vnum_reward = 5523
        local reward_zone, reward_local = reward_3bl_wrist_zone, reward_3bl_wrist_local
        local faction_required = 70
        local faction_multiplier = 1
    elseif object.id == vnum_gem_3bl_flail then
        local is_gem = 1
        local exp_multiplier = 16
        local vnum_reward = 5542
        local reward_zone, reward_local = reward_3bl_flail_zone, reward_3bl_flail_local
        local faction_required = 70
        local faction_multiplier = 1
    elseif object.id == vnum_gem_3bl_gloves then
        local is_gem = 1
        local exp_multiplier = 18
        local vnum_reward = 5525
        local reward_zone, reward_local = reward_3bl_gloves_zone, reward_3bl_gloves_local
        local faction_required = 85
        local faction_multiplier = 1
    elseif object.id == vnum_gem_3bl_symbol then
        local is_gem = 1
        local exp_multiplier = 18
        local vnum_reward = 5515
        local reward_zone, reward_local = reward_3bl_symbol_zone, reward_3bl_symbol_local
        local faction_required = 85
        local faction_multiplier = 1
    elseif object.id == vnum_gem_3bl_belt then
        local is_gem = 1
        local exp_multiplier = 20
        local vnum_reward = 5529
        local reward_zone, reward_local = reward_3bl_belt_zone, reward_3bl_belt_local
        local faction_required = 100
        local faction_multiplier = 1
    elseif object.id == vnum_gem_3bl_shiv then
        local is_gem = 1
        local exp_multiplier = 20
        local vnum_reward = 5543
        local reward_zone, reward_local = reward_3bl_shiv_zone, reward_3bl_shiv_local
        local faction_required = 100
        local faction_multiplier = 1
    elseif object.id == vnum_gem_3bl_boots then
        local is_gem = 1
        local exp_multiplier = 22
        local vnum_reward = 5533
        local reward_zone, reward_local = reward_3bl_boots_zone, reward_3bl_boots_local
        local faction_required = 115
        local faction_multiplier = 2
    elseif object.id == vnum_gem_3bl_lsword then
        local is_gem = 1
        local exp_multiplier = 22
        local vnum_reward = 5544
        local reward_zone, reward_local = reward_3bl_lsword_zone, reward_3bl_lsword_local
        local faction_required = 115
        local faction_multiplier = 2
    elseif object.id == vnum_gem_3bl_legs then
        local is_gem = 1
        local exp_multiplier = 24
        local vnum_reward = 5531
        local reward_zone, reward_local = reward_3bl_legs_zone, reward_3bl_legs_local
        local faction_required = 130
        local faction_multiplier = 2
    elseif object.id == vnum_gem_3bl_robe then
        local is_gem = 1
        local exp_multiplier = 26
        local vnum_reward = 5537
        local reward_zone, reward_local = reward_3bl_robe_zone, reward_3bl_robe_local
        local faction_required = 145
        local faction_multiplier = 2
    elseif object.id == vnum_gem_3bl_jerkin then
        local is_gem = 1
        local exp_multiplier = 26
        local vnum_reward = 5527
        local reward_zone, reward_local = reward_3bl_jerkin_zone, reward_3bl_jerkin_local
        local faction_required = 145
        local faction_multiplier = 2
    elseif object.id == vnum_gem_3bl_light then
        local is_gem = 1
        local exp_multiplier = 26
        local vnum_reward = 5553
        local reward_zone, reward_local = reward_3bl_light_zone, reward_3bl_light_local
        local faction_required = 85
        local faction_multiplier = 2
    elseif object.id == vnum_gem_3bl_mask then
        local is_gem = 1
        local exp_multiplier = 28
        local vnum_reward = 5535
        local reward_zone, reward_local = reward_3bl_mask_zone, reward_3bl_mask_local
        local faction_required = 160
        local faction_multiplier = 3
    elseif object.id == vnum_gem_3bl_smace then
        local is_gem = 1
        local exp_multiplier = 28
        local vnum_reward = 5545
        local reward_zone, reward_local = reward_3bl_smace_zone, reward_3bl_smace_local
        local faction_required = 160
        local faction_multiplier = 3
    elseif object.id == vnum_3el_skull then
        local exp_multiplier = 2
        local vnum_trophy = vnum_3el_skull
        local trophy_zone, trophy_local = 55, 4
        local faction_multiplier = 1
    elseif object.id == vnum_3el_ring then
        local exp_multiplier = 2
        local vnum_trophy = vnum_3el_ring
        local trophy_zone, trophy_local = 55, 6
        local faction_multiplier = 1
    elseif object.id == vnum_3el_badge then
        local exp_multiplier = 2
        local vnum_trophy = vnum_3el_badge
        local trophy_zone, trophy_local = 55, 8
        local faction_multiplier = 1
    elseif object.id == vnum_3el_token then
        local exp_multiplier = 2
        local vnum_trophy = vnum_3el_token
        local trophy_zone, trophy_local = 55, 10
        local faction_multiplier = 2
    elseif object.id == vnum_3el_insignia then
        local exp_multiplier = 2
        local vnum_trophy = vnum_3el_insignia
        local trophy_zone, trophy_local = 55, 12
        local faction_multiplier = 2
    elseif object.id == vnum_3el_wand then
        local exp_multiplier = 2
        local vnum_trophy = vnum_3el_wand
        local trophy_zone, trophy_local = 55, 14
        local faction_multiplier = 2
    elseif object.id == vnum_3el_symbol then
        local exp_multiplier = 2
        local vnum_trophy = vnum_3el_symbol
        local trophy_zone, trophy_local = 55, 16
        local faction_multiplier = 3
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
    if not is_gem then
        local faction_advance = 0
        local exp_advance = 0
        -- hrmm Jelos' magical variable declaration
        if actor.quest_variable["black_legion:" .. vnum_trophy .. "_trophies"] then
        else
            actor.name:set_quest_var("black_legion", vnum_trophy .. "_trophies", 0)
        end
        local trophies = actor.quest_variable["black_legion:" .. vnum_trophy .. "_trophies"]
        actor.name:set_quest_var("black_legion", vnum_trophy .. "_trophies", trophies)
        -- The highest faction a player can gain from interacting with the 3rd front creatures will
        -- be 200.  For this section the trophy turn in will reply on this and other checks.
        if actor:get_quest_var("black_legion:bl_faction") < 200 then
            local trophies = actor.quest_variable["black_legion:" .. vnum_trophy .. "_trophies"] + 1
            actor.name:set_quest_var("black_legion", vnum_trophy .. "_trophies", trophies)
            wait(2)
            actor:send(tostring(self.name) .. " tells you, 'Hrm, yes.. you have been out")
            actor:send("</>fighting the Eldorian Guard.  I see from my records you have now given me")
            actor:send("</><b:yellow>" .. tostring(trophies) .. "</> <b:white>" .. objects.template(trophy_zone, trophy_local).shortdesc .. "</>.'")
            world.destroy(object.name)
            actor:save()
            if trophies < 10 then
                local faction_advance = 1
                local exp_advance = 1
            else
                local faction_advance = 1
            end
        else
            if trophies < 10 then
                local exp_advance = 1
                local trophies = actor.quest_variable["black_legion:" .. vnum_trophy .. "_trophies"] + 1
                actor.name:set_quest_var("black_legion", vnum_trophy .. "_trophies", trophies)
            else
                _return_value = false
            end
            wait(2)
            self:command("eye " .. tostring(actor.name))
            actor:send(tostring(self.name) .. " tells you, 'You have garnered as much favor with")
            actor:send("</>the Black Legion as you possibly can by fighting the Third Eldrian Guard.  You")
            actor:send("</>may one day find other more difficult battles with those tree rats that will")
            actor:send("</>curry more favor with our lords.'")
        end
        -- 
        -- Double check that the criteria for rewards for this section are met.
        -- 
        if exp_advance > 0 then
            -- 
            -- loop for exp award.
            -- 
            -- (empty send to actor)
            actor:send("<b:yellow>You gain experience!</>")
            local lap = 1
            while lap <= exp_multiplier do
                actor:award_exp(2640)
                local lap = lap + 1
            end
            -- 
            -- end exp loop
            -- 
            -- all other items should be mpjunked or whatever by now
        end
        if faction_advance > 0 then
            -- 
            -- loop for faction award.
            -- 
            actor:send("<b:yellow>Your curry favor with the Black Legion!</>")
            actor:send("<b:red>You feel more hated by the Eldorian Guard!</>")
            local lap = 1
            while lap <= faction_multiplier do
                local faction = actor:get_quest_var("black_legion:bl_faction") + 1
                actor.name:set_quest_var("black_legion", "bl_faction", faction)
                -- 
                -- slight bug for now the trigger code can't seem to evaluate negative numbers?
                -- 
                local faction2 = actor:get_quest_var("black_legion:eg_faction") - 1
                actor.name:set_quest_var("black_legion", "eg_faction", faction2)
                local lap = lap + 1
            end
            -- 
            -- end faction loop
            -- 
            -- all other items should be mpjunked or whatever by now
        end
        -- end of !if_gem section or trophy endif
        actor.name:save()
    end
    if is_gem then
        -- hrmm Jelos' magical variable declaration
        if actor.quest_variable["black_legion:" .. vnum_reward .. "_reward"] then
        else
            actor.name:set_quest_var("black_legion", vnum_reward .. "_reward", 0)
        end
        local rewards = actor.quest_variable["black_legion:" .. vnum_reward .. "_reward"]
        actor.name:set_quest_var("black_legion", vnum_reward .. "_reward", rewards)
        if actor.alignment >= 151 then
            _return_value = false
            wait(2)
            actor:send(tostring(self.name) .. " tells you, 'You aren't quite evil enough for")
            actor:send("</>these rewards.'")
            return _return_value
        end
        if actor:get_quest_var("black_legion:bl_faction") >= faction_required then
            local rewards = actor.quest_variable["black_legion:" .. vnum_reward .. "_reward"] + 1
            actor.name:set_quest_var("black_legion", vnum_reward .. "_reward", rewards)
            wait(2)
            actor:send(tostring(self.name) .. " tells you, 'Ah yes, the Legion thanks you for")
            actor:send("</>your efforts.  Take this to aid you in your battles.'")
            wait(1)
            self.room:spawn_object(reward_zone, reward_local)
            wait(1)
            if actor.quest_variable["black_legion:" .. vnum_reward .. "_reward"] == 1 then
                -- 
                -- loop for exp award.
                -- 
                -- (empty send to actor)
                actor:send("<b:yellow>You gain experience!</>")
                local lap = 1
                while lap <= exp_multiplier do
                    actor:award_exp(2640)
                    local lap = lap + 1
                end
                -- 
                -- end exp loop
                -- 
                -- all other items should be mpjunked or whatever by now
            end
            if actor:get_quest_var("black_legion:bl_faction") < 200 then
                -- 
                -- loop for faction award.
                -- 
                actor:send("<b:yellow>Your curry favor with the Black Legion!</>")
                actor:send("<b:red>You feel more hated by the Eldorian Guard!</>")
                local lap = 1
                while lap <= faction_multiplier do
                    local faction = actor:get_quest_var("black_legion:bl_faction") + 1
                    actor.name:set_quest_var("black_legion", "bl_faction", faction)
                    -- 
                    -- slight bug for now the trigger code can't seem to evaluate negative numbers?
                    -- 
                    local faction2 = actor:get_quest_var("black_legion:eg_faction") - 1
                    actor.name:set_quest_var("black_legion", "eg_faction", faction2)
                    local lap = lap + 1
                end
                -- 
                -- end faction loop
                -- 
                -- all other items should be mpjunked or whatever by now
            end
            world.destroy(object.name)
            self:destroy_item("all.eldoria-trophy")
            self:command("give all " .. tostring(actor.name))
            actor.name:save()
        else
            _return_value = false
            wait(2)
            actor:send(tostring(self.name) .. " tells you, 'You aren't quite allied enough")
            actor:send("</>with our cause to earn that reward.'")
            return _return_value
        end
        -- end of if_gem section
    end
else
    -- Alignment not low enough or hasn't started the quest yet.
    _return_value = false
    wait(2)
    actor:send(tostring(self.name) .. " tells you, 'You aren't quite allied enough with")
    actor:send("</>our cause to earn our rewards.  You need a lower alignment or to start these")
    actor:send("</>quests by saying <b:white>[yes]</> or <b:white>[quest]</> or <b:white>[hello]</>.'")
end
return _return_value