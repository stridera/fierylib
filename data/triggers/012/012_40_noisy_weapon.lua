-- Trigger: Noisy Weapon
-- Zone: 12, ID: 40
-- Type: OBJECT, Flags: ATTACK
-- Status: CLEAN
--
-- Original DG Script: #1240

-- Converted from DG Script #1240: Noisy Weapon
-- Original: OBJECT trigger, flags: ATTACK, probability: 20%

-- 20% chance to trigger
if not percent_chance(20) then
    return true
end
local rndm = random(1, 10)
if damage == 0 then
    -- switch on rndm
    do
        local _sw1 = string.lower(tostring(rndm or ""))
        if tonumber(_sw1) == 1 then
            self.room:send(tostring(self.shortdesc) .. " says, \"Wow, totally missed that one.\"")
        elseif tonumber(_sw1) == 2 then
            self.room:send(tostring(self.shortdesc) .. " says, \"Where were you swinging?\"")
        elseif tonumber(_sw1) == 3 then
            self.room:send(tostring(self.shortdesc) .. " says, \"Are you even trying?\"")
        elseif tonumber(_sw1) == 4 then
            self.room:send(tostring(self.shortdesc) .. " says, \"No. Not like that.  You're supposed to HIT them!\"")
        elseif tonumber(_sw1) == 5 then
            self.room:send(tostring(self.shortdesc) .. " says, \"Why couldn't that other warrior have picked me up.\"")
        elseif tonumber(_sw1) == 6 then
            self.room:send(tostring(self.shortdesc) .. " says, \"Welp, I guess I will stay cleaner if you never hit.\"")
        elseif tonumber(_sw1) == 7 then
            self.room:send(tostring(self.shortdesc) .. " says, \"Missed again, big surprise.\"")
        elseif tonumber(_sw1) == 8 then
            self.room:send(tostring(self.shortdesc) .. " says, \"Oh, so close.\"")
        elseif tonumber(_sw1) == 9 then
            self.room:send(tostring(self.shortdesc) .. " says, \"Not even close that time.\"")
        elseif tonumber(_sw1) == 10 then
            self.room:send(tostring(self.shortdesc) .. " says, \"Well, at least you tried.\"")
        else
            self.room:send(tostring(self.shortdesc) .. " says, \"Wut?\"")
        end
    end
else
    -- switch on rndm
    do
        local _sw2 = string.lower(tostring(rndm or ""))
        if tonumber(_sw2) == 1 then
            self.room:send(tostring(self.shortdesc) .. " says, \"Ohh, the blood!  I'll need a bath after this.\"")
        elseif tonumber(_sw2) == 2 then
            self.room:send(tostring(self.shortdesc) .. " says, \"Wow, look at that hit!\"")
        elseif tonumber(_sw2) == 3 then
            self.room:send(tostring(self.shortdesc) .. " says, \"You're so strong!  Amazing.\"")
        elseif tonumber(_sw2) == 4 then
            self.room:send(tostring(self.shortdesc) .. " says, \"Oh yea, that's how you do it!\"")
        elseif tonumber(_sw2) == 5 then
            self.room:send(tostring(self.shortdesc) .. " says, \"Booyah!\"")
        elseif tonumber(_sw2) == 6 then
            self.room:send(tostring(self.shortdesc) .. " says, \"Ohh, the blood!  I'll need a bath after this.\"")
        elseif tonumber(_sw2) == 7 then
            self.room:send(tostring(self.shortdesc) .. " says, \"He won't be coming back from that hit.\"")
        elseif tonumber(_sw2) == 8 then
            self.room:send(tostring(self.shortdesc) .. " says, \"Yeah.  Much hit.  Very strong.  Wow!\"")
        elseif tonumber(_sw2) == 9 then
            self.room:send(tostring(self.shortdesc) .. " says, \"Just like that!\"")
        elseif tonumber(_sw2) == 10 then
            self.room:send(tostring(self.shortdesc) .. " says, \"Look at your glistening muscles!\"")
        else
            self.room:send(tostring(self.shortdesc) .. " says, \"How did you do that?\"")
        end
    end
end