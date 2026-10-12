-- Trigger: lylaith
-- Zone: 22, ID: 65
-- Type: OBJECT, Flags: WEAR
-- Status: CLEAN
--
-- Original DG Script: #2265

-- Converted from DG Script #2265: lylaith
-- Original: OBJECT trigger, flags: WEAR, num_arg: 5 (no chance roll in legacy)

wait(2)
actor:send("As you wield " .. tostring(self.shortdesc) .. ", the blade glows a <b:white>bright white</>!")
self.room:send_except(actor, "As " .. tostring(actor.name) .. " wields " .. tostring(self.shortdesc) .. ", the blade glows a <b:white>bright white</>!")