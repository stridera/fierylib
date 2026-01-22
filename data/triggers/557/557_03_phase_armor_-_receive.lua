-- Trigger: Phase Armor - Receive
-- Zone: 557, ID: 3
-- Type: MOB, Flags: RECEIVE
-- Status: NEEDS_REVIEW
--   Complex nesting: 17 if statements
--   Large script: 8327 chars
--
-- Original DG Script: #55703

-- Converted from DG Script #55703: Phase Armor - Receive
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
-- switch on object.id
if object.id == "%hands_armor%" or object.id == "%hands_gem%" or object.id == "%feet_armor%" or object.id == "%feet_gem%" or object.id == "%wrist_armor%" or object.id == "%wrist_gem%" or object.id == "%head_armor%" or object.id == "%head_gem%" or object.id == "%arms_armor%" or object.id == "%arms_gem%" or object.id == "%legs_armor%" or object.id == "%legs_gem%" or object.id == "%body_armor%" or object.id == "%body_gem%" then
    local anti = "Anti-Paladin"
    if not actor or not actor.can_be_seen then
        _return_value = false
        self:command("peer")
        actor:send(tostring(self.name) .. " says, 'I can't help you if I can't see you.'")
        return _return_value
    end
    if not (string.find(classes, "actor.class")) or (classes == "anti" and actor.class == "Paladin") then
        _return_value = false
        if string.find(classes, "and") then
            actor:send(tostring(self.name) .. " tells you, 'Sorry, this quest is for the " .. tostring(classes) .. " classes only.'")
        else
            actor:send(tostring(self.name) .. " tells you, 'Sorry, this quest is for the " .. tostring(classes) .. " class only.'")
        end
        return _return_value
    elseif actor.level <= 20 * (phase - 1) then
        _return_value = false
        actor:send(tostring(self.name) .. " tells you, 'Sorry, why don't you come back when you've gained more experience?'")
        actor:send(tostring(self.name) .. " refuses your item.")
        return _return_value
    elseif actor:get_quest_stage("phase_armor") < phase then
        _return_value = false
        actor:send(tostring(self.name) .. " tells you, 'I don't think you're ready for my armor quests yet.'")
        actor:send(tostring(self.name) .. " refuses your item.")
        return _return_value
    end
    local object_vnum = object.id
    -- switch on object_vnum
    if object_vnum == "%hands_armor%" then
        local is_armor = 1
    elseif object_vnum == "%hands_gem%" then
        local exp_x = 1
        local armor_vnum = hands_armor
        local gem_vnum = hands_gem
        local reward_vnum = hands_reward
    elseif object_vnum == "%feet_armor%" then
        local is_armor = 1
    elseif object_vnum == "%feet_gem%" then
        local exp_x = 2
        local armor_vnum = feet_armor
        local gem_vnum = feet_gem
        local reward_vnum = feet_reward
    elseif object_vnum == "%wrist_armor%" then
        local is_armor = 1
    elseif object_vnum == "%wrist_gem%" then
        local exp_x = 3
        local armor_vnum = wrist_armor
        local gem_vnum = wrist_gem
        local reward_vnum = wrist_reward
    elseif object_vnum == "%head_armor%" then
        local is_armor = 1
    elseif object_vnum == "%head_gem%" then
        local exp_x = 4
        local armor_vnum = head_armor
        local gem_vnum = head_gem
        local reward_vnum = head_reward
    elseif object_vnum == "%arms_armor%" then
        local is_armor = 1
    elseif object_vnum == "%arms_gem%" then
        local exp_x = 6
        local armor_vnum = arms_armor
        local gem_vnum = arms_gem
        local reward_vnum = arms_reward
    elseif object_vnum == "%legs_armor%" then
        local is_armor = 1
    elseif object_vnum == "%legs_gem%" then
        local exp_x = 8
        local armor_vnum = legs_armor
        local gem_vnum = legs_gem
        local reward_vnum = legs_reward
    elseif object_vnum == "%body_armor%" then
        local is_armor = 1
    elseif object_vnum == "%body_gem%" then
        local exp_x = 10
        local armor_vnum = body_armor
        local gem_vnum = body_gem
        local reward_vnum = body_reward
    end
    if is_armor then
        if not actor:get_quest_var("phase_armor:" .. object_vnum .. "_armor_acquired") then
            actor:set_quest_var("phase_armor", object_vnum .. "_armor_acquired", 0)
        end
        local armor_count = actor:get_quest_var("phase_armor:" .. object_vnum .. "_armor_acquired")
        if armor_count < 1 then
            _return_value = true
            wait(1)
            world.destroy(object.name)
            local armor_count = armor_count + 1
            actor:set_quest_var("phase_armor", object_vnum .. "_armor_acquired", armor_count)
            actor:send(tostring(self.name) .. " tells you, 'Hey now, what have we here!?")
            actor:send("</>I've been looking for this for some time.")
            actor:send("</>You have now given me " .. "%get.obj_shortdesc[%object_vnum%]%.'")
        else
            _return_value = false
            wait(2)
            self:command("eye " .. tostring(actor.name))
            actor:send(tostring(self.name) .. " tells you, 'Hey now, you've already given me one of these!'")
            actor:send(tostring(self.name) .. " refuses your item.")
            return _return_value
        end
    else
        if not actor:get_quest_var("phase_armor:" .. object_vnum .. "_gems_acquired") then
            actor:set_quest_var("phase_armor", object_vnum .. "_gems_acquired", 0)
        end
        local gem_count = actor:get_quest_var("phase_armor:" .. object_vnum .. "_gems_acquired")
        if gem_count < 3 then
            _return_value = true
            wait(1)
            world.destroy(object.name)
            local gem_count = gem_count + 1
            actor:set_quest_var("phase_armor", object_vnum .. "_gems_acquired", gem_count)
            actor:send(tostring(self.name) .. " tells you, 'Hey, very nice.'")
            wait(2)
            actor:send(tostring(self.name) .. " tells you, 'It is good to see that adventurers are out conquering the realm.'")
            wait(2)
            if gem_count == 1 then
                actor:send(tostring(self.name) .. " tells you, 'You have given me 1 " .. "%get.obj_noadesc[%object_vnum%]%.'")
            else
                actor:send(tostring(self.name) .. " tells you, 'You have given me " .. tostring(gem_count) .. " " .. "%get.obj_pldesc[%object_vnum%]%.'")
            end
        else
            _return_value = false
            wait(1)
            self:command("eye " .. tostring(actor.name))
            actor:send(tostring(self.name) .. " tells you, 'Hey now, you've already given me " .. tostring(gem_count) .. " of these!'")
            actor:send(tostring(self.name) .. " refuses your item.")
            return _return_value
        end
    end
    -- 
    -- Check to see if the quest is complete and if the reward can be given.
    -- 
    if (actor:get_quest_var("phase_armor:" .. gem_vnum .. "_gems_acquired") == 3) and (actor:get_quest_var("phase_armor:" .. armor_vnum .. "_armor_acquired") == 1) then
        wait(2)
        actor:send(tostring(self.name) .. " tells you, 'Excellent work, intrepid adventurer!")
        actor:send("</>You have provided me with all I need to reward you with:")
        actor:send("</>" .. "%get.obj_shortdesc[%reward_vnum%]%!'")
        wait(2)
        actor:send("<b:white>You gain experience!</>")
        -- switch on actor.class
        if actor.class == "Warrior" or actor.class == "Berserker" then
            local exp = 7590
        elseif actor.class == "Paladin" or actor.class == "Anti-Paladin" or actor.class == "Ranger" then
            local exp = 7935
        elseif actor.class == "Sorcerer" or actor.class == "Pyromancer" or actor.class == "Cryomancer" or actor.class == "Illusionist" or actor.class == "Bard" then
            local exp = 8280
        elseif actor.class == "Necromancer" or actor.class == "Monk" then
            local exp = 8970
        else
            local exp = 6900
        end
        if phase == 2 then
            -- eval exp (%exp% * 433) / 100
            local exp = (exp * 608) / 100
        elseif phase == 3 then
            -- eval exp (%exp% * 870) / 100
            local exp = (exp * 1340) / 100
        end
        local lap = 1
        while lap <= exp_x do
            actor:award_exp(exp)
            local lap = lap + 1
        end
        self.room:spawn_object(vnum_to_zone(reward_vnum), vnum_to_local(reward_vnum))
        self:command("give all " .. tostring(actor.name))
        self:command("drop all")
        actor:save()
    end
end  -- auto-close block
return _return_value