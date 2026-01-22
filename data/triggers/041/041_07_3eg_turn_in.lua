-- Trigger: 3eg_turn_in
-- Zone: 41, ID: 7
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--   Note: Complex quest turn-in script for Eldorian Guard faction
--
-- Original DG Script: #4107

-- Converted from DG Script #4107: 3eg_turn_in
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
-- 
-- This is the main receive trigger for the Edorian
-- combat quests installed on the mud. This trigger
-- will be generic and the vnums and variables set
-- to reflect which faction it applies to.
-- 
if actor:get_quest_var("Black_Legion:bl_ally") then
    actor:send(tostring(self.name) .. " tells you, 'You have pledged yourself to the forces of")
    actor:send("</>darkness!  Suffer under your choice!'")
    return _return_value
end
-- 3eg is Third Eldorian Guard
if actor.alignment >= -150 and actor:get_quest_stage("Black_Legion") > 0 then
    actor.name:set_quest_var("Black_Legion", "eg_ally", 1)
    -- 
    -- pertinent object definitions for this faction
    -- trophies
    local vnum_3bl_skull = 5503
    local vnum_3bl_ring = 5505
    local vnum_3bl_badge = 5507
    local vnum_3bl_token = 5509
    local vnum_3bl_insignia = 5511
    local vnum_3bl_wand = 5513
    local vnum_3bl_symbol = 5515
    -- gems for this faction
    local vnum_gem_3eg_cap = 55570
    local vnum_gem_3eg_neck = 55571
    local vnum_gem_3eg_arm = 55572
    local vnum_gem_3eg_wrist = 55573
    local vnum_gem_3eg_gloves = 55574
    local vnum_gem_3eg_jerkin = 55575
    local vnum_gem_3eg_robe = 55589
    local vnum_gem_3eg_belt = 55576
    local vnum_gem_3eg_legs = 55577
    local vnum_gem_3eg_boots = 55578
    local vnum_gem_3eg_mask = 55579
    local vnum_gem_3eg_symbol = 55580
    local vnum_gem_3eg_staff = 55581
    local vnum_gem_3eg_ssword = 55582
    local vnum_gem_3eg_whammer = 55583
    local vnum_gem_3eg_flail = 55584
    local vnum_gem_3eg_shiv = 55585
    local vnum_gem_3eg_lsword = 55586
    local vnum_gem_3eg_smace = 55587
    local vnum_gem_3eg_light = 55588
    local vnum_gem_3eg_food = 55566
    local vnum_gem_3eg_drink = 55567
    -- rewards
    local vnum_3eg_cap = 5518
    local vnum_3eg_neck = 5520
    local vnum_3eg_arm = 5522
    local vnum_3eg_wrist = 5524
    local vnum_3eg_gloves = 5526
    local vnum_3eg_jerkin = 5528
    local vnum_3eg_belt = 5530
    local vnum_3eg_legs = 5532
    local vnum_3eg_boots = 5534
    local vnum_3eg_mask = 5536
    local vnum_3eg_robe = 5538
    local vnum_3eg_symbol = 5516
    local vnum_3eg_staff = 5546
    local vnum_3eg_ssword = 5547
    local vnum_3eg_whammer = 5548
    local vnum_3eg_flail = 5549
    local vnum_3eg_shiv = 5550
    local vnum_3eg_lsword = 5551
    local vnum_3eg_smace = 5552
    local vnum_3eg_light = 5554
    local vnum_3eg_food = 5556
    local vnum_3eg_drink = 5558
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
    -- These cases set the variables for the quests.
    -- Note the object.vnum is the vnum of the object handed to
    -- the NPC by the player.
    -- 
    -- switch on object.id
    if object.id == vnum_gem_3eg_cap then
        local is_gem = 1
        local exp_multiplier = 10
        local vnum_reward = vnum_3eg_cap
        local faction_required = 20
        local faction_multiplier = 1
    elseif object.id == vnum_gem_3eg_food then
        local is_gem = 1
        local exp_multiplier = 10
        local vnum_reward = vnum_3eg_food
        local faction_required = 20
        local faction_multiplier = 1
    elseif object.id == vnum_gem_3eg_drink then
        local is_gem = 1
        local exp_multiplier = 10
        local vnum_reward = vnum_3eg_drink
        local faction_required = 20
        local faction_multiplier = 1
    elseif object.id == vnum_gem_3eg_ssword then
        local is_gem = 1
        local exp_multiplier = 10
        local vnum_reward = vnum_3eg_ssword
        local faction_required = 20
        local faction_multiplier = 1
    elseif object.id == vnum_gem_3eg_neck then
        local is_gem = 1
        local exp_multiplier = 12
        local vnum_reward = vnum_3eg_neck
        local faction_required = 40
        local faction_multiplier = 1
    elseif object.id == vnum_gem_3eg_staff then
        local is_gem = 1
        local exp_multiplier = 12
        local vnum_reward = vnum_3eg_staff
        local faction_required = 40
        local faction_multiplier = 1
    elseif object.id == vnum_gem_3eg_arm then
        local is_gem = 1
        local exp_multiplier = 14
        local vnum_reward = vnum_3eg_arm
        local faction_required = 55
        local faction_multiplier = 1
    elseif object.id == vnum_gem_3eg_whammer then
        local is_gem = 1
        local exp_multiplier = 14
        local vnum_reward = vnum_3eg_whammer
        local faction_required = 55
        local faction_multiplier = 1
    elseif object.id == vnum_gem_3eg_wrist then
        local is_gem = 1
        local exp_multiplier = 16
        local vnum_reward = vnum_3eg_wrist
        local faction_required = 70
        local faction_multiplier = 1
    elseif object.id == vnum_gem_3eg_flail then
        local is_gem = 1
        local exp_multiplier = 16
        local vnum_reward = vnum_3eg_flail
        local faction_required = 70
        local faction_multiplier = 1
    elseif object.id == vnum_3bl_skull then
        local exp_multiplier = 2
        local vnum_trophy = vnum_3bl_skull
        local faction_multiplier = 1
    elseif object.id == vnum_3bl_ring then
        local exp_multiplier = 2
        local vnum_trophy = vnum_3bl_ring
        local faction_multiplier = 1
    elseif object.id == vnum_3bl_badge then
        local exp_multiplier = 2
        local vnum_trophy = vnum_3bl_badge
        local faction_multiplier = 1
    elseif object.id == vnum_3bl_token then
        local exp_multiplier = 2
        local vnum_trophy = vnum_3bl_token
        local faction_multiplier = 2
    elseif object.id == vnum_3bl_insignia then
        local exp_multiplier = 2
        local vnum_trophy = vnum_3bl_insignia
        local faction_multiplier = 2
    elseif object.id == vnum_3bl_wand then
        local exp_multiplier = 2
        local vnum_trophy = vnum_3bl_wand
        local faction_multiplier = 2
    elseif object.id == vnum_3bl_symbol then
        local exp_multiplier = 2
        local vnum_trophy = vnum_3bl_symbol
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
        if actor:get_quest_var("black_legion:" .. tostring(vnum_trophy) .. "_trophies") then
        else
            actor.name:set_quest_var("black_legion", tostring(vnum_trophy) .. "_trophies", 0)
        end
        local trophies = actor:get_quest_var("black_legion:" .. tostring(vnum_trophy) .. "_trophies")
        actor.name:set_quest_var("black_legion", tostring(vnum_trophy) .. "_trophies", trophies)
        -- The highest faction a player can gain from interacting with the 3rd front creatures will
        -- be 200.  For this section the trophy turn in will reply on this and other checks.
        if actor:get_quest_var("black_legion:eg_faction") < 100 then
            local trophies = actor:get_quest_var("black_legion:" .. tostring(vnum_trophy) .. "_trophies") + 1
            actor.name:set_quest_var("black_legion", tostring(vnum_trophy) .. "_trophies", trophies)
            wait(2)
            actor:send(tostring(self.name) .. " tells you, 'Hrm, yes... you have been out fighting the")
            actor:send("</>influence of the Black Legion.  I see from my records you have now turned in")
            actor:send("</><b:yellow>" .. tostring(trophies) .. "</> <b:white>" .. "(trophy item)</>.'")
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
                local trophies = actor:get_quest_var("black_legion:" .. tostring(vnum_trophy) .. "_trophies") + 1
                actor.name:set_quest_var("black_legion", tostring(vnum_trophy) .. "_trophies", trophies)
            else
                _return_value = false
            end
            wait(2)
            self:command("eye " .. tostring(actor.name))
            actor:send(tostring(self.name) .. " tells you, 'You have garnered as much favor with the")
            actor:send("</>Eldorian Guard as you possibly can by raiding Split Skull.'")
            -- (empty send to actor)
            actor:send(tostring(self.name) .. " tells you, 'You will find other more difficult battles")
            actor:send("</>with the Legion that will curry more favor with our masters in Eldoria.'")
            -- (empty send to actor)
            actor:send(tostring(self.name) .. " tells you, 'Go to Tarelithis and seek the Recruiter of")
            actor:send("</>the Third Eldorian Guard!'")
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
            actor:send("<b:yellow>Your curry favor with the Eldorian Guard!</>")
            actor:send("<b:red>You feel more hated by the Black Legion!</>")
            local lap = 1
            while lap <= faction_multiplier do
                local faction = actor:get_quest_var("black_legion:eg_faction") + 1
                actor.name:set_quest_var("black_legion", "eg_faction", faction)
                -- 
                -- slight bug for now the trigger code can't seem to evaluate negative numbers?
                -- 
                local faction2 = actor:get_quest_var("black_legion:bl_faction") - 1
                actor.name:set_quest_var("black_legion", "bl_faction", faction2)
                local lap = lap + 1
            end
            -- 
            -- end faction loop
            -- 
            -- all other items should be mpjunked or whatever by now
        end
        actor.name:save()
        -- end of !if_gem section or trophy endif
    end
    if is_gem then
        -- hrmm Jelos' magical variable declaration
        if actor:get_quest_var("black_legion:" .. tostring(vnum_reward) .. "_reward") then
        else
            actor.name:set_quest_var("black_legion", tostring(vnum_reward) .. "_reward", 0)
        end
        local rewards = actor:get_quest_var("black_legion:" .. tostring(vnum_reward) .. "_reward")
        actor.name:set_quest_var("black_legion", tostring(vnum_reward) .. "_reward", rewards)
        if actor.alignment <= -151 then
            _return_value = false
            wait(2)
            actor:send(tostring(self.name) .. " tells you, 'You aren't quite good enough for these")
            actor:send("</>rewards.'")
            return _return_value
        end
        if actor:get_quest_var("black_legion:eg_faction") >= faction_required then
            local rewards = actor:get_quest_var("black_legion:" .. tostring(vnum_reward) .. "_reward") + 1
            actor.name:set_quest_var("black_legion", tostring(vnum_reward) .. "_reward", rewards)
            wait(2)
            actor:send(tostring(self.name) .. " tells you, 'Ah yes, the Guard thanks you for your")
            actor:send("</>efforts.  Take this to aid you in your battles.'")
            wait(1)
            self.room:spawn_object(vnum_to_zone(vnum_reward), vnum_to_local(vnum_reward))
            wait(1)
            if actor:get_quest_var("black_legion:" .. tostring(vnum_reward) .. "_reward") == 1 then
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
            if actor:get_quest_var("black_legion:eg_faction") < 200 then
                -- 
                -- loop for faction award.
                -- 
                actor:send("<b:yellow>Your curry favor with the Eldorian Guard!</>")
                actor:send("<b:red>You feel more hated by the Black Legion!</>")
                local lap = 1
                while lap <= faction_multiplier do
                    local faction = actor:get_quest_var("black_legion:eg_faction") + 1
                    actor.name:set_quest_var("black_legion", "eg_faction", faction)
                    -- 
                    -- 
                    -- slight bug for now the trigger code can't seem to evaluate negative numbers?
                    -- 
                    -- 
                    local faction2 = actor:get_quest_var("black_legion:bl_faction") - 1
                    actor.name:set_quest_var("black_legion", "bl_faction", faction2)
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
            actor:send(tostring(self.name) .. " tells you, 'You aren't quite allied enough with our cause")
            actor:send("</>to earn that reward.'")
            return _return_value
        end
        -- end of if_gem section
    end
else
    -- Alignment not high enough or hasn't started the quest yet.
    _return_value = false
    wait(2)
    actor:send(tostring(self.name) .. " tells you, 'You aren't quite allied enough with our cause")
    actor:send("</>to earn our rewards.  You need a higher alignment or to start these quests by")
    actor:send("</>saying <b:white>[yes]</> or <b:white>[quest]</> or <b:white>[hello]</>.'")
end
return _return_value