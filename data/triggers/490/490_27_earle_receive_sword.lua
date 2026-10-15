-- Trigger: Earle receive sword
-- Zone: 490, ID: 27
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #49027

-- Converted from DG Script #49027: Earle receive sword
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
-- DG receive arg list (49029): this trigger ran only for these items.
-- The runtime does not filter on arg_list, so the filter lives here.
if not (
    (object.zone_id == 490 and object.id == 29)
) then
    return true
end

-- Rune sword given
self.room:send_except(actor, tostring(actor.name) .. " gives " .. tostring(object.shortdesc) .. " to " .. tostring(self.name) .. ".")
actor:send("You give " .. tostring(object.shortdesc) .. " to " .. tostring(self.name) .. ".")
local person = actor
local oak = 0
local accept = 0
local stage = 1
local i = person.group_size
local a
if i then
    a = 1
else
    a = 0
end
while i >= a do
    person = person.group_member[a]
    if person.room == self.room then
        if person:get_quest_var("griffin_quest:oak") then
            oak = oak + 1
            if person:get_quest_stage("griffin_quest") == stage then
                person:advance_quest("griffin_quest")
                person:send("<b:white>You have advanced the quest!</>")
                accept = accept + 1
            end
        end
    elseif person and person.is_player then
        i = i + 1
    end
    a = a + 1
end
if oak == 0 then
    self:say("A fine weapon, but it will be of no use without the holy tree.")
    self:emote("returns the sword.")
else
    self:say("Ah... this sword would have saved a lot of trouble.")
    self:command("ponder")
    self.room:send(tostring(self.name) .. " says, 'If you didn't have too much trouble getting this sword, then perhaps you can help.  Go to the seer and say <b:cyan>\"Earle sends me\"</> and she will give you what aid she can.'")
    self:say("Please return to me when you have defeated Dagon.  And be sure to bring proof of the deed!")
    self:emote("hands back the sword.")
    if accept > 0 then
        self.room:send(tostring(self.name) .. " says, 'If you need, you can come to me and check your <b:cyan>[quest progress]</>.'")
    else
        self:emote("glances back with a thoughtful look.")
        self:say("Did I give you the sapling for the altar?  I can be so forgetful...'")
    end
end
return false  -- legacy return 0: the giver keeps the item
