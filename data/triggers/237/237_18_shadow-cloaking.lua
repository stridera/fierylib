-- Trigger: shadow-cloaking
-- Zone: 237, ID: 18
-- Type: OBJECT, Flags: WEAR
-- Status: CLEAN
--
-- Original DG Script: #23718

-- Converted from DG Script #23718: shadow-cloaking
-- Original: OBJECT trigger, flags: WEAR, probability: 100%
actor.name:send("You feel secure, cloaked in the shadows.")
self.room:send_except(actor, tostring(actor.name) .. " slowly fades into the shadows.")