-- Trigger: word_command_dargo_preentry_plus_43157
-- Zone: 430, ID: 51
-- Type: WORLD, Flags: PREENTRY
-- Status: CLEAN
--
-- Original DG Script: #43051

-- Converted from DG Script #43051: word_command_dargo_preentry_plus_43157
-- Original: WORLD trigger, flags: PREENTRY, probability: 100%
actor:send("Pillars of darkness converge on you, enfolding you in their nothingness!")
actor:send("You feel yourself swept even deeper into the keep.")
if world.count_mobiles("43021") == 0 then
    self.room:spawn_mobile(430, 21)
end