-- Trigger: Phase Armor - Receive
-- Zone: 557, ID: 3
-- Type: MOB, Flags: RECEIVE
--
-- The guildmaster accepts armor and gem turn-ins for the phase_armor
-- quest. Tracks per-slot progress in quest vars and rewards the
-- player when an armor + 3 matching gems have been collected.
--
-- Original DG Script: #55703

-- Converted from DG Script #55703: Phase Armor - Receive
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
-- TODO(parity): converter left every per-slot id comparison as a
-- string literal (e.g. `object.id == "%hands_armor%"`). They will
-- never match a real numeric object.id and the entire turn-in path
-- below is dead code until rewritten. Replace with comparisons
-- against the locals seeded by the LOAD trigger (e.g.
-- `object.id == hands_armor`) once it's confirmed whether stored
-- ids are local_id or composite (zone, id).
if object.id == hands_armor or object.id == hands_gem or object.id == feet_armor or object.id == feet_gem or object.id == wrist_armor or object.id == wrist_gem or object.id == head_armor or object.id == head_gem or object.id == arms_armor or object.id == arms_gem or object.id == legs_armor or object.id == legs_gem or object.id == body_armor or object.id == body_gem then
    local anti = "Anti-Paladin"
    if not actor or not actor.can_be_seen then
        _return_value = true
        self:command("peer")
        actor:send(tostring(self.name) .. " says, 'I can't help you if I can't see you.'")
        return _return_value
    end
    if not string.find(classes, actor.class) or (classes == anti and actor.class == "Paladin") then
        _return_value = true
        if string.find(classes, "and") then
            actor:send(tostring(self.name) .. " tells you, 'Sorry, this quest is for the " .. tostring(classes) .. " classes only.'")
        else
            actor:send(tostring(self.name) .. " tells you, 'Sorry, this quest is for the " .. tostring(classes) .. " class only.'")
        end
        return _return_value
    elseif actor.level <= 20 * (phase - 1) then
        _return_value = true
        actor:send(tostring(self.name) .. " tells you, 'Sorry, why don't you come back when you've gained more experience?'")
        actor:send(tostring(self.name) .. " refuses your item.")
        return _return_value
    elseif actor:get_quest_stage("phase_armor") < phase then
        _return_value = true
        actor:send(tostring(self.name) .. " tells you, 'I don't think you're ready for my armor quests yet.'")
        actor:send(tostring(self.name) .. " refuses your item.")
        return _return_value
    end
    local object_id = object.id
    local is_armor, exp_x, reward_id
    if object_id == hands_armor then
        is_armor = 1
    elseif object_id == hands_gem then
        exp_x = 1
        reward_id = hands_reward
    elseif object_id == feet_armor then
        is_armor = 1
    elseif object_id == feet_gem then
        exp_x = 2
        reward_id = feet_reward
    elseif object_id == wrist_armor then
        is_armor = 1
    elseif object_id == wrist_gem then
        exp_x = 3
        reward_id = wrist_reward
    elseif object_id == head_armor then
        is_armor = 1
    elseif object_id == head_gem then
        exp_x = 4
        reward_id = head_reward
    elseif object_id == arms_armor then
        is_armor = 1
    elseif object_id == arms_gem then
        exp_x = 6
        reward_id = arms_reward
    elseif object_id == legs_armor then
        is_armor = 1
    elseif object_id == legs_gem then
        exp_x = 8
        reward_id = legs_reward
    elseif object_id == body_armor then
        is_armor = 1
    elseif object_id == body_gem then
        exp_x = 10
        reward_id = body_reward
    end
    -- TODO(parity): DG `%get.obj_*[%object_id%]%` placeholders below
    -- are emitted as literal text. Substitute via
    -- `objects.template(zone, id).name` once the per-slot ids are
    -- promoted to (zone, local_id) tuples.
    if is_armor then
        local armor_key = tostring(object_id) .. "_armor_acquired"
        local armor_count = actor:get_quest_var("phase_armor:" .. armor_key) or 0
        if armor_count < 1 then
            _return_value = false
            wait(1)
            world.destroy(object)
            armor_count = armor_count + 1
            actor:set_quest_var("phase_armor", armor_key, armor_count)
            actor:send(tostring(self.name) .. " tells you, 'Hey now, what have we here!?")
            actor:send("</>I've been looking for this for some time.")
            actor:send("</>You have now given me " .. "%get.obj_shortdesc[%object_id%]%.'")
        else
            _return_value = true
            wait(2)
            self:command("eye " .. tostring(actor.name))
            actor:send(tostring(self.name) .. " tells you, 'Hey now, you've already given me one of these!'")
            actor:send(tostring(self.name) .. " refuses your item.")
            return _return_value
        end
    else
        local gem_key = tostring(object_id) .. "_gems_acquired"
        local gem_count = actor:get_quest_var("phase_armor:" .. gem_key) or 0
        if gem_count < 3 then
            _return_value = false
            wait(1)
            world.destroy(object)
            gem_count = gem_count + 1
            actor:set_quest_var("phase_armor", gem_key, gem_count)
            actor:send(tostring(self.name) .. " tells you, 'Hey, very nice.'")
            wait(2)
            actor:send(tostring(self.name) .. " tells you, 'It is good to see that adventurers are out conquering the realm.'")
            wait(2)
            if gem_count == 1 then
                actor:send(tostring(self.name) .. " tells you, 'You have given me 1 " .. "%get.obj_noadesc[%object_id%]%.'")
            else
                actor:send(tostring(self.name) .. " tells you, 'You have given me " .. tostring(gem_count) .. " " .. "%get.obj_pldesc[%object_id%]%.'")
            end
        else
            _return_value = true
            wait(1)
            self:command("eye " .. tostring(actor.name))
            actor:send(tostring(self.name) .. " tells you, 'Hey now, you've already given me " .. tostring(gem_count) .. " of these!'")
            actor:send(tostring(self.name) .. " refuses your item.")
            return _return_value
        end
    end
    --
    -- Check to see if the quest is complete and if the reward can be given.
    -- The original DG looked up `<gem_id>_gems_acquired` and
    -- `<armor_id>_armor_acquired`; we mirror that using the same
    -- `<id>_..._acquired` keying pattern used above. Per-slot pairing
    -- is derived from whichever gem/armor slot matches `object_id`.
    --
    local function _slot_for(oid)
        if oid == hands_armor or oid == hands_gem then return hands_armor, hands_gem end
        if oid == feet_armor  or oid == feet_gem  then return feet_armor,  feet_gem  end
        if oid == wrist_armor or oid == wrist_gem then return wrist_armor, wrist_gem end
        if oid == head_armor  or oid == head_gem  then return head_armor,  head_gem  end
        if oid == arms_armor  or oid == arms_gem  then return arms_armor,  arms_gem  end
        if oid == legs_armor  or oid == legs_gem  then return legs_armor,  legs_gem  end
        if oid == body_armor  or oid == body_gem  then return body_armor,  body_gem  end
    end
    local slot_armor_id, slot_gem_id = _slot_for(object_id)
    if slot_armor_id
       and (actor:get_quest_var("phase_armor:" .. tostring(slot_gem_id) .. "_gems_acquired") == 3)
       and (actor:get_quest_var("phase_armor:" .. tostring(slot_armor_id) .. "_armor_acquired") == 1) then
        wait(2)
        actor:send(tostring(self.name) .. " tells you, 'Excellent work, intrepid adventurer!")
        actor:send("</>You have provided me with all I need to reward you with:")
        actor:send("</>" .. "%get.obj_shortdesc[%reward_id%]%!'")
        wait(2)
        actor:send("<b:white>You gain experience!</>")
        local exp
        if actor.class == "Warrior" or actor.class == "Berserker" then
            exp = 7590
        elseif actor.class == "Paladin" or actor.class == "Anti-Paladin" or actor.class == "Ranger" then
            exp = 7935
        elseif actor.class == "Sorcerer" or actor.class == "Pyromancer" or actor.class == "Cryomancer" or actor.class == "Illusionist" or actor.class == "Bard" then
            exp = 8280
        elseif actor.class == "Necromancer" or actor.class == "Monk" then
            exp = 8970
        else
            exp = 6900
        end
        if phase == 2 then
            exp = math.floor(exp * 608 / 100)
        elseif phase == 3 then
            exp = math.floor(exp * 1340 / 100)
        end
        local lap = 1
        while lap <= exp_x do
            actor:award_exp(exp)
            lap = lap + 1
        end
        self.room:spawn_object(math.floor(reward_id / 100), reward_id % 100)
        self:command("give all " .. tostring(actor.name))
        self:command("drop all")
        actor:save()
    end
end  -- auto-close block
return _return_value