-- Trigger: Cirion_all_greet1
-- Zone: 370, ID: 7
-- Type: MOB, Flags: GREET_ALL
-- Status: CLEAN
--
-- Original DG Script: #37007

-- Converted from DG Script #37007: Cirion_all_greet1
-- Original: MOB trigger, flags: GREET_ALL, probability: 100%
-- All greet trig for players
if actor.id == -1 then
    actor:send(tostring(self.name) .. " says, 'Ah, finally Mesmeriz has summoned someone else here to be his slaves.'")
else
end