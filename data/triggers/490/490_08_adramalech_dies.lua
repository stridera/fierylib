-- Trigger: adramalech_dies
-- Zone: 490, ID: 8
-- Type: MOB, Flags: DEATH
-- Status: CLEAN
--
-- Original DG Script: #49008

-- Converted from DG Script #49008: adramalech_dies
-- Original: MOB trigger, flags: DEATH, probability: 100%
local _return_value = true  -- Default: allow action
_return_value = false
self.room:send(tostring(self.name) .. " emits a bone-rattling roar that fades away into a low rattle.")
self.room:send(tostring(self.name) .. " disintegrates into darkly glowing spots that fade from view.")
if self.room ~= 49190 then
    self.room:teleport_all(get_room(491, 90))
    self.room:send("</>")
    self.room:send("<b:white>A rift opens in the fabric of reality and pulls you through!</>")
    self.room:send("</>")
    local room = get_room("49190")
    local person = room.people
    while person do
        if person.id == -1 then
            -- person looks around
            local person = person.next_in_room
        end
    end
end
person = nil
local person = actor
local i = person.group_size
local stage = 8
if i then
    local a = 1
else
    local a = 0
end
while i >= a do
    local person = person.group_member[a]
    if person.room == self.room then
        if person:get_quest_stage("griffin_quest") == "stage" then
            person.name:advance_quest("griffin_quest")
        end
    elseif person and person.id == -1 then
        local i = i + 1
    end
    local a = a + 1
end
get_room(491, 90):at(function()
    run_room_trigger(49009)
end)
return _return_value