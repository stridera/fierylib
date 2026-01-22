-- Trigger: keep-maidservant
-- Zone: 489, ID: 1
-- Type: MOB, Flags: GREET
-- Status: CLEAN
--
-- Original DG Script: #48901

-- Converted from DG Script #48901: keep-maidservant
-- Original: MOB trigger, flags: GREET, probability: 100%
local chance = random(1, 10)
if chance > 5 then
    wait(1)
    self.room:send(tostring(self.name) .. " says, 'Lokari bought me out of slavery and freed me,' more")
    self.room:send("</>to herself than you.")
    wait(1)
    self:say("I won't let you harm him.")
end