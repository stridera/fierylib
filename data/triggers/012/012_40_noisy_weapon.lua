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
    if rndm == 1 then
        self.room:send(tostring(self.shortdesc) .. " says, \"Wow, totally missed that one.\"")
    elseif rndm == 2 then
        self.room:send(tostring(self.shortdesc) .. " says, \"Where were you swinging?\"")
    elseif rndm == 3 then
        self.room:send(tostring(self.shortdesc) .. " says, \"Are you even trying?\"")
    elseif rndm == 4 then
        self.room:send(tostring(self.shortdesc) .. " says, \"No. Not like that.  You're supposed to HIT them!\"")
    elseif rndm == 5 then
        self.room:send(tostring(self.shortdesc) .. " says, \"Why couldn't that other warrior have picked me up.\"")
    elseif rndm == 6 then
        self.room:send(tostring(self.shortdesc) .. " says, \"Welp, I guess I will stay cleaner if you never hit.\"")
    elseif rndm == 7 then
        self.room:send(tostring(self.shortdesc) .. " says, \"Missed again, big surprise.\"")
    elseif rndm == 8 then
        self.room:send(tostring(self.shortdesc) .. " says, \"Oh, so close.\"")
    elseif rndm == 9 then
        self.room:send(tostring(self.shortdesc) .. " says, \"Not even close that time.\"")
    elseif rndm == 10 then
        self.room:send(tostring(self.shortdesc) .. " says, \"Well, at least you tried.\"")
    else
        self.room:send(tostring(self.shortdesc) .. " says, \"Wut?\"")
    end
else
    -- switch on rndm
    if rndm == 1 then
        self.room:send(tostring(self.shortdesc) .. " says, \"Ohh, the blood!  I'll need a bath after this.\"")
    elseif rndm == 2 then
        self.room:send(tostring(self.shortdesc) .. " says, \"Wow, look at that hit!\"")
    elseif rndm == 3 then
        self.room:send(tostring(self.shortdesc) .. " says, \"You're so strong!  Amazing.\"")
    elseif rndm == 4 then
        self.room:send(tostring(self.shortdesc) .. " says, \"Oh yea, that's how you do it!\"")
    elseif rndm == 5 then
        self.room:send(tostring(self.shortdesc) .. " says, \"Booyah!\"")
    elseif rndm == 6 then
        self.room:send(tostring(self.shortdesc) .. " says, \"Ohh, the blood!  I'll need a bath after this.\"")
    elseif rndm == 7 then
        self.room:send(tostring(self.shortdesc) .. " says, \"He won't be coming back from that hit.\"")
    elseif rndm == 8 then
        self.room:send(tostring(self.shortdesc) .. " says, \"Yeah.  Much hit.  Very strong.  Wow!\"")
    elseif rndm == 9 then
        self.room:send(tostring(self.shortdesc) .. " says, \"Just like that!\"")
    elseif rndm == 10 then
        self.room:send(tostring(self.shortdesc) .. " says, \"Look at your glistening muscles!\"")
    else
        self.room:send(tostring(self.shortdesc) .. " says, \"How did you do that?\"")
    end
end