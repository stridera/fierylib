-- Trigger: Sunbird_greet
-- Zone: 581, ID: 2
-- Type: MOB, Flags: GREET
-- Status: CLEAN
--
-- Original DG Script: #58102

-- Converted from DG Script #58102: Sunbird_greet
-- Original: MOB trigger, flags: GREET, probability: 100%
if actor.id == -1 and actor.level < 100 then
    wait(1)
    self:command("bow " .. tostring(actor))
    self:say("Come, take shelter in the holy light of Kannon, Goddess of Mercy.")
end