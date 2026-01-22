-- Trigger: Sound damage
-- Zone: 492, ID: 0
-- Type: WORLD, Flags: PREENTRY
-- Status: CLEAN
--
-- Original DG Script: #49200

-- Converted from DG Script #49200: Sound damage
-- Original: WORLD trigger, flags: PREENTRY, probability: 100%
wait(1)
actor:damage(10)  -- type: physical
actor:send("The violent rage of sounds thrust into your body, leaving you breathless.")
self.room:send_except(actor, tostring(actor.name) .. " reels in pain as " .. tostring(actor.name) .. " gasps for air.")