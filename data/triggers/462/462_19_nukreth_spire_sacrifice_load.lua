-- Trigger: Nukreth Spire sacrifice load
-- Zone: 462, ID: 19
-- Type: MOB, Flags: LOAD
-- Status: CLEAN
--
-- Original DG Script: #46219

-- Converted from DG Script #46219: Nukreth Spire sacrifice load
-- Original: MOB trigger, flags: LOAD, probability: 100%
wait(1)
self.room:send("The man slowly climbs to his feet.")
self.room:send(tostring(self.name) .. " says, 'Did my wife send you?  Please, take me to her!")
self.room:send("</>Say 'follow me' and I'll go with you.'")