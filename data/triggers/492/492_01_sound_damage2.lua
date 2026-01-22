-- Trigger: Sound damage2
-- Zone: 492, ID: 1
-- Type: WORLD, Flags: PREENTRY
-- Status: CLEAN
--
-- Original DG Script: #49201

-- Converted from DG Script #49201: Sound damage2
-- Original: WORLD trigger, flags: PREENTRY, probability: 100%
wait(3)
actor:send("The violent rage of sounds thrust into your body, leaving you breathless.")
self.room:send_except(actor, tostring(actor.name) .. " slants over in a desperate attempt to breathe.")
actor:damage(15)  -- type: physical