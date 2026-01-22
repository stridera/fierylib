-- Trigger: Lichs Ruby
-- Zone: 125, ID: 17
-- Type: OBJECT, Flags: GET
-- Status: CLEAN
--
-- Original DG Script: #12517

-- Converted from DG Script #12517: Lichs Ruby
-- Original: OBJECT trigger, flags: GET, probability: 127%
actor.name:send("As you grab the gem, you feel memories and strength drain from you.")
self.room:send_except(actor.name, "As " .. tostring(actor.name) .. " grabs the gem, it glows brightly for a moment.")
actor.name:award_exp(-100000)