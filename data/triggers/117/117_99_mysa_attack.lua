-- Trigger: Mysa_Attack
-- Zone: 117, ID: 99
-- Type: MOB, Flags: FIGHT
-- Status: CLEAN
--
-- Original DG Script: #11799

-- Converted from DG Script #11799: Mysa_Attack
-- Original: MOB trigger, flags: FIGHT, probability: 15%

-- 15% chance to trigger
if not percent_chance(15) then
    return true
end
local val = random(1, 10)
do
    local _sw1 = string.lower(tostring(val or ""))
    if tonumber(_sw1) == 1 then
        -- TODO: actor:breath_attack is not yet bound in lua_actor.cpp. Substitute
        -- with the in-game `breathe` command for now so the dragon still emits
        -- a lightning breath; revisit once the binding lands.
        self:command("breathe lightning")
    elseif tonumber(_sw1) == 2 or tonumber(_sw1) == 3 then
        self:command("sweep")
    elseif tonumber(_sw1) == 4 or tonumber(_sw1) == 5 then
        self:command("roar")
    else
        self:command("growl")
    end
end