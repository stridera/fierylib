-- Trigger: fastrada_key
-- Zone: 43, ID: 4
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #4304

-- Converted from DG Script #4304: fastrada_key
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
self:set_flag("sentinel", true)
if object.id == 4302 then
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
            if person:get_quest_stage("theatre") == 3 then
                person:advance_quest("theatre")
                person:send("<b:white>You have advanced the quest!</>")
            end
        elseif person then
            local i = i + 1
        end
        local a = a + 1
    end
    if actor:get_quest_stage("theatre") >= 3 then
        wait(3)
        self:say("Thank you sooooo much.")
        self.room:send_except(actor, tostring(self.name) .. " drapes herself all over " .. tostring(actor.name) .. ".")
        actor:send(tostring(self.name) .. " drapes herself all over you.")
        wait(1)
        self:emote("bends over slowly...")
        wait(2)
        self:emote("picks up a key.")
        self.room:spawn_object(43, 1)
        wait(2)
        self:command("give key " .. tostring(actor.name))
        wait(2)
        self:say("My darling husband, the King, will probably want that.")
        wait(4)
        self:say("Go let him out of his cage, he'll enjoy some fresh air.")
        wait(5)
        self:command("wave")
    else
        _return_value = false
        self.room:send(tostring(self.name) .. " refused " .. tostring(object.shortdesc) .. ".")
        wait(2)
        self:say("How did you get this?")
        wait(1)
        self:command("peer " .. tostring(actor))
        self:say("Are you stalking me?")
    end
else
    wait(2)
    self:say("Why thank you!  I love a good gift!")
end
self:set_flag("sentinel", false)
return _return_value