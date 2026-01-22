-- Trigger: hermit_greet1
-- Zone: 490, ID: 40
-- Type: MOB, Flags: GREET
-- Status: CLEAN
--
-- Original DG Script: #49040

-- Converted from DG Script #49040: hermit_greet1
-- Original: MOB trigger, flags: GREET, probability: 100%
if actor:get_quest_stage("griffin_quest") then
    self:say("How may I help you " .. tostring(actor.name) .. "?")
end