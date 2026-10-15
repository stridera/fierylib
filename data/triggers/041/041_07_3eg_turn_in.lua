-- Trigger: 3eg_turn_in
-- Zone: 41, ID: 7
-- Type: MOB, Flags: RECEIVE
-- Status: TODO(parity)
--
-- TODO(parity): Stripped-down 041 mirror of 055_07 (Eldorian Guard
-- 3eg turn-in, fewer item tiers). Same systemic converter problems
-- as 041_03 / 055_07 -- briefly:
--   1. `object.id == "%id_xxx%"` placeholder strings never match;
--      the entire switch falls into the else "I am not interested" branch.
--   2. Branch-scoped `local` writes never escape to the trophy/reward
--      logic that follows.
--   3. The 3eg gem 5-digit vnums (55566..55584) need to be addressed as
--      (zone, local_id) tuples once spawn semantics are sorted.
--   4. Quest-var keys still contain literal `%id_trophy%`/`%id_reward%`
--      sentinels instead of substituted ids.
-- Light mechanical fixes are applied below (see inline comments) so the
-- file at least parses cleanly, but the quest gameplay still requires a
-- full rebuild before it is functional. See 055_07 for the upstream
-- shape and the same set of TODOs.
--
-- Original DG Script: #4107

local function proto_key(vnum)
    vnum = tonumber(vnum)
    if not vnum then return nil end
    local zone = math.floor(vnum / 100)
    if zone == 0 then zone = 1000 end
    return zone, vnum % 100
end
local function proto_short(vnum)
    local zone, id = proto_key(vnum)
    local name = zone and objects.template(zone, id).name
    if not name or name == "" then return "[no description for object " .. tostring(vnum) .. "]" end
    return name
end
local _return_value = true  -- Default: allow action
-- 
-- This is the main receive trigger for the Edorian
-- combat quests installed on the mud. This trigger
-- will be generic and the IDs and variables set
-- to reflect which faction it applies to.
-- 
if actor:get_quest_var("Black_Legion:bl_ally") then
    actor:send(tostring(self.name) .. " tells you, 'You have pledged yourself to the forces of")
    actor:send("</>darkness!  Suffer under your choice!'")
    return _return_value
end
-- 3eg is Third Eldorian Guard
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
    local id_gem_3eg_staff = 55581
    local id_gem_3eg_ssword = 55582
    local id_gem_3eg_whammer = 55583
    local id_gem_3eg_flail = 55584
    local id_gem_3eg_food = 55566
    local id_gem_3eg_drink = 55567
    -- rewards
    local id_3eg_cap = 18
    local id_3eg_neck = 20
    local id_3eg_arm = 22
    local id_3eg_wrist = 24
    local id_3eg_staff = 46
    local id_3eg_ssword = 47
    local id_3eg_whammer = 48
    local id_3eg_flail = 49
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
    local id_trophy
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
    elseif object.id == "%id_3bl_skull%" then
        exp_multiplier = 2
        id_trophy = id_3bl_skull
        faction_multiplier = 1
    elseif object.id == "%id_3bl_ring%" then
        exp_multiplier = 2
        id_trophy = id_3bl_ring
        faction_multiplier = 1
    elseif object.id == "%id_3bl_badge%" then
        exp_multiplier = 2
        id_trophy = id_3bl_badge
        faction_multiplier = 1
    elseif object.id == "%id_3bl_token%" then
        exp_multiplier = 2
        id_trophy = id_3bl_token
        faction_multiplier = 2
    elseif object.id == "%id_3bl_insignia%" then
        exp_multiplier = 2
        id_trophy = id_3bl_insignia
        faction_multiplier = 2
    elseif object.id == "%id_3bl_wand%" then
        exp_multiplier = 2
        id_trophy = id_3bl_wand
        faction_multiplier = 2
    elseif object.id == "%id_3bl_symbol%" then
        exp_multiplier = 2
        id_trophy = id_3bl_symbol
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
        if (actor:get_quest_var("black_legion:eg_faction") or 0) < 100 then
            local trophies = (actor:get_quest_var("black_legion:id_trophy_trophies") or 0) + 1
            actor:set_quest_var("black_legion", "%id_trophy%_trophies", trophies)
            wait(0.2)
            actor:send(tostring(self.name) .. " tells you, 'Hrm, yes... you have been out fighting the")
            actor:send("</>influence of the Black Legion.  I see from my records you have now turned in")
            actor:send("</><b:yellow>" .. tostring(trophies) .. "</> <b:white>" .. proto_short(id_trophy) .. "</>.'")
            world.destroy(object)  -- TODO(parity): legacy converter wrote `object.name`
            actor:save()
            if trophies < 10 then
                faction_advance = 1
                exp_advance = 1
            else
                faction_advance = 1
            end
        else
            if (trophies or 0) < 10 then
                exp_advance = 1
                local trophies = (actor:get_quest_var("black_legion:id_trophy_trophies") or 0) + 1
                actor:set_quest_var("black_legion", "%id_trophy%_trophies", trophies)
            else
                _return_value = true
            end
            wait(0.2)
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
                local faction = (actor:get_quest_var("black_legion:eg_faction") or 0) + 1
                actor:set_quest_var("black_legion", "eg_faction", faction)
                -- 
                -- slight bug for now the trigger code can't seem to evaluate negative numbers?
                -- 
                local faction2 = (actor:get_quest_var("black_legion:bl_faction") or 0) - 1
                actor:set_quest_var("black_legion", "bl_faction", faction2)
                lap = lap + 1
            end
            -- 
            -- end faction loop
            -- 
            -- all other items should be mpjunked or whatever by now
        end
        actor:save()  -- TODO(parity): legacy converter wrote `actor.name:save()`
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
            actor:send(tostring(self.name) .. " tells you, 'You aren't quite good enough for these")
            actor:send("</>rewards.'")
            return _return_value
        end
        if (actor:get_quest_var("black_legion:eg_faction") or 0) >= faction_required then
            local rewards = (actor:get_quest_var("black_legion:id_reward_reward") or 0) + 1
            actor:set_quest_var("black_legion", "%id_reward%_reward", rewards)
            wait(0.2)
            actor:send(tostring(self.name) .. " tells you, 'Ah yes, the Guard thanks you for your")
            actor:send("</>efforts.  Take this to aid you in your battles.'")
            wait(0.1)
            self.room:spawn_object(55, id_reward)
            wait(0.1)
            if (actor:get_quest_var("black_legion:id_reward_reward") or 0) == 1 then
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
            if (actor:get_quest_var("black_legion:eg_faction") or 0) < 200 then
                -- 
                -- loop for faction award.
                -- 
                actor:send("<b:yellow>Your curry favor with the Eldorian Guard!</>")
                actor:send("<b:red>You feel more hated by the Black Legion!</>")
                local lap = 1
                while lap <= faction_multiplier do
                    local faction = (actor:get_quest_var("black_legion:eg_faction") or 0) + 1
                    actor:set_quest_var("black_legion", "eg_faction", faction)
                    -- 
                    -- 
                    -- slight bug for now the trigger code can't seem to evaluate negative numbers?
                    -- 
                    -- 
                    local faction2 = (actor:get_quest_var("black_legion:bl_faction") or 0) - 1
                    actor:set_quest_var("black_legion", "bl_faction", faction2)
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
            wait(0.2)
            actor:send(tostring(self.name) .. " tells you, 'You aren't quite allied enough with our cause")
            actor:send("</>to earn that reward.'")
            return _return_value
        end
        -- end of if_gem section
    end
else
    -- Alignment not high enough or hasn't started the quest yet.
    _return_value = true
    wait(0.2)
    actor:send(tostring(self.name) .. " tells you, 'You aren't quite allied enough with our cause")
    actor:send("</>to earn our rewards.  You need a higher alignment or to start these quests by")
    actor:send("</>saying <b:white>[yes]</> or <b:white>[quest]</> or <b:white>[hello]</>.'")
end
return _return_value