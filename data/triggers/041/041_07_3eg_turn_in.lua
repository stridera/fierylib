-- Trigger: 3eg_turn_in
-- Zone: 41, ID: 7
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Combat-in-Eldoria turn-in for the Eldorian Guard: trophies of the other side raise faction and give
-- experience, gems buy faction-gated rewards. The received object is matched on its
-- (zone, id) against the legacy vnums below; quest variables are keyed by vnum as in DG.
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
-- The runtime fires RECEIVE after the item is already in the mob's hands, so a refusal hands it
-- back with a give command (DG's `return 0`).
local function give_back()
    local bare = string.gsub(string.gsub(object.name, "^%s*[Tt]he%s+", ""), "^%s*[Aa]n?%s+", "")
    self:command("give " .. bare .. " " .. actor.name)
end
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
    -- Objects this questmaster accepts, as the legacy vnums (zone * 100 + id) the DG script used:
    -- `item` is what the player hands over, `reward` the item given back for a gem. Quest-variable
    -- keys stay <vnum>_trophies / <vnum>_reward like legacy.
    local TURNIN = {
        { item = 55570, exp = 10, faction = 1, reward = 5518, faction_required = 20 },  -- gem_3eg_cap
        { item = 55566, exp = 10, faction = 1, reward = 5556, faction_required = 20 },  -- gem_3eg_food
        { item = 55567, exp = 10, faction = 1, reward = 5558, faction_required = 20 },  -- gem_3eg_drink
        { item = 55582, exp = 10, faction = 1, reward = 5547, faction_required = 20 },  -- gem_3eg_ssword
        { item = 55571, exp = 12, faction = 1, reward = 5520, faction_required = 40 },  -- gem_3eg_neck
        { item = 55581, exp = 12, faction = 1, reward = 5546, faction_required = 40 },  -- gem_3eg_staff
        { item = 55572, exp = 14, faction = 1, reward = 5522, faction_required = 55 },  -- gem_3eg_arm
        { item = 55583, exp = 14, faction = 1, reward = 5548, faction_required = 55 },  -- gem_3eg_whammer
        { item = 55573, exp = 16, faction = 1, reward = 5524, faction_required = 70 },  -- gem_3eg_wrist
        { item = 55584, exp = 16, faction = 1, reward = 5549, faction_required = 70 },  -- gem_3eg_flail
        { item = 5503, exp = 2, faction = 1 },  -- 3bl_skull (trophy)
        { item = 5505, exp = 2, faction = 1 },  -- 3bl_ring (trophy)
        { item = 5507, exp = 2, faction = 1 },  -- 3bl_badge (trophy)
        { item = 5509, exp = 2, faction = 2 },  -- 3bl_token (trophy)
        { item = 5511, exp = 2, faction = 2 },  -- 3bl_insignia (trophy)
        { item = 5513, exp = 2, faction = 2 },  -- 3bl_wand (trophy)
        { item = 5515, exp = 2, faction = 3 },  -- 3bl_symbol (trophy)
    }
    local is_gem, exp_multiplier, id_reward, faction_required, faction_multiplier
    local id_trophy
    local entry
    for _, t in ipairs(TURNIN) do
        local z, i = proto_key(t.item)
        if object.zone_id == z and object.id == i then
            entry = t
            break
        end
    end
    if entry then
        exp_multiplier = entry.exp
        faction_multiplier = entry.faction
        if entry.reward then
            is_gem = 1
            id_reward = entry.reward
            faction_required = entry.faction_required
        else
            id_trophy = entry.item
        end
    else
        give_back()
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
        if actor:get_quest_var("black_legion:" .. tostring(id_trophy) .. "_trophies") then
        else
            actor:set_quest_var("black_legion", tostring(id_trophy) .. "_trophies", 0)
        end
        local trophies = actor:get_quest_var("black_legion:" .. tostring(id_trophy) .. "_trophies")
        actor:set_quest_var("black_legion", tostring(id_trophy) .. "_trophies", trophies)
        -- The highest faction a player can gain from interacting with the 3rd front creatures will
        -- be 200.  For this section the trophy turn in will reply on this and other checks.
        if (actor:get_quest_var("black_legion:eg_faction") or 0) < 100 then
            local trophies = (actor:get_quest_var("black_legion:" .. tostring(id_trophy) .. "_trophies") or 0) + 1
            actor:set_quest_var("black_legion", tostring(id_trophy) .. "_trophies", trophies)
            wait(0.2)
            actor:send(tostring(self.name) .. " tells you, 'Hrm, yes... you have been out fighting the")
            actor:send("</>influence of the Black Legion.  I see from my records you have now turned in")
            actor:send("</><b:yellow>" .. tostring(trophies) .. "</> <b:white>" .. proto_short(id_trophy) .. "</>.'")
            world.destroy(object)
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
                local trophies = (actor:get_quest_var("black_legion:" .. tostring(id_trophy) .. "_trophies") or 0) + 1
                actor:set_quest_var("black_legion", tostring(id_trophy) .. "_trophies", trophies)
            else
                give_back()
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
        actor:save()
        -- end of !if_gem section or trophy endif
    end
    if is_gem then
        -- hrmm Jelos' magical variable declaration
        if actor:get_quest_var("black_legion:" .. tostring(id_reward) .. "_reward") then
        else
            actor:set_quest_var("black_legion", tostring(id_reward) .. "_reward", 0)
        end
        local rewards = actor:get_quest_var("black_legion:" .. tostring(id_reward) .. "_reward")
        actor:set_quest_var("black_legion", tostring(id_reward) .. "_reward", rewards)
        if actor.alignment <= -151 then
            give_back()
            wait(0.2)
            actor:send(tostring(self.name) .. " tells you, 'You aren't quite good enough for these")
            actor:send("</>rewards.'")
            return _return_value
        end
        if (actor:get_quest_var("black_legion:eg_faction") or 0) >= faction_required then
            local rewards = (actor:get_quest_var("black_legion:" .. tostring(id_reward) .. "_reward") or 0) + 1
            actor:set_quest_var("black_legion", tostring(id_reward) .. "_reward", rewards)
            wait(0.2)
            actor:send(tostring(self.name) .. " tells you, 'Ah yes, the Guard thanks you for your")
            actor:send("</>efforts.  Take this to aid you in your battles.'")
            wait(0.1)
            self:spawn_object(proto_key(id_reward))
            wait(0.1)
            if (actor:get_quest_var("black_legion:" .. tostring(id_reward) .. "_reward") or 0) == 1 then
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
            world.destroy(object)
            self:destroy_item("all.eldoria-trophy")
            self:command("give all " .. tostring(actor.name))
            actor:save()
        else
            give_back()
            wait(0.2)
            actor:send(tostring(self.name) .. " tells you, 'You aren't quite allied enough with our cause")
            actor:send("</>to earn that reward.'")
            return _return_value
        end
        -- end of if_gem section
    end
else
    -- Alignment not high enough or hasn't started the quest yet.
    give_back()
    wait(0.2)
    actor:send(tostring(self.name) .. " tells you, 'You aren't quite allied enough with our cause")
    actor:send("</>to earn our rewards.  You need a higher alignment or to start these quests by")
    actor:send("</>saying <b:white>[yes]</> or <b:white>[quest]</> or <b:white>[hello]</>.'")
end
return _return_value