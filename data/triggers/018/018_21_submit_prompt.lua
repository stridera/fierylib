-- Trigger: submit_prompt
-- Zone: 18, ID: 21
-- Type: MOB, Flags: RANDOM
-- Status: CLEAN
--
-- Original DG Script: #1821

-- Converted from DG Script #1821: submit_prompt
-- Original: MOB trigger, flags: RANDOM, probability: 100%
self:say("Submit to my will, and I might let you escape alive.")
self:say("Or perhaps if you give a sacrifice I like, I may send you out unscathed.")
run_room_trigger(1802)