-- Trigger: blur_cheetah_death
-- Zone: 18, ID: 30
-- Type: MOB, Flags: DEATH
-- Status: CLEAN
--
-- Original DG Script: #1830

-- Converted from DG Script #1830: blur_cheetah_death
-- Original: MOB trigger, flags: DEATH, probability: 100%
local room = self.room
local person = room.people
local lair = get_room("4236")
while person do
    if (person:get_quest_stage("blur") == 4) and (not person:get_quest_var("blur:west")) then
        person:send("<b:white>" .. tostring(mobiles.template(18, 22).name) .. " says, 'Well that was fun!</>")
        person:send("</><b:white>Now see if you can reach <b:cyan>" .. tostring(lair.name) .. "</><b:white> before I do!'</>")
        person:send(tostring(mobiles.template(18, 22).name) .. " blasts away into the sky!")
        person.name:set_quest_var("blur", "west", 1)
    end
    local person = person.next_in_room
end