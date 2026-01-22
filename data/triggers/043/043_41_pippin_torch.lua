-- Trigger: pippin_torch
-- Zone: 43, ID: 41
-- Type: MOB, Flags: GREET
-- Status: NEEDS_REVIEW
--   Complex nesting: 9 if statements
--
-- Original DG Script: #4341

-- Converted from DG Script #4341: pippin_torch
-- Original: MOB trigger, flags: GREET, probability: 100%
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
        if (person:has_equipped("4318") or person:has_item("4318")) and person:get_quest_stage("theatre") >= 6 then
            local check = 1
        end
    elseif person and person.id == -1 then
        local i = i + 1
    end
    local a = a + 1
end
if check then
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
            if person:get_quest_stage("theatre") == 6 then
                person:advance_quest("theatre")
                person:send("<b:white>You have advanced the quest!</>")
            end
            if not leader then
                local leader = person
            end
        elseif person and person.id == -1 then
            local i = i + 1
        end
        local a = a + 1
    end
end
if self.consented then
    return _return_value
elseif leader then
    wait(2)
    self:set_flag("sentinel", true)
    wait(1)
    self.room:send("The <red>F<b:yellow>i<b:red>r</><red>e G<b:yellow>o<b:red>dd</><b:yellow>e</><red>ss<b:red>'s</> Torch erupts to life and spews a shower of sparks and flame!")
    wait(1)
    self.room:send("Pippin watches the flames, completely entranced.")
    self:follow(leader.name)
    self:command("consent " .. tostring(leader.name))
end