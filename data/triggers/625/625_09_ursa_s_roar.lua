-- Trigger: Ursa's roar
-- Zone: 625, ID: 9
-- Type: MOB, Flags: GREET, FIGHT
-- Status: CLEAN
--
-- Original DG Script: #62509

-- Converted from DG Script #62509: Ursa's roar
-- Original: MOB trigger, flags: GREET, FIGHT, probability: 100%
local chance = random(1, 10)
wait(1)
if chance < 4 then
    wait(1)
    run_room_trigger(62504)
elseif chance < 6 then
    self:attack_all()
elseif chance < 8 then
    self:command("roar")
end