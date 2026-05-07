-- Trigger: demon wears or removes mask
-- Zone: 625, ID: 80
-- Type: MOB, Flags: RANDOM
-- Status: CLEAN
--
-- Original DG Script: #62580

-- Converted from DG Script #62580: demon wears or removes mask
-- Original: MOB trigger, flags: RANDOM, probability: 30%

-- 30% chance to trigger
if not percent_chance(30) then
    return true
end
-- Wounded demon roars defiance; healthy one toggles its facade mask (625, 80).
if self.hit > 450 then
    local victim = self.room.actors[1]
    if victim and victim ~= self then
        self:command("growl " .. tostring(victim.name))
    else
        self:command("growl")
    end
else
    if self:has_equipped(625, 80) then
        self:command("remove mask")
    else
        self:command("roar")
    end
end
