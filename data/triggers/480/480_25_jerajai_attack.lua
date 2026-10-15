-- Trigger: Jerajai_Attack
-- Zone: 480, ID: 25
-- Type: MOB, Flags: FIGHT
-- Status: CLEAN
--
-- Original DG Script: #48025

-- Converted from DG Script #48025: Jerajai_Attack
-- Original: MOB trigger, flags: FIGHT, probability: 20%

-- 20% chance to trigger
if not percent_chance(20) then
    return true
end
local val = random(1, 10)
-- switch on val
do
    local _sw1 = string.lower(tostring(val or ""))
    if tonumber(_sw1) == 1 then
        self:breath_attack("acid", nil)
    elseif tonumber(_sw1) == 2 or tonumber(_sw1) == 3 then
        self:command("sweep")
    elseif tonumber(_sw1) == 4 or tonumber(_sw1) == 5 then
        self:command("roar")
    else
        self:command("growl")
    end
end