-- Soak test: 510:6 non_clerics_out reads room occupants via self.room; 30:180 load random gems passes (zone, id) to has_equipped
--
-- Idempotent: a row already holding the new body is left alone, so rerunning
-- updates nothing. Keyed by the composite primary key (zone_id, id).
-- Guarded: a row is only touched while it still holds the previous committed
-- body (md5), so rows edited in Muditor since then are left alone.

BEGIN;

UPDATE "Triggers" AS t
SET commands = v.commands,
    updated_at = now()
FROM (VALUES
  -- data/triggers/030/030_180_load_random_gems.lua
  (30, 180, $trig$-- Converted from DG Script #3180: load random gems
-- Original: MOB trigger, flags: GREET, probability: 100%
if self:has_effect(Effect.Invisible) then
    self:command("vis")
end
-- number of gems to load -- starting at 3, but that might be too many
local loop = 3
-- gem IDs go from  to 55566-55751
-- p1 IDs from 55566-55593
-- p2 IDs from 55594-55670
-- P3 cnums from 55671-55747 (there are gems up to 55751, but not used.
-- random # -- 1-10 to create probabilities of good gem
-- 0 = NO GEM
-- 1 = NO GEM
-- 2-6 = P1 Gem
-- 7-9 = P2 Gem
-- 10  = P3 Gem
-- -- lets see if we should run process to get gems
-- -- we do that by looking for object 18701 -- if we are wearing it
-- -- then we don't need to load gems again
-- all the important stuff encased in this loop
if not self:has_equipped(187, 1) then
    self.room:spawn_object(187, 1)
    get_room(11, 0):at(function()
        self:command("wear lock")
    end)
    local itt = 1
    while itt <= loop do
        local p = random(1, 10)
        local base = 0
        local extra = 0
        if p == 10 then
            base = 55671
            extra = random(1, 76)
        elseif (p <= 9) and (p >= 7) then
            -- p2 gem
            base = 55594
            extra = random(1, 76)
        elseif (p <= 6) and (p >= 2) then
            -- p1 gem
            base = 55566
            extra = random(1, 27)
        end
        -- p < 2 leaves base/extra at 0 (no gem)
        if base > 55560 then
            local gem = base + extra
            self.room:spawn_object(math.floor(gem / 100), gem % 100)
            self:command("sell gem elspeth")
        end
        itt = itt + 1
    end
    self:command("chuckle")
    self:say("you wouldn't believe who I had to beat down to get these")
    self:command("flex")
end
-- 
-- Adding hint to find Rogue Guild for Elspeth
-- 
if (self.zone_id == 30 and self.id == 10) then
    if actor.class == "Rogue" and actor.level < 10 then
        wait(4)
        actor:send(tostring(self.name) .. " notices you skulking about her shop.")
        actor:send("<b:white>" .. tostring(self.name) .. " tells you, 'If you're looking for a certain Guild Hall, <cyan>search<white> behind</>")
        actor:send("</><b:white>the <cyan>curtain<white> on the wall.'</>")
    end
end$trig$, 'e4486ab9b3112ea55be6cd315065cdac'),
  -- data/triggers/510/510_06_non_clerics_out.lua
  (510, 6, $trig$-- `self` is the room's actor handle; occupants live on its LuaRoom.
local room = self.room
if not room or room.actor_count == 0 then
    return true
end

local rnd = room.actors[random(1, room.actor_count)]
if not rnd or not rnd.is_player or rnd.level >= 100 then
    return true
end

if string.find(rnd.class, "Cleric") or string.find(rnd.class, "Priest") then
    return true
end

rnd:send("You feel a force pushing you out of the room - you are powerless to resist!")
room:send_except(rnd, tostring(rnd.name) .. " suddenly starts moving out of the room.")
rnd:teleport(get_room(510, 50))
rnd:send("You seem to hear a voice whisper, 'This room is not for you.'")
wait(8)
rnd:command("look")$trig$, '5620045346174c8338e5b4cbd73780d1')
) AS v(zone_id, id, commands, old_md5)
WHERE t.zone_id = v.zone_id
  AND t.id = v.id
  AND md5(t.commands) = v.old_md5
  AND t.commands IS DISTINCT FROM v.commands;

COMMIT;
