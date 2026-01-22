-- Trigger: word_command_dargo_kill
-- Zone: 430, ID: 56
-- Type: MOB, Flags: RANDOM
-- Status: CLEAN
--
-- Original DG Script: #43056

-- Converted from DG Script #43056: word_command_dargo_kill
-- Original: MOB trigger, flags: RANDOM, probability: 100%
local room = self.room
local person = room.people
while person do
    if person.id ~= -1 and person.id ~= 43021 then
        if not person:get_flagged("illusory") then
            person:say("You will never escape this place, Dargo!")
            person:command("kill %self%")
        end
    end
    local person = person.next_in_room
end