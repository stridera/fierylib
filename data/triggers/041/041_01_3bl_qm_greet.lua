-- Trigger: 3bl_qm_greet
-- Zone: 41, ID: 1
-- Type: MOB, Flags: GREET
-- Status: CLEAN
--
-- 3bl questmaster greet: pitches the Black Legion side of the Black_Legion
-- quest to neutral/evil walkers (alignment <= 150) who haven't started it
-- yet. The quest is initiated via 041_02 when the player says yes/quest/etc.
--
-- Original DG Script: #4101
wait(2)
if actor.alignment <= 150 and actor:get_quest_stage("Black_Legion") == 0 then
    actor:send(tostring(self.name) .. " tells you, 'Hrm, fresh meat to fight the reach of the")
    actor:send("</>elven scum?'")
end