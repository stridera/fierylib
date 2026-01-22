-- Trigger: Green Woman Apothecary shop load
-- Zone: 60, ID: 3
-- Type: MOB, Flags: LOAD
-- Status: NEEDS_REVIEW
--   Complex nesting: 10 if statements
--   Large script: 6419 chars
--
-- Original DG Script: #6003

-- Converted from DG Script #6003: Green Woman Apothecary shop load
-- Original: MOB trigger, flags: LOAD, probability: 100%
wait(2)
local a = 1
while a < 6 do
    local herb = random(1, 12)
    -- switch on herb
    if herb == 1 then
        self.room:spawn_object(125, 52)
    elseif herb == 2 then
        self.room:spawn_object(237, 50)
    elseif herb == 3 then
        self.room:spawn_object(237, 51)
    elseif herb == 4 then
        self.room:spawn_object(237, 52)
    elseif herb == 5 then
        self.room:spawn_object(237, 53)
    elseif herb == 6 then
        self.room:spawn_object(237, 54)
    elseif herb == 7 then
        self.room:spawn_object(237, 55)
    elseif herb == 8 then
        self.room:spawn_object(237, 56)
    elseif herb == 9 then
        self.room:spawn_object(237, 57)
    elseif herb == 10 then
        self.room:spawn_object(237, 58)
    elseif herb == 11 then
        self.room:spawn_object(237, 59)
    else
        self.room:spawn_object(490, 22)
    end
    local a = a + 1
end
a = nil
local potion1 = random(1, 12)
-- switch on potion1
if potion1 == 1 then
    self.room:spawn_object(32, 48)
elseif potion1 == 2 then
    self.room:spawn_object(32, 51)
elseif potion1 == 3 then
    self.room:spawn_object(32, 54)
elseif potion1 == 4 then
    self.room:spawn_object(32, 57)
elseif potion1 == 5 or potion1 == 6 then
    self.room:spawn_object(32, 61)
elseif potion1 == 7 or potion1 == 8 then
    self.room:spawn_object(32, 64)
elseif potion1 == 9 or potion1 == 10 then
    self.room:spawn_object(32, 67)
else
    self.room:spawn_object(32, 70)
end
local potion2 = random(1, 16)
-- switch on potion2
if potion2 == 1 or potion2 == 2 then
    self.room:spawn_object(32, 73)
elseif potion2 == 3 then
    self.room:spawn_object(32, 75)
elseif potion2 == 4 or potion2 == 5 then
    self.room:spawn_object(32, 77)
elseif potion2 == 6 then
    self.room:spawn_object(32, 79)
elseif potion2 == 7 or potion2 == 8 then
    self.room:spawn_object(32, 81)
elseif potion2 == 9 then
    self.room:spawn_object(32, 83)
elseif potion2 == 10 or potion2 == 11 then
    self.room:spawn_object(32, 85)
elseif potion2 == 12 then
    self.room:spawn_object(32, 87)
elseif potion2 == 13 or potion2 == 14 then
    self.room:spawn_object(32, 89)
elseif potion2 == 15 then
    self.room:spawn_object(32, 93)
else
    self.room:spawn_object(32, 95)
end
local a = 1
while a < 4 do
    local potion3 = random(1, 35)
    -- switch on potion3
    if potion3 == 1 then
        self.room:spawn_object(16, 13)
    elseif potion3 == 2 then
        self.room:spawn_object(16, 20)
    elseif potion3 == 3 then
        self.room:spawn_object(16, 21)
    elseif potion3 == 4 then
        self.room:spawn_object(16, 22)
    elseif potion3 == 5 then
        self.room:spawn_object(30, 51)
    elseif potion3 == 6 then
        self.room:spawn_object(30, 59)
    elseif potion3 == 7 then
        self.room:spawn_object(31, 38)
    elseif potion3 == 8 then
        self.room:spawn_object(32, 0)
    elseif potion3 == 9 then
        self.room:spawn_object(32, 15)
    elseif potion3 == 10 then
        self.room:spawn_object(32, 16)
    elseif potion3 == 11 then
        self.room:spawn_object(32, 29)
    elseif potion3 == 12 then
        self.room:spawn_object(32, 30)
    elseif potion3 == 13 then
        self.room:spawn_object(32, 46)
    elseif potion3 == 14 then
        self.room:spawn_object(51, 0)
    elseif potion3 == 15 then
        self.room:spawn_object(52, 7)
    elseif potion3 == 16 then
        self.room:spawn_object(63, 31)
    elseif potion3 == 17 then
        self.room:spawn_object(63, 82)
    elseif potion3 == 18 then
        self.room:spawn_object(73, 2)
    elseif potion3 == 19 then
        self.room:spawn_object(83, 41)
    elseif potion3 == 20 then
        self.room:spawn_object(83, 42)
    elseif potion3 == 21 then
        self.room:spawn_object(83, 45)
    elseif potion3 == 22 then
        self.room:spawn_object(83, 46)
    elseif potion3 == 23 then
        self.room:spawn_object(87, 5)
    elseif potion3 == 24 then
        self.room:spawn_object(87, 6)
    elseif potion3 == 25 then
        self.room:spawn_object(117, 7)
    elseif potion3 == 26 then
        self.room:spawn_object(163, 3)
    elseif potion3 == 27 then
        self.room:spawn_object(169, 0)
    elseif potion3 == 28 then
        self.room:spawn_object(169, 6)
    elseif potion3 == 29 then
        self.room:spawn_object(172, 6)
    elseif potion3 == 30 then
        self.room:spawn_object(302, 14)
    elseif potion3 == 31 then
        self.room:spawn_object(410, 10)
    elseif potion3 == 32 then
        self.room:spawn_object(411, 15)
    elseif potion3 == 33 then
        self.room:spawn_object(510, 8)
    else
        self.room:spawn_object(521, 6)
    end
    local a = a + 1
end
local flower = random(1, 6)
-- switch on flower
if flower == 1 then
    self.room:spawn_object(69, 7)
elseif flower == 2 then
    self.room:spawn_object(180, 3)
elseif flower == 3 then
    self.room:spawn_object(370, 13)
elseif flower == 4 then
    self.room:spawn_object(615, 10)
elseif flower == 5 then
else
    self.room:spawn_object(583, 55)
end
local bonus = random(1, 3)
if bonus == 1 then
    local armor = random(1, 40)
    if armor < 11 then
        self.room:spawn_object(136, 47)
    elseif armor < 21 then
        local item = random(1, 4)
        -- switch on item
        if item == 1 then
            self.room:spawn_object(411, 16)
        elseif item == 2 then
            self.room:spawn_object(23, 29)
        elseif item == 3 then
            self.room:spawn_object(123, 37)
        else
            self.room:spawn_object(123, 40)
        end
    elseif armor < 31 then
        local item = random(1, 5)
        -- switch on item
        if item == 1 then
            self.room:spawn_object(62, 23)
        elseif item == 2 then
            self.room:spawn_object(123, 27)
        elseif item == 3 then
            self.room:spawn_object(123, 25)
        elseif item == 4 then
            self.room:spawn_object(123, 28)
        else
            self.room:spawn_object(123, 26)
        end
    elseif armor < 40 then
        local item = random(1, 4)
        -- switch on item
        if item == 1 or item == 2 then
            self.room:spawn_object(490, 14)
        else
            self.room:spawn_object(490, 63)
        end
    elseif armor == 40 then
        self.room:spawn_object(584, 31)
    end
end