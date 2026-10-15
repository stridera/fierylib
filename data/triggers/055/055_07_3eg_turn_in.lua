-- Trigger: 3eg_turn_in
-- Zone: 55, ID: 7
-- Type: MOB, Flags: RECEIVE
-- Status: TODO(parity)
--
-- TODO(parity): Mirror of 3bl_turn_in (055_03) for the Eldorian Guard
-- side. Same systemic converter problems apply -- see 055_03 header for
-- the full list. Briefly:
--   1. `object.id == "%id_xxx%"` placeholder strings never match.
--   2. Branch-scoped `local` writes never escape to the trophy/reward
--      logic.
--   3. Gem 5-digit vnums (55566..55589) need (zone, local_id) tuples.
--   4. Quest var keys still contain `%id_trophy%`/`%id_reward%`.
--   5. `%get.obj_shortdesc[...]%` interpolation is unresolved.
-- Light mechanical fixes applied (save call, world.destroy arg) but the
-- quest gameplay still requires a full rebuild before it is functional.
--
-- Original DG Script: #5507

-- Converted from DG Script #5507: 3eg_turn_in
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
-- 
-- This is the main receive trigger for the Edorian
-- combat quests installed on the mud. This trigger
-- will be generic and the IDs and variables set
-- to reflect which faction it applies to.
-- 
-- 3eg is Third Eldorian Guard
if actor:get_quest_var("Black_Legion:bl_ally") then
    actor:send(tostring(self.name) .. " tells you, 'You have pledged")
    actor:send("</>yourself to the forces of darkness!  Suffer under your choice!'")
    return _return_value
end
if actor.alignment >= -150 and actor:get_quest_stage("Black_Legion") > 0 then
    actor:set_quest_var("Black_Legion", "eg_ally", 1)
    -- 
    -- pertinent object definitions for this faction
    -- trophies
    local id_3bl_skull = 5503
    local id_3bl_ring = 5505
    local id_3bl_badge = 5507
    local id_3bl_token = 5509
    local id_3bl_insignia = 5511
    local id_3bl_wand = 5513
    local id_3bl_symbol = 5515
    -- gems for this faction
    local id_gem_3eg_cap = 55570
    local id_gem_3eg_neck = 55571
    local id_gem_3eg_arm = 55572
    local id_gem_3eg_wrist = 55573
    local id_gem_3eg_gloves = 55574
    local id_gem_3eg_jerkin = 55575
    local id_gem_3eg_robe = 55589
    local id_gem_3eg_belt = 55576
    local id_gem_3eg_legs = 55577
    local id_gem_3eg_boots = 55578
    local id_gem_3eg_mask = 55579
    local id_gem_3eg_symbol = 55580
    local id_gem_3eg_staff = 55581
    local id_gem_3eg_ssword = 55582
    local id_gem_3eg_whammer = 55583
    local id_gem_3eg_flail = 55584
    local id_gem_3eg_shiv = 55585
    local id_gem_3eg_lsword = 55586
    local id_gem_3eg_smace = 55587
    local id_gem_3eg_light = 55588
    local id_gem_3eg_food = 55566
    local id_gem_3eg_drink = 55567
    -- rewards
    local id_3eg_cap = 18
    local id_3eg_neck = 20
    local id_3eg_arm = 22
    local id_3eg_wrist = 24
    local id_3eg_gloves = 26
    local id_3eg_jerkin = 28
    local id_3eg_belt = 30
    local id_3eg_legs = 32
    local id_3eg_boots = 34
    local id_3eg_mask = 36
    local id_3eg_robe = 38
    local id_3eg_symbol = 16
    local id_3eg_staff = 46
    local id_3eg_ssword = 47
    local id_3eg_whammer = 48
    local id_3eg_flail = 49
    local id_3eg_shiv = 50
    local id_3eg_lsword = 51
    local id_3eg_smace = 52
    local id_3eg_light = 54
    local id_3eg_food = 56
    local id_3eg_drink = 58
    -- 
    -- attempt to reinitialize slutty dg variables to '' (nothing)
    -- so this switch will work.
    -- 
    is_gem = nil
    exp_multiplier = nil
    id_trophy = nil
    faction_multiplier = nil
    id_reward = nil
    faction_required = nil
    -- 
    -- These cases set the variables for the quests.
    -- The cases below switch on object.id (the local id of the
    -- proto handed to the NPC by the player).
    -- 
    -- switch on object.id
    local is_gem, exp_multiplier, id_reward, faction_required, faction_multiplier
    if object.id == "%id_gem_3eg_cap%" then
        is_gem = 1
        exp_multiplier = 10
        id_reward = id_3eg_cap
        faction_required = 20
        faction_multiplier = 1
    elseif object.id == "%id_gem_3eg_food%" then
        is_gem = 1
        exp_multiplier = 10
        id_reward = id_3eg_food
        faction_required = 20
        faction_multiplier = 1
    elseif object.id == "%id_gem_3eg_drink%" then
        is_gem = 1
        exp_multiplier = 10
        id_reward = id_3eg_drink
        faction_required = 20
        faction_multiplier = 1
    elseif object.id == "%id_gem_3eg_ssword%" then
        is_gem = 1
        exp_multiplier = 10
        id_reward = id_3eg_ssword
        faction_required = 20
        faction_multiplier = 1
    elseif object.id == "%id_gem_3eg_neck%" then
        is_gem = 1
        exp_multiplier = 12
        id_reward = id_3eg_neck
        faction_required = 40
        faction_multiplier = 1
    elseif object.id == "%id_gem_3eg_staff%" then
        is_gem = 1
        exp_multiplier = 12
        id_reward = id_3eg_staff
        faction_required = 40
        faction_multiplier = 1
    elseif object.id == "%id_gem_3eg_arm%" then
        is_gem = 1
        exp_multiplier = 14
        id_reward = id_3eg_arm
        faction_required = 55
        faction_multiplier = 1
    elseif object.id == "%id_gem_3eg_whammer%" then
        is_gem = 1
        exp_multiplier = 14
        id_reward = id_3eg_whammer
        faction_required = 55
        faction_multiplier = 1
    elseif object.id == "%id_gem_3eg_wrist%" then
        is_gem = 1
        exp_multiplier = 16
        id_reward = id_3eg_wrist
        faction_required = 70
        faction_multiplier = 1
    elseif object.id == "%id_gem_3eg_flail%" then
        is_gem = 1
        exp_multiplier = 16
        id_reward = id_3eg_flail
        faction_required = 70
        faction_multiplier = 1
    elseif object.id == "%id_gem_3eg_gloves%" then
        is_gem = 1
        exp_multiplier = 18
        id_reward = id_3eg_gloves
        faction_required = 85
        faction_multiplier = 1
    elseif object.id == "%id_gem_3eg_symbol%" then
        is_gem = 1
        exp_multiplier = 18
        id_reward = id_3eg_symbol
        faction_required = 85
        faction_multiplier = 1
    elseif object.id == "%id_gem_3eg_belt%" then
        is_gem = 1
        exp_multiplier = 20
        id_reward = id_3eg_belt
        faction_required = 100
        faction_multiplier = 1
    elseif object.id == "%id_gem_3eg_shiv%" then
        is_gem = 1
        exp_multiplier = 20
        id_reward = id_3eg_shiv
        faction_required = 100
        faction_multiplier = 1
    elseif object.id == "%id_gem_3eg_boots%" then
        is_gem = 1
        exp_multiplier = 22
        id_reward = id_3eg_boots
        faction_required = 115
        faction_multiplier = 2
    elseif object.id == "%id_gem_3eg_lsword%" then
        is_gem = 1
        exp_multiplier = 22
        id_reward = id_3eg_lsword
        faction_required = 115
        faction_multiplier = 2
    elseif object.id == "%id_gem_3eg_legs%" then
        is_gem = 1
        exp_multiplier = 24
        id_reward = id_3eg_legs
        faction_required = 130
        faction_multiplier = 2
    elseif object.id == "%id_gem_3eg_robe%" then
        is_gem = 1
        exp_multiplier = 26
        id_reward = id_3eg_robe
        faction_required = 145
        faction_multiplier = 2
    elseif object.id == "%id_gem_3eg_jerkin%" then
        is_gem = 1
        exp_multiplier = 26
        id_reward = id_3eg_jerkin
        faction_required = 145
        faction_multiplier = 2
    elseif object.id == "%id_gem_3eg_light%" then
        is_gem = 1
        exp_multiplier = 26
        id_reward = id_3eg_light
        faction_required = 85
        faction_multiplier = 2
    elseif object.id == "%id_gem_3eg_mask%" then
        is_gem = 1
        exp_multiplier = 28
        id_reward = id_3eg_mask
        faction_required = 160
        faction_multiplier = 3
    elseif object.id == "%id_gem_3eg_smace%" then
        is_gem = 1
        exp_multiplier = 28
        id_reward = id_3eg_smace
        faction_required = 160
        faction_multiplier = 3
    elseif object.id == "%id_3bl_skull%" then
        exp_multiplier = 2
        local id_trophy = id_3bl_skull
        faction_multiplier = 1
    elseif object.id == "%id_3bl_ring%" then
        exp_multiplier = 2
        local id_trophy = id_3bl_ring
        faction_multiplier = 1
    elseif object.id == "%id_3bl_badge%" then
        exp_multiplier = 2
        local id_trophy = id_3bl_badge
        faction_multiplier = 1
    elseif object.id == "%id_3bl_token%" then
        exp_multiplier = 2
        local id_trophy = id_3bl_token
        faction_multiplier = 2
    elseif object.id == "%id_3bl_insignia%" then
        exp_multiplier = 2
        local id_trophy = id_3bl_insignia
        faction_multiplier = 2
    elseif object.id == "%id_3bl_wand%" then
        exp_multiplier = 2
        local id_trophy = id_3bl_wand
        faction_multiplier = 2
    elseif object.id == "%id_3bl_symbol%" then
        exp_multiplier = 2
        local id_trophy = id_3bl_symbol
        faction_multiplier = 3
    else
        _return_value = true
        wait(0.1)
        self:command("eye " .. tostring(actor.name))
        actor:send(tostring(self.name) .. " tells you, 'I am not interested in")
        actor:send("</>this from you.'")
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
        if actor:get_quest_var("black_legion:id_trophy_trophies") then
        else
            actor:set_quest_var("black_legion", "%id_trophy%_trophies", 0)
        end
        local trophies = actor:get_quest_var("black_legion:id_trophy_trophies")
        actor:set_quest_var("black_legion", "%id_trophy%_trophies", trophies)
        -- The highest faction a player can gain from interacting with the 3rd front creatures will
        -- be 200.  For this section the trophy turn in will reply on this and other checks.
        if actor:get_quest_var("black_legion:eg_faction") < 200 then
            local trophies = actor:get_quest_var("black_legion:id_trophy_trophies") + 1
            actor:set_quest_var("black_legion", "%id_trophy%_trophies", trophies)
            wait(0.2)
            actor:send(tostring(self.name) .. " tells you, 'Hrm, yes... you have")
            actor:send("</>been out fighting the Black Legion.  I see from my records you have now given")
            actor:send("</>me <b:yellow>" .. tostring(trophies) .. " <white>" .. "%get.obj_shortdesc[%id_trophy%]%</>.'")
            world.destroy(object)
            actor:save()
            if trophies < 10 then
                faction_advance = 1
                exp_advance = 1
            else
                faction_advance = 1
            end
        else
            if trophies < 10 then
                exp_advance = 1
                local trophies = actor:get_quest_var("black_legion:id_trophy_trophies") + 1
                actor:set_quest_var("black_legion", "%id_trophy%_trophies", trophies)
            else
                _return_value = true
            end
            wait(0.2)
            self:command("eye " .. tostring(actor.name))
            actor:send(tostring(self.name) .. " tells you, 'You have garnered as")
            actor:send("</>much favor with the Eldorian Guard as you possibly can by fighting the Third")
            actor:send("</>Black Legion.  You may one day find other more difficult battles with those")
            actor:send("</>tree rats that will curry more favor with our masters.'")
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
                lap = lap + 1
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
                actor:set_quest_var("black_legion", "eg_faction", faction)
                -- 
                -- slight bug for now the trigger code can't seem to evaluate negative numbers?
                -- 
                local faction2 = actor:get_quest_var("black_legion:bl_faction") - 1
                actor:set_quest_var("black_legion", "bl_faction", faction2)
                lap = lap + 1
            end
            -- 
            -- end faction loop
            -- 
            -- all other items should be mpjunked or whatever by now
        end
        actor:save()
        -- end of !if_gem section or trophy endif
    end
    if is_gem then
        -- hrmm Jelos' magical variable declaration
        if actor:get_quest_var("black_legion:id_reward_reward") then
        else
            actor:set_quest_var("black_legion", "%id_reward%_reward", 0)
        end
        local rewards = actor:get_quest_var("black_legion:id_reward_reward")
        actor:set_quest_var("black_legion", "%id_reward%_reward", rewards)
        if actor.alignment <= -151 then
            _return_value = true
            wait(0.2)
            actor:send(tostring(self.name) .. " tells you, 'You aren't quite good")
            actor:send("</>enough for these rewards.'")
            return _return_value
        end
        if actor:get_quest_var("black_legion:eg_faction") >= faction_required then
            local rewards = actor:get_quest_var("black_legion:id_reward_reward") + 1
            actor:set_quest_var("black_legion", "%id_reward%_reward", rewards)
            wait(0.2)
            actor:send(tostring(self.name) .. " tells you, 'Ah yes, the Guard")
            actor:send("</>thanks you for your efforts.  Take this to aid you in your battles.'")
            wait(0.1)
            self.room:spawn_object(55, id_reward)
            wait(0.1)
            if actor:get_quest_var("black_legion:id_reward_reward") == 1 then
                -- 
                -- loop for exp award.
                -- 
                -- (empty send to actor)
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
                    actor:set_quest_var("black_legion", "eg_faction", faction)
                    -- 
                    -- slight bug for now the trigger code can't seem to evaluate negative numbers?
                    -- 
                    local faction2 = actor:get_quest_var("black_legion:bl_faction") - 1
                    actor:set_quest_var("black_legion", "bl_faction", faction2)
                    lap = lap + 1
                end
                -- 
                -- end faction loop
                -- 
                -- all other items should be mpjunked or whatever by now
            end
            world.destroy(object)
            self:destroy_item("all.eldoria-trophy")
            self:command("give all " .. tostring(actor.name))
            actor:save()
        else
            _return_value = true
            wait(0.2)
            actor:send(tostring(self.name) .. " tells you, 'You aren't quite allied")
            actor:send("</>enough with our cause to earn that reward.'")
            return _return_value
        end
        -- end of if_gem section
    end
else
    -- Alignment not high enough or hasn't started the quest yet.
    _return_value = true
    wait(0.2)
    actor:send(tostring(self.name) .. " tells you, 'You aren't quite allied")
    actor:send("</>enough with our cause to earn our rewards.  You need a higher alignment or to")
    actor:send("</>start these quests by saying <b:white>[yes]</> or <b:white>[quest]</> or <b:white>[hello]</>.'")
end
return _return_value