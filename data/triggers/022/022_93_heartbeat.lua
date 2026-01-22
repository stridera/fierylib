-- Trigger: heartbeat
-- Zone: 22, ID: 93
-- Type: OBJECT, Flags: GET
-- Status: CLEAN
--
-- Original DG Script: #2293

-- Converted from DG Script #2293: heartbeat
-- Original: OBJECT trigger, flags: GET, probability: 100%
wait(2)
actor.name:send("as you grab the heart, you notice it starts to beat in your hand.")
self.room:send_except(actor.name, tostring(actor.name) .. " grabs a ruby heart, which starts beating within his hand!")