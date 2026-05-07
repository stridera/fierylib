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
local hit = self.room.actors[random(1, #self.room.actors)]
-- Skip if rolled the mild merchant himself (625, 6).
if hit.zone_id ~= 625 or hit.local_id ~= 6 then
    combat.engage(self, hit)
end