-- Trigger: dying_tree_allgreet1
-- Zone: 520, ID: 17
-- Type: MOB, Flags: GREET_ALL
-- Status: CLEAN
--
-- Original DG Script: #52017

-- Converted from DG Script #52017: dying_tree_allgreet1
-- Original: MOB trigger, flags: GREET_ALL, probability: 100%
if actor.id == -1 then
    self:say(tostring(actor.name) .. ", have you come to help me?")
end