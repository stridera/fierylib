-- Trigger: Demise_Cyprianum_Death_Word_of_Command
-- Zone: 430, ID: 21
-- Type: MOB, Flags: DEATH
-- Status: CLEAN
--
-- Original DG Script: #43021

-- Converted from DG Script #43021: Demise_Cyprianum_Death_Word_of_Command
-- Original: MOB trigger, flags: DEATH, probability: 100%
self:emote("roars, 'Time is but a shell...'")
self.room:send("A non-descript wooden door bursts from Cyprianum!")
self.room:spawn_object(430, 26)
local i = actor.group_size
if i then
    local a = 1
else
    local a = 0
end
while i >= a do
    local person = actor.group_member[a]
    if person.room == self.room then
        if person:get_quest_stage("word_command") == 2 then
            person.name:advance_quest("word_command")
        end
    elseif person then
        local i = i + 1
    end
    local a = a + 1
end
local room = self.room
if room:get_people("43021") then
    self.room:send(tostring(mobiles.template(430, 21).name) .. " says, 'At last!!  The way out!'")
    self.room:send("Lord Dargo dashes for the door!")
    self.room:find_actor("dargo"):command("enter door")
end