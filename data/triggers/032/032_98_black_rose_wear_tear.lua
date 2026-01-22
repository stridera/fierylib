-- Trigger: Black_Rose_Wear_Tear
-- Zone: 32, ID: 98
-- Type: OBJECT, Flags: WEAR
-- Status: CLEAN
--
-- Original DG Script: #3298

-- Converted from DG Script #3298: Black_Rose_Wear_Tear
-- Original: OBJECT trigger, flags: WEAR, probability: 100%
-- *Trigger is meant as a tear drop in memory of Pergus**
actor:send("A small tear drops from the corner of your eye as you garnish the rose.")
self.room:send_except(actor, tostring(actor.name) .. " sheds a tear as " .. tostring(actor.name) .. " adjusts the rose.")