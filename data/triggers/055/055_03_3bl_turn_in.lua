-- Trigger: 3bl_turn_in
-- Zone: 55, ID: 3
-- Type: MOB, Flags: RECEIVE
-- Status: TODO(parity)
--
-- TODO(parity): Quest is non-functional in current form. The converter
-- left several systemic bugs that require a full rewrite against the
-- current (zone, id) catalog before this turn-in works:
--   1. Every `object.id == "%id_xxx%"` comparison is a string-vs-int
--      compare against the literal placeholder text, so no branch ever
--      fires and players always hit the "I am not interested" else.
--   2. The per-branch `local is_gem`/`exp_multiplier`/`id_reward`/etc.
--      shadow within their branch only; the outer reward and trophy
--      logic always sees nil. Needs hoisted (non-local) writes.
--   3. The gem item IDs are legacy 5-digit vnums (55570..55589, 55566,
--      55567) that need to be re-derived as proper (zone, local_id)
--      tuples once the gem zone is rebuilt.
--   4. Quest var keys still contain literal `%id_trophy%`/`%id_reward%`
--      placeholders -- they need string concatenation against the
--      resolved local_id.
--   5. `%get.obj_shortdesc[%id_trophy%]%` is never resolved -- swap to
--      `objects.template(zone, id).name` lookups.
-- Some lighter mechanical fixes (actor.name:save -> actor:save,
-- world.destroy arg, return value) are applied below to keep the file
-- parseable, but the gameplay logic still needs rebuilding end-to-end.
--
-- Original DG Script: #5503

-- Converted from DG Script #5503: 3bl_turn_in
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
-- 
-- This is the main receive trigger for the Edorian
-- combat quests installed on the mud. This trigger
-- will be generic and the IDs and variables set
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
    actor:set_quest_var("Black_Legion", "bl_ally", 1)
    -- 
    -- pertinent object definitions for this faction
    -- trophies
    local id_3el_skull = 5504
    local id_3el_ring = 5506
    local id_3el_badge = 5508
    local id_3el_token = 5510
    local id_3el_insignia = 5512
    local id_3el_wand = 5514
    local id_3el_symbol = 5516
    -- gems for this faction
    local id_gem_3bl_cap = 55570
    local id_gem_3bl_neck = 55571
    local id_gem_3bl_arm = 55572
    local id_gem_3bl_wrist = 55573
    local id_gem_3bl_gloves = 55574
    local id_gem_3bl_jerkin = 55575
    local id_gem_3bl_robe = 55589
    local id_gem_3bl_belt = 55576
    local id_gem_3bl_legs = 55577
    local id_gem_3bl_boots = 55578
    local id_gem_3bl_mask = 55579
    local id_gem_3bl_symbol = 55580
    local id_gem_3bl_staff = 55581
    local id_gem_3bl_ssword = 55582
    local id_gem_3bl_whammer = 55583
    local id_gem_3bl_flail = 55584
    local id_gem_3bl_shiv = 55585
    local id_gem_3bl_lsword = 55586
    local id_gem_3bl_smace = 55587
    local id_gem_3bl_light = 55588
    local id_gem_3bl_food = 55566
    local id_gem_3bl_drink = 55567
    -- rewards
    local id_3bl_cap = 17
    local id_3bl_neck = 19
    local id_3bl_arm = 21
    local id_3bl_wrist = 23
    local id_3bl_gloves = 25
    local id_3bl_jerkin = 27
    local id_3bl_belt = 29
    local id_3bl_legs = 31
    local id_3bl_boots = 33
    local id_3bl_mask = 35
    local id_3bl_robe = 37
    local id_3bl_symbol = 15
    local id_3bl_staff = 39
    local id_3bl_ssword = 40
    local id_3bl_whammer = 41
    local id_3bl_flail = 42
    local id_3bl_shiv = 43
    local id_3bl_lsword = 44
    local id_3bl_smace = 45
    local id_3bl_light = 53
    local id_3bl_food = 55
    local id_3bl_drink = 57
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
    -- These case set the variables for the quests.
    -- The cases below switch on object.id (the local id of the
    -- proto handed to the NPC by the player).
    -- 
    -- switch on object.id
    local is_gem, exp_multiplier, id_reward, faction_required, faction_multiplier
    if object.id == "%id_gem_3bl_cap%" then
        is_gem = 1
        exp_multiplier = 10
        id_reward = id_3bl_cap
        faction_required = 20
        faction_multiplier = 1
    elseif object.id == "%id_gem_3bl_food%" then
        is_gem = 1
        exp_multiplier = 10
        id_reward = id_3bl_food
        faction_required = 20
        faction_multiplier = 1
    elseif object.id == "%id_gem_3bl_drink%" then
        is_gem = 1
        exp_multiplier = 10
        id_reward = id_3bl_drink
        faction_required = 20
        faction_multiplier = 1
    elseif object.id == "%id_gem_3bl_ssword%" then
        is_gem = 1
        exp_multiplier = 10
        id_reward = id_3bl_ssword
        faction_required = 20
        faction_multiplier = 1
    elseif object.id == "%id_gem_3bl_neck%" then
        is_gem = 1
        exp_multiplier = 12
        id_reward = id_3bl_neck
        faction_required = 40
        faction_multiplier = 1
    elseif object.id == "%id_gem_3bl_staff%" then
        is_gem = 1
        exp_multiplier = 12
        id_reward = id_3bl_staff
        faction_required = 40
        faction_multiplier = 1
    elseif object.id == "%id_gem_3bl_arm%" then
        is_gem = 1
        exp_multiplier = 14
        id_reward = id_3bl_arm
        faction_required = 55
        faction_multiplier = 1
    elseif object.id == "%id_gem_3bl_whammer%" then
        is_gem = 1
        exp_multiplier = 14
        id_reward = id_3bl_whammer
        faction_required = 55
        faction_multiplier = 1
    elseif object.id == "%id_gem_3bl_wrist%" then
        is_gem = 1
        exp_multiplier = 16
        id_reward = id_3bl_wrist
        faction_required = 70
        faction_multiplier = 1
    elseif object.id == "%id_gem_3bl_flail%" then
        is_gem = 1
        exp_multiplier = 16
        id_reward = id_3bl_flail
        faction_required = 70
        faction_multiplier = 1
    elseif object.id == "%id_gem_3bl_gloves%" then
        is_gem = 1
        exp_multiplier = 18
        id_reward = id_3bl_gloves
        faction_required = 85
        faction_multiplier = 1
    elseif object.id == "%id_gem_3bl_symbol%" then
        is_gem = 1
        exp_multiplier = 18
        id_reward = id_3bl_symbol
        faction_required = 85
        faction_multiplier = 1
    elseif object.id == "%id_gem_3bl_belt%" then
        is_gem = 1
        exp_multiplier = 20
        id_reward = id_3bl_belt
        faction_required = 100
        faction_multiplier = 1
    elseif object.id == "%id_gem_3bl_shiv%" then
        is_gem = 1
        exp_multiplier = 20
        id_reward = id_3bl_shiv
        faction_required = 100
        faction_multiplier = 1
    elseif object.id == "%id_gem_3bl_boots%" then
        is_gem = 1
        exp_multiplier = 22
        id_reward = id_3bl_boots
        faction_required = 115
        faction_multiplier = 2
    elseif object.id == "%id_gem_3bl_lsword%" then
        is_gem = 1
        exp_multiplier = 22
        id_reward = id_3bl_lsword
        faction_required = 115
        faction_multiplier = 2
    elseif object.id == "%id_gem_3bl_legs%" then
        is_gem = 1
        exp_multiplier = 24
        id_reward = id_3bl_legs
        faction_required = 130
        faction_multiplier = 2
    elseif object.id == "%id_gem_3bl_robe%" then
        is_gem = 1
        exp_multiplier = 26
        id_reward = id_3bl_robe
        faction_required = 145
        faction_multiplier = 2
    elseif object.id == "%id_gem_3bl_jerkin%" then
        is_gem = 1
        exp_multiplier = 26
        id_reward = id_3bl_jerkin
        faction_required = 145
        faction_multiplier = 2
    elseif object.id == "%id_gem_3bl_light%" then
        is_gem = 1
        exp_multiplier = 26
        id_reward = id_3bl_light
        faction_required = 85
        faction_multiplier = 2
    elseif object.id == "%id_gem_3bl_mask%" then
        is_gem = 1
        exp_multiplier = 28
        id_reward = id_3bl_mask
        faction_required = 160
        faction_multiplier = 3
    elseif object.id == "%id_gem_3bl_smace%" then
        is_gem = 1
        exp_multiplier = 28
        id_reward = id_3bl_smace
        faction_required = 160
        faction_multiplier = 3
    elseif object.id == "%id_3el_skull%" then
        exp_multiplier = 2
        local id_trophy = id_3el_skull
        faction_multiplier = 1
    elseif object.id == "%id_3el_ring%" then
        exp_multiplier = 2
        local id_trophy = id_3el_ring
        faction_multiplier = 1
    elseif object.id == "%id_3el_badge%" then
        exp_multiplier = 2
        local id_trophy = id_3el_badge
        faction_multiplier = 1
    elseif object.id == "%id_3el_token%" then
        exp_multiplier = 2
        local id_trophy = id_3el_token
        faction_multiplier = 2
    elseif object.id == "%id_3el_insignia%" then
        exp_multiplier = 2
        local id_trophy = id_3el_insignia
        faction_multiplier = 2
    elseif object.id == "%id_3el_wand%" then
        exp_multiplier = 2
        local id_trophy = id_3el_wand
        faction_multiplier = 2
    elseif object.id == "%id_3el_symbol%" then
        exp_multiplier = 2
        local id_trophy = id_3el_symbol
        faction_multiplier = 3
    else
        _return_value = true
        wait(0.1)
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
        if actor:get_quest_var("black_legion:id_trophy_trophies") then
        else
            actor:set_quest_var("black_legion", "%id_trophy%_trophies", 0)
        end
        local trophies = actor:get_quest_var("black_legion:id_trophy_trophies")
        actor:set_quest_var("black_legion", "%id_trophy%_trophies", trophies)
        -- The highest faction a player can gain from interacting with the 3rd front creatures will
        -- be 200.  For this section the trophy turn in will reply on this and other checks.
        if actor:get_quest_var("black_legion:bl_faction") < 200 then
            local trophies = actor:get_quest_var("black_legion:id_trophy_trophies") + 1
            actor:set_quest_var("black_legion", "%id_trophy%_trophies", trophies)
            wait(0.2)
            actor:send(tostring(self.name) .. " tells you, 'Hrm, yes.. you have been out")
            actor:send("</>fighting the Eldorian Guard.  I see from my records you have now given me")
            actor:send("</><b:yellow>" .. tostring(trophies) .. "</> <b:white>" .. "%get.obj_shortdesc[%id_trophy%]%</>.'")
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
            actor:send("<b:yellow>Your curry favor with the Black Legion!</>")
            actor:send("<b:red>You feel more hated by the Eldorian Guard!</>")
            local lap = 1
            while lap <= faction_multiplier do
                local faction = actor:get_quest_var("black_legion:bl_faction") + 1
                actor:set_quest_var("black_legion", "bl_faction", faction)
                -- 
                -- slight bug for now the trigger code can't seem to evaluate negative numbers?
                -- 
                local faction2 = actor:get_quest_var("black_legion:eg_faction") - 1
                actor:set_quest_var("black_legion", "eg_faction", faction2)
                lap = lap + 1
            end
            -- 
            -- end faction loop
            -- 
            -- all other items should be mpjunked or whatever by now
        end
        -- end of !if_gem section or trophy endif
        actor:save()
    end
    if is_gem then
        -- hrmm Jelos' magical variable declaration
        if actor:get_quest_var("black_legion:id_reward_reward") then
        else
            actor:set_quest_var("black_legion", "%id_reward%_reward", 0)
        end
        local rewards = actor:get_quest_var("black_legion:id_reward_reward")
        actor:set_quest_var("black_legion", "%id_reward%_reward", rewards)
        if actor.alignment >= 151 then
            _return_value = true
            wait(0.2)
            actor:send(tostring(self.name) .. " tells you, 'You aren't quite evil enough for")
            actor:send("</>these rewards.'")
            return _return_value
        end
        if actor:get_quest_var("black_legion:bl_faction") >= faction_required then
            local rewards = actor:get_quest_var("black_legion:id_reward_reward") + 1
            actor:set_quest_var("black_legion", "%id_reward%_reward", rewards)
            wait(0.2)
            actor:send(tostring(self.name) .. " tells you, 'Ah yes, the Legion thanks you for")
            actor:send("</>your efforts.  Take this to aid you in your battles.'")
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
            if actor:get_quest_var("black_legion:bl_faction") < 200 then
                -- 
                -- loop for faction award.
                -- 
                actor:send("<b:yellow>Your curry favor with the Black Legion!</>")
                actor:send("<b:red>You feel more hated by the Eldorian Guard!</>")
                local lap = 1
                while lap <= faction_multiplier do
                    local faction = actor:get_quest_var("black_legion:bl_faction") + 1
                    actor:set_quest_var("black_legion", "bl_faction", faction)
                    -- 
                    -- slight bug for now the trigger code can't seem to evaluate negative numbers?
                    -- 
                    local faction2 = actor:get_quest_var("black_legion:eg_faction") - 1
                    actor:set_quest_var("black_legion", "eg_faction", faction2)
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
            actor:send(tostring(self.name) .. " tells you, 'You aren't quite allied enough")
            actor:send("</>with our cause to earn that reward.'")
            return _return_value
        end
        -- end of if_gem section
    end
else
    -- Alignment not low enough or hasn't started the quest yet.
    _return_value = true
    wait(0.2)
    actor:send(tostring(self.name) .. " tells you, 'You aren't quite allied enough with")
    actor:send("</>our cause to earn our rewards.  You need a lower alignment or to start these")
    actor:send("</>quests by saying <b:white>[yes]</> or <b:white>[quest]</> or <b:white>[hello]</>.'")
end
return _return_value