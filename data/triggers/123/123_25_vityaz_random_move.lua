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
    if self:has_equipped("12308") then
        self.room:send("<b:white>S</><b:yellow>P</><b:cyan>A</><b:yellow>R</><b:white>K</><b:yellow>S</> fly as " .. "%get.mob_shortdesc[12302]% trails %get.obj_shortdesc[12308]% along the ground.")
    end
elseif rndm >= 3 then
    -- switch on self.room
    if self.room == 12347 then
        self:move("south")
        return _return_value
    elseif self.room == 12348 then
        self:move("south")
        return _return_value
    elseif self.room == 12363 then
        self:move("south")
        return _return_value
    elseif self.room == 12358 then
        self:move("south")
        return _return_value
    elseif self.room == 12345 then
        self:move("south")
        return _return_value
    elseif self.room == 12346 then
        self:move("south")
        return _return_value
    elseif self.room == 12349 then
        self:move("west")
        return _return_value
    elseif self.room == 12364 then
        self:move("west")
        return _return_value
    elseif self.room == 12378 then
        self:move("west")
        return _return_value
    elseif self.room == 12392 then
        self:move("west")
        return _return_value
    elseif self.room == 12412 then
        self:move("west")
        return _return_value
    elseif self.room == 12426 then
        self:move("west")
        return _return_value
    elseif self.room == 12427 then
        self:move("north")
        return _return_value
    elseif self.room == 12441 then
        self:move("north")
        return _return_value
    elseif self.room == 12440 then
        self:move("north")
        return _return_value
    elseif self.room == 12439 then
        self:move("north")
        return _return_value
    elseif self.room == 12438 then
        self:move("north")
        return _return_value
    elseif self.room == 12422 then
        self:move("north")
        return _return_value
    elseif self.room == 12437 then
        self:move("east")
        return _return_value
    elseif self.room == 12421 then
        self:move("east")
        return _return_value
    elseif self.room == 12406 then
        self:move("east")
        return _return_value
    elseif self.room == 12386 then
        self:move("east")
        return _return_value
    elseif self.room == 12372 then
        self:move("east")
        return _return_value
    elseif self.room == 12359 then
        self:move("east")
        return _return_value
    else
        _return_value = false
    end
end
return _return_value