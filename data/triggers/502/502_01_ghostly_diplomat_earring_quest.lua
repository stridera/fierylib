-- Trigger: Ghostly Diplomat Earring Quest
-- Zone: 502, ID: 1
-- Type: MOB, Flags: RECEIVE
-- Status: NEEDS_REVIEW
--   Complex nesting: 9 if statements
--   Large script: 5346 chars
--
-- Original DG Script: #50201

-- Converted from DG Script #50201: Ghostly Diplomat Earring Quest
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
-- switch on object.id
if object.id == 50203 then
    -- The ghost of a diplomat has received the magical golden
    -- earring. He knows of this talisman from his studies and
    -- travels. He knows how to make it much more powerful. Now
    -- that he has it, he will do so. However, the process will
    -- drive him mad. The player's job will then be to find
    -- him (with the help of the quiet ranger) and retrieve the
    -- enhanced earring (now a crimson-tinged electrum hoop).
    wait(2)
    world.destroy(object)
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
            if not person:get_quest_stage("bayou_quest") then
                person.name:start_quest("bayou_quest")
            end
        elseif person then
            local i = i + 1
        end
        local a = a + 1
    end
    self:command("thank " .. tostring(actor.name))
    self:emote("gazes upon the earring, overwhelmed by its beauty.")
    self.room:send(tostring(self.name) .. " says, 'You fool!  You should never have given it up so easily!'")
    self:emote("dashes out of the room.")
    self:teleport(get_room(502, 43))
    if world.count_mobiles("50209") < 1 then
        self.room:spawn_mobile(502, 9)
        self:command("remove all")
        self:command("give all maddened-diplomat-spectre")
        self.room:find_actor("maddened-diplomat-spectre"):command("wear all")
        self.room:find_actor("maddened-diplomat-spectre"):move("d")
    end
    world.destroy(self)
elseif object.id == 50201 or object.id == 50202 then
    -- China from Odz
    self.room:send_except(actor, tostring(actor.name) .. " gives " .. tostring(object.shortdesc) .. " to " .. tostring(self.name) .. ".")
    actor:send("You give " .. tostring(object.shortdesc) .. " to " .. tostring(self.name) .. ".")
    _return_value = false
    wait(1)
    self:emote("looks over " .. tostring(object.shortdesc) .. " fondly.")
    wait(2)
    self.room:send(tostring(self.name) .. " says, 'Attractive, is it not?  A gift from our island friends.'")
    wait(1)
    self.room:send(tostring(self.name) .. " says, 'But alas, it has no intrinsic magic that I can detect.'")
    self:emote("politely returns the item.")
elseif object.id == 50204 or object.id == 50209 then
    -- Magical eq from bayou
    self.room:send_except(actor, tostring(actor.name) .. " gives " .. tostring(object.shortdesc) .. " to " .. tostring(self.name) .. ".")
    actor:send("You give " .. tostring(object.shortdesc) .. " to " .. tostring(self.name) .. ".")
    _return_value = false
    wait(1)
    self:emote("stares closely at " .. tostring(object.shortdesc) .. " for a time.")
    wait(4)
    self:command("sigh")
    wait(2)
    self.room:send(tostring(self.name) .. " says, 'There is something here, but this is far too weak.  No, the captain was after something much more valuable.'")
    wait(1)
    self:emote("returns the item.")
elseif object.id == 50215 then
    -- The electrum hoop!
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
            if not person:get_quest_stage("bayou_quest") then
                person.name:start_quest("bayou_quest")
            end
        elseif person then
            local i = i + 1
        end
        local a = a + 1
    end
    wait(2)
    world.destroy(object)
    if world.count_mobiles("50209") < 1 then
        get_room(502, 43):at(function()
            self.room:spawn_mobile(502, 9)
        end)
        get_room(502, 43):at(function()
            self:command("remove all")
        end)
        get_room(502, 43):at(function()
            self:command("give all maddened-diplomat-spectre")
        end)
        get_room(502, 43):at(function()
            self.room:find_actor("maddened-diplomat-spectre"):command("wear all")
        end)
    end
    wait(1)
    self:command("gasp")
    wait(1)
    self:say("What... how... I cannot believe it!")
    wait(2)
    self.room:send(tostring(self.name) .. " says, 'And you willingly gave it to me!  Oh the gods of Garl'lixxil smile upon me this day!'")
    wait(1)
    self.room:send("The ghost of a diplomat cackles, and seems to grow before your very eyes!")
    -- Now: move dip to secret room; load maddip; give earring maddip; purge dip; bring maddip back
    local startroom = self.room
    self.room:find_actor("maddened-diplomat-spectre"):teleport(find_room_by_name("%startroom%"))
    wait(1)
    world.destroy(self)
else
    self.room:send_except(actor, tostring(actor.name) .. " gives " .. tostring(object.shortdesc) .. " to " .. tostring(self.name) .. ".")
    actor:send("You give " .. tostring(object.shortdesc) .. " to " .. tostring(self.name) .. ".")
    _return_value = false
    wait(6)
    self:command("laugh")
    self:say("I'm afraid not.")
    wait(8)
    self:emote("politely returns the item.")
end
return _return_value