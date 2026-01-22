-- Trigger: A test trigger
-- Zone: 301, ID: 99
-- Type: MOB, Flags: GREET
-- Status: CLEAN
--
-- Original DG Script: #30199

-- Converted from DG Script #30199: A test trigger
-- Original: MOB trigger, flags: GREET, probability: 100%
if actor:get_has_completed("relocate_spell_quest") then
    self:say("I see that " .. tostring(actor.name) .. " has completed the relocate spell quest!")
else
    self:say("So, " .. tostring(actor.name) .. " has not completed the relocate spell quest.")
end