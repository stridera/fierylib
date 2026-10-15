-- Trigger: Green Woman Apothecary shop load
-- Zone: 60, ID: 3
-- Type: MOB, Flags: LOAD
--
-- Original DG Script: #6003

-- Converted from DG Script #6003: Green Woman Apothecary shop load
-- Original: MOB trigger, flags: LOAD, probability: 100%
wait(2)
local a = 1
while a < 6 do
    local herb = random(1, 12)
    -- switch on herb
    do
        local _sw1 = string.lower(tostring(herb or ""))
        if tonumber(_sw1) == 1 then
            self.room:spawn_object(125, 52)
        elseif tonumber(_sw1) == 2 then
            self.room:spawn_object(237, 50)
        elseif tonumber(_sw1) == 3 then
            self.room:spawn_object(237, 51)
        elseif tonumber(_sw1) == 4 then
            self.room:spawn_object(237, 52)
        elseif tonumber(_sw1) == 5 then
            self.room:spawn_object(237, 53)
        elseif tonumber(_sw1) == 6 then
            self.room:spawn_object(237, 54)
        elseif tonumber(_sw1) == 7 then
            self.room:spawn_object(237, 55)
        elseif tonumber(_sw1) == 8 then
            self.room:spawn_object(237, 56)
        elseif tonumber(_sw1) == 9 then
            self.room:spawn_object(237, 57)
        elseif tonumber(_sw1) == 10 then
            self.room:spawn_object(237, 58)
        elseif tonumber(_sw1) == 11 then
            self.room:spawn_object(237, 59)
        else
            self.room:spawn_object(490, 22)
        end
    end
    a = a + 1
end
a = nil
local potion1 = random(1, 12)
-- switch on potion1
do
    local _sw2 = string.lower(tostring(potion1 or ""))
    if tonumber(_sw2) == 1 then
        self.room:spawn_object(30, 248)
    elseif tonumber(_sw2) == 2 then
        self.room:spawn_object(30, 251)
    elseif tonumber(_sw2) == 3 then
        self.room:spawn_object(30, 254)
    elseif tonumber(_sw2) == 4 then
        self.room:spawn_object(30, 257)
    elseif tonumber(_sw2) == 5 or tonumber(_sw2) == 6 then
        self.room:spawn_object(30, 261)
    elseif tonumber(_sw2) == 7 or tonumber(_sw2) == 8 then
        self.room:spawn_object(30, 264)
    elseif tonumber(_sw2) == 9 or tonumber(_sw2) == 10 then
        self.room:spawn_object(30, 267)
    else
        self.room:spawn_object(30, 270)
    end
end
local potion2 = random(1, 16)
-- switch on potion2
do
    local _sw3 = string.lower(tostring(potion2 or ""))
    if tonumber(_sw3) == 1 or tonumber(_sw3) == 2 then
        self.room:spawn_object(30, 273)
    elseif tonumber(_sw3) == 3 then
        self.room:spawn_object(30, 275)
    elseif tonumber(_sw3) == 4 or tonumber(_sw3) == 5 then
        self.room:spawn_object(30, 277)
    elseif tonumber(_sw3) == 6 then
        self.room:spawn_object(30, 279)
    elseif tonumber(_sw3) == 7 or tonumber(_sw3) == 8 then
        self.room:spawn_object(30, 281)
    elseif tonumber(_sw3) == 9 then
        self.room:spawn_object(30, 283)
    elseif tonumber(_sw3) == 10 or tonumber(_sw3) == 11 then
        self.room:spawn_object(30, 285)
    elseif tonumber(_sw3) == 12 then
        self.room:spawn_object(30, 287)
    elseif tonumber(_sw3) == 13 or tonumber(_sw3) == 14 then
        self.room:spawn_object(30, 289)
    elseif tonumber(_sw3) == 15 then
        self.room:spawn_object(30, 293)
    else
        self.room:spawn_object(30, 295)
    end
end
local a = 1
while a < 4 do
    local potion3 = random(1, 35)
    -- switch on potion3
    do
        local _sw4 = string.lower(tostring(potion3 or ""))
        if tonumber(_sw4) == 1 then
            self.room:spawn_object(16, 13)
        elseif tonumber(_sw4) == 2 then
            self.room:spawn_object(16, 20)
        elseif tonumber(_sw4) == 3 then
            self.room:spawn_object(16, 21)
        elseif tonumber(_sw4) == 4 then
            self.room:spawn_object(16, 22)
        elseif tonumber(_sw4) == 5 then
            self.room:spawn_object(30, 51)
        elseif tonumber(_sw4) == 6 then
            self.room:spawn_object(30, 59)
        elseif tonumber(_sw4) == 7 then
            self.room:spawn_object(30, 138)
        elseif tonumber(_sw4) == 8 then
            self.room:spawn_object(30, 200)
        elseif tonumber(_sw4) == 9 then
            self.room:spawn_object(30, 215)
        elseif tonumber(_sw4) == 10 then
            self.room:spawn_object(30, 216)
        elseif tonumber(_sw4) == 11 then
            self.room:spawn_object(30, 229)
        elseif tonumber(_sw4) == 12 then
            self.room:spawn_object(30, 230)
        elseif tonumber(_sw4) == 13 then
            self.room:spawn_object(30, 246)
        elseif tonumber(_sw4) == 14 then
            self.room:spawn_object(51, 0)
        elseif tonumber(_sw4) == 15 then
            self.room:spawn_object(52, 7)
        elseif tonumber(_sw4) == 16 then
            self.room:spawn_object(63, 31)
        elseif tonumber(_sw4) == 17 then
            self.room:spawn_object(63, 82)
        elseif tonumber(_sw4) == 18 then
            self.room:spawn_object(73, 2)
        elseif tonumber(_sw4) == 19 then
            self.room:spawn_object(83, 41)
        elseif tonumber(_sw4) == 20 then
            self.room:spawn_object(83, 42)
        elseif tonumber(_sw4) == 21 then
            self.room:spawn_object(83, 45)
        elseif tonumber(_sw4) == 22 then
            self.room:spawn_object(83, 46)
        elseif tonumber(_sw4) == 23 then
            self.room:spawn_object(87, 5)
        elseif tonumber(_sw4) == 24 then
            self.room:spawn_object(87, 6)
        elseif tonumber(_sw4) == 25 then
            self.room:spawn_object(117, 7)
        elseif tonumber(_sw4) == 26 then
            self.room:spawn_object(163, 3)
        elseif tonumber(_sw4) == 27 then
            self.room:spawn_object(169, 0)
        elseif tonumber(_sw4) == 28 then
            self.room:spawn_object(169, 6)
        elseif tonumber(_sw4) == 29 then
            self.room:spawn_object(172, 6)
        elseif tonumber(_sw4) == 30 then
            self.room:spawn_object(302, 14)
        elseif tonumber(_sw4) == 31 then
            self.room:spawn_object(410, 10)
        elseif tonumber(_sw4) == 32 then
            self.room:spawn_object(411, 15)
        elseif tonumber(_sw4) == 33 then
            self.room:spawn_object(510, 8)
        else
            self.room:spawn_object(521, 6)
        end
    end
    a = a + 1
end
local flower = random(1, 6)
-- switch on flower
do
    local _sw5 = string.lower(tostring(flower or ""))
    if tonumber(_sw5) == 1 then
        self.room:spawn_object(69, 7)
    elseif tonumber(_sw5) == 2 then
        self.room:spawn_object(180, 3)
    elseif tonumber(_sw5) == 3 then
        self.room:spawn_object(370, 13)
    elseif tonumber(_sw5) == 4 then
        self.room:spawn_object(615, 10)
    else
        self.room:spawn_object(583, 55)
    end
end
local bonus = random(1, 3)
if bonus == 1 then
    local armor = random(1, 40)
    if armor < 11 then
        self.room:spawn_object(136, 47)
    elseif armor < 21 then
        local item = random(1, 4)
        -- switch on item
        do
            local _sw6 = string.lower(tostring(item or ""))
            if tonumber(_sw6) == 1 then
                self.room:spawn_object(411, 16)
            elseif tonumber(_sw6) == 2 then
                self.room:spawn_object(23, 29)
            elseif tonumber(_sw6) == 3 then
                self.room:spawn_object(123, 37)
            else
                self.room:spawn_object(123, 40)
            end
        end
    elseif armor < 31 then
        local item = random(1, 5)
        -- switch on item
        do
            local _sw7 = string.lower(tostring(item or ""))
            if tonumber(_sw7) == 1 then
                self.room:spawn_object(62, 23)
            elseif tonumber(_sw7) == 2 then
                self.room:spawn_object(123, 27)
            elseif tonumber(_sw7) == 3 then
                self.room:spawn_object(123, 25)
            elseif tonumber(_sw7) == 4 then
                self.room:spawn_object(123, 28)
            else
                self.room:spawn_object(123, 26)
            end
        end
    elseif armor < 40 then
        local item = random(1, 4)
        -- switch on item
        do
            local _sw8 = string.lower(tostring(item or ""))
            if tonumber(_sw8) == 1 or tonumber(_sw8) == 2 then
                self.room:spawn_object(490, 14)
            else
                self.room:spawn_object(490, 63)
            end
        end
    elseif armor == 40 then
        self.room:spawn_object(584, 31)
    end
end