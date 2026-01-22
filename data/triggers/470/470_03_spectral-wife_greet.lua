-- Trigger: spectral-wife_greet
-- Zone: 470, ID: 3
-- Type: MOB, Flags: GREET_ALL
-- Status: CLEAN
--
-- Original DG Script: #47003

-- Converted from DG Script #47003: spectral-wife_greet
-- Original: MOB trigger, flags: GREET_ALL, probability: 100%
wait(1)
actor:send(tostring(self.name) .. " says to you, '<b:yellow>Good day my friend.  It is not often I see'")
actor:send("'<b:yellow>city folk in these parts.  Won't you stay and talk?</>'")