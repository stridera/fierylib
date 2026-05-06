-- Trigger: vityaz_random_move
-- Zone: 123, ID: 25
-- Type: MOB, Flags: GLOBAL, RANDOM
-- Status: CLEAN
--
-- Original DG Script: #12325

-- Converted from DG Script #12325: vityaz_random_move
-- Original: MOB trigger, flags: GLOBAL, RANDOM, probability: 40%

-- 40% chance to trigger
if not percent_chance(40) then
    return true
end
local _return_value = true  -- Default: allow action
-- Pretty fluff.  Makes sparks.  Pure aesthetics.
--
local rndm = random(1, 5)
if rndm == 1 then
    self.room:send(tostring(mobiles.template(123, 2).name) .. " utters a few arcane words in the old Tzigane tongue.")
elseif rndm == 2 then
    if self:has_equipped(123, 8) then
        local mob_name = mobiles.template(123, 2) and tostring(mobiles.template(123, 2).name) or "the warrior"
        local obj_name = objects.template(123, 8) and tostring(objects.template(123, 8).name) or "a weapon"
        self.room:send("<b:white>S</><b:yellow>P</><b:cyan>A</><b:yellow>R</><b:white>K</><b:yellow>S</> fly as " .. mob_name .. " trails " .. obj_name .. " along the ground.")
    end
elseif rndm >= 3 then
    -- Patrol route: all rooms in zone 123
    local rid = self.room.local_id
    if rid == 45 or rid == 46 or rid == 47 or rid == 48 or rid == 58 or rid == 63 then
        self:move("south")
    elseif rid == 49 or rid == 64 or rid == 78 or rid == 92 or rid == 112 or rid == 126 then
        self:move("west")
    elseif rid == 127 or rid == 141 or rid == 140 or rid == 139 or rid == 138 or rid == 122 then
        self:move("north")
    elseif rid == 137 or rid == 121 or rid == 106 or rid == 86 or rid == 72 or rid == 59 then
        self:move("east")
    end
end
return _return_value
