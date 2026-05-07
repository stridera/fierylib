-- Trigger: 3bl_turn_in
-- Zone: 41, ID: 3
-- Type: MOB, Flags: RECEIVE
-- Status: TODO(parity)
--
-- TODO(parity): Stripped-down 041 mirror of 055_03 (same "Black Legion
-- 3bl turn-in" mechanic, fewer item tiers). The systemic converter
-- problems are identical to 055_03 -- briefly:
--   1. `object.id == "%id_xxx%"` placeholder strings never match;
--      the entire switch falls into the else "I am not interested" branch.
--   2. Branch-scoped `local` writes (is_gem, exp_multiplier, id_reward,
--      faction_required, faction_multiplier, id_trophy) never escape
--      to the trophy/reward logic that follows.
--   3. The 3bl gem 5-digit vnums (55566..55584) need to be addressed as
--      (zone, local_id) tuples once spawn semantics are sorted.
--   4. Quest-var keys still contain literal `%id_trophy%`/`%id_reward%`
--      sentinels instead of substituted ids.
--   5. `%get.obj_shortdesc[%id_trophy%]%` is unresolved interpolation.
-- Light mechanical fixes are applied below (see inline comments) so the
-- file at least parses cleanly, but the quest gameplay still requires a
-- full rebuild before it is functional. See 055_03 for the upstream
-- shape and the same set of TODOs.
--
-- Original DG Script: #4103

local _return_value = true  -- Default: allow action
-- 
-- This is the main receive trigger for the Edorian
-- combat quests installed on the mud. This trigger
-- will be generic and the IDs and variables set
-- to reflect which faction it applies to.
-- 
-- The original zone using these quests was
-- 55 Combat in Eldoria.  I'm adapting the
-- format of the quest mechanics to spread the
-- vast wealth of these quests to other zones
-- such that there isn't so much loot in one zone.
-- 
-- 3bl is Third Black Legion - The player MUST be
-- on the quest already in order to turn in because
-- the variables are not set yet!
if actor:get_quest_var("Black_Legion:eg_ally") then
    actor:send(tostring(self.name) .. " tells you, 'You have already chosen your side!  Be")
    actor:send("</>gone, filth!'")
    return _return_value
end
-- 
if actor.alignment <= 150 and actor:get_quest_stage("Black_Legion") > 0 then
    actor:set_quest_var("Black_Legion", "bl_ally", 1)
    -- 
    -- pertinent object definitions for this faction
    -- trophies
    -- 
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
    local id_gem_3bl_staff = 55581
    local id_gem_3bl_ssword = 55582
    local id_gem_3bl_whammer = 55583
    local id_gem_3bl_flail = 55584
    local id_gem_3bl_food = 55566
    local id_gem_3bl_drink = 55567
    -- rewards
    local id_3bl_cap = 17
    local id_3bl_neck = 19
    local id_3bl_arm = 21
    local id_3bl_wrist = 23
    local id_3bl_staff = 39
    local id_3bl_ssword = 40
    local id_3bl_whammer = 41
    local id_3bl_flail = 42
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
    -- These cases set the variables for the quests.
    -- The cases below switch on object.id (the local id of the
    -- proto handed to the NPC by the player).
    -- 
    -- These cases will only have the objects rewarded by this
    -- questmaster though the full set of objects will be defined
    -- by the script.
    -- 
    -- switch on object.id
    if object.id == "%id_gem_3bl_cap%" then
        local is_gem = 1
        local exp_multiplier = 10
        local id_reward = id_3bl_cap
        local faction_required = 20
        local faction_multiplier = 1
    elseif object.id == "%id_gem_3bl_food%" then
        local is_gem = 1
        local exp_multiplier = 10
        local id_reward = id_3bl_food
        local faction_required = 20
        local faction_multiplier = 1
    elseif object.id == "%id_gem_3bl_drink%" then
        local is_gem = 1
        local exp_multiplier = 10
        local id_reward = id_3bl_drink
        local faction_required = 20
        local faction_multiplier = 1
    elseif object.id == "%id_gem_3bl_ssword%" then
        local is_gem = 1
        local exp_multiplier = 10
        local id_reward = id_3bl_ssword
        local faction_required = 20
        local faction_multiplier = 1
    elseif object.id == "%id_gem_3bl_neck%" then
        local is_gem = 1
        local exp_multiplier = 12
        local id_reward = id_3bl_neck
        local faction_required = 40
        local faction_multiplier = 1
    elseif object.id == "%id_gem_3bl_staff%" then
        local is_gem = 1
        local exp_multiplier = 12
        local id_reward = id_3bl_staff
        local faction_required = 40
        local faction_multiplier = 1
    elseif object.id == "%id_gem_3bl_arm%" then
        local is_gem = 1
        local exp_multiplier = 14
        local id_reward = id_3bl_arm
        local faction_required = 55
        local faction_multiplier = 1
    elseif object.id == "%id_gem_3bl_whammer%" then
        local is_gem = 1
        local exp_multiplier = 14
        local id_reward = id_3bl_whammer
        local faction_required = 55
        local faction_multiplier = 1
    elseif object.id == "%id_gem_3bl_wrist%" then
        local is_gem = 1
        local exp_multiplier = 16
        local id_reward = id_3bl_wrist
        local faction_required = 70
        local faction_multiplier = 1
    elseif object.id == "%id_gem_3bl_flail%" then
        local is_gem = 1
        local exp_multiplier = 16
        local id_reward = id_3bl_flail
        local faction_required = 70
        local faction_multiplier = 1
    elseif object.id == "%id_3el_skull%" then
        local exp_multiplier = 2
        local id_trophy = id_3el_skull
        local faction_multiplier = 1
    elseif object.id == "%id_3el_ring%" then
        local exp_multiplier = 2
        local id_trophy = id_3el_ring
        local faction_multiplier = 1
    elseif object.id == "%id_3el_badge%" then
        local exp_multiplier = 2
        local id_trophy = id_3el_badge
        local faction_multiplier = 1
    elseif object.id == "%id_3el_token%" then
        local exp_multiplier = 2
        local id_trophy = id_3el_token
        local faction_multiplier = 2
    elseif object.id == "%id_3el_insignia%" then
        local exp_multiplier = 2
        local id_trophy = id_3el_insignia
        local faction_multiplier = 2
    elseif object.id == "%id_3el_wand%" then
        local exp_multiplier = 2
        local id_trophy = id_3el_wand
        local faction_multiplier = 2
    elseif object.id == "%id_3el_symbol%" then
        local exp_multiplier = 2
        local id_trophy = id_3el_symbol
        local faction_multiplier = 3
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
        if actor:get_quest_var("black_legion:bl_faction") < 100 then
            local trophies = actor:get_quest_var("black_legion:id_trophy_trophies") + 1
            actor:set_quest_var("black_legion", "%id_trophy%_trophies", trophies)
            wait(2)
            actor:send(tostring(self.name) .. " tells you, 'Hrm, I see you have been out raiding the")
            actor:send("</>monks assisting the Eldorians.  According to my records you have now turned in")
            actor:send("</>have now turned in <b:yellow>" .. tostring(trophies) .. "</> <b:white>" .. "%get.obj_shortdesc[%id_trophy%]%</>.'")
            world.destroy(object)  -- TODO(parity): legacy converter wrote `object.name`
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
                local trophies = actor:get_quest_var("black_legion:id_trophy_trophies") + 1
                actor:set_quest_var("black_legion", "%id_trophy%_trophies", trophies)
            else
                _return_value = true
            end
            wait(2)
            self:command("eye " .. tostring(actor.name))
            actor:send(tostring(self.name) .. " tells you, 'You have garnered as much favor with the")
            actor:send("</>Black Legion as you possibly can by raiding the Abbey.'")
            -- (empty send to actor)
            actor:send(tostring(self.name) .. " tells you, 'You may find other more difficult battles")
            actor:send("</>in Eldoria.'")
            -- (empty send to actor)
            actor:send(tostring(self.name) .. " tells you, 'Seek out the Third Black Legion Recruiter")
            actor:send("</>at the base of Tarelithis in order to curry more favor with our")
            actor:send("</>lords.'")
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
                -- 
                -- slight bug for now the trigger code can't seem to evaluate negative numbers?
                -- 
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
        actor:save()  -- TODO(parity): legacy converter wrote `actor.name:save()`
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
            wait(2)
            actor:send(tostring(self.name) .. " tells you, 'You aren't quite evil enough for these")
            actor:send("</>rewards.'")
            return _return_value
        end
        if actor:get_quest_var("black_legion:bl_faction") >= faction_required then
            local rewards = actor:get_quest_var("black_legion:id_reward_reward") + 1
            actor:set_quest_var("black_legion", "%id_reward%_reward", rewards)
            wait(2)
            actor:send(tostring(self.name) .. " tells you, 'Ah yes, the Legion thanks you for your")
            actor:send("</>efforts.  Take this to aid you in your battles.'")
            wait(1)
            self.room:spawn_object(55, id_reward)
            wait(1)
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
                    -- 
                    -- slight bug for now the trigger code can't seem to evaluate negative numbers?
                    -- 
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
            world.destroy(object)  -- TODO(parity): legacy converter wrote `object.name`
            self:destroy_item("all.eldoria-trophy")
            self:command("give all " .. tostring(actor.name))
            actor:save()  -- TODO(parity): legacy converter wrote `actor.name:save()`
        else
            _return_value = true
            wait(2)
            actor:send(tostring(self.name) .. " tells you, 'You aren't quite allied enough with our")
            actor:send("</>cause to earn that reward.'")
            return _return_value
        end
        -- end of if_gem section
    end
else
    -- Alignment not low enough or hasn't started the quest yet.
    _return_value = true
    wait(2)
    actor:send(tostring(self.name) .. " tells you, 'You aren't quite allied enough with our")
    actor:send("</>cause to earn our rewards.  You need a lower alignement, or to start these")
    actor:send("</>quests by saying <b:white>[yes]</>, <b:white>[quest]</>, or <b:white>[hello]</>.'")
end
return _return_value