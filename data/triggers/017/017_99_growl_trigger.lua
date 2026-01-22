-- Trigger: Growl Trigger
-- Zone: 17, ID: 99
-- Type: MOB, Flags: GREET
-- Status: CLEAN
--
-- Original DG Script: #1799

-- Converted from DG Script #1799: Growl Trigger
-- Original: MOB trigger, flags: GREET, probability: 15%

-- 15% chance to trigger
if not percent_chance(15) then
    return true
end
actor:send("As you enter the room " .. tostring(self) .. " raises its head towards you and growls ferociously...")
-- (empty send to actor)
actor:send("ggggggggggggggggggggg")
-- (empty send to actor)
actor:send("ggggGggggGggggGggggGggg")
-- (empty send to actor)
actor:send("gggGGGgggGGGgggGGGggg")
-- (empty send to actor)
actor:send("GGGgGGGgGGGgGGGgGGGg")
-- (empty send to actor)
actor:send("GGGGGGGGGGGGGGGGGGG")
-- (empty send to actor)
actor:send("GrGrGrGrGrGrGrGrGrGrGrGrGrG")
-- (empty send to actor)
actor:send("GRGRGRGRGRGRGRGRGRGRGRG")
-- (empty send to actor)
actor:send("RRRRRRRRRRRRRRRRRRRRRRRRRRR")
-- (empty send to actor)
actor:send("RoRoRoRoRoRoRoRoRoRoRoRoRoRoRoRoR")
-- (empty send to actor)
actor:send("OOOOOOOOOOOOOOOOOOOOOOOOOOOOOO")
-- (empty send to actor)
actor:send("OwOwOwOwOwOwOwOwOwOwOwOwOwOwOwOwO")
-- (empty send to actor)
actor:send("WWWWWWWWWWWWWWWWWWWWWWW")
-- (empty send to actor)
actor:send("WlWlWlWlWlWlWlWlWlWlWlWlWlWlWlWlWlWlWlWlW")
-- (empty send to actor)
actor:send("LLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLL")
-- (empty send to actor)
actor:send("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
actor:damage(30000)  -- type: physical