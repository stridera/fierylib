-- Trigger: pippin_torch
-- Zone: 43, ID: 41
-- Type: MOB, Flags: GREET
-- Status: CLEAN
--
-- Original DG Script: #4341

-- Converted from DG Script #4341: pippin_torch
-- Original: MOB trigger, flags: GREET, probability: 100%
local _return_value = true
local check
local leader
local person = actor
local i = person.group_size
local a
if i then
    a = 1
else
    a = 0
end
while i >= a do
    local member = actor.group_member[a]
    if member and member.room == self.room then
        if (member:has_equipped(43, 18) or member:has_item(43, 18)) and member:get_quest_stage("theatre") >= 6 then
            check = 1
        end
    elseif member and member.is_player then
        i = i + 1
    end
    a = a + 1
end
if check then
    local i2 = person.group_size
    local a2
    if i2 then
        a2 = 1
    else
        a2 = 0
    end
    while i2 >= a2 do
        local member = actor.group_member[a2]
        if member and member.room == self.room then
            if member:get_quest_stage("theatre") == 6 then
                member:advance_quest("theatre")
                member:send("<b:white>You have advanced the quest!</>")
            end
            if not leader then
                leader = member
            end
        elseif member and member.is_player then
            i2 = i2 + 1
        end
        a2 = a2 + 1
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