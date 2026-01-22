-- Trigger: Wise leprechaun receiving goodies
-- Zone: 615, ID: 24
-- Type: MOB, Flags: RECEIVE
-- Status: NEEDS_REVIEW
--   Complex nesting: 15 if statements
--   Large script: 8736 chars
--
-- Original DG Script: #61524

-- Converted from DG Script #61524: Wise leprechaun receiving goodies
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
-- switch on object.id
if object.id == 61501 or object.id == 12001 or object.id == 146 or object.id == 147 then
    wait(4)
    self:emote("sniffs " .. tostring(object.shortdesc) .. " carefully.")
    wait(1)
    self:emote("munches heartily on " .. tostring(object.shortdesc) .. ", juice running down his cheeks.")
    world.destroy(object.name)
    if actor.gender == "male" then
        self:say("Why thank you, good sir!")
    else
        self:say("Why thank you, my dear!")
    end
    wait(1)
    self:say("But that's not my favorite fruit is it, oh no.")
elseif object.id == 61502 then
    -- spotted apple
    wait(8)
    self:emote("turns " .. tostring(object.shortdesc) .. " over and peers at it thoughtfully.")
    wait(1)
    self:emote("swiftly eats " .. tostring(object.shortdesc) .. " with loud chewing noises.")
    world.destroy(object.name)
    if actor.gender == "female" then
        self:say("Well that was nice, wasn't it my darling?")
    else
        self:say("Well that was nice, wasn't it my boy?")
    end
    wait(1)
    self:say("But it just isn't what I'm looking for.")
    wait(4)
    self:command("sigh")
elseif object.id == 61503 then
    -- This is the wizened apple.
    wait(8)
    self:emote("stares daggers at " .. tostring(object.shortdesc) .. ", as if he'd been handed a spider.")
    wait(1)
    self:emote("angrily hurls " .. tostring(object.shortdesc) .. " off into the bushes!")
    world.destroy(object.name)
    wait(4)
    if actor.gender == "female" then
        self:say("Well now what's the big idea, lassie?")
    elseif actor.gender == "male" then
        self:say("Well now what's the big idea, laddie?")
    else
        self:say("Well now what's the big idea?")
    end
    wait(4)
    self.room:send(tostring(self.name) .. " says, 'That was an insult of a fruit, if ever there was one!'")
elseif object.id == 61551 then
    wait(8)
    self:emote("gazes lovingly at " .. tostring(object.shortdesc) .. ".")
    wait(1)
    if got_cherry == 1 then
        self.room:send(tostring(self.name) .. " says, 'I've already had one of these... but I can't turn them down!'")
    end
    wait(4)
    local got_cherry = 1
    globals.got_cherry = globals.got_cherry or true
    self:emote("happily pops " .. tostring(object.shortdesc) .. " into his mouth and chews gleefully!")
    wait(8)
    world.destroy(object.name)
    self.room:send(tostring(self.name) .. " says, '" .. tostring(actor.name) .. ", I thank you from the bottom of my heart.'")
    wait(1)
    self:say("That was a rare treat.")
    wait(2)
    -- (empty say)
    self.room:send(tostring(self.name) .. " says, 'Alright then, hand me a knife and I'll enchant it for ye.'")
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
            if person:get_quest_stage("enchanted_hollow_quest") == 0 then
                person.name:start_quest("enchanted_hollow_quest")
            end
            person.name:set_quest_var("enchanted_hollow_quest", "got_cherry", 1)
        elseif person then
            local i = i + 1
        end
        local a = a + 1
    end
    if got_cherry then
    elseif object.id == 61506 then
        got_cherry = nil
    end
    if actor:get_quest_var("enchanted_hollow_quest:got_cherry") == 1 then
        wait(8)
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
                if person:get_quest_stage("enchanted_hollow_quest") == 0 then
                    person.name:start_quest("enchanted_hollow_quest")
                end
                person.name:set_quest_var("enchanted_hollow_quest", "got_cherry", 0)
            elseif person then
                local i = i + 1
            end
            local a = a + 1
        end
        self:say("Well now!  I suppose I owe you an enchantment!")
        wait(4)
        self:emote("turns and thrusts " .. tostring(object.shortdesc) .. " into the earth.")
        wait(2)
        self:emote("says a few magical words, then touches " .. tostring(object.shortdesc) .. " on the hilt.")
        wait(4)
        world.destroy(object.name)
        self:emote("pulls an emblazoned flint knife out of the ground.")
        self.room:spawn_object(615, 5)
        wait(2)
        self:command("give emblazoned-flint-knife " .. tostring(actor.name))
        wait(1)
        self.room:send(tostring(self.name) .. " says, 'If you see a web, just drop this nearby it.  I've given it an innate hatred of webs, you'll see!'")
    else
        _return_value = false
        self.room:send_except(actor, tostring(actor.name) .. " gives " .. tostring(object.shortdesc) .. " to " .. tostring(self.name) .. ".")
        actor:send("You give " .. tostring(object.shortdesc) .. " to " .. tostring(self.name) .. ".")
        wait(8)
        self:say("Eh?  What have you done for me lately?")
        wait(2)
        self.room:send(tostring(self.name) .. " gives " .. tostring(object.shortdesc) .. " back.")
    end
elseif object.id == 61504 then
    _return_value = true
    wait(8)
    self:emote("quickly shields his eyes from " .. tostring(object.shortdesc) .. "'s intense glow.")
    self:say("Ach!  Are you trying to blind me?")
    wait(8)
    self:command("drop " .. tostring(object.name))
elseif object.id == 61505 then
    _return_value = false
    self.room:send_except(actor, tostring(actor.name) .. " gives " .. tostring(object.shortdesc) .. " to " .. tostring(self.name) .. ".")
    actor:send("You give " .. tostring(object.shortdesc) .. " to " .. tostring(self.name) .. ".")
    wait(8)
    self:say("What, not good enough for ye is it?  Well I'm afraid it'll have to do!'")
    wait(12)
    actor:send(tostring(self.name) .. " returns " .. tostring(object.shortdesc) .. " to you.")
    self.room:send_except(actor, tostring(self.name) .. " returns " .. tostring(object.shortdesc) .. " to " .. tostring(actor.name) .. ".")
elseif object.id == 55755 then
    -- dried fruit
    _return_value = false
    self.room:send_except(actor, tostring(actor.name) .. " gives " .. tostring(object.shortdesc) .. " to " .. tostring(self.name) .. ".")
    actor:send("You give " .. tostring(object.shortdesc) .. " to " .. tostring(self.name) .. ".")
    wait(1)
    self:emote("looks wistfully at " .. tostring(object.shortdesc) .. ".")
    self.room:send(tostring(self.name) .. " says, 'Ach, what a waste.  Sorry, it's no use trying to eat this now!'")
    wait(2)
    actor:send(tostring(self.name) .. " returns " .. tostring(object.shortdesc) .. " to you.")
    self.room:send_except(actor, tostring(self.name) .. " returns " .. tostring(object.shortdesc) .. " to " .. tostring(actor.name) .. ".")
elseif object.id == 62076 then
    -- banana
    _return_value = false
    self.room:send_except(actor, tostring(actor.name) .. " gives " .. tostring(object.shortdesc) .. " to " .. tostring(self.name) .. ".")
    actor:send("You give " .. tostring(object.shortdesc) .. " to " .. tostring(self.name) .. ".")
    wait(4)
    self:emote("seems a bit perplexed.")
    self:emote("sniffs " .. tostring(object.shortdesc) .. ".")
    wait(2)
    self:say("Well now... it smells nice, doesn't it?")
    self:command("peer " .. tostring(actor.name))
    self:emote("licks " .. tostring(object.shortdesc) .. " carefully.")
    wait(3)
    self:say("I'm not sure I want to bite this, though, do I?")
    actor:send(tostring(self.name) .. " returns " .. tostring(object.shortdesc) .. " to you.")
    self.room:send_except(actor, tostring(self.name) .. " returns " .. tostring(object.shortdesc) .. " to " .. tostring(actor.name) .. ".")
else
    _return_value = false
    self.room:send_except(actor, tostring(actor.name) .. " gives " .. tostring(object.shortdesc) .. " to " .. tostring(self.name) .. ".")
    actor:send("You give " .. tostring(object.shortdesc) .. " to " .. tostring(self.name) .. ".")
    wait(8)
    self.room:send(tostring(self.name) .. " says, 'Now I wouldn't know what to do with this, now would I?'")
    actor:send(tostring(self.name) .. " returns " .. tostring(object.shortdesc) .. " to you.")
    self.room:send_except(actor, tostring(self.name) .. " returns " .. tostring(object.shortdesc) .. " to " .. tostring(actor.name) .. ".")
end
return _return_value