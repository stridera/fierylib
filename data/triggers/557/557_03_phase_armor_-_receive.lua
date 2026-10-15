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
-- DG `%get.obj_shortdesc/noadesc/pldesc[VNUM]%` (legacy dg_scripts.cpp): VNUM = zone * 100 + id.
local function proto_short(vnum)
    vnum = tonumber(vnum)
    if not vnum then return "[no description for object ?]" end
    local name = objects.template(math.floor(vnum / 100), vnum % 100).name
    if name == nil or name == "" then return "[no description for object " .. vnum .. "]" end
    return name
end
local function without_article(s)
    for _, a in ipairs({"a pair ", "a ", "an ", "some ", "the "}) do
        if string.lower(string.sub(s, 1, #a)) == a then return string.sub(s, #a + 1) end
    end
    return s
end
local function proto_noa(vnum)
    return without_article(proto_short(vnum))
end
local function proto_plural(vnum)
    local s = proto_short(vnum)
    if string.lower(string.sub(s, 1, 5)) == "some " then
        return "quantities of " .. string.sub(s, 6)
    end
    local u = without_article(s)
    local last2, last1 = string.sub(u, -2, -2), string.sub(u, -1)
    local function consonant(c) return c:match("%a") ~= nil and not c:match("[aeiouAEIOU]") end
    if #u < 2 then return u .. "'s" end
    if last1 == "s" and last2 ~= "s" then return u end  -- already plural ("mittens")
    if (last2 == "e" or last2 == "i") and last1 == "z" then return u .. "zes" end
    if last1 == "x" or last1 == "z" or u:sub(-2) == "sh" or u:sub(-2) == "ss" or u:sub(-2) == "ch"
       or (consonant(last2) and last1 == "o") then
        return u .. "es"
    end
    if consonant(last2) and last1 == "y" then return u:sub(1, -2) .. "ies" end
    return u .. "s"
end
-- DG globals set on this mob by its init (LOAD) trigger, 557:10-39
local classes = self:getvar("classes")
local phase = self:getvar("phase")
local feet_gem = self:getvar("feet_gem")
local head_gem = self:getvar("head_gem")
local hands_gem = self:getvar("hands_gem")
local arms_gem = self:getvar("arms_gem")
local legs_gem = self:getvar("legs_gem")
local body_gem = self:getvar("body_gem")
local wrist_gem = self:getvar("wrist_gem")
local feet_armor = self:getvar("feet_armor")
local head_armor = self:getvar("head_armor")
local hands_armor = self:getvar("hands_armor")
local arms_armor = self:getvar("arms_armor")
local legs_armor = self:getvar("legs_armor")
local body_armor = self:getvar("body_armor")
local wrist_armor = self:getvar("wrist_armor")
local feet_reward = self:getvar("feet_reward")
local head_reward = self:getvar("head_reward")
local hands_reward = self:getvar("hands_reward")
local arms_reward = self:getvar("arms_reward")
local legs_reward = self:getvar("legs_reward")
local body_reward = self:getvar("body_reward")
local wrist_reward = self:getvar("wrist_reward")
if classes == nil or phase == nil then
    return true  -- the init trigger has not run for this mob
end
local _return_value = true  -- Default: allow action
-- The init trigger stores legacy vnums (zone * 100 + id); compare the
-- turned-in object the same way.
local object_id = (tonumber(object.zone_id) or 0) * 100 + (tonumber(object.local_id) or 0)
if object_id == hands_armor or object_id == hands_gem or object_id == feet_armor or object_id == feet_gem or object_id == wrist_armor or object_id == wrist_gem or object_id == head_armor or object_id == head_gem or object_id == arms_armor or object_id == arms_gem or object_id == legs_armor or object_id == legs_gem or object_id == body_armor or object_id == body_gem then
    local anti = "Anti-Paladin"
    if not actor or not actor.can_be_seen then
        self:command("peer")
        actor:send(tostring(self.name) .. " says, 'I can't help you if I can't see you.'")
        return false  -- legacy return 0: the giver keeps the item
    end
    if not string.find(string.lower(classes), actor.class, 1, true) or (classes == anti and actor.class == "paladin") then
        if string.find(classes, "and") then
            actor:send(tostring(self.name) .. " tells you, 'Sorry, this quest is for the " .. tostring(classes) .. " classes only.'")
        else
            actor:send(tostring(self.name) .. " tells you, 'Sorry, this quest is for the " .. tostring(classes) .. " class only.'")
        end
        return false  -- legacy return 0: the giver keeps the item
    elseif actor.level <= 20 * (phase - 1) then
        actor:send(tostring(self.name) .. " tells you, 'Sorry, why don't you come back when you've gained more experience?'")
        actor:send(tostring(self.name) .. " refuses your item.")
        return false  -- legacy return 0: the giver keeps the item
    elseif actor:get_quest_stage("phase_armor") < phase then
        actor:send(tostring(self.name) .. " tells you, 'I don't think you're ready for my armor quests yet.'")
        actor:send(tostring(self.name) .. " refuses your item.")
        return false  -- legacy return 0: the giver keeps the item
    end
    -- DG `case <armor>` falls through into `case <gem>`: both set the slot's
    -- multiplier and reward, only the armor sets `is_armor`.
    local is_armor, exp_x, reward_id
    local slot_table = {
        {hands_armor, hands_gem, 1, hands_reward},
        {feet_armor, feet_gem, 2, feet_reward},
        {wrist_armor, wrist_gem, 3, wrist_reward},
        {head_armor, head_gem, 4, head_reward},
        {arms_armor, arms_gem, 6, arms_reward},
        {legs_armor, legs_gem, 8, legs_reward},
        {body_armor, body_gem, 10, body_reward},
    }
    for _, sl in ipairs(slot_table) do
        if object_id == sl[1] then
            is_armor = 1
        end
        if object_id == sl[1] or object_id == sl[2] then
            exp_x = sl[3]
            reward_id = sl[4]
            break
        end
    end
    if is_armor then
        local armor_key = tostring(object_id) .. "_armor_acquired"
        local armor_count = actor:get_quest_var("phase_armor:" .. armor_key) or 0
        if armor_count < 1 then
            _return_value = false
            wait(0.1)
            world.destroy(object)
            armor_count = armor_count + 1
            actor:set_quest_var("phase_armor", armor_key, armor_count)
            actor:send(tostring(self.name) .. " tells you, 'Hey now, what have we here!?")
            actor:send("</>I've been looking for this for some time.")
            actor:send("</>You have now given me " .. proto_short(object_id) .. ".'")
        else
            self:command("eye " .. tostring(actor.name))
            actor:send(tostring(self.name) .. " tells you, 'Hey now, you've already given me one of these!'")
            actor:send(tostring(self.name) .. " refuses your item.")
            return false  -- legacy return 0: the giver keeps the item
        end
    else
        local gem_key = tostring(object_id) .. "_gems_acquired"
        local gem_count = actor:get_quest_var("phase_armor:" .. gem_key) or 0
        if gem_count < 3 then
            _return_value = false
            wait(0.1)
            world.destroy(object)
            gem_count = gem_count + 1
            actor:set_quest_var("phase_armor", gem_key, gem_count)
            actor:send(tostring(self.name) .. " tells you, 'Hey, very nice.'")
            wait(0.2)
            actor:send(tostring(self.name) .. " tells you, 'It is good to see that adventurers are out conquering the realm.'")
            wait(0.2)
            if gem_count == 1 then
                actor:send(tostring(self.name) .. " tells you, 'You have given me 1 " .. proto_noa(object_id) .. ".'")
            else
                actor:send(tostring(self.name) .. " tells you, 'You have given me " .. tostring(gem_count) .. " " .. proto_plural(object_id) .. ".'")
            end
        else
            self:command("eye " .. tostring(actor.name))
            actor:send(tostring(self.name) .. " tells you, 'Hey now, you've already given me " .. tostring(gem_count) .. " of these!'")
            actor:send(tostring(self.name) .. " refuses your item.")
            return false  -- legacy return 0: the giver keeps the item
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
       and ((actor:get_quest_var("phase_armor:" .. tostring(slot_gem_id) .. "_gems_acquired") or 0) == 3)
       and ((actor:get_quest_var("phase_armor:" .. tostring(slot_armor_id) .. "_armor_acquired") or 0) == 1) then
        wait(0.2)
        actor:send(tostring(self.name) .. " tells you, 'Excellent work, intrepid adventurer!")
        actor:send("</>You have provided me with all I need to reward you with:")
        actor:send("</>" .. proto_short(reward_id) .. "!'")
        wait(0.2)
        actor:send("<b:white>You gain experience!</>")
        local exp
        if actor.class == "warrior" or actor.class == "berserker" then
            exp = 7590
        elseif actor.class == "paladin" or actor.class == "anti-paladin" or actor.class == "ranger" then
            exp = 7935
        elseif actor.class == "sorcerer" or actor.class == "pyromancer" or actor.class == "cryomancer" or actor.class == "illusionist" or actor.class == "bard" then
            exp = 8280
        elseif actor.class == "necromancer" or actor.class == "monk" then
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