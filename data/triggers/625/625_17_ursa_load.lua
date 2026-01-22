-- Trigger: ursa load
-- Zone: 625, ID: 17
-- Type: MOB, Flags: LOAD
-- Status: CLEAN
--
-- Original DG Script: #62517

-- Converted from DG Script #62517: ursa load
-- Original: MOB trigger, flags: LOAD, probability: 100%
skills.set_level(self, "hitall", 100)
skills.set_level(self, "roar", 100)
self:command("roar")
local hit = room.actors[random(1, #room.actors)]
if hit.id ~= 62506 then
    combat.engage(self, hit)
else
    return _return_value
end