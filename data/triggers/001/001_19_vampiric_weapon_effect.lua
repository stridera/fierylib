-- Trigger: vampiric weapon effect
-- Zone: 1, ID: 19
-- Type: OBJECT, Flags: ATTACK
-- Status: CLEAN
--
-- Original DG Script: #119

-- Converted from DG Script #119: vampiric weapon effect
-- Original: OBJECT trigger, flags: ATTACK, probability: 3%

-- 3% chance to trigger
if not percent_chance(3) then
    return true
end
actor:send("A &9<blue>black haze</> forms around your sword as you strike " .. victim.name .. "!")
victim:send("A &9<blue>black haze</> forms around " .. actor.name .. "'s sword as " .. actor.heshe .. " strikes you!")
spells.cast(self, "vampiric breath", victim, actor.level)