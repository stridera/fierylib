-- Trigger: Sunbird_greet
-- Zone: 580, ID: 102
-- Type: MOB, Flags: GREET
-- Status: CLEAN
--
-- Sunbird greets sub-100 players by bowing and inviting them under
-- Kannon's protection.
if actor.is_player and actor.level < 100 then
    wait(1)
    self:command("bow " .. tostring(actor))
    self:say("Come, take shelter in the holy light of Kannon, Goddess of Mercy.")
end