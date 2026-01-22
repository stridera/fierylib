-- Trigger: Head Tear
-- Zone: 17, ID: 98
-- Type: OBJECT, Flags: GET
-- Status: CLEAN
--
-- Original DG Script: #1798

-- Converted from DG Script #1798: Head Tear
-- Original: OBJECT trigger, flags: GET, probability: 80%

-- 80% chance to trigger
if not percent_chance(80) then
    return true
end
actor:send("Seemingly for no reason " .. tostring(self) .. " sets its gaze on you...")
-- (empty send to actor)
-- (empty send to actor)
actor:send("charging across the field of battle, the " .. tostring(self) .. " leaps at you!")
-- (empty send to actor)
-- (empty send to actor)
actor:send("landing on you, " .. tostring(self) .. " begins to maul the living life out of you!!")
-- (empty send to actor)
-- (empty send to actor)
actor:send("you begin seeing red, but alas its too late, the " .. tostring(self) .. " rips your head off!!!!!!")
self.room:send_except(actor, tostring(self) .. " leaps onto " .. tostring(actor.name) .. " mauling him into a bloody pulp!")
actor:damage(30000)  -- type: physical