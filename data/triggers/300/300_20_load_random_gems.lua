-- Trigger: load random gems
-- Zone: 300, ID: 20
-- Type: MOB, Flags: GREET
-- Status: CLEAN
--
-- Original DG Script: #30020
--
-- Replenishes Jhanna's (the gem-merchant's) shop stock by loading and selling
-- a few randomly tiered gems whenever a player walks in, gated on whether the
-- mob is already wearing the "wear-lock" item 187:1 (which prevents re-runs
-- within a single session).
--
-- Gem ranges (legacy vnum -> composite):
--   p1: 55566-55593  -> (555, 66)..(555, 93)   28 entries
--   p2: 55594-55670  -> (555, 94)..(556, 70)   77 entries
--   p3: 55671-55747  -> (556, 71)..(557, 47)   77 entries
-- Tier roll on 1d10:
--   1     -> no gem
--   2-6   -> p1
--   7-9   -> p2
--   10    -> p3

-- Number of gems to attempt to spawn-and-sell on each greet.
local LOOP_COUNT = 3

-- 187:1 is the "wear-lock" sentinel object; presence on equipment means we
-- already topped up gems for this session.
if self:has_equipped(187, 1) then
    return true
end

-- Spawn the wear-lock and put it on. The legacy script used a remote-room
-- helper to issue the wear command; in the modern API we simply command
-- ourselves directly.
self.room:spawn_object(187, 1)
self:command("wear lock")

for _ = 1, LOOP_COUNT do
    local p = random(1, 10)
    local base, extra = 0, 0
    if p == 10 then
        base = 55671
        extra = random(0, 76)
    elseif p >= 7 then
        base = 55594
        extra = random(0, 76)
    elseif p >= 2 then
        base = 55566
        extra = random(0, 27)
    end
    -- TODO: review tier ranges -- legacy comments hint at off-by-one in p1
    -- (28 entries vs random(1,27) original). Using random(0, N-1) here.
    if base > 0 then
        local gem = base + extra
        self.room:spawn_object(math.floor(gem / 100), gem % 100)
        self:command("sell gem Jhanna")
    end
end
return true