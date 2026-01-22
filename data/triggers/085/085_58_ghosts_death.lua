-- Trigger: ghosts death
-- Zone: 85, ID: 58
-- Type: MOB, Flags: DEATH
-- Status: CLEAN
--
-- Original DG Script: #8558

-- Converted from DG Script #8558: ghosts death
-- Original: MOB trigger, flags: DEATH, probability: 100%
if quester then
    quester:set_quest_var("resurrection_quest", "%self.vnum%", 1)
    self.room:send("<b:cyan>" .. tostring(self.name) .. " is purged from this existance.</>")
    quester:send("<magenta>The death talisman twitches slightly. Creepy!</>")
end