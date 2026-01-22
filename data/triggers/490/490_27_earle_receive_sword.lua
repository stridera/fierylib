-- Trigger: Earle receive sword
-- Zone: 490, ID: 27
-- Type: MOB, Flags: RECEIVE
-- Status: NEEDS_REVIEW
--   Complex nesting: 6 if statements
--
-- Original DG Script: #49027

-- Converted from DG Script #49027: Earle receive sword
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
-- Rune sword given
_return_value = false
self.room:send_except(actor, tostring(actor.name) .. " gives " .. tostring(object.shortdesc) .. " to " .. tostring(self.name) .. ".")
actor:send("You give " .. tostring(object.shortdesc) .. " to " .. tostring(self.name) .. ".")
local person = actor
local oak = 0
local accept = 0
local stage = 1
local i = person.group_size
if i then
    local a = 1
else
    local a = 0
end
while i >= a do
    local person = person.group_member[a]
    if person.room == self.room then
        if person:get_quest_var("griffin_quest:oak") then
            local oak = oak + 1
            if person:get_quest_stage("griffin_quest") == "stage" then
                person.name:advance_quest("griffin_quest")
                person:send("<b:white>You have advanced the quest!</>")
                local accept = accept + 1
            end
        end
    elseif person and person.id == -1 then
        local i = i + 1
    end
    local a = a + 1
end
wait(2)
if not oak then
    self:say("A fine weapon, but it will be of no use without the holy tree.")
    self:emote("returns the sword.")
else
    self:say("Ah... this sword would have saved a lot of trouble.")
    self:command("ponder")
    wait(2)
    self.room:send(tostring(self.name) .. " says, 'If you didn't have too much trouble getting this sword, then perhaps you can help.  Go to the seer and say <b:cyan>\"Earle sends me\"</> and she will give you what aid she can.'")
    wait(3)
    self:say("Please return to me when you have defeated Dagon.  And be sure to bring proof of the deed!")
    self:emote("hands back the sword.")
    wait(2)
    if accept then
        self.room:send(tostring(self.name) .. " says, 'If you need, you can come to me and check your <b:cyan>[quest progress]</>.'")
    else
        self:emote("glances back with a thoughtful look.")
        wait(1)
        self:say("Did I give you the sapling for the altar?  I can be so forgetful...'")
    end
end
return _return_value