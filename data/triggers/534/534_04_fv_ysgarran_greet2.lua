-- Trigger: fv_ysgarran_greet2
-- Zone: 534, ID: 4
-- Type: MOB, Flags: GREET
-- Status: CLEAN
--
-- Original DG Script: #53404

-- Converted from DG Script #53404: fv_ysgarran_greet2
-- Original: MOB trigger, flags: GREET, probability: 30%

-- 30% chance to trigger
if not percent_chance(30) then
    return true
end
actor:send(tostring(self.name) .. " tells you, 'Hello Traveler, I am Ysgarran'")
self:command("bow")