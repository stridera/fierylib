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
if self.hit > 450 then
    self:command("growl " .. tostring(next_in_room))
else
    if wearing[62580] then
        self:command("remove mask")
    else
        self:command("roar")
    end
end