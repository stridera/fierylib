-- Trigger: solar-battle
-- Zone: 238, ID: 7
-- Type: MOB, Flags: FIGHT
--
-- During combat (15% chance), the solar may cast divine ray (~40% sub-chance).

-- 15% chance to trigger
if not percent_chance(15) then
    return true
end
if random(1, 10) < 5 then
    spells.cast(self, "divine ray")
end
