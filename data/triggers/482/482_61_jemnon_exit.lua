-- Trigger: jemnon_exit
-- Zone: 482, ID: 61
-- Type: MOB, Flags: LEAVE
-- Status: CLEAN
--
-- Original DG Script: #48261

-- Converted from DG Script #48261: jemnon_exit
-- Original: MOB trigger, flags: LEAVE, probability: 100%
if actor:get_quest_stage("meteorswarm") == 2 then
    self.room:send(tostring(self.name) .. " wanders off.")
    world.destroy(self)
end