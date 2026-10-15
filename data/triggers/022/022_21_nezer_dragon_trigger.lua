-- Trigger: Nezer_Dragon_trigger
-- Zone: 22, ID: 21
-- Type: MOB, Flags: FIGHT
-- Status: CLEAN
--
-- Original DG Script: #2221

-- Converted from DG Script #2221: Nezer_Dragon_trigger
-- Original: MOB trigger, flags: FIGHT, probability: 15%

-- 15% chance to trigger
if not percent_chance(15) then
    return true
end
local val = random(1, 10)
-- switch on val
do
    local _sw1 = string.lower(tostring(val or ""))
    if tonumber(_sw1) == 1 then
        self:breath_attack("fire", nil)
    elseif tonumber(_sw1) == 2 or tonumber(_sw1) == 3 then
        self:command("sweep")
    elseif tonumber(_sw1) == 4 or tonumber(_sw1) == 5 then
        self:command("roar")
    else
        self:command("growl")
    end
end