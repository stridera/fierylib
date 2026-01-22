-- Trigger: harness obj
-- Zone: 625, ID: 90
-- Type: OBJECT, Flags: RANDOM
-- Status: CLEAN
--
-- Original DG Script: #62590

-- Converted from DG Script #62590: harness obj
-- Original: OBJECT trigger, flags: RANDOM, probability: 100%
if actor:get_eff_flagged("harness") then
    self.room:send(tostring(actor.name) .. " has harness.")
else
    actor:set_flag("harness", true)
    self.room:send("<red>setting harness!</>")
end