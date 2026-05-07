-- Trigger: receive-rewards
-- Zone: 237, ID: 52
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #23752

-- Converted from DG Script #23752: receive-rewards
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
-- Vilekka receives the heart (stage 1 -> 2), the drider king's head
-- (stage 3 -> 4), or the ten herbs/spices (stage 5 completion).

-- Helper: is this object one of the accepted spices for stage 5?
-- Returns the canonical spice key (string) or nil.
local function spice_key(obj)
    local z, id = obj.zone_id, obj.local_id
    if z == 125 and id == 52 then return "12552" end
    if z == 490 and id == 22 then return "49022" end
    if z == 237 and id >= 50 and id <= 60 then
        return tostring(23700 + id)
    end
    return nil
end

local accepted = false

-- Stage 1 -> 2: drow master's heart (object 237/21).
if object.zone_id == 237 and object.local_id == 21 then
    for _, person in ipairs(actor.group) do
        if person.room == self.room and person:get_quest_stage("vilekka_stew") == 1 then
            person:advance_quest("vilekka_stew")
            person:send("<b:white>You have advanced the quest!</>")
            accepted = true
        end
    end
    if accepted then
        wait(1)
        self:destroy_item("all.heart")
        self:say("Excellent!")
        wait(1)
        self.room:send("The High Priestess takes the heart and places it gently on the altar.")
        self:command("smirk")
        wait(1)
        self:say("You have done me and my city a great service!  Do you wish to continue or stop now?")
        self:command("tap")
        self.room:send("<b:white>All characters must choose individually.</>")
        return true
    end
end

-- Stage 3 -> 4: drider king's head (object 237/20).
if object.zone_id == 237 and object.local_id == 20 then
    for _, person in ipairs(actor.group) do
        if person.room == self.room and person:get_quest_stage("vilekka_stew") == 3 then
            person:advance_quest("vilekka_stew")
            person:send("<b:white>You have advanced the quest!</>")
            accepted = true
            -- Cross-quest credit for hell_trident.
            if not person:get_quest_var("hell_trident:helltask6")
                and person:get_quest_stage("hell_trident") == 1 then
                person:set_quest_var("hell_trident", "helltask6", 1)
                person:send("<magenta>You have successfully assisted " .. tostring(self.name) .. " in service of Lolth!</>")
            end
        end
    end
    if accepted then
        wait(1)
        self:destroy_item("all.head")
        actor:send(tostring(self.name) .. " says, 'You are quite resourceful!  This is a great benefit to the entire city.'")
        self:emote("places the severed head on the altar, where it lolls around.")
        wait(1)
        actor:send(tostring(self.name) .. " says, 'But your work may not yet be finished...  Do you wish to continue, or stop here?'")
        self.room:send("<b:white>All characters must choose individually.</>")
        return true
    end
end

-- Stage 5: spices and herbs.
if actor:get_quest_stage("vilekka_stew") == 5 then
    local key = spice_key(object)
    local is_spice = key ~= nil
    -- Reject duplicates.
    local already_given = key
        and actor:get_quest_var("vilekka_stew:got_spice:" .. key) == 1
    if (not is_spice) or already_given then
        self:emote("refuses to accept " .. tostring(object.shortdesc) .. ".")
        wait(1)
        if is_spice then
            actor:send(tostring(self.name) .. " says, 'You have already given me " .. tostring(object.shortdesc) .. ".'")
        else
            actor:send(tostring(self.name) .. " says, 'What is this?  I need the spices!'")
        end
        return true
    end
    wait(1)
    local num_spices = 1 + (actor:get_quest_var("vilekka_stew:num_spices") or 0)
    actor:set_quest_var("vilekka_stew", "num_spices", num_spices)
    actor:set_quest_var("vilekka_stew", "got_spice:" .. key, 1)
    accepted = true
    if num_spices < 10 then
        self:destroy_item("herb")
        -- Per-spice progress acknowledgement.
        if num_spices == 1 then
            actor:send(tostring(self.name) .. " says, 'Very good!  But I still need nine more.'")
        elseif num_spices == 2 then
            self:command("lick")
            actor:send(tostring(self.name) .. " says, 'Eight more....'")
        elseif num_spices == 3 then
            actor:send(tostring(self.name) .. " says, 'Seven more spices, and my stew will be perfect!'")
        elseif num_spices == 4 then
            self:emote("is starting to look excited.")
            actor:send(tostring(self.name) .. " says, 'Six more!'")
        elseif num_spices == 5 then
            self:command("grin")
            actor:send(tostring(self.name) .. " says, 'You're halfway there!  Five more!'")
        elseif num_spices == 6 then
            self:emote("sniffs the spices carefully.")
            actor:send(tostring(self.name) .. " says, 'Yes!  Only four more!'")
        elseif num_spices == 7 then
            actor:send(tostring(self.name) .. " says, 'Three more!  Give them to me!'")
        elseif num_spices == 8 then
            self:emote("looks very excited now.")
            actor:send(tostring(self.name) .. " says, 'Two more spices!'")
        elseif num_spices == 9 then
            actor:send(tostring(self.name) .. " says, 'One more!  Give it to me!'")
        end
        return true
    end

    -- num_spices >= 10: complete the quest.
    self:command("cackle")
    actor:send(tostring(self.name) .. " says, 'Most excellent!  Now I may complete the will of my Queen!'")
    wait(1)
    self:emote("puts all the ingredients for the nasty stew into a small bag.")
    self.room:send("A servant silently enters and bows.")
    self:emote("gives a small bag to the servant.")
    self.room:send("The servant leaves.")
    wait(1)
    actor:send(tostring(self.name) .. " says, 'Oh yes, your reward....'")
    -- Reward boots depend on whether saffron (23760) and salt (23756) were
    -- among the ten spices delivered.
    local has_saffron = actor:get_quest_var("vilekka_stew:got_spice:23760") == 1
    local has_salt = actor:get_quest_var("vilekka_stew:got_spice:23756") == 1
    local expcap
    if has_saffron and has_salt then
        self.room:spawn_object(237, 98)
        expcap = math.min(actor.level, 60)
    elseif has_saffron then
        self.room:spawn_object(237, 99)
        expcap = math.min(actor.level, 85)
    elseif has_salt then
        self.room:spawn_object(237, 96)
        expcap = math.min(actor.level, 50)
    else
        self.room:spawn_object(237, 97)
        expcap = math.min(actor.level, 55)
    end

    local expmod
    if expcap < 9 then
        expmod = (((expcap * expcap) + expcap) / 2) * 55
    elseif expcap < 17 then
        expmod = 440 + ((expcap - 8) * 125)
    elseif expcap < 25 then
        expmod = 1440 + ((expcap - 16) * 175)
    elseif expcap < 34 then
        expmod = 2840 + ((expcap - 24) * 225)
    elseif expcap < 49 then
        expmod = 4640 + ((expcap - 32) * 250)
    elseif expcap < 90 then
        expmod = 8640 + ((expcap - 48) * 300)
    else
        expmod = 20940 + ((expcap - 89) * 600)
    end

    -- Class proportional adjustment.
    if actor.class == "Warrior" or actor.class == "Berserker" then
        -- 110% of standard
        expmod = expmod + (expmod / 10)
    elseif actor.class == "Paladin" or actor.class == "Anti-Paladin" or actor.class == "Ranger" then
        -- 115% of standard
        expmod = expmod + ((expmod * 2) / 15)
    elseif actor.class == "Sorcerer" or actor.class == "Pyromancer" or actor.class == "Cryomancer" or actor.class == "Illusionist" or actor.class == "Bard" then
        -- 120% of standard
        expmod = expmod + (expmod / 5)
    elseif actor.class == "Necromancer" or actor.class == "Monk" then
        -- 130% of standard
        expmod = expmod + ((expmod * 2) / 5)
    end

    actor:send("<b:yellow>You gain experience!</>")
    local setexp = expmod * 10
    for _ = 1, 10 do
        actor:award_exp(setexp)
    end
    self:command("give boots " .. tostring(actor.name))
    wait(1)
    self:command("smile")
    actor:send(tostring(self.name) .. " says, 'Wear them proudly!'")
    actor:complete_quest("vilekka_stew")
    return true
end

if not accepted then
    actor:send(tostring(self.name) .. " haughtily refuses your gift.")
    self.room:send_except(actor, tostring(self.name) .. " refuses to accept " .. tostring(object.shortdesc) .. " from " .. tostring(actor.name) .. ".")
    wait(1)
    self:say("No thank you.")
end
return true
