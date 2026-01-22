-- Trigger: Elder_Druid
-- Zone: 485, ID: 6
-- Type: MOB, Flags: DEATH
-- Status: CLEAN
--
-- Original DG Script: #48506

-- Converted from DG Script #48506: Elder_Druid
-- Original: MOB trigger, flags: DEATH, probability: 100%
self.room:send(tostring(self.name) .. " says, 'Finally my eternal torment is finished...")
-- (empty room echo)
self.room:send(tostring(self.name) .. " says, 'You, you must punish the evil God that is responsible")
self.room:send("</>for the destruction of my precious nature.  You must attempt to kill him.'")
-- (empty room echo)
self.room:send(tostring(self.name) .. " says, 'That vile bastard!'")
-- (empty room echo)
self.room:send(tostring(self.name) .. " says, 'LOKARI!'")