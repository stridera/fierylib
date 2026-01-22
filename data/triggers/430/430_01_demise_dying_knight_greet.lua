-- Trigger: Demise_dying_knight_greet
-- Zone: 430, ID: 1
-- Type: MOB, Flags: GREET
-- Status: CLEAN
--
-- Original DG Script: #43001

-- Converted from DG Script #43001: Demise_dying_knight_greet
-- Original: MOB trigger, flags: GREET, probability: 100%
wait(1)
self.room:send(tostring(self.name) .. " coughs loudly.")
self.room:send(tostring(self.name) .. " screams in frustration!")
self.room:send(tostring(self.name) .. " says, 'Hey you! wait!'")
wait(2)
self.room:send(tostring(self.name) .. " shouts, 'Wait!'")
self.room:send(tostring(self.name) .. " coughs loudly, spewing blood.")
self.room:send(tostring(self.name) .. " says, 'Turn back, it's awful! you will all die!'")
self.room:send(tostring(self.name) .. " rolls over in fit of bile-filled coughing.")