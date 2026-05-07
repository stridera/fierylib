-- Trigger: flood_lady_random
-- Zone: 390, ID: 0
-- Type: MOB, Flags: RANDOM
-- Status: CLEAN
--
-- Original DG Script: #39000
--
-- The Lady of the Sea rages at the settlement gate, screaming threats
-- and pounding the waves against it. Picks one of four ambient lines.

if not percent_chance(10) then
    return true
end

local roll = random(1, 4)
if roll == 1 then
    self:emote("screams in fury!")
elseif roll == 2 then
    self:emote("screams, 'I WILL TAKE BACK WHAT YOU HAVE STOLEN!'")
    self:emote("bangs furiously on the gate.")
elseif roll == 3 then
    self.room:send("The waves slam against the gate!")
    self:emote("screams, 'YOU WILL NOT ESCAPE THE SEA'S WRATH.'")
else
    self:emote("screams, 'THE SEA WILL RISE TO FLOOD YOU.'")
end