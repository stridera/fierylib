-- Trigger: leader_talk
-- Zone: 200, ID: 26
-- Type: MOB, Flags: GREET
-- Status: CLEAN
--
-- Original DG Script: #20026

-- Converted from DG Script #20026: leader_talk
-- Original: MOB trigger, flags: GREET, probability: 100%
self:say("We where told by the guardians that someone was coming to see us.")
self.room:send("Yix'Xyua whispers something to the assistant.")
self:say("The master wants to know what have you come here for?")