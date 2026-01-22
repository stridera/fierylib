-- Trigger: receive-rewards
-- Zone: 237, ID: 52
-- Type: MOB, Flags: RECEIVE
-- Status: NEEDS_REVIEW
--   Complex nesting: 40 if statements
--   Large script: 10470 chars
--
-- Original DG Script: #23752

-- Converted from DG Script #23752: receive-rewards
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
local accepted = 0
if object.id == 23721 then
    -- Received the heart
    local person = actor
    local i = person.group_size
    if i then
        local a = 1
    else
        local a = 0
    end
    while i >= a do
        local person = actor.group_member[a]
        if person.room == self.room then
            if person:get_quest_stage("vilekka_stew") == 1 then
                person.name:advance_quest("vilekka_stew")
                person:send("<b:white>You have advanced the quest!</>")
                local accepted = 1
            end
        elseif person and person.id == -1 then
            local i = i + 1
        end
        local a = a + 1
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
    end
end
if object.id == 23720 then
    -- Received the head
    local person = actor
    local i = person.group_size
    if i then
        local a = 1
    else
        local a = 0
    end
    while i >= a do
        local person = actor.group_member[a]
        if person.room == self.room then
            if person:get_quest_stage("vilekka_stew") == 3 then
                person.name:advance_quest("vilekka_stew")
                person:send("<b:white>You have advanced the quest!</>")
                local accepted = 1
                if not person:get_quest_var("hell_trident:helltask6") and person:get_quest_stage("hell_trident") == 1 then
                    person:set_quest_var("hell_trident", "helltask6", 1)
                    person:send("<magenta>You have successfully assisted " .. tostring(self.name) .. " in service of Lolth!</>")
                end
            end
        elseif person and person.id == -1 then
            local i = i + 1
        end
        local a = a + 1
    end
    if accepted then
        wait(1)
        self:destroy_item("all.head")
        actor:send(tostring(self.name) .. " says, 'You are quite resourceful!  This is a great benefit to the entire city.'")
        self:emote("places the severed head on the altar, where it lolls around.")
        wait(1)
        actor:send(tostring(self.name) .. " says, 'But your work may not yet be finished...  Do you wish to continue, or stop here?'")
        self.room:send("<b:white>All characters must choose individually.</>")
    end
end
local isspice = 0
if actor:get_quest_stage("vilekka_stew") == 5 then
    local num = object.id
    if num == 12552 then
        local accepted = 1
        local isspice = 1
    end
    if num == 49022 then
        local accepted = 1
        local isspice = 1
    end
    if num > 23749 then
        if num < 23761 then
            local accepted = 1
            local isspice = 1
        end
    end
    -- Make sure it's valid, and we haven't gotten it yet
    if accepted == 1 and actor.quest_variable[vilekka_stew:got_spice:num] == 1 then
        local accepted = 0
    end
    if accepted == 0 then
        _return_value = false
        self:emote("refuses to accept " .. tostring(object.shortdesc) .. ".")
        wait(1)
        if isspice == 1 then
            actor:send(tostring(self.name) .. " says, 'You have already given me " .. tostring(object.shortdesc) .. ".'")
        else
            actor:send(tostring(self.name) .. " says, 'What is this?  I need the spices!'")
        end
        return _return_value
    end
    wait(1)
    local num_spices = 1 + actor:get_quest_var("vilekka_stew:num_spices")
    actor.name:set_quest_var("vilekka_stew", "num_spices", num_spices)
    actor.name:set_quest_var("vilekka_stew", "got_spice:%num%", 1)
    if num_spices < 10 then
        self:destroy_item("herb")
        -- ok, here we have a way for the player to keep track
        -- of the number of spices he/she has given already
        if num_spices == 1 then
            actor:send(tostring(self.name) .. " says, 'Very good!  But I still need nine more.'")
        end
        if num_spices == 2 then
            self:command("lick")
            actor:send(tostring(self.name) .. " says, 'Eight more....'")
        end
        if num_spices == 3 then
            actor:send(tostring(self.name) .. " says, 'Seven more spices, and my stew will be perfect!'")
        end
        if num_spices == 4 then
            self:emote("is starting to look excited.")
            actor:send(tostring(self.name) .. " says, 'Six more!'")
        end
        if num_spices == 5 then
            self:command("grin")
            actor:send(tostring(self.name) .. " says, 'You're halfway there!  Five more!'")
        end
        if num_spices == 6 then
            self:emote("sniffs the spices carefully.")
            actor:send(tostring(self.name) .. " says, 'Yes!  Only four more!'")
        end
        if num_spices == 7 then
            actor:send(tostring(self.name) .. " says, 'Three more!  Give them to me!'")
        end
        if num_spices == 8 then
            self:emote("looks very excited now.")
            actor:send(tostring(self.name) .. " says, 'Two more spices!'")
        end
        if num_spices == 9 then
            actor:send(tostring(self.name) .. " says, 'One more!  Give it to me!'")
            -- k, I think that's all the spices and stuff
            -- now back to your regularly scheduled quest
        end
    end
    if num_spices >=10 then
        self:command("cackle")
        actor:send(tostring(self.name) .. " says, 'Most excellent!  Now I may complete the will of my Queen!'")
        wait(1)
        self:emote("puts all the ingredients for the nasty stew into a small bag.")
        self.room:send("A servant silently enters and bows.")
        self:emote("gives a small bag to the servant.")
        self.room:send("The servant leaves.")
        wait(1)
        actor:send(tostring(self.name) .. " says, 'Oh yes, your reward....'")
        if actor:get_quest_var("vilekka_stew:got_spice:23760") == 1 then
            if actor:get_quest_var("vilekka_stew:got_spice:23756") == 1 then
                -- saffron and salt
                self.room:spawn_object(237, 98)
                if actor.level < 60 then
                    local expcap = actor.level
                else
                    local expcap = 60
                end
            else
                -- Saffron and no salt
                self.room:spawn_object(237, 99)
                if actor.level < 85 then
                    local expcap = actor.level
                else
                    local expcap = 85
                end
            end
        else
            if actor:get_quest_var("vilekka_stew:got_spice:23756") == 1 then
                -- No Saffron and salt
                self.room:spawn_object(237, 96)
                if actor.level < 50 then
                    local expcap = actor.level
                else
                    local expcap = 50
                end
            else
                -- No Saffron and no salt
                self.room:spawn_object(237, 97)
                if actor.level < 55 then
                    local expcap = actor.level
                else
                    local expcap = 55
                end
            end
        end
        -- 
        -- Set X to the level of the award - code does not run without it
        -- 
        local expmod = 0
        if expcap < 9 then
            local expmod = (((expcap * expcap) + expcap) / 2) * 55
        elseif expcap < 17 then
            local expmod = 440 + ((expcap - 8) * 125)
        elseif expcap < 25 then
            local expmod = 1440 + ((expcap - 16) * 175)
        elseif expcap < 34 then
            local expmod = 2840 + ((expcap - 24) * 225)
        elseif expcap < 49 then
            local expmod = 4640 + ((expcap - 32) * 250)
        elseif expcap < 90 then
            local expmod = 8640 + ((expcap - 48) * 300)
        else
            local expmod = 20940 + ((expcap - 89) * 600)
        end
        -- 
        -- Adjust exp award by class so all classes receive the same proportionate amount
        -- 
        -- switch on actor.class
        if actor.class == "Warrior" or actor.class == "Berserker" then
            -- 
            -- 110% of standard
            -- 
            local expmod = (expmod + (expmod / 10))
        elseif actor.class == "Paladin" or actor.class == "Anti-Paladin" or actor.class == "Ranger" then
            -- 
            -- 115% of standard
            -- 
            local expmod = (expmod + ((expmod * 2) / 15))
        elseif actor.class == "Sorcerer" or actor.class == "Pyromancer" or actor.class == "Cryomancer" or actor.class == "Illusionist" or actor.class == "Bard" then
            -- 
            -- 120% of standard
            -- 
            local expmod = (expmod + (expmod / 5))
        elseif actor.class == "Necromancer" or actor.class == "Monk" then
            -- 
            -- 130% of standard
            -- 
            local expmod = (expmod + (expmod * 2) / 5)
        else
            local expmod = expmod
        end
        actor:send("<b:yellow>You gain experience!</>")
        local setexp = (expmod * 10)
        local loop = 0
        while loop < 10 do
            -- 
            -- Xexp must be replaced by mexp, oexp, or wexp for this code to work
            -- Pick depending on what is running the trigger
            -- 
            actor:award_exp(setexp)
            local loop = loop + 1
        end
        self:command("give boots " .. tostring(actor.name))
        wait(1)
        self:command("smile")
        actor:send(tostring(self.name) .. " says, 'Wear them proudly!'")
        actor.name:complete_quest("vilekka_stew")
    end
end
if accepted == 0 then
    _return_value = false
    actor:send(tostring(self.name) .. " haughtily refuses your gift.")
    self.room:send_except(actor, tostring(self.name) .. " refuses to accept " .. tostring(object.shortdesc) .. " from " .. tostring(actor.name) .. ".")
    wait(1)
    self:say("No thank you.")
    return _return_value
end