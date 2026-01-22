-- Trigger: give_nymph_junkk
-- Zone: 18, ID: 7
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #1807

-- Converted from DG Script #1807: give_nymph_junkk
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
wait(1)
self:command("junk " .. tostring(object.name))