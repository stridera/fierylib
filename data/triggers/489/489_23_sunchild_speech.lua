-- Trigger: sunchild speech
-- Zone: 489, ID: 23
-- Type: MOB, Flags: GREET
-- Status: CLEAN
--
-- Original DG Script: #48923

-- Converted from DG Script #48923: sunchild speech
-- Original: MOB trigger, flags: GREET, probability: 100%
local chance = random(1, 10)
if chance > 5 then
    wait(1)
    self.room:send(tostring(self.name) .. " says in a dulcet voice, 'The entire power of the sun is behind me.")
    self.room:send("</>You might as well give up.  I won't let you get to my mistress's lover.'")
end