-- Trigger: blur_winds_preentry
-- Zone: 18, ID: 33
-- Type: WORLD, Flags: PREENTRY
-- Status: CLEAN
--
-- Original DG Script: #1833
-- TODO(parity): legacy 5-digit room vnums 10001/2460/48223/20379 are the four
-- wind shrines. Translate to composite (zone_id, local_id) once the legacy
-- vnum→composite map is confirmed. Until then this branches off self.id which
-- is the live entity id, not a stable world id — this likely never matches.

-- Converted from DG Script #1833: blur_winds_preentry
-- Original: WORLD trigger, flags: PREENTRY, probability: 100%
if actor:get_quest_stage("blur") ~= 4 then
    return true
end

local direction
local mob
if self.zone_id == 100 and self.local_id == 1 then  -- North wind shrine (legacy 10001)
    direction = "north"
    mob = 19
elseif self.zone_id == 24 and self.local_id == 60 then  -- South wind shrine (legacy 2460)
    direction = "south"
    mob = 20
elseif self.zone_id == 482 and self.local_id == 23 then  -- East wind shrine (legacy 48223)
    direction = "east"
    mob = 21
elseif self.zone_id == 203 and self.local_id == 79 then  -- West wind shrine (legacy 20379)
    direction = "west"
    mob = 22
end

if mob and (actor:get_quest_var("blur:" .. direction) == 0 or actor:get_quest_var("blur:" .. direction) == "") and world.count_mobiles(18, mob) == 0 then
    self.room:spawn_mobile(18, mob)
end
return true