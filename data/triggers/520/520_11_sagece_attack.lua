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
do
    local _sw1 = string.lower(tostring(value or ""))
    if tonumber(_sw1) == 1 then
        self:breath_attack("fire", nil)
    elseif tonumber(_sw1) == 2 or tonumber(_sw1) == 3 then
        self:command("sweep")
    elseif tonumber(_sw1) == 4 or tonumber(_sw1) == 5 then
        self:command("roar")
    elseif tonumber(_sw1) == 6 then
        run_room_trigger(520, 20)
    elseif tonumber(_sw1) == 7 then
        run_room_trigger(520, 21)
    else
        self:command("growl")
    end
end