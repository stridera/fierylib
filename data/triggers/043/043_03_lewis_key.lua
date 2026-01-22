-- Trigger: lewis_key
-- Zone: 43, ID: 3
-- Type: MOB, Flags: RECEIVE
-- Status: NEEDS_REVIEW
--   Complex nesting: 7 if statements
--
-- Original DG Script: #4303

-- Converted from DG Script #4303: lewis_key
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
self:set_flag("sentinel", true)
if object.id == 4300 then
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
            if person:get_quest_stage("theatre") == 2 then
                person:advance_quest("theatre")
                person:send("<b:white>You have advanced the quest!</>")
            end
        elseif person then
            local i = i + 1
        end
        local a = a + 1
    end
    if actor:get_quest_stage("theatre") >= 2 then
        wait(2)
        self:say("Hurray!  Thank you!")
        self:command("clap")
        wait(2)
        self:say("Oh!  Mummy's going to want her key back too!")
        wait(2)
        self.room:send(tostring(self.name) .. " fishes a key out of his armor.")
        wait(1)
        self:say("Please, give this to her.")
        self.room:spawn_object(43, 2)
        self:command("give key " .. tostring(actor.name))
        wait(2)
        self:say("Ta!")
        wait(3)
        self:emote("makes air kisses.")
    else
        local refuse = "quest"
    end
else
    local refuse = "item"
end
if refuse then
    _return_value = false
    if refuse == "quest" then
        self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
        wait(2)
        self:say("What is this??  How did you get in here??")
    elseif refuse == "item" then
        self.room:send(tostring(self.name) .. " looks blankly at " .. tostring(object.shortdesc) .. ".")
        wait(2)
        self:say("Well yes that's nice but it doesn't exactly help the situation.")
    end
end
self:set_flag("sentinel", false)
return _return_value