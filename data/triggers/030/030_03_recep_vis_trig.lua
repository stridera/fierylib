-- Trigger: recep_vis_trig
-- Zone: 30, ID: 3
-- Type: WORLD, Flags: PREENTRY
-- Status: CLEAN
--
-- Original DG Script: #3003

-- Converted from DG Script #3003: recep_vis_trig
-- Original: WORLD trigger, flags: PREENTRY, probability: 100%
wait(2)
if self.actor_count then
    self.room:find_actor("recep"):command("vis")
    wait(2)
end