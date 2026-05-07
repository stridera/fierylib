-- Trigger: word_command_dargo_kill
-- Zone: 430, ID: 56
-- Type: MOB, Flags: RANDOM
-- Status: CLEAN
--
-- Original DG Script: #43056

-- Converted from DG Script #43056: word_command_dargo_kill
-- Original: MOB trigger, flags: RANDOM, probability: 100%
-- Every non-illusory NPC in the room (other than Dargo himself) turns on him.
for _, person in ipairs(self.room.people) do
    if person.is_npc and not (person.zone_id == 430 and person.local_id == 21)
       and not person:get_flagged("illusory") then
        person:say("You will never escape this place, Dargo!")
        person:command("kill " .. tostring(self.name))
    end
end