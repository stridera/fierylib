-- Trigger: 3eg_qm_greet
-- Zone: 41, ID: 5
-- Type: MOB, Flags: GREET
-- Status: CLEAN
--
-- 3eg questmaster greet: pitches the Eldorian Guard side of the
-- Black_Legion quest to neutral/good walkers (alignment >= -150) who
-- haven't started it yet. The quest is initiated via 041_06 when the
-- player says yes/quest/etc.
--
-- Original DG Script: #4105
wait(2)
if actor.alignment >= -150 and actor:get_quest_stage("Black_Legion") == 0 then
    actor:send(tostring(self.name) .. " tells you, 'Hrm, a poor sod to fight the undead masses?'")
end