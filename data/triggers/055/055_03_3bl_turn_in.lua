-- Trigger: 3bl_turn_in
-- Zone: 55, ID: 3
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Combat-in-Eldoria turn-in for the Black Legion: trophies of the other side raise faction and give
-- experience, gems buy faction-gated rewards. The received object is matched on its
-- (zone, id) against the legacy vnums below; quest variables are keyed by vnum as in DG.
--
-- Original DG Script: #5503


-- Converted from DG Script #5503: 3bl_turn_in
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
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
    -- Objects this questmaster accepts, as the legacy vnums (zone * 100 + id) the DG script used:
    -- `item` is what the player hands over, `reward` the item given back for a gem. Quest-variable
    -- keys stay <vnum>_trophies / <vnum>_reward like legacy.
    local TURNIN = {
        { item = 55570, exp = 10, faction = 1, reward = 5517, faction_required = 20 },  -- gem_3bl_cap
        { item = 55566, exp = 10, faction = 1, reward = 5555, faction_required = 20 },  -- gem_3bl_food
        { item = 55567, exp = 10, faction = 1, reward = 5557, faction_required = 20 },  -- gem_3bl_drink
        { item = 55582, exp = 10, faction = 1, reward = 5540, faction_required = 20 },  -- gem_3bl_ssword
        { item = 55571, exp = 12, faction = 1, reward = 5519, faction_required = 40 },  -- gem_3bl_neck
        { item = 55581, exp = 12, faction = 1, reward = 5539, faction_required = 40 },  -- gem_3bl_staff
        { item = 55572, exp = 14, faction = 1, reward = 5521, faction_required = 55 },  -- gem_3bl_arm
        { item = 55583, exp = 14, faction = 1, reward = 5541, faction_required = 55 },  -- gem_3bl_whammer
        { item = 55573, exp = 16, faction = 1, reward = 5523, faction_required = 70 },  -- gem_3bl_wrist
        { item = 55584, exp = 16, faction = 1, reward = 5542, faction_required = 70 },  -- gem_3bl_flail
        { item = 55574, exp = 18, faction = 1, reward = 5525, faction_required = 85 },  -- gem_3bl_gloves
        { item = 55580, exp = 18, faction = 1, reward = 5515, faction_required = 85 },  -- gem_3bl_symbol
        { item = 55576, exp = 20, faction = 1, reward = 5529, faction_required = 100 },  -- gem_3bl_belt
        { item = 55585, exp = 20, faction = 1, reward = 5543, faction_required = 100 },  -- gem_3bl_shiv
        { item = 55578, exp = 22, faction = 2, reward = 5533, faction_required = 115 },  -- gem_3bl_boots
        { item = 55586, exp = 22, faction = 2, reward = 5544, faction_required = 115 },  -- gem_3bl_lsword
        { item = 55577, exp = 24, faction = 2, reward = 5531, faction_required = 130 },  -- gem_3bl_legs
        { item = 55589, exp = 26, faction = 2, reward = 5537, faction_required = 145 },  -- gem_3bl_robe
        { item = 55575, exp = 26, faction = 2, reward = 5527, faction_required = 145 },  -- gem_3bl_jerkin
        { item = 55588, exp = 26, faction = 2, reward = 5553, faction_required = 85 },  -- gem_3bl_light
        { item = 55579, exp = 28, faction = 3, reward = 5535, faction_required = 160 },  -- gem_3bl_mask
        { item = 55587, exp = 28, faction = 3, reward = 5545, faction_required = 160 },  -- gem_3bl_smace
        { item = 5504, exp = 2, faction = 1 },  -- 3el_skull (trophy)
        { item = 5506, exp = 2, faction = 1 },  -- 3el_ring (trophy)
        { item = 5508, exp = 2, faction = 1 },  -- 3el_badge (trophy)
        { item = 5510, exp = 2, faction = 2 },  -- 3el_token (trophy)
        { item = 5512, exp = 2, faction = 2 },  -- 3el_insignia (trophy)
        { item = 5514, exp = 2, faction = 2 },  -- 3el_wand (trophy)
        { item = 5516, exp = 2, faction = 3 },  -- 3el_symbol (trophy)
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
        if (actor:get_quest_var("black_legion:bl_faction") or 0) < 200 then
            local trophies = (actor:get_quest_var("black_legion:" .. tostring(id_trophy) .. "_trophies") or 0) + 1
            actor:set_quest_var("black_legion", tostring(id_trophy) .. "_trophies", trophies)
            wait(0.2)
            actor:send(tostring(self.name) .. " tells you, 'Hrm, yes.. you have been out")
            actor:send("</>fighting the Eldorian Guard.  I see from my records you have now given me")
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
                local faction = (actor:get_quest_var("black_legion:bl_faction") or 0) + 1
                actor:set_quest_var("black_legion", "bl_faction", faction)
                -- 
                -- slight bug for now the trigger code can't seem to evaluate negative numbers?
                -- 
                local faction2 = (actor:get_quest_var("black_legion:eg_faction") or 0) - 1
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
        if actor:get_quest_var("black_legion:" .. tostring(id_reward) .. "_reward") then
        else
            actor:set_quest_var("black_legion", tostring(id_reward) .. "_reward", 0)
        end
        local rewards = actor:get_quest_var("black_legion:" .. tostring(id_reward) .. "_reward")
        actor:set_quest_var("black_legion", tostring(id_reward) .. "_reward", rewards)
        if actor.alignment >= 151 then
            give_back()
            wait(0.2)
            actor:send(tostring(self.name) .. " tells you, 'You aren't quite evil enough for")
            actor:send("</>these rewards.'")
            return _return_value
        end
        if (actor:get_quest_var("black_legion:bl_faction") or 0) >= faction_required then
            local rewards = (actor:get_quest_var("black_legion:" .. tostring(id_reward) .. "_reward") or 0) + 1
            actor:set_quest_var("black_legion", tostring(id_reward) .. "_reward", rewards)
            wait(0.2)
            actor:send(tostring(self.name) .. " tells you, 'Ah yes, the Legion thanks you for")
            actor:send("</>your efforts.  Take this to aid you in your battles.'")
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
            if (actor:get_quest_var("black_legion:bl_faction") or 0) < 200 then
                -- 
                -- loop for faction award.
                -- 
                actor:send("<b:yellow>Your curry favor with the Black Legion!</>")
                actor:send("<b:red>You feel more hated by the Eldorian Guard!</>")
                local lap = 1
                while lap <= faction_multiplier do
                    local faction = (actor:get_quest_var("black_legion:bl_faction") or 0) + 1
                    actor:set_quest_var("black_legion", "bl_faction", faction)
                    -- 
                    -- slight bug for now the trigger code can't seem to evaluate negative numbers?
                    -- 
                    local faction2 = (actor:get_quest_var("black_legion:eg_faction") or 0) - 1
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
            give_back()
            wait(0.2)
            actor:send(tostring(self.name) .. " tells you, 'You aren't quite allied enough")
            actor:send("</>with our cause to earn that reward.'")
            return _return_value
        end
        -- end of if_gem section
    end
else
    -- Alignment not low enough or hasn't started the quest yet.
    give_back()
    wait(0.2)
    actor:send(tostring(self.name) .. " tells you, 'You aren't quite allied enough with")
    actor:send("</>our cause to earn our rewards.  You need a lower alignment or to start these")
    actor:send("</>quests by saying <b:white>[yes]</> or <b:white>[quest]</> or <b:white>[hello]</>.'")
end
return _return_value