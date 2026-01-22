-- Trigger: Sagece_Attack
-- Zone: 520, ID: 11
-- Type: MOB, Flags: FIGHT
-- Status: CLEAN
--
-- Original DG Script: #52011

-- Converted from DG Script #52011: Sagece_Attack
-- Original: MOB trigger, flags: FIGHT, probability: 30%

-- 30% chance to trigger
if not percent_chance(30) then
    return true
end
wait(1)
local value = random(1, 10)
-- switch on value
if value == 1 then
    self:breath_attack("fire", nil)
elseif value == 2 or value == 3 then
    self:command("sweep")
elseif value == 4 or value == 5 then
    self:command("roar")
elseif value == 6 then
    run_room_trigger(52020)
elseif value == 7 then
    run_room_trigger(52021)
else
    self:command("growl")
end