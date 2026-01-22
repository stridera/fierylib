-- Trigger: krystophus_ring
-- Zone: 22, ID: 72
-- Type: OBJECT, Flags: WEAR
-- Status: CLEAN
--
-- Original DG Script: #2272

-- Converted from DG Script #2272: krystophus_ring
-- Original: OBJECT trigger, flags: WEAR, probability: 100%
wait(2)
actor:send("Your head beings to reel momentarily as you wear " .. tostring(self.shortdesc) .. ".")
self.room:send_except(actor, tostring(actor.name) .. " suddenly looks off balance for a moment.")