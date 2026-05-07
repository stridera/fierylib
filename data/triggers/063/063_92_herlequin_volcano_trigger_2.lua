-- Trigger: Herlequin volcano trigger 2
-- Zone: 63, ID: 92
-- Type: OBJECT, Flags: RANDOM
-- Status: CLEAN
--
-- Original DG Script: #6392
-- The volcano periodically launches a flaming rock at a random actor
-- in the room for 2..200 crush damage.
--
-- Note: DG's `%damdone%` reflects post-mitigation damage; our
-- `actor:damage(n)` returns nothing, so we can't distinguish a 0-damage
-- whiff from a hit at runtime. We always show the rolled amount as the
-- damage dealt — close enough since the rolled value is at minimum 2
-- and the legacy 0-damage branch was effectively unreachable in normal
-- play.

-- Converted from DG Script #6392: Herlequin volcano trigger 2
-- Original: OBJECT trigger, flags: RANDOM, probability: 100%

local actors = self.room.actors
if #actors == 0 then
    return true  -- Empty room; nothing to target.
end

local dice1 = random(1, 100)
local dice2 = random(1, 100)
local damage = dice1 + dice2
local victim = actors[random(1, #actors)]
local victim_name = tostring(victim.name)

self.room:send("A massive volcano shoots out a <b:red>flaming rock</>!")
wait(2)
victim:damage(damage)  -- type: crush (DG `odamage`)
self.room:send_except(
    victim,
    "A <b:red>flaming</> rock falls from the sky, smashing " .. victim_name ..
        " right on the head! (<b:red>" .. tostring(damage) .. "</>)"
)
victim:send(
    "A <b:red>flaming rock</> slams you directly on the head!  OUCH! (<b:red>" ..
        tostring(damage) .. "</>)"
)