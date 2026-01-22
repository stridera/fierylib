-- Trigger: nezer-death
-- Zone: 22, ID: 24
-- Type: MOB, Flags: DEATH
-- Status: CLEAN
--
-- Original DG Script: #2224

-- Converted from DG Script #2224: nezer-death
-- Original: MOB trigger, flags: DEATH, probability: 100%
self.room:send("&9<blue>The giant black dragon collapses to the ground with a mighty thunder!</>")
run_room_trigger(2225)