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
-- Advance Word of Command for every group member present in the room.
for _, person in ipairs(actor.group) do
    if person.room == self.room and person:get_quest_stage("word_command") == 2 then
        person:advance_quest("word_command")
    end
end
-- If Dargo (mob 430:21) is present, send him through the freshly-opened door.
if self.room:find_actor("dargo") then
    self.room:send(tostring(mobiles.template(430, 21).name) .. " says, 'At last!!  The way out!'")
    self.room:send("Lord Dargo dashes for the door!")
    self.room:find_actor("dargo"):command("enter door")
end