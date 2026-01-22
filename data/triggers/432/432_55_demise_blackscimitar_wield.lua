-- Trigger: Demise_BlackScimitar_Wield
-- Zone: 432, ID: 55
-- Type: OBJECT, Flags: WEAR
-- Status: CLEAN
--
-- Original DG Script: #43255

-- Converted from DG Script #43255: Demise_BlackScimitar_Wield
-- Original: OBJECT trigger, flags: WEAR, probability: 100%
self.room:send("Shadows appear over " .. tostring(actor.name) .. ", so vivid that they seem tangible.")
self.room:send("Suddenly they dive into " .. tostring(actor.name) .. "'s body, merging with " .. tostring(actor.possessive) .. " soul!")