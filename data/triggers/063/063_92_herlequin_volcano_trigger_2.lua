-- Trigger: Herlequin volcano trigger 2
-- Zone: 63, ID: 92
-- Type: OBJECT, Flags: RANDOM
-- Status: NEEDS_REVIEW
--   -- UNCONVERTED: %victim.name%!
--   -- UNCONVERTED: %victim.name% right on the head! (&1&b%damdone%&0)
--   -- UNCONVERTED: OUCH! (&1&b%damdone%&0)
--
-- Original DG Script: #6392

-- Converted from DG Script #6392: Herlequin volcano trigger 2
-- Original: OBJECT trigger, flags: RANDOM, probability: 100%
local dice1 = random(1, 100)
local dice2 = random(1, 100)
local damage = dice1 + dice2
local victim = room.actors[random(1, #room.actors)]
self.room:send("A massive volcano shoots out a <b:red>flaming rock</>!")
wait(2)
local damage_dealt = victim:damage(damage)  -- type: crush
if damage_dealt == 0 then
    self.room:send_except(victim, "A <b:red>flaming</> rock falls right next to")
    -- UNCONVERTED: %victim.name%!
    victim:send("A <b:red>flaming</> rock falls right next to you!")
else
    self.room:send_except(victim, "A <b:red>flaming</> rock falls from the sky, smashing")
    -- UNCONVERTED: %victim.name% right on the head! (&1&b%damdone%&0)
    victim:send("A <b:red>flaming rock</> slams you directly on the head!")
    -- UNCONVERTED: OUCH! (&1&b%damdone%&0)
end