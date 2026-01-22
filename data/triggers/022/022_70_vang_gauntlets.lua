-- Trigger: vang_gauntlets
-- Zone: 22, ID: 70
-- Type: OBJECT, Flags: WEAR
-- Status: CLEAN
--
-- Original DG Script: #2270

-- Converted from DG Script #2270: vang_gauntlets
-- Original: OBJECT trigger, flags: WEAR, probability: 100%
wait(2)
actor:send("As you wear " .. tostring(self.shortdesc) .. ", they begin to burn a <b:red>flaming red</>.")
self.room:send_except(actor, "As " .. tostring(actor.name) .. " wears " .. tostring(self.shortdesc) .. ", they begin to burn a <b:red>flaming red</>.")