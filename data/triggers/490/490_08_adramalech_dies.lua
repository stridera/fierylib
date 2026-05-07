-- Trigger: adramalech_dies
-- Zone: 490, ID: 8
-- Type: MOB, Flags: DEATH
-- Status: CLEAN
--
-- Original DG Script: #49008

-- Converted from DG Script #49008: adramalech_dies
-- Original: MOB trigger, flags: DEATH, probability: 100%
local _return_value = true  -- Default: allow action
self.room:send(tostring(self.name) .. " emits a bone-rattling roar that fades away into a low rattle.")
self.room:send(tostring(self.name) .. " disintegrates into darkly glowing spots that fade from view.")
if self.room ~= get_room(490, 190) then
    self.room:teleport_all(get_room(490, 190))
    self.room:send("</>")
    self.room:send("<b:white>A rift opens in the fabric of reality and pulls you through!</>")
    self.room:send("</>")
    local room = get_room(490, 190)
    local person = room.people
    while person do
        if person.is_player then
            -- person looks around
        end
        person = person.next_in_room
    end
end
local person = actor
local stage = 8
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
        if person:get_quest_stage("griffin_quest") == stage then
            person:advance_quest("griffin_quest")
        end
    elseif person and person.is_player then
        i = i + 1
    end
    a = a + 1
end
get_room(490, 190):at(function()
    run_room_trigger(490, 9)
end)
return _return_value