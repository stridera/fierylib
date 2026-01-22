-- Trigger: drow-heart-spawn
-- Zone: 237, ID: 55
-- Type: MOB, Flags: DEATH
-- Status: CLEAN
--
-- Original DG Script: #23755

-- Converted from DG Script #23755: drow-heart-spawn
-- Original: MOB trigger, flags: DEATH, probability: 100%
local _return_value = true  -- Default: allow action
-- This is for the vilekka_stew quest in the drow city of Dheduu.
local person = actor
local i = actor.group_size
if i then
    local a = 1
    person = nil
    while i >= a do
        local person = actor.group_member[a]
        if person.room == self.room then
            if person:get_quest_stage("vilekka_stew") == 1 then
                local quest = "yes"
            end
        elseif person then
            local i = i + 1
        end
        local a = a + 1
    end
elseif person:get_quest_stage("vilekka_stew") == 1 then
    local quest = "yes"
end
if quest == "yes" then
    _return_value = false
    self.room:spawn_object(237, 21)
    self.room:send("The drow master's last breath echoes softly as he dies.")
    self.room:send("'Mother...why...'")
end
return _return_value