-- Trigger: LP_magic
-- Zone: 43, ID: 49
-- Type: MOB, Flags: RANDOM
-- Status: CLEAN
--
-- Original DG Script: #4349

-- Converted from DG Script #4349: LP_magic
-- Original: MOB trigger, flags: RANDOM, probability: 15%

-- 15% chance to trigger
if not percent_chance(15) then
    return true
end
self:emote("brushes up to you, singing,")
self.room:send("'We've got magic to do, just for you.")
self.room:send("</>We've got miracle plays to play.'")
wait(3)
self.room:send("Smoothly gliding up and around you, the Leading Player keeps on enticing you to join him.")
wait(3)
self:emote("sings,")
self.room:send("'We've got parts to perform, hearts to warm.")
self.room:send("Kings and things to take by storm as we go along our way, hey!'")