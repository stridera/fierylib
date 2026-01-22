-- Trigger: genasi-port
-- Zone: 238, ID: 75
-- Type: MOB, Flags: FIGHT
-- Status: CLEAN
--
-- Original DG Script: #23875

-- Converted from DG Script #23875: genasi-port
-- Original: MOB trigger, flags: FIGHT, probability: 15%

-- 15% chance to trigger
if not percent_chance(15) then
    return true
end
local dest_room = random(1, 37) + 23831
self:command("sigh")
self:say("I really don't have time for this right now.")
self.room:send("&9<blue>" .. tostring(self.name) .. " slowly fades out of existence and is gone.</>")
self:teleport(get_room(vnum_to_zone(dest_room), vnum_to_local(dest_room)))
self.room:send("<b:white>" .. tostring(self.name) .. " blinks into existence.</>")