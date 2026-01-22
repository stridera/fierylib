-- Trigger: flood_lady_random
-- Zone: 390, ID: 0
-- Type: MOB, Flags: RANDOM
-- Status: CLEAN
--
-- Original DG Script: #39000

-- Converted from DG Script #39000: flood_lady_random
-- Original: MOB trigger, flags: RANDOM, probability: 10%

-- 10% chance to trigger
if not percent_chance(10) then
    return true
end
-- switch on random(1, 4)
if random(1, 4) == 1 then
    self:emote("screams in fury!")
elseif random(1, 4) == 2 then
    self:emote("screams, 'I WILL TAKE BACK WHAT YOU HAVE STOLEN!'")
    self:emote("bangs furiously on the gate.")
elseif random(1, 4) == 3 then
    self.room:send("The waves slam against the gate!")
    self:emote("screams, 'YOU WILL NOT ESCAPE THE SEA'S WRATH.'")
else
    self:emote("screams, 'THE SEA WILL RISE TO FLOOD YOU.'")
end