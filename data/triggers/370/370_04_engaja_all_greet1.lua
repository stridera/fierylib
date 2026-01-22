-- Trigger: Engaja_all_greet1
-- Zone: 370, ID: 4
-- Type: MOB, Flags: GREET_ALL
-- Status: CLEAN
--
-- Original DG Script: #37004

-- Converted from DG Script #37004: Engaja_all_greet1
-- Original: MOB trigger, flags: GREET_ALL, probability: 100%
if actor.id == -1 then
    actor:send(tostring(self.name) .. " says, 'What took you so long?'")
    actor:send(tostring(self.name) .. " says, 'Mesmeriz expected you at least a week ago...'")
else
end