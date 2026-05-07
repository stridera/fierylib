-- Trigger: genasi-port
-- Zone: 238, ID: 75
-- Type: MOB, Flags: FIGHT
--
-- Combat escape (15% chance per round): the genasi sighs, complains, and
-- teleports to a random room in zone 238 in the range 32..68.

-- 15% chance to trigger
if not percent_chance(15) then
    return true
end
local dest_local_id = random(1, 37) + 31
self:command("sigh")
self:say("I really don't have time for this right now.")
self.room:send("&9<blue>" .. tostring(self.name) .. " slowly fades out of existence and is gone.</>")
self:teleport(get_room(238, dest_local_id))
self.room:send("<b:white>" .. tostring(self.name) .. " blinks into existence.</>")
