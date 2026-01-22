-- Trigger: thief_subclass_sneak_past
-- Zone: 60, ID: 27
-- Type: MOB, Flags: RANDOM
-- Status: CLEAN
--
-- Original DG Script: #6027

-- Converted from DG Script #6027: thief_subclass_sneak_past
-- Original: MOB trigger, flags: RANDOM, probability: 100%
if self.is_fighting then
    return _return_value
end
local room = self.room
local person = room.people
while person do
    if person:get_quest_var("merc_ass_thi_subclass:subclass_name") == "thief" then
        if person:get_quest_stage("merc_ass_thi_subclass") == 3 or person:get_quest_stage("merc_ass_thi_subclass") == 4 then
            if person.can_be_seen and person.hiddenness < 1 then
                person:send(tostring(self.name) .. " notices you skulking about!")
                person:send(tostring(self.name) .. " says, 'Who are you?!  You weren't invited here!'")
                self.room:send_except(person, tostring(self.name) .. " shoos " .. tostring(person.name) .. " off the farm!")
                person:send(tostring(self.name) .. " shoos you off the farm!")
                person:teleport(get_room(80, 6))
                wait(1)
                -- person looks around
                actor:fail_quest("merc_ass_thi_subclass")
                actor:send("<b:yellow>You have failed your quest!</>")
                actor:send("You'll have to go back to " .. tostring(mobiles.template(60, 50).name) .. " and start over!")
            end
        end
    end
    local person = person.next_in_room
end