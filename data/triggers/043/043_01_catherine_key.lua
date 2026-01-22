-- Trigger: catherine_key
-- Zone: 43, ID: 1
-- Type: MOB, Flags: RECEIVE
-- Status: NEEDS_REVIEW
--   Complex nesting: 16 if statements
--
-- Original DG Script: #4301

-- Converted from DG Script #4301: catherine_key
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
self:set_flag("sentinel", true)
if actor:get_quest_stage("theatre") >= 1 then
    if object.id == 4351 then
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
                if person:get_quest_stage("theatre") >= 1 and not person:get_quest_var("theatre:lashes") then
                    person:set_quest_var("theatre", "lashes", 1)
                    if person:get_quest_stage("theatre") == 1 then
                        person:send("<b:white>You have helped return Catherine's eyelashes.</>")
                    end
                    local accept_lashes = 1
                end
            elseif person then
                local i = i + 1
            end
            local a = a + 1
        end
        if not accept_lashes then
            local refuse = "lashes"
        else
            wait(2)
            self:say("Thank you so much!")
            wait(1)
            self:command("sit")
            self:command("wear eyelashes")
            self:emote("flutters her eyelids a few times.")
            wait(2)
            self:command("stand")
            wait(2)
            self:say("Finally!  Now if I could just have my dressing room key back too please...")
        end
    elseif object.id == 4303 then
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
                if person:get_quest_stage("theatre") >= 1 and person:get_quest_var("theatre:lashes") == 1 then
                    if person:get_quest_stage("theatre") == 1 then
                        person:advance_quest("theatre")
                        person:send("<b:white>You have advanced the quest!</>")
                    end
                    person:set_quest_var("theatre", "lashes", 0)
                    local accept_key = 1
                end
            elseif person then
                local i = i + 1
            end
            local a = a + 1
        end
        if not accept_key then
            wait(2)
            self.room:send(tostring(self.name) .. " makes a weird, embarrassed face.")
            wait(1)
            self:say("Can you be a dear and bring me my eyelashes first?")
            wait(1)
            self:say("Thaaaaaaanks!")
            self:command("give key " .. tostring(actor.name))
        else
            wait(2)
            self:emote("looks incredibly relieved.")
            self:say("I can't believe those monkeys made off with my key but not my costumes.")
            wait(2)
            self:command("shrug")
            self:say("It's the little things I guess.")
            wait(1)
            self:say("Oh!  I think Lewis's key got locked in my dressing room...")
            get_room(43, 51):at(function()
                run_room_trigger(4365)
            end)
            wait(2)
            self:say("He might want that back.")
            wait(3)
            self:say("Now, if only I could find my shoes...")
            self:emote("trails off and wanders away.")
        end
    else
        local refuse = "item"
    end
else
    local refuse = "person"
end
if refuse then
    _return_value = false
    if refuse == "lashes" then
        self.room:send(tostring(self.name) .. " blinks in confusion.")
        wait(2)
        self:say("N...o?  You already gave me my eyelashes.")
        actor:send(tostring(self.name) .. " slowly pushes the eyelashes back to you.")
        wait(2)
        self.room:send_except(actor, tostring(self.name) .. " slowly pushes the eyelashes back to " .. tostring(actor.name) .. ".")
    elseif refuse == "item" then
        self.room:send("A confused look crosses Catherine's face as she refuses " .. tostring(object.shortdesc) .. ".")
        wait(2)
        self:say("This isn't what I was looking for!")
        wait(1)
        self:say("Please help me or I'll miss my cue!")
    elseif refuse == "person" then
        self.room:send(tostring(self.name) .. " looks at " .. tostring(object.shortdesc) .. " with confusion.")
        wait(2)
        self:say("Ummm, what is that?")
        wait(1)
        self.room:send_except(actor, tostring(self.name) .. " looks at " .. tostring(actor.name) .. " with confusion.")
        actor:send(tostring(self.name) .. " looks at you with confusion.")
        wait(2)
        self:say("I'm sorry, who are you?")
    end
end
self:set_flag("sentinel", false)
return _return_value